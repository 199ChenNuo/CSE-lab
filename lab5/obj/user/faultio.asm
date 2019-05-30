
obj/user/faultio.debug:     file format elf32-i386


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
  80002c:	e8 3e 00 00 00       	call   80006f <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>
#include <inc/x86.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 08             	sub    $0x8,%esp

static inline uint32_t
read_eflags(void)
{
	uint32_t eflags;
	asm volatile("pushfl; popl %0" : "=r" (eflags));
  800039:	9c                   	pushf  
  80003a:	58                   	pop    %eax
        int x, r;
	int nsecs = 1;
	int secno = 0;
	int diskno = 1;

	if (read_eflags() & FL_IOPL_3)
  80003b:	f6 c4 30             	test   $0x30,%ah
  80003e:	75 1d                	jne    80005d <umain+0x2a>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800040:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800045:	ba f6 01 00 00       	mov    $0x1f6,%edx
  80004a:	ee                   	out    %al,(%dx)

	// this outb to select disk 1 should result in a general protection
	// fault, because user-level code shouldn't be able to use the io space.
	outb(0x1F6, 0xE0 | (1<<4));

        cprintf("%s: made it here --- bug\n");
  80004b:	83 ec 0c             	sub    $0xc,%esp
  80004e:	68 4e 11 80 00       	push   $0x80114e
  800053:	e8 07 01 00 00       	call   80015f <cprintf>
}
  800058:	83 c4 10             	add    $0x10,%esp
  80005b:	c9                   	leave  
  80005c:	c3                   	ret    
		cprintf("eflags wrong\n");
  80005d:	83 ec 0c             	sub    $0xc,%esp
  800060:	68 40 11 80 00       	push   $0x801140
  800065:	e8 f5 00 00 00       	call   80015f <cprintf>
  80006a:	83 c4 10             	add    $0x10,%esp
  80006d:	eb d1                	jmp    800040 <umain+0xd>

0080006f <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80006f:	55                   	push   %ebp
  800070:	89 e5                	mov    %esp,%ebp
  800072:	56                   	push   %esi
  800073:	53                   	push   %ebx
  800074:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800077:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	// thisenv = 0;
	thisenv = &(envs[ENVX(sys_getenvid())]);
  80007a:	e8 ba 0b 00 00       	call   800c39 <sys_getenvid>
  80007f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800084:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80008a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80008f:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800094:	85 db                	test   %ebx,%ebx
  800096:	7e 07                	jle    80009f <libmain+0x30>
		binaryname = argv[0];
  800098:	8b 06                	mov    (%esi),%eax
  80009a:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  80009f:	83 ec 08             	sub    $0x8,%esp
  8000a2:	56                   	push   %esi
  8000a3:	53                   	push   %ebx
  8000a4:	e8 8a ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000a9:	e8 0a 00 00 00       	call   8000b8 <exit>
}
  8000ae:	83 c4 10             	add    $0x10,%esp
  8000b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000b4:	5b                   	pop    %ebx
  8000b5:	5e                   	pop    %esi
  8000b6:	5d                   	pop    %ebp
  8000b7:	c3                   	ret    

008000b8 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000b8:	55                   	push   %ebp
  8000b9:	89 e5                	mov    %esp,%ebp
  8000bb:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  8000be:	6a 00                	push   $0x0
  8000c0:	e8 33 0b 00 00       	call   800bf8 <sys_env_destroy>
}
  8000c5:	83 c4 10             	add    $0x10,%esp
  8000c8:	c9                   	leave  
  8000c9:	c3                   	ret    

008000ca <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000ca:	55                   	push   %ebp
  8000cb:	89 e5                	mov    %esp,%ebp
  8000cd:	53                   	push   %ebx
  8000ce:	83 ec 04             	sub    $0x4,%esp
  8000d1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000d4:	8b 13                	mov    (%ebx),%edx
  8000d6:	8d 42 01             	lea    0x1(%edx),%eax
  8000d9:	89 03                	mov    %eax,(%ebx)
  8000db:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000de:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000e2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000e7:	74 09                	je     8000f2 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000e9:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8000ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000f0:	c9                   	leave  
  8000f1:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8000f2:	83 ec 08             	sub    $0x8,%esp
  8000f5:	68 ff 00 00 00       	push   $0xff
  8000fa:	8d 43 08             	lea    0x8(%ebx),%eax
  8000fd:	50                   	push   %eax
  8000fe:	e8 b8 0a 00 00       	call   800bbb <sys_cputs>
		b->idx = 0;
  800103:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800109:	83 c4 10             	add    $0x10,%esp
  80010c:	eb db                	jmp    8000e9 <putch+0x1f>

0080010e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80010e:	55                   	push   %ebp
  80010f:	89 e5                	mov    %esp,%ebp
  800111:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800117:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80011e:	00 00 00 
	b.cnt = 0;
  800121:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800128:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80012b:	ff 75 0c             	pushl  0xc(%ebp)
  80012e:	ff 75 08             	pushl  0x8(%ebp)
  800131:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800137:	50                   	push   %eax
  800138:	68 ca 00 80 00       	push   $0x8000ca
  80013d:	e8 4a 01 00 00       	call   80028c <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800142:	83 c4 08             	add    $0x8,%esp
  800145:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80014b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800151:	50                   	push   %eax
  800152:	e8 64 0a 00 00       	call   800bbb <sys_cputs>

	return b.cnt;
}
  800157:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80015d:	c9                   	leave  
  80015e:	c3                   	ret    

0080015f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80015f:	55                   	push   %ebp
  800160:	89 e5                	mov    %esp,%ebp
  800162:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800165:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800168:	50                   	push   %eax
  800169:	ff 75 08             	pushl  0x8(%ebp)
  80016c:	e8 9d ff ff ff       	call   80010e <vcprintf>
	va_end(ap);

	return cnt;
}
  800171:	c9                   	leave  
  800172:	c3                   	ret    

00800173 <printnum>:


static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800173:	55                   	push   %ebp
  800174:	89 e5                	mov    %esp,%ebp
  800176:	57                   	push   %edi
  800177:	56                   	push   %esi
  800178:	53                   	push   %ebx
  800179:	83 ec 1c             	sub    $0x1c,%esp
  80017c:	89 c6                	mov    %eax,%esi
  80017e:	89 d7                	mov    %edx,%edi
  800180:	8b 45 08             	mov    0x8(%ebp),%eax
  800183:	8b 55 0c             	mov    0xc(%ebp),%edx
  800186:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800189:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80018c:	8b 45 10             	mov    0x10(%ebp),%eax
  80018f:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	// to support '-'
	if(padc == '-'){
  800192:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800196:	74 2c                	je     8001c4 <printnum+0x51>
		while (--width > 0)
			putch(' ', putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800198:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80019b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8001a2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8001a5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8001a8:	39 c2                	cmp    %eax,%edx
  8001aa:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8001ad:	73 43                	jae    8001f2 <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8001af:	83 eb 01             	sub    $0x1,%ebx
  8001b2:	85 db                	test   %ebx,%ebx
  8001b4:	7e 6c                	jle    800222 <printnum+0xaf>
			putch(padc, putdat);
  8001b6:	83 ec 08             	sub    $0x8,%esp
  8001b9:	57                   	push   %edi
  8001ba:	ff 75 18             	pushl  0x18(%ebp)
  8001bd:	ff d6                	call   *%esi
  8001bf:	83 c4 10             	add    $0x10,%esp
  8001c2:	eb eb                	jmp    8001af <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8001c4:	83 ec 0c             	sub    $0xc,%esp
  8001c7:	6a 20                	push   $0x20
  8001c9:	6a 00                	push   $0x0
  8001cb:	50                   	push   %eax
  8001cc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001cf:	ff 75 e0             	pushl  -0x20(%ebp)
  8001d2:	89 fa                	mov    %edi,%edx
  8001d4:	89 f0                	mov    %esi,%eax
  8001d6:	e8 98 ff ff ff       	call   800173 <printnum>
		while (--width > 0)
  8001db:	83 c4 20             	add    $0x20,%esp
  8001de:	83 eb 01             	sub    $0x1,%ebx
  8001e1:	85 db                	test   %ebx,%ebx
  8001e3:	7e 65                	jle    80024a <printnum+0xd7>
			putch(' ', putdat);
  8001e5:	83 ec 08             	sub    $0x8,%esp
  8001e8:	57                   	push   %edi
  8001e9:	6a 20                	push   $0x20
  8001eb:	ff d6                	call   *%esi
  8001ed:	83 c4 10             	add    $0x10,%esp
  8001f0:	eb ec                	jmp    8001de <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001f2:	83 ec 0c             	sub    $0xc,%esp
  8001f5:	ff 75 18             	pushl  0x18(%ebp)
  8001f8:	83 eb 01             	sub    $0x1,%ebx
  8001fb:	53                   	push   %ebx
  8001fc:	50                   	push   %eax
  8001fd:	83 ec 08             	sub    $0x8,%esp
  800200:	ff 75 dc             	pushl  -0x24(%ebp)
  800203:	ff 75 d8             	pushl  -0x28(%ebp)
  800206:	ff 75 e4             	pushl  -0x1c(%ebp)
  800209:	ff 75 e0             	pushl  -0x20(%ebp)
  80020c:	e8 df 0c 00 00       	call   800ef0 <__udivdi3>
  800211:	83 c4 18             	add    $0x18,%esp
  800214:	52                   	push   %edx
  800215:	50                   	push   %eax
  800216:	89 fa                	mov    %edi,%edx
  800218:	89 f0                	mov    %esi,%eax
  80021a:	e8 54 ff ff ff       	call   800173 <printnum>
  80021f:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800222:	83 ec 08             	sub    $0x8,%esp
  800225:	57                   	push   %edi
  800226:	83 ec 04             	sub    $0x4,%esp
  800229:	ff 75 dc             	pushl  -0x24(%ebp)
  80022c:	ff 75 d8             	pushl  -0x28(%ebp)
  80022f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800232:	ff 75 e0             	pushl  -0x20(%ebp)
  800235:	e8 c6 0d 00 00       	call   801000 <__umoddi3>
  80023a:	83 c4 14             	add    $0x14,%esp
  80023d:	0f be 80 72 11 80 00 	movsbl 0x801172(%eax),%eax
  800244:	50                   	push   %eax
  800245:	ff d6                	call   *%esi
  800247:	83 c4 10             	add    $0x10,%esp
}
  80024a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80024d:	5b                   	pop    %ebx
  80024e:	5e                   	pop    %esi
  80024f:	5f                   	pop    %edi
  800250:	5d                   	pop    %ebp
  800251:	c3                   	ret    

00800252 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800252:	55                   	push   %ebp
  800253:	89 e5                	mov    %esp,%ebp
  800255:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800258:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80025c:	8b 10                	mov    (%eax),%edx
  80025e:	3b 50 04             	cmp    0x4(%eax),%edx
  800261:	73 0a                	jae    80026d <sprintputch+0x1b>
		*b->buf++ = ch;
  800263:	8d 4a 01             	lea    0x1(%edx),%ecx
  800266:	89 08                	mov    %ecx,(%eax)
  800268:	8b 45 08             	mov    0x8(%ebp),%eax
  80026b:	88 02                	mov    %al,(%edx)
}
  80026d:	5d                   	pop    %ebp
  80026e:	c3                   	ret    

0080026f <printfmt>:
{
  80026f:	55                   	push   %ebp
  800270:	89 e5                	mov    %esp,%ebp
  800272:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800275:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800278:	50                   	push   %eax
  800279:	ff 75 10             	pushl  0x10(%ebp)
  80027c:	ff 75 0c             	pushl  0xc(%ebp)
  80027f:	ff 75 08             	pushl  0x8(%ebp)
  800282:	e8 05 00 00 00       	call   80028c <vprintfmt>
}
  800287:	83 c4 10             	add    $0x10,%esp
  80028a:	c9                   	leave  
  80028b:	c3                   	ret    

0080028c <vprintfmt>:
{
  80028c:	55                   	push   %ebp
  80028d:	89 e5                	mov    %esp,%ebp
  80028f:	57                   	push   %edi
  800290:	56                   	push   %esi
  800291:	53                   	push   %ebx
  800292:	83 ec 3c             	sub    $0x3c,%esp
  800295:	8b 75 08             	mov    0x8(%ebp),%esi
  800298:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80029b:	8b 7d 10             	mov    0x10(%ebp),%edi
  80029e:	e9 1e 04 00 00       	jmp    8006c1 <vprintfmt+0x435>
		posflag = 0;
  8002a3:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
		padc = ' ';
  8002aa:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8002ae:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8002b5:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8002bc:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002c3:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  8002ca:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002cf:	8d 47 01             	lea    0x1(%edi),%eax
  8002d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002d5:	0f b6 17             	movzbl (%edi),%edx
  8002d8:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002db:	3c 55                	cmp    $0x55,%al
  8002dd:	0f 87 d9 04 00 00    	ja     8007bc <vprintfmt+0x530>
  8002e3:	0f b6 c0             	movzbl %al,%eax
  8002e6:	ff 24 85 60 13 80 00 	jmp    *0x801360(,%eax,4)
  8002ed:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002f0:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8002f4:	eb d9                	jmp    8002cf <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8002f6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posflag = 1;
  8002f9:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  800300:	eb cd                	jmp    8002cf <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800302:	0f b6 d2             	movzbl %dl,%edx
  800305:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800308:	b8 00 00 00 00       	mov    $0x0,%eax
  80030d:	89 75 08             	mov    %esi,0x8(%ebp)
  800310:	eb 0c                	jmp    80031e <vprintfmt+0x92>
		switch (ch = *(unsigned char *) fmt++) {
  800312:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800315:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  800319:	eb b4                	jmp    8002cf <vprintfmt+0x43>
			for (precision = 0; ; ++fmt) {
  80031b:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80031e:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800321:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800325:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800328:	8d 72 d0             	lea    -0x30(%edx),%esi
  80032b:	83 fe 09             	cmp    $0x9,%esi
  80032e:	76 eb                	jbe    80031b <vprintfmt+0x8f>
  800330:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800333:	8b 75 08             	mov    0x8(%ebp),%esi
  800336:	eb 14                	jmp    80034c <vprintfmt+0xc0>
			precision = va_arg(ap, int);
  800338:	8b 45 14             	mov    0x14(%ebp),%eax
  80033b:	8b 00                	mov    (%eax),%eax
  80033d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800340:	8b 45 14             	mov    0x14(%ebp),%eax
  800343:	8d 40 04             	lea    0x4(%eax),%eax
  800346:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800349:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80034c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800350:	0f 89 79 ff ff ff    	jns    8002cf <vprintfmt+0x43>
				width = precision, precision = -1;
  800356:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800359:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80035c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800363:	e9 67 ff ff ff       	jmp    8002cf <vprintfmt+0x43>
  800368:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80036b:	85 c0                	test   %eax,%eax
  80036d:	0f 48 c1             	cmovs  %ecx,%eax
  800370:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800373:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800376:	e9 54 ff ff ff       	jmp    8002cf <vprintfmt+0x43>
  80037b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80037e:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800385:	e9 45 ff ff ff       	jmp    8002cf <vprintfmt+0x43>
			lflag++;
  80038a:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80038e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800391:	e9 39 ff ff ff       	jmp    8002cf <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800396:	8b 45 14             	mov    0x14(%ebp),%eax
  800399:	8d 78 04             	lea    0x4(%eax),%edi
  80039c:	83 ec 08             	sub    $0x8,%esp
  80039f:	53                   	push   %ebx
  8003a0:	ff 30                	pushl  (%eax)
  8003a2:	ff d6                	call   *%esi
			break;
  8003a4:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003a7:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003aa:	e9 0f 03 00 00       	jmp    8006be <vprintfmt+0x432>
			err = va_arg(ap, int);
  8003af:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b2:	8d 78 04             	lea    0x4(%eax),%edi
  8003b5:	8b 00                	mov    (%eax),%eax
  8003b7:	99                   	cltd   
  8003b8:	31 d0                	xor    %edx,%eax
  8003ba:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003bc:	83 f8 0f             	cmp    $0xf,%eax
  8003bf:	7f 23                	jg     8003e4 <vprintfmt+0x158>
  8003c1:	8b 14 85 c0 14 80 00 	mov    0x8014c0(,%eax,4),%edx
  8003c8:	85 d2                	test   %edx,%edx
  8003ca:	74 18                	je     8003e4 <vprintfmt+0x158>
				printfmt(putch, putdat, "%s", p);
  8003cc:	52                   	push   %edx
  8003cd:	68 93 11 80 00       	push   $0x801193
  8003d2:	53                   	push   %ebx
  8003d3:	56                   	push   %esi
  8003d4:	e8 96 fe ff ff       	call   80026f <printfmt>
  8003d9:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003dc:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003df:	e9 da 02 00 00       	jmp    8006be <vprintfmt+0x432>
				printfmt(putch, putdat, "error %d", err);
  8003e4:	50                   	push   %eax
  8003e5:	68 8a 11 80 00       	push   $0x80118a
  8003ea:	53                   	push   %ebx
  8003eb:	56                   	push   %esi
  8003ec:	e8 7e fe ff ff       	call   80026f <printfmt>
  8003f1:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003f4:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003f7:	e9 c2 02 00 00       	jmp    8006be <vprintfmt+0x432>
			if ((p = va_arg(ap, char *)) == NULL)
  8003fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ff:	83 c0 04             	add    $0x4,%eax
  800402:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800405:	8b 45 14             	mov    0x14(%ebp),%eax
  800408:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80040a:	85 c9                	test   %ecx,%ecx
  80040c:	b8 83 11 80 00       	mov    $0x801183,%eax
  800411:	0f 45 c1             	cmovne %ecx,%eax
  800414:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800417:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80041b:	7e 06                	jle    800423 <vprintfmt+0x197>
  80041d:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800421:	75 0d                	jne    800430 <vprintfmt+0x1a4>
				for (width -= strnlen(p, precision); width > 0; width--)
  800423:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800426:	89 c7                	mov    %eax,%edi
  800428:	03 45 e0             	add    -0x20(%ebp),%eax
  80042b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80042e:	eb 53                	jmp    800483 <vprintfmt+0x1f7>
  800430:	83 ec 08             	sub    $0x8,%esp
  800433:	ff 75 d8             	pushl  -0x28(%ebp)
  800436:	50                   	push   %eax
  800437:	e8 28 04 00 00       	call   800864 <strnlen>
  80043c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80043f:	29 c1                	sub    %eax,%ecx
  800441:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  800444:	83 c4 10             	add    $0x10,%esp
  800447:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800449:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80044d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800450:	eb 0f                	jmp    800461 <vprintfmt+0x1d5>
					putch(padc, putdat);
  800452:	83 ec 08             	sub    $0x8,%esp
  800455:	53                   	push   %ebx
  800456:	ff 75 e0             	pushl  -0x20(%ebp)
  800459:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80045b:	83 ef 01             	sub    $0x1,%edi
  80045e:	83 c4 10             	add    $0x10,%esp
  800461:	85 ff                	test   %edi,%edi
  800463:	7f ed                	jg     800452 <vprintfmt+0x1c6>
  800465:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  800468:	85 c9                	test   %ecx,%ecx
  80046a:	b8 00 00 00 00       	mov    $0x0,%eax
  80046f:	0f 49 c1             	cmovns %ecx,%eax
  800472:	29 c1                	sub    %eax,%ecx
  800474:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800477:	eb aa                	jmp    800423 <vprintfmt+0x197>
					putch(ch, putdat);
  800479:	83 ec 08             	sub    $0x8,%esp
  80047c:	53                   	push   %ebx
  80047d:	52                   	push   %edx
  80047e:	ff d6                	call   *%esi
  800480:	83 c4 10             	add    $0x10,%esp
  800483:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800486:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800488:	83 c7 01             	add    $0x1,%edi
  80048b:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80048f:	0f be d0             	movsbl %al,%edx
  800492:	85 d2                	test   %edx,%edx
  800494:	74 4b                	je     8004e1 <vprintfmt+0x255>
  800496:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80049a:	78 06                	js     8004a2 <vprintfmt+0x216>
  80049c:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004a0:	78 1e                	js     8004c0 <vprintfmt+0x234>
				if (altflag && (ch < ' ' || ch > '~'))
  8004a2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004a6:	74 d1                	je     800479 <vprintfmt+0x1ed>
  8004a8:	0f be c0             	movsbl %al,%eax
  8004ab:	83 e8 20             	sub    $0x20,%eax
  8004ae:	83 f8 5e             	cmp    $0x5e,%eax
  8004b1:	76 c6                	jbe    800479 <vprintfmt+0x1ed>
					putch('?', putdat);
  8004b3:	83 ec 08             	sub    $0x8,%esp
  8004b6:	53                   	push   %ebx
  8004b7:	6a 3f                	push   $0x3f
  8004b9:	ff d6                	call   *%esi
  8004bb:	83 c4 10             	add    $0x10,%esp
  8004be:	eb c3                	jmp    800483 <vprintfmt+0x1f7>
  8004c0:	89 cf                	mov    %ecx,%edi
  8004c2:	eb 0e                	jmp    8004d2 <vprintfmt+0x246>
				putch(' ', putdat);
  8004c4:	83 ec 08             	sub    $0x8,%esp
  8004c7:	53                   	push   %ebx
  8004c8:	6a 20                	push   $0x20
  8004ca:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004cc:	83 ef 01             	sub    $0x1,%edi
  8004cf:	83 c4 10             	add    $0x10,%esp
  8004d2:	85 ff                	test   %edi,%edi
  8004d4:	7f ee                	jg     8004c4 <vprintfmt+0x238>
			if ((p = va_arg(ap, char *)) == NULL)
  8004d6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004d9:	89 45 14             	mov    %eax,0x14(%ebp)
  8004dc:	e9 dd 01 00 00       	jmp    8006be <vprintfmt+0x432>
  8004e1:	89 cf                	mov    %ecx,%edi
  8004e3:	eb ed                	jmp    8004d2 <vprintfmt+0x246>
	if (lflag >= 2)
  8004e5:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8004e9:	7f 21                	jg     80050c <vprintfmt+0x280>
	else if (lflag)
  8004eb:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8004ef:	74 6a                	je     80055b <vprintfmt+0x2cf>
		return va_arg(*ap, long);
  8004f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f4:	8b 00                	mov    (%eax),%eax
  8004f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004f9:	89 c1                	mov    %eax,%ecx
  8004fb:	c1 f9 1f             	sar    $0x1f,%ecx
  8004fe:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800501:	8b 45 14             	mov    0x14(%ebp),%eax
  800504:	8d 40 04             	lea    0x4(%eax),%eax
  800507:	89 45 14             	mov    %eax,0x14(%ebp)
  80050a:	eb 17                	jmp    800523 <vprintfmt+0x297>
		return va_arg(*ap, long long);
  80050c:	8b 45 14             	mov    0x14(%ebp),%eax
  80050f:	8b 50 04             	mov    0x4(%eax),%edx
  800512:	8b 00                	mov    (%eax),%eax
  800514:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800517:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80051a:	8b 45 14             	mov    0x14(%ebp),%eax
  80051d:	8d 40 08             	lea    0x8(%eax),%eax
  800520:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800523:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  800526:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  80052b:	85 d2                	test   %edx,%edx
  80052d:	0f 89 5c 01 00 00    	jns    80068f <vprintfmt+0x403>
				putch('-', putdat);
  800533:	83 ec 08             	sub    $0x8,%esp
  800536:	53                   	push   %ebx
  800537:	6a 2d                	push   $0x2d
  800539:	ff d6                	call   *%esi
				num = -(long long) num;
  80053b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80053e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800541:	f7 d8                	neg    %eax
  800543:	83 d2 00             	adc    $0x0,%edx
  800546:	f7 da                	neg    %edx
  800548:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80054b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80054e:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800551:	bf 0a 00 00 00       	mov    $0xa,%edi
  800556:	e9 45 01 00 00       	jmp    8006a0 <vprintfmt+0x414>
		return va_arg(*ap, int);
  80055b:	8b 45 14             	mov    0x14(%ebp),%eax
  80055e:	8b 00                	mov    (%eax),%eax
  800560:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800563:	89 c1                	mov    %eax,%ecx
  800565:	c1 f9 1f             	sar    $0x1f,%ecx
  800568:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80056b:	8b 45 14             	mov    0x14(%ebp),%eax
  80056e:	8d 40 04             	lea    0x4(%eax),%eax
  800571:	89 45 14             	mov    %eax,0x14(%ebp)
  800574:	eb ad                	jmp    800523 <vprintfmt+0x297>
	if (lflag >= 2)
  800576:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  80057a:	7f 29                	jg     8005a5 <vprintfmt+0x319>
	else if (lflag)
  80057c:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800580:	74 44                	je     8005c6 <vprintfmt+0x33a>
		return va_arg(*ap, unsigned long);
  800582:	8b 45 14             	mov    0x14(%ebp),%eax
  800585:	8b 00                	mov    (%eax),%eax
  800587:	ba 00 00 00 00       	mov    $0x0,%edx
  80058c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80058f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800592:	8b 45 14             	mov    0x14(%ebp),%eax
  800595:	8d 40 04             	lea    0x4(%eax),%eax
  800598:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80059b:	bf 0a 00 00 00       	mov    $0xa,%edi
  8005a0:	e9 ea 00 00 00       	jmp    80068f <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  8005a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a8:	8b 50 04             	mov    0x4(%eax),%edx
  8005ab:	8b 00                	mov    (%eax),%eax
  8005ad:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005b0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b6:	8d 40 08             	lea    0x8(%eax),%eax
  8005b9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005bc:	bf 0a 00 00 00       	mov    $0xa,%edi
  8005c1:	e9 c9 00 00 00       	jmp    80068f <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  8005c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c9:	8b 00                	mov    (%eax),%eax
  8005cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8005d0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005d3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d9:	8d 40 04             	lea    0x4(%eax),%eax
  8005dc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005df:	bf 0a 00 00 00       	mov    $0xa,%edi
  8005e4:	e9 a6 00 00 00       	jmp    80068f <vprintfmt+0x403>
			putch('0', putdat);
  8005e9:	83 ec 08             	sub    $0x8,%esp
  8005ec:	53                   	push   %ebx
  8005ed:	6a 30                	push   $0x30
  8005ef:	ff d6                	call   *%esi
	if (lflag >= 2)
  8005f1:	83 c4 10             	add    $0x10,%esp
  8005f4:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8005f8:	7f 26                	jg     800620 <vprintfmt+0x394>
	else if (lflag)
  8005fa:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8005fe:	74 3e                	je     80063e <vprintfmt+0x3b2>
		return va_arg(*ap, unsigned long);
  800600:	8b 45 14             	mov    0x14(%ebp),%eax
  800603:	8b 00                	mov    (%eax),%eax
  800605:	ba 00 00 00 00       	mov    $0x0,%edx
  80060a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80060d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800610:	8b 45 14             	mov    0x14(%ebp),%eax
  800613:	8d 40 04             	lea    0x4(%eax),%eax
  800616:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800619:	bf 08 00 00 00       	mov    $0x8,%edi
  80061e:	eb 6f                	jmp    80068f <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  800620:	8b 45 14             	mov    0x14(%ebp),%eax
  800623:	8b 50 04             	mov    0x4(%eax),%edx
  800626:	8b 00                	mov    (%eax),%eax
  800628:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80062b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80062e:	8b 45 14             	mov    0x14(%ebp),%eax
  800631:	8d 40 08             	lea    0x8(%eax),%eax
  800634:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800637:	bf 08 00 00 00       	mov    $0x8,%edi
  80063c:	eb 51                	jmp    80068f <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  80063e:	8b 45 14             	mov    0x14(%ebp),%eax
  800641:	8b 00                	mov    (%eax),%eax
  800643:	ba 00 00 00 00       	mov    $0x0,%edx
  800648:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80064b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80064e:	8b 45 14             	mov    0x14(%ebp),%eax
  800651:	8d 40 04             	lea    0x4(%eax),%eax
  800654:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800657:	bf 08 00 00 00       	mov    $0x8,%edi
  80065c:	eb 31                	jmp    80068f <vprintfmt+0x403>
			putch('0', putdat);
  80065e:	83 ec 08             	sub    $0x8,%esp
  800661:	53                   	push   %ebx
  800662:	6a 30                	push   $0x30
  800664:	ff d6                	call   *%esi
			putch('x', putdat);
  800666:	83 c4 08             	add    $0x8,%esp
  800669:	53                   	push   %ebx
  80066a:	6a 78                	push   $0x78
  80066c:	ff d6                	call   *%esi
			num = (unsigned long long)
  80066e:	8b 45 14             	mov    0x14(%ebp),%eax
  800671:	8b 00                	mov    (%eax),%eax
  800673:	ba 00 00 00 00       	mov    $0x0,%edx
  800678:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80067b:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80067e:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800681:	8b 45 14             	mov    0x14(%ebp),%eax
  800684:	8d 40 04             	lea    0x4(%eax),%eax
  800687:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80068a:	bf 10 00 00 00       	mov    $0x10,%edi
			if(posflag)
  80068f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800693:	74 0b                	je     8006a0 <vprintfmt+0x414>
				putch('+', putdat);
  800695:	83 ec 08             	sub    $0x8,%esp
  800698:	53                   	push   %ebx
  800699:	6a 2b                	push   $0x2b
  80069b:	ff d6                	call   *%esi
  80069d:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  8006a0:	83 ec 0c             	sub    $0xc,%esp
  8006a3:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8006a7:	50                   	push   %eax
  8006a8:	ff 75 e0             	pushl  -0x20(%ebp)
  8006ab:	57                   	push   %edi
  8006ac:	ff 75 dc             	pushl  -0x24(%ebp)
  8006af:	ff 75 d8             	pushl  -0x28(%ebp)
  8006b2:	89 da                	mov    %ebx,%edx
  8006b4:	89 f0                	mov    %esi,%eax
  8006b6:	e8 b8 fa ff ff       	call   800173 <printnum>
			break;
  8006bb:	83 c4 20             	add    $0x20,%esp
			char* cp = va_arg(ap, char *);
  8006be:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006c1:	83 c7 01             	add    $0x1,%edi
  8006c4:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006c8:	83 f8 25             	cmp    $0x25,%eax
  8006cb:	0f 84 d2 fb ff ff    	je     8002a3 <vprintfmt+0x17>
			if (ch == '\0')
  8006d1:	85 c0                	test   %eax,%eax
  8006d3:	0f 84 03 01 00 00    	je     8007dc <vprintfmt+0x550>
			putch(ch, putdat);
  8006d9:	83 ec 08             	sub    $0x8,%esp
  8006dc:	53                   	push   %ebx
  8006dd:	50                   	push   %eax
  8006de:	ff d6                	call   *%esi
  8006e0:	83 c4 10             	add    $0x10,%esp
  8006e3:	eb dc                	jmp    8006c1 <vprintfmt+0x435>
	if (lflag >= 2)
  8006e5:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8006e9:	7f 29                	jg     800714 <vprintfmt+0x488>
	else if (lflag)
  8006eb:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8006ef:	74 44                	je     800735 <vprintfmt+0x4a9>
		return va_arg(*ap, unsigned long);
  8006f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f4:	8b 00                	mov    (%eax),%eax
  8006f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8006fb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006fe:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800701:	8b 45 14             	mov    0x14(%ebp),%eax
  800704:	8d 40 04             	lea    0x4(%eax),%eax
  800707:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80070a:	bf 10 00 00 00       	mov    $0x10,%edi
  80070f:	e9 7b ff ff ff       	jmp    80068f <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  800714:	8b 45 14             	mov    0x14(%ebp),%eax
  800717:	8b 50 04             	mov    0x4(%eax),%edx
  80071a:	8b 00                	mov    (%eax),%eax
  80071c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80071f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800722:	8b 45 14             	mov    0x14(%ebp),%eax
  800725:	8d 40 08             	lea    0x8(%eax),%eax
  800728:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80072b:	bf 10 00 00 00       	mov    $0x10,%edi
  800730:	e9 5a ff ff ff       	jmp    80068f <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  800735:	8b 45 14             	mov    0x14(%ebp),%eax
  800738:	8b 00                	mov    (%eax),%eax
  80073a:	ba 00 00 00 00       	mov    $0x0,%edx
  80073f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800742:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800745:	8b 45 14             	mov    0x14(%ebp),%eax
  800748:	8d 40 04             	lea    0x4(%eax),%eax
  80074b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80074e:	bf 10 00 00 00       	mov    $0x10,%edi
  800753:	e9 37 ff ff ff       	jmp    80068f <vprintfmt+0x403>
			char* cp = va_arg(ap, char *);
  800758:	8b 45 14             	mov    0x14(%ebp),%eax
  80075b:	8d 78 04             	lea    0x4(%eax),%edi
  80075e:	8b 00                	mov    (%eax),%eax
    			if (cp == NULL) {
  800760:	85 c0                	test   %eax,%eax
  800762:	74 2c                	je     800790 <vprintfmt+0x504>
    			*cp = *(int *)putdat;
  800764:	8b 13                	mov    (%ebx),%edx
  800766:	88 10                	mov    %dl,(%eax)
			char* cp = va_arg(ap, char *);
  800768:	89 7d 14             	mov    %edi,0x14(%ebp)
    			if ((*(int *) putdat) > 127)
  80076b:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  80076e:	0f 8e 4a ff ff ff    	jle    8006be <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", overflow_error);
  800774:	68 e0 12 80 00       	push   $0x8012e0
  800779:	68 93 11 80 00       	push   $0x801193
  80077e:	53                   	push   %ebx
  80077f:	56                   	push   %esi
  800780:	e8 ea fa ff ff       	call   80026f <printfmt>
  800785:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  800788:	89 7d 14             	mov    %edi,0x14(%ebp)
  80078b:	e9 2e ff ff ff       	jmp    8006be <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", null_error);
  800790:	68 a8 12 80 00       	push   $0x8012a8
  800795:	68 93 11 80 00       	push   $0x801193
  80079a:	53                   	push   %ebx
  80079b:	56                   	push   %esi
  80079c:	e8 ce fa ff ff       	call   80026f <printfmt>
        		break;
  8007a1:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  8007a4:	89 7d 14             	mov    %edi,0x14(%ebp)
        		break;
  8007a7:	e9 12 ff ff ff       	jmp    8006be <vprintfmt+0x432>
			putch(ch, putdat);
  8007ac:	83 ec 08             	sub    $0x8,%esp
  8007af:	53                   	push   %ebx
  8007b0:	6a 25                	push   $0x25
  8007b2:	ff d6                	call   *%esi
			break;
  8007b4:	83 c4 10             	add    $0x10,%esp
  8007b7:	e9 02 ff ff ff       	jmp    8006be <vprintfmt+0x432>
			putch('%', putdat);
  8007bc:	83 ec 08             	sub    $0x8,%esp
  8007bf:	53                   	push   %ebx
  8007c0:	6a 25                	push   $0x25
  8007c2:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007c4:	83 c4 10             	add    $0x10,%esp
  8007c7:	89 f8                	mov    %edi,%eax
  8007c9:	eb 03                	jmp    8007ce <vprintfmt+0x542>
  8007cb:	83 e8 01             	sub    $0x1,%eax
  8007ce:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8007d2:	75 f7                	jne    8007cb <vprintfmt+0x53f>
  8007d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007d7:	e9 e2 fe ff ff       	jmp    8006be <vprintfmt+0x432>
}
  8007dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007df:	5b                   	pop    %ebx
  8007e0:	5e                   	pop    %esi
  8007e1:	5f                   	pop    %edi
  8007e2:	5d                   	pop    %ebp
  8007e3:	c3                   	ret    

008007e4 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007e4:	55                   	push   %ebp
  8007e5:	89 e5                	mov    %esp,%ebp
  8007e7:	83 ec 18             	sub    $0x18,%esp
  8007ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ed:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007f3:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007f7:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800801:	85 c0                	test   %eax,%eax
  800803:	74 26                	je     80082b <vsnprintf+0x47>
  800805:	85 d2                	test   %edx,%edx
  800807:	7e 22                	jle    80082b <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800809:	ff 75 14             	pushl  0x14(%ebp)
  80080c:	ff 75 10             	pushl  0x10(%ebp)
  80080f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800812:	50                   	push   %eax
  800813:	68 52 02 80 00       	push   $0x800252
  800818:	e8 6f fa ff ff       	call   80028c <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80081d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800820:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800823:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800826:	83 c4 10             	add    $0x10,%esp
}
  800829:	c9                   	leave  
  80082a:	c3                   	ret    
		return -E_INVAL;
  80082b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800830:	eb f7                	jmp    800829 <vsnprintf+0x45>

00800832 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800832:	55                   	push   %ebp
  800833:	89 e5                	mov    %esp,%ebp
  800835:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800838:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80083b:	50                   	push   %eax
  80083c:	ff 75 10             	pushl  0x10(%ebp)
  80083f:	ff 75 0c             	pushl  0xc(%ebp)
  800842:	ff 75 08             	pushl  0x8(%ebp)
  800845:	e8 9a ff ff ff       	call   8007e4 <vsnprintf>
	va_end(ap);

	return rc;
}
  80084a:	c9                   	leave  
  80084b:	c3                   	ret    

0080084c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80084c:	55                   	push   %ebp
  80084d:	89 e5                	mov    %esp,%ebp
  80084f:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800852:	b8 00 00 00 00       	mov    $0x0,%eax
  800857:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80085b:	74 05                	je     800862 <strlen+0x16>
		n++;
  80085d:	83 c0 01             	add    $0x1,%eax
  800860:	eb f5                	jmp    800857 <strlen+0xb>
	return n;
}
  800862:	5d                   	pop    %ebp
  800863:	c3                   	ret    

00800864 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800864:	55                   	push   %ebp
  800865:	89 e5                	mov    %esp,%ebp
  800867:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80086a:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80086d:	ba 00 00 00 00       	mov    $0x0,%edx
  800872:	39 c2                	cmp    %eax,%edx
  800874:	74 0d                	je     800883 <strnlen+0x1f>
  800876:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  80087a:	74 05                	je     800881 <strnlen+0x1d>
		n++;
  80087c:	83 c2 01             	add    $0x1,%edx
  80087f:	eb f1                	jmp    800872 <strnlen+0xe>
  800881:	89 d0                	mov    %edx,%eax
	return n;
}
  800883:	5d                   	pop    %ebp
  800884:	c3                   	ret    

00800885 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800885:	55                   	push   %ebp
  800886:	89 e5                	mov    %esp,%ebp
  800888:	53                   	push   %ebx
  800889:	8b 45 08             	mov    0x8(%ebp),%eax
  80088c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80088f:	ba 00 00 00 00       	mov    $0x0,%edx
  800894:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800898:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  80089b:	83 c2 01             	add    $0x1,%edx
  80089e:	84 c9                	test   %cl,%cl
  8008a0:	75 f2                	jne    800894 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8008a2:	5b                   	pop    %ebx
  8008a3:	5d                   	pop    %ebp
  8008a4:	c3                   	ret    

008008a5 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008a5:	55                   	push   %ebp
  8008a6:	89 e5                	mov    %esp,%ebp
  8008a8:	53                   	push   %ebx
  8008a9:	83 ec 10             	sub    $0x10,%esp
  8008ac:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008af:	53                   	push   %ebx
  8008b0:	e8 97 ff ff ff       	call   80084c <strlen>
  8008b5:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8008b8:	ff 75 0c             	pushl  0xc(%ebp)
  8008bb:	01 d8                	add    %ebx,%eax
  8008bd:	50                   	push   %eax
  8008be:	e8 c2 ff ff ff       	call   800885 <strcpy>
	return dst;
}
  8008c3:	89 d8                	mov    %ebx,%eax
  8008c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008c8:	c9                   	leave  
  8008c9:	c3                   	ret    

008008ca <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008ca:	55                   	push   %ebp
  8008cb:	89 e5                	mov    %esp,%ebp
  8008cd:	56                   	push   %esi
  8008ce:	53                   	push   %ebx
  8008cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008d5:	89 c6                	mov    %eax,%esi
  8008d7:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008da:	89 c2                	mov    %eax,%edx
  8008dc:	39 f2                	cmp    %esi,%edx
  8008de:	74 11                	je     8008f1 <strncpy+0x27>
		*dst++ = *src;
  8008e0:	83 c2 01             	add    $0x1,%edx
  8008e3:	0f b6 19             	movzbl (%ecx),%ebx
  8008e6:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008e9:	80 fb 01             	cmp    $0x1,%bl
  8008ec:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8008ef:	eb eb                	jmp    8008dc <strncpy+0x12>
	}
	return ret;
}
  8008f1:	5b                   	pop    %ebx
  8008f2:	5e                   	pop    %esi
  8008f3:	5d                   	pop    %ebp
  8008f4:	c3                   	ret    

008008f5 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008f5:	55                   	push   %ebp
  8008f6:	89 e5                	mov    %esp,%ebp
  8008f8:	56                   	push   %esi
  8008f9:	53                   	push   %ebx
  8008fa:	8b 75 08             	mov    0x8(%ebp),%esi
  8008fd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800900:	8b 55 10             	mov    0x10(%ebp),%edx
  800903:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800905:	85 d2                	test   %edx,%edx
  800907:	74 21                	je     80092a <strlcpy+0x35>
  800909:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80090d:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80090f:	39 c2                	cmp    %eax,%edx
  800911:	74 14                	je     800927 <strlcpy+0x32>
  800913:	0f b6 19             	movzbl (%ecx),%ebx
  800916:	84 db                	test   %bl,%bl
  800918:	74 0b                	je     800925 <strlcpy+0x30>
			*dst++ = *src++;
  80091a:	83 c1 01             	add    $0x1,%ecx
  80091d:	83 c2 01             	add    $0x1,%edx
  800920:	88 5a ff             	mov    %bl,-0x1(%edx)
  800923:	eb ea                	jmp    80090f <strlcpy+0x1a>
  800925:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800927:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80092a:	29 f0                	sub    %esi,%eax
}
  80092c:	5b                   	pop    %ebx
  80092d:	5e                   	pop    %esi
  80092e:	5d                   	pop    %ebp
  80092f:	c3                   	ret    

00800930 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800930:	55                   	push   %ebp
  800931:	89 e5                	mov    %esp,%ebp
  800933:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800936:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800939:	0f b6 01             	movzbl (%ecx),%eax
  80093c:	84 c0                	test   %al,%al
  80093e:	74 0c                	je     80094c <strcmp+0x1c>
  800940:	3a 02                	cmp    (%edx),%al
  800942:	75 08                	jne    80094c <strcmp+0x1c>
		p++, q++;
  800944:	83 c1 01             	add    $0x1,%ecx
  800947:	83 c2 01             	add    $0x1,%edx
  80094a:	eb ed                	jmp    800939 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80094c:	0f b6 c0             	movzbl %al,%eax
  80094f:	0f b6 12             	movzbl (%edx),%edx
  800952:	29 d0                	sub    %edx,%eax
}
  800954:	5d                   	pop    %ebp
  800955:	c3                   	ret    

00800956 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800956:	55                   	push   %ebp
  800957:	89 e5                	mov    %esp,%ebp
  800959:	53                   	push   %ebx
  80095a:	8b 45 08             	mov    0x8(%ebp),%eax
  80095d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800960:	89 c3                	mov    %eax,%ebx
  800962:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800965:	eb 06                	jmp    80096d <strncmp+0x17>
		n--, p++, q++;
  800967:	83 c0 01             	add    $0x1,%eax
  80096a:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80096d:	39 d8                	cmp    %ebx,%eax
  80096f:	74 16                	je     800987 <strncmp+0x31>
  800971:	0f b6 08             	movzbl (%eax),%ecx
  800974:	84 c9                	test   %cl,%cl
  800976:	74 04                	je     80097c <strncmp+0x26>
  800978:	3a 0a                	cmp    (%edx),%cl
  80097a:	74 eb                	je     800967 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80097c:	0f b6 00             	movzbl (%eax),%eax
  80097f:	0f b6 12             	movzbl (%edx),%edx
  800982:	29 d0                	sub    %edx,%eax
}
  800984:	5b                   	pop    %ebx
  800985:	5d                   	pop    %ebp
  800986:	c3                   	ret    
		return 0;
  800987:	b8 00 00 00 00       	mov    $0x0,%eax
  80098c:	eb f6                	jmp    800984 <strncmp+0x2e>

0080098e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80098e:	55                   	push   %ebp
  80098f:	89 e5                	mov    %esp,%ebp
  800991:	8b 45 08             	mov    0x8(%ebp),%eax
  800994:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800998:	0f b6 10             	movzbl (%eax),%edx
  80099b:	84 d2                	test   %dl,%dl
  80099d:	74 09                	je     8009a8 <strchr+0x1a>
		if (*s == c)
  80099f:	38 ca                	cmp    %cl,%dl
  8009a1:	74 0a                	je     8009ad <strchr+0x1f>
	for (; *s; s++)
  8009a3:	83 c0 01             	add    $0x1,%eax
  8009a6:	eb f0                	jmp    800998 <strchr+0xa>
			return (char *) s;
	return 0;
  8009a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009ad:	5d                   	pop    %ebp
  8009ae:	c3                   	ret    

008009af <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009af:	55                   	push   %ebp
  8009b0:	89 e5                	mov    %esp,%ebp
  8009b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b5:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009b9:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009bc:	38 ca                	cmp    %cl,%dl
  8009be:	74 09                	je     8009c9 <strfind+0x1a>
  8009c0:	84 d2                	test   %dl,%dl
  8009c2:	74 05                	je     8009c9 <strfind+0x1a>
	for (; *s; s++)
  8009c4:	83 c0 01             	add    $0x1,%eax
  8009c7:	eb f0                	jmp    8009b9 <strfind+0xa>
			break;
	return (char *) s;
}
  8009c9:	5d                   	pop    %ebp
  8009ca:	c3                   	ret    

008009cb <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009cb:	55                   	push   %ebp
  8009cc:	89 e5                	mov    %esp,%ebp
  8009ce:	57                   	push   %edi
  8009cf:	56                   	push   %esi
  8009d0:	53                   	push   %ebx
  8009d1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009d4:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009d7:	85 c9                	test   %ecx,%ecx
  8009d9:	74 31                	je     800a0c <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009db:	89 f8                	mov    %edi,%eax
  8009dd:	09 c8                	or     %ecx,%eax
  8009df:	a8 03                	test   $0x3,%al
  8009e1:	75 23                	jne    800a06 <memset+0x3b>
		c &= 0xFF;
  8009e3:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009e7:	89 d3                	mov    %edx,%ebx
  8009e9:	c1 e3 08             	shl    $0x8,%ebx
  8009ec:	89 d0                	mov    %edx,%eax
  8009ee:	c1 e0 18             	shl    $0x18,%eax
  8009f1:	89 d6                	mov    %edx,%esi
  8009f3:	c1 e6 10             	shl    $0x10,%esi
  8009f6:	09 f0                	or     %esi,%eax
  8009f8:	09 c2                	or     %eax,%edx
  8009fa:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8009fc:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009ff:	89 d0                	mov    %edx,%eax
  800a01:	fc                   	cld    
  800a02:	f3 ab                	rep stos %eax,%es:(%edi)
  800a04:	eb 06                	jmp    800a0c <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a06:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a09:	fc                   	cld    
  800a0a:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a0c:	89 f8                	mov    %edi,%eax
  800a0e:	5b                   	pop    %ebx
  800a0f:	5e                   	pop    %esi
  800a10:	5f                   	pop    %edi
  800a11:	5d                   	pop    %ebp
  800a12:	c3                   	ret    

00800a13 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a13:	55                   	push   %ebp
  800a14:	89 e5                	mov    %esp,%ebp
  800a16:	57                   	push   %edi
  800a17:	56                   	push   %esi
  800a18:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a1e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a21:	39 c6                	cmp    %eax,%esi
  800a23:	73 32                	jae    800a57 <memmove+0x44>
  800a25:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a28:	39 c2                	cmp    %eax,%edx
  800a2a:	76 2b                	jbe    800a57 <memmove+0x44>
		s += n;
		d += n;
  800a2c:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a2f:	89 fe                	mov    %edi,%esi
  800a31:	09 ce                	or     %ecx,%esi
  800a33:	09 d6                	or     %edx,%esi
  800a35:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a3b:	75 0e                	jne    800a4b <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a3d:	83 ef 04             	sub    $0x4,%edi
  800a40:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a43:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a46:	fd                   	std    
  800a47:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a49:	eb 09                	jmp    800a54 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a4b:	83 ef 01             	sub    $0x1,%edi
  800a4e:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a51:	fd                   	std    
  800a52:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a54:	fc                   	cld    
  800a55:	eb 1a                	jmp    800a71 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a57:	89 c2                	mov    %eax,%edx
  800a59:	09 ca                	or     %ecx,%edx
  800a5b:	09 f2                	or     %esi,%edx
  800a5d:	f6 c2 03             	test   $0x3,%dl
  800a60:	75 0a                	jne    800a6c <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a62:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a65:	89 c7                	mov    %eax,%edi
  800a67:	fc                   	cld    
  800a68:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a6a:	eb 05                	jmp    800a71 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800a6c:	89 c7                	mov    %eax,%edi
  800a6e:	fc                   	cld    
  800a6f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a71:	5e                   	pop    %esi
  800a72:	5f                   	pop    %edi
  800a73:	5d                   	pop    %ebp
  800a74:	c3                   	ret    

00800a75 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a75:	55                   	push   %ebp
  800a76:	89 e5                	mov    %esp,%ebp
  800a78:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a7b:	ff 75 10             	pushl  0x10(%ebp)
  800a7e:	ff 75 0c             	pushl  0xc(%ebp)
  800a81:	ff 75 08             	pushl  0x8(%ebp)
  800a84:	e8 8a ff ff ff       	call   800a13 <memmove>
}
  800a89:	c9                   	leave  
  800a8a:	c3                   	ret    

00800a8b <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a8b:	55                   	push   %ebp
  800a8c:	89 e5                	mov    %esp,%ebp
  800a8e:	56                   	push   %esi
  800a8f:	53                   	push   %ebx
  800a90:	8b 45 08             	mov    0x8(%ebp),%eax
  800a93:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a96:	89 c6                	mov    %eax,%esi
  800a98:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a9b:	39 f0                	cmp    %esi,%eax
  800a9d:	74 1c                	je     800abb <memcmp+0x30>
		if (*s1 != *s2)
  800a9f:	0f b6 08             	movzbl (%eax),%ecx
  800aa2:	0f b6 1a             	movzbl (%edx),%ebx
  800aa5:	38 d9                	cmp    %bl,%cl
  800aa7:	75 08                	jne    800ab1 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800aa9:	83 c0 01             	add    $0x1,%eax
  800aac:	83 c2 01             	add    $0x1,%edx
  800aaf:	eb ea                	jmp    800a9b <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800ab1:	0f b6 c1             	movzbl %cl,%eax
  800ab4:	0f b6 db             	movzbl %bl,%ebx
  800ab7:	29 d8                	sub    %ebx,%eax
  800ab9:	eb 05                	jmp    800ac0 <memcmp+0x35>
	}

	return 0;
  800abb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ac0:	5b                   	pop    %ebx
  800ac1:	5e                   	pop    %esi
  800ac2:	5d                   	pop    %ebp
  800ac3:	c3                   	ret    

00800ac4 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ac4:	55                   	push   %ebp
  800ac5:	89 e5                	mov    %esp,%ebp
  800ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800acd:	89 c2                	mov    %eax,%edx
  800acf:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ad2:	39 d0                	cmp    %edx,%eax
  800ad4:	73 09                	jae    800adf <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ad6:	38 08                	cmp    %cl,(%eax)
  800ad8:	74 05                	je     800adf <memfind+0x1b>
	for (; s < ends; s++)
  800ada:	83 c0 01             	add    $0x1,%eax
  800add:	eb f3                	jmp    800ad2 <memfind+0xe>
			break;
	return (void *) s;
}
  800adf:	5d                   	pop    %ebp
  800ae0:	c3                   	ret    

00800ae1 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ae1:	55                   	push   %ebp
  800ae2:	89 e5                	mov    %esp,%ebp
  800ae4:	57                   	push   %edi
  800ae5:	56                   	push   %esi
  800ae6:	53                   	push   %ebx
  800ae7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800aea:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800aed:	eb 03                	jmp    800af2 <strtol+0x11>
		s++;
  800aef:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800af2:	0f b6 01             	movzbl (%ecx),%eax
  800af5:	3c 20                	cmp    $0x20,%al
  800af7:	74 f6                	je     800aef <strtol+0xe>
  800af9:	3c 09                	cmp    $0x9,%al
  800afb:	74 f2                	je     800aef <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800afd:	3c 2b                	cmp    $0x2b,%al
  800aff:	74 2a                	je     800b2b <strtol+0x4a>
	int neg = 0;
  800b01:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b06:	3c 2d                	cmp    $0x2d,%al
  800b08:	74 2b                	je     800b35 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b0a:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b10:	75 0f                	jne    800b21 <strtol+0x40>
  800b12:	80 39 30             	cmpb   $0x30,(%ecx)
  800b15:	74 28                	je     800b3f <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b17:	85 db                	test   %ebx,%ebx
  800b19:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b1e:	0f 44 d8             	cmove  %eax,%ebx
  800b21:	b8 00 00 00 00       	mov    $0x0,%eax
  800b26:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b29:	eb 50                	jmp    800b7b <strtol+0x9a>
		s++;
  800b2b:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b2e:	bf 00 00 00 00       	mov    $0x0,%edi
  800b33:	eb d5                	jmp    800b0a <strtol+0x29>
		s++, neg = 1;
  800b35:	83 c1 01             	add    $0x1,%ecx
  800b38:	bf 01 00 00 00       	mov    $0x1,%edi
  800b3d:	eb cb                	jmp    800b0a <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b3f:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b43:	74 0e                	je     800b53 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800b45:	85 db                	test   %ebx,%ebx
  800b47:	75 d8                	jne    800b21 <strtol+0x40>
		s++, base = 8;
  800b49:	83 c1 01             	add    $0x1,%ecx
  800b4c:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b51:	eb ce                	jmp    800b21 <strtol+0x40>
		s += 2, base = 16;
  800b53:	83 c1 02             	add    $0x2,%ecx
  800b56:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b5b:	eb c4                	jmp    800b21 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b5d:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b60:	89 f3                	mov    %esi,%ebx
  800b62:	80 fb 19             	cmp    $0x19,%bl
  800b65:	77 29                	ja     800b90 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800b67:	0f be d2             	movsbl %dl,%edx
  800b6a:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b6d:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b70:	7d 30                	jge    800ba2 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800b72:	83 c1 01             	add    $0x1,%ecx
  800b75:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b79:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b7b:	0f b6 11             	movzbl (%ecx),%edx
  800b7e:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b81:	89 f3                	mov    %esi,%ebx
  800b83:	80 fb 09             	cmp    $0x9,%bl
  800b86:	77 d5                	ja     800b5d <strtol+0x7c>
			dig = *s - '0';
  800b88:	0f be d2             	movsbl %dl,%edx
  800b8b:	83 ea 30             	sub    $0x30,%edx
  800b8e:	eb dd                	jmp    800b6d <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800b90:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b93:	89 f3                	mov    %esi,%ebx
  800b95:	80 fb 19             	cmp    $0x19,%bl
  800b98:	77 08                	ja     800ba2 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800b9a:	0f be d2             	movsbl %dl,%edx
  800b9d:	83 ea 37             	sub    $0x37,%edx
  800ba0:	eb cb                	jmp    800b6d <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800ba2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ba6:	74 05                	je     800bad <strtol+0xcc>
		*endptr = (char *) s;
  800ba8:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bab:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800bad:	89 c2                	mov    %eax,%edx
  800baf:	f7 da                	neg    %edx
  800bb1:	85 ff                	test   %edi,%edi
  800bb3:	0f 45 c2             	cmovne %edx,%eax
}
  800bb6:	5b                   	pop    %ebx
  800bb7:	5e                   	pop    %esi
  800bb8:	5f                   	pop    %edi
  800bb9:	5d                   	pop    %ebp
  800bba:	c3                   	ret    

00800bbb <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bbb:	55                   	push   %ebp
  800bbc:	89 e5                	mov    %esp,%ebp
  800bbe:	57                   	push   %edi
  800bbf:	56                   	push   %esi
  800bc0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bc1:	b8 00 00 00 00       	mov    $0x0,%eax
  800bc6:	8b 55 08             	mov    0x8(%ebp),%edx
  800bc9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bcc:	89 c3                	mov    %eax,%ebx
  800bce:	89 c7                	mov    %eax,%edi
  800bd0:	89 c6                	mov    %eax,%esi
  800bd2:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bd4:	5b                   	pop    %ebx
  800bd5:	5e                   	pop    %esi
  800bd6:	5f                   	pop    %edi
  800bd7:	5d                   	pop    %ebp
  800bd8:	c3                   	ret    

00800bd9 <sys_cgetc>:

int
sys_cgetc(void)
{
  800bd9:	55                   	push   %ebp
  800bda:	89 e5                	mov    %esp,%ebp
  800bdc:	57                   	push   %edi
  800bdd:	56                   	push   %esi
  800bde:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bdf:	ba 00 00 00 00       	mov    $0x0,%edx
  800be4:	b8 01 00 00 00       	mov    $0x1,%eax
  800be9:	89 d1                	mov    %edx,%ecx
  800beb:	89 d3                	mov    %edx,%ebx
  800bed:	89 d7                	mov    %edx,%edi
  800bef:	89 d6                	mov    %edx,%esi
  800bf1:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bf3:	5b                   	pop    %ebx
  800bf4:	5e                   	pop    %esi
  800bf5:	5f                   	pop    %edi
  800bf6:	5d                   	pop    %ebp
  800bf7:	c3                   	ret    

00800bf8 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bf8:	55                   	push   %ebp
  800bf9:	89 e5                	mov    %esp,%ebp
  800bfb:	57                   	push   %edi
  800bfc:	56                   	push   %esi
  800bfd:	53                   	push   %ebx
  800bfe:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c01:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c06:	8b 55 08             	mov    0x8(%ebp),%edx
  800c09:	b8 03 00 00 00       	mov    $0x3,%eax
  800c0e:	89 cb                	mov    %ecx,%ebx
  800c10:	89 cf                	mov    %ecx,%edi
  800c12:	89 ce                	mov    %ecx,%esi
  800c14:	cd 30                	int    $0x30
	if (check && ret > 0)
  800c16:	85 c0                	test   %eax,%eax
  800c18:	7f 08                	jg     800c22 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c1a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c1d:	5b                   	pop    %ebx
  800c1e:	5e                   	pop    %esi
  800c1f:	5f                   	pop    %edi
  800c20:	5d                   	pop    %ebp
  800c21:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c22:	83 ec 0c             	sub    $0xc,%esp
  800c25:	50                   	push   %eax
  800c26:	6a 03                	push   $0x3
  800c28:	68 00 15 80 00       	push   $0x801500
  800c2d:	6a 4c                	push   $0x4c
  800c2f:	68 1d 15 80 00       	push   $0x80151d
  800c34:	e8 70 02 00 00       	call   800ea9 <_panic>

00800c39 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c39:	55                   	push   %ebp
  800c3a:	89 e5                	mov    %esp,%ebp
  800c3c:	57                   	push   %edi
  800c3d:	56                   	push   %esi
  800c3e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c3f:	ba 00 00 00 00       	mov    $0x0,%edx
  800c44:	b8 02 00 00 00       	mov    $0x2,%eax
  800c49:	89 d1                	mov    %edx,%ecx
  800c4b:	89 d3                	mov    %edx,%ebx
  800c4d:	89 d7                	mov    %edx,%edi
  800c4f:	89 d6                	mov    %edx,%esi
  800c51:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c53:	5b                   	pop    %ebx
  800c54:	5e                   	pop    %esi
  800c55:	5f                   	pop    %edi
  800c56:	5d                   	pop    %ebp
  800c57:	c3                   	ret    

00800c58 <sys_yield>:

void
sys_yield(void)
{
  800c58:	55                   	push   %ebp
  800c59:	89 e5                	mov    %esp,%ebp
  800c5b:	57                   	push   %edi
  800c5c:	56                   	push   %esi
  800c5d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c5e:	ba 00 00 00 00       	mov    $0x0,%edx
  800c63:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c68:	89 d1                	mov    %edx,%ecx
  800c6a:	89 d3                	mov    %edx,%ebx
  800c6c:	89 d7                	mov    %edx,%edi
  800c6e:	89 d6                	mov    %edx,%esi
  800c70:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c72:	5b                   	pop    %ebx
  800c73:	5e                   	pop    %esi
  800c74:	5f                   	pop    %edi
  800c75:	5d                   	pop    %ebp
  800c76:	c3                   	ret    

00800c77 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c77:	55                   	push   %ebp
  800c78:	89 e5                	mov    %esp,%ebp
  800c7a:	57                   	push   %edi
  800c7b:	56                   	push   %esi
  800c7c:	53                   	push   %ebx
  800c7d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c80:	be 00 00 00 00       	mov    $0x0,%esi
  800c85:	8b 55 08             	mov    0x8(%ebp),%edx
  800c88:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c8b:	b8 04 00 00 00       	mov    $0x4,%eax
  800c90:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c93:	89 f7                	mov    %esi,%edi
  800c95:	cd 30                	int    $0x30
	if (check && ret > 0)
  800c97:	85 c0                	test   %eax,%eax
  800c99:	7f 08                	jg     800ca3 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c9e:	5b                   	pop    %ebx
  800c9f:	5e                   	pop    %esi
  800ca0:	5f                   	pop    %edi
  800ca1:	5d                   	pop    %ebp
  800ca2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ca3:	83 ec 0c             	sub    $0xc,%esp
  800ca6:	50                   	push   %eax
  800ca7:	6a 04                	push   $0x4
  800ca9:	68 00 15 80 00       	push   $0x801500
  800cae:	6a 4c                	push   $0x4c
  800cb0:	68 1d 15 80 00       	push   $0x80151d
  800cb5:	e8 ef 01 00 00       	call   800ea9 <_panic>

00800cba <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cba:	55                   	push   %ebp
  800cbb:	89 e5                	mov    %esp,%ebp
  800cbd:	57                   	push   %edi
  800cbe:	56                   	push   %esi
  800cbf:	53                   	push   %ebx
  800cc0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cc3:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cc9:	b8 05 00 00 00       	mov    $0x5,%eax
  800cce:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cd1:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cd4:	8b 75 18             	mov    0x18(%ebp),%esi
  800cd7:	cd 30                	int    $0x30
	if (check && ret > 0)
  800cd9:	85 c0                	test   %eax,%eax
  800cdb:	7f 08                	jg     800ce5 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800cdd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ce0:	5b                   	pop    %ebx
  800ce1:	5e                   	pop    %esi
  800ce2:	5f                   	pop    %edi
  800ce3:	5d                   	pop    %ebp
  800ce4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ce5:	83 ec 0c             	sub    $0xc,%esp
  800ce8:	50                   	push   %eax
  800ce9:	6a 05                	push   $0x5
  800ceb:	68 00 15 80 00       	push   $0x801500
  800cf0:	6a 4c                	push   $0x4c
  800cf2:	68 1d 15 80 00       	push   $0x80151d
  800cf7:	e8 ad 01 00 00       	call   800ea9 <_panic>

00800cfc <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800cfc:	55                   	push   %ebp
  800cfd:	89 e5                	mov    %esp,%ebp
  800cff:	57                   	push   %edi
  800d00:	56                   	push   %esi
  800d01:	53                   	push   %ebx
  800d02:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d05:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d0a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d0d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d10:	b8 06 00 00 00       	mov    $0x6,%eax
  800d15:	89 df                	mov    %ebx,%edi
  800d17:	89 de                	mov    %ebx,%esi
  800d19:	cd 30                	int    $0x30
	if (check && ret > 0)
  800d1b:	85 c0                	test   %eax,%eax
  800d1d:	7f 08                	jg     800d27 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d1f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d22:	5b                   	pop    %ebx
  800d23:	5e                   	pop    %esi
  800d24:	5f                   	pop    %edi
  800d25:	5d                   	pop    %ebp
  800d26:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d27:	83 ec 0c             	sub    $0xc,%esp
  800d2a:	50                   	push   %eax
  800d2b:	6a 06                	push   $0x6
  800d2d:	68 00 15 80 00       	push   $0x801500
  800d32:	6a 4c                	push   $0x4c
  800d34:	68 1d 15 80 00       	push   $0x80151d
  800d39:	e8 6b 01 00 00       	call   800ea9 <_panic>

00800d3e <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d3e:	55                   	push   %ebp
  800d3f:	89 e5                	mov    %esp,%ebp
  800d41:	57                   	push   %edi
  800d42:	56                   	push   %esi
  800d43:	53                   	push   %ebx
  800d44:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d47:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d4c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d52:	b8 08 00 00 00       	mov    $0x8,%eax
  800d57:	89 df                	mov    %ebx,%edi
  800d59:	89 de                	mov    %ebx,%esi
  800d5b:	cd 30                	int    $0x30
	if (check && ret > 0)
  800d5d:	85 c0                	test   %eax,%eax
  800d5f:	7f 08                	jg     800d69 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d61:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d64:	5b                   	pop    %ebx
  800d65:	5e                   	pop    %esi
  800d66:	5f                   	pop    %edi
  800d67:	5d                   	pop    %ebp
  800d68:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d69:	83 ec 0c             	sub    $0xc,%esp
  800d6c:	50                   	push   %eax
  800d6d:	6a 08                	push   $0x8
  800d6f:	68 00 15 80 00       	push   $0x801500
  800d74:	6a 4c                	push   $0x4c
  800d76:	68 1d 15 80 00       	push   $0x80151d
  800d7b:	e8 29 01 00 00       	call   800ea9 <_panic>

00800d80 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d80:	55                   	push   %ebp
  800d81:	89 e5                	mov    %esp,%ebp
  800d83:	57                   	push   %edi
  800d84:	56                   	push   %esi
  800d85:	53                   	push   %ebx
  800d86:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d89:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d8e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d91:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d94:	b8 09 00 00 00       	mov    $0x9,%eax
  800d99:	89 df                	mov    %ebx,%edi
  800d9b:	89 de                	mov    %ebx,%esi
  800d9d:	cd 30                	int    $0x30
	if (check && ret > 0)
  800d9f:	85 c0                	test   %eax,%eax
  800da1:	7f 08                	jg     800dab <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800da3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800da6:	5b                   	pop    %ebx
  800da7:	5e                   	pop    %esi
  800da8:	5f                   	pop    %edi
  800da9:	5d                   	pop    %ebp
  800daa:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dab:	83 ec 0c             	sub    $0xc,%esp
  800dae:	50                   	push   %eax
  800daf:	6a 09                	push   $0x9
  800db1:	68 00 15 80 00       	push   $0x801500
  800db6:	6a 4c                	push   $0x4c
  800db8:	68 1d 15 80 00       	push   $0x80151d
  800dbd:	e8 e7 00 00 00       	call   800ea9 <_panic>

00800dc2 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800dc2:	55                   	push   %ebp
  800dc3:	89 e5                	mov    %esp,%ebp
  800dc5:	57                   	push   %edi
  800dc6:	56                   	push   %esi
  800dc7:	53                   	push   %ebx
  800dc8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dcb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dd0:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd6:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ddb:	89 df                	mov    %ebx,%edi
  800ddd:	89 de                	mov    %ebx,%esi
  800ddf:	cd 30                	int    $0x30
	if (check && ret > 0)
  800de1:	85 c0                	test   %eax,%eax
  800de3:	7f 08                	jg     800ded <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800de5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800de8:	5b                   	pop    %ebx
  800de9:	5e                   	pop    %esi
  800dea:	5f                   	pop    %edi
  800deb:	5d                   	pop    %ebp
  800dec:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ded:	83 ec 0c             	sub    $0xc,%esp
  800df0:	50                   	push   %eax
  800df1:	6a 0a                	push   $0xa
  800df3:	68 00 15 80 00       	push   $0x801500
  800df8:	6a 4c                	push   $0x4c
  800dfa:	68 1d 15 80 00       	push   $0x80151d
  800dff:	e8 a5 00 00 00       	call   800ea9 <_panic>

00800e04 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e04:	55                   	push   %ebp
  800e05:	89 e5                	mov    %esp,%ebp
  800e07:	57                   	push   %edi
  800e08:	56                   	push   %esi
  800e09:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e0a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e10:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e15:	be 00 00 00 00       	mov    $0x0,%esi
  800e1a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e1d:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e20:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e22:	5b                   	pop    %ebx
  800e23:	5e                   	pop    %esi
  800e24:	5f                   	pop    %edi
  800e25:	5d                   	pop    %ebp
  800e26:	c3                   	ret    

00800e27 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e27:	55                   	push   %ebp
  800e28:	89 e5                	mov    %esp,%ebp
  800e2a:	57                   	push   %edi
  800e2b:	56                   	push   %esi
  800e2c:	53                   	push   %ebx
  800e2d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e30:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e35:	8b 55 08             	mov    0x8(%ebp),%edx
  800e38:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e3d:	89 cb                	mov    %ecx,%ebx
  800e3f:	89 cf                	mov    %ecx,%edi
  800e41:	89 ce                	mov    %ecx,%esi
  800e43:	cd 30                	int    $0x30
	if (check && ret > 0)
  800e45:	85 c0                	test   %eax,%eax
  800e47:	7f 08                	jg     800e51 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e49:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e4c:	5b                   	pop    %ebx
  800e4d:	5e                   	pop    %esi
  800e4e:	5f                   	pop    %edi
  800e4f:	5d                   	pop    %ebp
  800e50:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e51:	83 ec 0c             	sub    $0xc,%esp
  800e54:	50                   	push   %eax
  800e55:	6a 0d                	push   $0xd
  800e57:	68 00 15 80 00       	push   $0x801500
  800e5c:	6a 4c                	push   $0x4c
  800e5e:	68 1d 15 80 00       	push   $0x80151d
  800e63:	e8 41 00 00 00       	call   800ea9 <_panic>

00800e68 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800e68:	55                   	push   %ebp
  800e69:	89 e5                	mov    %esp,%ebp
  800e6b:	57                   	push   %edi
  800e6c:	56                   	push   %esi
  800e6d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e6e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e73:	8b 55 08             	mov    0x8(%ebp),%edx
  800e76:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e79:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e7e:	89 df                	mov    %ebx,%edi
  800e80:	89 de                	mov    %ebx,%esi
  800e82:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800e84:	5b                   	pop    %ebx
  800e85:	5e                   	pop    %esi
  800e86:	5f                   	pop    %edi
  800e87:	5d                   	pop    %ebp
  800e88:	c3                   	ret    

00800e89 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800e89:	55                   	push   %ebp
  800e8a:	89 e5                	mov    %esp,%ebp
  800e8c:	57                   	push   %edi
  800e8d:	56                   	push   %esi
  800e8e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e8f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e94:	8b 55 08             	mov    0x8(%ebp),%edx
  800e97:	b8 0f 00 00 00       	mov    $0xf,%eax
  800e9c:	89 cb                	mov    %ecx,%ebx
  800e9e:	89 cf                	mov    %ecx,%edi
  800ea0:	89 ce                	mov    %ecx,%esi
  800ea2:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800ea4:	5b                   	pop    %ebx
  800ea5:	5e                   	pop    %esi
  800ea6:	5f                   	pop    %edi
  800ea7:	5d                   	pop    %ebp
  800ea8:	c3                   	ret    

00800ea9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800ea9:	55                   	push   %ebp
  800eaa:	89 e5                	mov    %esp,%ebp
  800eac:	56                   	push   %esi
  800ead:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800eae:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800eb1:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800eb7:	e8 7d fd ff ff       	call   800c39 <sys_getenvid>
  800ebc:	83 ec 0c             	sub    $0xc,%esp
  800ebf:	ff 75 0c             	pushl  0xc(%ebp)
  800ec2:	ff 75 08             	pushl  0x8(%ebp)
  800ec5:	56                   	push   %esi
  800ec6:	50                   	push   %eax
  800ec7:	68 2c 15 80 00       	push   $0x80152c
  800ecc:	e8 8e f2 ff ff       	call   80015f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800ed1:	83 c4 18             	add    $0x18,%esp
  800ed4:	53                   	push   %ebx
  800ed5:	ff 75 10             	pushl  0x10(%ebp)
  800ed8:	e8 31 f2 ff ff       	call   80010e <vcprintf>
	cprintf("\n");
  800edd:	c7 04 24 4c 11 80 00 	movl   $0x80114c,(%esp)
  800ee4:	e8 76 f2 ff ff       	call   80015f <cprintf>
  800ee9:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800eec:	cc                   	int3   
  800eed:	eb fd                	jmp    800eec <_panic+0x43>
  800eef:	90                   	nop

00800ef0 <__udivdi3>:
  800ef0:	55                   	push   %ebp
  800ef1:	57                   	push   %edi
  800ef2:	56                   	push   %esi
  800ef3:	53                   	push   %ebx
  800ef4:	83 ec 1c             	sub    $0x1c,%esp
  800ef7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800efb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800eff:	8b 74 24 34          	mov    0x34(%esp),%esi
  800f03:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800f07:	85 d2                	test   %edx,%edx
  800f09:	75 4d                	jne    800f58 <__udivdi3+0x68>
  800f0b:	39 f3                	cmp    %esi,%ebx
  800f0d:	76 19                	jbe    800f28 <__udivdi3+0x38>
  800f0f:	31 ff                	xor    %edi,%edi
  800f11:	89 e8                	mov    %ebp,%eax
  800f13:	89 f2                	mov    %esi,%edx
  800f15:	f7 f3                	div    %ebx
  800f17:	89 fa                	mov    %edi,%edx
  800f19:	83 c4 1c             	add    $0x1c,%esp
  800f1c:	5b                   	pop    %ebx
  800f1d:	5e                   	pop    %esi
  800f1e:	5f                   	pop    %edi
  800f1f:	5d                   	pop    %ebp
  800f20:	c3                   	ret    
  800f21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f28:	89 d9                	mov    %ebx,%ecx
  800f2a:	85 db                	test   %ebx,%ebx
  800f2c:	75 0b                	jne    800f39 <__udivdi3+0x49>
  800f2e:	b8 01 00 00 00       	mov    $0x1,%eax
  800f33:	31 d2                	xor    %edx,%edx
  800f35:	f7 f3                	div    %ebx
  800f37:	89 c1                	mov    %eax,%ecx
  800f39:	31 d2                	xor    %edx,%edx
  800f3b:	89 f0                	mov    %esi,%eax
  800f3d:	f7 f1                	div    %ecx
  800f3f:	89 c6                	mov    %eax,%esi
  800f41:	89 e8                	mov    %ebp,%eax
  800f43:	89 f7                	mov    %esi,%edi
  800f45:	f7 f1                	div    %ecx
  800f47:	89 fa                	mov    %edi,%edx
  800f49:	83 c4 1c             	add    $0x1c,%esp
  800f4c:	5b                   	pop    %ebx
  800f4d:	5e                   	pop    %esi
  800f4e:	5f                   	pop    %edi
  800f4f:	5d                   	pop    %ebp
  800f50:	c3                   	ret    
  800f51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f58:	39 f2                	cmp    %esi,%edx
  800f5a:	77 1c                	ja     800f78 <__udivdi3+0x88>
  800f5c:	0f bd fa             	bsr    %edx,%edi
  800f5f:	83 f7 1f             	xor    $0x1f,%edi
  800f62:	75 2c                	jne    800f90 <__udivdi3+0xa0>
  800f64:	39 f2                	cmp    %esi,%edx
  800f66:	72 06                	jb     800f6e <__udivdi3+0x7e>
  800f68:	31 c0                	xor    %eax,%eax
  800f6a:	39 eb                	cmp    %ebp,%ebx
  800f6c:	77 a9                	ja     800f17 <__udivdi3+0x27>
  800f6e:	b8 01 00 00 00       	mov    $0x1,%eax
  800f73:	eb a2                	jmp    800f17 <__udivdi3+0x27>
  800f75:	8d 76 00             	lea    0x0(%esi),%esi
  800f78:	31 ff                	xor    %edi,%edi
  800f7a:	31 c0                	xor    %eax,%eax
  800f7c:	89 fa                	mov    %edi,%edx
  800f7e:	83 c4 1c             	add    $0x1c,%esp
  800f81:	5b                   	pop    %ebx
  800f82:	5e                   	pop    %esi
  800f83:	5f                   	pop    %edi
  800f84:	5d                   	pop    %ebp
  800f85:	c3                   	ret    
  800f86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f8d:	8d 76 00             	lea    0x0(%esi),%esi
  800f90:	89 f9                	mov    %edi,%ecx
  800f92:	b8 20 00 00 00       	mov    $0x20,%eax
  800f97:	29 f8                	sub    %edi,%eax
  800f99:	d3 e2                	shl    %cl,%edx
  800f9b:	89 54 24 08          	mov    %edx,0x8(%esp)
  800f9f:	89 c1                	mov    %eax,%ecx
  800fa1:	89 da                	mov    %ebx,%edx
  800fa3:	d3 ea                	shr    %cl,%edx
  800fa5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800fa9:	09 d1                	or     %edx,%ecx
  800fab:	89 f2                	mov    %esi,%edx
  800fad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800fb1:	89 f9                	mov    %edi,%ecx
  800fb3:	d3 e3                	shl    %cl,%ebx
  800fb5:	89 c1                	mov    %eax,%ecx
  800fb7:	d3 ea                	shr    %cl,%edx
  800fb9:	89 f9                	mov    %edi,%ecx
  800fbb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800fbf:	89 eb                	mov    %ebp,%ebx
  800fc1:	d3 e6                	shl    %cl,%esi
  800fc3:	89 c1                	mov    %eax,%ecx
  800fc5:	d3 eb                	shr    %cl,%ebx
  800fc7:	09 de                	or     %ebx,%esi
  800fc9:	89 f0                	mov    %esi,%eax
  800fcb:	f7 74 24 08          	divl   0x8(%esp)
  800fcf:	89 d6                	mov    %edx,%esi
  800fd1:	89 c3                	mov    %eax,%ebx
  800fd3:	f7 64 24 0c          	mull   0xc(%esp)
  800fd7:	39 d6                	cmp    %edx,%esi
  800fd9:	72 15                	jb     800ff0 <__udivdi3+0x100>
  800fdb:	89 f9                	mov    %edi,%ecx
  800fdd:	d3 e5                	shl    %cl,%ebp
  800fdf:	39 c5                	cmp    %eax,%ebp
  800fe1:	73 04                	jae    800fe7 <__udivdi3+0xf7>
  800fe3:	39 d6                	cmp    %edx,%esi
  800fe5:	74 09                	je     800ff0 <__udivdi3+0x100>
  800fe7:	89 d8                	mov    %ebx,%eax
  800fe9:	31 ff                	xor    %edi,%edi
  800feb:	e9 27 ff ff ff       	jmp    800f17 <__udivdi3+0x27>
  800ff0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800ff3:	31 ff                	xor    %edi,%edi
  800ff5:	e9 1d ff ff ff       	jmp    800f17 <__udivdi3+0x27>
  800ffa:	66 90                	xchg   %ax,%ax
  800ffc:	66 90                	xchg   %ax,%ax
  800ffe:	66 90                	xchg   %ax,%ax

00801000 <__umoddi3>:
  801000:	55                   	push   %ebp
  801001:	57                   	push   %edi
  801002:	56                   	push   %esi
  801003:	53                   	push   %ebx
  801004:	83 ec 1c             	sub    $0x1c,%esp
  801007:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80100b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80100f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801013:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801017:	89 da                	mov    %ebx,%edx
  801019:	85 c0                	test   %eax,%eax
  80101b:	75 43                	jne    801060 <__umoddi3+0x60>
  80101d:	39 df                	cmp    %ebx,%edi
  80101f:	76 17                	jbe    801038 <__umoddi3+0x38>
  801021:	89 f0                	mov    %esi,%eax
  801023:	f7 f7                	div    %edi
  801025:	89 d0                	mov    %edx,%eax
  801027:	31 d2                	xor    %edx,%edx
  801029:	83 c4 1c             	add    $0x1c,%esp
  80102c:	5b                   	pop    %ebx
  80102d:	5e                   	pop    %esi
  80102e:	5f                   	pop    %edi
  80102f:	5d                   	pop    %ebp
  801030:	c3                   	ret    
  801031:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801038:	89 fd                	mov    %edi,%ebp
  80103a:	85 ff                	test   %edi,%edi
  80103c:	75 0b                	jne    801049 <__umoddi3+0x49>
  80103e:	b8 01 00 00 00       	mov    $0x1,%eax
  801043:	31 d2                	xor    %edx,%edx
  801045:	f7 f7                	div    %edi
  801047:	89 c5                	mov    %eax,%ebp
  801049:	89 d8                	mov    %ebx,%eax
  80104b:	31 d2                	xor    %edx,%edx
  80104d:	f7 f5                	div    %ebp
  80104f:	89 f0                	mov    %esi,%eax
  801051:	f7 f5                	div    %ebp
  801053:	89 d0                	mov    %edx,%eax
  801055:	eb d0                	jmp    801027 <__umoddi3+0x27>
  801057:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80105e:	66 90                	xchg   %ax,%ax
  801060:	89 f1                	mov    %esi,%ecx
  801062:	39 d8                	cmp    %ebx,%eax
  801064:	76 0a                	jbe    801070 <__umoddi3+0x70>
  801066:	89 f0                	mov    %esi,%eax
  801068:	83 c4 1c             	add    $0x1c,%esp
  80106b:	5b                   	pop    %ebx
  80106c:	5e                   	pop    %esi
  80106d:	5f                   	pop    %edi
  80106e:	5d                   	pop    %ebp
  80106f:	c3                   	ret    
  801070:	0f bd e8             	bsr    %eax,%ebp
  801073:	83 f5 1f             	xor    $0x1f,%ebp
  801076:	75 20                	jne    801098 <__umoddi3+0x98>
  801078:	39 d8                	cmp    %ebx,%eax
  80107a:	0f 82 b0 00 00 00    	jb     801130 <__umoddi3+0x130>
  801080:	39 f7                	cmp    %esi,%edi
  801082:	0f 86 a8 00 00 00    	jbe    801130 <__umoddi3+0x130>
  801088:	89 c8                	mov    %ecx,%eax
  80108a:	83 c4 1c             	add    $0x1c,%esp
  80108d:	5b                   	pop    %ebx
  80108e:	5e                   	pop    %esi
  80108f:	5f                   	pop    %edi
  801090:	5d                   	pop    %ebp
  801091:	c3                   	ret    
  801092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801098:	89 e9                	mov    %ebp,%ecx
  80109a:	ba 20 00 00 00       	mov    $0x20,%edx
  80109f:	29 ea                	sub    %ebp,%edx
  8010a1:	d3 e0                	shl    %cl,%eax
  8010a3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8010a7:	89 d1                	mov    %edx,%ecx
  8010a9:	89 f8                	mov    %edi,%eax
  8010ab:	d3 e8                	shr    %cl,%eax
  8010ad:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8010b1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8010b5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8010b9:	09 c1                	or     %eax,%ecx
  8010bb:	89 d8                	mov    %ebx,%eax
  8010bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8010c1:	89 e9                	mov    %ebp,%ecx
  8010c3:	d3 e7                	shl    %cl,%edi
  8010c5:	89 d1                	mov    %edx,%ecx
  8010c7:	d3 e8                	shr    %cl,%eax
  8010c9:	89 e9                	mov    %ebp,%ecx
  8010cb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8010cf:	d3 e3                	shl    %cl,%ebx
  8010d1:	89 c7                	mov    %eax,%edi
  8010d3:	89 d1                	mov    %edx,%ecx
  8010d5:	89 f0                	mov    %esi,%eax
  8010d7:	d3 e8                	shr    %cl,%eax
  8010d9:	89 e9                	mov    %ebp,%ecx
  8010db:	89 fa                	mov    %edi,%edx
  8010dd:	d3 e6                	shl    %cl,%esi
  8010df:	09 d8                	or     %ebx,%eax
  8010e1:	f7 74 24 08          	divl   0x8(%esp)
  8010e5:	89 d1                	mov    %edx,%ecx
  8010e7:	89 f3                	mov    %esi,%ebx
  8010e9:	f7 64 24 0c          	mull   0xc(%esp)
  8010ed:	89 c6                	mov    %eax,%esi
  8010ef:	89 d7                	mov    %edx,%edi
  8010f1:	39 d1                	cmp    %edx,%ecx
  8010f3:	72 06                	jb     8010fb <__umoddi3+0xfb>
  8010f5:	75 10                	jne    801107 <__umoddi3+0x107>
  8010f7:	39 c3                	cmp    %eax,%ebx
  8010f9:	73 0c                	jae    801107 <__umoddi3+0x107>
  8010fb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8010ff:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801103:	89 d7                	mov    %edx,%edi
  801105:	89 c6                	mov    %eax,%esi
  801107:	89 ca                	mov    %ecx,%edx
  801109:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80110e:	29 f3                	sub    %esi,%ebx
  801110:	19 fa                	sbb    %edi,%edx
  801112:	89 d0                	mov    %edx,%eax
  801114:	d3 e0                	shl    %cl,%eax
  801116:	89 e9                	mov    %ebp,%ecx
  801118:	d3 eb                	shr    %cl,%ebx
  80111a:	d3 ea                	shr    %cl,%edx
  80111c:	09 d8                	or     %ebx,%eax
  80111e:	83 c4 1c             	add    $0x1c,%esp
  801121:	5b                   	pop    %ebx
  801122:	5e                   	pop    %esi
  801123:	5f                   	pop    %edi
  801124:	5d                   	pop    %ebp
  801125:	c3                   	ret    
  801126:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80112d:	8d 76 00             	lea    0x0(%esi),%esi
  801130:	89 da                	mov    %ebx,%edx
  801132:	29 fe                	sub    %edi,%esi
  801134:	19 c2                	sbb    %eax,%edx
  801136:	89 f1                	mov    %esi,%ecx
  801138:	89 c8                	mov    %ecx,%eax
  80113a:	e9 4b ff ff ff       	jmp    80108a <__umoddi3+0x8a>
