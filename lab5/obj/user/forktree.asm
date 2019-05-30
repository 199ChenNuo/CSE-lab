
obj/user/forktree.debug:     file format elf32-i386


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
  80002c:	e8 b2 00 00 00       	call   8000e3 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <forktree>:
	}
}

void
forktree(const char *cur)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 04             	sub    $0x4,%esp
  80003a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("%04x: I am '%s'\n", sys_getenvid(), cur);
  80003d:	e8 6b 0c 00 00       	call   800cad <sys_getenvid>
  800042:	83 ec 04             	sub    $0x4,%esp
  800045:	53                   	push   %ebx
  800046:	50                   	push   %eax
  800047:	68 60 16 80 00       	push   $0x801660
  80004c:	e8 82 01 00 00       	call   8001d3 <cprintf>

	forkchild(cur, '0');
  800051:	83 c4 08             	add    $0x8,%esp
  800054:	6a 30                	push   $0x30
  800056:	53                   	push   %ebx
  800057:	e8 13 00 00 00       	call   80006f <forkchild>
	forkchild(cur, '1');
  80005c:	83 c4 08             	add    $0x8,%esp
  80005f:	6a 31                	push   $0x31
  800061:	53                   	push   %ebx
  800062:	e8 08 00 00 00       	call   80006f <forkchild>
}
  800067:	83 c4 10             	add    $0x10,%esp
  80006a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80006d:	c9                   	leave  
  80006e:	c3                   	ret    

0080006f <forkchild>:
{
  80006f:	55                   	push   %ebp
  800070:	89 e5                	mov    %esp,%ebp
  800072:	56                   	push   %esi
  800073:	53                   	push   %ebx
  800074:	83 ec 1c             	sub    $0x1c,%esp
  800077:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80007a:	8b 75 0c             	mov    0xc(%ebp),%esi
	if (strlen(cur) >= DEPTH)
  80007d:	53                   	push   %ebx
  80007e:	e8 3d 08 00 00       	call   8008c0 <strlen>
  800083:	83 c4 10             	add    $0x10,%esp
  800086:	83 f8 02             	cmp    $0x2,%eax
  800089:	7e 07                	jle    800092 <forkchild+0x23>
}
  80008b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80008e:	5b                   	pop    %ebx
  80008f:	5e                   	pop    %esi
  800090:	5d                   	pop    %ebp
  800091:	c3                   	ret    
	snprintf(nxt, DEPTH+1, "%s%c", cur, branch);
  800092:	83 ec 0c             	sub    $0xc,%esp
  800095:	89 f0                	mov    %esi,%eax
  800097:	0f be f0             	movsbl %al,%esi
  80009a:	56                   	push   %esi
  80009b:	53                   	push   %ebx
  80009c:	68 71 16 80 00       	push   $0x801671
  8000a1:	6a 04                	push   $0x4
  8000a3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000a6:	50                   	push   %eax
  8000a7:	e8 fa 07 00 00       	call   8008a6 <snprintf>
	if (fork() == 0) {
  8000ac:	83 c4 20             	add    $0x20,%esp
  8000af:	e8 65 0f 00 00       	call   801019 <fork>
  8000b4:	85 c0                	test   %eax,%eax
  8000b6:	75 d3                	jne    80008b <forkchild+0x1c>
		forktree(nxt);
  8000b8:	83 ec 0c             	sub    $0xc,%esp
  8000bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000be:	50                   	push   %eax
  8000bf:	e8 6f ff ff ff       	call   800033 <forktree>
		exit();
  8000c4:	e8 63 00 00 00       	call   80012c <exit>
  8000c9:	83 c4 10             	add    $0x10,%esp
  8000cc:	eb bd                	jmp    80008b <forkchild+0x1c>

008000ce <umain>:

void
umain(int argc, char **argv)
{
  8000ce:	55                   	push   %ebp
  8000cf:	89 e5                	mov    %esp,%ebp
  8000d1:	83 ec 14             	sub    $0x14,%esp
	forktree("");
  8000d4:	68 70 16 80 00       	push   $0x801670
  8000d9:	e8 55 ff ff ff       	call   800033 <forktree>
}
  8000de:	83 c4 10             	add    $0x10,%esp
  8000e1:	c9                   	leave  
  8000e2:	c3                   	ret    

008000e3 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000e3:	55                   	push   %ebp
  8000e4:	89 e5                	mov    %esp,%ebp
  8000e6:	56                   	push   %esi
  8000e7:	53                   	push   %ebx
  8000e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000eb:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	// thisenv = 0;
	thisenv = &(envs[ENVX(sys_getenvid())]);
  8000ee:	e8 ba 0b 00 00       	call   800cad <sys_getenvid>
  8000f3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000f8:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8000fe:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800103:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800108:	85 db                	test   %ebx,%ebx
  80010a:	7e 07                	jle    800113 <libmain+0x30>
		binaryname = argv[0];
  80010c:	8b 06                	mov    (%esi),%eax
  80010e:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800113:	83 ec 08             	sub    $0x8,%esp
  800116:	56                   	push   %esi
  800117:	53                   	push   %ebx
  800118:	e8 b1 ff ff ff       	call   8000ce <umain>

	// exit gracefully
	exit();
  80011d:	e8 0a 00 00 00       	call   80012c <exit>
}
  800122:	83 c4 10             	add    $0x10,%esp
  800125:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800128:	5b                   	pop    %ebx
  800129:	5e                   	pop    %esi
  80012a:	5d                   	pop    %ebp
  80012b:	c3                   	ret    

0080012c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80012c:	55                   	push   %ebp
  80012d:	89 e5                	mov    %esp,%ebp
  80012f:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  800132:	6a 00                	push   $0x0
  800134:	e8 33 0b 00 00       	call   800c6c <sys_env_destroy>
}
  800139:	83 c4 10             	add    $0x10,%esp
  80013c:	c9                   	leave  
  80013d:	c3                   	ret    

0080013e <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80013e:	55                   	push   %ebp
  80013f:	89 e5                	mov    %esp,%ebp
  800141:	53                   	push   %ebx
  800142:	83 ec 04             	sub    $0x4,%esp
  800145:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800148:	8b 13                	mov    (%ebx),%edx
  80014a:	8d 42 01             	lea    0x1(%edx),%eax
  80014d:	89 03                	mov    %eax,(%ebx)
  80014f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800152:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800156:	3d ff 00 00 00       	cmp    $0xff,%eax
  80015b:	74 09                	je     800166 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80015d:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800161:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800164:	c9                   	leave  
  800165:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800166:	83 ec 08             	sub    $0x8,%esp
  800169:	68 ff 00 00 00       	push   $0xff
  80016e:	8d 43 08             	lea    0x8(%ebx),%eax
  800171:	50                   	push   %eax
  800172:	e8 b8 0a 00 00       	call   800c2f <sys_cputs>
		b->idx = 0;
  800177:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80017d:	83 c4 10             	add    $0x10,%esp
  800180:	eb db                	jmp    80015d <putch+0x1f>

00800182 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800182:	55                   	push   %ebp
  800183:	89 e5                	mov    %esp,%ebp
  800185:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80018b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800192:	00 00 00 
	b.cnt = 0;
  800195:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80019c:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80019f:	ff 75 0c             	pushl  0xc(%ebp)
  8001a2:	ff 75 08             	pushl  0x8(%ebp)
  8001a5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001ab:	50                   	push   %eax
  8001ac:	68 3e 01 80 00       	push   $0x80013e
  8001b1:	e8 4a 01 00 00       	call   800300 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001b6:	83 c4 08             	add    $0x8,%esp
  8001b9:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001bf:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001c5:	50                   	push   %eax
  8001c6:	e8 64 0a 00 00       	call   800c2f <sys_cputs>

	return b.cnt;
}
  8001cb:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001d1:	c9                   	leave  
  8001d2:	c3                   	ret    

008001d3 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001d3:	55                   	push   %ebp
  8001d4:	89 e5                	mov    %esp,%ebp
  8001d6:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001d9:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001dc:	50                   	push   %eax
  8001dd:	ff 75 08             	pushl  0x8(%ebp)
  8001e0:	e8 9d ff ff ff       	call   800182 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001e5:	c9                   	leave  
  8001e6:	c3                   	ret    

008001e7 <printnum>:


static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001e7:	55                   	push   %ebp
  8001e8:	89 e5                	mov    %esp,%ebp
  8001ea:	57                   	push   %edi
  8001eb:	56                   	push   %esi
  8001ec:	53                   	push   %ebx
  8001ed:	83 ec 1c             	sub    $0x1c,%esp
  8001f0:	89 c6                	mov    %eax,%esi
  8001f2:	89 d7                	mov    %edx,%edi
  8001f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8001f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001fa:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001fd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800200:	8b 45 10             	mov    0x10(%ebp),%eax
  800203:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	// to support '-'
	if(padc == '-'){
  800206:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80020a:	74 2c                	je     800238 <printnum+0x51>
		while (--width > 0)
			putch(' ', putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80020c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80020f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800216:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800219:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80021c:	39 c2                	cmp    %eax,%edx
  80021e:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800221:	73 43                	jae    800266 <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800223:	83 eb 01             	sub    $0x1,%ebx
  800226:	85 db                	test   %ebx,%ebx
  800228:	7e 6c                	jle    800296 <printnum+0xaf>
			putch(padc, putdat);
  80022a:	83 ec 08             	sub    $0x8,%esp
  80022d:	57                   	push   %edi
  80022e:	ff 75 18             	pushl  0x18(%ebp)
  800231:	ff d6                	call   *%esi
  800233:	83 c4 10             	add    $0x10,%esp
  800236:	eb eb                	jmp    800223 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800238:	83 ec 0c             	sub    $0xc,%esp
  80023b:	6a 20                	push   $0x20
  80023d:	6a 00                	push   $0x0
  80023f:	50                   	push   %eax
  800240:	ff 75 e4             	pushl  -0x1c(%ebp)
  800243:	ff 75 e0             	pushl  -0x20(%ebp)
  800246:	89 fa                	mov    %edi,%edx
  800248:	89 f0                	mov    %esi,%eax
  80024a:	e8 98 ff ff ff       	call   8001e7 <printnum>
		while (--width > 0)
  80024f:	83 c4 20             	add    $0x20,%esp
  800252:	83 eb 01             	sub    $0x1,%ebx
  800255:	85 db                	test   %ebx,%ebx
  800257:	7e 65                	jle    8002be <printnum+0xd7>
			putch(' ', putdat);
  800259:	83 ec 08             	sub    $0x8,%esp
  80025c:	57                   	push   %edi
  80025d:	6a 20                	push   $0x20
  80025f:	ff d6                	call   *%esi
  800261:	83 c4 10             	add    $0x10,%esp
  800264:	eb ec                	jmp    800252 <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800266:	83 ec 0c             	sub    $0xc,%esp
  800269:	ff 75 18             	pushl  0x18(%ebp)
  80026c:	83 eb 01             	sub    $0x1,%ebx
  80026f:	53                   	push   %ebx
  800270:	50                   	push   %eax
  800271:	83 ec 08             	sub    $0x8,%esp
  800274:	ff 75 dc             	pushl  -0x24(%ebp)
  800277:	ff 75 d8             	pushl  -0x28(%ebp)
  80027a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80027d:	ff 75 e0             	pushl  -0x20(%ebp)
  800280:	e8 8b 11 00 00       	call   801410 <__udivdi3>
  800285:	83 c4 18             	add    $0x18,%esp
  800288:	52                   	push   %edx
  800289:	50                   	push   %eax
  80028a:	89 fa                	mov    %edi,%edx
  80028c:	89 f0                	mov    %esi,%eax
  80028e:	e8 54 ff ff ff       	call   8001e7 <printnum>
  800293:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800296:	83 ec 08             	sub    $0x8,%esp
  800299:	57                   	push   %edi
  80029a:	83 ec 04             	sub    $0x4,%esp
  80029d:	ff 75 dc             	pushl  -0x24(%ebp)
  8002a0:	ff 75 d8             	pushl  -0x28(%ebp)
  8002a3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002a6:	ff 75 e0             	pushl  -0x20(%ebp)
  8002a9:	e8 72 12 00 00       	call   801520 <__umoddi3>
  8002ae:	83 c4 14             	add    $0x14,%esp
  8002b1:	0f be 80 80 16 80 00 	movsbl 0x801680(%eax),%eax
  8002b8:	50                   	push   %eax
  8002b9:	ff d6                	call   *%esi
  8002bb:	83 c4 10             	add    $0x10,%esp
}
  8002be:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002c1:	5b                   	pop    %ebx
  8002c2:	5e                   	pop    %esi
  8002c3:	5f                   	pop    %edi
  8002c4:	5d                   	pop    %ebp
  8002c5:	c3                   	ret    

008002c6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002c6:	55                   	push   %ebp
  8002c7:	89 e5                	mov    %esp,%ebp
  8002c9:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002cc:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002d0:	8b 10                	mov    (%eax),%edx
  8002d2:	3b 50 04             	cmp    0x4(%eax),%edx
  8002d5:	73 0a                	jae    8002e1 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002d7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002da:	89 08                	mov    %ecx,(%eax)
  8002dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8002df:	88 02                	mov    %al,(%edx)
}
  8002e1:	5d                   	pop    %ebp
  8002e2:	c3                   	ret    

008002e3 <printfmt>:
{
  8002e3:	55                   	push   %ebp
  8002e4:	89 e5                	mov    %esp,%ebp
  8002e6:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002e9:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002ec:	50                   	push   %eax
  8002ed:	ff 75 10             	pushl  0x10(%ebp)
  8002f0:	ff 75 0c             	pushl  0xc(%ebp)
  8002f3:	ff 75 08             	pushl  0x8(%ebp)
  8002f6:	e8 05 00 00 00       	call   800300 <vprintfmt>
}
  8002fb:	83 c4 10             	add    $0x10,%esp
  8002fe:	c9                   	leave  
  8002ff:	c3                   	ret    

00800300 <vprintfmt>:
{
  800300:	55                   	push   %ebp
  800301:	89 e5                	mov    %esp,%ebp
  800303:	57                   	push   %edi
  800304:	56                   	push   %esi
  800305:	53                   	push   %ebx
  800306:	83 ec 3c             	sub    $0x3c,%esp
  800309:	8b 75 08             	mov    0x8(%ebp),%esi
  80030c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80030f:	8b 7d 10             	mov    0x10(%ebp),%edi
  800312:	e9 1e 04 00 00       	jmp    800735 <vprintfmt+0x435>
		posflag = 0;
  800317:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
		padc = ' ';
  80031e:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800322:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800329:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800330:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800337:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  80033e:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800343:	8d 47 01             	lea    0x1(%edi),%eax
  800346:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800349:	0f b6 17             	movzbl (%edi),%edx
  80034c:	8d 42 dd             	lea    -0x23(%edx),%eax
  80034f:	3c 55                	cmp    $0x55,%al
  800351:	0f 87 d9 04 00 00    	ja     800830 <vprintfmt+0x530>
  800357:	0f b6 c0             	movzbl %al,%eax
  80035a:	ff 24 85 60 18 80 00 	jmp    *0x801860(,%eax,4)
  800361:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800364:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800368:	eb d9                	jmp    800343 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80036a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posflag = 1;
  80036d:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  800374:	eb cd                	jmp    800343 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800376:	0f b6 d2             	movzbl %dl,%edx
  800379:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80037c:	b8 00 00 00 00       	mov    $0x0,%eax
  800381:	89 75 08             	mov    %esi,0x8(%ebp)
  800384:	eb 0c                	jmp    800392 <vprintfmt+0x92>
		switch (ch = *(unsigned char *) fmt++) {
  800386:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800389:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  80038d:	eb b4                	jmp    800343 <vprintfmt+0x43>
			for (precision = 0; ; ++fmt) {
  80038f:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800392:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800395:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800399:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80039c:	8d 72 d0             	lea    -0x30(%edx),%esi
  80039f:	83 fe 09             	cmp    $0x9,%esi
  8003a2:	76 eb                	jbe    80038f <vprintfmt+0x8f>
  8003a4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003a7:	8b 75 08             	mov    0x8(%ebp),%esi
  8003aa:	eb 14                	jmp    8003c0 <vprintfmt+0xc0>
			precision = va_arg(ap, int);
  8003ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8003af:	8b 00                	mov    (%eax),%eax
  8003b1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b7:	8d 40 04             	lea    0x4(%eax),%eax
  8003ba:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003bd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003c0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003c4:	0f 89 79 ff ff ff    	jns    800343 <vprintfmt+0x43>
				width = precision, precision = -1;
  8003ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003cd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003d0:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003d7:	e9 67 ff ff ff       	jmp    800343 <vprintfmt+0x43>
  8003dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003df:	85 c0                	test   %eax,%eax
  8003e1:	0f 48 c1             	cmovs  %ecx,%eax
  8003e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003e7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003ea:	e9 54 ff ff ff       	jmp    800343 <vprintfmt+0x43>
  8003ef:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003f2:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8003f9:	e9 45 ff ff ff       	jmp    800343 <vprintfmt+0x43>
			lflag++;
  8003fe:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800402:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800405:	e9 39 ff ff ff       	jmp    800343 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  80040a:	8b 45 14             	mov    0x14(%ebp),%eax
  80040d:	8d 78 04             	lea    0x4(%eax),%edi
  800410:	83 ec 08             	sub    $0x8,%esp
  800413:	53                   	push   %ebx
  800414:	ff 30                	pushl  (%eax)
  800416:	ff d6                	call   *%esi
			break;
  800418:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80041b:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80041e:	e9 0f 03 00 00       	jmp    800732 <vprintfmt+0x432>
			err = va_arg(ap, int);
  800423:	8b 45 14             	mov    0x14(%ebp),%eax
  800426:	8d 78 04             	lea    0x4(%eax),%edi
  800429:	8b 00                	mov    (%eax),%eax
  80042b:	99                   	cltd   
  80042c:	31 d0                	xor    %edx,%eax
  80042e:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800430:	83 f8 0f             	cmp    $0xf,%eax
  800433:	7f 23                	jg     800458 <vprintfmt+0x158>
  800435:	8b 14 85 c0 19 80 00 	mov    0x8019c0(,%eax,4),%edx
  80043c:	85 d2                	test   %edx,%edx
  80043e:	74 18                	je     800458 <vprintfmt+0x158>
				printfmt(putch, putdat, "%s", p);
  800440:	52                   	push   %edx
  800441:	68 a1 16 80 00       	push   $0x8016a1
  800446:	53                   	push   %ebx
  800447:	56                   	push   %esi
  800448:	e8 96 fe ff ff       	call   8002e3 <printfmt>
  80044d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800450:	89 7d 14             	mov    %edi,0x14(%ebp)
  800453:	e9 da 02 00 00       	jmp    800732 <vprintfmt+0x432>
				printfmt(putch, putdat, "error %d", err);
  800458:	50                   	push   %eax
  800459:	68 98 16 80 00       	push   $0x801698
  80045e:	53                   	push   %ebx
  80045f:	56                   	push   %esi
  800460:	e8 7e fe ff ff       	call   8002e3 <printfmt>
  800465:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800468:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80046b:	e9 c2 02 00 00       	jmp    800732 <vprintfmt+0x432>
			if ((p = va_arg(ap, char *)) == NULL)
  800470:	8b 45 14             	mov    0x14(%ebp),%eax
  800473:	83 c0 04             	add    $0x4,%eax
  800476:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800479:	8b 45 14             	mov    0x14(%ebp),%eax
  80047c:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80047e:	85 c9                	test   %ecx,%ecx
  800480:	b8 91 16 80 00       	mov    $0x801691,%eax
  800485:	0f 45 c1             	cmovne %ecx,%eax
  800488:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80048b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80048f:	7e 06                	jle    800497 <vprintfmt+0x197>
  800491:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800495:	75 0d                	jne    8004a4 <vprintfmt+0x1a4>
				for (width -= strnlen(p, precision); width > 0; width--)
  800497:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80049a:	89 c7                	mov    %eax,%edi
  80049c:	03 45 e0             	add    -0x20(%ebp),%eax
  80049f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004a2:	eb 53                	jmp    8004f7 <vprintfmt+0x1f7>
  8004a4:	83 ec 08             	sub    $0x8,%esp
  8004a7:	ff 75 d8             	pushl  -0x28(%ebp)
  8004aa:	50                   	push   %eax
  8004ab:	e8 28 04 00 00       	call   8008d8 <strnlen>
  8004b0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004b3:	29 c1                	sub    %eax,%ecx
  8004b5:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  8004b8:	83 c4 10             	add    $0x10,%esp
  8004bb:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8004bd:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8004c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004c4:	eb 0f                	jmp    8004d5 <vprintfmt+0x1d5>
					putch(padc, putdat);
  8004c6:	83 ec 08             	sub    $0x8,%esp
  8004c9:	53                   	push   %ebx
  8004ca:	ff 75 e0             	pushl  -0x20(%ebp)
  8004cd:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004cf:	83 ef 01             	sub    $0x1,%edi
  8004d2:	83 c4 10             	add    $0x10,%esp
  8004d5:	85 ff                	test   %edi,%edi
  8004d7:	7f ed                	jg     8004c6 <vprintfmt+0x1c6>
  8004d9:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  8004dc:	85 c9                	test   %ecx,%ecx
  8004de:	b8 00 00 00 00       	mov    $0x0,%eax
  8004e3:	0f 49 c1             	cmovns %ecx,%eax
  8004e6:	29 c1                	sub    %eax,%ecx
  8004e8:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8004eb:	eb aa                	jmp    800497 <vprintfmt+0x197>
					putch(ch, putdat);
  8004ed:	83 ec 08             	sub    $0x8,%esp
  8004f0:	53                   	push   %ebx
  8004f1:	52                   	push   %edx
  8004f2:	ff d6                	call   *%esi
  8004f4:	83 c4 10             	add    $0x10,%esp
  8004f7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004fa:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004fc:	83 c7 01             	add    $0x1,%edi
  8004ff:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800503:	0f be d0             	movsbl %al,%edx
  800506:	85 d2                	test   %edx,%edx
  800508:	74 4b                	je     800555 <vprintfmt+0x255>
  80050a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80050e:	78 06                	js     800516 <vprintfmt+0x216>
  800510:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800514:	78 1e                	js     800534 <vprintfmt+0x234>
				if (altflag && (ch < ' ' || ch > '~'))
  800516:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80051a:	74 d1                	je     8004ed <vprintfmt+0x1ed>
  80051c:	0f be c0             	movsbl %al,%eax
  80051f:	83 e8 20             	sub    $0x20,%eax
  800522:	83 f8 5e             	cmp    $0x5e,%eax
  800525:	76 c6                	jbe    8004ed <vprintfmt+0x1ed>
					putch('?', putdat);
  800527:	83 ec 08             	sub    $0x8,%esp
  80052a:	53                   	push   %ebx
  80052b:	6a 3f                	push   $0x3f
  80052d:	ff d6                	call   *%esi
  80052f:	83 c4 10             	add    $0x10,%esp
  800532:	eb c3                	jmp    8004f7 <vprintfmt+0x1f7>
  800534:	89 cf                	mov    %ecx,%edi
  800536:	eb 0e                	jmp    800546 <vprintfmt+0x246>
				putch(' ', putdat);
  800538:	83 ec 08             	sub    $0x8,%esp
  80053b:	53                   	push   %ebx
  80053c:	6a 20                	push   $0x20
  80053e:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800540:	83 ef 01             	sub    $0x1,%edi
  800543:	83 c4 10             	add    $0x10,%esp
  800546:	85 ff                	test   %edi,%edi
  800548:	7f ee                	jg     800538 <vprintfmt+0x238>
			if ((p = va_arg(ap, char *)) == NULL)
  80054a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80054d:	89 45 14             	mov    %eax,0x14(%ebp)
  800550:	e9 dd 01 00 00       	jmp    800732 <vprintfmt+0x432>
  800555:	89 cf                	mov    %ecx,%edi
  800557:	eb ed                	jmp    800546 <vprintfmt+0x246>
	if (lflag >= 2)
  800559:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  80055d:	7f 21                	jg     800580 <vprintfmt+0x280>
	else if (lflag)
  80055f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800563:	74 6a                	je     8005cf <vprintfmt+0x2cf>
		return va_arg(*ap, long);
  800565:	8b 45 14             	mov    0x14(%ebp),%eax
  800568:	8b 00                	mov    (%eax),%eax
  80056a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80056d:	89 c1                	mov    %eax,%ecx
  80056f:	c1 f9 1f             	sar    $0x1f,%ecx
  800572:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800575:	8b 45 14             	mov    0x14(%ebp),%eax
  800578:	8d 40 04             	lea    0x4(%eax),%eax
  80057b:	89 45 14             	mov    %eax,0x14(%ebp)
  80057e:	eb 17                	jmp    800597 <vprintfmt+0x297>
		return va_arg(*ap, long long);
  800580:	8b 45 14             	mov    0x14(%ebp),%eax
  800583:	8b 50 04             	mov    0x4(%eax),%edx
  800586:	8b 00                	mov    (%eax),%eax
  800588:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80058b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80058e:	8b 45 14             	mov    0x14(%ebp),%eax
  800591:	8d 40 08             	lea    0x8(%eax),%eax
  800594:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800597:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  80059a:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  80059f:	85 d2                	test   %edx,%edx
  8005a1:	0f 89 5c 01 00 00    	jns    800703 <vprintfmt+0x403>
				putch('-', putdat);
  8005a7:	83 ec 08             	sub    $0x8,%esp
  8005aa:	53                   	push   %ebx
  8005ab:	6a 2d                	push   $0x2d
  8005ad:	ff d6                	call   *%esi
				num = -(long long) num;
  8005af:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005b2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8005b5:	f7 d8                	neg    %eax
  8005b7:	83 d2 00             	adc    $0x0,%edx
  8005ba:	f7 da                	neg    %edx
  8005bc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005bf:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005c2:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005c5:	bf 0a 00 00 00       	mov    $0xa,%edi
  8005ca:	e9 45 01 00 00       	jmp    800714 <vprintfmt+0x414>
		return va_arg(*ap, int);
  8005cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d2:	8b 00                	mov    (%eax),%eax
  8005d4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005d7:	89 c1                	mov    %eax,%ecx
  8005d9:	c1 f9 1f             	sar    $0x1f,%ecx
  8005dc:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005df:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e2:	8d 40 04             	lea    0x4(%eax),%eax
  8005e5:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e8:	eb ad                	jmp    800597 <vprintfmt+0x297>
	if (lflag >= 2)
  8005ea:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8005ee:	7f 29                	jg     800619 <vprintfmt+0x319>
	else if (lflag)
  8005f0:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8005f4:	74 44                	je     80063a <vprintfmt+0x33a>
		return va_arg(*ap, unsigned long);
  8005f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f9:	8b 00                	mov    (%eax),%eax
  8005fb:	ba 00 00 00 00       	mov    $0x0,%edx
  800600:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800603:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800606:	8b 45 14             	mov    0x14(%ebp),%eax
  800609:	8d 40 04             	lea    0x4(%eax),%eax
  80060c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80060f:	bf 0a 00 00 00       	mov    $0xa,%edi
  800614:	e9 ea 00 00 00       	jmp    800703 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  800619:	8b 45 14             	mov    0x14(%ebp),%eax
  80061c:	8b 50 04             	mov    0x4(%eax),%edx
  80061f:	8b 00                	mov    (%eax),%eax
  800621:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800624:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800627:	8b 45 14             	mov    0x14(%ebp),%eax
  80062a:	8d 40 08             	lea    0x8(%eax),%eax
  80062d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800630:	bf 0a 00 00 00       	mov    $0xa,%edi
  800635:	e9 c9 00 00 00       	jmp    800703 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  80063a:	8b 45 14             	mov    0x14(%ebp),%eax
  80063d:	8b 00                	mov    (%eax),%eax
  80063f:	ba 00 00 00 00       	mov    $0x0,%edx
  800644:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800647:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80064a:	8b 45 14             	mov    0x14(%ebp),%eax
  80064d:	8d 40 04             	lea    0x4(%eax),%eax
  800650:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800653:	bf 0a 00 00 00       	mov    $0xa,%edi
  800658:	e9 a6 00 00 00       	jmp    800703 <vprintfmt+0x403>
			putch('0', putdat);
  80065d:	83 ec 08             	sub    $0x8,%esp
  800660:	53                   	push   %ebx
  800661:	6a 30                	push   $0x30
  800663:	ff d6                	call   *%esi
	if (lflag >= 2)
  800665:	83 c4 10             	add    $0x10,%esp
  800668:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  80066c:	7f 26                	jg     800694 <vprintfmt+0x394>
	else if (lflag)
  80066e:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800672:	74 3e                	je     8006b2 <vprintfmt+0x3b2>
		return va_arg(*ap, unsigned long);
  800674:	8b 45 14             	mov    0x14(%ebp),%eax
  800677:	8b 00                	mov    (%eax),%eax
  800679:	ba 00 00 00 00       	mov    $0x0,%edx
  80067e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800681:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800684:	8b 45 14             	mov    0x14(%ebp),%eax
  800687:	8d 40 04             	lea    0x4(%eax),%eax
  80068a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80068d:	bf 08 00 00 00       	mov    $0x8,%edi
  800692:	eb 6f                	jmp    800703 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  800694:	8b 45 14             	mov    0x14(%ebp),%eax
  800697:	8b 50 04             	mov    0x4(%eax),%edx
  80069a:	8b 00                	mov    (%eax),%eax
  80069c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80069f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a5:	8d 40 08             	lea    0x8(%eax),%eax
  8006a8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006ab:	bf 08 00 00 00       	mov    $0x8,%edi
  8006b0:	eb 51                	jmp    800703 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  8006b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b5:	8b 00                	mov    (%eax),%eax
  8006b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8006bc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006bf:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c5:	8d 40 04             	lea    0x4(%eax),%eax
  8006c8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006cb:	bf 08 00 00 00       	mov    $0x8,%edi
  8006d0:	eb 31                	jmp    800703 <vprintfmt+0x403>
			putch('0', putdat);
  8006d2:	83 ec 08             	sub    $0x8,%esp
  8006d5:	53                   	push   %ebx
  8006d6:	6a 30                	push   $0x30
  8006d8:	ff d6                	call   *%esi
			putch('x', putdat);
  8006da:	83 c4 08             	add    $0x8,%esp
  8006dd:	53                   	push   %ebx
  8006de:	6a 78                	push   $0x78
  8006e0:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e5:	8b 00                	mov    (%eax),%eax
  8006e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ec:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ef:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8006f2:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f8:	8d 40 04             	lea    0x4(%eax),%eax
  8006fb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006fe:	bf 10 00 00 00       	mov    $0x10,%edi
			if(posflag)
  800703:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800707:	74 0b                	je     800714 <vprintfmt+0x414>
				putch('+', putdat);
  800709:	83 ec 08             	sub    $0x8,%esp
  80070c:	53                   	push   %ebx
  80070d:	6a 2b                	push   $0x2b
  80070f:	ff d6                	call   *%esi
  800711:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  800714:	83 ec 0c             	sub    $0xc,%esp
  800717:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80071b:	50                   	push   %eax
  80071c:	ff 75 e0             	pushl  -0x20(%ebp)
  80071f:	57                   	push   %edi
  800720:	ff 75 dc             	pushl  -0x24(%ebp)
  800723:	ff 75 d8             	pushl  -0x28(%ebp)
  800726:	89 da                	mov    %ebx,%edx
  800728:	89 f0                	mov    %esi,%eax
  80072a:	e8 b8 fa ff ff       	call   8001e7 <printnum>
			break;
  80072f:	83 c4 20             	add    $0x20,%esp
			char* cp = va_arg(ap, char *);
  800732:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800735:	83 c7 01             	add    $0x1,%edi
  800738:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80073c:	83 f8 25             	cmp    $0x25,%eax
  80073f:	0f 84 d2 fb ff ff    	je     800317 <vprintfmt+0x17>
			if (ch == '\0')
  800745:	85 c0                	test   %eax,%eax
  800747:	0f 84 03 01 00 00    	je     800850 <vprintfmt+0x550>
			putch(ch, putdat);
  80074d:	83 ec 08             	sub    $0x8,%esp
  800750:	53                   	push   %ebx
  800751:	50                   	push   %eax
  800752:	ff d6                	call   *%esi
  800754:	83 c4 10             	add    $0x10,%esp
  800757:	eb dc                	jmp    800735 <vprintfmt+0x435>
	if (lflag >= 2)
  800759:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  80075d:	7f 29                	jg     800788 <vprintfmt+0x488>
	else if (lflag)
  80075f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800763:	74 44                	je     8007a9 <vprintfmt+0x4a9>
		return va_arg(*ap, unsigned long);
  800765:	8b 45 14             	mov    0x14(%ebp),%eax
  800768:	8b 00                	mov    (%eax),%eax
  80076a:	ba 00 00 00 00       	mov    $0x0,%edx
  80076f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800772:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800775:	8b 45 14             	mov    0x14(%ebp),%eax
  800778:	8d 40 04             	lea    0x4(%eax),%eax
  80077b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80077e:	bf 10 00 00 00       	mov    $0x10,%edi
  800783:	e9 7b ff ff ff       	jmp    800703 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  800788:	8b 45 14             	mov    0x14(%ebp),%eax
  80078b:	8b 50 04             	mov    0x4(%eax),%edx
  80078e:	8b 00                	mov    (%eax),%eax
  800790:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800793:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800796:	8b 45 14             	mov    0x14(%ebp),%eax
  800799:	8d 40 08             	lea    0x8(%eax),%eax
  80079c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80079f:	bf 10 00 00 00       	mov    $0x10,%edi
  8007a4:	e9 5a ff ff ff       	jmp    800703 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  8007a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ac:	8b 00                	mov    (%eax),%eax
  8007ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8007b3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007b6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bc:	8d 40 04             	lea    0x4(%eax),%eax
  8007bf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007c2:	bf 10 00 00 00       	mov    $0x10,%edi
  8007c7:	e9 37 ff ff ff       	jmp    800703 <vprintfmt+0x403>
			char* cp = va_arg(ap, char *);
  8007cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cf:	8d 78 04             	lea    0x4(%eax),%edi
  8007d2:	8b 00                	mov    (%eax),%eax
    			if (cp == NULL) {
  8007d4:	85 c0                	test   %eax,%eax
  8007d6:	74 2c                	je     800804 <vprintfmt+0x504>
    			*cp = *(int *)putdat;
  8007d8:	8b 13                	mov    (%ebx),%edx
  8007da:	88 10                	mov    %dl,(%eax)
			char* cp = va_arg(ap, char *);
  8007dc:	89 7d 14             	mov    %edi,0x14(%ebp)
    			if ((*(int *) putdat) > 127)
  8007df:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  8007e2:	0f 8e 4a ff ff ff    	jle    800732 <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", overflow_error);
  8007e8:	68 f0 17 80 00       	push   $0x8017f0
  8007ed:	68 a1 16 80 00       	push   $0x8016a1
  8007f2:	53                   	push   %ebx
  8007f3:	56                   	push   %esi
  8007f4:	e8 ea fa ff ff       	call   8002e3 <printfmt>
  8007f9:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  8007fc:	89 7d 14             	mov    %edi,0x14(%ebp)
  8007ff:	e9 2e ff ff ff       	jmp    800732 <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", null_error);
  800804:	68 b8 17 80 00       	push   $0x8017b8
  800809:	68 a1 16 80 00       	push   $0x8016a1
  80080e:	53                   	push   %ebx
  80080f:	56                   	push   %esi
  800810:	e8 ce fa ff ff       	call   8002e3 <printfmt>
        		break;
  800815:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  800818:	89 7d 14             	mov    %edi,0x14(%ebp)
        		break;
  80081b:	e9 12 ff ff ff       	jmp    800732 <vprintfmt+0x432>
			putch(ch, putdat);
  800820:	83 ec 08             	sub    $0x8,%esp
  800823:	53                   	push   %ebx
  800824:	6a 25                	push   $0x25
  800826:	ff d6                	call   *%esi
			break;
  800828:	83 c4 10             	add    $0x10,%esp
  80082b:	e9 02 ff ff ff       	jmp    800732 <vprintfmt+0x432>
			putch('%', putdat);
  800830:	83 ec 08             	sub    $0x8,%esp
  800833:	53                   	push   %ebx
  800834:	6a 25                	push   $0x25
  800836:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800838:	83 c4 10             	add    $0x10,%esp
  80083b:	89 f8                	mov    %edi,%eax
  80083d:	eb 03                	jmp    800842 <vprintfmt+0x542>
  80083f:	83 e8 01             	sub    $0x1,%eax
  800842:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800846:	75 f7                	jne    80083f <vprintfmt+0x53f>
  800848:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80084b:	e9 e2 fe ff ff       	jmp    800732 <vprintfmt+0x432>
}
  800850:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800853:	5b                   	pop    %ebx
  800854:	5e                   	pop    %esi
  800855:	5f                   	pop    %edi
  800856:	5d                   	pop    %ebp
  800857:	c3                   	ret    

00800858 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800858:	55                   	push   %ebp
  800859:	89 e5                	mov    %esp,%ebp
  80085b:	83 ec 18             	sub    $0x18,%esp
  80085e:	8b 45 08             	mov    0x8(%ebp),%eax
  800861:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800864:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800867:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80086b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80086e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800875:	85 c0                	test   %eax,%eax
  800877:	74 26                	je     80089f <vsnprintf+0x47>
  800879:	85 d2                	test   %edx,%edx
  80087b:	7e 22                	jle    80089f <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80087d:	ff 75 14             	pushl  0x14(%ebp)
  800880:	ff 75 10             	pushl  0x10(%ebp)
  800883:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800886:	50                   	push   %eax
  800887:	68 c6 02 80 00       	push   $0x8002c6
  80088c:	e8 6f fa ff ff       	call   800300 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800891:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800894:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800897:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80089a:	83 c4 10             	add    $0x10,%esp
}
  80089d:	c9                   	leave  
  80089e:	c3                   	ret    
		return -E_INVAL;
  80089f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008a4:	eb f7                	jmp    80089d <vsnprintf+0x45>

008008a6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008a6:	55                   	push   %ebp
  8008a7:	89 e5                	mov    %esp,%ebp
  8008a9:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008ac:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008af:	50                   	push   %eax
  8008b0:	ff 75 10             	pushl  0x10(%ebp)
  8008b3:	ff 75 0c             	pushl  0xc(%ebp)
  8008b6:	ff 75 08             	pushl  0x8(%ebp)
  8008b9:	e8 9a ff ff ff       	call   800858 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008be:	c9                   	leave  
  8008bf:	c3                   	ret    

008008c0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008c0:	55                   	push   %ebp
  8008c1:	89 e5                	mov    %esp,%ebp
  8008c3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8008cb:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008cf:	74 05                	je     8008d6 <strlen+0x16>
		n++;
  8008d1:	83 c0 01             	add    $0x1,%eax
  8008d4:	eb f5                	jmp    8008cb <strlen+0xb>
	return n;
}
  8008d6:	5d                   	pop    %ebp
  8008d7:	c3                   	ret    

008008d8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008d8:	55                   	push   %ebp
  8008d9:	89 e5                	mov    %esp,%ebp
  8008db:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008de:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8008e6:	39 c2                	cmp    %eax,%edx
  8008e8:	74 0d                	je     8008f7 <strnlen+0x1f>
  8008ea:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8008ee:	74 05                	je     8008f5 <strnlen+0x1d>
		n++;
  8008f0:	83 c2 01             	add    $0x1,%edx
  8008f3:	eb f1                	jmp    8008e6 <strnlen+0xe>
  8008f5:	89 d0                	mov    %edx,%eax
	return n;
}
  8008f7:	5d                   	pop    %ebp
  8008f8:	c3                   	ret    

008008f9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008f9:	55                   	push   %ebp
  8008fa:	89 e5                	mov    %esp,%ebp
  8008fc:	53                   	push   %ebx
  8008fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800900:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800903:	ba 00 00 00 00       	mov    $0x0,%edx
  800908:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80090c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  80090f:	83 c2 01             	add    $0x1,%edx
  800912:	84 c9                	test   %cl,%cl
  800914:	75 f2                	jne    800908 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800916:	5b                   	pop    %ebx
  800917:	5d                   	pop    %ebp
  800918:	c3                   	ret    

00800919 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800919:	55                   	push   %ebp
  80091a:	89 e5                	mov    %esp,%ebp
  80091c:	53                   	push   %ebx
  80091d:	83 ec 10             	sub    $0x10,%esp
  800920:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800923:	53                   	push   %ebx
  800924:	e8 97 ff ff ff       	call   8008c0 <strlen>
  800929:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80092c:	ff 75 0c             	pushl  0xc(%ebp)
  80092f:	01 d8                	add    %ebx,%eax
  800931:	50                   	push   %eax
  800932:	e8 c2 ff ff ff       	call   8008f9 <strcpy>
	return dst;
}
  800937:	89 d8                	mov    %ebx,%eax
  800939:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80093c:	c9                   	leave  
  80093d:	c3                   	ret    

0080093e <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80093e:	55                   	push   %ebp
  80093f:	89 e5                	mov    %esp,%ebp
  800941:	56                   	push   %esi
  800942:	53                   	push   %ebx
  800943:	8b 45 08             	mov    0x8(%ebp),%eax
  800946:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800949:	89 c6                	mov    %eax,%esi
  80094b:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80094e:	89 c2                	mov    %eax,%edx
  800950:	39 f2                	cmp    %esi,%edx
  800952:	74 11                	je     800965 <strncpy+0x27>
		*dst++ = *src;
  800954:	83 c2 01             	add    $0x1,%edx
  800957:	0f b6 19             	movzbl (%ecx),%ebx
  80095a:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80095d:	80 fb 01             	cmp    $0x1,%bl
  800960:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800963:	eb eb                	jmp    800950 <strncpy+0x12>
	}
	return ret;
}
  800965:	5b                   	pop    %ebx
  800966:	5e                   	pop    %esi
  800967:	5d                   	pop    %ebp
  800968:	c3                   	ret    

00800969 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800969:	55                   	push   %ebp
  80096a:	89 e5                	mov    %esp,%ebp
  80096c:	56                   	push   %esi
  80096d:	53                   	push   %ebx
  80096e:	8b 75 08             	mov    0x8(%ebp),%esi
  800971:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800974:	8b 55 10             	mov    0x10(%ebp),%edx
  800977:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800979:	85 d2                	test   %edx,%edx
  80097b:	74 21                	je     80099e <strlcpy+0x35>
  80097d:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800981:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800983:	39 c2                	cmp    %eax,%edx
  800985:	74 14                	je     80099b <strlcpy+0x32>
  800987:	0f b6 19             	movzbl (%ecx),%ebx
  80098a:	84 db                	test   %bl,%bl
  80098c:	74 0b                	je     800999 <strlcpy+0x30>
			*dst++ = *src++;
  80098e:	83 c1 01             	add    $0x1,%ecx
  800991:	83 c2 01             	add    $0x1,%edx
  800994:	88 5a ff             	mov    %bl,-0x1(%edx)
  800997:	eb ea                	jmp    800983 <strlcpy+0x1a>
  800999:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80099b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80099e:	29 f0                	sub    %esi,%eax
}
  8009a0:	5b                   	pop    %ebx
  8009a1:	5e                   	pop    %esi
  8009a2:	5d                   	pop    %ebp
  8009a3:	c3                   	ret    

008009a4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009a4:	55                   	push   %ebp
  8009a5:	89 e5                	mov    %esp,%ebp
  8009a7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009aa:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009ad:	0f b6 01             	movzbl (%ecx),%eax
  8009b0:	84 c0                	test   %al,%al
  8009b2:	74 0c                	je     8009c0 <strcmp+0x1c>
  8009b4:	3a 02                	cmp    (%edx),%al
  8009b6:	75 08                	jne    8009c0 <strcmp+0x1c>
		p++, q++;
  8009b8:	83 c1 01             	add    $0x1,%ecx
  8009bb:	83 c2 01             	add    $0x1,%edx
  8009be:	eb ed                	jmp    8009ad <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009c0:	0f b6 c0             	movzbl %al,%eax
  8009c3:	0f b6 12             	movzbl (%edx),%edx
  8009c6:	29 d0                	sub    %edx,%eax
}
  8009c8:	5d                   	pop    %ebp
  8009c9:	c3                   	ret    

008009ca <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009ca:	55                   	push   %ebp
  8009cb:	89 e5                	mov    %esp,%ebp
  8009cd:	53                   	push   %ebx
  8009ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009d4:	89 c3                	mov    %eax,%ebx
  8009d6:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009d9:	eb 06                	jmp    8009e1 <strncmp+0x17>
		n--, p++, q++;
  8009db:	83 c0 01             	add    $0x1,%eax
  8009de:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009e1:	39 d8                	cmp    %ebx,%eax
  8009e3:	74 16                	je     8009fb <strncmp+0x31>
  8009e5:	0f b6 08             	movzbl (%eax),%ecx
  8009e8:	84 c9                	test   %cl,%cl
  8009ea:	74 04                	je     8009f0 <strncmp+0x26>
  8009ec:	3a 0a                	cmp    (%edx),%cl
  8009ee:	74 eb                	je     8009db <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009f0:	0f b6 00             	movzbl (%eax),%eax
  8009f3:	0f b6 12             	movzbl (%edx),%edx
  8009f6:	29 d0                	sub    %edx,%eax
}
  8009f8:	5b                   	pop    %ebx
  8009f9:	5d                   	pop    %ebp
  8009fa:	c3                   	ret    
		return 0;
  8009fb:	b8 00 00 00 00       	mov    $0x0,%eax
  800a00:	eb f6                	jmp    8009f8 <strncmp+0x2e>

00800a02 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a02:	55                   	push   %ebp
  800a03:	89 e5                	mov    %esp,%ebp
  800a05:	8b 45 08             	mov    0x8(%ebp),%eax
  800a08:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a0c:	0f b6 10             	movzbl (%eax),%edx
  800a0f:	84 d2                	test   %dl,%dl
  800a11:	74 09                	je     800a1c <strchr+0x1a>
		if (*s == c)
  800a13:	38 ca                	cmp    %cl,%dl
  800a15:	74 0a                	je     800a21 <strchr+0x1f>
	for (; *s; s++)
  800a17:	83 c0 01             	add    $0x1,%eax
  800a1a:	eb f0                	jmp    800a0c <strchr+0xa>
			return (char *) s;
	return 0;
  800a1c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a21:	5d                   	pop    %ebp
  800a22:	c3                   	ret    

00800a23 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a23:	55                   	push   %ebp
  800a24:	89 e5                	mov    %esp,%ebp
  800a26:	8b 45 08             	mov    0x8(%ebp),%eax
  800a29:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a2d:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a30:	38 ca                	cmp    %cl,%dl
  800a32:	74 09                	je     800a3d <strfind+0x1a>
  800a34:	84 d2                	test   %dl,%dl
  800a36:	74 05                	je     800a3d <strfind+0x1a>
	for (; *s; s++)
  800a38:	83 c0 01             	add    $0x1,%eax
  800a3b:	eb f0                	jmp    800a2d <strfind+0xa>
			break;
	return (char *) s;
}
  800a3d:	5d                   	pop    %ebp
  800a3e:	c3                   	ret    

00800a3f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a3f:	55                   	push   %ebp
  800a40:	89 e5                	mov    %esp,%ebp
  800a42:	57                   	push   %edi
  800a43:	56                   	push   %esi
  800a44:	53                   	push   %ebx
  800a45:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a48:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a4b:	85 c9                	test   %ecx,%ecx
  800a4d:	74 31                	je     800a80 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a4f:	89 f8                	mov    %edi,%eax
  800a51:	09 c8                	or     %ecx,%eax
  800a53:	a8 03                	test   $0x3,%al
  800a55:	75 23                	jne    800a7a <memset+0x3b>
		c &= 0xFF;
  800a57:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a5b:	89 d3                	mov    %edx,%ebx
  800a5d:	c1 e3 08             	shl    $0x8,%ebx
  800a60:	89 d0                	mov    %edx,%eax
  800a62:	c1 e0 18             	shl    $0x18,%eax
  800a65:	89 d6                	mov    %edx,%esi
  800a67:	c1 e6 10             	shl    $0x10,%esi
  800a6a:	09 f0                	or     %esi,%eax
  800a6c:	09 c2                	or     %eax,%edx
  800a6e:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a70:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a73:	89 d0                	mov    %edx,%eax
  800a75:	fc                   	cld    
  800a76:	f3 ab                	rep stos %eax,%es:(%edi)
  800a78:	eb 06                	jmp    800a80 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7d:	fc                   	cld    
  800a7e:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a80:	89 f8                	mov    %edi,%eax
  800a82:	5b                   	pop    %ebx
  800a83:	5e                   	pop    %esi
  800a84:	5f                   	pop    %edi
  800a85:	5d                   	pop    %ebp
  800a86:	c3                   	ret    

00800a87 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a87:	55                   	push   %ebp
  800a88:	89 e5                	mov    %esp,%ebp
  800a8a:	57                   	push   %edi
  800a8b:	56                   	push   %esi
  800a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a92:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a95:	39 c6                	cmp    %eax,%esi
  800a97:	73 32                	jae    800acb <memmove+0x44>
  800a99:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a9c:	39 c2                	cmp    %eax,%edx
  800a9e:	76 2b                	jbe    800acb <memmove+0x44>
		s += n;
		d += n;
  800aa0:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aa3:	89 fe                	mov    %edi,%esi
  800aa5:	09 ce                	or     %ecx,%esi
  800aa7:	09 d6                	or     %edx,%esi
  800aa9:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800aaf:	75 0e                	jne    800abf <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ab1:	83 ef 04             	sub    $0x4,%edi
  800ab4:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ab7:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800aba:	fd                   	std    
  800abb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800abd:	eb 09                	jmp    800ac8 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800abf:	83 ef 01             	sub    $0x1,%edi
  800ac2:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ac5:	fd                   	std    
  800ac6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ac8:	fc                   	cld    
  800ac9:	eb 1a                	jmp    800ae5 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800acb:	89 c2                	mov    %eax,%edx
  800acd:	09 ca                	or     %ecx,%edx
  800acf:	09 f2                	or     %esi,%edx
  800ad1:	f6 c2 03             	test   $0x3,%dl
  800ad4:	75 0a                	jne    800ae0 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ad6:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800ad9:	89 c7                	mov    %eax,%edi
  800adb:	fc                   	cld    
  800adc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ade:	eb 05                	jmp    800ae5 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800ae0:	89 c7                	mov    %eax,%edi
  800ae2:	fc                   	cld    
  800ae3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ae5:	5e                   	pop    %esi
  800ae6:	5f                   	pop    %edi
  800ae7:	5d                   	pop    %ebp
  800ae8:	c3                   	ret    

00800ae9 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ae9:	55                   	push   %ebp
  800aea:	89 e5                	mov    %esp,%ebp
  800aec:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800aef:	ff 75 10             	pushl  0x10(%ebp)
  800af2:	ff 75 0c             	pushl  0xc(%ebp)
  800af5:	ff 75 08             	pushl  0x8(%ebp)
  800af8:	e8 8a ff ff ff       	call   800a87 <memmove>
}
  800afd:	c9                   	leave  
  800afe:	c3                   	ret    

00800aff <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800aff:	55                   	push   %ebp
  800b00:	89 e5                	mov    %esp,%ebp
  800b02:	56                   	push   %esi
  800b03:	53                   	push   %ebx
  800b04:	8b 45 08             	mov    0x8(%ebp),%eax
  800b07:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b0a:	89 c6                	mov    %eax,%esi
  800b0c:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b0f:	39 f0                	cmp    %esi,%eax
  800b11:	74 1c                	je     800b2f <memcmp+0x30>
		if (*s1 != *s2)
  800b13:	0f b6 08             	movzbl (%eax),%ecx
  800b16:	0f b6 1a             	movzbl (%edx),%ebx
  800b19:	38 d9                	cmp    %bl,%cl
  800b1b:	75 08                	jne    800b25 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b1d:	83 c0 01             	add    $0x1,%eax
  800b20:	83 c2 01             	add    $0x1,%edx
  800b23:	eb ea                	jmp    800b0f <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b25:	0f b6 c1             	movzbl %cl,%eax
  800b28:	0f b6 db             	movzbl %bl,%ebx
  800b2b:	29 d8                	sub    %ebx,%eax
  800b2d:	eb 05                	jmp    800b34 <memcmp+0x35>
	}

	return 0;
  800b2f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b34:	5b                   	pop    %ebx
  800b35:	5e                   	pop    %esi
  800b36:	5d                   	pop    %ebp
  800b37:	c3                   	ret    

00800b38 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b38:	55                   	push   %ebp
  800b39:	89 e5                	mov    %esp,%ebp
  800b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b41:	89 c2                	mov    %eax,%edx
  800b43:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b46:	39 d0                	cmp    %edx,%eax
  800b48:	73 09                	jae    800b53 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b4a:	38 08                	cmp    %cl,(%eax)
  800b4c:	74 05                	je     800b53 <memfind+0x1b>
	for (; s < ends; s++)
  800b4e:	83 c0 01             	add    $0x1,%eax
  800b51:	eb f3                	jmp    800b46 <memfind+0xe>
			break;
	return (void *) s;
}
  800b53:	5d                   	pop    %ebp
  800b54:	c3                   	ret    

00800b55 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b55:	55                   	push   %ebp
  800b56:	89 e5                	mov    %esp,%ebp
  800b58:	57                   	push   %edi
  800b59:	56                   	push   %esi
  800b5a:	53                   	push   %ebx
  800b5b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b5e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b61:	eb 03                	jmp    800b66 <strtol+0x11>
		s++;
  800b63:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b66:	0f b6 01             	movzbl (%ecx),%eax
  800b69:	3c 20                	cmp    $0x20,%al
  800b6b:	74 f6                	je     800b63 <strtol+0xe>
  800b6d:	3c 09                	cmp    $0x9,%al
  800b6f:	74 f2                	je     800b63 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b71:	3c 2b                	cmp    $0x2b,%al
  800b73:	74 2a                	je     800b9f <strtol+0x4a>
	int neg = 0;
  800b75:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b7a:	3c 2d                	cmp    $0x2d,%al
  800b7c:	74 2b                	je     800ba9 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b7e:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b84:	75 0f                	jne    800b95 <strtol+0x40>
  800b86:	80 39 30             	cmpb   $0x30,(%ecx)
  800b89:	74 28                	je     800bb3 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b8b:	85 db                	test   %ebx,%ebx
  800b8d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b92:	0f 44 d8             	cmove  %eax,%ebx
  800b95:	b8 00 00 00 00       	mov    $0x0,%eax
  800b9a:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b9d:	eb 50                	jmp    800bef <strtol+0x9a>
		s++;
  800b9f:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800ba2:	bf 00 00 00 00       	mov    $0x0,%edi
  800ba7:	eb d5                	jmp    800b7e <strtol+0x29>
		s++, neg = 1;
  800ba9:	83 c1 01             	add    $0x1,%ecx
  800bac:	bf 01 00 00 00       	mov    $0x1,%edi
  800bb1:	eb cb                	jmp    800b7e <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bb3:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bb7:	74 0e                	je     800bc7 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800bb9:	85 db                	test   %ebx,%ebx
  800bbb:	75 d8                	jne    800b95 <strtol+0x40>
		s++, base = 8;
  800bbd:	83 c1 01             	add    $0x1,%ecx
  800bc0:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bc5:	eb ce                	jmp    800b95 <strtol+0x40>
		s += 2, base = 16;
  800bc7:	83 c1 02             	add    $0x2,%ecx
  800bca:	bb 10 00 00 00       	mov    $0x10,%ebx
  800bcf:	eb c4                	jmp    800b95 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800bd1:	8d 72 9f             	lea    -0x61(%edx),%esi
  800bd4:	89 f3                	mov    %esi,%ebx
  800bd6:	80 fb 19             	cmp    $0x19,%bl
  800bd9:	77 29                	ja     800c04 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800bdb:	0f be d2             	movsbl %dl,%edx
  800bde:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800be1:	3b 55 10             	cmp    0x10(%ebp),%edx
  800be4:	7d 30                	jge    800c16 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800be6:	83 c1 01             	add    $0x1,%ecx
  800be9:	0f af 45 10          	imul   0x10(%ebp),%eax
  800bed:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800bef:	0f b6 11             	movzbl (%ecx),%edx
  800bf2:	8d 72 d0             	lea    -0x30(%edx),%esi
  800bf5:	89 f3                	mov    %esi,%ebx
  800bf7:	80 fb 09             	cmp    $0x9,%bl
  800bfa:	77 d5                	ja     800bd1 <strtol+0x7c>
			dig = *s - '0';
  800bfc:	0f be d2             	movsbl %dl,%edx
  800bff:	83 ea 30             	sub    $0x30,%edx
  800c02:	eb dd                	jmp    800be1 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c04:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c07:	89 f3                	mov    %esi,%ebx
  800c09:	80 fb 19             	cmp    $0x19,%bl
  800c0c:	77 08                	ja     800c16 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c0e:	0f be d2             	movsbl %dl,%edx
  800c11:	83 ea 37             	sub    $0x37,%edx
  800c14:	eb cb                	jmp    800be1 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c16:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c1a:	74 05                	je     800c21 <strtol+0xcc>
		*endptr = (char *) s;
  800c1c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c1f:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c21:	89 c2                	mov    %eax,%edx
  800c23:	f7 da                	neg    %edx
  800c25:	85 ff                	test   %edi,%edi
  800c27:	0f 45 c2             	cmovne %edx,%eax
}
  800c2a:	5b                   	pop    %ebx
  800c2b:	5e                   	pop    %esi
  800c2c:	5f                   	pop    %edi
  800c2d:	5d                   	pop    %ebp
  800c2e:	c3                   	ret    

00800c2f <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c2f:	55                   	push   %ebp
  800c30:	89 e5                	mov    %esp,%ebp
  800c32:	57                   	push   %edi
  800c33:	56                   	push   %esi
  800c34:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c35:	b8 00 00 00 00       	mov    $0x0,%eax
  800c3a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c3d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c40:	89 c3                	mov    %eax,%ebx
  800c42:	89 c7                	mov    %eax,%edi
  800c44:	89 c6                	mov    %eax,%esi
  800c46:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c48:	5b                   	pop    %ebx
  800c49:	5e                   	pop    %esi
  800c4a:	5f                   	pop    %edi
  800c4b:	5d                   	pop    %ebp
  800c4c:	c3                   	ret    

00800c4d <sys_cgetc>:

int
sys_cgetc(void)
{
  800c4d:	55                   	push   %ebp
  800c4e:	89 e5                	mov    %esp,%ebp
  800c50:	57                   	push   %edi
  800c51:	56                   	push   %esi
  800c52:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c53:	ba 00 00 00 00       	mov    $0x0,%edx
  800c58:	b8 01 00 00 00       	mov    $0x1,%eax
  800c5d:	89 d1                	mov    %edx,%ecx
  800c5f:	89 d3                	mov    %edx,%ebx
  800c61:	89 d7                	mov    %edx,%edi
  800c63:	89 d6                	mov    %edx,%esi
  800c65:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c67:	5b                   	pop    %ebx
  800c68:	5e                   	pop    %esi
  800c69:	5f                   	pop    %edi
  800c6a:	5d                   	pop    %ebp
  800c6b:	c3                   	ret    

00800c6c <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c6c:	55                   	push   %ebp
  800c6d:	89 e5                	mov    %esp,%ebp
  800c6f:	57                   	push   %edi
  800c70:	56                   	push   %esi
  800c71:	53                   	push   %ebx
  800c72:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c75:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c7a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7d:	b8 03 00 00 00       	mov    $0x3,%eax
  800c82:	89 cb                	mov    %ecx,%ebx
  800c84:	89 cf                	mov    %ecx,%edi
  800c86:	89 ce                	mov    %ecx,%esi
  800c88:	cd 30                	int    $0x30
	if (check && ret > 0)
  800c8a:	85 c0                	test   %eax,%eax
  800c8c:	7f 08                	jg     800c96 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c91:	5b                   	pop    %ebx
  800c92:	5e                   	pop    %esi
  800c93:	5f                   	pop    %edi
  800c94:	5d                   	pop    %ebp
  800c95:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c96:	83 ec 0c             	sub    $0xc,%esp
  800c99:	50                   	push   %eax
  800c9a:	6a 03                	push   $0x3
  800c9c:	68 00 1a 80 00       	push   $0x801a00
  800ca1:	6a 4c                	push   $0x4c
  800ca3:	68 1d 1a 80 00       	push   $0x801a1d
  800ca8:	e8 8c 06 00 00       	call   801339 <_panic>

00800cad <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cad:	55                   	push   %ebp
  800cae:	89 e5                	mov    %esp,%ebp
  800cb0:	57                   	push   %edi
  800cb1:	56                   	push   %esi
  800cb2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cb3:	ba 00 00 00 00       	mov    $0x0,%edx
  800cb8:	b8 02 00 00 00       	mov    $0x2,%eax
  800cbd:	89 d1                	mov    %edx,%ecx
  800cbf:	89 d3                	mov    %edx,%ebx
  800cc1:	89 d7                	mov    %edx,%edi
  800cc3:	89 d6                	mov    %edx,%esi
  800cc5:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cc7:	5b                   	pop    %ebx
  800cc8:	5e                   	pop    %esi
  800cc9:	5f                   	pop    %edi
  800cca:	5d                   	pop    %ebp
  800ccb:	c3                   	ret    

00800ccc <sys_yield>:

void
sys_yield(void)
{
  800ccc:	55                   	push   %ebp
  800ccd:	89 e5                	mov    %esp,%ebp
  800ccf:	57                   	push   %edi
  800cd0:	56                   	push   %esi
  800cd1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cd2:	ba 00 00 00 00       	mov    $0x0,%edx
  800cd7:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cdc:	89 d1                	mov    %edx,%ecx
  800cde:	89 d3                	mov    %edx,%ebx
  800ce0:	89 d7                	mov    %edx,%edi
  800ce2:	89 d6                	mov    %edx,%esi
  800ce4:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800ce6:	5b                   	pop    %ebx
  800ce7:	5e                   	pop    %esi
  800ce8:	5f                   	pop    %edi
  800ce9:	5d                   	pop    %ebp
  800cea:	c3                   	ret    

00800ceb <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800ceb:	55                   	push   %ebp
  800cec:	89 e5                	mov    %esp,%ebp
  800cee:	57                   	push   %edi
  800cef:	56                   	push   %esi
  800cf0:	53                   	push   %ebx
  800cf1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cf4:	be 00 00 00 00       	mov    $0x0,%esi
  800cf9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cfc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cff:	b8 04 00 00 00       	mov    $0x4,%eax
  800d04:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d07:	89 f7                	mov    %esi,%edi
  800d09:	cd 30                	int    $0x30
	if (check && ret > 0)
  800d0b:	85 c0                	test   %eax,%eax
  800d0d:	7f 08                	jg     800d17 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d0f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d12:	5b                   	pop    %ebx
  800d13:	5e                   	pop    %esi
  800d14:	5f                   	pop    %edi
  800d15:	5d                   	pop    %ebp
  800d16:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d17:	83 ec 0c             	sub    $0xc,%esp
  800d1a:	50                   	push   %eax
  800d1b:	6a 04                	push   $0x4
  800d1d:	68 00 1a 80 00       	push   $0x801a00
  800d22:	6a 4c                	push   $0x4c
  800d24:	68 1d 1a 80 00       	push   $0x801a1d
  800d29:	e8 0b 06 00 00       	call   801339 <_panic>

00800d2e <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d2e:	55                   	push   %ebp
  800d2f:	89 e5                	mov    %esp,%ebp
  800d31:	57                   	push   %edi
  800d32:	56                   	push   %esi
  800d33:	53                   	push   %ebx
  800d34:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d37:	8b 55 08             	mov    0x8(%ebp),%edx
  800d3a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d3d:	b8 05 00 00 00       	mov    $0x5,%eax
  800d42:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d45:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d48:	8b 75 18             	mov    0x18(%ebp),%esi
  800d4b:	cd 30                	int    $0x30
	if (check && ret > 0)
  800d4d:	85 c0                	test   %eax,%eax
  800d4f:	7f 08                	jg     800d59 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d51:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d54:	5b                   	pop    %ebx
  800d55:	5e                   	pop    %esi
  800d56:	5f                   	pop    %edi
  800d57:	5d                   	pop    %ebp
  800d58:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d59:	83 ec 0c             	sub    $0xc,%esp
  800d5c:	50                   	push   %eax
  800d5d:	6a 05                	push   $0x5
  800d5f:	68 00 1a 80 00       	push   $0x801a00
  800d64:	6a 4c                	push   $0x4c
  800d66:	68 1d 1a 80 00       	push   $0x801a1d
  800d6b:	e8 c9 05 00 00       	call   801339 <_panic>

00800d70 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d70:	55                   	push   %ebp
  800d71:	89 e5                	mov    %esp,%ebp
  800d73:	57                   	push   %edi
  800d74:	56                   	push   %esi
  800d75:	53                   	push   %ebx
  800d76:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d79:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d7e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d81:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d84:	b8 06 00 00 00       	mov    $0x6,%eax
  800d89:	89 df                	mov    %ebx,%edi
  800d8b:	89 de                	mov    %ebx,%esi
  800d8d:	cd 30                	int    $0x30
	if (check && ret > 0)
  800d8f:	85 c0                	test   %eax,%eax
  800d91:	7f 08                	jg     800d9b <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d93:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d96:	5b                   	pop    %ebx
  800d97:	5e                   	pop    %esi
  800d98:	5f                   	pop    %edi
  800d99:	5d                   	pop    %ebp
  800d9a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d9b:	83 ec 0c             	sub    $0xc,%esp
  800d9e:	50                   	push   %eax
  800d9f:	6a 06                	push   $0x6
  800da1:	68 00 1a 80 00       	push   $0x801a00
  800da6:	6a 4c                	push   $0x4c
  800da8:	68 1d 1a 80 00       	push   $0x801a1d
  800dad:	e8 87 05 00 00       	call   801339 <_panic>

00800db2 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800db2:	55                   	push   %ebp
  800db3:	89 e5                	mov    %esp,%ebp
  800db5:	57                   	push   %edi
  800db6:	56                   	push   %esi
  800db7:	53                   	push   %ebx
  800db8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dbb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dc0:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc6:	b8 08 00 00 00       	mov    $0x8,%eax
  800dcb:	89 df                	mov    %ebx,%edi
  800dcd:	89 de                	mov    %ebx,%esi
  800dcf:	cd 30                	int    $0x30
	if (check && ret > 0)
  800dd1:	85 c0                	test   %eax,%eax
  800dd3:	7f 08                	jg     800ddd <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800dd5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dd8:	5b                   	pop    %ebx
  800dd9:	5e                   	pop    %esi
  800dda:	5f                   	pop    %edi
  800ddb:	5d                   	pop    %ebp
  800ddc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ddd:	83 ec 0c             	sub    $0xc,%esp
  800de0:	50                   	push   %eax
  800de1:	6a 08                	push   $0x8
  800de3:	68 00 1a 80 00       	push   $0x801a00
  800de8:	6a 4c                	push   $0x4c
  800dea:	68 1d 1a 80 00       	push   $0x801a1d
  800def:	e8 45 05 00 00       	call   801339 <_panic>

00800df4 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800df4:	55                   	push   %ebp
  800df5:	89 e5                	mov    %esp,%ebp
  800df7:	57                   	push   %edi
  800df8:	56                   	push   %esi
  800df9:	53                   	push   %ebx
  800dfa:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dfd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e02:	8b 55 08             	mov    0x8(%ebp),%edx
  800e05:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e08:	b8 09 00 00 00       	mov    $0x9,%eax
  800e0d:	89 df                	mov    %ebx,%edi
  800e0f:	89 de                	mov    %ebx,%esi
  800e11:	cd 30                	int    $0x30
	if (check && ret > 0)
  800e13:	85 c0                	test   %eax,%eax
  800e15:	7f 08                	jg     800e1f <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e17:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e1a:	5b                   	pop    %ebx
  800e1b:	5e                   	pop    %esi
  800e1c:	5f                   	pop    %edi
  800e1d:	5d                   	pop    %ebp
  800e1e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e1f:	83 ec 0c             	sub    $0xc,%esp
  800e22:	50                   	push   %eax
  800e23:	6a 09                	push   $0x9
  800e25:	68 00 1a 80 00       	push   $0x801a00
  800e2a:	6a 4c                	push   $0x4c
  800e2c:	68 1d 1a 80 00       	push   $0x801a1d
  800e31:	e8 03 05 00 00       	call   801339 <_panic>

00800e36 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e36:	55                   	push   %ebp
  800e37:	89 e5                	mov    %esp,%ebp
  800e39:	57                   	push   %edi
  800e3a:	56                   	push   %esi
  800e3b:	53                   	push   %ebx
  800e3c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e3f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e44:	8b 55 08             	mov    0x8(%ebp),%edx
  800e47:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e4a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e4f:	89 df                	mov    %ebx,%edi
  800e51:	89 de                	mov    %ebx,%esi
  800e53:	cd 30                	int    $0x30
	if (check && ret > 0)
  800e55:	85 c0                	test   %eax,%eax
  800e57:	7f 08                	jg     800e61 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e59:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e5c:	5b                   	pop    %ebx
  800e5d:	5e                   	pop    %esi
  800e5e:	5f                   	pop    %edi
  800e5f:	5d                   	pop    %ebp
  800e60:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e61:	83 ec 0c             	sub    $0xc,%esp
  800e64:	50                   	push   %eax
  800e65:	6a 0a                	push   $0xa
  800e67:	68 00 1a 80 00       	push   $0x801a00
  800e6c:	6a 4c                	push   $0x4c
  800e6e:	68 1d 1a 80 00       	push   $0x801a1d
  800e73:	e8 c1 04 00 00       	call   801339 <_panic>

00800e78 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e78:	55                   	push   %ebp
  800e79:	89 e5                	mov    %esp,%ebp
  800e7b:	57                   	push   %edi
  800e7c:	56                   	push   %esi
  800e7d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e7e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e81:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e84:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e89:	be 00 00 00 00       	mov    $0x0,%esi
  800e8e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e91:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e94:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e96:	5b                   	pop    %ebx
  800e97:	5e                   	pop    %esi
  800e98:	5f                   	pop    %edi
  800e99:	5d                   	pop    %ebp
  800e9a:	c3                   	ret    

00800e9b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e9b:	55                   	push   %ebp
  800e9c:	89 e5                	mov    %esp,%ebp
  800e9e:	57                   	push   %edi
  800e9f:	56                   	push   %esi
  800ea0:	53                   	push   %ebx
  800ea1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ea4:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ea9:	8b 55 08             	mov    0x8(%ebp),%edx
  800eac:	b8 0d 00 00 00       	mov    $0xd,%eax
  800eb1:	89 cb                	mov    %ecx,%ebx
  800eb3:	89 cf                	mov    %ecx,%edi
  800eb5:	89 ce                	mov    %ecx,%esi
  800eb7:	cd 30                	int    $0x30
	if (check && ret > 0)
  800eb9:	85 c0                	test   %eax,%eax
  800ebb:	7f 08                	jg     800ec5 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ebd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ec0:	5b                   	pop    %ebx
  800ec1:	5e                   	pop    %esi
  800ec2:	5f                   	pop    %edi
  800ec3:	5d                   	pop    %ebp
  800ec4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec5:	83 ec 0c             	sub    $0xc,%esp
  800ec8:	50                   	push   %eax
  800ec9:	6a 0d                	push   $0xd
  800ecb:	68 00 1a 80 00       	push   $0x801a00
  800ed0:	6a 4c                	push   $0x4c
  800ed2:	68 1d 1a 80 00       	push   $0x801a1d
  800ed7:	e8 5d 04 00 00       	call   801339 <_panic>

00800edc <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800edc:	55                   	push   %ebp
  800edd:	89 e5                	mov    %esp,%ebp
  800edf:	57                   	push   %edi
  800ee0:	56                   	push   %esi
  800ee1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ee2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ee7:	8b 55 08             	mov    0x8(%ebp),%edx
  800eea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eed:	b8 0e 00 00 00       	mov    $0xe,%eax
  800ef2:	89 df                	mov    %ebx,%edi
  800ef4:	89 de                	mov    %ebx,%esi
  800ef6:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800ef8:	5b                   	pop    %ebx
  800ef9:	5e                   	pop    %esi
  800efa:	5f                   	pop    %edi
  800efb:	5d                   	pop    %ebp
  800efc:	c3                   	ret    

00800efd <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800efd:	55                   	push   %ebp
  800efe:	89 e5                	mov    %esp,%ebp
  800f00:	57                   	push   %edi
  800f01:	56                   	push   %esi
  800f02:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f03:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f08:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0b:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f10:	89 cb                	mov    %ecx,%ebx
  800f12:	89 cf                	mov    %ecx,%edi
  800f14:	89 ce                	mov    %ecx,%esi
  800f16:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f18:	5b                   	pop    %ebx
  800f19:	5e                   	pop    %esi
  800f1a:	5f                   	pop    %edi
  800f1b:	5d                   	pop    %ebp
  800f1c:	c3                   	ret    

00800f1d <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800f1d:	55                   	push   %ebp
  800f1e:	89 e5                	mov    %esp,%ebp
  800f20:	53                   	push   %ebx
  800f21:	83 ec 04             	sub    $0x4,%esp
  800f24:	8b 55 08             	mov    0x8(%ebp),%edx
	// cprintf("pgfault()\n");
	void *addr = (void *) utf->utf_fault_va;
  800f27:	8b 02                	mov    (%edx),%eax
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(!(err & FEC_WR) || !(uvpd[PDX(addr)] & PTE_P) || !(uvpt[PGNUM(addr)] & PTE_P) || !(uvpt[PGNUM(addr)] & PTE_COW))
  800f29:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  800f2d:	0f 84 9c 00 00 00    	je     800fcf <pgfault+0xb2>
  800f33:	89 c2                	mov    %eax,%edx
  800f35:	c1 ea 16             	shr    $0x16,%edx
  800f38:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f3f:	f6 c2 01             	test   $0x1,%dl
  800f42:	0f 84 87 00 00 00    	je     800fcf <pgfault+0xb2>
  800f48:	89 c2                	mov    %eax,%edx
  800f4a:	c1 ea 0c             	shr    $0xc,%edx
  800f4d:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  800f54:	f6 c1 01             	test   $0x1,%cl
  800f57:	74 76                	je     800fcf <pgfault+0xb2>
  800f59:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f60:	f6 c6 08             	test   $0x8,%dh
  800f63:	74 6a                	je     800fcf <pgfault+0xb2>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  800f65:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f6a:	89 c3                	mov    %eax,%ebx

	r = sys_page_alloc(0, PFTEMP, PTE_P|PTE_U|PTE_W);
  800f6c:	83 ec 04             	sub    $0x4,%esp
  800f6f:	6a 07                	push   $0x7
  800f71:	68 00 f0 7f 00       	push   $0x7ff000
  800f76:	6a 00                	push   $0x0
  800f78:	e8 6e fd ff ff       	call   800ceb <sys_page_alloc>
	if(r < 0){
  800f7d:	83 c4 10             	add    $0x10,%esp
  800f80:	85 c0                	test   %eax,%eax
  800f82:	78 5f                	js     800fe3 <pgfault+0xc6>
		panic("pgfault: sys_page_alloc fail, r: %d", r);
	}

	memmove(PFTEMP, addr, PGSIZE);
  800f84:	83 ec 04             	sub    $0x4,%esp
  800f87:	68 00 10 00 00       	push   $0x1000
  800f8c:	53                   	push   %ebx
  800f8d:	68 00 f0 7f 00       	push   $0x7ff000
  800f92:	e8 f0 fa ff ff       	call   800a87 <memmove>

	r = sys_page_map(0, PFTEMP, 0, addr, PTE_P|PTE_U|PTE_W);
  800f97:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800f9e:	53                   	push   %ebx
  800f9f:	6a 00                	push   $0x0
  800fa1:	68 00 f0 7f 00       	push   $0x7ff000
  800fa6:	6a 00                	push   $0x0
  800fa8:	e8 81 fd ff ff       	call   800d2e <sys_page_map>
	if(r < 0){
  800fad:	83 c4 20             	add    $0x20,%esp
  800fb0:	85 c0                	test   %eax,%eax
  800fb2:	78 41                	js     800ff5 <pgfault+0xd8>
		panic("pgfault: sys_page_map fail, r: %d", r);
	}

	r = sys_page_unmap(0, PFTEMP);
  800fb4:	83 ec 08             	sub    $0x8,%esp
  800fb7:	68 00 f0 7f 00       	push   $0x7ff000
  800fbc:	6a 00                	push   $0x0
  800fbe:	e8 ad fd ff ff       	call   800d70 <sys_page_unmap>
	if(r < 0){
  800fc3:	83 c4 10             	add    $0x10,%esp
  800fc6:	85 c0                	test   %eax,%eax
  800fc8:	78 3d                	js     801007 <pgfault+0xea>
		panic("sys_page_unmap: %e", r);
	}
}
  800fca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800fcd:	c9                   	leave  
  800fce:	c3                   	ret    
		panic("pgfault: 1\n");
  800fcf:	83 ec 04             	sub    $0x4,%esp
  800fd2:	68 2b 1a 80 00       	push   $0x801a2b
  800fd7:	6a 20                	push   $0x20
  800fd9:	68 37 1a 80 00       	push   $0x801a37
  800fde:	e8 56 03 00 00       	call   801339 <_panic>
		panic("pgfault: sys_page_alloc fail, r: %d", r);
  800fe3:	50                   	push   %eax
  800fe4:	68 8c 1a 80 00       	push   $0x801a8c
  800fe9:	6a 2e                	push   $0x2e
  800feb:	68 37 1a 80 00       	push   $0x801a37
  800ff0:	e8 44 03 00 00       	call   801339 <_panic>
		panic("pgfault: sys_page_map fail, r: %d", r);
  800ff5:	50                   	push   %eax
  800ff6:	68 b0 1a 80 00       	push   $0x801ab0
  800ffb:	6a 35                	push   $0x35
  800ffd:	68 37 1a 80 00       	push   $0x801a37
  801002:	e8 32 03 00 00       	call   801339 <_panic>
		panic("sys_page_unmap: %e", r);
  801007:	50                   	push   %eax
  801008:	68 42 1a 80 00       	push   $0x801a42
  80100d:	6a 3a                	push   $0x3a
  80100f:	68 37 1a 80 00       	push   $0x801a37
  801014:	e8 20 03 00 00       	call   801339 <_panic>

00801019 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801019:	55                   	push   %ebp
  80101a:	89 e5                	mov    %esp,%ebp
  80101c:	57                   	push   %edi
  80101d:	56                   	push   %esi
  80101e:	53                   	push   %ebx
  80101f:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	// panic("fork not implemented");
	int r;
	set_pgfault_handler(pgfault);
  801022:	68 1d 0f 80 00       	push   $0x800f1d
  801027:	e8 53 03 00 00       	call   80137f <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  80102c:	b8 07 00 00 00       	mov    $0x7,%eax
  801031:	cd 30                	int    $0x30
  801033:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int i;
	uintptr_t va;
	envid_t childid = sys_exofork();
	if (childid < 0){
  801036:	83 c4 10             	add    $0x10,%esp
  801039:	85 c0                	test   %eax,%eax
  80103b:	78 2c                	js     801069 <fork+0x50>
  80103d:	89 c7                	mov    %eax,%edi
	}

	extern volatile pde_t uvpd[];
	extern volatile pte_t uvpt[];

	for (va = UTEXT; va < USTACKTOP; va += PGSIZE){
  80103f:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if (childid == 0) {
  801044:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801048:	75 72                	jne    8010bc <fork+0xa3>
		thisenv = &envs[ENVX(sys_getenvid())];
  80104a:	e8 5e fc ff ff       	call   800cad <sys_getenvid>
  80104f:	25 ff 03 00 00       	and    $0x3ff,%eax
  801054:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80105a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80105f:	a3 04 20 80 00       	mov    %eax,0x802004
		return 0;
  801064:	e9 36 01 00 00       	jmp    80119f <fork+0x186>
		panic("fork: child id < 0: %d", childid);
  801069:	50                   	push   %eax
  80106a:	68 55 1a 80 00       	push   $0x801a55
  80106f:	68 83 00 00 00       	push   $0x83
  801074:	68 37 1a 80 00       	push   $0x801a37
  801079:	e8 bb 02 00 00       	call   801339 <_panic>
			panic("sys_page_map: sys_page_map fail, r:%d\n", r);
  80107e:	50                   	push   %eax
  80107f:	68 d4 1a 80 00       	push   $0x801ad4
  801084:	6a 56                	push   $0x56
  801086:	68 37 1a 80 00       	push   $0x801a37
  80108b:	e8 a9 02 00 00       	call   801339 <_panic>
		r = sys_page_map((envid_t)0, va, envid, va, PTE_U | PTE_P);
  801090:	83 ec 0c             	sub    $0xc,%esp
  801093:	6a 05                	push   $0x5
  801095:	56                   	push   %esi
  801096:	57                   	push   %edi
  801097:	56                   	push   %esi
  801098:	6a 00                	push   $0x0
  80109a:	e8 8f fc ff ff       	call   800d2e <sys_page_map>
		if(r < 0){
  80109f:	83 c4 20             	add    $0x20,%esp
  8010a2:	85 c0                	test   %eax,%eax
  8010a4:	0f 88 9f 00 00 00    	js     801149 <fork+0x130>
	for (va = UTEXT; va < USTACKTOP; va += PGSIZE){
  8010aa:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8010b0:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8010b6:	0f 84 9f 00 00 00    	je     80115b <fork+0x142>
		if ((uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_U)){
  8010bc:	89 d8                	mov    %ebx,%eax
  8010be:	c1 e8 16             	shr    $0x16,%eax
  8010c1:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8010c8:	a8 01                	test   $0x1,%al
  8010ca:	74 de                	je     8010aa <fork+0x91>
  8010cc:	89 d8                	mov    %ebx,%eax
  8010ce:	c1 e8 0c             	shr    $0xc,%eax
  8010d1:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8010d8:	f6 c2 01             	test   $0x1,%dl
  8010db:	74 cd                	je     8010aa <fork+0x91>
  8010dd:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8010e4:	f6 c2 04             	test   $0x4,%dl
  8010e7:	74 c1                	je     8010aa <fork+0x91>
	void * va = (void *)(pn * PGSIZE);
  8010e9:	89 c6                	mov    %eax,%esi
  8010eb:	c1 e6 0c             	shl    $0xc,%esi
	int perm = (uvpt[pn]);
  8010ee:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (perm & (PTE_W | PTE_COW)) {
  8010f5:	a9 02 08 00 00       	test   $0x802,%eax
  8010fa:	74 94                	je     801090 <fork+0x77>
		r = sys_page_map((envid_t)0, va, envid, va, PTE_U | PTE_P | PTE_COW);
  8010fc:	83 ec 0c             	sub    $0xc,%esp
  8010ff:	68 05 08 00 00       	push   $0x805
  801104:	56                   	push   %esi
  801105:	57                   	push   %edi
  801106:	56                   	push   %esi
  801107:	6a 00                	push   $0x0
  801109:	e8 20 fc ff ff       	call   800d2e <sys_page_map>
		if(r < 0){
  80110e:	83 c4 20             	add    $0x20,%esp
  801111:	85 c0                	test   %eax,%eax
  801113:	0f 88 65 ff ff ff    	js     80107e <fork+0x65>
		r = sys_page_map((envid_t)0, va, (envid_t)0, va, PTE_U | PTE_P | PTE_COW);
  801119:	83 ec 0c             	sub    $0xc,%esp
  80111c:	68 05 08 00 00       	push   $0x805
  801121:	56                   	push   %esi
  801122:	6a 00                	push   $0x0
  801124:	56                   	push   %esi
  801125:	6a 00                	push   $0x0
  801127:	e8 02 fc ff ff       	call   800d2e <sys_page_map>
		if(r < 0){
  80112c:	83 c4 20             	add    $0x20,%esp
  80112f:	85 c0                	test   %eax,%eax
  801131:	0f 89 73 ff ff ff    	jns    8010aa <fork+0x91>
			panic("sys_page_map: sys_page_map fail, r:%d\n", r);
  801137:	50                   	push   %eax
  801138:	68 d4 1a 80 00       	push   $0x801ad4
  80113d:	6a 5b                	push   $0x5b
  80113f:	68 37 1a 80 00       	push   $0x801a37
  801144:	e8 f0 01 00 00       	call   801339 <_panic>
			panic("sys_page_map: sys_page_map fail, r:%d\n", r);
  801149:	50                   	push   %eax
  80114a:	68 d4 1a 80 00       	push   $0x801ad4
  80114f:	6a 61                	push   $0x61
  801151:	68 37 1a 80 00       	push   $0x801a37
  801156:	e8 de 01 00 00       	call   801339 <_panic>
			duppage(childid, PGNUM(va));
		}
	}

	r = sys_page_alloc(childid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  80115b:	83 ec 04             	sub    $0x4,%esp
  80115e:	6a 07                	push   $0x7
  801160:	68 00 f0 bf ee       	push   $0xeebff000
  801165:	ff 75 e4             	pushl  -0x1c(%ebp)
  801168:	e8 7e fb ff ff       	call   800ceb <sys_page_alloc>
	if (r < 0){
  80116d:	83 c4 10             	add    $0x10,%esp
  801170:	85 c0                	test   %eax,%eax
  801172:	78 36                	js     8011aa <fork+0x191>
		panic("fork: allocate user exception stack for child env error, %d", r);
	}
	r = sys_env_set_pgfault_upcall(childid, _pgfault_upcall);
  801174:	83 ec 08             	sub    $0x8,%esp
  801177:	68 ea 13 80 00       	push   $0x8013ea
  80117c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80117f:	e8 b2 fc ff ff       	call   800e36 <sys_env_set_pgfault_upcall>
	if (r < 0){
  801184:	83 c4 10             	add    $0x10,%esp
  801187:	85 c0                	test   %eax,%eax
  801189:	78 34                	js     8011bf <fork+0x1a6>
		panic("fork: sys_env_set_pgfault_upcall error, %d", r);
	}
	r = sys_env_set_status(childid, ENV_RUNNABLE);
  80118b:	83 ec 08             	sub    $0x8,%esp
  80118e:	6a 02                	push   $0x2
  801190:	ff 75 e4             	pushl  -0x1c(%ebp)
  801193:	e8 1a fc ff ff       	call   800db2 <sys_env_set_status>
	if(r < 0){
  801198:	83 c4 10             	add    $0x10,%esp
  80119b:	85 c0                	test   %eax,%eax
  80119d:	78 35                	js     8011d4 <fork+0x1bb>
		panic("forK: sys_env_set_status, r%d", r);
	}
	return childid;
}
  80119f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011a5:	5b                   	pop    %ebx
  8011a6:	5e                   	pop    %esi
  8011a7:	5f                   	pop    %edi
  8011a8:	5d                   	pop    %ebp
  8011a9:	c3                   	ret    
		panic("fork: allocate user exception stack for child env error, %d", r);
  8011aa:	50                   	push   %eax
  8011ab:	68 fc 1a 80 00       	push   $0x801afc
  8011b0:	68 96 00 00 00       	push   $0x96
  8011b5:	68 37 1a 80 00       	push   $0x801a37
  8011ba:	e8 7a 01 00 00       	call   801339 <_panic>
		panic("fork: sys_env_set_pgfault_upcall error, %d", r);
  8011bf:	50                   	push   %eax
  8011c0:	68 38 1b 80 00       	push   $0x801b38
  8011c5:	68 9a 00 00 00       	push   $0x9a
  8011ca:	68 37 1a 80 00       	push   $0x801a37
  8011cf:	e8 65 01 00 00       	call   801339 <_panic>
		panic("forK: sys_env_set_status, r%d", r);
  8011d4:	50                   	push   %eax
  8011d5:	68 6c 1a 80 00       	push   $0x801a6c
  8011da:	68 9e 00 00 00       	push   $0x9e
  8011df:	68 37 1a 80 00       	push   $0x801a37
  8011e4:	e8 50 01 00 00       	call   801339 <_panic>

008011e9 <sfork>:

// Challenge!
int
sfork(void)
{
  8011e9:	55                   	push   %ebp
  8011ea:	89 e5                	mov    %esp,%ebp
  8011ec:	57                   	push   %edi
  8011ed:	56                   	push   %esi
  8011ee:	53                   	push   %ebx
  8011ef:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// return -E_INVAL;
	set_pgfault_handler(pgfault);
  8011f2:	68 1d 0f 80 00       	push   $0x800f1d
  8011f7:	e8 83 01 00 00       	call   80137f <set_pgfault_handler>
  8011fc:	b8 07 00 00 00       	mov    $0x7,%eax
  801201:	cd 30                	int    $0x30
  801203:	89 c6                	mov    %eax,%esi
	int i;
	uintptr_t va;
	envid_t childid = sys_exofork();
	int r;
	if (childid < 0){
  801205:	83 c4 10             	add    $0x10,%esp
  801208:	85 c0                	test   %eax,%eax
  80120a:	78 28                	js     801234 <sfork+0x4b>
  80120c:	89 c7                	mov    %eax,%edi
	}

	extern volatile pde_t uvpd[];
	extern volatile pte_t uvpt[];

	for (va = 0; va < USTACKTOP; va += PGSIZE){
  80120e:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (childid == 0) {
  801213:	75 42                	jne    801257 <sfork+0x6e>
		thisenv = &envs[ENVX(sys_getenvid())];
  801215:	e8 93 fa ff ff       	call   800cad <sys_getenvid>
  80121a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80121f:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  801225:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80122a:	a3 04 20 80 00       	mov    %eax,0x802004
		return 0;
  80122f:	e9 bc 00 00 00       	jmp    8012f0 <sfork+0x107>
		panic("fork: child id < 0: %d", childid);
  801234:	50                   	push   %eax
  801235:	68 55 1a 80 00       	push   $0x801a55
  80123a:	68 af 00 00 00       	push   $0xaf
  80123f:	68 37 1a 80 00       	push   $0x801a37
  801244:	e8 f0 00 00 00       	call   801339 <_panic>
	for (va = 0; va < USTACKTOP; va += PGSIZE){
  801249:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80124f:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801255:	74 5b                	je     8012b2 <sfork+0xc9>
		if ((uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_U)){
  801257:	89 d8                	mov    %ebx,%eax
  801259:	c1 e8 16             	shr    $0x16,%eax
  80125c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801263:	a8 01                	test   $0x1,%al
  801265:	74 e2                	je     801249 <sfork+0x60>
  801267:	89 d8                	mov    %ebx,%eax
  801269:	c1 e8 0c             	shr    $0xc,%eax
  80126c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801273:	f6 c2 01             	test   $0x1,%dl
  801276:	74 d1                	je     801249 <sfork+0x60>
  801278:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80127f:	f6 c2 04             	test   $0x4,%dl
  801282:	74 c5                	je     801249 <sfork+0x60>
			void *addr = (void *)(PGNUM(va) * PGSIZE);
  801284:	c1 e0 0c             	shl    $0xc,%eax
			struct PageInfo *page;
			pte_t *pte;
			
			// page = page_lookup((envid_t)0->env_pgdir, addr, &pte);
			// page_insert(dstenv->env_pgdir, page, addr, PTE_U | PTE_P);
			r = sys_page_map((envid_t)0, addr, childid, addr, PTE_U | PTE_P);
  801287:	83 ec 0c             	sub    $0xc,%esp
  80128a:	6a 05                	push   $0x5
  80128c:	50                   	push   %eax
  80128d:	57                   	push   %edi
  80128e:	50                   	push   %eax
  80128f:	6a 00                	push   $0x0
  801291:	e8 98 fa ff ff       	call   800d2e <sys_page_map>
			if(r < 0){
  801296:	83 c4 20             	add    $0x20,%esp
  801299:	85 c0                	test   %eax,%eax
  80129b:	79 ac                	jns    801249 <sfork+0x60>
				panic("sfork: sys_page_map fail, r:%d\n", r);
  80129d:	50                   	push   %eax
  80129e:	68 64 1b 80 00       	push   $0x801b64
  8012a3:	68 c4 00 00 00       	push   $0xc4
  8012a8:	68 37 1a 80 00       	push   $0x801a37
  8012ad:	e8 87 00 00 00       	call   801339 <_panic>
			}
		}
	}

	r = sys_page_alloc(childid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8012b2:	83 ec 04             	sub    $0x4,%esp
  8012b5:	6a 07                	push   $0x7
  8012b7:	68 00 f0 bf ee       	push   $0xeebff000
  8012bc:	56                   	push   %esi
  8012bd:	e8 29 fa ff ff       	call   800ceb <sys_page_alloc>
	if (r < 0){
  8012c2:	83 c4 10             	add    $0x10,%esp
  8012c5:	85 c0                	test   %eax,%eax
  8012c7:	78 31                	js     8012fa <sfork+0x111>
		panic("sfork: allocate user exception stack for child env error, %d", r);
	}
	r = sys_env_set_pgfault_upcall(childid, _pgfault_upcall);
  8012c9:	83 ec 08             	sub    $0x8,%esp
  8012cc:	68 ea 13 80 00       	push   $0x8013ea
  8012d1:	56                   	push   %esi
  8012d2:	e8 5f fb ff ff       	call   800e36 <sys_env_set_pgfault_upcall>
	if (r < 0){
  8012d7:	83 c4 10             	add    $0x10,%esp
  8012da:	85 c0                	test   %eax,%eax
  8012dc:	78 31                	js     80130f <sfork+0x126>
		panic("sfork: sys_env_set_pgfault_upcall error, %d", r);
	}
	r = sys_env_set_status(childid, ENV_RUNNABLE);
  8012de:	83 ec 08             	sub    $0x8,%esp
  8012e1:	6a 02                	push   $0x2
  8012e3:	56                   	push   %esi
  8012e4:	e8 c9 fa ff ff       	call   800db2 <sys_env_set_status>
	if(r < 0){
  8012e9:	83 c4 10             	add    $0x10,%esp
  8012ec:	85 c0                	test   %eax,%eax
  8012ee:	78 34                	js     801324 <sfork+0x13b>
		panic("sforK: sys_env_set_status, r%d", r);
	}
	return childid;
}
  8012f0:	89 f0                	mov    %esi,%eax
  8012f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012f5:	5b                   	pop    %ebx
  8012f6:	5e                   	pop    %esi
  8012f7:	5f                   	pop    %edi
  8012f8:	5d                   	pop    %ebp
  8012f9:	c3                   	ret    
		panic("sfork: allocate user exception stack for child env error, %d", r);
  8012fa:	50                   	push   %eax
  8012fb:	68 84 1b 80 00       	push   $0x801b84
  801300:	68 cb 00 00 00       	push   $0xcb
  801305:	68 37 1a 80 00       	push   $0x801a37
  80130a:	e8 2a 00 00 00       	call   801339 <_panic>
		panic("sfork: sys_env_set_pgfault_upcall error, %d", r);
  80130f:	50                   	push   %eax
  801310:	68 c4 1b 80 00       	push   $0x801bc4
  801315:	68 cf 00 00 00       	push   $0xcf
  80131a:	68 37 1a 80 00       	push   $0x801a37
  80131f:	e8 15 00 00 00       	call   801339 <_panic>
		panic("sforK: sys_env_set_status, r%d", r);
  801324:	50                   	push   %eax
  801325:	68 f0 1b 80 00       	push   $0x801bf0
  80132a:	68 d3 00 00 00       	push   $0xd3
  80132f:	68 37 1a 80 00       	push   $0x801a37
  801334:	e8 00 00 00 00       	call   801339 <_panic>

00801339 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801339:	55                   	push   %ebp
  80133a:	89 e5                	mov    %esp,%ebp
  80133c:	56                   	push   %esi
  80133d:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80133e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801341:	8b 35 00 20 80 00    	mov    0x802000,%esi
  801347:	e8 61 f9 ff ff       	call   800cad <sys_getenvid>
  80134c:	83 ec 0c             	sub    $0xc,%esp
  80134f:	ff 75 0c             	pushl  0xc(%ebp)
  801352:	ff 75 08             	pushl  0x8(%ebp)
  801355:	56                   	push   %esi
  801356:	50                   	push   %eax
  801357:	68 10 1c 80 00       	push   $0x801c10
  80135c:	e8 72 ee ff ff       	call   8001d3 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801361:	83 c4 18             	add    $0x18,%esp
  801364:	53                   	push   %ebx
  801365:	ff 75 10             	pushl  0x10(%ebp)
  801368:	e8 15 ee ff ff       	call   800182 <vcprintf>
	cprintf("\n");
  80136d:	c7 04 24 6f 16 80 00 	movl   $0x80166f,(%esp)
  801374:	e8 5a ee ff ff       	call   8001d3 <cprintf>
  801379:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80137c:	cc                   	int3   
  80137d:	eb fd                	jmp    80137c <_panic+0x43>

0080137f <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80137f:	55                   	push   %ebp
  801380:	89 e5                	mov    %esp,%ebp
  801382:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801385:	83 3d 08 20 80 00 00 	cmpl   $0x0,0x802008
  80138c:	74 0a                	je     801398 <set_pgfault_handler+0x19>
			panic("set_pgfault_handler: sys_env_set_pgfault_upcall fail, ret:%d", ret);
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80138e:	8b 45 08             	mov    0x8(%ebp),%eax
  801391:	a3 08 20 80 00       	mov    %eax,0x802008
}
  801396:	c9                   	leave  
  801397:	c3                   	ret    
		ret = sys_page_alloc((envid_t)0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W);
  801398:	83 ec 04             	sub    $0x4,%esp
  80139b:	6a 07                	push   $0x7
  80139d:	68 00 f0 bf ee       	push   $0xeebff000
  8013a2:	6a 00                	push   $0x0
  8013a4:	e8 42 f9 ff ff       	call   800ceb <sys_page_alloc>
		if(ret < 0){
  8013a9:	83 c4 10             	add    $0x10,%esp
  8013ac:	85 c0                	test   %eax,%eax
  8013ae:	78 28                	js     8013d8 <set_pgfault_handler+0x59>
    	ret = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  8013b0:	83 ec 08             	sub    $0x8,%esp
  8013b3:	68 ea 13 80 00       	push   $0x8013ea
  8013b8:	6a 00                	push   $0x0
  8013ba:	e8 77 fa ff ff       	call   800e36 <sys_env_set_pgfault_upcall>
		if(ret < 0){
  8013bf:	83 c4 10             	add    $0x10,%esp
  8013c2:	85 c0                	test   %eax,%eax
  8013c4:	79 c8                	jns    80138e <set_pgfault_handler+0xf>
			panic("set_pgfault_handler: sys_env_set_pgfault_upcall fail, ret:%d", ret);
  8013c6:	50                   	push   %eax
  8013c7:	68 68 1c 80 00       	push   $0x801c68
  8013cc:	6a 28                	push   $0x28
  8013ce:	68 a8 1c 80 00       	push   $0x801ca8
  8013d3:	e8 61 ff ff ff       	call   801339 <_panic>
			panic("set_pgfault_handler: sys_page_alloc fail, ret:%d", ret);
  8013d8:	50                   	push   %eax
  8013d9:	68 34 1c 80 00       	push   $0x801c34
  8013de:	6a 24                	push   $0x24
  8013e0:	68 a8 1c 80 00       	push   $0x801ca8
  8013e5:	e8 4f ff ff ff       	call   801339 <_panic>

008013ea <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8013ea:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8013eb:	a1 08 20 80 00       	mov    0x802008,%eax
	call *%eax
  8013f0:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8013f2:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %edi
  8013f5:	8b 7c 24 28          	mov    0x28(%esp),%edi
	movl 0x30(%esp), %esi
  8013f9:	8b 74 24 30          	mov    0x30(%esp),%esi
	subl $4, %esi
  8013fd:	83 ee 04             	sub    $0x4,%esi
	movl %edi, (%esi)
  801400:	89 3e                	mov    %edi,(%esi)
	movl %esi, 0x30(%esp)
  801402:	89 74 24 30          	mov    %esi,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  801406:	83 c4 08             	add    $0x8,%esp
	popal
  801409:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  80140a:	83 c4 04             	add    $0x4,%esp
	popfl
  80140d:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80140e:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  80140f:	c3                   	ret    

00801410 <__udivdi3>:
  801410:	55                   	push   %ebp
  801411:	57                   	push   %edi
  801412:	56                   	push   %esi
  801413:	53                   	push   %ebx
  801414:	83 ec 1c             	sub    $0x1c,%esp
  801417:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80141b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80141f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801423:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801427:	85 d2                	test   %edx,%edx
  801429:	75 4d                	jne    801478 <__udivdi3+0x68>
  80142b:	39 f3                	cmp    %esi,%ebx
  80142d:	76 19                	jbe    801448 <__udivdi3+0x38>
  80142f:	31 ff                	xor    %edi,%edi
  801431:	89 e8                	mov    %ebp,%eax
  801433:	89 f2                	mov    %esi,%edx
  801435:	f7 f3                	div    %ebx
  801437:	89 fa                	mov    %edi,%edx
  801439:	83 c4 1c             	add    $0x1c,%esp
  80143c:	5b                   	pop    %ebx
  80143d:	5e                   	pop    %esi
  80143e:	5f                   	pop    %edi
  80143f:	5d                   	pop    %ebp
  801440:	c3                   	ret    
  801441:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801448:	89 d9                	mov    %ebx,%ecx
  80144a:	85 db                	test   %ebx,%ebx
  80144c:	75 0b                	jne    801459 <__udivdi3+0x49>
  80144e:	b8 01 00 00 00       	mov    $0x1,%eax
  801453:	31 d2                	xor    %edx,%edx
  801455:	f7 f3                	div    %ebx
  801457:	89 c1                	mov    %eax,%ecx
  801459:	31 d2                	xor    %edx,%edx
  80145b:	89 f0                	mov    %esi,%eax
  80145d:	f7 f1                	div    %ecx
  80145f:	89 c6                	mov    %eax,%esi
  801461:	89 e8                	mov    %ebp,%eax
  801463:	89 f7                	mov    %esi,%edi
  801465:	f7 f1                	div    %ecx
  801467:	89 fa                	mov    %edi,%edx
  801469:	83 c4 1c             	add    $0x1c,%esp
  80146c:	5b                   	pop    %ebx
  80146d:	5e                   	pop    %esi
  80146e:	5f                   	pop    %edi
  80146f:	5d                   	pop    %ebp
  801470:	c3                   	ret    
  801471:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801478:	39 f2                	cmp    %esi,%edx
  80147a:	77 1c                	ja     801498 <__udivdi3+0x88>
  80147c:	0f bd fa             	bsr    %edx,%edi
  80147f:	83 f7 1f             	xor    $0x1f,%edi
  801482:	75 2c                	jne    8014b0 <__udivdi3+0xa0>
  801484:	39 f2                	cmp    %esi,%edx
  801486:	72 06                	jb     80148e <__udivdi3+0x7e>
  801488:	31 c0                	xor    %eax,%eax
  80148a:	39 eb                	cmp    %ebp,%ebx
  80148c:	77 a9                	ja     801437 <__udivdi3+0x27>
  80148e:	b8 01 00 00 00       	mov    $0x1,%eax
  801493:	eb a2                	jmp    801437 <__udivdi3+0x27>
  801495:	8d 76 00             	lea    0x0(%esi),%esi
  801498:	31 ff                	xor    %edi,%edi
  80149a:	31 c0                	xor    %eax,%eax
  80149c:	89 fa                	mov    %edi,%edx
  80149e:	83 c4 1c             	add    $0x1c,%esp
  8014a1:	5b                   	pop    %ebx
  8014a2:	5e                   	pop    %esi
  8014a3:	5f                   	pop    %edi
  8014a4:	5d                   	pop    %ebp
  8014a5:	c3                   	ret    
  8014a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8014ad:	8d 76 00             	lea    0x0(%esi),%esi
  8014b0:	89 f9                	mov    %edi,%ecx
  8014b2:	b8 20 00 00 00       	mov    $0x20,%eax
  8014b7:	29 f8                	sub    %edi,%eax
  8014b9:	d3 e2                	shl    %cl,%edx
  8014bb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8014bf:	89 c1                	mov    %eax,%ecx
  8014c1:	89 da                	mov    %ebx,%edx
  8014c3:	d3 ea                	shr    %cl,%edx
  8014c5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8014c9:	09 d1                	or     %edx,%ecx
  8014cb:	89 f2                	mov    %esi,%edx
  8014cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8014d1:	89 f9                	mov    %edi,%ecx
  8014d3:	d3 e3                	shl    %cl,%ebx
  8014d5:	89 c1                	mov    %eax,%ecx
  8014d7:	d3 ea                	shr    %cl,%edx
  8014d9:	89 f9                	mov    %edi,%ecx
  8014db:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8014df:	89 eb                	mov    %ebp,%ebx
  8014e1:	d3 e6                	shl    %cl,%esi
  8014e3:	89 c1                	mov    %eax,%ecx
  8014e5:	d3 eb                	shr    %cl,%ebx
  8014e7:	09 de                	or     %ebx,%esi
  8014e9:	89 f0                	mov    %esi,%eax
  8014eb:	f7 74 24 08          	divl   0x8(%esp)
  8014ef:	89 d6                	mov    %edx,%esi
  8014f1:	89 c3                	mov    %eax,%ebx
  8014f3:	f7 64 24 0c          	mull   0xc(%esp)
  8014f7:	39 d6                	cmp    %edx,%esi
  8014f9:	72 15                	jb     801510 <__udivdi3+0x100>
  8014fb:	89 f9                	mov    %edi,%ecx
  8014fd:	d3 e5                	shl    %cl,%ebp
  8014ff:	39 c5                	cmp    %eax,%ebp
  801501:	73 04                	jae    801507 <__udivdi3+0xf7>
  801503:	39 d6                	cmp    %edx,%esi
  801505:	74 09                	je     801510 <__udivdi3+0x100>
  801507:	89 d8                	mov    %ebx,%eax
  801509:	31 ff                	xor    %edi,%edi
  80150b:	e9 27 ff ff ff       	jmp    801437 <__udivdi3+0x27>
  801510:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801513:	31 ff                	xor    %edi,%edi
  801515:	e9 1d ff ff ff       	jmp    801437 <__udivdi3+0x27>
  80151a:	66 90                	xchg   %ax,%ax
  80151c:	66 90                	xchg   %ax,%ax
  80151e:	66 90                	xchg   %ax,%ax

00801520 <__umoddi3>:
  801520:	55                   	push   %ebp
  801521:	57                   	push   %edi
  801522:	56                   	push   %esi
  801523:	53                   	push   %ebx
  801524:	83 ec 1c             	sub    $0x1c,%esp
  801527:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80152b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80152f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801533:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801537:	89 da                	mov    %ebx,%edx
  801539:	85 c0                	test   %eax,%eax
  80153b:	75 43                	jne    801580 <__umoddi3+0x60>
  80153d:	39 df                	cmp    %ebx,%edi
  80153f:	76 17                	jbe    801558 <__umoddi3+0x38>
  801541:	89 f0                	mov    %esi,%eax
  801543:	f7 f7                	div    %edi
  801545:	89 d0                	mov    %edx,%eax
  801547:	31 d2                	xor    %edx,%edx
  801549:	83 c4 1c             	add    $0x1c,%esp
  80154c:	5b                   	pop    %ebx
  80154d:	5e                   	pop    %esi
  80154e:	5f                   	pop    %edi
  80154f:	5d                   	pop    %ebp
  801550:	c3                   	ret    
  801551:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801558:	89 fd                	mov    %edi,%ebp
  80155a:	85 ff                	test   %edi,%edi
  80155c:	75 0b                	jne    801569 <__umoddi3+0x49>
  80155e:	b8 01 00 00 00       	mov    $0x1,%eax
  801563:	31 d2                	xor    %edx,%edx
  801565:	f7 f7                	div    %edi
  801567:	89 c5                	mov    %eax,%ebp
  801569:	89 d8                	mov    %ebx,%eax
  80156b:	31 d2                	xor    %edx,%edx
  80156d:	f7 f5                	div    %ebp
  80156f:	89 f0                	mov    %esi,%eax
  801571:	f7 f5                	div    %ebp
  801573:	89 d0                	mov    %edx,%eax
  801575:	eb d0                	jmp    801547 <__umoddi3+0x27>
  801577:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80157e:	66 90                	xchg   %ax,%ax
  801580:	89 f1                	mov    %esi,%ecx
  801582:	39 d8                	cmp    %ebx,%eax
  801584:	76 0a                	jbe    801590 <__umoddi3+0x70>
  801586:	89 f0                	mov    %esi,%eax
  801588:	83 c4 1c             	add    $0x1c,%esp
  80158b:	5b                   	pop    %ebx
  80158c:	5e                   	pop    %esi
  80158d:	5f                   	pop    %edi
  80158e:	5d                   	pop    %ebp
  80158f:	c3                   	ret    
  801590:	0f bd e8             	bsr    %eax,%ebp
  801593:	83 f5 1f             	xor    $0x1f,%ebp
  801596:	75 20                	jne    8015b8 <__umoddi3+0x98>
  801598:	39 d8                	cmp    %ebx,%eax
  80159a:	0f 82 b0 00 00 00    	jb     801650 <__umoddi3+0x130>
  8015a0:	39 f7                	cmp    %esi,%edi
  8015a2:	0f 86 a8 00 00 00    	jbe    801650 <__umoddi3+0x130>
  8015a8:	89 c8                	mov    %ecx,%eax
  8015aa:	83 c4 1c             	add    $0x1c,%esp
  8015ad:	5b                   	pop    %ebx
  8015ae:	5e                   	pop    %esi
  8015af:	5f                   	pop    %edi
  8015b0:	5d                   	pop    %ebp
  8015b1:	c3                   	ret    
  8015b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8015b8:	89 e9                	mov    %ebp,%ecx
  8015ba:	ba 20 00 00 00       	mov    $0x20,%edx
  8015bf:	29 ea                	sub    %ebp,%edx
  8015c1:	d3 e0                	shl    %cl,%eax
  8015c3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8015c7:	89 d1                	mov    %edx,%ecx
  8015c9:	89 f8                	mov    %edi,%eax
  8015cb:	d3 e8                	shr    %cl,%eax
  8015cd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8015d1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8015d5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8015d9:	09 c1                	or     %eax,%ecx
  8015db:	89 d8                	mov    %ebx,%eax
  8015dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8015e1:	89 e9                	mov    %ebp,%ecx
  8015e3:	d3 e7                	shl    %cl,%edi
  8015e5:	89 d1                	mov    %edx,%ecx
  8015e7:	d3 e8                	shr    %cl,%eax
  8015e9:	89 e9                	mov    %ebp,%ecx
  8015eb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8015ef:	d3 e3                	shl    %cl,%ebx
  8015f1:	89 c7                	mov    %eax,%edi
  8015f3:	89 d1                	mov    %edx,%ecx
  8015f5:	89 f0                	mov    %esi,%eax
  8015f7:	d3 e8                	shr    %cl,%eax
  8015f9:	89 e9                	mov    %ebp,%ecx
  8015fb:	89 fa                	mov    %edi,%edx
  8015fd:	d3 e6                	shl    %cl,%esi
  8015ff:	09 d8                	or     %ebx,%eax
  801601:	f7 74 24 08          	divl   0x8(%esp)
  801605:	89 d1                	mov    %edx,%ecx
  801607:	89 f3                	mov    %esi,%ebx
  801609:	f7 64 24 0c          	mull   0xc(%esp)
  80160d:	89 c6                	mov    %eax,%esi
  80160f:	89 d7                	mov    %edx,%edi
  801611:	39 d1                	cmp    %edx,%ecx
  801613:	72 06                	jb     80161b <__umoddi3+0xfb>
  801615:	75 10                	jne    801627 <__umoddi3+0x107>
  801617:	39 c3                	cmp    %eax,%ebx
  801619:	73 0c                	jae    801627 <__umoddi3+0x107>
  80161b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80161f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801623:	89 d7                	mov    %edx,%edi
  801625:	89 c6                	mov    %eax,%esi
  801627:	89 ca                	mov    %ecx,%edx
  801629:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80162e:	29 f3                	sub    %esi,%ebx
  801630:	19 fa                	sbb    %edi,%edx
  801632:	89 d0                	mov    %edx,%eax
  801634:	d3 e0                	shl    %cl,%eax
  801636:	89 e9                	mov    %ebp,%ecx
  801638:	d3 eb                	shr    %cl,%ebx
  80163a:	d3 ea                	shr    %cl,%edx
  80163c:	09 d8                	or     %ebx,%eax
  80163e:	83 c4 1c             	add    $0x1c,%esp
  801641:	5b                   	pop    %ebx
  801642:	5e                   	pop    %esi
  801643:	5f                   	pop    %edi
  801644:	5d                   	pop    %ebp
  801645:	c3                   	ret    
  801646:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80164d:	8d 76 00             	lea    0x0(%esi),%esi
  801650:	89 da                	mov    %ebx,%edx
  801652:	29 fe                	sub    %edi,%esi
  801654:	19 c2                	sbb    %eax,%edx
  801656:	89 f1                	mov    %esi,%ecx
  801658:	89 c8                	mov    %ecx,%eax
  80165a:	e9 4b ff ff ff       	jmp    8015aa <__umoddi3+0x8a>
