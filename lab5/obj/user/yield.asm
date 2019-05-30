
obj/user/yield.debug:     file format elf32-i386


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
  80002c:	e8 69 00 00 00       	call   80009a <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 0c             	sub    $0xc,%esp
	int i;

	cprintf("Hello, I am environment %08x.\n", thisenv->env_id);
  80003a:	a1 04 20 80 00       	mov    0x802004,%eax
  80003f:	8b 40 48             	mov    0x48(%eax),%eax
  800042:	50                   	push   %eax
  800043:	68 80 11 80 00       	push   $0x801180
  800048:	e8 3d 01 00 00       	call   80018a <cprintf>
  80004d:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 5; i++) {
  800050:	bb 00 00 00 00       	mov    $0x0,%ebx
		sys_yield();
  800055:	e8 29 0c 00 00       	call   800c83 <sys_yield>
		cprintf("Back in environment %08x, iteration %d.\n",
			thisenv->env_id, i);
  80005a:	a1 04 20 80 00       	mov    0x802004,%eax
		cprintf("Back in environment %08x, iteration %d.\n",
  80005f:	8b 40 48             	mov    0x48(%eax),%eax
  800062:	83 ec 04             	sub    $0x4,%esp
  800065:	53                   	push   %ebx
  800066:	50                   	push   %eax
  800067:	68 a0 11 80 00       	push   $0x8011a0
  80006c:	e8 19 01 00 00       	call   80018a <cprintf>
	for (i = 0; i < 5; i++) {
  800071:	83 c3 01             	add    $0x1,%ebx
  800074:	83 c4 10             	add    $0x10,%esp
  800077:	83 fb 05             	cmp    $0x5,%ebx
  80007a:	75 d9                	jne    800055 <umain+0x22>
	}
	cprintf("All done in environment %08x.\n", thisenv->env_id);
  80007c:	a1 04 20 80 00       	mov    0x802004,%eax
  800081:	8b 40 48             	mov    0x48(%eax),%eax
  800084:	83 ec 08             	sub    $0x8,%esp
  800087:	50                   	push   %eax
  800088:	68 cc 11 80 00       	push   $0x8011cc
  80008d:	e8 f8 00 00 00       	call   80018a <cprintf>
}
  800092:	83 c4 10             	add    $0x10,%esp
  800095:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800098:	c9                   	leave  
  800099:	c3                   	ret    

0080009a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80009a:	55                   	push   %ebp
  80009b:	89 e5                	mov    %esp,%ebp
  80009d:	56                   	push   %esi
  80009e:	53                   	push   %ebx
  80009f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000a2:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	// thisenv = 0;
	thisenv = &(envs[ENVX(sys_getenvid())]);
  8000a5:	e8 ba 0b 00 00       	call   800c64 <sys_getenvid>
  8000aa:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000af:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8000b5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000ba:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000bf:	85 db                	test   %ebx,%ebx
  8000c1:	7e 07                	jle    8000ca <libmain+0x30>
		binaryname = argv[0];
  8000c3:	8b 06                	mov    (%esi),%eax
  8000c5:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  8000ca:	83 ec 08             	sub    $0x8,%esp
  8000cd:	56                   	push   %esi
  8000ce:	53                   	push   %ebx
  8000cf:	e8 5f ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000d4:	e8 0a 00 00 00       	call   8000e3 <exit>
}
  8000d9:	83 c4 10             	add    $0x10,%esp
  8000dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000df:	5b                   	pop    %ebx
  8000e0:	5e                   	pop    %esi
  8000e1:	5d                   	pop    %ebp
  8000e2:	c3                   	ret    

008000e3 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000e3:	55                   	push   %ebp
  8000e4:	89 e5                	mov    %esp,%ebp
  8000e6:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  8000e9:	6a 00                	push   $0x0
  8000eb:	e8 33 0b 00 00       	call   800c23 <sys_env_destroy>
}
  8000f0:	83 c4 10             	add    $0x10,%esp
  8000f3:	c9                   	leave  
  8000f4:	c3                   	ret    

008000f5 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000f5:	55                   	push   %ebp
  8000f6:	89 e5                	mov    %esp,%ebp
  8000f8:	53                   	push   %ebx
  8000f9:	83 ec 04             	sub    $0x4,%esp
  8000fc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000ff:	8b 13                	mov    (%ebx),%edx
  800101:	8d 42 01             	lea    0x1(%edx),%eax
  800104:	89 03                	mov    %eax,(%ebx)
  800106:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800109:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80010d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800112:	74 09                	je     80011d <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800114:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800118:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80011b:	c9                   	leave  
  80011c:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80011d:	83 ec 08             	sub    $0x8,%esp
  800120:	68 ff 00 00 00       	push   $0xff
  800125:	8d 43 08             	lea    0x8(%ebx),%eax
  800128:	50                   	push   %eax
  800129:	e8 b8 0a 00 00       	call   800be6 <sys_cputs>
		b->idx = 0;
  80012e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800134:	83 c4 10             	add    $0x10,%esp
  800137:	eb db                	jmp    800114 <putch+0x1f>

00800139 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800139:	55                   	push   %ebp
  80013a:	89 e5                	mov    %esp,%ebp
  80013c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800142:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800149:	00 00 00 
	b.cnt = 0;
  80014c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800153:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800156:	ff 75 0c             	pushl  0xc(%ebp)
  800159:	ff 75 08             	pushl  0x8(%ebp)
  80015c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800162:	50                   	push   %eax
  800163:	68 f5 00 80 00       	push   $0x8000f5
  800168:	e8 4a 01 00 00       	call   8002b7 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80016d:	83 c4 08             	add    $0x8,%esp
  800170:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800176:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80017c:	50                   	push   %eax
  80017d:	e8 64 0a 00 00       	call   800be6 <sys_cputs>

	return b.cnt;
}
  800182:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800188:	c9                   	leave  
  800189:	c3                   	ret    

0080018a <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80018a:	55                   	push   %ebp
  80018b:	89 e5                	mov    %esp,%ebp
  80018d:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800190:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800193:	50                   	push   %eax
  800194:	ff 75 08             	pushl  0x8(%ebp)
  800197:	e8 9d ff ff ff       	call   800139 <vcprintf>
	va_end(ap);

	return cnt;
}
  80019c:	c9                   	leave  
  80019d:	c3                   	ret    

0080019e <printnum>:


static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80019e:	55                   	push   %ebp
  80019f:	89 e5                	mov    %esp,%ebp
  8001a1:	57                   	push   %edi
  8001a2:	56                   	push   %esi
  8001a3:	53                   	push   %ebx
  8001a4:	83 ec 1c             	sub    $0x1c,%esp
  8001a7:	89 c6                	mov    %eax,%esi
  8001a9:	89 d7                	mov    %edx,%edi
  8001ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8001ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001b4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8001b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8001ba:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	// to support '-'
	if(padc == '-'){
  8001bd:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8001c1:	74 2c                	je     8001ef <printnum+0x51>
		while (--width > 0)
			putch(' ', putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001c3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001c6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8001cd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8001d0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8001d3:	39 c2                	cmp    %eax,%edx
  8001d5:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8001d8:	73 43                	jae    80021d <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8001da:	83 eb 01             	sub    $0x1,%ebx
  8001dd:	85 db                	test   %ebx,%ebx
  8001df:	7e 6c                	jle    80024d <printnum+0xaf>
			putch(padc, putdat);
  8001e1:	83 ec 08             	sub    $0x8,%esp
  8001e4:	57                   	push   %edi
  8001e5:	ff 75 18             	pushl  0x18(%ebp)
  8001e8:	ff d6                	call   *%esi
  8001ea:	83 c4 10             	add    $0x10,%esp
  8001ed:	eb eb                	jmp    8001da <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8001ef:	83 ec 0c             	sub    $0xc,%esp
  8001f2:	6a 20                	push   $0x20
  8001f4:	6a 00                	push   $0x0
  8001f6:	50                   	push   %eax
  8001f7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001fa:	ff 75 e0             	pushl  -0x20(%ebp)
  8001fd:	89 fa                	mov    %edi,%edx
  8001ff:	89 f0                	mov    %esi,%eax
  800201:	e8 98 ff ff ff       	call   80019e <printnum>
		while (--width > 0)
  800206:	83 c4 20             	add    $0x20,%esp
  800209:	83 eb 01             	sub    $0x1,%ebx
  80020c:	85 db                	test   %ebx,%ebx
  80020e:	7e 65                	jle    800275 <printnum+0xd7>
			putch(' ', putdat);
  800210:	83 ec 08             	sub    $0x8,%esp
  800213:	57                   	push   %edi
  800214:	6a 20                	push   $0x20
  800216:	ff d6                	call   *%esi
  800218:	83 c4 10             	add    $0x10,%esp
  80021b:	eb ec                	jmp    800209 <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80021d:	83 ec 0c             	sub    $0xc,%esp
  800220:	ff 75 18             	pushl  0x18(%ebp)
  800223:	83 eb 01             	sub    $0x1,%ebx
  800226:	53                   	push   %ebx
  800227:	50                   	push   %eax
  800228:	83 ec 08             	sub    $0x8,%esp
  80022b:	ff 75 dc             	pushl  -0x24(%ebp)
  80022e:	ff 75 d8             	pushl  -0x28(%ebp)
  800231:	ff 75 e4             	pushl  -0x1c(%ebp)
  800234:	ff 75 e0             	pushl  -0x20(%ebp)
  800237:	e8 e4 0c 00 00       	call   800f20 <__udivdi3>
  80023c:	83 c4 18             	add    $0x18,%esp
  80023f:	52                   	push   %edx
  800240:	50                   	push   %eax
  800241:	89 fa                	mov    %edi,%edx
  800243:	89 f0                	mov    %esi,%eax
  800245:	e8 54 ff ff ff       	call   80019e <printnum>
  80024a:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80024d:	83 ec 08             	sub    $0x8,%esp
  800250:	57                   	push   %edi
  800251:	83 ec 04             	sub    $0x4,%esp
  800254:	ff 75 dc             	pushl  -0x24(%ebp)
  800257:	ff 75 d8             	pushl  -0x28(%ebp)
  80025a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80025d:	ff 75 e0             	pushl  -0x20(%ebp)
  800260:	e8 cb 0d 00 00       	call   801030 <__umoddi3>
  800265:	83 c4 14             	add    $0x14,%esp
  800268:	0f be 80 f5 11 80 00 	movsbl 0x8011f5(%eax),%eax
  80026f:	50                   	push   %eax
  800270:	ff d6                	call   *%esi
  800272:	83 c4 10             	add    $0x10,%esp
}
  800275:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800278:	5b                   	pop    %ebx
  800279:	5e                   	pop    %esi
  80027a:	5f                   	pop    %edi
  80027b:	5d                   	pop    %ebp
  80027c:	c3                   	ret    

0080027d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80027d:	55                   	push   %ebp
  80027e:	89 e5                	mov    %esp,%ebp
  800280:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800283:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800287:	8b 10                	mov    (%eax),%edx
  800289:	3b 50 04             	cmp    0x4(%eax),%edx
  80028c:	73 0a                	jae    800298 <sprintputch+0x1b>
		*b->buf++ = ch;
  80028e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800291:	89 08                	mov    %ecx,(%eax)
  800293:	8b 45 08             	mov    0x8(%ebp),%eax
  800296:	88 02                	mov    %al,(%edx)
}
  800298:	5d                   	pop    %ebp
  800299:	c3                   	ret    

0080029a <printfmt>:
{
  80029a:	55                   	push   %ebp
  80029b:	89 e5                	mov    %esp,%ebp
  80029d:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002a0:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002a3:	50                   	push   %eax
  8002a4:	ff 75 10             	pushl  0x10(%ebp)
  8002a7:	ff 75 0c             	pushl  0xc(%ebp)
  8002aa:	ff 75 08             	pushl  0x8(%ebp)
  8002ad:	e8 05 00 00 00       	call   8002b7 <vprintfmt>
}
  8002b2:	83 c4 10             	add    $0x10,%esp
  8002b5:	c9                   	leave  
  8002b6:	c3                   	ret    

008002b7 <vprintfmt>:
{
  8002b7:	55                   	push   %ebp
  8002b8:	89 e5                	mov    %esp,%ebp
  8002ba:	57                   	push   %edi
  8002bb:	56                   	push   %esi
  8002bc:	53                   	push   %ebx
  8002bd:	83 ec 3c             	sub    $0x3c,%esp
  8002c0:	8b 75 08             	mov    0x8(%ebp),%esi
  8002c3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002c6:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002c9:	e9 1e 04 00 00       	jmp    8006ec <vprintfmt+0x435>
		posflag = 0;
  8002ce:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
		padc = ' ';
  8002d5:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8002d9:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8002e0:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8002e7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002ee:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  8002f5:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002fa:	8d 47 01             	lea    0x1(%edi),%eax
  8002fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800300:	0f b6 17             	movzbl (%edi),%edx
  800303:	8d 42 dd             	lea    -0x23(%edx),%eax
  800306:	3c 55                	cmp    $0x55,%al
  800308:	0f 87 d9 04 00 00    	ja     8007e7 <vprintfmt+0x530>
  80030e:	0f b6 c0             	movzbl %al,%eax
  800311:	ff 24 85 e0 13 80 00 	jmp    *0x8013e0(,%eax,4)
  800318:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80031b:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80031f:	eb d9                	jmp    8002fa <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800321:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posflag = 1;
  800324:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  80032b:	eb cd                	jmp    8002fa <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80032d:	0f b6 d2             	movzbl %dl,%edx
  800330:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800333:	b8 00 00 00 00       	mov    $0x0,%eax
  800338:	89 75 08             	mov    %esi,0x8(%ebp)
  80033b:	eb 0c                	jmp    800349 <vprintfmt+0x92>
		switch (ch = *(unsigned char *) fmt++) {
  80033d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800340:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  800344:	eb b4                	jmp    8002fa <vprintfmt+0x43>
			for (precision = 0; ; ++fmt) {
  800346:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800349:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80034c:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800350:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800353:	8d 72 d0             	lea    -0x30(%edx),%esi
  800356:	83 fe 09             	cmp    $0x9,%esi
  800359:	76 eb                	jbe    800346 <vprintfmt+0x8f>
  80035b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80035e:	8b 75 08             	mov    0x8(%ebp),%esi
  800361:	eb 14                	jmp    800377 <vprintfmt+0xc0>
			precision = va_arg(ap, int);
  800363:	8b 45 14             	mov    0x14(%ebp),%eax
  800366:	8b 00                	mov    (%eax),%eax
  800368:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80036b:	8b 45 14             	mov    0x14(%ebp),%eax
  80036e:	8d 40 04             	lea    0x4(%eax),%eax
  800371:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800374:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800377:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80037b:	0f 89 79 ff ff ff    	jns    8002fa <vprintfmt+0x43>
				width = precision, precision = -1;
  800381:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800384:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800387:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80038e:	e9 67 ff ff ff       	jmp    8002fa <vprintfmt+0x43>
  800393:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800396:	85 c0                	test   %eax,%eax
  800398:	0f 48 c1             	cmovs  %ecx,%eax
  80039b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80039e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003a1:	e9 54 ff ff ff       	jmp    8002fa <vprintfmt+0x43>
  8003a6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003a9:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8003b0:	e9 45 ff ff ff       	jmp    8002fa <vprintfmt+0x43>
			lflag++;
  8003b5:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003b9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003bc:	e9 39 ff ff ff       	jmp    8002fa <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8003c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c4:	8d 78 04             	lea    0x4(%eax),%edi
  8003c7:	83 ec 08             	sub    $0x8,%esp
  8003ca:	53                   	push   %ebx
  8003cb:	ff 30                	pushl  (%eax)
  8003cd:	ff d6                	call   *%esi
			break;
  8003cf:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003d2:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003d5:	e9 0f 03 00 00       	jmp    8006e9 <vprintfmt+0x432>
			err = va_arg(ap, int);
  8003da:	8b 45 14             	mov    0x14(%ebp),%eax
  8003dd:	8d 78 04             	lea    0x4(%eax),%edi
  8003e0:	8b 00                	mov    (%eax),%eax
  8003e2:	99                   	cltd   
  8003e3:	31 d0                	xor    %edx,%eax
  8003e5:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003e7:	83 f8 0f             	cmp    $0xf,%eax
  8003ea:	7f 23                	jg     80040f <vprintfmt+0x158>
  8003ec:	8b 14 85 40 15 80 00 	mov    0x801540(,%eax,4),%edx
  8003f3:	85 d2                	test   %edx,%edx
  8003f5:	74 18                	je     80040f <vprintfmt+0x158>
				printfmt(putch, putdat, "%s", p);
  8003f7:	52                   	push   %edx
  8003f8:	68 16 12 80 00       	push   $0x801216
  8003fd:	53                   	push   %ebx
  8003fe:	56                   	push   %esi
  8003ff:	e8 96 fe ff ff       	call   80029a <printfmt>
  800404:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800407:	89 7d 14             	mov    %edi,0x14(%ebp)
  80040a:	e9 da 02 00 00       	jmp    8006e9 <vprintfmt+0x432>
				printfmt(putch, putdat, "error %d", err);
  80040f:	50                   	push   %eax
  800410:	68 0d 12 80 00       	push   $0x80120d
  800415:	53                   	push   %ebx
  800416:	56                   	push   %esi
  800417:	e8 7e fe ff ff       	call   80029a <printfmt>
  80041c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80041f:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800422:	e9 c2 02 00 00       	jmp    8006e9 <vprintfmt+0x432>
			if ((p = va_arg(ap, char *)) == NULL)
  800427:	8b 45 14             	mov    0x14(%ebp),%eax
  80042a:	83 c0 04             	add    $0x4,%eax
  80042d:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800430:	8b 45 14             	mov    0x14(%ebp),%eax
  800433:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800435:	85 c9                	test   %ecx,%ecx
  800437:	b8 06 12 80 00       	mov    $0x801206,%eax
  80043c:	0f 45 c1             	cmovne %ecx,%eax
  80043f:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800442:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800446:	7e 06                	jle    80044e <vprintfmt+0x197>
  800448:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80044c:	75 0d                	jne    80045b <vprintfmt+0x1a4>
				for (width -= strnlen(p, precision); width > 0; width--)
  80044e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800451:	89 c7                	mov    %eax,%edi
  800453:	03 45 e0             	add    -0x20(%ebp),%eax
  800456:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800459:	eb 53                	jmp    8004ae <vprintfmt+0x1f7>
  80045b:	83 ec 08             	sub    $0x8,%esp
  80045e:	ff 75 d8             	pushl  -0x28(%ebp)
  800461:	50                   	push   %eax
  800462:	e8 28 04 00 00       	call   80088f <strnlen>
  800467:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80046a:	29 c1                	sub    %eax,%ecx
  80046c:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  80046f:	83 c4 10             	add    $0x10,%esp
  800472:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800474:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800478:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80047b:	eb 0f                	jmp    80048c <vprintfmt+0x1d5>
					putch(padc, putdat);
  80047d:	83 ec 08             	sub    $0x8,%esp
  800480:	53                   	push   %ebx
  800481:	ff 75 e0             	pushl  -0x20(%ebp)
  800484:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800486:	83 ef 01             	sub    $0x1,%edi
  800489:	83 c4 10             	add    $0x10,%esp
  80048c:	85 ff                	test   %edi,%edi
  80048e:	7f ed                	jg     80047d <vprintfmt+0x1c6>
  800490:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  800493:	85 c9                	test   %ecx,%ecx
  800495:	b8 00 00 00 00       	mov    $0x0,%eax
  80049a:	0f 49 c1             	cmovns %ecx,%eax
  80049d:	29 c1                	sub    %eax,%ecx
  80049f:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8004a2:	eb aa                	jmp    80044e <vprintfmt+0x197>
					putch(ch, putdat);
  8004a4:	83 ec 08             	sub    $0x8,%esp
  8004a7:	53                   	push   %ebx
  8004a8:	52                   	push   %edx
  8004a9:	ff d6                	call   *%esi
  8004ab:	83 c4 10             	add    $0x10,%esp
  8004ae:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004b1:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004b3:	83 c7 01             	add    $0x1,%edi
  8004b6:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004ba:	0f be d0             	movsbl %al,%edx
  8004bd:	85 d2                	test   %edx,%edx
  8004bf:	74 4b                	je     80050c <vprintfmt+0x255>
  8004c1:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004c5:	78 06                	js     8004cd <vprintfmt+0x216>
  8004c7:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004cb:	78 1e                	js     8004eb <vprintfmt+0x234>
				if (altflag && (ch < ' ' || ch > '~'))
  8004cd:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004d1:	74 d1                	je     8004a4 <vprintfmt+0x1ed>
  8004d3:	0f be c0             	movsbl %al,%eax
  8004d6:	83 e8 20             	sub    $0x20,%eax
  8004d9:	83 f8 5e             	cmp    $0x5e,%eax
  8004dc:	76 c6                	jbe    8004a4 <vprintfmt+0x1ed>
					putch('?', putdat);
  8004de:	83 ec 08             	sub    $0x8,%esp
  8004e1:	53                   	push   %ebx
  8004e2:	6a 3f                	push   $0x3f
  8004e4:	ff d6                	call   *%esi
  8004e6:	83 c4 10             	add    $0x10,%esp
  8004e9:	eb c3                	jmp    8004ae <vprintfmt+0x1f7>
  8004eb:	89 cf                	mov    %ecx,%edi
  8004ed:	eb 0e                	jmp    8004fd <vprintfmt+0x246>
				putch(' ', putdat);
  8004ef:	83 ec 08             	sub    $0x8,%esp
  8004f2:	53                   	push   %ebx
  8004f3:	6a 20                	push   $0x20
  8004f5:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004f7:	83 ef 01             	sub    $0x1,%edi
  8004fa:	83 c4 10             	add    $0x10,%esp
  8004fd:	85 ff                	test   %edi,%edi
  8004ff:	7f ee                	jg     8004ef <vprintfmt+0x238>
			if ((p = va_arg(ap, char *)) == NULL)
  800501:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800504:	89 45 14             	mov    %eax,0x14(%ebp)
  800507:	e9 dd 01 00 00       	jmp    8006e9 <vprintfmt+0x432>
  80050c:	89 cf                	mov    %ecx,%edi
  80050e:	eb ed                	jmp    8004fd <vprintfmt+0x246>
	if (lflag >= 2)
  800510:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800514:	7f 21                	jg     800537 <vprintfmt+0x280>
	else if (lflag)
  800516:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80051a:	74 6a                	je     800586 <vprintfmt+0x2cf>
		return va_arg(*ap, long);
  80051c:	8b 45 14             	mov    0x14(%ebp),%eax
  80051f:	8b 00                	mov    (%eax),%eax
  800521:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800524:	89 c1                	mov    %eax,%ecx
  800526:	c1 f9 1f             	sar    $0x1f,%ecx
  800529:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80052c:	8b 45 14             	mov    0x14(%ebp),%eax
  80052f:	8d 40 04             	lea    0x4(%eax),%eax
  800532:	89 45 14             	mov    %eax,0x14(%ebp)
  800535:	eb 17                	jmp    80054e <vprintfmt+0x297>
		return va_arg(*ap, long long);
  800537:	8b 45 14             	mov    0x14(%ebp),%eax
  80053a:	8b 50 04             	mov    0x4(%eax),%edx
  80053d:	8b 00                	mov    (%eax),%eax
  80053f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800542:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800545:	8b 45 14             	mov    0x14(%ebp),%eax
  800548:	8d 40 08             	lea    0x8(%eax),%eax
  80054b:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80054e:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  800551:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800556:	85 d2                	test   %edx,%edx
  800558:	0f 89 5c 01 00 00    	jns    8006ba <vprintfmt+0x403>
				putch('-', putdat);
  80055e:	83 ec 08             	sub    $0x8,%esp
  800561:	53                   	push   %ebx
  800562:	6a 2d                	push   $0x2d
  800564:	ff d6                	call   *%esi
				num = -(long long) num;
  800566:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800569:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80056c:	f7 d8                	neg    %eax
  80056e:	83 d2 00             	adc    $0x0,%edx
  800571:	f7 da                	neg    %edx
  800573:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800576:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800579:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80057c:	bf 0a 00 00 00       	mov    $0xa,%edi
  800581:	e9 45 01 00 00       	jmp    8006cb <vprintfmt+0x414>
		return va_arg(*ap, int);
  800586:	8b 45 14             	mov    0x14(%ebp),%eax
  800589:	8b 00                	mov    (%eax),%eax
  80058b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80058e:	89 c1                	mov    %eax,%ecx
  800590:	c1 f9 1f             	sar    $0x1f,%ecx
  800593:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800596:	8b 45 14             	mov    0x14(%ebp),%eax
  800599:	8d 40 04             	lea    0x4(%eax),%eax
  80059c:	89 45 14             	mov    %eax,0x14(%ebp)
  80059f:	eb ad                	jmp    80054e <vprintfmt+0x297>
	if (lflag >= 2)
  8005a1:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8005a5:	7f 29                	jg     8005d0 <vprintfmt+0x319>
	else if (lflag)
  8005a7:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8005ab:	74 44                	je     8005f1 <vprintfmt+0x33a>
		return va_arg(*ap, unsigned long);
  8005ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b0:	8b 00                	mov    (%eax),%eax
  8005b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8005b7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ba:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c0:	8d 40 04             	lea    0x4(%eax),%eax
  8005c3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005c6:	bf 0a 00 00 00       	mov    $0xa,%edi
  8005cb:	e9 ea 00 00 00       	jmp    8006ba <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  8005d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d3:	8b 50 04             	mov    0x4(%eax),%edx
  8005d6:	8b 00                	mov    (%eax),%eax
  8005d8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005db:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005de:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e1:	8d 40 08             	lea    0x8(%eax),%eax
  8005e4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005e7:	bf 0a 00 00 00       	mov    $0xa,%edi
  8005ec:	e9 c9 00 00 00       	jmp    8006ba <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  8005f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f4:	8b 00                	mov    (%eax),%eax
  8005f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8005fb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005fe:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800601:	8b 45 14             	mov    0x14(%ebp),%eax
  800604:	8d 40 04             	lea    0x4(%eax),%eax
  800607:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80060a:	bf 0a 00 00 00       	mov    $0xa,%edi
  80060f:	e9 a6 00 00 00       	jmp    8006ba <vprintfmt+0x403>
			putch('0', putdat);
  800614:	83 ec 08             	sub    $0x8,%esp
  800617:	53                   	push   %ebx
  800618:	6a 30                	push   $0x30
  80061a:	ff d6                	call   *%esi
	if (lflag >= 2)
  80061c:	83 c4 10             	add    $0x10,%esp
  80061f:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800623:	7f 26                	jg     80064b <vprintfmt+0x394>
	else if (lflag)
  800625:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800629:	74 3e                	je     800669 <vprintfmt+0x3b2>
		return va_arg(*ap, unsigned long);
  80062b:	8b 45 14             	mov    0x14(%ebp),%eax
  80062e:	8b 00                	mov    (%eax),%eax
  800630:	ba 00 00 00 00       	mov    $0x0,%edx
  800635:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800638:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80063b:	8b 45 14             	mov    0x14(%ebp),%eax
  80063e:	8d 40 04             	lea    0x4(%eax),%eax
  800641:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800644:	bf 08 00 00 00       	mov    $0x8,%edi
  800649:	eb 6f                	jmp    8006ba <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  80064b:	8b 45 14             	mov    0x14(%ebp),%eax
  80064e:	8b 50 04             	mov    0x4(%eax),%edx
  800651:	8b 00                	mov    (%eax),%eax
  800653:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800656:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800659:	8b 45 14             	mov    0x14(%ebp),%eax
  80065c:	8d 40 08             	lea    0x8(%eax),%eax
  80065f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800662:	bf 08 00 00 00       	mov    $0x8,%edi
  800667:	eb 51                	jmp    8006ba <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  800669:	8b 45 14             	mov    0x14(%ebp),%eax
  80066c:	8b 00                	mov    (%eax),%eax
  80066e:	ba 00 00 00 00       	mov    $0x0,%edx
  800673:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800676:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800679:	8b 45 14             	mov    0x14(%ebp),%eax
  80067c:	8d 40 04             	lea    0x4(%eax),%eax
  80067f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800682:	bf 08 00 00 00       	mov    $0x8,%edi
  800687:	eb 31                	jmp    8006ba <vprintfmt+0x403>
			putch('0', putdat);
  800689:	83 ec 08             	sub    $0x8,%esp
  80068c:	53                   	push   %ebx
  80068d:	6a 30                	push   $0x30
  80068f:	ff d6                	call   *%esi
			putch('x', putdat);
  800691:	83 c4 08             	add    $0x8,%esp
  800694:	53                   	push   %ebx
  800695:	6a 78                	push   $0x78
  800697:	ff d6                	call   *%esi
			num = (unsigned long long)
  800699:	8b 45 14             	mov    0x14(%ebp),%eax
  80069c:	8b 00                	mov    (%eax),%eax
  80069e:	ba 00 00 00 00       	mov    $0x0,%edx
  8006a3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006a6:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8006a9:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8006af:	8d 40 04             	lea    0x4(%eax),%eax
  8006b2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006b5:	bf 10 00 00 00       	mov    $0x10,%edi
			if(posflag)
  8006ba:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006be:	74 0b                	je     8006cb <vprintfmt+0x414>
				putch('+', putdat);
  8006c0:	83 ec 08             	sub    $0x8,%esp
  8006c3:	53                   	push   %ebx
  8006c4:	6a 2b                	push   $0x2b
  8006c6:	ff d6                	call   *%esi
  8006c8:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  8006cb:	83 ec 0c             	sub    $0xc,%esp
  8006ce:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8006d2:	50                   	push   %eax
  8006d3:	ff 75 e0             	pushl  -0x20(%ebp)
  8006d6:	57                   	push   %edi
  8006d7:	ff 75 dc             	pushl  -0x24(%ebp)
  8006da:	ff 75 d8             	pushl  -0x28(%ebp)
  8006dd:	89 da                	mov    %ebx,%edx
  8006df:	89 f0                	mov    %esi,%eax
  8006e1:	e8 b8 fa ff ff       	call   80019e <printnum>
			break;
  8006e6:	83 c4 20             	add    $0x20,%esp
			char* cp = va_arg(ap, char *);
  8006e9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006ec:	83 c7 01             	add    $0x1,%edi
  8006ef:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006f3:	83 f8 25             	cmp    $0x25,%eax
  8006f6:	0f 84 d2 fb ff ff    	je     8002ce <vprintfmt+0x17>
			if (ch == '\0')
  8006fc:	85 c0                	test   %eax,%eax
  8006fe:	0f 84 03 01 00 00    	je     800807 <vprintfmt+0x550>
			putch(ch, putdat);
  800704:	83 ec 08             	sub    $0x8,%esp
  800707:	53                   	push   %ebx
  800708:	50                   	push   %eax
  800709:	ff d6                	call   *%esi
  80070b:	83 c4 10             	add    $0x10,%esp
  80070e:	eb dc                	jmp    8006ec <vprintfmt+0x435>
	if (lflag >= 2)
  800710:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800714:	7f 29                	jg     80073f <vprintfmt+0x488>
	else if (lflag)
  800716:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80071a:	74 44                	je     800760 <vprintfmt+0x4a9>
		return va_arg(*ap, unsigned long);
  80071c:	8b 45 14             	mov    0x14(%ebp),%eax
  80071f:	8b 00                	mov    (%eax),%eax
  800721:	ba 00 00 00 00       	mov    $0x0,%edx
  800726:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800729:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80072c:	8b 45 14             	mov    0x14(%ebp),%eax
  80072f:	8d 40 04             	lea    0x4(%eax),%eax
  800732:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800735:	bf 10 00 00 00       	mov    $0x10,%edi
  80073a:	e9 7b ff ff ff       	jmp    8006ba <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  80073f:	8b 45 14             	mov    0x14(%ebp),%eax
  800742:	8b 50 04             	mov    0x4(%eax),%edx
  800745:	8b 00                	mov    (%eax),%eax
  800747:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80074a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80074d:	8b 45 14             	mov    0x14(%ebp),%eax
  800750:	8d 40 08             	lea    0x8(%eax),%eax
  800753:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800756:	bf 10 00 00 00       	mov    $0x10,%edi
  80075b:	e9 5a ff ff ff       	jmp    8006ba <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  800760:	8b 45 14             	mov    0x14(%ebp),%eax
  800763:	8b 00                	mov    (%eax),%eax
  800765:	ba 00 00 00 00       	mov    $0x0,%edx
  80076a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80076d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800770:	8b 45 14             	mov    0x14(%ebp),%eax
  800773:	8d 40 04             	lea    0x4(%eax),%eax
  800776:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800779:	bf 10 00 00 00       	mov    $0x10,%edi
  80077e:	e9 37 ff ff ff       	jmp    8006ba <vprintfmt+0x403>
			char* cp = va_arg(ap, char *);
  800783:	8b 45 14             	mov    0x14(%ebp),%eax
  800786:	8d 78 04             	lea    0x4(%eax),%edi
  800789:	8b 00                	mov    (%eax),%eax
    			if (cp == NULL) {
  80078b:	85 c0                	test   %eax,%eax
  80078d:	74 2c                	je     8007bb <vprintfmt+0x504>
    			*cp = *(int *)putdat;
  80078f:	8b 13                	mov    (%ebx),%edx
  800791:	88 10                	mov    %dl,(%eax)
			char* cp = va_arg(ap, char *);
  800793:	89 7d 14             	mov    %edi,0x14(%ebp)
    			if ((*(int *) putdat) > 127)
  800796:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  800799:	0f 8e 4a ff ff ff    	jle    8006e9 <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", overflow_error);
  80079f:	68 64 13 80 00       	push   $0x801364
  8007a4:	68 16 12 80 00       	push   $0x801216
  8007a9:	53                   	push   %ebx
  8007aa:	56                   	push   %esi
  8007ab:	e8 ea fa ff ff       	call   80029a <printfmt>
  8007b0:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  8007b3:	89 7d 14             	mov    %edi,0x14(%ebp)
  8007b6:	e9 2e ff ff ff       	jmp    8006e9 <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", null_error);
  8007bb:	68 2c 13 80 00       	push   $0x80132c
  8007c0:	68 16 12 80 00       	push   $0x801216
  8007c5:	53                   	push   %ebx
  8007c6:	56                   	push   %esi
  8007c7:	e8 ce fa ff ff       	call   80029a <printfmt>
        		break;
  8007cc:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  8007cf:	89 7d 14             	mov    %edi,0x14(%ebp)
        		break;
  8007d2:	e9 12 ff ff ff       	jmp    8006e9 <vprintfmt+0x432>
			putch(ch, putdat);
  8007d7:	83 ec 08             	sub    $0x8,%esp
  8007da:	53                   	push   %ebx
  8007db:	6a 25                	push   $0x25
  8007dd:	ff d6                	call   *%esi
			break;
  8007df:	83 c4 10             	add    $0x10,%esp
  8007e2:	e9 02 ff ff ff       	jmp    8006e9 <vprintfmt+0x432>
			putch('%', putdat);
  8007e7:	83 ec 08             	sub    $0x8,%esp
  8007ea:	53                   	push   %ebx
  8007eb:	6a 25                	push   $0x25
  8007ed:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007ef:	83 c4 10             	add    $0x10,%esp
  8007f2:	89 f8                	mov    %edi,%eax
  8007f4:	eb 03                	jmp    8007f9 <vprintfmt+0x542>
  8007f6:	83 e8 01             	sub    $0x1,%eax
  8007f9:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8007fd:	75 f7                	jne    8007f6 <vprintfmt+0x53f>
  8007ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800802:	e9 e2 fe ff ff       	jmp    8006e9 <vprintfmt+0x432>
}
  800807:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80080a:	5b                   	pop    %ebx
  80080b:	5e                   	pop    %esi
  80080c:	5f                   	pop    %edi
  80080d:	5d                   	pop    %ebp
  80080e:	c3                   	ret    

0080080f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80080f:	55                   	push   %ebp
  800810:	89 e5                	mov    %esp,%ebp
  800812:	83 ec 18             	sub    $0x18,%esp
  800815:	8b 45 08             	mov    0x8(%ebp),%eax
  800818:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80081b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80081e:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800822:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800825:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80082c:	85 c0                	test   %eax,%eax
  80082e:	74 26                	je     800856 <vsnprintf+0x47>
  800830:	85 d2                	test   %edx,%edx
  800832:	7e 22                	jle    800856 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800834:	ff 75 14             	pushl  0x14(%ebp)
  800837:	ff 75 10             	pushl  0x10(%ebp)
  80083a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80083d:	50                   	push   %eax
  80083e:	68 7d 02 80 00       	push   $0x80027d
  800843:	e8 6f fa ff ff       	call   8002b7 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800848:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80084b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80084e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800851:	83 c4 10             	add    $0x10,%esp
}
  800854:	c9                   	leave  
  800855:	c3                   	ret    
		return -E_INVAL;
  800856:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80085b:	eb f7                	jmp    800854 <vsnprintf+0x45>

0080085d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80085d:	55                   	push   %ebp
  80085e:	89 e5                	mov    %esp,%ebp
  800860:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800863:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800866:	50                   	push   %eax
  800867:	ff 75 10             	pushl  0x10(%ebp)
  80086a:	ff 75 0c             	pushl  0xc(%ebp)
  80086d:	ff 75 08             	pushl  0x8(%ebp)
  800870:	e8 9a ff ff ff       	call   80080f <vsnprintf>
	va_end(ap);

	return rc;
}
  800875:	c9                   	leave  
  800876:	c3                   	ret    

00800877 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800877:	55                   	push   %ebp
  800878:	89 e5                	mov    %esp,%ebp
  80087a:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80087d:	b8 00 00 00 00       	mov    $0x0,%eax
  800882:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800886:	74 05                	je     80088d <strlen+0x16>
		n++;
  800888:	83 c0 01             	add    $0x1,%eax
  80088b:	eb f5                	jmp    800882 <strlen+0xb>
	return n;
}
  80088d:	5d                   	pop    %ebp
  80088e:	c3                   	ret    

0080088f <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80088f:	55                   	push   %ebp
  800890:	89 e5                	mov    %esp,%ebp
  800892:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800895:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800898:	ba 00 00 00 00       	mov    $0x0,%edx
  80089d:	39 c2                	cmp    %eax,%edx
  80089f:	74 0d                	je     8008ae <strnlen+0x1f>
  8008a1:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8008a5:	74 05                	je     8008ac <strnlen+0x1d>
		n++;
  8008a7:	83 c2 01             	add    $0x1,%edx
  8008aa:	eb f1                	jmp    80089d <strnlen+0xe>
  8008ac:	89 d0                	mov    %edx,%eax
	return n;
}
  8008ae:	5d                   	pop    %ebp
  8008af:	c3                   	ret    

008008b0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008b0:	55                   	push   %ebp
  8008b1:	89 e5                	mov    %esp,%ebp
  8008b3:	53                   	push   %ebx
  8008b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8008bf:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8008c3:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8008c6:	83 c2 01             	add    $0x1,%edx
  8008c9:	84 c9                	test   %cl,%cl
  8008cb:	75 f2                	jne    8008bf <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8008cd:	5b                   	pop    %ebx
  8008ce:	5d                   	pop    %ebp
  8008cf:	c3                   	ret    

008008d0 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008d0:	55                   	push   %ebp
  8008d1:	89 e5                	mov    %esp,%ebp
  8008d3:	53                   	push   %ebx
  8008d4:	83 ec 10             	sub    $0x10,%esp
  8008d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008da:	53                   	push   %ebx
  8008db:	e8 97 ff ff ff       	call   800877 <strlen>
  8008e0:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8008e3:	ff 75 0c             	pushl  0xc(%ebp)
  8008e6:	01 d8                	add    %ebx,%eax
  8008e8:	50                   	push   %eax
  8008e9:	e8 c2 ff ff ff       	call   8008b0 <strcpy>
	return dst;
}
  8008ee:	89 d8                	mov    %ebx,%eax
  8008f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008f3:	c9                   	leave  
  8008f4:	c3                   	ret    

008008f5 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008f5:	55                   	push   %ebp
  8008f6:	89 e5                	mov    %esp,%ebp
  8008f8:	56                   	push   %esi
  8008f9:	53                   	push   %ebx
  8008fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800900:	89 c6                	mov    %eax,%esi
  800902:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800905:	89 c2                	mov    %eax,%edx
  800907:	39 f2                	cmp    %esi,%edx
  800909:	74 11                	je     80091c <strncpy+0x27>
		*dst++ = *src;
  80090b:	83 c2 01             	add    $0x1,%edx
  80090e:	0f b6 19             	movzbl (%ecx),%ebx
  800911:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800914:	80 fb 01             	cmp    $0x1,%bl
  800917:	83 d9 ff             	sbb    $0xffffffff,%ecx
  80091a:	eb eb                	jmp    800907 <strncpy+0x12>
	}
	return ret;
}
  80091c:	5b                   	pop    %ebx
  80091d:	5e                   	pop    %esi
  80091e:	5d                   	pop    %ebp
  80091f:	c3                   	ret    

00800920 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800920:	55                   	push   %ebp
  800921:	89 e5                	mov    %esp,%ebp
  800923:	56                   	push   %esi
  800924:	53                   	push   %ebx
  800925:	8b 75 08             	mov    0x8(%ebp),%esi
  800928:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80092b:	8b 55 10             	mov    0x10(%ebp),%edx
  80092e:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800930:	85 d2                	test   %edx,%edx
  800932:	74 21                	je     800955 <strlcpy+0x35>
  800934:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800938:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80093a:	39 c2                	cmp    %eax,%edx
  80093c:	74 14                	je     800952 <strlcpy+0x32>
  80093e:	0f b6 19             	movzbl (%ecx),%ebx
  800941:	84 db                	test   %bl,%bl
  800943:	74 0b                	je     800950 <strlcpy+0x30>
			*dst++ = *src++;
  800945:	83 c1 01             	add    $0x1,%ecx
  800948:	83 c2 01             	add    $0x1,%edx
  80094b:	88 5a ff             	mov    %bl,-0x1(%edx)
  80094e:	eb ea                	jmp    80093a <strlcpy+0x1a>
  800950:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800952:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800955:	29 f0                	sub    %esi,%eax
}
  800957:	5b                   	pop    %ebx
  800958:	5e                   	pop    %esi
  800959:	5d                   	pop    %ebp
  80095a:	c3                   	ret    

0080095b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80095b:	55                   	push   %ebp
  80095c:	89 e5                	mov    %esp,%ebp
  80095e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800961:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800964:	0f b6 01             	movzbl (%ecx),%eax
  800967:	84 c0                	test   %al,%al
  800969:	74 0c                	je     800977 <strcmp+0x1c>
  80096b:	3a 02                	cmp    (%edx),%al
  80096d:	75 08                	jne    800977 <strcmp+0x1c>
		p++, q++;
  80096f:	83 c1 01             	add    $0x1,%ecx
  800972:	83 c2 01             	add    $0x1,%edx
  800975:	eb ed                	jmp    800964 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800977:	0f b6 c0             	movzbl %al,%eax
  80097a:	0f b6 12             	movzbl (%edx),%edx
  80097d:	29 d0                	sub    %edx,%eax
}
  80097f:	5d                   	pop    %ebp
  800980:	c3                   	ret    

00800981 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800981:	55                   	push   %ebp
  800982:	89 e5                	mov    %esp,%ebp
  800984:	53                   	push   %ebx
  800985:	8b 45 08             	mov    0x8(%ebp),%eax
  800988:	8b 55 0c             	mov    0xc(%ebp),%edx
  80098b:	89 c3                	mov    %eax,%ebx
  80098d:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800990:	eb 06                	jmp    800998 <strncmp+0x17>
		n--, p++, q++;
  800992:	83 c0 01             	add    $0x1,%eax
  800995:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800998:	39 d8                	cmp    %ebx,%eax
  80099a:	74 16                	je     8009b2 <strncmp+0x31>
  80099c:	0f b6 08             	movzbl (%eax),%ecx
  80099f:	84 c9                	test   %cl,%cl
  8009a1:	74 04                	je     8009a7 <strncmp+0x26>
  8009a3:	3a 0a                	cmp    (%edx),%cl
  8009a5:	74 eb                	je     800992 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009a7:	0f b6 00             	movzbl (%eax),%eax
  8009aa:	0f b6 12             	movzbl (%edx),%edx
  8009ad:	29 d0                	sub    %edx,%eax
}
  8009af:	5b                   	pop    %ebx
  8009b0:	5d                   	pop    %ebp
  8009b1:	c3                   	ret    
		return 0;
  8009b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8009b7:	eb f6                	jmp    8009af <strncmp+0x2e>

008009b9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009b9:	55                   	push   %ebp
  8009ba:	89 e5                	mov    %esp,%ebp
  8009bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bf:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009c3:	0f b6 10             	movzbl (%eax),%edx
  8009c6:	84 d2                	test   %dl,%dl
  8009c8:	74 09                	je     8009d3 <strchr+0x1a>
		if (*s == c)
  8009ca:	38 ca                	cmp    %cl,%dl
  8009cc:	74 0a                	je     8009d8 <strchr+0x1f>
	for (; *s; s++)
  8009ce:	83 c0 01             	add    $0x1,%eax
  8009d1:	eb f0                	jmp    8009c3 <strchr+0xa>
			return (char *) s;
	return 0;
  8009d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009d8:	5d                   	pop    %ebp
  8009d9:	c3                   	ret    

008009da <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009da:	55                   	push   %ebp
  8009db:	89 e5                	mov    %esp,%ebp
  8009dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009e4:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009e7:	38 ca                	cmp    %cl,%dl
  8009e9:	74 09                	je     8009f4 <strfind+0x1a>
  8009eb:	84 d2                	test   %dl,%dl
  8009ed:	74 05                	je     8009f4 <strfind+0x1a>
	for (; *s; s++)
  8009ef:	83 c0 01             	add    $0x1,%eax
  8009f2:	eb f0                	jmp    8009e4 <strfind+0xa>
			break;
	return (char *) s;
}
  8009f4:	5d                   	pop    %ebp
  8009f5:	c3                   	ret    

008009f6 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009f6:	55                   	push   %ebp
  8009f7:	89 e5                	mov    %esp,%ebp
  8009f9:	57                   	push   %edi
  8009fa:	56                   	push   %esi
  8009fb:	53                   	push   %ebx
  8009fc:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009ff:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a02:	85 c9                	test   %ecx,%ecx
  800a04:	74 31                	je     800a37 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a06:	89 f8                	mov    %edi,%eax
  800a08:	09 c8                	or     %ecx,%eax
  800a0a:	a8 03                	test   $0x3,%al
  800a0c:	75 23                	jne    800a31 <memset+0x3b>
		c &= 0xFF;
  800a0e:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a12:	89 d3                	mov    %edx,%ebx
  800a14:	c1 e3 08             	shl    $0x8,%ebx
  800a17:	89 d0                	mov    %edx,%eax
  800a19:	c1 e0 18             	shl    $0x18,%eax
  800a1c:	89 d6                	mov    %edx,%esi
  800a1e:	c1 e6 10             	shl    $0x10,%esi
  800a21:	09 f0                	or     %esi,%eax
  800a23:	09 c2                	or     %eax,%edx
  800a25:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a27:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a2a:	89 d0                	mov    %edx,%eax
  800a2c:	fc                   	cld    
  800a2d:	f3 ab                	rep stos %eax,%es:(%edi)
  800a2f:	eb 06                	jmp    800a37 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a34:	fc                   	cld    
  800a35:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a37:	89 f8                	mov    %edi,%eax
  800a39:	5b                   	pop    %ebx
  800a3a:	5e                   	pop    %esi
  800a3b:	5f                   	pop    %edi
  800a3c:	5d                   	pop    %ebp
  800a3d:	c3                   	ret    

00800a3e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a3e:	55                   	push   %ebp
  800a3f:	89 e5                	mov    %esp,%ebp
  800a41:	57                   	push   %edi
  800a42:	56                   	push   %esi
  800a43:	8b 45 08             	mov    0x8(%ebp),%eax
  800a46:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a49:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a4c:	39 c6                	cmp    %eax,%esi
  800a4e:	73 32                	jae    800a82 <memmove+0x44>
  800a50:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a53:	39 c2                	cmp    %eax,%edx
  800a55:	76 2b                	jbe    800a82 <memmove+0x44>
		s += n;
		d += n;
  800a57:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a5a:	89 fe                	mov    %edi,%esi
  800a5c:	09 ce                	or     %ecx,%esi
  800a5e:	09 d6                	or     %edx,%esi
  800a60:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a66:	75 0e                	jne    800a76 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a68:	83 ef 04             	sub    $0x4,%edi
  800a6b:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a6e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a71:	fd                   	std    
  800a72:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a74:	eb 09                	jmp    800a7f <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a76:	83 ef 01             	sub    $0x1,%edi
  800a79:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a7c:	fd                   	std    
  800a7d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a7f:	fc                   	cld    
  800a80:	eb 1a                	jmp    800a9c <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a82:	89 c2                	mov    %eax,%edx
  800a84:	09 ca                	or     %ecx,%edx
  800a86:	09 f2                	or     %esi,%edx
  800a88:	f6 c2 03             	test   $0x3,%dl
  800a8b:	75 0a                	jne    800a97 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a8d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a90:	89 c7                	mov    %eax,%edi
  800a92:	fc                   	cld    
  800a93:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a95:	eb 05                	jmp    800a9c <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800a97:	89 c7                	mov    %eax,%edi
  800a99:	fc                   	cld    
  800a9a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a9c:	5e                   	pop    %esi
  800a9d:	5f                   	pop    %edi
  800a9e:	5d                   	pop    %ebp
  800a9f:	c3                   	ret    

00800aa0 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800aa0:	55                   	push   %ebp
  800aa1:	89 e5                	mov    %esp,%ebp
  800aa3:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800aa6:	ff 75 10             	pushl  0x10(%ebp)
  800aa9:	ff 75 0c             	pushl  0xc(%ebp)
  800aac:	ff 75 08             	pushl  0x8(%ebp)
  800aaf:	e8 8a ff ff ff       	call   800a3e <memmove>
}
  800ab4:	c9                   	leave  
  800ab5:	c3                   	ret    

00800ab6 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ab6:	55                   	push   %ebp
  800ab7:	89 e5                	mov    %esp,%ebp
  800ab9:	56                   	push   %esi
  800aba:	53                   	push   %ebx
  800abb:	8b 45 08             	mov    0x8(%ebp),%eax
  800abe:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ac1:	89 c6                	mov    %eax,%esi
  800ac3:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ac6:	39 f0                	cmp    %esi,%eax
  800ac8:	74 1c                	je     800ae6 <memcmp+0x30>
		if (*s1 != *s2)
  800aca:	0f b6 08             	movzbl (%eax),%ecx
  800acd:	0f b6 1a             	movzbl (%edx),%ebx
  800ad0:	38 d9                	cmp    %bl,%cl
  800ad2:	75 08                	jne    800adc <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800ad4:	83 c0 01             	add    $0x1,%eax
  800ad7:	83 c2 01             	add    $0x1,%edx
  800ada:	eb ea                	jmp    800ac6 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800adc:	0f b6 c1             	movzbl %cl,%eax
  800adf:	0f b6 db             	movzbl %bl,%ebx
  800ae2:	29 d8                	sub    %ebx,%eax
  800ae4:	eb 05                	jmp    800aeb <memcmp+0x35>
	}

	return 0;
  800ae6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800aeb:	5b                   	pop    %ebx
  800aec:	5e                   	pop    %esi
  800aed:	5d                   	pop    %ebp
  800aee:	c3                   	ret    

00800aef <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800aef:	55                   	push   %ebp
  800af0:	89 e5                	mov    %esp,%ebp
  800af2:	8b 45 08             	mov    0x8(%ebp),%eax
  800af5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800af8:	89 c2                	mov    %eax,%edx
  800afa:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800afd:	39 d0                	cmp    %edx,%eax
  800aff:	73 09                	jae    800b0a <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b01:	38 08                	cmp    %cl,(%eax)
  800b03:	74 05                	je     800b0a <memfind+0x1b>
	for (; s < ends; s++)
  800b05:	83 c0 01             	add    $0x1,%eax
  800b08:	eb f3                	jmp    800afd <memfind+0xe>
			break;
	return (void *) s;
}
  800b0a:	5d                   	pop    %ebp
  800b0b:	c3                   	ret    

00800b0c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b0c:	55                   	push   %ebp
  800b0d:	89 e5                	mov    %esp,%ebp
  800b0f:	57                   	push   %edi
  800b10:	56                   	push   %esi
  800b11:	53                   	push   %ebx
  800b12:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b15:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b18:	eb 03                	jmp    800b1d <strtol+0x11>
		s++;
  800b1a:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b1d:	0f b6 01             	movzbl (%ecx),%eax
  800b20:	3c 20                	cmp    $0x20,%al
  800b22:	74 f6                	je     800b1a <strtol+0xe>
  800b24:	3c 09                	cmp    $0x9,%al
  800b26:	74 f2                	je     800b1a <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b28:	3c 2b                	cmp    $0x2b,%al
  800b2a:	74 2a                	je     800b56 <strtol+0x4a>
	int neg = 0;
  800b2c:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b31:	3c 2d                	cmp    $0x2d,%al
  800b33:	74 2b                	je     800b60 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b35:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b3b:	75 0f                	jne    800b4c <strtol+0x40>
  800b3d:	80 39 30             	cmpb   $0x30,(%ecx)
  800b40:	74 28                	je     800b6a <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b42:	85 db                	test   %ebx,%ebx
  800b44:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b49:	0f 44 d8             	cmove  %eax,%ebx
  800b4c:	b8 00 00 00 00       	mov    $0x0,%eax
  800b51:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b54:	eb 50                	jmp    800ba6 <strtol+0x9a>
		s++;
  800b56:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b59:	bf 00 00 00 00       	mov    $0x0,%edi
  800b5e:	eb d5                	jmp    800b35 <strtol+0x29>
		s++, neg = 1;
  800b60:	83 c1 01             	add    $0x1,%ecx
  800b63:	bf 01 00 00 00       	mov    $0x1,%edi
  800b68:	eb cb                	jmp    800b35 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b6a:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b6e:	74 0e                	je     800b7e <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800b70:	85 db                	test   %ebx,%ebx
  800b72:	75 d8                	jne    800b4c <strtol+0x40>
		s++, base = 8;
  800b74:	83 c1 01             	add    $0x1,%ecx
  800b77:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b7c:	eb ce                	jmp    800b4c <strtol+0x40>
		s += 2, base = 16;
  800b7e:	83 c1 02             	add    $0x2,%ecx
  800b81:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b86:	eb c4                	jmp    800b4c <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b88:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b8b:	89 f3                	mov    %esi,%ebx
  800b8d:	80 fb 19             	cmp    $0x19,%bl
  800b90:	77 29                	ja     800bbb <strtol+0xaf>
			dig = *s - 'a' + 10;
  800b92:	0f be d2             	movsbl %dl,%edx
  800b95:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b98:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b9b:	7d 30                	jge    800bcd <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800b9d:	83 c1 01             	add    $0x1,%ecx
  800ba0:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ba4:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800ba6:	0f b6 11             	movzbl (%ecx),%edx
  800ba9:	8d 72 d0             	lea    -0x30(%edx),%esi
  800bac:	89 f3                	mov    %esi,%ebx
  800bae:	80 fb 09             	cmp    $0x9,%bl
  800bb1:	77 d5                	ja     800b88 <strtol+0x7c>
			dig = *s - '0';
  800bb3:	0f be d2             	movsbl %dl,%edx
  800bb6:	83 ea 30             	sub    $0x30,%edx
  800bb9:	eb dd                	jmp    800b98 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800bbb:	8d 72 bf             	lea    -0x41(%edx),%esi
  800bbe:	89 f3                	mov    %esi,%ebx
  800bc0:	80 fb 19             	cmp    $0x19,%bl
  800bc3:	77 08                	ja     800bcd <strtol+0xc1>
			dig = *s - 'A' + 10;
  800bc5:	0f be d2             	movsbl %dl,%edx
  800bc8:	83 ea 37             	sub    $0x37,%edx
  800bcb:	eb cb                	jmp    800b98 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800bcd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bd1:	74 05                	je     800bd8 <strtol+0xcc>
		*endptr = (char *) s;
  800bd3:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bd6:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800bd8:	89 c2                	mov    %eax,%edx
  800bda:	f7 da                	neg    %edx
  800bdc:	85 ff                	test   %edi,%edi
  800bde:	0f 45 c2             	cmovne %edx,%eax
}
  800be1:	5b                   	pop    %ebx
  800be2:	5e                   	pop    %esi
  800be3:	5f                   	pop    %edi
  800be4:	5d                   	pop    %ebp
  800be5:	c3                   	ret    

00800be6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800be6:	55                   	push   %ebp
  800be7:	89 e5                	mov    %esp,%ebp
  800be9:	57                   	push   %edi
  800bea:	56                   	push   %esi
  800beb:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bec:	b8 00 00 00 00       	mov    $0x0,%eax
  800bf1:	8b 55 08             	mov    0x8(%ebp),%edx
  800bf4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bf7:	89 c3                	mov    %eax,%ebx
  800bf9:	89 c7                	mov    %eax,%edi
  800bfb:	89 c6                	mov    %eax,%esi
  800bfd:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bff:	5b                   	pop    %ebx
  800c00:	5e                   	pop    %esi
  800c01:	5f                   	pop    %edi
  800c02:	5d                   	pop    %ebp
  800c03:	c3                   	ret    

00800c04 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c04:	55                   	push   %ebp
  800c05:	89 e5                	mov    %esp,%ebp
  800c07:	57                   	push   %edi
  800c08:	56                   	push   %esi
  800c09:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c0a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c0f:	b8 01 00 00 00       	mov    $0x1,%eax
  800c14:	89 d1                	mov    %edx,%ecx
  800c16:	89 d3                	mov    %edx,%ebx
  800c18:	89 d7                	mov    %edx,%edi
  800c1a:	89 d6                	mov    %edx,%esi
  800c1c:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c1e:	5b                   	pop    %ebx
  800c1f:	5e                   	pop    %esi
  800c20:	5f                   	pop    %edi
  800c21:	5d                   	pop    %ebp
  800c22:	c3                   	ret    

00800c23 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c23:	55                   	push   %ebp
  800c24:	89 e5                	mov    %esp,%ebp
  800c26:	57                   	push   %edi
  800c27:	56                   	push   %esi
  800c28:	53                   	push   %ebx
  800c29:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c2c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c31:	8b 55 08             	mov    0x8(%ebp),%edx
  800c34:	b8 03 00 00 00       	mov    $0x3,%eax
  800c39:	89 cb                	mov    %ecx,%ebx
  800c3b:	89 cf                	mov    %ecx,%edi
  800c3d:	89 ce                	mov    %ecx,%esi
  800c3f:	cd 30                	int    $0x30
	if (check && ret > 0)
  800c41:	85 c0                	test   %eax,%eax
  800c43:	7f 08                	jg     800c4d <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c45:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c48:	5b                   	pop    %ebx
  800c49:	5e                   	pop    %esi
  800c4a:	5f                   	pop    %edi
  800c4b:	5d                   	pop    %ebp
  800c4c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c4d:	83 ec 0c             	sub    $0xc,%esp
  800c50:	50                   	push   %eax
  800c51:	6a 03                	push   $0x3
  800c53:	68 80 15 80 00       	push   $0x801580
  800c58:	6a 4c                	push   $0x4c
  800c5a:	68 9d 15 80 00       	push   $0x80159d
  800c5f:	e8 70 02 00 00       	call   800ed4 <_panic>

00800c64 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c64:	55                   	push   %ebp
  800c65:	89 e5                	mov    %esp,%ebp
  800c67:	57                   	push   %edi
  800c68:	56                   	push   %esi
  800c69:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c6a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c6f:	b8 02 00 00 00       	mov    $0x2,%eax
  800c74:	89 d1                	mov    %edx,%ecx
  800c76:	89 d3                	mov    %edx,%ebx
  800c78:	89 d7                	mov    %edx,%edi
  800c7a:	89 d6                	mov    %edx,%esi
  800c7c:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c7e:	5b                   	pop    %ebx
  800c7f:	5e                   	pop    %esi
  800c80:	5f                   	pop    %edi
  800c81:	5d                   	pop    %ebp
  800c82:	c3                   	ret    

00800c83 <sys_yield>:

void
sys_yield(void)
{
  800c83:	55                   	push   %ebp
  800c84:	89 e5                	mov    %esp,%ebp
  800c86:	57                   	push   %edi
  800c87:	56                   	push   %esi
  800c88:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c89:	ba 00 00 00 00       	mov    $0x0,%edx
  800c8e:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c93:	89 d1                	mov    %edx,%ecx
  800c95:	89 d3                	mov    %edx,%ebx
  800c97:	89 d7                	mov    %edx,%edi
  800c99:	89 d6                	mov    %edx,%esi
  800c9b:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c9d:	5b                   	pop    %ebx
  800c9e:	5e                   	pop    %esi
  800c9f:	5f                   	pop    %edi
  800ca0:	5d                   	pop    %ebp
  800ca1:	c3                   	ret    

00800ca2 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800ca2:	55                   	push   %ebp
  800ca3:	89 e5                	mov    %esp,%ebp
  800ca5:	57                   	push   %edi
  800ca6:	56                   	push   %esi
  800ca7:	53                   	push   %ebx
  800ca8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cab:	be 00 00 00 00       	mov    $0x0,%esi
  800cb0:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb6:	b8 04 00 00 00       	mov    $0x4,%eax
  800cbb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cbe:	89 f7                	mov    %esi,%edi
  800cc0:	cd 30                	int    $0x30
	if (check && ret > 0)
  800cc2:	85 c0                	test   %eax,%eax
  800cc4:	7f 08                	jg     800cce <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800cc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cc9:	5b                   	pop    %ebx
  800cca:	5e                   	pop    %esi
  800ccb:	5f                   	pop    %edi
  800ccc:	5d                   	pop    %ebp
  800ccd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cce:	83 ec 0c             	sub    $0xc,%esp
  800cd1:	50                   	push   %eax
  800cd2:	6a 04                	push   $0x4
  800cd4:	68 80 15 80 00       	push   $0x801580
  800cd9:	6a 4c                	push   $0x4c
  800cdb:	68 9d 15 80 00       	push   $0x80159d
  800ce0:	e8 ef 01 00 00       	call   800ed4 <_panic>

00800ce5 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ce5:	55                   	push   %ebp
  800ce6:	89 e5                	mov    %esp,%ebp
  800ce8:	57                   	push   %edi
  800ce9:	56                   	push   %esi
  800cea:	53                   	push   %ebx
  800ceb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cee:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf4:	b8 05 00 00 00       	mov    $0x5,%eax
  800cf9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cfc:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cff:	8b 75 18             	mov    0x18(%ebp),%esi
  800d02:	cd 30                	int    $0x30
	if (check && ret > 0)
  800d04:	85 c0                	test   %eax,%eax
  800d06:	7f 08                	jg     800d10 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d08:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d0b:	5b                   	pop    %ebx
  800d0c:	5e                   	pop    %esi
  800d0d:	5f                   	pop    %edi
  800d0e:	5d                   	pop    %ebp
  800d0f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d10:	83 ec 0c             	sub    $0xc,%esp
  800d13:	50                   	push   %eax
  800d14:	6a 05                	push   $0x5
  800d16:	68 80 15 80 00       	push   $0x801580
  800d1b:	6a 4c                	push   $0x4c
  800d1d:	68 9d 15 80 00       	push   $0x80159d
  800d22:	e8 ad 01 00 00       	call   800ed4 <_panic>

00800d27 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d27:	55                   	push   %ebp
  800d28:	89 e5                	mov    %esp,%ebp
  800d2a:	57                   	push   %edi
  800d2b:	56                   	push   %esi
  800d2c:	53                   	push   %ebx
  800d2d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d30:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d35:	8b 55 08             	mov    0x8(%ebp),%edx
  800d38:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d3b:	b8 06 00 00 00       	mov    $0x6,%eax
  800d40:	89 df                	mov    %ebx,%edi
  800d42:	89 de                	mov    %ebx,%esi
  800d44:	cd 30                	int    $0x30
	if (check && ret > 0)
  800d46:	85 c0                	test   %eax,%eax
  800d48:	7f 08                	jg     800d52 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d4d:	5b                   	pop    %ebx
  800d4e:	5e                   	pop    %esi
  800d4f:	5f                   	pop    %edi
  800d50:	5d                   	pop    %ebp
  800d51:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d52:	83 ec 0c             	sub    $0xc,%esp
  800d55:	50                   	push   %eax
  800d56:	6a 06                	push   $0x6
  800d58:	68 80 15 80 00       	push   $0x801580
  800d5d:	6a 4c                	push   $0x4c
  800d5f:	68 9d 15 80 00       	push   $0x80159d
  800d64:	e8 6b 01 00 00       	call   800ed4 <_panic>

00800d69 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d69:	55                   	push   %ebp
  800d6a:	89 e5                	mov    %esp,%ebp
  800d6c:	57                   	push   %edi
  800d6d:	56                   	push   %esi
  800d6e:	53                   	push   %ebx
  800d6f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d72:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d77:	8b 55 08             	mov    0x8(%ebp),%edx
  800d7a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d7d:	b8 08 00 00 00       	mov    $0x8,%eax
  800d82:	89 df                	mov    %ebx,%edi
  800d84:	89 de                	mov    %ebx,%esi
  800d86:	cd 30                	int    $0x30
	if (check && ret > 0)
  800d88:	85 c0                	test   %eax,%eax
  800d8a:	7f 08                	jg     800d94 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d8f:	5b                   	pop    %ebx
  800d90:	5e                   	pop    %esi
  800d91:	5f                   	pop    %edi
  800d92:	5d                   	pop    %ebp
  800d93:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d94:	83 ec 0c             	sub    $0xc,%esp
  800d97:	50                   	push   %eax
  800d98:	6a 08                	push   $0x8
  800d9a:	68 80 15 80 00       	push   $0x801580
  800d9f:	6a 4c                	push   $0x4c
  800da1:	68 9d 15 80 00       	push   $0x80159d
  800da6:	e8 29 01 00 00       	call   800ed4 <_panic>

00800dab <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800dab:	55                   	push   %ebp
  800dac:	89 e5                	mov    %esp,%ebp
  800dae:	57                   	push   %edi
  800daf:	56                   	push   %esi
  800db0:	53                   	push   %ebx
  800db1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800db4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800db9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dbc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dbf:	b8 09 00 00 00       	mov    $0x9,%eax
  800dc4:	89 df                	mov    %ebx,%edi
  800dc6:	89 de                	mov    %ebx,%esi
  800dc8:	cd 30                	int    $0x30
	if (check && ret > 0)
  800dca:	85 c0                	test   %eax,%eax
  800dcc:	7f 08                	jg     800dd6 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800dce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dd1:	5b                   	pop    %ebx
  800dd2:	5e                   	pop    %esi
  800dd3:	5f                   	pop    %edi
  800dd4:	5d                   	pop    %ebp
  800dd5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dd6:	83 ec 0c             	sub    $0xc,%esp
  800dd9:	50                   	push   %eax
  800dda:	6a 09                	push   $0x9
  800ddc:	68 80 15 80 00       	push   $0x801580
  800de1:	6a 4c                	push   $0x4c
  800de3:	68 9d 15 80 00       	push   $0x80159d
  800de8:	e8 e7 00 00 00       	call   800ed4 <_panic>

00800ded <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ded:	55                   	push   %ebp
  800dee:	89 e5                	mov    %esp,%ebp
  800df0:	57                   	push   %edi
  800df1:	56                   	push   %esi
  800df2:	53                   	push   %ebx
  800df3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800df6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dfb:	8b 55 08             	mov    0x8(%ebp),%edx
  800dfe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e01:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e06:	89 df                	mov    %ebx,%edi
  800e08:	89 de                	mov    %ebx,%esi
  800e0a:	cd 30                	int    $0x30
	if (check && ret > 0)
  800e0c:	85 c0                	test   %eax,%eax
  800e0e:	7f 08                	jg     800e18 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e10:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e13:	5b                   	pop    %ebx
  800e14:	5e                   	pop    %esi
  800e15:	5f                   	pop    %edi
  800e16:	5d                   	pop    %ebp
  800e17:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e18:	83 ec 0c             	sub    $0xc,%esp
  800e1b:	50                   	push   %eax
  800e1c:	6a 0a                	push   $0xa
  800e1e:	68 80 15 80 00       	push   $0x801580
  800e23:	6a 4c                	push   $0x4c
  800e25:	68 9d 15 80 00       	push   $0x80159d
  800e2a:	e8 a5 00 00 00       	call   800ed4 <_panic>

00800e2f <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e2f:	55                   	push   %ebp
  800e30:	89 e5                	mov    %esp,%ebp
  800e32:	57                   	push   %edi
  800e33:	56                   	push   %esi
  800e34:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e35:	8b 55 08             	mov    0x8(%ebp),%edx
  800e38:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e3b:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e40:	be 00 00 00 00       	mov    $0x0,%esi
  800e45:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e48:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e4b:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e4d:	5b                   	pop    %ebx
  800e4e:	5e                   	pop    %esi
  800e4f:	5f                   	pop    %edi
  800e50:	5d                   	pop    %ebp
  800e51:	c3                   	ret    

00800e52 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e52:	55                   	push   %ebp
  800e53:	89 e5                	mov    %esp,%ebp
  800e55:	57                   	push   %edi
  800e56:	56                   	push   %esi
  800e57:	53                   	push   %ebx
  800e58:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e5b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e60:	8b 55 08             	mov    0x8(%ebp),%edx
  800e63:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e68:	89 cb                	mov    %ecx,%ebx
  800e6a:	89 cf                	mov    %ecx,%edi
  800e6c:	89 ce                	mov    %ecx,%esi
  800e6e:	cd 30                	int    $0x30
	if (check && ret > 0)
  800e70:	85 c0                	test   %eax,%eax
  800e72:	7f 08                	jg     800e7c <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e74:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e77:	5b                   	pop    %ebx
  800e78:	5e                   	pop    %esi
  800e79:	5f                   	pop    %edi
  800e7a:	5d                   	pop    %ebp
  800e7b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e7c:	83 ec 0c             	sub    $0xc,%esp
  800e7f:	50                   	push   %eax
  800e80:	6a 0d                	push   $0xd
  800e82:	68 80 15 80 00       	push   $0x801580
  800e87:	6a 4c                	push   $0x4c
  800e89:	68 9d 15 80 00       	push   $0x80159d
  800e8e:	e8 41 00 00 00       	call   800ed4 <_panic>

00800e93 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800e93:	55                   	push   %ebp
  800e94:	89 e5                	mov    %esp,%ebp
  800e96:	57                   	push   %edi
  800e97:	56                   	push   %esi
  800e98:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e99:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e9e:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea4:	b8 0e 00 00 00       	mov    $0xe,%eax
  800ea9:	89 df                	mov    %ebx,%edi
  800eab:	89 de                	mov    %ebx,%esi
  800ead:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800eaf:	5b                   	pop    %ebx
  800eb0:	5e                   	pop    %esi
  800eb1:	5f                   	pop    %edi
  800eb2:	5d                   	pop    %ebp
  800eb3:	c3                   	ret    

00800eb4 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800eb4:	55                   	push   %ebp
  800eb5:	89 e5                	mov    %esp,%ebp
  800eb7:	57                   	push   %edi
  800eb8:	56                   	push   %esi
  800eb9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800eba:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ebf:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec2:	b8 0f 00 00 00       	mov    $0xf,%eax
  800ec7:	89 cb                	mov    %ecx,%ebx
  800ec9:	89 cf                	mov    %ecx,%edi
  800ecb:	89 ce                	mov    %ecx,%esi
  800ecd:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800ecf:	5b                   	pop    %ebx
  800ed0:	5e                   	pop    %esi
  800ed1:	5f                   	pop    %edi
  800ed2:	5d                   	pop    %ebp
  800ed3:	c3                   	ret    

00800ed4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800ed4:	55                   	push   %ebp
  800ed5:	89 e5                	mov    %esp,%ebp
  800ed7:	56                   	push   %esi
  800ed8:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800ed9:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800edc:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800ee2:	e8 7d fd ff ff       	call   800c64 <sys_getenvid>
  800ee7:	83 ec 0c             	sub    $0xc,%esp
  800eea:	ff 75 0c             	pushl  0xc(%ebp)
  800eed:	ff 75 08             	pushl  0x8(%ebp)
  800ef0:	56                   	push   %esi
  800ef1:	50                   	push   %eax
  800ef2:	68 ac 15 80 00       	push   $0x8015ac
  800ef7:	e8 8e f2 ff ff       	call   80018a <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800efc:	83 c4 18             	add    $0x18,%esp
  800eff:	53                   	push   %ebx
  800f00:	ff 75 10             	pushl  0x10(%ebp)
  800f03:	e8 31 f2 ff ff       	call   800139 <vcprintf>
	cprintf("\n");
  800f08:	c7 04 24 d0 15 80 00 	movl   $0x8015d0,(%esp)
  800f0f:	e8 76 f2 ff ff       	call   80018a <cprintf>
  800f14:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800f17:	cc                   	int3   
  800f18:	eb fd                	jmp    800f17 <_panic+0x43>
  800f1a:	66 90                	xchg   %ax,%ax
  800f1c:	66 90                	xchg   %ax,%ax
  800f1e:	66 90                	xchg   %ax,%ax

00800f20 <__udivdi3>:
  800f20:	55                   	push   %ebp
  800f21:	57                   	push   %edi
  800f22:	56                   	push   %esi
  800f23:	53                   	push   %ebx
  800f24:	83 ec 1c             	sub    $0x1c,%esp
  800f27:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800f2b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800f2f:	8b 74 24 34          	mov    0x34(%esp),%esi
  800f33:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800f37:	85 d2                	test   %edx,%edx
  800f39:	75 4d                	jne    800f88 <__udivdi3+0x68>
  800f3b:	39 f3                	cmp    %esi,%ebx
  800f3d:	76 19                	jbe    800f58 <__udivdi3+0x38>
  800f3f:	31 ff                	xor    %edi,%edi
  800f41:	89 e8                	mov    %ebp,%eax
  800f43:	89 f2                	mov    %esi,%edx
  800f45:	f7 f3                	div    %ebx
  800f47:	89 fa                	mov    %edi,%edx
  800f49:	83 c4 1c             	add    $0x1c,%esp
  800f4c:	5b                   	pop    %ebx
  800f4d:	5e                   	pop    %esi
  800f4e:	5f                   	pop    %edi
  800f4f:	5d                   	pop    %ebp
  800f50:	c3                   	ret    
  800f51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f58:	89 d9                	mov    %ebx,%ecx
  800f5a:	85 db                	test   %ebx,%ebx
  800f5c:	75 0b                	jne    800f69 <__udivdi3+0x49>
  800f5e:	b8 01 00 00 00       	mov    $0x1,%eax
  800f63:	31 d2                	xor    %edx,%edx
  800f65:	f7 f3                	div    %ebx
  800f67:	89 c1                	mov    %eax,%ecx
  800f69:	31 d2                	xor    %edx,%edx
  800f6b:	89 f0                	mov    %esi,%eax
  800f6d:	f7 f1                	div    %ecx
  800f6f:	89 c6                	mov    %eax,%esi
  800f71:	89 e8                	mov    %ebp,%eax
  800f73:	89 f7                	mov    %esi,%edi
  800f75:	f7 f1                	div    %ecx
  800f77:	89 fa                	mov    %edi,%edx
  800f79:	83 c4 1c             	add    $0x1c,%esp
  800f7c:	5b                   	pop    %ebx
  800f7d:	5e                   	pop    %esi
  800f7e:	5f                   	pop    %edi
  800f7f:	5d                   	pop    %ebp
  800f80:	c3                   	ret    
  800f81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f88:	39 f2                	cmp    %esi,%edx
  800f8a:	77 1c                	ja     800fa8 <__udivdi3+0x88>
  800f8c:	0f bd fa             	bsr    %edx,%edi
  800f8f:	83 f7 1f             	xor    $0x1f,%edi
  800f92:	75 2c                	jne    800fc0 <__udivdi3+0xa0>
  800f94:	39 f2                	cmp    %esi,%edx
  800f96:	72 06                	jb     800f9e <__udivdi3+0x7e>
  800f98:	31 c0                	xor    %eax,%eax
  800f9a:	39 eb                	cmp    %ebp,%ebx
  800f9c:	77 a9                	ja     800f47 <__udivdi3+0x27>
  800f9e:	b8 01 00 00 00       	mov    $0x1,%eax
  800fa3:	eb a2                	jmp    800f47 <__udivdi3+0x27>
  800fa5:	8d 76 00             	lea    0x0(%esi),%esi
  800fa8:	31 ff                	xor    %edi,%edi
  800faa:	31 c0                	xor    %eax,%eax
  800fac:	89 fa                	mov    %edi,%edx
  800fae:	83 c4 1c             	add    $0x1c,%esp
  800fb1:	5b                   	pop    %ebx
  800fb2:	5e                   	pop    %esi
  800fb3:	5f                   	pop    %edi
  800fb4:	5d                   	pop    %ebp
  800fb5:	c3                   	ret    
  800fb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800fbd:	8d 76 00             	lea    0x0(%esi),%esi
  800fc0:	89 f9                	mov    %edi,%ecx
  800fc2:	b8 20 00 00 00       	mov    $0x20,%eax
  800fc7:	29 f8                	sub    %edi,%eax
  800fc9:	d3 e2                	shl    %cl,%edx
  800fcb:	89 54 24 08          	mov    %edx,0x8(%esp)
  800fcf:	89 c1                	mov    %eax,%ecx
  800fd1:	89 da                	mov    %ebx,%edx
  800fd3:	d3 ea                	shr    %cl,%edx
  800fd5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800fd9:	09 d1                	or     %edx,%ecx
  800fdb:	89 f2                	mov    %esi,%edx
  800fdd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800fe1:	89 f9                	mov    %edi,%ecx
  800fe3:	d3 e3                	shl    %cl,%ebx
  800fe5:	89 c1                	mov    %eax,%ecx
  800fe7:	d3 ea                	shr    %cl,%edx
  800fe9:	89 f9                	mov    %edi,%ecx
  800feb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800fef:	89 eb                	mov    %ebp,%ebx
  800ff1:	d3 e6                	shl    %cl,%esi
  800ff3:	89 c1                	mov    %eax,%ecx
  800ff5:	d3 eb                	shr    %cl,%ebx
  800ff7:	09 de                	or     %ebx,%esi
  800ff9:	89 f0                	mov    %esi,%eax
  800ffb:	f7 74 24 08          	divl   0x8(%esp)
  800fff:	89 d6                	mov    %edx,%esi
  801001:	89 c3                	mov    %eax,%ebx
  801003:	f7 64 24 0c          	mull   0xc(%esp)
  801007:	39 d6                	cmp    %edx,%esi
  801009:	72 15                	jb     801020 <__udivdi3+0x100>
  80100b:	89 f9                	mov    %edi,%ecx
  80100d:	d3 e5                	shl    %cl,%ebp
  80100f:	39 c5                	cmp    %eax,%ebp
  801011:	73 04                	jae    801017 <__udivdi3+0xf7>
  801013:	39 d6                	cmp    %edx,%esi
  801015:	74 09                	je     801020 <__udivdi3+0x100>
  801017:	89 d8                	mov    %ebx,%eax
  801019:	31 ff                	xor    %edi,%edi
  80101b:	e9 27 ff ff ff       	jmp    800f47 <__udivdi3+0x27>
  801020:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801023:	31 ff                	xor    %edi,%edi
  801025:	e9 1d ff ff ff       	jmp    800f47 <__udivdi3+0x27>
  80102a:	66 90                	xchg   %ax,%ax
  80102c:	66 90                	xchg   %ax,%ax
  80102e:	66 90                	xchg   %ax,%ax

00801030 <__umoddi3>:
  801030:	55                   	push   %ebp
  801031:	57                   	push   %edi
  801032:	56                   	push   %esi
  801033:	53                   	push   %ebx
  801034:	83 ec 1c             	sub    $0x1c,%esp
  801037:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80103b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80103f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801043:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801047:	89 da                	mov    %ebx,%edx
  801049:	85 c0                	test   %eax,%eax
  80104b:	75 43                	jne    801090 <__umoddi3+0x60>
  80104d:	39 df                	cmp    %ebx,%edi
  80104f:	76 17                	jbe    801068 <__umoddi3+0x38>
  801051:	89 f0                	mov    %esi,%eax
  801053:	f7 f7                	div    %edi
  801055:	89 d0                	mov    %edx,%eax
  801057:	31 d2                	xor    %edx,%edx
  801059:	83 c4 1c             	add    $0x1c,%esp
  80105c:	5b                   	pop    %ebx
  80105d:	5e                   	pop    %esi
  80105e:	5f                   	pop    %edi
  80105f:	5d                   	pop    %ebp
  801060:	c3                   	ret    
  801061:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801068:	89 fd                	mov    %edi,%ebp
  80106a:	85 ff                	test   %edi,%edi
  80106c:	75 0b                	jne    801079 <__umoddi3+0x49>
  80106e:	b8 01 00 00 00       	mov    $0x1,%eax
  801073:	31 d2                	xor    %edx,%edx
  801075:	f7 f7                	div    %edi
  801077:	89 c5                	mov    %eax,%ebp
  801079:	89 d8                	mov    %ebx,%eax
  80107b:	31 d2                	xor    %edx,%edx
  80107d:	f7 f5                	div    %ebp
  80107f:	89 f0                	mov    %esi,%eax
  801081:	f7 f5                	div    %ebp
  801083:	89 d0                	mov    %edx,%eax
  801085:	eb d0                	jmp    801057 <__umoddi3+0x27>
  801087:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80108e:	66 90                	xchg   %ax,%ax
  801090:	89 f1                	mov    %esi,%ecx
  801092:	39 d8                	cmp    %ebx,%eax
  801094:	76 0a                	jbe    8010a0 <__umoddi3+0x70>
  801096:	89 f0                	mov    %esi,%eax
  801098:	83 c4 1c             	add    $0x1c,%esp
  80109b:	5b                   	pop    %ebx
  80109c:	5e                   	pop    %esi
  80109d:	5f                   	pop    %edi
  80109e:	5d                   	pop    %ebp
  80109f:	c3                   	ret    
  8010a0:	0f bd e8             	bsr    %eax,%ebp
  8010a3:	83 f5 1f             	xor    $0x1f,%ebp
  8010a6:	75 20                	jne    8010c8 <__umoddi3+0x98>
  8010a8:	39 d8                	cmp    %ebx,%eax
  8010aa:	0f 82 b0 00 00 00    	jb     801160 <__umoddi3+0x130>
  8010b0:	39 f7                	cmp    %esi,%edi
  8010b2:	0f 86 a8 00 00 00    	jbe    801160 <__umoddi3+0x130>
  8010b8:	89 c8                	mov    %ecx,%eax
  8010ba:	83 c4 1c             	add    $0x1c,%esp
  8010bd:	5b                   	pop    %ebx
  8010be:	5e                   	pop    %esi
  8010bf:	5f                   	pop    %edi
  8010c0:	5d                   	pop    %ebp
  8010c1:	c3                   	ret    
  8010c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8010c8:	89 e9                	mov    %ebp,%ecx
  8010ca:	ba 20 00 00 00       	mov    $0x20,%edx
  8010cf:	29 ea                	sub    %ebp,%edx
  8010d1:	d3 e0                	shl    %cl,%eax
  8010d3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8010d7:	89 d1                	mov    %edx,%ecx
  8010d9:	89 f8                	mov    %edi,%eax
  8010db:	d3 e8                	shr    %cl,%eax
  8010dd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8010e1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8010e5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8010e9:	09 c1                	or     %eax,%ecx
  8010eb:	89 d8                	mov    %ebx,%eax
  8010ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8010f1:	89 e9                	mov    %ebp,%ecx
  8010f3:	d3 e7                	shl    %cl,%edi
  8010f5:	89 d1                	mov    %edx,%ecx
  8010f7:	d3 e8                	shr    %cl,%eax
  8010f9:	89 e9                	mov    %ebp,%ecx
  8010fb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8010ff:	d3 e3                	shl    %cl,%ebx
  801101:	89 c7                	mov    %eax,%edi
  801103:	89 d1                	mov    %edx,%ecx
  801105:	89 f0                	mov    %esi,%eax
  801107:	d3 e8                	shr    %cl,%eax
  801109:	89 e9                	mov    %ebp,%ecx
  80110b:	89 fa                	mov    %edi,%edx
  80110d:	d3 e6                	shl    %cl,%esi
  80110f:	09 d8                	or     %ebx,%eax
  801111:	f7 74 24 08          	divl   0x8(%esp)
  801115:	89 d1                	mov    %edx,%ecx
  801117:	89 f3                	mov    %esi,%ebx
  801119:	f7 64 24 0c          	mull   0xc(%esp)
  80111d:	89 c6                	mov    %eax,%esi
  80111f:	89 d7                	mov    %edx,%edi
  801121:	39 d1                	cmp    %edx,%ecx
  801123:	72 06                	jb     80112b <__umoddi3+0xfb>
  801125:	75 10                	jne    801137 <__umoddi3+0x107>
  801127:	39 c3                	cmp    %eax,%ebx
  801129:	73 0c                	jae    801137 <__umoddi3+0x107>
  80112b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80112f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801133:	89 d7                	mov    %edx,%edi
  801135:	89 c6                	mov    %eax,%esi
  801137:	89 ca                	mov    %ecx,%edx
  801139:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80113e:	29 f3                	sub    %esi,%ebx
  801140:	19 fa                	sbb    %edi,%edx
  801142:	89 d0                	mov    %edx,%eax
  801144:	d3 e0                	shl    %cl,%eax
  801146:	89 e9                	mov    %ebp,%ecx
  801148:	d3 eb                	shr    %cl,%ebx
  80114a:	d3 ea                	shr    %cl,%edx
  80114c:	09 d8                	or     %ebx,%eax
  80114e:	83 c4 1c             	add    $0x1c,%esp
  801151:	5b                   	pop    %ebx
  801152:	5e                   	pop    %esi
  801153:	5f                   	pop    %edi
  801154:	5d                   	pop    %ebp
  801155:	c3                   	ret    
  801156:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80115d:	8d 76 00             	lea    0x0(%esi),%esi
  801160:	89 da                	mov    %ebx,%edx
  801162:	29 fe                	sub    %edi,%esi
  801164:	19 c2                	sbb    %eax,%edx
  801166:	89 f1                	mov    %esi,%ecx
  801168:	89 c8                	mov    %ecx,%eax
  80116a:	e9 4b ff ff ff       	jmp    8010ba <__umoddi3+0x8a>
