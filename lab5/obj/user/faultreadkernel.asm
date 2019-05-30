
obj/user/faultreadkernel.debug:     file format elf32-i386


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
  80002c:	e8 1d 00 00 00       	call   80004e <libmain>
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
	cprintf("I read %08x from location 0xf0100000!\n", *(unsigned*)0xf0100000);
  800039:	ff 35 00 00 10 f0    	pushl  0xf0100000
  80003f:	68 20 11 80 00       	push   $0x801120
  800044:	e8 f5 00 00 00       	call   80013e <cprintf>
}
  800049:	83 c4 10             	add    $0x10,%esp
  80004c:	c9                   	leave  
  80004d:	c3                   	ret    

0080004e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80004e:	55                   	push   %ebp
  80004f:	89 e5                	mov    %esp,%ebp
  800051:	56                   	push   %esi
  800052:	53                   	push   %ebx
  800053:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800056:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	// thisenv = 0;
	thisenv = &(envs[ENVX(sys_getenvid())]);
  800059:	e8 ba 0b 00 00       	call   800c18 <sys_getenvid>
  80005e:	25 ff 03 00 00       	and    $0x3ff,%eax
  800063:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  800069:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80006e:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800073:	85 db                	test   %ebx,%ebx
  800075:	7e 07                	jle    80007e <libmain+0x30>
		binaryname = argv[0];
  800077:	8b 06                	mov    (%esi),%eax
  800079:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  80007e:	83 ec 08             	sub    $0x8,%esp
  800081:	56                   	push   %esi
  800082:	53                   	push   %ebx
  800083:	e8 ab ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800088:	e8 0a 00 00 00       	call   800097 <exit>
}
  80008d:	83 c4 10             	add    $0x10,%esp
  800090:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800093:	5b                   	pop    %ebx
  800094:	5e                   	pop    %esi
  800095:	5d                   	pop    %ebp
  800096:	c3                   	ret    

00800097 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800097:	55                   	push   %ebp
  800098:	89 e5                	mov    %esp,%ebp
  80009a:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  80009d:	6a 00                	push   $0x0
  80009f:	e8 33 0b 00 00       	call   800bd7 <sys_env_destroy>
}
  8000a4:	83 c4 10             	add    $0x10,%esp
  8000a7:	c9                   	leave  
  8000a8:	c3                   	ret    

008000a9 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000a9:	55                   	push   %ebp
  8000aa:	89 e5                	mov    %esp,%ebp
  8000ac:	53                   	push   %ebx
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000b3:	8b 13                	mov    (%ebx),%edx
  8000b5:	8d 42 01             	lea    0x1(%edx),%eax
  8000b8:	89 03                	mov    %eax,(%ebx)
  8000ba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000bd:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000c1:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000c6:	74 09                	je     8000d1 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000c8:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8000cc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000cf:	c9                   	leave  
  8000d0:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8000d1:	83 ec 08             	sub    $0x8,%esp
  8000d4:	68 ff 00 00 00       	push   $0xff
  8000d9:	8d 43 08             	lea    0x8(%ebx),%eax
  8000dc:	50                   	push   %eax
  8000dd:	e8 b8 0a 00 00       	call   800b9a <sys_cputs>
		b->idx = 0;
  8000e2:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8000e8:	83 c4 10             	add    $0x10,%esp
  8000eb:	eb db                	jmp    8000c8 <putch+0x1f>

008000ed <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8000ed:	55                   	push   %ebp
  8000ee:	89 e5                	mov    %esp,%ebp
  8000f0:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8000f6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8000fd:	00 00 00 
	b.cnt = 0;
  800100:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800107:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80010a:	ff 75 0c             	pushl  0xc(%ebp)
  80010d:	ff 75 08             	pushl  0x8(%ebp)
  800110:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800116:	50                   	push   %eax
  800117:	68 a9 00 80 00       	push   $0x8000a9
  80011c:	e8 4a 01 00 00       	call   80026b <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800121:	83 c4 08             	add    $0x8,%esp
  800124:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80012a:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800130:	50                   	push   %eax
  800131:	e8 64 0a 00 00       	call   800b9a <sys_cputs>

	return b.cnt;
}
  800136:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80013c:	c9                   	leave  
  80013d:	c3                   	ret    

0080013e <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80013e:	55                   	push   %ebp
  80013f:	89 e5                	mov    %esp,%ebp
  800141:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800144:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800147:	50                   	push   %eax
  800148:	ff 75 08             	pushl  0x8(%ebp)
  80014b:	e8 9d ff ff ff       	call   8000ed <vcprintf>
	va_end(ap);

	return cnt;
}
  800150:	c9                   	leave  
  800151:	c3                   	ret    

00800152 <printnum>:


static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800152:	55                   	push   %ebp
  800153:	89 e5                	mov    %esp,%ebp
  800155:	57                   	push   %edi
  800156:	56                   	push   %esi
  800157:	53                   	push   %ebx
  800158:	83 ec 1c             	sub    $0x1c,%esp
  80015b:	89 c6                	mov    %eax,%esi
  80015d:	89 d7                	mov    %edx,%edi
  80015f:	8b 45 08             	mov    0x8(%ebp),%eax
  800162:	8b 55 0c             	mov    0xc(%ebp),%edx
  800165:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800168:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80016b:	8b 45 10             	mov    0x10(%ebp),%eax
  80016e:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	// to support '-'
	if(padc == '-'){
  800171:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800175:	74 2c                	je     8001a3 <printnum+0x51>
		while (--width > 0)
			putch(' ', putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800177:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80017a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800181:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800184:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800187:	39 c2                	cmp    %eax,%edx
  800189:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80018c:	73 43                	jae    8001d1 <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80018e:	83 eb 01             	sub    $0x1,%ebx
  800191:	85 db                	test   %ebx,%ebx
  800193:	7e 6c                	jle    800201 <printnum+0xaf>
			putch(padc, putdat);
  800195:	83 ec 08             	sub    $0x8,%esp
  800198:	57                   	push   %edi
  800199:	ff 75 18             	pushl  0x18(%ebp)
  80019c:	ff d6                	call   *%esi
  80019e:	83 c4 10             	add    $0x10,%esp
  8001a1:	eb eb                	jmp    80018e <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8001a3:	83 ec 0c             	sub    $0xc,%esp
  8001a6:	6a 20                	push   $0x20
  8001a8:	6a 00                	push   $0x0
  8001aa:	50                   	push   %eax
  8001ab:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001ae:	ff 75 e0             	pushl  -0x20(%ebp)
  8001b1:	89 fa                	mov    %edi,%edx
  8001b3:	89 f0                	mov    %esi,%eax
  8001b5:	e8 98 ff ff ff       	call   800152 <printnum>
		while (--width > 0)
  8001ba:	83 c4 20             	add    $0x20,%esp
  8001bd:	83 eb 01             	sub    $0x1,%ebx
  8001c0:	85 db                	test   %ebx,%ebx
  8001c2:	7e 65                	jle    800229 <printnum+0xd7>
			putch(' ', putdat);
  8001c4:	83 ec 08             	sub    $0x8,%esp
  8001c7:	57                   	push   %edi
  8001c8:	6a 20                	push   $0x20
  8001ca:	ff d6                	call   *%esi
  8001cc:	83 c4 10             	add    $0x10,%esp
  8001cf:	eb ec                	jmp    8001bd <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001d1:	83 ec 0c             	sub    $0xc,%esp
  8001d4:	ff 75 18             	pushl  0x18(%ebp)
  8001d7:	83 eb 01             	sub    $0x1,%ebx
  8001da:	53                   	push   %ebx
  8001db:	50                   	push   %eax
  8001dc:	83 ec 08             	sub    $0x8,%esp
  8001df:	ff 75 dc             	pushl  -0x24(%ebp)
  8001e2:	ff 75 d8             	pushl  -0x28(%ebp)
  8001e5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001e8:	ff 75 e0             	pushl  -0x20(%ebp)
  8001eb:	e8 e0 0c 00 00       	call   800ed0 <__udivdi3>
  8001f0:	83 c4 18             	add    $0x18,%esp
  8001f3:	52                   	push   %edx
  8001f4:	50                   	push   %eax
  8001f5:	89 fa                	mov    %edi,%edx
  8001f7:	89 f0                	mov    %esi,%eax
  8001f9:	e8 54 ff ff ff       	call   800152 <printnum>
  8001fe:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800201:	83 ec 08             	sub    $0x8,%esp
  800204:	57                   	push   %edi
  800205:	83 ec 04             	sub    $0x4,%esp
  800208:	ff 75 dc             	pushl  -0x24(%ebp)
  80020b:	ff 75 d8             	pushl  -0x28(%ebp)
  80020e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800211:	ff 75 e0             	pushl  -0x20(%ebp)
  800214:	e8 c7 0d 00 00       	call   800fe0 <__umoddi3>
  800219:	83 c4 14             	add    $0x14,%esp
  80021c:	0f be 80 51 11 80 00 	movsbl 0x801151(%eax),%eax
  800223:	50                   	push   %eax
  800224:	ff d6                	call   *%esi
  800226:	83 c4 10             	add    $0x10,%esp
}
  800229:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80022c:	5b                   	pop    %ebx
  80022d:	5e                   	pop    %esi
  80022e:	5f                   	pop    %edi
  80022f:	5d                   	pop    %ebp
  800230:	c3                   	ret    

00800231 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800231:	55                   	push   %ebp
  800232:	89 e5                	mov    %esp,%ebp
  800234:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800237:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80023b:	8b 10                	mov    (%eax),%edx
  80023d:	3b 50 04             	cmp    0x4(%eax),%edx
  800240:	73 0a                	jae    80024c <sprintputch+0x1b>
		*b->buf++ = ch;
  800242:	8d 4a 01             	lea    0x1(%edx),%ecx
  800245:	89 08                	mov    %ecx,(%eax)
  800247:	8b 45 08             	mov    0x8(%ebp),%eax
  80024a:	88 02                	mov    %al,(%edx)
}
  80024c:	5d                   	pop    %ebp
  80024d:	c3                   	ret    

0080024e <printfmt>:
{
  80024e:	55                   	push   %ebp
  80024f:	89 e5                	mov    %esp,%ebp
  800251:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800254:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800257:	50                   	push   %eax
  800258:	ff 75 10             	pushl  0x10(%ebp)
  80025b:	ff 75 0c             	pushl  0xc(%ebp)
  80025e:	ff 75 08             	pushl  0x8(%ebp)
  800261:	e8 05 00 00 00       	call   80026b <vprintfmt>
}
  800266:	83 c4 10             	add    $0x10,%esp
  800269:	c9                   	leave  
  80026a:	c3                   	ret    

0080026b <vprintfmt>:
{
  80026b:	55                   	push   %ebp
  80026c:	89 e5                	mov    %esp,%ebp
  80026e:	57                   	push   %edi
  80026f:	56                   	push   %esi
  800270:	53                   	push   %ebx
  800271:	83 ec 3c             	sub    $0x3c,%esp
  800274:	8b 75 08             	mov    0x8(%ebp),%esi
  800277:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80027a:	8b 7d 10             	mov    0x10(%ebp),%edi
  80027d:	e9 1e 04 00 00       	jmp    8006a0 <vprintfmt+0x435>
		posflag = 0;
  800282:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
		padc = ' ';
  800289:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80028d:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800294:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80029b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002a2:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  8002a9:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002ae:	8d 47 01             	lea    0x1(%edi),%eax
  8002b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002b4:	0f b6 17             	movzbl (%edi),%edx
  8002b7:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002ba:	3c 55                	cmp    $0x55,%al
  8002bc:	0f 87 d9 04 00 00    	ja     80079b <vprintfmt+0x530>
  8002c2:	0f b6 c0             	movzbl %al,%eax
  8002c5:	ff 24 85 40 13 80 00 	jmp    *0x801340(,%eax,4)
  8002cc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002cf:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8002d3:	eb d9                	jmp    8002ae <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8002d5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posflag = 1;
  8002d8:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  8002df:	eb cd                	jmp    8002ae <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8002e1:	0f b6 d2             	movzbl %dl,%edx
  8002e4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8002e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8002ec:	89 75 08             	mov    %esi,0x8(%ebp)
  8002ef:	eb 0c                	jmp    8002fd <vprintfmt+0x92>
		switch (ch = *(unsigned char *) fmt++) {
  8002f1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8002f4:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  8002f8:	eb b4                	jmp    8002ae <vprintfmt+0x43>
			for (precision = 0; ; ++fmt) {
  8002fa:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8002fd:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800300:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800304:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800307:	8d 72 d0             	lea    -0x30(%edx),%esi
  80030a:	83 fe 09             	cmp    $0x9,%esi
  80030d:	76 eb                	jbe    8002fa <vprintfmt+0x8f>
  80030f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800312:	8b 75 08             	mov    0x8(%ebp),%esi
  800315:	eb 14                	jmp    80032b <vprintfmt+0xc0>
			precision = va_arg(ap, int);
  800317:	8b 45 14             	mov    0x14(%ebp),%eax
  80031a:	8b 00                	mov    (%eax),%eax
  80031c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80031f:	8b 45 14             	mov    0x14(%ebp),%eax
  800322:	8d 40 04             	lea    0x4(%eax),%eax
  800325:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800328:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80032b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80032f:	0f 89 79 ff ff ff    	jns    8002ae <vprintfmt+0x43>
				width = precision, precision = -1;
  800335:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800338:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80033b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800342:	e9 67 ff ff ff       	jmp    8002ae <vprintfmt+0x43>
  800347:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80034a:	85 c0                	test   %eax,%eax
  80034c:	0f 48 c1             	cmovs  %ecx,%eax
  80034f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800352:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800355:	e9 54 ff ff ff       	jmp    8002ae <vprintfmt+0x43>
  80035a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80035d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800364:	e9 45 ff ff ff       	jmp    8002ae <vprintfmt+0x43>
			lflag++;
  800369:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80036d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800370:	e9 39 ff ff ff       	jmp    8002ae <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800375:	8b 45 14             	mov    0x14(%ebp),%eax
  800378:	8d 78 04             	lea    0x4(%eax),%edi
  80037b:	83 ec 08             	sub    $0x8,%esp
  80037e:	53                   	push   %ebx
  80037f:	ff 30                	pushl  (%eax)
  800381:	ff d6                	call   *%esi
			break;
  800383:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800386:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800389:	e9 0f 03 00 00       	jmp    80069d <vprintfmt+0x432>
			err = va_arg(ap, int);
  80038e:	8b 45 14             	mov    0x14(%ebp),%eax
  800391:	8d 78 04             	lea    0x4(%eax),%edi
  800394:	8b 00                	mov    (%eax),%eax
  800396:	99                   	cltd   
  800397:	31 d0                	xor    %edx,%eax
  800399:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80039b:	83 f8 0f             	cmp    $0xf,%eax
  80039e:	7f 23                	jg     8003c3 <vprintfmt+0x158>
  8003a0:	8b 14 85 a0 14 80 00 	mov    0x8014a0(,%eax,4),%edx
  8003a7:	85 d2                	test   %edx,%edx
  8003a9:	74 18                	je     8003c3 <vprintfmt+0x158>
				printfmt(putch, putdat, "%s", p);
  8003ab:	52                   	push   %edx
  8003ac:	68 72 11 80 00       	push   $0x801172
  8003b1:	53                   	push   %ebx
  8003b2:	56                   	push   %esi
  8003b3:	e8 96 fe ff ff       	call   80024e <printfmt>
  8003b8:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003bb:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003be:	e9 da 02 00 00       	jmp    80069d <vprintfmt+0x432>
				printfmt(putch, putdat, "error %d", err);
  8003c3:	50                   	push   %eax
  8003c4:	68 69 11 80 00       	push   $0x801169
  8003c9:	53                   	push   %ebx
  8003ca:	56                   	push   %esi
  8003cb:	e8 7e fe ff ff       	call   80024e <printfmt>
  8003d0:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003d3:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003d6:	e9 c2 02 00 00       	jmp    80069d <vprintfmt+0x432>
			if ((p = va_arg(ap, char *)) == NULL)
  8003db:	8b 45 14             	mov    0x14(%ebp),%eax
  8003de:	83 c0 04             	add    $0x4,%eax
  8003e1:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8003e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e7:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8003e9:	85 c9                	test   %ecx,%ecx
  8003eb:	b8 62 11 80 00       	mov    $0x801162,%eax
  8003f0:	0f 45 c1             	cmovne %ecx,%eax
  8003f3:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8003f6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003fa:	7e 06                	jle    800402 <vprintfmt+0x197>
  8003fc:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800400:	75 0d                	jne    80040f <vprintfmt+0x1a4>
				for (width -= strnlen(p, precision); width > 0; width--)
  800402:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800405:	89 c7                	mov    %eax,%edi
  800407:	03 45 e0             	add    -0x20(%ebp),%eax
  80040a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80040d:	eb 53                	jmp    800462 <vprintfmt+0x1f7>
  80040f:	83 ec 08             	sub    $0x8,%esp
  800412:	ff 75 d8             	pushl  -0x28(%ebp)
  800415:	50                   	push   %eax
  800416:	e8 28 04 00 00       	call   800843 <strnlen>
  80041b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80041e:	29 c1                	sub    %eax,%ecx
  800420:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  800423:	83 c4 10             	add    $0x10,%esp
  800426:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800428:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80042c:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80042f:	eb 0f                	jmp    800440 <vprintfmt+0x1d5>
					putch(padc, putdat);
  800431:	83 ec 08             	sub    $0x8,%esp
  800434:	53                   	push   %ebx
  800435:	ff 75 e0             	pushl  -0x20(%ebp)
  800438:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80043a:	83 ef 01             	sub    $0x1,%edi
  80043d:	83 c4 10             	add    $0x10,%esp
  800440:	85 ff                	test   %edi,%edi
  800442:	7f ed                	jg     800431 <vprintfmt+0x1c6>
  800444:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  800447:	85 c9                	test   %ecx,%ecx
  800449:	b8 00 00 00 00       	mov    $0x0,%eax
  80044e:	0f 49 c1             	cmovns %ecx,%eax
  800451:	29 c1                	sub    %eax,%ecx
  800453:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800456:	eb aa                	jmp    800402 <vprintfmt+0x197>
					putch(ch, putdat);
  800458:	83 ec 08             	sub    $0x8,%esp
  80045b:	53                   	push   %ebx
  80045c:	52                   	push   %edx
  80045d:	ff d6                	call   *%esi
  80045f:	83 c4 10             	add    $0x10,%esp
  800462:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800465:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800467:	83 c7 01             	add    $0x1,%edi
  80046a:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80046e:	0f be d0             	movsbl %al,%edx
  800471:	85 d2                	test   %edx,%edx
  800473:	74 4b                	je     8004c0 <vprintfmt+0x255>
  800475:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800479:	78 06                	js     800481 <vprintfmt+0x216>
  80047b:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80047f:	78 1e                	js     80049f <vprintfmt+0x234>
				if (altflag && (ch < ' ' || ch > '~'))
  800481:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800485:	74 d1                	je     800458 <vprintfmt+0x1ed>
  800487:	0f be c0             	movsbl %al,%eax
  80048a:	83 e8 20             	sub    $0x20,%eax
  80048d:	83 f8 5e             	cmp    $0x5e,%eax
  800490:	76 c6                	jbe    800458 <vprintfmt+0x1ed>
					putch('?', putdat);
  800492:	83 ec 08             	sub    $0x8,%esp
  800495:	53                   	push   %ebx
  800496:	6a 3f                	push   $0x3f
  800498:	ff d6                	call   *%esi
  80049a:	83 c4 10             	add    $0x10,%esp
  80049d:	eb c3                	jmp    800462 <vprintfmt+0x1f7>
  80049f:	89 cf                	mov    %ecx,%edi
  8004a1:	eb 0e                	jmp    8004b1 <vprintfmt+0x246>
				putch(' ', putdat);
  8004a3:	83 ec 08             	sub    $0x8,%esp
  8004a6:	53                   	push   %ebx
  8004a7:	6a 20                	push   $0x20
  8004a9:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004ab:	83 ef 01             	sub    $0x1,%edi
  8004ae:	83 c4 10             	add    $0x10,%esp
  8004b1:	85 ff                	test   %edi,%edi
  8004b3:	7f ee                	jg     8004a3 <vprintfmt+0x238>
			if ((p = va_arg(ap, char *)) == NULL)
  8004b5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004b8:	89 45 14             	mov    %eax,0x14(%ebp)
  8004bb:	e9 dd 01 00 00       	jmp    80069d <vprintfmt+0x432>
  8004c0:	89 cf                	mov    %ecx,%edi
  8004c2:	eb ed                	jmp    8004b1 <vprintfmt+0x246>
	if (lflag >= 2)
  8004c4:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8004c8:	7f 21                	jg     8004eb <vprintfmt+0x280>
	else if (lflag)
  8004ca:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8004ce:	74 6a                	je     80053a <vprintfmt+0x2cf>
		return va_arg(*ap, long);
  8004d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d3:	8b 00                	mov    (%eax),%eax
  8004d5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004d8:	89 c1                	mov    %eax,%ecx
  8004da:	c1 f9 1f             	sar    $0x1f,%ecx
  8004dd:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8004e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e3:	8d 40 04             	lea    0x4(%eax),%eax
  8004e6:	89 45 14             	mov    %eax,0x14(%ebp)
  8004e9:	eb 17                	jmp    800502 <vprintfmt+0x297>
		return va_arg(*ap, long long);
  8004eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ee:	8b 50 04             	mov    0x4(%eax),%edx
  8004f1:	8b 00                	mov    (%eax),%eax
  8004f3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004f6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fc:	8d 40 08             	lea    0x8(%eax),%eax
  8004ff:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800502:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  800505:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  80050a:	85 d2                	test   %edx,%edx
  80050c:	0f 89 5c 01 00 00    	jns    80066e <vprintfmt+0x403>
				putch('-', putdat);
  800512:	83 ec 08             	sub    $0x8,%esp
  800515:	53                   	push   %ebx
  800516:	6a 2d                	push   $0x2d
  800518:	ff d6                	call   *%esi
				num = -(long long) num;
  80051a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80051d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800520:	f7 d8                	neg    %eax
  800522:	83 d2 00             	adc    $0x0,%edx
  800525:	f7 da                	neg    %edx
  800527:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80052a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80052d:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800530:	bf 0a 00 00 00       	mov    $0xa,%edi
  800535:	e9 45 01 00 00       	jmp    80067f <vprintfmt+0x414>
		return va_arg(*ap, int);
  80053a:	8b 45 14             	mov    0x14(%ebp),%eax
  80053d:	8b 00                	mov    (%eax),%eax
  80053f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800542:	89 c1                	mov    %eax,%ecx
  800544:	c1 f9 1f             	sar    $0x1f,%ecx
  800547:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80054a:	8b 45 14             	mov    0x14(%ebp),%eax
  80054d:	8d 40 04             	lea    0x4(%eax),%eax
  800550:	89 45 14             	mov    %eax,0x14(%ebp)
  800553:	eb ad                	jmp    800502 <vprintfmt+0x297>
	if (lflag >= 2)
  800555:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800559:	7f 29                	jg     800584 <vprintfmt+0x319>
	else if (lflag)
  80055b:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80055f:	74 44                	je     8005a5 <vprintfmt+0x33a>
		return va_arg(*ap, unsigned long);
  800561:	8b 45 14             	mov    0x14(%ebp),%eax
  800564:	8b 00                	mov    (%eax),%eax
  800566:	ba 00 00 00 00       	mov    $0x0,%edx
  80056b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80056e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800571:	8b 45 14             	mov    0x14(%ebp),%eax
  800574:	8d 40 04             	lea    0x4(%eax),%eax
  800577:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80057a:	bf 0a 00 00 00       	mov    $0xa,%edi
  80057f:	e9 ea 00 00 00       	jmp    80066e <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  800584:	8b 45 14             	mov    0x14(%ebp),%eax
  800587:	8b 50 04             	mov    0x4(%eax),%edx
  80058a:	8b 00                	mov    (%eax),%eax
  80058c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80058f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800592:	8b 45 14             	mov    0x14(%ebp),%eax
  800595:	8d 40 08             	lea    0x8(%eax),%eax
  800598:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80059b:	bf 0a 00 00 00       	mov    $0xa,%edi
  8005a0:	e9 c9 00 00 00       	jmp    80066e <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  8005a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a8:	8b 00                	mov    (%eax),%eax
  8005aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8005af:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005b2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b8:	8d 40 04             	lea    0x4(%eax),%eax
  8005bb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005be:	bf 0a 00 00 00       	mov    $0xa,%edi
  8005c3:	e9 a6 00 00 00       	jmp    80066e <vprintfmt+0x403>
			putch('0', putdat);
  8005c8:	83 ec 08             	sub    $0x8,%esp
  8005cb:	53                   	push   %ebx
  8005cc:	6a 30                	push   $0x30
  8005ce:	ff d6                	call   *%esi
	if (lflag >= 2)
  8005d0:	83 c4 10             	add    $0x10,%esp
  8005d3:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8005d7:	7f 26                	jg     8005ff <vprintfmt+0x394>
	else if (lflag)
  8005d9:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8005dd:	74 3e                	je     80061d <vprintfmt+0x3b2>
		return va_arg(*ap, unsigned long);
  8005df:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e2:	8b 00                	mov    (%eax),%eax
  8005e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8005e9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ec:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f2:	8d 40 04             	lea    0x4(%eax),%eax
  8005f5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005f8:	bf 08 00 00 00       	mov    $0x8,%edi
  8005fd:	eb 6f                	jmp    80066e <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  8005ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800602:	8b 50 04             	mov    0x4(%eax),%edx
  800605:	8b 00                	mov    (%eax),%eax
  800607:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80060a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80060d:	8b 45 14             	mov    0x14(%ebp),%eax
  800610:	8d 40 08             	lea    0x8(%eax),%eax
  800613:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800616:	bf 08 00 00 00       	mov    $0x8,%edi
  80061b:	eb 51                	jmp    80066e <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  80061d:	8b 45 14             	mov    0x14(%ebp),%eax
  800620:	8b 00                	mov    (%eax),%eax
  800622:	ba 00 00 00 00       	mov    $0x0,%edx
  800627:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80062a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80062d:	8b 45 14             	mov    0x14(%ebp),%eax
  800630:	8d 40 04             	lea    0x4(%eax),%eax
  800633:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800636:	bf 08 00 00 00       	mov    $0x8,%edi
  80063b:	eb 31                	jmp    80066e <vprintfmt+0x403>
			putch('0', putdat);
  80063d:	83 ec 08             	sub    $0x8,%esp
  800640:	53                   	push   %ebx
  800641:	6a 30                	push   $0x30
  800643:	ff d6                	call   *%esi
			putch('x', putdat);
  800645:	83 c4 08             	add    $0x8,%esp
  800648:	53                   	push   %ebx
  800649:	6a 78                	push   $0x78
  80064b:	ff d6                	call   *%esi
			num = (unsigned long long)
  80064d:	8b 45 14             	mov    0x14(%ebp),%eax
  800650:	8b 00                	mov    (%eax),%eax
  800652:	ba 00 00 00 00       	mov    $0x0,%edx
  800657:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80065a:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80065d:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800660:	8b 45 14             	mov    0x14(%ebp),%eax
  800663:	8d 40 04             	lea    0x4(%eax),%eax
  800666:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800669:	bf 10 00 00 00       	mov    $0x10,%edi
			if(posflag)
  80066e:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800672:	74 0b                	je     80067f <vprintfmt+0x414>
				putch('+', putdat);
  800674:	83 ec 08             	sub    $0x8,%esp
  800677:	53                   	push   %ebx
  800678:	6a 2b                	push   $0x2b
  80067a:	ff d6                	call   *%esi
  80067c:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  80067f:	83 ec 0c             	sub    $0xc,%esp
  800682:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800686:	50                   	push   %eax
  800687:	ff 75 e0             	pushl  -0x20(%ebp)
  80068a:	57                   	push   %edi
  80068b:	ff 75 dc             	pushl  -0x24(%ebp)
  80068e:	ff 75 d8             	pushl  -0x28(%ebp)
  800691:	89 da                	mov    %ebx,%edx
  800693:	89 f0                	mov    %esi,%eax
  800695:	e8 b8 fa ff ff       	call   800152 <printnum>
			break;
  80069a:	83 c4 20             	add    $0x20,%esp
			char* cp = va_arg(ap, char *);
  80069d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006a0:	83 c7 01             	add    $0x1,%edi
  8006a3:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006a7:	83 f8 25             	cmp    $0x25,%eax
  8006aa:	0f 84 d2 fb ff ff    	je     800282 <vprintfmt+0x17>
			if (ch == '\0')
  8006b0:	85 c0                	test   %eax,%eax
  8006b2:	0f 84 03 01 00 00    	je     8007bb <vprintfmt+0x550>
			putch(ch, putdat);
  8006b8:	83 ec 08             	sub    $0x8,%esp
  8006bb:	53                   	push   %ebx
  8006bc:	50                   	push   %eax
  8006bd:	ff d6                	call   *%esi
  8006bf:	83 c4 10             	add    $0x10,%esp
  8006c2:	eb dc                	jmp    8006a0 <vprintfmt+0x435>
	if (lflag >= 2)
  8006c4:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8006c8:	7f 29                	jg     8006f3 <vprintfmt+0x488>
	else if (lflag)
  8006ca:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8006ce:	74 44                	je     800714 <vprintfmt+0x4a9>
		return va_arg(*ap, unsigned long);
  8006d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d3:	8b 00                	mov    (%eax),%eax
  8006d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8006da:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006dd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e3:	8d 40 04             	lea    0x4(%eax),%eax
  8006e6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006e9:	bf 10 00 00 00       	mov    $0x10,%edi
  8006ee:	e9 7b ff ff ff       	jmp    80066e <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  8006f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f6:	8b 50 04             	mov    0x4(%eax),%edx
  8006f9:	8b 00                	mov    (%eax),%eax
  8006fb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006fe:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800701:	8b 45 14             	mov    0x14(%ebp),%eax
  800704:	8d 40 08             	lea    0x8(%eax),%eax
  800707:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80070a:	bf 10 00 00 00       	mov    $0x10,%edi
  80070f:	e9 5a ff ff ff       	jmp    80066e <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  800714:	8b 45 14             	mov    0x14(%ebp),%eax
  800717:	8b 00                	mov    (%eax),%eax
  800719:	ba 00 00 00 00       	mov    $0x0,%edx
  80071e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800721:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800724:	8b 45 14             	mov    0x14(%ebp),%eax
  800727:	8d 40 04             	lea    0x4(%eax),%eax
  80072a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80072d:	bf 10 00 00 00       	mov    $0x10,%edi
  800732:	e9 37 ff ff ff       	jmp    80066e <vprintfmt+0x403>
			char* cp = va_arg(ap, char *);
  800737:	8b 45 14             	mov    0x14(%ebp),%eax
  80073a:	8d 78 04             	lea    0x4(%eax),%edi
  80073d:	8b 00                	mov    (%eax),%eax
    			if (cp == NULL) {
  80073f:	85 c0                	test   %eax,%eax
  800741:	74 2c                	je     80076f <vprintfmt+0x504>
    			*cp = *(int *)putdat;
  800743:	8b 13                	mov    (%ebx),%edx
  800745:	88 10                	mov    %dl,(%eax)
			char* cp = va_arg(ap, char *);
  800747:	89 7d 14             	mov    %edi,0x14(%ebp)
    			if ((*(int *) putdat) > 127)
  80074a:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  80074d:	0f 8e 4a ff ff ff    	jle    80069d <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", overflow_error);
  800753:	68 c0 12 80 00       	push   $0x8012c0
  800758:	68 72 11 80 00       	push   $0x801172
  80075d:	53                   	push   %ebx
  80075e:	56                   	push   %esi
  80075f:	e8 ea fa ff ff       	call   80024e <printfmt>
  800764:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  800767:	89 7d 14             	mov    %edi,0x14(%ebp)
  80076a:	e9 2e ff ff ff       	jmp    80069d <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", null_error);
  80076f:	68 88 12 80 00       	push   $0x801288
  800774:	68 72 11 80 00       	push   $0x801172
  800779:	53                   	push   %ebx
  80077a:	56                   	push   %esi
  80077b:	e8 ce fa ff ff       	call   80024e <printfmt>
        		break;
  800780:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  800783:	89 7d 14             	mov    %edi,0x14(%ebp)
        		break;
  800786:	e9 12 ff ff ff       	jmp    80069d <vprintfmt+0x432>
			putch(ch, putdat);
  80078b:	83 ec 08             	sub    $0x8,%esp
  80078e:	53                   	push   %ebx
  80078f:	6a 25                	push   $0x25
  800791:	ff d6                	call   *%esi
			break;
  800793:	83 c4 10             	add    $0x10,%esp
  800796:	e9 02 ff ff ff       	jmp    80069d <vprintfmt+0x432>
			putch('%', putdat);
  80079b:	83 ec 08             	sub    $0x8,%esp
  80079e:	53                   	push   %ebx
  80079f:	6a 25                	push   $0x25
  8007a1:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007a3:	83 c4 10             	add    $0x10,%esp
  8007a6:	89 f8                	mov    %edi,%eax
  8007a8:	eb 03                	jmp    8007ad <vprintfmt+0x542>
  8007aa:	83 e8 01             	sub    $0x1,%eax
  8007ad:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8007b1:	75 f7                	jne    8007aa <vprintfmt+0x53f>
  8007b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007b6:	e9 e2 fe ff ff       	jmp    80069d <vprintfmt+0x432>
}
  8007bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007be:	5b                   	pop    %ebx
  8007bf:	5e                   	pop    %esi
  8007c0:	5f                   	pop    %edi
  8007c1:	5d                   	pop    %ebp
  8007c2:	c3                   	ret    

008007c3 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007c3:	55                   	push   %ebp
  8007c4:	89 e5                	mov    %esp,%ebp
  8007c6:	83 ec 18             	sub    $0x18,%esp
  8007c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cc:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007d2:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007d6:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007e0:	85 c0                	test   %eax,%eax
  8007e2:	74 26                	je     80080a <vsnprintf+0x47>
  8007e4:	85 d2                	test   %edx,%edx
  8007e6:	7e 22                	jle    80080a <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007e8:	ff 75 14             	pushl  0x14(%ebp)
  8007eb:	ff 75 10             	pushl  0x10(%ebp)
  8007ee:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007f1:	50                   	push   %eax
  8007f2:	68 31 02 80 00       	push   $0x800231
  8007f7:	e8 6f fa ff ff       	call   80026b <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007ff:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800802:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800805:	83 c4 10             	add    $0x10,%esp
}
  800808:	c9                   	leave  
  800809:	c3                   	ret    
		return -E_INVAL;
  80080a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80080f:	eb f7                	jmp    800808 <vsnprintf+0x45>

00800811 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800811:	55                   	push   %ebp
  800812:	89 e5                	mov    %esp,%ebp
  800814:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800817:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80081a:	50                   	push   %eax
  80081b:	ff 75 10             	pushl  0x10(%ebp)
  80081e:	ff 75 0c             	pushl  0xc(%ebp)
  800821:	ff 75 08             	pushl  0x8(%ebp)
  800824:	e8 9a ff ff ff       	call   8007c3 <vsnprintf>
	va_end(ap);

	return rc;
}
  800829:	c9                   	leave  
  80082a:	c3                   	ret    

0080082b <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80082b:	55                   	push   %ebp
  80082c:	89 e5                	mov    %esp,%ebp
  80082e:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800831:	b8 00 00 00 00       	mov    $0x0,%eax
  800836:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80083a:	74 05                	je     800841 <strlen+0x16>
		n++;
  80083c:	83 c0 01             	add    $0x1,%eax
  80083f:	eb f5                	jmp    800836 <strlen+0xb>
	return n;
}
  800841:	5d                   	pop    %ebp
  800842:	c3                   	ret    

00800843 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800843:	55                   	push   %ebp
  800844:	89 e5                	mov    %esp,%ebp
  800846:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800849:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80084c:	ba 00 00 00 00       	mov    $0x0,%edx
  800851:	39 c2                	cmp    %eax,%edx
  800853:	74 0d                	je     800862 <strnlen+0x1f>
  800855:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800859:	74 05                	je     800860 <strnlen+0x1d>
		n++;
  80085b:	83 c2 01             	add    $0x1,%edx
  80085e:	eb f1                	jmp    800851 <strnlen+0xe>
  800860:	89 d0                	mov    %edx,%eax
	return n;
}
  800862:	5d                   	pop    %ebp
  800863:	c3                   	ret    

00800864 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800864:	55                   	push   %ebp
  800865:	89 e5                	mov    %esp,%ebp
  800867:	53                   	push   %ebx
  800868:	8b 45 08             	mov    0x8(%ebp),%eax
  80086b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80086e:	ba 00 00 00 00       	mov    $0x0,%edx
  800873:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800877:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  80087a:	83 c2 01             	add    $0x1,%edx
  80087d:	84 c9                	test   %cl,%cl
  80087f:	75 f2                	jne    800873 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800881:	5b                   	pop    %ebx
  800882:	5d                   	pop    %ebp
  800883:	c3                   	ret    

00800884 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800884:	55                   	push   %ebp
  800885:	89 e5                	mov    %esp,%ebp
  800887:	53                   	push   %ebx
  800888:	83 ec 10             	sub    $0x10,%esp
  80088b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80088e:	53                   	push   %ebx
  80088f:	e8 97 ff ff ff       	call   80082b <strlen>
  800894:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800897:	ff 75 0c             	pushl  0xc(%ebp)
  80089a:	01 d8                	add    %ebx,%eax
  80089c:	50                   	push   %eax
  80089d:	e8 c2 ff ff ff       	call   800864 <strcpy>
	return dst;
}
  8008a2:	89 d8                	mov    %ebx,%eax
  8008a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008a7:	c9                   	leave  
  8008a8:	c3                   	ret    

008008a9 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008a9:	55                   	push   %ebp
  8008aa:	89 e5                	mov    %esp,%ebp
  8008ac:	56                   	push   %esi
  8008ad:	53                   	push   %ebx
  8008ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008b4:	89 c6                	mov    %eax,%esi
  8008b6:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008b9:	89 c2                	mov    %eax,%edx
  8008bb:	39 f2                	cmp    %esi,%edx
  8008bd:	74 11                	je     8008d0 <strncpy+0x27>
		*dst++ = *src;
  8008bf:	83 c2 01             	add    $0x1,%edx
  8008c2:	0f b6 19             	movzbl (%ecx),%ebx
  8008c5:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008c8:	80 fb 01             	cmp    $0x1,%bl
  8008cb:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8008ce:	eb eb                	jmp    8008bb <strncpy+0x12>
	}
	return ret;
}
  8008d0:	5b                   	pop    %ebx
  8008d1:	5e                   	pop    %esi
  8008d2:	5d                   	pop    %ebp
  8008d3:	c3                   	ret    

008008d4 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008d4:	55                   	push   %ebp
  8008d5:	89 e5                	mov    %esp,%ebp
  8008d7:	56                   	push   %esi
  8008d8:	53                   	push   %ebx
  8008d9:	8b 75 08             	mov    0x8(%ebp),%esi
  8008dc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008df:	8b 55 10             	mov    0x10(%ebp),%edx
  8008e2:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008e4:	85 d2                	test   %edx,%edx
  8008e6:	74 21                	je     800909 <strlcpy+0x35>
  8008e8:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8008ec:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8008ee:	39 c2                	cmp    %eax,%edx
  8008f0:	74 14                	je     800906 <strlcpy+0x32>
  8008f2:	0f b6 19             	movzbl (%ecx),%ebx
  8008f5:	84 db                	test   %bl,%bl
  8008f7:	74 0b                	je     800904 <strlcpy+0x30>
			*dst++ = *src++;
  8008f9:	83 c1 01             	add    $0x1,%ecx
  8008fc:	83 c2 01             	add    $0x1,%edx
  8008ff:	88 5a ff             	mov    %bl,-0x1(%edx)
  800902:	eb ea                	jmp    8008ee <strlcpy+0x1a>
  800904:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800906:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800909:	29 f0                	sub    %esi,%eax
}
  80090b:	5b                   	pop    %ebx
  80090c:	5e                   	pop    %esi
  80090d:	5d                   	pop    %ebp
  80090e:	c3                   	ret    

0080090f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80090f:	55                   	push   %ebp
  800910:	89 e5                	mov    %esp,%ebp
  800912:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800915:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800918:	0f b6 01             	movzbl (%ecx),%eax
  80091b:	84 c0                	test   %al,%al
  80091d:	74 0c                	je     80092b <strcmp+0x1c>
  80091f:	3a 02                	cmp    (%edx),%al
  800921:	75 08                	jne    80092b <strcmp+0x1c>
		p++, q++;
  800923:	83 c1 01             	add    $0x1,%ecx
  800926:	83 c2 01             	add    $0x1,%edx
  800929:	eb ed                	jmp    800918 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80092b:	0f b6 c0             	movzbl %al,%eax
  80092e:	0f b6 12             	movzbl (%edx),%edx
  800931:	29 d0                	sub    %edx,%eax
}
  800933:	5d                   	pop    %ebp
  800934:	c3                   	ret    

00800935 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800935:	55                   	push   %ebp
  800936:	89 e5                	mov    %esp,%ebp
  800938:	53                   	push   %ebx
  800939:	8b 45 08             	mov    0x8(%ebp),%eax
  80093c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80093f:	89 c3                	mov    %eax,%ebx
  800941:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800944:	eb 06                	jmp    80094c <strncmp+0x17>
		n--, p++, q++;
  800946:	83 c0 01             	add    $0x1,%eax
  800949:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80094c:	39 d8                	cmp    %ebx,%eax
  80094e:	74 16                	je     800966 <strncmp+0x31>
  800950:	0f b6 08             	movzbl (%eax),%ecx
  800953:	84 c9                	test   %cl,%cl
  800955:	74 04                	je     80095b <strncmp+0x26>
  800957:	3a 0a                	cmp    (%edx),%cl
  800959:	74 eb                	je     800946 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80095b:	0f b6 00             	movzbl (%eax),%eax
  80095e:	0f b6 12             	movzbl (%edx),%edx
  800961:	29 d0                	sub    %edx,%eax
}
  800963:	5b                   	pop    %ebx
  800964:	5d                   	pop    %ebp
  800965:	c3                   	ret    
		return 0;
  800966:	b8 00 00 00 00       	mov    $0x0,%eax
  80096b:	eb f6                	jmp    800963 <strncmp+0x2e>

0080096d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80096d:	55                   	push   %ebp
  80096e:	89 e5                	mov    %esp,%ebp
  800970:	8b 45 08             	mov    0x8(%ebp),%eax
  800973:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800977:	0f b6 10             	movzbl (%eax),%edx
  80097a:	84 d2                	test   %dl,%dl
  80097c:	74 09                	je     800987 <strchr+0x1a>
		if (*s == c)
  80097e:	38 ca                	cmp    %cl,%dl
  800980:	74 0a                	je     80098c <strchr+0x1f>
	for (; *s; s++)
  800982:	83 c0 01             	add    $0x1,%eax
  800985:	eb f0                	jmp    800977 <strchr+0xa>
			return (char *) s;
	return 0;
  800987:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80098c:	5d                   	pop    %ebp
  80098d:	c3                   	ret    

0080098e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80098e:	55                   	push   %ebp
  80098f:	89 e5                	mov    %esp,%ebp
  800991:	8b 45 08             	mov    0x8(%ebp),%eax
  800994:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800998:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80099b:	38 ca                	cmp    %cl,%dl
  80099d:	74 09                	je     8009a8 <strfind+0x1a>
  80099f:	84 d2                	test   %dl,%dl
  8009a1:	74 05                	je     8009a8 <strfind+0x1a>
	for (; *s; s++)
  8009a3:	83 c0 01             	add    $0x1,%eax
  8009a6:	eb f0                	jmp    800998 <strfind+0xa>
			break;
	return (char *) s;
}
  8009a8:	5d                   	pop    %ebp
  8009a9:	c3                   	ret    

008009aa <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009aa:	55                   	push   %ebp
  8009ab:	89 e5                	mov    %esp,%ebp
  8009ad:	57                   	push   %edi
  8009ae:	56                   	push   %esi
  8009af:	53                   	push   %ebx
  8009b0:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009b3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009b6:	85 c9                	test   %ecx,%ecx
  8009b8:	74 31                	je     8009eb <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009ba:	89 f8                	mov    %edi,%eax
  8009bc:	09 c8                	or     %ecx,%eax
  8009be:	a8 03                	test   $0x3,%al
  8009c0:	75 23                	jne    8009e5 <memset+0x3b>
		c &= 0xFF;
  8009c2:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009c6:	89 d3                	mov    %edx,%ebx
  8009c8:	c1 e3 08             	shl    $0x8,%ebx
  8009cb:	89 d0                	mov    %edx,%eax
  8009cd:	c1 e0 18             	shl    $0x18,%eax
  8009d0:	89 d6                	mov    %edx,%esi
  8009d2:	c1 e6 10             	shl    $0x10,%esi
  8009d5:	09 f0                	or     %esi,%eax
  8009d7:	09 c2                	or     %eax,%edx
  8009d9:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8009db:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009de:	89 d0                	mov    %edx,%eax
  8009e0:	fc                   	cld    
  8009e1:	f3 ab                	rep stos %eax,%es:(%edi)
  8009e3:	eb 06                	jmp    8009eb <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009e8:	fc                   	cld    
  8009e9:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009eb:	89 f8                	mov    %edi,%eax
  8009ed:	5b                   	pop    %ebx
  8009ee:	5e                   	pop    %esi
  8009ef:	5f                   	pop    %edi
  8009f0:	5d                   	pop    %ebp
  8009f1:	c3                   	ret    

008009f2 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009f2:	55                   	push   %ebp
  8009f3:	89 e5                	mov    %esp,%ebp
  8009f5:	57                   	push   %edi
  8009f6:	56                   	push   %esi
  8009f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fa:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009fd:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a00:	39 c6                	cmp    %eax,%esi
  800a02:	73 32                	jae    800a36 <memmove+0x44>
  800a04:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a07:	39 c2                	cmp    %eax,%edx
  800a09:	76 2b                	jbe    800a36 <memmove+0x44>
		s += n;
		d += n;
  800a0b:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a0e:	89 fe                	mov    %edi,%esi
  800a10:	09 ce                	or     %ecx,%esi
  800a12:	09 d6                	or     %edx,%esi
  800a14:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a1a:	75 0e                	jne    800a2a <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a1c:	83 ef 04             	sub    $0x4,%edi
  800a1f:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a22:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a25:	fd                   	std    
  800a26:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a28:	eb 09                	jmp    800a33 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a2a:	83 ef 01             	sub    $0x1,%edi
  800a2d:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a30:	fd                   	std    
  800a31:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a33:	fc                   	cld    
  800a34:	eb 1a                	jmp    800a50 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a36:	89 c2                	mov    %eax,%edx
  800a38:	09 ca                	or     %ecx,%edx
  800a3a:	09 f2                	or     %esi,%edx
  800a3c:	f6 c2 03             	test   $0x3,%dl
  800a3f:	75 0a                	jne    800a4b <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a41:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a44:	89 c7                	mov    %eax,%edi
  800a46:	fc                   	cld    
  800a47:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a49:	eb 05                	jmp    800a50 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800a4b:	89 c7                	mov    %eax,%edi
  800a4d:	fc                   	cld    
  800a4e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a50:	5e                   	pop    %esi
  800a51:	5f                   	pop    %edi
  800a52:	5d                   	pop    %ebp
  800a53:	c3                   	ret    

00800a54 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a54:	55                   	push   %ebp
  800a55:	89 e5                	mov    %esp,%ebp
  800a57:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a5a:	ff 75 10             	pushl  0x10(%ebp)
  800a5d:	ff 75 0c             	pushl  0xc(%ebp)
  800a60:	ff 75 08             	pushl  0x8(%ebp)
  800a63:	e8 8a ff ff ff       	call   8009f2 <memmove>
}
  800a68:	c9                   	leave  
  800a69:	c3                   	ret    

00800a6a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a6a:	55                   	push   %ebp
  800a6b:	89 e5                	mov    %esp,%ebp
  800a6d:	56                   	push   %esi
  800a6e:	53                   	push   %ebx
  800a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a72:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a75:	89 c6                	mov    %eax,%esi
  800a77:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a7a:	39 f0                	cmp    %esi,%eax
  800a7c:	74 1c                	je     800a9a <memcmp+0x30>
		if (*s1 != *s2)
  800a7e:	0f b6 08             	movzbl (%eax),%ecx
  800a81:	0f b6 1a             	movzbl (%edx),%ebx
  800a84:	38 d9                	cmp    %bl,%cl
  800a86:	75 08                	jne    800a90 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a88:	83 c0 01             	add    $0x1,%eax
  800a8b:	83 c2 01             	add    $0x1,%edx
  800a8e:	eb ea                	jmp    800a7a <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a90:	0f b6 c1             	movzbl %cl,%eax
  800a93:	0f b6 db             	movzbl %bl,%ebx
  800a96:	29 d8                	sub    %ebx,%eax
  800a98:	eb 05                	jmp    800a9f <memcmp+0x35>
	}

	return 0;
  800a9a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a9f:	5b                   	pop    %ebx
  800aa0:	5e                   	pop    %esi
  800aa1:	5d                   	pop    %ebp
  800aa2:	c3                   	ret    

00800aa3 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800aa3:	55                   	push   %ebp
  800aa4:	89 e5                	mov    %esp,%ebp
  800aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800aac:	89 c2                	mov    %eax,%edx
  800aae:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ab1:	39 d0                	cmp    %edx,%eax
  800ab3:	73 09                	jae    800abe <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ab5:	38 08                	cmp    %cl,(%eax)
  800ab7:	74 05                	je     800abe <memfind+0x1b>
	for (; s < ends; s++)
  800ab9:	83 c0 01             	add    $0x1,%eax
  800abc:	eb f3                	jmp    800ab1 <memfind+0xe>
			break;
	return (void *) s;
}
  800abe:	5d                   	pop    %ebp
  800abf:	c3                   	ret    

00800ac0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ac0:	55                   	push   %ebp
  800ac1:	89 e5                	mov    %esp,%ebp
  800ac3:	57                   	push   %edi
  800ac4:	56                   	push   %esi
  800ac5:	53                   	push   %ebx
  800ac6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ac9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800acc:	eb 03                	jmp    800ad1 <strtol+0x11>
		s++;
  800ace:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ad1:	0f b6 01             	movzbl (%ecx),%eax
  800ad4:	3c 20                	cmp    $0x20,%al
  800ad6:	74 f6                	je     800ace <strtol+0xe>
  800ad8:	3c 09                	cmp    $0x9,%al
  800ada:	74 f2                	je     800ace <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800adc:	3c 2b                	cmp    $0x2b,%al
  800ade:	74 2a                	je     800b0a <strtol+0x4a>
	int neg = 0;
  800ae0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ae5:	3c 2d                	cmp    $0x2d,%al
  800ae7:	74 2b                	je     800b14 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ae9:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800aef:	75 0f                	jne    800b00 <strtol+0x40>
  800af1:	80 39 30             	cmpb   $0x30,(%ecx)
  800af4:	74 28                	je     800b1e <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800af6:	85 db                	test   %ebx,%ebx
  800af8:	b8 0a 00 00 00       	mov    $0xa,%eax
  800afd:	0f 44 d8             	cmove  %eax,%ebx
  800b00:	b8 00 00 00 00       	mov    $0x0,%eax
  800b05:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b08:	eb 50                	jmp    800b5a <strtol+0x9a>
		s++;
  800b0a:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b0d:	bf 00 00 00 00       	mov    $0x0,%edi
  800b12:	eb d5                	jmp    800ae9 <strtol+0x29>
		s++, neg = 1;
  800b14:	83 c1 01             	add    $0x1,%ecx
  800b17:	bf 01 00 00 00       	mov    $0x1,%edi
  800b1c:	eb cb                	jmp    800ae9 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b1e:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b22:	74 0e                	je     800b32 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800b24:	85 db                	test   %ebx,%ebx
  800b26:	75 d8                	jne    800b00 <strtol+0x40>
		s++, base = 8;
  800b28:	83 c1 01             	add    $0x1,%ecx
  800b2b:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b30:	eb ce                	jmp    800b00 <strtol+0x40>
		s += 2, base = 16;
  800b32:	83 c1 02             	add    $0x2,%ecx
  800b35:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b3a:	eb c4                	jmp    800b00 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b3c:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b3f:	89 f3                	mov    %esi,%ebx
  800b41:	80 fb 19             	cmp    $0x19,%bl
  800b44:	77 29                	ja     800b6f <strtol+0xaf>
			dig = *s - 'a' + 10;
  800b46:	0f be d2             	movsbl %dl,%edx
  800b49:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b4c:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b4f:	7d 30                	jge    800b81 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800b51:	83 c1 01             	add    $0x1,%ecx
  800b54:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b58:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b5a:	0f b6 11             	movzbl (%ecx),%edx
  800b5d:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b60:	89 f3                	mov    %esi,%ebx
  800b62:	80 fb 09             	cmp    $0x9,%bl
  800b65:	77 d5                	ja     800b3c <strtol+0x7c>
			dig = *s - '0';
  800b67:	0f be d2             	movsbl %dl,%edx
  800b6a:	83 ea 30             	sub    $0x30,%edx
  800b6d:	eb dd                	jmp    800b4c <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800b6f:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b72:	89 f3                	mov    %esi,%ebx
  800b74:	80 fb 19             	cmp    $0x19,%bl
  800b77:	77 08                	ja     800b81 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800b79:	0f be d2             	movsbl %dl,%edx
  800b7c:	83 ea 37             	sub    $0x37,%edx
  800b7f:	eb cb                	jmp    800b4c <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b81:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b85:	74 05                	je     800b8c <strtol+0xcc>
		*endptr = (char *) s;
  800b87:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b8a:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b8c:	89 c2                	mov    %eax,%edx
  800b8e:	f7 da                	neg    %edx
  800b90:	85 ff                	test   %edi,%edi
  800b92:	0f 45 c2             	cmovne %edx,%eax
}
  800b95:	5b                   	pop    %ebx
  800b96:	5e                   	pop    %esi
  800b97:	5f                   	pop    %edi
  800b98:	5d                   	pop    %ebp
  800b99:	c3                   	ret    

00800b9a <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b9a:	55                   	push   %ebp
  800b9b:	89 e5                	mov    %esp,%ebp
  800b9d:	57                   	push   %edi
  800b9e:	56                   	push   %esi
  800b9f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ba0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ba5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ba8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bab:	89 c3                	mov    %eax,%ebx
  800bad:	89 c7                	mov    %eax,%edi
  800baf:	89 c6                	mov    %eax,%esi
  800bb1:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bb3:	5b                   	pop    %ebx
  800bb4:	5e                   	pop    %esi
  800bb5:	5f                   	pop    %edi
  800bb6:	5d                   	pop    %ebp
  800bb7:	c3                   	ret    

00800bb8 <sys_cgetc>:

int
sys_cgetc(void)
{
  800bb8:	55                   	push   %ebp
  800bb9:	89 e5                	mov    %esp,%ebp
  800bbb:	57                   	push   %edi
  800bbc:	56                   	push   %esi
  800bbd:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bbe:	ba 00 00 00 00       	mov    $0x0,%edx
  800bc3:	b8 01 00 00 00       	mov    $0x1,%eax
  800bc8:	89 d1                	mov    %edx,%ecx
  800bca:	89 d3                	mov    %edx,%ebx
  800bcc:	89 d7                	mov    %edx,%edi
  800bce:	89 d6                	mov    %edx,%esi
  800bd0:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bd2:	5b                   	pop    %ebx
  800bd3:	5e                   	pop    %esi
  800bd4:	5f                   	pop    %edi
  800bd5:	5d                   	pop    %ebp
  800bd6:	c3                   	ret    

00800bd7 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bd7:	55                   	push   %ebp
  800bd8:	89 e5                	mov    %esp,%ebp
  800bda:	57                   	push   %edi
  800bdb:	56                   	push   %esi
  800bdc:	53                   	push   %ebx
  800bdd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800be0:	b9 00 00 00 00       	mov    $0x0,%ecx
  800be5:	8b 55 08             	mov    0x8(%ebp),%edx
  800be8:	b8 03 00 00 00       	mov    $0x3,%eax
  800bed:	89 cb                	mov    %ecx,%ebx
  800bef:	89 cf                	mov    %ecx,%edi
  800bf1:	89 ce                	mov    %ecx,%esi
  800bf3:	cd 30                	int    $0x30
	if (check && ret > 0)
  800bf5:	85 c0                	test   %eax,%eax
  800bf7:	7f 08                	jg     800c01 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bf9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bfc:	5b                   	pop    %ebx
  800bfd:	5e                   	pop    %esi
  800bfe:	5f                   	pop    %edi
  800bff:	5d                   	pop    %ebp
  800c00:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c01:	83 ec 0c             	sub    $0xc,%esp
  800c04:	50                   	push   %eax
  800c05:	6a 03                	push   $0x3
  800c07:	68 e0 14 80 00       	push   $0x8014e0
  800c0c:	6a 4c                	push   $0x4c
  800c0e:	68 fd 14 80 00       	push   $0x8014fd
  800c13:	e8 70 02 00 00       	call   800e88 <_panic>

00800c18 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c18:	55                   	push   %ebp
  800c19:	89 e5                	mov    %esp,%ebp
  800c1b:	57                   	push   %edi
  800c1c:	56                   	push   %esi
  800c1d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c1e:	ba 00 00 00 00       	mov    $0x0,%edx
  800c23:	b8 02 00 00 00       	mov    $0x2,%eax
  800c28:	89 d1                	mov    %edx,%ecx
  800c2a:	89 d3                	mov    %edx,%ebx
  800c2c:	89 d7                	mov    %edx,%edi
  800c2e:	89 d6                	mov    %edx,%esi
  800c30:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c32:	5b                   	pop    %ebx
  800c33:	5e                   	pop    %esi
  800c34:	5f                   	pop    %edi
  800c35:	5d                   	pop    %ebp
  800c36:	c3                   	ret    

00800c37 <sys_yield>:

void
sys_yield(void)
{
  800c37:	55                   	push   %ebp
  800c38:	89 e5                	mov    %esp,%ebp
  800c3a:	57                   	push   %edi
  800c3b:	56                   	push   %esi
  800c3c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c3d:	ba 00 00 00 00       	mov    $0x0,%edx
  800c42:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c47:	89 d1                	mov    %edx,%ecx
  800c49:	89 d3                	mov    %edx,%ebx
  800c4b:	89 d7                	mov    %edx,%edi
  800c4d:	89 d6                	mov    %edx,%esi
  800c4f:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c51:	5b                   	pop    %ebx
  800c52:	5e                   	pop    %esi
  800c53:	5f                   	pop    %edi
  800c54:	5d                   	pop    %ebp
  800c55:	c3                   	ret    

00800c56 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c56:	55                   	push   %ebp
  800c57:	89 e5                	mov    %esp,%ebp
  800c59:	57                   	push   %edi
  800c5a:	56                   	push   %esi
  800c5b:	53                   	push   %ebx
  800c5c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c5f:	be 00 00 00 00       	mov    $0x0,%esi
  800c64:	8b 55 08             	mov    0x8(%ebp),%edx
  800c67:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c6a:	b8 04 00 00 00       	mov    $0x4,%eax
  800c6f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c72:	89 f7                	mov    %esi,%edi
  800c74:	cd 30                	int    $0x30
	if (check && ret > 0)
  800c76:	85 c0                	test   %eax,%eax
  800c78:	7f 08                	jg     800c82 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c7d:	5b                   	pop    %ebx
  800c7e:	5e                   	pop    %esi
  800c7f:	5f                   	pop    %edi
  800c80:	5d                   	pop    %ebp
  800c81:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c82:	83 ec 0c             	sub    $0xc,%esp
  800c85:	50                   	push   %eax
  800c86:	6a 04                	push   $0x4
  800c88:	68 e0 14 80 00       	push   $0x8014e0
  800c8d:	6a 4c                	push   $0x4c
  800c8f:	68 fd 14 80 00       	push   $0x8014fd
  800c94:	e8 ef 01 00 00       	call   800e88 <_panic>

00800c99 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c99:	55                   	push   %ebp
  800c9a:	89 e5                	mov    %esp,%ebp
  800c9c:	57                   	push   %edi
  800c9d:	56                   	push   %esi
  800c9e:	53                   	push   %ebx
  800c9f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ca2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ca8:	b8 05 00 00 00       	mov    $0x5,%eax
  800cad:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cb0:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cb3:	8b 75 18             	mov    0x18(%ebp),%esi
  800cb6:	cd 30                	int    $0x30
	if (check && ret > 0)
  800cb8:	85 c0                	test   %eax,%eax
  800cba:	7f 08                	jg     800cc4 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800cbc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cbf:	5b                   	pop    %ebx
  800cc0:	5e                   	pop    %esi
  800cc1:	5f                   	pop    %edi
  800cc2:	5d                   	pop    %ebp
  800cc3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cc4:	83 ec 0c             	sub    $0xc,%esp
  800cc7:	50                   	push   %eax
  800cc8:	6a 05                	push   $0x5
  800cca:	68 e0 14 80 00       	push   $0x8014e0
  800ccf:	6a 4c                	push   $0x4c
  800cd1:	68 fd 14 80 00       	push   $0x8014fd
  800cd6:	e8 ad 01 00 00       	call   800e88 <_panic>

00800cdb <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800cdb:	55                   	push   %ebp
  800cdc:	89 e5                	mov    %esp,%ebp
  800cde:	57                   	push   %edi
  800cdf:	56                   	push   %esi
  800ce0:	53                   	push   %ebx
  800ce1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ce4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ce9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cef:	b8 06 00 00 00       	mov    $0x6,%eax
  800cf4:	89 df                	mov    %ebx,%edi
  800cf6:	89 de                	mov    %ebx,%esi
  800cf8:	cd 30                	int    $0x30
	if (check && ret > 0)
  800cfa:	85 c0                	test   %eax,%eax
  800cfc:	7f 08                	jg     800d06 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800cfe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d01:	5b                   	pop    %ebx
  800d02:	5e                   	pop    %esi
  800d03:	5f                   	pop    %edi
  800d04:	5d                   	pop    %ebp
  800d05:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d06:	83 ec 0c             	sub    $0xc,%esp
  800d09:	50                   	push   %eax
  800d0a:	6a 06                	push   $0x6
  800d0c:	68 e0 14 80 00       	push   $0x8014e0
  800d11:	6a 4c                	push   $0x4c
  800d13:	68 fd 14 80 00       	push   $0x8014fd
  800d18:	e8 6b 01 00 00       	call   800e88 <_panic>

00800d1d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d1d:	55                   	push   %ebp
  800d1e:	89 e5                	mov    %esp,%ebp
  800d20:	57                   	push   %edi
  800d21:	56                   	push   %esi
  800d22:	53                   	push   %ebx
  800d23:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d26:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d2b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d2e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d31:	b8 08 00 00 00       	mov    $0x8,%eax
  800d36:	89 df                	mov    %ebx,%edi
  800d38:	89 de                	mov    %ebx,%esi
  800d3a:	cd 30                	int    $0x30
	if (check && ret > 0)
  800d3c:	85 c0                	test   %eax,%eax
  800d3e:	7f 08                	jg     800d48 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d40:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d43:	5b                   	pop    %ebx
  800d44:	5e                   	pop    %esi
  800d45:	5f                   	pop    %edi
  800d46:	5d                   	pop    %ebp
  800d47:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d48:	83 ec 0c             	sub    $0xc,%esp
  800d4b:	50                   	push   %eax
  800d4c:	6a 08                	push   $0x8
  800d4e:	68 e0 14 80 00       	push   $0x8014e0
  800d53:	6a 4c                	push   $0x4c
  800d55:	68 fd 14 80 00       	push   $0x8014fd
  800d5a:	e8 29 01 00 00       	call   800e88 <_panic>

00800d5f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d5f:	55                   	push   %ebp
  800d60:	89 e5                	mov    %esp,%ebp
  800d62:	57                   	push   %edi
  800d63:	56                   	push   %esi
  800d64:	53                   	push   %ebx
  800d65:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d68:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d6d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d70:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d73:	b8 09 00 00 00       	mov    $0x9,%eax
  800d78:	89 df                	mov    %ebx,%edi
  800d7a:	89 de                	mov    %ebx,%esi
  800d7c:	cd 30                	int    $0x30
	if (check && ret > 0)
  800d7e:	85 c0                	test   %eax,%eax
  800d80:	7f 08                	jg     800d8a <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d82:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d85:	5b                   	pop    %ebx
  800d86:	5e                   	pop    %esi
  800d87:	5f                   	pop    %edi
  800d88:	5d                   	pop    %ebp
  800d89:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d8a:	83 ec 0c             	sub    $0xc,%esp
  800d8d:	50                   	push   %eax
  800d8e:	6a 09                	push   $0x9
  800d90:	68 e0 14 80 00       	push   $0x8014e0
  800d95:	6a 4c                	push   $0x4c
  800d97:	68 fd 14 80 00       	push   $0x8014fd
  800d9c:	e8 e7 00 00 00       	call   800e88 <_panic>

00800da1 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800da1:	55                   	push   %ebp
  800da2:	89 e5                	mov    %esp,%ebp
  800da4:	57                   	push   %edi
  800da5:	56                   	push   %esi
  800da6:	53                   	push   %ebx
  800da7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800daa:	bb 00 00 00 00       	mov    $0x0,%ebx
  800daf:	8b 55 08             	mov    0x8(%ebp),%edx
  800db2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db5:	b8 0a 00 00 00       	mov    $0xa,%eax
  800dba:	89 df                	mov    %ebx,%edi
  800dbc:	89 de                	mov    %ebx,%esi
  800dbe:	cd 30                	int    $0x30
	if (check && ret > 0)
  800dc0:	85 c0                	test   %eax,%eax
  800dc2:	7f 08                	jg     800dcc <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800dc4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dc7:	5b                   	pop    %ebx
  800dc8:	5e                   	pop    %esi
  800dc9:	5f                   	pop    %edi
  800dca:	5d                   	pop    %ebp
  800dcb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dcc:	83 ec 0c             	sub    $0xc,%esp
  800dcf:	50                   	push   %eax
  800dd0:	6a 0a                	push   $0xa
  800dd2:	68 e0 14 80 00       	push   $0x8014e0
  800dd7:	6a 4c                	push   $0x4c
  800dd9:	68 fd 14 80 00       	push   $0x8014fd
  800dde:	e8 a5 00 00 00       	call   800e88 <_panic>

00800de3 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800de3:	55                   	push   %ebp
  800de4:	89 e5                	mov    %esp,%ebp
  800de6:	57                   	push   %edi
  800de7:	56                   	push   %esi
  800de8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800de9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800def:	b8 0c 00 00 00       	mov    $0xc,%eax
  800df4:	be 00 00 00 00       	mov    $0x0,%esi
  800df9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dfc:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dff:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e01:	5b                   	pop    %ebx
  800e02:	5e                   	pop    %esi
  800e03:	5f                   	pop    %edi
  800e04:	5d                   	pop    %ebp
  800e05:	c3                   	ret    

00800e06 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e06:	55                   	push   %ebp
  800e07:	89 e5                	mov    %esp,%ebp
  800e09:	57                   	push   %edi
  800e0a:	56                   	push   %esi
  800e0b:	53                   	push   %ebx
  800e0c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e0f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e14:	8b 55 08             	mov    0x8(%ebp),%edx
  800e17:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e1c:	89 cb                	mov    %ecx,%ebx
  800e1e:	89 cf                	mov    %ecx,%edi
  800e20:	89 ce                	mov    %ecx,%esi
  800e22:	cd 30                	int    $0x30
	if (check && ret > 0)
  800e24:	85 c0                	test   %eax,%eax
  800e26:	7f 08                	jg     800e30 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e28:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e2b:	5b                   	pop    %ebx
  800e2c:	5e                   	pop    %esi
  800e2d:	5f                   	pop    %edi
  800e2e:	5d                   	pop    %ebp
  800e2f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e30:	83 ec 0c             	sub    $0xc,%esp
  800e33:	50                   	push   %eax
  800e34:	6a 0d                	push   $0xd
  800e36:	68 e0 14 80 00       	push   $0x8014e0
  800e3b:	6a 4c                	push   $0x4c
  800e3d:	68 fd 14 80 00       	push   $0x8014fd
  800e42:	e8 41 00 00 00       	call   800e88 <_panic>

00800e47 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800e47:	55                   	push   %ebp
  800e48:	89 e5                	mov    %esp,%ebp
  800e4a:	57                   	push   %edi
  800e4b:	56                   	push   %esi
  800e4c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e4d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e52:	8b 55 08             	mov    0x8(%ebp),%edx
  800e55:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e58:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e5d:	89 df                	mov    %ebx,%edi
  800e5f:	89 de                	mov    %ebx,%esi
  800e61:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800e63:	5b                   	pop    %ebx
  800e64:	5e                   	pop    %esi
  800e65:	5f                   	pop    %edi
  800e66:	5d                   	pop    %ebp
  800e67:	c3                   	ret    

00800e68 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800e68:	55                   	push   %ebp
  800e69:	89 e5                	mov    %esp,%ebp
  800e6b:	57                   	push   %edi
  800e6c:	56                   	push   %esi
  800e6d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e6e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e73:	8b 55 08             	mov    0x8(%ebp),%edx
  800e76:	b8 0f 00 00 00       	mov    $0xf,%eax
  800e7b:	89 cb                	mov    %ecx,%ebx
  800e7d:	89 cf                	mov    %ecx,%edi
  800e7f:	89 ce                	mov    %ecx,%esi
  800e81:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800e83:	5b                   	pop    %ebx
  800e84:	5e                   	pop    %esi
  800e85:	5f                   	pop    %edi
  800e86:	5d                   	pop    %ebp
  800e87:	c3                   	ret    

00800e88 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800e88:	55                   	push   %ebp
  800e89:	89 e5                	mov    %esp,%ebp
  800e8b:	56                   	push   %esi
  800e8c:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800e8d:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800e90:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800e96:	e8 7d fd ff ff       	call   800c18 <sys_getenvid>
  800e9b:	83 ec 0c             	sub    $0xc,%esp
  800e9e:	ff 75 0c             	pushl  0xc(%ebp)
  800ea1:	ff 75 08             	pushl  0x8(%ebp)
  800ea4:	56                   	push   %esi
  800ea5:	50                   	push   %eax
  800ea6:	68 0c 15 80 00       	push   $0x80150c
  800eab:	e8 8e f2 ff ff       	call   80013e <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800eb0:	83 c4 18             	add    $0x18,%esp
  800eb3:	53                   	push   %ebx
  800eb4:	ff 75 10             	pushl  0x10(%ebp)
  800eb7:	e8 31 f2 ff ff       	call   8000ed <vcprintf>
	cprintf("\n");
  800ebc:	c7 04 24 30 15 80 00 	movl   $0x801530,(%esp)
  800ec3:	e8 76 f2 ff ff       	call   80013e <cprintf>
  800ec8:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800ecb:	cc                   	int3   
  800ecc:	eb fd                	jmp    800ecb <_panic+0x43>
  800ece:	66 90                	xchg   %ax,%ax

00800ed0 <__udivdi3>:
  800ed0:	55                   	push   %ebp
  800ed1:	57                   	push   %edi
  800ed2:	56                   	push   %esi
  800ed3:	53                   	push   %ebx
  800ed4:	83 ec 1c             	sub    $0x1c,%esp
  800ed7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800edb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800edf:	8b 74 24 34          	mov    0x34(%esp),%esi
  800ee3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800ee7:	85 d2                	test   %edx,%edx
  800ee9:	75 4d                	jne    800f38 <__udivdi3+0x68>
  800eeb:	39 f3                	cmp    %esi,%ebx
  800eed:	76 19                	jbe    800f08 <__udivdi3+0x38>
  800eef:	31 ff                	xor    %edi,%edi
  800ef1:	89 e8                	mov    %ebp,%eax
  800ef3:	89 f2                	mov    %esi,%edx
  800ef5:	f7 f3                	div    %ebx
  800ef7:	89 fa                	mov    %edi,%edx
  800ef9:	83 c4 1c             	add    $0x1c,%esp
  800efc:	5b                   	pop    %ebx
  800efd:	5e                   	pop    %esi
  800efe:	5f                   	pop    %edi
  800eff:	5d                   	pop    %ebp
  800f00:	c3                   	ret    
  800f01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f08:	89 d9                	mov    %ebx,%ecx
  800f0a:	85 db                	test   %ebx,%ebx
  800f0c:	75 0b                	jne    800f19 <__udivdi3+0x49>
  800f0e:	b8 01 00 00 00       	mov    $0x1,%eax
  800f13:	31 d2                	xor    %edx,%edx
  800f15:	f7 f3                	div    %ebx
  800f17:	89 c1                	mov    %eax,%ecx
  800f19:	31 d2                	xor    %edx,%edx
  800f1b:	89 f0                	mov    %esi,%eax
  800f1d:	f7 f1                	div    %ecx
  800f1f:	89 c6                	mov    %eax,%esi
  800f21:	89 e8                	mov    %ebp,%eax
  800f23:	89 f7                	mov    %esi,%edi
  800f25:	f7 f1                	div    %ecx
  800f27:	89 fa                	mov    %edi,%edx
  800f29:	83 c4 1c             	add    $0x1c,%esp
  800f2c:	5b                   	pop    %ebx
  800f2d:	5e                   	pop    %esi
  800f2e:	5f                   	pop    %edi
  800f2f:	5d                   	pop    %ebp
  800f30:	c3                   	ret    
  800f31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f38:	39 f2                	cmp    %esi,%edx
  800f3a:	77 1c                	ja     800f58 <__udivdi3+0x88>
  800f3c:	0f bd fa             	bsr    %edx,%edi
  800f3f:	83 f7 1f             	xor    $0x1f,%edi
  800f42:	75 2c                	jne    800f70 <__udivdi3+0xa0>
  800f44:	39 f2                	cmp    %esi,%edx
  800f46:	72 06                	jb     800f4e <__udivdi3+0x7e>
  800f48:	31 c0                	xor    %eax,%eax
  800f4a:	39 eb                	cmp    %ebp,%ebx
  800f4c:	77 a9                	ja     800ef7 <__udivdi3+0x27>
  800f4e:	b8 01 00 00 00       	mov    $0x1,%eax
  800f53:	eb a2                	jmp    800ef7 <__udivdi3+0x27>
  800f55:	8d 76 00             	lea    0x0(%esi),%esi
  800f58:	31 ff                	xor    %edi,%edi
  800f5a:	31 c0                	xor    %eax,%eax
  800f5c:	89 fa                	mov    %edi,%edx
  800f5e:	83 c4 1c             	add    $0x1c,%esp
  800f61:	5b                   	pop    %ebx
  800f62:	5e                   	pop    %esi
  800f63:	5f                   	pop    %edi
  800f64:	5d                   	pop    %ebp
  800f65:	c3                   	ret    
  800f66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f6d:	8d 76 00             	lea    0x0(%esi),%esi
  800f70:	89 f9                	mov    %edi,%ecx
  800f72:	b8 20 00 00 00       	mov    $0x20,%eax
  800f77:	29 f8                	sub    %edi,%eax
  800f79:	d3 e2                	shl    %cl,%edx
  800f7b:	89 54 24 08          	mov    %edx,0x8(%esp)
  800f7f:	89 c1                	mov    %eax,%ecx
  800f81:	89 da                	mov    %ebx,%edx
  800f83:	d3 ea                	shr    %cl,%edx
  800f85:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800f89:	09 d1                	or     %edx,%ecx
  800f8b:	89 f2                	mov    %esi,%edx
  800f8d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800f91:	89 f9                	mov    %edi,%ecx
  800f93:	d3 e3                	shl    %cl,%ebx
  800f95:	89 c1                	mov    %eax,%ecx
  800f97:	d3 ea                	shr    %cl,%edx
  800f99:	89 f9                	mov    %edi,%ecx
  800f9b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800f9f:	89 eb                	mov    %ebp,%ebx
  800fa1:	d3 e6                	shl    %cl,%esi
  800fa3:	89 c1                	mov    %eax,%ecx
  800fa5:	d3 eb                	shr    %cl,%ebx
  800fa7:	09 de                	or     %ebx,%esi
  800fa9:	89 f0                	mov    %esi,%eax
  800fab:	f7 74 24 08          	divl   0x8(%esp)
  800faf:	89 d6                	mov    %edx,%esi
  800fb1:	89 c3                	mov    %eax,%ebx
  800fb3:	f7 64 24 0c          	mull   0xc(%esp)
  800fb7:	39 d6                	cmp    %edx,%esi
  800fb9:	72 15                	jb     800fd0 <__udivdi3+0x100>
  800fbb:	89 f9                	mov    %edi,%ecx
  800fbd:	d3 e5                	shl    %cl,%ebp
  800fbf:	39 c5                	cmp    %eax,%ebp
  800fc1:	73 04                	jae    800fc7 <__udivdi3+0xf7>
  800fc3:	39 d6                	cmp    %edx,%esi
  800fc5:	74 09                	je     800fd0 <__udivdi3+0x100>
  800fc7:	89 d8                	mov    %ebx,%eax
  800fc9:	31 ff                	xor    %edi,%edi
  800fcb:	e9 27 ff ff ff       	jmp    800ef7 <__udivdi3+0x27>
  800fd0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800fd3:	31 ff                	xor    %edi,%edi
  800fd5:	e9 1d ff ff ff       	jmp    800ef7 <__udivdi3+0x27>
  800fda:	66 90                	xchg   %ax,%ax
  800fdc:	66 90                	xchg   %ax,%ax
  800fde:	66 90                	xchg   %ax,%ax

00800fe0 <__umoddi3>:
  800fe0:	55                   	push   %ebp
  800fe1:	57                   	push   %edi
  800fe2:	56                   	push   %esi
  800fe3:	53                   	push   %ebx
  800fe4:	83 ec 1c             	sub    $0x1c,%esp
  800fe7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800feb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  800fef:	8b 74 24 30          	mov    0x30(%esp),%esi
  800ff3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  800ff7:	89 da                	mov    %ebx,%edx
  800ff9:	85 c0                	test   %eax,%eax
  800ffb:	75 43                	jne    801040 <__umoddi3+0x60>
  800ffd:	39 df                	cmp    %ebx,%edi
  800fff:	76 17                	jbe    801018 <__umoddi3+0x38>
  801001:	89 f0                	mov    %esi,%eax
  801003:	f7 f7                	div    %edi
  801005:	89 d0                	mov    %edx,%eax
  801007:	31 d2                	xor    %edx,%edx
  801009:	83 c4 1c             	add    $0x1c,%esp
  80100c:	5b                   	pop    %ebx
  80100d:	5e                   	pop    %esi
  80100e:	5f                   	pop    %edi
  80100f:	5d                   	pop    %ebp
  801010:	c3                   	ret    
  801011:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801018:	89 fd                	mov    %edi,%ebp
  80101a:	85 ff                	test   %edi,%edi
  80101c:	75 0b                	jne    801029 <__umoddi3+0x49>
  80101e:	b8 01 00 00 00       	mov    $0x1,%eax
  801023:	31 d2                	xor    %edx,%edx
  801025:	f7 f7                	div    %edi
  801027:	89 c5                	mov    %eax,%ebp
  801029:	89 d8                	mov    %ebx,%eax
  80102b:	31 d2                	xor    %edx,%edx
  80102d:	f7 f5                	div    %ebp
  80102f:	89 f0                	mov    %esi,%eax
  801031:	f7 f5                	div    %ebp
  801033:	89 d0                	mov    %edx,%eax
  801035:	eb d0                	jmp    801007 <__umoddi3+0x27>
  801037:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80103e:	66 90                	xchg   %ax,%ax
  801040:	89 f1                	mov    %esi,%ecx
  801042:	39 d8                	cmp    %ebx,%eax
  801044:	76 0a                	jbe    801050 <__umoddi3+0x70>
  801046:	89 f0                	mov    %esi,%eax
  801048:	83 c4 1c             	add    $0x1c,%esp
  80104b:	5b                   	pop    %ebx
  80104c:	5e                   	pop    %esi
  80104d:	5f                   	pop    %edi
  80104e:	5d                   	pop    %ebp
  80104f:	c3                   	ret    
  801050:	0f bd e8             	bsr    %eax,%ebp
  801053:	83 f5 1f             	xor    $0x1f,%ebp
  801056:	75 20                	jne    801078 <__umoddi3+0x98>
  801058:	39 d8                	cmp    %ebx,%eax
  80105a:	0f 82 b0 00 00 00    	jb     801110 <__umoddi3+0x130>
  801060:	39 f7                	cmp    %esi,%edi
  801062:	0f 86 a8 00 00 00    	jbe    801110 <__umoddi3+0x130>
  801068:	89 c8                	mov    %ecx,%eax
  80106a:	83 c4 1c             	add    $0x1c,%esp
  80106d:	5b                   	pop    %ebx
  80106e:	5e                   	pop    %esi
  80106f:	5f                   	pop    %edi
  801070:	5d                   	pop    %ebp
  801071:	c3                   	ret    
  801072:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801078:	89 e9                	mov    %ebp,%ecx
  80107a:	ba 20 00 00 00       	mov    $0x20,%edx
  80107f:	29 ea                	sub    %ebp,%edx
  801081:	d3 e0                	shl    %cl,%eax
  801083:	89 44 24 08          	mov    %eax,0x8(%esp)
  801087:	89 d1                	mov    %edx,%ecx
  801089:	89 f8                	mov    %edi,%eax
  80108b:	d3 e8                	shr    %cl,%eax
  80108d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801091:	89 54 24 04          	mov    %edx,0x4(%esp)
  801095:	8b 54 24 04          	mov    0x4(%esp),%edx
  801099:	09 c1                	or     %eax,%ecx
  80109b:	89 d8                	mov    %ebx,%eax
  80109d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8010a1:	89 e9                	mov    %ebp,%ecx
  8010a3:	d3 e7                	shl    %cl,%edi
  8010a5:	89 d1                	mov    %edx,%ecx
  8010a7:	d3 e8                	shr    %cl,%eax
  8010a9:	89 e9                	mov    %ebp,%ecx
  8010ab:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8010af:	d3 e3                	shl    %cl,%ebx
  8010b1:	89 c7                	mov    %eax,%edi
  8010b3:	89 d1                	mov    %edx,%ecx
  8010b5:	89 f0                	mov    %esi,%eax
  8010b7:	d3 e8                	shr    %cl,%eax
  8010b9:	89 e9                	mov    %ebp,%ecx
  8010bb:	89 fa                	mov    %edi,%edx
  8010bd:	d3 e6                	shl    %cl,%esi
  8010bf:	09 d8                	or     %ebx,%eax
  8010c1:	f7 74 24 08          	divl   0x8(%esp)
  8010c5:	89 d1                	mov    %edx,%ecx
  8010c7:	89 f3                	mov    %esi,%ebx
  8010c9:	f7 64 24 0c          	mull   0xc(%esp)
  8010cd:	89 c6                	mov    %eax,%esi
  8010cf:	89 d7                	mov    %edx,%edi
  8010d1:	39 d1                	cmp    %edx,%ecx
  8010d3:	72 06                	jb     8010db <__umoddi3+0xfb>
  8010d5:	75 10                	jne    8010e7 <__umoddi3+0x107>
  8010d7:	39 c3                	cmp    %eax,%ebx
  8010d9:	73 0c                	jae    8010e7 <__umoddi3+0x107>
  8010db:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8010df:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8010e3:	89 d7                	mov    %edx,%edi
  8010e5:	89 c6                	mov    %eax,%esi
  8010e7:	89 ca                	mov    %ecx,%edx
  8010e9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8010ee:	29 f3                	sub    %esi,%ebx
  8010f0:	19 fa                	sbb    %edi,%edx
  8010f2:	89 d0                	mov    %edx,%eax
  8010f4:	d3 e0                	shl    %cl,%eax
  8010f6:	89 e9                	mov    %ebp,%ecx
  8010f8:	d3 eb                	shr    %cl,%ebx
  8010fa:	d3 ea                	shr    %cl,%edx
  8010fc:	09 d8                	or     %ebx,%eax
  8010fe:	83 c4 1c             	add    $0x1c,%esp
  801101:	5b                   	pop    %ebx
  801102:	5e                   	pop    %esi
  801103:	5f                   	pop    %edi
  801104:	5d                   	pop    %ebp
  801105:	c3                   	ret    
  801106:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80110d:	8d 76 00             	lea    0x0(%esi),%esi
  801110:	89 da                	mov    %ebx,%edx
  801112:	29 fe                	sub    %edi,%esi
  801114:	19 c2                	sbb    %eax,%edx
  801116:	89 f1                	mov    %esi,%ecx
  801118:	89 c8                	mov    %ecx,%eax
  80111a:	e9 4b ff ff ff       	jmp    80106a <__umoddi3+0x8a>
