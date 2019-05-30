
obj/user/pingpong.debug:     file format elf32-i386


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
  80002c:	e8 8f 00 00 00       	call   8000c0 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 1c             	sub    $0x1c,%esp
	envid_t who;

	if ((who = fork()) != 0) {
  80003c:	e8 b5 0f 00 00       	call   800ff6 <fork>
  800041:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800044:	85 c0                	test   %eax,%eax
  800046:	75 4f                	jne    800097 <umain+0x64>
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
		ipc_send(who, 0, 0, 0);
	}

	while (1) {
		uint32_t i = ipc_recv(&who, 0, 0);
  800048:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80004b:	83 ec 04             	sub    $0x4,%esp
  80004e:	6a 00                	push   $0x0
  800050:	6a 00                	push   $0x0
  800052:	56                   	push   %esi
  800053:	e8 be 12 00 00       	call   801316 <ipc_recv>
  800058:	89 c3                	mov    %eax,%ebx
		cprintf("%x got %d from %x\n", sys_getenvid(), i, who);
  80005a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80005d:	e8 28 0c 00 00       	call   800c8a <sys_getenvid>
  800062:	57                   	push   %edi
  800063:	53                   	push   %ebx
  800064:	50                   	push   %eax
  800065:	68 56 17 80 00       	push   $0x801756
  80006a:	e8 41 01 00 00       	call   8001b0 <cprintf>
		if (i == 10)
  80006f:	83 c4 20             	add    $0x20,%esp
  800072:	83 fb 0a             	cmp    $0xa,%ebx
  800075:	74 18                	je     80008f <umain+0x5c>
			return;
		i++;
  800077:	83 c3 01             	add    $0x1,%ebx
		ipc_send(who, i, 0, 0);
  80007a:	6a 00                	push   $0x0
  80007c:	6a 00                	push   $0x0
  80007e:	53                   	push   %ebx
  80007f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800082:	e8 f8 12 00 00       	call   80137f <ipc_send>
		if (i == 10)
  800087:	83 c4 10             	add    $0x10,%esp
  80008a:	83 fb 0a             	cmp    $0xa,%ebx
  80008d:	75 bc                	jne    80004b <umain+0x18>
			return;
	}

}
  80008f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800092:	5b                   	pop    %ebx
  800093:	5e                   	pop    %esi
  800094:	5f                   	pop    %edi
  800095:	5d                   	pop    %ebp
  800096:	c3                   	ret    
  800097:	89 c3                	mov    %eax,%ebx
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  800099:	e8 ec 0b 00 00       	call   800c8a <sys_getenvid>
  80009e:	83 ec 04             	sub    $0x4,%esp
  8000a1:	53                   	push   %ebx
  8000a2:	50                   	push   %eax
  8000a3:	68 40 17 80 00       	push   $0x801740
  8000a8:	e8 03 01 00 00       	call   8001b0 <cprintf>
		ipc_send(who, 0, 0, 0);
  8000ad:	6a 00                	push   $0x0
  8000af:	6a 00                	push   $0x0
  8000b1:	6a 00                	push   $0x0
  8000b3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000b6:	e8 c4 12 00 00       	call   80137f <ipc_send>
  8000bb:	83 c4 20             	add    $0x20,%esp
  8000be:	eb 88                	jmp    800048 <umain+0x15>

008000c0 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000c0:	55                   	push   %ebp
  8000c1:	89 e5                	mov    %esp,%ebp
  8000c3:	56                   	push   %esi
  8000c4:	53                   	push   %ebx
  8000c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000c8:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	// thisenv = 0;
	thisenv = &(envs[ENVX(sys_getenvid())]);
  8000cb:	e8 ba 0b 00 00       	call   800c8a <sys_getenvid>
  8000d0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000d5:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8000db:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000e0:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000e5:	85 db                	test   %ebx,%ebx
  8000e7:	7e 07                	jle    8000f0 <libmain+0x30>
		binaryname = argv[0];
  8000e9:	8b 06                	mov    (%esi),%eax
  8000eb:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  8000f0:	83 ec 08             	sub    $0x8,%esp
  8000f3:	56                   	push   %esi
  8000f4:	53                   	push   %ebx
  8000f5:	e8 39 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000fa:	e8 0a 00 00 00       	call   800109 <exit>
}
  8000ff:	83 c4 10             	add    $0x10,%esp
  800102:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800105:	5b                   	pop    %ebx
  800106:	5e                   	pop    %esi
  800107:	5d                   	pop    %ebp
  800108:	c3                   	ret    

00800109 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800109:	55                   	push   %ebp
  80010a:	89 e5                	mov    %esp,%ebp
  80010c:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  80010f:	6a 00                	push   $0x0
  800111:	e8 33 0b 00 00       	call   800c49 <sys_env_destroy>
}
  800116:	83 c4 10             	add    $0x10,%esp
  800119:	c9                   	leave  
  80011a:	c3                   	ret    

0080011b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80011b:	55                   	push   %ebp
  80011c:	89 e5                	mov    %esp,%ebp
  80011e:	53                   	push   %ebx
  80011f:	83 ec 04             	sub    $0x4,%esp
  800122:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800125:	8b 13                	mov    (%ebx),%edx
  800127:	8d 42 01             	lea    0x1(%edx),%eax
  80012a:	89 03                	mov    %eax,(%ebx)
  80012c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80012f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800133:	3d ff 00 00 00       	cmp    $0xff,%eax
  800138:	74 09                	je     800143 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80013a:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80013e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800141:	c9                   	leave  
  800142:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800143:	83 ec 08             	sub    $0x8,%esp
  800146:	68 ff 00 00 00       	push   $0xff
  80014b:	8d 43 08             	lea    0x8(%ebx),%eax
  80014e:	50                   	push   %eax
  80014f:	e8 b8 0a 00 00       	call   800c0c <sys_cputs>
		b->idx = 0;
  800154:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80015a:	83 c4 10             	add    $0x10,%esp
  80015d:	eb db                	jmp    80013a <putch+0x1f>

0080015f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80015f:	55                   	push   %ebp
  800160:	89 e5                	mov    %esp,%ebp
  800162:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800168:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80016f:	00 00 00 
	b.cnt = 0;
  800172:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800179:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80017c:	ff 75 0c             	pushl  0xc(%ebp)
  80017f:	ff 75 08             	pushl  0x8(%ebp)
  800182:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800188:	50                   	push   %eax
  800189:	68 1b 01 80 00       	push   $0x80011b
  80018e:	e8 4a 01 00 00       	call   8002dd <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800193:	83 c4 08             	add    $0x8,%esp
  800196:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80019c:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001a2:	50                   	push   %eax
  8001a3:	e8 64 0a 00 00       	call   800c0c <sys_cputs>

	return b.cnt;
}
  8001a8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001ae:	c9                   	leave  
  8001af:	c3                   	ret    

008001b0 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001b0:	55                   	push   %ebp
  8001b1:	89 e5                	mov    %esp,%ebp
  8001b3:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001b6:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001b9:	50                   	push   %eax
  8001ba:	ff 75 08             	pushl  0x8(%ebp)
  8001bd:	e8 9d ff ff ff       	call   80015f <vcprintf>
	va_end(ap);

	return cnt;
}
  8001c2:	c9                   	leave  
  8001c3:	c3                   	ret    

008001c4 <printnum>:


static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001c4:	55                   	push   %ebp
  8001c5:	89 e5                	mov    %esp,%ebp
  8001c7:	57                   	push   %edi
  8001c8:	56                   	push   %esi
  8001c9:	53                   	push   %ebx
  8001ca:	83 ec 1c             	sub    $0x1c,%esp
  8001cd:	89 c6                	mov    %eax,%esi
  8001cf:	89 d7                	mov    %edx,%edi
  8001d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8001d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001d7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001da:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8001dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8001e0:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	// to support '-'
	if(padc == '-'){
  8001e3:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8001e7:	74 2c                	je     800215 <printnum+0x51>
		while (--width > 0)
			putch(' ', putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001e9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001ec:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8001f3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8001f6:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8001f9:	39 c2                	cmp    %eax,%edx
  8001fb:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8001fe:	73 43                	jae    800243 <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800200:	83 eb 01             	sub    $0x1,%ebx
  800203:	85 db                	test   %ebx,%ebx
  800205:	7e 6c                	jle    800273 <printnum+0xaf>
			putch(padc, putdat);
  800207:	83 ec 08             	sub    $0x8,%esp
  80020a:	57                   	push   %edi
  80020b:	ff 75 18             	pushl  0x18(%ebp)
  80020e:	ff d6                	call   *%esi
  800210:	83 c4 10             	add    $0x10,%esp
  800213:	eb eb                	jmp    800200 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800215:	83 ec 0c             	sub    $0xc,%esp
  800218:	6a 20                	push   $0x20
  80021a:	6a 00                	push   $0x0
  80021c:	50                   	push   %eax
  80021d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800220:	ff 75 e0             	pushl  -0x20(%ebp)
  800223:	89 fa                	mov    %edi,%edx
  800225:	89 f0                	mov    %esi,%eax
  800227:	e8 98 ff ff ff       	call   8001c4 <printnum>
		while (--width > 0)
  80022c:	83 c4 20             	add    $0x20,%esp
  80022f:	83 eb 01             	sub    $0x1,%ebx
  800232:	85 db                	test   %ebx,%ebx
  800234:	7e 65                	jle    80029b <printnum+0xd7>
			putch(' ', putdat);
  800236:	83 ec 08             	sub    $0x8,%esp
  800239:	57                   	push   %edi
  80023a:	6a 20                	push   $0x20
  80023c:	ff d6                	call   *%esi
  80023e:	83 c4 10             	add    $0x10,%esp
  800241:	eb ec                	jmp    80022f <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800243:	83 ec 0c             	sub    $0xc,%esp
  800246:	ff 75 18             	pushl  0x18(%ebp)
  800249:	83 eb 01             	sub    $0x1,%ebx
  80024c:	53                   	push   %ebx
  80024d:	50                   	push   %eax
  80024e:	83 ec 08             	sub    $0x8,%esp
  800251:	ff 75 dc             	pushl  -0x24(%ebp)
  800254:	ff 75 d8             	pushl  -0x28(%ebp)
  800257:	ff 75 e4             	pushl  -0x1c(%ebp)
  80025a:	ff 75 e0             	pushl  -0x20(%ebp)
  80025d:	e8 8e 12 00 00       	call   8014f0 <__udivdi3>
  800262:	83 c4 18             	add    $0x18,%esp
  800265:	52                   	push   %edx
  800266:	50                   	push   %eax
  800267:	89 fa                	mov    %edi,%edx
  800269:	89 f0                	mov    %esi,%eax
  80026b:	e8 54 ff ff ff       	call   8001c4 <printnum>
  800270:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800273:	83 ec 08             	sub    $0x8,%esp
  800276:	57                   	push   %edi
  800277:	83 ec 04             	sub    $0x4,%esp
  80027a:	ff 75 dc             	pushl  -0x24(%ebp)
  80027d:	ff 75 d8             	pushl  -0x28(%ebp)
  800280:	ff 75 e4             	pushl  -0x1c(%ebp)
  800283:	ff 75 e0             	pushl  -0x20(%ebp)
  800286:	e8 75 13 00 00       	call   801600 <__umoddi3>
  80028b:	83 c4 14             	add    $0x14,%esp
  80028e:	0f be 80 73 17 80 00 	movsbl 0x801773(%eax),%eax
  800295:	50                   	push   %eax
  800296:	ff d6                	call   *%esi
  800298:	83 c4 10             	add    $0x10,%esp
}
  80029b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80029e:	5b                   	pop    %ebx
  80029f:	5e                   	pop    %esi
  8002a0:	5f                   	pop    %edi
  8002a1:	5d                   	pop    %ebp
  8002a2:	c3                   	ret    

008002a3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002a3:	55                   	push   %ebp
  8002a4:	89 e5                	mov    %esp,%ebp
  8002a6:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002a9:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002ad:	8b 10                	mov    (%eax),%edx
  8002af:	3b 50 04             	cmp    0x4(%eax),%edx
  8002b2:	73 0a                	jae    8002be <sprintputch+0x1b>
		*b->buf++ = ch;
  8002b4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002b7:	89 08                	mov    %ecx,(%eax)
  8002b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8002bc:	88 02                	mov    %al,(%edx)
}
  8002be:	5d                   	pop    %ebp
  8002bf:	c3                   	ret    

008002c0 <printfmt>:
{
  8002c0:	55                   	push   %ebp
  8002c1:	89 e5                	mov    %esp,%ebp
  8002c3:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002c6:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002c9:	50                   	push   %eax
  8002ca:	ff 75 10             	pushl  0x10(%ebp)
  8002cd:	ff 75 0c             	pushl  0xc(%ebp)
  8002d0:	ff 75 08             	pushl  0x8(%ebp)
  8002d3:	e8 05 00 00 00       	call   8002dd <vprintfmt>
}
  8002d8:	83 c4 10             	add    $0x10,%esp
  8002db:	c9                   	leave  
  8002dc:	c3                   	ret    

008002dd <vprintfmt>:
{
  8002dd:	55                   	push   %ebp
  8002de:	89 e5                	mov    %esp,%ebp
  8002e0:	57                   	push   %edi
  8002e1:	56                   	push   %esi
  8002e2:	53                   	push   %ebx
  8002e3:	83 ec 3c             	sub    $0x3c,%esp
  8002e6:	8b 75 08             	mov    0x8(%ebp),%esi
  8002e9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002ec:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002ef:	e9 1e 04 00 00       	jmp    800712 <vprintfmt+0x435>
		posflag = 0;
  8002f4:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
		padc = ' ';
  8002fb:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8002ff:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800306:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80030d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800314:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  80031b:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800320:	8d 47 01             	lea    0x1(%edi),%eax
  800323:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800326:	0f b6 17             	movzbl (%edi),%edx
  800329:	8d 42 dd             	lea    -0x23(%edx),%eax
  80032c:	3c 55                	cmp    $0x55,%al
  80032e:	0f 87 d9 04 00 00    	ja     80080d <vprintfmt+0x530>
  800334:	0f b6 c0             	movzbl %al,%eax
  800337:	ff 24 85 60 19 80 00 	jmp    *0x801960(,%eax,4)
  80033e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800341:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800345:	eb d9                	jmp    800320 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800347:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posflag = 1;
  80034a:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  800351:	eb cd                	jmp    800320 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800353:	0f b6 d2             	movzbl %dl,%edx
  800356:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800359:	b8 00 00 00 00       	mov    $0x0,%eax
  80035e:	89 75 08             	mov    %esi,0x8(%ebp)
  800361:	eb 0c                	jmp    80036f <vprintfmt+0x92>
		switch (ch = *(unsigned char *) fmt++) {
  800363:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800366:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  80036a:	eb b4                	jmp    800320 <vprintfmt+0x43>
			for (precision = 0; ; ++fmt) {
  80036c:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80036f:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800372:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800376:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800379:	8d 72 d0             	lea    -0x30(%edx),%esi
  80037c:	83 fe 09             	cmp    $0x9,%esi
  80037f:	76 eb                	jbe    80036c <vprintfmt+0x8f>
  800381:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800384:	8b 75 08             	mov    0x8(%ebp),%esi
  800387:	eb 14                	jmp    80039d <vprintfmt+0xc0>
			precision = va_arg(ap, int);
  800389:	8b 45 14             	mov    0x14(%ebp),%eax
  80038c:	8b 00                	mov    (%eax),%eax
  80038e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800391:	8b 45 14             	mov    0x14(%ebp),%eax
  800394:	8d 40 04             	lea    0x4(%eax),%eax
  800397:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80039a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80039d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003a1:	0f 89 79 ff ff ff    	jns    800320 <vprintfmt+0x43>
				width = precision, precision = -1;
  8003a7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003aa:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003ad:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003b4:	e9 67 ff ff ff       	jmp    800320 <vprintfmt+0x43>
  8003b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003bc:	85 c0                	test   %eax,%eax
  8003be:	0f 48 c1             	cmovs  %ecx,%eax
  8003c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003c4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003c7:	e9 54 ff ff ff       	jmp    800320 <vprintfmt+0x43>
  8003cc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003cf:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8003d6:	e9 45 ff ff ff       	jmp    800320 <vprintfmt+0x43>
			lflag++;
  8003db:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003df:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003e2:	e9 39 ff ff ff       	jmp    800320 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8003e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ea:	8d 78 04             	lea    0x4(%eax),%edi
  8003ed:	83 ec 08             	sub    $0x8,%esp
  8003f0:	53                   	push   %ebx
  8003f1:	ff 30                	pushl  (%eax)
  8003f3:	ff d6                	call   *%esi
			break;
  8003f5:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003f8:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003fb:	e9 0f 03 00 00       	jmp    80070f <vprintfmt+0x432>
			err = va_arg(ap, int);
  800400:	8b 45 14             	mov    0x14(%ebp),%eax
  800403:	8d 78 04             	lea    0x4(%eax),%edi
  800406:	8b 00                	mov    (%eax),%eax
  800408:	99                   	cltd   
  800409:	31 d0                	xor    %edx,%eax
  80040b:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80040d:	83 f8 0f             	cmp    $0xf,%eax
  800410:	7f 23                	jg     800435 <vprintfmt+0x158>
  800412:	8b 14 85 c0 1a 80 00 	mov    0x801ac0(,%eax,4),%edx
  800419:	85 d2                	test   %edx,%edx
  80041b:	74 18                	je     800435 <vprintfmt+0x158>
				printfmt(putch, putdat, "%s", p);
  80041d:	52                   	push   %edx
  80041e:	68 94 17 80 00       	push   $0x801794
  800423:	53                   	push   %ebx
  800424:	56                   	push   %esi
  800425:	e8 96 fe ff ff       	call   8002c0 <printfmt>
  80042a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80042d:	89 7d 14             	mov    %edi,0x14(%ebp)
  800430:	e9 da 02 00 00       	jmp    80070f <vprintfmt+0x432>
				printfmt(putch, putdat, "error %d", err);
  800435:	50                   	push   %eax
  800436:	68 8b 17 80 00       	push   $0x80178b
  80043b:	53                   	push   %ebx
  80043c:	56                   	push   %esi
  80043d:	e8 7e fe ff ff       	call   8002c0 <printfmt>
  800442:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800445:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800448:	e9 c2 02 00 00       	jmp    80070f <vprintfmt+0x432>
			if ((p = va_arg(ap, char *)) == NULL)
  80044d:	8b 45 14             	mov    0x14(%ebp),%eax
  800450:	83 c0 04             	add    $0x4,%eax
  800453:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800456:	8b 45 14             	mov    0x14(%ebp),%eax
  800459:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80045b:	85 c9                	test   %ecx,%ecx
  80045d:	b8 84 17 80 00       	mov    $0x801784,%eax
  800462:	0f 45 c1             	cmovne %ecx,%eax
  800465:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800468:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80046c:	7e 06                	jle    800474 <vprintfmt+0x197>
  80046e:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800472:	75 0d                	jne    800481 <vprintfmt+0x1a4>
				for (width -= strnlen(p, precision); width > 0; width--)
  800474:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800477:	89 c7                	mov    %eax,%edi
  800479:	03 45 e0             	add    -0x20(%ebp),%eax
  80047c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80047f:	eb 53                	jmp    8004d4 <vprintfmt+0x1f7>
  800481:	83 ec 08             	sub    $0x8,%esp
  800484:	ff 75 d8             	pushl  -0x28(%ebp)
  800487:	50                   	push   %eax
  800488:	e8 28 04 00 00       	call   8008b5 <strnlen>
  80048d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800490:	29 c1                	sub    %eax,%ecx
  800492:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  800495:	83 c4 10             	add    $0x10,%esp
  800498:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  80049a:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80049e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004a1:	eb 0f                	jmp    8004b2 <vprintfmt+0x1d5>
					putch(padc, putdat);
  8004a3:	83 ec 08             	sub    $0x8,%esp
  8004a6:	53                   	push   %ebx
  8004a7:	ff 75 e0             	pushl  -0x20(%ebp)
  8004aa:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004ac:	83 ef 01             	sub    $0x1,%edi
  8004af:	83 c4 10             	add    $0x10,%esp
  8004b2:	85 ff                	test   %edi,%edi
  8004b4:	7f ed                	jg     8004a3 <vprintfmt+0x1c6>
  8004b6:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  8004b9:	85 c9                	test   %ecx,%ecx
  8004bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c0:	0f 49 c1             	cmovns %ecx,%eax
  8004c3:	29 c1                	sub    %eax,%ecx
  8004c5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8004c8:	eb aa                	jmp    800474 <vprintfmt+0x197>
					putch(ch, putdat);
  8004ca:	83 ec 08             	sub    $0x8,%esp
  8004cd:	53                   	push   %ebx
  8004ce:	52                   	push   %edx
  8004cf:	ff d6                	call   *%esi
  8004d1:	83 c4 10             	add    $0x10,%esp
  8004d4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004d7:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004d9:	83 c7 01             	add    $0x1,%edi
  8004dc:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004e0:	0f be d0             	movsbl %al,%edx
  8004e3:	85 d2                	test   %edx,%edx
  8004e5:	74 4b                	je     800532 <vprintfmt+0x255>
  8004e7:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004eb:	78 06                	js     8004f3 <vprintfmt+0x216>
  8004ed:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004f1:	78 1e                	js     800511 <vprintfmt+0x234>
				if (altflag && (ch < ' ' || ch > '~'))
  8004f3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004f7:	74 d1                	je     8004ca <vprintfmt+0x1ed>
  8004f9:	0f be c0             	movsbl %al,%eax
  8004fc:	83 e8 20             	sub    $0x20,%eax
  8004ff:	83 f8 5e             	cmp    $0x5e,%eax
  800502:	76 c6                	jbe    8004ca <vprintfmt+0x1ed>
					putch('?', putdat);
  800504:	83 ec 08             	sub    $0x8,%esp
  800507:	53                   	push   %ebx
  800508:	6a 3f                	push   $0x3f
  80050a:	ff d6                	call   *%esi
  80050c:	83 c4 10             	add    $0x10,%esp
  80050f:	eb c3                	jmp    8004d4 <vprintfmt+0x1f7>
  800511:	89 cf                	mov    %ecx,%edi
  800513:	eb 0e                	jmp    800523 <vprintfmt+0x246>
				putch(' ', putdat);
  800515:	83 ec 08             	sub    $0x8,%esp
  800518:	53                   	push   %ebx
  800519:	6a 20                	push   $0x20
  80051b:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80051d:	83 ef 01             	sub    $0x1,%edi
  800520:	83 c4 10             	add    $0x10,%esp
  800523:	85 ff                	test   %edi,%edi
  800525:	7f ee                	jg     800515 <vprintfmt+0x238>
			if ((p = va_arg(ap, char *)) == NULL)
  800527:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80052a:	89 45 14             	mov    %eax,0x14(%ebp)
  80052d:	e9 dd 01 00 00       	jmp    80070f <vprintfmt+0x432>
  800532:	89 cf                	mov    %ecx,%edi
  800534:	eb ed                	jmp    800523 <vprintfmt+0x246>
	if (lflag >= 2)
  800536:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  80053a:	7f 21                	jg     80055d <vprintfmt+0x280>
	else if (lflag)
  80053c:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800540:	74 6a                	je     8005ac <vprintfmt+0x2cf>
		return va_arg(*ap, long);
  800542:	8b 45 14             	mov    0x14(%ebp),%eax
  800545:	8b 00                	mov    (%eax),%eax
  800547:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80054a:	89 c1                	mov    %eax,%ecx
  80054c:	c1 f9 1f             	sar    $0x1f,%ecx
  80054f:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800552:	8b 45 14             	mov    0x14(%ebp),%eax
  800555:	8d 40 04             	lea    0x4(%eax),%eax
  800558:	89 45 14             	mov    %eax,0x14(%ebp)
  80055b:	eb 17                	jmp    800574 <vprintfmt+0x297>
		return va_arg(*ap, long long);
  80055d:	8b 45 14             	mov    0x14(%ebp),%eax
  800560:	8b 50 04             	mov    0x4(%eax),%edx
  800563:	8b 00                	mov    (%eax),%eax
  800565:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800568:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80056b:	8b 45 14             	mov    0x14(%ebp),%eax
  80056e:	8d 40 08             	lea    0x8(%eax),%eax
  800571:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800574:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  800577:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  80057c:	85 d2                	test   %edx,%edx
  80057e:	0f 89 5c 01 00 00    	jns    8006e0 <vprintfmt+0x403>
				putch('-', putdat);
  800584:	83 ec 08             	sub    $0x8,%esp
  800587:	53                   	push   %ebx
  800588:	6a 2d                	push   $0x2d
  80058a:	ff d6                	call   *%esi
				num = -(long long) num;
  80058c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80058f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800592:	f7 d8                	neg    %eax
  800594:	83 d2 00             	adc    $0x0,%edx
  800597:	f7 da                	neg    %edx
  800599:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80059c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80059f:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005a2:	bf 0a 00 00 00       	mov    $0xa,%edi
  8005a7:	e9 45 01 00 00       	jmp    8006f1 <vprintfmt+0x414>
		return va_arg(*ap, int);
  8005ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8005af:	8b 00                	mov    (%eax),%eax
  8005b1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005b4:	89 c1                	mov    %eax,%ecx
  8005b6:	c1 f9 1f             	sar    $0x1f,%ecx
  8005b9:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bf:	8d 40 04             	lea    0x4(%eax),%eax
  8005c2:	89 45 14             	mov    %eax,0x14(%ebp)
  8005c5:	eb ad                	jmp    800574 <vprintfmt+0x297>
	if (lflag >= 2)
  8005c7:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8005cb:	7f 29                	jg     8005f6 <vprintfmt+0x319>
	else if (lflag)
  8005cd:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8005d1:	74 44                	je     800617 <vprintfmt+0x33a>
		return va_arg(*ap, unsigned long);
  8005d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d6:	8b 00                	mov    (%eax),%eax
  8005d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8005dd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005e0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e6:	8d 40 04             	lea    0x4(%eax),%eax
  8005e9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005ec:	bf 0a 00 00 00       	mov    $0xa,%edi
  8005f1:	e9 ea 00 00 00       	jmp    8006e0 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  8005f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f9:	8b 50 04             	mov    0x4(%eax),%edx
  8005fc:	8b 00                	mov    (%eax),%eax
  8005fe:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800601:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800604:	8b 45 14             	mov    0x14(%ebp),%eax
  800607:	8d 40 08             	lea    0x8(%eax),%eax
  80060a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80060d:	bf 0a 00 00 00       	mov    $0xa,%edi
  800612:	e9 c9 00 00 00       	jmp    8006e0 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  800617:	8b 45 14             	mov    0x14(%ebp),%eax
  80061a:	8b 00                	mov    (%eax),%eax
  80061c:	ba 00 00 00 00       	mov    $0x0,%edx
  800621:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800624:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800627:	8b 45 14             	mov    0x14(%ebp),%eax
  80062a:	8d 40 04             	lea    0x4(%eax),%eax
  80062d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800630:	bf 0a 00 00 00       	mov    $0xa,%edi
  800635:	e9 a6 00 00 00       	jmp    8006e0 <vprintfmt+0x403>
			putch('0', putdat);
  80063a:	83 ec 08             	sub    $0x8,%esp
  80063d:	53                   	push   %ebx
  80063e:	6a 30                	push   $0x30
  800640:	ff d6                	call   *%esi
	if (lflag >= 2)
  800642:	83 c4 10             	add    $0x10,%esp
  800645:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800649:	7f 26                	jg     800671 <vprintfmt+0x394>
	else if (lflag)
  80064b:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80064f:	74 3e                	je     80068f <vprintfmt+0x3b2>
		return va_arg(*ap, unsigned long);
  800651:	8b 45 14             	mov    0x14(%ebp),%eax
  800654:	8b 00                	mov    (%eax),%eax
  800656:	ba 00 00 00 00       	mov    $0x0,%edx
  80065b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80065e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800661:	8b 45 14             	mov    0x14(%ebp),%eax
  800664:	8d 40 04             	lea    0x4(%eax),%eax
  800667:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80066a:	bf 08 00 00 00       	mov    $0x8,%edi
  80066f:	eb 6f                	jmp    8006e0 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  800671:	8b 45 14             	mov    0x14(%ebp),%eax
  800674:	8b 50 04             	mov    0x4(%eax),%edx
  800677:	8b 00                	mov    (%eax),%eax
  800679:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80067c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80067f:	8b 45 14             	mov    0x14(%ebp),%eax
  800682:	8d 40 08             	lea    0x8(%eax),%eax
  800685:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800688:	bf 08 00 00 00       	mov    $0x8,%edi
  80068d:	eb 51                	jmp    8006e0 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  80068f:	8b 45 14             	mov    0x14(%ebp),%eax
  800692:	8b 00                	mov    (%eax),%eax
  800694:	ba 00 00 00 00       	mov    $0x0,%edx
  800699:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80069c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80069f:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a2:	8d 40 04             	lea    0x4(%eax),%eax
  8006a5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006a8:	bf 08 00 00 00       	mov    $0x8,%edi
  8006ad:	eb 31                	jmp    8006e0 <vprintfmt+0x403>
			putch('0', putdat);
  8006af:	83 ec 08             	sub    $0x8,%esp
  8006b2:	53                   	push   %ebx
  8006b3:	6a 30                	push   $0x30
  8006b5:	ff d6                	call   *%esi
			putch('x', putdat);
  8006b7:	83 c4 08             	add    $0x8,%esp
  8006ba:	53                   	push   %ebx
  8006bb:	6a 78                	push   $0x78
  8006bd:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c2:	8b 00                	mov    (%eax),%eax
  8006c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006cc:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8006cf:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d5:	8d 40 04             	lea    0x4(%eax),%eax
  8006d8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006db:	bf 10 00 00 00       	mov    $0x10,%edi
			if(posflag)
  8006e0:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006e4:	74 0b                	je     8006f1 <vprintfmt+0x414>
				putch('+', putdat);
  8006e6:	83 ec 08             	sub    $0x8,%esp
  8006e9:	53                   	push   %ebx
  8006ea:	6a 2b                	push   $0x2b
  8006ec:	ff d6                	call   *%esi
  8006ee:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  8006f1:	83 ec 0c             	sub    $0xc,%esp
  8006f4:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8006f8:	50                   	push   %eax
  8006f9:	ff 75 e0             	pushl  -0x20(%ebp)
  8006fc:	57                   	push   %edi
  8006fd:	ff 75 dc             	pushl  -0x24(%ebp)
  800700:	ff 75 d8             	pushl  -0x28(%ebp)
  800703:	89 da                	mov    %ebx,%edx
  800705:	89 f0                	mov    %esi,%eax
  800707:	e8 b8 fa ff ff       	call   8001c4 <printnum>
			break;
  80070c:	83 c4 20             	add    $0x20,%esp
			char* cp = va_arg(ap, char *);
  80070f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800712:	83 c7 01             	add    $0x1,%edi
  800715:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800719:	83 f8 25             	cmp    $0x25,%eax
  80071c:	0f 84 d2 fb ff ff    	je     8002f4 <vprintfmt+0x17>
			if (ch == '\0')
  800722:	85 c0                	test   %eax,%eax
  800724:	0f 84 03 01 00 00    	je     80082d <vprintfmt+0x550>
			putch(ch, putdat);
  80072a:	83 ec 08             	sub    $0x8,%esp
  80072d:	53                   	push   %ebx
  80072e:	50                   	push   %eax
  80072f:	ff d6                	call   *%esi
  800731:	83 c4 10             	add    $0x10,%esp
  800734:	eb dc                	jmp    800712 <vprintfmt+0x435>
	if (lflag >= 2)
  800736:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  80073a:	7f 29                	jg     800765 <vprintfmt+0x488>
	else if (lflag)
  80073c:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800740:	74 44                	je     800786 <vprintfmt+0x4a9>
		return va_arg(*ap, unsigned long);
  800742:	8b 45 14             	mov    0x14(%ebp),%eax
  800745:	8b 00                	mov    (%eax),%eax
  800747:	ba 00 00 00 00       	mov    $0x0,%edx
  80074c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80074f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800752:	8b 45 14             	mov    0x14(%ebp),%eax
  800755:	8d 40 04             	lea    0x4(%eax),%eax
  800758:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80075b:	bf 10 00 00 00       	mov    $0x10,%edi
  800760:	e9 7b ff ff ff       	jmp    8006e0 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  800765:	8b 45 14             	mov    0x14(%ebp),%eax
  800768:	8b 50 04             	mov    0x4(%eax),%edx
  80076b:	8b 00                	mov    (%eax),%eax
  80076d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800770:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800773:	8b 45 14             	mov    0x14(%ebp),%eax
  800776:	8d 40 08             	lea    0x8(%eax),%eax
  800779:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80077c:	bf 10 00 00 00       	mov    $0x10,%edi
  800781:	e9 5a ff ff ff       	jmp    8006e0 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  800786:	8b 45 14             	mov    0x14(%ebp),%eax
  800789:	8b 00                	mov    (%eax),%eax
  80078b:	ba 00 00 00 00       	mov    $0x0,%edx
  800790:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800793:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800796:	8b 45 14             	mov    0x14(%ebp),%eax
  800799:	8d 40 04             	lea    0x4(%eax),%eax
  80079c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80079f:	bf 10 00 00 00       	mov    $0x10,%edi
  8007a4:	e9 37 ff ff ff       	jmp    8006e0 <vprintfmt+0x403>
			char* cp = va_arg(ap, char *);
  8007a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ac:	8d 78 04             	lea    0x4(%eax),%edi
  8007af:	8b 00                	mov    (%eax),%eax
    			if (cp == NULL) {
  8007b1:	85 c0                	test   %eax,%eax
  8007b3:	74 2c                	je     8007e1 <vprintfmt+0x504>
    			*cp = *(int *)putdat;
  8007b5:	8b 13                	mov    (%ebx),%edx
  8007b7:	88 10                	mov    %dl,(%eax)
			char* cp = va_arg(ap, char *);
  8007b9:	89 7d 14             	mov    %edi,0x14(%ebp)
    			if ((*(int *) putdat) > 127)
  8007bc:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  8007bf:	0f 8e 4a ff ff ff    	jle    80070f <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", overflow_error);
  8007c5:	68 e4 18 80 00       	push   $0x8018e4
  8007ca:	68 94 17 80 00       	push   $0x801794
  8007cf:	53                   	push   %ebx
  8007d0:	56                   	push   %esi
  8007d1:	e8 ea fa ff ff       	call   8002c0 <printfmt>
  8007d6:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  8007d9:	89 7d 14             	mov    %edi,0x14(%ebp)
  8007dc:	e9 2e ff ff ff       	jmp    80070f <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", null_error);
  8007e1:	68 ac 18 80 00       	push   $0x8018ac
  8007e6:	68 94 17 80 00       	push   $0x801794
  8007eb:	53                   	push   %ebx
  8007ec:	56                   	push   %esi
  8007ed:	e8 ce fa ff ff       	call   8002c0 <printfmt>
        		break;
  8007f2:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  8007f5:	89 7d 14             	mov    %edi,0x14(%ebp)
        		break;
  8007f8:	e9 12 ff ff ff       	jmp    80070f <vprintfmt+0x432>
			putch(ch, putdat);
  8007fd:	83 ec 08             	sub    $0x8,%esp
  800800:	53                   	push   %ebx
  800801:	6a 25                	push   $0x25
  800803:	ff d6                	call   *%esi
			break;
  800805:	83 c4 10             	add    $0x10,%esp
  800808:	e9 02 ff ff ff       	jmp    80070f <vprintfmt+0x432>
			putch('%', putdat);
  80080d:	83 ec 08             	sub    $0x8,%esp
  800810:	53                   	push   %ebx
  800811:	6a 25                	push   $0x25
  800813:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800815:	83 c4 10             	add    $0x10,%esp
  800818:	89 f8                	mov    %edi,%eax
  80081a:	eb 03                	jmp    80081f <vprintfmt+0x542>
  80081c:	83 e8 01             	sub    $0x1,%eax
  80081f:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800823:	75 f7                	jne    80081c <vprintfmt+0x53f>
  800825:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800828:	e9 e2 fe ff ff       	jmp    80070f <vprintfmt+0x432>
}
  80082d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800830:	5b                   	pop    %ebx
  800831:	5e                   	pop    %esi
  800832:	5f                   	pop    %edi
  800833:	5d                   	pop    %ebp
  800834:	c3                   	ret    

00800835 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800835:	55                   	push   %ebp
  800836:	89 e5                	mov    %esp,%ebp
  800838:	83 ec 18             	sub    $0x18,%esp
  80083b:	8b 45 08             	mov    0x8(%ebp),%eax
  80083e:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800841:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800844:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800848:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80084b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800852:	85 c0                	test   %eax,%eax
  800854:	74 26                	je     80087c <vsnprintf+0x47>
  800856:	85 d2                	test   %edx,%edx
  800858:	7e 22                	jle    80087c <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80085a:	ff 75 14             	pushl  0x14(%ebp)
  80085d:	ff 75 10             	pushl  0x10(%ebp)
  800860:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800863:	50                   	push   %eax
  800864:	68 a3 02 80 00       	push   $0x8002a3
  800869:	e8 6f fa ff ff       	call   8002dd <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80086e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800871:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800874:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800877:	83 c4 10             	add    $0x10,%esp
}
  80087a:	c9                   	leave  
  80087b:	c3                   	ret    
		return -E_INVAL;
  80087c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800881:	eb f7                	jmp    80087a <vsnprintf+0x45>

00800883 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800883:	55                   	push   %ebp
  800884:	89 e5                	mov    %esp,%ebp
  800886:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800889:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80088c:	50                   	push   %eax
  80088d:	ff 75 10             	pushl  0x10(%ebp)
  800890:	ff 75 0c             	pushl  0xc(%ebp)
  800893:	ff 75 08             	pushl  0x8(%ebp)
  800896:	e8 9a ff ff ff       	call   800835 <vsnprintf>
	va_end(ap);

	return rc;
}
  80089b:	c9                   	leave  
  80089c:	c3                   	ret    

0080089d <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80089d:	55                   	push   %ebp
  80089e:	89 e5                	mov    %esp,%ebp
  8008a0:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8008a8:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008ac:	74 05                	je     8008b3 <strlen+0x16>
		n++;
  8008ae:	83 c0 01             	add    $0x1,%eax
  8008b1:	eb f5                	jmp    8008a8 <strlen+0xb>
	return n;
}
  8008b3:	5d                   	pop    %ebp
  8008b4:	c3                   	ret    

008008b5 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008b5:	55                   	push   %ebp
  8008b6:	89 e5                	mov    %esp,%ebp
  8008b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008bb:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008be:	ba 00 00 00 00       	mov    $0x0,%edx
  8008c3:	39 c2                	cmp    %eax,%edx
  8008c5:	74 0d                	je     8008d4 <strnlen+0x1f>
  8008c7:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8008cb:	74 05                	je     8008d2 <strnlen+0x1d>
		n++;
  8008cd:	83 c2 01             	add    $0x1,%edx
  8008d0:	eb f1                	jmp    8008c3 <strnlen+0xe>
  8008d2:	89 d0                	mov    %edx,%eax
	return n;
}
  8008d4:	5d                   	pop    %ebp
  8008d5:	c3                   	ret    

008008d6 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008d6:	55                   	push   %ebp
  8008d7:	89 e5                	mov    %esp,%ebp
  8008d9:	53                   	push   %ebx
  8008da:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8008e5:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8008e9:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8008ec:	83 c2 01             	add    $0x1,%edx
  8008ef:	84 c9                	test   %cl,%cl
  8008f1:	75 f2                	jne    8008e5 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8008f3:	5b                   	pop    %ebx
  8008f4:	5d                   	pop    %ebp
  8008f5:	c3                   	ret    

008008f6 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008f6:	55                   	push   %ebp
  8008f7:	89 e5                	mov    %esp,%ebp
  8008f9:	53                   	push   %ebx
  8008fa:	83 ec 10             	sub    $0x10,%esp
  8008fd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800900:	53                   	push   %ebx
  800901:	e8 97 ff ff ff       	call   80089d <strlen>
  800906:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800909:	ff 75 0c             	pushl  0xc(%ebp)
  80090c:	01 d8                	add    %ebx,%eax
  80090e:	50                   	push   %eax
  80090f:	e8 c2 ff ff ff       	call   8008d6 <strcpy>
	return dst;
}
  800914:	89 d8                	mov    %ebx,%eax
  800916:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800919:	c9                   	leave  
  80091a:	c3                   	ret    

0080091b <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80091b:	55                   	push   %ebp
  80091c:	89 e5                	mov    %esp,%ebp
  80091e:	56                   	push   %esi
  80091f:	53                   	push   %ebx
  800920:	8b 45 08             	mov    0x8(%ebp),%eax
  800923:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800926:	89 c6                	mov    %eax,%esi
  800928:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80092b:	89 c2                	mov    %eax,%edx
  80092d:	39 f2                	cmp    %esi,%edx
  80092f:	74 11                	je     800942 <strncpy+0x27>
		*dst++ = *src;
  800931:	83 c2 01             	add    $0x1,%edx
  800934:	0f b6 19             	movzbl (%ecx),%ebx
  800937:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80093a:	80 fb 01             	cmp    $0x1,%bl
  80093d:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800940:	eb eb                	jmp    80092d <strncpy+0x12>
	}
	return ret;
}
  800942:	5b                   	pop    %ebx
  800943:	5e                   	pop    %esi
  800944:	5d                   	pop    %ebp
  800945:	c3                   	ret    

00800946 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800946:	55                   	push   %ebp
  800947:	89 e5                	mov    %esp,%ebp
  800949:	56                   	push   %esi
  80094a:	53                   	push   %ebx
  80094b:	8b 75 08             	mov    0x8(%ebp),%esi
  80094e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800951:	8b 55 10             	mov    0x10(%ebp),%edx
  800954:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800956:	85 d2                	test   %edx,%edx
  800958:	74 21                	je     80097b <strlcpy+0x35>
  80095a:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80095e:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800960:	39 c2                	cmp    %eax,%edx
  800962:	74 14                	je     800978 <strlcpy+0x32>
  800964:	0f b6 19             	movzbl (%ecx),%ebx
  800967:	84 db                	test   %bl,%bl
  800969:	74 0b                	je     800976 <strlcpy+0x30>
			*dst++ = *src++;
  80096b:	83 c1 01             	add    $0x1,%ecx
  80096e:	83 c2 01             	add    $0x1,%edx
  800971:	88 5a ff             	mov    %bl,-0x1(%edx)
  800974:	eb ea                	jmp    800960 <strlcpy+0x1a>
  800976:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800978:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80097b:	29 f0                	sub    %esi,%eax
}
  80097d:	5b                   	pop    %ebx
  80097e:	5e                   	pop    %esi
  80097f:	5d                   	pop    %ebp
  800980:	c3                   	ret    

00800981 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800981:	55                   	push   %ebp
  800982:	89 e5                	mov    %esp,%ebp
  800984:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800987:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80098a:	0f b6 01             	movzbl (%ecx),%eax
  80098d:	84 c0                	test   %al,%al
  80098f:	74 0c                	je     80099d <strcmp+0x1c>
  800991:	3a 02                	cmp    (%edx),%al
  800993:	75 08                	jne    80099d <strcmp+0x1c>
		p++, q++;
  800995:	83 c1 01             	add    $0x1,%ecx
  800998:	83 c2 01             	add    $0x1,%edx
  80099b:	eb ed                	jmp    80098a <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80099d:	0f b6 c0             	movzbl %al,%eax
  8009a0:	0f b6 12             	movzbl (%edx),%edx
  8009a3:	29 d0                	sub    %edx,%eax
}
  8009a5:	5d                   	pop    %ebp
  8009a6:	c3                   	ret    

008009a7 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009a7:	55                   	push   %ebp
  8009a8:	89 e5                	mov    %esp,%ebp
  8009aa:	53                   	push   %ebx
  8009ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009b1:	89 c3                	mov    %eax,%ebx
  8009b3:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009b6:	eb 06                	jmp    8009be <strncmp+0x17>
		n--, p++, q++;
  8009b8:	83 c0 01             	add    $0x1,%eax
  8009bb:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009be:	39 d8                	cmp    %ebx,%eax
  8009c0:	74 16                	je     8009d8 <strncmp+0x31>
  8009c2:	0f b6 08             	movzbl (%eax),%ecx
  8009c5:	84 c9                	test   %cl,%cl
  8009c7:	74 04                	je     8009cd <strncmp+0x26>
  8009c9:	3a 0a                	cmp    (%edx),%cl
  8009cb:	74 eb                	je     8009b8 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009cd:	0f b6 00             	movzbl (%eax),%eax
  8009d0:	0f b6 12             	movzbl (%edx),%edx
  8009d3:	29 d0                	sub    %edx,%eax
}
  8009d5:	5b                   	pop    %ebx
  8009d6:	5d                   	pop    %ebp
  8009d7:	c3                   	ret    
		return 0;
  8009d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8009dd:	eb f6                	jmp    8009d5 <strncmp+0x2e>

008009df <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009df:	55                   	push   %ebp
  8009e0:	89 e5                	mov    %esp,%ebp
  8009e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e5:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009e9:	0f b6 10             	movzbl (%eax),%edx
  8009ec:	84 d2                	test   %dl,%dl
  8009ee:	74 09                	je     8009f9 <strchr+0x1a>
		if (*s == c)
  8009f0:	38 ca                	cmp    %cl,%dl
  8009f2:	74 0a                	je     8009fe <strchr+0x1f>
	for (; *s; s++)
  8009f4:	83 c0 01             	add    $0x1,%eax
  8009f7:	eb f0                	jmp    8009e9 <strchr+0xa>
			return (char *) s;
	return 0;
  8009f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009fe:	5d                   	pop    %ebp
  8009ff:	c3                   	ret    

00800a00 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a00:	55                   	push   %ebp
  800a01:	89 e5                	mov    %esp,%ebp
  800a03:	8b 45 08             	mov    0x8(%ebp),%eax
  800a06:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a0a:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a0d:	38 ca                	cmp    %cl,%dl
  800a0f:	74 09                	je     800a1a <strfind+0x1a>
  800a11:	84 d2                	test   %dl,%dl
  800a13:	74 05                	je     800a1a <strfind+0x1a>
	for (; *s; s++)
  800a15:	83 c0 01             	add    $0x1,%eax
  800a18:	eb f0                	jmp    800a0a <strfind+0xa>
			break;
	return (char *) s;
}
  800a1a:	5d                   	pop    %ebp
  800a1b:	c3                   	ret    

00800a1c <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a1c:	55                   	push   %ebp
  800a1d:	89 e5                	mov    %esp,%ebp
  800a1f:	57                   	push   %edi
  800a20:	56                   	push   %esi
  800a21:	53                   	push   %ebx
  800a22:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a25:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a28:	85 c9                	test   %ecx,%ecx
  800a2a:	74 31                	je     800a5d <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a2c:	89 f8                	mov    %edi,%eax
  800a2e:	09 c8                	or     %ecx,%eax
  800a30:	a8 03                	test   $0x3,%al
  800a32:	75 23                	jne    800a57 <memset+0x3b>
		c &= 0xFF;
  800a34:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a38:	89 d3                	mov    %edx,%ebx
  800a3a:	c1 e3 08             	shl    $0x8,%ebx
  800a3d:	89 d0                	mov    %edx,%eax
  800a3f:	c1 e0 18             	shl    $0x18,%eax
  800a42:	89 d6                	mov    %edx,%esi
  800a44:	c1 e6 10             	shl    $0x10,%esi
  800a47:	09 f0                	or     %esi,%eax
  800a49:	09 c2                	or     %eax,%edx
  800a4b:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a4d:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a50:	89 d0                	mov    %edx,%eax
  800a52:	fc                   	cld    
  800a53:	f3 ab                	rep stos %eax,%es:(%edi)
  800a55:	eb 06                	jmp    800a5d <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a5a:	fc                   	cld    
  800a5b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a5d:	89 f8                	mov    %edi,%eax
  800a5f:	5b                   	pop    %ebx
  800a60:	5e                   	pop    %esi
  800a61:	5f                   	pop    %edi
  800a62:	5d                   	pop    %ebp
  800a63:	c3                   	ret    

00800a64 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a64:	55                   	push   %ebp
  800a65:	89 e5                	mov    %esp,%ebp
  800a67:	57                   	push   %edi
  800a68:	56                   	push   %esi
  800a69:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a6f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a72:	39 c6                	cmp    %eax,%esi
  800a74:	73 32                	jae    800aa8 <memmove+0x44>
  800a76:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a79:	39 c2                	cmp    %eax,%edx
  800a7b:	76 2b                	jbe    800aa8 <memmove+0x44>
		s += n;
		d += n;
  800a7d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a80:	89 fe                	mov    %edi,%esi
  800a82:	09 ce                	or     %ecx,%esi
  800a84:	09 d6                	or     %edx,%esi
  800a86:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a8c:	75 0e                	jne    800a9c <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a8e:	83 ef 04             	sub    $0x4,%edi
  800a91:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a94:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a97:	fd                   	std    
  800a98:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a9a:	eb 09                	jmp    800aa5 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a9c:	83 ef 01             	sub    $0x1,%edi
  800a9f:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800aa2:	fd                   	std    
  800aa3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800aa5:	fc                   	cld    
  800aa6:	eb 1a                	jmp    800ac2 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aa8:	89 c2                	mov    %eax,%edx
  800aaa:	09 ca                	or     %ecx,%edx
  800aac:	09 f2                	or     %esi,%edx
  800aae:	f6 c2 03             	test   $0x3,%dl
  800ab1:	75 0a                	jne    800abd <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ab3:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800ab6:	89 c7                	mov    %eax,%edi
  800ab8:	fc                   	cld    
  800ab9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800abb:	eb 05                	jmp    800ac2 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800abd:	89 c7                	mov    %eax,%edi
  800abf:	fc                   	cld    
  800ac0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ac2:	5e                   	pop    %esi
  800ac3:	5f                   	pop    %edi
  800ac4:	5d                   	pop    %ebp
  800ac5:	c3                   	ret    

00800ac6 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ac6:	55                   	push   %ebp
  800ac7:	89 e5                	mov    %esp,%ebp
  800ac9:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800acc:	ff 75 10             	pushl  0x10(%ebp)
  800acf:	ff 75 0c             	pushl  0xc(%ebp)
  800ad2:	ff 75 08             	pushl  0x8(%ebp)
  800ad5:	e8 8a ff ff ff       	call   800a64 <memmove>
}
  800ada:	c9                   	leave  
  800adb:	c3                   	ret    

00800adc <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800adc:	55                   	push   %ebp
  800add:	89 e5                	mov    %esp,%ebp
  800adf:	56                   	push   %esi
  800ae0:	53                   	push   %ebx
  800ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ae7:	89 c6                	mov    %eax,%esi
  800ae9:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800aec:	39 f0                	cmp    %esi,%eax
  800aee:	74 1c                	je     800b0c <memcmp+0x30>
		if (*s1 != *s2)
  800af0:	0f b6 08             	movzbl (%eax),%ecx
  800af3:	0f b6 1a             	movzbl (%edx),%ebx
  800af6:	38 d9                	cmp    %bl,%cl
  800af8:	75 08                	jne    800b02 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800afa:	83 c0 01             	add    $0x1,%eax
  800afd:	83 c2 01             	add    $0x1,%edx
  800b00:	eb ea                	jmp    800aec <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b02:	0f b6 c1             	movzbl %cl,%eax
  800b05:	0f b6 db             	movzbl %bl,%ebx
  800b08:	29 d8                	sub    %ebx,%eax
  800b0a:	eb 05                	jmp    800b11 <memcmp+0x35>
	}

	return 0;
  800b0c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b11:	5b                   	pop    %ebx
  800b12:	5e                   	pop    %esi
  800b13:	5d                   	pop    %ebp
  800b14:	c3                   	ret    

00800b15 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b15:	55                   	push   %ebp
  800b16:	89 e5                	mov    %esp,%ebp
  800b18:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b1e:	89 c2                	mov    %eax,%edx
  800b20:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b23:	39 d0                	cmp    %edx,%eax
  800b25:	73 09                	jae    800b30 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b27:	38 08                	cmp    %cl,(%eax)
  800b29:	74 05                	je     800b30 <memfind+0x1b>
	for (; s < ends; s++)
  800b2b:	83 c0 01             	add    $0x1,%eax
  800b2e:	eb f3                	jmp    800b23 <memfind+0xe>
			break;
	return (void *) s;
}
  800b30:	5d                   	pop    %ebp
  800b31:	c3                   	ret    

00800b32 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b32:	55                   	push   %ebp
  800b33:	89 e5                	mov    %esp,%ebp
  800b35:	57                   	push   %edi
  800b36:	56                   	push   %esi
  800b37:	53                   	push   %ebx
  800b38:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b3b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b3e:	eb 03                	jmp    800b43 <strtol+0x11>
		s++;
  800b40:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b43:	0f b6 01             	movzbl (%ecx),%eax
  800b46:	3c 20                	cmp    $0x20,%al
  800b48:	74 f6                	je     800b40 <strtol+0xe>
  800b4a:	3c 09                	cmp    $0x9,%al
  800b4c:	74 f2                	je     800b40 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b4e:	3c 2b                	cmp    $0x2b,%al
  800b50:	74 2a                	je     800b7c <strtol+0x4a>
	int neg = 0;
  800b52:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b57:	3c 2d                	cmp    $0x2d,%al
  800b59:	74 2b                	je     800b86 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b5b:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b61:	75 0f                	jne    800b72 <strtol+0x40>
  800b63:	80 39 30             	cmpb   $0x30,(%ecx)
  800b66:	74 28                	je     800b90 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b68:	85 db                	test   %ebx,%ebx
  800b6a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b6f:	0f 44 d8             	cmove  %eax,%ebx
  800b72:	b8 00 00 00 00       	mov    $0x0,%eax
  800b77:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b7a:	eb 50                	jmp    800bcc <strtol+0x9a>
		s++;
  800b7c:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b7f:	bf 00 00 00 00       	mov    $0x0,%edi
  800b84:	eb d5                	jmp    800b5b <strtol+0x29>
		s++, neg = 1;
  800b86:	83 c1 01             	add    $0x1,%ecx
  800b89:	bf 01 00 00 00       	mov    $0x1,%edi
  800b8e:	eb cb                	jmp    800b5b <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b90:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b94:	74 0e                	je     800ba4 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800b96:	85 db                	test   %ebx,%ebx
  800b98:	75 d8                	jne    800b72 <strtol+0x40>
		s++, base = 8;
  800b9a:	83 c1 01             	add    $0x1,%ecx
  800b9d:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ba2:	eb ce                	jmp    800b72 <strtol+0x40>
		s += 2, base = 16;
  800ba4:	83 c1 02             	add    $0x2,%ecx
  800ba7:	bb 10 00 00 00       	mov    $0x10,%ebx
  800bac:	eb c4                	jmp    800b72 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800bae:	8d 72 9f             	lea    -0x61(%edx),%esi
  800bb1:	89 f3                	mov    %esi,%ebx
  800bb3:	80 fb 19             	cmp    $0x19,%bl
  800bb6:	77 29                	ja     800be1 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800bb8:	0f be d2             	movsbl %dl,%edx
  800bbb:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800bbe:	3b 55 10             	cmp    0x10(%ebp),%edx
  800bc1:	7d 30                	jge    800bf3 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800bc3:	83 c1 01             	add    $0x1,%ecx
  800bc6:	0f af 45 10          	imul   0x10(%ebp),%eax
  800bca:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800bcc:	0f b6 11             	movzbl (%ecx),%edx
  800bcf:	8d 72 d0             	lea    -0x30(%edx),%esi
  800bd2:	89 f3                	mov    %esi,%ebx
  800bd4:	80 fb 09             	cmp    $0x9,%bl
  800bd7:	77 d5                	ja     800bae <strtol+0x7c>
			dig = *s - '0';
  800bd9:	0f be d2             	movsbl %dl,%edx
  800bdc:	83 ea 30             	sub    $0x30,%edx
  800bdf:	eb dd                	jmp    800bbe <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800be1:	8d 72 bf             	lea    -0x41(%edx),%esi
  800be4:	89 f3                	mov    %esi,%ebx
  800be6:	80 fb 19             	cmp    $0x19,%bl
  800be9:	77 08                	ja     800bf3 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800beb:	0f be d2             	movsbl %dl,%edx
  800bee:	83 ea 37             	sub    $0x37,%edx
  800bf1:	eb cb                	jmp    800bbe <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800bf3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bf7:	74 05                	je     800bfe <strtol+0xcc>
		*endptr = (char *) s;
  800bf9:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bfc:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800bfe:	89 c2                	mov    %eax,%edx
  800c00:	f7 da                	neg    %edx
  800c02:	85 ff                	test   %edi,%edi
  800c04:	0f 45 c2             	cmovne %edx,%eax
}
  800c07:	5b                   	pop    %ebx
  800c08:	5e                   	pop    %esi
  800c09:	5f                   	pop    %edi
  800c0a:	5d                   	pop    %ebp
  800c0b:	c3                   	ret    

00800c0c <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c0c:	55                   	push   %ebp
  800c0d:	89 e5                	mov    %esp,%ebp
  800c0f:	57                   	push   %edi
  800c10:	56                   	push   %esi
  800c11:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c12:	b8 00 00 00 00       	mov    $0x0,%eax
  800c17:	8b 55 08             	mov    0x8(%ebp),%edx
  800c1a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c1d:	89 c3                	mov    %eax,%ebx
  800c1f:	89 c7                	mov    %eax,%edi
  800c21:	89 c6                	mov    %eax,%esi
  800c23:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c25:	5b                   	pop    %ebx
  800c26:	5e                   	pop    %esi
  800c27:	5f                   	pop    %edi
  800c28:	5d                   	pop    %ebp
  800c29:	c3                   	ret    

00800c2a <sys_cgetc>:

int
sys_cgetc(void)
{
  800c2a:	55                   	push   %ebp
  800c2b:	89 e5                	mov    %esp,%ebp
  800c2d:	57                   	push   %edi
  800c2e:	56                   	push   %esi
  800c2f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c30:	ba 00 00 00 00       	mov    $0x0,%edx
  800c35:	b8 01 00 00 00       	mov    $0x1,%eax
  800c3a:	89 d1                	mov    %edx,%ecx
  800c3c:	89 d3                	mov    %edx,%ebx
  800c3e:	89 d7                	mov    %edx,%edi
  800c40:	89 d6                	mov    %edx,%esi
  800c42:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c44:	5b                   	pop    %ebx
  800c45:	5e                   	pop    %esi
  800c46:	5f                   	pop    %edi
  800c47:	5d                   	pop    %ebp
  800c48:	c3                   	ret    

00800c49 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c49:	55                   	push   %ebp
  800c4a:	89 e5                	mov    %esp,%ebp
  800c4c:	57                   	push   %edi
  800c4d:	56                   	push   %esi
  800c4e:	53                   	push   %ebx
  800c4f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c52:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c57:	8b 55 08             	mov    0x8(%ebp),%edx
  800c5a:	b8 03 00 00 00       	mov    $0x3,%eax
  800c5f:	89 cb                	mov    %ecx,%ebx
  800c61:	89 cf                	mov    %ecx,%edi
  800c63:	89 ce                	mov    %ecx,%esi
  800c65:	cd 30                	int    $0x30
	if (check && ret > 0)
  800c67:	85 c0                	test   %eax,%eax
  800c69:	7f 08                	jg     800c73 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c6e:	5b                   	pop    %ebx
  800c6f:	5e                   	pop    %esi
  800c70:	5f                   	pop    %edi
  800c71:	5d                   	pop    %ebp
  800c72:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c73:	83 ec 0c             	sub    $0xc,%esp
  800c76:	50                   	push   %eax
  800c77:	6a 03                	push   $0x3
  800c79:	68 00 1b 80 00       	push   $0x801b00
  800c7e:	6a 4c                	push   $0x4c
  800c80:	68 1d 1b 80 00       	push   $0x801b1d
  800c85:	e8 81 07 00 00       	call   80140b <_panic>

00800c8a <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c8a:	55                   	push   %ebp
  800c8b:	89 e5                	mov    %esp,%ebp
  800c8d:	57                   	push   %edi
  800c8e:	56                   	push   %esi
  800c8f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c90:	ba 00 00 00 00       	mov    $0x0,%edx
  800c95:	b8 02 00 00 00       	mov    $0x2,%eax
  800c9a:	89 d1                	mov    %edx,%ecx
  800c9c:	89 d3                	mov    %edx,%ebx
  800c9e:	89 d7                	mov    %edx,%edi
  800ca0:	89 d6                	mov    %edx,%esi
  800ca2:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800ca4:	5b                   	pop    %ebx
  800ca5:	5e                   	pop    %esi
  800ca6:	5f                   	pop    %edi
  800ca7:	5d                   	pop    %ebp
  800ca8:	c3                   	ret    

00800ca9 <sys_yield>:

void
sys_yield(void)
{
  800ca9:	55                   	push   %ebp
  800caa:	89 e5                	mov    %esp,%ebp
  800cac:	57                   	push   %edi
  800cad:	56                   	push   %esi
  800cae:	53                   	push   %ebx
	asm volatile("int %1\n"
  800caf:	ba 00 00 00 00       	mov    $0x0,%edx
  800cb4:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cb9:	89 d1                	mov    %edx,%ecx
  800cbb:	89 d3                	mov    %edx,%ebx
  800cbd:	89 d7                	mov    %edx,%edi
  800cbf:	89 d6                	mov    %edx,%esi
  800cc1:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cc3:	5b                   	pop    %ebx
  800cc4:	5e                   	pop    %esi
  800cc5:	5f                   	pop    %edi
  800cc6:	5d                   	pop    %ebp
  800cc7:	c3                   	ret    

00800cc8 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cc8:	55                   	push   %ebp
  800cc9:	89 e5                	mov    %esp,%ebp
  800ccb:	57                   	push   %edi
  800ccc:	56                   	push   %esi
  800ccd:	53                   	push   %ebx
  800cce:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cd1:	be 00 00 00 00       	mov    $0x0,%esi
  800cd6:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cdc:	b8 04 00 00 00       	mov    $0x4,%eax
  800ce1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ce4:	89 f7                	mov    %esi,%edi
  800ce6:	cd 30                	int    $0x30
	if (check && ret > 0)
  800ce8:	85 c0                	test   %eax,%eax
  800cea:	7f 08                	jg     800cf4 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800cec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cef:	5b                   	pop    %ebx
  800cf0:	5e                   	pop    %esi
  800cf1:	5f                   	pop    %edi
  800cf2:	5d                   	pop    %ebp
  800cf3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cf4:	83 ec 0c             	sub    $0xc,%esp
  800cf7:	50                   	push   %eax
  800cf8:	6a 04                	push   $0x4
  800cfa:	68 00 1b 80 00       	push   $0x801b00
  800cff:	6a 4c                	push   $0x4c
  800d01:	68 1d 1b 80 00       	push   $0x801b1d
  800d06:	e8 00 07 00 00       	call   80140b <_panic>

00800d0b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d0b:	55                   	push   %ebp
  800d0c:	89 e5                	mov    %esp,%ebp
  800d0e:	57                   	push   %edi
  800d0f:	56                   	push   %esi
  800d10:	53                   	push   %ebx
  800d11:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d14:	8b 55 08             	mov    0x8(%ebp),%edx
  800d17:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d1a:	b8 05 00 00 00       	mov    $0x5,%eax
  800d1f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d22:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d25:	8b 75 18             	mov    0x18(%ebp),%esi
  800d28:	cd 30                	int    $0x30
	if (check && ret > 0)
  800d2a:	85 c0                	test   %eax,%eax
  800d2c:	7f 08                	jg     800d36 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d31:	5b                   	pop    %ebx
  800d32:	5e                   	pop    %esi
  800d33:	5f                   	pop    %edi
  800d34:	5d                   	pop    %ebp
  800d35:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d36:	83 ec 0c             	sub    $0xc,%esp
  800d39:	50                   	push   %eax
  800d3a:	6a 05                	push   $0x5
  800d3c:	68 00 1b 80 00       	push   $0x801b00
  800d41:	6a 4c                	push   $0x4c
  800d43:	68 1d 1b 80 00       	push   $0x801b1d
  800d48:	e8 be 06 00 00       	call   80140b <_panic>

00800d4d <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d4d:	55                   	push   %ebp
  800d4e:	89 e5                	mov    %esp,%ebp
  800d50:	57                   	push   %edi
  800d51:	56                   	push   %esi
  800d52:	53                   	push   %ebx
  800d53:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d56:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d5b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d61:	b8 06 00 00 00       	mov    $0x6,%eax
  800d66:	89 df                	mov    %ebx,%edi
  800d68:	89 de                	mov    %ebx,%esi
  800d6a:	cd 30                	int    $0x30
	if (check && ret > 0)
  800d6c:	85 c0                	test   %eax,%eax
  800d6e:	7f 08                	jg     800d78 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d70:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d73:	5b                   	pop    %ebx
  800d74:	5e                   	pop    %esi
  800d75:	5f                   	pop    %edi
  800d76:	5d                   	pop    %ebp
  800d77:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d78:	83 ec 0c             	sub    $0xc,%esp
  800d7b:	50                   	push   %eax
  800d7c:	6a 06                	push   $0x6
  800d7e:	68 00 1b 80 00       	push   $0x801b00
  800d83:	6a 4c                	push   $0x4c
  800d85:	68 1d 1b 80 00       	push   $0x801b1d
  800d8a:	e8 7c 06 00 00       	call   80140b <_panic>

00800d8f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d8f:	55                   	push   %ebp
  800d90:	89 e5                	mov    %esp,%ebp
  800d92:	57                   	push   %edi
  800d93:	56                   	push   %esi
  800d94:	53                   	push   %ebx
  800d95:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d98:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d9d:	8b 55 08             	mov    0x8(%ebp),%edx
  800da0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da3:	b8 08 00 00 00       	mov    $0x8,%eax
  800da8:	89 df                	mov    %ebx,%edi
  800daa:	89 de                	mov    %ebx,%esi
  800dac:	cd 30                	int    $0x30
	if (check && ret > 0)
  800dae:	85 c0                	test   %eax,%eax
  800db0:	7f 08                	jg     800dba <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800db2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800db5:	5b                   	pop    %ebx
  800db6:	5e                   	pop    %esi
  800db7:	5f                   	pop    %edi
  800db8:	5d                   	pop    %ebp
  800db9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dba:	83 ec 0c             	sub    $0xc,%esp
  800dbd:	50                   	push   %eax
  800dbe:	6a 08                	push   $0x8
  800dc0:	68 00 1b 80 00       	push   $0x801b00
  800dc5:	6a 4c                	push   $0x4c
  800dc7:	68 1d 1b 80 00       	push   $0x801b1d
  800dcc:	e8 3a 06 00 00       	call   80140b <_panic>

00800dd1 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800dd1:	55                   	push   %ebp
  800dd2:	89 e5                	mov    %esp,%ebp
  800dd4:	57                   	push   %edi
  800dd5:	56                   	push   %esi
  800dd6:	53                   	push   %ebx
  800dd7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dda:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ddf:	8b 55 08             	mov    0x8(%ebp),%edx
  800de2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de5:	b8 09 00 00 00       	mov    $0x9,%eax
  800dea:	89 df                	mov    %ebx,%edi
  800dec:	89 de                	mov    %ebx,%esi
  800dee:	cd 30                	int    $0x30
	if (check && ret > 0)
  800df0:	85 c0                	test   %eax,%eax
  800df2:	7f 08                	jg     800dfc <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800df4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800df7:	5b                   	pop    %ebx
  800df8:	5e                   	pop    %esi
  800df9:	5f                   	pop    %edi
  800dfa:	5d                   	pop    %ebp
  800dfb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dfc:	83 ec 0c             	sub    $0xc,%esp
  800dff:	50                   	push   %eax
  800e00:	6a 09                	push   $0x9
  800e02:	68 00 1b 80 00       	push   $0x801b00
  800e07:	6a 4c                	push   $0x4c
  800e09:	68 1d 1b 80 00       	push   $0x801b1d
  800e0e:	e8 f8 05 00 00       	call   80140b <_panic>

00800e13 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e13:	55                   	push   %ebp
  800e14:	89 e5                	mov    %esp,%ebp
  800e16:	57                   	push   %edi
  800e17:	56                   	push   %esi
  800e18:	53                   	push   %ebx
  800e19:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e1c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e21:	8b 55 08             	mov    0x8(%ebp),%edx
  800e24:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e27:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e2c:	89 df                	mov    %ebx,%edi
  800e2e:	89 de                	mov    %ebx,%esi
  800e30:	cd 30                	int    $0x30
	if (check && ret > 0)
  800e32:	85 c0                	test   %eax,%eax
  800e34:	7f 08                	jg     800e3e <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e36:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e39:	5b                   	pop    %ebx
  800e3a:	5e                   	pop    %esi
  800e3b:	5f                   	pop    %edi
  800e3c:	5d                   	pop    %ebp
  800e3d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e3e:	83 ec 0c             	sub    $0xc,%esp
  800e41:	50                   	push   %eax
  800e42:	6a 0a                	push   $0xa
  800e44:	68 00 1b 80 00       	push   $0x801b00
  800e49:	6a 4c                	push   $0x4c
  800e4b:	68 1d 1b 80 00       	push   $0x801b1d
  800e50:	e8 b6 05 00 00       	call   80140b <_panic>

00800e55 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e55:	55                   	push   %ebp
  800e56:	89 e5                	mov    %esp,%ebp
  800e58:	57                   	push   %edi
  800e59:	56                   	push   %esi
  800e5a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e5b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e61:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e66:	be 00 00 00 00       	mov    $0x0,%esi
  800e6b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e6e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e71:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e73:	5b                   	pop    %ebx
  800e74:	5e                   	pop    %esi
  800e75:	5f                   	pop    %edi
  800e76:	5d                   	pop    %ebp
  800e77:	c3                   	ret    

00800e78 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e78:	55                   	push   %ebp
  800e79:	89 e5                	mov    %esp,%ebp
  800e7b:	57                   	push   %edi
  800e7c:	56                   	push   %esi
  800e7d:	53                   	push   %ebx
  800e7e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e81:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e86:	8b 55 08             	mov    0x8(%ebp),%edx
  800e89:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e8e:	89 cb                	mov    %ecx,%ebx
  800e90:	89 cf                	mov    %ecx,%edi
  800e92:	89 ce                	mov    %ecx,%esi
  800e94:	cd 30                	int    $0x30
	if (check && ret > 0)
  800e96:	85 c0                	test   %eax,%eax
  800e98:	7f 08                	jg     800ea2 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e9a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e9d:	5b                   	pop    %ebx
  800e9e:	5e                   	pop    %esi
  800e9f:	5f                   	pop    %edi
  800ea0:	5d                   	pop    %ebp
  800ea1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ea2:	83 ec 0c             	sub    $0xc,%esp
  800ea5:	50                   	push   %eax
  800ea6:	6a 0d                	push   $0xd
  800ea8:	68 00 1b 80 00       	push   $0x801b00
  800ead:	6a 4c                	push   $0x4c
  800eaf:	68 1d 1b 80 00       	push   $0x801b1d
  800eb4:	e8 52 05 00 00       	call   80140b <_panic>

00800eb9 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800eb9:	55                   	push   %ebp
  800eba:	89 e5                	mov    %esp,%ebp
  800ebc:	57                   	push   %edi
  800ebd:	56                   	push   %esi
  800ebe:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ebf:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ec4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eca:	b8 0e 00 00 00       	mov    $0xe,%eax
  800ecf:	89 df                	mov    %ebx,%edi
  800ed1:	89 de                	mov    %ebx,%esi
  800ed3:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800ed5:	5b                   	pop    %ebx
  800ed6:	5e                   	pop    %esi
  800ed7:	5f                   	pop    %edi
  800ed8:	5d                   	pop    %ebp
  800ed9:	c3                   	ret    

00800eda <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800eda:	55                   	push   %ebp
  800edb:	89 e5                	mov    %esp,%ebp
  800edd:	57                   	push   %edi
  800ede:	56                   	push   %esi
  800edf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ee0:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ee5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee8:	b8 0f 00 00 00       	mov    $0xf,%eax
  800eed:	89 cb                	mov    %ecx,%ebx
  800eef:	89 cf                	mov    %ecx,%edi
  800ef1:	89 ce                	mov    %ecx,%esi
  800ef3:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800ef5:	5b                   	pop    %ebx
  800ef6:	5e                   	pop    %esi
  800ef7:	5f                   	pop    %edi
  800ef8:	5d                   	pop    %ebp
  800ef9:	c3                   	ret    

00800efa <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800efa:	55                   	push   %ebp
  800efb:	89 e5                	mov    %esp,%ebp
  800efd:	53                   	push   %ebx
  800efe:	83 ec 04             	sub    $0x4,%esp
  800f01:	8b 55 08             	mov    0x8(%ebp),%edx
	// cprintf("pgfault()\n");
	void *addr = (void *) utf->utf_fault_va;
  800f04:	8b 02                	mov    (%edx),%eax
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(!(err & FEC_WR) || !(uvpd[PDX(addr)] & PTE_P) || !(uvpt[PGNUM(addr)] & PTE_P) || !(uvpt[PGNUM(addr)] & PTE_COW))
  800f06:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  800f0a:	0f 84 9c 00 00 00    	je     800fac <pgfault+0xb2>
  800f10:	89 c2                	mov    %eax,%edx
  800f12:	c1 ea 16             	shr    $0x16,%edx
  800f15:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f1c:	f6 c2 01             	test   $0x1,%dl
  800f1f:	0f 84 87 00 00 00    	je     800fac <pgfault+0xb2>
  800f25:	89 c2                	mov    %eax,%edx
  800f27:	c1 ea 0c             	shr    $0xc,%edx
  800f2a:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  800f31:	f6 c1 01             	test   $0x1,%cl
  800f34:	74 76                	je     800fac <pgfault+0xb2>
  800f36:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f3d:	f6 c6 08             	test   $0x8,%dh
  800f40:	74 6a                	je     800fac <pgfault+0xb2>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  800f42:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f47:	89 c3                	mov    %eax,%ebx

	r = sys_page_alloc(0, PFTEMP, PTE_P|PTE_U|PTE_W);
  800f49:	83 ec 04             	sub    $0x4,%esp
  800f4c:	6a 07                	push   $0x7
  800f4e:	68 00 f0 7f 00       	push   $0x7ff000
  800f53:	6a 00                	push   $0x0
  800f55:	e8 6e fd ff ff       	call   800cc8 <sys_page_alloc>
	if(r < 0){
  800f5a:	83 c4 10             	add    $0x10,%esp
  800f5d:	85 c0                	test   %eax,%eax
  800f5f:	78 5f                	js     800fc0 <pgfault+0xc6>
		panic("pgfault: sys_page_alloc fail, r: %d", r);
	}

	memmove(PFTEMP, addr, PGSIZE);
  800f61:	83 ec 04             	sub    $0x4,%esp
  800f64:	68 00 10 00 00       	push   $0x1000
  800f69:	53                   	push   %ebx
  800f6a:	68 00 f0 7f 00       	push   $0x7ff000
  800f6f:	e8 f0 fa ff ff       	call   800a64 <memmove>

	r = sys_page_map(0, PFTEMP, 0, addr, PTE_P|PTE_U|PTE_W);
  800f74:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800f7b:	53                   	push   %ebx
  800f7c:	6a 00                	push   $0x0
  800f7e:	68 00 f0 7f 00       	push   $0x7ff000
  800f83:	6a 00                	push   $0x0
  800f85:	e8 81 fd ff ff       	call   800d0b <sys_page_map>
	if(r < 0){
  800f8a:	83 c4 20             	add    $0x20,%esp
  800f8d:	85 c0                	test   %eax,%eax
  800f8f:	78 41                	js     800fd2 <pgfault+0xd8>
		panic("pgfault: sys_page_map fail, r: %d", r);
	}

	r = sys_page_unmap(0, PFTEMP);
  800f91:	83 ec 08             	sub    $0x8,%esp
  800f94:	68 00 f0 7f 00       	push   $0x7ff000
  800f99:	6a 00                	push   $0x0
  800f9b:	e8 ad fd ff ff       	call   800d4d <sys_page_unmap>
	if(r < 0){
  800fa0:	83 c4 10             	add    $0x10,%esp
  800fa3:	85 c0                	test   %eax,%eax
  800fa5:	78 3d                	js     800fe4 <pgfault+0xea>
		panic("sys_page_unmap: %e", r);
	}
}
  800fa7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800faa:	c9                   	leave  
  800fab:	c3                   	ret    
		panic("pgfault: 1\n");
  800fac:	83 ec 04             	sub    $0x4,%esp
  800faf:	68 2b 1b 80 00       	push   $0x801b2b
  800fb4:	6a 20                	push   $0x20
  800fb6:	68 37 1b 80 00       	push   $0x801b37
  800fbb:	e8 4b 04 00 00       	call   80140b <_panic>
		panic("pgfault: sys_page_alloc fail, r: %d", r);
  800fc0:	50                   	push   %eax
  800fc1:	68 8c 1b 80 00       	push   $0x801b8c
  800fc6:	6a 2e                	push   $0x2e
  800fc8:	68 37 1b 80 00       	push   $0x801b37
  800fcd:	e8 39 04 00 00       	call   80140b <_panic>
		panic("pgfault: sys_page_map fail, r: %d", r);
  800fd2:	50                   	push   %eax
  800fd3:	68 b0 1b 80 00       	push   $0x801bb0
  800fd8:	6a 35                	push   $0x35
  800fda:	68 37 1b 80 00       	push   $0x801b37
  800fdf:	e8 27 04 00 00       	call   80140b <_panic>
		panic("sys_page_unmap: %e", r);
  800fe4:	50                   	push   %eax
  800fe5:	68 42 1b 80 00       	push   $0x801b42
  800fea:	6a 3a                	push   $0x3a
  800fec:	68 37 1b 80 00       	push   $0x801b37
  800ff1:	e8 15 04 00 00       	call   80140b <_panic>

00800ff6 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800ff6:	55                   	push   %ebp
  800ff7:	89 e5                	mov    %esp,%ebp
  800ff9:	57                   	push   %edi
  800ffa:	56                   	push   %esi
  800ffb:	53                   	push   %ebx
  800ffc:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	// panic("fork not implemented");
	int r;
	set_pgfault_handler(pgfault);
  800fff:	68 fa 0e 80 00       	push   $0x800efa
  801004:	e8 48 04 00 00       	call   801451 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801009:	b8 07 00 00 00       	mov    $0x7,%eax
  80100e:	cd 30                	int    $0x30
  801010:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int i;
	uintptr_t va;
	envid_t childid = sys_exofork();
	if (childid < 0){
  801013:	83 c4 10             	add    $0x10,%esp
  801016:	85 c0                	test   %eax,%eax
  801018:	78 2c                	js     801046 <fork+0x50>
  80101a:	89 c7                	mov    %eax,%edi
	}

	extern volatile pde_t uvpd[];
	extern volatile pte_t uvpt[];

	for (va = UTEXT; va < USTACKTOP; va += PGSIZE){
  80101c:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if (childid == 0) {
  801021:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801025:	75 72                	jne    801099 <fork+0xa3>
		thisenv = &envs[ENVX(sys_getenvid())];
  801027:	e8 5e fc ff ff       	call   800c8a <sys_getenvid>
  80102c:	25 ff 03 00 00       	and    $0x3ff,%eax
  801031:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  801037:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80103c:	a3 04 20 80 00       	mov    %eax,0x802004
		return 0;
  801041:	e9 36 01 00 00       	jmp    80117c <fork+0x186>
		panic("fork: child id < 0: %d", childid);
  801046:	50                   	push   %eax
  801047:	68 55 1b 80 00       	push   $0x801b55
  80104c:	68 83 00 00 00       	push   $0x83
  801051:	68 37 1b 80 00       	push   $0x801b37
  801056:	e8 b0 03 00 00       	call   80140b <_panic>
			panic("sys_page_map: sys_page_map fail, r:%d\n", r);
  80105b:	50                   	push   %eax
  80105c:	68 d4 1b 80 00       	push   $0x801bd4
  801061:	6a 56                	push   $0x56
  801063:	68 37 1b 80 00       	push   $0x801b37
  801068:	e8 9e 03 00 00       	call   80140b <_panic>
		r = sys_page_map((envid_t)0, va, envid, va, PTE_U | PTE_P);
  80106d:	83 ec 0c             	sub    $0xc,%esp
  801070:	6a 05                	push   $0x5
  801072:	56                   	push   %esi
  801073:	57                   	push   %edi
  801074:	56                   	push   %esi
  801075:	6a 00                	push   $0x0
  801077:	e8 8f fc ff ff       	call   800d0b <sys_page_map>
		if(r < 0){
  80107c:	83 c4 20             	add    $0x20,%esp
  80107f:	85 c0                	test   %eax,%eax
  801081:	0f 88 9f 00 00 00    	js     801126 <fork+0x130>
	for (va = UTEXT; va < USTACKTOP; va += PGSIZE){
  801087:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80108d:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801093:	0f 84 9f 00 00 00    	je     801138 <fork+0x142>
		if ((uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_U)){
  801099:	89 d8                	mov    %ebx,%eax
  80109b:	c1 e8 16             	shr    $0x16,%eax
  80109e:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8010a5:	a8 01                	test   $0x1,%al
  8010a7:	74 de                	je     801087 <fork+0x91>
  8010a9:	89 d8                	mov    %ebx,%eax
  8010ab:	c1 e8 0c             	shr    $0xc,%eax
  8010ae:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8010b5:	f6 c2 01             	test   $0x1,%dl
  8010b8:	74 cd                	je     801087 <fork+0x91>
  8010ba:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8010c1:	f6 c2 04             	test   $0x4,%dl
  8010c4:	74 c1                	je     801087 <fork+0x91>
	void * va = (void *)(pn * PGSIZE);
  8010c6:	89 c6                	mov    %eax,%esi
  8010c8:	c1 e6 0c             	shl    $0xc,%esi
	int perm = (uvpt[pn]);
  8010cb:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (perm & (PTE_W | PTE_COW)) {
  8010d2:	a9 02 08 00 00       	test   $0x802,%eax
  8010d7:	74 94                	je     80106d <fork+0x77>
		r = sys_page_map((envid_t)0, va, envid, va, PTE_U | PTE_P | PTE_COW);
  8010d9:	83 ec 0c             	sub    $0xc,%esp
  8010dc:	68 05 08 00 00       	push   $0x805
  8010e1:	56                   	push   %esi
  8010e2:	57                   	push   %edi
  8010e3:	56                   	push   %esi
  8010e4:	6a 00                	push   $0x0
  8010e6:	e8 20 fc ff ff       	call   800d0b <sys_page_map>
		if(r < 0){
  8010eb:	83 c4 20             	add    $0x20,%esp
  8010ee:	85 c0                	test   %eax,%eax
  8010f0:	0f 88 65 ff ff ff    	js     80105b <fork+0x65>
		r = sys_page_map((envid_t)0, va, (envid_t)0, va, PTE_U | PTE_P | PTE_COW);
  8010f6:	83 ec 0c             	sub    $0xc,%esp
  8010f9:	68 05 08 00 00       	push   $0x805
  8010fe:	56                   	push   %esi
  8010ff:	6a 00                	push   $0x0
  801101:	56                   	push   %esi
  801102:	6a 00                	push   $0x0
  801104:	e8 02 fc ff ff       	call   800d0b <sys_page_map>
		if(r < 0){
  801109:	83 c4 20             	add    $0x20,%esp
  80110c:	85 c0                	test   %eax,%eax
  80110e:	0f 89 73 ff ff ff    	jns    801087 <fork+0x91>
			panic("sys_page_map: sys_page_map fail, r:%d\n", r);
  801114:	50                   	push   %eax
  801115:	68 d4 1b 80 00       	push   $0x801bd4
  80111a:	6a 5b                	push   $0x5b
  80111c:	68 37 1b 80 00       	push   $0x801b37
  801121:	e8 e5 02 00 00       	call   80140b <_panic>
			panic("sys_page_map: sys_page_map fail, r:%d\n", r);
  801126:	50                   	push   %eax
  801127:	68 d4 1b 80 00       	push   $0x801bd4
  80112c:	6a 61                	push   $0x61
  80112e:	68 37 1b 80 00       	push   $0x801b37
  801133:	e8 d3 02 00 00       	call   80140b <_panic>
			duppage(childid, PGNUM(va));
		}
	}

	r = sys_page_alloc(childid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801138:	83 ec 04             	sub    $0x4,%esp
  80113b:	6a 07                	push   $0x7
  80113d:	68 00 f0 bf ee       	push   $0xeebff000
  801142:	ff 75 e4             	pushl  -0x1c(%ebp)
  801145:	e8 7e fb ff ff       	call   800cc8 <sys_page_alloc>
	if (r < 0){
  80114a:	83 c4 10             	add    $0x10,%esp
  80114d:	85 c0                	test   %eax,%eax
  80114f:	78 36                	js     801187 <fork+0x191>
		panic("fork: allocate user exception stack for child env error, %d", r);
	}
	r = sys_env_set_pgfault_upcall(childid, _pgfault_upcall);
  801151:	83 ec 08             	sub    $0x8,%esp
  801154:	68 bc 14 80 00       	push   $0x8014bc
  801159:	ff 75 e4             	pushl  -0x1c(%ebp)
  80115c:	e8 b2 fc ff ff       	call   800e13 <sys_env_set_pgfault_upcall>
	if (r < 0){
  801161:	83 c4 10             	add    $0x10,%esp
  801164:	85 c0                	test   %eax,%eax
  801166:	78 34                	js     80119c <fork+0x1a6>
		panic("fork: sys_env_set_pgfault_upcall error, %d", r);
	}
	r = sys_env_set_status(childid, ENV_RUNNABLE);
  801168:	83 ec 08             	sub    $0x8,%esp
  80116b:	6a 02                	push   $0x2
  80116d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801170:	e8 1a fc ff ff       	call   800d8f <sys_env_set_status>
	if(r < 0){
  801175:	83 c4 10             	add    $0x10,%esp
  801178:	85 c0                	test   %eax,%eax
  80117a:	78 35                	js     8011b1 <fork+0x1bb>
		panic("forK: sys_env_set_status, r%d", r);
	}
	return childid;
}
  80117c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80117f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801182:	5b                   	pop    %ebx
  801183:	5e                   	pop    %esi
  801184:	5f                   	pop    %edi
  801185:	5d                   	pop    %ebp
  801186:	c3                   	ret    
		panic("fork: allocate user exception stack for child env error, %d", r);
  801187:	50                   	push   %eax
  801188:	68 fc 1b 80 00       	push   $0x801bfc
  80118d:	68 96 00 00 00       	push   $0x96
  801192:	68 37 1b 80 00       	push   $0x801b37
  801197:	e8 6f 02 00 00       	call   80140b <_panic>
		panic("fork: sys_env_set_pgfault_upcall error, %d", r);
  80119c:	50                   	push   %eax
  80119d:	68 38 1c 80 00       	push   $0x801c38
  8011a2:	68 9a 00 00 00       	push   $0x9a
  8011a7:	68 37 1b 80 00       	push   $0x801b37
  8011ac:	e8 5a 02 00 00       	call   80140b <_panic>
		panic("forK: sys_env_set_status, r%d", r);
  8011b1:	50                   	push   %eax
  8011b2:	68 6c 1b 80 00       	push   $0x801b6c
  8011b7:	68 9e 00 00 00       	push   $0x9e
  8011bc:	68 37 1b 80 00       	push   $0x801b37
  8011c1:	e8 45 02 00 00       	call   80140b <_panic>

008011c6 <sfork>:

// Challenge!
int
sfork(void)
{
  8011c6:	55                   	push   %ebp
  8011c7:	89 e5                	mov    %esp,%ebp
  8011c9:	57                   	push   %edi
  8011ca:	56                   	push   %esi
  8011cb:	53                   	push   %ebx
  8011cc:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// return -E_INVAL;
	set_pgfault_handler(pgfault);
  8011cf:	68 fa 0e 80 00       	push   $0x800efa
  8011d4:	e8 78 02 00 00       	call   801451 <set_pgfault_handler>
  8011d9:	b8 07 00 00 00       	mov    $0x7,%eax
  8011de:	cd 30                	int    $0x30
  8011e0:	89 c6                	mov    %eax,%esi
	int i;
	uintptr_t va;
	envid_t childid = sys_exofork();
	int r;
	if (childid < 0){
  8011e2:	83 c4 10             	add    $0x10,%esp
  8011e5:	85 c0                	test   %eax,%eax
  8011e7:	78 28                	js     801211 <sfork+0x4b>
  8011e9:	89 c7                	mov    %eax,%edi
	}

	extern volatile pde_t uvpd[];
	extern volatile pte_t uvpt[];

	for (va = 0; va < USTACKTOP; va += PGSIZE){
  8011eb:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (childid == 0) {
  8011f0:	75 42                	jne    801234 <sfork+0x6e>
		thisenv = &envs[ENVX(sys_getenvid())];
  8011f2:	e8 93 fa ff ff       	call   800c8a <sys_getenvid>
  8011f7:	25 ff 03 00 00       	and    $0x3ff,%eax
  8011fc:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  801202:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801207:	a3 04 20 80 00       	mov    %eax,0x802004
		return 0;
  80120c:	e9 bc 00 00 00       	jmp    8012cd <sfork+0x107>
		panic("fork: child id < 0: %d", childid);
  801211:	50                   	push   %eax
  801212:	68 55 1b 80 00       	push   $0x801b55
  801217:	68 af 00 00 00       	push   $0xaf
  80121c:	68 37 1b 80 00       	push   $0x801b37
  801221:	e8 e5 01 00 00       	call   80140b <_panic>
	for (va = 0; va < USTACKTOP; va += PGSIZE){
  801226:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80122c:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801232:	74 5b                	je     80128f <sfork+0xc9>
		if ((uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_U)){
  801234:	89 d8                	mov    %ebx,%eax
  801236:	c1 e8 16             	shr    $0x16,%eax
  801239:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801240:	a8 01                	test   $0x1,%al
  801242:	74 e2                	je     801226 <sfork+0x60>
  801244:	89 d8                	mov    %ebx,%eax
  801246:	c1 e8 0c             	shr    $0xc,%eax
  801249:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801250:	f6 c2 01             	test   $0x1,%dl
  801253:	74 d1                	je     801226 <sfork+0x60>
  801255:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80125c:	f6 c2 04             	test   $0x4,%dl
  80125f:	74 c5                	je     801226 <sfork+0x60>
			void *addr = (void *)(PGNUM(va) * PGSIZE);
  801261:	c1 e0 0c             	shl    $0xc,%eax
			struct PageInfo *page;
			pte_t *pte;
			
			// page = page_lookup((envid_t)0->env_pgdir, addr, &pte);
			// page_insert(dstenv->env_pgdir, page, addr, PTE_U | PTE_P);
			r = sys_page_map((envid_t)0, addr, childid, addr, PTE_U | PTE_P);
  801264:	83 ec 0c             	sub    $0xc,%esp
  801267:	6a 05                	push   $0x5
  801269:	50                   	push   %eax
  80126a:	57                   	push   %edi
  80126b:	50                   	push   %eax
  80126c:	6a 00                	push   $0x0
  80126e:	e8 98 fa ff ff       	call   800d0b <sys_page_map>
			if(r < 0){
  801273:	83 c4 20             	add    $0x20,%esp
  801276:	85 c0                	test   %eax,%eax
  801278:	79 ac                	jns    801226 <sfork+0x60>
				panic("sfork: sys_page_map fail, r:%d\n", r);
  80127a:	50                   	push   %eax
  80127b:	68 64 1c 80 00       	push   $0x801c64
  801280:	68 c4 00 00 00       	push   $0xc4
  801285:	68 37 1b 80 00       	push   $0x801b37
  80128a:	e8 7c 01 00 00       	call   80140b <_panic>
			}
		}
	}

	r = sys_page_alloc(childid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  80128f:	83 ec 04             	sub    $0x4,%esp
  801292:	6a 07                	push   $0x7
  801294:	68 00 f0 bf ee       	push   $0xeebff000
  801299:	56                   	push   %esi
  80129a:	e8 29 fa ff ff       	call   800cc8 <sys_page_alloc>
	if (r < 0){
  80129f:	83 c4 10             	add    $0x10,%esp
  8012a2:	85 c0                	test   %eax,%eax
  8012a4:	78 31                	js     8012d7 <sfork+0x111>
		panic("sfork: allocate user exception stack for child env error, %d", r);
	}
	r = sys_env_set_pgfault_upcall(childid, _pgfault_upcall);
  8012a6:	83 ec 08             	sub    $0x8,%esp
  8012a9:	68 bc 14 80 00       	push   $0x8014bc
  8012ae:	56                   	push   %esi
  8012af:	e8 5f fb ff ff       	call   800e13 <sys_env_set_pgfault_upcall>
	if (r < 0){
  8012b4:	83 c4 10             	add    $0x10,%esp
  8012b7:	85 c0                	test   %eax,%eax
  8012b9:	78 31                	js     8012ec <sfork+0x126>
		panic("sfork: sys_env_set_pgfault_upcall error, %d", r);
	}
	r = sys_env_set_status(childid, ENV_RUNNABLE);
  8012bb:	83 ec 08             	sub    $0x8,%esp
  8012be:	6a 02                	push   $0x2
  8012c0:	56                   	push   %esi
  8012c1:	e8 c9 fa ff ff       	call   800d8f <sys_env_set_status>
	if(r < 0){
  8012c6:	83 c4 10             	add    $0x10,%esp
  8012c9:	85 c0                	test   %eax,%eax
  8012cb:	78 34                	js     801301 <sfork+0x13b>
		panic("sforK: sys_env_set_status, r%d", r);
	}
	return childid;
}
  8012cd:	89 f0                	mov    %esi,%eax
  8012cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012d2:	5b                   	pop    %ebx
  8012d3:	5e                   	pop    %esi
  8012d4:	5f                   	pop    %edi
  8012d5:	5d                   	pop    %ebp
  8012d6:	c3                   	ret    
		panic("sfork: allocate user exception stack for child env error, %d", r);
  8012d7:	50                   	push   %eax
  8012d8:	68 84 1c 80 00       	push   $0x801c84
  8012dd:	68 cb 00 00 00       	push   $0xcb
  8012e2:	68 37 1b 80 00       	push   $0x801b37
  8012e7:	e8 1f 01 00 00       	call   80140b <_panic>
		panic("sfork: sys_env_set_pgfault_upcall error, %d", r);
  8012ec:	50                   	push   %eax
  8012ed:	68 c4 1c 80 00       	push   $0x801cc4
  8012f2:	68 cf 00 00 00       	push   $0xcf
  8012f7:	68 37 1b 80 00       	push   $0x801b37
  8012fc:	e8 0a 01 00 00       	call   80140b <_panic>
		panic("sforK: sys_env_set_status, r%d", r);
  801301:	50                   	push   %eax
  801302:	68 f0 1c 80 00       	push   $0x801cf0
  801307:	68 d3 00 00 00       	push   $0xd3
  80130c:	68 37 1b 80 00       	push   $0x801b37
  801311:	e8 f5 00 00 00       	call   80140b <_panic>

00801316 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801316:	55                   	push   %ebp
  801317:	89 e5                	mov    %esp,%ebp
  801319:	56                   	push   %esi
  80131a:	53                   	push   %ebx
  80131b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80131e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801321:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// return 0;
	if(!pg)
  801324:	85 c0                	test   %eax,%eax
		pg = (void*)UTOP;
  801326:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80132b:	0f 44 c2             	cmove  %edx,%eax
	
	int ret;

	ret = sys_ipc_recv(pg);
  80132e:	83 ec 0c             	sub    $0xc,%esp
  801331:	50                   	push   %eax
  801332:	e8 41 fb ff ff       	call   800e78 <sys_ipc_recv>
	if(ret < 0){
  801337:	83 c4 10             	add    $0x10,%esp
  80133a:	85 c0                	test   %eax,%eax
  80133c:	78 2b                	js     801369 <ipc_recv+0x53>
		if(perm_store) *perm_store = 0;
		if(from_env_store) *from_env_store = 0;
		return ret;
	}
	
	if(perm_store)
  80133e:	85 f6                	test   %esi,%esi
  801340:	74 0a                	je     80134c <ipc_recv+0x36>
		*perm_store = thisenv->env_ipc_perm;
  801342:	a1 04 20 80 00       	mov    0x802004,%eax
  801347:	8b 40 78             	mov    0x78(%eax),%eax
  80134a:	89 06                	mov    %eax,(%esi)
	if(from_env_store)
  80134c:	85 db                	test   %ebx,%ebx
  80134e:	74 0a                	je     80135a <ipc_recv+0x44>
		*from_env_store = thisenv->env_ipc_from;
  801350:	a1 04 20 80 00       	mov    0x802004,%eax
  801355:	8b 40 74             	mov    0x74(%eax),%eax
  801358:	89 03                	mov    %eax,(%ebx)

	return thisenv->env_ipc_value;
  80135a:	a1 04 20 80 00       	mov    0x802004,%eax
  80135f:	8b 40 70             	mov    0x70(%eax),%eax
}
  801362:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801365:	5b                   	pop    %ebx
  801366:	5e                   	pop    %esi
  801367:	5d                   	pop    %ebp
  801368:	c3                   	ret    
		if(perm_store) *perm_store = 0;
  801369:	85 f6                	test   %esi,%esi
  80136b:	74 06                	je     801373 <ipc_recv+0x5d>
  80136d:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(from_env_store) *from_env_store = 0;
  801373:	85 db                	test   %ebx,%ebx
  801375:	74 eb                	je     801362 <ipc_recv+0x4c>
  801377:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80137d:	eb e3                	jmp    801362 <ipc_recv+0x4c>

0080137f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80137f:	55                   	push   %ebp
  801380:	89 e5                	mov    %esp,%ebp
  801382:	57                   	push   %edi
  801383:	56                   	push   %esi
  801384:	53                   	push   %ebx
  801385:	83 ec 0c             	sub    $0xc,%esp
  801388:	8b 7d 08             	mov    0x8(%ebp),%edi
  80138b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80138e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
	if (!pg)
  801391:	85 db                	test   %ebx,%ebx
		pg = (void*)UTOP;
  801393:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801398:	0f 44 d8             	cmove  %eax,%ebx

	int ret = -E_IPC_NOT_RECV;
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))) {
  80139b:	ff 75 14             	pushl  0x14(%ebp)
  80139e:	53                   	push   %ebx
  80139f:	56                   	push   %esi
  8013a0:	57                   	push   %edi
  8013a1:	e8 af fa ff ff       	call   800e55 <sys_ipc_try_send>
  8013a6:	83 c4 10             	add    $0x10,%esp
  8013a9:	85 c0                	test   %eax,%eax
  8013ab:	74 17                	je     8013c4 <ipc_send+0x45>
		if(ret != -E_IPC_NOT_RECV){
  8013ad:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8013b0:	74 e9                	je     80139b <ipc_send+0x1c>
			panic("ipc_send: ret : %d", ret);
  8013b2:	50                   	push   %eax
  8013b3:	68 0f 1d 80 00       	push   $0x801d0f
  8013b8:	6a 43                	push   $0x43
  8013ba:	68 22 1d 80 00       	push   $0x801d22
  8013bf:	e8 47 00 00 00       	call   80140b <_panic>
			sys_yield();
		}
	}
}
  8013c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013c7:	5b                   	pop    %ebx
  8013c8:	5e                   	pop    %esi
  8013c9:	5f                   	pop    %edi
  8013ca:	5d                   	pop    %ebp
  8013cb:	c3                   	ret    

008013cc <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8013cc:	55                   	push   %ebp
  8013cd:	89 e5                	mov    %esp,%ebp
  8013cf:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8013d2:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8013d7:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  8013dd:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8013e3:	8b 52 50             	mov    0x50(%edx),%edx
  8013e6:	39 ca                	cmp    %ecx,%edx
  8013e8:	74 11                	je     8013fb <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  8013ea:	83 c0 01             	add    $0x1,%eax
  8013ed:	3d 00 04 00 00       	cmp    $0x400,%eax
  8013f2:	75 e3                	jne    8013d7 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8013f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8013f9:	eb 0e                	jmp    801409 <ipc_find_env+0x3d>
			return envs[i].env_id;
  8013fb:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  801401:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801406:	8b 40 48             	mov    0x48(%eax),%eax
}
  801409:	5d                   	pop    %ebp
  80140a:	c3                   	ret    

0080140b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80140b:	55                   	push   %ebp
  80140c:	89 e5                	mov    %esp,%ebp
  80140e:	56                   	push   %esi
  80140f:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801410:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801413:	8b 35 00 20 80 00    	mov    0x802000,%esi
  801419:	e8 6c f8 ff ff       	call   800c8a <sys_getenvid>
  80141e:	83 ec 0c             	sub    $0xc,%esp
  801421:	ff 75 0c             	pushl  0xc(%ebp)
  801424:	ff 75 08             	pushl  0x8(%ebp)
  801427:	56                   	push   %esi
  801428:	50                   	push   %eax
  801429:	68 2c 1d 80 00       	push   $0x801d2c
  80142e:	e8 7d ed ff ff       	call   8001b0 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801433:	83 c4 18             	add    $0x18,%esp
  801436:	53                   	push   %ebx
  801437:	ff 75 10             	pushl  0x10(%ebp)
  80143a:	e8 20 ed ff ff       	call   80015f <vcprintf>
	cprintf("\n");
  80143f:	c7 04 24 35 1b 80 00 	movl   $0x801b35,(%esp)
  801446:	e8 65 ed ff ff       	call   8001b0 <cprintf>
  80144b:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80144e:	cc                   	int3   
  80144f:	eb fd                	jmp    80144e <_panic+0x43>

00801451 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801451:	55                   	push   %ebp
  801452:	89 e5                	mov    %esp,%ebp
  801454:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801457:	83 3d 08 20 80 00 00 	cmpl   $0x0,0x802008
  80145e:	74 0a                	je     80146a <set_pgfault_handler+0x19>
			panic("set_pgfault_handler: sys_env_set_pgfault_upcall fail, ret:%d", ret);
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801460:	8b 45 08             	mov    0x8(%ebp),%eax
  801463:	a3 08 20 80 00       	mov    %eax,0x802008
}
  801468:	c9                   	leave  
  801469:	c3                   	ret    
		ret = sys_page_alloc((envid_t)0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W);
  80146a:	83 ec 04             	sub    $0x4,%esp
  80146d:	6a 07                	push   $0x7
  80146f:	68 00 f0 bf ee       	push   $0xeebff000
  801474:	6a 00                	push   $0x0
  801476:	e8 4d f8 ff ff       	call   800cc8 <sys_page_alloc>
		if(ret < 0){
  80147b:	83 c4 10             	add    $0x10,%esp
  80147e:	85 c0                	test   %eax,%eax
  801480:	78 28                	js     8014aa <set_pgfault_handler+0x59>
    	ret = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  801482:	83 ec 08             	sub    $0x8,%esp
  801485:	68 bc 14 80 00       	push   $0x8014bc
  80148a:	6a 00                	push   $0x0
  80148c:	e8 82 f9 ff ff       	call   800e13 <sys_env_set_pgfault_upcall>
		if(ret < 0){
  801491:	83 c4 10             	add    $0x10,%esp
  801494:	85 c0                	test   %eax,%eax
  801496:	79 c8                	jns    801460 <set_pgfault_handler+0xf>
			panic("set_pgfault_handler: sys_env_set_pgfault_upcall fail, ret:%d", ret);
  801498:	50                   	push   %eax
  801499:	68 84 1d 80 00       	push   $0x801d84
  80149e:	6a 28                	push   $0x28
  8014a0:	68 c4 1d 80 00       	push   $0x801dc4
  8014a5:	e8 61 ff ff ff       	call   80140b <_panic>
			panic("set_pgfault_handler: sys_page_alloc fail, ret:%d", ret);
  8014aa:	50                   	push   %eax
  8014ab:	68 50 1d 80 00       	push   $0x801d50
  8014b0:	6a 24                	push   $0x24
  8014b2:	68 c4 1d 80 00       	push   $0x801dc4
  8014b7:	e8 4f ff ff ff       	call   80140b <_panic>

008014bc <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8014bc:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8014bd:	a1 08 20 80 00       	mov    0x802008,%eax
	call *%eax
  8014c2:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8014c4:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %edi
  8014c7:	8b 7c 24 28          	mov    0x28(%esp),%edi
	movl 0x30(%esp), %esi
  8014cb:	8b 74 24 30          	mov    0x30(%esp),%esi
	subl $4, %esi
  8014cf:	83 ee 04             	sub    $0x4,%esi
	movl %edi, (%esi)
  8014d2:	89 3e                	mov    %edi,(%esi)
	movl %esi, 0x30(%esp)
  8014d4:	89 74 24 30          	mov    %esi,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  8014d8:	83 c4 08             	add    $0x8,%esp
	popal
  8014db:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8014dc:	83 c4 04             	add    $0x4,%esp
	popfl
  8014df:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8014e0:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  8014e1:	c3                   	ret    
  8014e2:	66 90                	xchg   %ax,%ax
  8014e4:	66 90                	xchg   %ax,%ax
  8014e6:	66 90                	xchg   %ax,%ax
  8014e8:	66 90                	xchg   %ax,%ax
  8014ea:	66 90                	xchg   %ax,%ax
  8014ec:	66 90                	xchg   %ax,%ax
  8014ee:	66 90                	xchg   %ax,%ax

008014f0 <__udivdi3>:
  8014f0:	55                   	push   %ebp
  8014f1:	57                   	push   %edi
  8014f2:	56                   	push   %esi
  8014f3:	53                   	push   %ebx
  8014f4:	83 ec 1c             	sub    $0x1c,%esp
  8014f7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8014fb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8014ff:	8b 74 24 34          	mov    0x34(%esp),%esi
  801503:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801507:	85 d2                	test   %edx,%edx
  801509:	75 4d                	jne    801558 <__udivdi3+0x68>
  80150b:	39 f3                	cmp    %esi,%ebx
  80150d:	76 19                	jbe    801528 <__udivdi3+0x38>
  80150f:	31 ff                	xor    %edi,%edi
  801511:	89 e8                	mov    %ebp,%eax
  801513:	89 f2                	mov    %esi,%edx
  801515:	f7 f3                	div    %ebx
  801517:	89 fa                	mov    %edi,%edx
  801519:	83 c4 1c             	add    $0x1c,%esp
  80151c:	5b                   	pop    %ebx
  80151d:	5e                   	pop    %esi
  80151e:	5f                   	pop    %edi
  80151f:	5d                   	pop    %ebp
  801520:	c3                   	ret    
  801521:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801528:	89 d9                	mov    %ebx,%ecx
  80152a:	85 db                	test   %ebx,%ebx
  80152c:	75 0b                	jne    801539 <__udivdi3+0x49>
  80152e:	b8 01 00 00 00       	mov    $0x1,%eax
  801533:	31 d2                	xor    %edx,%edx
  801535:	f7 f3                	div    %ebx
  801537:	89 c1                	mov    %eax,%ecx
  801539:	31 d2                	xor    %edx,%edx
  80153b:	89 f0                	mov    %esi,%eax
  80153d:	f7 f1                	div    %ecx
  80153f:	89 c6                	mov    %eax,%esi
  801541:	89 e8                	mov    %ebp,%eax
  801543:	89 f7                	mov    %esi,%edi
  801545:	f7 f1                	div    %ecx
  801547:	89 fa                	mov    %edi,%edx
  801549:	83 c4 1c             	add    $0x1c,%esp
  80154c:	5b                   	pop    %ebx
  80154d:	5e                   	pop    %esi
  80154e:	5f                   	pop    %edi
  80154f:	5d                   	pop    %ebp
  801550:	c3                   	ret    
  801551:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801558:	39 f2                	cmp    %esi,%edx
  80155a:	77 1c                	ja     801578 <__udivdi3+0x88>
  80155c:	0f bd fa             	bsr    %edx,%edi
  80155f:	83 f7 1f             	xor    $0x1f,%edi
  801562:	75 2c                	jne    801590 <__udivdi3+0xa0>
  801564:	39 f2                	cmp    %esi,%edx
  801566:	72 06                	jb     80156e <__udivdi3+0x7e>
  801568:	31 c0                	xor    %eax,%eax
  80156a:	39 eb                	cmp    %ebp,%ebx
  80156c:	77 a9                	ja     801517 <__udivdi3+0x27>
  80156e:	b8 01 00 00 00       	mov    $0x1,%eax
  801573:	eb a2                	jmp    801517 <__udivdi3+0x27>
  801575:	8d 76 00             	lea    0x0(%esi),%esi
  801578:	31 ff                	xor    %edi,%edi
  80157a:	31 c0                	xor    %eax,%eax
  80157c:	89 fa                	mov    %edi,%edx
  80157e:	83 c4 1c             	add    $0x1c,%esp
  801581:	5b                   	pop    %ebx
  801582:	5e                   	pop    %esi
  801583:	5f                   	pop    %edi
  801584:	5d                   	pop    %ebp
  801585:	c3                   	ret    
  801586:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80158d:	8d 76 00             	lea    0x0(%esi),%esi
  801590:	89 f9                	mov    %edi,%ecx
  801592:	b8 20 00 00 00       	mov    $0x20,%eax
  801597:	29 f8                	sub    %edi,%eax
  801599:	d3 e2                	shl    %cl,%edx
  80159b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80159f:	89 c1                	mov    %eax,%ecx
  8015a1:	89 da                	mov    %ebx,%edx
  8015a3:	d3 ea                	shr    %cl,%edx
  8015a5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8015a9:	09 d1                	or     %edx,%ecx
  8015ab:	89 f2                	mov    %esi,%edx
  8015ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8015b1:	89 f9                	mov    %edi,%ecx
  8015b3:	d3 e3                	shl    %cl,%ebx
  8015b5:	89 c1                	mov    %eax,%ecx
  8015b7:	d3 ea                	shr    %cl,%edx
  8015b9:	89 f9                	mov    %edi,%ecx
  8015bb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8015bf:	89 eb                	mov    %ebp,%ebx
  8015c1:	d3 e6                	shl    %cl,%esi
  8015c3:	89 c1                	mov    %eax,%ecx
  8015c5:	d3 eb                	shr    %cl,%ebx
  8015c7:	09 de                	or     %ebx,%esi
  8015c9:	89 f0                	mov    %esi,%eax
  8015cb:	f7 74 24 08          	divl   0x8(%esp)
  8015cf:	89 d6                	mov    %edx,%esi
  8015d1:	89 c3                	mov    %eax,%ebx
  8015d3:	f7 64 24 0c          	mull   0xc(%esp)
  8015d7:	39 d6                	cmp    %edx,%esi
  8015d9:	72 15                	jb     8015f0 <__udivdi3+0x100>
  8015db:	89 f9                	mov    %edi,%ecx
  8015dd:	d3 e5                	shl    %cl,%ebp
  8015df:	39 c5                	cmp    %eax,%ebp
  8015e1:	73 04                	jae    8015e7 <__udivdi3+0xf7>
  8015e3:	39 d6                	cmp    %edx,%esi
  8015e5:	74 09                	je     8015f0 <__udivdi3+0x100>
  8015e7:	89 d8                	mov    %ebx,%eax
  8015e9:	31 ff                	xor    %edi,%edi
  8015eb:	e9 27 ff ff ff       	jmp    801517 <__udivdi3+0x27>
  8015f0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8015f3:	31 ff                	xor    %edi,%edi
  8015f5:	e9 1d ff ff ff       	jmp    801517 <__udivdi3+0x27>
  8015fa:	66 90                	xchg   %ax,%ax
  8015fc:	66 90                	xchg   %ax,%ax
  8015fe:	66 90                	xchg   %ax,%ax

00801600 <__umoddi3>:
  801600:	55                   	push   %ebp
  801601:	57                   	push   %edi
  801602:	56                   	push   %esi
  801603:	53                   	push   %ebx
  801604:	83 ec 1c             	sub    $0x1c,%esp
  801607:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80160b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80160f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801613:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801617:	89 da                	mov    %ebx,%edx
  801619:	85 c0                	test   %eax,%eax
  80161b:	75 43                	jne    801660 <__umoddi3+0x60>
  80161d:	39 df                	cmp    %ebx,%edi
  80161f:	76 17                	jbe    801638 <__umoddi3+0x38>
  801621:	89 f0                	mov    %esi,%eax
  801623:	f7 f7                	div    %edi
  801625:	89 d0                	mov    %edx,%eax
  801627:	31 d2                	xor    %edx,%edx
  801629:	83 c4 1c             	add    $0x1c,%esp
  80162c:	5b                   	pop    %ebx
  80162d:	5e                   	pop    %esi
  80162e:	5f                   	pop    %edi
  80162f:	5d                   	pop    %ebp
  801630:	c3                   	ret    
  801631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801638:	89 fd                	mov    %edi,%ebp
  80163a:	85 ff                	test   %edi,%edi
  80163c:	75 0b                	jne    801649 <__umoddi3+0x49>
  80163e:	b8 01 00 00 00       	mov    $0x1,%eax
  801643:	31 d2                	xor    %edx,%edx
  801645:	f7 f7                	div    %edi
  801647:	89 c5                	mov    %eax,%ebp
  801649:	89 d8                	mov    %ebx,%eax
  80164b:	31 d2                	xor    %edx,%edx
  80164d:	f7 f5                	div    %ebp
  80164f:	89 f0                	mov    %esi,%eax
  801651:	f7 f5                	div    %ebp
  801653:	89 d0                	mov    %edx,%eax
  801655:	eb d0                	jmp    801627 <__umoddi3+0x27>
  801657:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80165e:	66 90                	xchg   %ax,%ax
  801660:	89 f1                	mov    %esi,%ecx
  801662:	39 d8                	cmp    %ebx,%eax
  801664:	76 0a                	jbe    801670 <__umoddi3+0x70>
  801666:	89 f0                	mov    %esi,%eax
  801668:	83 c4 1c             	add    $0x1c,%esp
  80166b:	5b                   	pop    %ebx
  80166c:	5e                   	pop    %esi
  80166d:	5f                   	pop    %edi
  80166e:	5d                   	pop    %ebp
  80166f:	c3                   	ret    
  801670:	0f bd e8             	bsr    %eax,%ebp
  801673:	83 f5 1f             	xor    $0x1f,%ebp
  801676:	75 20                	jne    801698 <__umoddi3+0x98>
  801678:	39 d8                	cmp    %ebx,%eax
  80167a:	0f 82 b0 00 00 00    	jb     801730 <__umoddi3+0x130>
  801680:	39 f7                	cmp    %esi,%edi
  801682:	0f 86 a8 00 00 00    	jbe    801730 <__umoddi3+0x130>
  801688:	89 c8                	mov    %ecx,%eax
  80168a:	83 c4 1c             	add    $0x1c,%esp
  80168d:	5b                   	pop    %ebx
  80168e:	5e                   	pop    %esi
  80168f:	5f                   	pop    %edi
  801690:	5d                   	pop    %ebp
  801691:	c3                   	ret    
  801692:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801698:	89 e9                	mov    %ebp,%ecx
  80169a:	ba 20 00 00 00       	mov    $0x20,%edx
  80169f:	29 ea                	sub    %ebp,%edx
  8016a1:	d3 e0                	shl    %cl,%eax
  8016a3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8016a7:	89 d1                	mov    %edx,%ecx
  8016a9:	89 f8                	mov    %edi,%eax
  8016ab:	d3 e8                	shr    %cl,%eax
  8016ad:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8016b1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8016b5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8016b9:	09 c1                	or     %eax,%ecx
  8016bb:	89 d8                	mov    %ebx,%eax
  8016bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8016c1:	89 e9                	mov    %ebp,%ecx
  8016c3:	d3 e7                	shl    %cl,%edi
  8016c5:	89 d1                	mov    %edx,%ecx
  8016c7:	d3 e8                	shr    %cl,%eax
  8016c9:	89 e9                	mov    %ebp,%ecx
  8016cb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8016cf:	d3 e3                	shl    %cl,%ebx
  8016d1:	89 c7                	mov    %eax,%edi
  8016d3:	89 d1                	mov    %edx,%ecx
  8016d5:	89 f0                	mov    %esi,%eax
  8016d7:	d3 e8                	shr    %cl,%eax
  8016d9:	89 e9                	mov    %ebp,%ecx
  8016db:	89 fa                	mov    %edi,%edx
  8016dd:	d3 e6                	shl    %cl,%esi
  8016df:	09 d8                	or     %ebx,%eax
  8016e1:	f7 74 24 08          	divl   0x8(%esp)
  8016e5:	89 d1                	mov    %edx,%ecx
  8016e7:	89 f3                	mov    %esi,%ebx
  8016e9:	f7 64 24 0c          	mull   0xc(%esp)
  8016ed:	89 c6                	mov    %eax,%esi
  8016ef:	89 d7                	mov    %edx,%edi
  8016f1:	39 d1                	cmp    %edx,%ecx
  8016f3:	72 06                	jb     8016fb <__umoddi3+0xfb>
  8016f5:	75 10                	jne    801707 <__umoddi3+0x107>
  8016f7:	39 c3                	cmp    %eax,%ebx
  8016f9:	73 0c                	jae    801707 <__umoddi3+0x107>
  8016fb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8016ff:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801703:	89 d7                	mov    %edx,%edi
  801705:	89 c6                	mov    %eax,%esi
  801707:	89 ca                	mov    %ecx,%edx
  801709:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80170e:	29 f3                	sub    %esi,%ebx
  801710:	19 fa                	sbb    %edi,%edx
  801712:	89 d0                	mov    %edx,%eax
  801714:	d3 e0                	shl    %cl,%eax
  801716:	89 e9                	mov    %ebp,%ecx
  801718:	d3 eb                	shr    %cl,%ebx
  80171a:	d3 ea                	shr    %cl,%edx
  80171c:	09 d8                	or     %ebx,%eax
  80171e:	83 c4 1c             	add    $0x1c,%esp
  801721:	5b                   	pop    %ebx
  801722:	5e                   	pop    %esi
  801723:	5f                   	pop    %edi
  801724:	5d                   	pop    %ebp
  801725:	c3                   	ret    
  801726:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80172d:	8d 76 00             	lea    0x0(%esi),%esi
  801730:	89 da                	mov    %ebx,%edx
  801732:	29 fe                	sub    %edi,%esi
  801734:	19 c2                	sbb    %eax,%edx
  801736:	89 f1                	mov    %esi,%ecx
  801738:	89 c8                	mov    %ecx,%eax
  80173a:	e9 4b ff ff ff       	jmp    80168a <__umoddi3+0x8a>
