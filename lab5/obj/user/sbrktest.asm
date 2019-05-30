
obj/user/sbrktest.debug:     file format elf32-i386


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
  80002c:	e8 8a 00 00 00       	call   8000bb <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#define ALLOCATE_SIZE 4096
#define STRING_SIZE	  64

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 18             	sub    $0x18,%esp
	int i;
	uint32_t start, end;
	char *s;

	start = sys_sbrk(0);
  80003c:	6a 00                	push   $0x0
  80003e:	e8 92 0e 00 00       	call   800ed5 <sys_sbrk>
  800043:	89 c6                	mov    %eax,%esi
  800045:	89 c3                	mov    %eax,%ebx
	end = sys_sbrk(ALLOCATE_SIZE);
  800047:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  80004e:	e8 82 0e 00 00       	call   800ed5 <sys_sbrk>

	if (end - start < ALLOCATE_SIZE) {
  800053:	29 f0                	sub    %esi,%eax
  800055:	83 c4 10             	add    $0x10,%esp
  800058:	3d ff 0f 00 00       	cmp    $0xfff,%eax
  80005d:	76 4a                	jbe    8000a9 <umain+0x76>
		cprintf("sbrk not correctly implemented\n");
	}

	s = (char *) start;
	for ( i = 0; i < STRING_SIZE; i++) {
  80005f:	b9 00 00 00 00       	mov    $0x0,%ecx
		s[i] = 'A' + (i % 26);
  800064:	bf 4f ec c4 4e       	mov    $0x4ec4ec4f,%edi
  800069:	89 c8                	mov    %ecx,%eax
  80006b:	f7 ef                	imul   %edi
  80006d:	c1 fa 03             	sar    $0x3,%edx
  800070:	89 c8                	mov    %ecx,%eax
  800072:	c1 f8 1f             	sar    $0x1f,%eax
  800075:	29 c2                	sub    %eax,%edx
  800077:	6b d2 1a             	imul   $0x1a,%edx,%edx
  80007a:	89 c8                	mov    %ecx,%eax
  80007c:	29 d0                	sub    %edx,%eax
  80007e:	83 c0 41             	add    $0x41,%eax
  800081:	88 04 19             	mov    %al,(%ecx,%ebx,1)
	for ( i = 0; i < STRING_SIZE; i++) {
  800084:	83 c1 01             	add    $0x1,%ecx
  800087:	83 f9 40             	cmp    $0x40,%ecx
  80008a:	75 dd                	jne    800069 <umain+0x36>
	}
	s[STRING_SIZE] = '\0';
  80008c:	c6 46 40 00          	movb   $0x0,0x40(%esi)

	cprintf("SBRK_TEST(%s)\n", s);
  800090:	83 ec 08             	sub    $0x8,%esp
  800093:	56                   	push   %esi
  800094:	68 c0 11 80 00       	push   $0x8011c0
  800099:	e8 0d 01 00 00       	call   8001ab <cprintf>
}
  80009e:	83 c4 10             	add    $0x10,%esp
  8000a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000a4:	5b                   	pop    %ebx
  8000a5:	5e                   	pop    %esi
  8000a6:	5f                   	pop    %edi
  8000a7:	5d                   	pop    %ebp
  8000a8:	c3                   	ret    
		cprintf("sbrk not correctly implemented\n");
  8000a9:	83 ec 0c             	sub    $0xc,%esp
  8000ac:	68 a0 11 80 00       	push   $0x8011a0
  8000b1:	e8 f5 00 00 00       	call   8001ab <cprintf>
  8000b6:	83 c4 10             	add    $0x10,%esp
  8000b9:	eb a4                	jmp    80005f <umain+0x2c>

008000bb <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000bb:	55                   	push   %ebp
  8000bc:	89 e5                	mov    %esp,%ebp
  8000be:	56                   	push   %esi
  8000bf:	53                   	push   %ebx
  8000c0:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000c3:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	// thisenv = 0;
	thisenv = &(envs[ENVX(sys_getenvid())]);
  8000c6:	e8 ba 0b 00 00       	call   800c85 <sys_getenvid>
  8000cb:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000d0:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8000d6:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000db:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000e0:	85 db                	test   %ebx,%ebx
  8000e2:	7e 07                	jle    8000eb <libmain+0x30>
		binaryname = argv[0];
  8000e4:	8b 06                	mov    (%esi),%eax
  8000e6:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  8000eb:	83 ec 08             	sub    $0x8,%esp
  8000ee:	56                   	push   %esi
  8000ef:	53                   	push   %ebx
  8000f0:	e8 3e ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000f5:	e8 0a 00 00 00       	call   800104 <exit>
}
  8000fa:	83 c4 10             	add    $0x10,%esp
  8000fd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800100:	5b                   	pop    %ebx
  800101:	5e                   	pop    %esi
  800102:	5d                   	pop    %ebp
  800103:	c3                   	ret    

00800104 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800104:	55                   	push   %ebp
  800105:	89 e5                	mov    %esp,%ebp
  800107:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  80010a:	6a 00                	push   $0x0
  80010c:	e8 33 0b 00 00       	call   800c44 <sys_env_destroy>
}
  800111:	83 c4 10             	add    $0x10,%esp
  800114:	c9                   	leave  
  800115:	c3                   	ret    

00800116 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800116:	55                   	push   %ebp
  800117:	89 e5                	mov    %esp,%ebp
  800119:	53                   	push   %ebx
  80011a:	83 ec 04             	sub    $0x4,%esp
  80011d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800120:	8b 13                	mov    (%ebx),%edx
  800122:	8d 42 01             	lea    0x1(%edx),%eax
  800125:	89 03                	mov    %eax,(%ebx)
  800127:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80012a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80012e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800133:	74 09                	je     80013e <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800135:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800139:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80013c:	c9                   	leave  
  80013d:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80013e:	83 ec 08             	sub    $0x8,%esp
  800141:	68 ff 00 00 00       	push   $0xff
  800146:	8d 43 08             	lea    0x8(%ebx),%eax
  800149:	50                   	push   %eax
  80014a:	e8 b8 0a 00 00       	call   800c07 <sys_cputs>
		b->idx = 0;
  80014f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800155:	83 c4 10             	add    $0x10,%esp
  800158:	eb db                	jmp    800135 <putch+0x1f>

0080015a <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80015a:	55                   	push   %ebp
  80015b:	89 e5                	mov    %esp,%ebp
  80015d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800163:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80016a:	00 00 00 
	b.cnt = 0;
  80016d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800174:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800177:	ff 75 0c             	pushl  0xc(%ebp)
  80017a:	ff 75 08             	pushl  0x8(%ebp)
  80017d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800183:	50                   	push   %eax
  800184:	68 16 01 80 00       	push   $0x800116
  800189:	e8 4a 01 00 00       	call   8002d8 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80018e:	83 c4 08             	add    $0x8,%esp
  800191:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800197:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80019d:	50                   	push   %eax
  80019e:	e8 64 0a 00 00       	call   800c07 <sys_cputs>

	return b.cnt;
}
  8001a3:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001a9:	c9                   	leave  
  8001aa:	c3                   	ret    

008001ab <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001ab:	55                   	push   %ebp
  8001ac:	89 e5                	mov    %esp,%ebp
  8001ae:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001b1:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001b4:	50                   	push   %eax
  8001b5:	ff 75 08             	pushl  0x8(%ebp)
  8001b8:	e8 9d ff ff ff       	call   80015a <vcprintf>
	va_end(ap);

	return cnt;
}
  8001bd:	c9                   	leave  
  8001be:	c3                   	ret    

008001bf <printnum>:


static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001bf:	55                   	push   %ebp
  8001c0:	89 e5                	mov    %esp,%ebp
  8001c2:	57                   	push   %edi
  8001c3:	56                   	push   %esi
  8001c4:	53                   	push   %ebx
  8001c5:	83 ec 1c             	sub    $0x1c,%esp
  8001c8:	89 c6                	mov    %eax,%esi
  8001ca:	89 d7                	mov    %edx,%edi
  8001cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8001cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001d5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8001d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8001db:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	// to support '-'
	if(padc == '-'){
  8001de:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8001e2:	74 2c                	je     800210 <printnum+0x51>
		while (--width > 0)
			putch(' ', putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001e4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001e7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8001ee:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8001f1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8001f4:	39 c2                	cmp    %eax,%edx
  8001f6:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8001f9:	73 43                	jae    80023e <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8001fb:	83 eb 01             	sub    $0x1,%ebx
  8001fe:	85 db                	test   %ebx,%ebx
  800200:	7e 6c                	jle    80026e <printnum+0xaf>
			putch(padc, putdat);
  800202:	83 ec 08             	sub    $0x8,%esp
  800205:	57                   	push   %edi
  800206:	ff 75 18             	pushl  0x18(%ebp)
  800209:	ff d6                	call   *%esi
  80020b:	83 c4 10             	add    $0x10,%esp
  80020e:	eb eb                	jmp    8001fb <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800210:	83 ec 0c             	sub    $0xc,%esp
  800213:	6a 20                	push   $0x20
  800215:	6a 00                	push   $0x0
  800217:	50                   	push   %eax
  800218:	ff 75 e4             	pushl  -0x1c(%ebp)
  80021b:	ff 75 e0             	pushl  -0x20(%ebp)
  80021e:	89 fa                	mov    %edi,%edx
  800220:	89 f0                	mov    %esi,%eax
  800222:	e8 98 ff ff ff       	call   8001bf <printnum>
		while (--width > 0)
  800227:	83 c4 20             	add    $0x20,%esp
  80022a:	83 eb 01             	sub    $0x1,%ebx
  80022d:	85 db                	test   %ebx,%ebx
  80022f:	7e 65                	jle    800296 <printnum+0xd7>
			putch(' ', putdat);
  800231:	83 ec 08             	sub    $0x8,%esp
  800234:	57                   	push   %edi
  800235:	6a 20                	push   $0x20
  800237:	ff d6                	call   *%esi
  800239:	83 c4 10             	add    $0x10,%esp
  80023c:	eb ec                	jmp    80022a <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80023e:	83 ec 0c             	sub    $0xc,%esp
  800241:	ff 75 18             	pushl  0x18(%ebp)
  800244:	83 eb 01             	sub    $0x1,%ebx
  800247:	53                   	push   %ebx
  800248:	50                   	push   %eax
  800249:	83 ec 08             	sub    $0x8,%esp
  80024c:	ff 75 dc             	pushl  -0x24(%ebp)
  80024f:	ff 75 d8             	pushl  -0x28(%ebp)
  800252:	ff 75 e4             	pushl  -0x1c(%ebp)
  800255:	ff 75 e0             	pushl  -0x20(%ebp)
  800258:	e8 e3 0c 00 00       	call   800f40 <__udivdi3>
  80025d:	83 c4 18             	add    $0x18,%esp
  800260:	52                   	push   %edx
  800261:	50                   	push   %eax
  800262:	89 fa                	mov    %edi,%edx
  800264:	89 f0                	mov    %esi,%eax
  800266:	e8 54 ff ff ff       	call   8001bf <printnum>
  80026b:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80026e:	83 ec 08             	sub    $0x8,%esp
  800271:	57                   	push   %edi
  800272:	83 ec 04             	sub    $0x4,%esp
  800275:	ff 75 dc             	pushl  -0x24(%ebp)
  800278:	ff 75 d8             	pushl  -0x28(%ebp)
  80027b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80027e:	ff 75 e0             	pushl  -0x20(%ebp)
  800281:	e8 ca 0d 00 00       	call   801050 <__umoddi3>
  800286:	83 c4 14             	add    $0x14,%esp
  800289:	0f be 80 d9 11 80 00 	movsbl 0x8011d9(%eax),%eax
  800290:	50                   	push   %eax
  800291:	ff d6                	call   *%esi
  800293:	83 c4 10             	add    $0x10,%esp
}
  800296:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800299:	5b                   	pop    %ebx
  80029a:	5e                   	pop    %esi
  80029b:	5f                   	pop    %edi
  80029c:	5d                   	pop    %ebp
  80029d:	c3                   	ret    

0080029e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80029e:	55                   	push   %ebp
  80029f:	89 e5                	mov    %esp,%ebp
  8002a1:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002a4:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002a8:	8b 10                	mov    (%eax),%edx
  8002aa:	3b 50 04             	cmp    0x4(%eax),%edx
  8002ad:	73 0a                	jae    8002b9 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002af:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002b2:	89 08                	mov    %ecx,(%eax)
  8002b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b7:	88 02                	mov    %al,(%edx)
}
  8002b9:	5d                   	pop    %ebp
  8002ba:	c3                   	ret    

008002bb <printfmt>:
{
  8002bb:	55                   	push   %ebp
  8002bc:	89 e5                	mov    %esp,%ebp
  8002be:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002c1:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002c4:	50                   	push   %eax
  8002c5:	ff 75 10             	pushl  0x10(%ebp)
  8002c8:	ff 75 0c             	pushl  0xc(%ebp)
  8002cb:	ff 75 08             	pushl  0x8(%ebp)
  8002ce:	e8 05 00 00 00       	call   8002d8 <vprintfmt>
}
  8002d3:	83 c4 10             	add    $0x10,%esp
  8002d6:	c9                   	leave  
  8002d7:	c3                   	ret    

008002d8 <vprintfmt>:
{
  8002d8:	55                   	push   %ebp
  8002d9:	89 e5                	mov    %esp,%ebp
  8002db:	57                   	push   %edi
  8002dc:	56                   	push   %esi
  8002dd:	53                   	push   %ebx
  8002de:	83 ec 3c             	sub    $0x3c,%esp
  8002e1:	8b 75 08             	mov    0x8(%ebp),%esi
  8002e4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002e7:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002ea:	e9 1e 04 00 00       	jmp    80070d <vprintfmt+0x435>
		posflag = 0;
  8002ef:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
		padc = ' ';
  8002f6:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8002fa:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800301:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800308:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80030f:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  800316:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80031b:	8d 47 01             	lea    0x1(%edi),%eax
  80031e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800321:	0f b6 17             	movzbl (%edi),%edx
  800324:	8d 42 dd             	lea    -0x23(%edx),%eax
  800327:	3c 55                	cmp    $0x55,%al
  800329:	0f 87 d9 04 00 00    	ja     800808 <vprintfmt+0x530>
  80032f:	0f b6 c0             	movzbl %al,%eax
  800332:	ff 24 85 c0 13 80 00 	jmp    *0x8013c0(,%eax,4)
  800339:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80033c:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800340:	eb d9                	jmp    80031b <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800342:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posflag = 1;
  800345:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  80034c:	eb cd                	jmp    80031b <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80034e:	0f b6 d2             	movzbl %dl,%edx
  800351:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800354:	b8 00 00 00 00       	mov    $0x0,%eax
  800359:	89 75 08             	mov    %esi,0x8(%ebp)
  80035c:	eb 0c                	jmp    80036a <vprintfmt+0x92>
		switch (ch = *(unsigned char *) fmt++) {
  80035e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800361:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  800365:	eb b4                	jmp    80031b <vprintfmt+0x43>
			for (precision = 0; ; ++fmt) {
  800367:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80036a:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80036d:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800371:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800374:	8d 72 d0             	lea    -0x30(%edx),%esi
  800377:	83 fe 09             	cmp    $0x9,%esi
  80037a:	76 eb                	jbe    800367 <vprintfmt+0x8f>
  80037c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80037f:	8b 75 08             	mov    0x8(%ebp),%esi
  800382:	eb 14                	jmp    800398 <vprintfmt+0xc0>
			precision = va_arg(ap, int);
  800384:	8b 45 14             	mov    0x14(%ebp),%eax
  800387:	8b 00                	mov    (%eax),%eax
  800389:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80038c:	8b 45 14             	mov    0x14(%ebp),%eax
  80038f:	8d 40 04             	lea    0x4(%eax),%eax
  800392:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800395:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800398:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80039c:	0f 89 79 ff ff ff    	jns    80031b <vprintfmt+0x43>
				width = precision, precision = -1;
  8003a2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003a8:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003af:	e9 67 ff ff ff       	jmp    80031b <vprintfmt+0x43>
  8003b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003b7:	85 c0                	test   %eax,%eax
  8003b9:	0f 48 c1             	cmovs  %ecx,%eax
  8003bc:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003bf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003c2:	e9 54 ff ff ff       	jmp    80031b <vprintfmt+0x43>
  8003c7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003ca:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8003d1:	e9 45 ff ff ff       	jmp    80031b <vprintfmt+0x43>
			lflag++;
  8003d6:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003da:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003dd:	e9 39 ff ff ff       	jmp    80031b <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8003e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e5:	8d 78 04             	lea    0x4(%eax),%edi
  8003e8:	83 ec 08             	sub    $0x8,%esp
  8003eb:	53                   	push   %ebx
  8003ec:	ff 30                	pushl  (%eax)
  8003ee:	ff d6                	call   *%esi
			break;
  8003f0:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003f3:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003f6:	e9 0f 03 00 00       	jmp    80070a <vprintfmt+0x432>
			err = va_arg(ap, int);
  8003fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8003fe:	8d 78 04             	lea    0x4(%eax),%edi
  800401:	8b 00                	mov    (%eax),%eax
  800403:	99                   	cltd   
  800404:	31 d0                	xor    %edx,%eax
  800406:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800408:	83 f8 0f             	cmp    $0xf,%eax
  80040b:	7f 23                	jg     800430 <vprintfmt+0x158>
  80040d:	8b 14 85 20 15 80 00 	mov    0x801520(,%eax,4),%edx
  800414:	85 d2                	test   %edx,%edx
  800416:	74 18                	je     800430 <vprintfmt+0x158>
				printfmt(putch, putdat, "%s", p);
  800418:	52                   	push   %edx
  800419:	68 fa 11 80 00       	push   $0x8011fa
  80041e:	53                   	push   %ebx
  80041f:	56                   	push   %esi
  800420:	e8 96 fe ff ff       	call   8002bb <printfmt>
  800425:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800428:	89 7d 14             	mov    %edi,0x14(%ebp)
  80042b:	e9 da 02 00 00       	jmp    80070a <vprintfmt+0x432>
				printfmt(putch, putdat, "error %d", err);
  800430:	50                   	push   %eax
  800431:	68 f1 11 80 00       	push   $0x8011f1
  800436:	53                   	push   %ebx
  800437:	56                   	push   %esi
  800438:	e8 7e fe ff ff       	call   8002bb <printfmt>
  80043d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800440:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800443:	e9 c2 02 00 00       	jmp    80070a <vprintfmt+0x432>
			if ((p = va_arg(ap, char *)) == NULL)
  800448:	8b 45 14             	mov    0x14(%ebp),%eax
  80044b:	83 c0 04             	add    $0x4,%eax
  80044e:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800451:	8b 45 14             	mov    0x14(%ebp),%eax
  800454:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800456:	85 c9                	test   %ecx,%ecx
  800458:	b8 ea 11 80 00       	mov    $0x8011ea,%eax
  80045d:	0f 45 c1             	cmovne %ecx,%eax
  800460:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800463:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800467:	7e 06                	jle    80046f <vprintfmt+0x197>
  800469:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80046d:	75 0d                	jne    80047c <vprintfmt+0x1a4>
				for (width -= strnlen(p, precision); width > 0; width--)
  80046f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800472:	89 c7                	mov    %eax,%edi
  800474:	03 45 e0             	add    -0x20(%ebp),%eax
  800477:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80047a:	eb 53                	jmp    8004cf <vprintfmt+0x1f7>
  80047c:	83 ec 08             	sub    $0x8,%esp
  80047f:	ff 75 d8             	pushl  -0x28(%ebp)
  800482:	50                   	push   %eax
  800483:	e8 28 04 00 00       	call   8008b0 <strnlen>
  800488:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80048b:	29 c1                	sub    %eax,%ecx
  80048d:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  800490:	83 c4 10             	add    $0x10,%esp
  800493:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800495:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800499:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80049c:	eb 0f                	jmp    8004ad <vprintfmt+0x1d5>
					putch(padc, putdat);
  80049e:	83 ec 08             	sub    $0x8,%esp
  8004a1:	53                   	push   %ebx
  8004a2:	ff 75 e0             	pushl  -0x20(%ebp)
  8004a5:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004a7:	83 ef 01             	sub    $0x1,%edi
  8004aa:	83 c4 10             	add    $0x10,%esp
  8004ad:	85 ff                	test   %edi,%edi
  8004af:	7f ed                	jg     80049e <vprintfmt+0x1c6>
  8004b1:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  8004b4:	85 c9                	test   %ecx,%ecx
  8004b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8004bb:	0f 49 c1             	cmovns %ecx,%eax
  8004be:	29 c1                	sub    %eax,%ecx
  8004c0:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8004c3:	eb aa                	jmp    80046f <vprintfmt+0x197>
					putch(ch, putdat);
  8004c5:	83 ec 08             	sub    $0x8,%esp
  8004c8:	53                   	push   %ebx
  8004c9:	52                   	push   %edx
  8004ca:	ff d6                	call   *%esi
  8004cc:	83 c4 10             	add    $0x10,%esp
  8004cf:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004d2:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004d4:	83 c7 01             	add    $0x1,%edi
  8004d7:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004db:	0f be d0             	movsbl %al,%edx
  8004de:	85 d2                	test   %edx,%edx
  8004e0:	74 4b                	je     80052d <vprintfmt+0x255>
  8004e2:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004e6:	78 06                	js     8004ee <vprintfmt+0x216>
  8004e8:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004ec:	78 1e                	js     80050c <vprintfmt+0x234>
				if (altflag && (ch < ' ' || ch > '~'))
  8004ee:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004f2:	74 d1                	je     8004c5 <vprintfmt+0x1ed>
  8004f4:	0f be c0             	movsbl %al,%eax
  8004f7:	83 e8 20             	sub    $0x20,%eax
  8004fa:	83 f8 5e             	cmp    $0x5e,%eax
  8004fd:	76 c6                	jbe    8004c5 <vprintfmt+0x1ed>
					putch('?', putdat);
  8004ff:	83 ec 08             	sub    $0x8,%esp
  800502:	53                   	push   %ebx
  800503:	6a 3f                	push   $0x3f
  800505:	ff d6                	call   *%esi
  800507:	83 c4 10             	add    $0x10,%esp
  80050a:	eb c3                	jmp    8004cf <vprintfmt+0x1f7>
  80050c:	89 cf                	mov    %ecx,%edi
  80050e:	eb 0e                	jmp    80051e <vprintfmt+0x246>
				putch(' ', putdat);
  800510:	83 ec 08             	sub    $0x8,%esp
  800513:	53                   	push   %ebx
  800514:	6a 20                	push   $0x20
  800516:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800518:	83 ef 01             	sub    $0x1,%edi
  80051b:	83 c4 10             	add    $0x10,%esp
  80051e:	85 ff                	test   %edi,%edi
  800520:	7f ee                	jg     800510 <vprintfmt+0x238>
			if ((p = va_arg(ap, char *)) == NULL)
  800522:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800525:	89 45 14             	mov    %eax,0x14(%ebp)
  800528:	e9 dd 01 00 00       	jmp    80070a <vprintfmt+0x432>
  80052d:	89 cf                	mov    %ecx,%edi
  80052f:	eb ed                	jmp    80051e <vprintfmt+0x246>
	if (lflag >= 2)
  800531:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800535:	7f 21                	jg     800558 <vprintfmt+0x280>
	else if (lflag)
  800537:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80053b:	74 6a                	je     8005a7 <vprintfmt+0x2cf>
		return va_arg(*ap, long);
  80053d:	8b 45 14             	mov    0x14(%ebp),%eax
  800540:	8b 00                	mov    (%eax),%eax
  800542:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800545:	89 c1                	mov    %eax,%ecx
  800547:	c1 f9 1f             	sar    $0x1f,%ecx
  80054a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80054d:	8b 45 14             	mov    0x14(%ebp),%eax
  800550:	8d 40 04             	lea    0x4(%eax),%eax
  800553:	89 45 14             	mov    %eax,0x14(%ebp)
  800556:	eb 17                	jmp    80056f <vprintfmt+0x297>
		return va_arg(*ap, long long);
  800558:	8b 45 14             	mov    0x14(%ebp),%eax
  80055b:	8b 50 04             	mov    0x4(%eax),%edx
  80055e:	8b 00                	mov    (%eax),%eax
  800560:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800563:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800566:	8b 45 14             	mov    0x14(%ebp),%eax
  800569:	8d 40 08             	lea    0x8(%eax),%eax
  80056c:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80056f:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  800572:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800577:	85 d2                	test   %edx,%edx
  800579:	0f 89 5c 01 00 00    	jns    8006db <vprintfmt+0x403>
				putch('-', putdat);
  80057f:	83 ec 08             	sub    $0x8,%esp
  800582:	53                   	push   %ebx
  800583:	6a 2d                	push   $0x2d
  800585:	ff d6                	call   *%esi
				num = -(long long) num;
  800587:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80058a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80058d:	f7 d8                	neg    %eax
  80058f:	83 d2 00             	adc    $0x0,%edx
  800592:	f7 da                	neg    %edx
  800594:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800597:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80059a:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80059d:	bf 0a 00 00 00       	mov    $0xa,%edi
  8005a2:	e9 45 01 00 00       	jmp    8006ec <vprintfmt+0x414>
		return va_arg(*ap, int);
  8005a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005aa:	8b 00                	mov    (%eax),%eax
  8005ac:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005af:	89 c1                	mov    %eax,%ecx
  8005b1:	c1 f9 1f             	sar    $0x1f,%ecx
  8005b4:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ba:	8d 40 04             	lea    0x4(%eax),%eax
  8005bd:	89 45 14             	mov    %eax,0x14(%ebp)
  8005c0:	eb ad                	jmp    80056f <vprintfmt+0x297>
	if (lflag >= 2)
  8005c2:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8005c6:	7f 29                	jg     8005f1 <vprintfmt+0x319>
	else if (lflag)
  8005c8:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8005cc:	74 44                	je     800612 <vprintfmt+0x33a>
		return va_arg(*ap, unsigned long);
  8005ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d1:	8b 00                	mov    (%eax),%eax
  8005d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8005d8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005db:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005de:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e1:	8d 40 04             	lea    0x4(%eax),%eax
  8005e4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005e7:	bf 0a 00 00 00       	mov    $0xa,%edi
  8005ec:	e9 ea 00 00 00       	jmp    8006db <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  8005f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f4:	8b 50 04             	mov    0x4(%eax),%edx
  8005f7:	8b 00                	mov    (%eax),%eax
  8005f9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005fc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800602:	8d 40 08             	lea    0x8(%eax),%eax
  800605:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800608:	bf 0a 00 00 00       	mov    $0xa,%edi
  80060d:	e9 c9 00 00 00       	jmp    8006db <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  800612:	8b 45 14             	mov    0x14(%ebp),%eax
  800615:	8b 00                	mov    (%eax),%eax
  800617:	ba 00 00 00 00       	mov    $0x0,%edx
  80061c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80061f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800622:	8b 45 14             	mov    0x14(%ebp),%eax
  800625:	8d 40 04             	lea    0x4(%eax),%eax
  800628:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80062b:	bf 0a 00 00 00       	mov    $0xa,%edi
  800630:	e9 a6 00 00 00       	jmp    8006db <vprintfmt+0x403>
			putch('0', putdat);
  800635:	83 ec 08             	sub    $0x8,%esp
  800638:	53                   	push   %ebx
  800639:	6a 30                	push   $0x30
  80063b:	ff d6                	call   *%esi
	if (lflag >= 2)
  80063d:	83 c4 10             	add    $0x10,%esp
  800640:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800644:	7f 26                	jg     80066c <vprintfmt+0x394>
	else if (lflag)
  800646:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80064a:	74 3e                	je     80068a <vprintfmt+0x3b2>
		return va_arg(*ap, unsigned long);
  80064c:	8b 45 14             	mov    0x14(%ebp),%eax
  80064f:	8b 00                	mov    (%eax),%eax
  800651:	ba 00 00 00 00       	mov    $0x0,%edx
  800656:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800659:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80065c:	8b 45 14             	mov    0x14(%ebp),%eax
  80065f:	8d 40 04             	lea    0x4(%eax),%eax
  800662:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800665:	bf 08 00 00 00       	mov    $0x8,%edi
  80066a:	eb 6f                	jmp    8006db <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  80066c:	8b 45 14             	mov    0x14(%ebp),%eax
  80066f:	8b 50 04             	mov    0x4(%eax),%edx
  800672:	8b 00                	mov    (%eax),%eax
  800674:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800677:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80067a:	8b 45 14             	mov    0x14(%ebp),%eax
  80067d:	8d 40 08             	lea    0x8(%eax),%eax
  800680:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800683:	bf 08 00 00 00       	mov    $0x8,%edi
  800688:	eb 51                	jmp    8006db <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  80068a:	8b 45 14             	mov    0x14(%ebp),%eax
  80068d:	8b 00                	mov    (%eax),%eax
  80068f:	ba 00 00 00 00       	mov    $0x0,%edx
  800694:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800697:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80069a:	8b 45 14             	mov    0x14(%ebp),%eax
  80069d:	8d 40 04             	lea    0x4(%eax),%eax
  8006a0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006a3:	bf 08 00 00 00       	mov    $0x8,%edi
  8006a8:	eb 31                	jmp    8006db <vprintfmt+0x403>
			putch('0', putdat);
  8006aa:	83 ec 08             	sub    $0x8,%esp
  8006ad:	53                   	push   %ebx
  8006ae:	6a 30                	push   $0x30
  8006b0:	ff d6                	call   *%esi
			putch('x', putdat);
  8006b2:	83 c4 08             	add    $0x8,%esp
  8006b5:	53                   	push   %ebx
  8006b6:	6a 78                	push   $0x78
  8006b8:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bd:	8b 00                	mov    (%eax),%eax
  8006bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006c7:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8006ca:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d0:	8d 40 04             	lea    0x4(%eax),%eax
  8006d3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006d6:	bf 10 00 00 00       	mov    $0x10,%edi
			if(posflag)
  8006db:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006df:	74 0b                	je     8006ec <vprintfmt+0x414>
				putch('+', putdat);
  8006e1:	83 ec 08             	sub    $0x8,%esp
  8006e4:	53                   	push   %ebx
  8006e5:	6a 2b                	push   $0x2b
  8006e7:	ff d6                	call   *%esi
  8006e9:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  8006ec:	83 ec 0c             	sub    $0xc,%esp
  8006ef:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8006f3:	50                   	push   %eax
  8006f4:	ff 75 e0             	pushl  -0x20(%ebp)
  8006f7:	57                   	push   %edi
  8006f8:	ff 75 dc             	pushl  -0x24(%ebp)
  8006fb:	ff 75 d8             	pushl  -0x28(%ebp)
  8006fe:	89 da                	mov    %ebx,%edx
  800700:	89 f0                	mov    %esi,%eax
  800702:	e8 b8 fa ff ff       	call   8001bf <printnum>
			break;
  800707:	83 c4 20             	add    $0x20,%esp
			char* cp = va_arg(ap, char *);
  80070a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80070d:	83 c7 01             	add    $0x1,%edi
  800710:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800714:	83 f8 25             	cmp    $0x25,%eax
  800717:	0f 84 d2 fb ff ff    	je     8002ef <vprintfmt+0x17>
			if (ch == '\0')
  80071d:	85 c0                	test   %eax,%eax
  80071f:	0f 84 03 01 00 00    	je     800828 <vprintfmt+0x550>
			putch(ch, putdat);
  800725:	83 ec 08             	sub    $0x8,%esp
  800728:	53                   	push   %ebx
  800729:	50                   	push   %eax
  80072a:	ff d6                	call   *%esi
  80072c:	83 c4 10             	add    $0x10,%esp
  80072f:	eb dc                	jmp    80070d <vprintfmt+0x435>
	if (lflag >= 2)
  800731:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800735:	7f 29                	jg     800760 <vprintfmt+0x488>
	else if (lflag)
  800737:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80073b:	74 44                	je     800781 <vprintfmt+0x4a9>
		return va_arg(*ap, unsigned long);
  80073d:	8b 45 14             	mov    0x14(%ebp),%eax
  800740:	8b 00                	mov    (%eax),%eax
  800742:	ba 00 00 00 00       	mov    $0x0,%edx
  800747:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80074a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80074d:	8b 45 14             	mov    0x14(%ebp),%eax
  800750:	8d 40 04             	lea    0x4(%eax),%eax
  800753:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800756:	bf 10 00 00 00       	mov    $0x10,%edi
  80075b:	e9 7b ff ff ff       	jmp    8006db <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  800760:	8b 45 14             	mov    0x14(%ebp),%eax
  800763:	8b 50 04             	mov    0x4(%eax),%edx
  800766:	8b 00                	mov    (%eax),%eax
  800768:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80076b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80076e:	8b 45 14             	mov    0x14(%ebp),%eax
  800771:	8d 40 08             	lea    0x8(%eax),%eax
  800774:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800777:	bf 10 00 00 00       	mov    $0x10,%edi
  80077c:	e9 5a ff ff ff       	jmp    8006db <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  800781:	8b 45 14             	mov    0x14(%ebp),%eax
  800784:	8b 00                	mov    (%eax),%eax
  800786:	ba 00 00 00 00       	mov    $0x0,%edx
  80078b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80078e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800791:	8b 45 14             	mov    0x14(%ebp),%eax
  800794:	8d 40 04             	lea    0x4(%eax),%eax
  800797:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80079a:	bf 10 00 00 00       	mov    $0x10,%edi
  80079f:	e9 37 ff ff ff       	jmp    8006db <vprintfmt+0x403>
			char* cp = va_arg(ap, char *);
  8007a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a7:	8d 78 04             	lea    0x4(%eax),%edi
  8007aa:	8b 00                	mov    (%eax),%eax
    			if (cp == NULL) {
  8007ac:	85 c0                	test   %eax,%eax
  8007ae:	74 2c                	je     8007dc <vprintfmt+0x504>
    			*cp = *(int *)putdat;
  8007b0:	8b 13                	mov    (%ebx),%edx
  8007b2:	88 10                	mov    %dl,(%eax)
			char* cp = va_arg(ap, char *);
  8007b4:	89 7d 14             	mov    %edi,0x14(%ebp)
    			if ((*(int *) putdat) > 127)
  8007b7:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  8007ba:	0f 8e 4a ff ff ff    	jle    80070a <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", overflow_error);
  8007c0:	68 48 13 80 00       	push   $0x801348
  8007c5:	68 fa 11 80 00       	push   $0x8011fa
  8007ca:	53                   	push   %ebx
  8007cb:	56                   	push   %esi
  8007cc:	e8 ea fa ff ff       	call   8002bb <printfmt>
  8007d1:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  8007d4:	89 7d 14             	mov    %edi,0x14(%ebp)
  8007d7:	e9 2e ff ff ff       	jmp    80070a <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", null_error);
  8007dc:	68 10 13 80 00       	push   $0x801310
  8007e1:	68 fa 11 80 00       	push   $0x8011fa
  8007e6:	53                   	push   %ebx
  8007e7:	56                   	push   %esi
  8007e8:	e8 ce fa ff ff       	call   8002bb <printfmt>
        		break;
  8007ed:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  8007f0:	89 7d 14             	mov    %edi,0x14(%ebp)
        		break;
  8007f3:	e9 12 ff ff ff       	jmp    80070a <vprintfmt+0x432>
			putch(ch, putdat);
  8007f8:	83 ec 08             	sub    $0x8,%esp
  8007fb:	53                   	push   %ebx
  8007fc:	6a 25                	push   $0x25
  8007fe:	ff d6                	call   *%esi
			break;
  800800:	83 c4 10             	add    $0x10,%esp
  800803:	e9 02 ff ff ff       	jmp    80070a <vprintfmt+0x432>
			putch('%', putdat);
  800808:	83 ec 08             	sub    $0x8,%esp
  80080b:	53                   	push   %ebx
  80080c:	6a 25                	push   $0x25
  80080e:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800810:	83 c4 10             	add    $0x10,%esp
  800813:	89 f8                	mov    %edi,%eax
  800815:	eb 03                	jmp    80081a <vprintfmt+0x542>
  800817:	83 e8 01             	sub    $0x1,%eax
  80081a:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80081e:	75 f7                	jne    800817 <vprintfmt+0x53f>
  800820:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800823:	e9 e2 fe ff ff       	jmp    80070a <vprintfmt+0x432>
}
  800828:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80082b:	5b                   	pop    %ebx
  80082c:	5e                   	pop    %esi
  80082d:	5f                   	pop    %edi
  80082e:	5d                   	pop    %ebp
  80082f:	c3                   	ret    

00800830 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800830:	55                   	push   %ebp
  800831:	89 e5                	mov    %esp,%ebp
  800833:	83 ec 18             	sub    $0x18,%esp
  800836:	8b 45 08             	mov    0x8(%ebp),%eax
  800839:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80083c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80083f:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800843:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800846:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80084d:	85 c0                	test   %eax,%eax
  80084f:	74 26                	je     800877 <vsnprintf+0x47>
  800851:	85 d2                	test   %edx,%edx
  800853:	7e 22                	jle    800877 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800855:	ff 75 14             	pushl  0x14(%ebp)
  800858:	ff 75 10             	pushl  0x10(%ebp)
  80085b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80085e:	50                   	push   %eax
  80085f:	68 9e 02 80 00       	push   $0x80029e
  800864:	e8 6f fa ff ff       	call   8002d8 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800869:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80086c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80086f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800872:	83 c4 10             	add    $0x10,%esp
}
  800875:	c9                   	leave  
  800876:	c3                   	ret    
		return -E_INVAL;
  800877:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80087c:	eb f7                	jmp    800875 <vsnprintf+0x45>

0080087e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80087e:	55                   	push   %ebp
  80087f:	89 e5                	mov    %esp,%ebp
  800881:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800884:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800887:	50                   	push   %eax
  800888:	ff 75 10             	pushl  0x10(%ebp)
  80088b:	ff 75 0c             	pushl  0xc(%ebp)
  80088e:	ff 75 08             	pushl  0x8(%ebp)
  800891:	e8 9a ff ff ff       	call   800830 <vsnprintf>
	va_end(ap);

	return rc;
}
  800896:	c9                   	leave  
  800897:	c3                   	ret    

00800898 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800898:	55                   	push   %ebp
  800899:	89 e5                	mov    %esp,%ebp
  80089b:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80089e:	b8 00 00 00 00       	mov    $0x0,%eax
  8008a3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008a7:	74 05                	je     8008ae <strlen+0x16>
		n++;
  8008a9:	83 c0 01             	add    $0x1,%eax
  8008ac:	eb f5                	jmp    8008a3 <strlen+0xb>
	return n;
}
  8008ae:	5d                   	pop    %ebp
  8008af:	c3                   	ret    

008008b0 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008b0:	55                   	push   %ebp
  8008b1:	89 e5                	mov    %esp,%ebp
  8008b3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008b6:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8008be:	39 c2                	cmp    %eax,%edx
  8008c0:	74 0d                	je     8008cf <strnlen+0x1f>
  8008c2:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8008c6:	74 05                	je     8008cd <strnlen+0x1d>
		n++;
  8008c8:	83 c2 01             	add    $0x1,%edx
  8008cb:	eb f1                	jmp    8008be <strnlen+0xe>
  8008cd:	89 d0                	mov    %edx,%eax
	return n;
}
  8008cf:	5d                   	pop    %ebp
  8008d0:	c3                   	ret    

008008d1 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008d1:	55                   	push   %ebp
  8008d2:	89 e5                	mov    %esp,%ebp
  8008d4:	53                   	push   %ebx
  8008d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008db:	ba 00 00 00 00       	mov    $0x0,%edx
  8008e0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8008e4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8008e7:	83 c2 01             	add    $0x1,%edx
  8008ea:	84 c9                	test   %cl,%cl
  8008ec:	75 f2                	jne    8008e0 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8008ee:	5b                   	pop    %ebx
  8008ef:	5d                   	pop    %ebp
  8008f0:	c3                   	ret    

008008f1 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008f1:	55                   	push   %ebp
  8008f2:	89 e5                	mov    %esp,%ebp
  8008f4:	53                   	push   %ebx
  8008f5:	83 ec 10             	sub    $0x10,%esp
  8008f8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008fb:	53                   	push   %ebx
  8008fc:	e8 97 ff ff ff       	call   800898 <strlen>
  800901:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800904:	ff 75 0c             	pushl  0xc(%ebp)
  800907:	01 d8                	add    %ebx,%eax
  800909:	50                   	push   %eax
  80090a:	e8 c2 ff ff ff       	call   8008d1 <strcpy>
	return dst;
}
  80090f:	89 d8                	mov    %ebx,%eax
  800911:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800914:	c9                   	leave  
  800915:	c3                   	ret    

00800916 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800916:	55                   	push   %ebp
  800917:	89 e5                	mov    %esp,%ebp
  800919:	56                   	push   %esi
  80091a:	53                   	push   %ebx
  80091b:	8b 45 08             	mov    0x8(%ebp),%eax
  80091e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800921:	89 c6                	mov    %eax,%esi
  800923:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800926:	89 c2                	mov    %eax,%edx
  800928:	39 f2                	cmp    %esi,%edx
  80092a:	74 11                	je     80093d <strncpy+0x27>
		*dst++ = *src;
  80092c:	83 c2 01             	add    $0x1,%edx
  80092f:	0f b6 19             	movzbl (%ecx),%ebx
  800932:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800935:	80 fb 01             	cmp    $0x1,%bl
  800938:	83 d9 ff             	sbb    $0xffffffff,%ecx
  80093b:	eb eb                	jmp    800928 <strncpy+0x12>
	}
	return ret;
}
  80093d:	5b                   	pop    %ebx
  80093e:	5e                   	pop    %esi
  80093f:	5d                   	pop    %ebp
  800940:	c3                   	ret    

00800941 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800941:	55                   	push   %ebp
  800942:	89 e5                	mov    %esp,%ebp
  800944:	56                   	push   %esi
  800945:	53                   	push   %ebx
  800946:	8b 75 08             	mov    0x8(%ebp),%esi
  800949:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80094c:	8b 55 10             	mov    0x10(%ebp),%edx
  80094f:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800951:	85 d2                	test   %edx,%edx
  800953:	74 21                	je     800976 <strlcpy+0x35>
  800955:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800959:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80095b:	39 c2                	cmp    %eax,%edx
  80095d:	74 14                	je     800973 <strlcpy+0x32>
  80095f:	0f b6 19             	movzbl (%ecx),%ebx
  800962:	84 db                	test   %bl,%bl
  800964:	74 0b                	je     800971 <strlcpy+0x30>
			*dst++ = *src++;
  800966:	83 c1 01             	add    $0x1,%ecx
  800969:	83 c2 01             	add    $0x1,%edx
  80096c:	88 5a ff             	mov    %bl,-0x1(%edx)
  80096f:	eb ea                	jmp    80095b <strlcpy+0x1a>
  800971:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800973:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800976:	29 f0                	sub    %esi,%eax
}
  800978:	5b                   	pop    %ebx
  800979:	5e                   	pop    %esi
  80097a:	5d                   	pop    %ebp
  80097b:	c3                   	ret    

0080097c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80097c:	55                   	push   %ebp
  80097d:	89 e5                	mov    %esp,%ebp
  80097f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800982:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800985:	0f b6 01             	movzbl (%ecx),%eax
  800988:	84 c0                	test   %al,%al
  80098a:	74 0c                	je     800998 <strcmp+0x1c>
  80098c:	3a 02                	cmp    (%edx),%al
  80098e:	75 08                	jne    800998 <strcmp+0x1c>
		p++, q++;
  800990:	83 c1 01             	add    $0x1,%ecx
  800993:	83 c2 01             	add    $0x1,%edx
  800996:	eb ed                	jmp    800985 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800998:	0f b6 c0             	movzbl %al,%eax
  80099b:	0f b6 12             	movzbl (%edx),%edx
  80099e:	29 d0                	sub    %edx,%eax
}
  8009a0:	5d                   	pop    %ebp
  8009a1:	c3                   	ret    

008009a2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009a2:	55                   	push   %ebp
  8009a3:	89 e5                	mov    %esp,%ebp
  8009a5:	53                   	push   %ebx
  8009a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ac:	89 c3                	mov    %eax,%ebx
  8009ae:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009b1:	eb 06                	jmp    8009b9 <strncmp+0x17>
		n--, p++, q++;
  8009b3:	83 c0 01             	add    $0x1,%eax
  8009b6:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009b9:	39 d8                	cmp    %ebx,%eax
  8009bb:	74 16                	je     8009d3 <strncmp+0x31>
  8009bd:	0f b6 08             	movzbl (%eax),%ecx
  8009c0:	84 c9                	test   %cl,%cl
  8009c2:	74 04                	je     8009c8 <strncmp+0x26>
  8009c4:	3a 0a                	cmp    (%edx),%cl
  8009c6:	74 eb                	je     8009b3 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009c8:	0f b6 00             	movzbl (%eax),%eax
  8009cb:	0f b6 12             	movzbl (%edx),%edx
  8009ce:	29 d0                	sub    %edx,%eax
}
  8009d0:	5b                   	pop    %ebx
  8009d1:	5d                   	pop    %ebp
  8009d2:	c3                   	ret    
		return 0;
  8009d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8009d8:	eb f6                	jmp    8009d0 <strncmp+0x2e>

008009da <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009da:	55                   	push   %ebp
  8009db:	89 e5                	mov    %esp,%ebp
  8009dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009e4:	0f b6 10             	movzbl (%eax),%edx
  8009e7:	84 d2                	test   %dl,%dl
  8009e9:	74 09                	je     8009f4 <strchr+0x1a>
		if (*s == c)
  8009eb:	38 ca                	cmp    %cl,%dl
  8009ed:	74 0a                	je     8009f9 <strchr+0x1f>
	for (; *s; s++)
  8009ef:	83 c0 01             	add    $0x1,%eax
  8009f2:	eb f0                	jmp    8009e4 <strchr+0xa>
			return (char *) s;
	return 0;
  8009f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009f9:	5d                   	pop    %ebp
  8009fa:	c3                   	ret    

008009fb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009fb:	55                   	push   %ebp
  8009fc:	89 e5                	mov    %esp,%ebp
  8009fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800a01:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a05:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a08:	38 ca                	cmp    %cl,%dl
  800a0a:	74 09                	je     800a15 <strfind+0x1a>
  800a0c:	84 d2                	test   %dl,%dl
  800a0e:	74 05                	je     800a15 <strfind+0x1a>
	for (; *s; s++)
  800a10:	83 c0 01             	add    $0x1,%eax
  800a13:	eb f0                	jmp    800a05 <strfind+0xa>
			break;
	return (char *) s;
}
  800a15:	5d                   	pop    %ebp
  800a16:	c3                   	ret    

00800a17 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a17:	55                   	push   %ebp
  800a18:	89 e5                	mov    %esp,%ebp
  800a1a:	57                   	push   %edi
  800a1b:	56                   	push   %esi
  800a1c:	53                   	push   %ebx
  800a1d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a20:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a23:	85 c9                	test   %ecx,%ecx
  800a25:	74 31                	je     800a58 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a27:	89 f8                	mov    %edi,%eax
  800a29:	09 c8                	or     %ecx,%eax
  800a2b:	a8 03                	test   $0x3,%al
  800a2d:	75 23                	jne    800a52 <memset+0x3b>
		c &= 0xFF;
  800a2f:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a33:	89 d3                	mov    %edx,%ebx
  800a35:	c1 e3 08             	shl    $0x8,%ebx
  800a38:	89 d0                	mov    %edx,%eax
  800a3a:	c1 e0 18             	shl    $0x18,%eax
  800a3d:	89 d6                	mov    %edx,%esi
  800a3f:	c1 e6 10             	shl    $0x10,%esi
  800a42:	09 f0                	or     %esi,%eax
  800a44:	09 c2                	or     %eax,%edx
  800a46:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a48:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a4b:	89 d0                	mov    %edx,%eax
  800a4d:	fc                   	cld    
  800a4e:	f3 ab                	rep stos %eax,%es:(%edi)
  800a50:	eb 06                	jmp    800a58 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a55:	fc                   	cld    
  800a56:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a58:	89 f8                	mov    %edi,%eax
  800a5a:	5b                   	pop    %ebx
  800a5b:	5e                   	pop    %esi
  800a5c:	5f                   	pop    %edi
  800a5d:	5d                   	pop    %ebp
  800a5e:	c3                   	ret    

00800a5f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a5f:	55                   	push   %ebp
  800a60:	89 e5                	mov    %esp,%ebp
  800a62:	57                   	push   %edi
  800a63:	56                   	push   %esi
  800a64:	8b 45 08             	mov    0x8(%ebp),%eax
  800a67:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a6a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a6d:	39 c6                	cmp    %eax,%esi
  800a6f:	73 32                	jae    800aa3 <memmove+0x44>
  800a71:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a74:	39 c2                	cmp    %eax,%edx
  800a76:	76 2b                	jbe    800aa3 <memmove+0x44>
		s += n;
		d += n;
  800a78:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a7b:	89 fe                	mov    %edi,%esi
  800a7d:	09 ce                	or     %ecx,%esi
  800a7f:	09 d6                	or     %edx,%esi
  800a81:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a87:	75 0e                	jne    800a97 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a89:	83 ef 04             	sub    $0x4,%edi
  800a8c:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a8f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a92:	fd                   	std    
  800a93:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a95:	eb 09                	jmp    800aa0 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a97:	83 ef 01             	sub    $0x1,%edi
  800a9a:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a9d:	fd                   	std    
  800a9e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800aa0:	fc                   	cld    
  800aa1:	eb 1a                	jmp    800abd <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aa3:	89 c2                	mov    %eax,%edx
  800aa5:	09 ca                	or     %ecx,%edx
  800aa7:	09 f2                	or     %esi,%edx
  800aa9:	f6 c2 03             	test   $0x3,%dl
  800aac:	75 0a                	jne    800ab8 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800aae:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800ab1:	89 c7                	mov    %eax,%edi
  800ab3:	fc                   	cld    
  800ab4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ab6:	eb 05                	jmp    800abd <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800ab8:	89 c7                	mov    %eax,%edi
  800aba:	fc                   	cld    
  800abb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800abd:	5e                   	pop    %esi
  800abe:	5f                   	pop    %edi
  800abf:	5d                   	pop    %ebp
  800ac0:	c3                   	ret    

00800ac1 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ac1:	55                   	push   %ebp
  800ac2:	89 e5                	mov    %esp,%ebp
  800ac4:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ac7:	ff 75 10             	pushl  0x10(%ebp)
  800aca:	ff 75 0c             	pushl  0xc(%ebp)
  800acd:	ff 75 08             	pushl  0x8(%ebp)
  800ad0:	e8 8a ff ff ff       	call   800a5f <memmove>
}
  800ad5:	c9                   	leave  
  800ad6:	c3                   	ret    

00800ad7 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ad7:	55                   	push   %ebp
  800ad8:	89 e5                	mov    %esp,%ebp
  800ada:	56                   	push   %esi
  800adb:	53                   	push   %ebx
  800adc:	8b 45 08             	mov    0x8(%ebp),%eax
  800adf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ae2:	89 c6                	mov    %eax,%esi
  800ae4:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ae7:	39 f0                	cmp    %esi,%eax
  800ae9:	74 1c                	je     800b07 <memcmp+0x30>
		if (*s1 != *s2)
  800aeb:	0f b6 08             	movzbl (%eax),%ecx
  800aee:	0f b6 1a             	movzbl (%edx),%ebx
  800af1:	38 d9                	cmp    %bl,%cl
  800af3:	75 08                	jne    800afd <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800af5:	83 c0 01             	add    $0x1,%eax
  800af8:	83 c2 01             	add    $0x1,%edx
  800afb:	eb ea                	jmp    800ae7 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800afd:	0f b6 c1             	movzbl %cl,%eax
  800b00:	0f b6 db             	movzbl %bl,%ebx
  800b03:	29 d8                	sub    %ebx,%eax
  800b05:	eb 05                	jmp    800b0c <memcmp+0x35>
	}

	return 0;
  800b07:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b0c:	5b                   	pop    %ebx
  800b0d:	5e                   	pop    %esi
  800b0e:	5d                   	pop    %ebp
  800b0f:	c3                   	ret    

00800b10 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b10:	55                   	push   %ebp
  800b11:	89 e5                	mov    %esp,%ebp
  800b13:	8b 45 08             	mov    0x8(%ebp),%eax
  800b16:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b19:	89 c2                	mov    %eax,%edx
  800b1b:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b1e:	39 d0                	cmp    %edx,%eax
  800b20:	73 09                	jae    800b2b <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b22:	38 08                	cmp    %cl,(%eax)
  800b24:	74 05                	je     800b2b <memfind+0x1b>
	for (; s < ends; s++)
  800b26:	83 c0 01             	add    $0x1,%eax
  800b29:	eb f3                	jmp    800b1e <memfind+0xe>
			break;
	return (void *) s;
}
  800b2b:	5d                   	pop    %ebp
  800b2c:	c3                   	ret    

00800b2d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b2d:	55                   	push   %ebp
  800b2e:	89 e5                	mov    %esp,%ebp
  800b30:	57                   	push   %edi
  800b31:	56                   	push   %esi
  800b32:	53                   	push   %ebx
  800b33:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b36:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b39:	eb 03                	jmp    800b3e <strtol+0x11>
		s++;
  800b3b:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b3e:	0f b6 01             	movzbl (%ecx),%eax
  800b41:	3c 20                	cmp    $0x20,%al
  800b43:	74 f6                	je     800b3b <strtol+0xe>
  800b45:	3c 09                	cmp    $0x9,%al
  800b47:	74 f2                	je     800b3b <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b49:	3c 2b                	cmp    $0x2b,%al
  800b4b:	74 2a                	je     800b77 <strtol+0x4a>
	int neg = 0;
  800b4d:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b52:	3c 2d                	cmp    $0x2d,%al
  800b54:	74 2b                	je     800b81 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b56:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b5c:	75 0f                	jne    800b6d <strtol+0x40>
  800b5e:	80 39 30             	cmpb   $0x30,(%ecx)
  800b61:	74 28                	je     800b8b <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b63:	85 db                	test   %ebx,%ebx
  800b65:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b6a:	0f 44 d8             	cmove  %eax,%ebx
  800b6d:	b8 00 00 00 00       	mov    $0x0,%eax
  800b72:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b75:	eb 50                	jmp    800bc7 <strtol+0x9a>
		s++;
  800b77:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b7a:	bf 00 00 00 00       	mov    $0x0,%edi
  800b7f:	eb d5                	jmp    800b56 <strtol+0x29>
		s++, neg = 1;
  800b81:	83 c1 01             	add    $0x1,%ecx
  800b84:	bf 01 00 00 00       	mov    $0x1,%edi
  800b89:	eb cb                	jmp    800b56 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b8b:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b8f:	74 0e                	je     800b9f <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800b91:	85 db                	test   %ebx,%ebx
  800b93:	75 d8                	jne    800b6d <strtol+0x40>
		s++, base = 8;
  800b95:	83 c1 01             	add    $0x1,%ecx
  800b98:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b9d:	eb ce                	jmp    800b6d <strtol+0x40>
		s += 2, base = 16;
  800b9f:	83 c1 02             	add    $0x2,%ecx
  800ba2:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ba7:	eb c4                	jmp    800b6d <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800ba9:	8d 72 9f             	lea    -0x61(%edx),%esi
  800bac:	89 f3                	mov    %esi,%ebx
  800bae:	80 fb 19             	cmp    $0x19,%bl
  800bb1:	77 29                	ja     800bdc <strtol+0xaf>
			dig = *s - 'a' + 10;
  800bb3:	0f be d2             	movsbl %dl,%edx
  800bb6:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800bb9:	3b 55 10             	cmp    0x10(%ebp),%edx
  800bbc:	7d 30                	jge    800bee <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800bbe:	83 c1 01             	add    $0x1,%ecx
  800bc1:	0f af 45 10          	imul   0x10(%ebp),%eax
  800bc5:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800bc7:	0f b6 11             	movzbl (%ecx),%edx
  800bca:	8d 72 d0             	lea    -0x30(%edx),%esi
  800bcd:	89 f3                	mov    %esi,%ebx
  800bcf:	80 fb 09             	cmp    $0x9,%bl
  800bd2:	77 d5                	ja     800ba9 <strtol+0x7c>
			dig = *s - '0';
  800bd4:	0f be d2             	movsbl %dl,%edx
  800bd7:	83 ea 30             	sub    $0x30,%edx
  800bda:	eb dd                	jmp    800bb9 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800bdc:	8d 72 bf             	lea    -0x41(%edx),%esi
  800bdf:	89 f3                	mov    %esi,%ebx
  800be1:	80 fb 19             	cmp    $0x19,%bl
  800be4:	77 08                	ja     800bee <strtol+0xc1>
			dig = *s - 'A' + 10;
  800be6:	0f be d2             	movsbl %dl,%edx
  800be9:	83 ea 37             	sub    $0x37,%edx
  800bec:	eb cb                	jmp    800bb9 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800bee:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bf2:	74 05                	je     800bf9 <strtol+0xcc>
		*endptr = (char *) s;
  800bf4:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bf7:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800bf9:	89 c2                	mov    %eax,%edx
  800bfb:	f7 da                	neg    %edx
  800bfd:	85 ff                	test   %edi,%edi
  800bff:	0f 45 c2             	cmovne %edx,%eax
}
  800c02:	5b                   	pop    %ebx
  800c03:	5e                   	pop    %esi
  800c04:	5f                   	pop    %edi
  800c05:	5d                   	pop    %ebp
  800c06:	c3                   	ret    

00800c07 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c07:	55                   	push   %ebp
  800c08:	89 e5                	mov    %esp,%ebp
  800c0a:	57                   	push   %edi
  800c0b:	56                   	push   %esi
  800c0c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c0d:	b8 00 00 00 00       	mov    $0x0,%eax
  800c12:	8b 55 08             	mov    0x8(%ebp),%edx
  800c15:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c18:	89 c3                	mov    %eax,%ebx
  800c1a:	89 c7                	mov    %eax,%edi
  800c1c:	89 c6                	mov    %eax,%esi
  800c1e:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c20:	5b                   	pop    %ebx
  800c21:	5e                   	pop    %esi
  800c22:	5f                   	pop    %edi
  800c23:	5d                   	pop    %ebp
  800c24:	c3                   	ret    

00800c25 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c25:	55                   	push   %ebp
  800c26:	89 e5                	mov    %esp,%ebp
  800c28:	57                   	push   %edi
  800c29:	56                   	push   %esi
  800c2a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c2b:	ba 00 00 00 00       	mov    $0x0,%edx
  800c30:	b8 01 00 00 00       	mov    $0x1,%eax
  800c35:	89 d1                	mov    %edx,%ecx
  800c37:	89 d3                	mov    %edx,%ebx
  800c39:	89 d7                	mov    %edx,%edi
  800c3b:	89 d6                	mov    %edx,%esi
  800c3d:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c3f:	5b                   	pop    %ebx
  800c40:	5e                   	pop    %esi
  800c41:	5f                   	pop    %edi
  800c42:	5d                   	pop    %ebp
  800c43:	c3                   	ret    

00800c44 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c44:	55                   	push   %ebp
  800c45:	89 e5                	mov    %esp,%ebp
  800c47:	57                   	push   %edi
  800c48:	56                   	push   %esi
  800c49:	53                   	push   %ebx
  800c4a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c4d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c52:	8b 55 08             	mov    0x8(%ebp),%edx
  800c55:	b8 03 00 00 00       	mov    $0x3,%eax
  800c5a:	89 cb                	mov    %ecx,%ebx
  800c5c:	89 cf                	mov    %ecx,%edi
  800c5e:	89 ce                	mov    %ecx,%esi
  800c60:	cd 30                	int    $0x30
	if (check && ret > 0)
  800c62:	85 c0                	test   %eax,%eax
  800c64:	7f 08                	jg     800c6e <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c66:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c69:	5b                   	pop    %ebx
  800c6a:	5e                   	pop    %esi
  800c6b:	5f                   	pop    %edi
  800c6c:	5d                   	pop    %ebp
  800c6d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c6e:	83 ec 0c             	sub    $0xc,%esp
  800c71:	50                   	push   %eax
  800c72:	6a 03                	push   $0x3
  800c74:	68 60 15 80 00       	push   $0x801560
  800c79:	6a 4c                	push   $0x4c
  800c7b:	68 7d 15 80 00       	push   $0x80157d
  800c80:	e8 70 02 00 00       	call   800ef5 <_panic>

00800c85 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c85:	55                   	push   %ebp
  800c86:	89 e5                	mov    %esp,%ebp
  800c88:	57                   	push   %edi
  800c89:	56                   	push   %esi
  800c8a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c8b:	ba 00 00 00 00       	mov    $0x0,%edx
  800c90:	b8 02 00 00 00       	mov    $0x2,%eax
  800c95:	89 d1                	mov    %edx,%ecx
  800c97:	89 d3                	mov    %edx,%ebx
  800c99:	89 d7                	mov    %edx,%edi
  800c9b:	89 d6                	mov    %edx,%esi
  800c9d:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c9f:	5b                   	pop    %ebx
  800ca0:	5e                   	pop    %esi
  800ca1:	5f                   	pop    %edi
  800ca2:	5d                   	pop    %ebp
  800ca3:	c3                   	ret    

00800ca4 <sys_yield>:

void
sys_yield(void)
{
  800ca4:	55                   	push   %ebp
  800ca5:	89 e5                	mov    %esp,%ebp
  800ca7:	57                   	push   %edi
  800ca8:	56                   	push   %esi
  800ca9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800caa:	ba 00 00 00 00       	mov    $0x0,%edx
  800caf:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cb4:	89 d1                	mov    %edx,%ecx
  800cb6:	89 d3                	mov    %edx,%ebx
  800cb8:	89 d7                	mov    %edx,%edi
  800cba:	89 d6                	mov    %edx,%esi
  800cbc:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cbe:	5b                   	pop    %ebx
  800cbf:	5e                   	pop    %esi
  800cc0:	5f                   	pop    %edi
  800cc1:	5d                   	pop    %ebp
  800cc2:	c3                   	ret    

00800cc3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cc3:	55                   	push   %ebp
  800cc4:	89 e5                	mov    %esp,%ebp
  800cc6:	57                   	push   %edi
  800cc7:	56                   	push   %esi
  800cc8:	53                   	push   %ebx
  800cc9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ccc:	be 00 00 00 00       	mov    $0x0,%esi
  800cd1:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd7:	b8 04 00 00 00       	mov    $0x4,%eax
  800cdc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cdf:	89 f7                	mov    %esi,%edi
  800ce1:	cd 30                	int    $0x30
	if (check && ret > 0)
  800ce3:	85 c0                	test   %eax,%eax
  800ce5:	7f 08                	jg     800cef <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800ce7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cea:	5b                   	pop    %ebx
  800ceb:	5e                   	pop    %esi
  800cec:	5f                   	pop    %edi
  800ced:	5d                   	pop    %ebp
  800cee:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cef:	83 ec 0c             	sub    $0xc,%esp
  800cf2:	50                   	push   %eax
  800cf3:	6a 04                	push   $0x4
  800cf5:	68 60 15 80 00       	push   $0x801560
  800cfa:	6a 4c                	push   $0x4c
  800cfc:	68 7d 15 80 00       	push   $0x80157d
  800d01:	e8 ef 01 00 00       	call   800ef5 <_panic>

00800d06 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d06:	55                   	push   %ebp
  800d07:	89 e5                	mov    %esp,%ebp
  800d09:	57                   	push   %edi
  800d0a:	56                   	push   %esi
  800d0b:	53                   	push   %ebx
  800d0c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d0f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d12:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d15:	b8 05 00 00 00       	mov    $0x5,%eax
  800d1a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d1d:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d20:	8b 75 18             	mov    0x18(%ebp),%esi
  800d23:	cd 30                	int    $0x30
	if (check && ret > 0)
  800d25:	85 c0                	test   %eax,%eax
  800d27:	7f 08                	jg     800d31 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d29:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d2c:	5b                   	pop    %ebx
  800d2d:	5e                   	pop    %esi
  800d2e:	5f                   	pop    %edi
  800d2f:	5d                   	pop    %ebp
  800d30:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d31:	83 ec 0c             	sub    $0xc,%esp
  800d34:	50                   	push   %eax
  800d35:	6a 05                	push   $0x5
  800d37:	68 60 15 80 00       	push   $0x801560
  800d3c:	6a 4c                	push   $0x4c
  800d3e:	68 7d 15 80 00       	push   $0x80157d
  800d43:	e8 ad 01 00 00       	call   800ef5 <_panic>

00800d48 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d48:	55                   	push   %ebp
  800d49:	89 e5                	mov    %esp,%ebp
  800d4b:	57                   	push   %edi
  800d4c:	56                   	push   %esi
  800d4d:	53                   	push   %ebx
  800d4e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d51:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d56:	8b 55 08             	mov    0x8(%ebp),%edx
  800d59:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d5c:	b8 06 00 00 00       	mov    $0x6,%eax
  800d61:	89 df                	mov    %ebx,%edi
  800d63:	89 de                	mov    %ebx,%esi
  800d65:	cd 30                	int    $0x30
	if (check && ret > 0)
  800d67:	85 c0                	test   %eax,%eax
  800d69:	7f 08                	jg     800d73 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d6e:	5b                   	pop    %ebx
  800d6f:	5e                   	pop    %esi
  800d70:	5f                   	pop    %edi
  800d71:	5d                   	pop    %ebp
  800d72:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d73:	83 ec 0c             	sub    $0xc,%esp
  800d76:	50                   	push   %eax
  800d77:	6a 06                	push   $0x6
  800d79:	68 60 15 80 00       	push   $0x801560
  800d7e:	6a 4c                	push   $0x4c
  800d80:	68 7d 15 80 00       	push   $0x80157d
  800d85:	e8 6b 01 00 00       	call   800ef5 <_panic>

00800d8a <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d8a:	55                   	push   %ebp
  800d8b:	89 e5                	mov    %esp,%ebp
  800d8d:	57                   	push   %edi
  800d8e:	56                   	push   %esi
  800d8f:	53                   	push   %ebx
  800d90:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d93:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d98:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d9e:	b8 08 00 00 00       	mov    $0x8,%eax
  800da3:	89 df                	mov    %ebx,%edi
  800da5:	89 de                	mov    %ebx,%esi
  800da7:	cd 30                	int    $0x30
	if (check && ret > 0)
  800da9:	85 c0                	test   %eax,%eax
  800dab:	7f 08                	jg     800db5 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800dad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800db0:	5b                   	pop    %ebx
  800db1:	5e                   	pop    %esi
  800db2:	5f                   	pop    %edi
  800db3:	5d                   	pop    %ebp
  800db4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800db5:	83 ec 0c             	sub    $0xc,%esp
  800db8:	50                   	push   %eax
  800db9:	6a 08                	push   $0x8
  800dbb:	68 60 15 80 00       	push   $0x801560
  800dc0:	6a 4c                	push   $0x4c
  800dc2:	68 7d 15 80 00       	push   $0x80157d
  800dc7:	e8 29 01 00 00       	call   800ef5 <_panic>

00800dcc <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800dcc:	55                   	push   %ebp
  800dcd:	89 e5                	mov    %esp,%ebp
  800dcf:	57                   	push   %edi
  800dd0:	56                   	push   %esi
  800dd1:	53                   	push   %ebx
  800dd2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dd5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dda:	8b 55 08             	mov    0x8(%ebp),%edx
  800ddd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de0:	b8 09 00 00 00       	mov    $0x9,%eax
  800de5:	89 df                	mov    %ebx,%edi
  800de7:	89 de                	mov    %ebx,%esi
  800de9:	cd 30                	int    $0x30
	if (check && ret > 0)
  800deb:	85 c0                	test   %eax,%eax
  800ded:	7f 08                	jg     800df7 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800def:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800df2:	5b                   	pop    %ebx
  800df3:	5e                   	pop    %esi
  800df4:	5f                   	pop    %edi
  800df5:	5d                   	pop    %ebp
  800df6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800df7:	83 ec 0c             	sub    $0xc,%esp
  800dfa:	50                   	push   %eax
  800dfb:	6a 09                	push   $0x9
  800dfd:	68 60 15 80 00       	push   $0x801560
  800e02:	6a 4c                	push   $0x4c
  800e04:	68 7d 15 80 00       	push   $0x80157d
  800e09:	e8 e7 00 00 00       	call   800ef5 <_panic>

00800e0e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e0e:	55                   	push   %ebp
  800e0f:	89 e5                	mov    %esp,%ebp
  800e11:	57                   	push   %edi
  800e12:	56                   	push   %esi
  800e13:	53                   	push   %ebx
  800e14:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e17:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e1c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e22:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e27:	89 df                	mov    %ebx,%edi
  800e29:	89 de                	mov    %ebx,%esi
  800e2b:	cd 30                	int    $0x30
	if (check && ret > 0)
  800e2d:	85 c0                	test   %eax,%eax
  800e2f:	7f 08                	jg     800e39 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e31:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e34:	5b                   	pop    %ebx
  800e35:	5e                   	pop    %esi
  800e36:	5f                   	pop    %edi
  800e37:	5d                   	pop    %ebp
  800e38:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e39:	83 ec 0c             	sub    $0xc,%esp
  800e3c:	50                   	push   %eax
  800e3d:	6a 0a                	push   $0xa
  800e3f:	68 60 15 80 00       	push   $0x801560
  800e44:	6a 4c                	push   $0x4c
  800e46:	68 7d 15 80 00       	push   $0x80157d
  800e4b:	e8 a5 00 00 00       	call   800ef5 <_panic>

00800e50 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e50:	55                   	push   %ebp
  800e51:	89 e5                	mov    %esp,%ebp
  800e53:	57                   	push   %edi
  800e54:	56                   	push   %esi
  800e55:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e56:	8b 55 08             	mov    0x8(%ebp),%edx
  800e59:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e5c:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e61:	be 00 00 00 00       	mov    $0x0,%esi
  800e66:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e69:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e6c:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e6e:	5b                   	pop    %ebx
  800e6f:	5e                   	pop    %esi
  800e70:	5f                   	pop    %edi
  800e71:	5d                   	pop    %ebp
  800e72:	c3                   	ret    

00800e73 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e73:	55                   	push   %ebp
  800e74:	89 e5                	mov    %esp,%ebp
  800e76:	57                   	push   %edi
  800e77:	56                   	push   %esi
  800e78:	53                   	push   %ebx
  800e79:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e7c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e81:	8b 55 08             	mov    0x8(%ebp),%edx
  800e84:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e89:	89 cb                	mov    %ecx,%ebx
  800e8b:	89 cf                	mov    %ecx,%edi
  800e8d:	89 ce                	mov    %ecx,%esi
  800e8f:	cd 30                	int    $0x30
	if (check && ret > 0)
  800e91:	85 c0                	test   %eax,%eax
  800e93:	7f 08                	jg     800e9d <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e95:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e98:	5b                   	pop    %ebx
  800e99:	5e                   	pop    %esi
  800e9a:	5f                   	pop    %edi
  800e9b:	5d                   	pop    %ebp
  800e9c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e9d:	83 ec 0c             	sub    $0xc,%esp
  800ea0:	50                   	push   %eax
  800ea1:	6a 0d                	push   $0xd
  800ea3:	68 60 15 80 00       	push   $0x801560
  800ea8:	6a 4c                	push   $0x4c
  800eaa:	68 7d 15 80 00       	push   $0x80157d
  800eaf:	e8 41 00 00 00       	call   800ef5 <_panic>

00800eb4 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800eb4:	55                   	push   %ebp
  800eb5:	89 e5                	mov    %esp,%ebp
  800eb7:	57                   	push   %edi
  800eb8:	56                   	push   %esi
  800eb9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800eba:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ebf:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec5:	b8 0e 00 00 00       	mov    $0xe,%eax
  800eca:	89 df                	mov    %ebx,%edi
  800ecc:	89 de                	mov    %ebx,%esi
  800ece:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800ed0:	5b                   	pop    %ebx
  800ed1:	5e                   	pop    %esi
  800ed2:	5f                   	pop    %edi
  800ed3:	5d                   	pop    %ebp
  800ed4:	c3                   	ret    

00800ed5 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800ed5:	55                   	push   %ebp
  800ed6:	89 e5                	mov    %esp,%ebp
  800ed8:	57                   	push   %edi
  800ed9:	56                   	push   %esi
  800eda:	53                   	push   %ebx
	asm volatile("int %1\n"
  800edb:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ee0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee3:	b8 0f 00 00 00       	mov    $0xf,%eax
  800ee8:	89 cb                	mov    %ecx,%ebx
  800eea:	89 cf                	mov    %ecx,%edi
  800eec:	89 ce                	mov    %ecx,%esi
  800eee:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800ef0:	5b                   	pop    %ebx
  800ef1:	5e                   	pop    %esi
  800ef2:	5f                   	pop    %edi
  800ef3:	5d                   	pop    %ebp
  800ef4:	c3                   	ret    

00800ef5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800ef5:	55                   	push   %ebp
  800ef6:	89 e5                	mov    %esp,%ebp
  800ef8:	56                   	push   %esi
  800ef9:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800efa:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800efd:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800f03:	e8 7d fd ff ff       	call   800c85 <sys_getenvid>
  800f08:	83 ec 0c             	sub    $0xc,%esp
  800f0b:	ff 75 0c             	pushl  0xc(%ebp)
  800f0e:	ff 75 08             	pushl  0x8(%ebp)
  800f11:	56                   	push   %esi
  800f12:	50                   	push   %eax
  800f13:	68 8c 15 80 00       	push   $0x80158c
  800f18:	e8 8e f2 ff ff       	call   8001ab <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800f1d:	83 c4 18             	add    $0x18,%esp
  800f20:	53                   	push   %ebx
  800f21:	ff 75 10             	pushl  0x10(%ebp)
  800f24:	e8 31 f2 ff ff       	call   80015a <vcprintf>
	cprintf("\n");
  800f29:	c7 04 24 cd 11 80 00 	movl   $0x8011cd,(%esp)
  800f30:	e8 76 f2 ff ff       	call   8001ab <cprintf>
  800f35:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800f38:	cc                   	int3   
  800f39:	eb fd                	jmp    800f38 <_panic+0x43>
  800f3b:	66 90                	xchg   %ax,%ax
  800f3d:	66 90                	xchg   %ax,%ax
  800f3f:	90                   	nop

00800f40 <__udivdi3>:
  800f40:	55                   	push   %ebp
  800f41:	57                   	push   %edi
  800f42:	56                   	push   %esi
  800f43:	53                   	push   %ebx
  800f44:	83 ec 1c             	sub    $0x1c,%esp
  800f47:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800f4b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800f4f:	8b 74 24 34          	mov    0x34(%esp),%esi
  800f53:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800f57:	85 d2                	test   %edx,%edx
  800f59:	75 4d                	jne    800fa8 <__udivdi3+0x68>
  800f5b:	39 f3                	cmp    %esi,%ebx
  800f5d:	76 19                	jbe    800f78 <__udivdi3+0x38>
  800f5f:	31 ff                	xor    %edi,%edi
  800f61:	89 e8                	mov    %ebp,%eax
  800f63:	89 f2                	mov    %esi,%edx
  800f65:	f7 f3                	div    %ebx
  800f67:	89 fa                	mov    %edi,%edx
  800f69:	83 c4 1c             	add    $0x1c,%esp
  800f6c:	5b                   	pop    %ebx
  800f6d:	5e                   	pop    %esi
  800f6e:	5f                   	pop    %edi
  800f6f:	5d                   	pop    %ebp
  800f70:	c3                   	ret    
  800f71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f78:	89 d9                	mov    %ebx,%ecx
  800f7a:	85 db                	test   %ebx,%ebx
  800f7c:	75 0b                	jne    800f89 <__udivdi3+0x49>
  800f7e:	b8 01 00 00 00       	mov    $0x1,%eax
  800f83:	31 d2                	xor    %edx,%edx
  800f85:	f7 f3                	div    %ebx
  800f87:	89 c1                	mov    %eax,%ecx
  800f89:	31 d2                	xor    %edx,%edx
  800f8b:	89 f0                	mov    %esi,%eax
  800f8d:	f7 f1                	div    %ecx
  800f8f:	89 c6                	mov    %eax,%esi
  800f91:	89 e8                	mov    %ebp,%eax
  800f93:	89 f7                	mov    %esi,%edi
  800f95:	f7 f1                	div    %ecx
  800f97:	89 fa                	mov    %edi,%edx
  800f99:	83 c4 1c             	add    $0x1c,%esp
  800f9c:	5b                   	pop    %ebx
  800f9d:	5e                   	pop    %esi
  800f9e:	5f                   	pop    %edi
  800f9f:	5d                   	pop    %ebp
  800fa0:	c3                   	ret    
  800fa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800fa8:	39 f2                	cmp    %esi,%edx
  800faa:	77 1c                	ja     800fc8 <__udivdi3+0x88>
  800fac:	0f bd fa             	bsr    %edx,%edi
  800faf:	83 f7 1f             	xor    $0x1f,%edi
  800fb2:	75 2c                	jne    800fe0 <__udivdi3+0xa0>
  800fb4:	39 f2                	cmp    %esi,%edx
  800fb6:	72 06                	jb     800fbe <__udivdi3+0x7e>
  800fb8:	31 c0                	xor    %eax,%eax
  800fba:	39 eb                	cmp    %ebp,%ebx
  800fbc:	77 a9                	ja     800f67 <__udivdi3+0x27>
  800fbe:	b8 01 00 00 00       	mov    $0x1,%eax
  800fc3:	eb a2                	jmp    800f67 <__udivdi3+0x27>
  800fc5:	8d 76 00             	lea    0x0(%esi),%esi
  800fc8:	31 ff                	xor    %edi,%edi
  800fca:	31 c0                	xor    %eax,%eax
  800fcc:	89 fa                	mov    %edi,%edx
  800fce:	83 c4 1c             	add    $0x1c,%esp
  800fd1:	5b                   	pop    %ebx
  800fd2:	5e                   	pop    %esi
  800fd3:	5f                   	pop    %edi
  800fd4:	5d                   	pop    %ebp
  800fd5:	c3                   	ret    
  800fd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800fdd:	8d 76 00             	lea    0x0(%esi),%esi
  800fe0:	89 f9                	mov    %edi,%ecx
  800fe2:	b8 20 00 00 00       	mov    $0x20,%eax
  800fe7:	29 f8                	sub    %edi,%eax
  800fe9:	d3 e2                	shl    %cl,%edx
  800feb:	89 54 24 08          	mov    %edx,0x8(%esp)
  800fef:	89 c1                	mov    %eax,%ecx
  800ff1:	89 da                	mov    %ebx,%edx
  800ff3:	d3 ea                	shr    %cl,%edx
  800ff5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800ff9:	09 d1                	or     %edx,%ecx
  800ffb:	89 f2                	mov    %esi,%edx
  800ffd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801001:	89 f9                	mov    %edi,%ecx
  801003:	d3 e3                	shl    %cl,%ebx
  801005:	89 c1                	mov    %eax,%ecx
  801007:	d3 ea                	shr    %cl,%edx
  801009:	89 f9                	mov    %edi,%ecx
  80100b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80100f:	89 eb                	mov    %ebp,%ebx
  801011:	d3 e6                	shl    %cl,%esi
  801013:	89 c1                	mov    %eax,%ecx
  801015:	d3 eb                	shr    %cl,%ebx
  801017:	09 de                	or     %ebx,%esi
  801019:	89 f0                	mov    %esi,%eax
  80101b:	f7 74 24 08          	divl   0x8(%esp)
  80101f:	89 d6                	mov    %edx,%esi
  801021:	89 c3                	mov    %eax,%ebx
  801023:	f7 64 24 0c          	mull   0xc(%esp)
  801027:	39 d6                	cmp    %edx,%esi
  801029:	72 15                	jb     801040 <__udivdi3+0x100>
  80102b:	89 f9                	mov    %edi,%ecx
  80102d:	d3 e5                	shl    %cl,%ebp
  80102f:	39 c5                	cmp    %eax,%ebp
  801031:	73 04                	jae    801037 <__udivdi3+0xf7>
  801033:	39 d6                	cmp    %edx,%esi
  801035:	74 09                	je     801040 <__udivdi3+0x100>
  801037:	89 d8                	mov    %ebx,%eax
  801039:	31 ff                	xor    %edi,%edi
  80103b:	e9 27 ff ff ff       	jmp    800f67 <__udivdi3+0x27>
  801040:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801043:	31 ff                	xor    %edi,%edi
  801045:	e9 1d ff ff ff       	jmp    800f67 <__udivdi3+0x27>
  80104a:	66 90                	xchg   %ax,%ax
  80104c:	66 90                	xchg   %ax,%ax
  80104e:	66 90                	xchg   %ax,%ax

00801050 <__umoddi3>:
  801050:	55                   	push   %ebp
  801051:	57                   	push   %edi
  801052:	56                   	push   %esi
  801053:	53                   	push   %ebx
  801054:	83 ec 1c             	sub    $0x1c,%esp
  801057:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80105b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80105f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801063:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801067:	89 da                	mov    %ebx,%edx
  801069:	85 c0                	test   %eax,%eax
  80106b:	75 43                	jne    8010b0 <__umoddi3+0x60>
  80106d:	39 df                	cmp    %ebx,%edi
  80106f:	76 17                	jbe    801088 <__umoddi3+0x38>
  801071:	89 f0                	mov    %esi,%eax
  801073:	f7 f7                	div    %edi
  801075:	89 d0                	mov    %edx,%eax
  801077:	31 d2                	xor    %edx,%edx
  801079:	83 c4 1c             	add    $0x1c,%esp
  80107c:	5b                   	pop    %ebx
  80107d:	5e                   	pop    %esi
  80107e:	5f                   	pop    %edi
  80107f:	5d                   	pop    %ebp
  801080:	c3                   	ret    
  801081:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801088:	89 fd                	mov    %edi,%ebp
  80108a:	85 ff                	test   %edi,%edi
  80108c:	75 0b                	jne    801099 <__umoddi3+0x49>
  80108e:	b8 01 00 00 00       	mov    $0x1,%eax
  801093:	31 d2                	xor    %edx,%edx
  801095:	f7 f7                	div    %edi
  801097:	89 c5                	mov    %eax,%ebp
  801099:	89 d8                	mov    %ebx,%eax
  80109b:	31 d2                	xor    %edx,%edx
  80109d:	f7 f5                	div    %ebp
  80109f:	89 f0                	mov    %esi,%eax
  8010a1:	f7 f5                	div    %ebp
  8010a3:	89 d0                	mov    %edx,%eax
  8010a5:	eb d0                	jmp    801077 <__umoddi3+0x27>
  8010a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8010ae:	66 90                	xchg   %ax,%ax
  8010b0:	89 f1                	mov    %esi,%ecx
  8010b2:	39 d8                	cmp    %ebx,%eax
  8010b4:	76 0a                	jbe    8010c0 <__umoddi3+0x70>
  8010b6:	89 f0                	mov    %esi,%eax
  8010b8:	83 c4 1c             	add    $0x1c,%esp
  8010bb:	5b                   	pop    %ebx
  8010bc:	5e                   	pop    %esi
  8010bd:	5f                   	pop    %edi
  8010be:	5d                   	pop    %ebp
  8010bf:	c3                   	ret    
  8010c0:	0f bd e8             	bsr    %eax,%ebp
  8010c3:	83 f5 1f             	xor    $0x1f,%ebp
  8010c6:	75 20                	jne    8010e8 <__umoddi3+0x98>
  8010c8:	39 d8                	cmp    %ebx,%eax
  8010ca:	0f 82 b0 00 00 00    	jb     801180 <__umoddi3+0x130>
  8010d0:	39 f7                	cmp    %esi,%edi
  8010d2:	0f 86 a8 00 00 00    	jbe    801180 <__umoddi3+0x130>
  8010d8:	89 c8                	mov    %ecx,%eax
  8010da:	83 c4 1c             	add    $0x1c,%esp
  8010dd:	5b                   	pop    %ebx
  8010de:	5e                   	pop    %esi
  8010df:	5f                   	pop    %edi
  8010e0:	5d                   	pop    %ebp
  8010e1:	c3                   	ret    
  8010e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8010e8:	89 e9                	mov    %ebp,%ecx
  8010ea:	ba 20 00 00 00       	mov    $0x20,%edx
  8010ef:	29 ea                	sub    %ebp,%edx
  8010f1:	d3 e0                	shl    %cl,%eax
  8010f3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8010f7:	89 d1                	mov    %edx,%ecx
  8010f9:	89 f8                	mov    %edi,%eax
  8010fb:	d3 e8                	shr    %cl,%eax
  8010fd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801101:	89 54 24 04          	mov    %edx,0x4(%esp)
  801105:	8b 54 24 04          	mov    0x4(%esp),%edx
  801109:	09 c1                	or     %eax,%ecx
  80110b:	89 d8                	mov    %ebx,%eax
  80110d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801111:	89 e9                	mov    %ebp,%ecx
  801113:	d3 e7                	shl    %cl,%edi
  801115:	89 d1                	mov    %edx,%ecx
  801117:	d3 e8                	shr    %cl,%eax
  801119:	89 e9                	mov    %ebp,%ecx
  80111b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80111f:	d3 e3                	shl    %cl,%ebx
  801121:	89 c7                	mov    %eax,%edi
  801123:	89 d1                	mov    %edx,%ecx
  801125:	89 f0                	mov    %esi,%eax
  801127:	d3 e8                	shr    %cl,%eax
  801129:	89 e9                	mov    %ebp,%ecx
  80112b:	89 fa                	mov    %edi,%edx
  80112d:	d3 e6                	shl    %cl,%esi
  80112f:	09 d8                	or     %ebx,%eax
  801131:	f7 74 24 08          	divl   0x8(%esp)
  801135:	89 d1                	mov    %edx,%ecx
  801137:	89 f3                	mov    %esi,%ebx
  801139:	f7 64 24 0c          	mull   0xc(%esp)
  80113d:	89 c6                	mov    %eax,%esi
  80113f:	89 d7                	mov    %edx,%edi
  801141:	39 d1                	cmp    %edx,%ecx
  801143:	72 06                	jb     80114b <__umoddi3+0xfb>
  801145:	75 10                	jne    801157 <__umoddi3+0x107>
  801147:	39 c3                	cmp    %eax,%ebx
  801149:	73 0c                	jae    801157 <__umoddi3+0x107>
  80114b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80114f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801153:	89 d7                	mov    %edx,%edi
  801155:	89 c6                	mov    %eax,%esi
  801157:	89 ca                	mov    %ecx,%edx
  801159:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80115e:	29 f3                	sub    %esi,%ebx
  801160:	19 fa                	sbb    %edi,%edx
  801162:	89 d0                	mov    %edx,%eax
  801164:	d3 e0                	shl    %cl,%eax
  801166:	89 e9                	mov    %ebp,%ecx
  801168:	d3 eb                	shr    %cl,%ebx
  80116a:	d3 ea                	shr    %cl,%edx
  80116c:	09 d8                	or     %ebx,%eax
  80116e:	83 c4 1c             	add    $0x1c,%esp
  801171:	5b                   	pop    %ebx
  801172:	5e                   	pop    %esi
  801173:	5f                   	pop    %edi
  801174:	5d                   	pop    %ebp
  801175:	c3                   	ret    
  801176:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80117d:	8d 76 00             	lea    0x0(%esi),%esi
  801180:	89 da                	mov    %ebx,%edx
  801182:	29 fe                	sub    %edi,%esi
  801184:	19 c2                	sbb    %eax,%edx
  801186:	89 f1                	mov    %esi,%ecx
  801188:	89 c8                	mov    %ecx,%eax
  80118a:	e9 4b ff ff ff       	jmp    8010da <__umoddi3+0x8a>
