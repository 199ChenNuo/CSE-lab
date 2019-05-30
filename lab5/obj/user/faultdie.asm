
obj/user/faultdie.debug:     file format elf32-i386


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
  80002c:	e8 4f 00 00 00       	call   800080 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <handler>:

#include <inc/lib.h>

void
handler(struct UTrapframe *utf)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 0c             	sub    $0xc,%esp
  800039:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void*)utf->utf_fault_va;
	uint32_t err = utf->utf_err;
	cprintf("i faulted at va %x, err %x\n", addr, err & 7);
  80003c:	8b 42 04             	mov    0x4(%edx),%eax
  80003f:	83 e0 07             	and    $0x7,%eax
  800042:	50                   	push   %eax
  800043:	ff 32                	pushl  (%edx)
  800045:	68 00 12 80 00       	push   $0x801200
  80004a:	e8 21 01 00 00       	call   800170 <cprintf>
	sys_env_destroy(sys_getenvid());
  80004f:	e8 f6 0b 00 00       	call   800c4a <sys_getenvid>
  800054:	89 04 24             	mov    %eax,(%esp)
  800057:	e8 ad 0b 00 00       	call   800c09 <sys_env_destroy>
}
  80005c:	83 c4 10             	add    $0x10,%esp
  80005f:	c9                   	leave  
  800060:	c3                   	ret    

00800061 <umain>:

void
umain(int argc, char **argv)
{
  800061:	55                   	push   %ebp
  800062:	89 e5                	mov    %esp,%ebp
  800064:	83 ec 14             	sub    $0x14,%esp
	set_pgfault_handler(handler);
  800067:	68 33 00 80 00       	push   $0x800033
  80006c:	e8 49 0e 00 00       	call   800eba <set_pgfault_handler>
	*(int*)0xDeadBeef = 0;
  800071:	c7 05 ef be ad de 00 	movl   $0x0,0xdeadbeef
  800078:	00 00 00 
}
  80007b:	83 c4 10             	add    $0x10,%esp
  80007e:	c9                   	leave  
  80007f:	c3                   	ret    

00800080 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800080:	55                   	push   %ebp
  800081:	89 e5                	mov    %esp,%ebp
  800083:	56                   	push   %esi
  800084:	53                   	push   %ebx
  800085:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800088:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	// thisenv = 0;
	thisenv = &(envs[ENVX(sys_getenvid())]);
  80008b:	e8 ba 0b 00 00       	call   800c4a <sys_getenvid>
  800090:	25 ff 03 00 00       	and    $0x3ff,%eax
  800095:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80009b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000a0:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000a5:	85 db                	test   %ebx,%ebx
  8000a7:	7e 07                	jle    8000b0 <libmain+0x30>
		binaryname = argv[0];
  8000a9:	8b 06                	mov    (%esi),%eax
  8000ab:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  8000b0:	83 ec 08             	sub    $0x8,%esp
  8000b3:	56                   	push   %esi
  8000b4:	53                   	push   %ebx
  8000b5:	e8 a7 ff ff ff       	call   800061 <umain>

	// exit gracefully
	exit();
  8000ba:	e8 0a 00 00 00       	call   8000c9 <exit>
}
  8000bf:	83 c4 10             	add    $0x10,%esp
  8000c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000c5:	5b                   	pop    %ebx
  8000c6:	5e                   	pop    %esi
  8000c7:	5d                   	pop    %ebp
  8000c8:	c3                   	ret    

008000c9 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000c9:	55                   	push   %ebp
  8000ca:	89 e5                	mov    %esp,%ebp
  8000cc:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  8000cf:	6a 00                	push   $0x0
  8000d1:	e8 33 0b 00 00       	call   800c09 <sys_env_destroy>
}
  8000d6:	83 c4 10             	add    $0x10,%esp
  8000d9:	c9                   	leave  
  8000da:	c3                   	ret    

008000db <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000db:	55                   	push   %ebp
  8000dc:	89 e5                	mov    %esp,%ebp
  8000de:	53                   	push   %ebx
  8000df:	83 ec 04             	sub    $0x4,%esp
  8000e2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000e5:	8b 13                	mov    (%ebx),%edx
  8000e7:	8d 42 01             	lea    0x1(%edx),%eax
  8000ea:	89 03                	mov    %eax,(%ebx)
  8000ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000ef:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000f3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000f8:	74 09                	je     800103 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000fa:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8000fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800101:	c9                   	leave  
  800102:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800103:	83 ec 08             	sub    $0x8,%esp
  800106:	68 ff 00 00 00       	push   $0xff
  80010b:	8d 43 08             	lea    0x8(%ebx),%eax
  80010e:	50                   	push   %eax
  80010f:	e8 b8 0a 00 00       	call   800bcc <sys_cputs>
		b->idx = 0;
  800114:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80011a:	83 c4 10             	add    $0x10,%esp
  80011d:	eb db                	jmp    8000fa <putch+0x1f>

0080011f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80011f:	55                   	push   %ebp
  800120:	89 e5                	mov    %esp,%ebp
  800122:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800128:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80012f:	00 00 00 
	b.cnt = 0;
  800132:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800139:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80013c:	ff 75 0c             	pushl  0xc(%ebp)
  80013f:	ff 75 08             	pushl  0x8(%ebp)
  800142:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800148:	50                   	push   %eax
  800149:	68 db 00 80 00       	push   $0x8000db
  80014e:	e8 4a 01 00 00       	call   80029d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800153:	83 c4 08             	add    $0x8,%esp
  800156:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80015c:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800162:	50                   	push   %eax
  800163:	e8 64 0a 00 00       	call   800bcc <sys_cputs>

	return b.cnt;
}
  800168:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80016e:	c9                   	leave  
  80016f:	c3                   	ret    

00800170 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800170:	55                   	push   %ebp
  800171:	89 e5                	mov    %esp,%ebp
  800173:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800176:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800179:	50                   	push   %eax
  80017a:	ff 75 08             	pushl  0x8(%ebp)
  80017d:	e8 9d ff ff ff       	call   80011f <vcprintf>
	va_end(ap);

	return cnt;
}
  800182:	c9                   	leave  
  800183:	c3                   	ret    

00800184 <printnum>:


static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800184:	55                   	push   %ebp
  800185:	89 e5                	mov    %esp,%ebp
  800187:	57                   	push   %edi
  800188:	56                   	push   %esi
  800189:	53                   	push   %ebx
  80018a:	83 ec 1c             	sub    $0x1c,%esp
  80018d:	89 c6                	mov    %eax,%esi
  80018f:	89 d7                	mov    %edx,%edi
  800191:	8b 45 08             	mov    0x8(%ebp),%eax
  800194:	8b 55 0c             	mov    0xc(%ebp),%edx
  800197:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80019a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80019d:	8b 45 10             	mov    0x10(%ebp),%eax
  8001a0:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	// to support '-'
	if(padc == '-'){
  8001a3:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8001a7:	74 2c                	je     8001d5 <printnum+0x51>
		while (--width > 0)
			putch(' ', putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001a9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001ac:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8001b3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8001b6:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8001b9:	39 c2                	cmp    %eax,%edx
  8001bb:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8001be:	73 43                	jae    800203 <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8001c0:	83 eb 01             	sub    $0x1,%ebx
  8001c3:	85 db                	test   %ebx,%ebx
  8001c5:	7e 6c                	jle    800233 <printnum+0xaf>
			putch(padc, putdat);
  8001c7:	83 ec 08             	sub    $0x8,%esp
  8001ca:	57                   	push   %edi
  8001cb:	ff 75 18             	pushl  0x18(%ebp)
  8001ce:	ff d6                	call   *%esi
  8001d0:	83 c4 10             	add    $0x10,%esp
  8001d3:	eb eb                	jmp    8001c0 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8001d5:	83 ec 0c             	sub    $0xc,%esp
  8001d8:	6a 20                	push   $0x20
  8001da:	6a 00                	push   $0x0
  8001dc:	50                   	push   %eax
  8001dd:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001e0:	ff 75 e0             	pushl  -0x20(%ebp)
  8001e3:	89 fa                	mov    %edi,%edx
  8001e5:	89 f0                	mov    %esi,%eax
  8001e7:	e8 98 ff ff ff       	call   800184 <printnum>
		while (--width > 0)
  8001ec:	83 c4 20             	add    $0x20,%esp
  8001ef:	83 eb 01             	sub    $0x1,%ebx
  8001f2:	85 db                	test   %ebx,%ebx
  8001f4:	7e 65                	jle    80025b <printnum+0xd7>
			putch(' ', putdat);
  8001f6:	83 ec 08             	sub    $0x8,%esp
  8001f9:	57                   	push   %edi
  8001fa:	6a 20                	push   $0x20
  8001fc:	ff d6                	call   *%esi
  8001fe:	83 c4 10             	add    $0x10,%esp
  800201:	eb ec                	jmp    8001ef <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800203:	83 ec 0c             	sub    $0xc,%esp
  800206:	ff 75 18             	pushl  0x18(%ebp)
  800209:	83 eb 01             	sub    $0x1,%ebx
  80020c:	53                   	push   %ebx
  80020d:	50                   	push   %eax
  80020e:	83 ec 08             	sub    $0x8,%esp
  800211:	ff 75 dc             	pushl  -0x24(%ebp)
  800214:	ff 75 d8             	pushl  -0x28(%ebp)
  800217:	ff 75 e4             	pushl  -0x1c(%ebp)
  80021a:	ff 75 e0             	pushl  -0x20(%ebp)
  80021d:	e8 7e 0d 00 00       	call   800fa0 <__udivdi3>
  800222:	83 c4 18             	add    $0x18,%esp
  800225:	52                   	push   %edx
  800226:	50                   	push   %eax
  800227:	89 fa                	mov    %edi,%edx
  800229:	89 f0                	mov    %esi,%eax
  80022b:	e8 54 ff ff ff       	call   800184 <printnum>
  800230:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800233:	83 ec 08             	sub    $0x8,%esp
  800236:	57                   	push   %edi
  800237:	83 ec 04             	sub    $0x4,%esp
  80023a:	ff 75 dc             	pushl  -0x24(%ebp)
  80023d:	ff 75 d8             	pushl  -0x28(%ebp)
  800240:	ff 75 e4             	pushl  -0x1c(%ebp)
  800243:	ff 75 e0             	pushl  -0x20(%ebp)
  800246:	e8 65 0e 00 00       	call   8010b0 <__umoddi3>
  80024b:	83 c4 14             	add    $0x14,%esp
  80024e:	0f be 80 26 12 80 00 	movsbl 0x801226(%eax),%eax
  800255:	50                   	push   %eax
  800256:	ff d6                	call   *%esi
  800258:	83 c4 10             	add    $0x10,%esp
}
  80025b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80025e:	5b                   	pop    %ebx
  80025f:	5e                   	pop    %esi
  800260:	5f                   	pop    %edi
  800261:	5d                   	pop    %ebp
  800262:	c3                   	ret    

00800263 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800263:	55                   	push   %ebp
  800264:	89 e5                	mov    %esp,%ebp
  800266:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800269:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80026d:	8b 10                	mov    (%eax),%edx
  80026f:	3b 50 04             	cmp    0x4(%eax),%edx
  800272:	73 0a                	jae    80027e <sprintputch+0x1b>
		*b->buf++ = ch;
  800274:	8d 4a 01             	lea    0x1(%edx),%ecx
  800277:	89 08                	mov    %ecx,(%eax)
  800279:	8b 45 08             	mov    0x8(%ebp),%eax
  80027c:	88 02                	mov    %al,(%edx)
}
  80027e:	5d                   	pop    %ebp
  80027f:	c3                   	ret    

00800280 <printfmt>:
{
  800280:	55                   	push   %ebp
  800281:	89 e5                	mov    %esp,%ebp
  800283:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800286:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800289:	50                   	push   %eax
  80028a:	ff 75 10             	pushl  0x10(%ebp)
  80028d:	ff 75 0c             	pushl  0xc(%ebp)
  800290:	ff 75 08             	pushl  0x8(%ebp)
  800293:	e8 05 00 00 00       	call   80029d <vprintfmt>
}
  800298:	83 c4 10             	add    $0x10,%esp
  80029b:	c9                   	leave  
  80029c:	c3                   	ret    

0080029d <vprintfmt>:
{
  80029d:	55                   	push   %ebp
  80029e:	89 e5                	mov    %esp,%ebp
  8002a0:	57                   	push   %edi
  8002a1:	56                   	push   %esi
  8002a2:	53                   	push   %ebx
  8002a3:	83 ec 3c             	sub    $0x3c,%esp
  8002a6:	8b 75 08             	mov    0x8(%ebp),%esi
  8002a9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002ac:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002af:	e9 1e 04 00 00       	jmp    8006d2 <vprintfmt+0x435>
		posflag = 0;
  8002b4:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
		padc = ' ';
  8002bb:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8002bf:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8002c6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8002cd:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002d4:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  8002db:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002e0:	8d 47 01             	lea    0x1(%edi),%eax
  8002e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002e6:	0f b6 17             	movzbl (%edi),%edx
  8002e9:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002ec:	3c 55                	cmp    $0x55,%al
  8002ee:	0f 87 d9 04 00 00    	ja     8007cd <vprintfmt+0x530>
  8002f4:	0f b6 c0             	movzbl %al,%eax
  8002f7:	ff 24 85 00 14 80 00 	jmp    *0x801400(,%eax,4)
  8002fe:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800301:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800305:	eb d9                	jmp    8002e0 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800307:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posflag = 1;
  80030a:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  800311:	eb cd                	jmp    8002e0 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800313:	0f b6 d2             	movzbl %dl,%edx
  800316:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800319:	b8 00 00 00 00       	mov    $0x0,%eax
  80031e:	89 75 08             	mov    %esi,0x8(%ebp)
  800321:	eb 0c                	jmp    80032f <vprintfmt+0x92>
		switch (ch = *(unsigned char *) fmt++) {
  800323:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800326:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  80032a:	eb b4                	jmp    8002e0 <vprintfmt+0x43>
			for (precision = 0; ; ++fmt) {
  80032c:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80032f:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800332:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800336:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800339:	8d 72 d0             	lea    -0x30(%edx),%esi
  80033c:	83 fe 09             	cmp    $0x9,%esi
  80033f:	76 eb                	jbe    80032c <vprintfmt+0x8f>
  800341:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800344:	8b 75 08             	mov    0x8(%ebp),%esi
  800347:	eb 14                	jmp    80035d <vprintfmt+0xc0>
			precision = va_arg(ap, int);
  800349:	8b 45 14             	mov    0x14(%ebp),%eax
  80034c:	8b 00                	mov    (%eax),%eax
  80034e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800351:	8b 45 14             	mov    0x14(%ebp),%eax
  800354:	8d 40 04             	lea    0x4(%eax),%eax
  800357:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80035a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80035d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800361:	0f 89 79 ff ff ff    	jns    8002e0 <vprintfmt+0x43>
				width = precision, precision = -1;
  800367:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80036a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80036d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800374:	e9 67 ff ff ff       	jmp    8002e0 <vprintfmt+0x43>
  800379:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80037c:	85 c0                	test   %eax,%eax
  80037e:	0f 48 c1             	cmovs  %ecx,%eax
  800381:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800384:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800387:	e9 54 ff ff ff       	jmp    8002e0 <vprintfmt+0x43>
  80038c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80038f:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800396:	e9 45 ff ff ff       	jmp    8002e0 <vprintfmt+0x43>
			lflag++;
  80039b:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80039f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003a2:	e9 39 ff ff ff       	jmp    8002e0 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8003a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8003aa:	8d 78 04             	lea    0x4(%eax),%edi
  8003ad:	83 ec 08             	sub    $0x8,%esp
  8003b0:	53                   	push   %ebx
  8003b1:	ff 30                	pushl  (%eax)
  8003b3:	ff d6                	call   *%esi
			break;
  8003b5:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003b8:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003bb:	e9 0f 03 00 00       	jmp    8006cf <vprintfmt+0x432>
			err = va_arg(ap, int);
  8003c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c3:	8d 78 04             	lea    0x4(%eax),%edi
  8003c6:	8b 00                	mov    (%eax),%eax
  8003c8:	99                   	cltd   
  8003c9:	31 d0                	xor    %edx,%eax
  8003cb:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003cd:	83 f8 0f             	cmp    $0xf,%eax
  8003d0:	7f 23                	jg     8003f5 <vprintfmt+0x158>
  8003d2:	8b 14 85 60 15 80 00 	mov    0x801560(,%eax,4),%edx
  8003d9:	85 d2                	test   %edx,%edx
  8003db:	74 18                	je     8003f5 <vprintfmt+0x158>
				printfmt(putch, putdat, "%s", p);
  8003dd:	52                   	push   %edx
  8003de:	68 47 12 80 00       	push   $0x801247
  8003e3:	53                   	push   %ebx
  8003e4:	56                   	push   %esi
  8003e5:	e8 96 fe ff ff       	call   800280 <printfmt>
  8003ea:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003ed:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003f0:	e9 da 02 00 00       	jmp    8006cf <vprintfmt+0x432>
				printfmt(putch, putdat, "error %d", err);
  8003f5:	50                   	push   %eax
  8003f6:	68 3e 12 80 00       	push   $0x80123e
  8003fb:	53                   	push   %ebx
  8003fc:	56                   	push   %esi
  8003fd:	e8 7e fe ff ff       	call   800280 <printfmt>
  800402:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800405:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800408:	e9 c2 02 00 00       	jmp    8006cf <vprintfmt+0x432>
			if ((p = va_arg(ap, char *)) == NULL)
  80040d:	8b 45 14             	mov    0x14(%ebp),%eax
  800410:	83 c0 04             	add    $0x4,%eax
  800413:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800416:	8b 45 14             	mov    0x14(%ebp),%eax
  800419:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80041b:	85 c9                	test   %ecx,%ecx
  80041d:	b8 37 12 80 00       	mov    $0x801237,%eax
  800422:	0f 45 c1             	cmovne %ecx,%eax
  800425:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800428:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80042c:	7e 06                	jle    800434 <vprintfmt+0x197>
  80042e:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800432:	75 0d                	jne    800441 <vprintfmt+0x1a4>
				for (width -= strnlen(p, precision); width > 0; width--)
  800434:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800437:	89 c7                	mov    %eax,%edi
  800439:	03 45 e0             	add    -0x20(%ebp),%eax
  80043c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80043f:	eb 53                	jmp    800494 <vprintfmt+0x1f7>
  800441:	83 ec 08             	sub    $0x8,%esp
  800444:	ff 75 d8             	pushl  -0x28(%ebp)
  800447:	50                   	push   %eax
  800448:	e8 28 04 00 00       	call   800875 <strnlen>
  80044d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800450:	29 c1                	sub    %eax,%ecx
  800452:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  800455:	83 c4 10             	add    $0x10,%esp
  800458:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  80045a:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80045e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800461:	eb 0f                	jmp    800472 <vprintfmt+0x1d5>
					putch(padc, putdat);
  800463:	83 ec 08             	sub    $0x8,%esp
  800466:	53                   	push   %ebx
  800467:	ff 75 e0             	pushl  -0x20(%ebp)
  80046a:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80046c:	83 ef 01             	sub    $0x1,%edi
  80046f:	83 c4 10             	add    $0x10,%esp
  800472:	85 ff                	test   %edi,%edi
  800474:	7f ed                	jg     800463 <vprintfmt+0x1c6>
  800476:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  800479:	85 c9                	test   %ecx,%ecx
  80047b:	b8 00 00 00 00       	mov    $0x0,%eax
  800480:	0f 49 c1             	cmovns %ecx,%eax
  800483:	29 c1                	sub    %eax,%ecx
  800485:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800488:	eb aa                	jmp    800434 <vprintfmt+0x197>
					putch(ch, putdat);
  80048a:	83 ec 08             	sub    $0x8,%esp
  80048d:	53                   	push   %ebx
  80048e:	52                   	push   %edx
  80048f:	ff d6                	call   *%esi
  800491:	83 c4 10             	add    $0x10,%esp
  800494:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800497:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800499:	83 c7 01             	add    $0x1,%edi
  80049c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004a0:	0f be d0             	movsbl %al,%edx
  8004a3:	85 d2                	test   %edx,%edx
  8004a5:	74 4b                	je     8004f2 <vprintfmt+0x255>
  8004a7:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004ab:	78 06                	js     8004b3 <vprintfmt+0x216>
  8004ad:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004b1:	78 1e                	js     8004d1 <vprintfmt+0x234>
				if (altflag && (ch < ' ' || ch > '~'))
  8004b3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004b7:	74 d1                	je     80048a <vprintfmt+0x1ed>
  8004b9:	0f be c0             	movsbl %al,%eax
  8004bc:	83 e8 20             	sub    $0x20,%eax
  8004bf:	83 f8 5e             	cmp    $0x5e,%eax
  8004c2:	76 c6                	jbe    80048a <vprintfmt+0x1ed>
					putch('?', putdat);
  8004c4:	83 ec 08             	sub    $0x8,%esp
  8004c7:	53                   	push   %ebx
  8004c8:	6a 3f                	push   $0x3f
  8004ca:	ff d6                	call   *%esi
  8004cc:	83 c4 10             	add    $0x10,%esp
  8004cf:	eb c3                	jmp    800494 <vprintfmt+0x1f7>
  8004d1:	89 cf                	mov    %ecx,%edi
  8004d3:	eb 0e                	jmp    8004e3 <vprintfmt+0x246>
				putch(' ', putdat);
  8004d5:	83 ec 08             	sub    $0x8,%esp
  8004d8:	53                   	push   %ebx
  8004d9:	6a 20                	push   $0x20
  8004db:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004dd:	83 ef 01             	sub    $0x1,%edi
  8004e0:	83 c4 10             	add    $0x10,%esp
  8004e3:	85 ff                	test   %edi,%edi
  8004e5:	7f ee                	jg     8004d5 <vprintfmt+0x238>
			if ((p = va_arg(ap, char *)) == NULL)
  8004e7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004ea:	89 45 14             	mov    %eax,0x14(%ebp)
  8004ed:	e9 dd 01 00 00       	jmp    8006cf <vprintfmt+0x432>
  8004f2:	89 cf                	mov    %ecx,%edi
  8004f4:	eb ed                	jmp    8004e3 <vprintfmt+0x246>
	if (lflag >= 2)
  8004f6:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8004fa:	7f 21                	jg     80051d <vprintfmt+0x280>
	else if (lflag)
  8004fc:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800500:	74 6a                	je     80056c <vprintfmt+0x2cf>
		return va_arg(*ap, long);
  800502:	8b 45 14             	mov    0x14(%ebp),%eax
  800505:	8b 00                	mov    (%eax),%eax
  800507:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80050a:	89 c1                	mov    %eax,%ecx
  80050c:	c1 f9 1f             	sar    $0x1f,%ecx
  80050f:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800512:	8b 45 14             	mov    0x14(%ebp),%eax
  800515:	8d 40 04             	lea    0x4(%eax),%eax
  800518:	89 45 14             	mov    %eax,0x14(%ebp)
  80051b:	eb 17                	jmp    800534 <vprintfmt+0x297>
		return va_arg(*ap, long long);
  80051d:	8b 45 14             	mov    0x14(%ebp),%eax
  800520:	8b 50 04             	mov    0x4(%eax),%edx
  800523:	8b 00                	mov    (%eax),%eax
  800525:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800528:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80052b:	8b 45 14             	mov    0x14(%ebp),%eax
  80052e:	8d 40 08             	lea    0x8(%eax),%eax
  800531:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800534:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  800537:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  80053c:	85 d2                	test   %edx,%edx
  80053e:	0f 89 5c 01 00 00    	jns    8006a0 <vprintfmt+0x403>
				putch('-', putdat);
  800544:	83 ec 08             	sub    $0x8,%esp
  800547:	53                   	push   %ebx
  800548:	6a 2d                	push   $0x2d
  80054a:	ff d6                	call   *%esi
				num = -(long long) num;
  80054c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80054f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800552:	f7 d8                	neg    %eax
  800554:	83 d2 00             	adc    $0x0,%edx
  800557:	f7 da                	neg    %edx
  800559:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80055c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80055f:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800562:	bf 0a 00 00 00       	mov    $0xa,%edi
  800567:	e9 45 01 00 00       	jmp    8006b1 <vprintfmt+0x414>
		return va_arg(*ap, int);
  80056c:	8b 45 14             	mov    0x14(%ebp),%eax
  80056f:	8b 00                	mov    (%eax),%eax
  800571:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800574:	89 c1                	mov    %eax,%ecx
  800576:	c1 f9 1f             	sar    $0x1f,%ecx
  800579:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80057c:	8b 45 14             	mov    0x14(%ebp),%eax
  80057f:	8d 40 04             	lea    0x4(%eax),%eax
  800582:	89 45 14             	mov    %eax,0x14(%ebp)
  800585:	eb ad                	jmp    800534 <vprintfmt+0x297>
	if (lflag >= 2)
  800587:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  80058b:	7f 29                	jg     8005b6 <vprintfmt+0x319>
	else if (lflag)
  80058d:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800591:	74 44                	je     8005d7 <vprintfmt+0x33a>
		return va_arg(*ap, unsigned long);
  800593:	8b 45 14             	mov    0x14(%ebp),%eax
  800596:	8b 00                	mov    (%eax),%eax
  800598:	ba 00 00 00 00       	mov    $0x0,%edx
  80059d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005a0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a6:	8d 40 04             	lea    0x4(%eax),%eax
  8005a9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005ac:	bf 0a 00 00 00       	mov    $0xa,%edi
  8005b1:	e9 ea 00 00 00       	jmp    8006a0 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  8005b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b9:	8b 50 04             	mov    0x4(%eax),%edx
  8005bc:	8b 00                	mov    (%eax),%eax
  8005be:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005c1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c7:	8d 40 08             	lea    0x8(%eax),%eax
  8005ca:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005cd:	bf 0a 00 00 00       	mov    $0xa,%edi
  8005d2:	e9 c9 00 00 00       	jmp    8006a0 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  8005d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005da:	8b 00                	mov    (%eax),%eax
  8005dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8005e1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005e4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ea:	8d 40 04             	lea    0x4(%eax),%eax
  8005ed:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005f0:	bf 0a 00 00 00       	mov    $0xa,%edi
  8005f5:	e9 a6 00 00 00       	jmp    8006a0 <vprintfmt+0x403>
			putch('0', putdat);
  8005fa:	83 ec 08             	sub    $0x8,%esp
  8005fd:	53                   	push   %ebx
  8005fe:	6a 30                	push   $0x30
  800600:	ff d6                	call   *%esi
	if (lflag >= 2)
  800602:	83 c4 10             	add    $0x10,%esp
  800605:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800609:	7f 26                	jg     800631 <vprintfmt+0x394>
	else if (lflag)
  80060b:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80060f:	74 3e                	je     80064f <vprintfmt+0x3b2>
		return va_arg(*ap, unsigned long);
  800611:	8b 45 14             	mov    0x14(%ebp),%eax
  800614:	8b 00                	mov    (%eax),%eax
  800616:	ba 00 00 00 00       	mov    $0x0,%edx
  80061b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80061e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800621:	8b 45 14             	mov    0x14(%ebp),%eax
  800624:	8d 40 04             	lea    0x4(%eax),%eax
  800627:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80062a:	bf 08 00 00 00       	mov    $0x8,%edi
  80062f:	eb 6f                	jmp    8006a0 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  800631:	8b 45 14             	mov    0x14(%ebp),%eax
  800634:	8b 50 04             	mov    0x4(%eax),%edx
  800637:	8b 00                	mov    (%eax),%eax
  800639:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80063c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80063f:	8b 45 14             	mov    0x14(%ebp),%eax
  800642:	8d 40 08             	lea    0x8(%eax),%eax
  800645:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800648:	bf 08 00 00 00       	mov    $0x8,%edi
  80064d:	eb 51                	jmp    8006a0 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  80064f:	8b 45 14             	mov    0x14(%ebp),%eax
  800652:	8b 00                	mov    (%eax),%eax
  800654:	ba 00 00 00 00       	mov    $0x0,%edx
  800659:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80065c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80065f:	8b 45 14             	mov    0x14(%ebp),%eax
  800662:	8d 40 04             	lea    0x4(%eax),%eax
  800665:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800668:	bf 08 00 00 00       	mov    $0x8,%edi
  80066d:	eb 31                	jmp    8006a0 <vprintfmt+0x403>
			putch('0', putdat);
  80066f:	83 ec 08             	sub    $0x8,%esp
  800672:	53                   	push   %ebx
  800673:	6a 30                	push   $0x30
  800675:	ff d6                	call   *%esi
			putch('x', putdat);
  800677:	83 c4 08             	add    $0x8,%esp
  80067a:	53                   	push   %ebx
  80067b:	6a 78                	push   $0x78
  80067d:	ff d6                	call   *%esi
			num = (unsigned long long)
  80067f:	8b 45 14             	mov    0x14(%ebp),%eax
  800682:	8b 00                	mov    (%eax),%eax
  800684:	ba 00 00 00 00       	mov    $0x0,%edx
  800689:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80068c:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80068f:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800692:	8b 45 14             	mov    0x14(%ebp),%eax
  800695:	8d 40 04             	lea    0x4(%eax),%eax
  800698:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80069b:	bf 10 00 00 00       	mov    $0x10,%edi
			if(posflag)
  8006a0:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006a4:	74 0b                	je     8006b1 <vprintfmt+0x414>
				putch('+', putdat);
  8006a6:	83 ec 08             	sub    $0x8,%esp
  8006a9:	53                   	push   %ebx
  8006aa:	6a 2b                	push   $0x2b
  8006ac:	ff d6                	call   *%esi
  8006ae:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  8006b1:	83 ec 0c             	sub    $0xc,%esp
  8006b4:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8006b8:	50                   	push   %eax
  8006b9:	ff 75 e0             	pushl  -0x20(%ebp)
  8006bc:	57                   	push   %edi
  8006bd:	ff 75 dc             	pushl  -0x24(%ebp)
  8006c0:	ff 75 d8             	pushl  -0x28(%ebp)
  8006c3:	89 da                	mov    %ebx,%edx
  8006c5:	89 f0                	mov    %esi,%eax
  8006c7:	e8 b8 fa ff ff       	call   800184 <printnum>
			break;
  8006cc:	83 c4 20             	add    $0x20,%esp
			char* cp = va_arg(ap, char *);
  8006cf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006d2:	83 c7 01             	add    $0x1,%edi
  8006d5:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006d9:	83 f8 25             	cmp    $0x25,%eax
  8006dc:	0f 84 d2 fb ff ff    	je     8002b4 <vprintfmt+0x17>
			if (ch == '\0')
  8006e2:	85 c0                	test   %eax,%eax
  8006e4:	0f 84 03 01 00 00    	je     8007ed <vprintfmt+0x550>
			putch(ch, putdat);
  8006ea:	83 ec 08             	sub    $0x8,%esp
  8006ed:	53                   	push   %ebx
  8006ee:	50                   	push   %eax
  8006ef:	ff d6                	call   *%esi
  8006f1:	83 c4 10             	add    $0x10,%esp
  8006f4:	eb dc                	jmp    8006d2 <vprintfmt+0x435>
	if (lflag >= 2)
  8006f6:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8006fa:	7f 29                	jg     800725 <vprintfmt+0x488>
	else if (lflag)
  8006fc:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800700:	74 44                	je     800746 <vprintfmt+0x4a9>
		return va_arg(*ap, unsigned long);
  800702:	8b 45 14             	mov    0x14(%ebp),%eax
  800705:	8b 00                	mov    (%eax),%eax
  800707:	ba 00 00 00 00       	mov    $0x0,%edx
  80070c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80070f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800712:	8b 45 14             	mov    0x14(%ebp),%eax
  800715:	8d 40 04             	lea    0x4(%eax),%eax
  800718:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80071b:	bf 10 00 00 00       	mov    $0x10,%edi
  800720:	e9 7b ff ff ff       	jmp    8006a0 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  800725:	8b 45 14             	mov    0x14(%ebp),%eax
  800728:	8b 50 04             	mov    0x4(%eax),%edx
  80072b:	8b 00                	mov    (%eax),%eax
  80072d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800730:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800733:	8b 45 14             	mov    0x14(%ebp),%eax
  800736:	8d 40 08             	lea    0x8(%eax),%eax
  800739:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80073c:	bf 10 00 00 00       	mov    $0x10,%edi
  800741:	e9 5a ff ff ff       	jmp    8006a0 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  800746:	8b 45 14             	mov    0x14(%ebp),%eax
  800749:	8b 00                	mov    (%eax),%eax
  80074b:	ba 00 00 00 00       	mov    $0x0,%edx
  800750:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800753:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800756:	8b 45 14             	mov    0x14(%ebp),%eax
  800759:	8d 40 04             	lea    0x4(%eax),%eax
  80075c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80075f:	bf 10 00 00 00       	mov    $0x10,%edi
  800764:	e9 37 ff ff ff       	jmp    8006a0 <vprintfmt+0x403>
			char* cp = va_arg(ap, char *);
  800769:	8b 45 14             	mov    0x14(%ebp),%eax
  80076c:	8d 78 04             	lea    0x4(%eax),%edi
  80076f:	8b 00                	mov    (%eax),%eax
    			if (cp == NULL) {
  800771:	85 c0                	test   %eax,%eax
  800773:	74 2c                	je     8007a1 <vprintfmt+0x504>
    			*cp = *(int *)putdat;
  800775:	8b 13                	mov    (%ebx),%edx
  800777:	88 10                	mov    %dl,(%eax)
			char* cp = va_arg(ap, char *);
  800779:	89 7d 14             	mov    %edi,0x14(%ebp)
    			if ((*(int *) putdat) > 127)
  80077c:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  80077f:	0f 8e 4a ff ff ff    	jle    8006cf <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", overflow_error);
  800785:	68 94 13 80 00       	push   $0x801394
  80078a:	68 47 12 80 00       	push   $0x801247
  80078f:	53                   	push   %ebx
  800790:	56                   	push   %esi
  800791:	e8 ea fa ff ff       	call   800280 <printfmt>
  800796:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  800799:	89 7d 14             	mov    %edi,0x14(%ebp)
  80079c:	e9 2e ff ff ff       	jmp    8006cf <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", null_error);
  8007a1:	68 5c 13 80 00       	push   $0x80135c
  8007a6:	68 47 12 80 00       	push   $0x801247
  8007ab:	53                   	push   %ebx
  8007ac:	56                   	push   %esi
  8007ad:	e8 ce fa ff ff       	call   800280 <printfmt>
        		break;
  8007b2:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  8007b5:	89 7d 14             	mov    %edi,0x14(%ebp)
        		break;
  8007b8:	e9 12 ff ff ff       	jmp    8006cf <vprintfmt+0x432>
			putch(ch, putdat);
  8007bd:	83 ec 08             	sub    $0x8,%esp
  8007c0:	53                   	push   %ebx
  8007c1:	6a 25                	push   $0x25
  8007c3:	ff d6                	call   *%esi
			break;
  8007c5:	83 c4 10             	add    $0x10,%esp
  8007c8:	e9 02 ff ff ff       	jmp    8006cf <vprintfmt+0x432>
			putch('%', putdat);
  8007cd:	83 ec 08             	sub    $0x8,%esp
  8007d0:	53                   	push   %ebx
  8007d1:	6a 25                	push   $0x25
  8007d3:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007d5:	83 c4 10             	add    $0x10,%esp
  8007d8:	89 f8                	mov    %edi,%eax
  8007da:	eb 03                	jmp    8007df <vprintfmt+0x542>
  8007dc:	83 e8 01             	sub    $0x1,%eax
  8007df:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8007e3:	75 f7                	jne    8007dc <vprintfmt+0x53f>
  8007e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007e8:	e9 e2 fe ff ff       	jmp    8006cf <vprintfmt+0x432>
}
  8007ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007f0:	5b                   	pop    %ebx
  8007f1:	5e                   	pop    %esi
  8007f2:	5f                   	pop    %edi
  8007f3:	5d                   	pop    %ebp
  8007f4:	c3                   	ret    

008007f5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007f5:	55                   	push   %ebp
  8007f6:	89 e5                	mov    %esp,%ebp
  8007f8:	83 ec 18             	sub    $0x18,%esp
  8007fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fe:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800801:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800804:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800808:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80080b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800812:	85 c0                	test   %eax,%eax
  800814:	74 26                	je     80083c <vsnprintf+0x47>
  800816:	85 d2                	test   %edx,%edx
  800818:	7e 22                	jle    80083c <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80081a:	ff 75 14             	pushl  0x14(%ebp)
  80081d:	ff 75 10             	pushl  0x10(%ebp)
  800820:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800823:	50                   	push   %eax
  800824:	68 63 02 80 00       	push   $0x800263
  800829:	e8 6f fa ff ff       	call   80029d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80082e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800831:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800834:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800837:	83 c4 10             	add    $0x10,%esp
}
  80083a:	c9                   	leave  
  80083b:	c3                   	ret    
		return -E_INVAL;
  80083c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800841:	eb f7                	jmp    80083a <vsnprintf+0x45>

00800843 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800843:	55                   	push   %ebp
  800844:	89 e5                	mov    %esp,%ebp
  800846:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800849:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80084c:	50                   	push   %eax
  80084d:	ff 75 10             	pushl  0x10(%ebp)
  800850:	ff 75 0c             	pushl  0xc(%ebp)
  800853:	ff 75 08             	pushl  0x8(%ebp)
  800856:	e8 9a ff ff ff       	call   8007f5 <vsnprintf>
	va_end(ap);

	return rc;
}
  80085b:	c9                   	leave  
  80085c:	c3                   	ret    

0080085d <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80085d:	55                   	push   %ebp
  80085e:	89 e5                	mov    %esp,%ebp
  800860:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800863:	b8 00 00 00 00       	mov    $0x0,%eax
  800868:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80086c:	74 05                	je     800873 <strlen+0x16>
		n++;
  80086e:	83 c0 01             	add    $0x1,%eax
  800871:	eb f5                	jmp    800868 <strlen+0xb>
	return n;
}
  800873:	5d                   	pop    %ebp
  800874:	c3                   	ret    

00800875 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800875:	55                   	push   %ebp
  800876:	89 e5                	mov    %esp,%ebp
  800878:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80087b:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80087e:	ba 00 00 00 00       	mov    $0x0,%edx
  800883:	39 c2                	cmp    %eax,%edx
  800885:	74 0d                	je     800894 <strnlen+0x1f>
  800887:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  80088b:	74 05                	je     800892 <strnlen+0x1d>
		n++;
  80088d:	83 c2 01             	add    $0x1,%edx
  800890:	eb f1                	jmp    800883 <strnlen+0xe>
  800892:	89 d0                	mov    %edx,%eax
	return n;
}
  800894:	5d                   	pop    %ebp
  800895:	c3                   	ret    

00800896 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800896:	55                   	push   %ebp
  800897:	89 e5                	mov    %esp,%ebp
  800899:	53                   	push   %ebx
  80089a:	8b 45 08             	mov    0x8(%ebp),%eax
  80089d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8008a5:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8008a9:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8008ac:	83 c2 01             	add    $0x1,%edx
  8008af:	84 c9                	test   %cl,%cl
  8008b1:	75 f2                	jne    8008a5 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8008b3:	5b                   	pop    %ebx
  8008b4:	5d                   	pop    %ebp
  8008b5:	c3                   	ret    

008008b6 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008b6:	55                   	push   %ebp
  8008b7:	89 e5                	mov    %esp,%ebp
  8008b9:	53                   	push   %ebx
  8008ba:	83 ec 10             	sub    $0x10,%esp
  8008bd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008c0:	53                   	push   %ebx
  8008c1:	e8 97 ff ff ff       	call   80085d <strlen>
  8008c6:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8008c9:	ff 75 0c             	pushl  0xc(%ebp)
  8008cc:	01 d8                	add    %ebx,%eax
  8008ce:	50                   	push   %eax
  8008cf:	e8 c2 ff ff ff       	call   800896 <strcpy>
	return dst;
}
  8008d4:	89 d8                	mov    %ebx,%eax
  8008d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008d9:	c9                   	leave  
  8008da:	c3                   	ret    

008008db <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008db:	55                   	push   %ebp
  8008dc:	89 e5                	mov    %esp,%ebp
  8008de:	56                   	push   %esi
  8008df:	53                   	push   %ebx
  8008e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008e6:	89 c6                	mov    %eax,%esi
  8008e8:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008eb:	89 c2                	mov    %eax,%edx
  8008ed:	39 f2                	cmp    %esi,%edx
  8008ef:	74 11                	je     800902 <strncpy+0x27>
		*dst++ = *src;
  8008f1:	83 c2 01             	add    $0x1,%edx
  8008f4:	0f b6 19             	movzbl (%ecx),%ebx
  8008f7:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008fa:	80 fb 01             	cmp    $0x1,%bl
  8008fd:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800900:	eb eb                	jmp    8008ed <strncpy+0x12>
	}
	return ret;
}
  800902:	5b                   	pop    %ebx
  800903:	5e                   	pop    %esi
  800904:	5d                   	pop    %ebp
  800905:	c3                   	ret    

00800906 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800906:	55                   	push   %ebp
  800907:	89 e5                	mov    %esp,%ebp
  800909:	56                   	push   %esi
  80090a:	53                   	push   %ebx
  80090b:	8b 75 08             	mov    0x8(%ebp),%esi
  80090e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800911:	8b 55 10             	mov    0x10(%ebp),%edx
  800914:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800916:	85 d2                	test   %edx,%edx
  800918:	74 21                	je     80093b <strlcpy+0x35>
  80091a:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80091e:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800920:	39 c2                	cmp    %eax,%edx
  800922:	74 14                	je     800938 <strlcpy+0x32>
  800924:	0f b6 19             	movzbl (%ecx),%ebx
  800927:	84 db                	test   %bl,%bl
  800929:	74 0b                	je     800936 <strlcpy+0x30>
			*dst++ = *src++;
  80092b:	83 c1 01             	add    $0x1,%ecx
  80092e:	83 c2 01             	add    $0x1,%edx
  800931:	88 5a ff             	mov    %bl,-0x1(%edx)
  800934:	eb ea                	jmp    800920 <strlcpy+0x1a>
  800936:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800938:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80093b:	29 f0                	sub    %esi,%eax
}
  80093d:	5b                   	pop    %ebx
  80093e:	5e                   	pop    %esi
  80093f:	5d                   	pop    %ebp
  800940:	c3                   	ret    

00800941 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800941:	55                   	push   %ebp
  800942:	89 e5                	mov    %esp,%ebp
  800944:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800947:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80094a:	0f b6 01             	movzbl (%ecx),%eax
  80094d:	84 c0                	test   %al,%al
  80094f:	74 0c                	je     80095d <strcmp+0x1c>
  800951:	3a 02                	cmp    (%edx),%al
  800953:	75 08                	jne    80095d <strcmp+0x1c>
		p++, q++;
  800955:	83 c1 01             	add    $0x1,%ecx
  800958:	83 c2 01             	add    $0x1,%edx
  80095b:	eb ed                	jmp    80094a <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80095d:	0f b6 c0             	movzbl %al,%eax
  800960:	0f b6 12             	movzbl (%edx),%edx
  800963:	29 d0                	sub    %edx,%eax
}
  800965:	5d                   	pop    %ebp
  800966:	c3                   	ret    

00800967 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800967:	55                   	push   %ebp
  800968:	89 e5                	mov    %esp,%ebp
  80096a:	53                   	push   %ebx
  80096b:	8b 45 08             	mov    0x8(%ebp),%eax
  80096e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800971:	89 c3                	mov    %eax,%ebx
  800973:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800976:	eb 06                	jmp    80097e <strncmp+0x17>
		n--, p++, q++;
  800978:	83 c0 01             	add    $0x1,%eax
  80097b:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80097e:	39 d8                	cmp    %ebx,%eax
  800980:	74 16                	je     800998 <strncmp+0x31>
  800982:	0f b6 08             	movzbl (%eax),%ecx
  800985:	84 c9                	test   %cl,%cl
  800987:	74 04                	je     80098d <strncmp+0x26>
  800989:	3a 0a                	cmp    (%edx),%cl
  80098b:	74 eb                	je     800978 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80098d:	0f b6 00             	movzbl (%eax),%eax
  800990:	0f b6 12             	movzbl (%edx),%edx
  800993:	29 d0                	sub    %edx,%eax
}
  800995:	5b                   	pop    %ebx
  800996:	5d                   	pop    %ebp
  800997:	c3                   	ret    
		return 0;
  800998:	b8 00 00 00 00       	mov    $0x0,%eax
  80099d:	eb f6                	jmp    800995 <strncmp+0x2e>

0080099f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80099f:	55                   	push   %ebp
  8009a0:	89 e5                	mov    %esp,%ebp
  8009a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a5:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009a9:	0f b6 10             	movzbl (%eax),%edx
  8009ac:	84 d2                	test   %dl,%dl
  8009ae:	74 09                	je     8009b9 <strchr+0x1a>
		if (*s == c)
  8009b0:	38 ca                	cmp    %cl,%dl
  8009b2:	74 0a                	je     8009be <strchr+0x1f>
	for (; *s; s++)
  8009b4:	83 c0 01             	add    $0x1,%eax
  8009b7:	eb f0                	jmp    8009a9 <strchr+0xa>
			return (char *) s;
	return 0;
  8009b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009be:	5d                   	pop    %ebp
  8009bf:	c3                   	ret    

008009c0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009c0:	55                   	push   %ebp
  8009c1:	89 e5                	mov    %esp,%ebp
  8009c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009ca:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009cd:	38 ca                	cmp    %cl,%dl
  8009cf:	74 09                	je     8009da <strfind+0x1a>
  8009d1:	84 d2                	test   %dl,%dl
  8009d3:	74 05                	je     8009da <strfind+0x1a>
	for (; *s; s++)
  8009d5:	83 c0 01             	add    $0x1,%eax
  8009d8:	eb f0                	jmp    8009ca <strfind+0xa>
			break;
	return (char *) s;
}
  8009da:	5d                   	pop    %ebp
  8009db:	c3                   	ret    

008009dc <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009dc:	55                   	push   %ebp
  8009dd:	89 e5                	mov    %esp,%ebp
  8009df:	57                   	push   %edi
  8009e0:	56                   	push   %esi
  8009e1:	53                   	push   %ebx
  8009e2:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009e5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009e8:	85 c9                	test   %ecx,%ecx
  8009ea:	74 31                	je     800a1d <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009ec:	89 f8                	mov    %edi,%eax
  8009ee:	09 c8                	or     %ecx,%eax
  8009f0:	a8 03                	test   $0x3,%al
  8009f2:	75 23                	jne    800a17 <memset+0x3b>
		c &= 0xFF;
  8009f4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009f8:	89 d3                	mov    %edx,%ebx
  8009fa:	c1 e3 08             	shl    $0x8,%ebx
  8009fd:	89 d0                	mov    %edx,%eax
  8009ff:	c1 e0 18             	shl    $0x18,%eax
  800a02:	89 d6                	mov    %edx,%esi
  800a04:	c1 e6 10             	shl    $0x10,%esi
  800a07:	09 f0                	or     %esi,%eax
  800a09:	09 c2                	or     %eax,%edx
  800a0b:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a0d:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a10:	89 d0                	mov    %edx,%eax
  800a12:	fc                   	cld    
  800a13:	f3 ab                	rep stos %eax,%es:(%edi)
  800a15:	eb 06                	jmp    800a1d <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a1a:	fc                   	cld    
  800a1b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a1d:	89 f8                	mov    %edi,%eax
  800a1f:	5b                   	pop    %ebx
  800a20:	5e                   	pop    %esi
  800a21:	5f                   	pop    %edi
  800a22:	5d                   	pop    %ebp
  800a23:	c3                   	ret    

00800a24 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a24:	55                   	push   %ebp
  800a25:	89 e5                	mov    %esp,%ebp
  800a27:	57                   	push   %edi
  800a28:	56                   	push   %esi
  800a29:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a2f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a32:	39 c6                	cmp    %eax,%esi
  800a34:	73 32                	jae    800a68 <memmove+0x44>
  800a36:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a39:	39 c2                	cmp    %eax,%edx
  800a3b:	76 2b                	jbe    800a68 <memmove+0x44>
		s += n;
		d += n;
  800a3d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a40:	89 fe                	mov    %edi,%esi
  800a42:	09 ce                	or     %ecx,%esi
  800a44:	09 d6                	or     %edx,%esi
  800a46:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a4c:	75 0e                	jne    800a5c <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a4e:	83 ef 04             	sub    $0x4,%edi
  800a51:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a54:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a57:	fd                   	std    
  800a58:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a5a:	eb 09                	jmp    800a65 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a5c:	83 ef 01             	sub    $0x1,%edi
  800a5f:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a62:	fd                   	std    
  800a63:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a65:	fc                   	cld    
  800a66:	eb 1a                	jmp    800a82 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a68:	89 c2                	mov    %eax,%edx
  800a6a:	09 ca                	or     %ecx,%edx
  800a6c:	09 f2                	or     %esi,%edx
  800a6e:	f6 c2 03             	test   $0x3,%dl
  800a71:	75 0a                	jne    800a7d <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a73:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a76:	89 c7                	mov    %eax,%edi
  800a78:	fc                   	cld    
  800a79:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a7b:	eb 05                	jmp    800a82 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800a7d:	89 c7                	mov    %eax,%edi
  800a7f:	fc                   	cld    
  800a80:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a82:	5e                   	pop    %esi
  800a83:	5f                   	pop    %edi
  800a84:	5d                   	pop    %ebp
  800a85:	c3                   	ret    

00800a86 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a86:	55                   	push   %ebp
  800a87:	89 e5                	mov    %esp,%ebp
  800a89:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a8c:	ff 75 10             	pushl  0x10(%ebp)
  800a8f:	ff 75 0c             	pushl  0xc(%ebp)
  800a92:	ff 75 08             	pushl  0x8(%ebp)
  800a95:	e8 8a ff ff ff       	call   800a24 <memmove>
}
  800a9a:	c9                   	leave  
  800a9b:	c3                   	ret    

00800a9c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a9c:	55                   	push   %ebp
  800a9d:	89 e5                	mov    %esp,%ebp
  800a9f:	56                   	push   %esi
  800aa0:	53                   	push   %ebx
  800aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aa7:	89 c6                	mov    %eax,%esi
  800aa9:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800aac:	39 f0                	cmp    %esi,%eax
  800aae:	74 1c                	je     800acc <memcmp+0x30>
		if (*s1 != *s2)
  800ab0:	0f b6 08             	movzbl (%eax),%ecx
  800ab3:	0f b6 1a             	movzbl (%edx),%ebx
  800ab6:	38 d9                	cmp    %bl,%cl
  800ab8:	75 08                	jne    800ac2 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800aba:	83 c0 01             	add    $0x1,%eax
  800abd:	83 c2 01             	add    $0x1,%edx
  800ac0:	eb ea                	jmp    800aac <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800ac2:	0f b6 c1             	movzbl %cl,%eax
  800ac5:	0f b6 db             	movzbl %bl,%ebx
  800ac8:	29 d8                	sub    %ebx,%eax
  800aca:	eb 05                	jmp    800ad1 <memcmp+0x35>
	}

	return 0;
  800acc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ad1:	5b                   	pop    %ebx
  800ad2:	5e                   	pop    %esi
  800ad3:	5d                   	pop    %ebp
  800ad4:	c3                   	ret    

00800ad5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ad5:	55                   	push   %ebp
  800ad6:	89 e5                	mov    %esp,%ebp
  800ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  800adb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ade:	89 c2                	mov    %eax,%edx
  800ae0:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ae3:	39 d0                	cmp    %edx,%eax
  800ae5:	73 09                	jae    800af0 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ae7:	38 08                	cmp    %cl,(%eax)
  800ae9:	74 05                	je     800af0 <memfind+0x1b>
	for (; s < ends; s++)
  800aeb:	83 c0 01             	add    $0x1,%eax
  800aee:	eb f3                	jmp    800ae3 <memfind+0xe>
			break;
	return (void *) s;
}
  800af0:	5d                   	pop    %ebp
  800af1:	c3                   	ret    

00800af2 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800af2:	55                   	push   %ebp
  800af3:	89 e5                	mov    %esp,%ebp
  800af5:	57                   	push   %edi
  800af6:	56                   	push   %esi
  800af7:	53                   	push   %ebx
  800af8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800afb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800afe:	eb 03                	jmp    800b03 <strtol+0x11>
		s++;
  800b00:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b03:	0f b6 01             	movzbl (%ecx),%eax
  800b06:	3c 20                	cmp    $0x20,%al
  800b08:	74 f6                	je     800b00 <strtol+0xe>
  800b0a:	3c 09                	cmp    $0x9,%al
  800b0c:	74 f2                	je     800b00 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b0e:	3c 2b                	cmp    $0x2b,%al
  800b10:	74 2a                	je     800b3c <strtol+0x4a>
	int neg = 0;
  800b12:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b17:	3c 2d                	cmp    $0x2d,%al
  800b19:	74 2b                	je     800b46 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b1b:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b21:	75 0f                	jne    800b32 <strtol+0x40>
  800b23:	80 39 30             	cmpb   $0x30,(%ecx)
  800b26:	74 28                	je     800b50 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b28:	85 db                	test   %ebx,%ebx
  800b2a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b2f:	0f 44 d8             	cmove  %eax,%ebx
  800b32:	b8 00 00 00 00       	mov    $0x0,%eax
  800b37:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b3a:	eb 50                	jmp    800b8c <strtol+0x9a>
		s++;
  800b3c:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b3f:	bf 00 00 00 00       	mov    $0x0,%edi
  800b44:	eb d5                	jmp    800b1b <strtol+0x29>
		s++, neg = 1;
  800b46:	83 c1 01             	add    $0x1,%ecx
  800b49:	bf 01 00 00 00       	mov    $0x1,%edi
  800b4e:	eb cb                	jmp    800b1b <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b50:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b54:	74 0e                	je     800b64 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800b56:	85 db                	test   %ebx,%ebx
  800b58:	75 d8                	jne    800b32 <strtol+0x40>
		s++, base = 8;
  800b5a:	83 c1 01             	add    $0x1,%ecx
  800b5d:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b62:	eb ce                	jmp    800b32 <strtol+0x40>
		s += 2, base = 16;
  800b64:	83 c1 02             	add    $0x2,%ecx
  800b67:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b6c:	eb c4                	jmp    800b32 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b6e:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b71:	89 f3                	mov    %esi,%ebx
  800b73:	80 fb 19             	cmp    $0x19,%bl
  800b76:	77 29                	ja     800ba1 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800b78:	0f be d2             	movsbl %dl,%edx
  800b7b:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b7e:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b81:	7d 30                	jge    800bb3 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800b83:	83 c1 01             	add    $0x1,%ecx
  800b86:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b8a:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b8c:	0f b6 11             	movzbl (%ecx),%edx
  800b8f:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b92:	89 f3                	mov    %esi,%ebx
  800b94:	80 fb 09             	cmp    $0x9,%bl
  800b97:	77 d5                	ja     800b6e <strtol+0x7c>
			dig = *s - '0';
  800b99:	0f be d2             	movsbl %dl,%edx
  800b9c:	83 ea 30             	sub    $0x30,%edx
  800b9f:	eb dd                	jmp    800b7e <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800ba1:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ba4:	89 f3                	mov    %esi,%ebx
  800ba6:	80 fb 19             	cmp    $0x19,%bl
  800ba9:	77 08                	ja     800bb3 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800bab:	0f be d2             	movsbl %dl,%edx
  800bae:	83 ea 37             	sub    $0x37,%edx
  800bb1:	eb cb                	jmp    800b7e <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800bb3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bb7:	74 05                	je     800bbe <strtol+0xcc>
		*endptr = (char *) s;
  800bb9:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bbc:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800bbe:	89 c2                	mov    %eax,%edx
  800bc0:	f7 da                	neg    %edx
  800bc2:	85 ff                	test   %edi,%edi
  800bc4:	0f 45 c2             	cmovne %edx,%eax
}
  800bc7:	5b                   	pop    %ebx
  800bc8:	5e                   	pop    %esi
  800bc9:	5f                   	pop    %edi
  800bca:	5d                   	pop    %ebp
  800bcb:	c3                   	ret    

00800bcc <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bcc:	55                   	push   %ebp
  800bcd:	89 e5                	mov    %esp,%ebp
  800bcf:	57                   	push   %edi
  800bd0:	56                   	push   %esi
  800bd1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bd2:	b8 00 00 00 00       	mov    $0x0,%eax
  800bd7:	8b 55 08             	mov    0x8(%ebp),%edx
  800bda:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bdd:	89 c3                	mov    %eax,%ebx
  800bdf:	89 c7                	mov    %eax,%edi
  800be1:	89 c6                	mov    %eax,%esi
  800be3:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800be5:	5b                   	pop    %ebx
  800be6:	5e                   	pop    %esi
  800be7:	5f                   	pop    %edi
  800be8:	5d                   	pop    %ebp
  800be9:	c3                   	ret    

00800bea <sys_cgetc>:

int
sys_cgetc(void)
{
  800bea:	55                   	push   %ebp
  800beb:	89 e5                	mov    %esp,%ebp
  800bed:	57                   	push   %edi
  800bee:	56                   	push   %esi
  800bef:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bf0:	ba 00 00 00 00       	mov    $0x0,%edx
  800bf5:	b8 01 00 00 00       	mov    $0x1,%eax
  800bfa:	89 d1                	mov    %edx,%ecx
  800bfc:	89 d3                	mov    %edx,%ebx
  800bfe:	89 d7                	mov    %edx,%edi
  800c00:	89 d6                	mov    %edx,%esi
  800c02:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c04:	5b                   	pop    %ebx
  800c05:	5e                   	pop    %esi
  800c06:	5f                   	pop    %edi
  800c07:	5d                   	pop    %ebp
  800c08:	c3                   	ret    

00800c09 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c09:	55                   	push   %ebp
  800c0a:	89 e5                	mov    %esp,%ebp
  800c0c:	57                   	push   %edi
  800c0d:	56                   	push   %esi
  800c0e:	53                   	push   %ebx
  800c0f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c12:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c17:	8b 55 08             	mov    0x8(%ebp),%edx
  800c1a:	b8 03 00 00 00       	mov    $0x3,%eax
  800c1f:	89 cb                	mov    %ecx,%ebx
  800c21:	89 cf                	mov    %ecx,%edi
  800c23:	89 ce                	mov    %ecx,%esi
  800c25:	cd 30                	int    $0x30
	if (check && ret > 0)
  800c27:	85 c0                	test   %eax,%eax
  800c29:	7f 08                	jg     800c33 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c2b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c2e:	5b                   	pop    %ebx
  800c2f:	5e                   	pop    %esi
  800c30:	5f                   	pop    %edi
  800c31:	5d                   	pop    %ebp
  800c32:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c33:	83 ec 0c             	sub    $0xc,%esp
  800c36:	50                   	push   %eax
  800c37:	6a 03                	push   $0x3
  800c39:	68 a0 15 80 00       	push   $0x8015a0
  800c3e:	6a 4c                	push   $0x4c
  800c40:	68 bd 15 80 00       	push   $0x8015bd
  800c45:	e8 01 03 00 00       	call   800f4b <_panic>

00800c4a <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c4a:	55                   	push   %ebp
  800c4b:	89 e5                	mov    %esp,%ebp
  800c4d:	57                   	push   %edi
  800c4e:	56                   	push   %esi
  800c4f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c50:	ba 00 00 00 00       	mov    $0x0,%edx
  800c55:	b8 02 00 00 00       	mov    $0x2,%eax
  800c5a:	89 d1                	mov    %edx,%ecx
  800c5c:	89 d3                	mov    %edx,%ebx
  800c5e:	89 d7                	mov    %edx,%edi
  800c60:	89 d6                	mov    %edx,%esi
  800c62:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c64:	5b                   	pop    %ebx
  800c65:	5e                   	pop    %esi
  800c66:	5f                   	pop    %edi
  800c67:	5d                   	pop    %ebp
  800c68:	c3                   	ret    

00800c69 <sys_yield>:

void
sys_yield(void)
{
  800c69:	55                   	push   %ebp
  800c6a:	89 e5                	mov    %esp,%ebp
  800c6c:	57                   	push   %edi
  800c6d:	56                   	push   %esi
  800c6e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c6f:	ba 00 00 00 00       	mov    $0x0,%edx
  800c74:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c79:	89 d1                	mov    %edx,%ecx
  800c7b:	89 d3                	mov    %edx,%ebx
  800c7d:	89 d7                	mov    %edx,%edi
  800c7f:	89 d6                	mov    %edx,%esi
  800c81:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c83:	5b                   	pop    %ebx
  800c84:	5e                   	pop    %esi
  800c85:	5f                   	pop    %edi
  800c86:	5d                   	pop    %ebp
  800c87:	c3                   	ret    

00800c88 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c88:	55                   	push   %ebp
  800c89:	89 e5                	mov    %esp,%ebp
  800c8b:	57                   	push   %edi
  800c8c:	56                   	push   %esi
  800c8d:	53                   	push   %ebx
  800c8e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c91:	be 00 00 00 00       	mov    $0x0,%esi
  800c96:	8b 55 08             	mov    0x8(%ebp),%edx
  800c99:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c9c:	b8 04 00 00 00       	mov    $0x4,%eax
  800ca1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ca4:	89 f7                	mov    %esi,%edi
  800ca6:	cd 30                	int    $0x30
	if (check && ret > 0)
  800ca8:	85 c0                	test   %eax,%eax
  800caa:	7f 08                	jg     800cb4 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800cac:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800caf:	5b                   	pop    %ebx
  800cb0:	5e                   	pop    %esi
  800cb1:	5f                   	pop    %edi
  800cb2:	5d                   	pop    %ebp
  800cb3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cb4:	83 ec 0c             	sub    $0xc,%esp
  800cb7:	50                   	push   %eax
  800cb8:	6a 04                	push   $0x4
  800cba:	68 a0 15 80 00       	push   $0x8015a0
  800cbf:	6a 4c                	push   $0x4c
  800cc1:	68 bd 15 80 00       	push   $0x8015bd
  800cc6:	e8 80 02 00 00       	call   800f4b <_panic>

00800ccb <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ccb:	55                   	push   %ebp
  800ccc:	89 e5                	mov    %esp,%ebp
  800cce:	57                   	push   %edi
  800ccf:	56                   	push   %esi
  800cd0:	53                   	push   %ebx
  800cd1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cd4:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cda:	b8 05 00 00 00       	mov    $0x5,%eax
  800cdf:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ce2:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ce5:	8b 75 18             	mov    0x18(%ebp),%esi
  800ce8:	cd 30                	int    $0x30
	if (check && ret > 0)
  800cea:	85 c0                	test   %eax,%eax
  800cec:	7f 08                	jg     800cf6 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800cee:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cf1:	5b                   	pop    %ebx
  800cf2:	5e                   	pop    %esi
  800cf3:	5f                   	pop    %edi
  800cf4:	5d                   	pop    %ebp
  800cf5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cf6:	83 ec 0c             	sub    $0xc,%esp
  800cf9:	50                   	push   %eax
  800cfa:	6a 05                	push   $0x5
  800cfc:	68 a0 15 80 00       	push   $0x8015a0
  800d01:	6a 4c                	push   $0x4c
  800d03:	68 bd 15 80 00       	push   $0x8015bd
  800d08:	e8 3e 02 00 00       	call   800f4b <_panic>

00800d0d <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d0d:	55                   	push   %ebp
  800d0e:	89 e5                	mov    %esp,%ebp
  800d10:	57                   	push   %edi
  800d11:	56                   	push   %esi
  800d12:	53                   	push   %ebx
  800d13:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d16:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d1b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d1e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d21:	b8 06 00 00 00       	mov    $0x6,%eax
  800d26:	89 df                	mov    %ebx,%edi
  800d28:	89 de                	mov    %ebx,%esi
  800d2a:	cd 30                	int    $0x30
	if (check && ret > 0)
  800d2c:	85 c0                	test   %eax,%eax
  800d2e:	7f 08                	jg     800d38 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d30:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d33:	5b                   	pop    %ebx
  800d34:	5e                   	pop    %esi
  800d35:	5f                   	pop    %edi
  800d36:	5d                   	pop    %ebp
  800d37:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d38:	83 ec 0c             	sub    $0xc,%esp
  800d3b:	50                   	push   %eax
  800d3c:	6a 06                	push   $0x6
  800d3e:	68 a0 15 80 00       	push   $0x8015a0
  800d43:	6a 4c                	push   $0x4c
  800d45:	68 bd 15 80 00       	push   $0x8015bd
  800d4a:	e8 fc 01 00 00       	call   800f4b <_panic>

00800d4f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d4f:	55                   	push   %ebp
  800d50:	89 e5                	mov    %esp,%ebp
  800d52:	57                   	push   %edi
  800d53:	56                   	push   %esi
  800d54:	53                   	push   %ebx
  800d55:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d58:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d5d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d60:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d63:	b8 08 00 00 00       	mov    $0x8,%eax
  800d68:	89 df                	mov    %ebx,%edi
  800d6a:	89 de                	mov    %ebx,%esi
  800d6c:	cd 30                	int    $0x30
	if (check && ret > 0)
  800d6e:	85 c0                	test   %eax,%eax
  800d70:	7f 08                	jg     800d7a <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d72:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d75:	5b                   	pop    %ebx
  800d76:	5e                   	pop    %esi
  800d77:	5f                   	pop    %edi
  800d78:	5d                   	pop    %ebp
  800d79:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d7a:	83 ec 0c             	sub    $0xc,%esp
  800d7d:	50                   	push   %eax
  800d7e:	6a 08                	push   $0x8
  800d80:	68 a0 15 80 00       	push   $0x8015a0
  800d85:	6a 4c                	push   $0x4c
  800d87:	68 bd 15 80 00       	push   $0x8015bd
  800d8c:	e8 ba 01 00 00       	call   800f4b <_panic>

00800d91 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d91:	55                   	push   %ebp
  800d92:	89 e5                	mov    %esp,%ebp
  800d94:	57                   	push   %edi
  800d95:	56                   	push   %esi
  800d96:	53                   	push   %ebx
  800d97:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d9a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d9f:	8b 55 08             	mov    0x8(%ebp),%edx
  800da2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da5:	b8 09 00 00 00       	mov    $0x9,%eax
  800daa:	89 df                	mov    %ebx,%edi
  800dac:	89 de                	mov    %ebx,%esi
  800dae:	cd 30                	int    $0x30
	if (check && ret > 0)
  800db0:	85 c0                	test   %eax,%eax
  800db2:	7f 08                	jg     800dbc <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800db4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800db7:	5b                   	pop    %ebx
  800db8:	5e                   	pop    %esi
  800db9:	5f                   	pop    %edi
  800dba:	5d                   	pop    %ebp
  800dbb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dbc:	83 ec 0c             	sub    $0xc,%esp
  800dbf:	50                   	push   %eax
  800dc0:	6a 09                	push   $0x9
  800dc2:	68 a0 15 80 00       	push   $0x8015a0
  800dc7:	6a 4c                	push   $0x4c
  800dc9:	68 bd 15 80 00       	push   $0x8015bd
  800dce:	e8 78 01 00 00       	call   800f4b <_panic>

00800dd3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800dd3:	55                   	push   %ebp
  800dd4:	89 e5                	mov    %esp,%ebp
  800dd6:	57                   	push   %edi
  800dd7:	56                   	push   %esi
  800dd8:	53                   	push   %ebx
  800dd9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ddc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800de1:	8b 55 08             	mov    0x8(%ebp),%edx
  800de4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de7:	b8 0a 00 00 00       	mov    $0xa,%eax
  800dec:	89 df                	mov    %ebx,%edi
  800dee:	89 de                	mov    %ebx,%esi
  800df0:	cd 30                	int    $0x30
	if (check && ret > 0)
  800df2:	85 c0                	test   %eax,%eax
  800df4:	7f 08                	jg     800dfe <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800df6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800df9:	5b                   	pop    %ebx
  800dfa:	5e                   	pop    %esi
  800dfb:	5f                   	pop    %edi
  800dfc:	5d                   	pop    %ebp
  800dfd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dfe:	83 ec 0c             	sub    $0xc,%esp
  800e01:	50                   	push   %eax
  800e02:	6a 0a                	push   $0xa
  800e04:	68 a0 15 80 00       	push   $0x8015a0
  800e09:	6a 4c                	push   $0x4c
  800e0b:	68 bd 15 80 00       	push   $0x8015bd
  800e10:	e8 36 01 00 00       	call   800f4b <_panic>

00800e15 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e15:	55                   	push   %ebp
  800e16:	89 e5                	mov    %esp,%ebp
  800e18:	57                   	push   %edi
  800e19:	56                   	push   %esi
  800e1a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e1b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e21:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e26:	be 00 00 00 00       	mov    $0x0,%esi
  800e2b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e2e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e31:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e33:	5b                   	pop    %ebx
  800e34:	5e                   	pop    %esi
  800e35:	5f                   	pop    %edi
  800e36:	5d                   	pop    %ebp
  800e37:	c3                   	ret    

00800e38 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e38:	55                   	push   %ebp
  800e39:	89 e5                	mov    %esp,%ebp
  800e3b:	57                   	push   %edi
  800e3c:	56                   	push   %esi
  800e3d:	53                   	push   %ebx
  800e3e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e41:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e46:	8b 55 08             	mov    0x8(%ebp),%edx
  800e49:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e4e:	89 cb                	mov    %ecx,%ebx
  800e50:	89 cf                	mov    %ecx,%edi
  800e52:	89 ce                	mov    %ecx,%esi
  800e54:	cd 30                	int    $0x30
	if (check && ret > 0)
  800e56:	85 c0                	test   %eax,%eax
  800e58:	7f 08                	jg     800e62 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e5a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e5d:	5b                   	pop    %ebx
  800e5e:	5e                   	pop    %esi
  800e5f:	5f                   	pop    %edi
  800e60:	5d                   	pop    %ebp
  800e61:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e62:	83 ec 0c             	sub    $0xc,%esp
  800e65:	50                   	push   %eax
  800e66:	6a 0d                	push   $0xd
  800e68:	68 a0 15 80 00       	push   $0x8015a0
  800e6d:	6a 4c                	push   $0x4c
  800e6f:	68 bd 15 80 00       	push   $0x8015bd
  800e74:	e8 d2 00 00 00       	call   800f4b <_panic>

00800e79 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800e79:	55                   	push   %ebp
  800e7a:	89 e5                	mov    %esp,%ebp
  800e7c:	57                   	push   %edi
  800e7d:	56                   	push   %esi
  800e7e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e7f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e84:	8b 55 08             	mov    0x8(%ebp),%edx
  800e87:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e8a:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e8f:	89 df                	mov    %ebx,%edi
  800e91:	89 de                	mov    %ebx,%esi
  800e93:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800e95:	5b                   	pop    %ebx
  800e96:	5e                   	pop    %esi
  800e97:	5f                   	pop    %edi
  800e98:	5d                   	pop    %ebp
  800e99:	c3                   	ret    

00800e9a <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800e9a:	55                   	push   %ebp
  800e9b:	89 e5                	mov    %esp,%ebp
  800e9d:	57                   	push   %edi
  800e9e:	56                   	push   %esi
  800e9f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ea0:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ea5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea8:	b8 0f 00 00 00       	mov    $0xf,%eax
  800ead:	89 cb                	mov    %ecx,%ebx
  800eaf:	89 cf                	mov    %ecx,%edi
  800eb1:	89 ce                	mov    %ecx,%esi
  800eb3:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800eb5:	5b                   	pop    %ebx
  800eb6:	5e                   	pop    %esi
  800eb7:	5f                   	pop    %edi
  800eb8:	5d                   	pop    %ebp
  800eb9:	c3                   	ret    

00800eba <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800eba:	55                   	push   %ebp
  800ebb:	89 e5                	mov    %esp,%ebp
  800ebd:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  800ec0:	83 3d 08 20 80 00 00 	cmpl   $0x0,0x802008
  800ec7:	74 0a                	je     800ed3 <set_pgfault_handler+0x19>
			panic("set_pgfault_handler: sys_env_set_pgfault_upcall fail, ret:%d", ret);
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  800ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecc:	a3 08 20 80 00       	mov    %eax,0x802008
}
  800ed1:	c9                   	leave  
  800ed2:	c3                   	ret    
		ret = sys_page_alloc((envid_t)0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W);
  800ed3:	83 ec 04             	sub    $0x4,%esp
  800ed6:	6a 07                	push   $0x7
  800ed8:	68 00 f0 bf ee       	push   $0xeebff000
  800edd:	6a 00                	push   $0x0
  800edf:	e8 a4 fd ff ff       	call   800c88 <sys_page_alloc>
		if(ret < 0){
  800ee4:	83 c4 10             	add    $0x10,%esp
  800ee7:	85 c0                	test   %eax,%eax
  800ee9:	78 28                	js     800f13 <set_pgfault_handler+0x59>
    	ret = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  800eeb:	83 ec 08             	sub    $0x8,%esp
  800eee:	68 25 0f 80 00       	push   $0x800f25
  800ef3:	6a 00                	push   $0x0
  800ef5:	e8 d9 fe ff ff       	call   800dd3 <sys_env_set_pgfault_upcall>
		if(ret < 0){
  800efa:	83 c4 10             	add    $0x10,%esp
  800efd:	85 c0                	test   %eax,%eax
  800eff:	79 c8                	jns    800ec9 <set_pgfault_handler+0xf>
			panic("set_pgfault_handler: sys_env_set_pgfault_upcall fail, ret:%d", ret);
  800f01:	50                   	push   %eax
  800f02:	68 00 16 80 00       	push   $0x801600
  800f07:	6a 28                	push   $0x28
  800f09:	68 3d 16 80 00       	push   $0x80163d
  800f0e:	e8 38 00 00 00       	call   800f4b <_panic>
			panic("set_pgfault_handler: sys_page_alloc fail, ret:%d", ret);
  800f13:	50                   	push   %eax
  800f14:	68 cc 15 80 00       	push   $0x8015cc
  800f19:	6a 24                	push   $0x24
  800f1b:	68 3d 16 80 00       	push   $0x80163d
  800f20:	e8 26 00 00 00       	call   800f4b <_panic>

00800f25 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  800f25:	54                   	push   %esp
	movl _pgfault_handler, %eax
  800f26:	a1 08 20 80 00       	mov    0x802008,%eax
	call *%eax
  800f2b:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  800f2d:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %edi
  800f30:	8b 7c 24 28          	mov    0x28(%esp),%edi
	movl 0x30(%esp), %esi
  800f34:	8b 74 24 30          	mov    0x30(%esp),%esi
	subl $4, %esi
  800f38:	83 ee 04             	sub    $0x4,%esi
	movl %edi, (%esi)
  800f3b:	89 3e                	mov    %edi,(%esi)
	movl %esi, 0x30(%esp)
  800f3d:	89 74 24 30          	mov    %esi,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  800f41:	83 c4 08             	add    $0x8,%esp
	popal
  800f44:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  800f45:	83 c4 04             	add    $0x4,%esp
	popfl
  800f48:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  800f49:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  800f4a:	c3                   	ret    

00800f4b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800f4b:	55                   	push   %ebp
  800f4c:	89 e5                	mov    %esp,%ebp
  800f4e:	56                   	push   %esi
  800f4f:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800f50:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800f53:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800f59:	e8 ec fc ff ff       	call   800c4a <sys_getenvid>
  800f5e:	83 ec 0c             	sub    $0xc,%esp
  800f61:	ff 75 0c             	pushl  0xc(%ebp)
  800f64:	ff 75 08             	pushl  0x8(%ebp)
  800f67:	56                   	push   %esi
  800f68:	50                   	push   %eax
  800f69:	68 4c 16 80 00       	push   $0x80164c
  800f6e:	e8 fd f1 ff ff       	call   800170 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800f73:	83 c4 18             	add    $0x18,%esp
  800f76:	53                   	push   %ebx
  800f77:	ff 75 10             	pushl  0x10(%ebp)
  800f7a:	e8 a0 f1 ff ff       	call   80011f <vcprintf>
	cprintf("\n");
  800f7f:	c7 04 24 1a 12 80 00 	movl   $0x80121a,(%esp)
  800f86:	e8 e5 f1 ff ff       	call   800170 <cprintf>
  800f8b:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800f8e:	cc                   	int3   
  800f8f:	eb fd                	jmp    800f8e <_panic+0x43>
  800f91:	66 90                	xchg   %ax,%ax
  800f93:	66 90                	xchg   %ax,%ax
  800f95:	66 90                	xchg   %ax,%ax
  800f97:	66 90                	xchg   %ax,%ax
  800f99:	66 90                	xchg   %ax,%ax
  800f9b:	66 90                	xchg   %ax,%ax
  800f9d:	66 90                	xchg   %ax,%ax
  800f9f:	90                   	nop

00800fa0 <__udivdi3>:
  800fa0:	55                   	push   %ebp
  800fa1:	57                   	push   %edi
  800fa2:	56                   	push   %esi
  800fa3:	53                   	push   %ebx
  800fa4:	83 ec 1c             	sub    $0x1c,%esp
  800fa7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800fab:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800faf:	8b 74 24 34          	mov    0x34(%esp),%esi
  800fb3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800fb7:	85 d2                	test   %edx,%edx
  800fb9:	75 4d                	jne    801008 <__udivdi3+0x68>
  800fbb:	39 f3                	cmp    %esi,%ebx
  800fbd:	76 19                	jbe    800fd8 <__udivdi3+0x38>
  800fbf:	31 ff                	xor    %edi,%edi
  800fc1:	89 e8                	mov    %ebp,%eax
  800fc3:	89 f2                	mov    %esi,%edx
  800fc5:	f7 f3                	div    %ebx
  800fc7:	89 fa                	mov    %edi,%edx
  800fc9:	83 c4 1c             	add    $0x1c,%esp
  800fcc:	5b                   	pop    %ebx
  800fcd:	5e                   	pop    %esi
  800fce:	5f                   	pop    %edi
  800fcf:	5d                   	pop    %ebp
  800fd0:	c3                   	ret    
  800fd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800fd8:	89 d9                	mov    %ebx,%ecx
  800fda:	85 db                	test   %ebx,%ebx
  800fdc:	75 0b                	jne    800fe9 <__udivdi3+0x49>
  800fde:	b8 01 00 00 00       	mov    $0x1,%eax
  800fe3:	31 d2                	xor    %edx,%edx
  800fe5:	f7 f3                	div    %ebx
  800fe7:	89 c1                	mov    %eax,%ecx
  800fe9:	31 d2                	xor    %edx,%edx
  800feb:	89 f0                	mov    %esi,%eax
  800fed:	f7 f1                	div    %ecx
  800fef:	89 c6                	mov    %eax,%esi
  800ff1:	89 e8                	mov    %ebp,%eax
  800ff3:	89 f7                	mov    %esi,%edi
  800ff5:	f7 f1                	div    %ecx
  800ff7:	89 fa                	mov    %edi,%edx
  800ff9:	83 c4 1c             	add    $0x1c,%esp
  800ffc:	5b                   	pop    %ebx
  800ffd:	5e                   	pop    %esi
  800ffe:	5f                   	pop    %edi
  800fff:	5d                   	pop    %ebp
  801000:	c3                   	ret    
  801001:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801008:	39 f2                	cmp    %esi,%edx
  80100a:	77 1c                	ja     801028 <__udivdi3+0x88>
  80100c:	0f bd fa             	bsr    %edx,%edi
  80100f:	83 f7 1f             	xor    $0x1f,%edi
  801012:	75 2c                	jne    801040 <__udivdi3+0xa0>
  801014:	39 f2                	cmp    %esi,%edx
  801016:	72 06                	jb     80101e <__udivdi3+0x7e>
  801018:	31 c0                	xor    %eax,%eax
  80101a:	39 eb                	cmp    %ebp,%ebx
  80101c:	77 a9                	ja     800fc7 <__udivdi3+0x27>
  80101e:	b8 01 00 00 00       	mov    $0x1,%eax
  801023:	eb a2                	jmp    800fc7 <__udivdi3+0x27>
  801025:	8d 76 00             	lea    0x0(%esi),%esi
  801028:	31 ff                	xor    %edi,%edi
  80102a:	31 c0                	xor    %eax,%eax
  80102c:	89 fa                	mov    %edi,%edx
  80102e:	83 c4 1c             	add    $0x1c,%esp
  801031:	5b                   	pop    %ebx
  801032:	5e                   	pop    %esi
  801033:	5f                   	pop    %edi
  801034:	5d                   	pop    %ebp
  801035:	c3                   	ret    
  801036:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80103d:	8d 76 00             	lea    0x0(%esi),%esi
  801040:	89 f9                	mov    %edi,%ecx
  801042:	b8 20 00 00 00       	mov    $0x20,%eax
  801047:	29 f8                	sub    %edi,%eax
  801049:	d3 e2                	shl    %cl,%edx
  80104b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80104f:	89 c1                	mov    %eax,%ecx
  801051:	89 da                	mov    %ebx,%edx
  801053:	d3 ea                	shr    %cl,%edx
  801055:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801059:	09 d1                	or     %edx,%ecx
  80105b:	89 f2                	mov    %esi,%edx
  80105d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801061:	89 f9                	mov    %edi,%ecx
  801063:	d3 e3                	shl    %cl,%ebx
  801065:	89 c1                	mov    %eax,%ecx
  801067:	d3 ea                	shr    %cl,%edx
  801069:	89 f9                	mov    %edi,%ecx
  80106b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80106f:	89 eb                	mov    %ebp,%ebx
  801071:	d3 e6                	shl    %cl,%esi
  801073:	89 c1                	mov    %eax,%ecx
  801075:	d3 eb                	shr    %cl,%ebx
  801077:	09 de                	or     %ebx,%esi
  801079:	89 f0                	mov    %esi,%eax
  80107b:	f7 74 24 08          	divl   0x8(%esp)
  80107f:	89 d6                	mov    %edx,%esi
  801081:	89 c3                	mov    %eax,%ebx
  801083:	f7 64 24 0c          	mull   0xc(%esp)
  801087:	39 d6                	cmp    %edx,%esi
  801089:	72 15                	jb     8010a0 <__udivdi3+0x100>
  80108b:	89 f9                	mov    %edi,%ecx
  80108d:	d3 e5                	shl    %cl,%ebp
  80108f:	39 c5                	cmp    %eax,%ebp
  801091:	73 04                	jae    801097 <__udivdi3+0xf7>
  801093:	39 d6                	cmp    %edx,%esi
  801095:	74 09                	je     8010a0 <__udivdi3+0x100>
  801097:	89 d8                	mov    %ebx,%eax
  801099:	31 ff                	xor    %edi,%edi
  80109b:	e9 27 ff ff ff       	jmp    800fc7 <__udivdi3+0x27>
  8010a0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8010a3:	31 ff                	xor    %edi,%edi
  8010a5:	e9 1d ff ff ff       	jmp    800fc7 <__udivdi3+0x27>
  8010aa:	66 90                	xchg   %ax,%ax
  8010ac:	66 90                	xchg   %ax,%ax
  8010ae:	66 90                	xchg   %ax,%ax

008010b0 <__umoddi3>:
  8010b0:	55                   	push   %ebp
  8010b1:	57                   	push   %edi
  8010b2:	56                   	push   %esi
  8010b3:	53                   	push   %ebx
  8010b4:	83 ec 1c             	sub    $0x1c,%esp
  8010b7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8010bb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8010bf:	8b 74 24 30          	mov    0x30(%esp),%esi
  8010c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8010c7:	89 da                	mov    %ebx,%edx
  8010c9:	85 c0                	test   %eax,%eax
  8010cb:	75 43                	jne    801110 <__umoddi3+0x60>
  8010cd:	39 df                	cmp    %ebx,%edi
  8010cf:	76 17                	jbe    8010e8 <__umoddi3+0x38>
  8010d1:	89 f0                	mov    %esi,%eax
  8010d3:	f7 f7                	div    %edi
  8010d5:	89 d0                	mov    %edx,%eax
  8010d7:	31 d2                	xor    %edx,%edx
  8010d9:	83 c4 1c             	add    $0x1c,%esp
  8010dc:	5b                   	pop    %ebx
  8010dd:	5e                   	pop    %esi
  8010de:	5f                   	pop    %edi
  8010df:	5d                   	pop    %ebp
  8010e0:	c3                   	ret    
  8010e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8010e8:	89 fd                	mov    %edi,%ebp
  8010ea:	85 ff                	test   %edi,%edi
  8010ec:	75 0b                	jne    8010f9 <__umoddi3+0x49>
  8010ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8010f3:	31 d2                	xor    %edx,%edx
  8010f5:	f7 f7                	div    %edi
  8010f7:	89 c5                	mov    %eax,%ebp
  8010f9:	89 d8                	mov    %ebx,%eax
  8010fb:	31 d2                	xor    %edx,%edx
  8010fd:	f7 f5                	div    %ebp
  8010ff:	89 f0                	mov    %esi,%eax
  801101:	f7 f5                	div    %ebp
  801103:	89 d0                	mov    %edx,%eax
  801105:	eb d0                	jmp    8010d7 <__umoddi3+0x27>
  801107:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80110e:	66 90                	xchg   %ax,%ax
  801110:	89 f1                	mov    %esi,%ecx
  801112:	39 d8                	cmp    %ebx,%eax
  801114:	76 0a                	jbe    801120 <__umoddi3+0x70>
  801116:	89 f0                	mov    %esi,%eax
  801118:	83 c4 1c             	add    $0x1c,%esp
  80111b:	5b                   	pop    %ebx
  80111c:	5e                   	pop    %esi
  80111d:	5f                   	pop    %edi
  80111e:	5d                   	pop    %ebp
  80111f:	c3                   	ret    
  801120:	0f bd e8             	bsr    %eax,%ebp
  801123:	83 f5 1f             	xor    $0x1f,%ebp
  801126:	75 20                	jne    801148 <__umoddi3+0x98>
  801128:	39 d8                	cmp    %ebx,%eax
  80112a:	0f 82 b0 00 00 00    	jb     8011e0 <__umoddi3+0x130>
  801130:	39 f7                	cmp    %esi,%edi
  801132:	0f 86 a8 00 00 00    	jbe    8011e0 <__umoddi3+0x130>
  801138:	89 c8                	mov    %ecx,%eax
  80113a:	83 c4 1c             	add    $0x1c,%esp
  80113d:	5b                   	pop    %ebx
  80113e:	5e                   	pop    %esi
  80113f:	5f                   	pop    %edi
  801140:	5d                   	pop    %ebp
  801141:	c3                   	ret    
  801142:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801148:	89 e9                	mov    %ebp,%ecx
  80114a:	ba 20 00 00 00       	mov    $0x20,%edx
  80114f:	29 ea                	sub    %ebp,%edx
  801151:	d3 e0                	shl    %cl,%eax
  801153:	89 44 24 08          	mov    %eax,0x8(%esp)
  801157:	89 d1                	mov    %edx,%ecx
  801159:	89 f8                	mov    %edi,%eax
  80115b:	d3 e8                	shr    %cl,%eax
  80115d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801161:	89 54 24 04          	mov    %edx,0x4(%esp)
  801165:	8b 54 24 04          	mov    0x4(%esp),%edx
  801169:	09 c1                	or     %eax,%ecx
  80116b:	89 d8                	mov    %ebx,%eax
  80116d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801171:	89 e9                	mov    %ebp,%ecx
  801173:	d3 e7                	shl    %cl,%edi
  801175:	89 d1                	mov    %edx,%ecx
  801177:	d3 e8                	shr    %cl,%eax
  801179:	89 e9                	mov    %ebp,%ecx
  80117b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80117f:	d3 e3                	shl    %cl,%ebx
  801181:	89 c7                	mov    %eax,%edi
  801183:	89 d1                	mov    %edx,%ecx
  801185:	89 f0                	mov    %esi,%eax
  801187:	d3 e8                	shr    %cl,%eax
  801189:	89 e9                	mov    %ebp,%ecx
  80118b:	89 fa                	mov    %edi,%edx
  80118d:	d3 e6                	shl    %cl,%esi
  80118f:	09 d8                	or     %ebx,%eax
  801191:	f7 74 24 08          	divl   0x8(%esp)
  801195:	89 d1                	mov    %edx,%ecx
  801197:	89 f3                	mov    %esi,%ebx
  801199:	f7 64 24 0c          	mull   0xc(%esp)
  80119d:	89 c6                	mov    %eax,%esi
  80119f:	89 d7                	mov    %edx,%edi
  8011a1:	39 d1                	cmp    %edx,%ecx
  8011a3:	72 06                	jb     8011ab <__umoddi3+0xfb>
  8011a5:	75 10                	jne    8011b7 <__umoddi3+0x107>
  8011a7:	39 c3                	cmp    %eax,%ebx
  8011a9:	73 0c                	jae    8011b7 <__umoddi3+0x107>
  8011ab:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8011af:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8011b3:	89 d7                	mov    %edx,%edi
  8011b5:	89 c6                	mov    %eax,%esi
  8011b7:	89 ca                	mov    %ecx,%edx
  8011b9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8011be:	29 f3                	sub    %esi,%ebx
  8011c0:	19 fa                	sbb    %edi,%edx
  8011c2:	89 d0                	mov    %edx,%eax
  8011c4:	d3 e0                	shl    %cl,%eax
  8011c6:	89 e9                	mov    %ebp,%ecx
  8011c8:	d3 eb                	shr    %cl,%ebx
  8011ca:	d3 ea                	shr    %cl,%edx
  8011cc:	09 d8                	or     %ebx,%eax
  8011ce:	83 c4 1c             	add    $0x1c,%esp
  8011d1:	5b                   	pop    %ebx
  8011d2:	5e                   	pop    %esi
  8011d3:	5f                   	pop    %edi
  8011d4:	5d                   	pop    %ebp
  8011d5:	c3                   	ret    
  8011d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8011dd:	8d 76 00             	lea    0x0(%esi),%esi
  8011e0:	89 da                	mov    %ebx,%edx
  8011e2:	29 fe                	sub    %edi,%esi
  8011e4:	19 c2                	sbb    %eax,%edx
  8011e6:	89 f1                	mov    %esi,%ecx
  8011e8:	89 c8                	mov    %ecx,%eax
  8011ea:	e9 4b ff ff ff       	jmp    80113a <__umoddi3+0x8a>
