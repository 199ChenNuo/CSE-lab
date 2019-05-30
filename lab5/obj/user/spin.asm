
obj/user/spin.debug:     file format elf32-i386


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

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 10             	sub    $0x10,%esp
	envid_t env;

	cprintf("I am the parent.  Forking the child...\n");
  80003a:	68 40 16 80 00       	push   $0x801640
  80003f:	e8 61 01 00 00       	call   8001a5 <cprintf>
	if ((env = fork()) == 0) {
  800044:	e8 a2 0f 00 00       	call   800feb <fork>
  800049:	83 c4 10             	add    $0x10,%esp
  80004c:	85 c0                	test   %eax,%eax
  80004e:	75 12                	jne    800062 <umain+0x2f>
		cprintf("I am the child.  Spinning...\n");
  800050:	83 ec 0c             	sub    $0xc,%esp
  800053:	68 b8 16 80 00       	push   $0x8016b8
  800058:	e8 48 01 00 00       	call   8001a5 <cprintf>
  80005d:	83 c4 10             	add    $0x10,%esp
  800060:	eb fe                	jmp    800060 <umain+0x2d>
  800062:	89 c3                	mov    %eax,%ebx
		while (1)
			/* do nothing */;
	}

	cprintf("I am the parent.  Running the child...\n");
  800064:	83 ec 0c             	sub    $0xc,%esp
  800067:	68 68 16 80 00       	push   $0x801668
  80006c:	e8 34 01 00 00       	call   8001a5 <cprintf>
	sys_yield();
  800071:	e8 28 0c 00 00       	call   800c9e <sys_yield>
	sys_yield();
  800076:	e8 23 0c 00 00       	call   800c9e <sys_yield>
	sys_yield();
  80007b:	e8 1e 0c 00 00       	call   800c9e <sys_yield>
	sys_yield();
  800080:	e8 19 0c 00 00       	call   800c9e <sys_yield>
	sys_yield();
  800085:	e8 14 0c 00 00       	call   800c9e <sys_yield>
	sys_yield();
  80008a:	e8 0f 0c 00 00       	call   800c9e <sys_yield>
	sys_yield();
  80008f:	e8 0a 0c 00 00       	call   800c9e <sys_yield>
	sys_yield();
  800094:	e8 05 0c 00 00       	call   800c9e <sys_yield>

	cprintf("I am the parent.  Killing the child...\n");
  800099:	c7 04 24 90 16 80 00 	movl   $0x801690,(%esp)
  8000a0:	e8 00 01 00 00       	call   8001a5 <cprintf>
	sys_env_destroy(env);
  8000a5:	89 1c 24             	mov    %ebx,(%esp)
  8000a8:	e8 91 0b 00 00       	call   800c3e <sys_env_destroy>
}
  8000ad:	83 c4 10             	add    $0x10,%esp
  8000b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
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
  8000c0:	e8 ba 0b 00 00       	call   800c7f <sys_getenvid>
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
  8000ea:	e8 44 ff ff ff       	call   800033 <umain>

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
  800106:	e8 33 0b 00 00       	call   800c3e <sys_env_destroy>
}
  80010b:	83 c4 10             	add    $0x10,%esp
  80010e:	c9                   	leave  
  80010f:	c3                   	ret    

00800110 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800110:	55                   	push   %ebp
  800111:	89 e5                	mov    %esp,%ebp
  800113:	53                   	push   %ebx
  800114:	83 ec 04             	sub    $0x4,%esp
  800117:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80011a:	8b 13                	mov    (%ebx),%edx
  80011c:	8d 42 01             	lea    0x1(%edx),%eax
  80011f:	89 03                	mov    %eax,(%ebx)
  800121:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800124:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800128:	3d ff 00 00 00       	cmp    $0xff,%eax
  80012d:	74 09                	je     800138 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80012f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800133:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800136:	c9                   	leave  
  800137:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800138:	83 ec 08             	sub    $0x8,%esp
  80013b:	68 ff 00 00 00       	push   $0xff
  800140:	8d 43 08             	lea    0x8(%ebx),%eax
  800143:	50                   	push   %eax
  800144:	e8 b8 0a 00 00       	call   800c01 <sys_cputs>
		b->idx = 0;
  800149:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80014f:	83 c4 10             	add    $0x10,%esp
  800152:	eb db                	jmp    80012f <putch+0x1f>

00800154 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800154:	55                   	push   %ebp
  800155:	89 e5                	mov    %esp,%ebp
  800157:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80015d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800164:	00 00 00 
	b.cnt = 0;
  800167:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80016e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800171:	ff 75 0c             	pushl  0xc(%ebp)
  800174:	ff 75 08             	pushl  0x8(%ebp)
  800177:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80017d:	50                   	push   %eax
  80017e:	68 10 01 80 00       	push   $0x800110
  800183:	e8 4a 01 00 00       	call   8002d2 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800188:	83 c4 08             	add    $0x8,%esp
  80018b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800191:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800197:	50                   	push   %eax
  800198:	e8 64 0a 00 00       	call   800c01 <sys_cputs>

	return b.cnt;
}
  80019d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001a3:	c9                   	leave  
  8001a4:	c3                   	ret    

008001a5 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001a5:	55                   	push   %ebp
  8001a6:	89 e5                	mov    %esp,%ebp
  8001a8:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001ab:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001ae:	50                   	push   %eax
  8001af:	ff 75 08             	pushl  0x8(%ebp)
  8001b2:	e8 9d ff ff ff       	call   800154 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001b7:	c9                   	leave  
  8001b8:	c3                   	ret    

008001b9 <printnum>:


static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001b9:	55                   	push   %ebp
  8001ba:	89 e5                	mov    %esp,%ebp
  8001bc:	57                   	push   %edi
  8001bd:	56                   	push   %esi
  8001be:	53                   	push   %ebx
  8001bf:	83 ec 1c             	sub    $0x1c,%esp
  8001c2:	89 c6                	mov    %eax,%esi
  8001c4:	89 d7                	mov    %edx,%edi
  8001c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8001c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001cf:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8001d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8001d5:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	// to support '-'
	if(padc == '-'){
  8001d8:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8001dc:	74 2c                	je     80020a <printnum+0x51>
		while (--width > 0)
			putch(' ', putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001de:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001e1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8001e8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8001eb:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8001ee:	39 c2                	cmp    %eax,%edx
  8001f0:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8001f3:	73 43                	jae    800238 <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8001f5:	83 eb 01             	sub    $0x1,%ebx
  8001f8:	85 db                	test   %ebx,%ebx
  8001fa:	7e 6c                	jle    800268 <printnum+0xaf>
			putch(padc, putdat);
  8001fc:	83 ec 08             	sub    $0x8,%esp
  8001ff:	57                   	push   %edi
  800200:	ff 75 18             	pushl  0x18(%ebp)
  800203:	ff d6                	call   *%esi
  800205:	83 c4 10             	add    $0x10,%esp
  800208:	eb eb                	jmp    8001f5 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80020a:	83 ec 0c             	sub    $0xc,%esp
  80020d:	6a 20                	push   $0x20
  80020f:	6a 00                	push   $0x0
  800211:	50                   	push   %eax
  800212:	ff 75 e4             	pushl  -0x1c(%ebp)
  800215:	ff 75 e0             	pushl  -0x20(%ebp)
  800218:	89 fa                	mov    %edi,%edx
  80021a:	89 f0                	mov    %esi,%eax
  80021c:	e8 98 ff ff ff       	call   8001b9 <printnum>
		while (--width > 0)
  800221:	83 c4 20             	add    $0x20,%esp
  800224:	83 eb 01             	sub    $0x1,%ebx
  800227:	85 db                	test   %ebx,%ebx
  800229:	7e 65                	jle    800290 <printnum+0xd7>
			putch(' ', putdat);
  80022b:	83 ec 08             	sub    $0x8,%esp
  80022e:	57                   	push   %edi
  80022f:	6a 20                	push   $0x20
  800231:	ff d6                	call   *%esi
  800233:	83 c4 10             	add    $0x10,%esp
  800236:	eb ec                	jmp    800224 <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800238:	83 ec 0c             	sub    $0xc,%esp
  80023b:	ff 75 18             	pushl  0x18(%ebp)
  80023e:	83 eb 01             	sub    $0x1,%ebx
  800241:	53                   	push   %ebx
  800242:	50                   	push   %eax
  800243:	83 ec 08             	sub    $0x8,%esp
  800246:	ff 75 dc             	pushl  -0x24(%ebp)
  800249:	ff 75 d8             	pushl  -0x28(%ebp)
  80024c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80024f:	ff 75 e0             	pushl  -0x20(%ebp)
  800252:	e8 99 11 00 00       	call   8013f0 <__udivdi3>
  800257:	83 c4 18             	add    $0x18,%esp
  80025a:	52                   	push   %edx
  80025b:	50                   	push   %eax
  80025c:	89 fa                	mov    %edi,%edx
  80025e:	89 f0                	mov    %esi,%eax
  800260:	e8 54 ff ff ff       	call   8001b9 <printnum>
  800265:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800268:	83 ec 08             	sub    $0x8,%esp
  80026b:	57                   	push   %edi
  80026c:	83 ec 04             	sub    $0x4,%esp
  80026f:	ff 75 dc             	pushl  -0x24(%ebp)
  800272:	ff 75 d8             	pushl  -0x28(%ebp)
  800275:	ff 75 e4             	pushl  -0x1c(%ebp)
  800278:	ff 75 e0             	pushl  -0x20(%ebp)
  80027b:	e8 80 12 00 00       	call   801500 <__umoddi3>
  800280:	83 c4 14             	add    $0x14,%esp
  800283:	0f be 80 e0 16 80 00 	movsbl 0x8016e0(%eax),%eax
  80028a:	50                   	push   %eax
  80028b:	ff d6                	call   *%esi
  80028d:	83 c4 10             	add    $0x10,%esp
}
  800290:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800293:	5b                   	pop    %ebx
  800294:	5e                   	pop    %esi
  800295:	5f                   	pop    %edi
  800296:	5d                   	pop    %ebp
  800297:	c3                   	ret    

00800298 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800298:	55                   	push   %ebp
  800299:	89 e5                	mov    %esp,%ebp
  80029b:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80029e:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002a2:	8b 10                	mov    (%eax),%edx
  8002a4:	3b 50 04             	cmp    0x4(%eax),%edx
  8002a7:	73 0a                	jae    8002b3 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002a9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002ac:	89 08                	mov    %ecx,(%eax)
  8002ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b1:	88 02                	mov    %al,(%edx)
}
  8002b3:	5d                   	pop    %ebp
  8002b4:	c3                   	ret    

008002b5 <printfmt>:
{
  8002b5:	55                   	push   %ebp
  8002b6:	89 e5                	mov    %esp,%ebp
  8002b8:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002bb:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002be:	50                   	push   %eax
  8002bf:	ff 75 10             	pushl  0x10(%ebp)
  8002c2:	ff 75 0c             	pushl  0xc(%ebp)
  8002c5:	ff 75 08             	pushl  0x8(%ebp)
  8002c8:	e8 05 00 00 00       	call   8002d2 <vprintfmt>
}
  8002cd:	83 c4 10             	add    $0x10,%esp
  8002d0:	c9                   	leave  
  8002d1:	c3                   	ret    

008002d2 <vprintfmt>:
{
  8002d2:	55                   	push   %ebp
  8002d3:	89 e5                	mov    %esp,%ebp
  8002d5:	57                   	push   %edi
  8002d6:	56                   	push   %esi
  8002d7:	53                   	push   %ebx
  8002d8:	83 ec 3c             	sub    $0x3c,%esp
  8002db:	8b 75 08             	mov    0x8(%ebp),%esi
  8002de:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002e1:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002e4:	e9 1e 04 00 00       	jmp    800707 <vprintfmt+0x435>
		posflag = 0;
  8002e9:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
		padc = ' ';
  8002f0:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8002f4:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8002fb:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800302:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800309:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  800310:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800315:	8d 47 01             	lea    0x1(%edi),%eax
  800318:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80031b:	0f b6 17             	movzbl (%edi),%edx
  80031e:	8d 42 dd             	lea    -0x23(%edx),%eax
  800321:	3c 55                	cmp    $0x55,%al
  800323:	0f 87 d9 04 00 00    	ja     800802 <vprintfmt+0x530>
  800329:	0f b6 c0             	movzbl %al,%eax
  80032c:	ff 24 85 c0 18 80 00 	jmp    *0x8018c0(,%eax,4)
  800333:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800336:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80033a:	eb d9                	jmp    800315 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80033c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posflag = 1;
  80033f:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  800346:	eb cd                	jmp    800315 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800348:	0f b6 d2             	movzbl %dl,%edx
  80034b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80034e:	b8 00 00 00 00       	mov    $0x0,%eax
  800353:	89 75 08             	mov    %esi,0x8(%ebp)
  800356:	eb 0c                	jmp    800364 <vprintfmt+0x92>
		switch (ch = *(unsigned char *) fmt++) {
  800358:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80035b:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  80035f:	eb b4                	jmp    800315 <vprintfmt+0x43>
			for (precision = 0; ; ++fmt) {
  800361:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800364:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800367:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80036b:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80036e:	8d 72 d0             	lea    -0x30(%edx),%esi
  800371:	83 fe 09             	cmp    $0x9,%esi
  800374:	76 eb                	jbe    800361 <vprintfmt+0x8f>
  800376:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800379:	8b 75 08             	mov    0x8(%ebp),%esi
  80037c:	eb 14                	jmp    800392 <vprintfmt+0xc0>
			precision = va_arg(ap, int);
  80037e:	8b 45 14             	mov    0x14(%ebp),%eax
  800381:	8b 00                	mov    (%eax),%eax
  800383:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800386:	8b 45 14             	mov    0x14(%ebp),%eax
  800389:	8d 40 04             	lea    0x4(%eax),%eax
  80038c:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80038f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800392:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800396:	0f 89 79 ff ff ff    	jns    800315 <vprintfmt+0x43>
				width = precision, precision = -1;
  80039c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80039f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003a2:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003a9:	e9 67 ff ff ff       	jmp    800315 <vprintfmt+0x43>
  8003ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003b1:	85 c0                	test   %eax,%eax
  8003b3:	0f 48 c1             	cmovs  %ecx,%eax
  8003b6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003b9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003bc:	e9 54 ff ff ff       	jmp    800315 <vprintfmt+0x43>
  8003c1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003c4:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8003cb:	e9 45 ff ff ff       	jmp    800315 <vprintfmt+0x43>
			lflag++;
  8003d0:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003d4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003d7:	e9 39 ff ff ff       	jmp    800315 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8003dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8003df:	8d 78 04             	lea    0x4(%eax),%edi
  8003e2:	83 ec 08             	sub    $0x8,%esp
  8003e5:	53                   	push   %ebx
  8003e6:	ff 30                	pushl  (%eax)
  8003e8:	ff d6                	call   *%esi
			break;
  8003ea:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003ed:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003f0:	e9 0f 03 00 00       	jmp    800704 <vprintfmt+0x432>
			err = va_arg(ap, int);
  8003f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f8:	8d 78 04             	lea    0x4(%eax),%edi
  8003fb:	8b 00                	mov    (%eax),%eax
  8003fd:	99                   	cltd   
  8003fe:	31 d0                	xor    %edx,%eax
  800400:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800402:	83 f8 0f             	cmp    $0xf,%eax
  800405:	7f 23                	jg     80042a <vprintfmt+0x158>
  800407:	8b 14 85 20 1a 80 00 	mov    0x801a20(,%eax,4),%edx
  80040e:	85 d2                	test   %edx,%edx
  800410:	74 18                	je     80042a <vprintfmt+0x158>
				printfmt(putch, putdat, "%s", p);
  800412:	52                   	push   %edx
  800413:	68 01 17 80 00       	push   $0x801701
  800418:	53                   	push   %ebx
  800419:	56                   	push   %esi
  80041a:	e8 96 fe ff ff       	call   8002b5 <printfmt>
  80041f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800422:	89 7d 14             	mov    %edi,0x14(%ebp)
  800425:	e9 da 02 00 00       	jmp    800704 <vprintfmt+0x432>
				printfmt(putch, putdat, "error %d", err);
  80042a:	50                   	push   %eax
  80042b:	68 f8 16 80 00       	push   $0x8016f8
  800430:	53                   	push   %ebx
  800431:	56                   	push   %esi
  800432:	e8 7e fe ff ff       	call   8002b5 <printfmt>
  800437:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80043a:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80043d:	e9 c2 02 00 00       	jmp    800704 <vprintfmt+0x432>
			if ((p = va_arg(ap, char *)) == NULL)
  800442:	8b 45 14             	mov    0x14(%ebp),%eax
  800445:	83 c0 04             	add    $0x4,%eax
  800448:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80044b:	8b 45 14             	mov    0x14(%ebp),%eax
  80044e:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800450:	85 c9                	test   %ecx,%ecx
  800452:	b8 f1 16 80 00       	mov    $0x8016f1,%eax
  800457:	0f 45 c1             	cmovne %ecx,%eax
  80045a:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80045d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800461:	7e 06                	jle    800469 <vprintfmt+0x197>
  800463:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800467:	75 0d                	jne    800476 <vprintfmt+0x1a4>
				for (width -= strnlen(p, precision); width > 0; width--)
  800469:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80046c:	89 c7                	mov    %eax,%edi
  80046e:	03 45 e0             	add    -0x20(%ebp),%eax
  800471:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800474:	eb 53                	jmp    8004c9 <vprintfmt+0x1f7>
  800476:	83 ec 08             	sub    $0x8,%esp
  800479:	ff 75 d8             	pushl  -0x28(%ebp)
  80047c:	50                   	push   %eax
  80047d:	e8 28 04 00 00       	call   8008aa <strnlen>
  800482:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800485:	29 c1                	sub    %eax,%ecx
  800487:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  80048a:	83 c4 10             	add    $0x10,%esp
  80048d:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  80048f:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800493:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800496:	eb 0f                	jmp    8004a7 <vprintfmt+0x1d5>
					putch(padc, putdat);
  800498:	83 ec 08             	sub    $0x8,%esp
  80049b:	53                   	push   %ebx
  80049c:	ff 75 e0             	pushl  -0x20(%ebp)
  80049f:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004a1:	83 ef 01             	sub    $0x1,%edi
  8004a4:	83 c4 10             	add    $0x10,%esp
  8004a7:	85 ff                	test   %edi,%edi
  8004a9:	7f ed                	jg     800498 <vprintfmt+0x1c6>
  8004ab:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  8004ae:	85 c9                	test   %ecx,%ecx
  8004b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8004b5:	0f 49 c1             	cmovns %ecx,%eax
  8004b8:	29 c1                	sub    %eax,%ecx
  8004ba:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8004bd:	eb aa                	jmp    800469 <vprintfmt+0x197>
					putch(ch, putdat);
  8004bf:	83 ec 08             	sub    $0x8,%esp
  8004c2:	53                   	push   %ebx
  8004c3:	52                   	push   %edx
  8004c4:	ff d6                	call   *%esi
  8004c6:	83 c4 10             	add    $0x10,%esp
  8004c9:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004cc:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004ce:	83 c7 01             	add    $0x1,%edi
  8004d1:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004d5:	0f be d0             	movsbl %al,%edx
  8004d8:	85 d2                	test   %edx,%edx
  8004da:	74 4b                	je     800527 <vprintfmt+0x255>
  8004dc:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004e0:	78 06                	js     8004e8 <vprintfmt+0x216>
  8004e2:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004e6:	78 1e                	js     800506 <vprintfmt+0x234>
				if (altflag && (ch < ' ' || ch > '~'))
  8004e8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004ec:	74 d1                	je     8004bf <vprintfmt+0x1ed>
  8004ee:	0f be c0             	movsbl %al,%eax
  8004f1:	83 e8 20             	sub    $0x20,%eax
  8004f4:	83 f8 5e             	cmp    $0x5e,%eax
  8004f7:	76 c6                	jbe    8004bf <vprintfmt+0x1ed>
					putch('?', putdat);
  8004f9:	83 ec 08             	sub    $0x8,%esp
  8004fc:	53                   	push   %ebx
  8004fd:	6a 3f                	push   $0x3f
  8004ff:	ff d6                	call   *%esi
  800501:	83 c4 10             	add    $0x10,%esp
  800504:	eb c3                	jmp    8004c9 <vprintfmt+0x1f7>
  800506:	89 cf                	mov    %ecx,%edi
  800508:	eb 0e                	jmp    800518 <vprintfmt+0x246>
				putch(' ', putdat);
  80050a:	83 ec 08             	sub    $0x8,%esp
  80050d:	53                   	push   %ebx
  80050e:	6a 20                	push   $0x20
  800510:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800512:	83 ef 01             	sub    $0x1,%edi
  800515:	83 c4 10             	add    $0x10,%esp
  800518:	85 ff                	test   %edi,%edi
  80051a:	7f ee                	jg     80050a <vprintfmt+0x238>
			if ((p = va_arg(ap, char *)) == NULL)
  80051c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80051f:	89 45 14             	mov    %eax,0x14(%ebp)
  800522:	e9 dd 01 00 00       	jmp    800704 <vprintfmt+0x432>
  800527:	89 cf                	mov    %ecx,%edi
  800529:	eb ed                	jmp    800518 <vprintfmt+0x246>
	if (lflag >= 2)
  80052b:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  80052f:	7f 21                	jg     800552 <vprintfmt+0x280>
	else if (lflag)
  800531:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800535:	74 6a                	je     8005a1 <vprintfmt+0x2cf>
		return va_arg(*ap, long);
  800537:	8b 45 14             	mov    0x14(%ebp),%eax
  80053a:	8b 00                	mov    (%eax),%eax
  80053c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80053f:	89 c1                	mov    %eax,%ecx
  800541:	c1 f9 1f             	sar    $0x1f,%ecx
  800544:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800547:	8b 45 14             	mov    0x14(%ebp),%eax
  80054a:	8d 40 04             	lea    0x4(%eax),%eax
  80054d:	89 45 14             	mov    %eax,0x14(%ebp)
  800550:	eb 17                	jmp    800569 <vprintfmt+0x297>
		return va_arg(*ap, long long);
  800552:	8b 45 14             	mov    0x14(%ebp),%eax
  800555:	8b 50 04             	mov    0x4(%eax),%edx
  800558:	8b 00                	mov    (%eax),%eax
  80055a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80055d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800560:	8b 45 14             	mov    0x14(%ebp),%eax
  800563:	8d 40 08             	lea    0x8(%eax),%eax
  800566:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800569:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  80056c:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800571:	85 d2                	test   %edx,%edx
  800573:	0f 89 5c 01 00 00    	jns    8006d5 <vprintfmt+0x403>
				putch('-', putdat);
  800579:	83 ec 08             	sub    $0x8,%esp
  80057c:	53                   	push   %ebx
  80057d:	6a 2d                	push   $0x2d
  80057f:	ff d6                	call   *%esi
				num = -(long long) num;
  800581:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800584:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800587:	f7 d8                	neg    %eax
  800589:	83 d2 00             	adc    $0x0,%edx
  80058c:	f7 da                	neg    %edx
  80058e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800591:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800594:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800597:	bf 0a 00 00 00       	mov    $0xa,%edi
  80059c:	e9 45 01 00 00       	jmp    8006e6 <vprintfmt+0x414>
		return va_arg(*ap, int);
  8005a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a4:	8b 00                	mov    (%eax),%eax
  8005a6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005a9:	89 c1                	mov    %eax,%ecx
  8005ab:	c1 f9 1f             	sar    $0x1f,%ecx
  8005ae:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b4:	8d 40 04             	lea    0x4(%eax),%eax
  8005b7:	89 45 14             	mov    %eax,0x14(%ebp)
  8005ba:	eb ad                	jmp    800569 <vprintfmt+0x297>
	if (lflag >= 2)
  8005bc:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8005c0:	7f 29                	jg     8005eb <vprintfmt+0x319>
	else if (lflag)
  8005c2:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8005c6:	74 44                	je     80060c <vprintfmt+0x33a>
		return va_arg(*ap, unsigned long);
  8005c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cb:	8b 00                	mov    (%eax),%eax
  8005cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8005d2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005d5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005db:	8d 40 04             	lea    0x4(%eax),%eax
  8005de:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005e1:	bf 0a 00 00 00       	mov    $0xa,%edi
  8005e6:	e9 ea 00 00 00       	jmp    8006d5 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  8005eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ee:	8b 50 04             	mov    0x4(%eax),%edx
  8005f1:	8b 00                	mov    (%eax),%eax
  8005f3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005f6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fc:	8d 40 08             	lea    0x8(%eax),%eax
  8005ff:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800602:	bf 0a 00 00 00       	mov    $0xa,%edi
  800607:	e9 c9 00 00 00       	jmp    8006d5 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  80060c:	8b 45 14             	mov    0x14(%ebp),%eax
  80060f:	8b 00                	mov    (%eax),%eax
  800611:	ba 00 00 00 00       	mov    $0x0,%edx
  800616:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800619:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80061c:	8b 45 14             	mov    0x14(%ebp),%eax
  80061f:	8d 40 04             	lea    0x4(%eax),%eax
  800622:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800625:	bf 0a 00 00 00       	mov    $0xa,%edi
  80062a:	e9 a6 00 00 00       	jmp    8006d5 <vprintfmt+0x403>
			putch('0', putdat);
  80062f:	83 ec 08             	sub    $0x8,%esp
  800632:	53                   	push   %ebx
  800633:	6a 30                	push   $0x30
  800635:	ff d6                	call   *%esi
	if (lflag >= 2)
  800637:	83 c4 10             	add    $0x10,%esp
  80063a:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  80063e:	7f 26                	jg     800666 <vprintfmt+0x394>
	else if (lflag)
  800640:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800644:	74 3e                	je     800684 <vprintfmt+0x3b2>
		return va_arg(*ap, unsigned long);
  800646:	8b 45 14             	mov    0x14(%ebp),%eax
  800649:	8b 00                	mov    (%eax),%eax
  80064b:	ba 00 00 00 00       	mov    $0x0,%edx
  800650:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800653:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800656:	8b 45 14             	mov    0x14(%ebp),%eax
  800659:	8d 40 04             	lea    0x4(%eax),%eax
  80065c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80065f:	bf 08 00 00 00       	mov    $0x8,%edi
  800664:	eb 6f                	jmp    8006d5 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  800666:	8b 45 14             	mov    0x14(%ebp),%eax
  800669:	8b 50 04             	mov    0x4(%eax),%edx
  80066c:	8b 00                	mov    (%eax),%eax
  80066e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800671:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800674:	8b 45 14             	mov    0x14(%ebp),%eax
  800677:	8d 40 08             	lea    0x8(%eax),%eax
  80067a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80067d:	bf 08 00 00 00       	mov    $0x8,%edi
  800682:	eb 51                	jmp    8006d5 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  800684:	8b 45 14             	mov    0x14(%ebp),%eax
  800687:	8b 00                	mov    (%eax),%eax
  800689:	ba 00 00 00 00       	mov    $0x0,%edx
  80068e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800691:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800694:	8b 45 14             	mov    0x14(%ebp),%eax
  800697:	8d 40 04             	lea    0x4(%eax),%eax
  80069a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80069d:	bf 08 00 00 00       	mov    $0x8,%edi
  8006a2:	eb 31                	jmp    8006d5 <vprintfmt+0x403>
			putch('0', putdat);
  8006a4:	83 ec 08             	sub    $0x8,%esp
  8006a7:	53                   	push   %ebx
  8006a8:	6a 30                	push   $0x30
  8006aa:	ff d6                	call   *%esi
			putch('x', putdat);
  8006ac:	83 c4 08             	add    $0x8,%esp
  8006af:	53                   	push   %ebx
  8006b0:	6a 78                	push   $0x78
  8006b2:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b7:	8b 00                	mov    (%eax),%eax
  8006b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8006be:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006c1:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8006c4:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ca:	8d 40 04             	lea    0x4(%eax),%eax
  8006cd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006d0:	bf 10 00 00 00       	mov    $0x10,%edi
			if(posflag)
  8006d5:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006d9:	74 0b                	je     8006e6 <vprintfmt+0x414>
				putch('+', putdat);
  8006db:	83 ec 08             	sub    $0x8,%esp
  8006de:	53                   	push   %ebx
  8006df:	6a 2b                	push   $0x2b
  8006e1:	ff d6                	call   *%esi
  8006e3:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  8006e6:	83 ec 0c             	sub    $0xc,%esp
  8006e9:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8006ed:	50                   	push   %eax
  8006ee:	ff 75 e0             	pushl  -0x20(%ebp)
  8006f1:	57                   	push   %edi
  8006f2:	ff 75 dc             	pushl  -0x24(%ebp)
  8006f5:	ff 75 d8             	pushl  -0x28(%ebp)
  8006f8:	89 da                	mov    %ebx,%edx
  8006fa:	89 f0                	mov    %esi,%eax
  8006fc:	e8 b8 fa ff ff       	call   8001b9 <printnum>
			break;
  800701:	83 c4 20             	add    $0x20,%esp
			char* cp = va_arg(ap, char *);
  800704:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800707:	83 c7 01             	add    $0x1,%edi
  80070a:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80070e:	83 f8 25             	cmp    $0x25,%eax
  800711:	0f 84 d2 fb ff ff    	je     8002e9 <vprintfmt+0x17>
			if (ch == '\0')
  800717:	85 c0                	test   %eax,%eax
  800719:	0f 84 03 01 00 00    	je     800822 <vprintfmt+0x550>
			putch(ch, putdat);
  80071f:	83 ec 08             	sub    $0x8,%esp
  800722:	53                   	push   %ebx
  800723:	50                   	push   %eax
  800724:	ff d6                	call   *%esi
  800726:	83 c4 10             	add    $0x10,%esp
  800729:	eb dc                	jmp    800707 <vprintfmt+0x435>
	if (lflag >= 2)
  80072b:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  80072f:	7f 29                	jg     80075a <vprintfmt+0x488>
	else if (lflag)
  800731:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800735:	74 44                	je     80077b <vprintfmt+0x4a9>
		return va_arg(*ap, unsigned long);
  800737:	8b 45 14             	mov    0x14(%ebp),%eax
  80073a:	8b 00                	mov    (%eax),%eax
  80073c:	ba 00 00 00 00       	mov    $0x0,%edx
  800741:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800744:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800747:	8b 45 14             	mov    0x14(%ebp),%eax
  80074a:	8d 40 04             	lea    0x4(%eax),%eax
  80074d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800750:	bf 10 00 00 00       	mov    $0x10,%edi
  800755:	e9 7b ff ff ff       	jmp    8006d5 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  80075a:	8b 45 14             	mov    0x14(%ebp),%eax
  80075d:	8b 50 04             	mov    0x4(%eax),%edx
  800760:	8b 00                	mov    (%eax),%eax
  800762:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800765:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800768:	8b 45 14             	mov    0x14(%ebp),%eax
  80076b:	8d 40 08             	lea    0x8(%eax),%eax
  80076e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800771:	bf 10 00 00 00       	mov    $0x10,%edi
  800776:	e9 5a ff ff ff       	jmp    8006d5 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  80077b:	8b 45 14             	mov    0x14(%ebp),%eax
  80077e:	8b 00                	mov    (%eax),%eax
  800780:	ba 00 00 00 00       	mov    $0x0,%edx
  800785:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800788:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80078b:	8b 45 14             	mov    0x14(%ebp),%eax
  80078e:	8d 40 04             	lea    0x4(%eax),%eax
  800791:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800794:	bf 10 00 00 00       	mov    $0x10,%edi
  800799:	e9 37 ff ff ff       	jmp    8006d5 <vprintfmt+0x403>
			char* cp = va_arg(ap, char *);
  80079e:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a1:	8d 78 04             	lea    0x4(%eax),%edi
  8007a4:	8b 00                	mov    (%eax),%eax
    			if (cp == NULL) {
  8007a6:	85 c0                	test   %eax,%eax
  8007a8:	74 2c                	je     8007d6 <vprintfmt+0x504>
    			*cp = *(int *)putdat;
  8007aa:	8b 13                	mov    (%ebx),%edx
  8007ac:	88 10                	mov    %dl,(%eax)
			char* cp = va_arg(ap, char *);
  8007ae:	89 7d 14             	mov    %edi,0x14(%ebp)
    			if ((*(int *) putdat) > 127)
  8007b1:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  8007b4:	0f 8e 4a ff ff ff    	jle    800704 <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", overflow_error);
  8007ba:	68 50 18 80 00       	push   $0x801850
  8007bf:	68 01 17 80 00       	push   $0x801701
  8007c4:	53                   	push   %ebx
  8007c5:	56                   	push   %esi
  8007c6:	e8 ea fa ff ff       	call   8002b5 <printfmt>
  8007cb:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  8007ce:	89 7d 14             	mov    %edi,0x14(%ebp)
  8007d1:	e9 2e ff ff ff       	jmp    800704 <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", null_error);
  8007d6:	68 18 18 80 00       	push   $0x801818
  8007db:	68 01 17 80 00       	push   $0x801701
  8007e0:	53                   	push   %ebx
  8007e1:	56                   	push   %esi
  8007e2:	e8 ce fa ff ff       	call   8002b5 <printfmt>
        		break;
  8007e7:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  8007ea:	89 7d 14             	mov    %edi,0x14(%ebp)
        		break;
  8007ed:	e9 12 ff ff ff       	jmp    800704 <vprintfmt+0x432>
			putch(ch, putdat);
  8007f2:	83 ec 08             	sub    $0x8,%esp
  8007f5:	53                   	push   %ebx
  8007f6:	6a 25                	push   $0x25
  8007f8:	ff d6                	call   *%esi
			break;
  8007fa:	83 c4 10             	add    $0x10,%esp
  8007fd:	e9 02 ff ff ff       	jmp    800704 <vprintfmt+0x432>
			putch('%', putdat);
  800802:	83 ec 08             	sub    $0x8,%esp
  800805:	53                   	push   %ebx
  800806:	6a 25                	push   $0x25
  800808:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80080a:	83 c4 10             	add    $0x10,%esp
  80080d:	89 f8                	mov    %edi,%eax
  80080f:	eb 03                	jmp    800814 <vprintfmt+0x542>
  800811:	83 e8 01             	sub    $0x1,%eax
  800814:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800818:	75 f7                	jne    800811 <vprintfmt+0x53f>
  80081a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80081d:	e9 e2 fe ff ff       	jmp    800704 <vprintfmt+0x432>
}
  800822:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800825:	5b                   	pop    %ebx
  800826:	5e                   	pop    %esi
  800827:	5f                   	pop    %edi
  800828:	5d                   	pop    %ebp
  800829:	c3                   	ret    

0080082a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80082a:	55                   	push   %ebp
  80082b:	89 e5                	mov    %esp,%ebp
  80082d:	83 ec 18             	sub    $0x18,%esp
  800830:	8b 45 08             	mov    0x8(%ebp),%eax
  800833:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800836:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800839:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80083d:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800840:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800847:	85 c0                	test   %eax,%eax
  800849:	74 26                	je     800871 <vsnprintf+0x47>
  80084b:	85 d2                	test   %edx,%edx
  80084d:	7e 22                	jle    800871 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80084f:	ff 75 14             	pushl  0x14(%ebp)
  800852:	ff 75 10             	pushl  0x10(%ebp)
  800855:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800858:	50                   	push   %eax
  800859:	68 98 02 80 00       	push   $0x800298
  80085e:	e8 6f fa ff ff       	call   8002d2 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800863:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800866:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800869:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80086c:	83 c4 10             	add    $0x10,%esp
}
  80086f:	c9                   	leave  
  800870:	c3                   	ret    
		return -E_INVAL;
  800871:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800876:	eb f7                	jmp    80086f <vsnprintf+0x45>

00800878 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800878:	55                   	push   %ebp
  800879:	89 e5                	mov    %esp,%ebp
  80087b:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80087e:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800881:	50                   	push   %eax
  800882:	ff 75 10             	pushl  0x10(%ebp)
  800885:	ff 75 0c             	pushl  0xc(%ebp)
  800888:	ff 75 08             	pushl  0x8(%ebp)
  80088b:	e8 9a ff ff ff       	call   80082a <vsnprintf>
	va_end(ap);

	return rc;
}
  800890:	c9                   	leave  
  800891:	c3                   	ret    

00800892 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800892:	55                   	push   %ebp
  800893:	89 e5                	mov    %esp,%ebp
  800895:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800898:	b8 00 00 00 00       	mov    $0x0,%eax
  80089d:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008a1:	74 05                	je     8008a8 <strlen+0x16>
		n++;
  8008a3:	83 c0 01             	add    $0x1,%eax
  8008a6:	eb f5                	jmp    80089d <strlen+0xb>
	return n;
}
  8008a8:	5d                   	pop    %ebp
  8008a9:	c3                   	ret    

008008aa <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008aa:	55                   	push   %ebp
  8008ab:	89 e5                	mov    %esp,%ebp
  8008ad:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008b0:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8008b8:	39 c2                	cmp    %eax,%edx
  8008ba:	74 0d                	je     8008c9 <strnlen+0x1f>
  8008bc:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8008c0:	74 05                	je     8008c7 <strnlen+0x1d>
		n++;
  8008c2:	83 c2 01             	add    $0x1,%edx
  8008c5:	eb f1                	jmp    8008b8 <strnlen+0xe>
  8008c7:	89 d0                	mov    %edx,%eax
	return n;
}
  8008c9:	5d                   	pop    %ebp
  8008ca:	c3                   	ret    

008008cb <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008cb:	55                   	push   %ebp
  8008cc:	89 e5                	mov    %esp,%ebp
  8008ce:	53                   	push   %ebx
  8008cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8008da:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8008de:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8008e1:	83 c2 01             	add    $0x1,%edx
  8008e4:	84 c9                	test   %cl,%cl
  8008e6:	75 f2                	jne    8008da <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8008e8:	5b                   	pop    %ebx
  8008e9:	5d                   	pop    %ebp
  8008ea:	c3                   	ret    

008008eb <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008eb:	55                   	push   %ebp
  8008ec:	89 e5                	mov    %esp,%ebp
  8008ee:	53                   	push   %ebx
  8008ef:	83 ec 10             	sub    $0x10,%esp
  8008f2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008f5:	53                   	push   %ebx
  8008f6:	e8 97 ff ff ff       	call   800892 <strlen>
  8008fb:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8008fe:	ff 75 0c             	pushl  0xc(%ebp)
  800901:	01 d8                	add    %ebx,%eax
  800903:	50                   	push   %eax
  800904:	e8 c2 ff ff ff       	call   8008cb <strcpy>
	return dst;
}
  800909:	89 d8                	mov    %ebx,%eax
  80090b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80090e:	c9                   	leave  
  80090f:	c3                   	ret    

00800910 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800910:	55                   	push   %ebp
  800911:	89 e5                	mov    %esp,%ebp
  800913:	56                   	push   %esi
  800914:	53                   	push   %ebx
  800915:	8b 45 08             	mov    0x8(%ebp),%eax
  800918:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80091b:	89 c6                	mov    %eax,%esi
  80091d:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800920:	89 c2                	mov    %eax,%edx
  800922:	39 f2                	cmp    %esi,%edx
  800924:	74 11                	je     800937 <strncpy+0x27>
		*dst++ = *src;
  800926:	83 c2 01             	add    $0x1,%edx
  800929:	0f b6 19             	movzbl (%ecx),%ebx
  80092c:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80092f:	80 fb 01             	cmp    $0x1,%bl
  800932:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800935:	eb eb                	jmp    800922 <strncpy+0x12>
	}
	return ret;
}
  800937:	5b                   	pop    %ebx
  800938:	5e                   	pop    %esi
  800939:	5d                   	pop    %ebp
  80093a:	c3                   	ret    

0080093b <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80093b:	55                   	push   %ebp
  80093c:	89 e5                	mov    %esp,%ebp
  80093e:	56                   	push   %esi
  80093f:	53                   	push   %ebx
  800940:	8b 75 08             	mov    0x8(%ebp),%esi
  800943:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800946:	8b 55 10             	mov    0x10(%ebp),%edx
  800949:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80094b:	85 d2                	test   %edx,%edx
  80094d:	74 21                	je     800970 <strlcpy+0x35>
  80094f:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800953:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800955:	39 c2                	cmp    %eax,%edx
  800957:	74 14                	je     80096d <strlcpy+0x32>
  800959:	0f b6 19             	movzbl (%ecx),%ebx
  80095c:	84 db                	test   %bl,%bl
  80095e:	74 0b                	je     80096b <strlcpy+0x30>
			*dst++ = *src++;
  800960:	83 c1 01             	add    $0x1,%ecx
  800963:	83 c2 01             	add    $0x1,%edx
  800966:	88 5a ff             	mov    %bl,-0x1(%edx)
  800969:	eb ea                	jmp    800955 <strlcpy+0x1a>
  80096b:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80096d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800970:	29 f0                	sub    %esi,%eax
}
  800972:	5b                   	pop    %ebx
  800973:	5e                   	pop    %esi
  800974:	5d                   	pop    %ebp
  800975:	c3                   	ret    

00800976 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800976:	55                   	push   %ebp
  800977:	89 e5                	mov    %esp,%ebp
  800979:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80097c:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80097f:	0f b6 01             	movzbl (%ecx),%eax
  800982:	84 c0                	test   %al,%al
  800984:	74 0c                	je     800992 <strcmp+0x1c>
  800986:	3a 02                	cmp    (%edx),%al
  800988:	75 08                	jne    800992 <strcmp+0x1c>
		p++, q++;
  80098a:	83 c1 01             	add    $0x1,%ecx
  80098d:	83 c2 01             	add    $0x1,%edx
  800990:	eb ed                	jmp    80097f <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800992:	0f b6 c0             	movzbl %al,%eax
  800995:	0f b6 12             	movzbl (%edx),%edx
  800998:	29 d0                	sub    %edx,%eax
}
  80099a:	5d                   	pop    %ebp
  80099b:	c3                   	ret    

0080099c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80099c:	55                   	push   %ebp
  80099d:	89 e5                	mov    %esp,%ebp
  80099f:	53                   	push   %ebx
  8009a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009a6:	89 c3                	mov    %eax,%ebx
  8009a8:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009ab:	eb 06                	jmp    8009b3 <strncmp+0x17>
		n--, p++, q++;
  8009ad:	83 c0 01             	add    $0x1,%eax
  8009b0:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009b3:	39 d8                	cmp    %ebx,%eax
  8009b5:	74 16                	je     8009cd <strncmp+0x31>
  8009b7:	0f b6 08             	movzbl (%eax),%ecx
  8009ba:	84 c9                	test   %cl,%cl
  8009bc:	74 04                	je     8009c2 <strncmp+0x26>
  8009be:	3a 0a                	cmp    (%edx),%cl
  8009c0:	74 eb                	je     8009ad <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009c2:	0f b6 00             	movzbl (%eax),%eax
  8009c5:	0f b6 12             	movzbl (%edx),%edx
  8009c8:	29 d0                	sub    %edx,%eax
}
  8009ca:	5b                   	pop    %ebx
  8009cb:	5d                   	pop    %ebp
  8009cc:	c3                   	ret    
		return 0;
  8009cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8009d2:	eb f6                	jmp    8009ca <strncmp+0x2e>

008009d4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009d4:	55                   	push   %ebp
  8009d5:	89 e5                	mov    %esp,%ebp
  8009d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009da:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009de:	0f b6 10             	movzbl (%eax),%edx
  8009e1:	84 d2                	test   %dl,%dl
  8009e3:	74 09                	je     8009ee <strchr+0x1a>
		if (*s == c)
  8009e5:	38 ca                	cmp    %cl,%dl
  8009e7:	74 0a                	je     8009f3 <strchr+0x1f>
	for (; *s; s++)
  8009e9:	83 c0 01             	add    $0x1,%eax
  8009ec:	eb f0                	jmp    8009de <strchr+0xa>
			return (char *) s;
	return 0;
  8009ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009f3:	5d                   	pop    %ebp
  8009f4:	c3                   	ret    

008009f5 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009f5:	55                   	push   %ebp
  8009f6:	89 e5                	mov    %esp,%ebp
  8009f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fb:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009ff:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a02:	38 ca                	cmp    %cl,%dl
  800a04:	74 09                	je     800a0f <strfind+0x1a>
  800a06:	84 d2                	test   %dl,%dl
  800a08:	74 05                	je     800a0f <strfind+0x1a>
	for (; *s; s++)
  800a0a:	83 c0 01             	add    $0x1,%eax
  800a0d:	eb f0                	jmp    8009ff <strfind+0xa>
			break;
	return (char *) s;
}
  800a0f:	5d                   	pop    %ebp
  800a10:	c3                   	ret    

00800a11 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a11:	55                   	push   %ebp
  800a12:	89 e5                	mov    %esp,%ebp
  800a14:	57                   	push   %edi
  800a15:	56                   	push   %esi
  800a16:	53                   	push   %ebx
  800a17:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a1a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a1d:	85 c9                	test   %ecx,%ecx
  800a1f:	74 31                	je     800a52 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a21:	89 f8                	mov    %edi,%eax
  800a23:	09 c8                	or     %ecx,%eax
  800a25:	a8 03                	test   $0x3,%al
  800a27:	75 23                	jne    800a4c <memset+0x3b>
		c &= 0xFF;
  800a29:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a2d:	89 d3                	mov    %edx,%ebx
  800a2f:	c1 e3 08             	shl    $0x8,%ebx
  800a32:	89 d0                	mov    %edx,%eax
  800a34:	c1 e0 18             	shl    $0x18,%eax
  800a37:	89 d6                	mov    %edx,%esi
  800a39:	c1 e6 10             	shl    $0x10,%esi
  800a3c:	09 f0                	or     %esi,%eax
  800a3e:	09 c2                	or     %eax,%edx
  800a40:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a42:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a45:	89 d0                	mov    %edx,%eax
  800a47:	fc                   	cld    
  800a48:	f3 ab                	rep stos %eax,%es:(%edi)
  800a4a:	eb 06                	jmp    800a52 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a4f:	fc                   	cld    
  800a50:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a52:	89 f8                	mov    %edi,%eax
  800a54:	5b                   	pop    %ebx
  800a55:	5e                   	pop    %esi
  800a56:	5f                   	pop    %edi
  800a57:	5d                   	pop    %ebp
  800a58:	c3                   	ret    

00800a59 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a59:	55                   	push   %ebp
  800a5a:	89 e5                	mov    %esp,%ebp
  800a5c:	57                   	push   %edi
  800a5d:	56                   	push   %esi
  800a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a61:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a64:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a67:	39 c6                	cmp    %eax,%esi
  800a69:	73 32                	jae    800a9d <memmove+0x44>
  800a6b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a6e:	39 c2                	cmp    %eax,%edx
  800a70:	76 2b                	jbe    800a9d <memmove+0x44>
		s += n;
		d += n;
  800a72:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a75:	89 fe                	mov    %edi,%esi
  800a77:	09 ce                	or     %ecx,%esi
  800a79:	09 d6                	or     %edx,%esi
  800a7b:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a81:	75 0e                	jne    800a91 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a83:	83 ef 04             	sub    $0x4,%edi
  800a86:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a89:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a8c:	fd                   	std    
  800a8d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a8f:	eb 09                	jmp    800a9a <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a91:	83 ef 01             	sub    $0x1,%edi
  800a94:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a97:	fd                   	std    
  800a98:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a9a:	fc                   	cld    
  800a9b:	eb 1a                	jmp    800ab7 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a9d:	89 c2                	mov    %eax,%edx
  800a9f:	09 ca                	or     %ecx,%edx
  800aa1:	09 f2                	or     %esi,%edx
  800aa3:	f6 c2 03             	test   $0x3,%dl
  800aa6:	75 0a                	jne    800ab2 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800aa8:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800aab:	89 c7                	mov    %eax,%edi
  800aad:	fc                   	cld    
  800aae:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ab0:	eb 05                	jmp    800ab7 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800ab2:	89 c7                	mov    %eax,%edi
  800ab4:	fc                   	cld    
  800ab5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ab7:	5e                   	pop    %esi
  800ab8:	5f                   	pop    %edi
  800ab9:	5d                   	pop    %ebp
  800aba:	c3                   	ret    

00800abb <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800abb:	55                   	push   %ebp
  800abc:	89 e5                	mov    %esp,%ebp
  800abe:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ac1:	ff 75 10             	pushl  0x10(%ebp)
  800ac4:	ff 75 0c             	pushl  0xc(%ebp)
  800ac7:	ff 75 08             	pushl  0x8(%ebp)
  800aca:	e8 8a ff ff ff       	call   800a59 <memmove>
}
  800acf:	c9                   	leave  
  800ad0:	c3                   	ret    

00800ad1 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ad1:	55                   	push   %ebp
  800ad2:	89 e5                	mov    %esp,%ebp
  800ad4:	56                   	push   %esi
  800ad5:	53                   	push   %ebx
  800ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800adc:	89 c6                	mov    %eax,%esi
  800ade:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ae1:	39 f0                	cmp    %esi,%eax
  800ae3:	74 1c                	je     800b01 <memcmp+0x30>
		if (*s1 != *s2)
  800ae5:	0f b6 08             	movzbl (%eax),%ecx
  800ae8:	0f b6 1a             	movzbl (%edx),%ebx
  800aeb:	38 d9                	cmp    %bl,%cl
  800aed:	75 08                	jne    800af7 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800aef:	83 c0 01             	add    $0x1,%eax
  800af2:	83 c2 01             	add    $0x1,%edx
  800af5:	eb ea                	jmp    800ae1 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800af7:	0f b6 c1             	movzbl %cl,%eax
  800afa:	0f b6 db             	movzbl %bl,%ebx
  800afd:	29 d8                	sub    %ebx,%eax
  800aff:	eb 05                	jmp    800b06 <memcmp+0x35>
	}

	return 0;
  800b01:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b06:	5b                   	pop    %ebx
  800b07:	5e                   	pop    %esi
  800b08:	5d                   	pop    %ebp
  800b09:	c3                   	ret    

00800b0a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b0a:	55                   	push   %ebp
  800b0b:	89 e5                	mov    %esp,%ebp
  800b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b10:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b13:	89 c2                	mov    %eax,%edx
  800b15:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b18:	39 d0                	cmp    %edx,%eax
  800b1a:	73 09                	jae    800b25 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b1c:	38 08                	cmp    %cl,(%eax)
  800b1e:	74 05                	je     800b25 <memfind+0x1b>
	for (; s < ends; s++)
  800b20:	83 c0 01             	add    $0x1,%eax
  800b23:	eb f3                	jmp    800b18 <memfind+0xe>
			break;
	return (void *) s;
}
  800b25:	5d                   	pop    %ebp
  800b26:	c3                   	ret    

00800b27 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b27:	55                   	push   %ebp
  800b28:	89 e5                	mov    %esp,%ebp
  800b2a:	57                   	push   %edi
  800b2b:	56                   	push   %esi
  800b2c:	53                   	push   %ebx
  800b2d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b30:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b33:	eb 03                	jmp    800b38 <strtol+0x11>
		s++;
  800b35:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b38:	0f b6 01             	movzbl (%ecx),%eax
  800b3b:	3c 20                	cmp    $0x20,%al
  800b3d:	74 f6                	je     800b35 <strtol+0xe>
  800b3f:	3c 09                	cmp    $0x9,%al
  800b41:	74 f2                	je     800b35 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b43:	3c 2b                	cmp    $0x2b,%al
  800b45:	74 2a                	je     800b71 <strtol+0x4a>
	int neg = 0;
  800b47:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b4c:	3c 2d                	cmp    $0x2d,%al
  800b4e:	74 2b                	je     800b7b <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b50:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b56:	75 0f                	jne    800b67 <strtol+0x40>
  800b58:	80 39 30             	cmpb   $0x30,(%ecx)
  800b5b:	74 28                	je     800b85 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b5d:	85 db                	test   %ebx,%ebx
  800b5f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b64:	0f 44 d8             	cmove  %eax,%ebx
  800b67:	b8 00 00 00 00       	mov    $0x0,%eax
  800b6c:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b6f:	eb 50                	jmp    800bc1 <strtol+0x9a>
		s++;
  800b71:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b74:	bf 00 00 00 00       	mov    $0x0,%edi
  800b79:	eb d5                	jmp    800b50 <strtol+0x29>
		s++, neg = 1;
  800b7b:	83 c1 01             	add    $0x1,%ecx
  800b7e:	bf 01 00 00 00       	mov    $0x1,%edi
  800b83:	eb cb                	jmp    800b50 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b85:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b89:	74 0e                	je     800b99 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800b8b:	85 db                	test   %ebx,%ebx
  800b8d:	75 d8                	jne    800b67 <strtol+0x40>
		s++, base = 8;
  800b8f:	83 c1 01             	add    $0x1,%ecx
  800b92:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b97:	eb ce                	jmp    800b67 <strtol+0x40>
		s += 2, base = 16;
  800b99:	83 c1 02             	add    $0x2,%ecx
  800b9c:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ba1:	eb c4                	jmp    800b67 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800ba3:	8d 72 9f             	lea    -0x61(%edx),%esi
  800ba6:	89 f3                	mov    %esi,%ebx
  800ba8:	80 fb 19             	cmp    $0x19,%bl
  800bab:	77 29                	ja     800bd6 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800bad:	0f be d2             	movsbl %dl,%edx
  800bb0:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800bb3:	3b 55 10             	cmp    0x10(%ebp),%edx
  800bb6:	7d 30                	jge    800be8 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800bb8:	83 c1 01             	add    $0x1,%ecx
  800bbb:	0f af 45 10          	imul   0x10(%ebp),%eax
  800bbf:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800bc1:	0f b6 11             	movzbl (%ecx),%edx
  800bc4:	8d 72 d0             	lea    -0x30(%edx),%esi
  800bc7:	89 f3                	mov    %esi,%ebx
  800bc9:	80 fb 09             	cmp    $0x9,%bl
  800bcc:	77 d5                	ja     800ba3 <strtol+0x7c>
			dig = *s - '0';
  800bce:	0f be d2             	movsbl %dl,%edx
  800bd1:	83 ea 30             	sub    $0x30,%edx
  800bd4:	eb dd                	jmp    800bb3 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800bd6:	8d 72 bf             	lea    -0x41(%edx),%esi
  800bd9:	89 f3                	mov    %esi,%ebx
  800bdb:	80 fb 19             	cmp    $0x19,%bl
  800bde:	77 08                	ja     800be8 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800be0:	0f be d2             	movsbl %dl,%edx
  800be3:	83 ea 37             	sub    $0x37,%edx
  800be6:	eb cb                	jmp    800bb3 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800be8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bec:	74 05                	je     800bf3 <strtol+0xcc>
		*endptr = (char *) s;
  800bee:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bf1:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800bf3:	89 c2                	mov    %eax,%edx
  800bf5:	f7 da                	neg    %edx
  800bf7:	85 ff                	test   %edi,%edi
  800bf9:	0f 45 c2             	cmovne %edx,%eax
}
  800bfc:	5b                   	pop    %ebx
  800bfd:	5e                   	pop    %esi
  800bfe:	5f                   	pop    %edi
  800bff:	5d                   	pop    %ebp
  800c00:	c3                   	ret    

00800c01 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c01:	55                   	push   %ebp
  800c02:	89 e5                	mov    %esp,%ebp
  800c04:	57                   	push   %edi
  800c05:	56                   	push   %esi
  800c06:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c07:	b8 00 00 00 00       	mov    $0x0,%eax
  800c0c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c0f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c12:	89 c3                	mov    %eax,%ebx
  800c14:	89 c7                	mov    %eax,%edi
  800c16:	89 c6                	mov    %eax,%esi
  800c18:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c1a:	5b                   	pop    %ebx
  800c1b:	5e                   	pop    %esi
  800c1c:	5f                   	pop    %edi
  800c1d:	5d                   	pop    %ebp
  800c1e:	c3                   	ret    

00800c1f <sys_cgetc>:

int
sys_cgetc(void)
{
  800c1f:	55                   	push   %ebp
  800c20:	89 e5                	mov    %esp,%ebp
  800c22:	57                   	push   %edi
  800c23:	56                   	push   %esi
  800c24:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c25:	ba 00 00 00 00       	mov    $0x0,%edx
  800c2a:	b8 01 00 00 00       	mov    $0x1,%eax
  800c2f:	89 d1                	mov    %edx,%ecx
  800c31:	89 d3                	mov    %edx,%ebx
  800c33:	89 d7                	mov    %edx,%edi
  800c35:	89 d6                	mov    %edx,%esi
  800c37:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c39:	5b                   	pop    %ebx
  800c3a:	5e                   	pop    %esi
  800c3b:	5f                   	pop    %edi
  800c3c:	5d                   	pop    %ebp
  800c3d:	c3                   	ret    

00800c3e <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c3e:	55                   	push   %ebp
  800c3f:	89 e5                	mov    %esp,%ebp
  800c41:	57                   	push   %edi
  800c42:	56                   	push   %esi
  800c43:	53                   	push   %ebx
  800c44:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c47:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c4c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c4f:	b8 03 00 00 00       	mov    $0x3,%eax
  800c54:	89 cb                	mov    %ecx,%ebx
  800c56:	89 cf                	mov    %ecx,%edi
  800c58:	89 ce                	mov    %ecx,%esi
  800c5a:	cd 30                	int    $0x30
	if (check && ret > 0)
  800c5c:	85 c0                	test   %eax,%eax
  800c5e:	7f 08                	jg     800c68 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c60:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c63:	5b                   	pop    %ebx
  800c64:	5e                   	pop    %esi
  800c65:	5f                   	pop    %edi
  800c66:	5d                   	pop    %ebp
  800c67:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c68:	83 ec 0c             	sub    $0xc,%esp
  800c6b:	50                   	push   %eax
  800c6c:	6a 03                	push   $0x3
  800c6e:	68 60 1a 80 00       	push   $0x801a60
  800c73:	6a 4c                	push   $0x4c
  800c75:	68 7d 1a 80 00       	push   $0x801a7d
  800c7a:	e8 8c 06 00 00       	call   80130b <_panic>

00800c7f <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c7f:	55                   	push   %ebp
  800c80:	89 e5                	mov    %esp,%ebp
  800c82:	57                   	push   %edi
  800c83:	56                   	push   %esi
  800c84:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c85:	ba 00 00 00 00       	mov    $0x0,%edx
  800c8a:	b8 02 00 00 00       	mov    $0x2,%eax
  800c8f:	89 d1                	mov    %edx,%ecx
  800c91:	89 d3                	mov    %edx,%ebx
  800c93:	89 d7                	mov    %edx,%edi
  800c95:	89 d6                	mov    %edx,%esi
  800c97:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c99:	5b                   	pop    %ebx
  800c9a:	5e                   	pop    %esi
  800c9b:	5f                   	pop    %edi
  800c9c:	5d                   	pop    %ebp
  800c9d:	c3                   	ret    

00800c9e <sys_yield>:

void
sys_yield(void)
{
  800c9e:	55                   	push   %ebp
  800c9f:	89 e5                	mov    %esp,%ebp
  800ca1:	57                   	push   %edi
  800ca2:	56                   	push   %esi
  800ca3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ca4:	ba 00 00 00 00       	mov    $0x0,%edx
  800ca9:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cae:	89 d1                	mov    %edx,%ecx
  800cb0:	89 d3                	mov    %edx,%ebx
  800cb2:	89 d7                	mov    %edx,%edi
  800cb4:	89 d6                	mov    %edx,%esi
  800cb6:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cb8:	5b                   	pop    %ebx
  800cb9:	5e                   	pop    %esi
  800cba:	5f                   	pop    %edi
  800cbb:	5d                   	pop    %ebp
  800cbc:	c3                   	ret    

00800cbd <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cbd:	55                   	push   %ebp
  800cbe:	89 e5                	mov    %esp,%ebp
  800cc0:	57                   	push   %edi
  800cc1:	56                   	push   %esi
  800cc2:	53                   	push   %ebx
  800cc3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cc6:	be 00 00 00 00       	mov    $0x0,%esi
  800ccb:	8b 55 08             	mov    0x8(%ebp),%edx
  800cce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd1:	b8 04 00 00 00       	mov    $0x4,%eax
  800cd6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cd9:	89 f7                	mov    %esi,%edi
  800cdb:	cd 30                	int    $0x30
	if (check && ret > 0)
  800cdd:	85 c0                	test   %eax,%eax
  800cdf:	7f 08                	jg     800ce9 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800ce1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ce4:	5b                   	pop    %ebx
  800ce5:	5e                   	pop    %esi
  800ce6:	5f                   	pop    %edi
  800ce7:	5d                   	pop    %ebp
  800ce8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ce9:	83 ec 0c             	sub    $0xc,%esp
  800cec:	50                   	push   %eax
  800ced:	6a 04                	push   $0x4
  800cef:	68 60 1a 80 00       	push   $0x801a60
  800cf4:	6a 4c                	push   $0x4c
  800cf6:	68 7d 1a 80 00       	push   $0x801a7d
  800cfb:	e8 0b 06 00 00       	call   80130b <_panic>

00800d00 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d00:	55                   	push   %ebp
  800d01:	89 e5                	mov    %esp,%ebp
  800d03:	57                   	push   %edi
  800d04:	56                   	push   %esi
  800d05:	53                   	push   %ebx
  800d06:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d09:	8b 55 08             	mov    0x8(%ebp),%edx
  800d0c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d0f:	b8 05 00 00 00       	mov    $0x5,%eax
  800d14:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d17:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d1a:	8b 75 18             	mov    0x18(%ebp),%esi
  800d1d:	cd 30                	int    $0x30
	if (check && ret > 0)
  800d1f:	85 c0                	test   %eax,%eax
  800d21:	7f 08                	jg     800d2b <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d23:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d26:	5b                   	pop    %ebx
  800d27:	5e                   	pop    %esi
  800d28:	5f                   	pop    %edi
  800d29:	5d                   	pop    %ebp
  800d2a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d2b:	83 ec 0c             	sub    $0xc,%esp
  800d2e:	50                   	push   %eax
  800d2f:	6a 05                	push   $0x5
  800d31:	68 60 1a 80 00       	push   $0x801a60
  800d36:	6a 4c                	push   $0x4c
  800d38:	68 7d 1a 80 00       	push   $0x801a7d
  800d3d:	e8 c9 05 00 00       	call   80130b <_panic>

00800d42 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d42:	55                   	push   %ebp
  800d43:	89 e5                	mov    %esp,%ebp
  800d45:	57                   	push   %edi
  800d46:	56                   	push   %esi
  800d47:	53                   	push   %ebx
  800d48:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d4b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d50:	8b 55 08             	mov    0x8(%ebp),%edx
  800d53:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d56:	b8 06 00 00 00       	mov    $0x6,%eax
  800d5b:	89 df                	mov    %ebx,%edi
  800d5d:	89 de                	mov    %ebx,%esi
  800d5f:	cd 30                	int    $0x30
	if (check && ret > 0)
  800d61:	85 c0                	test   %eax,%eax
  800d63:	7f 08                	jg     800d6d <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d65:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d68:	5b                   	pop    %ebx
  800d69:	5e                   	pop    %esi
  800d6a:	5f                   	pop    %edi
  800d6b:	5d                   	pop    %ebp
  800d6c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d6d:	83 ec 0c             	sub    $0xc,%esp
  800d70:	50                   	push   %eax
  800d71:	6a 06                	push   $0x6
  800d73:	68 60 1a 80 00       	push   $0x801a60
  800d78:	6a 4c                	push   $0x4c
  800d7a:	68 7d 1a 80 00       	push   $0x801a7d
  800d7f:	e8 87 05 00 00       	call   80130b <_panic>

00800d84 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d84:	55                   	push   %ebp
  800d85:	89 e5                	mov    %esp,%ebp
  800d87:	57                   	push   %edi
  800d88:	56                   	push   %esi
  800d89:	53                   	push   %ebx
  800d8a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d8d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d92:	8b 55 08             	mov    0x8(%ebp),%edx
  800d95:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d98:	b8 08 00 00 00       	mov    $0x8,%eax
  800d9d:	89 df                	mov    %ebx,%edi
  800d9f:	89 de                	mov    %ebx,%esi
  800da1:	cd 30                	int    $0x30
	if (check && ret > 0)
  800da3:	85 c0                	test   %eax,%eax
  800da5:	7f 08                	jg     800daf <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800da7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800daa:	5b                   	pop    %ebx
  800dab:	5e                   	pop    %esi
  800dac:	5f                   	pop    %edi
  800dad:	5d                   	pop    %ebp
  800dae:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800daf:	83 ec 0c             	sub    $0xc,%esp
  800db2:	50                   	push   %eax
  800db3:	6a 08                	push   $0x8
  800db5:	68 60 1a 80 00       	push   $0x801a60
  800dba:	6a 4c                	push   $0x4c
  800dbc:	68 7d 1a 80 00       	push   $0x801a7d
  800dc1:	e8 45 05 00 00       	call   80130b <_panic>

00800dc6 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800dc6:	55                   	push   %ebp
  800dc7:	89 e5                	mov    %esp,%ebp
  800dc9:	57                   	push   %edi
  800dca:	56                   	push   %esi
  800dcb:	53                   	push   %ebx
  800dcc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dcf:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dd4:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dda:	b8 09 00 00 00       	mov    $0x9,%eax
  800ddf:	89 df                	mov    %ebx,%edi
  800de1:	89 de                	mov    %ebx,%esi
  800de3:	cd 30                	int    $0x30
	if (check && ret > 0)
  800de5:	85 c0                	test   %eax,%eax
  800de7:	7f 08                	jg     800df1 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800de9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dec:	5b                   	pop    %ebx
  800ded:	5e                   	pop    %esi
  800dee:	5f                   	pop    %edi
  800def:	5d                   	pop    %ebp
  800df0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800df1:	83 ec 0c             	sub    $0xc,%esp
  800df4:	50                   	push   %eax
  800df5:	6a 09                	push   $0x9
  800df7:	68 60 1a 80 00       	push   $0x801a60
  800dfc:	6a 4c                	push   $0x4c
  800dfe:	68 7d 1a 80 00       	push   $0x801a7d
  800e03:	e8 03 05 00 00       	call   80130b <_panic>

00800e08 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e08:	55                   	push   %ebp
  800e09:	89 e5                	mov    %esp,%ebp
  800e0b:	57                   	push   %edi
  800e0c:	56                   	push   %esi
  800e0d:	53                   	push   %ebx
  800e0e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e11:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e16:	8b 55 08             	mov    0x8(%ebp),%edx
  800e19:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e1c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e21:	89 df                	mov    %ebx,%edi
  800e23:	89 de                	mov    %ebx,%esi
  800e25:	cd 30                	int    $0x30
	if (check && ret > 0)
  800e27:	85 c0                	test   %eax,%eax
  800e29:	7f 08                	jg     800e33 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e2b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e2e:	5b                   	pop    %ebx
  800e2f:	5e                   	pop    %esi
  800e30:	5f                   	pop    %edi
  800e31:	5d                   	pop    %ebp
  800e32:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e33:	83 ec 0c             	sub    $0xc,%esp
  800e36:	50                   	push   %eax
  800e37:	6a 0a                	push   $0xa
  800e39:	68 60 1a 80 00       	push   $0x801a60
  800e3e:	6a 4c                	push   $0x4c
  800e40:	68 7d 1a 80 00       	push   $0x801a7d
  800e45:	e8 c1 04 00 00       	call   80130b <_panic>

00800e4a <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e4a:	55                   	push   %ebp
  800e4b:	89 e5                	mov    %esp,%ebp
  800e4d:	57                   	push   %edi
  800e4e:	56                   	push   %esi
  800e4f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e50:	8b 55 08             	mov    0x8(%ebp),%edx
  800e53:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e56:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e5b:	be 00 00 00 00       	mov    $0x0,%esi
  800e60:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e63:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e66:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e68:	5b                   	pop    %ebx
  800e69:	5e                   	pop    %esi
  800e6a:	5f                   	pop    %edi
  800e6b:	5d                   	pop    %ebp
  800e6c:	c3                   	ret    

00800e6d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e6d:	55                   	push   %ebp
  800e6e:	89 e5                	mov    %esp,%ebp
  800e70:	57                   	push   %edi
  800e71:	56                   	push   %esi
  800e72:	53                   	push   %ebx
  800e73:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e76:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e7b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e7e:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e83:	89 cb                	mov    %ecx,%ebx
  800e85:	89 cf                	mov    %ecx,%edi
  800e87:	89 ce                	mov    %ecx,%esi
  800e89:	cd 30                	int    $0x30
	if (check && ret > 0)
  800e8b:	85 c0                	test   %eax,%eax
  800e8d:	7f 08                	jg     800e97 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e8f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e92:	5b                   	pop    %ebx
  800e93:	5e                   	pop    %esi
  800e94:	5f                   	pop    %edi
  800e95:	5d                   	pop    %ebp
  800e96:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e97:	83 ec 0c             	sub    $0xc,%esp
  800e9a:	50                   	push   %eax
  800e9b:	6a 0d                	push   $0xd
  800e9d:	68 60 1a 80 00       	push   $0x801a60
  800ea2:	6a 4c                	push   $0x4c
  800ea4:	68 7d 1a 80 00       	push   $0x801a7d
  800ea9:	e8 5d 04 00 00       	call   80130b <_panic>

00800eae <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800eae:	55                   	push   %ebp
  800eaf:	89 e5                	mov    %esp,%ebp
  800eb1:	57                   	push   %edi
  800eb2:	56                   	push   %esi
  800eb3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800eb4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eb9:	8b 55 08             	mov    0x8(%ebp),%edx
  800ebc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ebf:	b8 0e 00 00 00       	mov    $0xe,%eax
  800ec4:	89 df                	mov    %ebx,%edi
  800ec6:	89 de                	mov    %ebx,%esi
  800ec8:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800eca:	5b                   	pop    %ebx
  800ecb:	5e                   	pop    %esi
  800ecc:	5f                   	pop    %edi
  800ecd:	5d                   	pop    %ebp
  800ece:	c3                   	ret    

00800ecf <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800ecf:	55                   	push   %ebp
  800ed0:	89 e5                	mov    %esp,%ebp
  800ed2:	57                   	push   %edi
  800ed3:	56                   	push   %esi
  800ed4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ed5:	b9 00 00 00 00       	mov    $0x0,%ecx
  800eda:	8b 55 08             	mov    0x8(%ebp),%edx
  800edd:	b8 0f 00 00 00       	mov    $0xf,%eax
  800ee2:	89 cb                	mov    %ecx,%ebx
  800ee4:	89 cf                	mov    %ecx,%edi
  800ee6:	89 ce                	mov    %ecx,%esi
  800ee8:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800eea:	5b                   	pop    %ebx
  800eeb:	5e                   	pop    %esi
  800eec:	5f                   	pop    %edi
  800eed:	5d                   	pop    %ebp
  800eee:	c3                   	ret    

00800eef <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800eef:	55                   	push   %ebp
  800ef0:	89 e5                	mov    %esp,%ebp
  800ef2:	53                   	push   %ebx
  800ef3:	83 ec 04             	sub    $0x4,%esp
  800ef6:	8b 55 08             	mov    0x8(%ebp),%edx
	// cprintf("pgfault()\n");
	void *addr = (void *) utf->utf_fault_va;
  800ef9:	8b 02                	mov    (%edx),%eax
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(!(err & FEC_WR) || !(uvpd[PDX(addr)] & PTE_P) || !(uvpt[PGNUM(addr)] & PTE_P) || !(uvpt[PGNUM(addr)] & PTE_COW))
  800efb:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  800eff:	0f 84 9c 00 00 00    	je     800fa1 <pgfault+0xb2>
  800f05:	89 c2                	mov    %eax,%edx
  800f07:	c1 ea 16             	shr    $0x16,%edx
  800f0a:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f11:	f6 c2 01             	test   $0x1,%dl
  800f14:	0f 84 87 00 00 00    	je     800fa1 <pgfault+0xb2>
  800f1a:	89 c2                	mov    %eax,%edx
  800f1c:	c1 ea 0c             	shr    $0xc,%edx
  800f1f:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  800f26:	f6 c1 01             	test   $0x1,%cl
  800f29:	74 76                	je     800fa1 <pgfault+0xb2>
  800f2b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f32:	f6 c6 08             	test   $0x8,%dh
  800f35:	74 6a                	je     800fa1 <pgfault+0xb2>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  800f37:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f3c:	89 c3                	mov    %eax,%ebx

	r = sys_page_alloc(0, PFTEMP, PTE_P|PTE_U|PTE_W);
  800f3e:	83 ec 04             	sub    $0x4,%esp
  800f41:	6a 07                	push   $0x7
  800f43:	68 00 f0 7f 00       	push   $0x7ff000
  800f48:	6a 00                	push   $0x0
  800f4a:	e8 6e fd ff ff       	call   800cbd <sys_page_alloc>
	if(r < 0){
  800f4f:	83 c4 10             	add    $0x10,%esp
  800f52:	85 c0                	test   %eax,%eax
  800f54:	78 5f                	js     800fb5 <pgfault+0xc6>
		panic("pgfault: sys_page_alloc fail, r: %d", r);
	}

	memmove(PFTEMP, addr, PGSIZE);
  800f56:	83 ec 04             	sub    $0x4,%esp
  800f59:	68 00 10 00 00       	push   $0x1000
  800f5e:	53                   	push   %ebx
  800f5f:	68 00 f0 7f 00       	push   $0x7ff000
  800f64:	e8 f0 fa ff ff       	call   800a59 <memmove>

	r = sys_page_map(0, PFTEMP, 0, addr, PTE_P|PTE_U|PTE_W);
  800f69:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800f70:	53                   	push   %ebx
  800f71:	6a 00                	push   $0x0
  800f73:	68 00 f0 7f 00       	push   $0x7ff000
  800f78:	6a 00                	push   $0x0
  800f7a:	e8 81 fd ff ff       	call   800d00 <sys_page_map>
	if(r < 0){
  800f7f:	83 c4 20             	add    $0x20,%esp
  800f82:	85 c0                	test   %eax,%eax
  800f84:	78 41                	js     800fc7 <pgfault+0xd8>
		panic("pgfault: sys_page_map fail, r: %d", r);
	}

	r = sys_page_unmap(0, PFTEMP);
  800f86:	83 ec 08             	sub    $0x8,%esp
  800f89:	68 00 f0 7f 00       	push   $0x7ff000
  800f8e:	6a 00                	push   $0x0
  800f90:	e8 ad fd ff ff       	call   800d42 <sys_page_unmap>
	if(r < 0){
  800f95:	83 c4 10             	add    $0x10,%esp
  800f98:	85 c0                	test   %eax,%eax
  800f9a:	78 3d                	js     800fd9 <pgfault+0xea>
		panic("sys_page_unmap: %e", r);
	}
}
  800f9c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f9f:	c9                   	leave  
  800fa0:	c3                   	ret    
		panic("pgfault: 1\n");
  800fa1:	83 ec 04             	sub    $0x4,%esp
  800fa4:	68 8b 1a 80 00       	push   $0x801a8b
  800fa9:	6a 20                	push   $0x20
  800fab:	68 97 1a 80 00       	push   $0x801a97
  800fb0:	e8 56 03 00 00       	call   80130b <_panic>
		panic("pgfault: sys_page_alloc fail, r: %d", r);
  800fb5:	50                   	push   %eax
  800fb6:	68 ec 1a 80 00       	push   $0x801aec
  800fbb:	6a 2e                	push   $0x2e
  800fbd:	68 97 1a 80 00       	push   $0x801a97
  800fc2:	e8 44 03 00 00       	call   80130b <_panic>
		panic("pgfault: sys_page_map fail, r: %d", r);
  800fc7:	50                   	push   %eax
  800fc8:	68 10 1b 80 00       	push   $0x801b10
  800fcd:	6a 35                	push   $0x35
  800fcf:	68 97 1a 80 00       	push   $0x801a97
  800fd4:	e8 32 03 00 00       	call   80130b <_panic>
		panic("sys_page_unmap: %e", r);
  800fd9:	50                   	push   %eax
  800fda:	68 a2 1a 80 00       	push   $0x801aa2
  800fdf:	6a 3a                	push   $0x3a
  800fe1:	68 97 1a 80 00       	push   $0x801a97
  800fe6:	e8 20 03 00 00       	call   80130b <_panic>

00800feb <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800feb:	55                   	push   %ebp
  800fec:	89 e5                	mov    %esp,%ebp
  800fee:	57                   	push   %edi
  800fef:	56                   	push   %esi
  800ff0:	53                   	push   %ebx
  800ff1:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	// panic("fork not implemented");
	int r;
	set_pgfault_handler(pgfault);
  800ff4:	68 ef 0e 80 00       	push   $0x800eef
  800ff9:	e8 53 03 00 00       	call   801351 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800ffe:	b8 07 00 00 00       	mov    $0x7,%eax
  801003:	cd 30                	int    $0x30
  801005:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int i;
	uintptr_t va;
	envid_t childid = sys_exofork();
	if (childid < 0){
  801008:	83 c4 10             	add    $0x10,%esp
  80100b:	85 c0                	test   %eax,%eax
  80100d:	78 2c                	js     80103b <fork+0x50>
  80100f:	89 c7                	mov    %eax,%edi
	}

	extern volatile pde_t uvpd[];
	extern volatile pte_t uvpt[];

	for (va = UTEXT; va < USTACKTOP; va += PGSIZE){
  801011:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if (childid == 0) {
  801016:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80101a:	75 72                	jne    80108e <fork+0xa3>
		thisenv = &envs[ENVX(sys_getenvid())];
  80101c:	e8 5e fc ff ff       	call   800c7f <sys_getenvid>
  801021:	25 ff 03 00 00       	and    $0x3ff,%eax
  801026:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80102c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801031:	a3 04 20 80 00       	mov    %eax,0x802004
		return 0;
  801036:	e9 36 01 00 00       	jmp    801171 <fork+0x186>
		panic("fork: child id < 0: %d", childid);
  80103b:	50                   	push   %eax
  80103c:	68 b5 1a 80 00       	push   $0x801ab5
  801041:	68 83 00 00 00       	push   $0x83
  801046:	68 97 1a 80 00       	push   $0x801a97
  80104b:	e8 bb 02 00 00       	call   80130b <_panic>
			panic("sys_page_map: sys_page_map fail, r:%d\n", r);
  801050:	50                   	push   %eax
  801051:	68 34 1b 80 00       	push   $0x801b34
  801056:	6a 56                	push   $0x56
  801058:	68 97 1a 80 00       	push   $0x801a97
  80105d:	e8 a9 02 00 00       	call   80130b <_panic>
		r = sys_page_map((envid_t)0, va, envid, va, PTE_U | PTE_P);
  801062:	83 ec 0c             	sub    $0xc,%esp
  801065:	6a 05                	push   $0x5
  801067:	56                   	push   %esi
  801068:	57                   	push   %edi
  801069:	56                   	push   %esi
  80106a:	6a 00                	push   $0x0
  80106c:	e8 8f fc ff ff       	call   800d00 <sys_page_map>
		if(r < 0){
  801071:	83 c4 20             	add    $0x20,%esp
  801074:	85 c0                	test   %eax,%eax
  801076:	0f 88 9f 00 00 00    	js     80111b <fork+0x130>
	for (va = UTEXT; va < USTACKTOP; va += PGSIZE){
  80107c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801082:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801088:	0f 84 9f 00 00 00    	je     80112d <fork+0x142>
		if ((uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_U)){
  80108e:	89 d8                	mov    %ebx,%eax
  801090:	c1 e8 16             	shr    $0x16,%eax
  801093:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80109a:	a8 01                	test   $0x1,%al
  80109c:	74 de                	je     80107c <fork+0x91>
  80109e:	89 d8                	mov    %ebx,%eax
  8010a0:	c1 e8 0c             	shr    $0xc,%eax
  8010a3:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8010aa:	f6 c2 01             	test   $0x1,%dl
  8010ad:	74 cd                	je     80107c <fork+0x91>
  8010af:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8010b6:	f6 c2 04             	test   $0x4,%dl
  8010b9:	74 c1                	je     80107c <fork+0x91>
	void * va = (void *)(pn * PGSIZE);
  8010bb:	89 c6                	mov    %eax,%esi
  8010bd:	c1 e6 0c             	shl    $0xc,%esi
	int perm = (uvpt[pn]);
  8010c0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (perm & (PTE_W | PTE_COW)) {
  8010c7:	a9 02 08 00 00       	test   $0x802,%eax
  8010cc:	74 94                	je     801062 <fork+0x77>
		r = sys_page_map((envid_t)0, va, envid, va, PTE_U | PTE_P | PTE_COW);
  8010ce:	83 ec 0c             	sub    $0xc,%esp
  8010d1:	68 05 08 00 00       	push   $0x805
  8010d6:	56                   	push   %esi
  8010d7:	57                   	push   %edi
  8010d8:	56                   	push   %esi
  8010d9:	6a 00                	push   $0x0
  8010db:	e8 20 fc ff ff       	call   800d00 <sys_page_map>
		if(r < 0){
  8010e0:	83 c4 20             	add    $0x20,%esp
  8010e3:	85 c0                	test   %eax,%eax
  8010e5:	0f 88 65 ff ff ff    	js     801050 <fork+0x65>
		r = sys_page_map((envid_t)0, va, (envid_t)0, va, PTE_U | PTE_P | PTE_COW);
  8010eb:	83 ec 0c             	sub    $0xc,%esp
  8010ee:	68 05 08 00 00       	push   $0x805
  8010f3:	56                   	push   %esi
  8010f4:	6a 00                	push   $0x0
  8010f6:	56                   	push   %esi
  8010f7:	6a 00                	push   $0x0
  8010f9:	e8 02 fc ff ff       	call   800d00 <sys_page_map>
		if(r < 0){
  8010fe:	83 c4 20             	add    $0x20,%esp
  801101:	85 c0                	test   %eax,%eax
  801103:	0f 89 73 ff ff ff    	jns    80107c <fork+0x91>
			panic("sys_page_map: sys_page_map fail, r:%d\n", r);
  801109:	50                   	push   %eax
  80110a:	68 34 1b 80 00       	push   $0x801b34
  80110f:	6a 5b                	push   $0x5b
  801111:	68 97 1a 80 00       	push   $0x801a97
  801116:	e8 f0 01 00 00       	call   80130b <_panic>
			panic("sys_page_map: sys_page_map fail, r:%d\n", r);
  80111b:	50                   	push   %eax
  80111c:	68 34 1b 80 00       	push   $0x801b34
  801121:	6a 61                	push   $0x61
  801123:	68 97 1a 80 00       	push   $0x801a97
  801128:	e8 de 01 00 00       	call   80130b <_panic>
			duppage(childid, PGNUM(va));
		}
	}

	r = sys_page_alloc(childid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  80112d:	83 ec 04             	sub    $0x4,%esp
  801130:	6a 07                	push   $0x7
  801132:	68 00 f0 bf ee       	push   $0xeebff000
  801137:	ff 75 e4             	pushl  -0x1c(%ebp)
  80113a:	e8 7e fb ff ff       	call   800cbd <sys_page_alloc>
	if (r < 0){
  80113f:	83 c4 10             	add    $0x10,%esp
  801142:	85 c0                	test   %eax,%eax
  801144:	78 36                	js     80117c <fork+0x191>
		panic("fork: allocate user exception stack for child env error, %d", r);
	}
	r = sys_env_set_pgfault_upcall(childid, _pgfault_upcall);
  801146:	83 ec 08             	sub    $0x8,%esp
  801149:	68 bc 13 80 00       	push   $0x8013bc
  80114e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801151:	e8 b2 fc ff ff       	call   800e08 <sys_env_set_pgfault_upcall>
	if (r < 0){
  801156:	83 c4 10             	add    $0x10,%esp
  801159:	85 c0                	test   %eax,%eax
  80115b:	78 34                	js     801191 <fork+0x1a6>
		panic("fork: sys_env_set_pgfault_upcall error, %d", r);
	}
	r = sys_env_set_status(childid, ENV_RUNNABLE);
  80115d:	83 ec 08             	sub    $0x8,%esp
  801160:	6a 02                	push   $0x2
  801162:	ff 75 e4             	pushl  -0x1c(%ebp)
  801165:	e8 1a fc ff ff       	call   800d84 <sys_env_set_status>
	if(r < 0){
  80116a:	83 c4 10             	add    $0x10,%esp
  80116d:	85 c0                	test   %eax,%eax
  80116f:	78 35                	js     8011a6 <fork+0x1bb>
		panic("forK: sys_env_set_status, r%d", r);
	}
	return childid;
}
  801171:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801174:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801177:	5b                   	pop    %ebx
  801178:	5e                   	pop    %esi
  801179:	5f                   	pop    %edi
  80117a:	5d                   	pop    %ebp
  80117b:	c3                   	ret    
		panic("fork: allocate user exception stack for child env error, %d", r);
  80117c:	50                   	push   %eax
  80117d:	68 5c 1b 80 00       	push   $0x801b5c
  801182:	68 96 00 00 00       	push   $0x96
  801187:	68 97 1a 80 00       	push   $0x801a97
  80118c:	e8 7a 01 00 00       	call   80130b <_panic>
		panic("fork: sys_env_set_pgfault_upcall error, %d", r);
  801191:	50                   	push   %eax
  801192:	68 98 1b 80 00       	push   $0x801b98
  801197:	68 9a 00 00 00       	push   $0x9a
  80119c:	68 97 1a 80 00       	push   $0x801a97
  8011a1:	e8 65 01 00 00       	call   80130b <_panic>
		panic("forK: sys_env_set_status, r%d", r);
  8011a6:	50                   	push   %eax
  8011a7:	68 cc 1a 80 00       	push   $0x801acc
  8011ac:	68 9e 00 00 00       	push   $0x9e
  8011b1:	68 97 1a 80 00       	push   $0x801a97
  8011b6:	e8 50 01 00 00       	call   80130b <_panic>

008011bb <sfork>:

// Challenge!
int
sfork(void)
{
  8011bb:	55                   	push   %ebp
  8011bc:	89 e5                	mov    %esp,%ebp
  8011be:	57                   	push   %edi
  8011bf:	56                   	push   %esi
  8011c0:	53                   	push   %ebx
  8011c1:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// return -E_INVAL;
	set_pgfault_handler(pgfault);
  8011c4:	68 ef 0e 80 00       	push   $0x800eef
  8011c9:	e8 83 01 00 00       	call   801351 <set_pgfault_handler>
  8011ce:	b8 07 00 00 00       	mov    $0x7,%eax
  8011d3:	cd 30                	int    $0x30
  8011d5:	89 c6                	mov    %eax,%esi
	int i;
	uintptr_t va;
	envid_t childid = sys_exofork();
	int r;
	if (childid < 0){
  8011d7:	83 c4 10             	add    $0x10,%esp
  8011da:	85 c0                	test   %eax,%eax
  8011dc:	78 28                	js     801206 <sfork+0x4b>
  8011de:	89 c7                	mov    %eax,%edi
	}

	extern volatile pde_t uvpd[];
	extern volatile pte_t uvpt[];

	for (va = 0; va < USTACKTOP; va += PGSIZE){
  8011e0:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (childid == 0) {
  8011e5:	75 42                	jne    801229 <sfork+0x6e>
		thisenv = &envs[ENVX(sys_getenvid())];
  8011e7:	e8 93 fa ff ff       	call   800c7f <sys_getenvid>
  8011ec:	25 ff 03 00 00       	and    $0x3ff,%eax
  8011f1:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8011f7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8011fc:	a3 04 20 80 00       	mov    %eax,0x802004
		return 0;
  801201:	e9 bc 00 00 00       	jmp    8012c2 <sfork+0x107>
		panic("fork: child id < 0: %d", childid);
  801206:	50                   	push   %eax
  801207:	68 b5 1a 80 00       	push   $0x801ab5
  80120c:	68 af 00 00 00       	push   $0xaf
  801211:	68 97 1a 80 00       	push   $0x801a97
  801216:	e8 f0 00 00 00       	call   80130b <_panic>
	for (va = 0; va < USTACKTOP; va += PGSIZE){
  80121b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801221:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801227:	74 5b                	je     801284 <sfork+0xc9>
		if ((uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_U)){
  801229:	89 d8                	mov    %ebx,%eax
  80122b:	c1 e8 16             	shr    $0x16,%eax
  80122e:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801235:	a8 01                	test   $0x1,%al
  801237:	74 e2                	je     80121b <sfork+0x60>
  801239:	89 d8                	mov    %ebx,%eax
  80123b:	c1 e8 0c             	shr    $0xc,%eax
  80123e:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801245:	f6 c2 01             	test   $0x1,%dl
  801248:	74 d1                	je     80121b <sfork+0x60>
  80124a:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801251:	f6 c2 04             	test   $0x4,%dl
  801254:	74 c5                	je     80121b <sfork+0x60>
			void *addr = (void *)(PGNUM(va) * PGSIZE);
  801256:	c1 e0 0c             	shl    $0xc,%eax
			struct PageInfo *page;
			pte_t *pte;
			
			// page = page_lookup((envid_t)0->env_pgdir, addr, &pte);
			// page_insert(dstenv->env_pgdir, page, addr, PTE_U | PTE_P);
			r = sys_page_map((envid_t)0, addr, childid, addr, PTE_U | PTE_P);
  801259:	83 ec 0c             	sub    $0xc,%esp
  80125c:	6a 05                	push   $0x5
  80125e:	50                   	push   %eax
  80125f:	57                   	push   %edi
  801260:	50                   	push   %eax
  801261:	6a 00                	push   $0x0
  801263:	e8 98 fa ff ff       	call   800d00 <sys_page_map>
			if(r < 0){
  801268:	83 c4 20             	add    $0x20,%esp
  80126b:	85 c0                	test   %eax,%eax
  80126d:	79 ac                	jns    80121b <sfork+0x60>
				panic("sfork: sys_page_map fail, r:%d\n", r);
  80126f:	50                   	push   %eax
  801270:	68 c4 1b 80 00       	push   $0x801bc4
  801275:	68 c4 00 00 00       	push   $0xc4
  80127a:	68 97 1a 80 00       	push   $0x801a97
  80127f:	e8 87 00 00 00       	call   80130b <_panic>
			}
		}
	}

	r = sys_page_alloc(childid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801284:	83 ec 04             	sub    $0x4,%esp
  801287:	6a 07                	push   $0x7
  801289:	68 00 f0 bf ee       	push   $0xeebff000
  80128e:	56                   	push   %esi
  80128f:	e8 29 fa ff ff       	call   800cbd <sys_page_alloc>
	if (r < 0){
  801294:	83 c4 10             	add    $0x10,%esp
  801297:	85 c0                	test   %eax,%eax
  801299:	78 31                	js     8012cc <sfork+0x111>
		panic("sfork: allocate user exception stack for child env error, %d", r);
	}
	r = sys_env_set_pgfault_upcall(childid, _pgfault_upcall);
  80129b:	83 ec 08             	sub    $0x8,%esp
  80129e:	68 bc 13 80 00       	push   $0x8013bc
  8012a3:	56                   	push   %esi
  8012a4:	e8 5f fb ff ff       	call   800e08 <sys_env_set_pgfault_upcall>
	if (r < 0){
  8012a9:	83 c4 10             	add    $0x10,%esp
  8012ac:	85 c0                	test   %eax,%eax
  8012ae:	78 31                	js     8012e1 <sfork+0x126>
		panic("sfork: sys_env_set_pgfault_upcall error, %d", r);
	}
	r = sys_env_set_status(childid, ENV_RUNNABLE);
  8012b0:	83 ec 08             	sub    $0x8,%esp
  8012b3:	6a 02                	push   $0x2
  8012b5:	56                   	push   %esi
  8012b6:	e8 c9 fa ff ff       	call   800d84 <sys_env_set_status>
	if(r < 0){
  8012bb:	83 c4 10             	add    $0x10,%esp
  8012be:	85 c0                	test   %eax,%eax
  8012c0:	78 34                	js     8012f6 <sfork+0x13b>
		panic("sforK: sys_env_set_status, r%d", r);
	}
	return childid;
}
  8012c2:	89 f0                	mov    %esi,%eax
  8012c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012c7:	5b                   	pop    %ebx
  8012c8:	5e                   	pop    %esi
  8012c9:	5f                   	pop    %edi
  8012ca:	5d                   	pop    %ebp
  8012cb:	c3                   	ret    
		panic("sfork: allocate user exception stack for child env error, %d", r);
  8012cc:	50                   	push   %eax
  8012cd:	68 e4 1b 80 00       	push   $0x801be4
  8012d2:	68 cb 00 00 00       	push   $0xcb
  8012d7:	68 97 1a 80 00       	push   $0x801a97
  8012dc:	e8 2a 00 00 00       	call   80130b <_panic>
		panic("sfork: sys_env_set_pgfault_upcall error, %d", r);
  8012e1:	50                   	push   %eax
  8012e2:	68 24 1c 80 00       	push   $0x801c24
  8012e7:	68 cf 00 00 00       	push   $0xcf
  8012ec:	68 97 1a 80 00       	push   $0x801a97
  8012f1:	e8 15 00 00 00       	call   80130b <_panic>
		panic("sforK: sys_env_set_status, r%d", r);
  8012f6:	50                   	push   %eax
  8012f7:	68 50 1c 80 00       	push   $0x801c50
  8012fc:	68 d3 00 00 00       	push   $0xd3
  801301:	68 97 1a 80 00       	push   $0x801a97
  801306:	e8 00 00 00 00       	call   80130b <_panic>

0080130b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80130b:	55                   	push   %ebp
  80130c:	89 e5                	mov    %esp,%ebp
  80130e:	56                   	push   %esi
  80130f:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801310:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801313:	8b 35 00 20 80 00    	mov    0x802000,%esi
  801319:	e8 61 f9 ff ff       	call   800c7f <sys_getenvid>
  80131e:	83 ec 0c             	sub    $0xc,%esp
  801321:	ff 75 0c             	pushl  0xc(%ebp)
  801324:	ff 75 08             	pushl  0x8(%ebp)
  801327:	56                   	push   %esi
  801328:	50                   	push   %eax
  801329:	68 70 1c 80 00       	push   $0x801c70
  80132e:	e8 72 ee ff ff       	call   8001a5 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801333:	83 c4 18             	add    $0x18,%esp
  801336:	53                   	push   %ebx
  801337:	ff 75 10             	pushl  0x10(%ebp)
  80133a:	e8 15 ee ff ff       	call   800154 <vcprintf>
	cprintf("\n");
  80133f:	c7 04 24 d4 16 80 00 	movl   $0x8016d4,(%esp)
  801346:	e8 5a ee ff ff       	call   8001a5 <cprintf>
  80134b:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80134e:	cc                   	int3   
  80134f:	eb fd                	jmp    80134e <_panic+0x43>

00801351 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801351:	55                   	push   %ebp
  801352:	89 e5                	mov    %esp,%ebp
  801354:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801357:	83 3d 08 20 80 00 00 	cmpl   $0x0,0x802008
  80135e:	74 0a                	je     80136a <set_pgfault_handler+0x19>
			panic("set_pgfault_handler: sys_env_set_pgfault_upcall fail, ret:%d", ret);
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801360:	8b 45 08             	mov    0x8(%ebp),%eax
  801363:	a3 08 20 80 00       	mov    %eax,0x802008
}
  801368:	c9                   	leave  
  801369:	c3                   	ret    
		ret = sys_page_alloc((envid_t)0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W);
  80136a:	83 ec 04             	sub    $0x4,%esp
  80136d:	6a 07                	push   $0x7
  80136f:	68 00 f0 bf ee       	push   $0xeebff000
  801374:	6a 00                	push   $0x0
  801376:	e8 42 f9 ff ff       	call   800cbd <sys_page_alloc>
		if(ret < 0){
  80137b:	83 c4 10             	add    $0x10,%esp
  80137e:	85 c0                	test   %eax,%eax
  801380:	78 28                	js     8013aa <set_pgfault_handler+0x59>
    	ret = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  801382:	83 ec 08             	sub    $0x8,%esp
  801385:	68 bc 13 80 00       	push   $0x8013bc
  80138a:	6a 00                	push   $0x0
  80138c:	e8 77 fa ff ff       	call   800e08 <sys_env_set_pgfault_upcall>
		if(ret < 0){
  801391:	83 c4 10             	add    $0x10,%esp
  801394:	85 c0                	test   %eax,%eax
  801396:	79 c8                	jns    801360 <set_pgfault_handler+0xf>
			panic("set_pgfault_handler: sys_env_set_pgfault_upcall fail, ret:%d", ret);
  801398:	50                   	push   %eax
  801399:	68 c8 1c 80 00       	push   $0x801cc8
  80139e:	6a 28                	push   $0x28
  8013a0:	68 08 1d 80 00       	push   $0x801d08
  8013a5:	e8 61 ff ff ff       	call   80130b <_panic>
			panic("set_pgfault_handler: sys_page_alloc fail, ret:%d", ret);
  8013aa:	50                   	push   %eax
  8013ab:	68 94 1c 80 00       	push   $0x801c94
  8013b0:	6a 24                	push   $0x24
  8013b2:	68 08 1d 80 00       	push   $0x801d08
  8013b7:	e8 4f ff ff ff       	call   80130b <_panic>

008013bc <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8013bc:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8013bd:	a1 08 20 80 00       	mov    0x802008,%eax
	call *%eax
  8013c2:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8013c4:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %edi
  8013c7:	8b 7c 24 28          	mov    0x28(%esp),%edi
	movl 0x30(%esp), %esi
  8013cb:	8b 74 24 30          	mov    0x30(%esp),%esi
	subl $4, %esi
  8013cf:	83 ee 04             	sub    $0x4,%esi
	movl %edi, (%esi)
  8013d2:	89 3e                	mov    %edi,(%esi)
	movl %esi, 0x30(%esp)
  8013d4:	89 74 24 30          	mov    %esi,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  8013d8:	83 c4 08             	add    $0x8,%esp
	popal
  8013db:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8013dc:	83 c4 04             	add    $0x4,%esp
	popfl
  8013df:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8013e0:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  8013e1:	c3                   	ret    
  8013e2:	66 90                	xchg   %ax,%ax
  8013e4:	66 90                	xchg   %ax,%ax
  8013e6:	66 90                	xchg   %ax,%ax
  8013e8:	66 90                	xchg   %ax,%ax
  8013ea:	66 90                	xchg   %ax,%ax
  8013ec:	66 90                	xchg   %ax,%ax
  8013ee:	66 90                	xchg   %ax,%ax

008013f0 <__udivdi3>:
  8013f0:	55                   	push   %ebp
  8013f1:	57                   	push   %edi
  8013f2:	56                   	push   %esi
  8013f3:	53                   	push   %ebx
  8013f4:	83 ec 1c             	sub    $0x1c,%esp
  8013f7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8013fb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8013ff:	8b 74 24 34          	mov    0x34(%esp),%esi
  801403:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801407:	85 d2                	test   %edx,%edx
  801409:	75 4d                	jne    801458 <__udivdi3+0x68>
  80140b:	39 f3                	cmp    %esi,%ebx
  80140d:	76 19                	jbe    801428 <__udivdi3+0x38>
  80140f:	31 ff                	xor    %edi,%edi
  801411:	89 e8                	mov    %ebp,%eax
  801413:	89 f2                	mov    %esi,%edx
  801415:	f7 f3                	div    %ebx
  801417:	89 fa                	mov    %edi,%edx
  801419:	83 c4 1c             	add    $0x1c,%esp
  80141c:	5b                   	pop    %ebx
  80141d:	5e                   	pop    %esi
  80141e:	5f                   	pop    %edi
  80141f:	5d                   	pop    %ebp
  801420:	c3                   	ret    
  801421:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801428:	89 d9                	mov    %ebx,%ecx
  80142a:	85 db                	test   %ebx,%ebx
  80142c:	75 0b                	jne    801439 <__udivdi3+0x49>
  80142e:	b8 01 00 00 00       	mov    $0x1,%eax
  801433:	31 d2                	xor    %edx,%edx
  801435:	f7 f3                	div    %ebx
  801437:	89 c1                	mov    %eax,%ecx
  801439:	31 d2                	xor    %edx,%edx
  80143b:	89 f0                	mov    %esi,%eax
  80143d:	f7 f1                	div    %ecx
  80143f:	89 c6                	mov    %eax,%esi
  801441:	89 e8                	mov    %ebp,%eax
  801443:	89 f7                	mov    %esi,%edi
  801445:	f7 f1                	div    %ecx
  801447:	89 fa                	mov    %edi,%edx
  801449:	83 c4 1c             	add    $0x1c,%esp
  80144c:	5b                   	pop    %ebx
  80144d:	5e                   	pop    %esi
  80144e:	5f                   	pop    %edi
  80144f:	5d                   	pop    %ebp
  801450:	c3                   	ret    
  801451:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801458:	39 f2                	cmp    %esi,%edx
  80145a:	77 1c                	ja     801478 <__udivdi3+0x88>
  80145c:	0f bd fa             	bsr    %edx,%edi
  80145f:	83 f7 1f             	xor    $0x1f,%edi
  801462:	75 2c                	jne    801490 <__udivdi3+0xa0>
  801464:	39 f2                	cmp    %esi,%edx
  801466:	72 06                	jb     80146e <__udivdi3+0x7e>
  801468:	31 c0                	xor    %eax,%eax
  80146a:	39 eb                	cmp    %ebp,%ebx
  80146c:	77 a9                	ja     801417 <__udivdi3+0x27>
  80146e:	b8 01 00 00 00       	mov    $0x1,%eax
  801473:	eb a2                	jmp    801417 <__udivdi3+0x27>
  801475:	8d 76 00             	lea    0x0(%esi),%esi
  801478:	31 ff                	xor    %edi,%edi
  80147a:	31 c0                	xor    %eax,%eax
  80147c:	89 fa                	mov    %edi,%edx
  80147e:	83 c4 1c             	add    $0x1c,%esp
  801481:	5b                   	pop    %ebx
  801482:	5e                   	pop    %esi
  801483:	5f                   	pop    %edi
  801484:	5d                   	pop    %ebp
  801485:	c3                   	ret    
  801486:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80148d:	8d 76 00             	lea    0x0(%esi),%esi
  801490:	89 f9                	mov    %edi,%ecx
  801492:	b8 20 00 00 00       	mov    $0x20,%eax
  801497:	29 f8                	sub    %edi,%eax
  801499:	d3 e2                	shl    %cl,%edx
  80149b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80149f:	89 c1                	mov    %eax,%ecx
  8014a1:	89 da                	mov    %ebx,%edx
  8014a3:	d3 ea                	shr    %cl,%edx
  8014a5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8014a9:	09 d1                	or     %edx,%ecx
  8014ab:	89 f2                	mov    %esi,%edx
  8014ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8014b1:	89 f9                	mov    %edi,%ecx
  8014b3:	d3 e3                	shl    %cl,%ebx
  8014b5:	89 c1                	mov    %eax,%ecx
  8014b7:	d3 ea                	shr    %cl,%edx
  8014b9:	89 f9                	mov    %edi,%ecx
  8014bb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8014bf:	89 eb                	mov    %ebp,%ebx
  8014c1:	d3 e6                	shl    %cl,%esi
  8014c3:	89 c1                	mov    %eax,%ecx
  8014c5:	d3 eb                	shr    %cl,%ebx
  8014c7:	09 de                	or     %ebx,%esi
  8014c9:	89 f0                	mov    %esi,%eax
  8014cb:	f7 74 24 08          	divl   0x8(%esp)
  8014cf:	89 d6                	mov    %edx,%esi
  8014d1:	89 c3                	mov    %eax,%ebx
  8014d3:	f7 64 24 0c          	mull   0xc(%esp)
  8014d7:	39 d6                	cmp    %edx,%esi
  8014d9:	72 15                	jb     8014f0 <__udivdi3+0x100>
  8014db:	89 f9                	mov    %edi,%ecx
  8014dd:	d3 e5                	shl    %cl,%ebp
  8014df:	39 c5                	cmp    %eax,%ebp
  8014e1:	73 04                	jae    8014e7 <__udivdi3+0xf7>
  8014e3:	39 d6                	cmp    %edx,%esi
  8014e5:	74 09                	je     8014f0 <__udivdi3+0x100>
  8014e7:	89 d8                	mov    %ebx,%eax
  8014e9:	31 ff                	xor    %edi,%edi
  8014eb:	e9 27 ff ff ff       	jmp    801417 <__udivdi3+0x27>
  8014f0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8014f3:	31 ff                	xor    %edi,%edi
  8014f5:	e9 1d ff ff ff       	jmp    801417 <__udivdi3+0x27>
  8014fa:	66 90                	xchg   %ax,%ax
  8014fc:	66 90                	xchg   %ax,%ax
  8014fe:	66 90                	xchg   %ax,%ax

00801500 <__umoddi3>:
  801500:	55                   	push   %ebp
  801501:	57                   	push   %edi
  801502:	56                   	push   %esi
  801503:	53                   	push   %ebx
  801504:	83 ec 1c             	sub    $0x1c,%esp
  801507:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80150b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80150f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801513:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801517:	89 da                	mov    %ebx,%edx
  801519:	85 c0                	test   %eax,%eax
  80151b:	75 43                	jne    801560 <__umoddi3+0x60>
  80151d:	39 df                	cmp    %ebx,%edi
  80151f:	76 17                	jbe    801538 <__umoddi3+0x38>
  801521:	89 f0                	mov    %esi,%eax
  801523:	f7 f7                	div    %edi
  801525:	89 d0                	mov    %edx,%eax
  801527:	31 d2                	xor    %edx,%edx
  801529:	83 c4 1c             	add    $0x1c,%esp
  80152c:	5b                   	pop    %ebx
  80152d:	5e                   	pop    %esi
  80152e:	5f                   	pop    %edi
  80152f:	5d                   	pop    %ebp
  801530:	c3                   	ret    
  801531:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801538:	89 fd                	mov    %edi,%ebp
  80153a:	85 ff                	test   %edi,%edi
  80153c:	75 0b                	jne    801549 <__umoddi3+0x49>
  80153e:	b8 01 00 00 00       	mov    $0x1,%eax
  801543:	31 d2                	xor    %edx,%edx
  801545:	f7 f7                	div    %edi
  801547:	89 c5                	mov    %eax,%ebp
  801549:	89 d8                	mov    %ebx,%eax
  80154b:	31 d2                	xor    %edx,%edx
  80154d:	f7 f5                	div    %ebp
  80154f:	89 f0                	mov    %esi,%eax
  801551:	f7 f5                	div    %ebp
  801553:	89 d0                	mov    %edx,%eax
  801555:	eb d0                	jmp    801527 <__umoddi3+0x27>
  801557:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80155e:	66 90                	xchg   %ax,%ax
  801560:	89 f1                	mov    %esi,%ecx
  801562:	39 d8                	cmp    %ebx,%eax
  801564:	76 0a                	jbe    801570 <__umoddi3+0x70>
  801566:	89 f0                	mov    %esi,%eax
  801568:	83 c4 1c             	add    $0x1c,%esp
  80156b:	5b                   	pop    %ebx
  80156c:	5e                   	pop    %esi
  80156d:	5f                   	pop    %edi
  80156e:	5d                   	pop    %ebp
  80156f:	c3                   	ret    
  801570:	0f bd e8             	bsr    %eax,%ebp
  801573:	83 f5 1f             	xor    $0x1f,%ebp
  801576:	75 20                	jne    801598 <__umoddi3+0x98>
  801578:	39 d8                	cmp    %ebx,%eax
  80157a:	0f 82 b0 00 00 00    	jb     801630 <__umoddi3+0x130>
  801580:	39 f7                	cmp    %esi,%edi
  801582:	0f 86 a8 00 00 00    	jbe    801630 <__umoddi3+0x130>
  801588:	89 c8                	mov    %ecx,%eax
  80158a:	83 c4 1c             	add    $0x1c,%esp
  80158d:	5b                   	pop    %ebx
  80158e:	5e                   	pop    %esi
  80158f:	5f                   	pop    %edi
  801590:	5d                   	pop    %ebp
  801591:	c3                   	ret    
  801592:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801598:	89 e9                	mov    %ebp,%ecx
  80159a:	ba 20 00 00 00       	mov    $0x20,%edx
  80159f:	29 ea                	sub    %ebp,%edx
  8015a1:	d3 e0                	shl    %cl,%eax
  8015a3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8015a7:	89 d1                	mov    %edx,%ecx
  8015a9:	89 f8                	mov    %edi,%eax
  8015ab:	d3 e8                	shr    %cl,%eax
  8015ad:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8015b1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8015b5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8015b9:	09 c1                	or     %eax,%ecx
  8015bb:	89 d8                	mov    %ebx,%eax
  8015bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8015c1:	89 e9                	mov    %ebp,%ecx
  8015c3:	d3 e7                	shl    %cl,%edi
  8015c5:	89 d1                	mov    %edx,%ecx
  8015c7:	d3 e8                	shr    %cl,%eax
  8015c9:	89 e9                	mov    %ebp,%ecx
  8015cb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8015cf:	d3 e3                	shl    %cl,%ebx
  8015d1:	89 c7                	mov    %eax,%edi
  8015d3:	89 d1                	mov    %edx,%ecx
  8015d5:	89 f0                	mov    %esi,%eax
  8015d7:	d3 e8                	shr    %cl,%eax
  8015d9:	89 e9                	mov    %ebp,%ecx
  8015db:	89 fa                	mov    %edi,%edx
  8015dd:	d3 e6                	shl    %cl,%esi
  8015df:	09 d8                	or     %ebx,%eax
  8015e1:	f7 74 24 08          	divl   0x8(%esp)
  8015e5:	89 d1                	mov    %edx,%ecx
  8015e7:	89 f3                	mov    %esi,%ebx
  8015e9:	f7 64 24 0c          	mull   0xc(%esp)
  8015ed:	89 c6                	mov    %eax,%esi
  8015ef:	89 d7                	mov    %edx,%edi
  8015f1:	39 d1                	cmp    %edx,%ecx
  8015f3:	72 06                	jb     8015fb <__umoddi3+0xfb>
  8015f5:	75 10                	jne    801607 <__umoddi3+0x107>
  8015f7:	39 c3                	cmp    %eax,%ebx
  8015f9:	73 0c                	jae    801607 <__umoddi3+0x107>
  8015fb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8015ff:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801603:	89 d7                	mov    %edx,%edi
  801605:	89 c6                	mov    %eax,%esi
  801607:	89 ca                	mov    %ecx,%edx
  801609:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80160e:	29 f3                	sub    %esi,%ebx
  801610:	19 fa                	sbb    %edi,%edx
  801612:	89 d0                	mov    %edx,%eax
  801614:	d3 e0                	shl    %cl,%eax
  801616:	89 e9                	mov    %ebp,%ecx
  801618:	d3 eb                	shr    %cl,%ebx
  80161a:	d3 ea                	shr    %cl,%edx
  80161c:	09 d8                	or     %ebx,%eax
  80161e:	83 c4 1c             	add    $0x1c,%esp
  801621:	5b                   	pop    %ebx
  801622:	5e                   	pop    %esi
  801623:	5f                   	pop    %edi
  801624:	5d                   	pop    %ebp
  801625:	c3                   	ret    
  801626:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80162d:	8d 76 00             	lea    0x0(%esi),%esi
  801630:	89 da                	mov    %ebx,%edx
  801632:	29 fe                	sub    %edi,%esi
  801634:	19 c2                	sbb    %eax,%edx
  801636:	89 f1                	mov    %esi,%ecx
  801638:	89 c8                	mov    %ecx,%eax
  80163a:	e9 4b ff ff ff       	jmp    80158a <__umoddi3+0x8a>
