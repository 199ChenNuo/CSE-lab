
obj/user/lsfd.debug:     file format elf32-i386


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
  80002c:	e8 e0 00 00 00       	call   800111 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <usage>:
#include <inc/lib.h>

void
usage(void)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 14             	sub    $0x14,%esp
	cprintf("usage: lsfd [-1]\n");
  800039:	68 00 22 80 00       	push   $0x802200
  80003e:	e8 be 01 00 00       	call   800201 <cprintf>
	exit();
  800043:	e8 12 01 00 00       	call   80015a <exit>
}
  800048:	83 c4 10             	add    $0x10,%esp
  80004b:	c9                   	leave  
  80004c:	c3                   	ret    

0080004d <umain>:

void
umain(int argc, char **argv)
{
  80004d:	55                   	push   %ebp
  80004e:	89 e5                	mov    %esp,%ebp
  800050:	57                   	push   %edi
  800051:	56                   	push   %esi
  800052:	53                   	push   %ebx
  800053:	81 ec b0 00 00 00    	sub    $0xb0,%esp
	int i, usefprint = 0;
	struct Stat st;
	struct Argstate args;

	argstart(&argc, argv, &args);
  800059:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  80005f:	50                   	push   %eax
  800060:	ff 75 0c             	pushl  0xc(%ebp)
  800063:	8d 45 08             	lea    0x8(%ebp),%eax
  800066:	50                   	push   %eax
  800067:	e8 df 0e 00 00       	call   800f4b <argstart>
	while ((i = argnext(&args)) >= 0)
  80006c:	83 c4 10             	add    $0x10,%esp
	int i, usefprint = 0;
  80006f:	bf 00 00 00 00       	mov    $0x0,%edi
	while ((i = argnext(&args)) >= 0)
  800074:	8d 9d 4c ff ff ff    	lea    -0xb4(%ebp),%ebx
		if (i == '1')
			usefprint = 1;
  80007a:	be 01 00 00 00       	mov    $0x1,%esi
	while ((i = argnext(&args)) >= 0)
  80007f:	83 ec 0c             	sub    $0xc,%esp
  800082:	53                   	push   %ebx
  800083:	e8 f3 0e 00 00       	call   800f7b <argnext>
  800088:	83 c4 10             	add    $0x10,%esp
  80008b:	85 c0                	test   %eax,%eax
  80008d:	78 10                	js     80009f <umain+0x52>
		if (i == '1')
  80008f:	83 f8 31             	cmp    $0x31,%eax
  800092:	75 04                	jne    800098 <umain+0x4b>
			usefprint = 1;
  800094:	89 f7                	mov    %esi,%edi
  800096:	eb e7                	jmp    80007f <umain+0x32>
		else
			usage();
  800098:	e8 96 ff ff ff       	call   800033 <usage>
  80009d:	eb e0                	jmp    80007f <umain+0x32>

	for (i = 0; i < 32; i++)
  80009f:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (fstat(i, &st) >= 0) {
  8000a4:	8d b5 5c ff ff ff    	lea    -0xa4(%ebp),%esi
  8000aa:	eb 26                	jmp    8000d2 <umain+0x85>
			if (usefprint)
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
  8000ac:	83 ec 08             	sub    $0x8,%esp
  8000af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000b2:	ff 70 04             	pushl  0x4(%eax)
  8000b5:	ff 75 dc             	pushl  -0x24(%ebp)
  8000b8:	ff 75 e0             	pushl  -0x20(%ebp)
  8000bb:	56                   	push   %esi
  8000bc:	53                   	push   %ebx
  8000bd:	68 14 22 80 00       	push   $0x802214
  8000c2:	e8 3a 01 00 00       	call   800201 <cprintf>
  8000c7:	83 c4 20             	add    $0x20,%esp
	for (i = 0; i < 32; i++)
  8000ca:	83 c3 01             	add    $0x1,%ebx
  8000cd:	83 fb 20             	cmp    $0x20,%ebx
  8000d0:	74 37                	je     800109 <umain+0xbc>
		if (fstat(i, &st) >= 0) {
  8000d2:	83 ec 08             	sub    $0x8,%esp
  8000d5:	56                   	push   %esi
  8000d6:	53                   	push   %ebx
  8000d7:	e8 9d 14 00 00       	call   801579 <fstat>
  8000dc:	83 c4 10             	add    $0x10,%esp
  8000df:	85 c0                	test   %eax,%eax
  8000e1:	78 e7                	js     8000ca <umain+0x7d>
			if (usefprint)
  8000e3:	85 ff                	test   %edi,%edi
  8000e5:	74 c5                	je     8000ac <umain+0x5f>
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
  8000e7:	83 ec 04             	sub    $0x4,%esp
  8000ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000ed:	ff 70 04             	pushl  0x4(%eax)
  8000f0:	ff 75 dc             	pushl  -0x24(%ebp)
  8000f3:	ff 75 e0             	pushl  -0x20(%ebp)
  8000f6:	56                   	push   %esi
  8000f7:	53                   	push   %ebx
  8000f8:	68 14 22 80 00       	push   $0x802214
  8000fd:	6a 01                	push   $0x1
  8000ff:	e8 42 18 00 00       	call   801946 <fprintf>
  800104:	83 c4 20             	add    $0x20,%esp
  800107:	eb c1                	jmp    8000ca <umain+0x7d>
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
		}
}
  800109:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80010c:	5b                   	pop    %ebx
  80010d:	5e                   	pop    %esi
  80010e:	5f                   	pop    %edi
  80010f:	5d                   	pop    %ebp
  800110:	c3                   	ret    

00800111 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800111:	55                   	push   %ebp
  800112:	89 e5                	mov    %esp,%ebp
  800114:	56                   	push   %esi
  800115:	53                   	push   %ebx
  800116:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800119:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	// thisenv = 0;
	thisenv = &(envs[ENVX(sys_getenvid())]);
  80011c:	e8 ba 0b 00 00       	call   800cdb <sys_getenvid>
  800121:	25 ff 03 00 00       	and    $0x3ff,%eax
  800126:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80012c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800131:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800136:	85 db                	test   %ebx,%ebx
  800138:	7e 07                	jle    800141 <libmain+0x30>
		binaryname = argv[0];
  80013a:	8b 06                	mov    (%esi),%eax
  80013c:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800141:	83 ec 08             	sub    $0x8,%esp
  800144:	56                   	push   %esi
  800145:	53                   	push   %ebx
  800146:	e8 02 ff ff ff       	call   80004d <umain>

	// exit gracefully
	exit();
  80014b:	e8 0a 00 00 00       	call   80015a <exit>
}
  800150:	83 c4 10             	add    $0x10,%esp
  800153:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800156:	5b                   	pop    %ebx
  800157:	5e                   	pop    %esi
  800158:	5d                   	pop    %ebp
  800159:	c3                   	ret    

0080015a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80015a:	55                   	push   %ebp
  80015b:	89 e5                	mov    %esp,%ebp
  80015d:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  800160:	6a 00                	push   $0x0
  800162:	e8 33 0b 00 00       	call   800c9a <sys_env_destroy>
}
  800167:	83 c4 10             	add    $0x10,%esp
  80016a:	c9                   	leave  
  80016b:	c3                   	ret    

0080016c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80016c:	55                   	push   %ebp
  80016d:	89 e5                	mov    %esp,%ebp
  80016f:	53                   	push   %ebx
  800170:	83 ec 04             	sub    $0x4,%esp
  800173:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800176:	8b 13                	mov    (%ebx),%edx
  800178:	8d 42 01             	lea    0x1(%edx),%eax
  80017b:	89 03                	mov    %eax,(%ebx)
  80017d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800180:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800184:	3d ff 00 00 00       	cmp    $0xff,%eax
  800189:	74 09                	je     800194 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80018b:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80018f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800192:	c9                   	leave  
  800193:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800194:	83 ec 08             	sub    $0x8,%esp
  800197:	68 ff 00 00 00       	push   $0xff
  80019c:	8d 43 08             	lea    0x8(%ebx),%eax
  80019f:	50                   	push   %eax
  8001a0:	e8 b8 0a 00 00       	call   800c5d <sys_cputs>
		b->idx = 0;
  8001a5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001ab:	83 c4 10             	add    $0x10,%esp
  8001ae:	eb db                	jmp    80018b <putch+0x1f>

008001b0 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001b0:	55                   	push   %ebp
  8001b1:	89 e5                	mov    %esp,%ebp
  8001b3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001b9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001c0:	00 00 00 
	b.cnt = 0;
  8001c3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001ca:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001cd:	ff 75 0c             	pushl  0xc(%ebp)
  8001d0:	ff 75 08             	pushl  0x8(%ebp)
  8001d3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001d9:	50                   	push   %eax
  8001da:	68 6c 01 80 00       	push   $0x80016c
  8001df:	e8 4a 01 00 00       	call   80032e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001e4:	83 c4 08             	add    $0x8,%esp
  8001e7:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001ed:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001f3:	50                   	push   %eax
  8001f4:	e8 64 0a 00 00       	call   800c5d <sys_cputs>

	return b.cnt;
}
  8001f9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001ff:	c9                   	leave  
  800200:	c3                   	ret    

00800201 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800201:	55                   	push   %ebp
  800202:	89 e5                	mov    %esp,%ebp
  800204:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800207:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80020a:	50                   	push   %eax
  80020b:	ff 75 08             	pushl  0x8(%ebp)
  80020e:	e8 9d ff ff ff       	call   8001b0 <vcprintf>
	va_end(ap);

	return cnt;
}
  800213:	c9                   	leave  
  800214:	c3                   	ret    

00800215 <printnum>:


static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800215:	55                   	push   %ebp
  800216:	89 e5                	mov    %esp,%ebp
  800218:	57                   	push   %edi
  800219:	56                   	push   %esi
  80021a:	53                   	push   %ebx
  80021b:	83 ec 1c             	sub    $0x1c,%esp
  80021e:	89 c6                	mov    %eax,%esi
  800220:	89 d7                	mov    %edx,%edi
  800222:	8b 45 08             	mov    0x8(%ebp),%eax
  800225:	8b 55 0c             	mov    0xc(%ebp),%edx
  800228:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80022b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80022e:	8b 45 10             	mov    0x10(%ebp),%eax
  800231:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	// to support '-'
	if(padc == '-'){
  800234:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800238:	74 2c                	je     800266 <printnum+0x51>
		while (--width > 0)
			putch(' ', putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80023a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80023d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800244:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800247:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80024a:	39 c2                	cmp    %eax,%edx
  80024c:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80024f:	73 43                	jae    800294 <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800251:	83 eb 01             	sub    $0x1,%ebx
  800254:	85 db                	test   %ebx,%ebx
  800256:	7e 6c                	jle    8002c4 <printnum+0xaf>
			putch(padc, putdat);
  800258:	83 ec 08             	sub    $0x8,%esp
  80025b:	57                   	push   %edi
  80025c:	ff 75 18             	pushl  0x18(%ebp)
  80025f:	ff d6                	call   *%esi
  800261:	83 c4 10             	add    $0x10,%esp
  800264:	eb eb                	jmp    800251 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800266:	83 ec 0c             	sub    $0xc,%esp
  800269:	6a 20                	push   $0x20
  80026b:	6a 00                	push   $0x0
  80026d:	50                   	push   %eax
  80026e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800271:	ff 75 e0             	pushl  -0x20(%ebp)
  800274:	89 fa                	mov    %edi,%edx
  800276:	89 f0                	mov    %esi,%eax
  800278:	e8 98 ff ff ff       	call   800215 <printnum>
		while (--width > 0)
  80027d:	83 c4 20             	add    $0x20,%esp
  800280:	83 eb 01             	sub    $0x1,%ebx
  800283:	85 db                	test   %ebx,%ebx
  800285:	7e 65                	jle    8002ec <printnum+0xd7>
			putch(' ', putdat);
  800287:	83 ec 08             	sub    $0x8,%esp
  80028a:	57                   	push   %edi
  80028b:	6a 20                	push   $0x20
  80028d:	ff d6                	call   *%esi
  80028f:	83 c4 10             	add    $0x10,%esp
  800292:	eb ec                	jmp    800280 <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800294:	83 ec 0c             	sub    $0xc,%esp
  800297:	ff 75 18             	pushl  0x18(%ebp)
  80029a:	83 eb 01             	sub    $0x1,%ebx
  80029d:	53                   	push   %ebx
  80029e:	50                   	push   %eax
  80029f:	83 ec 08             	sub    $0x8,%esp
  8002a2:	ff 75 dc             	pushl  -0x24(%ebp)
  8002a5:	ff 75 d8             	pushl  -0x28(%ebp)
  8002a8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002ab:	ff 75 e0             	pushl  -0x20(%ebp)
  8002ae:	e8 fd 1c 00 00       	call   801fb0 <__udivdi3>
  8002b3:	83 c4 18             	add    $0x18,%esp
  8002b6:	52                   	push   %edx
  8002b7:	50                   	push   %eax
  8002b8:	89 fa                	mov    %edi,%edx
  8002ba:	89 f0                	mov    %esi,%eax
  8002bc:	e8 54 ff ff ff       	call   800215 <printnum>
  8002c1:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002c4:	83 ec 08             	sub    $0x8,%esp
  8002c7:	57                   	push   %edi
  8002c8:	83 ec 04             	sub    $0x4,%esp
  8002cb:	ff 75 dc             	pushl  -0x24(%ebp)
  8002ce:	ff 75 d8             	pushl  -0x28(%ebp)
  8002d1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002d4:	ff 75 e0             	pushl  -0x20(%ebp)
  8002d7:	e8 e4 1d 00 00       	call   8020c0 <__umoddi3>
  8002dc:	83 c4 14             	add    $0x14,%esp
  8002df:	0f be 80 46 22 80 00 	movsbl 0x802246(%eax),%eax
  8002e6:	50                   	push   %eax
  8002e7:	ff d6                	call   *%esi
  8002e9:	83 c4 10             	add    $0x10,%esp
}
  8002ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002ef:	5b                   	pop    %ebx
  8002f0:	5e                   	pop    %esi
  8002f1:	5f                   	pop    %edi
  8002f2:	5d                   	pop    %ebp
  8002f3:	c3                   	ret    

008002f4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002f4:	55                   	push   %ebp
  8002f5:	89 e5                	mov    %esp,%ebp
  8002f7:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002fa:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002fe:	8b 10                	mov    (%eax),%edx
  800300:	3b 50 04             	cmp    0x4(%eax),%edx
  800303:	73 0a                	jae    80030f <sprintputch+0x1b>
		*b->buf++ = ch;
  800305:	8d 4a 01             	lea    0x1(%edx),%ecx
  800308:	89 08                	mov    %ecx,(%eax)
  80030a:	8b 45 08             	mov    0x8(%ebp),%eax
  80030d:	88 02                	mov    %al,(%edx)
}
  80030f:	5d                   	pop    %ebp
  800310:	c3                   	ret    

00800311 <printfmt>:
{
  800311:	55                   	push   %ebp
  800312:	89 e5                	mov    %esp,%ebp
  800314:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800317:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80031a:	50                   	push   %eax
  80031b:	ff 75 10             	pushl  0x10(%ebp)
  80031e:	ff 75 0c             	pushl  0xc(%ebp)
  800321:	ff 75 08             	pushl  0x8(%ebp)
  800324:	e8 05 00 00 00       	call   80032e <vprintfmt>
}
  800329:	83 c4 10             	add    $0x10,%esp
  80032c:	c9                   	leave  
  80032d:	c3                   	ret    

0080032e <vprintfmt>:
{
  80032e:	55                   	push   %ebp
  80032f:	89 e5                	mov    %esp,%ebp
  800331:	57                   	push   %edi
  800332:	56                   	push   %esi
  800333:	53                   	push   %ebx
  800334:	83 ec 3c             	sub    $0x3c,%esp
  800337:	8b 75 08             	mov    0x8(%ebp),%esi
  80033a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80033d:	8b 7d 10             	mov    0x10(%ebp),%edi
  800340:	e9 1e 04 00 00       	jmp    800763 <vprintfmt+0x435>
		posflag = 0;
  800345:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
		padc = ' ';
  80034c:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800350:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800357:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80035e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800365:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  80036c:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800371:	8d 47 01             	lea    0x1(%edi),%eax
  800374:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800377:	0f b6 17             	movzbl (%edi),%edx
  80037a:	8d 42 dd             	lea    -0x23(%edx),%eax
  80037d:	3c 55                	cmp    $0x55,%al
  80037f:	0f 87 d9 04 00 00    	ja     80085e <vprintfmt+0x530>
  800385:	0f b6 c0             	movzbl %al,%eax
  800388:	ff 24 85 20 24 80 00 	jmp    *0x802420(,%eax,4)
  80038f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800392:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800396:	eb d9                	jmp    800371 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800398:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posflag = 1;
  80039b:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  8003a2:	eb cd                	jmp    800371 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003a4:	0f b6 d2             	movzbl %dl,%edx
  8003a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8003af:	89 75 08             	mov    %esi,0x8(%ebp)
  8003b2:	eb 0c                	jmp    8003c0 <vprintfmt+0x92>
		switch (ch = *(unsigned char *) fmt++) {
  8003b4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003b7:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  8003bb:	eb b4                	jmp    800371 <vprintfmt+0x43>
			for (precision = 0; ; ++fmt) {
  8003bd:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003c0:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003c3:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003c7:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003ca:	8d 72 d0             	lea    -0x30(%edx),%esi
  8003cd:	83 fe 09             	cmp    $0x9,%esi
  8003d0:	76 eb                	jbe    8003bd <vprintfmt+0x8f>
  8003d2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003d5:	8b 75 08             	mov    0x8(%ebp),%esi
  8003d8:	eb 14                	jmp    8003ee <vprintfmt+0xc0>
			precision = va_arg(ap, int);
  8003da:	8b 45 14             	mov    0x14(%ebp),%eax
  8003dd:	8b 00                	mov    (%eax),%eax
  8003df:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e5:	8d 40 04             	lea    0x4(%eax),%eax
  8003e8:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003eb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003ee:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003f2:	0f 89 79 ff ff ff    	jns    800371 <vprintfmt+0x43>
				width = precision, precision = -1;
  8003f8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003fe:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800405:	e9 67 ff ff ff       	jmp    800371 <vprintfmt+0x43>
  80040a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80040d:	85 c0                	test   %eax,%eax
  80040f:	0f 48 c1             	cmovs  %ecx,%eax
  800412:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800415:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800418:	e9 54 ff ff ff       	jmp    800371 <vprintfmt+0x43>
  80041d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800420:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800427:	e9 45 ff ff ff       	jmp    800371 <vprintfmt+0x43>
			lflag++;
  80042c:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800430:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800433:	e9 39 ff ff ff       	jmp    800371 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800438:	8b 45 14             	mov    0x14(%ebp),%eax
  80043b:	8d 78 04             	lea    0x4(%eax),%edi
  80043e:	83 ec 08             	sub    $0x8,%esp
  800441:	53                   	push   %ebx
  800442:	ff 30                	pushl  (%eax)
  800444:	ff d6                	call   *%esi
			break;
  800446:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800449:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80044c:	e9 0f 03 00 00       	jmp    800760 <vprintfmt+0x432>
			err = va_arg(ap, int);
  800451:	8b 45 14             	mov    0x14(%ebp),%eax
  800454:	8d 78 04             	lea    0x4(%eax),%edi
  800457:	8b 00                	mov    (%eax),%eax
  800459:	99                   	cltd   
  80045a:	31 d0                	xor    %edx,%eax
  80045c:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80045e:	83 f8 0f             	cmp    $0xf,%eax
  800461:	7f 23                	jg     800486 <vprintfmt+0x158>
  800463:	8b 14 85 80 25 80 00 	mov    0x802580(,%eax,4),%edx
  80046a:	85 d2                	test   %edx,%edx
  80046c:	74 18                	je     800486 <vprintfmt+0x158>
				printfmt(putch, putdat, "%s", p);
  80046e:	52                   	push   %edx
  80046f:	68 ba 26 80 00       	push   $0x8026ba
  800474:	53                   	push   %ebx
  800475:	56                   	push   %esi
  800476:	e8 96 fe ff ff       	call   800311 <printfmt>
  80047b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80047e:	89 7d 14             	mov    %edi,0x14(%ebp)
  800481:	e9 da 02 00 00       	jmp    800760 <vprintfmt+0x432>
				printfmt(putch, putdat, "error %d", err);
  800486:	50                   	push   %eax
  800487:	68 5e 22 80 00       	push   $0x80225e
  80048c:	53                   	push   %ebx
  80048d:	56                   	push   %esi
  80048e:	e8 7e fe ff ff       	call   800311 <printfmt>
  800493:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800496:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800499:	e9 c2 02 00 00       	jmp    800760 <vprintfmt+0x432>
			if ((p = va_arg(ap, char *)) == NULL)
  80049e:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a1:	83 c0 04             	add    $0x4,%eax
  8004a4:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8004a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004aa:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8004ac:	85 c9                	test   %ecx,%ecx
  8004ae:	b8 57 22 80 00       	mov    $0x802257,%eax
  8004b3:	0f 45 c1             	cmovne %ecx,%eax
  8004b6:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8004b9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004bd:	7e 06                	jle    8004c5 <vprintfmt+0x197>
  8004bf:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8004c3:	75 0d                	jne    8004d2 <vprintfmt+0x1a4>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004c5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004c8:	89 c7                	mov    %eax,%edi
  8004ca:	03 45 e0             	add    -0x20(%ebp),%eax
  8004cd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004d0:	eb 53                	jmp    800525 <vprintfmt+0x1f7>
  8004d2:	83 ec 08             	sub    $0x8,%esp
  8004d5:	ff 75 d8             	pushl  -0x28(%ebp)
  8004d8:	50                   	push   %eax
  8004d9:	e8 28 04 00 00       	call   800906 <strnlen>
  8004de:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004e1:	29 c1                	sub    %eax,%ecx
  8004e3:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  8004e6:	83 c4 10             	add    $0x10,%esp
  8004e9:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8004eb:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8004ef:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004f2:	eb 0f                	jmp    800503 <vprintfmt+0x1d5>
					putch(padc, putdat);
  8004f4:	83 ec 08             	sub    $0x8,%esp
  8004f7:	53                   	push   %ebx
  8004f8:	ff 75 e0             	pushl  -0x20(%ebp)
  8004fb:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004fd:	83 ef 01             	sub    $0x1,%edi
  800500:	83 c4 10             	add    $0x10,%esp
  800503:	85 ff                	test   %edi,%edi
  800505:	7f ed                	jg     8004f4 <vprintfmt+0x1c6>
  800507:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  80050a:	85 c9                	test   %ecx,%ecx
  80050c:	b8 00 00 00 00       	mov    $0x0,%eax
  800511:	0f 49 c1             	cmovns %ecx,%eax
  800514:	29 c1                	sub    %eax,%ecx
  800516:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800519:	eb aa                	jmp    8004c5 <vprintfmt+0x197>
					putch(ch, putdat);
  80051b:	83 ec 08             	sub    $0x8,%esp
  80051e:	53                   	push   %ebx
  80051f:	52                   	push   %edx
  800520:	ff d6                	call   *%esi
  800522:	83 c4 10             	add    $0x10,%esp
  800525:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800528:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80052a:	83 c7 01             	add    $0x1,%edi
  80052d:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800531:	0f be d0             	movsbl %al,%edx
  800534:	85 d2                	test   %edx,%edx
  800536:	74 4b                	je     800583 <vprintfmt+0x255>
  800538:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80053c:	78 06                	js     800544 <vprintfmt+0x216>
  80053e:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800542:	78 1e                	js     800562 <vprintfmt+0x234>
				if (altflag && (ch < ' ' || ch > '~'))
  800544:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800548:	74 d1                	je     80051b <vprintfmt+0x1ed>
  80054a:	0f be c0             	movsbl %al,%eax
  80054d:	83 e8 20             	sub    $0x20,%eax
  800550:	83 f8 5e             	cmp    $0x5e,%eax
  800553:	76 c6                	jbe    80051b <vprintfmt+0x1ed>
					putch('?', putdat);
  800555:	83 ec 08             	sub    $0x8,%esp
  800558:	53                   	push   %ebx
  800559:	6a 3f                	push   $0x3f
  80055b:	ff d6                	call   *%esi
  80055d:	83 c4 10             	add    $0x10,%esp
  800560:	eb c3                	jmp    800525 <vprintfmt+0x1f7>
  800562:	89 cf                	mov    %ecx,%edi
  800564:	eb 0e                	jmp    800574 <vprintfmt+0x246>
				putch(' ', putdat);
  800566:	83 ec 08             	sub    $0x8,%esp
  800569:	53                   	push   %ebx
  80056a:	6a 20                	push   $0x20
  80056c:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80056e:	83 ef 01             	sub    $0x1,%edi
  800571:	83 c4 10             	add    $0x10,%esp
  800574:	85 ff                	test   %edi,%edi
  800576:	7f ee                	jg     800566 <vprintfmt+0x238>
			if ((p = va_arg(ap, char *)) == NULL)
  800578:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80057b:	89 45 14             	mov    %eax,0x14(%ebp)
  80057e:	e9 dd 01 00 00       	jmp    800760 <vprintfmt+0x432>
  800583:	89 cf                	mov    %ecx,%edi
  800585:	eb ed                	jmp    800574 <vprintfmt+0x246>
	if (lflag >= 2)
  800587:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  80058b:	7f 21                	jg     8005ae <vprintfmt+0x280>
	else if (lflag)
  80058d:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800591:	74 6a                	je     8005fd <vprintfmt+0x2cf>
		return va_arg(*ap, long);
  800593:	8b 45 14             	mov    0x14(%ebp),%eax
  800596:	8b 00                	mov    (%eax),%eax
  800598:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80059b:	89 c1                	mov    %eax,%ecx
  80059d:	c1 f9 1f             	sar    $0x1f,%ecx
  8005a0:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a6:	8d 40 04             	lea    0x4(%eax),%eax
  8005a9:	89 45 14             	mov    %eax,0x14(%ebp)
  8005ac:	eb 17                	jmp    8005c5 <vprintfmt+0x297>
		return va_arg(*ap, long long);
  8005ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b1:	8b 50 04             	mov    0x4(%eax),%edx
  8005b4:	8b 00                	mov    (%eax),%eax
  8005b6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005b9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bf:	8d 40 08             	lea    0x8(%eax),%eax
  8005c2:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8005c5:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  8005c8:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  8005cd:	85 d2                	test   %edx,%edx
  8005cf:	0f 89 5c 01 00 00    	jns    800731 <vprintfmt+0x403>
				putch('-', putdat);
  8005d5:	83 ec 08             	sub    $0x8,%esp
  8005d8:	53                   	push   %ebx
  8005d9:	6a 2d                	push   $0x2d
  8005db:	ff d6                	call   *%esi
				num = -(long long) num;
  8005dd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005e0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8005e3:	f7 d8                	neg    %eax
  8005e5:	83 d2 00             	adc    $0x0,%edx
  8005e8:	f7 da                	neg    %edx
  8005ea:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ed:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005f0:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005f3:	bf 0a 00 00 00       	mov    $0xa,%edi
  8005f8:	e9 45 01 00 00       	jmp    800742 <vprintfmt+0x414>
		return va_arg(*ap, int);
  8005fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800600:	8b 00                	mov    (%eax),%eax
  800602:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800605:	89 c1                	mov    %eax,%ecx
  800607:	c1 f9 1f             	sar    $0x1f,%ecx
  80060a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80060d:	8b 45 14             	mov    0x14(%ebp),%eax
  800610:	8d 40 04             	lea    0x4(%eax),%eax
  800613:	89 45 14             	mov    %eax,0x14(%ebp)
  800616:	eb ad                	jmp    8005c5 <vprintfmt+0x297>
	if (lflag >= 2)
  800618:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  80061c:	7f 29                	jg     800647 <vprintfmt+0x319>
	else if (lflag)
  80061e:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800622:	74 44                	je     800668 <vprintfmt+0x33a>
		return va_arg(*ap, unsigned long);
  800624:	8b 45 14             	mov    0x14(%ebp),%eax
  800627:	8b 00                	mov    (%eax),%eax
  800629:	ba 00 00 00 00       	mov    $0x0,%edx
  80062e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800631:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800634:	8b 45 14             	mov    0x14(%ebp),%eax
  800637:	8d 40 04             	lea    0x4(%eax),%eax
  80063a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80063d:	bf 0a 00 00 00       	mov    $0xa,%edi
  800642:	e9 ea 00 00 00       	jmp    800731 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  800647:	8b 45 14             	mov    0x14(%ebp),%eax
  80064a:	8b 50 04             	mov    0x4(%eax),%edx
  80064d:	8b 00                	mov    (%eax),%eax
  80064f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800652:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800655:	8b 45 14             	mov    0x14(%ebp),%eax
  800658:	8d 40 08             	lea    0x8(%eax),%eax
  80065b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80065e:	bf 0a 00 00 00       	mov    $0xa,%edi
  800663:	e9 c9 00 00 00       	jmp    800731 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  800668:	8b 45 14             	mov    0x14(%ebp),%eax
  80066b:	8b 00                	mov    (%eax),%eax
  80066d:	ba 00 00 00 00       	mov    $0x0,%edx
  800672:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800675:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800678:	8b 45 14             	mov    0x14(%ebp),%eax
  80067b:	8d 40 04             	lea    0x4(%eax),%eax
  80067e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800681:	bf 0a 00 00 00       	mov    $0xa,%edi
  800686:	e9 a6 00 00 00       	jmp    800731 <vprintfmt+0x403>
			putch('0', putdat);
  80068b:	83 ec 08             	sub    $0x8,%esp
  80068e:	53                   	push   %ebx
  80068f:	6a 30                	push   $0x30
  800691:	ff d6                	call   *%esi
	if (lflag >= 2)
  800693:	83 c4 10             	add    $0x10,%esp
  800696:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  80069a:	7f 26                	jg     8006c2 <vprintfmt+0x394>
	else if (lflag)
  80069c:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8006a0:	74 3e                	je     8006e0 <vprintfmt+0x3b2>
		return va_arg(*ap, unsigned long);
  8006a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a5:	8b 00                	mov    (%eax),%eax
  8006a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ac:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006af:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b5:	8d 40 04             	lea    0x4(%eax),%eax
  8006b8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006bb:	bf 08 00 00 00       	mov    $0x8,%edi
  8006c0:	eb 6f                	jmp    800731 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  8006c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c5:	8b 50 04             	mov    0x4(%eax),%edx
  8006c8:	8b 00                	mov    (%eax),%eax
  8006ca:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006cd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d3:	8d 40 08             	lea    0x8(%eax),%eax
  8006d6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006d9:	bf 08 00 00 00       	mov    $0x8,%edi
  8006de:	eb 51                	jmp    800731 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  8006e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e3:	8b 00                	mov    (%eax),%eax
  8006e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ea:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ed:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f3:	8d 40 04             	lea    0x4(%eax),%eax
  8006f6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006f9:	bf 08 00 00 00       	mov    $0x8,%edi
  8006fe:	eb 31                	jmp    800731 <vprintfmt+0x403>
			putch('0', putdat);
  800700:	83 ec 08             	sub    $0x8,%esp
  800703:	53                   	push   %ebx
  800704:	6a 30                	push   $0x30
  800706:	ff d6                	call   *%esi
			putch('x', putdat);
  800708:	83 c4 08             	add    $0x8,%esp
  80070b:	53                   	push   %ebx
  80070c:	6a 78                	push   $0x78
  80070e:	ff d6                	call   *%esi
			num = (unsigned long long)
  800710:	8b 45 14             	mov    0x14(%ebp),%eax
  800713:	8b 00                	mov    (%eax),%eax
  800715:	ba 00 00 00 00       	mov    $0x0,%edx
  80071a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80071d:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800720:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800723:	8b 45 14             	mov    0x14(%ebp),%eax
  800726:	8d 40 04             	lea    0x4(%eax),%eax
  800729:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80072c:	bf 10 00 00 00       	mov    $0x10,%edi
			if(posflag)
  800731:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800735:	74 0b                	je     800742 <vprintfmt+0x414>
				putch('+', putdat);
  800737:	83 ec 08             	sub    $0x8,%esp
  80073a:	53                   	push   %ebx
  80073b:	6a 2b                	push   $0x2b
  80073d:	ff d6                	call   *%esi
  80073f:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  800742:	83 ec 0c             	sub    $0xc,%esp
  800745:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800749:	50                   	push   %eax
  80074a:	ff 75 e0             	pushl  -0x20(%ebp)
  80074d:	57                   	push   %edi
  80074e:	ff 75 dc             	pushl  -0x24(%ebp)
  800751:	ff 75 d8             	pushl  -0x28(%ebp)
  800754:	89 da                	mov    %ebx,%edx
  800756:	89 f0                	mov    %esi,%eax
  800758:	e8 b8 fa ff ff       	call   800215 <printnum>
			break;
  80075d:	83 c4 20             	add    $0x20,%esp
			char* cp = va_arg(ap, char *);
  800760:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800763:	83 c7 01             	add    $0x1,%edi
  800766:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80076a:	83 f8 25             	cmp    $0x25,%eax
  80076d:	0f 84 d2 fb ff ff    	je     800345 <vprintfmt+0x17>
			if (ch == '\0')
  800773:	85 c0                	test   %eax,%eax
  800775:	0f 84 03 01 00 00    	je     80087e <vprintfmt+0x550>
			putch(ch, putdat);
  80077b:	83 ec 08             	sub    $0x8,%esp
  80077e:	53                   	push   %ebx
  80077f:	50                   	push   %eax
  800780:	ff d6                	call   *%esi
  800782:	83 c4 10             	add    $0x10,%esp
  800785:	eb dc                	jmp    800763 <vprintfmt+0x435>
	if (lflag >= 2)
  800787:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  80078b:	7f 29                	jg     8007b6 <vprintfmt+0x488>
	else if (lflag)
  80078d:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800791:	74 44                	je     8007d7 <vprintfmt+0x4a9>
		return va_arg(*ap, unsigned long);
  800793:	8b 45 14             	mov    0x14(%ebp),%eax
  800796:	8b 00                	mov    (%eax),%eax
  800798:	ba 00 00 00 00       	mov    $0x0,%edx
  80079d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a6:	8d 40 04             	lea    0x4(%eax),%eax
  8007a9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007ac:	bf 10 00 00 00       	mov    $0x10,%edi
  8007b1:	e9 7b ff ff ff       	jmp    800731 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  8007b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b9:	8b 50 04             	mov    0x4(%eax),%edx
  8007bc:	8b 00                	mov    (%eax),%eax
  8007be:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007c1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c7:	8d 40 08             	lea    0x8(%eax),%eax
  8007ca:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007cd:	bf 10 00 00 00       	mov    $0x10,%edi
  8007d2:	e9 5a ff ff ff       	jmp    800731 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  8007d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007da:	8b 00                	mov    (%eax),%eax
  8007dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8007e1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007e4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ea:	8d 40 04             	lea    0x4(%eax),%eax
  8007ed:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007f0:	bf 10 00 00 00       	mov    $0x10,%edi
  8007f5:	e9 37 ff ff ff       	jmp    800731 <vprintfmt+0x403>
			char* cp = va_arg(ap, char *);
  8007fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fd:	8d 78 04             	lea    0x4(%eax),%edi
  800800:	8b 00                	mov    (%eax),%eax
    			if (cp == NULL) {
  800802:	85 c0                	test   %eax,%eax
  800804:	74 2c                	je     800832 <vprintfmt+0x504>
    			*cp = *(int *)putdat;
  800806:	8b 13                	mov    (%ebx),%edx
  800808:	88 10                	mov    %dl,(%eax)
			char* cp = va_arg(ap, char *);
  80080a:	89 7d 14             	mov    %edi,0x14(%ebp)
    			if ((*(int *) putdat) > 127)
  80080d:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  800810:	0f 8e 4a ff ff ff    	jle    800760 <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", overflow_error);
  800816:	68 b4 23 80 00       	push   $0x8023b4
  80081b:	68 ba 26 80 00       	push   $0x8026ba
  800820:	53                   	push   %ebx
  800821:	56                   	push   %esi
  800822:	e8 ea fa ff ff       	call   800311 <printfmt>
  800827:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  80082a:	89 7d 14             	mov    %edi,0x14(%ebp)
  80082d:	e9 2e ff ff ff       	jmp    800760 <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", null_error);
  800832:	68 7c 23 80 00       	push   $0x80237c
  800837:	68 ba 26 80 00       	push   $0x8026ba
  80083c:	53                   	push   %ebx
  80083d:	56                   	push   %esi
  80083e:	e8 ce fa ff ff       	call   800311 <printfmt>
        		break;
  800843:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  800846:	89 7d 14             	mov    %edi,0x14(%ebp)
        		break;
  800849:	e9 12 ff ff ff       	jmp    800760 <vprintfmt+0x432>
			putch(ch, putdat);
  80084e:	83 ec 08             	sub    $0x8,%esp
  800851:	53                   	push   %ebx
  800852:	6a 25                	push   $0x25
  800854:	ff d6                	call   *%esi
			break;
  800856:	83 c4 10             	add    $0x10,%esp
  800859:	e9 02 ff ff ff       	jmp    800760 <vprintfmt+0x432>
			putch('%', putdat);
  80085e:	83 ec 08             	sub    $0x8,%esp
  800861:	53                   	push   %ebx
  800862:	6a 25                	push   $0x25
  800864:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800866:	83 c4 10             	add    $0x10,%esp
  800869:	89 f8                	mov    %edi,%eax
  80086b:	eb 03                	jmp    800870 <vprintfmt+0x542>
  80086d:	83 e8 01             	sub    $0x1,%eax
  800870:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800874:	75 f7                	jne    80086d <vprintfmt+0x53f>
  800876:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800879:	e9 e2 fe ff ff       	jmp    800760 <vprintfmt+0x432>
}
  80087e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800881:	5b                   	pop    %ebx
  800882:	5e                   	pop    %esi
  800883:	5f                   	pop    %edi
  800884:	5d                   	pop    %ebp
  800885:	c3                   	ret    

00800886 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800886:	55                   	push   %ebp
  800887:	89 e5                	mov    %esp,%ebp
  800889:	83 ec 18             	sub    $0x18,%esp
  80088c:	8b 45 08             	mov    0x8(%ebp),%eax
  80088f:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800892:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800895:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800899:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80089c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008a3:	85 c0                	test   %eax,%eax
  8008a5:	74 26                	je     8008cd <vsnprintf+0x47>
  8008a7:	85 d2                	test   %edx,%edx
  8008a9:	7e 22                	jle    8008cd <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008ab:	ff 75 14             	pushl  0x14(%ebp)
  8008ae:	ff 75 10             	pushl  0x10(%ebp)
  8008b1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008b4:	50                   	push   %eax
  8008b5:	68 f4 02 80 00       	push   $0x8002f4
  8008ba:	e8 6f fa ff ff       	call   80032e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008c2:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008c8:	83 c4 10             	add    $0x10,%esp
}
  8008cb:	c9                   	leave  
  8008cc:	c3                   	ret    
		return -E_INVAL;
  8008cd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008d2:	eb f7                	jmp    8008cb <vsnprintf+0x45>

008008d4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008d4:	55                   	push   %ebp
  8008d5:	89 e5                	mov    %esp,%ebp
  8008d7:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008da:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008dd:	50                   	push   %eax
  8008de:	ff 75 10             	pushl  0x10(%ebp)
  8008e1:	ff 75 0c             	pushl  0xc(%ebp)
  8008e4:	ff 75 08             	pushl  0x8(%ebp)
  8008e7:	e8 9a ff ff ff       	call   800886 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008ec:	c9                   	leave  
  8008ed:	c3                   	ret    

008008ee <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008ee:	55                   	push   %ebp
  8008ef:	89 e5                	mov    %esp,%ebp
  8008f1:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8008f9:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008fd:	74 05                	je     800904 <strlen+0x16>
		n++;
  8008ff:	83 c0 01             	add    $0x1,%eax
  800902:	eb f5                	jmp    8008f9 <strlen+0xb>
	return n;
}
  800904:	5d                   	pop    %ebp
  800905:	c3                   	ret    

00800906 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800906:	55                   	push   %ebp
  800907:	89 e5                	mov    %esp,%ebp
  800909:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80090c:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80090f:	ba 00 00 00 00       	mov    $0x0,%edx
  800914:	39 c2                	cmp    %eax,%edx
  800916:	74 0d                	je     800925 <strnlen+0x1f>
  800918:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  80091c:	74 05                	je     800923 <strnlen+0x1d>
		n++;
  80091e:	83 c2 01             	add    $0x1,%edx
  800921:	eb f1                	jmp    800914 <strnlen+0xe>
  800923:	89 d0                	mov    %edx,%eax
	return n;
}
  800925:	5d                   	pop    %ebp
  800926:	c3                   	ret    

00800927 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800927:	55                   	push   %ebp
  800928:	89 e5                	mov    %esp,%ebp
  80092a:	53                   	push   %ebx
  80092b:	8b 45 08             	mov    0x8(%ebp),%eax
  80092e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800931:	ba 00 00 00 00       	mov    $0x0,%edx
  800936:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80093a:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  80093d:	83 c2 01             	add    $0x1,%edx
  800940:	84 c9                	test   %cl,%cl
  800942:	75 f2                	jne    800936 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800944:	5b                   	pop    %ebx
  800945:	5d                   	pop    %ebp
  800946:	c3                   	ret    

00800947 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800947:	55                   	push   %ebp
  800948:	89 e5                	mov    %esp,%ebp
  80094a:	53                   	push   %ebx
  80094b:	83 ec 10             	sub    $0x10,%esp
  80094e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800951:	53                   	push   %ebx
  800952:	e8 97 ff ff ff       	call   8008ee <strlen>
  800957:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80095a:	ff 75 0c             	pushl  0xc(%ebp)
  80095d:	01 d8                	add    %ebx,%eax
  80095f:	50                   	push   %eax
  800960:	e8 c2 ff ff ff       	call   800927 <strcpy>
	return dst;
}
  800965:	89 d8                	mov    %ebx,%eax
  800967:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80096a:	c9                   	leave  
  80096b:	c3                   	ret    

0080096c <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80096c:	55                   	push   %ebp
  80096d:	89 e5                	mov    %esp,%ebp
  80096f:	56                   	push   %esi
  800970:	53                   	push   %ebx
  800971:	8b 45 08             	mov    0x8(%ebp),%eax
  800974:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800977:	89 c6                	mov    %eax,%esi
  800979:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80097c:	89 c2                	mov    %eax,%edx
  80097e:	39 f2                	cmp    %esi,%edx
  800980:	74 11                	je     800993 <strncpy+0x27>
		*dst++ = *src;
  800982:	83 c2 01             	add    $0x1,%edx
  800985:	0f b6 19             	movzbl (%ecx),%ebx
  800988:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80098b:	80 fb 01             	cmp    $0x1,%bl
  80098e:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800991:	eb eb                	jmp    80097e <strncpy+0x12>
	}
	return ret;
}
  800993:	5b                   	pop    %ebx
  800994:	5e                   	pop    %esi
  800995:	5d                   	pop    %ebp
  800996:	c3                   	ret    

00800997 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800997:	55                   	push   %ebp
  800998:	89 e5                	mov    %esp,%ebp
  80099a:	56                   	push   %esi
  80099b:	53                   	push   %ebx
  80099c:	8b 75 08             	mov    0x8(%ebp),%esi
  80099f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009a2:	8b 55 10             	mov    0x10(%ebp),%edx
  8009a5:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009a7:	85 d2                	test   %edx,%edx
  8009a9:	74 21                	je     8009cc <strlcpy+0x35>
  8009ab:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009af:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8009b1:	39 c2                	cmp    %eax,%edx
  8009b3:	74 14                	je     8009c9 <strlcpy+0x32>
  8009b5:	0f b6 19             	movzbl (%ecx),%ebx
  8009b8:	84 db                	test   %bl,%bl
  8009ba:	74 0b                	je     8009c7 <strlcpy+0x30>
			*dst++ = *src++;
  8009bc:	83 c1 01             	add    $0x1,%ecx
  8009bf:	83 c2 01             	add    $0x1,%edx
  8009c2:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009c5:	eb ea                	jmp    8009b1 <strlcpy+0x1a>
  8009c7:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009c9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009cc:	29 f0                	sub    %esi,%eax
}
  8009ce:	5b                   	pop    %ebx
  8009cf:	5e                   	pop    %esi
  8009d0:	5d                   	pop    %ebp
  8009d1:	c3                   	ret    

008009d2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009d2:	55                   	push   %ebp
  8009d3:	89 e5                	mov    %esp,%ebp
  8009d5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009d8:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009db:	0f b6 01             	movzbl (%ecx),%eax
  8009de:	84 c0                	test   %al,%al
  8009e0:	74 0c                	je     8009ee <strcmp+0x1c>
  8009e2:	3a 02                	cmp    (%edx),%al
  8009e4:	75 08                	jne    8009ee <strcmp+0x1c>
		p++, q++;
  8009e6:	83 c1 01             	add    $0x1,%ecx
  8009e9:	83 c2 01             	add    $0x1,%edx
  8009ec:	eb ed                	jmp    8009db <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009ee:	0f b6 c0             	movzbl %al,%eax
  8009f1:	0f b6 12             	movzbl (%edx),%edx
  8009f4:	29 d0                	sub    %edx,%eax
}
  8009f6:	5d                   	pop    %ebp
  8009f7:	c3                   	ret    

008009f8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009f8:	55                   	push   %ebp
  8009f9:	89 e5                	mov    %esp,%ebp
  8009fb:	53                   	push   %ebx
  8009fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a02:	89 c3                	mov    %eax,%ebx
  800a04:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a07:	eb 06                	jmp    800a0f <strncmp+0x17>
		n--, p++, q++;
  800a09:	83 c0 01             	add    $0x1,%eax
  800a0c:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a0f:	39 d8                	cmp    %ebx,%eax
  800a11:	74 16                	je     800a29 <strncmp+0x31>
  800a13:	0f b6 08             	movzbl (%eax),%ecx
  800a16:	84 c9                	test   %cl,%cl
  800a18:	74 04                	je     800a1e <strncmp+0x26>
  800a1a:	3a 0a                	cmp    (%edx),%cl
  800a1c:	74 eb                	je     800a09 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a1e:	0f b6 00             	movzbl (%eax),%eax
  800a21:	0f b6 12             	movzbl (%edx),%edx
  800a24:	29 d0                	sub    %edx,%eax
}
  800a26:	5b                   	pop    %ebx
  800a27:	5d                   	pop    %ebp
  800a28:	c3                   	ret    
		return 0;
  800a29:	b8 00 00 00 00       	mov    $0x0,%eax
  800a2e:	eb f6                	jmp    800a26 <strncmp+0x2e>

00800a30 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a30:	55                   	push   %ebp
  800a31:	89 e5                	mov    %esp,%ebp
  800a33:	8b 45 08             	mov    0x8(%ebp),%eax
  800a36:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a3a:	0f b6 10             	movzbl (%eax),%edx
  800a3d:	84 d2                	test   %dl,%dl
  800a3f:	74 09                	je     800a4a <strchr+0x1a>
		if (*s == c)
  800a41:	38 ca                	cmp    %cl,%dl
  800a43:	74 0a                	je     800a4f <strchr+0x1f>
	for (; *s; s++)
  800a45:	83 c0 01             	add    $0x1,%eax
  800a48:	eb f0                	jmp    800a3a <strchr+0xa>
			return (char *) s;
	return 0;
  800a4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a4f:	5d                   	pop    %ebp
  800a50:	c3                   	ret    

00800a51 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a51:	55                   	push   %ebp
  800a52:	89 e5                	mov    %esp,%ebp
  800a54:	8b 45 08             	mov    0x8(%ebp),%eax
  800a57:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a5b:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a5e:	38 ca                	cmp    %cl,%dl
  800a60:	74 09                	je     800a6b <strfind+0x1a>
  800a62:	84 d2                	test   %dl,%dl
  800a64:	74 05                	je     800a6b <strfind+0x1a>
	for (; *s; s++)
  800a66:	83 c0 01             	add    $0x1,%eax
  800a69:	eb f0                	jmp    800a5b <strfind+0xa>
			break;
	return (char *) s;
}
  800a6b:	5d                   	pop    %ebp
  800a6c:	c3                   	ret    

00800a6d <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a6d:	55                   	push   %ebp
  800a6e:	89 e5                	mov    %esp,%ebp
  800a70:	57                   	push   %edi
  800a71:	56                   	push   %esi
  800a72:	53                   	push   %ebx
  800a73:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a76:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a79:	85 c9                	test   %ecx,%ecx
  800a7b:	74 31                	je     800aae <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a7d:	89 f8                	mov    %edi,%eax
  800a7f:	09 c8                	or     %ecx,%eax
  800a81:	a8 03                	test   $0x3,%al
  800a83:	75 23                	jne    800aa8 <memset+0x3b>
		c &= 0xFF;
  800a85:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a89:	89 d3                	mov    %edx,%ebx
  800a8b:	c1 e3 08             	shl    $0x8,%ebx
  800a8e:	89 d0                	mov    %edx,%eax
  800a90:	c1 e0 18             	shl    $0x18,%eax
  800a93:	89 d6                	mov    %edx,%esi
  800a95:	c1 e6 10             	shl    $0x10,%esi
  800a98:	09 f0                	or     %esi,%eax
  800a9a:	09 c2                	or     %eax,%edx
  800a9c:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a9e:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800aa1:	89 d0                	mov    %edx,%eax
  800aa3:	fc                   	cld    
  800aa4:	f3 ab                	rep stos %eax,%es:(%edi)
  800aa6:	eb 06                	jmp    800aae <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800aa8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aab:	fc                   	cld    
  800aac:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800aae:	89 f8                	mov    %edi,%eax
  800ab0:	5b                   	pop    %ebx
  800ab1:	5e                   	pop    %esi
  800ab2:	5f                   	pop    %edi
  800ab3:	5d                   	pop    %ebp
  800ab4:	c3                   	ret    

00800ab5 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ab5:	55                   	push   %ebp
  800ab6:	89 e5                	mov    %esp,%ebp
  800ab8:	57                   	push   %edi
  800ab9:	56                   	push   %esi
  800aba:	8b 45 08             	mov    0x8(%ebp),%eax
  800abd:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ac0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ac3:	39 c6                	cmp    %eax,%esi
  800ac5:	73 32                	jae    800af9 <memmove+0x44>
  800ac7:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800aca:	39 c2                	cmp    %eax,%edx
  800acc:	76 2b                	jbe    800af9 <memmove+0x44>
		s += n;
		d += n;
  800ace:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ad1:	89 fe                	mov    %edi,%esi
  800ad3:	09 ce                	or     %ecx,%esi
  800ad5:	09 d6                	or     %edx,%esi
  800ad7:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800add:	75 0e                	jne    800aed <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800adf:	83 ef 04             	sub    $0x4,%edi
  800ae2:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ae5:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800ae8:	fd                   	std    
  800ae9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800aeb:	eb 09                	jmp    800af6 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800aed:	83 ef 01             	sub    $0x1,%edi
  800af0:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800af3:	fd                   	std    
  800af4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800af6:	fc                   	cld    
  800af7:	eb 1a                	jmp    800b13 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800af9:	89 c2                	mov    %eax,%edx
  800afb:	09 ca                	or     %ecx,%edx
  800afd:	09 f2                	or     %esi,%edx
  800aff:	f6 c2 03             	test   $0x3,%dl
  800b02:	75 0a                	jne    800b0e <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b04:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b07:	89 c7                	mov    %eax,%edi
  800b09:	fc                   	cld    
  800b0a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b0c:	eb 05                	jmp    800b13 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b0e:	89 c7                	mov    %eax,%edi
  800b10:	fc                   	cld    
  800b11:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b13:	5e                   	pop    %esi
  800b14:	5f                   	pop    %edi
  800b15:	5d                   	pop    %ebp
  800b16:	c3                   	ret    

00800b17 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b17:	55                   	push   %ebp
  800b18:	89 e5                	mov    %esp,%ebp
  800b1a:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b1d:	ff 75 10             	pushl  0x10(%ebp)
  800b20:	ff 75 0c             	pushl  0xc(%ebp)
  800b23:	ff 75 08             	pushl  0x8(%ebp)
  800b26:	e8 8a ff ff ff       	call   800ab5 <memmove>
}
  800b2b:	c9                   	leave  
  800b2c:	c3                   	ret    

00800b2d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b2d:	55                   	push   %ebp
  800b2e:	89 e5                	mov    %esp,%ebp
  800b30:	56                   	push   %esi
  800b31:	53                   	push   %ebx
  800b32:	8b 45 08             	mov    0x8(%ebp),%eax
  800b35:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b38:	89 c6                	mov    %eax,%esi
  800b3a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b3d:	39 f0                	cmp    %esi,%eax
  800b3f:	74 1c                	je     800b5d <memcmp+0x30>
		if (*s1 != *s2)
  800b41:	0f b6 08             	movzbl (%eax),%ecx
  800b44:	0f b6 1a             	movzbl (%edx),%ebx
  800b47:	38 d9                	cmp    %bl,%cl
  800b49:	75 08                	jne    800b53 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b4b:	83 c0 01             	add    $0x1,%eax
  800b4e:	83 c2 01             	add    $0x1,%edx
  800b51:	eb ea                	jmp    800b3d <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b53:	0f b6 c1             	movzbl %cl,%eax
  800b56:	0f b6 db             	movzbl %bl,%ebx
  800b59:	29 d8                	sub    %ebx,%eax
  800b5b:	eb 05                	jmp    800b62 <memcmp+0x35>
	}

	return 0;
  800b5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b62:	5b                   	pop    %ebx
  800b63:	5e                   	pop    %esi
  800b64:	5d                   	pop    %ebp
  800b65:	c3                   	ret    

00800b66 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b66:	55                   	push   %ebp
  800b67:	89 e5                	mov    %esp,%ebp
  800b69:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b6f:	89 c2                	mov    %eax,%edx
  800b71:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b74:	39 d0                	cmp    %edx,%eax
  800b76:	73 09                	jae    800b81 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b78:	38 08                	cmp    %cl,(%eax)
  800b7a:	74 05                	je     800b81 <memfind+0x1b>
	for (; s < ends; s++)
  800b7c:	83 c0 01             	add    $0x1,%eax
  800b7f:	eb f3                	jmp    800b74 <memfind+0xe>
			break;
	return (void *) s;
}
  800b81:	5d                   	pop    %ebp
  800b82:	c3                   	ret    

00800b83 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b83:	55                   	push   %ebp
  800b84:	89 e5                	mov    %esp,%ebp
  800b86:	57                   	push   %edi
  800b87:	56                   	push   %esi
  800b88:	53                   	push   %ebx
  800b89:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b8c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b8f:	eb 03                	jmp    800b94 <strtol+0x11>
		s++;
  800b91:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b94:	0f b6 01             	movzbl (%ecx),%eax
  800b97:	3c 20                	cmp    $0x20,%al
  800b99:	74 f6                	je     800b91 <strtol+0xe>
  800b9b:	3c 09                	cmp    $0x9,%al
  800b9d:	74 f2                	je     800b91 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b9f:	3c 2b                	cmp    $0x2b,%al
  800ba1:	74 2a                	je     800bcd <strtol+0x4a>
	int neg = 0;
  800ba3:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ba8:	3c 2d                	cmp    $0x2d,%al
  800baa:	74 2b                	je     800bd7 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bac:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bb2:	75 0f                	jne    800bc3 <strtol+0x40>
  800bb4:	80 39 30             	cmpb   $0x30,(%ecx)
  800bb7:	74 28                	je     800be1 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bb9:	85 db                	test   %ebx,%ebx
  800bbb:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bc0:	0f 44 d8             	cmove  %eax,%ebx
  800bc3:	b8 00 00 00 00       	mov    $0x0,%eax
  800bc8:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bcb:	eb 50                	jmp    800c1d <strtol+0x9a>
		s++;
  800bcd:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800bd0:	bf 00 00 00 00       	mov    $0x0,%edi
  800bd5:	eb d5                	jmp    800bac <strtol+0x29>
		s++, neg = 1;
  800bd7:	83 c1 01             	add    $0x1,%ecx
  800bda:	bf 01 00 00 00       	mov    $0x1,%edi
  800bdf:	eb cb                	jmp    800bac <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800be1:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800be5:	74 0e                	je     800bf5 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800be7:	85 db                	test   %ebx,%ebx
  800be9:	75 d8                	jne    800bc3 <strtol+0x40>
		s++, base = 8;
  800beb:	83 c1 01             	add    $0x1,%ecx
  800bee:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bf3:	eb ce                	jmp    800bc3 <strtol+0x40>
		s += 2, base = 16;
  800bf5:	83 c1 02             	add    $0x2,%ecx
  800bf8:	bb 10 00 00 00       	mov    $0x10,%ebx
  800bfd:	eb c4                	jmp    800bc3 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800bff:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c02:	89 f3                	mov    %esi,%ebx
  800c04:	80 fb 19             	cmp    $0x19,%bl
  800c07:	77 29                	ja     800c32 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c09:	0f be d2             	movsbl %dl,%edx
  800c0c:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c0f:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c12:	7d 30                	jge    800c44 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c14:	83 c1 01             	add    $0x1,%ecx
  800c17:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c1b:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c1d:	0f b6 11             	movzbl (%ecx),%edx
  800c20:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c23:	89 f3                	mov    %esi,%ebx
  800c25:	80 fb 09             	cmp    $0x9,%bl
  800c28:	77 d5                	ja     800bff <strtol+0x7c>
			dig = *s - '0';
  800c2a:	0f be d2             	movsbl %dl,%edx
  800c2d:	83 ea 30             	sub    $0x30,%edx
  800c30:	eb dd                	jmp    800c0f <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c32:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c35:	89 f3                	mov    %esi,%ebx
  800c37:	80 fb 19             	cmp    $0x19,%bl
  800c3a:	77 08                	ja     800c44 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c3c:	0f be d2             	movsbl %dl,%edx
  800c3f:	83 ea 37             	sub    $0x37,%edx
  800c42:	eb cb                	jmp    800c0f <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c44:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c48:	74 05                	je     800c4f <strtol+0xcc>
		*endptr = (char *) s;
  800c4a:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c4d:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c4f:	89 c2                	mov    %eax,%edx
  800c51:	f7 da                	neg    %edx
  800c53:	85 ff                	test   %edi,%edi
  800c55:	0f 45 c2             	cmovne %edx,%eax
}
  800c58:	5b                   	pop    %ebx
  800c59:	5e                   	pop    %esi
  800c5a:	5f                   	pop    %edi
  800c5b:	5d                   	pop    %ebp
  800c5c:	c3                   	ret    

00800c5d <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c5d:	55                   	push   %ebp
  800c5e:	89 e5                	mov    %esp,%ebp
  800c60:	57                   	push   %edi
  800c61:	56                   	push   %esi
  800c62:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c63:	b8 00 00 00 00       	mov    $0x0,%eax
  800c68:	8b 55 08             	mov    0x8(%ebp),%edx
  800c6b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c6e:	89 c3                	mov    %eax,%ebx
  800c70:	89 c7                	mov    %eax,%edi
  800c72:	89 c6                	mov    %eax,%esi
  800c74:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c76:	5b                   	pop    %ebx
  800c77:	5e                   	pop    %esi
  800c78:	5f                   	pop    %edi
  800c79:	5d                   	pop    %ebp
  800c7a:	c3                   	ret    

00800c7b <sys_cgetc>:

int
sys_cgetc(void)
{
  800c7b:	55                   	push   %ebp
  800c7c:	89 e5                	mov    %esp,%ebp
  800c7e:	57                   	push   %edi
  800c7f:	56                   	push   %esi
  800c80:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c81:	ba 00 00 00 00       	mov    $0x0,%edx
  800c86:	b8 01 00 00 00       	mov    $0x1,%eax
  800c8b:	89 d1                	mov    %edx,%ecx
  800c8d:	89 d3                	mov    %edx,%ebx
  800c8f:	89 d7                	mov    %edx,%edi
  800c91:	89 d6                	mov    %edx,%esi
  800c93:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c95:	5b                   	pop    %ebx
  800c96:	5e                   	pop    %esi
  800c97:	5f                   	pop    %edi
  800c98:	5d                   	pop    %ebp
  800c99:	c3                   	ret    

00800c9a <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c9a:	55                   	push   %ebp
  800c9b:	89 e5                	mov    %esp,%ebp
  800c9d:	57                   	push   %edi
  800c9e:	56                   	push   %esi
  800c9f:	53                   	push   %ebx
  800ca0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ca3:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ca8:	8b 55 08             	mov    0x8(%ebp),%edx
  800cab:	b8 03 00 00 00       	mov    $0x3,%eax
  800cb0:	89 cb                	mov    %ecx,%ebx
  800cb2:	89 cf                	mov    %ecx,%edi
  800cb4:	89 ce                	mov    %ecx,%esi
  800cb6:	cd 30                	int    $0x30
	if (check && ret > 0)
  800cb8:	85 c0                	test   %eax,%eax
  800cba:	7f 08                	jg     800cc4 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
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
  800cc8:	6a 03                	push   $0x3
  800cca:	68 c0 25 80 00       	push   $0x8025c0
  800ccf:	6a 4c                	push   $0x4c
  800cd1:	68 dd 25 80 00       	push   $0x8025dd
  800cd6:	e8 5b 11 00 00       	call   801e36 <_panic>

00800cdb <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cdb:	55                   	push   %ebp
  800cdc:	89 e5                	mov    %esp,%ebp
  800cde:	57                   	push   %edi
  800cdf:	56                   	push   %esi
  800ce0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ce1:	ba 00 00 00 00       	mov    $0x0,%edx
  800ce6:	b8 02 00 00 00       	mov    $0x2,%eax
  800ceb:	89 d1                	mov    %edx,%ecx
  800ced:	89 d3                	mov    %edx,%ebx
  800cef:	89 d7                	mov    %edx,%edi
  800cf1:	89 d6                	mov    %edx,%esi
  800cf3:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cf5:	5b                   	pop    %ebx
  800cf6:	5e                   	pop    %esi
  800cf7:	5f                   	pop    %edi
  800cf8:	5d                   	pop    %ebp
  800cf9:	c3                   	ret    

00800cfa <sys_yield>:

void
sys_yield(void)
{
  800cfa:	55                   	push   %ebp
  800cfb:	89 e5                	mov    %esp,%ebp
  800cfd:	57                   	push   %edi
  800cfe:	56                   	push   %esi
  800cff:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d00:	ba 00 00 00 00       	mov    $0x0,%edx
  800d05:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d0a:	89 d1                	mov    %edx,%ecx
  800d0c:	89 d3                	mov    %edx,%ebx
  800d0e:	89 d7                	mov    %edx,%edi
  800d10:	89 d6                	mov    %edx,%esi
  800d12:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d14:	5b                   	pop    %ebx
  800d15:	5e                   	pop    %esi
  800d16:	5f                   	pop    %edi
  800d17:	5d                   	pop    %ebp
  800d18:	c3                   	ret    

00800d19 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d19:	55                   	push   %ebp
  800d1a:	89 e5                	mov    %esp,%ebp
  800d1c:	57                   	push   %edi
  800d1d:	56                   	push   %esi
  800d1e:	53                   	push   %ebx
  800d1f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d22:	be 00 00 00 00       	mov    $0x0,%esi
  800d27:	8b 55 08             	mov    0x8(%ebp),%edx
  800d2a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d2d:	b8 04 00 00 00       	mov    $0x4,%eax
  800d32:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d35:	89 f7                	mov    %esi,%edi
  800d37:	cd 30                	int    $0x30
	if (check && ret > 0)
  800d39:	85 c0                	test   %eax,%eax
  800d3b:	7f 08                	jg     800d45 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d40:	5b                   	pop    %ebx
  800d41:	5e                   	pop    %esi
  800d42:	5f                   	pop    %edi
  800d43:	5d                   	pop    %ebp
  800d44:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d45:	83 ec 0c             	sub    $0xc,%esp
  800d48:	50                   	push   %eax
  800d49:	6a 04                	push   $0x4
  800d4b:	68 c0 25 80 00       	push   $0x8025c0
  800d50:	6a 4c                	push   $0x4c
  800d52:	68 dd 25 80 00       	push   $0x8025dd
  800d57:	e8 da 10 00 00       	call   801e36 <_panic>

00800d5c <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d5c:	55                   	push   %ebp
  800d5d:	89 e5                	mov    %esp,%ebp
  800d5f:	57                   	push   %edi
  800d60:	56                   	push   %esi
  800d61:	53                   	push   %ebx
  800d62:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d65:	8b 55 08             	mov    0x8(%ebp),%edx
  800d68:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d6b:	b8 05 00 00 00       	mov    $0x5,%eax
  800d70:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d73:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d76:	8b 75 18             	mov    0x18(%ebp),%esi
  800d79:	cd 30                	int    $0x30
	if (check && ret > 0)
  800d7b:	85 c0                	test   %eax,%eax
  800d7d:	7f 08                	jg     800d87 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d7f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d82:	5b                   	pop    %ebx
  800d83:	5e                   	pop    %esi
  800d84:	5f                   	pop    %edi
  800d85:	5d                   	pop    %ebp
  800d86:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d87:	83 ec 0c             	sub    $0xc,%esp
  800d8a:	50                   	push   %eax
  800d8b:	6a 05                	push   $0x5
  800d8d:	68 c0 25 80 00       	push   $0x8025c0
  800d92:	6a 4c                	push   $0x4c
  800d94:	68 dd 25 80 00       	push   $0x8025dd
  800d99:	e8 98 10 00 00       	call   801e36 <_panic>

00800d9e <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d9e:	55                   	push   %ebp
  800d9f:	89 e5                	mov    %esp,%ebp
  800da1:	57                   	push   %edi
  800da2:	56                   	push   %esi
  800da3:	53                   	push   %ebx
  800da4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800da7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dac:	8b 55 08             	mov    0x8(%ebp),%edx
  800daf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db2:	b8 06 00 00 00       	mov    $0x6,%eax
  800db7:	89 df                	mov    %ebx,%edi
  800db9:	89 de                	mov    %ebx,%esi
  800dbb:	cd 30                	int    $0x30
	if (check && ret > 0)
  800dbd:	85 c0                	test   %eax,%eax
  800dbf:	7f 08                	jg     800dc9 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800dc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dc4:	5b                   	pop    %ebx
  800dc5:	5e                   	pop    %esi
  800dc6:	5f                   	pop    %edi
  800dc7:	5d                   	pop    %ebp
  800dc8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dc9:	83 ec 0c             	sub    $0xc,%esp
  800dcc:	50                   	push   %eax
  800dcd:	6a 06                	push   $0x6
  800dcf:	68 c0 25 80 00       	push   $0x8025c0
  800dd4:	6a 4c                	push   $0x4c
  800dd6:	68 dd 25 80 00       	push   $0x8025dd
  800ddb:	e8 56 10 00 00       	call   801e36 <_panic>

00800de0 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800de0:	55                   	push   %ebp
  800de1:	89 e5                	mov    %esp,%ebp
  800de3:	57                   	push   %edi
  800de4:	56                   	push   %esi
  800de5:	53                   	push   %ebx
  800de6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800de9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dee:	8b 55 08             	mov    0x8(%ebp),%edx
  800df1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df4:	b8 08 00 00 00       	mov    $0x8,%eax
  800df9:	89 df                	mov    %ebx,%edi
  800dfb:	89 de                	mov    %ebx,%esi
  800dfd:	cd 30                	int    $0x30
	if (check && ret > 0)
  800dff:	85 c0                	test   %eax,%eax
  800e01:	7f 08                	jg     800e0b <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e03:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e06:	5b                   	pop    %ebx
  800e07:	5e                   	pop    %esi
  800e08:	5f                   	pop    %edi
  800e09:	5d                   	pop    %ebp
  800e0a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e0b:	83 ec 0c             	sub    $0xc,%esp
  800e0e:	50                   	push   %eax
  800e0f:	6a 08                	push   $0x8
  800e11:	68 c0 25 80 00       	push   $0x8025c0
  800e16:	6a 4c                	push   $0x4c
  800e18:	68 dd 25 80 00       	push   $0x8025dd
  800e1d:	e8 14 10 00 00       	call   801e36 <_panic>

00800e22 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e22:	55                   	push   %ebp
  800e23:	89 e5                	mov    %esp,%ebp
  800e25:	57                   	push   %edi
  800e26:	56                   	push   %esi
  800e27:	53                   	push   %ebx
  800e28:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e2b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e30:	8b 55 08             	mov    0x8(%ebp),%edx
  800e33:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e36:	b8 09 00 00 00       	mov    $0x9,%eax
  800e3b:	89 df                	mov    %ebx,%edi
  800e3d:	89 de                	mov    %ebx,%esi
  800e3f:	cd 30                	int    $0x30
	if (check && ret > 0)
  800e41:	85 c0                	test   %eax,%eax
  800e43:	7f 08                	jg     800e4d <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e45:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e48:	5b                   	pop    %ebx
  800e49:	5e                   	pop    %esi
  800e4a:	5f                   	pop    %edi
  800e4b:	5d                   	pop    %ebp
  800e4c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e4d:	83 ec 0c             	sub    $0xc,%esp
  800e50:	50                   	push   %eax
  800e51:	6a 09                	push   $0x9
  800e53:	68 c0 25 80 00       	push   $0x8025c0
  800e58:	6a 4c                	push   $0x4c
  800e5a:	68 dd 25 80 00       	push   $0x8025dd
  800e5f:	e8 d2 0f 00 00       	call   801e36 <_panic>

00800e64 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e64:	55                   	push   %ebp
  800e65:	89 e5                	mov    %esp,%ebp
  800e67:	57                   	push   %edi
  800e68:	56                   	push   %esi
  800e69:	53                   	push   %ebx
  800e6a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e6d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e72:	8b 55 08             	mov    0x8(%ebp),%edx
  800e75:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e78:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e7d:	89 df                	mov    %ebx,%edi
  800e7f:	89 de                	mov    %ebx,%esi
  800e81:	cd 30                	int    $0x30
	if (check && ret > 0)
  800e83:	85 c0                	test   %eax,%eax
  800e85:	7f 08                	jg     800e8f <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e87:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e8a:	5b                   	pop    %ebx
  800e8b:	5e                   	pop    %esi
  800e8c:	5f                   	pop    %edi
  800e8d:	5d                   	pop    %ebp
  800e8e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e8f:	83 ec 0c             	sub    $0xc,%esp
  800e92:	50                   	push   %eax
  800e93:	6a 0a                	push   $0xa
  800e95:	68 c0 25 80 00       	push   $0x8025c0
  800e9a:	6a 4c                	push   $0x4c
  800e9c:	68 dd 25 80 00       	push   $0x8025dd
  800ea1:	e8 90 0f 00 00       	call   801e36 <_panic>

00800ea6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ea6:	55                   	push   %ebp
  800ea7:	89 e5                	mov    %esp,%ebp
  800ea9:	57                   	push   %edi
  800eaa:	56                   	push   %esi
  800eab:	53                   	push   %ebx
	asm volatile("int %1\n"
  800eac:	8b 55 08             	mov    0x8(%ebp),%edx
  800eaf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb2:	b8 0c 00 00 00       	mov    $0xc,%eax
  800eb7:	be 00 00 00 00       	mov    $0x0,%esi
  800ebc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ebf:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ec2:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ec4:	5b                   	pop    %ebx
  800ec5:	5e                   	pop    %esi
  800ec6:	5f                   	pop    %edi
  800ec7:	5d                   	pop    %ebp
  800ec8:	c3                   	ret    

00800ec9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ec9:	55                   	push   %ebp
  800eca:	89 e5                	mov    %esp,%ebp
  800ecc:	57                   	push   %edi
  800ecd:	56                   	push   %esi
  800ece:	53                   	push   %ebx
  800ecf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ed2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ed7:	8b 55 08             	mov    0x8(%ebp),%edx
  800eda:	b8 0d 00 00 00       	mov    $0xd,%eax
  800edf:	89 cb                	mov    %ecx,%ebx
  800ee1:	89 cf                	mov    %ecx,%edi
  800ee3:	89 ce                	mov    %ecx,%esi
  800ee5:	cd 30                	int    $0x30
	if (check && ret > 0)
  800ee7:	85 c0                	test   %eax,%eax
  800ee9:	7f 08                	jg     800ef3 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800eeb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eee:	5b                   	pop    %ebx
  800eef:	5e                   	pop    %esi
  800ef0:	5f                   	pop    %edi
  800ef1:	5d                   	pop    %ebp
  800ef2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ef3:	83 ec 0c             	sub    $0xc,%esp
  800ef6:	50                   	push   %eax
  800ef7:	6a 0d                	push   $0xd
  800ef9:	68 c0 25 80 00       	push   $0x8025c0
  800efe:	6a 4c                	push   $0x4c
  800f00:	68 dd 25 80 00       	push   $0x8025dd
  800f05:	e8 2c 0f 00 00       	call   801e36 <_panic>

00800f0a <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f0a:	55                   	push   %ebp
  800f0b:	89 e5                	mov    %esp,%ebp
  800f0d:	57                   	push   %edi
  800f0e:	56                   	push   %esi
  800f0f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f10:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f15:	8b 55 08             	mov    0x8(%ebp),%edx
  800f18:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f1b:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f20:	89 df                	mov    %ebx,%edi
  800f22:	89 de                	mov    %ebx,%esi
  800f24:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f26:	5b                   	pop    %ebx
  800f27:	5e                   	pop    %esi
  800f28:	5f                   	pop    %edi
  800f29:	5d                   	pop    %ebp
  800f2a:	c3                   	ret    

00800f2b <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f2b:	55                   	push   %ebp
  800f2c:	89 e5                	mov    %esp,%ebp
  800f2e:	57                   	push   %edi
  800f2f:	56                   	push   %esi
  800f30:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f31:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f36:	8b 55 08             	mov    0x8(%ebp),%edx
  800f39:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f3e:	89 cb                	mov    %ecx,%ebx
  800f40:	89 cf                	mov    %ecx,%edi
  800f42:	89 ce                	mov    %ecx,%esi
  800f44:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f46:	5b                   	pop    %ebx
  800f47:	5e                   	pop    %esi
  800f48:	5f                   	pop    %edi
  800f49:	5d                   	pop    %ebp
  800f4a:	c3                   	ret    

00800f4b <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  800f4b:	55                   	push   %ebp
  800f4c:	89 e5                	mov    %esp,%ebp
  800f4e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f51:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f54:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  800f57:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  800f59:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  800f5c:	83 3a 01             	cmpl   $0x1,(%edx)
  800f5f:	7e 09                	jle    800f6a <argstart+0x1f>
  800f61:	ba 11 22 80 00       	mov    $0x802211,%edx
  800f66:	85 c9                	test   %ecx,%ecx
  800f68:	75 05                	jne    800f6f <argstart+0x24>
  800f6a:	ba 00 00 00 00       	mov    $0x0,%edx
  800f6f:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  800f72:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  800f79:	5d                   	pop    %ebp
  800f7a:	c3                   	ret    

00800f7b <argnext>:

int
argnext(struct Argstate *args)
{
  800f7b:	55                   	push   %ebp
  800f7c:	89 e5                	mov    %esp,%ebp
  800f7e:	53                   	push   %ebx
  800f7f:	83 ec 04             	sub    $0x4,%esp
  800f82:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  800f85:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  800f8c:	8b 43 08             	mov    0x8(%ebx),%eax
  800f8f:	85 c0                	test   %eax,%eax
  800f91:	74 72                	je     801005 <argnext+0x8a>
		return -1;

	if (!*args->curarg) {
  800f93:	80 38 00             	cmpb   $0x0,(%eax)
  800f96:	75 48                	jne    800fe0 <argnext+0x65>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  800f98:	8b 0b                	mov    (%ebx),%ecx
  800f9a:	83 39 01             	cmpl   $0x1,(%ecx)
  800f9d:	74 58                	je     800ff7 <argnext+0x7c>
		    || args->argv[1][0] != '-'
  800f9f:	8b 53 04             	mov    0x4(%ebx),%edx
  800fa2:	8b 42 04             	mov    0x4(%edx),%eax
  800fa5:	80 38 2d             	cmpb   $0x2d,(%eax)
  800fa8:	75 4d                	jne    800ff7 <argnext+0x7c>
		    || args->argv[1][1] == '\0')
  800faa:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  800fae:	74 47                	je     800ff7 <argnext+0x7c>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  800fb0:	83 c0 01             	add    $0x1,%eax
  800fb3:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  800fb6:	83 ec 04             	sub    $0x4,%esp
  800fb9:	8b 01                	mov    (%ecx),%eax
  800fbb:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  800fc2:	50                   	push   %eax
  800fc3:	8d 42 08             	lea    0x8(%edx),%eax
  800fc6:	50                   	push   %eax
  800fc7:	83 c2 04             	add    $0x4,%edx
  800fca:	52                   	push   %edx
  800fcb:	e8 e5 fa ff ff       	call   800ab5 <memmove>
		(*args->argc)--;
  800fd0:	8b 03                	mov    (%ebx),%eax
  800fd2:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  800fd5:	8b 43 08             	mov    0x8(%ebx),%eax
  800fd8:	83 c4 10             	add    $0x10,%esp
  800fdb:	80 38 2d             	cmpb   $0x2d,(%eax)
  800fde:	74 11                	je     800ff1 <argnext+0x76>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  800fe0:	8b 53 08             	mov    0x8(%ebx),%edx
  800fe3:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  800fe6:	83 c2 01             	add    $0x1,%edx
  800fe9:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  800fec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800fef:	c9                   	leave  
  800ff0:	c3                   	ret    
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  800ff1:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  800ff5:	75 e9                	jne    800fe0 <argnext+0x65>
	args->curarg = 0;
  800ff7:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  800ffe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801003:	eb e7                	jmp    800fec <argnext+0x71>
		return -1;
  801005:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80100a:	eb e0                	jmp    800fec <argnext+0x71>

0080100c <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  80100c:	55                   	push   %ebp
  80100d:	89 e5                	mov    %esp,%ebp
  80100f:	53                   	push   %ebx
  801010:	83 ec 04             	sub    $0x4,%esp
  801013:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  801016:	8b 43 08             	mov    0x8(%ebx),%eax
  801019:	85 c0                	test   %eax,%eax
  80101b:	74 5b                	je     801078 <argnextvalue+0x6c>
		return 0;
	if (*args->curarg) {
  80101d:	80 38 00             	cmpb   $0x0,(%eax)
  801020:	74 12                	je     801034 <argnextvalue+0x28>
		args->argvalue = args->curarg;
  801022:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  801025:	c7 43 08 11 22 80 00 	movl   $0x802211,0x8(%ebx)
		(*args->argc)--;
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
  80102c:	8b 43 0c             	mov    0xc(%ebx),%eax
}
  80102f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801032:	c9                   	leave  
  801033:	c3                   	ret    
	} else if (*args->argc > 1) {
  801034:	8b 13                	mov    (%ebx),%edx
  801036:	83 3a 01             	cmpl   $0x1,(%edx)
  801039:	7f 10                	jg     80104b <argnextvalue+0x3f>
		args->argvalue = 0;
  80103b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  801042:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  801049:	eb e1                	jmp    80102c <argnextvalue+0x20>
		args->argvalue = args->argv[1];
  80104b:	8b 43 04             	mov    0x4(%ebx),%eax
  80104e:	8b 48 04             	mov    0x4(%eax),%ecx
  801051:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801054:	83 ec 04             	sub    $0x4,%esp
  801057:	8b 12                	mov    (%edx),%edx
  801059:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  801060:	52                   	push   %edx
  801061:	8d 50 08             	lea    0x8(%eax),%edx
  801064:	52                   	push   %edx
  801065:	83 c0 04             	add    $0x4,%eax
  801068:	50                   	push   %eax
  801069:	e8 47 fa ff ff       	call   800ab5 <memmove>
		(*args->argc)--;
  80106e:	8b 03                	mov    (%ebx),%eax
  801070:	83 28 01             	subl   $0x1,(%eax)
  801073:	83 c4 10             	add    $0x10,%esp
  801076:	eb b4                	jmp    80102c <argnextvalue+0x20>
		return 0;
  801078:	b8 00 00 00 00       	mov    $0x0,%eax
  80107d:	eb b0                	jmp    80102f <argnextvalue+0x23>

0080107f <argvalue>:
{
  80107f:	55                   	push   %ebp
  801080:	89 e5                	mov    %esp,%ebp
  801082:	83 ec 08             	sub    $0x8,%esp
  801085:	8b 55 08             	mov    0x8(%ebp),%edx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801088:	8b 42 0c             	mov    0xc(%edx),%eax
  80108b:	85 c0                	test   %eax,%eax
  80108d:	74 02                	je     801091 <argvalue+0x12>
}
  80108f:	c9                   	leave  
  801090:	c3                   	ret    
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801091:	83 ec 0c             	sub    $0xc,%esp
  801094:	52                   	push   %edx
  801095:	e8 72 ff ff ff       	call   80100c <argnextvalue>
  80109a:	83 c4 10             	add    $0x10,%esp
  80109d:	eb f0                	jmp    80108f <argvalue+0x10>

0080109f <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80109f:	55                   	push   %ebp
  8010a0:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a5:	05 00 00 00 30       	add    $0x30000000,%eax
  8010aa:	c1 e8 0c             	shr    $0xc,%eax
}
  8010ad:	5d                   	pop    %ebp
  8010ae:	c3                   	ret    

008010af <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8010af:	55                   	push   %ebp
  8010b0:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b5:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8010ba:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010bf:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8010c4:	5d                   	pop    %ebp
  8010c5:	c3                   	ret    

008010c6 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8010c6:	55                   	push   %ebp
  8010c7:	89 e5                	mov    %esp,%ebp
  8010c9:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8010ce:	89 c2                	mov    %eax,%edx
  8010d0:	c1 ea 16             	shr    $0x16,%edx
  8010d3:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010da:	f6 c2 01             	test   $0x1,%dl
  8010dd:	74 2d                	je     80110c <fd_alloc+0x46>
  8010df:	89 c2                	mov    %eax,%edx
  8010e1:	c1 ea 0c             	shr    $0xc,%edx
  8010e4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010eb:	f6 c2 01             	test   $0x1,%dl
  8010ee:	74 1c                	je     80110c <fd_alloc+0x46>
  8010f0:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8010f5:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8010fa:	75 d2                	jne    8010ce <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8010fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801105:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80110a:	eb 0a                	jmp    801116 <fd_alloc+0x50>
			*fd_store = fd;
  80110c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80110f:	89 01                	mov    %eax,(%ecx)
			return 0;
  801111:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801116:	5d                   	pop    %ebp
  801117:	c3                   	ret    

00801118 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801118:	55                   	push   %ebp
  801119:	89 e5                	mov    %esp,%ebp
  80111b:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80111e:	83 f8 1f             	cmp    $0x1f,%eax
  801121:	77 30                	ja     801153 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801123:	c1 e0 0c             	shl    $0xc,%eax
  801126:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80112b:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801131:	f6 c2 01             	test   $0x1,%dl
  801134:	74 24                	je     80115a <fd_lookup+0x42>
  801136:	89 c2                	mov    %eax,%edx
  801138:	c1 ea 0c             	shr    $0xc,%edx
  80113b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801142:	f6 c2 01             	test   $0x1,%dl
  801145:	74 1a                	je     801161 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801147:	8b 55 0c             	mov    0xc(%ebp),%edx
  80114a:	89 02                	mov    %eax,(%edx)
	return 0;
  80114c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801151:	5d                   	pop    %ebp
  801152:	c3                   	ret    
		return -E_INVAL;
  801153:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801158:	eb f7                	jmp    801151 <fd_lookup+0x39>
		return -E_INVAL;
  80115a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80115f:	eb f0                	jmp    801151 <fd_lookup+0x39>
  801161:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801166:	eb e9                	jmp    801151 <fd_lookup+0x39>

00801168 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801168:	55                   	push   %ebp
  801169:	89 e5                	mov    %esp,%ebp
  80116b:	83 ec 08             	sub    $0x8,%esp
  80116e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801171:	ba 68 26 80 00       	mov    $0x802668,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801176:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80117b:	39 08                	cmp    %ecx,(%eax)
  80117d:	74 33                	je     8011b2 <dev_lookup+0x4a>
  80117f:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801182:	8b 02                	mov    (%edx),%eax
  801184:	85 c0                	test   %eax,%eax
  801186:	75 f3                	jne    80117b <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801188:	a1 04 40 80 00       	mov    0x804004,%eax
  80118d:	8b 40 48             	mov    0x48(%eax),%eax
  801190:	83 ec 04             	sub    $0x4,%esp
  801193:	51                   	push   %ecx
  801194:	50                   	push   %eax
  801195:	68 ec 25 80 00       	push   $0x8025ec
  80119a:	e8 62 f0 ff ff       	call   800201 <cprintf>
	*dev = 0;
  80119f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8011a8:	83 c4 10             	add    $0x10,%esp
  8011ab:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8011b0:	c9                   	leave  
  8011b1:	c3                   	ret    
			*dev = devtab[i];
  8011b2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011b5:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8011bc:	eb f2                	jmp    8011b0 <dev_lookup+0x48>

008011be <fd_close>:
{
  8011be:	55                   	push   %ebp
  8011bf:	89 e5                	mov    %esp,%ebp
  8011c1:	57                   	push   %edi
  8011c2:	56                   	push   %esi
  8011c3:	53                   	push   %ebx
  8011c4:	83 ec 24             	sub    $0x24,%esp
  8011c7:	8b 75 08             	mov    0x8(%ebp),%esi
  8011ca:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011cd:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011d0:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011d1:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8011d7:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011da:	50                   	push   %eax
  8011db:	e8 38 ff ff ff       	call   801118 <fd_lookup>
  8011e0:	89 c3                	mov    %eax,%ebx
  8011e2:	83 c4 10             	add    $0x10,%esp
  8011e5:	85 c0                	test   %eax,%eax
  8011e7:	78 05                	js     8011ee <fd_close+0x30>
	    || fd != fd2)
  8011e9:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8011ec:	74 16                	je     801204 <fd_close+0x46>
		return (must_exist ? r : 0);
  8011ee:	89 f8                	mov    %edi,%eax
  8011f0:	84 c0                	test   %al,%al
  8011f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8011f7:	0f 44 d8             	cmove  %eax,%ebx
}
  8011fa:	89 d8                	mov    %ebx,%eax
  8011fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011ff:	5b                   	pop    %ebx
  801200:	5e                   	pop    %esi
  801201:	5f                   	pop    %edi
  801202:	5d                   	pop    %ebp
  801203:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801204:	83 ec 08             	sub    $0x8,%esp
  801207:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80120a:	50                   	push   %eax
  80120b:	ff 36                	pushl  (%esi)
  80120d:	e8 56 ff ff ff       	call   801168 <dev_lookup>
  801212:	89 c3                	mov    %eax,%ebx
  801214:	83 c4 10             	add    $0x10,%esp
  801217:	85 c0                	test   %eax,%eax
  801219:	78 1a                	js     801235 <fd_close+0x77>
		if (dev->dev_close)
  80121b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80121e:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801221:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801226:	85 c0                	test   %eax,%eax
  801228:	74 0b                	je     801235 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80122a:	83 ec 0c             	sub    $0xc,%esp
  80122d:	56                   	push   %esi
  80122e:	ff d0                	call   *%eax
  801230:	89 c3                	mov    %eax,%ebx
  801232:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801235:	83 ec 08             	sub    $0x8,%esp
  801238:	56                   	push   %esi
  801239:	6a 00                	push   $0x0
  80123b:	e8 5e fb ff ff       	call   800d9e <sys_page_unmap>
	return r;
  801240:	83 c4 10             	add    $0x10,%esp
  801243:	eb b5                	jmp    8011fa <fd_close+0x3c>

00801245 <close>:

int
close(int fdnum)
{
  801245:	55                   	push   %ebp
  801246:	89 e5                	mov    %esp,%ebp
  801248:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80124b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80124e:	50                   	push   %eax
  80124f:	ff 75 08             	pushl  0x8(%ebp)
  801252:	e8 c1 fe ff ff       	call   801118 <fd_lookup>
  801257:	83 c4 10             	add    $0x10,%esp
  80125a:	85 c0                	test   %eax,%eax
  80125c:	79 02                	jns    801260 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80125e:	c9                   	leave  
  80125f:	c3                   	ret    
		return fd_close(fd, 1);
  801260:	83 ec 08             	sub    $0x8,%esp
  801263:	6a 01                	push   $0x1
  801265:	ff 75 f4             	pushl  -0xc(%ebp)
  801268:	e8 51 ff ff ff       	call   8011be <fd_close>
  80126d:	83 c4 10             	add    $0x10,%esp
  801270:	eb ec                	jmp    80125e <close+0x19>

00801272 <close_all>:

void
close_all(void)
{
  801272:	55                   	push   %ebp
  801273:	89 e5                	mov    %esp,%ebp
  801275:	53                   	push   %ebx
  801276:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801279:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80127e:	83 ec 0c             	sub    $0xc,%esp
  801281:	53                   	push   %ebx
  801282:	e8 be ff ff ff       	call   801245 <close>
	for (i = 0; i < MAXFD; i++)
  801287:	83 c3 01             	add    $0x1,%ebx
  80128a:	83 c4 10             	add    $0x10,%esp
  80128d:	83 fb 20             	cmp    $0x20,%ebx
  801290:	75 ec                	jne    80127e <close_all+0xc>
}
  801292:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801295:	c9                   	leave  
  801296:	c3                   	ret    

00801297 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801297:	55                   	push   %ebp
  801298:	89 e5                	mov    %esp,%ebp
  80129a:	57                   	push   %edi
  80129b:	56                   	push   %esi
  80129c:	53                   	push   %ebx
  80129d:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8012a0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012a3:	50                   	push   %eax
  8012a4:	ff 75 08             	pushl  0x8(%ebp)
  8012a7:	e8 6c fe ff ff       	call   801118 <fd_lookup>
  8012ac:	89 c3                	mov    %eax,%ebx
  8012ae:	83 c4 10             	add    $0x10,%esp
  8012b1:	85 c0                	test   %eax,%eax
  8012b3:	0f 88 81 00 00 00    	js     80133a <dup+0xa3>
		return r;
	close(newfdnum);
  8012b9:	83 ec 0c             	sub    $0xc,%esp
  8012bc:	ff 75 0c             	pushl  0xc(%ebp)
  8012bf:	e8 81 ff ff ff       	call   801245 <close>

	newfd = INDEX2FD(newfdnum);
  8012c4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8012c7:	c1 e6 0c             	shl    $0xc,%esi
  8012ca:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8012d0:	83 c4 04             	add    $0x4,%esp
  8012d3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012d6:	e8 d4 fd ff ff       	call   8010af <fd2data>
  8012db:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8012dd:	89 34 24             	mov    %esi,(%esp)
  8012e0:	e8 ca fd ff ff       	call   8010af <fd2data>
  8012e5:	83 c4 10             	add    $0x10,%esp
  8012e8:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8012ea:	89 d8                	mov    %ebx,%eax
  8012ec:	c1 e8 16             	shr    $0x16,%eax
  8012ef:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8012f6:	a8 01                	test   $0x1,%al
  8012f8:	74 11                	je     80130b <dup+0x74>
  8012fa:	89 d8                	mov    %ebx,%eax
  8012fc:	c1 e8 0c             	shr    $0xc,%eax
  8012ff:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801306:	f6 c2 01             	test   $0x1,%dl
  801309:	75 39                	jne    801344 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80130b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80130e:	89 d0                	mov    %edx,%eax
  801310:	c1 e8 0c             	shr    $0xc,%eax
  801313:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80131a:	83 ec 0c             	sub    $0xc,%esp
  80131d:	25 07 0e 00 00       	and    $0xe07,%eax
  801322:	50                   	push   %eax
  801323:	56                   	push   %esi
  801324:	6a 00                	push   $0x0
  801326:	52                   	push   %edx
  801327:	6a 00                	push   $0x0
  801329:	e8 2e fa ff ff       	call   800d5c <sys_page_map>
  80132e:	89 c3                	mov    %eax,%ebx
  801330:	83 c4 20             	add    $0x20,%esp
  801333:	85 c0                	test   %eax,%eax
  801335:	78 31                	js     801368 <dup+0xd1>
		goto err;

	return newfdnum;
  801337:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80133a:	89 d8                	mov    %ebx,%eax
  80133c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80133f:	5b                   	pop    %ebx
  801340:	5e                   	pop    %esi
  801341:	5f                   	pop    %edi
  801342:	5d                   	pop    %ebp
  801343:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801344:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80134b:	83 ec 0c             	sub    $0xc,%esp
  80134e:	25 07 0e 00 00       	and    $0xe07,%eax
  801353:	50                   	push   %eax
  801354:	57                   	push   %edi
  801355:	6a 00                	push   $0x0
  801357:	53                   	push   %ebx
  801358:	6a 00                	push   $0x0
  80135a:	e8 fd f9 ff ff       	call   800d5c <sys_page_map>
  80135f:	89 c3                	mov    %eax,%ebx
  801361:	83 c4 20             	add    $0x20,%esp
  801364:	85 c0                	test   %eax,%eax
  801366:	79 a3                	jns    80130b <dup+0x74>
	sys_page_unmap(0, newfd);
  801368:	83 ec 08             	sub    $0x8,%esp
  80136b:	56                   	push   %esi
  80136c:	6a 00                	push   $0x0
  80136e:	e8 2b fa ff ff       	call   800d9e <sys_page_unmap>
	sys_page_unmap(0, nva);
  801373:	83 c4 08             	add    $0x8,%esp
  801376:	57                   	push   %edi
  801377:	6a 00                	push   $0x0
  801379:	e8 20 fa ff ff       	call   800d9e <sys_page_unmap>
	return r;
  80137e:	83 c4 10             	add    $0x10,%esp
  801381:	eb b7                	jmp    80133a <dup+0xa3>

00801383 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801383:	55                   	push   %ebp
  801384:	89 e5                	mov    %esp,%ebp
  801386:	53                   	push   %ebx
  801387:	83 ec 1c             	sub    $0x1c,%esp
  80138a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80138d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801390:	50                   	push   %eax
  801391:	53                   	push   %ebx
  801392:	e8 81 fd ff ff       	call   801118 <fd_lookup>
  801397:	83 c4 10             	add    $0x10,%esp
  80139a:	85 c0                	test   %eax,%eax
  80139c:	78 3f                	js     8013dd <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80139e:	83 ec 08             	sub    $0x8,%esp
  8013a1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013a4:	50                   	push   %eax
  8013a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013a8:	ff 30                	pushl  (%eax)
  8013aa:	e8 b9 fd ff ff       	call   801168 <dev_lookup>
  8013af:	83 c4 10             	add    $0x10,%esp
  8013b2:	85 c0                	test   %eax,%eax
  8013b4:	78 27                	js     8013dd <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8013b6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013b9:	8b 42 08             	mov    0x8(%edx),%eax
  8013bc:	83 e0 03             	and    $0x3,%eax
  8013bf:	83 f8 01             	cmp    $0x1,%eax
  8013c2:	74 1e                	je     8013e2 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8013c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013c7:	8b 40 08             	mov    0x8(%eax),%eax
  8013ca:	85 c0                	test   %eax,%eax
  8013cc:	74 35                	je     801403 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8013ce:	83 ec 04             	sub    $0x4,%esp
  8013d1:	ff 75 10             	pushl  0x10(%ebp)
  8013d4:	ff 75 0c             	pushl  0xc(%ebp)
  8013d7:	52                   	push   %edx
  8013d8:	ff d0                	call   *%eax
  8013da:	83 c4 10             	add    $0x10,%esp
}
  8013dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013e0:	c9                   	leave  
  8013e1:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8013e2:	a1 04 40 80 00       	mov    0x804004,%eax
  8013e7:	8b 40 48             	mov    0x48(%eax),%eax
  8013ea:	83 ec 04             	sub    $0x4,%esp
  8013ed:	53                   	push   %ebx
  8013ee:	50                   	push   %eax
  8013ef:	68 2d 26 80 00       	push   $0x80262d
  8013f4:	e8 08 ee ff ff       	call   800201 <cprintf>
		return -E_INVAL;
  8013f9:	83 c4 10             	add    $0x10,%esp
  8013fc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801401:	eb da                	jmp    8013dd <read+0x5a>
		return -E_NOT_SUPP;
  801403:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801408:	eb d3                	jmp    8013dd <read+0x5a>

0080140a <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80140a:	55                   	push   %ebp
  80140b:	89 e5                	mov    %esp,%ebp
  80140d:	57                   	push   %edi
  80140e:	56                   	push   %esi
  80140f:	53                   	push   %ebx
  801410:	83 ec 0c             	sub    $0xc,%esp
  801413:	8b 7d 08             	mov    0x8(%ebp),%edi
  801416:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801419:	bb 00 00 00 00       	mov    $0x0,%ebx
  80141e:	39 f3                	cmp    %esi,%ebx
  801420:	73 23                	jae    801445 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801422:	83 ec 04             	sub    $0x4,%esp
  801425:	89 f0                	mov    %esi,%eax
  801427:	29 d8                	sub    %ebx,%eax
  801429:	50                   	push   %eax
  80142a:	89 d8                	mov    %ebx,%eax
  80142c:	03 45 0c             	add    0xc(%ebp),%eax
  80142f:	50                   	push   %eax
  801430:	57                   	push   %edi
  801431:	e8 4d ff ff ff       	call   801383 <read>
		if (m < 0)
  801436:	83 c4 10             	add    $0x10,%esp
  801439:	85 c0                	test   %eax,%eax
  80143b:	78 06                	js     801443 <readn+0x39>
			return m;
		if (m == 0)
  80143d:	74 06                	je     801445 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  80143f:	01 c3                	add    %eax,%ebx
  801441:	eb db                	jmp    80141e <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801443:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801445:	89 d8                	mov    %ebx,%eax
  801447:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80144a:	5b                   	pop    %ebx
  80144b:	5e                   	pop    %esi
  80144c:	5f                   	pop    %edi
  80144d:	5d                   	pop    %ebp
  80144e:	c3                   	ret    

0080144f <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80144f:	55                   	push   %ebp
  801450:	89 e5                	mov    %esp,%ebp
  801452:	53                   	push   %ebx
  801453:	83 ec 1c             	sub    $0x1c,%esp
  801456:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801459:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80145c:	50                   	push   %eax
  80145d:	53                   	push   %ebx
  80145e:	e8 b5 fc ff ff       	call   801118 <fd_lookup>
  801463:	83 c4 10             	add    $0x10,%esp
  801466:	85 c0                	test   %eax,%eax
  801468:	78 3a                	js     8014a4 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80146a:	83 ec 08             	sub    $0x8,%esp
  80146d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801470:	50                   	push   %eax
  801471:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801474:	ff 30                	pushl  (%eax)
  801476:	e8 ed fc ff ff       	call   801168 <dev_lookup>
  80147b:	83 c4 10             	add    $0x10,%esp
  80147e:	85 c0                	test   %eax,%eax
  801480:	78 22                	js     8014a4 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801482:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801485:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801489:	74 1e                	je     8014a9 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80148b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80148e:	8b 52 0c             	mov    0xc(%edx),%edx
  801491:	85 d2                	test   %edx,%edx
  801493:	74 35                	je     8014ca <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801495:	83 ec 04             	sub    $0x4,%esp
  801498:	ff 75 10             	pushl  0x10(%ebp)
  80149b:	ff 75 0c             	pushl  0xc(%ebp)
  80149e:	50                   	push   %eax
  80149f:	ff d2                	call   *%edx
  8014a1:	83 c4 10             	add    $0x10,%esp
}
  8014a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014a7:	c9                   	leave  
  8014a8:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8014a9:	a1 04 40 80 00       	mov    0x804004,%eax
  8014ae:	8b 40 48             	mov    0x48(%eax),%eax
  8014b1:	83 ec 04             	sub    $0x4,%esp
  8014b4:	53                   	push   %ebx
  8014b5:	50                   	push   %eax
  8014b6:	68 49 26 80 00       	push   $0x802649
  8014bb:	e8 41 ed ff ff       	call   800201 <cprintf>
		return -E_INVAL;
  8014c0:	83 c4 10             	add    $0x10,%esp
  8014c3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014c8:	eb da                	jmp    8014a4 <write+0x55>
		return -E_NOT_SUPP;
  8014ca:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014cf:	eb d3                	jmp    8014a4 <write+0x55>

008014d1 <seek>:

int
seek(int fdnum, off_t offset)
{
  8014d1:	55                   	push   %ebp
  8014d2:	89 e5                	mov    %esp,%ebp
  8014d4:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014d7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014da:	50                   	push   %eax
  8014db:	ff 75 08             	pushl  0x8(%ebp)
  8014de:	e8 35 fc ff ff       	call   801118 <fd_lookup>
  8014e3:	83 c4 10             	add    $0x10,%esp
  8014e6:	85 c0                	test   %eax,%eax
  8014e8:	78 0e                	js     8014f8 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8014ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014f0:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8014f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014f8:	c9                   	leave  
  8014f9:	c3                   	ret    

008014fa <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8014fa:	55                   	push   %ebp
  8014fb:	89 e5                	mov    %esp,%ebp
  8014fd:	53                   	push   %ebx
  8014fe:	83 ec 1c             	sub    $0x1c,%esp
  801501:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801504:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801507:	50                   	push   %eax
  801508:	53                   	push   %ebx
  801509:	e8 0a fc ff ff       	call   801118 <fd_lookup>
  80150e:	83 c4 10             	add    $0x10,%esp
  801511:	85 c0                	test   %eax,%eax
  801513:	78 37                	js     80154c <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801515:	83 ec 08             	sub    $0x8,%esp
  801518:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80151b:	50                   	push   %eax
  80151c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80151f:	ff 30                	pushl  (%eax)
  801521:	e8 42 fc ff ff       	call   801168 <dev_lookup>
  801526:	83 c4 10             	add    $0x10,%esp
  801529:	85 c0                	test   %eax,%eax
  80152b:	78 1f                	js     80154c <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80152d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801530:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801534:	74 1b                	je     801551 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801536:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801539:	8b 52 18             	mov    0x18(%edx),%edx
  80153c:	85 d2                	test   %edx,%edx
  80153e:	74 32                	je     801572 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801540:	83 ec 08             	sub    $0x8,%esp
  801543:	ff 75 0c             	pushl  0xc(%ebp)
  801546:	50                   	push   %eax
  801547:	ff d2                	call   *%edx
  801549:	83 c4 10             	add    $0x10,%esp
}
  80154c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80154f:	c9                   	leave  
  801550:	c3                   	ret    
			thisenv->env_id, fdnum);
  801551:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801556:	8b 40 48             	mov    0x48(%eax),%eax
  801559:	83 ec 04             	sub    $0x4,%esp
  80155c:	53                   	push   %ebx
  80155d:	50                   	push   %eax
  80155e:	68 0c 26 80 00       	push   $0x80260c
  801563:	e8 99 ec ff ff       	call   800201 <cprintf>
		return -E_INVAL;
  801568:	83 c4 10             	add    $0x10,%esp
  80156b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801570:	eb da                	jmp    80154c <ftruncate+0x52>
		return -E_NOT_SUPP;
  801572:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801577:	eb d3                	jmp    80154c <ftruncate+0x52>

00801579 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801579:	55                   	push   %ebp
  80157a:	89 e5                	mov    %esp,%ebp
  80157c:	53                   	push   %ebx
  80157d:	83 ec 1c             	sub    $0x1c,%esp
  801580:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801583:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801586:	50                   	push   %eax
  801587:	ff 75 08             	pushl  0x8(%ebp)
  80158a:	e8 89 fb ff ff       	call   801118 <fd_lookup>
  80158f:	83 c4 10             	add    $0x10,%esp
  801592:	85 c0                	test   %eax,%eax
  801594:	78 4b                	js     8015e1 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801596:	83 ec 08             	sub    $0x8,%esp
  801599:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80159c:	50                   	push   %eax
  80159d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015a0:	ff 30                	pushl  (%eax)
  8015a2:	e8 c1 fb ff ff       	call   801168 <dev_lookup>
  8015a7:	83 c4 10             	add    $0x10,%esp
  8015aa:	85 c0                	test   %eax,%eax
  8015ac:	78 33                	js     8015e1 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8015ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015b1:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8015b5:	74 2f                	je     8015e6 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8015b7:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8015ba:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8015c1:	00 00 00 
	stat->st_isdir = 0;
  8015c4:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8015cb:	00 00 00 
	stat->st_dev = dev;
  8015ce:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8015d4:	83 ec 08             	sub    $0x8,%esp
  8015d7:	53                   	push   %ebx
  8015d8:	ff 75 f0             	pushl  -0x10(%ebp)
  8015db:	ff 50 14             	call   *0x14(%eax)
  8015de:	83 c4 10             	add    $0x10,%esp
}
  8015e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015e4:	c9                   	leave  
  8015e5:	c3                   	ret    
		return -E_NOT_SUPP;
  8015e6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015eb:	eb f4                	jmp    8015e1 <fstat+0x68>

008015ed <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8015ed:	55                   	push   %ebp
  8015ee:	89 e5                	mov    %esp,%ebp
  8015f0:	56                   	push   %esi
  8015f1:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8015f2:	83 ec 08             	sub    $0x8,%esp
  8015f5:	6a 00                	push   $0x0
  8015f7:	ff 75 08             	pushl  0x8(%ebp)
  8015fa:	e8 bb 01 00 00       	call   8017ba <open>
  8015ff:	89 c3                	mov    %eax,%ebx
  801601:	83 c4 10             	add    $0x10,%esp
  801604:	85 c0                	test   %eax,%eax
  801606:	78 1b                	js     801623 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801608:	83 ec 08             	sub    $0x8,%esp
  80160b:	ff 75 0c             	pushl  0xc(%ebp)
  80160e:	50                   	push   %eax
  80160f:	e8 65 ff ff ff       	call   801579 <fstat>
  801614:	89 c6                	mov    %eax,%esi
	close(fd);
  801616:	89 1c 24             	mov    %ebx,(%esp)
  801619:	e8 27 fc ff ff       	call   801245 <close>
	return r;
  80161e:	83 c4 10             	add    $0x10,%esp
  801621:	89 f3                	mov    %esi,%ebx
}
  801623:	89 d8                	mov    %ebx,%eax
  801625:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801628:	5b                   	pop    %ebx
  801629:	5e                   	pop    %esi
  80162a:	5d                   	pop    %ebp
  80162b:	c3                   	ret    

0080162c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80162c:	55                   	push   %ebp
  80162d:	89 e5                	mov    %esp,%ebp
  80162f:	56                   	push   %esi
  801630:	53                   	push   %ebx
  801631:	89 c6                	mov    %eax,%esi
  801633:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801635:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80163c:	74 27                	je     801665 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80163e:	6a 07                	push   $0x7
  801640:	68 00 50 80 00       	push   $0x805000
  801645:	56                   	push   %esi
  801646:	ff 35 00 40 80 00    	pushl  0x804000
  80164c:	e8 94 08 00 00       	call   801ee5 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801651:	83 c4 0c             	add    $0xc,%esp
  801654:	6a 00                	push   $0x0
  801656:	53                   	push   %ebx
  801657:	6a 00                	push   $0x0
  801659:	e8 1e 08 00 00       	call   801e7c <ipc_recv>
}
  80165e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801661:	5b                   	pop    %ebx
  801662:	5e                   	pop    %esi
  801663:	5d                   	pop    %ebp
  801664:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801665:	83 ec 0c             	sub    $0xc,%esp
  801668:	6a 01                	push   $0x1
  80166a:	e8 c3 08 00 00       	call   801f32 <ipc_find_env>
  80166f:	a3 00 40 80 00       	mov    %eax,0x804000
  801674:	83 c4 10             	add    $0x10,%esp
  801677:	eb c5                	jmp    80163e <fsipc+0x12>

00801679 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801679:	55                   	push   %ebp
  80167a:	89 e5                	mov    %esp,%ebp
  80167c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80167f:	8b 45 08             	mov    0x8(%ebp),%eax
  801682:	8b 40 0c             	mov    0xc(%eax),%eax
  801685:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80168a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80168d:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801692:	ba 00 00 00 00       	mov    $0x0,%edx
  801697:	b8 02 00 00 00       	mov    $0x2,%eax
  80169c:	e8 8b ff ff ff       	call   80162c <fsipc>
}
  8016a1:	c9                   	leave  
  8016a2:	c3                   	ret    

008016a3 <devfile_flush>:
{
  8016a3:	55                   	push   %ebp
  8016a4:	89 e5                	mov    %esp,%ebp
  8016a6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8016a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8016af:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8016b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8016b9:	b8 06 00 00 00       	mov    $0x6,%eax
  8016be:	e8 69 ff ff ff       	call   80162c <fsipc>
}
  8016c3:	c9                   	leave  
  8016c4:	c3                   	ret    

008016c5 <devfile_stat>:
{
  8016c5:	55                   	push   %ebp
  8016c6:	89 e5                	mov    %esp,%ebp
  8016c8:	53                   	push   %ebx
  8016c9:	83 ec 04             	sub    $0x4,%esp
  8016cc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8016cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8016d5:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8016da:	ba 00 00 00 00       	mov    $0x0,%edx
  8016df:	b8 05 00 00 00       	mov    $0x5,%eax
  8016e4:	e8 43 ff ff ff       	call   80162c <fsipc>
  8016e9:	85 c0                	test   %eax,%eax
  8016eb:	78 2c                	js     801719 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8016ed:	83 ec 08             	sub    $0x8,%esp
  8016f0:	68 00 50 80 00       	push   $0x805000
  8016f5:	53                   	push   %ebx
  8016f6:	e8 2c f2 ff ff       	call   800927 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8016fb:	a1 80 50 80 00       	mov    0x805080,%eax
  801700:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801706:	a1 84 50 80 00       	mov    0x805084,%eax
  80170b:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801711:	83 c4 10             	add    $0x10,%esp
  801714:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801719:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80171c:	c9                   	leave  
  80171d:	c3                   	ret    

0080171e <devfile_write>:
{
  80171e:	55                   	push   %ebp
  80171f:	89 e5                	mov    %esp,%ebp
  801721:	83 ec 0c             	sub    $0xc,%esp
	panic("devfile_write not implemented");
  801724:	68 78 26 80 00       	push   $0x802678
  801729:	68 90 00 00 00       	push   $0x90
  80172e:	68 96 26 80 00       	push   $0x802696
  801733:	e8 fe 06 00 00       	call   801e36 <_panic>

00801738 <devfile_read>:
{
  801738:	55                   	push   %ebp
  801739:	89 e5                	mov    %esp,%ebp
  80173b:	56                   	push   %esi
  80173c:	53                   	push   %ebx
  80173d:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801740:	8b 45 08             	mov    0x8(%ebp),%eax
  801743:	8b 40 0c             	mov    0xc(%eax),%eax
  801746:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80174b:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801751:	ba 00 00 00 00       	mov    $0x0,%edx
  801756:	b8 03 00 00 00       	mov    $0x3,%eax
  80175b:	e8 cc fe ff ff       	call   80162c <fsipc>
  801760:	89 c3                	mov    %eax,%ebx
  801762:	85 c0                	test   %eax,%eax
  801764:	78 1f                	js     801785 <devfile_read+0x4d>
	assert(r <= n);
  801766:	39 f0                	cmp    %esi,%eax
  801768:	77 24                	ja     80178e <devfile_read+0x56>
	assert(r <= PGSIZE);
  80176a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80176f:	7f 33                	jg     8017a4 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801771:	83 ec 04             	sub    $0x4,%esp
  801774:	50                   	push   %eax
  801775:	68 00 50 80 00       	push   $0x805000
  80177a:	ff 75 0c             	pushl  0xc(%ebp)
  80177d:	e8 33 f3 ff ff       	call   800ab5 <memmove>
	return r;
  801782:	83 c4 10             	add    $0x10,%esp
}
  801785:	89 d8                	mov    %ebx,%eax
  801787:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80178a:	5b                   	pop    %ebx
  80178b:	5e                   	pop    %esi
  80178c:	5d                   	pop    %ebp
  80178d:	c3                   	ret    
	assert(r <= n);
  80178e:	68 a1 26 80 00       	push   $0x8026a1
  801793:	68 a8 26 80 00       	push   $0x8026a8
  801798:	6a 7c                	push   $0x7c
  80179a:	68 96 26 80 00       	push   $0x802696
  80179f:	e8 92 06 00 00       	call   801e36 <_panic>
	assert(r <= PGSIZE);
  8017a4:	68 bd 26 80 00       	push   $0x8026bd
  8017a9:	68 a8 26 80 00       	push   $0x8026a8
  8017ae:	6a 7d                	push   $0x7d
  8017b0:	68 96 26 80 00       	push   $0x802696
  8017b5:	e8 7c 06 00 00       	call   801e36 <_panic>

008017ba <open>:
{
  8017ba:	55                   	push   %ebp
  8017bb:	89 e5                	mov    %esp,%ebp
  8017bd:	56                   	push   %esi
  8017be:	53                   	push   %ebx
  8017bf:	83 ec 1c             	sub    $0x1c,%esp
  8017c2:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8017c5:	56                   	push   %esi
  8017c6:	e8 23 f1 ff ff       	call   8008ee <strlen>
  8017cb:	83 c4 10             	add    $0x10,%esp
  8017ce:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8017d3:	7f 6c                	jg     801841 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8017d5:	83 ec 0c             	sub    $0xc,%esp
  8017d8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017db:	50                   	push   %eax
  8017dc:	e8 e5 f8 ff ff       	call   8010c6 <fd_alloc>
  8017e1:	89 c3                	mov    %eax,%ebx
  8017e3:	83 c4 10             	add    $0x10,%esp
  8017e6:	85 c0                	test   %eax,%eax
  8017e8:	78 3c                	js     801826 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8017ea:	83 ec 08             	sub    $0x8,%esp
  8017ed:	56                   	push   %esi
  8017ee:	68 00 50 80 00       	push   $0x805000
  8017f3:	e8 2f f1 ff ff       	call   800927 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8017f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017fb:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801800:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801803:	b8 01 00 00 00       	mov    $0x1,%eax
  801808:	e8 1f fe ff ff       	call   80162c <fsipc>
  80180d:	89 c3                	mov    %eax,%ebx
  80180f:	83 c4 10             	add    $0x10,%esp
  801812:	85 c0                	test   %eax,%eax
  801814:	78 19                	js     80182f <open+0x75>
	return fd2num(fd);
  801816:	83 ec 0c             	sub    $0xc,%esp
  801819:	ff 75 f4             	pushl  -0xc(%ebp)
  80181c:	e8 7e f8 ff ff       	call   80109f <fd2num>
  801821:	89 c3                	mov    %eax,%ebx
  801823:	83 c4 10             	add    $0x10,%esp
}
  801826:	89 d8                	mov    %ebx,%eax
  801828:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80182b:	5b                   	pop    %ebx
  80182c:	5e                   	pop    %esi
  80182d:	5d                   	pop    %ebp
  80182e:	c3                   	ret    
		fd_close(fd, 0);
  80182f:	83 ec 08             	sub    $0x8,%esp
  801832:	6a 00                	push   $0x0
  801834:	ff 75 f4             	pushl  -0xc(%ebp)
  801837:	e8 82 f9 ff ff       	call   8011be <fd_close>
		return r;
  80183c:	83 c4 10             	add    $0x10,%esp
  80183f:	eb e5                	jmp    801826 <open+0x6c>
		return -E_BAD_PATH;
  801841:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801846:	eb de                	jmp    801826 <open+0x6c>

00801848 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801848:	55                   	push   %ebp
  801849:	89 e5                	mov    %esp,%ebp
  80184b:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80184e:	ba 00 00 00 00       	mov    $0x0,%edx
  801853:	b8 08 00 00 00       	mov    $0x8,%eax
  801858:	e8 cf fd ff ff       	call   80162c <fsipc>
}
  80185d:	c9                   	leave  
  80185e:	c3                   	ret    

0080185f <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  80185f:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801863:	7f 01                	jg     801866 <writebuf+0x7>
  801865:	c3                   	ret    
{
  801866:	55                   	push   %ebp
  801867:	89 e5                	mov    %esp,%ebp
  801869:	53                   	push   %ebx
  80186a:	83 ec 08             	sub    $0x8,%esp
  80186d:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  80186f:	ff 70 04             	pushl  0x4(%eax)
  801872:	8d 40 10             	lea    0x10(%eax),%eax
  801875:	50                   	push   %eax
  801876:	ff 33                	pushl  (%ebx)
  801878:	e8 d2 fb ff ff       	call   80144f <write>
		if (result > 0)
  80187d:	83 c4 10             	add    $0x10,%esp
  801880:	85 c0                	test   %eax,%eax
  801882:	7e 03                	jle    801887 <writebuf+0x28>
			b->result += result;
  801884:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801887:	39 43 04             	cmp    %eax,0x4(%ebx)
  80188a:	74 0d                	je     801899 <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  80188c:	85 c0                	test   %eax,%eax
  80188e:	ba 00 00 00 00       	mov    $0x0,%edx
  801893:	0f 4f c2             	cmovg  %edx,%eax
  801896:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801899:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80189c:	c9                   	leave  
  80189d:	c3                   	ret    

0080189e <putch>:

static void
putch(int ch, void *thunk)
{
  80189e:	55                   	push   %ebp
  80189f:	89 e5                	mov    %esp,%ebp
  8018a1:	53                   	push   %ebx
  8018a2:	83 ec 04             	sub    $0x4,%esp
  8018a5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  8018a8:	8b 53 04             	mov    0x4(%ebx),%edx
  8018ab:	8d 42 01             	lea    0x1(%edx),%eax
  8018ae:	89 43 04             	mov    %eax,0x4(%ebx)
  8018b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018b4:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  8018b8:	3d 00 01 00 00       	cmp    $0x100,%eax
  8018bd:	74 06                	je     8018c5 <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  8018bf:	83 c4 04             	add    $0x4,%esp
  8018c2:	5b                   	pop    %ebx
  8018c3:	5d                   	pop    %ebp
  8018c4:	c3                   	ret    
		writebuf(b);
  8018c5:	89 d8                	mov    %ebx,%eax
  8018c7:	e8 93 ff ff ff       	call   80185f <writebuf>
		b->idx = 0;
  8018cc:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  8018d3:	eb ea                	jmp    8018bf <putch+0x21>

008018d5 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  8018d5:	55                   	push   %ebp
  8018d6:	89 e5                	mov    %esp,%ebp
  8018d8:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  8018de:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e1:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  8018e7:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  8018ee:	00 00 00 
	b.result = 0;
  8018f1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8018f8:	00 00 00 
	b.error = 1;
  8018fb:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801902:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801905:	ff 75 10             	pushl  0x10(%ebp)
  801908:	ff 75 0c             	pushl  0xc(%ebp)
  80190b:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801911:	50                   	push   %eax
  801912:	68 9e 18 80 00       	push   $0x80189e
  801917:	e8 12 ea ff ff       	call   80032e <vprintfmt>
	if (b.idx > 0)
  80191c:	83 c4 10             	add    $0x10,%esp
  80191f:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801926:	7f 11                	jg     801939 <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  801928:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80192e:	85 c0                	test   %eax,%eax
  801930:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801937:	c9                   	leave  
  801938:	c3                   	ret    
		writebuf(&b);
  801939:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80193f:	e8 1b ff ff ff       	call   80185f <writebuf>
  801944:	eb e2                	jmp    801928 <vfprintf+0x53>

00801946 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801946:	55                   	push   %ebp
  801947:	89 e5                	mov    %esp,%ebp
  801949:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80194c:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  80194f:	50                   	push   %eax
  801950:	ff 75 0c             	pushl  0xc(%ebp)
  801953:	ff 75 08             	pushl  0x8(%ebp)
  801956:	e8 7a ff ff ff       	call   8018d5 <vfprintf>
	va_end(ap);

	return cnt;
}
  80195b:	c9                   	leave  
  80195c:	c3                   	ret    

0080195d <printf>:

int
printf(const char *fmt, ...)
{
  80195d:	55                   	push   %ebp
  80195e:	89 e5                	mov    %esp,%ebp
  801960:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801963:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801966:	50                   	push   %eax
  801967:	ff 75 08             	pushl  0x8(%ebp)
  80196a:	6a 01                	push   $0x1
  80196c:	e8 64 ff ff ff       	call   8018d5 <vfprintf>
	va_end(ap);

	return cnt;
}
  801971:	c9                   	leave  
  801972:	c3                   	ret    

00801973 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801973:	55                   	push   %ebp
  801974:	89 e5                	mov    %esp,%ebp
  801976:	56                   	push   %esi
  801977:	53                   	push   %ebx
  801978:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80197b:	83 ec 0c             	sub    $0xc,%esp
  80197e:	ff 75 08             	pushl  0x8(%ebp)
  801981:	e8 29 f7 ff ff       	call   8010af <fd2data>
  801986:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801988:	83 c4 08             	add    $0x8,%esp
  80198b:	68 c9 26 80 00       	push   $0x8026c9
  801990:	53                   	push   %ebx
  801991:	e8 91 ef ff ff       	call   800927 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801996:	8b 46 04             	mov    0x4(%esi),%eax
  801999:	2b 06                	sub    (%esi),%eax
  80199b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8019a1:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8019a8:	00 00 00 
	stat->st_dev = &devpipe;
  8019ab:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  8019b2:	30 80 00 
	return 0;
}
  8019b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8019ba:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019bd:	5b                   	pop    %ebx
  8019be:	5e                   	pop    %esi
  8019bf:	5d                   	pop    %ebp
  8019c0:	c3                   	ret    

008019c1 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8019c1:	55                   	push   %ebp
  8019c2:	89 e5                	mov    %esp,%ebp
  8019c4:	53                   	push   %ebx
  8019c5:	83 ec 0c             	sub    $0xc,%esp
  8019c8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8019cb:	53                   	push   %ebx
  8019cc:	6a 00                	push   $0x0
  8019ce:	e8 cb f3 ff ff       	call   800d9e <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8019d3:	89 1c 24             	mov    %ebx,(%esp)
  8019d6:	e8 d4 f6 ff ff       	call   8010af <fd2data>
  8019db:	83 c4 08             	add    $0x8,%esp
  8019de:	50                   	push   %eax
  8019df:	6a 00                	push   $0x0
  8019e1:	e8 b8 f3 ff ff       	call   800d9e <sys_page_unmap>
}
  8019e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019e9:	c9                   	leave  
  8019ea:	c3                   	ret    

008019eb <_pipeisclosed>:
{
  8019eb:	55                   	push   %ebp
  8019ec:	89 e5                	mov    %esp,%ebp
  8019ee:	57                   	push   %edi
  8019ef:	56                   	push   %esi
  8019f0:	53                   	push   %ebx
  8019f1:	83 ec 1c             	sub    $0x1c,%esp
  8019f4:	89 c7                	mov    %eax,%edi
  8019f6:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8019f8:	a1 04 40 80 00       	mov    0x804004,%eax
  8019fd:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801a00:	83 ec 0c             	sub    $0xc,%esp
  801a03:	57                   	push   %edi
  801a04:	e8 68 05 00 00       	call   801f71 <pageref>
  801a09:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801a0c:	89 34 24             	mov    %esi,(%esp)
  801a0f:	e8 5d 05 00 00       	call   801f71 <pageref>
		nn = thisenv->env_runs;
  801a14:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801a1a:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801a1d:	83 c4 10             	add    $0x10,%esp
  801a20:	39 cb                	cmp    %ecx,%ebx
  801a22:	74 1b                	je     801a3f <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801a24:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801a27:	75 cf                	jne    8019f8 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801a29:	8b 42 58             	mov    0x58(%edx),%eax
  801a2c:	6a 01                	push   $0x1
  801a2e:	50                   	push   %eax
  801a2f:	53                   	push   %ebx
  801a30:	68 d0 26 80 00       	push   $0x8026d0
  801a35:	e8 c7 e7 ff ff       	call   800201 <cprintf>
  801a3a:	83 c4 10             	add    $0x10,%esp
  801a3d:	eb b9                	jmp    8019f8 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801a3f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801a42:	0f 94 c0             	sete   %al
  801a45:	0f b6 c0             	movzbl %al,%eax
}
  801a48:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a4b:	5b                   	pop    %ebx
  801a4c:	5e                   	pop    %esi
  801a4d:	5f                   	pop    %edi
  801a4e:	5d                   	pop    %ebp
  801a4f:	c3                   	ret    

00801a50 <devpipe_write>:
{
  801a50:	55                   	push   %ebp
  801a51:	89 e5                	mov    %esp,%ebp
  801a53:	57                   	push   %edi
  801a54:	56                   	push   %esi
  801a55:	53                   	push   %ebx
  801a56:	83 ec 28             	sub    $0x28,%esp
  801a59:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801a5c:	56                   	push   %esi
  801a5d:	e8 4d f6 ff ff       	call   8010af <fd2data>
  801a62:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801a64:	83 c4 10             	add    $0x10,%esp
  801a67:	bf 00 00 00 00       	mov    $0x0,%edi
  801a6c:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801a6f:	74 4f                	je     801ac0 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801a71:	8b 43 04             	mov    0x4(%ebx),%eax
  801a74:	8b 0b                	mov    (%ebx),%ecx
  801a76:	8d 51 20             	lea    0x20(%ecx),%edx
  801a79:	39 d0                	cmp    %edx,%eax
  801a7b:	72 14                	jb     801a91 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801a7d:	89 da                	mov    %ebx,%edx
  801a7f:	89 f0                	mov    %esi,%eax
  801a81:	e8 65 ff ff ff       	call   8019eb <_pipeisclosed>
  801a86:	85 c0                	test   %eax,%eax
  801a88:	75 3b                	jne    801ac5 <devpipe_write+0x75>
			sys_yield();
  801a8a:	e8 6b f2 ff ff       	call   800cfa <sys_yield>
  801a8f:	eb e0                	jmp    801a71 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801a91:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a94:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801a98:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801a9b:	89 c2                	mov    %eax,%edx
  801a9d:	c1 fa 1f             	sar    $0x1f,%edx
  801aa0:	89 d1                	mov    %edx,%ecx
  801aa2:	c1 e9 1b             	shr    $0x1b,%ecx
  801aa5:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801aa8:	83 e2 1f             	and    $0x1f,%edx
  801aab:	29 ca                	sub    %ecx,%edx
  801aad:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801ab1:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801ab5:	83 c0 01             	add    $0x1,%eax
  801ab8:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801abb:	83 c7 01             	add    $0x1,%edi
  801abe:	eb ac                	jmp    801a6c <devpipe_write+0x1c>
	return i;
  801ac0:	8b 45 10             	mov    0x10(%ebp),%eax
  801ac3:	eb 05                	jmp    801aca <devpipe_write+0x7a>
				return 0;
  801ac5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801acd:	5b                   	pop    %ebx
  801ace:	5e                   	pop    %esi
  801acf:	5f                   	pop    %edi
  801ad0:	5d                   	pop    %ebp
  801ad1:	c3                   	ret    

00801ad2 <devpipe_read>:
{
  801ad2:	55                   	push   %ebp
  801ad3:	89 e5                	mov    %esp,%ebp
  801ad5:	57                   	push   %edi
  801ad6:	56                   	push   %esi
  801ad7:	53                   	push   %ebx
  801ad8:	83 ec 18             	sub    $0x18,%esp
  801adb:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801ade:	57                   	push   %edi
  801adf:	e8 cb f5 ff ff       	call   8010af <fd2data>
  801ae4:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801ae6:	83 c4 10             	add    $0x10,%esp
  801ae9:	be 00 00 00 00       	mov    $0x0,%esi
  801aee:	3b 75 10             	cmp    0x10(%ebp),%esi
  801af1:	75 14                	jne    801b07 <devpipe_read+0x35>
	return i;
  801af3:	8b 45 10             	mov    0x10(%ebp),%eax
  801af6:	eb 02                	jmp    801afa <devpipe_read+0x28>
				return i;
  801af8:	89 f0                	mov    %esi,%eax
}
  801afa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801afd:	5b                   	pop    %ebx
  801afe:	5e                   	pop    %esi
  801aff:	5f                   	pop    %edi
  801b00:	5d                   	pop    %ebp
  801b01:	c3                   	ret    
			sys_yield();
  801b02:	e8 f3 f1 ff ff       	call   800cfa <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801b07:	8b 03                	mov    (%ebx),%eax
  801b09:	3b 43 04             	cmp    0x4(%ebx),%eax
  801b0c:	75 18                	jne    801b26 <devpipe_read+0x54>
			if (i > 0)
  801b0e:	85 f6                	test   %esi,%esi
  801b10:	75 e6                	jne    801af8 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801b12:	89 da                	mov    %ebx,%edx
  801b14:	89 f8                	mov    %edi,%eax
  801b16:	e8 d0 fe ff ff       	call   8019eb <_pipeisclosed>
  801b1b:	85 c0                	test   %eax,%eax
  801b1d:	74 e3                	je     801b02 <devpipe_read+0x30>
				return 0;
  801b1f:	b8 00 00 00 00       	mov    $0x0,%eax
  801b24:	eb d4                	jmp    801afa <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801b26:	99                   	cltd   
  801b27:	c1 ea 1b             	shr    $0x1b,%edx
  801b2a:	01 d0                	add    %edx,%eax
  801b2c:	83 e0 1f             	and    $0x1f,%eax
  801b2f:	29 d0                	sub    %edx,%eax
  801b31:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801b36:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b39:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801b3c:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801b3f:	83 c6 01             	add    $0x1,%esi
  801b42:	eb aa                	jmp    801aee <devpipe_read+0x1c>

00801b44 <pipe>:
{
  801b44:	55                   	push   %ebp
  801b45:	89 e5                	mov    %esp,%ebp
  801b47:	56                   	push   %esi
  801b48:	53                   	push   %ebx
  801b49:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801b4c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b4f:	50                   	push   %eax
  801b50:	e8 71 f5 ff ff       	call   8010c6 <fd_alloc>
  801b55:	89 c3                	mov    %eax,%ebx
  801b57:	83 c4 10             	add    $0x10,%esp
  801b5a:	85 c0                	test   %eax,%eax
  801b5c:	0f 88 23 01 00 00    	js     801c85 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b62:	83 ec 04             	sub    $0x4,%esp
  801b65:	68 07 04 00 00       	push   $0x407
  801b6a:	ff 75 f4             	pushl  -0xc(%ebp)
  801b6d:	6a 00                	push   $0x0
  801b6f:	e8 a5 f1 ff ff       	call   800d19 <sys_page_alloc>
  801b74:	89 c3                	mov    %eax,%ebx
  801b76:	83 c4 10             	add    $0x10,%esp
  801b79:	85 c0                	test   %eax,%eax
  801b7b:	0f 88 04 01 00 00    	js     801c85 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801b81:	83 ec 0c             	sub    $0xc,%esp
  801b84:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b87:	50                   	push   %eax
  801b88:	e8 39 f5 ff ff       	call   8010c6 <fd_alloc>
  801b8d:	89 c3                	mov    %eax,%ebx
  801b8f:	83 c4 10             	add    $0x10,%esp
  801b92:	85 c0                	test   %eax,%eax
  801b94:	0f 88 db 00 00 00    	js     801c75 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b9a:	83 ec 04             	sub    $0x4,%esp
  801b9d:	68 07 04 00 00       	push   $0x407
  801ba2:	ff 75 f0             	pushl  -0x10(%ebp)
  801ba5:	6a 00                	push   $0x0
  801ba7:	e8 6d f1 ff ff       	call   800d19 <sys_page_alloc>
  801bac:	89 c3                	mov    %eax,%ebx
  801bae:	83 c4 10             	add    $0x10,%esp
  801bb1:	85 c0                	test   %eax,%eax
  801bb3:	0f 88 bc 00 00 00    	js     801c75 <pipe+0x131>
	va = fd2data(fd0);
  801bb9:	83 ec 0c             	sub    $0xc,%esp
  801bbc:	ff 75 f4             	pushl  -0xc(%ebp)
  801bbf:	e8 eb f4 ff ff       	call   8010af <fd2data>
  801bc4:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801bc6:	83 c4 0c             	add    $0xc,%esp
  801bc9:	68 07 04 00 00       	push   $0x407
  801bce:	50                   	push   %eax
  801bcf:	6a 00                	push   $0x0
  801bd1:	e8 43 f1 ff ff       	call   800d19 <sys_page_alloc>
  801bd6:	89 c3                	mov    %eax,%ebx
  801bd8:	83 c4 10             	add    $0x10,%esp
  801bdb:	85 c0                	test   %eax,%eax
  801bdd:	0f 88 82 00 00 00    	js     801c65 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801be3:	83 ec 0c             	sub    $0xc,%esp
  801be6:	ff 75 f0             	pushl  -0x10(%ebp)
  801be9:	e8 c1 f4 ff ff       	call   8010af <fd2data>
  801bee:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801bf5:	50                   	push   %eax
  801bf6:	6a 00                	push   $0x0
  801bf8:	56                   	push   %esi
  801bf9:	6a 00                	push   $0x0
  801bfb:	e8 5c f1 ff ff       	call   800d5c <sys_page_map>
  801c00:	89 c3                	mov    %eax,%ebx
  801c02:	83 c4 20             	add    $0x20,%esp
  801c05:	85 c0                	test   %eax,%eax
  801c07:	78 4e                	js     801c57 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801c09:	a1 20 30 80 00       	mov    0x803020,%eax
  801c0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c11:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801c13:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c16:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801c1d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c20:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801c22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c25:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801c2c:	83 ec 0c             	sub    $0xc,%esp
  801c2f:	ff 75 f4             	pushl  -0xc(%ebp)
  801c32:	e8 68 f4 ff ff       	call   80109f <fd2num>
  801c37:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c3a:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801c3c:	83 c4 04             	add    $0x4,%esp
  801c3f:	ff 75 f0             	pushl  -0x10(%ebp)
  801c42:	e8 58 f4 ff ff       	call   80109f <fd2num>
  801c47:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c4a:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801c4d:	83 c4 10             	add    $0x10,%esp
  801c50:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c55:	eb 2e                	jmp    801c85 <pipe+0x141>
	sys_page_unmap(0, va);
  801c57:	83 ec 08             	sub    $0x8,%esp
  801c5a:	56                   	push   %esi
  801c5b:	6a 00                	push   $0x0
  801c5d:	e8 3c f1 ff ff       	call   800d9e <sys_page_unmap>
  801c62:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801c65:	83 ec 08             	sub    $0x8,%esp
  801c68:	ff 75 f0             	pushl  -0x10(%ebp)
  801c6b:	6a 00                	push   $0x0
  801c6d:	e8 2c f1 ff ff       	call   800d9e <sys_page_unmap>
  801c72:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801c75:	83 ec 08             	sub    $0x8,%esp
  801c78:	ff 75 f4             	pushl  -0xc(%ebp)
  801c7b:	6a 00                	push   $0x0
  801c7d:	e8 1c f1 ff ff       	call   800d9e <sys_page_unmap>
  801c82:	83 c4 10             	add    $0x10,%esp
}
  801c85:	89 d8                	mov    %ebx,%eax
  801c87:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c8a:	5b                   	pop    %ebx
  801c8b:	5e                   	pop    %esi
  801c8c:	5d                   	pop    %ebp
  801c8d:	c3                   	ret    

00801c8e <pipeisclosed>:
{
  801c8e:	55                   	push   %ebp
  801c8f:	89 e5                	mov    %esp,%ebp
  801c91:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c94:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c97:	50                   	push   %eax
  801c98:	ff 75 08             	pushl  0x8(%ebp)
  801c9b:	e8 78 f4 ff ff       	call   801118 <fd_lookup>
  801ca0:	83 c4 10             	add    $0x10,%esp
  801ca3:	85 c0                	test   %eax,%eax
  801ca5:	78 18                	js     801cbf <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801ca7:	83 ec 0c             	sub    $0xc,%esp
  801caa:	ff 75 f4             	pushl  -0xc(%ebp)
  801cad:	e8 fd f3 ff ff       	call   8010af <fd2data>
	return _pipeisclosed(fd, p);
  801cb2:	89 c2                	mov    %eax,%edx
  801cb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cb7:	e8 2f fd ff ff       	call   8019eb <_pipeisclosed>
  801cbc:	83 c4 10             	add    $0x10,%esp
}
  801cbf:	c9                   	leave  
  801cc0:	c3                   	ret    

00801cc1 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801cc1:	b8 00 00 00 00       	mov    $0x0,%eax
  801cc6:	c3                   	ret    

00801cc7 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801cc7:	55                   	push   %ebp
  801cc8:	89 e5                	mov    %esp,%ebp
  801cca:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801ccd:	68 e8 26 80 00       	push   $0x8026e8
  801cd2:	ff 75 0c             	pushl  0xc(%ebp)
  801cd5:	e8 4d ec ff ff       	call   800927 <strcpy>
	return 0;
}
  801cda:	b8 00 00 00 00       	mov    $0x0,%eax
  801cdf:	c9                   	leave  
  801ce0:	c3                   	ret    

00801ce1 <devcons_write>:
{
  801ce1:	55                   	push   %ebp
  801ce2:	89 e5                	mov    %esp,%ebp
  801ce4:	57                   	push   %edi
  801ce5:	56                   	push   %esi
  801ce6:	53                   	push   %ebx
  801ce7:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801ced:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801cf2:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801cf8:	3b 75 10             	cmp    0x10(%ebp),%esi
  801cfb:	73 31                	jae    801d2e <devcons_write+0x4d>
		m = n - tot;
  801cfd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801d00:	29 f3                	sub    %esi,%ebx
  801d02:	83 fb 7f             	cmp    $0x7f,%ebx
  801d05:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801d0a:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801d0d:	83 ec 04             	sub    $0x4,%esp
  801d10:	53                   	push   %ebx
  801d11:	89 f0                	mov    %esi,%eax
  801d13:	03 45 0c             	add    0xc(%ebp),%eax
  801d16:	50                   	push   %eax
  801d17:	57                   	push   %edi
  801d18:	e8 98 ed ff ff       	call   800ab5 <memmove>
		sys_cputs(buf, m);
  801d1d:	83 c4 08             	add    $0x8,%esp
  801d20:	53                   	push   %ebx
  801d21:	57                   	push   %edi
  801d22:	e8 36 ef ff ff       	call   800c5d <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801d27:	01 de                	add    %ebx,%esi
  801d29:	83 c4 10             	add    $0x10,%esp
  801d2c:	eb ca                	jmp    801cf8 <devcons_write+0x17>
}
  801d2e:	89 f0                	mov    %esi,%eax
  801d30:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d33:	5b                   	pop    %ebx
  801d34:	5e                   	pop    %esi
  801d35:	5f                   	pop    %edi
  801d36:	5d                   	pop    %ebp
  801d37:	c3                   	ret    

00801d38 <devcons_read>:
{
  801d38:	55                   	push   %ebp
  801d39:	89 e5                	mov    %esp,%ebp
  801d3b:	83 ec 08             	sub    $0x8,%esp
  801d3e:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801d43:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d47:	74 21                	je     801d6a <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  801d49:	e8 2d ef ff ff       	call   800c7b <sys_cgetc>
  801d4e:	85 c0                	test   %eax,%eax
  801d50:	75 07                	jne    801d59 <devcons_read+0x21>
		sys_yield();
  801d52:	e8 a3 ef ff ff       	call   800cfa <sys_yield>
  801d57:	eb f0                	jmp    801d49 <devcons_read+0x11>
	if (c < 0)
  801d59:	78 0f                	js     801d6a <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  801d5b:	83 f8 04             	cmp    $0x4,%eax
  801d5e:	74 0c                	je     801d6c <devcons_read+0x34>
	*(char*)vbuf = c;
  801d60:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d63:	88 02                	mov    %al,(%edx)
	return 1;
  801d65:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801d6a:	c9                   	leave  
  801d6b:	c3                   	ret    
		return 0;
  801d6c:	b8 00 00 00 00       	mov    $0x0,%eax
  801d71:	eb f7                	jmp    801d6a <devcons_read+0x32>

00801d73 <cputchar>:
{
  801d73:	55                   	push   %ebp
  801d74:	89 e5                	mov    %esp,%ebp
  801d76:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801d79:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7c:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801d7f:	6a 01                	push   $0x1
  801d81:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801d84:	50                   	push   %eax
  801d85:	e8 d3 ee ff ff       	call   800c5d <sys_cputs>
}
  801d8a:	83 c4 10             	add    $0x10,%esp
  801d8d:	c9                   	leave  
  801d8e:	c3                   	ret    

00801d8f <getchar>:
{
  801d8f:	55                   	push   %ebp
  801d90:	89 e5                	mov    %esp,%ebp
  801d92:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801d95:	6a 01                	push   $0x1
  801d97:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801d9a:	50                   	push   %eax
  801d9b:	6a 00                	push   $0x0
  801d9d:	e8 e1 f5 ff ff       	call   801383 <read>
	if (r < 0)
  801da2:	83 c4 10             	add    $0x10,%esp
  801da5:	85 c0                	test   %eax,%eax
  801da7:	78 06                	js     801daf <getchar+0x20>
	if (r < 1)
  801da9:	74 06                	je     801db1 <getchar+0x22>
	return c;
  801dab:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801daf:	c9                   	leave  
  801db0:	c3                   	ret    
		return -E_EOF;
  801db1:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801db6:	eb f7                	jmp    801daf <getchar+0x20>

00801db8 <iscons>:
{
  801db8:	55                   	push   %ebp
  801db9:	89 e5                	mov    %esp,%ebp
  801dbb:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801dbe:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dc1:	50                   	push   %eax
  801dc2:	ff 75 08             	pushl  0x8(%ebp)
  801dc5:	e8 4e f3 ff ff       	call   801118 <fd_lookup>
  801dca:	83 c4 10             	add    $0x10,%esp
  801dcd:	85 c0                	test   %eax,%eax
  801dcf:	78 11                	js     801de2 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801dd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd4:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801dda:	39 10                	cmp    %edx,(%eax)
  801ddc:	0f 94 c0             	sete   %al
  801ddf:	0f b6 c0             	movzbl %al,%eax
}
  801de2:	c9                   	leave  
  801de3:	c3                   	ret    

00801de4 <opencons>:
{
  801de4:	55                   	push   %ebp
  801de5:	89 e5                	mov    %esp,%ebp
  801de7:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801dea:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ded:	50                   	push   %eax
  801dee:	e8 d3 f2 ff ff       	call   8010c6 <fd_alloc>
  801df3:	83 c4 10             	add    $0x10,%esp
  801df6:	85 c0                	test   %eax,%eax
  801df8:	78 3a                	js     801e34 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801dfa:	83 ec 04             	sub    $0x4,%esp
  801dfd:	68 07 04 00 00       	push   $0x407
  801e02:	ff 75 f4             	pushl  -0xc(%ebp)
  801e05:	6a 00                	push   $0x0
  801e07:	e8 0d ef ff ff       	call   800d19 <sys_page_alloc>
  801e0c:	83 c4 10             	add    $0x10,%esp
  801e0f:	85 c0                	test   %eax,%eax
  801e11:	78 21                	js     801e34 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801e13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e16:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801e1c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801e1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e21:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801e28:	83 ec 0c             	sub    $0xc,%esp
  801e2b:	50                   	push   %eax
  801e2c:	e8 6e f2 ff ff       	call   80109f <fd2num>
  801e31:	83 c4 10             	add    $0x10,%esp
}
  801e34:	c9                   	leave  
  801e35:	c3                   	ret    

00801e36 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801e36:	55                   	push   %ebp
  801e37:	89 e5                	mov    %esp,%ebp
  801e39:	56                   	push   %esi
  801e3a:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801e3b:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801e3e:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801e44:	e8 92 ee ff ff       	call   800cdb <sys_getenvid>
  801e49:	83 ec 0c             	sub    $0xc,%esp
  801e4c:	ff 75 0c             	pushl  0xc(%ebp)
  801e4f:	ff 75 08             	pushl  0x8(%ebp)
  801e52:	56                   	push   %esi
  801e53:	50                   	push   %eax
  801e54:	68 f4 26 80 00       	push   $0x8026f4
  801e59:	e8 a3 e3 ff ff       	call   800201 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801e5e:	83 c4 18             	add    $0x18,%esp
  801e61:	53                   	push   %ebx
  801e62:	ff 75 10             	pushl  0x10(%ebp)
  801e65:	e8 46 e3 ff ff       	call   8001b0 <vcprintf>
	cprintf("\n");
  801e6a:	c7 04 24 10 22 80 00 	movl   $0x802210,(%esp)
  801e71:	e8 8b e3 ff ff       	call   800201 <cprintf>
  801e76:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801e79:	cc                   	int3   
  801e7a:	eb fd                	jmp    801e79 <_panic+0x43>

00801e7c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801e7c:	55                   	push   %ebp
  801e7d:	89 e5                	mov    %esp,%ebp
  801e7f:	56                   	push   %esi
  801e80:	53                   	push   %ebx
  801e81:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801e84:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e87:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// return 0;
	if(!pg)
  801e8a:	85 c0                	test   %eax,%eax
		pg = (void*)UTOP;
  801e8c:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801e91:	0f 44 c2             	cmove  %edx,%eax
	
	int ret;

	ret = sys_ipc_recv(pg);
  801e94:	83 ec 0c             	sub    $0xc,%esp
  801e97:	50                   	push   %eax
  801e98:	e8 2c f0 ff ff       	call   800ec9 <sys_ipc_recv>
	if(ret < 0){
  801e9d:	83 c4 10             	add    $0x10,%esp
  801ea0:	85 c0                	test   %eax,%eax
  801ea2:	78 2b                	js     801ecf <ipc_recv+0x53>
		if(perm_store) *perm_store = 0;
		if(from_env_store) *from_env_store = 0;
		return ret;
	}
	
	if(perm_store)
  801ea4:	85 f6                	test   %esi,%esi
  801ea6:	74 0a                	je     801eb2 <ipc_recv+0x36>
		*perm_store = thisenv->env_ipc_perm;
  801ea8:	a1 04 40 80 00       	mov    0x804004,%eax
  801ead:	8b 40 78             	mov    0x78(%eax),%eax
  801eb0:	89 06                	mov    %eax,(%esi)
	if(from_env_store)
  801eb2:	85 db                	test   %ebx,%ebx
  801eb4:	74 0a                	je     801ec0 <ipc_recv+0x44>
		*from_env_store = thisenv->env_ipc_from;
  801eb6:	a1 04 40 80 00       	mov    0x804004,%eax
  801ebb:	8b 40 74             	mov    0x74(%eax),%eax
  801ebe:	89 03                	mov    %eax,(%ebx)

	return thisenv->env_ipc_value;
  801ec0:	a1 04 40 80 00       	mov    0x804004,%eax
  801ec5:	8b 40 70             	mov    0x70(%eax),%eax
}
  801ec8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ecb:	5b                   	pop    %ebx
  801ecc:	5e                   	pop    %esi
  801ecd:	5d                   	pop    %ebp
  801ece:	c3                   	ret    
		if(perm_store) *perm_store = 0;
  801ecf:	85 f6                	test   %esi,%esi
  801ed1:	74 06                	je     801ed9 <ipc_recv+0x5d>
  801ed3:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(from_env_store) *from_env_store = 0;
  801ed9:	85 db                	test   %ebx,%ebx
  801edb:	74 eb                	je     801ec8 <ipc_recv+0x4c>
  801edd:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801ee3:	eb e3                	jmp    801ec8 <ipc_recv+0x4c>

00801ee5 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801ee5:	55                   	push   %ebp
  801ee6:	89 e5                	mov    %esp,%ebp
  801ee8:	57                   	push   %edi
  801ee9:	56                   	push   %esi
  801eea:	53                   	push   %ebx
  801eeb:	83 ec 0c             	sub    $0xc,%esp
  801eee:	8b 7d 08             	mov    0x8(%ebp),%edi
  801ef1:	8b 75 0c             	mov    0xc(%ebp),%esi
  801ef4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
	if (!pg)
  801ef7:	85 db                	test   %ebx,%ebx
		pg = (void*)UTOP;
  801ef9:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801efe:	0f 44 d8             	cmove  %eax,%ebx

	int ret = -E_IPC_NOT_RECV;
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))) {
  801f01:	ff 75 14             	pushl  0x14(%ebp)
  801f04:	53                   	push   %ebx
  801f05:	56                   	push   %esi
  801f06:	57                   	push   %edi
  801f07:	e8 9a ef ff ff       	call   800ea6 <sys_ipc_try_send>
  801f0c:	83 c4 10             	add    $0x10,%esp
  801f0f:	85 c0                	test   %eax,%eax
  801f11:	74 17                	je     801f2a <ipc_send+0x45>
		if(ret != -E_IPC_NOT_RECV){
  801f13:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801f16:	74 e9                	je     801f01 <ipc_send+0x1c>
			panic("ipc_send: ret : %d", ret);
  801f18:	50                   	push   %eax
  801f19:	68 18 27 80 00       	push   $0x802718
  801f1e:	6a 43                	push   $0x43
  801f20:	68 2b 27 80 00       	push   $0x80272b
  801f25:	e8 0c ff ff ff       	call   801e36 <_panic>
			sys_yield();
		}
	}
}
  801f2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f2d:	5b                   	pop    %ebx
  801f2e:	5e                   	pop    %esi
  801f2f:	5f                   	pop    %edi
  801f30:	5d                   	pop    %ebp
  801f31:	c3                   	ret    

00801f32 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801f32:	55                   	push   %ebp
  801f33:	89 e5                	mov    %esp,%ebp
  801f35:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801f38:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801f3d:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  801f43:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801f49:	8b 52 50             	mov    0x50(%edx),%edx
  801f4c:	39 ca                	cmp    %ecx,%edx
  801f4e:	74 11                	je     801f61 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  801f50:	83 c0 01             	add    $0x1,%eax
  801f53:	3d 00 04 00 00       	cmp    $0x400,%eax
  801f58:	75 e3                	jne    801f3d <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801f5a:	b8 00 00 00 00       	mov    $0x0,%eax
  801f5f:	eb 0e                	jmp    801f6f <ipc_find_env+0x3d>
			return envs[i].env_id;
  801f61:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  801f67:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801f6c:	8b 40 48             	mov    0x48(%eax),%eax
}
  801f6f:	5d                   	pop    %ebp
  801f70:	c3                   	ret    

00801f71 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801f71:	55                   	push   %ebp
  801f72:	89 e5                	mov    %esp,%ebp
  801f74:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801f77:	89 d0                	mov    %edx,%eax
  801f79:	c1 e8 16             	shr    $0x16,%eax
  801f7c:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801f83:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801f88:	f6 c1 01             	test   $0x1,%cl
  801f8b:	74 1d                	je     801faa <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801f8d:	c1 ea 0c             	shr    $0xc,%edx
  801f90:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801f97:	f6 c2 01             	test   $0x1,%dl
  801f9a:	74 0e                	je     801faa <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801f9c:	c1 ea 0c             	shr    $0xc,%edx
  801f9f:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801fa6:	ef 
  801fa7:	0f b7 c0             	movzwl %ax,%eax
}
  801faa:	5d                   	pop    %ebp
  801fab:	c3                   	ret    
  801fac:	66 90                	xchg   %ax,%ax
  801fae:	66 90                	xchg   %ax,%ax

00801fb0 <__udivdi3>:
  801fb0:	55                   	push   %ebp
  801fb1:	57                   	push   %edi
  801fb2:	56                   	push   %esi
  801fb3:	53                   	push   %ebx
  801fb4:	83 ec 1c             	sub    $0x1c,%esp
  801fb7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801fbb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801fbf:	8b 74 24 34          	mov    0x34(%esp),%esi
  801fc3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801fc7:	85 d2                	test   %edx,%edx
  801fc9:	75 4d                	jne    802018 <__udivdi3+0x68>
  801fcb:	39 f3                	cmp    %esi,%ebx
  801fcd:	76 19                	jbe    801fe8 <__udivdi3+0x38>
  801fcf:	31 ff                	xor    %edi,%edi
  801fd1:	89 e8                	mov    %ebp,%eax
  801fd3:	89 f2                	mov    %esi,%edx
  801fd5:	f7 f3                	div    %ebx
  801fd7:	89 fa                	mov    %edi,%edx
  801fd9:	83 c4 1c             	add    $0x1c,%esp
  801fdc:	5b                   	pop    %ebx
  801fdd:	5e                   	pop    %esi
  801fde:	5f                   	pop    %edi
  801fdf:	5d                   	pop    %ebp
  801fe0:	c3                   	ret    
  801fe1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801fe8:	89 d9                	mov    %ebx,%ecx
  801fea:	85 db                	test   %ebx,%ebx
  801fec:	75 0b                	jne    801ff9 <__udivdi3+0x49>
  801fee:	b8 01 00 00 00       	mov    $0x1,%eax
  801ff3:	31 d2                	xor    %edx,%edx
  801ff5:	f7 f3                	div    %ebx
  801ff7:	89 c1                	mov    %eax,%ecx
  801ff9:	31 d2                	xor    %edx,%edx
  801ffb:	89 f0                	mov    %esi,%eax
  801ffd:	f7 f1                	div    %ecx
  801fff:	89 c6                	mov    %eax,%esi
  802001:	89 e8                	mov    %ebp,%eax
  802003:	89 f7                	mov    %esi,%edi
  802005:	f7 f1                	div    %ecx
  802007:	89 fa                	mov    %edi,%edx
  802009:	83 c4 1c             	add    $0x1c,%esp
  80200c:	5b                   	pop    %ebx
  80200d:	5e                   	pop    %esi
  80200e:	5f                   	pop    %edi
  80200f:	5d                   	pop    %ebp
  802010:	c3                   	ret    
  802011:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802018:	39 f2                	cmp    %esi,%edx
  80201a:	77 1c                	ja     802038 <__udivdi3+0x88>
  80201c:	0f bd fa             	bsr    %edx,%edi
  80201f:	83 f7 1f             	xor    $0x1f,%edi
  802022:	75 2c                	jne    802050 <__udivdi3+0xa0>
  802024:	39 f2                	cmp    %esi,%edx
  802026:	72 06                	jb     80202e <__udivdi3+0x7e>
  802028:	31 c0                	xor    %eax,%eax
  80202a:	39 eb                	cmp    %ebp,%ebx
  80202c:	77 a9                	ja     801fd7 <__udivdi3+0x27>
  80202e:	b8 01 00 00 00       	mov    $0x1,%eax
  802033:	eb a2                	jmp    801fd7 <__udivdi3+0x27>
  802035:	8d 76 00             	lea    0x0(%esi),%esi
  802038:	31 ff                	xor    %edi,%edi
  80203a:	31 c0                	xor    %eax,%eax
  80203c:	89 fa                	mov    %edi,%edx
  80203e:	83 c4 1c             	add    $0x1c,%esp
  802041:	5b                   	pop    %ebx
  802042:	5e                   	pop    %esi
  802043:	5f                   	pop    %edi
  802044:	5d                   	pop    %ebp
  802045:	c3                   	ret    
  802046:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80204d:	8d 76 00             	lea    0x0(%esi),%esi
  802050:	89 f9                	mov    %edi,%ecx
  802052:	b8 20 00 00 00       	mov    $0x20,%eax
  802057:	29 f8                	sub    %edi,%eax
  802059:	d3 e2                	shl    %cl,%edx
  80205b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80205f:	89 c1                	mov    %eax,%ecx
  802061:	89 da                	mov    %ebx,%edx
  802063:	d3 ea                	shr    %cl,%edx
  802065:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802069:	09 d1                	or     %edx,%ecx
  80206b:	89 f2                	mov    %esi,%edx
  80206d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802071:	89 f9                	mov    %edi,%ecx
  802073:	d3 e3                	shl    %cl,%ebx
  802075:	89 c1                	mov    %eax,%ecx
  802077:	d3 ea                	shr    %cl,%edx
  802079:	89 f9                	mov    %edi,%ecx
  80207b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80207f:	89 eb                	mov    %ebp,%ebx
  802081:	d3 e6                	shl    %cl,%esi
  802083:	89 c1                	mov    %eax,%ecx
  802085:	d3 eb                	shr    %cl,%ebx
  802087:	09 de                	or     %ebx,%esi
  802089:	89 f0                	mov    %esi,%eax
  80208b:	f7 74 24 08          	divl   0x8(%esp)
  80208f:	89 d6                	mov    %edx,%esi
  802091:	89 c3                	mov    %eax,%ebx
  802093:	f7 64 24 0c          	mull   0xc(%esp)
  802097:	39 d6                	cmp    %edx,%esi
  802099:	72 15                	jb     8020b0 <__udivdi3+0x100>
  80209b:	89 f9                	mov    %edi,%ecx
  80209d:	d3 e5                	shl    %cl,%ebp
  80209f:	39 c5                	cmp    %eax,%ebp
  8020a1:	73 04                	jae    8020a7 <__udivdi3+0xf7>
  8020a3:	39 d6                	cmp    %edx,%esi
  8020a5:	74 09                	je     8020b0 <__udivdi3+0x100>
  8020a7:	89 d8                	mov    %ebx,%eax
  8020a9:	31 ff                	xor    %edi,%edi
  8020ab:	e9 27 ff ff ff       	jmp    801fd7 <__udivdi3+0x27>
  8020b0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8020b3:	31 ff                	xor    %edi,%edi
  8020b5:	e9 1d ff ff ff       	jmp    801fd7 <__udivdi3+0x27>
  8020ba:	66 90                	xchg   %ax,%ax
  8020bc:	66 90                	xchg   %ax,%ax
  8020be:	66 90                	xchg   %ax,%ax

008020c0 <__umoddi3>:
  8020c0:	55                   	push   %ebp
  8020c1:	57                   	push   %edi
  8020c2:	56                   	push   %esi
  8020c3:	53                   	push   %ebx
  8020c4:	83 ec 1c             	sub    $0x1c,%esp
  8020c7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8020cb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8020cf:	8b 74 24 30          	mov    0x30(%esp),%esi
  8020d3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8020d7:	89 da                	mov    %ebx,%edx
  8020d9:	85 c0                	test   %eax,%eax
  8020db:	75 43                	jne    802120 <__umoddi3+0x60>
  8020dd:	39 df                	cmp    %ebx,%edi
  8020df:	76 17                	jbe    8020f8 <__umoddi3+0x38>
  8020e1:	89 f0                	mov    %esi,%eax
  8020e3:	f7 f7                	div    %edi
  8020e5:	89 d0                	mov    %edx,%eax
  8020e7:	31 d2                	xor    %edx,%edx
  8020e9:	83 c4 1c             	add    $0x1c,%esp
  8020ec:	5b                   	pop    %ebx
  8020ed:	5e                   	pop    %esi
  8020ee:	5f                   	pop    %edi
  8020ef:	5d                   	pop    %ebp
  8020f0:	c3                   	ret    
  8020f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8020f8:	89 fd                	mov    %edi,%ebp
  8020fa:	85 ff                	test   %edi,%edi
  8020fc:	75 0b                	jne    802109 <__umoddi3+0x49>
  8020fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802103:	31 d2                	xor    %edx,%edx
  802105:	f7 f7                	div    %edi
  802107:	89 c5                	mov    %eax,%ebp
  802109:	89 d8                	mov    %ebx,%eax
  80210b:	31 d2                	xor    %edx,%edx
  80210d:	f7 f5                	div    %ebp
  80210f:	89 f0                	mov    %esi,%eax
  802111:	f7 f5                	div    %ebp
  802113:	89 d0                	mov    %edx,%eax
  802115:	eb d0                	jmp    8020e7 <__umoddi3+0x27>
  802117:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80211e:	66 90                	xchg   %ax,%ax
  802120:	89 f1                	mov    %esi,%ecx
  802122:	39 d8                	cmp    %ebx,%eax
  802124:	76 0a                	jbe    802130 <__umoddi3+0x70>
  802126:	89 f0                	mov    %esi,%eax
  802128:	83 c4 1c             	add    $0x1c,%esp
  80212b:	5b                   	pop    %ebx
  80212c:	5e                   	pop    %esi
  80212d:	5f                   	pop    %edi
  80212e:	5d                   	pop    %ebp
  80212f:	c3                   	ret    
  802130:	0f bd e8             	bsr    %eax,%ebp
  802133:	83 f5 1f             	xor    $0x1f,%ebp
  802136:	75 20                	jne    802158 <__umoddi3+0x98>
  802138:	39 d8                	cmp    %ebx,%eax
  80213a:	0f 82 b0 00 00 00    	jb     8021f0 <__umoddi3+0x130>
  802140:	39 f7                	cmp    %esi,%edi
  802142:	0f 86 a8 00 00 00    	jbe    8021f0 <__umoddi3+0x130>
  802148:	89 c8                	mov    %ecx,%eax
  80214a:	83 c4 1c             	add    $0x1c,%esp
  80214d:	5b                   	pop    %ebx
  80214e:	5e                   	pop    %esi
  80214f:	5f                   	pop    %edi
  802150:	5d                   	pop    %ebp
  802151:	c3                   	ret    
  802152:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802158:	89 e9                	mov    %ebp,%ecx
  80215a:	ba 20 00 00 00       	mov    $0x20,%edx
  80215f:	29 ea                	sub    %ebp,%edx
  802161:	d3 e0                	shl    %cl,%eax
  802163:	89 44 24 08          	mov    %eax,0x8(%esp)
  802167:	89 d1                	mov    %edx,%ecx
  802169:	89 f8                	mov    %edi,%eax
  80216b:	d3 e8                	shr    %cl,%eax
  80216d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802171:	89 54 24 04          	mov    %edx,0x4(%esp)
  802175:	8b 54 24 04          	mov    0x4(%esp),%edx
  802179:	09 c1                	or     %eax,%ecx
  80217b:	89 d8                	mov    %ebx,%eax
  80217d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802181:	89 e9                	mov    %ebp,%ecx
  802183:	d3 e7                	shl    %cl,%edi
  802185:	89 d1                	mov    %edx,%ecx
  802187:	d3 e8                	shr    %cl,%eax
  802189:	89 e9                	mov    %ebp,%ecx
  80218b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80218f:	d3 e3                	shl    %cl,%ebx
  802191:	89 c7                	mov    %eax,%edi
  802193:	89 d1                	mov    %edx,%ecx
  802195:	89 f0                	mov    %esi,%eax
  802197:	d3 e8                	shr    %cl,%eax
  802199:	89 e9                	mov    %ebp,%ecx
  80219b:	89 fa                	mov    %edi,%edx
  80219d:	d3 e6                	shl    %cl,%esi
  80219f:	09 d8                	or     %ebx,%eax
  8021a1:	f7 74 24 08          	divl   0x8(%esp)
  8021a5:	89 d1                	mov    %edx,%ecx
  8021a7:	89 f3                	mov    %esi,%ebx
  8021a9:	f7 64 24 0c          	mull   0xc(%esp)
  8021ad:	89 c6                	mov    %eax,%esi
  8021af:	89 d7                	mov    %edx,%edi
  8021b1:	39 d1                	cmp    %edx,%ecx
  8021b3:	72 06                	jb     8021bb <__umoddi3+0xfb>
  8021b5:	75 10                	jne    8021c7 <__umoddi3+0x107>
  8021b7:	39 c3                	cmp    %eax,%ebx
  8021b9:	73 0c                	jae    8021c7 <__umoddi3+0x107>
  8021bb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8021bf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8021c3:	89 d7                	mov    %edx,%edi
  8021c5:	89 c6                	mov    %eax,%esi
  8021c7:	89 ca                	mov    %ecx,%edx
  8021c9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8021ce:	29 f3                	sub    %esi,%ebx
  8021d0:	19 fa                	sbb    %edi,%edx
  8021d2:	89 d0                	mov    %edx,%eax
  8021d4:	d3 e0                	shl    %cl,%eax
  8021d6:	89 e9                	mov    %ebp,%ecx
  8021d8:	d3 eb                	shr    %cl,%ebx
  8021da:	d3 ea                	shr    %cl,%edx
  8021dc:	09 d8                	or     %ebx,%eax
  8021de:	83 c4 1c             	add    $0x1c,%esp
  8021e1:	5b                   	pop    %ebx
  8021e2:	5e                   	pop    %esi
  8021e3:	5f                   	pop    %edi
  8021e4:	5d                   	pop    %ebp
  8021e5:	c3                   	ret    
  8021e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8021ed:	8d 76 00             	lea    0x0(%esi),%esi
  8021f0:	89 da                	mov    %ebx,%edx
  8021f2:	29 fe                	sub    %edi,%esi
  8021f4:	19 c2                	sbb    %eax,%edx
  8021f6:	89 f1                	mov    %esi,%ecx
  8021f8:	89 c8                	mov    %ecx,%eax
  8021fa:	e9 4b ff ff ff       	jmp    80214a <__umoddi3+0x8a>
