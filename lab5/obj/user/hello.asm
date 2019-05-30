
obj/user/hello.debug:     file format elf32-i386


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
  80002c:	e8 2d 00 00 00       	call   80005e <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
// hello, world
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 14             	sub    $0x14,%esp
	cprintf("hello, world\n");
  800039:	68 40 11 80 00       	push   $0x801140
  80003e:	e8 0b 01 00 00       	call   80014e <cprintf>
	cprintf("i am environment %08x\n", thisenv->env_id);
  800043:	a1 04 20 80 00       	mov    0x802004,%eax
  800048:	8b 40 48             	mov    0x48(%eax),%eax
  80004b:	83 c4 08             	add    $0x8,%esp
  80004e:	50                   	push   %eax
  80004f:	68 4e 11 80 00       	push   $0x80114e
  800054:	e8 f5 00 00 00       	call   80014e <cprintf>
}
  800059:	83 c4 10             	add    $0x10,%esp
  80005c:	c9                   	leave  
  80005d:	c3                   	ret    

0080005e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80005e:	55                   	push   %ebp
  80005f:	89 e5                	mov    %esp,%ebp
  800061:	56                   	push   %esi
  800062:	53                   	push   %ebx
  800063:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800066:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	// thisenv = 0;
	thisenv = &(envs[ENVX(sys_getenvid())]);
  800069:	e8 ba 0b 00 00       	call   800c28 <sys_getenvid>
  80006e:	25 ff 03 00 00       	and    $0x3ff,%eax
  800073:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  800079:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80007e:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800083:	85 db                	test   %ebx,%ebx
  800085:	7e 07                	jle    80008e <libmain+0x30>
		binaryname = argv[0];
  800087:	8b 06                	mov    (%esi),%eax
  800089:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  80008e:	83 ec 08             	sub    $0x8,%esp
  800091:	56                   	push   %esi
  800092:	53                   	push   %ebx
  800093:	e8 9b ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800098:	e8 0a 00 00 00       	call   8000a7 <exit>
}
  80009d:	83 c4 10             	add    $0x10,%esp
  8000a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000a3:	5b                   	pop    %ebx
  8000a4:	5e                   	pop    %esi
  8000a5:	5d                   	pop    %ebp
  8000a6:	c3                   	ret    

008000a7 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000a7:	55                   	push   %ebp
  8000a8:	89 e5                	mov    %esp,%ebp
  8000aa:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  8000ad:	6a 00                	push   $0x0
  8000af:	e8 33 0b 00 00       	call   800be7 <sys_env_destroy>
}
  8000b4:	83 c4 10             	add    $0x10,%esp
  8000b7:	c9                   	leave  
  8000b8:	c3                   	ret    

008000b9 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000b9:	55                   	push   %ebp
  8000ba:	89 e5                	mov    %esp,%ebp
  8000bc:	53                   	push   %ebx
  8000bd:	83 ec 04             	sub    $0x4,%esp
  8000c0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000c3:	8b 13                	mov    (%ebx),%edx
  8000c5:	8d 42 01             	lea    0x1(%edx),%eax
  8000c8:	89 03                	mov    %eax,(%ebx)
  8000ca:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000cd:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000d1:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000d6:	74 09                	je     8000e1 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000d8:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8000dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000df:	c9                   	leave  
  8000e0:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8000e1:	83 ec 08             	sub    $0x8,%esp
  8000e4:	68 ff 00 00 00       	push   $0xff
  8000e9:	8d 43 08             	lea    0x8(%ebx),%eax
  8000ec:	50                   	push   %eax
  8000ed:	e8 b8 0a 00 00       	call   800baa <sys_cputs>
		b->idx = 0;
  8000f2:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8000f8:	83 c4 10             	add    $0x10,%esp
  8000fb:	eb db                	jmp    8000d8 <putch+0x1f>

008000fd <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8000fd:	55                   	push   %ebp
  8000fe:	89 e5                	mov    %esp,%ebp
  800100:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800106:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80010d:	00 00 00 
	b.cnt = 0;
  800110:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800117:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80011a:	ff 75 0c             	pushl  0xc(%ebp)
  80011d:	ff 75 08             	pushl  0x8(%ebp)
  800120:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800126:	50                   	push   %eax
  800127:	68 b9 00 80 00       	push   $0x8000b9
  80012c:	e8 4a 01 00 00       	call   80027b <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800131:	83 c4 08             	add    $0x8,%esp
  800134:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80013a:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800140:	50                   	push   %eax
  800141:	e8 64 0a 00 00       	call   800baa <sys_cputs>

	return b.cnt;
}
  800146:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80014c:	c9                   	leave  
  80014d:	c3                   	ret    

0080014e <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80014e:	55                   	push   %ebp
  80014f:	89 e5                	mov    %esp,%ebp
  800151:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800154:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800157:	50                   	push   %eax
  800158:	ff 75 08             	pushl  0x8(%ebp)
  80015b:	e8 9d ff ff ff       	call   8000fd <vcprintf>
	va_end(ap);

	return cnt;
}
  800160:	c9                   	leave  
  800161:	c3                   	ret    

00800162 <printnum>:


static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800162:	55                   	push   %ebp
  800163:	89 e5                	mov    %esp,%ebp
  800165:	57                   	push   %edi
  800166:	56                   	push   %esi
  800167:	53                   	push   %ebx
  800168:	83 ec 1c             	sub    $0x1c,%esp
  80016b:	89 c6                	mov    %eax,%esi
  80016d:	89 d7                	mov    %edx,%edi
  80016f:	8b 45 08             	mov    0x8(%ebp),%eax
  800172:	8b 55 0c             	mov    0xc(%ebp),%edx
  800175:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800178:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80017b:	8b 45 10             	mov    0x10(%ebp),%eax
  80017e:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	// to support '-'
	if(padc == '-'){
  800181:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800185:	74 2c                	je     8001b3 <printnum+0x51>
		while (--width > 0)
			putch(' ', putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800187:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80018a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800191:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800194:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800197:	39 c2                	cmp    %eax,%edx
  800199:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80019c:	73 43                	jae    8001e1 <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80019e:	83 eb 01             	sub    $0x1,%ebx
  8001a1:	85 db                	test   %ebx,%ebx
  8001a3:	7e 6c                	jle    800211 <printnum+0xaf>
			putch(padc, putdat);
  8001a5:	83 ec 08             	sub    $0x8,%esp
  8001a8:	57                   	push   %edi
  8001a9:	ff 75 18             	pushl  0x18(%ebp)
  8001ac:	ff d6                	call   *%esi
  8001ae:	83 c4 10             	add    $0x10,%esp
  8001b1:	eb eb                	jmp    80019e <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8001b3:	83 ec 0c             	sub    $0xc,%esp
  8001b6:	6a 20                	push   $0x20
  8001b8:	6a 00                	push   $0x0
  8001ba:	50                   	push   %eax
  8001bb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001be:	ff 75 e0             	pushl  -0x20(%ebp)
  8001c1:	89 fa                	mov    %edi,%edx
  8001c3:	89 f0                	mov    %esi,%eax
  8001c5:	e8 98 ff ff ff       	call   800162 <printnum>
		while (--width > 0)
  8001ca:	83 c4 20             	add    $0x20,%esp
  8001cd:	83 eb 01             	sub    $0x1,%ebx
  8001d0:	85 db                	test   %ebx,%ebx
  8001d2:	7e 65                	jle    800239 <printnum+0xd7>
			putch(' ', putdat);
  8001d4:	83 ec 08             	sub    $0x8,%esp
  8001d7:	57                   	push   %edi
  8001d8:	6a 20                	push   $0x20
  8001da:	ff d6                	call   *%esi
  8001dc:	83 c4 10             	add    $0x10,%esp
  8001df:	eb ec                	jmp    8001cd <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001e1:	83 ec 0c             	sub    $0xc,%esp
  8001e4:	ff 75 18             	pushl  0x18(%ebp)
  8001e7:	83 eb 01             	sub    $0x1,%ebx
  8001ea:	53                   	push   %ebx
  8001eb:	50                   	push   %eax
  8001ec:	83 ec 08             	sub    $0x8,%esp
  8001ef:	ff 75 dc             	pushl  -0x24(%ebp)
  8001f2:	ff 75 d8             	pushl  -0x28(%ebp)
  8001f5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001f8:	ff 75 e0             	pushl  -0x20(%ebp)
  8001fb:	e8 e0 0c 00 00       	call   800ee0 <__udivdi3>
  800200:	83 c4 18             	add    $0x18,%esp
  800203:	52                   	push   %edx
  800204:	50                   	push   %eax
  800205:	89 fa                	mov    %edi,%edx
  800207:	89 f0                	mov    %esi,%eax
  800209:	e8 54 ff ff ff       	call   800162 <printnum>
  80020e:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800211:	83 ec 08             	sub    $0x8,%esp
  800214:	57                   	push   %edi
  800215:	83 ec 04             	sub    $0x4,%esp
  800218:	ff 75 dc             	pushl  -0x24(%ebp)
  80021b:	ff 75 d8             	pushl  -0x28(%ebp)
  80021e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800221:	ff 75 e0             	pushl  -0x20(%ebp)
  800224:	e8 c7 0d 00 00       	call   800ff0 <__umoddi3>
  800229:	83 c4 14             	add    $0x14,%esp
  80022c:	0f be 80 6f 11 80 00 	movsbl 0x80116f(%eax),%eax
  800233:	50                   	push   %eax
  800234:	ff d6                	call   *%esi
  800236:	83 c4 10             	add    $0x10,%esp
}
  800239:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80023c:	5b                   	pop    %ebx
  80023d:	5e                   	pop    %esi
  80023e:	5f                   	pop    %edi
  80023f:	5d                   	pop    %ebp
  800240:	c3                   	ret    

00800241 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800241:	55                   	push   %ebp
  800242:	89 e5                	mov    %esp,%ebp
  800244:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800247:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80024b:	8b 10                	mov    (%eax),%edx
  80024d:	3b 50 04             	cmp    0x4(%eax),%edx
  800250:	73 0a                	jae    80025c <sprintputch+0x1b>
		*b->buf++ = ch;
  800252:	8d 4a 01             	lea    0x1(%edx),%ecx
  800255:	89 08                	mov    %ecx,(%eax)
  800257:	8b 45 08             	mov    0x8(%ebp),%eax
  80025a:	88 02                	mov    %al,(%edx)
}
  80025c:	5d                   	pop    %ebp
  80025d:	c3                   	ret    

0080025e <printfmt>:
{
  80025e:	55                   	push   %ebp
  80025f:	89 e5                	mov    %esp,%ebp
  800261:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800264:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800267:	50                   	push   %eax
  800268:	ff 75 10             	pushl  0x10(%ebp)
  80026b:	ff 75 0c             	pushl  0xc(%ebp)
  80026e:	ff 75 08             	pushl  0x8(%ebp)
  800271:	e8 05 00 00 00       	call   80027b <vprintfmt>
}
  800276:	83 c4 10             	add    $0x10,%esp
  800279:	c9                   	leave  
  80027a:	c3                   	ret    

0080027b <vprintfmt>:
{
  80027b:	55                   	push   %ebp
  80027c:	89 e5                	mov    %esp,%ebp
  80027e:	57                   	push   %edi
  80027f:	56                   	push   %esi
  800280:	53                   	push   %ebx
  800281:	83 ec 3c             	sub    $0x3c,%esp
  800284:	8b 75 08             	mov    0x8(%ebp),%esi
  800287:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80028a:	8b 7d 10             	mov    0x10(%ebp),%edi
  80028d:	e9 1e 04 00 00       	jmp    8006b0 <vprintfmt+0x435>
		posflag = 0;
  800292:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
		padc = ' ';
  800299:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80029d:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8002a4:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8002ab:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002b2:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  8002b9:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002be:	8d 47 01             	lea    0x1(%edi),%eax
  8002c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002c4:	0f b6 17             	movzbl (%edi),%edx
  8002c7:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002ca:	3c 55                	cmp    $0x55,%al
  8002cc:	0f 87 d9 04 00 00    	ja     8007ab <vprintfmt+0x530>
  8002d2:	0f b6 c0             	movzbl %al,%eax
  8002d5:	ff 24 85 60 13 80 00 	jmp    *0x801360(,%eax,4)
  8002dc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002df:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8002e3:	eb d9                	jmp    8002be <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8002e5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posflag = 1;
  8002e8:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  8002ef:	eb cd                	jmp    8002be <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8002f1:	0f b6 d2             	movzbl %dl,%edx
  8002f4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8002f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8002fc:	89 75 08             	mov    %esi,0x8(%ebp)
  8002ff:	eb 0c                	jmp    80030d <vprintfmt+0x92>
		switch (ch = *(unsigned char *) fmt++) {
  800301:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800304:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  800308:	eb b4                	jmp    8002be <vprintfmt+0x43>
			for (precision = 0; ; ++fmt) {
  80030a:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80030d:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800310:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800314:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800317:	8d 72 d0             	lea    -0x30(%edx),%esi
  80031a:	83 fe 09             	cmp    $0x9,%esi
  80031d:	76 eb                	jbe    80030a <vprintfmt+0x8f>
  80031f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800322:	8b 75 08             	mov    0x8(%ebp),%esi
  800325:	eb 14                	jmp    80033b <vprintfmt+0xc0>
			precision = va_arg(ap, int);
  800327:	8b 45 14             	mov    0x14(%ebp),%eax
  80032a:	8b 00                	mov    (%eax),%eax
  80032c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80032f:	8b 45 14             	mov    0x14(%ebp),%eax
  800332:	8d 40 04             	lea    0x4(%eax),%eax
  800335:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800338:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80033b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80033f:	0f 89 79 ff ff ff    	jns    8002be <vprintfmt+0x43>
				width = precision, precision = -1;
  800345:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800348:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80034b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800352:	e9 67 ff ff ff       	jmp    8002be <vprintfmt+0x43>
  800357:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80035a:	85 c0                	test   %eax,%eax
  80035c:	0f 48 c1             	cmovs  %ecx,%eax
  80035f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800362:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800365:	e9 54 ff ff ff       	jmp    8002be <vprintfmt+0x43>
  80036a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80036d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800374:	e9 45 ff ff ff       	jmp    8002be <vprintfmt+0x43>
			lflag++;
  800379:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80037d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800380:	e9 39 ff ff ff       	jmp    8002be <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800385:	8b 45 14             	mov    0x14(%ebp),%eax
  800388:	8d 78 04             	lea    0x4(%eax),%edi
  80038b:	83 ec 08             	sub    $0x8,%esp
  80038e:	53                   	push   %ebx
  80038f:	ff 30                	pushl  (%eax)
  800391:	ff d6                	call   *%esi
			break;
  800393:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800396:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800399:	e9 0f 03 00 00       	jmp    8006ad <vprintfmt+0x432>
			err = va_arg(ap, int);
  80039e:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a1:	8d 78 04             	lea    0x4(%eax),%edi
  8003a4:	8b 00                	mov    (%eax),%eax
  8003a6:	99                   	cltd   
  8003a7:	31 d0                	xor    %edx,%eax
  8003a9:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003ab:	83 f8 0f             	cmp    $0xf,%eax
  8003ae:	7f 23                	jg     8003d3 <vprintfmt+0x158>
  8003b0:	8b 14 85 c0 14 80 00 	mov    0x8014c0(,%eax,4),%edx
  8003b7:	85 d2                	test   %edx,%edx
  8003b9:	74 18                	je     8003d3 <vprintfmt+0x158>
				printfmt(putch, putdat, "%s", p);
  8003bb:	52                   	push   %edx
  8003bc:	68 90 11 80 00       	push   $0x801190
  8003c1:	53                   	push   %ebx
  8003c2:	56                   	push   %esi
  8003c3:	e8 96 fe ff ff       	call   80025e <printfmt>
  8003c8:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003cb:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003ce:	e9 da 02 00 00       	jmp    8006ad <vprintfmt+0x432>
				printfmt(putch, putdat, "error %d", err);
  8003d3:	50                   	push   %eax
  8003d4:	68 87 11 80 00       	push   $0x801187
  8003d9:	53                   	push   %ebx
  8003da:	56                   	push   %esi
  8003db:	e8 7e fe ff ff       	call   80025e <printfmt>
  8003e0:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003e3:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003e6:	e9 c2 02 00 00       	jmp    8006ad <vprintfmt+0x432>
			if ((p = va_arg(ap, char *)) == NULL)
  8003eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ee:	83 c0 04             	add    $0x4,%eax
  8003f1:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8003f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f7:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8003f9:	85 c9                	test   %ecx,%ecx
  8003fb:	b8 80 11 80 00       	mov    $0x801180,%eax
  800400:	0f 45 c1             	cmovne %ecx,%eax
  800403:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800406:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80040a:	7e 06                	jle    800412 <vprintfmt+0x197>
  80040c:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800410:	75 0d                	jne    80041f <vprintfmt+0x1a4>
				for (width -= strnlen(p, precision); width > 0; width--)
  800412:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800415:	89 c7                	mov    %eax,%edi
  800417:	03 45 e0             	add    -0x20(%ebp),%eax
  80041a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80041d:	eb 53                	jmp    800472 <vprintfmt+0x1f7>
  80041f:	83 ec 08             	sub    $0x8,%esp
  800422:	ff 75 d8             	pushl  -0x28(%ebp)
  800425:	50                   	push   %eax
  800426:	e8 28 04 00 00       	call   800853 <strnlen>
  80042b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80042e:	29 c1                	sub    %eax,%ecx
  800430:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  800433:	83 c4 10             	add    $0x10,%esp
  800436:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800438:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80043c:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80043f:	eb 0f                	jmp    800450 <vprintfmt+0x1d5>
					putch(padc, putdat);
  800441:	83 ec 08             	sub    $0x8,%esp
  800444:	53                   	push   %ebx
  800445:	ff 75 e0             	pushl  -0x20(%ebp)
  800448:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80044a:	83 ef 01             	sub    $0x1,%edi
  80044d:	83 c4 10             	add    $0x10,%esp
  800450:	85 ff                	test   %edi,%edi
  800452:	7f ed                	jg     800441 <vprintfmt+0x1c6>
  800454:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  800457:	85 c9                	test   %ecx,%ecx
  800459:	b8 00 00 00 00       	mov    $0x0,%eax
  80045e:	0f 49 c1             	cmovns %ecx,%eax
  800461:	29 c1                	sub    %eax,%ecx
  800463:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800466:	eb aa                	jmp    800412 <vprintfmt+0x197>
					putch(ch, putdat);
  800468:	83 ec 08             	sub    $0x8,%esp
  80046b:	53                   	push   %ebx
  80046c:	52                   	push   %edx
  80046d:	ff d6                	call   *%esi
  80046f:	83 c4 10             	add    $0x10,%esp
  800472:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800475:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800477:	83 c7 01             	add    $0x1,%edi
  80047a:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80047e:	0f be d0             	movsbl %al,%edx
  800481:	85 d2                	test   %edx,%edx
  800483:	74 4b                	je     8004d0 <vprintfmt+0x255>
  800485:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800489:	78 06                	js     800491 <vprintfmt+0x216>
  80048b:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80048f:	78 1e                	js     8004af <vprintfmt+0x234>
				if (altflag && (ch < ' ' || ch > '~'))
  800491:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800495:	74 d1                	je     800468 <vprintfmt+0x1ed>
  800497:	0f be c0             	movsbl %al,%eax
  80049a:	83 e8 20             	sub    $0x20,%eax
  80049d:	83 f8 5e             	cmp    $0x5e,%eax
  8004a0:	76 c6                	jbe    800468 <vprintfmt+0x1ed>
					putch('?', putdat);
  8004a2:	83 ec 08             	sub    $0x8,%esp
  8004a5:	53                   	push   %ebx
  8004a6:	6a 3f                	push   $0x3f
  8004a8:	ff d6                	call   *%esi
  8004aa:	83 c4 10             	add    $0x10,%esp
  8004ad:	eb c3                	jmp    800472 <vprintfmt+0x1f7>
  8004af:	89 cf                	mov    %ecx,%edi
  8004b1:	eb 0e                	jmp    8004c1 <vprintfmt+0x246>
				putch(' ', putdat);
  8004b3:	83 ec 08             	sub    $0x8,%esp
  8004b6:	53                   	push   %ebx
  8004b7:	6a 20                	push   $0x20
  8004b9:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004bb:	83 ef 01             	sub    $0x1,%edi
  8004be:	83 c4 10             	add    $0x10,%esp
  8004c1:	85 ff                	test   %edi,%edi
  8004c3:	7f ee                	jg     8004b3 <vprintfmt+0x238>
			if ((p = va_arg(ap, char *)) == NULL)
  8004c5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004c8:	89 45 14             	mov    %eax,0x14(%ebp)
  8004cb:	e9 dd 01 00 00       	jmp    8006ad <vprintfmt+0x432>
  8004d0:	89 cf                	mov    %ecx,%edi
  8004d2:	eb ed                	jmp    8004c1 <vprintfmt+0x246>
	if (lflag >= 2)
  8004d4:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8004d8:	7f 21                	jg     8004fb <vprintfmt+0x280>
	else if (lflag)
  8004da:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8004de:	74 6a                	je     80054a <vprintfmt+0x2cf>
		return va_arg(*ap, long);
  8004e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e3:	8b 00                	mov    (%eax),%eax
  8004e5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004e8:	89 c1                	mov    %eax,%ecx
  8004ea:	c1 f9 1f             	sar    $0x1f,%ecx
  8004ed:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8004f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f3:	8d 40 04             	lea    0x4(%eax),%eax
  8004f6:	89 45 14             	mov    %eax,0x14(%ebp)
  8004f9:	eb 17                	jmp    800512 <vprintfmt+0x297>
		return va_arg(*ap, long long);
  8004fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fe:	8b 50 04             	mov    0x4(%eax),%edx
  800501:	8b 00                	mov    (%eax),%eax
  800503:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800506:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800509:	8b 45 14             	mov    0x14(%ebp),%eax
  80050c:	8d 40 08             	lea    0x8(%eax),%eax
  80050f:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800512:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  800515:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  80051a:	85 d2                	test   %edx,%edx
  80051c:	0f 89 5c 01 00 00    	jns    80067e <vprintfmt+0x403>
				putch('-', putdat);
  800522:	83 ec 08             	sub    $0x8,%esp
  800525:	53                   	push   %ebx
  800526:	6a 2d                	push   $0x2d
  800528:	ff d6                	call   *%esi
				num = -(long long) num;
  80052a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80052d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800530:	f7 d8                	neg    %eax
  800532:	83 d2 00             	adc    $0x0,%edx
  800535:	f7 da                	neg    %edx
  800537:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80053a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80053d:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800540:	bf 0a 00 00 00       	mov    $0xa,%edi
  800545:	e9 45 01 00 00       	jmp    80068f <vprintfmt+0x414>
		return va_arg(*ap, int);
  80054a:	8b 45 14             	mov    0x14(%ebp),%eax
  80054d:	8b 00                	mov    (%eax),%eax
  80054f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800552:	89 c1                	mov    %eax,%ecx
  800554:	c1 f9 1f             	sar    $0x1f,%ecx
  800557:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80055a:	8b 45 14             	mov    0x14(%ebp),%eax
  80055d:	8d 40 04             	lea    0x4(%eax),%eax
  800560:	89 45 14             	mov    %eax,0x14(%ebp)
  800563:	eb ad                	jmp    800512 <vprintfmt+0x297>
	if (lflag >= 2)
  800565:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800569:	7f 29                	jg     800594 <vprintfmt+0x319>
	else if (lflag)
  80056b:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80056f:	74 44                	je     8005b5 <vprintfmt+0x33a>
		return va_arg(*ap, unsigned long);
  800571:	8b 45 14             	mov    0x14(%ebp),%eax
  800574:	8b 00                	mov    (%eax),%eax
  800576:	ba 00 00 00 00       	mov    $0x0,%edx
  80057b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80057e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800581:	8b 45 14             	mov    0x14(%ebp),%eax
  800584:	8d 40 04             	lea    0x4(%eax),%eax
  800587:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80058a:	bf 0a 00 00 00       	mov    $0xa,%edi
  80058f:	e9 ea 00 00 00       	jmp    80067e <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  800594:	8b 45 14             	mov    0x14(%ebp),%eax
  800597:	8b 50 04             	mov    0x4(%eax),%edx
  80059a:	8b 00                	mov    (%eax),%eax
  80059c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80059f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a5:	8d 40 08             	lea    0x8(%eax),%eax
  8005a8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005ab:	bf 0a 00 00 00       	mov    $0xa,%edi
  8005b0:	e9 c9 00 00 00       	jmp    80067e <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  8005b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b8:	8b 00                	mov    (%eax),%eax
  8005ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8005bf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005c2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c8:	8d 40 04             	lea    0x4(%eax),%eax
  8005cb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005ce:	bf 0a 00 00 00       	mov    $0xa,%edi
  8005d3:	e9 a6 00 00 00       	jmp    80067e <vprintfmt+0x403>
			putch('0', putdat);
  8005d8:	83 ec 08             	sub    $0x8,%esp
  8005db:	53                   	push   %ebx
  8005dc:	6a 30                	push   $0x30
  8005de:	ff d6                	call   *%esi
	if (lflag >= 2)
  8005e0:	83 c4 10             	add    $0x10,%esp
  8005e3:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8005e7:	7f 26                	jg     80060f <vprintfmt+0x394>
	else if (lflag)
  8005e9:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8005ed:	74 3e                	je     80062d <vprintfmt+0x3b2>
		return va_arg(*ap, unsigned long);
  8005ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f2:	8b 00                	mov    (%eax),%eax
  8005f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8005f9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005fc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800602:	8d 40 04             	lea    0x4(%eax),%eax
  800605:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800608:	bf 08 00 00 00       	mov    $0x8,%edi
  80060d:	eb 6f                	jmp    80067e <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  80060f:	8b 45 14             	mov    0x14(%ebp),%eax
  800612:	8b 50 04             	mov    0x4(%eax),%edx
  800615:	8b 00                	mov    (%eax),%eax
  800617:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80061a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80061d:	8b 45 14             	mov    0x14(%ebp),%eax
  800620:	8d 40 08             	lea    0x8(%eax),%eax
  800623:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800626:	bf 08 00 00 00       	mov    $0x8,%edi
  80062b:	eb 51                	jmp    80067e <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  80062d:	8b 45 14             	mov    0x14(%ebp),%eax
  800630:	8b 00                	mov    (%eax),%eax
  800632:	ba 00 00 00 00       	mov    $0x0,%edx
  800637:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80063a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80063d:	8b 45 14             	mov    0x14(%ebp),%eax
  800640:	8d 40 04             	lea    0x4(%eax),%eax
  800643:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800646:	bf 08 00 00 00       	mov    $0x8,%edi
  80064b:	eb 31                	jmp    80067e <vprintfmt+0x403>
			putch('0', putdat);
  80064d:	83 ec 08             	sub    $0x8,%esp
  800650:	53                   	push   %ebx
  800651:	6a 30                	push   $0x30
  800653:	ff d6                	call   *%esi
			putch('x', putdat);
  800655:	83 c4 08             	add    $0x8,%esp
  800658:	53                   	push   %ebx
  800659:	6a 78                	push   $0x78
  80065b:	ff d6                	call   *%esi
			num = (unsigned long long)
  80065d:	8b 45 14             	mov    0x14(%ebp),%eax
  800660:	8b 00                	mov    (%eax),%eax
  800662:	ba 00 00 00 00       	mov    $0x0,%edx
  800667:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80066a:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80066d:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800670:	8b 45 14             	mov    0x14(%ebp),%eax
  800673:	8d 40 04             	lea    0x4(%eax),%eax
  800676:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800679:	bf 10 00 00 00       	mov    $0x10,%edi
			if(posflag)
  80067e:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800682:	74 0b                	je     80068f <vprintfmt+0x414>
				putch('+', putdat);
  800684:	83 ec 08             	sub    $0x8,%esp
  800687:	53                   	push   %ebx
  800688:	6a 2b                	push   $0x2b
  80068a:	ff d6                	call   *%esi
  80068c:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  80068f:	83 ec 0c             	sub    $0xc,%esp
  800692:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800696:	50                   	push   %eax
  800697:	ff 75 e0             	pushl  -0x20(%ebp)
  80069a:	57                   	push   %edi
  80069b:	ff 75 dc             	pushl  -0x24(%ebp)
  80069e:	ff 75 d8             	pushl  -0x28(%ebp)
  8006a1:	89 da                	mov    %ebx,%edx
  8006a3:	89 f0                	mov    %esi,%eax
  8006a5:	e8 b8 fa ff ff       	call   800162 <printnum>
			break;
  8006aa:	83 c4 20             	add    $0x20,%esp
			char* cp = va_arg(ap, char *);
  8006ad:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006b0:	83 c7 01             	add    $0x1,%edi
  8006b3:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006b7:	83 f8 25             	cmp    $0x25,%eax
  8006ba:	0f 84 d2 fb ff ff    	je     800292 <vprintfmt+0x17>
			if (ch == '\0')
  8006c0:	85 c0                	test   %eax,%eax
  8006c2:	0f 84 03 01 00 00    	je     8007cb <vprintfmt+0x550>
			putch(ch, putdat);
  8006c8:	83 ec 08             	sub    $0x8,%esp
  8006cb:	53                   	push   %ebx
  8006cc:	50                   	push   %eax
  8006cd:	ff d6                	call   *%esi
  8006cf:	83 c4 10             	add    $0x10,%esp
  8006d2:	eb dc                	jmp    8006b0 <vprintfmt+0x435>
	if (lflag >= 2)
  8006d4:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8006d8:	7f 29                	jg     800703 <vprintfmt+0x488>
	else if (lflag)
  8006da:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8006de:	74 44                	je     800724 <vprintfmt+0x4a9>
		return va_arg(*ap, unsigned long);
  8006e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e3:	8b 00                	mov    (%eax),%eax
  8006e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ea:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ed:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f3:	8d 40 04             	lea    0x4(%eax),%eax
  8006f6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006f9:	bf 10 00 00 00       	mov    $0x10,%edi
  8006fe:	e9 7b ff ff ff       	jmp    80067e <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  800703:	8b 45 14             	mov    0x14(%ebp),%eax
  800706:	8b 50 04             	mov    0x4(%eax),%edx
  800709:	8b 00                	mov    (%eax),%eax
  80070b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80070e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800711:	8b 45 14             	mov    0x14(%ebp),%eax
  800714:	8d 40 08             	lea    0x8(%eax),%eax
  800717:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80071a:	bf 10 00 00 00       	mov    $0x10,%edi
  80071f:	e9 5a ff ff ff       	jmp    80067e <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  800724:	8b 45 14             	mov    0x14(%ebp),%eax
  800727:	8b 00                	mov    (%eax),%eax
  800729:	ba 00 00 00 00       	mov    $0x0,%edx
  80072e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800731:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800734:	8b 45 14             	mov    0x14(%ebp),%eax
  800737:	8d 40 04             	lea    0x4(%eax),%eax
  80073a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80073d:	bf 10 00 00 00       	mov    $0x10,%edi
  800742:	e9 37 ff ff ff       	jmp    80067e <vprintfmt+0x403>
			char* cp = va_arg(ap, char *);
  800747:	8b 45 14             	mov    0x14(%ebp),%eax
  80074a:	8d 78 04             	lea    0x4(%eax),%edi
  80074d:	8b 00                	mov    (%eax),%eax
    			if (cp == NULL) {
  80074f:	85 c0                	test   %eax,%eax
  800751:	74 2c                	je     80077f <vprintfmt+0x504>
    			*cp = *(int *)putdat;
  800753:	8b 13                	mov    (%ebx),%edx
  800755:	88 10                	mov    %dl,(%eax)
			char* cp = va_arg(ap, char *);
  800757:	89 7d 14             	mov    %edi,0x14(%ebp)
    			if ((*(int *) putdat) > 127)
  80075a:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  80075d:	0f 8e 4a ff ff ff    	jle    8006ad <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", overflow_error);
  800763:	68 e0 12 80 00       	push   $0x8012e0
  800768:	68 90 11 80 00       	push   $0x801190
  80076d:	53                   	push   %ebx
  80076e:	56                   	push   %esi
  80076f:	e8 ea fa ff ff       	call   80025e <printfmt>
  800774:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  800777:	89 7d 14             	mov    %edi,0x14(%ebp)
  80077a:	e9 2e ff ff ff       	jmp    8006ad <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", null_error);
  80077f:	68 a8 12 80 00       	push   $0x8012a8
  800784:	68 90 11 80 00       	push   $0x801190
  800789:	53                   	push   %ebx
  80078a:	56                   	push   %esi
  80078b:	e8 ce fa ff ff       	call   80025e <printfmt>
        		break;
  800790:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  800793:	89 7d 14             	mov    %edi,0x14(%ebp)
        		break;
  800796:	e9 12 ff ff ff       	jmp    8006ad <vprintfmt+0x432>
			putch(ch, putdat);
  80079b:	83 ec 08             	sub    $0x8,%esp
  80079e:	53                   	push   %ebx
  80079f:	6a 25                	push   $0x25
  8007a1:	ff d6                	call   *%esi
			break;
  8007a3:	83 c4 10             	add    $0x10,%esp
  8007a6:	e9 02 ff ff ff       	jmp    8006ad <vprintfmt+0x432>
			putch('%', putdat);
  8007ab:	83 ec 08             	sub    $0x8,%esp
  8007ae:	53                   	push   %ebx
  8007af:	6a 25                	push   $0x25
  8007b1:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007b3:	83 c4 10             	add    $0x10,%esp
  8007b6:	89 f8                	mov    %edi,%eax
  8007b8:	eb 03                	jmp    8007bd <vprintfmt+0x542>
  8007ba:	83 e8 01             	sub    $0x1,%eax
  8007bd:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8007c1:	75 f7                	jne    8007ba <vprintfmt+0x53f>
  8007c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007c6:	e9 e2 fe ff ff       	jmp    8006ad <vprintfmt+0x432>
}
  8007cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007ce:	5b                   	pop    %ebx
  8007cf:	5e                   	pop    %esi
  8007d0:	5f                   	pop    %edi
  8007d1:	5d                   	pop    %ebp
  8007d2:	c3                   	ret    

008007d3 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007d3:	55                   	push   %ebp
  8007d4:	89 e5                	mov    %esp,%ebp
  8007d6:	83 ec 18             	sub    $0x18,%esp
  8007d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007dc:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007df:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007e2:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007e6:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007e9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007f0:	85 c0                	test   %eax,%eax
  8007f2:	74 26                	je     80081a <vsnprintf+0x47>
  8007f4:	85 d2                	test   %edx,%edx
  8007f6:	7e 22                	jle    80081a <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007f8:	ff 75 14             	pushl  0x14(%ebp)
  8007fb:	ff 75 10             	pushl  0x10(%ebp)
  8007fe:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800801:	50                   	push   %eax
  800802:	68 41 02 80 00       	push   $0x800241
  800807:	e8 6f fa ff ff       	call   80027b <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80080c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80080f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800812:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800815:	83 c4 10             	add    $0x10,%esp
}
  800818:	c9                   	leave  
  800819:	c3                   	ret    
		return -E_INVAL;
  80081a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80081f:	eb f7                	jmp    800818 <vsnprintf+0x45>

00800821 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800821:	55                   	push   %ebp
  800822:	89 e5                	mov    %esp,%ebp
  800824:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800827:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80082a:	50                   	push   %eax
  80082b:	ff 75 10             	pushl  0x10(%ebp)
  80082e:	ff 75 0c             	pushl  0xc(%ebp)
  800831:	ff 75 08             	pushl  0x8(%ebp)
  800834:	e8 9a ff ff ff       	call   8007d3 <vsnprintf>
	va_end(ap);

	return rc;
}
  800839:	c9                   	leave  
  80083a:	c3                   	ret    

0080083b <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80083b:	55                   	push   %ebp
  80083c:	89 e5                	mov    %esp,%ebp
  80083e:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800841:	b8 00 00 00 00       	mov    $0x0,%eax
  800846:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80084a:	74 05                	je     800851 <strlen+0x16>
		n++;
  80084c:	83 c0 01             	add    $0x1,%eax
  80084f:	eb f5                	jmp    800846 <strlen+0xb>
	return n;
}
  800851:	5d                   	pop    %ebp
  800852:	c3                   	ret    

00800853 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800853:	55                   	push   %ebp
  800854:	89 e5                	mov    %esp,%ebp
  800856:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800859:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80085c:	ba 00 00 00 00       	mov    $0x0,%edx
  800861:	39 c2                	cmp    %eax,%edx
  800863:	74 0d                	je     800872 <strnlen+0x1f>
  800865:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800869:	74 05                	je     800870 <strnlen+0x1d>
		n++;
  80086b:	83 c2 01             	add    $0x1,%edx
  80086e:	eb f1                	jmp    800861 <strnlen+0xe>
  800870:	89 d0                	mov    %edx,%eax
	return n;
}
  800872:	5d                   	pop    %ebp
  800873:	c3                   	ret    

00800874 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800874:	55                   	push   %ebp
  800875:	89 e5                	mov    %esp,%ebp
  800877:	53                   	push   %ebx
  800878:	8b 45 08             	mov    0x8(%ebp),%eax
  80087b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80087e:	ba 00 00 00 00       	mov    $0x0,%edx
  800883:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800887:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  80088a:	83 c2 01             	add    $0x1,%edx
  80088d:	84 c9                	test   %cl,%cl
  80088f:	75 f2                	jne    800883 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800891:	5b                   	pop    %ebx
  800892:	5d                   	pop    %ebp
  800893:	c3                   	ret    

00800894 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800894:	55                   	push   %ebp
  800895:	89 e5                	mov    %esp,%ebp
  800897:	53                   	push   %ebx
  800898:	83 ec 10             	sub    $0x10,%esp
  80089b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80089e:	53                   	push   %ebx
  80089f:	e8 97 ff ff ff       	call   80083b <strlen>
  8008a4:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8008a7:	ff 75 0c             	pushl  0xc(%ebp)
  8008aa:	01 d8                	add    %ebx,%eax
  8008ac:	50                   	push   %eax
  8008ad:	e8 c2 ff ff ff       	call   800874 <strcpy>
	return dst;
}
  8008b2:	89 d8                	mov    %ebx,%eax
  8008b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008b7:	c9                   	leave  
  8008b8:	c3                   	ret    

008008b9 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008b9:	55                   	push   %ebp
  8008ba:	89 e5                	mov    %esp,%ebp
  8008bc:	56                   	push   %esi
  8008bd:	53                   	push   %ebx
  8008be:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008c4:	89 c6                	mov    %eax,%esi
  8008c6:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008c9:	89 c2                	mov    %eax,%edx
  8008cb:	39 f2                	cmp    %esi,%edx
  8008cd:	74 11                	je     8008e0 <strncpy+0x27>
		*dst++ = *src;
  8008cf:	83 c2 01             	add    $0x1,%edx
  8008d2:	0f b6 19             	movzbl (%ecx),%ebx
  8008d5:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008d8:	80 fb 01             	cmp    $0x1,%bl
  8008db:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8008de:	eb eb                	jmp    8008cb <strncpy+0x12>
	}
	return ret;
}
  8008e0:	5b                   	pop    %ebx
  8008e1:	5e                   	pop    %esi
  8008e2:	5d                   	pop    %ebp
  8008e3:	c3                   	ret    

008008e4 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008e4:	55                   	push   %ebp
  8008e5:	89 e5                	mov    %esp,%ebp
  8008e7:	56                   	push   %esi
  8008e8:	53                   	push   %ebx
  8008e9:	8b 75 08             	mov    0x8(%ebp),%esi
  8008ec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008ef:	8b 55 10             	mov    0x10(%ebp),%edx
  8008f2:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008f4:	85 d2                	test   %edx,%edx
  8008f6:	74 21                	je     800919 <strlcpy+0x35>
  8008f8:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8008fc:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8008fe:	39 c2                	cmp    %eax,%edx
  800900:	74 14                	je     800916 <strlcpy+0x32>
  800902:	0f b6 19             	movzbl (%ecx),%ebx
  800905:	84 db                	test   %bl,%bl
  800907:	74 0b                	je     800914 <strlcpy+0x30>
			*dst++ = *src++;
  800909:	83 c1 01             	add    $0x1,%ecx
  80090c:	83 c2 01             	add    $0x1,%edx
  80090f:	88 5a ff             	mov    %bl,-0x1(%edx)
  800912:	eb ea                	jmp    8008fe <strlcpy+0x1a>
  800914:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800916:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800919:	29 f0                	sub    %esi,%eax
}
  80091b:	5b                   	pop    %ebx
  80091c:	5e                   	pop    %esi
  80091d:	5d                   	pop    %ebp
  80091e:	c3                   	ret    

0080091f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80091f:	55                   	push   %ebp
  800920:	89 e5                	mov    %esp,%ebp
  800922:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800925:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800928:	0f b6 01             	movzbl (%ecx),%eax
  80092b:	84 c0                	test   %al,%al
  80092d:	74 0c                	je     80093b <strcmp+0x1c>
  80092f:	3a 02                	cmp    (%edx),%al
  800931:	75 08                	jne    80093b <strcmp+0x1c>
		p++, q++;
  800933:	83 c1 01             	add    $0x1,%ecx
  800936:	83 c2 01             	add    $0x1,%edx
  800939:	eb ed                	jmp    800928 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80093b:	0f b6 c0             	movzbl %al,%eax
  80093e:	0f b6 12             	movzbl (%edx),%edx
  800941:	29 d0                	sub    %edx,%eax
}
  800943:	5d                   	pop    %ebp
  800944:	c3                   	ret    

00800945 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800945:	55                   	push   %ebp
  800946:	89 e5                	mov    %esp,%ebp
  800948:	53                   	push   %ebx
  800949:	8b 45 08             	mov    0x8(%ebp),%eax
  80094c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80094f:	89 c3                	mov    %eax,%ebx
  800951:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800954:	eb 06                	jmp    80095c <strncmp+0x17>
		n--, p++, q++;
  800956:	83 c0 01             	add    $0x1,%eax
  800959:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80095c:	39 d8                	cmp    %ebx,%eax
  80095e:	74 16                	je     800976 <strncmp+0x31>
  800960:	0f b6 08             	movzbl (%eax),%ecx
  800963:	84 c9                	test   %cl,%cl
  800965:	74 04                	je     80096b <strncmp+0x26>
  800967:	3a 0a                	cmp    (%edx),%cl
  800969:	74 eb                	je     800956 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80096b:	0f b6 00             	movzbl (%eax),%eax
  80096e:	0f b6 12             	movzbl (%edx),%edx
  800971:	29 d0                	sub    %edx,%eax
}
  800973:	5b                   	pop    %ebx
  800974:	5d                   	pop    %ebp
  800975:	c3                   	ret    
		return 0;
  800976:	b8 00 00 00 00       	mov    $0x0,%eax
  80097b:	eb f6                	jmp    800973 <strncmp+0x2e>

0080097d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80097d:	55                   	push   %ebp
  80097e:	89 e5                	mov    %esp,%ebp
  800980:	8b 45 08             	mov    0x8(%ebp),%eax
  800983:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800987:	0f b6 10             	movzbl (%eax),%edx
  80098a:	84 d2                	test   %dl,%dl
  80098c:	74 09                	je     800997 <strchr+0x1a>
		if (*s == c)
  80098e:	38 ca                	cmp    %cl,%dl
  800990:	74 0a                	je     80099c <strchr+0x1f>
	for (; *s; s++)
  800992:	83 c0 01             	add    $0x1,%eax
  800995:	eb f0                	jmp    800987 <strchr+0xa>
			return (char *) s;
	return 0;
  800997:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80099c:	5d                   	pop    %ebp
  80099d:	c3                   	ret    

0080099e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80099e:	55                   	push   %ebp
  80099f:	89 e5                	mov    %esp,%ebp
  8009a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009a8:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009ab:	38 ca                	cmp    %cl,%dl
  8009ad:	74 09                	je     8009b8 <strfind+0x1a>
  8009af:	84 d2                	test   %dl,%dl
  8009b1:	74 05                	je     8009b8 <strfind+0x1a>
	for (; *s; s++)
  8009b3:	83 c0 01             	add    $0x1,%eax
  8009b6:	eb f0                	jmp    8009a8 <strfind+0xa>
			break;
	return (char *) s;
}
  8009b8:	5d                   	pop    %ebp
  8009b9:	c3                   	ret    

008009ba <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009ba:	55                   	push   %ebp
  8009bb:	89 e5                	mov    %esp,%ebp
  8009bd:	57                   	push   %edi
  8009be:	56                   	push   %esi
  8009bf:	53                   	push   %ebx
  8009c0:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009c3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009c6:	85 c9                	test   %ecx,%ecx
  8009c8:	74 31                	je     8009fb <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009ca:	89 f8                	mov    %edi,%eax
  8009cc:	09 c8                	or     %ecx,%eax
  8009ce:	a8 03                	test   $0x3,%al
  8009d0:	75 23                	jne    8009f5 <memset+0x3b>
		c &= 0xFF;
  8009d2:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009d6:	89 d3                	mov    %edx,%ebx
  8009d8:	c1 e3 08             	shl    $0x8,%ebx
  8009db:	89 d0                	mov    %edx,%eax
  8009dd:	c1 e0 18             	shl    $0x18,%eax
  8009e0:	89 d6                	mov    %edx,%esi
  8009e2:	c1 e6 10             	shl    $0x10,%esi
  8009e5:	09 f0                	or     %esi,%eax
  8009e7:	09 c2                	or     %eax,%edx
  8009e9:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8009eb:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009ee:	89 d0                	mov    %edx,%eax
  8009f0:	fc                   	cld    
  8009f1:	f3 ab                	rep stos %eax,%es:(%edi)
  8009f3:	eb 06                	jmp    8009fb <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f8:	fc                   	cld    
  8009f9:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009fb:	89 f8                	mov    %edi,%eax
  8009fd:	5b                   	pop    %ebx
  8009fe:	5e                   	pop    %esi
  8009ff:	5f                   	pop    %edi
  800a00:	5d                   	pop    %ebp
  800a01:	c3                   	ret    

00800a02 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a02:	55                   	push   %ebp
  800a03:	89 e5                	mov    %esp,%ebp
  800a05:	57                   	push   %edi
  800a06:	56                   	push   %esi
  800a07:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0a:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a0d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a10:	39 c6                	cmp    %eax,%esi
  800a12:	73 32                	jae    800a46 <memmove+0x44>
  800a14:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a17:	39 c2                	cmp    %eax,%edx
  800a19:	76 2b                	jbe    800a46 <memmove+0x44>
		s += n;
		d += n;
  800a1b:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a1e:	89 fe                	mov    %edi,%esi
  800a20:	09 ce                	or     %ecx,%esi
  800a22:	09 d6                	or     %edx,%esi
  800a24:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a2a:	75 0e                	jne    800a3a <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a2c:	83 ef 04             	sub    $0x4,%edi
  800a2f:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a32:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a35:	fd                   	std    
  800a36:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a38:	eb 09                	jmp    800a43 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a3a:	83 ef 01             	sub    $0x1,%edi
  800a3d:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a40:	fd                   	std    
  800a41:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a43:	fc                   	cld    
  800a44:	eb 1a                	jmp    800a60 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a46:	89 c2                	mov    %eax,%edx
  800a48:	09 ca                	or     %ecx,%edx
  800a4a:	09 f2                	or     %esi,%edx
  800a4c:	f6 c2 03             	test   $0x3,%dl
  800a4f:	75 0a                	jne    800a5b <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a51:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a54:	89 c7                	mov    %eax,%edi
  800a56:	fc                   	cld    
  800a57:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a59:	eb 05                	jmp    800a60 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800a5b:	89 c7                	mov    %eax,%edi
  800a5d:	fc                   	cld    
  800a5e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a60:	5e                   	pop    %esi
  800a61:	5f                   	pop    %edi
  800a62:	5d                   	pop    %ebp
  800a63:	c3                   	ret    

00800a64 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a64:	55                   	push   %ebp
  800a65:	89 e5                	mov    %esp,%ebp
  800a67:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a6a:	ff 75 10             	pushl  0x10(%ebp)
  800a6d:	ff 75 0c             	pushl  0xc(%ebp)
  800a70:	ff 75 08             	pushl  0x8(%ebp)
  800a73:	e8 8a ff ff ff       	call   800a02 <memmove>
}
  800a78:	c9                   	leave  
  800a79:	c3                   	ret    

00800a7a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a7a:	55                   	push   %ebp
  800a7b:	89 e5                	mov    %esp,%ebp
  800a7d:	56                   	push   %esi
  800a7e:	53                   	push   %ebx
  800a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a82:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a85:	89 c6                	mov    %eax,%esi
  800a87:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a8a:	39 f0                	cmp    %esi,%eax
  800a8c:	74 1c                	je     800aaa <memcmp+0x30>
		if (*s1 != *s2)
  800a8e:	0f b6 08             	movzbl (%eax),%ecx
  800a91:	0f b6 1a             	movzbl (%edx),%ebx
  800a94:	38 d9                	cmp    %bl,%cl
  800a96:	75 08                	jne    800aa0 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a98:	83 c0 01             	add    $0x1,%eax
  800a9b:	83 c2 01             	add    $0x1,%edx
  800a9e:	eb ea                	jmp    800a8a <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800aa0:	0f b6 c1             	movzbl %cl,%eax
  800aa3:	0f b6 db             	movzbl %bl,%ebx
  800aa6:	29 d8                	sub    %ebx,%eax
  800aa8:	eb 05                	jmp    800aaf <memcmp+0x35>
	}

	return 0;
  800aaa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800aaf:	5b                   	pop    %ebx
  800ab0:	5e                   	pop    %esi
  800ab1:	5d                   	pop    %ebp
  800ab2:	c3                   	ret    

00800ab3 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ab3:	55                   	push   %ebp
  800ab4:	89 e5                	mov    %esp,%ebp
  800ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800abc:	89 c2                	mov    %eax,%edx
  800abe:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ac1:	39 d0                	cmp    %edx,%eax
  800ac3:	73 09                	jae    800ace <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ac5:	38 08                	cmp    %cl,(%eax)
  800ac7:	74 05                	je     800ace <memfind+0x1b>
	for (; s < ends; s++)
  800ac9:	83 c0 01             	add    $0x1,%eax
  800acc:	eb f3                	jmp    800ac1 <memfind+0xe>
			break;
	return (void *) s;
}
  800ace:	5d                   	pop    %ebp
  800acf:	c3                   	ret    

00800ad0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ad0:	55                   	push   %ebp
  800ad1:	89 e5                	mov    %esp,%ebp
  800ad3:	57                   	push   %edi
  800ad4:	56                   	push   %esi
  800ad5:	53                   	push   %ebx
  800ad6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ad9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800adc:	eb 03                	jmp    800ae1 <strtol+0x11>
		s++;
  800ade:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ae1:	0f b6 01             	movzbl (%ecx),%eax
  800ae4:	3c 20                	cmp    $0x20,%al
  800ae6:	74 f6                	je     800ade <strtol+0xe>
  800ae8:	3c 09                	cmp    $0x9,%al
  800aea:	74 f2                	je     800ade <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800aec:	3c 2b                	cmp    $0x2b,%al
  800aee:	74 2a                	je     800b1a <strtol+0x4a>
	int neg = 0;
  800af0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800af5:	3c 2d                	cmp    $0x2d,%al
  800af7:	74 2b                	je     800b24 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800af9:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800aff:	75 0f                	jne    800b10 <strtol+0x40>
  800b01:	80 39 30             	cmpb   $0x30,(%ecx)
  800b04:	74 28                	je     800b2e <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b06:	85 db                	test   %ebx,%ebx
  800b08:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b0d:	0f 44 d8             	cmove  %eax,%ebx
  800b10:	b8 00 00 00 00       	mov    $0x0,%eax
  800b15:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b18:	eb 50                	jmp    800b6a <strtol+0x9a>
		s++;
  800b1a:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b1d:	bf 00 00 00 00       	mov    $0x0,%edi
  800b22:	eb d5                	jmp    800af9 <strtol+0x29>
		s++, neg = 1;
  800b24:	83 c1 01             	add    $0x1,%ecx
  800b27:	bf 01 00 00 00       	mov    $0x1,%edi
  800b2c:	eb cb                	jmp    800af9 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b2e:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b32:	74 0e                	je     800b42 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800b34:	85 db                	test   %ebx,%ebx
  800b36:	75 d8                	jne    800b10 <strtol+0x40>
		s++, base = 8;
  800b38:	83 c1 01             	add    $0x1,%ecx
  800b3b:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b40:	eb ce                	jmp    800b10 <strtol+0x40>
		s += 2, base = 16;
  800b42:	83 c1 02             	add    $0x2,%ecx
  800b45:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b4a:	eb c4                	jmp    800b10 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b4c:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b4f:	89 f3                	mov    %esi,%ebx
  800b51:	80 fb 19             	cmp    $0x19,%bl
  800b54:	77 29                	ja     800b7f <strtol+0xaf>
			dig = *s - 'a' + 10;
  800b56:	0f be d2             	movsbl %dl,%edx
  800b59:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b5c:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b5f:	7d 30                	jge    800b91 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800b61:	83 c1 01             	add    $0x1,%ecx
  800b64:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b68:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b6a:	0f b6 11             	movzbl (%ecx),%edx
  800b6d:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b70:	89 f3                	mov    %esi,%ebx
  800b72:	80 fb 09             	cmp    $0x9,%bl
  800b75:	77 d5                	ja     800b4c <strtol+0x7c>
			dig = *s - '0';
  800b77:	0f be d2             	movsbl %dl,%edx
  800b7a:	83 ea 30             	sub    $0x30,%edx
  800b7d:	eb dd                	jmp    800b5c <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800b7f:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b82:	89 f3                	mov    %esi,%ebx
  800b84:	80 fb 19             	cmp    $0x19,%bl
  800b87:	77 08                	ja     800b91 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800b89:	0f be d2             	movsbl %dl,%edx
  800b8c:	83 ea 37             	sub    $0x37,%edx
  800b8f:	eb cb                	jmp    800b5c <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b91:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b95:	74 05                	je     800b9c <strtol+0xcc>
		*endptr = (char *) s;
  800b97:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b9a:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b9c:	89 c2                	mov    %eax,%edx
  800b9e:	f7 da                	neg    %edx
  800ba0:	85 ff                	test   %edi,%edi
  800ba2:	0f 45 c2             	cmovne %edx,%eax
}
  800ba5:	5b                   	pop    %ebx
  800ba6:	5e                   	pop    %esi
  800ba7:	5f                   	pop    %edi
  800ba8:	5d                   	pop    %ebp
  800ba9:	c3                   	ret    

00800baa <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800baa:	55                   	push   %ebp
  800bab:	89 e5                	mov    %esp,%ebp
  800bad:	57                   	push   %edi
  800bae:	56                   	push   %esi
  800baf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bb0:	b8 00 00 00 00       	mov    $0x0,%eax
  800bb5:	8b 55 08             	mov    0x8(%ebp),%edx
  800bb8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bbb:	89 c3                	mov    %eax,%ebx
  800bbd:	89 c7                	mov    %eax,%edi
  800bbf:	89 c6                	mov    %eax,%esi
  800bc1:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bc3:	5b                   	pop    %ebx
  800bc4:	5e                   	pop    %esi
  800bc5:	5f                   	pop    %edi
  800bc6:	5d                   	pop    %ebp
  800bc7:	c3                   	ret    

00800bc8 <sys_cgetc>:

int
sys_cgetc(void)
{
  800bc8:	55                   	push   %ebp
  800bc9:	89 e5                	mov    %esp,%ebp
  800bcb:	57                   	push   %edi
  800bcc:	56                   	push   %esi
  800bcd:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bce:	ba 00 00 00 00       	mov    $0x0,%edx
  800bd3:	b8 01 00 00 00       	mov    $0x1,%eax
  800bd8:	89 d1                	mov    %edx,%ecx
  800bda:	89 d3                	mov    %edx,%ebx
  800bdc:	89 d7                	mov    %edx,%edi
  800bde:	89 d6                	mov    %edx,%esi
  800be0:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800be2:	5b                   	pop    %ebx
  800be3:	5e                   	pop    %esi
  800be4:	5f                   	pop    %edi
  800be5:	5d                   	pop    %ebp
  800be6:	c3                   	ret    

00800be7 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800be7:	55                   	push   %ebp
  800be8:	89 e5                	mov    %esp,%ebp
  800bea:	57                   	push   %edi
  800beb:	56                   	push   %esi
  800bec:	53                   	push   %ebx
  800bed:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bf0:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bf5:	8b 55 08             	mov    0x8(%ebp),%edx
  800bf8:	b8 03 00 00 00       	mov    $0x3,%eax
  800bfd:	89 cb                	mov    %ecx,%ebx
  800bff:	89 cf                	mov    %ecx,%edi
  800c01:	89 ce                	mov    %ecx,%esi
  800c03:	cd 30                	int    $0x30
	if (check && ret > 0)
  800c05:	85 c0                	test   %eax,%eax
  800c07:	7f 08                	jg     800c11 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c09:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c0c:	5b                   	pop    %ebx
  800c0d:	5e                   	pop    %esi
  800c0e:	5f                   	pop    %edi
  800c0f:	5d                   	pop    %ebp
  800c10:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c11:	83 ec 0c             	sub    $0xc,%esp
  800c14:	50                   	push   %eax
  800c15:	6a 03                	push   $0x3
  800c17:	68 00 15 80 00       	push   $0x801500
  800c1c:	6a 4c                	push   $0x4c
  800c1e:	68 1d 15 80 00       	push   $0x80151d
  800c23:	e8 70 02 00 00       	call   800e98 <_panic>

00800c28 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c28:	55                   	push   %ebp
  800c29:	89 e5                	mov    %esp,%ebp
  800c2b:	57                   	push   %edi
  800c2c:	56                   	push   %esi
  800c2d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c2e:	ba 00 00 00 00       	mov    $0x0,%edx
  800c33:	b8 02 00 00 00       	mov    $0x2,%eax
  800c38:	89 d1                	mov    %edx,%ecx
  800c3a:	89 d3                	mov    %edx,%ebx
  800c3c:	89 d7                	mov    %edx,%edi
  800c3e:	89 d6                	mov    %edx,%esi
  800c40:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c42:	5b                   	pop    %ebx
  800c43:	5e                   	pop    %esi
  800c44:	5f                   	pop    %edi
  800c45:	5d                   	pop    %ebp
  800c46:	c3                   	ret    

00800c47 <sys_yield>:

void
sys_yield(void)
{
  800c47:	55                   	push   %ebp
  800c48:	89 e5                	mov    %esp,%ebp
  800c4a:	57                   	push   %edi
  800c4b:	56                   	push   %esi
  800c4c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c4d:	ba 00 00 00 00       	mov    $0x0,%edx
  800c52:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c57:	89 d1                	mov    %edx,%ecx
  800c59:	89 d3                	mov    %edx,%ebx
  800c5b:	89 d7                	mov    %edx,%edi
  800c5d:	89 d6                	mov    %edx,%esi
  800c5f:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c61:	5b                   	pop    %ebx
  800c62:	5e                   	pop    %esi
  800c63:	5f                   	pop    %edi
  800c64:	5d                   	pop    %ebp
  800c65:	c3                   	ret    

00800c66 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c66:	55                   	push   %ebp
  800c67:	89 e5                	mov    %esp,%ebp
  800c69:	57                   	push   %edi
  800c6a:	56                   	push   %esi
  800c6b:	53                   	push   %ebx
  800c6c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c6f:	be 00 00 00 00       	mov    $0x0,%esi
  800c74:	8b 55 08             	mov    0x8(%ebp),%edx
  800c77:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c7a:	b8 04 00 00 00       	mov    $0x4,%eax
  800c7f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c82:	89 f7                	mov    %esi,%edi
  800c84:	cd 30                	int    $0x30
	if (check && ret > 0)
  800c86:	85 c0                	test   %eax,%eax
  800c88:	7f 08                	jg     800c92 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c8a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c8d:	5b                   	pop    %ebx
  800c8e:	5e                   	pop    %esi
  800c8f:	5f                   	pop    %edi
  800c90:	5d                   	pop    %ebp
  800c91:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c92:	83 ec 0c             	sub    $0xc,%esp
  800c95:	50                   	push   %eax
  800c96:	6a 04                	push   $0x4
  800c98:	68 00 15 80 00       	push   $0x801500
  800c9d:	6a 4c                	push   $0x4c
  800c9f:	68 1d 15 80 00       	push   $0x80151d
  800ca4:	e8 ef 01 00 00       	call   800e98 <_panic>

00800ca9 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ca9:	55                   	push   %ebp
  800caa:	89 e5                	mov    %esp,%ebp
  800cac:	57                   	push   %edi
  800cad:	56                   	push   %esi
  800cae:	53                   	push   %ebx
  800caf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cb2:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb8:	b8 05 00 00 00       	mov    $0x5,%eax
  800cbd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cc0:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cc3:	8b 75 18             	mov    0x18(%ebp),%esi
  800cc6:	cd 30                	int    $0x30
	if (check && ret > 0)
  800cc8:	85 c0                	test   %eax,%eax
  800cca:	7f 08                	jg     800cd4 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ccc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ccf:	5b                   	pop    %ebx
  800cd0:	5e                   	pop    %esi
  800cd1:	5f                   	pop    %edi
  800cd2:	5d                   	pop    %ebp
  800cd3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cd4:	83 ec 0c             	sub    $0xc,%esp
  800cd7:	50                   	push   %eax
  800cd8:	6a 05                	push   $0x5
  800cda:	68 00 15 80 00       	push   $0x801500
  800cdf:	6a 4c                	push   $0x4c
  800ce1:	68 1d 15 80 00       	push   $0x80151d
  800ce6:	e8 ad 01 00 00       	call   800e98 <_panic>

00800ceb <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ceb:	55                   	push   %ebp
  800cec:	89 e5                	mov    %esp,%ebp
  800cee:	57                   	push   %edi
  800cef:	56                   	push   %esi
  800cf0:	53                   	push   %ebx
  800cf1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cf4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cf9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cfc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cff:	b8 06 00 00 00       	mov    $0x6,%eax
  800d04:	89 df                	mov    %ebx,%edi
  800d06:	89 de                	mov    %ebx,%esi
  800d08:	cd 30                	int    $0x30
	if (check && ret > 0)
  800d0a:	85 c0                	test   %eax,%eax
  800d0c:	7f 08                	jg     800d16 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d11:	5b                   	pop    %ebx
  800d12:	5e                   	pop    %esi
  800d13:	5f                   	pop    %edi
  800d14:	5d                   	pop    %ebp
  800d15:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d16:	83 ec 0c             	sub    $0xc,%esp
  800d19:	50                   	push   %eax
  800d1a:	6a 06                	push   $0x6
  800d1c:	68 00 15 80 00       	push   $0x801500
  800d21:	6a 4c                	push   $0x4c
  800d23:	68 1d 15 80 00       	push   $0x80151d
  800d28:	e8 6b 01 00 00       	call   800e98 <_panic>

00800d2d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d2d:	55                   	push   %ebp
  800d2e:	89 e5                	mov    %esp,%ebp
  800d30:	57                   	push   %edi
  800d31:	56                   	push   %esi
  800d32:	53                   	push   %ebx
  800d33:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d36:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d3b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d3e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d41:	b8 08 00 00 00       	mov    $0x8,%eax
  800d46:	89 df                	mov    %ebx,%edi
  800d48:	89 de                	mov    %ebx,%esi
  800d4a:	cd 30                	int    $0x30
	if (check && ret > 0)
  800d4c:	85 c0                	test   %eax,%eax
  800d4e:	7f 08                	jg     800d58 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d50:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d53:	5b                   	pop    %ebx
  800d54:	5e                   	pop    %esi
  800d55:	5f                   	pop    %edi
  800d56:	5d                   	pop    %ebp
  800d57:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d58:	83 ec 0c             	sub    $0xc,%esp
  800d5b:	50                   	push   %eax
  800d5c:	6a 08                	push   $0x8
  800d5e:	68 00 15 80 00       	push   $0x801500
  800d63:	6a 4c                	push   $0x4c
  800d65:	68 1d 15 80 00       	push   $0x80151d
  800d6a:	e8 29 01 00 00       	call   800e98 <_panic>

00800d6f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d6f:	55                   	push   %ebp
  800d70:	89 e5                	mov    %esp,%ebp
  800d72:	57                   	push   %edi
  800d73:	56                   	push   %esi
  800d74:	53                   	push   %ebx
  800d75:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d78:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d7d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d80:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d83:	b8 09 00 00 00       	mov    $0x9,%eax
  800d88:	89 df                	mov    %ebx,%edi
  800d8a:	89 de                	mov    %ebx,%esi
  800d8c:	cd 30                	int    $0x30
	if (check && ret > 0)
  800d8e:	85 c0                	test   %eax,%eax
  800d90:	7f 08                	jg     800d9a <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d92:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d95:	5b                   	pop    %ebx
  800d96:	5e                   	pop    %esi
  800d97:	5f                   	pop    %edi
  800d98:	5d                   	pop    %ebp
  800d99:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d9a:	83 ec 0c             	sub    $0xc,%esp
  800d9d:	50                   	push   %eax
  800d9e:	6a 09                	push   $0x9
  800da0:	68 00 15 80 00       	push   $0x801500
  800da5:	6a 4c                	push   $0x4c
  800da7:	68 1d 15 80 00       	push   $0x80151d
  800dac:	e8 e7 00 00 00       	call   800e98 <_panic>

00800db1 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800db1:	55                   	push   %ebp
  800db2:	89 e5                	mov    %esp,%ebp
  800db4:	57                   	push   %edi
  800db5:	56                   	push   %esi
  800db6:	53                   	push   %ebx
  800db7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dba:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dbf:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc5:	b8 0a 00 00 00       	mov    $0xa,%eax
  800dca:	89 df                	mov    %ebx,%edi
  800dcc:	89 de                	mov    %ebx,%esi
  800dce:	cd 30                	int    $0x30
	if (check && ret > 0)
  800dd0:	85 c0                	test   %eax,%eax
  800dd2:	7f 08                	jg     800ddc <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800dd4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dd7:	5b                   	pop    %ebx
  800dd8:	5e                   	pop    %esi
  800dd9:	5f                   	pop    %edi
  800dda:	5d                   	pop    %ebp
  800ddb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ddc:	83 ec 0c             	sub    $0xc,%esp
  800ddf:	50                   	push   %eax
  800de0:	6a 0a                	push   $0xa
  800de2:	68 00 15 80 00       	push   $0x801500
  800de7:	6a 4c                	push   $0x4c
  800de9:	68 1d 15 80 00       	push   $0x80151d
  800dee:	e8 a5 00 00 00       	call   800e98 <_panic>

00800df3 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800df3:	55                   	push   %ebp
  800df4:	89 e5                	mov    %esp,%ebp
  800df6:	57                   	push   %edi
  800df7:	56                   	push   %esi
  800df8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800df9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dfc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dff:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e04:	be 00 00 00 00       	mov    $0x0,%esi
  800e09:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e0c:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e0f:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e11:	5b                   	pop    %ebx
  800e12:	5e                   	pop    %esi
  800e13:	5f                   	pop    %edi
  800e14:	5d                   	pop    %ebp
  800e15:	c3                   	ret    

00800e16 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e16:	55                   	push   %ebp
  800e17:	89 e5                	mov    %esp,%ebp
  800e19:	57                   	push   %edi
  800e1a:	56                   	push   %esi
  800e1b:	53                   	push   %ebx
  800e1c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e1f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e24:	8b 55 08             	mov    0x8(%ebp),%edx
  800e27:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e2c:	89 cb                	mov    %ecx,%ebx
  800e2e:	89 cf                	mov    %ecx,%edi
  800e30:	89 ce                	mov    %ecx,%esi
  800e32:	cd 30                	int    $0x30
	if (check && ret > 0)
  800e34:	85 c0                	test   %eax,%eax
  800e36:	7f 08                	jg     800e40 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e38:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e3b:	5b                   	pop    %ebx
  800e3c:	5e                   	pop    %esi
  800e3d:	5f                   	pop    %edi
  800e3e:	5d                   	pop    %ebp
  800e3f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e40:	83 ec 0c             	sub    $0xc,%esp
  800e43:	50                   	push   %eax
  800e44:	6a 0d                	push   $0xd
  800e46:	68 00 15 80 00       	push   $0x801500
  800e4b:	6a 4c                	push   $0x4c
  800e4d:	68 1d 15 80 00       	push   $0x80151d
  800e52:	e8 41 00 00 00       	call   800e98 <_panic>

00800e57 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800e57:	55                   	push   %ebp
  800e58:	89 e5                	mov    %esp,%ebp
  800e5a:	57                   	push   %edi
  800e5b:	56                   	push   %esi
  800e5c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e5d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e62:	8b 55 08             	mov    0x8(%ebp),%edx
  800e65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e68:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e6d:	89 df                	mov    %ebx,%edi
  800e6f:	89 de                	mov    %ebx,%esi
  800e71:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800e73:	5b                   	pop    %ebx
  800e74:	5e                   	pop    %esi
  800e75:	5f                   	pop    %edi
  800e76:	5d                   	pop    %ebp
  800e77:	c3                   	ret    

00800e78 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800e78:	55                   	push   %ebp
  800e79:	89 e5                	mov    %esp,%ebp
  800e7b:	57                   	push   %edi
  800e7c:	56                   	push   %esi
  800e7d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e7e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e83:	8b 55 08             	mov    0x8(%ebp),%edx
  800e86:	b8 0f 00 00 00       	mov    $0xf,%eax
  800e8b:	89 cb                	mov    %ecx,%ebx
  800e8d:	89 cf                	mov    %ecx,%edi
  800e8f:	89 ce                	mov    %ecx,%esi
  800e91:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800e93:	5b                   	pop    %ebx
  800e94:	5e                   	pop    %esi
  800e95:	5f                   	pop    %edi
  800e96:	5d                   	pop    %ebp
  800e97:	c3                   	ret    

00800e98 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800e98:	55                   	push   %ebp
  800e99:	89 e5                	mov    %esp,%ebp
  800e9b:	56                   	push   %esi
  800e9c:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800e9d:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800ea0:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800ea6:	e8 7d fd ff ff       	call   800c28 <sys_getenvid>
  800eab:	83 ec 0c             	sub    $0xc,%esp
  800eae:	ff 75 0c             	pushl  0xc(%ebp)
  800eb1:	ff 75 08             	pushl  0x8(%ebp)
  800eb4:	56                   	push   %esi
  800eb5:	50                   	push   %eax
  800eb6:	68 2c 15 80 00       	push   $0x80152c
  800ebb:	e8 8e f2 ff ff       	call   80014e <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800ec0:	83 c4 18             	add    $0x18,%esp
  800ec3:	53                   	push   %ebx
  800ec4:	ff 75 10             	pushl  0x10(%ebp)
  800ec7:	e8 31 f2 ff ff       	call   8000fd <vcprintf>
	cprintf("\n");
  800ecc:	c7 04 24 4c 11 80 00 	movl   $0x80114c,(%esp)
  800ed3:	e8 76 f2 ff ff       	call   80014e <cprintf>
  800ed8:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800edb:	cc                   	int3   
  800edc:	eb fd                	jmp    800edb <_panic+0x43>
  800ede:	66 90                	xchg   %ax,%ax

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
