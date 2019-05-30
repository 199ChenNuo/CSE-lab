
obj/user/divzero.debug:     file format elf32-i386


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
  80002c:	e8 2f 00 00 00       	call   800060 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

int zero;

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	zero = 0;
  800039:	c7 05 04 20 80 00 00 	movl   $0x0,0x802004
  800040:	00 00 00 
	cprintf("1/0 is %08x!\n", 1/zero);
  800043:	b8 01 00 00 00       	mov    $0x1,%eax
  800048:	b9 00 00 00 00       	mov    $0x0,%ecx
  80004d:	99                   	cltd   
  80004e:	f7 f9                	idiv   %ecx
  800050:	50                   	push   %eax
  800051:	68 40 11 80 00       	push   $0x801140
  800056:	e8 f5 00 00 00       	call   800150 <cprintf>
}
  80005b:	83 c4 10             	add    $0x10,%esp
  80005e:	c9                   	leave  
  80005f:	c3                   	ret    

00800060 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800060:	55                   	push   %ebp
  800061:	89 e5                	mov    %esp,%ebp
  800063:	56                   	push   %esi
  800064:	53                   	push   %ebx
  800065:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800068:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	// thisenv = 0;
	thisenv = &(envs[ENVX(sys_getenvid())]);
  80006b:	e8 ba 0b 00 00       	call   800c2a <sys_getenvid>
  800070:	25 ff 03 00 00       	and    $0x3ff,%eax
  800075:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80007b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800080:	a3 08 20 80 00       	mov    %eax,0x802008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800085:	85 db                	test   %ebx,%ebx
  800087:	7e 07                	jle    800090 <libmain+0x30>
		binaryname = argv[0];
  800089:	8b 06                	mov    (%esi),%eax
  80008b:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800090:	83 ec 08             	sub    $0x8,%esp
  800093:	56                   	push   %esi
  800094:	53                   	push   %ebx
  800095:	e8 99 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80009a:	e8 0a 00 00 00       	call   8000a9 <exit>
}
  80009f:	83 c4 10             	add    $0x10,%esp
  8000a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000a5:	5b                   	pop    %ebx
  8000a6:	5e                   	pop    %esi
  8000a7:	5d                   	pop    %ebp
  8000a8:	c3                   	ret    

008000a9 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000a9:	55                   	push   %ebp
  8000aa:	89 e5                	mov    %esp,%ebp
  8000ac:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  8000af:	6a 00                	push   $0x0
  8000b1:	e8 33 0b 00 00       	call   800be9 <sys_env_destroy>
}
  8000b6:	83 c4 10             	add    $0x10,%esp
  8000b9:	c9                   	leave  
  8000ba:	c3                   	ret    

008000bb <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000bb:	55                   	push   %ebp
  8000bc:	89 e5                	mov    %esp,%ebp
  8000be:	53                   	push   %ebx
  8000bf:	83 ec 04             	sub    $0x4,%esp
  8000c2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000c5:	8b 13                	mov    (%ebx),%edx
  8000c7:	8d 42 01             	lea    0x1(%edx),%eax
  8000ca:	89 03                	mov    %eax,(%ebx)
  8000cc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000cf:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000d3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000d8:	74 09                	je     8000e3 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000da:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8000de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000e1:	c9                   	leave  
  8000e2:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8000e3:	83 ec 08             	sub    $0x8,%esp
  8000e6:	68 ff 00 00 00       	push   $0xff
  8000eb:	8d 43 08             	lea    0x8(%ebx),%eax
  8000ee:	50                   	push   %eax
  8000ef:	e8 b8 0a 00 00       	call   800bac <sys_cputs>
		b->idx = 0;
  8000f4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8000fa:	83 c4 10             	add    $0x10,%esp
  8000fd:	eb db                	jmp    8000da <putch+0x1f>

008000ff <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8000ff:	55                   	push   %ebp
  800100:	89 e5                	mov    %esp,%ebp
  800102:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800108:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80010f:	00 00 00 
	b.cnt = 0;
  800112:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800119:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80011c:	ff 75 0c             	pushl  0xc(%ebp)
  80011f:	ff 75 08             	pushl  0x8(%ebp)
  800122:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800128:	50                   	push   %eax
  800129:	68 bb 00 80 00       	push   $0x8000bb
  80012e:	e8 4a 01 00 00       	call   80027d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800133:	83 c4 08             	add    $0x8,%esp
  800136:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80013c:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800142:	50                   	push   %eax
  800143:	e8 64 0a 00 00       	call   800bac <sys_cputs>

	return b.cnt;
}
  800148:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80014e:	c9                   	leave  
  80014f:	c3                   	ret    

00800150 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800150:	55                   	push   %ebp
  800151:	89 e5                	mov    %esp,%ebp
  800153:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800156:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800159:	50                   	push   %eax
  80015a:	ff 75 08             	pushl  0x8(%ebp)
  80015d:	e8 9d ff ff ff       	call   8000ff <vcprintf>
	va_end(ap);

	return cnt;
}
  800162:	c9                   	leave  
  800163:	c3                   	ret    

00800164 <printnum>:


static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800164:	55                   	push   %ebp
  800165:	89 e5                	mov    %esp,%ebp
  800167:	57                   	push   %edi
  800168:	56                   	push   %esi
  800169:	53                   	push   %ebx
  80016a:	83 ec 1c             	sub    $0x1c,%esp
  80016d:	89 c6                	mov    %eax,%esi
  80016f:	89 d7                	mov    %edx,%edi
  800171:	8b 45 08             	mov    0x8(%ebp),%eax
  800174:	8b 55 0c             	mov    0xc(%ebp),%edx
  800177:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80017a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80017d:	8b 45 10             	mov    0x10(%ebp),%eax
  800180:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	// to support '-'
	if(padc == '-'){
  800183:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800187:	74 2c                	je     8001b5 <printnum+0x51>
		while (--width > 0)
			putch(' ', putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800189:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80018c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800193:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800196:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800199:	39 c2                	cmp    %eax,%edx
  80019b:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80019e:	73 43                	jae    8001e3 <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8001a0:	83 eb 01             	sub    $0x1,%ebx
  8001a3:	85 db                	test   %ebx,%ebx
  8001a5:	7e 6c                	jle    800213 <printnum+0xaf>
			putch(padc, putdat);
  8001a7:	83 ec 08             	sub    $0x8,%esp
  8001aa:	57                   	push   %edi
  8001ab:	ff 75 18             	pushl  0x18(%ebp)
  8001ae:	ff d6                	call   *%esi
  8001b0:	83 c4 10             	add    $0x10,%esp
  8001b3:	eb eb                	jmp    8001a0 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8001b5:	83 ec 0c             	sub    $0xc,%esp
  8001b8:	6a 20                	push   $0x20
  8001ba:	6a 00                	push   $0x0
  8001bc:	50                   	push   %eax
  8001bd:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001c0:	ff 75 e0             	pushl  -0x20(%ebp)
  8001c3:	89 fa                	mov    %edi,%edx
  8001c5:	89 f0                	mov    %esi,%eax
  8001c7:	e8 98 ff ff ff       	call   800164 <printnum>
		while (--width > 0)
  8001cc:	83 c4 20             	add    $0x20,%esp
  8001cf:	83 eb 01             	sub    $0x1,%ebx
  8001d2:	85 db                	test   %ebx,%ebx
  8001d4:	7e 65                	jle    80023b <printnum+0xd7>
			putch(' ', putdat);
  8001d6:	83 ec 08             	sub    $0x8,%esp
  8001d9:	57                   	push   %edi
  8001da:	6a 20                	push   $0x20
  8001dc:	ff d6                	call   *%esi
  8001de:	83 c4 10             	add    $0x10,%esp
  8001e1:	eb ec                	jmp    8001cf <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001e3:	83 ec 0c             	sub    $0xc,%esp
  8001e6:	ff 75 18             	pushl  0x18(%ebp)
  8001e9:	83 eb 01             	sub    $0x1,%ebx
  8001ec:	53                   	push   %ebx
  8001ed:	50                   	push   %eax
  8001ee:	83 ec 08             	sub    $0x8,%esp
  8001f1:	ff 75 dc             	pushl  -0x24(%ebp)
  8001f4:	ff 75 d8             	pushl  -0x28(%ebp)
  8001f7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001fa:	ff 75 e0             	pushl  -0x20(%ebp)
  8001fd:	e8 de 0c 00 00       	call   800ee0 <__udivdi3>
  800202:	83 c4 18             	add    $0x18,%esp
  800205:	52                   	push   %edx
  800206:	50                   	push   %eax
  800207:	89 fa                	mov    %edi,%edx
  800209:	89 f0                	mov    %esi,%eax
  80020b:	e8 54 ff ff ff       	call   800164 <printnum>
  800210:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800213:	83 ec 08             	sub    $0x8,%esp
  800216:	57                   	push   %edi
  800217:	83 ec 04             	sub    $0x4,%esp
  80021a:	ff 75 dc             	pushl  -0x24(%ebp)
  80021d:	ff 75 d8             	pushl  -0x28(%ebp)
  800220:	ff 75 e4             	pushl  -0x1c(%ebp)
  800223:	ff 75 e0             	pushl  -0x20(%ebp)
  800226:	e8 c5 0d 00 00       	call   800ff0 <__umoddi3>
  80022b:	83 c4 14             	add    $0x14,%esp
  80022e:	0f be 80 58 11 80 00 	movsbl 0x801158(%eax),%eax
  800235:	50                   	push   %eax
  800236:	ff d6                	call   *%esi
  800238:	83 c4 10             	add    $0x10,%esp
}
  80023b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80023e:	5b                   	pop    %ebx
  80023f:	5e                   	pop    %esi
  800240:	5f                   	pop    %edi
  800241:	5d                   	pop    %ebp
  800242:	c3                   	ret    

00800243 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800243:	55                   	push   %ebp
  800244:	89 e5                	mov    %esp,%ebp
  800246:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800249:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80024d:	8b 10                	mov    (%eax),%edx
  80024f:	3b 50 04             	cmp    0x4(%eax),%edx
  800252:	73 0a                	jae    80025e <sprintputch+0x1b>
		*b->buf++ = ch;
  800254:	8d 4a 01             	lea    0x1(%edx),%ecx
  800257:	89 08                	mov    %ecx,(%eax)
  800259:	8b 45 08             	mov    0x8(%ebp),%eax
  80025c:	88 02                	mov    %al,(%edx)
}
  80025e:	5d                   	pop    %ebp
  80025f:	c3                   	ret    

00800260 <printfmt>:
{
  800260:	55                   	push   %ebp
  800261:	89 e5                	mov    %esp,%ebp
  800263:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800266:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800269:	50                   	push   %eax
  80026a:	ff 75 10             	pushl  0x10(%ebp)
  80026d:	ff 75 0c             	pushl  0xc(%ebp)
  800270:	ff 75 08             	pushl  0x8(%ebp)
  800273:	e8 05 00 00 00       	call   80027d <vprintfmt>
}
  800278:	83 c4 10             	add    $0x10,%esp
  80027b:	c9                   	leave  
  80027c:	c3                   	ret    

0080027d <vprintfmt>:
{
  80027d:	55                   	push   %ebp
  80027e:	89 e5                	mov    %esp,%ebp
  800280:	57                   	push   %edi
  800281:	56                   	push   %esi
  800282:	53                   	push   %ebx
  800283:	83 ec 3c             	sub    $0x3c,%esp
  800286:	8b 75 08             	mov    0x8(%ebp),%esi
  800289:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80028c:	8b 7d 10             	mov    0x10(%ebp),%edi
  80028f:	e9 1e 04 00 00       	jmp    8006b2 <vprintfmt+0x435>
		posflag = 0;
  800294:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
		padc = ' ';
  80029b:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80029f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8002a6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8002ad:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002b4:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  8002bb:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002c0:	8d 47 01             	lea    0x1(%edi),%eax
  8002c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002c6:	0f b6 17             	movzbl (%edi),%edx
  8002c9:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002cc:	3c 55                	cmp    $0x55,%al
  8002ce:	0f 87 d9 04 00 00    	ja     8007ad <vprintfmt+0x530>
  8002d4:	0f b6 c0             	movzbl %al,%eax
  8002d7:	ff 24 85 40 13 80 00 	jmp    *0x801340(,%eax,4)
  8002de:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002e1:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8002e5:	eb d9                	jmp    8002c0 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8002e7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posflag = 1;
  8002ea:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  8002f1:	eb cd                	jmp    8002c0 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8002f3:	0f b6 d2             	movzbl %dl,%edx
  8002f6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8002f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8002fe:	89 75 08             	mov    %esi,0x8(%ebp)
  800301:	eb 0c                	jmp    80030f <vprintfmt+0x92>
		switch (ch = *(unsigned char *) fmt++) {
  800303:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800306:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  80030a:	eb b4                	jmp    8002c0 <vprintfmt+0x43>
			for (precision = 0; ; ++fmt) {
  80030c:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80030f:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800312:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800316:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800319:	8d 72 d0             	lea    -0x30(%edx),%esi
  80031c:	83 fe 09             	cmp    $0x9,%esi
  80031f:	76 eb                	jbe    80030c <vprintfmt+0x8f>
  800321:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800324:	8b 75 08             	mov    0x8(%ebp),%esi
  800327:	eb 14                	jmp    80033d <vprintfmt+0xc0>
			precision = va_arg(ap, int);
  800329:	8b 45 14             	mov    0x14(%ebp),%eax
  80032c:	8b 00                	mov    (%eax),%eax
  80032e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800331:	8b 45 14             	mov    0x14(%ebp),%eax
  800334:	8d 40 04             	lea    0x4(%eax),%eax
  800337:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80033a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80033d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800341:	0f 89 79 ff ff ff    	jns    8002c0 <vprintfmt+0x43>
				width = precision, precision = -1;
  800347:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80034a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80034d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800354:	e9 67 ff ff ff       	jmp    8002c0 <vprintfmt+0x43>
  800359:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80035c:	85 c0                	test   %eax,%eax
  80035e:	0f 48 c1             	cmovs  %ecx,%eax
  800361:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800364:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800367:	e9 54 ff ff ff       	jmp    8002c0 <vprintfmt+0x43>
  80036c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80036f:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800376:	e9 45 ff ff ff       	jmp    8002c0 <vprintfmt+0x43>
			lflag++;
  80037b:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80037f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800382:	e9 39 ff ff ff       	jmp    8002c0 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800387:	8b 45 14             	mov    0x14(%ebp),%eax
  80038a:	8d 78 04             	lea    0x4(%eax),%edi
  80038d:	83 ec 08             	sub    $0x8,%esp
  800390:	53                   	push   %ebx
  800391:	ff 30                	pushl  (%eax)
  800393:	ff d6                	call   *%esi
			break;
  800395:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800398:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80039b:	e9 0f 03 00 00       	jmp    8006af <vprintfmt+0x432>
			err = va_arg(ap, int);
  8003a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a3:	8d 78 04             	lea    0x4(%eax),%edi
  8003a6:	8b 00                	mov    (%eax),%eax
  8003a8:	99                   	cltd   
  8003a9:	31 d0                	xor    %edx,%eax
  8003ab:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003ad:	83 f8 0f             	cmp    $0xf,%eax
  8003b0:	7f 23                	jg     8003d5 <vprintfmt+0x158>
  8003b2:	8b 14 85 a0 14 80 00 	mov    0x8014a0(,%eax,4),%edx
  8003b9:	85 d2                	test   %edx,%edx
  8003bb:	74 18                	je     8003d5 <vprintfmt+0x158>
				printfmt(putch, putdat, "%s", p);
  8003bd:	52                   	push   %edx
  8003be:	68 79 11 80 00       	push   $0x801179
  8003c3:	53                   	push   %ebx
  8003c4:	56                   	push   %esi
  8003c5:	e8 96 fe ff ff       	call   800260 <printfmt>
  8003ca:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003cd:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003d0:	e9 da 02 00 00       	jmp    8006af <vprintfmt+0x432>
				printfmt(putch, putdat, "error %d", err);
  8003d5:	50                   	push   %eax
  8003d6:	68 70 11 80 00       	push   $0x801170
  8003db:	53                   	push   %ebx
  8003dc:	56                   	push   %esi
  8003dd:	e8 7e fe ff ff       	call   800260 <printfmt>
  8003e2:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003e5:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003e8:	e9 c2 02 00 00       	jmp    8006af <vprintfmt+0x432>
			if ((p = va_arg(ap, char *)) == NULL)
  8003ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f0:	83 c0 04             	add    $0x4,%eax
  8003f3:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8003f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f9:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8003fb:	85 c9                	test   %ecx,%ecx
  8003fd:	b8 69 11 80 00       	mov    $0x801169,%eax
  800402:	0f 45 c1             	cmovne %ecx,%eax
  800405:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800408:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80040c:	7e 06                	jle    800414 <vprintfmt+0x197>
  80040e:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800412:	75 0d                	jne    800421 <vprintfmt+0x1a4>
				for (width -= strnlen(p, precision); width > 0; width--)
  800414:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800417:	89 c7                	mov    %eax,%edi
  800419:	03 45 e0             	add    -0x20(%ebp),%eax
  80041c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80041f:	eb 53                	jmp    800474 <vprintfmt+0x1f7>
  800421:	83 ec 08             	sub    $0x8,%esp
  800424:	ff 75 d8             	pushl  -0x28(%ebp)
  800427:	50                   	push   %eax
  800428:	e8 28 04 00 00       	call   800855 <strnlen>
  80042d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800430:	29 c1                	sub    %eax,%ecx
  800432:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  800435:	83 c4 10             	add    $0x10,%esp
  800438:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  80043a:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80043e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800441:	eb 0f                	jmp    800452 <vprintfmt+0x1d5>
					putch(padc, putdat);
  800443:	83 ec 08             	sub    $0x8,%esp
  800446:	53                   	push   %ebx
  800447:	ff 75 e0             	pushl  -0x20(%ebp)
  80044a:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80044c:	83 ef 01             	sub    $0x1,%edi
  80044f:	83 c4 10             	add    $0x10,%esp
  800452:	85 ff                	test   %edi,%edi
  800454:	7f ed                	jg     800443 <vprintfmt+0x1c6>
  800456:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  800459:	85 c9                	test   %ecx,%ecx
  80045b:	b8 00 00 00 00       	mov    $0x0,%eax
  800460:	0f 49 c1             	cmovns %ecx,%eax
  800463:	29 c1                	sub    %eax,%ecx
  800465:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800468:	eb aa                	jmp    800414 <vprintfmt+0x197>
					putch(ch, putdat);
  80046a:	83 ec 08             	sub    $0x8,%esp
  80046d:	53                   	push   %ebx
  80046e:	52                   	push   %edx
  80046f:	ff d6                	call   *%esi
  800471:	83 c4 10             	add    $0x10,%esp
  800474:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800477:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800479:	83 c7 01             	add    $0x1,%edi
  80047c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800480:	0f be d0             	movsbl %al,%edx
  800483:	85 d2                	test   %edx,%edx
  800485:	74 4b                	je     8004d2 <vprintfmt+0x255>
  800487:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80048b:	78 06                	js     800493 <vprintfmt+0x216>
  80048d:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800491:	78 1e                	js     8004b1 <vprintfmt+0x234>
				if (altflag && (ch < ' ' || ch > '~'))
  800493:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800497:	74 d1                	je     80046a <vprintfmt+0x1ed>
  800499:	0f be c0             	movsbl %al,%eax
  80049c:	83 e8 20             	sub    $0x20,%eax
  80049f:	83 f8 5e             	cmp    $0x5e,%eax
  8004a2:	76 c6                	jbe    80046a <vprintfmt+0x1ed>
					putch('?', putdat);
  8004a4:	83 ec 08             	sub    $0x8,%esp
  8004a7:	53                   	push   %ebx
  8004a8:	6a 3f                	push   $0x3f
  8004aa:	ff d6                	call   *%esi
  8004ac:	83 c4 10             	add    $0x10,%esp
  8004af:	eb c3                	jmp    800474 <vprintfmt+0x1f7>
  8004b1:	89 cf                	mov    %ecx,%edi
  8004b3:	eb 0e                	jmp    8004c3 <vprintfmt+0x246>
				putch(' ', putdat);
  8004b5:	83 ec 08             	sub    $0x8,%esp
  8004b8:	53                   	push   %ebx
  8004b9:	6a 20                	push   $0x20
  8004bb:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004bd:	83 ef 01             	sub    $0x1,%edi
  8004c0:	83 c4 10             	add    $0x10,%esp
  8004c3:	85 ff                	test   %edi,%edi
  8004c5:	7f ee                	jg     8004b5 <vprintfmt+0x238>
			if ((p = va_arg(ap, char *)) == NULL)
  8004c7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004ca:	89 45 14             	mov    %eax,0x14(%ebp)
  8004cd:	e9 dd 01 00 00       	jmp    8006af <vprintfmt+0x432>
  8004d2:	89 cf                	mov    %ecx,%edi
  8004d4:	eb ed                	jmp    8004c3 <vprintfmt+0x246>
	if (lflag >= 2)
  8004d6:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8004da:	7f 21                	jg     8004fd <vprintfmt+0x280>
	else if (lflag)
  8004dc:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8004e0:	74 6a                	je     80054c <vprintfmt+0x2cf>
		return va_arg(*ap, long);
  8004e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e5:	8b 00                	mov    (%eax),%eax
  8004e7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004ea:	89 c1                	mov    %eax,%ecx
  8004ec:	c1 f9 1f             	sar    $0x1f,%ecx
  8004ef:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8004f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f5:	8d 40 04             	lea    0x4(%eax),%eax
  8004f8:	89 45 14             	mov    %eax,0x14(%ebp)
  8004fb:	eb 17                	jmp    800514 <vprintfmt+0x297>
		return va_arg(*ap, long long);
  8004fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800500:	8b 50 04             	mov    0x4(%eax),%edx
  800503:	8b 00                	mov    (%eax),%eax
  800505:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800508:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80050b:	8b 45 14             	mov    0x14(%ebp),%eax
  80050e:	8d 40 08             	lea    0x8(%eax),%eax
  800511:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800514:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  800517:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  80051c:	85 d2                	test   %edx,%edx
  80051e:	0f 89 5c 01 00 00    	jns    800680 <vprintfmt+0x403>
				putch('-', putdat);
  800524:	83 ec 08             	sub    $0x8,%esp
  800527:	53                   	push   %ebx
  800528:	6a 2d                	push   $0x2d
  80052a:	ff d6                	call   *%esi
				num = -(long long) num;
  80052c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80052f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800532:	f7 d8                	neg    %eax
  800534:	83 d2 00             	adc    $0x0,%edx
  800537:	f7 da                	neg    %edx
  800539:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80053c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80053f:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800542:	bf 0a 00 00 00       	mov    $0xa,%edi
  800547:	e9 45 01 00 00       	jmp    800691 <vprintfmt+0x414>
		return va_arg(*ap, int);
  80054c:	8b 45 14             	mov    0x14(%ebp),%eax
  80054f:	8b 00                	mov    (%eax),%eax
  800551:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800554:	89 c1                	mov    %eax,%ecx
  800556:	c1 f9 1f             	sar    $0x1f,%ecx
  800559:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80055c:	8b 45 14             	mov    0x14(%ebp),%eax
  80055f:	8d 40 04             	lea    0x4(%eax),%eax
  800562:	89 45 14             	mov    %eax,0x14(%ebp)
  800565:	eb ad                	jmp    800514 <vprintfmt+0x297>
	if (lflag >= 2)
  800567:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  80056b:	7f 29                	jg     800596 <vprintfmt+0x319>
	else if (lflag)
  80056d:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800571:	74 44                	je     8005b7 <vprintfmt+0x33a>
		return va_arg(*ap, unsigned long);
  800573:	8b 45 14             	mov    0x14(%ebp),%eax
  800576:	8b 00                	mov    (%eax),%eax
  800578:	ba 00 00 00 00       	mov    $0x0,%edx
  80057d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800580:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800583:	8b 45 14             	mov    0x14(%ebp),%eax
  800586:	8d 40 04             	lea    0x4(%eax),%eax
  800589:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80058c:	bf 0a 00 00 00       	mov    $0xa,%edi
  800591:	e9 ea 00 00 00       	jmp    800680 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  800596:	8b 45 14             	mov    0x14(%ebp),%eax
  800599:	8b 50 04             	mov    0x4(%eax),%edx
  80059c:	8b 00                	mov    (%eax),%eax
  80059e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005a1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a7:	8d 40 08             	lea    0x8(%eax),%eax
  8005aa:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005ad:	bf 0a 00 00 00       	mov    $0xa,%edi
  8005b2:	e9 c9 00 00 00       	jmp    800680 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  8005b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ba:	8b 00                	mov    (%eax),%eax
  8005bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8005c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005c4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ca:	8d 40 04             	lea    0x4(%eax),%eax
  8005cd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005d0:	bf 0a 00 00 00       	mov    $0xa,%edi
  8005d5:	e9 a6 00 00 00       	jmp    800680 <vprintfmt+0x403>
			putch('0', putdat);
  8005da:	83 ec 08             	sub    $0x8,%esp
  8005dd:	53                   	push   %ebx
  8005de:	6a 30                	push   $0x30
  8005e0:	ff d6                	call   *%esi
	if (lflag >= 2)
  8005e2:	83 c4 10             	add    $0x10,%esp
  8005e5:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8005e9:	7f 26                	jg     800611 <vprintfmt+0x394>
	else if (lflag)
  8005eb:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8005ef:	74 3e                	je     80062f <vprintfmt+0x3b2>
		return va_arg(*ap, unsigned long);
  8005f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f4:	8b 00                	mov    (%eax),%eax
  8005f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8005fb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005fe:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800601:	8b 45 14             	mov    0x14(%ebp),%eax
  800604:	8d 40 04             	lea    0x4(%eax),%eax
  800607:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80060a:	bf 08 00 00 00       	mov    $0x8,%edi
  80060f:	eb 6f                	jmp    800680 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  800611:	8b 45 14             	mov    0x14(%ebp),%eax
  800614:	8b 50 04             	mov    0x4(%eax),%edx
  800617:	8b 00                	mov    (%eax),%eax
  800619:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80061c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80061f:	8b 45 14             	mov    0x14(%ebp),%eax
  800622:	8d 40 08             	lea    0x8(%eax),%eax
  800625:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800628:	bf 08 00 00 00       	mov    $0x8,%edi
  80062d:	eb 51                	jmp    800680 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  80062f:	8b 45 14             	mov    0x14(%ebp),%eax
  800632:	8b 00                	mov    (%eax),%eax
  800634:	ba 00 00 00 00       	mov    $0x0,%edx
  800639:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80063c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80063f:	8b 45 14             	mov    0x14(%ebp),%eax
  800642:	8d 40 04             	lea    0x4(%eax),%eax
  800645:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800648:	bf 08 00 00 00       	mov    $0x8,%edi
  80064d:	eb 31                	jmp    800680 <vprintfmt+0x403>
			putch('0', putdat);
  80064f:	83 ec 08             	sub    $0x8,%esp
  800652:	53                   	push   %ebx
  800653:	6a 30                	push   $0x30
  800655:	ff d6                	call   *%esi
			putch('x', putdat);
  800657:	83 c4 08             	add    $0x8,%esp
  80065a:	53                   	push   %ebx
  80065b:	6a 78                	push   $0x78
  80065d:	ff d6                	call   *%esi
			num = (unsigned long long)
  80065f:	8b 45 14             	mov    0x14(%ebp),%eax
  800662:	8b 00                	mov    (%eax),%eax
  800664:	ba 00 00 00 00       	mov    $0x0,%edx
  800669:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80066c:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80066f:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800672:	8b 45 14             	mov    0x14(%ebp),%eax
  800675:	8d 40 04             	lea    0x4(%eax),%eax
  800678:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80067b:	bf 10 00 00 00       	mov    $0x10,%edi
			if(posflag)
  800680:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800684:	74 0b                	je     800691 <vprintfmt+0x414>
				putch('+', putdat);
  800686:	83 ec 08             	sub    $0x8,%esp
  800689:	53                   	push   %ebx
  80068a:	6a 2b                	push   $0x2b
  80068c:	ff d6                	call   *%esi
  80068e:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  800691:	83 ec 0c             	sub    $0xc,%esp
  800694:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800698:	50                   	push   %eax
  800699:	ff 75 e0             	pushl  -0x20(%ebp)
  80069c:	57                   	push   %edi
  80069d:	ff 75 dc             	pushl  -0x24(%ebp)
  8006a0:	ff 75 d8             	pushl  -0x28(%ebp)
  8006a3:	89 da                	mov    %ebx,%edx
  8006a5:	89 f0                	mov    %esi,%eax
  8006a7:	e8 b8 fa ff ff       	call   800164 <printnum>
			break;
  8006ac:	83 c4 20             	add    $0x20,%esp
			char* cp = va_arg(ap, char *);
  8006af:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006b2:	83 c7 01             	add    $0x1,%edi
  8006b5:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006b9:	83 f8 25             	cmp    $0x25,%eax
  8006bc:	0f 84 d2 fb ff ff    	je     800294 <vprintfmt+0x17>
			if (ch == '\0')
  8006c2:	85 c0                	test   %eax,%eax
  8006c4:	0f 84 03 01 00 00    	je     8007cd <vprintfmt+0x550>
			putch(ch, putdat);
  8006ca:	83 ec 08             	sub    $0x8,%esp
  8006cd:	53                   	push   %ebx
  8006ce:	50                   	push   %eax
  8006cf:	ff d6                	call   *%esi
  8006d1:	83 c4 10             	add    $0x10,%esp
  8006d4:	eb dc                	jmp    8006b2 <vprintfmt+0x435>
	if (lflag >= 2)
  8006d6:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8006da:	7f 29                	jg     800705 <vprintfmt+0x488>
	else if (lflag)
  8006dc:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8006e0:	74 44                	je     800726 <vprintfmt+0x4a9>
		return va_arg(*ap, unsigned long);
  8006e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e5:	8b 00                	mov    (%eax),%eax
  8006e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ec:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ef:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f5:	8d 40 04             	lea    0x4(%eax),%eax
  8006f8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006fb:	bf 10 00 00 00       	mov    $0x10,%edi
  800700:	e9 7b ff ff ff       	jmp    800680 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  800705:	8b 45 14             	mov    0x14(%ebp),%eax
  800708:	8b 50 04             	mov    0x4(%eax),%edx
  80070b:	8b 00                	mov    (%eax),%eax
  80070d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800710:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800713:	8b 45 14             	mov    0x14(%ebp),%eax
  800716:	8d 40 08             	lea    0x8(%eax),%eax
  800719:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80071c:	bf 10 00 00 00       	mov    $0x10,%edi
  800721:	e9 5a ff ff ff       	jmp    800680 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  800726:	8b 45 14             	mov    0x14(%ebp),%eax
  800729:	8b 00                	mov    (%eax),%eax
  80072b:	ba 00 00 00 00       	mov    $0x0,%edx
  800730:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800733:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800736:	8b 45 14             	mov    0x14(%ebp),%eax
  800739:	8d 40 04             	lea    0x4(%eax),%eax
  80073c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80073f:	bf 10 00 00 00       	mov    $0x10,%edi
  800744:	e9 37 ff ff ff       	jmp    800680 <vprintfmt+0x403>
			char* cp = va_arg(ap, char *);
  800749:	8b 45 14             	mov    0x14(%ebp),%eax
  80074c:	8d 78 04             	lea    0x4(%eax),%edi
  80074f:	8b 00                	mov    (%eax),%eax
    			if (cp == NULL) {
  800751:	85 c0                	test   %eax,%eax
  800753:	74 2c                	je     800781 <vprintfmt+0x504>
    			*cp = *(int *)putdat;
  800755:	8b 13                	mov    (%ebx),%edx
  800757:	88 10                	mov    %dl,(%eax)
			char* cp = va_arg(ap, char *);
  800759:	89 7d 14             	mov    %edi,0x14(%ebp)
    			if ((*(int *) putdat) > 127)
  80075c:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  80075f:	0f 8e 4a ff ff ff    	jle    8006af <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", overflow_error);
  800765:	68 c8 12 80 00       	push   $0x8012c8
  80076a:	68 79 11 80 00       	push   $0x801179
  80076f:	53                   	push   %ebx
  800770:	56                   	push   %esi
  800771:	e8 ea fa ff ff       	call   800260 <printfmt>
  800776:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  800779:	89 7d 14             	mov    %edi,0x14(%ebp)
  80077c:	e9 2e ff ff ff       	jmp    8006af <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", null_error);
  800781:	68 90 12 80 00       	push   $0x801290
  800786:	68 79 11 80 00       	push   $0x801179
  80078b:	53                   	push   %ebx
  80078c:	56                   	push   %esi
  80078d:	e8 ce fa ff ff       	call   800260 <printfmt>
        		break;
  800792:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  800795:	89 7d 14             	mov    %edi,0x14(%ebp)
        		break;
  800798:	e9 12 ff ff ff       	jmp    8006af <vprintfmt+0x432>
			putch(ch, putdat);
  80079d:	83 ec 08             	sub    $0x8,%esp
  8007a0:	53                   	push   %ebx
  8007a1:	6a 25                	push   $0x25
  8007a3:	ff d6                	call   *%esi
			break;
  8007a5:	83 c4 10             	add    $0x10,%esp
  8007a8:	e9 02 ff ff ff       	jmp    8006af <vprintfmt+0x432>
			putch('%', putdat);
  8007ad:	83 ec 08             	sub    $0x8,%esp
  8007b0:	53                   	push   %ebx
  8007b1:	6a 25                	push   $0x25
  8007b3:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007b5:	83 c4 10             	add    $0x10,%esp
  8007b8:	89 f8                	mov    %edi,%eax
  8007ba:	eb 03                	jmp    8007bf <vprintfmt+0x542>
  8007bc:	83 e8 01             	sub    $0x1,%eax
  8007bf:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8007c3:	75 f7                	jne    8007bc <vprintfmt+0x53f>
  8007c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007c8:	e9 e2 fe ff ff       	jmp    8006af <vprintfmt+0x432>
}
  8007cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007d0:	5b                   	pop    %ebx
  8007d1:	5e                   	pop    %esi
  8007d2:	5f                   	pop    %edi
  8007d3:	5d                   	pop    %ebp
  8007d4:	c3                   	ret    

008007d5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007d5:	55                   	push   %ebp
  8007d6:	89 e5                	mov    %esp,%ebp
  8007d8:	83 ec 18             	sub    $0x18,%esp
  8007db:	8b 45 08             	mov    0x8(%ebp),%eax
  8007de:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007e1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007e4:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007e8:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007eb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007f2:	85 c0                	test   %eax,%eax
  8007f4:	74 26                	je     80081c <vsnprintf+0x47>
  8007f6:	85 d2                	test   %edx,%edx
  8007f8:	7e 22                	jle    80081c <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007fa:	ff 75 14             	pushl  0x14(%ebp)
  8007fd:	ff 75 10             	pushl  0x10(%ebp)
  800800:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800803:	50                   	push   %eax
  800804:	68 43 02 80 00       	push   $0x800243
  800809:	e8 6f fa ff ff       	call   80027d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80080e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800811:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800814:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800817:	83 c4 10             	add    $0x10,%esp
}
  80081a:	c9                   	leave  
  80081b:	c3                   	ret    
		return -E_INVAL;
  80081c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800821:	eb f7                	jmp    80081a <vsnprintf+0x45>

00800823 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800823:	55                   	push   %ebp
  800824:	89 e5                	mov    %esp,%ebp
  800826:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800829:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80082c:	50                   	push   %eax
  80082d:	ff 75 10             	pushl  0x10(%ebp)
  800830:	ff 75 0c             	pushl  0xc(%ebp)
  800833:	ff 75 08             	pushl  0x8(%ebp)
  800836:	e8 9a ff ff ff       	call   8007d5 <vsnprintf>
	va_end(ap);

	return rc;
}
  80083b:	c9                   	leave  
  80083c:	c3                   	ret    

0080083d <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80083d:	55                   	push   %ebp
  80083e:	89 e5                	mov    %esp,%ebp
  800840:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800843:	b8 00 00 00 00       	mov    $0x0,%eax
  800848:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80084c:	74 05                	je     800853 <strlen+0x16>
		n++;
  80084e:	83 c0 01             	add    $0x1,%eax
  800851:	eb f5                	jmp    800848 <strlen+0xb>
	return n;
}
  800853:	5d                   	pop    %ebp
  800854:	c3                   	ret    

00800855 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800855:	55                   	push   %ebp
  800856:	89 e5                	mov    %esp,%ebp
  800858:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80085b:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80085e:	ba 00 00 00 00       	mov    $0x0,%edx
  800863:	39 c2                	cmp    %eax,%edx
  800865:	74 0d                	je     800874 <strnlen+0x1f>
  800867:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  80086b:	74 05                	je     800872 <strnlen+0x1d>
		n++;
  80086d:	83 c2 01             	add    $0x1,%edx
  800870:	eb f1                	jmp    800863 <strnlen+0xe>
  800872:	89 d0                	mov    %edx,%eax
	return n;
}
  800874:	5d                   	pop    %ebp
  800875:	c3                   	ret    

00800876 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800876:	55                   	push   %ebp
  800877:	89 e5                	mov    %esp,%ebp
  800879:	53                   	push   %ebx
  80087a:	8b 45 08             	mov    0x8(%ebp),%eax
  80087d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800880:	ba 00 00 00 00       	mov    $0x0,%edx
  800885:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800889:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  80088c:	83 c2 01             	add    $0x1,%edx
  80088f:	84 c9                	test   %cl,%cl
  800891:	75 f2                	jne    800885 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800893:	5b                   	pop    %ebx
  800894:	5d                   	pop    %ebp
  800895:	c3                   	ret    

00800896 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800896:	55                   	push   %ebp
  800897:	89 e5                	mov    %esp,%ebp
  800899:	53                   	push   %ebx
  80089a:	83 ec 10             	sub    $0x10,%esp
  80089d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008a0:	53                   	push   %ebx
  8008a1:	e8 97 ff ff ff       	call   80083d <strlen>
  8008a6:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8008a9:	ff 75 0c             	pushl  0xc(%ebp)
  8008ac:	01 d8                	add    %ebx,%eax
  8008ae:	50                   	push   %eax
  8008af:	e8 c2 ff ff ff       	call   800876 <strcpy>
	return dst;
}
  8008b4:	89 d8                	mov    %ebx,%eax
  8008b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008b9:	c9                   	leave  
  8008ba:	c3                   	ret    

008008bb <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008bb:	55                   	push   %ebp
  8008bc:	89 e5                	mov    %esp,%ebp
  8008be:	56                   	push   %esi
  8008bf:	53                   	push   %ebx
  8008c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008c6:	89 c6                	mov    %eax,%esi
  8008c8:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008cb:	89 c2                	mov    %eax,%edx
  8008cd:	39 f2                	cmp    %esi,%edx
  8008cf:	74 11                	je     8008e2 <strncpy+0x27>
		*dst++ = *src;
  8008d1:	83 c2 01             	add    $0x1,%edx
  8008d4:	0f b6 19             	movzbl (%ecx),%ebx
  8008d7:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008da:	80 fb 01             	cmp    $0x1,%bl
  8008dd:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8008e0:	eb eb                	jmp    8008cd <strncpy+0x12>
	}
	return ret;
}
  8008e2:	5b                   	pop    %ebx
  8008e3:	5e                   	pop    %esi
  8008e4:	5d                   	pop    %ebp
  8008e5:	c3                   	ret    

008008e6 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008e6:	55                   	push   %ebp
  8008e7:	89 e5                	mov    %esp,%ebp
  8008e9:	56                   	push   %esi
  8008ea:	53                   	push   %ebx
  8008eb:	8b 75 08             	mov    0x8(%ebp),%esi
  8008ee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008f1:	8b 55 10             	mov    0x10(%ebp),%edx
  8008f4:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008f6:	85 d2                	test   %edx,%edx
  8008f8:	74 21                	je     80091b <strlcpy+0x35>
  8008fa:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8008fe:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800900:	39 c2                	cmp    %eax,%edx
  800902:	74 14                	je     800918 <strlcpy+0x32>
  800904:	0f b6 19             	movzbl (%ecx),%ebx
  800907:	84 db                	test   %bl,%bl
  800909:	74 0b                	je     800916 <strlcpy+0x30>
			*dst++ = *src++;
  80090b:	83 c1 01             	add    $0x1,%ecx
  80090e:	83 c2 01             	add    $0x1,%edx
  800911:	88 5a ff             	mov    %bl,-0x1(%edx)
  800914:	eb ea                	jmp    800900 <strlcpy+0x1a>
  800916:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800918:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80091b:	29 f0                	sub    %esi,%eax
}
  80091d:	5b                   	pop    %ebx
  80091e:	5e                   	pop    %esi
  80091f:	5d                   	pop    %ebp
  800920:	c3                   	ret    

00800921 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800921:	55                   	push   %ebp
  800922:	89 e5                	mov    %esp,%ebp
  800924:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800927:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80092a:	0f b6 01             	movzbl (%ecx),%eax
  80092d:	84 c0                	test   %al,%al
  80092f:	74 0c                	je     80093d <strcmp+0x1c>
  800931:	3a 02                	cmp    (%edx),%al
  800933:	75 08                	jne    80093d <strcmp+0x1c>
		p++, q++;
  800935:	83 c1 01             	add    $0x1,%ecx
  800938:	83 c2 01             	add    $0x1,%edx
  80093b:	eb ed                	jmp    80092a <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80093d:	0f b6 c0             	movzbl %al,%eax
  800940:	0f b6 12             	movzbl (%edx),%edx
  800943:	29 d0                	sub    %edx,%eax
}
  800945:	5d                   	pop    %ebp
  800946:	c3                   	ret    

00800947 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800947:	55                   	push   %ebp
  800948:	89 e5                	mov    %esp,%ebp
  80094a:	53                   	push   %ebx
  80094b:	8b 45 08             	mov    0x8(%ebp),%eax
  80094e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800951:	89 c3                	mov    %eax,%ebx
  800953:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800956:	eb 06                	jmp    80095e <strncmp+0x17>
		n--, p++, q++;
  800958:	83 c0 01             	add    $0x1,%eax
  80095b:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80095e:	39 d8                	cmp    %ebx,%eax
  800960:	74 16                	je     800978 <strncmp+0x31>
  800962:	0f b6 08             	movzbl (%eax),%ecx
  800965:	84 c9                	test   %cl,%cl
  800967:	74 04                	je     80096d <strncmp+0x26>
  800969:	3a 0a                	cmp    (%edx),%cl
  80096b:	74 eb                	je     800958 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80096d:	0f b6 00             	movzbl (%eax),%eax
  800970:	0f b6 12             	movzbl (%edx),%edx
  800973:	29 d0                	sub    %edx,%eax
}
  800975:	5b                   	pop    %ebx
  800976:	5d                   	pop    %ebp
  800977:	c3                   	ret    
		return 0;
  800978:	b8 00 00 00 00       	mov    $0x0,%eax
  80097d:	eb f6                	jmp    800975 <strncmp+0x2e>

0080097f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80097f:	55                   	push   %ebp
  800980:	89 e5                	mov    %esp,%ebp
  800982:	8b 45 08             	mov    0x8(%ebp),%eax
  800985:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800989:	0f b6 10             	movzbl (%eax),%edx
  80098c:	84 d2                	test   %dl,%dl
  80098e:	74 09                	je     800999 <strchr+0x1a>
		if (*s == c)
  800990:	38 ca                	cmp    %cl,%dl
  800992:	74 0a                	je     80099e <strchr+0x1f>
	for (; *s; s++)
  800994:	83 c0 01             	add    $0x1,%eax
  800997:	eb f0                	jmp    800989 <strchr+0xa>
			return (char *) s;
	return 0;
  800999:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80099e:	5d                   	pop    %ebp
  80099f:	c3                   	ret    

008009a0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009a0:	55                   	push   %ebp
  8009a1:	89 e5                	mov    %esp,%ebp
  8009a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009aa:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009ad:	38 ca                	cmp    %cl,%dl
  8009af:	74 09                	je     8009ba <strfind+0x1a>
  8009b1:	84 d2                	test   %dl,%dl
  8009b3:	74 05                	je     8009ba <strfind+0x1a>
	for (; *s; s++)
  8009b5:	83 c0 01             	add    $0x1,%eax
  8009b8:	eb f0                	jmp    8009aa <strfind+0xa>
			break;
	return (char *) s;
}
  8009ba:	5d                   	pop    %ebp
  8009bb:	c3                   	ret    

008009bc <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009bc:	55                   	push   %ebp
  8009bd:	89 e5                	mov    %esp,%ebp
  8009bf:	57                   	push   %edi
  8009c0:	56                   	push   %esi
  8009c1:	53                   	push   %ebx
  8009c2:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009c5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009c8:	85 c9                	test   %ecx,%ecx
  8009ca:	74 31                	je     8009fd <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009cc:	89 f8                	mov    %edi,%eax
  8009ce:	09 c8                	or     %ecx,%eax
  8009d0:	a8 03                	test   $0x3,%al
  8009d2:	75 23                	jne    8009f7 <memset+0x3b>
		c &= 0xFF;
  8009d4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009d8:	89 d3                	mov    %edx,%ebx
  8009da:	c1 e3 08             	shl    $0x8,%ebx
  8009dd:	89 d0                	mov    %edx,%eax
  8009df:	c1 e0 18             	shl    $0x18,%eax
  8009e2:	89 d6                	mov    %edx,%esi
  8009e4:	c1 e6 10             	shl    $0x10,%esi
  8009e7:	09 f0                	or     %esi,%eax
  8009e9:	09 c2                	or     %eax,%edx
  8009eb:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8009ed:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009f0:	89 d0                	mov    %edx,%eax
  8009f2:	fc                   	cld    
  8009f3:	f3 ab                	rep stos %eax,%es:(%edi)
  8009f5:	eb 06                	jmp    8009fd <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009fa:	fc                   	cld    
  8009fb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009fd:	89 f8                	mov    %edi,%eax
  8009ff:	5b                   	pop    %ebx
  800a00:	5e                   	pop    %esi
  800a01:	5f                   	pop    %edi
  800a02:	5d                   	pop    %ebp
  800a03:	c3                   	ret    

00800a04 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a04:	55                   	push   %ebp
  800a05:	89 e5                	mov    %esp,%ebp
  800a07:	57                   	push   %edi
  800a08:	56                   	push   %esi
  800a09:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a0f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a12:	39 c6                	cmp    %eax,%esi
  800a14:	73 32                	jae    800a48 <memmove+0x44>
  800a16:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a19:	39 c2                	cmp    %eax,%edx
  800a1b:	76 2b                	jbe    800a48 <memmove+0x44>
		s += n;
		d += n;
  800a1d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a20:	89 fe                	mov    %edi,%esi
  800a22:	09 ce                	or     %ecx,%esi
  800a24:	09 d6                	or     %edx,%esi
  800a26:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a2c:	75 0e                	jne    800a3c <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a2e:	83 ef 04             	sub    $0x4,%edi
  800a31:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a34:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a37:	fd                   	std    
  800a38:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a3a:	eb 09                	jmp    800a45 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a3c:	83 ef 01             	sub    $0x1,%edi
  800a3f:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a42:	fd                   	std    
  800a43:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a45:	fc                   	cld    
  800a46:	eb 1a                	jmp    800a62 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a48:	89 c2                	mov    %eax,%edx
  800a4a:	09 ca                	or     %ecx,%edx
  800a4c:	09 f2                	or     %esi,%edx
  800a4e:	f6 c2 03             	test   $0x3,%dl
  800a51:	75 0a                	jne    800a5d <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a53:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a56:	89 c7                	mov    %eax,%edi
  800a58:	fc                   	cld    
  800a59:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a5b:	eb 05                	jmp    800a62 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800a5d:	89 c7                	mov    %eax,%edi
  800a5f:	fc                   	cld    
  800a60:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a62:	5e                   	pop    %esi
  800a63:	5f                   	pop    %edi
  800a64:	5d                   	pop    %ebp
  800a65:	c3                   	ret    

00800a66 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a66:	55                   	push   %ebp
  800a67:	89 e5                	mov    %esp,%ebp
  800a69:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a6c:	ff 75 10             	pushl  0x10(%ebp)
  800a6f:	ff 75 0c             	pushl  0xc(%ebp)
  800a72:	ff 75 08             	pushl  0x8(%ebp)
  800a75:	e8 8a ff ff ff       	call   800a04 <memmove>
}
  800a7a:	c9                   	leave  
  800a7b:	c3                   	ret    

00800a7c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a7c:	55                   	push   %ebp
  800a7d:	89 e5                	mov    %esp,%ebp
  800a7f:	56                   	push   %esi
  800a80:	53                   	push   %ebx
  800a81:	8b 45 08             	mov    0x8(%ebp),%eax
  800a84:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a87:	89 c6                	mov    %eax,%esi
  800a89:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a8c:	39 f0                	cmp    %esi,%eax
  800a8e:	74 1c                	je     800aac <memcmp+0x30>
		if (*s1 != *s2)
  800a90:	0f b6 08             	movzbl (%eax),%ecx
  800a93:	0f b6 1a             	movzbl (%edx),%ebx
  800a96:	38 d9                	cmp    %bl,%cl
  800a98:	75 08                	jne    800aa2 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a9a:	83 c0 01             	add    $0x1,%eax
  800a9d:	83 c2 01             	add    $0x1,%edx
  800aa0:	eb ea                	jmp    800a8c <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800aa2:	0f b6 c1             	movzbl %cl,%eax
  800aa5:	0f b6 db             	movzbl %bl,%ebx
  800aa8:	29 d8                	sub    %ebx,%eax
  800aaa:	eb 05                	jmp    800ab1 <memcmp+0x35>
	}

	return 0;
  800aac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ab1:	5b                   	pop    %ebx
  800ab2:	5e                   	pop    %esi
  800ab3:	5d                   	pop    %ebp
  800ab4:	c3                   	ret    

00800ab5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ab5:	55                   	push   %ebp
  800ab6:	89 e5                	mov    %esp,%ebp
  800ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  800abb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800abe:	89 c2                	mov    %eax,%edx
  800ac0:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ac3:	39 d0                	cmp    %edx,%eax
  800ac5:	73 09                	jae    800ad0 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ac7:	38 08                	cmp    %cl,(%eax)
  800ac9:	74 05                	je     800ad0 <memfind+0x1b>
	for (; s < ends; s++)
  800acb:	83 c0 01             	add    $0x1,%eax
  800ace:	eb f3                	jmp    800ac3 <memfind+0xe>
			break;
	return (void *) s;
}
  800ad0:	5d                   	pop    %ebp
  800ad1:	c3                   	ret    

00800ad2 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ad2:	55                   	push   %ebp
  800ad3:	89 e5                	mov    %esp,%ebp
  800ad5:	57                   	push   %edi
  800ad6:	56                   	push   %esi
  800ad7:	53                   	push   %ebx
  800ad8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800adb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ade:	eb 03                	jmp    800ae3 <strtol+0x11>
		s++;
  800ae0:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ae3:	0f b6 01             	movzbl (%ecx),%eax
  800ae6:	3c 20                	cmp    $0x20,%al
  800ae8:	74 f6                	je     800ae0 <strtol+0xe>
  800aea:	3c 09                	cmp    $0x9,%al
  800aec:	74 f2                	je     800ae0 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800aee:	3c 2b                	cmp    $0x2b,%al
  800af0:	74 2a                	je     800b1c <strtol+0x4a>
	int neg = 0;
  800af2:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800af7:	3c 2d                	cmp    $0x2d,%al
  800af9:	74 2b                	je     800b26 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800afb:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b01:	75 0f                	jne    800b12 <strtol+0x40>
  800b03:	80 39 30             	cmpb   $0x30,(%ecx)
  800b06:	74 28                	je     800b30 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b08:	85 db                	test   %ebx,%ebx
  800b0a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b0f:	0f 44 d8             	cmove  %eax,%ebx
  800b12:	b8 00 00 00 00       	mov    $0x0,%eax
  800b17:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b1a:	eb 50                	jmp    800b6c <strtol+0x9a>
		s++;
  800b1c:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b1f:	bf 00 00 00 00       	mov    $0x0,%edi
  800b24:	eb d5                	jmp    800afb <strtol+0x29>
		s++, neg = 1;
  800b26:	83 c1 01             	add    $0x1,%ecx
  800b29:	bf 01 00 00 00       	mov    $0x1,%edi
  800b2e:	eb cb                	jmp    800afb <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b30:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b34:	74 0e                	je     800b44 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800b36:	85 db                	test   %ebx,%ebx
  800b38:	75 d8                	jne    800b12 <strtol+0x40>
		s++, base = 8;
  800b3a:	83 c1 01             	add    $0x1,%ecx
  800b3d:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b42:	eb ce                	jmp    800b12 <strtol+0x40>
		s += 2, base = 16;
  800b44:	83 c1 02             	add    $0x2,%ecx
  800b47:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b4c:	eb c4                	jmp    800b12 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b4e:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b51:	89 f3                	mov    %esi,%ebx
  800b53:	80 fb 19             	cmp    $0x19,%bl
  800b56:	77 29                	ja     800b81 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800b58:	0f be d2             	movsbl %dl,%edx
  800b5b:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b5e:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b61:	7d 30                	jge    800b93 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800b63:	83 c1 01             	add    $0x1,%ecx
  800b66:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b6a:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b6c:	0f b6 11             	movzbl (%ecx),%edx
  800b6f:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b72:	89 f3                	mov    %esi,%ebx
  800b74:	80 fb 09             	cmp    $0x9,%bl
  800b77:	77 d5                	ja     800b4e <strtol+0x7c>
			dig = *s - '0';
  800b79:	0f be d2             	movsbl %dl,%edx
  800b7c:	83 ea 30             	sub    $0x30,%edx
  800b7f:	eb dd                	jmp    800b5e <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800b81:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b84:	89 f3                	mov    %esi,%ebx
  800b86:	80 fb 19             	cmp    $0x19,%bl
  800b89:	77 08                	ja     800b93 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800b8b:	0f be d2             	movsbl %dl,%edx
  800b8e:	83 ea 37             	sub    $0x37,%edx
  800b91:	eb cb                	jmp    800b5e <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b93:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b97:	74 05                	je     800b9e <strtol+0xcc>
		*endptr = (char *) s;
  800b99:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b9c:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b9e:	89 c2                	mov    %eax,%edx
  800ba0:	f7 da                	neg    %edx
  800ba2:	85 ff                	test   %edi,%edi
  800ba4:	0f 45 c2             	cmovne %edx,%eax
}
  800ba7:	5b                   	pop    %ebx
  800ba8:	5e                   	pop    %esi
  800ba9:	5f                   	pop    %edi
  800baa:	5d                   	pop    %ebp
  800bab:	c3                   	ret    

00800bac <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bac:	55                   	push   %ebp
  800bad:	89 e5                	mov    %esp,%ebp
  800baf:	57                   	push   %edi
  800bb0:	56                   	push   %esi
  800bb1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bb2:	b8 00 00 00 00       	mov    $0x0,%eax
  800bb7:	8b 55 08             	mov    0x8(%ebp),%edx
  800bba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bbd:	89 c3                	mov    %eax,%ebx
  800bbf:	89 c7                	mov    %eax,%edi
  800bc1:	89 c6                	mov    %eax,%esi
  800bc3:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bc5:	5b                   	pop    %ebx
  800bc6:	5e                   	pop    %esi
  800bc7:	5f                   	pop    %edi
  800bc8:	5d                   	pop    %ebp
  800bc9:	c3                   	ret    

00800bca <sys_cgetc>:

int
sys_cgetc(void)
{
  800bca:	55                   	push   %ebp
  800bcb:	89 e5                	mov    %esp,%ebp
  800bcd:	57                   	push   %edi
  800bce:	56                   	push   %esi
  800bcf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bd0:	ba 00 00 00 00       	mov    $0x0,%edx
  800bd5:	b8 01 00 00 00       	mov    $0x1,%eax
  800bda:	89 d1                	mov    %edx,%ecx
  800bdc:	89 d3                	mov    %edx,%ebx
  800bde:	89 d7                	mov    %edx,%edi
  800be0:	89 d6                	mov    %edx,%esi
  800be2:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800be4:	5b                   	pop    %ebx
  800be5:	5e                   	pop    %esi
  800be6:	5f                   	pop    %edi
  800be7:	5d                   	pop    %ebp
  800be8:	c3                   	ret    

00800be9 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800be9:	55                   	push   %ebp
  800bea:	89 e5                	mov    %esp,%ebp
  800bec:	57                   	push   %edi
  800bed:	56                   	push   %esi
  800bee:	53                   	push   %ebx
  800bef:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bf2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bf7:	8b 55 08             	mov    0x8(%ebp),%edx
  800bfa:	b8 03 00 00 00       	mov    $0x3,%eax
  800bff:	89 cb                	mov    %ecx,%ebx
  800c01:	89 cf                	mov    %ecx,%edi
  800c03:	89 ce                	mov    %ecx,%esi
  800c05:	cd 30                	int    $0x30
	if (check && ret > 0)
  800c07:	85 c0                	test   %eax,%eax
  800c09:	7f 08                	jg     800c13 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c0e:	5b                   	pop    %ebx
  800c0f:	5e                   	pop    %esi
  800c10:	5f                   	pop    %edi
  800c11:	5d                   	pop    %ebp
  800c12:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c13:	83 ec 0c             	sub    $0xc,%esp
  800c16:	50                   	push   %eax
  800c17:	6a 03                	push   $0x3
  800c19:	68 e0 14 80 00       	push   $0x8014e0
  800c1e:	6a 4c                	push   $0x4c
  800c20:	68 fd 14 80 00       	push   $0x8014fd
  800c25:	e8 70 02 00 00       	call   800e9a <_panic>

00800c2a <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c2a:	55                   	push   %ebp
  800c2b:	89 e5                	mov    %esp,%ebp
  800c2d:	57                   	push   %edi
  800c2e:	56                   	push   %esi
  800c2f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c30:	ba 00 00 00 00       	mov    $0x0,%edx
  800c35:	b8 02 00 00 00       	mov    $0x2,%eax
  800c3a:	89 d1                	mov    %edx,%ecx
  800c3c:	89 d3                	mov    %edx,%ebx
  800c3e:	89 d7                	mov    %edx,%edi
  800c40:	89 d6                	mov    %edx,%esi
  800c42:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c44:	5b                   	pop    %ebx
  800c45:	5e                   	pop    %esi
  800c46:	5f                   	pop    %edi
  800c47:	5d                   	pop    %ebp
  800c48:	c3                   	ret    

00800c49 <sys_yield>:

void
sys_yield(void)
{
  800c49:	55                   	push   %ebp
  800c4a:	89 e5                	mov    %esp,%ebp
  800c4c:	57                   	push   %edi
  800c4d:	56                   	push   %esi
  800c4e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c4f:	ba 00 00 00 00       	mov    $0x0,%edx
  800c54:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c59:	89 d1                	mov    %edx,%ecx
  800c5b:	89 d3                	mov    %edx,%ebx
  800c5d:	89 d7                	mov    %edx,%edi
  800c5f:	89 d6                	mov    %edx,%esi
  800c61:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c63:	5b                   	pop    %ebx
  800c64:	5e                   	pop    %esi
  800c65:	5f                   	pop    %edi
  800c66:	5d                   	pop    %ebp
  800c67:	c3                   	ret    

00800c68 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c68:	55                   	push   %ebp
  800c69:	89 e5                	mov    %esp,%ebp
  800c6b:	57                   	push   %edi
  800c6c:	56                   	push   %esi
  800c6d:	53                   	push   %ebx
  800c6e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c71:	be 00 00 00 00       	mov    $0x0,%esi
  800c76:	8b 55 08             	mov    0x8(%ebp),%edx
  800c79:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c7c:	b8 04 00 00 00       	mov    $0x4,%eax
  800c81:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c84:	89 f7                	mov    %esi,%edi
  800c86:	cd 30                	int    $0x30
	if (check && ret > 0)
  800c88:	85 c0                	test   %eax,%eax
  800c8a:	7f 08                	jg     800c94 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c8f:	5b                   	pop    %ebx
  800c90:	5e                   	pop    %esi
  800c91:	5f                   	pop    %edi
  800c92:	5d                   	pop    %ebp
  800c93:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c94:	83 ec 0c             	sub    $0xc,%esp
  800c97:	50                   	push   %eax
  800c98:	6a 04                	push   $0x4
  800c9a:	68 e0 14 80 00       	push   $0x8014e0
  800c9f:	6a 4c                	push   $0x4c
  800ca1:	68 fd 14 80 00       	push   $0x8014fd
  800ca6:	e8 ef 01 00 00       	call   800e9a <_panic>

00800cab <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cab:	55                   	push   %ebp
  800cac:	89 e5                	mov    %esp,%ebp
  800cae:	57                   	push   %edi
  800caf:	56                   	push   %esi
  800cb0:	53                   	push   %ebx
  800cb1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cb4:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cba:	b8 05 00 00 00       	mov    $0x5,%eax
  800cbf:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cc2:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cc5:	8b 75 18             	mov    0x18(%ebp),%esi
  800cc8:	cd 30                	int    $0x30
	if (check && ret > 0)
  800cca:	85 c0                	test   %eax,%eax
  800ccc:	7f 08                	jg     800cd6 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800cce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cd1:	5b                   	pop    %ebx
  800cd2:	5e                   	pop    %esi
  800cd3:	5f                   	pop    %edi
  800cd4:	5d                   	pop    %ebp
  800cd5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cd6:	83 ec 0c             	sub    $0xc,%esp
  800cd9:	50                   	push   %eax
  800cda:	6a 05                	push   $0x5
  800cdc:	68 e0 14 80 00       	push   $0x8014e0
  800ce1:	6a 4c                	push   $0x4c
  800ce3:	68 fd 14 80 00       	push   $0x8014fd
  800ce8:	e8 ad 01 00 00       	call   800e9a <_panic>

00800ced <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ced:	55                   	push   %ebp
  800cee:	89 e5                	mov    %esp,%ebp
  800cf0:	57                   	push   %edi
  800cf1:	56                   	push   %esi
  800cf2:	53                   	push   %ebx
  800cf3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cf6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cfb:	8b 55 08             	mov    0x8(%ebp),%edx
  800cfe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d01:	b8 06 00 00 00       	mov    $0x6,%eax
  800d06:	89 df                	mov    %ebx,%edi
  800d08:	89 de                	mov    %ebx,%esi
  800d0a:	cd 30                	int    $0x30
	if (check && ret > 0)
  800d0c:	85 c0                	test   %eax,%eax
  800d0e:	7f 08                	jg     800d18 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d10:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d13:	5b                   	pop    %ebx
  800d14:	5e                   	pop    %esi
  800d15:	5f                   	pop    %edi
  800d16:	5d                   	pop    %ebp
  800d17:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d18:	83 ec 0c             	sub    $0xc,%esp
  800d1b:	50                   	push   %eax
  800d1c:	6a 06                	push   $0x6
  800d1e:	68 e0 14 80 00       	push   $0x8014e0
  800d23:	6a 4c                	push   $0x4c
  800d25:	68 fd 14 80 00       	push   $0x8014fd
  800d2a:	e8 6b 01 00 00       	call   800e9a <_panic>

00800d2f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d2f:	55                   	push   %ebp
  800d30:	89 e5                	mov    %esp,%ebp
  800d32:	57                   	push   %edi
  800d33:	56                   	push   %esi
  800d34:	53                   	push   %ebx
  800d35:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d38:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d3d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d40:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d43:	b8 08 00 00 00       	mov    $0x8,%eax
  800d48:	89 df                	mov    %ebx,%edi
  800d4a:	89 de                	mov    %ebx,%esi
  800d4c:	cd 30                	int    $0x30
	if (check && ret > 0)
  800d4e:	85 c0                	test   %eax,%eax
  800d50:	7f 08                	jg     800d5a <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d52:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d55:	5b                   	pop    %ebx
  800d56:	5e                   	pop    %esi
  800d57:	5f                   	pop    %edi
  800d58:	5d                   	pop    %ebp
  800d59:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d5a:	83 ec 0c             	sub    $0xc,%esp
  800d5d:	50                   	push   %eax
  800d5e:	6a 08                	push   $0x8
  800d60:	68 e0 14 80 00       	push   $0x8014e0
  800d65:	6a 4c                	push   $0x4c
  800d67:	68 fd 14 80 00       	push   $0x8014fd
  800d6c:	e8 29 01 00 00       	call   800e9a <_panic>

00800d71 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d71:	55                   	push   %ebp
  800d72:	89 e5                	mov    %esp,%ebp
  800d74:	57                   	push   %edi
  800d75:	56                   	push   %esi
  800d76:	53                   	push   %ebx
  800d77:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d7a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d7f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d82:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d85:	b8 09 00 00 00       	mov    $0x9,%eax
  800d8a:	89 df                	mov    %ebx,%edi
  800d8c:	89 de                	mov    %ebx,%esi
  800d8e:	cd 30                	int    $0x30
	if (check && ret > 0)
  800d90:	85 c0                	test   %eax,%eax
  800d92:	7f 08                	jg     800d9c <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d94:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d97:	5b                   	pop    %ebx
  800d98:	5e                   	pop    %esi
  800d99:	5f                   	pop    %edi
  800d9a:	5d                   	pop    %ebp
  800d9b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d9c:	83 ec 0c             	sub    $0xc,%esp
  800d9f:	50                   	push   %eax
  800da0:	6a 09                	push   $0x9
  800da2:	68 e0 14 80 00       	push   $0x8014e0
  800da7:	6a 4c                	push   $0x4c
  800da9:	68 fd 14 80 00       	push   $0x8014fd
  800dae:	e8 e7 00 00 00       	call   800e9a <_panic>

00800db3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800db3:	55                   	push   %ebp
  800db4:	89 e5                	mov    %esp,%ebp
  800db6:	57                   	push   %edi
  800db7:	56                   	push   %esi
  800db8:	53                   	push   %ebx
  800db9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dbc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dc1:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc7:	b8 0a 00 00 00       	mov    $0xa,%eax
  800dcc:	89 df                	mov    %ebx,%edi
  800dce:	89 de                	mov    %ebx,%esi
  800dd0:	cd 30                	int    $0x30
	if (check && ret > 0)
  800dd2:	85 c0                	test   %eax,%eax
  800dd4:	7f 08                	jg     800dde <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800dd6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dd9:	5b                   	pop    %ebx
  800dda:	5e                   	pop    %esi
  800ddb:	5f                   	pop    %edi
  800ddc:	5d                   	pop    %ebp
  800ddd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dde:	83 ec 0c             	sub    $0xc,%esp
  800de1:	50                   	push   %eax
  800de2:	6a 0a                	push   $0xa
  800de4:	68 e0 14 80 00       	push   $0x8014e0
  800de9:	6a 4c                	push   $0x4c
  800deb:	68 fd 14 80 00       	push   $0x8014fd
  800df0:	e8 a5 00 00 00       	call   800e9a <_panic>

00800df5 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800df5:	55                   	push   %ebp
  800df6:	89 e5                	mov    %esp,%ebp
  800df8:	57                   	push   %edi
  800df9:	56                   	push   %esi
  800dfa:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dfb:	8b 55 08             	mov    0x8(%ebp),%edx
  800dfe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e01:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e06:	be 00 00 00 00       	mov    $0x0,%esi
  800e0b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e0e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e11:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e13:	5b                   	pop    %ebx
  800e14:	5e                   	pop    %esi
  800e15:	5f                   	pop    %edi
  800e16:	5d                   	pop    %ebp
  800e17:	c3                   	ret    

00800e18 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e18:	55                   	push   %ebp
  800e19:	89 e5                	mov    %esp,%ebp
  800e1b:	57                   	push   %edi
  800e1c:	56                   	push   %esi
  800e1d:	53                   	push   %ebx
  800e1e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e21:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e26:	8b 55 08             	mov    0x8(%ebp),%edx
  800e29:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e2e:	89 cb                	mov    %ecx,%ebx
  800e30:	89 cf                	mov    %ecx,%edi
  800e32:	89 ce                	mov    %ecx,%esi
  800e34:	cd 30                	int    $0x30
	if (check && ret > 0)
  800e36:	85 c0                	test   %eax,%eax
  800e38:	7f 08                	jg     800e42 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e3d:	5b                   	pop    %ebx
  800e3e:	5e                   	pop    %esi
  800e3f:	5f                   	pop    %edi
  800e40:	5d                   	pop    %ebp
  800e41:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e42:	83 ec 0c             	sub    $0xc,%esp
  800e45:	50                   	push   %eax
  800e46:	6a 0d                	push   $0xd
  800e48:	68 e0 14 80 00       	push   $0x8014e0
  800e4d:	6a 4c                	push   $0x4c
  800e4f:	68 fd 14 80 00       	push   $0x8014fd
  800e54:	e8 41 00 00 00       	call   800e9a <_panic>

00800e59 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800e59:	55                   	push   %ebp
  800e5a:	89 e5                	mov    %esp,%ebp
  800e5c:	57                   	push   %edi
  800e5d:	56                   	push   %esi
  800e5e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e5f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e64:	8b 55 08             	mov    0x8(%ebp),%edx
  800e67:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e6a:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e6f:	89 df                	mov    %ebx,%edi
  800e71:	89 de                	mov    %ebx,%esi
  800e73:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800e75:	5b                   	pop    %ebx
  800e76:	5e                   	pop    %esi
  800e77:	5f                   	pop    %edi
  800e78:	5d                   	pop    %ebp
  800e79:	c3                   	ret    

00800e7a <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800e7a:	55                   	push   %ebp
  800e7b:	89 e5                	mov    %esp,%ebp
  800e7d:	57                   	push   %edi
  800e7e:	56                   	push   %esi
  800e7f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e80:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e85:	8b 55 08             	mov    0x8(%ebp),%edx
  800e88:	b8 0f 00 00 00       	mov    $0xf,%eax
  800e8d:	89 cb                	mov    %ecx,%ebx
  800e8f:	89 cf                	mov    %ecx,%edi
  800e91:	89 ce                	mov    %ecx,%esi
  800e93:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800e95:	5b                   	pop    %ebx
  800e96:	5e                   	pop    %esi
  800e97:	5f                   	pop    %edi
  800e98:	5d                   	pop    %ebp
  800e99:	c3                   	ret    

00800e9a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800e9a:	55                   	push   %ebp
  800e9b:	89 e5                	mov    %esp,%ebp
  800e9d:	56                   	push   %esi
  800e9e:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800e9f:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800ea2:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800ea8:	e8 7d fd ff ff       	call   800c2a <sys_getenvid>
  800ead:	83 ec 0c             	sub    $0xc,%esp
  800eb0:	ff 75 0c             	pushl  0xc(%ebp)
  800eb3:	ff 75 08             	pushl  0x8(%ebp)
  800eb6:	56                   	push   %esi
  800eb7:	50                   	push   %eax
  800eb8:	68 0c 15 80 00       	push   $0x80150c
  800ebd:	e8 8e f2 ff ff       	call   800150 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800ec2:	83 c4 18             	add    $0x18,%esp
  800ec5:	53                   	push   %ebx
  800ec6:	ff 75 10             	pushl  0x10(%ebp)
  800ec9:	e8 31 f2 ff ff       	call   8000ff <vcprintf>
	cprintf("\n");
  800ece:	c7 04 24 4c 11 80 00 	movl   $0x80114c,(%esp)
  800ed5:	e8 76 f2 ff ff       	call   800150 <cprintf>
  800eda:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800edd:	cc                   	int3   
  800ede:	eb fd                	jmp    800edd <_panic+0x43>

00800ee0 <__udivdi3>:
  800ee0:	55                   	push   %ebp
  800ee1:	57                   	push   %edi
  800ee2:	56                   	push   %esi
  800ee3:	53                   	push   %ebx
  800ee4:	83 ec 1c             	sub    $0x1c,%esp
  800ee7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800eeb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800eef:	8b 74 24 34          	mov    0x34(%esp),%esi
  800ef3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800ef7:	85 d2                	test   %edx,%edx
  800ef9:	75 4d                	jne    800f48 <__udivdi3+0x68>
  800efb:	39 f3                	cmp    %esi,%ebx
  800efd:	76 19                	jbe    800f18 <__udivdi3+0x38>
  800eff:	31 ff                	xor    %edi,%edi
  800f01:	89 e8                	mov    %ebp,%eax
  800f03:	89 f2                	mov    %esi,%edx
  800f05:	f7 f3                	div    %ebx
  800f07:	89 fa                	mov    %edi,%edx
  800f09:	83 c4 1c             	add    $0x1c,%esp
  800f0c:	5b                   	pop    %ebx
  800f0d:	5e                   	pop    %esi
  800f0e:	5f                   	pop    %edi
  800f0f:	5d                   	pop    %ebp
  800f10:	c3                   	ret    
  800f11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f18:	89 d9                	mov    %ebx,%ecx
  800f1a:	85 db                	test   %ebx,%ebx
  800f1c:	75 0b                	jne    800f29 <__udivdi3+0x49>
  800f1e:	b8 01 00 00 00       	mov    $0x1,%eax
  800f23:	31 d2                	xor    %edx,%edx
  800f25:	f7 f3                	div    %ebx
  800f27:	89 c1                	mov    %eax,%ecx
  800f29:	31 d2                	xor    %edx,%edx
  800f2b:	89 f0                	mov    %esi,%eax
  800f2d:	f7 f1                	div    %ecx
  800f2f:	89 c6                	mov    %eax,%esi
  800f31:	89 e8                	mov    %ebp,%eax
  800f33:	89 f7                	mov    %esi,%edi
  800f35:	f7 f1                	div    %ecx
  800f37:	89 fa                	mov    %edi,%edx
  800f39:	83 c4 1c             	add    $0x1c,%esp
  800f3c:	5b                   	pop    %ebx
  800f3d:	5e                   	pop    %esi
  800f3e:	5f                   	pop    %edi
  800f3f:	5d                   	pop    %ebp
  800f40:	c3                   	ret    
  800f41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f48:	39 f2                	cmp    %esi,%edx
  800f4a:	77 1c                	ja     800f68 <__udivdi3+0x88>
  800f4c:	0f bd fa             	bsr    %edx,%edi
  800f4f:	83 f7 1f             	xor    $0x1f,%edi
  800f52:	75 2c                	jne    800f80 <__udivdi3+0xa0>
  800f54:	39 f2                	cmp    %esi,%edx
  800f56:	72 06                	jb     800f5e <__udivdi3+0x7e>
  800f58:	31 c0                	xor    %eax,%eax
  800f5a:	39 eb                	cmp    %ebp,%ebx
  800f5c:	77 a9                	ja     800f07 <__udivdi3+0x27>
  800f5e:	b8 01 00 00 00       	mov    $0x1,%eax
  800f63:	eb a2                	jmp    800f07 <__udivdi3+0x27>
  800f65:	8d 76 00             	lea    0x0(%esi),%esi
  800f68:	31 ff                	xor    %edi,%edi
  800f6a:	31 c0                	xor    %eax,%eax
  800f6c:	89 fa                	mov    %edi,%edx
  800f6e:	83 c4 1c             	add    $0x1c,%esp
  800f71:	5b                   	pop    %ebx
  800f72:	5e                   	pop    %esi
  800f73:	5f                   	pop    %edi
  800f74:	5d                   	pop    %ebp
  800f75:	c3                   	ret    
  800f76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f7d:	8d 76 00             	lea    0x0(%esi),%esi
  800f80:	89 f9                	mov    %edi,%ecx
  800f82:	b8 20 00 00 00       	mov    $0x20,%eax
  800f87:	29 f8                	sub    %edi,%eax
  800f89:	d3 e2                	shl    %cl,%edx
  800f8b:	89 54 24 08          	mov    %edx,0x8(%esp)
  800f8f:	89 c1                	mov    %eax,%ecx
  800f91:	89 da                	mov    %ebx,%edx
  800f93:	d3 ea                	shr    %cl,%edx
  800f95:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800f99:	09 d1                	or     %edx,%ecx
  800f9b:	89 f2                	mov    %esi,%edx
  800f9d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800fa1:	89 f9                	mov    %edi,%ecx
  800fa3:	d3 e3                	shl    %cl,%ebx
  800fa5:	89 c1                	mov    %eax,%ecx
  800fa7:	d3 ea                	shr    %cl,%edx
  800fa9:	89 f9                	mov    %edi,%ecx
  800fab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800faf:	89 eb                	mov    %ebp,%ebx
  800fb1:	d3 e6                	shl    %cl,%esi
  800fb3:	89 c1                	mov    %eax,%ecx
  800fb5:	d3 eb                	shr    %cl,%ebx
  800fb7:	09 de                	or     %ebx,%esi
  800fb9:	89 f0                	mov    %esi,%eax
  800fbb:	f7 74 24 08          	divl   0x8(%esp)
  800fbf:	89 d6                	mov    %edx,%esi
  800fc1:	89 c3                	mov    %eax,%ebx
  800fc3:	f7 64 24 0c          	mull   0xc(%esp)
  800fc7:	39 d6                	cmp    %edx,%esi
  800fc9:	72 15                	jb     800fe0 <__udivdi3+0x100>
  800fcb:	89 f9                	mov    %edi,%ecx
  800fcd:	d3 e5                	shl    %cl,%ebp
  800fcf:	39 c5                	cmp    %eax,%ebp
  800fd1:	73 04                	jae    800fd7 <__udivdi3+0xf7>
  800fd3:	39 d6                	cmp    %edx,%esi
  800fd5:	74 09                	je     800fe0 <__udivdi3+0x100>
  800fd7:	89 d8                	mov    %ebx,%eax
  800fd9:	31 ff                	xor    %edi,%edi
  800fdb:	e9 27 ff ff ff       	jmp    800f07 <__udivdi3+0x27>
  800fe0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800fe3:	31 ff                	xor    %edi,%edi
  800fe5:	e9 1d ff ff ff       	jmp    800f07 <__udivdi3+0x27>
  800fea:	66 90                	xchg   %ax,%ax
  800fec:	66 90                	xchg   %ax,%ax
  800fee:	66 90                	xchg   %ax,%ax

00800ff0 <__umoddi3>:
  800ff0:	55                   	push   %ebp
  800ff1:	57                   	push   %edi
  800ff2:	56                   	push   %esi
  800ff3:	53                   	push   %ebx
  800ff4:	83 ec 1c             	sub    $0x1c,%esp
  800ff7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800ffb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  800fff:	8b 74 24 30          	mov    0x30(%esp),%esi
  801003:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801007:	89 da                	mov    %ebx,%edx
  801009:	85 c0                	test   %eax,%eax
  80100b:	75 43                	jne    801050 <__umoddi3+0x60>
  80100d:	39 df                	cmp    %ebx,%edi
  80100f:	76 17                	jbe    801028 <__umoddi3+0x38>
  801011:	89 f0                	mov    %esi,%eax
  801013:	f7 f7                	div    %edi
  801015:	89 d0                	mov    %edx,%eax
  801017:	31 d2                	xor    %edx,%edx
  801019:	83 c4 1c             	add    $0x1c,%esp
  80101c:	5b                   	pop    %ebx
  80101d:	5e                   	pop    %esi
  80101e:	5f                   	pop    %edi
  80101f:	5d                   	pop    %ebp
  801020:	c3                   	ret    
  801021:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801028:	89 fd                	mov    %edi,%ebp
  80102a:	85 ff                	test   %edi,%edi
  80102c:	75 0b                	jne    801039 <__umoddi3+0x49>
  80102e:	b8 01 00 00 00       	mov    $0x1,%eax
  801033:	31 d2                	xor    %edx,%edx
  801035:	f7 f7                	div    %edi
  801037:	89 c5                	mov    %eax,%ebp
  801039:	89 d8                	mov    %ebx,%eax
  80103b:	31 d2                	xor    %edx,%edx
  80103d:	f7 f5                	div    %ebp
  80103f:	89 f0                	mov    %esi,%eax
  801041:	f7 f5                	div    %ebp
  801043:	89 d0                	mov    %edx,%eax
  801045:	eb d0                	jmp    801017 <__umoddi3+0x27>
  801047:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80104e:	66 90                	xchg   %ax,%ax
  801050:	89 f1                	mov    %esi,%ecx
  801052:	39 d8                	cmp    %ebx,%eax
  801054:	76 0a                	jbe    801060 <__umoddi3+0x70>
  801056:	89 f0                	mov    %esi,%eax
  801058:	83 c4 1c             	add    $0x1c,%esp
  80105b:	5b                   	pop    %ebx
  80105c:	5e                   	pop    %esi
  80105d:	5f                   	pop    %edi
  80105e:	5d                   	pop    %ebp
  80105f:	c3                   	ret    
  801060:	0f bd e8             	bsr    %eax,%ebp
  801063:	83 f5 1f             	xor    $0x1f,%ebp
  801066:	75 20                	jne    801088 <__umoddi3+0x98>
  801068:	39 d8                	cmp    %ebx,%eax
  80106a:	0f 82 b0 00 00 00    	jb     801120 <__umoddi3+0x130>
  801070:	39 f7                	cmp    %esi,%edi
  801072:	0f 86 a8 00 00 00    	jbe    801120 <__umoddi3+0x130>
  801078:	89 c8                	mov    %ecx,%eax
  80107a:	83 c4 1c             	add    $0x1c,%esp
  80107d:	5b                   	pop    %ebx
  80107e:	5e                   	pop    %esi
  80107f:	5f                   	pop    %edi
  801080:	5d                   	pop    %ebp
  801081:	c3                   	ret    
  801082:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801088:	89 e9                	mov    %ebp,%ecx
  80108a:	ba 20 00 00 00       	mov    $0x20,%edx
  80108f:	29 ea                	sub    %ebp,%edx
  801091:	d3 e0                	shl    %cl,%eax
  801093:	89 44 24 08          	mov    %eax,0x8(%esp)
  801097:	89 d1                	mov    %edx,%ecx
  801099:	89 f8                	mov    %edi,%eax
  80109b:	d3 e8                	shr    %cl,%eax
  80109d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8010a1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8010a5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8010a9:	09 c1                	or     %eax,%ecx
  8010ab:	89 d8                	mov    %ebx,%eax
  8010ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8010b1:	89 e9                	mov    %ebp,%ecx
  8010b3:	d3 e7                	shl    %cl,%edi
  8010b5:	89 d1                	mov    %edx,%ecx
  8010b7:	d3 e8                	shr    %cl,%eax
  8010b9:	89 e9                	mov    %ebp,%ecx
  8010bb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8010bf:	d3 e3                	shl    %cl,%ebx
  8010c1:	89 c7                	mov    %eax,%edi
  8010c3:	89 d1                	mov    %edx,%ecx
  8010c5:	89 f0                	mov    %esi,%eax
  8010c7:	d3 e8                	shr    %cl,%eax
  8010c9:	89 e9                	mov    %ebp,%ecx
  8010cb:	89 fa                	mov    %edi,%edx
  8010cd:	d3 e6                	shl    %cl,%esi
  8010cf:	09 d8                	or     %ebx,%eax
  8010d1:	f7 74 24 08          	divl   0x8(%esp)
  8010d5:	89 d1                	mov    %edx,%ecx
  8010d7:	89 f3                	mov    %esi,%ebx
  8010d9:	f7 64 24 0c          	mull   0xc(%esp)
  8010dd:	89 c6                	mov    %eax,%esi
  8010df:	89 d7                	mov    %edx,%edi
  8010e1:	39 d1                	cmp    %edx,%ecx
  8010e3:	72 06                	jb     8010eb <__umoddi3+0xfb>
  8010e5:	75 10                	jne    8010f7 <__umoddi3+0x107>
  8010e7:	39 c3                	cmp    %eax,%ebx
  8010e9:	73 0c                	jae    8010f7 <__umoddi3+0x107>
  8010eb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8010ef:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8010f3:	89 d7                	mov    %edx,%edi
  8010f5:	89 c6                	mov    %eax,%esi
  8010f7:	89 ca                	mov    %ecx,%edx
  8010f9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8010fe:	29 f3                	sub    %esi,%ebx
  801100:	19 fa                	sbb    %edi,%edx
  801102:	89 d0                	mov    %edx,%eax
  801104:	d3 e0                	shl    %cl,%eax
  801106:	89 e9                	mov    %ebp,%ecx
  801108:	d3 eb                	shr    %cl,%ebx
  80110a:	d3 ea                	shr    %cl,%edx
  80110c:	09 d8                	or     %ebx,%eax
  80110e:	83 c4 1c             	add    $0x1c,%esp
  801111:	5b                   	pop    %ebx
  801112:	5e                   	pop    %esi
  801113:	5f                   	pop    %edi
  801114:	5d                   	pop    %ebp
  801115:	c3                   	ret    
  801116:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80111d:	8d 76 00             	lea    0x0(%esi),%esi
  801120:	89 da                	mov    %ebx,%edx
  801122:	29 fe                	sub    %edi,%esi
  801124:	19 c2                	sbb    %eax,%edx
  801126:	89 f1                	mov    %esi,%ecx
  801128:	89 c8                	mov    %ecx,%eax
  80112a:	e9 4b ff ff ff       	jmp    80107a <__umoddi3+0x8a>
