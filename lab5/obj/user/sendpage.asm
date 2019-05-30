
obj/user/sendpage.debug:     file format elf32-i386


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
  80002c:	e8 73 01 00 00       	call   8001a4 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#define TEMP_ADDR	((char*)0xa00000)
#define TEMP_ADDR_CHILD	((char*)0xb00000)

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 18             	sub    $0x18,%esp
	envid_t who;

	if ((who = fork()) == 0) {
  800039:	e8 9c 10 00 00       	call   8010da <fork>
  80003e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800041:	85 c0                	test   %eax,%eax
  800043:	0f 84 a5 00 00 00    	je     8000ee <umain+0xbb>
		ipc_send(who, 0, TEMP_ADDR_CHILD, PTE_P | PTE_W | PTE_U);
		return;
	}

	// Parent
	sys_page_alloc(thisenv->env_id, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
  800049:	a1 0c 20 80 00       	mov    0x80200c,%eax
  80004e:	8b 40 48             	mov    0x48(%eax),%eax
  800051:	83 ec 04             	sub    $0x4,%esp
  800054:	6a 07                	push   $0x7
  800056:	68 00 00 a0 00       	push   $0xa00000
  80005b:	50                   	push   %eax
  80005c:	e8 4b 0d 00 00       	call   800dac <sys_page_alloc>
	memcpy(TEMP_ADDR, str1, strlen(str1) + 1);
  800061:	83 c4 04             	add    $0x4,%esp
  800064:	ff 35 04 20 80 00    	pushl  0x802004
  80006a:	e8 12 09 00 00       	call   800981 <strlen>
  80006f:	83 c4 0c             	add    $0xc,%esp
  800072:	83 c0 01             	add    $0x1,%eax
  800075:	50                   	push   %eax
  800076:	ff 35 04 20 80 00    	pushl  0x802004
  80007c:	68 00 00 a0 00       	push   $0xa00000
  800081:	e8 24 0b 00 00       	call   800baa <memcpy>
	ipc_send(who, 0, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
  800086:	6a 07                	push   $0x7
  800088:	68 00 00 a0 00       	push   $0xa00000
  80008d:	6a 00                	push   $0x0
  80008f:	ff 75 f4             	pushl  -0xc(%ebp)
  800092:	e8 cc 13 00 00       	call   801463 <ipc_send>

	ipc_recv(&who, TEMP_ADDR, 0);
  800097:	83 c4 1c             	add    $0x1c,%esp
  80009a:	6a 00                	push   $0x0
  80009c:	68 00 00 a0 00       	push   $0xa00000
  8000a1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000a4:	50                   	push   %eax
  8000a5:	e8 50 13 00 00       	call   8013fa <ipc_recv>
	cprintf("%x got message: %s\n", who, TEMP_ADDR);
  8000aa:	83 c4 0c             	add    $0xc,%esp
  8000ad:	68 00 00 a0 00       	push   $0xa00000
  8000b2:	ff 75 f4             	pushl  -0xc(%ebp)
  8000b5:	68 20 18 80 00       	push   $0x801820
  8000ba:	e8 d5 01 00 00       	call   800294 <cprintf>
	if (strncmp(TEMP_ADDR, str2, strlen(str2)) == 0)
  8000bf:	83 c4 04             	add    $0x4,%esp
  8000c2:	ff 35 00 20 80 00    	pushl  0x802000
  8000c8:	e8 b4 08 00 00       	call   800981 <strlen>
  8000cd:	83 c4 0c             	add    $0xc,%esp
  8000d0:	50                   	push   %eax
  8000d1:	ff 35 00 20 80 00    	pushl  0x802000
  8000d7:	68 00 00 a0 00       	push   $0xa00000
  8000dc:	e8 aa 09 00 00       	call   800a8b <strncmp>
  8000e1:	83 c4 10             	add    $0x10,%esp
  8000e4:	85 c0                	test   %eax,%eax
  8000e6:	0f 84 a3 00 00 00    	je     80018f <umain+0x15c>
		cprintf("parent received correct message\n");
	return;
}
  8000ec:	c9                   	leave  
  8000ed:	c3                   	ret    
		ipc_recv(&who, TEMP_ADDR_CHILD, 0);
  8000ee:	83 ec 04             	sub    $0x4,%esp
  8000f1:	6a 00                	push   $0x0
  8000f3:	68 00 00 b0 00       	push   $0xb00000
  8000f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000fb:	50                   	push   %eax
  8000fc:	e8 f9 12 00 00       	call   8013fa <ipc_recv>
		cprintf("%x got message: %s\n", who, TEMP_ADDR_CHILD);
  800101:	83 c4 0c             	add    $0xc,%esp
  800104:	68 00 00 b0 00       	push   $0xb00000
  800109:	ff 75 f4             	pushl  -0xc(%ebp)
  80010c:	68 20 18 80 00       	push   $0x801820
  800111:	e8 7e 01 00 00       	call   800294 <cprintf>
		if (strncmp(TEMP_ADDR_CHILD, str1, strlen(str1)) == 0)
  800116:	83 c4 04             	add    $0x4,%esp
  800119:	ff 35 04 20 80 00    	pushl  0x802004
  80011f:	e8 5d 08 00 00       	call   800981 <strlen>
  800124:	83 c4 0c             	add    $0xc,%esp
  800127:	50                   	push   %eax
  800128:	ff 35 04 20 80 00    	pushl  0x802004
  80012e:	68 00 00 b0 00       	push   $0xb00000
  800133:	e8 53 09 00 00       	call   800a8b <strncmp>
  800138:	83 c4 10             	add    $0x10,%esp
  80013b:	85 c0                	test   %eax,%eax
  80013d:	74 3e                	je     80017d <umain+0x14a>
		memcpy(TEMP_ADDR_CHILD, str2, strlen(str2) + 1);
  80013f:	83 ec 0c             	sub    $0xc,%esp
  800142:	ff 35 00 20 80 00    	pushl  0x802000
  800148:	e8 34 08 00 00       	call   800981 <strlen>
  80014d:	83 c4 0c             	add    $0xc,%esp
  800150:	83 c0 01             	add    $0x1,%eax
  800153:	50                   	push   %eax
  800154:	ff 35 00 20 80 00    	pushl  0x802000
  80015a:	68 00 00 b0 00       	push   $0xb00000
  80015f:	e8 46 0a 00 00       	call   800baa <memcpy>
		ipc_send(who, 0, TEMP_ADDR_CHILD, PTE_P | PTE_W | PTE_U);
  800164:	6a 07                	push   $0x7
  800166:	68 00 00 b0 00       	push   $0xb00000
  80016b:	6a 00                	push   $0x0
  80016d:	ff 75 f4             	pushl  -0xc(%ebp)
  800170:	e8 ee 12 00 00       	call   801463 <ipc_send>
		return;
  800175:	83 c4 20             	add    $0x20,%esp
  800178:	e9 6f ff ff ff       	jmp    8000ec <umain+0xb9>
			cprintf("child received correct message\n");
  80017d:	83 ec 0c             	sub    $0xc,%esp
  800180:	68 34 18 80 00       	push   $0x801834
  800185:	e8 0a 01 00 00       	call   800294 <cprintf>
  80018a:	83 c4 10             	add    $0x10,%esp
  80018d:	eb b0                	jmp    80013f <umain+0x10c>
		cprintf("parent received correct message\n");
  80018f:	83 ec 0c             	sub    $0xc,%esp
  800192:	68 54 18 80 00       	push   $0x801854
  800197:	e8 f8 00 00 00       	call   800294 <cprintf>
  80019c:	83 c4 10             	add    $0x10,%esp
  80019f:	e9 48 ff ff ff       	jmp    8000ec <umain+0xb9>

008001a4 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001a4:	55                   	push   %ebp
  8001a5:	89 e5                	mov    %esp,%ebp
  8001a7:	56                   	push   %esi
  8001a8:	53                   	push   %ebx
  8001a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001ac:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	// thisenv = 0;
	thisenv = &(envs[ENVX(sys_getenvid())]);
  8001af:	e8 ba 0b 00 00       	call   800d6e <sys_getenvid>
  8001b4:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001b9:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8001bf:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001c4:	a3 0c 20 80 00       	mov    %eax,0x80200c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001c9:	85 db                	test   %ebx,%ebx
  8001cb:	7e 07                	jle    8001d4 <libmain+0x30>
		binaryname = argv[0];
  8001cd:	8b 06                	mov    (%esi),%eax
  8001cf:	a3 08 20 80 00       	mov    %eax,0x802008

	// call user main routine
	umain(argc, argv);
  8001d4:	83 ec 08             	sub    $0x8,%esp
  8001d7:	56                   	push   %esi
  8001d8:	53                   	push   %ebx
  8001d9:	e8 55 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8001de:	e8 0a 00 00 00       	call   8001ed <exit>
}
  8001e3:	83 c4 10             	add    $0x10,%esp
  8001e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001e9:	5b                   	pop    %ebx
  8001ea:	5e                   	pop    %esi
  8001eb:	5d                   	pop    %ebp
  8001ec:	c3                   	ret    

008001ed <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001ed:	55                   	push   %ebp
  8001ee:	89 e5                	mov    %esp,%ebp
  8001f0:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  8001f3:	6a 00                	push   $0x0
  8001f5:	e8 33 0b 00 00       	call   800d2d <sys_env_destroy>
}
  8001fa:	83 c4 10             	add    $0x10,%esp
  8001fd:	c9                   	leave  
  8001fe:	c3                   	ret    

008001ff <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001ff:	55                   	push   %ebp
  800200:	89 e5                	mov    %esp,%ebp
  800202:	53                   	push   %ebx
  800203:	83 ec 04             	sub    $0x4,%esp
  800206:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800209:	8b 13                	mov    (%ebx),%edx
  80020b:	8d 42 01             	lea    0x1(%edx),%eax
  80020e:	89 03                	mov    %eax,(%ebx)
  800210:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800213:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800217:	3d ff 00 00 00       	cmp    $0xff,%eax
  80021c:	74 09                	je     800227 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80021e:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800222:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800225:	c9                   	leave  
  800226:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800227:	83 ec 08             	sub    $0x8,%esp
  80022a:	68 ff 00 00 00       	push   $0xff
  80022f:	8d 43 08             	lea    0x8(%ebx),%eax
  800232:	50                   	push   %eax
  800233:	e8 b8 0a 00 00       	call   800cf0 <sys_cputs>
		b->idx = 0;
  800238:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80023e:	83 c4 10             	add    $0x10,%esp
  800241:	eb db                	jmp    80021e <putch+0x1f>

00800243 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800243:	55                   	push   %ebp
  800244:	89 e5                	mov    %esp,%ebp
  800246:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80024c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800253:	00 00 00 
	b.cnt = 0;
  800256:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80025d:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800260:	ff 75 0c             	pushl  0xc(%ebp)
  800263:	ff 75 08             	pushl  0x8(%ebp)
  800266:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80026c:	50                   	push   %eax
  80026d:	68 ff 01 80 00       	push   $0x8001ff
  800272:	e8 4a 01 00 00       	call   8003c1 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800277:	83 c4 08             	add    $0x8,%esp
  80027a:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800280:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800286:	50                   	push   %eax
  800287:	e8 64 0a 00 00       	call   800cf0 <sys_cputs>

	return b.cnt;
}
  80028c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800292:	c9                   	leave  
  800293:	c3                   	ret    

00800294 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800294:	55                   	push   %ebp
  800295:	89 e5                	mov    %esp,%ebp
  800297:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80029a:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80029d:	50                   	push   %eax
  80029e:	ff 75 08             	pushl  0x8(%ebp)
  8002a1:	e8 9d ff ff ff       	call   800243 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002a6:	c9                   	leave  
  8002a7:	c3                   	ret    

008002a8 <printnum>:


static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002a8:	55                   	push   %ebp
  8002a9:	89 e5                	mov    %esp,%ebp
  8002ab:	57                   	push   %edi
  8002ac:	56                   	push   %esi
  8002ad:	53                   	push   %ebx
  8002ae:	83 ec 1c             	sub    $0x1c,%esp
  8002b1:	89 c6                	mov    %eax,%esi
  8002b3:	89 d7                	mov    %edx,%edi
  8002b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002be:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8002c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8002c4:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	// to support '-'
	if(padc == '-'){
  8002c7:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8002cb:	74 2c                	je     8002f9 <printnum+0x51>
		while (--width > 0)
			putch(' ', putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002cd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002d0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8002d7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002da:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8002dd:	39 c2                	cmp    %eax,%edx
  8002df:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8002e2:	73 43                	jae    800327 <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8002e4:	83 eb 01             	sub    $0x1,%ebx
  8002e7:	85 db                	test   %ebx,%ebx
  8002e9:	7e 6c                	jle    800357 <printnum+0xaf>
			putch(padc, putdat);
  8002eb:	83 ec 08             	sub    $0x8,%esp
  8002ee:	57                   	push   %edi
  8002ef:	ff 75 18             	pushl  0x18(%ebp)
  8002f2:	ff d6                	call   *%esi
  8002f4:	83 c4 10             	add    $0x10,%esp
  8002f7:	eb eb                	jmp    8002e4 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8002f9:	83 ec 0c             	sub    $0xc,%esp
  8002fc:	6a 20                	push   $0x20
  8002fe:	6a 00                	push   $0x0
  800300:	50                   	push   %eax
  800301:	ff 75 e4             	pushl  -0x1c(%ebp)
  800304:	ff 75 e0             	pushl  -0x20(%ebp)
  800307:	89 fa                	mov    %edi,%edx
  800309:	89 f0                	mov    %esi,%eax
  80030b:	e8 98 ff ff ff       	call   8002a8 <printnum>
		while (--width > 0)
  800310:	83 c4 20             	add    $0x20,%esp
  800313:	83 eb 01             	sub    $0x1,%ebx
  800316:	85 db                	test   %ebx,%ebx
  800318:	7e 65                	jle    80037f <printnum+0xd7>
			putch(' ', putdat);
  80031a:	83 ec 08             	sub    $0x8,%esp
  80031d:	57                   	push   %edi
  80031e:	6a 20                	push   $0x20
  800320:	ff d6                	call   *%esi
  800322:	83 c4 10             	add    $0x10,%esp
  800325:	eb ec                	jmp    800313 <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800327:	83 ec 0c             	sub    $0xc,%esp
  80032a:	ff 75 18             	pushl  0x18(%ebp)
  80032d:	83 eb 01             	sub    $0x1,%ebx
  800330:	53                   	push   %ebx
  800331:	50                   	push   %eax
  800332:	83 ec 08             	sub    $0x8,%esp
  800335:	ff 75 dc             	pushl  -0x24(%ebp)
  800338:	ff 75 d8             	pushl  -0x28(%ebp)
  80033b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80033e:	ff 75 e0             	pushl  -0x20(%ebp)
  800341:	e8 8a 12 00 00       	call   8015d0 <__udivdi3>
  800346:	83 c4 18             	add    $0x18,%esp
  800349:	52                   	push   %edx
  80034a:	50                   	push   %eax
  80034b:	89 fa                	mov    %edi,%edx
  80034d:	89 f0                	mov    %esi,%eax
  80034f:	e8 54 ff ff ff       	call   8002a8 <printnum>
  800354:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800357:	83 ec 08             	sub    $0x8,%esp
  80035a:	57                   	push   %edi
  80035b:	83 ec 04             	sub    $0x4,%esp
  80035e:	ff 75 dc             	pushl  -0x24(%ebp)
  800361:	ff 75 d8             	pushl  -0x28(%ebp)
  800364:	ff 75 e4             	pushl  -0x1c(%ebp)
  800367:	ff 75 e0             	pushl  -0x20(%ebp)
  80036a:	e8 71 13 00 00       	call   8016e0 <__umoddi3>
  80036f:	83 c4 14             	add    $0x14,%esp
  800372:	0f be 80 cc 18 80 00 	movsbl 0x8018cc(%eax),%eax
  800379:	50                   	push   %eax
  80037a:	ff d6                	call   *%esi
  80037c:	83 c4 10             	add    $0x10,%esp
}
  80037f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800382:	5b                   	pop    %ebx
  800383:	5e                   	pop    %esi
  800384:	5f                   	pop    %edi
  800385:	5d                   	pop    %ebp
  800386:	c3                   	ret    

00800387 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800387:	55                   	push   %ebp
  800388:	89 e5                	mov    %esp,%ebp
  80038a:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80038d:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800391:	8b 10                	mov    (%eax),%edx
  800393:	3b 50 04             	cmp    0x4(%eax),%edx
  800396:	73 0a                	jae    8003a2 <sprintputch+0x1b>
		*b->buf++ = ch;
  800398:	8d 4a 01             	lea    0x1(%edx),%ecx
  80039b:	89 08                	mov    %ecx,(%eax)
  80039d:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a0:	88 02                	mov    %al,(%edx)
}
  8003a2:	5d                   	pop    %ebp
  8003a3:	c3                   	ret    

008003a4 <printfmt>:
{
  8003a4:	55                   	push   %ebp
  8003a5:	89 e5                	mov    %esp,%ebp
  8003a7:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003aa:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003ad:	50                   	push   %eax
  8003ae:	ff 75 10             	pushl  0x10(%ebp)
  8003b1:	ff 75 0c             	pushl  0xc(%ebp)
  8003b4:	ff 75 08             	pushl  0x8(%ebp)
  8003b7:	e8 05 00 00 00       	call   8003c1 <vprintfmt>
}
  8003bc:	83 c4 10             	add    $0x10,%esp
  8003bf:	c9                   	leave  
  8003c0:	c3                   	ret    

008003c1 <vprintfmt>:
{
  8003c1:	55                   	push   %ebp
  8003c2:	89 e5                	mov    %esp,%ebp
  8003c4:	57                   	push   %edi
  8003c5:	56                   	push   %esi
  8003c6:	53                   	push   %ebx
  8003c7:	83 ec 3c             	sub    $0x3c,%esp
  8003ca:	8b 75 08             	mov    0x8(%ebp),%esi
  8003cd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8003d0:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003d3:	e9 1e 04 00 00       	jmp    8007f6 <vprintfmt+0x435>
		posflag = 0;
  8003d8:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
		padc = ' ';
  8003df:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8003e3:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8003ea:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8003f1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003f8:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  8003ff:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800404:	8d 47 01             	lea    0x1(%edi),%eax
  800407:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80040a:	0f b6 17             	movzbl (%edi),%edx
  80040d:	8d 42 dd             	lea    -0x23(%edx),%eax
  800410:	3c 55                	cmp    $0x55,%al
  800412:	0f 87 d9 04 00 00    	ja     8008f1 <vprintfmt+0x530>
  800418:	0f b6 c0             	movzbl %al,%eax
  80041b:	ff 24 85 a0 1a 80 00 	jmp    *0x801aa0(,%eax,4)
  800422:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800425:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800429:	eb d9                	jmp    800404 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80042b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posflag = 1;
  80042e:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  800435:	eb cd                	jmp    800404 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800437:	0f b6 d2             	movzbl %dl,%edx
  80043a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80043d:	b8 00 00 00 00       	mov    $0x0,%eax
  800442:	89 75 08             	mov    %esi,0x8(%ebp)
  800445:	eb 0c                	jmp    800453 <vprintfmt+0x92>
		switch (ch = *(unsigned char *) fmt++) {
  800447:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80044a:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  80044e:	eb b4                	jmp    800404 <vprintfmt+0x43>
			for (precision = 0; ; ++fmt) {
  800450:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800453:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800456:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80045a:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80045d:	8d 72 d0             	lea    -0x30(%edx),%esi
  800460:	83 fe 09             	cmp    $0x9,%esi
  800463:	76 eb                	jbe    800450 <vprintfmt+0x8f>
  800465:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800468:	8b 75 08             	mov    0x8(%ebp),%esi
  80046b:	eb 14                	jmp    800481 <vprintfmt+0xc0>
			precision = va_arg(ap, int);
  80046d:	8b 45 14             	mov    0x14(%ebp),%eax
  800470:	8b 00                	mov    (%eax),%eax
  800472:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800475:	8b 45 14             	mov    0x14(%ebp),%eax
  800478:	8d 40 04             	lea    0x4(%eax),%eax
  80047b:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80047e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800481:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800485:	0f 89 79 ff ff ff    	jns    800404 <vprintfmt+0x43>
				width = precision, precision = -1;
  80048b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80048e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800491:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800498:	e9 67 ff ff ff       	jmp    800404 <vprintfmt+0x43>
  80049d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004a0:	85 c0                	test   %eax,%eax
  8004a2:	0f 48 c1             	cmovs  %ecx,%eax
  8004a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004a8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004ab:	e9 54 ff ff ff       	jmp    800404 <vprintfmt+0x43>
  8004b0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8004b3:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8004ba:	e9 45 ff ff ff       	jmp    800404 <vprintfmt+0x43>
			lflag++;
  8004bf:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004c3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004c6:	e9 39 ff ff ff       	jmp    800404 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8004cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ce:	8d 78 04             	lea    0x4(%eax),%edi
  8004d1:	83 ec 08             	sub    $0x8,%esp
  8004d4:	53                   	push   %ebx
  8004d5:	ff 30                	pushl  (%eax)
  8004d7:	ff d6                	call   *%esi
			break;
  8004d9:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004dc:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8004df:	e9 0f 03 00 00       	jmp    8007f3 <vprintfmt+0x432>
			err = va_arg(ap, int);
  8004e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e7:	8d 78 04             	lea    0x4(%eax),%edi
  8004ea:	8b 00                	mov    (%eax),%eax
  8004ec:	99                   	cltd   
  8004ed:	31 d0                	xor    %edx,%eax
  8004ef:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004f1:	83 f8 0f             	cmp    $0xf,%eax
  8004f4:	7f 23                	jg     800519 <vprintfmt+0x158>
  8004f6:	8b 14 85 00 1c 80 00 	mov    0x801c00(,%eax,4),%edx
  8004fd:	85 d2                	test   %edx,%edx
  8004ff:	74 18                	je     800519 <vprintfmt+0x158>
				printfmt(putch, putdat, "%s", p);
  800501:	52                   	push   %edx
  800502:	68 ed 18 80 00       	push   $0x8018ed
  800507:	53                   	push   %ebx
  800508:	56                   	push   %esi
  800509:	e8 96 fe ff ff       	call   8003a4 <printfmt>
  80050e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800511:	89 7d 14             	mov    %edi,0x14(%ebp)
  800514:	e9 da 02 00 00       	jmp    8007f3 <vprintfmt+0x432>
				printfmt(putch, putdat, "error %d", err);
  800519:	50                   	push   %eax
  80051a:	68 e4 18 80 00       	push   $0x8018e4
  80051f:	53                   	push   %ebx
  800520:	56                   	push   %esi
  800521:	e8 7e fe ff ff       	call   8003a4 <printfmt>
  800526:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800529:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80052c:	e9 c2 02 00 00       	jmp    8007f3 <vprintfmt+0x432>
			if ((p = va_arg(ap, char *)) == NULL)
  800531:	8b 45 14             	mov    0x14(%ebp),%eax
  800534:	83 c0 04             	add    $0x4,%eax
  800537:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80053a:	8b 45 14             	mov    0x14(%ebp),%eax
  80053d:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80053f:	85 c9                	test   %ecx,%ecx
  800541:	b8 dd 18 80 00       	mov    $0x8018dd,%eax
  800546:	0f 45 c1             	cmovne %ecx,%eax
  800549:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80054c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800550:	7e 06                	jle    800558 <vprintfmt+0x197>
  800552:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800556:	75 0d                	jne    800565 <vprintfmt+0x1a4>
				for (width -= strnlen(p, precision); width > 0; width--)
  800558:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80055b:	89 c7                	mov    %eax,%edi
  80055d:	03 45 e0             	add    -0x20(%ebp),%eax
  800560:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800563:	eb 53                	jmp    8005b8 <vprintfmt+0x1f7>
  800565:	83 ec 08             	sub    $0x8,%esp
  800568:	ff 75 d8             	pushl  -0x28(%ebp)
  80056b:	50                   	push   %eax
  80056c:	e8 28 04 00 00       	call   800999 <strnlen>
  800571:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800574:	29 c1                	sub    %eax,%ecx
  800576:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  800579:	83 c4 10             	add    $0x10,%esp
  80057c:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  80057e:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800582:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800585:	eb 0f                	jmp    800596 <vprintfmt+0x1d5>
					putch(padc, putdat);
  800587:	83 ec 08             	sub    $0x8,%esp
  80058a:	53                   	push   %ebx
  80058b:	ff 75 e0             	pushl  -0x20(%ebp)
  80058e:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800590:	83 ef 01             	sub    $0x1,%edi
  800593:	83 c4 10             	add    $0x10,%esp
  800596:	85 ff                	test   %edi,%edi
  800598:	7f ed                	jg     800587 <vprintfmt+0x1c6>
  80059a:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  80059d:	85 c9                	test   %ecx,%ecx
  80059f:	b8 00 00 00 00       	mov    $0x0,%eax
  8005a4:	0f 49 c1             	cmovns %ecx,%eax
  8005a7:	29 c1                	sub    %eax,%ecx
  8005a9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8005ac:	eb aa                	jmp    800558 <vprintfmt+0x197>
					putch(ch, putdat);
  8005ae:	83 ec 08             	sub    $0x8,%esp
  8005b1:	53                   	push   %ebx
  8005b2:	52                   	push   %edx
  8005b3:	ff d6                	call   *%esi
  8005b5:	83 c4 10             	add    $0x10,%esp
  8005b8:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005bb:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005bd:	83 c7 01             	add    $0x1,%edi
  8005c0:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005c4:	0f be d0             	movsbl %al,%edx
  8005c7:	85 d2                	test   %edx,%edx
  8005c9:	74 4b                	je     800616 <vprintfmt+0x255>
  8005cb:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005cf:	78 06                	js     8005d7 <vprintfmt+0x216>
  8005d1:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8005d5:	78 1e                	js     8005f5 <vprintfmt+0x234>
				if (altflag && (ch < ' ' || ch > '~'))
  8005d7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005db:	74 d1                	je     8005ae <vprintfmt+0x1ed>
  8005dd:	0f be c0             	movsbl %al,%eax
  8005e0:	83 e8 20             	sub    $0x20,%eax
  8005e3:	83 f8 5e             	cmp    $0x5e,%eax
  8005e6:	76 c6                	jbe    8005ae <vprintfmt+0x1ed>
					putch('?', putdat);
  8005e8:	83 ec 08             	sub    $0x8,%esp
  8005eb:	53                   	push   %ebx
  8005ec:	6a 3f                	push   $0x3f
  8005ee:	ff d6                	call   *%esi
  8005f0:	83 c4 10             	add    $0x10,%esp
  8005f3:	eb c3                	jmp    8005b8 <vprintfmt+0x1f7>
  8005f5:	89 cf                	mov    %ecx,%edi
  8005f7:	eb 0e                	jmp    800607 <vprintfmt+0x246>
				putch(' ', putdat);
  8005f9:	83 ec 08             	sub    $0x8,%esp
  8005fc:	53                   	push   %ebx
  8005fd:	6a 20                	push   $0x20
  8005ff:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800601:	83 ef 01             	sub    $0x1,%edi
  800604:	83 c4 10             	add    $0x10,%esp
  800607:	85 ff                	test   %edi,%edi
  800609:	7f ee                	jg     8005f9 <vprintfmt+0x238>
			if ((p = va_arg(ap, char *)) == NULL)
  80060b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80060e:	89 45 14             	mov    %eax,0x14(%ebp)
  800611:	e9 dd 01 00 00       	jmp    8007f3 <vprintfmt+0x432>
  800616:	89 cf                	mov    %ecx,%edi
  800618:	eb ed                	jmp    800607 <vprintfmt+0x246>
	if (lflag >= 2)
  80061a:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  80061e:	7f 21                	jg     800641 <vprintfmt+0x280>
	else if (lflag)
  800620:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800624:	74 6a                	je     800690 <vprintfmt+0x2cf>
		return va_arg(*ap, long);
  800626:	8b 45 14             	mov    0x14(%ebp),%eax
  800629:	8b 00                	mov    (%eax),%eax
  80062b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80062e:	89 c1                	mov    %eax,%ecx
  800630:	c1 f9 1f             	sar    $0x1f,%ecx
  800633:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800636:	8b 45 14             	mov    0x14(%ebp),%eax
  800639:	8d 40 04             	lea    0x4(%eax),%eax
  80063c:	89 45 14             	mov    %eax,0x14(%ebp)
  80063f:	eb 17                	jmp    800658 <vprintfmt+0x297>
		return va_arg(*ap, long long);
  800641:	8b 45 14             	mov    0x14(%ebp),%eax
  800644:	8b 50 04             	mov    0x4(%eax),%edx
  800647:	8b 00                	mov    (%eax),%eax
  800649:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80064c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80064f:	8b 45 14             	mov    0x14(%ebp),%eax
  800652:	8d 40 08             	lea    0x8(%eax),%eax
  800655:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800658:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  80065b:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800660:	85 d2                	test   %edx,%edx
  800662:	0f 89 5c 01 00 00    	jns    8007c4 <vprintfmt+0x403>
				putch('-', putdat);
  800668:	83 ec 08             	sub    $0x8,%esp
  80066b:	53                   	push   %ebx
  80066c:	6a 2d                	push   $0x2d
  80066e:	ff d6                	call   *%esi
				num = -(long long) num;
  800670:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800673:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800676:	f7 d8                	neg    %eax
  800678:	83 d2 00             	adc    $0x0,%edx
  80067b:	f7 da                	neg    %edx
  80067d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800680:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800683:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800686:	bf 0a 00 00 00       	mov    $0xa,%edi
  80068b:	e9 45 01 00 00       	jmp    8007d5 <vprintfmt+0x414>
		return va_arg(*ap, int);
  800690:	8b 45 14             	mov    0x14(%ebp),%eax
  800693:	8b 00                	mov    (%eax),%eax
  800695:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800698:	89 c1                	mov    %eax,%ecx
  80069a:	c1 f9 1f             	sar    $0x1f,%ecx
  80069d:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a3:	8d 40 04             	lea    0x4(%eax),%eax
  8006a6:	89 45 14             	mov    %eax,0x14(%ebp)
  8006a9:	eb ad                	jmp    800658 <vprintfmt+0x297>
	if (lflag >= 2)
  8006ab:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8006af:	7f 29                	jg     8006da <vprintfmt+0x319>
	else if (lflag)
  8006b1:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8006b5:	74 44                	je     8006fb <vprintfmt+0x33a>
		return va_arg(*ap, unsigned long);
  8006b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ba:	8b 00                	mov    (%eax),%eax
  8006bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006c4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ca:	8d 40 04             	lea    0x4(%eax),%eax
  8006cd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006d0:	bf 0a 00 00 00       	mov    $0xa,%edi
  8006d5:	e9 ea 00 00 00       	jmp    8007c4 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  8006da:	8b 45 14             	mov    0x14(%ebp),%eax
  8006dd:	8b 50 04             	mov    0x4(%eax),%edx
  8006e0:	8b 00                	mov    (%eax),%eax
  8006e2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006e5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006eb:	8d 40 08             	lea    0x8(%eax),%eax
  8006ee:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006f1:	bf 0a 00 00 00       	mov    $0xa,%edi
  8006f6:	e9 c9 00 00 00       	jmp    8007c4 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  8006fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fe:	8b 00                	mov    (%eax),%eax
  800700:	ba 00 00 00 00       	mov    $0x0,%edx
  800705:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800708:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80070b:	8b 45 14             	mov    0x14(%ebp),%eax
  80070e:	8d 40 04             	lea    0x4(%eax),%eax
  800711:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800714:	bf 0a 00 00 00       	mov    $0xa,%edi
  800719:	e9 a6 00 00 00       	jmp    8007c4 <vprintfmt+0x403>
			putch('0', putdat);
  80071e:	83 ec 08             	sub    $0x8,%esp
  800721:	53                   	push   %ebx
  800722:	6a 30                	push   $0x30
  800724:	ff d6                	call   *%esi
	if (lflag >= 2)
  800726:	83 c4 10             	add    $0x10,%esp
  800729:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  80072d:	7f 26                	jg     800755 <vprintfmt+0x394>
	else if (lflag)
  80072f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800733:	74 3e                	je     800773 <vprintfmt+0x3b2>
		return va_arg(*ap, unsigned long);
  800735:	8b 45 14             	mov    0x14(%ebp),%eax
  800738:	8b 00                	mov    (%eax),%eax
  80073a:	ba 00 00 00 00       	mov    $0x0,%edx
  80073f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800742:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800745:	8b 45 14             	mov    0x14(%ebp),%eax
  800748:	8d 40 04             	lea    0x4(%eax),%eax
  80074b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80074e:	bf 08 00 00 00       	mov    $0x8,%edi
  800753:	eb 6f                	jmp    8007c4 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  800755:	8b 45 14             	mov    0x14(%ebp),%eax
  800758:	8b 50 04             	mov    0x4(%eax),%edx
  80075b:	8b 00                	mov    (%eax),%eax
  80075d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800760:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800763:	8b 45 14             	mov    0x14(%ebp),%eax
  800766:	8d 40 08             	lea    0x8(%eax),%eax
  800769:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80076c:	bf 08 00 00 00       	mov    $0x8,%edi
  800771:	eb 51                	jmp    8007c4 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  800773:	8b 45 14             	mov    0x14(%ebp),%eax
  800776:	8b 00                	mov    (%eax),%eax
  800778:	ba 00 00 00 00       	mov    $0x0,%edx
  80077d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800780:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800783:	8b 45 14             	mov    0x14(%ebp),%eax
  800786:	8d 40 04             	lea    0x4(%eax),%eax
  800789:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80078c:	bf 08 00 00 00       	mov    $0x8,%edi
  800791:	eb 31                	jmp    8007c4 <vprintfmt+0x403>
			putch('0', putdat);
  800793:	83 ec 08             	sub    $0x8,%esp
  800796:	53                   	push   %ebx
  800797:	6a 30                	push   $0x30
  800799:	ff d6                	call   *%esi
			putch('x', putdat);
  80079b:	83 c4 08             	add    $0x8,%esp
  80079e:	53                   	push   %ebx
  80079f:	6a 78                	push   $0x78
  8007a1:	ff d6                	call   *%esi
			num = (unsigned long long)
  8007a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a6:	8b 00                	mov    (%eax),%eax
  8007a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8007ad:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007b0:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8007b3:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b9:	8d 40 04             	lea    0x4(%eax),%eax
  8007bc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007bf:	bf 10 00 00 00       	mov    $0x10,%edi
			if(posflag)
  8007c4:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007c8:	74 0b                	je     8007d5 <vprintfmt+0x414>
				putch('+', putdat);
  8007ca:	83 ec 08             	sub    $0x8,%esp
  8007cd:	53                   	push   %ebx
  8007ce:	6a 2b                	push   $0x2b
  8007d0:	ff d6                	call   *%esi
  8007d2:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  8007d5:	83 ec 0c             	sub    $0xc,%esp
  8007d8:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8007dc:	50                   	push   %eax
  8007dd:	ff 75 e0             	pushl  -0x20(%ebp)
  8007e0:	57                   	push   %edi
  8007e1:	ff 75 dc             	pushl  -0x24(%ebp)
  8007e4:	ff 75 d8             	pushl  -0x28(%ebp)
  8007e7:	89 da                	mov    %ebx,%edx
  8007e9:	89 f0                	mov    %esi,%eax
  8007eb:	e8 b8 fa ff ff       	call   8002a8 <printnum>
			break;
  8007f0:	83 c4 20             	add    $0x20,%esp
			char* cp = va_arg(ap, char *);
  8007f3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007f6:	83 c7 01             	add    $0x1,%edi
  8007f9:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007fd:	83 f8 25             	cmp    $0x25,%eax
  800800:	0f 84 d2 fb ff ff    	je     8003d8 <vprintfmt+0x17>
			if (ch == '\0')
  800806:	85 c0                	test   %eax,%eax
  800808:	0f 84 03 01 00 00    	je     800911 <vprintfmt+0x550>
			putch(ch, putdat);
  80080e:	83 ec 08             	sub    $0x8,%esp
  800811:	53                   	push   %ebx
  800812:	50                   	push   %eax
  800813:	ff d6                	call   *%esi
  800815:	83 c4 10             	add    $0x10,%esp
  800818:	eb dc                	jmp    8007f6 <vprintfmt+0x435>
	if (lflag >= 2)
  80081a:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  80081e:	7f 29                	jg     800849 <vprintfmt+0x488>
	else if (lflag)
  800820:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800824:	74 44                	je     80086a <vprintfmt+0x4a9>
		return va_arg(*ap, unsigned long);
  800826:	8b 45 14             	mov    0x14(%ebp),%eax
  800829:	8b 00                	mov    (%eax),%eax
  80082b:	ba 00 00 00 00       	mov    $0x0,%edx
  800830:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800833:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800836:	8b 45 14             	mov    0x14(%ebp),%eax
  800839:	8d 40 04             	lea    0x4(%eax),%eax
  80083c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80083f:	bf 10 00 00 00       	mov    $0x10,%edi
  800844:	e9 7b ff ff ff       	jmp    8007c4 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  800849:	8b 45 14             	mov    0x14(%ebp),%eax
  80084c:	8b 50 04             	mov    0x4(%eax),%edx
  80084f:	8b 00                	mov    (%eax),%eax
  800851:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800854:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800857:	8b 45 14             	mov    0x14(%ebp),%eax
  80085a:	8d 40 08             	lea    0x8(%eax),%eax
  80085d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800860:	bf 10 00 00 00       	mov    $0x10,%edi
  800865:	e9 5a ff ff ff       	jmp    8007c4 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  80086a:	8b 45 14             	mov    0x14(%ebp),%eax
  80086d:	8b 00                	mov    (%eax),%eax
  80086f:	ba 00 00 00 00       	mov    $0x0,%edx
  800874:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800877:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80087a:	8b 45 14             	mov    0x14(%ebp),%eax
  80087d:	8d 40 04             	lea    0x4(%eax),%eax
  800880:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800883:	bf 10 00 00 00       	mov    $0x10,%edi
  800888:	e9 37 ff ff ff       	jmp    8007c4 <vprintfmt+0x403>
			char* cp = va_arg(ap, char *);
  80088d:	8b 45 14             	mov    0x14(%ebp),%eax
  800890:	8d 78 04             	lea    0x4(%eax),%edi
  800893:	8b 00                	mov    (%eax),%eax
    			if (cp == NULL) {
  800895:	85 c0                	test   %eax,%eax
  800897:	74 2c                	je     8008c5 <vprintfmt+0x504>
    			*cp = *(int *)putdat;
  800899:	8b 13                	mov    (%ebx),%edx
  80089b:	88 10                	mov    %dl,(%eax)
			char* cp = va_arg(ap, char *);
  80089d:	89 7d 14             	mov    %edi,0x14(%ebp)
    			if ((*(int *) putdat) > 127)
  8008a0:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  8008a3:	0f 8e 4a ff ff ff    	jle    8007f3 <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", overflow_error);
  8008a9:	68 3c 1a 80 00       	push   $0x801a3c
  8008ae:	68 ed 18 80 00       	push   $0x8018ed
  8008b3:	53                   	push   %ebx
  8008b4:	56                   	push   %esi
  8008b5:	e8 ea fa ff ff       	call   8003a4 <printfmt>
  8008ba:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  8008bd:	89 7d 14             	mov    %edi,0x14(%ebp)
  8008c0:	e9 2e ff ff ff       	jmp    8007f3 <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", null_error);
  8008c5:	68 04 1a 80 00       	push   $0x801a04
  8008ca:	68 ed 18 80 00       	push   $0x8018ed
  8008cf:	53                   	push   %ebx
  8008d0:	56                   	push   %esi
  8008d1:	e8 ce fa ff ff       	call   8003a4 <printfmt>
        		break;
  8008d6:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  8008d9:	89 7d 14             	mov    %edi,0x14(%ebp)
        		break;
  8008dc:	e9 12 ff ff ff       	jmp    8007f3 <vprintfmt+0x432>
			putch(ch, putdat);
  8008e1:	83 ec 08             	sub    $0x8,%esp
  8008e4:	53                   	push   %ebx
  8008e5:	6a 25                	push   $0x25
  8008e7:	ff d6                	call   *%esi
			break;
  8008e9:	83 c4 10             	add    $0x10,%esp
  8008ec:	e9 02 ff ff ff       	jmp    8007f3 <vprintfmt+0x432>
			putch('%', putdat);
  8008f1:	83 ec 08             	sub    $0x8,%esp
  8008f4:	53                   	push   %ebx
  8008f5:	6a 25                	push   $0x25
  8008f7:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008f9:	83 c4 10             	add    $0x10,%esp
  8008fc:	89 f8                	mov    %edi,%eax
  8008fe:	eb 03                	jmp    800903 <vprintfmt+0x542>
  800900:	83 e8 01             	sub    $0x1,%eax
  800903:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800907:	75 f7                	jne    800900 <vprintfmt+0x53f>
  800909:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80090c:	e9 e2 fe ff ff       	jmp    8007f3 <vprintfmt+0x432>
}
  800911:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800914:	5b                   	pop    %ebx
  800915:	5e                   	pop    %esi
  800916:	5f                   	pop    %edi
  800917:	5d                   	pop    %ebp
  800918:	c3                   	ret    

00800919 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800919:	55                   	push   %ebp
  80091a:	89 e5                	mov    %esp,%ebp
  80091c:	83 ec 18             	sub    $0x18,%esp
  80091f:	8b 45 08             	mov    0x8(%ebp),%eax
  800922:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800925:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800928:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80092c:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80092f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800936:	85 c0                	test   %eax,%eax
  800938:	74 26                	je     800960 <vsnprintf+0x47>
  80093a:	85 d2                	test   %edx,%edx
  80093c:	7e 22                	jle    800960 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80093e:	ff 75 14             	pushl  0x14(%ebp)
  800941:	ff 75 10             	pushl  0x10(%ebp)
  800944:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800947:	50                   	push   %eax
  800948:	68 87 03 80 00       	push   $0x800387
  80094d:	e8 6f fa ff ff       	call   8003c1 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800952:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800955:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800958:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80095b:	83 c4 10             	add    $0x10,%esp
}
  80095e:	c9                   	leave  
  80095f:	c3                   	ret    
		return -E_INVAL;
  800960:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800965:	eb f7                	jmp    80095e <vsnprintf+0x45>

00800967 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800967:	55                   	push   %ebp
  800968:	89 e5                	mov    %esp,%ebp
  80096a:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80096d:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800970:	50                   	push   %eax
  800971:	ff 75 10             	pushl  0x10(%ebp)
  800974:	ff 75 0c             	pushl  0xc(%ebp)
  800977:	ff 75 08             	pushl  0x8(%ebp)
  80097a:	e8 9a ff ff ff       	call   800919 <vsnprintf>
	va_end(ap);

	return rc;
}
  80097f:	c9                   	leave  
  800980:	c3                   	ret    

00800981 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800981:	55                   	push   %ebp
  800982:	89 e5                	mov    %esp,%ebp
  800984:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800987:	b8 00 00 00 00       	mov    $0x0,%eax
  80098c:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800990:	74 05                	je     800997 <strlen+0x16>
		n++;
  800992:	83 c0 01             	add    $0x1,%eax
  800995:	eb f5                	jmp    80098c <strlen+0xb>
	return n;
}
  800997:	5d                   	pop    %ebp
  800998:	c3                   	ret    

00800999 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800999:	55                   	push   %ebp
  80099a:	89 e5                	mov    %esp,%ebp
  80099c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80099f:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8009a7:	39 c2                	cmp    %eax,%edx
  8009a9:	74 0d                	je     8009b8 <strnlen+0x1f>
  8009ab:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8009af:	74 05                	je     8009b6 <strnlen+0x1d>
		n++;
  8009b1:	83 c2 01             	add    $0x1,%edx
  8009b4:	eb f1                	jmp    8009a7 <strnlen+0xe>
  8009b6:	89 d0                	mov    %edx,%eax
	return n;
}
  8009b8:	5d                   	pop    %ebp
  8009b9:	c3                   	ret    

008009ba <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009ba:	55                   	push   %ebp
  8009bb:	89 e5                	mov    %esp,%ebp
  8009bd:	53                   	push   %ebx
  8009be:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8009c9:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8009cd:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8009d0:	83 c2 01             	add    $0x1,%edx
  8009d3:	84 c9                	test   %cl,%cl
  8009d5:	75 f2                	jne    8009c9 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8009d7:	5b                   	pop    %ebx
  8009d8:	5d                   	pop    %ebp
  8009d9:	c3                   	ret    

008009da <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009da:	55                   	push   %ebp
  8009db:	89 e5                	mov    %esp,%ebp
  8009dd:	53                   	push   %ebx
  8009de:	83 ec 10             	sub    $0x10,%esp
  8009e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009e4:	53                   	push   %ebx
  8009e5:	e8 97 ff ff ff       	call   800981 <strlen>
  8009ea:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8009ed:	ff 75 0c             	pushl  0xc(%ebp)
  8009f0:	01 d8                	add    %ebx,%eax
  8009f2:	50                   	push   %eax
  8009f3:	e8 c2 ff ff ff       	call   8009ba <strcpy>
	return dst;
}
  8009f8:	89 d8                	mov    %ebx,%eax
  8009fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009fd:	c9                   	leave  
  8009fe:	c3                   	ret    

008009ff <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009ff:	55                   	push   %ebp
  800a00:	89 e5                	mov    %esp,%ebp
  800a02:	56                   	push   %esi
  800a03:	53                   	push   %ebx
  800a04:	8b 45 08             	mov    0x8(%ebp),%eax
  800a07:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a0a:	89 c6                	mov    %eax,%esi
  800a0c:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a0f:	89 c2                	mov    %eax,%edx
  800a11:	39 f2                	cmp    %esi,%edx
  800a13:	74 11                	je     800a26 <strncpy+0x27>
		*dst++ = *src;
  800a15:	83 c2 01             	add    $0x1,%edx
  800a18:	0f b6 19             	movzbl (%ecx),%ebx
  800a1b:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a1e:	80 fb 01             	cmp    $0x1,%bl
  800a21:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800a24:	eb eb                	jmp    800a11 <strncpy+0x12>
	}
	return ret;
}
  800a26:	5b                   	pop    %ebx
  800a27:	5e                   	pop    %esi
  800a28:	5d                   	pop    %ebp
  800a29:	c3                   	ret    

00800a2a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a2a:	55                   	push   %ebp
  800a2b:	89 e5                	mov    %esp,%ebp
  800a2d:	56                   	push   %esi
  800a2e:	53                   	push   %ebx
  800a2f:	8b 75 08             	mov    0x8(%ebp),%esi
  800a32:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a35:	8b 55 10             	mov    0x10(%ebp),%edx
  800a38:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a3a:	85 d2                	test   %edx,%edx
  800a3c:	74 21                	je     800a5f <strlcpy+0x35>
  800a3e:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a42:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800a44:	39 c2                	cmp    %eax,%edx
  800a46:	74 14                	je     800a5c <strlcpy+0x32>
  800a48:	0f b6 19             	movzbl (%ecx),%ebx
  800a4b:	84 db                	test   %bl,%bl
  800a4d:	74 0b                	je     800a5a <strlcpy+0x30>
			*dst++ = *src++;
  800a4f:	83 c1 01             	add    $0x1,%ecx
  800a52:	83 c2 01             	add    $0x1,%edx
  800a55:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a58:	eb ea                	jmp    800a44 <strlcpy+0x1a>
  800a5a:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a5c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a5f:	29 f0                	sub    %esi,%eax
}
  800a61:	5b                   	pop    %ebx
  800a62:	5e                   	pop    %esi
  800a63:	5d                   	pop    %ebp
  800a64:	c3                   	ret    

00800a65 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a65:	55                   	push   %ebp
  800a66:	89 e5                	mov    %esp,%ebp
  800a68:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a6b:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a6e:	0f b6 01             	movzbl (%ecx),%eax
  800a71:	84 c0                	test   %al,%al
  800a73:	74 0c                	je     800a81 <strcmp+0x1c>
  800a75:	3a 02                	cmp    (%edx),%al
  800a77:	75 08                	jne    800a81 <strcmp+0x1c>
		p++, q++;
  800a79:	83 c1 01             	add    $0x1,%ecx
  800a7c:	83 c2 01             	add    $0x1,%edx
  800a7f:	eb ed                	jmp    800a6e <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a81:	0f b6 c0             	movzbl %al,%eax
  800a84:	0f b6 12             	movzbl (%edx),%edx
  800a87:	29 d0                	sub    %edx,%eax
}
  800a89:	5d                   	pop    %ebp
  800a8a:	c3                   	ret    

00800a8b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a8b:	55                   	push   %ebp
  800a8c:	89 e5                	mov    %esp,%ebp
  800a8e:	53                   	push   %ebx
  800a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a92:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a95:	89 c3                	mov    %eax,%ebx
  800a97:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a9a:	eb 06                	jmp    800aa2 <strncmp+0x17>
		n--, p++, q++;
  800a9c:	83 c0 01             	add    $0x1,%eax
  800a9f:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800aa2:	39 d8                	cmp    %ebx,%eax
  800aa4:	74 16                	je     800abc <strncmp+0x31>
  800aa6:	0f b6 08             	movzbl (%eax),%ecx
  800aa9:	84 c9                	test   %cl,%cl
  800aab:	74 04                	je     800ab1 <strncmp+0x26>
  800aad:	3a 0a                	cmp    (%edx),%cl
  800aaf:	74 eb                	je     800a9c <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ab1:	0f b6 00             	movzbl (%eax),%eax
  800ab4:	0f b6 12             	movzbl (%edx),%edx
  800ab7:	29 d0                	sub    %edx,%eax
}
  800ab9:	5b                   	pop    %ebx
  800aba:	5d                   	pop    %ebp
  800abb:	c3                   	ret    
		return 0;
  800abc:	b8 00 00 00 00       	mov    $0x0,%eax
  800ac1:	eb f6                	jmp    800ab9 <strncmp+0x2e>

00800ac3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ac3:	55                   	push   %ebp
  800ac4:	89 e5                	mov    %esp,%ebp
  800ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800acd:	0f b6 10             	movzbl (%eax),%edx
  800ad0:	84 d2                	test   %dl,%dl
  800ad2:	74 09                	je     800add <strchr+0x1a>
		if (*s == c)
  800ad4:	38 ca                	cmp    %cl,%dl
  800ad6:	74 0a                	je     800ae2 <strchr+0x1f>
	for (; *s; s++)
  800ad8:	83 c0 01             	add    $0x1,%eax
  800adb:	eb f0                	jmp    800acd <strchr+0xa>
			return (char *) s;
	return 0;
  800add:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ae2:	5d                   	pop    %ebp
  800ae3:	c3                   	ret    

00800ae4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ae4:	55                   	push   %ebp
  800ae5:	89 e5                	mov    %esp,%ebp
  800ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aea:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800aee:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800af1:	38 ca                	cmp    %cl,%dl
  800af3:	74 09                	je     800afe <strfind+0x1a>
  800af5:	84 d2                	test   %dl,%dl
  800af7:	74 05                	je     800afe <strfind+0x1a>
	for (; *s; s++)
  800af9:	83 c0 01             	add    $0x1,%eax
  800afc:	eb f0                	jmp    800aee <strfind+0xa>
			break;
	return (char *) s;
}
  800afe:	5d                   	pop    %ebp
  800aff:	c3                   	ret    

00800b00 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b00:	55                   	push   %ebp
  800b01:	89 e5                	mov    %esp,%ebp
  800b03:	57                   	push   %edi
  800b04:	56                   	push   %esi
  800b05:	53                   	push   %ebx
  800b06:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b09:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b0c:	85 c9                	test   %ecx,%ecx
  800b0e:	74 31                	je     800b41 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b10:	89 f8                	mov    %edi,%eax
  800b12:	09 c8                	or     %ecx,%eax
  800b14:	a8 03                	test   $0x3,%al
  800b16:	75 23                	jne    800b3b <memset+0x3b>
		c &= 0xFF;
  800b18:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b1c:	89 d3                	mov    %edx,%ebx
  800b1e:	c1 e3 08             	shl    $0x8,%ebx
  800b21:	89 d0                	mov    %edx,%eax
  800b23:	c1 e0 18             	shl    $0x18,%eax
  800b26:	89 d6                	mov    %edx,%esi
  800b28:	c1 e6 10             	shl    $0x10,%esi
  800b2b:	09 f0                	or     %esi,%eax
  800b2d:	09 c2                	or     %eax,%edx
  800b2f:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b31:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b34:	89 d0                	mov    %edx,%eax
  800b36:	fc                   	cld    
  800b37:	f3 ab                	rep stos %eax,%es:(%edi)
  800b39:	eb 06                	jmp    800b41 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3e:	fc                   	cld    
  800b3f:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b41:	89 f8                	mov    %edi,%eax
  800b43:	5b                   	pop    %ebx
  800b44:	5e                   	pop    %esi
  800b45:	5f                   	pop    %edi
  800b46:	5d                   	pop    %ebp
  800b47:	c3                   	ret    

00800b48 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b48:	55                   	push   %ebp
  800b49:	89 e5                	mov    %esp,%ebp
  800b4b:	57                   	push   %edi
  800b4c:	56                   	push   %esi
  800b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b50:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b53:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b56:	39 c6                	cmp    %eax,%esi
  800b58:	73 32                	jae    800b8c <memmove+0x44>
  800b5a:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b5d:	39 c2                	cmp    %eax,%edx
  800b5f:	76 2b                	jbe    800b8c <memmove+0x44>
		s += n;
		d += n;
  800b61:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b64:	89 fe                	mov    %edi,%esi
  800b66:	09 ce                	or     %ecx,%esi
  800b68:	09 d6                	or     %edx,%esi
  800b6a:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b70:	75 0e                	jne    800b80 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b72:	83 ef 04             	sub    $0x4,%edi
  800b75:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b78:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b7b:	fd                   	std    
  800b7c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b7e:	eb 09                	jmp    800b89 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b80:	83 ef 01             	sub    $0x1,%edi
  800b83:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b86:	fd                   	std    
  800b87:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b89:	fc                   	cld    
  800b8a:	eb 1a                	jmp    800ba6 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b8c:	89 c2                	mov    %eax,%edx
  800b8e:	09 ca                	or     %ecx,%edx
  800b90:	09 f2                	or     %esi,%edx
  800b92:	f6 c2 03             	test   $0x3,%dl
  800b95:	75 0a                	jne    800ba1 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b97:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b9a:	89 c7                	mov    %eax,%edi
  800b9c:	fc                   	cld    
  800b9d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b9f:	eb 05                	jmp    800ba6 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800ba1:	89 c7                	mov    %eax,%edi
  800ba3:	fc                   	cld    
  800ba4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ba6:	5e                   	pop    %esi
  800ba7:	5f                   	pop    %edi
  800ba8:	5d                   	pop    %ebp
  800ba9:	c3                   	ret    

00800baa <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800baa:	55                   	push   %ebp
  800bab:	89 e5                	mov    %esp,%ebp
  800bad:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800bb0:	ff 75 10             	pushl  0x10(%ebp)
  800bb3:	ff 75 0c             	pushl  0xc(%ebp)
  800bb6:	ff 75 08             	pushl  0x8(%ebp)
  800bb9:	e8 8a ff ff ff       	call   800b48 <memmove>
}
  800bbe:	c9                   	leave  
  800bbf:	c3                   	ret    

00800bc0 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800bc0:	55                   	push   %ebp
  800bc1:	89 e5                	mov    %esp,%ebp
  800bc3:	56                   	push   %esi
  800bc4:	53                   	push   %ebx
  800bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bcb:	89 c6                	mov    %eax,%esi
  800bcd:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bd0:	39 f0                	cmp    %esi,%eax
  800bd2:	74 1c                	je     800bf0 <memcmp+0x30>
		if (*s1 != *s2)
  800bd4:	0f b6 08             	movzbl (%eax),%ecx
  800bd7:	0f b6 1a             	movzbl (%edx),%ebx
  800bda:	38 d9                	cmp    %bl,%cl
  800bdc:	75 08                	jne    800be6 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800bde:	83 c0 01             	add    $0x1,%eax
  800be1:	83 c2 01             	add    $0x1,%edx
  800be4:	eb ea                	jmp    800bd0 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800be6:	0f b6 c1             	movzbl %cl,%eax
  800be9:	0f b6 db             	movzbl %bl,%ebx
  800bec:	29 d8                	sub    %ebx,%eax
  800bee:	eb 05                	jmp    800bf5 <memcmp+0x35>
	}

	return 0;
  800bf0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bf5:	5b                   	pop    %ebx
  800bf6:	5e                   	pop    %esi
  800bf7:	5d                   	pop    %ebp
  800bf8:	c3                   	ret    

00800bf9 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800bf9:	55                   	push   %ebp
  800bfa:	89 e5                	mov    %esp,%ebp
  800bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c02:	89 c2                	mov    %eax,%edx
  800c04:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c07:	39 d0                	cmp    %edx,%eax
  800c09:	73 09                	jae    800c14 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c0b:	38 08                	cmp    %cl,(%eax)
  800c0d:	74 05                	je     800c14 <memfind+0x1b>
	for (; s < ends; s++)
  800c0f:	83 c0 01             	add    $0x1,%eax
  800c12:	eb f3                	jmp    800c07 <memfind+0xe>
			break;
	return (void *) s;
}
  800c14:	5d                   	pop    %ebp
  800c15:	c3                   	ret    

00800c16 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c16:	55                   	push   %ebp
  800c17:	89 e5                	mov    %esp,%ebp
  800c19:	57                   	push   %edi
  800c1a:	56                   	push   %esi
  800c1b:	53                   	push   %ebx
  800c1c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c1f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c22:	eb 03                	jmp    800c27 <strtol+0x11>
		s++;
  800c24:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c27:	0f b6 01             	movzbl (%ecx),%eax
  800c2a:	3c 20                	cmp    $0x20,%al
  800c2c:	74 f6                	je     800c24 <strtol+0xe>
  800c2e:	3c 09                	cmp    $0x9,%al
  800c30:	74 f2                	je     800c24 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c32:	3c 2b                	cmp    $0x2b,%al
  800c34:	74 2a                	je     800c60 <strtol+0x4a>
	int neg = 0;
  800c36:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c3b:	3c 2d                	cmp    $0x2d,%al
  800c3d:	74 2b                	je     800c6a <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c3f:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c45:	75 0f                	jne    800c56 <strtol+0x40>
  800c47:	80 39 30             	cmpb   $0x30,(%ecx)
  800c4a:	74 28                	je     800c74 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c4c:	85 db                	test   %ebx,%ebx
  800c4e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c53:	0f 44 d8             	cmove  %eax,%ebx
  800c56:	b8 00 00 00 00       	mov    $0x0,%eax
  800c5b:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c5e:	eb 50                	jmp    800cb0 <strtol+0x9a>
		s++;
  800c60:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c63:	bf 00 00 00 00       	mov    $0x0,%edi
  800c68:	eb d5                	jmp    800c3f <strtol+0x29>
		s++, neg = 1;
  800c6a:	83 c1 01             	add    $0x1,%ecx
  800c6d:	bf 01 00 00 00       	mov    $0x1,%edi
  800c72:	eb cb                	jmp    800c3f <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c74:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c78:	74 0e                	je     800c88 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c7a:	85 db                	test   %ebx,%ebx
  800c7c:	75 d8                	jne    800c56 <strtol+0x40>
		s++, base = 8;
  800c7e:	83 c1 01             	add    $0x1,%ecx
  800c81:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c86:	eb ce                	jmp    800c56 <strtol+0x40>
		s += 2, base = 16;
  800c88:	83 c1 02             	add    $0x2,%ecx
  800c8b:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c90:	eb c4                	jmp    800c56 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c92:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c95:	89 f3                	mov    %esi,%ebx
  800c97:	80 fb 19             	cmp    $0x19,%bl
  800c9a:	77 29                	ja     800cc5 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c9c:	0f be d2             	movsbl %dl,%edx
  800c9f:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ca2:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ca5:	7d 30                	jge    800cd7 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800ca7:	83 c1 01             	add    $0x1,%ecx
  800caa:	0f af 45 10          	imul   0x10(%ebp),%eax
  800cae:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800cb0:	0f b6 11             	movzbl (%ecx),%edx
  800cb3:	8d 72 d0             	lea    -0x30(%edx),%esi
  800cb6:	89 f3                	mov    %esi,%ebx
  800cb8:	80 fb 09             	cmp    $0x9,%bl
  800cbb:	77 d5                	ja     800c92 <strtol+0x7c>
			dig = *s - '0';
  800cbd:	0f be d2             	movsbl %dl,%edx
  800cc0:	83 ea 30             	sub    $0x30,%edx
  800cc3:	eb dd                	jmp    800ca2 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800cc5:	8d 72 bf             	lea    -0x41(%edx),%esi
  800cc8:	89 f3                	mov    %esi,%ebx
  800cca:	80 fb 19             	cmp    $0x19,%bl
  800ccd:	77 08                	ja     800cd7 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800ccf:	0f be d2             	movsbl %dl,%edx
  800cd2:	83 ea 37             	sub    $0x37,%edx
  800cd5:	eb cb                	jmp    800ca2 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800cd7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cdb:	74 05                	je     800ce2 <strtol+0xcc>
		*endptr = (char *) s;
  800cdd:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ce0:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ce2:	89 c2                	mov    %eax,%edx
  800ce4:	f7 da                	neg    %edx
  800ce6:	85 ff                	test   %edi,%edi
  800ce8:	0f 45 c2             	cmovne %edx,%eax
}
  800ceb:	5b                   	pop    %ebx
  800cec:	5e                   	pop    %esi
  800ced:	5f                   	pop    %edi
  800cee:	5d                   	pop    %ebp
  800cef:	c3                   	ret    

00800cf0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800cf0:	55                   	push   %ebp
  800cf1:	89 e5                	mov    %esp,%ebp
  800cf3:	57                   	push   %edi
  800cf4:	56                   	push   %esi
  800cf5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cf6:	b8 00 00 00 00       	mov    $0x0,%eax
  800cfb:	8b 55 08             	mov    0x8(%ebp),%edx
  800cfe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d01:	89 c3                	mov    %eax,%ebx
  800d03:	89 c7                	mov    %eax,%edi
  800d05:	89 c6                	mov    %eax,%esi
  800d07:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d09:	5b                   	pop    %ebx
  800d0a:	5e                   	pop    %esi
  800d0b:	5f                   	pop    %edi
  800d0c:	5d                   	pop    %ebp
  800d0d:	c3                   	ret    

00800d0e <sys_cgetc>:

int
sys_cgetc(void)
{
  800d0e:	55                   	push   %ebp
  800d0f:	89 e5                	mov    %esp,%ebp
  800d11:	57                   	push   %edi
  800d12:	56                   	push   %esi
  800d13:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d14:	ba 00 00 00 00       	mov    $0x0,%edx
  800d19:	b8 01 00 00 00       	mov    $0x1,%eax
  800d1e:	89 d1                	mov    %edx,%ecx
  800d20:	89 d3                	mov    %edx,%ebx
  800d22:	89 d7                	mov    %edx,%edi
  800d24:	89 d6                	mov    %edx,%esi
  800d26:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d28:	5b                   	pop    %ebx
  800d29:	5e                   	pop    %esi
  800d2a:	5f                   	pop    %edi
  800d2b:	5d                   	pop    %ebp
  800d2c:	c3                   	ret    

00800d2d <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d2d:	55                   	push   %ebp
  800d2e:	89 e5                	mov    %esp,%ebp
  800d30:	57                   	push   %edi
  800d31:	56                   	push   %esi
  800d32:	53                   	push   %ebx
  800d33:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d36:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d3b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d3e:	b8 03 00 00 00       	mov    $0x3,%eax
  800d43:	89 cb                	mov    %ecx,%ebx
  800d45:	89 cf                	mov    %ecx,%edi
  800d47:	89 ce                	mov    %ecx,%esi
  800d49:	cd 30                	int    $0x30
	if (check && ret > 0)
  800d4b:	85 c0                	test   %eax,%eax
  800d4d:	7f 08                	jg     800d57 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d4f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d52:	5b                   	pop    %ebx
  800d53:	5e                   	pop    %esi
  800d54:	5f                   	pop    %edi
  800d55:	5d                   	pop    %ebp
  800d56:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d57:	83 ec 0c             	sub    $0xc,%esp
  800d5a:	50                   	push   %eax
  800d5b:	6a 03                	push   $0x3
  800d5d:	68 40 1c 80 00       	push   $0x801c40
  800d62:	6a 4c                	push   $0x4c
  800d64:	68 5d 1c 80 00       	push   $0x801c5d
  800d69:	e8 81 07 00 00       	call   8014ef <_panic>

00800d6e <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d6e:	55                   	push   %ebp
  800d6f:	89 e5                	mov    %esp,%ebp
  800d71:	57                   	push   %edi
  800d72:	56                   	push   %esi
  800d73:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d74:	ba 00 00 00 00       	mov    $0x0,%edx
  800d79:	b8 02 00 00 00       	mov    $0x2,%eax
  800d7e:	89 d1                	mov    %edx,%ecx
  800d80:	89 d3                	mov    %edx,%ebx
  800d82:	89 d7                	mov    %edx,%edi
  800d84:	89 d6                	mov    %edx,%esi
  800d86:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d88:	5b                   	pop    %ebx
  800d89:	5e                   	pop    %esi
  800d8a:	5f                   	pop    %edi
  800d8b:	5d                   	pop    %ebp
  800d8c:	c3                   	ret    

00800d8d <sys_yield>:

void
sys_yield(void)
{
  800d8d:	55                   	push   %ebp
  800d8e:	89 e5                	mov    %esp,%ebp
  800d90:	57                   	push   %edi
  800d91:	56                   	push   %esi
  800d92:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d93:	ba 00 00 00 00       	mov    $0x0,%edx
  800d98:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d9d:	89 d1                	mov    %edx,%ecx
  800d9f:	89 d3                	mov    %edx,%ebx
  800da1:	89 d7                	mov    %edx,%edi
  800da3:	89 d6                	mov    %edx,%esi
  800da5:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800da7:	5b                   	pop    %ebx
  800da8:	5e                   	pop    %esi
  800da9:	5f                   	pop    %edi
  800daa:	5d                   	pop    %ebp
  800dab:	c3                   	ret    

00800dac <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800dac:	55                   	push   %ebp
  800dad:	89 e5                	mov    %esp,%ebp
  800daf:	57                   	push   %edi
  800db0:	56                   	push   %esi
  800db1:	53                   	push   %ebx
  800db2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800db5:	be 00 00 00 00       	mov    $0x0,%esi
  800dba:	8b 55 08             	mov    0x8(%ebp),%edx
  800dbd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc0:	b8 04 00 00 00       	mov    $0x4,%eax
  800dc5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dc8:	89 f7                	mov    %esi,%edi
  800dca:	cd 30                	int    $0x30
	if (check && ret > 0)
  800dcc:	85 c0                	test   %eax,%eax
  800dce:	7f 08                	jg     800dd8 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800dd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dd3:	5b                   	pop    %ebx
  800dd4:	5e                   	pop    %esi
  800dd5:	5f                   	pop    %edi
  800dd6:	5d                   	pop    %ebp
  800dd7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dd8:	83 ec 0c             	sub    $0xc,%esp
  800ddb:	50                   	push   %eax
  800ddc:	6a 04                	push   $0x4
  800dde:	68 40 1c 80 00       	push   $0x801c40
  800de3:	6a 4c                	push   $0x4c
  800de5:	68 5d 1c 80 00       	push   $0x801c5d
  800dea:	e8 00 07 00 00       	call   8014ef <_panic>

00800def <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800def:	55                   	push   %ebp
  800df0:	89 e5                	mov    %esp,%ebp
  800df2:	57                   	push   %edi
  800df3:	56                   	push   %esi
  800df4:	53                   	push   %ebx
  800df5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800df8:	8b 55 08             	mov    0x8(%ebp),%edx
  800dfb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dfe:	b8 05 00 00 00       	mov    $0x5,%eax
  800e03:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e06:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e09:	8b 75 18             	mov    0x18(%ebp),%esi
  800e0c:	cd 30                	int    $0x30
	if (check && ret > 0)
  800e0e:	85 c0                	test   %eax,%eax
  800e10:	7f 08                	jg     800e1a <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e12:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e15:	5b                   	pop    %ebx
  800e16:	5e                   	pop    %esi
  800e17:	5f                   	pop    %edi
  800e18:	5d                   	pop    %ebp
  800e19:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e1a:	83 ec 0c             	sub    $0xc,%esp
  800e1d:	50                   	push   %eax
  800e1e:	6a 05                	push   $0x5
  800e20:	68 40 1c 80 00       	push   $0x801c40
  800e25:	6a 4c                	push   $0x4c
  800e27:	68 5d 1c 80 00       	push   $0x801c5d
  800e2c:	e8 be 06 00 00       	call   8014ef <_panic>

00800e31 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e31:	55                   	push   %ebp
  800e32:	89 e5                	mov    %esp,%ebp
  800e34:	57                   	push   %edi
  800e35:	56                   	push   %esi
  800e36:	53                   	push   %ebx
  800e37:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e3a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e3f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e42:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e45:	b8 06 00 00 00       	mov    $0x6,%eax
  800e4a:	89 df                	mov    %ebx,%edi
  800e4c:	89 de                	mov    %ebx,%esi
  800e4e:	cd 30                	int    $0x30
	if (check && ret > 0)
  800e50:	85 c0                	test   %eax,%eax
  800e52:	7f 08                	jg     800e5c <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e54:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e57:	5b                   	pop    %ebx
  800e58:	5e                   	pop    %esi
  800e59:	5f                   	pop    %edi
  800e5a:	5d                   	pop    %ebp
  800e5b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e5c:	83 ec 0c             	sub    $0xc,%esp
  800e5f:	50                   	push   %eax
  800e60:	6a 06                	push   $0x6
  800e62:	68 40 1c 80 00       	push   $0x801c40
  800e67:	6a 4c                	push   $0x4c
  800e69:	68 5d 1c 80 00       	push   $0x801c5d
  800e6e:	e8 7c 06 00 00       	call   8014ef <_panic>

00800e73 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e73:	55                   	push   %ebp
  800e74:	89 e5                	mov    %esp,%ebp
  800e76:	57                   	push   %edi
  800e77:	56                   	push   %esi
  800e78:	53                   	push   %ebx
  800e79:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e7c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e81:	8b 55 08             	mov    0x8(%ebp),%edx
  800e84:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e87:	b8 08 00 00 00       	mov    $0x8,%eax
  800e8c:	89 df                	mov    %ebx,%edi
  800e8e:	89 de                	mov    %ebx,%esi
  800e90:	cd 30                	int    $0x30
	if (check && ret > 0)
  800e92:	85 c0                	test   %eax,%eax
  800e94:	7f 08                	jg     800e9e <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e96:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e99:	5b                   	pop    %ebx
  800e9a:	5e                   	pop    %esi
  800e9b:	5f                   	pop    %edi
  800e9c:	5d                   	pop    %ebp
  800e9d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e9e:	83 ec 0c             	sub    $0xc,%esp
  800ea1:	50                   	push   %eax
  800ea2:	6a 08                	push   $0x8
  800ea4:	68 40 1c 80 00       	push   $0x801c40
  800ea9:	6a 4c                	push   $0x4c
  800eab:	68 5d 1c 80 00       	push   $0x801c5d
  800eb0:	e8 3a 06 00 00       	call   8014ef <_panic>

00800eb5 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800eb5:	55                   	push   %ebp
  800eb6:	89 e5                	mov    %esp,%ebp
  800eb8:	57                   	push   %edi
  800eb9:	56                   	push   %esi
  800eba:	53                   	push   %ebx
  800ebb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ebe:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ec3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec9:	b8 09 00 00 00       	mov    $0x9,%eax
  800ece:	89 df                	mov    %ebx,%edi
  800ed0:	89 de                	mov    %ebx,%esi
  800ed2:	cd 30                	int    $0x30
	if (check && ret > 0)
  800ed4:	85 c0                	test   %eax,%eax
  800ed6:	7f 08                	jg     800ee0 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ed8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800edb:	5b                   	pop    %ebx
  800edc:	5e                   	pop    %esi
  800edd:	5f                   	pop    %edi
  800ede:	5d                   	pop    %ebp
  800edf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ee0:	83 ec 0c             	sub    $0xc,%esp
  800ee3:	50                   	push   %eax
  800ee4:	6a 09                	push   $0x9
  800ee6:	68 40 1c 80 00       	push   $0x801c40
  800eeb:	6a 4c                	push   $0x4c
  800eed:	68 5d 1c 80 00       	push   $0x801c5d
  800ef2:	e8 f8 05 00 00       	call   8014ef <_panic>

00800ef7 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ef7:	55                   	push   %ebp
  800ef8:	89 e5                	mov    %esp,%ebp
  800efa:	57                   	push   %edi
  800efb:	56                   	push   %esi
  800efc:	53                   	push   %ebx
  800efd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f00:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f05:	8b 55 08             	mov    0x8(%ebp),%edx
  800f08:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f0b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f10:	89 df                	mov    %ebx,%edi
  800f12:	89 de                	mov    %ebx,%esi
  800f14:	cd 30                	int    $0x30
	if (check && ret > 0)
  800f16:	85 c0                	test   %eax,%eax
  800f18:	7f 08                	jg     800f22 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f1a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f1d:	5b                   	pop    %ebx
  800f1e:	5e                   	pop    %esi
  800f1f:	5f                   	pop    %edi
  800f20:	5d                   	pop    %ebp
  800f21:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f22:	83 ec 0c             	sub    $0xc,%esp
  800f25:	50                   	push   %eax
  800f26:	6a 0a                	push   $0xa
  800f28:	68 40 1c 80 00       	push   $0x801c40
  800f2d:	6a 4c                	push   $0x4c
  800f2f:	68 5d 1c 80 00       	push   $0x801c5d
  800f34:	e8 b6 05 00 00       	call   8014ef <_panic>

00800f39 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f39:	55                   	push   %ebp
  800f3a:	89 e5                	mov    %esp,%ebp
  800f3c:	57                   	push   %edi
  800f3d:	56                   	push   %esi
  800f3e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f3f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f42:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f45:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f4a:	be 00 00 00 00       	mov    $0x0,%esi
  800f4f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f52:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f55:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f57:	5b                   	pop    %ebx
  800f58:	5e                   	pop    %esi
  800f59:	5f                   	pop    %edi
  800f5a:	5d                   	pop    %ebp
  800f5b:	c3                   	ret    

00800f5c <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f5c:	55                   	push   %ebp
  800f5d:	89 e5                	mov    %esp,%ebp
  800f5f:	57                   	push   %edi
  800f60:	56                   	push   %esi
  800f61:	53                   	push   %ebx
  800f62:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f65:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f6a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6d:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f72:	89 cb                	mov    %ecx,%ebx
  800f74:	89 cf                	mov    %ecx,%edi
  800f76:	89 ce                	mov    %ecx,%esi
  800f78:	cd 30                	int    $0x30
	if (check && ret > 0)
  800f7a:	85 c0                	test   %eax,%eax
  800f7c:	7f 08                	jg     800f86 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f7e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f81:	5b                   	pop    %ebx
  800f82:	5e                   	pop    %esi
  800f83:	5f                   	pop    %edi
  800f84:	5d                   	pop    %ebp
  800f85:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f86:	83 ec 0c             	sub    $0xc,%esp
  800f89:	50                   	push   %eax
  800f8a:	6a 0d                	push   $0xd
  800f8c:	68 40 1c 80 00       	push   $0x801c40
  800f91:	6a 4c                	push   $0x4c
  800f93:	68 5d 1c 80 00       	push   $0x801c5d
  800f98:	e8 52 05 00 00       	call   8014ef <_panic>

00800f9d <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f9d:	55                   	push   %ebp
  800f9e:	89 e5                	mov    %esp,%ebp
  800fa0:	57                   	push   %edi
  800fa1:	56                   	push   %esi
  800fa2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fa3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fa8:	8b 55 08             	mov    0x8(%ebp),%edx
  800fab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fae:	b8 0e 00 00 00       	mov    $0xe,%eax
  800fb3:	89 df                	mov    %ebx,%edi
  800fb5:	89 de                	mov    %ebx,%esi
  800fb7:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800fb9:	5b                   	pop    %ebx
  800fba:	5e                   	pop    %esi
  800fbb:	5f                   	pop    %edi
  800fbc:	5d                   	pop    %ebp
  800fbd:	c3                   	ret    

00800fbe <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800fbe:	55                   	push   %ebp
  800fbf:	89 e5                	mov    %esp,%ebp
  800fc1:	57                   	push   %edi
  800fc2:	56                   	push   %esi
  800fc3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fc4:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fc9:	8b 55 08             	mov    0x8(%ebp),%edx
  800fcc:	b8 0f 00 00 00       	mov    $0xf,%eax
  800fd1:	89 cb                	mov    %ecx,%ebx
  800fd3:	89 cf                	mov    %ecx,%edi
  800fd5:	89 ce                	mov    %ecx,%esi
  800fd7:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800fd9:	5b                   	pop    %ebx
  800fda:	5e                   	pop    %esi
  800fdb:	5f                   	pop    %edi
  800fdc:	5d                   	pop    %ebp
  800fdd:	c3                   	ret    

00800fde <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800fde:	55                   	push   %ebp
  800fdf:	89 e5                	mov    %esp,%ebp
  800fe1:	53                   	push   %ebx
  800fe2:	83 ec 04             	sub    $0x4,%esp
  800fe5:	8b 55 08             	mov    0x8(%ebp),%edx
	// cprintf("pgfault()\n");
	void *addr = (void *) utf->utf_fault_va;
  800fe8:	8b 02                	mov    (%edx),%eax
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(!(err & FEC_WR) || !(uvpd[PDX(addr)] & PTE_P) || !(uvpt[PGNUM(addr)] & PTE_P) || !(uvpt[PGNUM(addr)] & PTE_COW))
  800fea:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  800fee:	0f 84 9c 00 00 00    	je     801090 <pgfault+0xb2>
  800ff4:	89 c2                	mov    %eax,%edx
  800ff6:	c1 ea 16             	shr    $0x16,%edx
  800ff9:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801000:	f6 c2 01             	test   $0x1,%dl
  801003:	0f 84 87 00 00 00    	je     801090 <pgfault+0xb2>
  801009:	89 c2                	mov    %eax,%edx
  80100b:	c1 ea 0c             	shr    $0xc,%edx
  80100e:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801015:	f6 c1 01             	test   $0x1,%cl
  801018:	74 76                	je     801090 <pgfault+0xb2>
  80101a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801021:	f6 c6 08             	test   $0x8,%dh
  801024:	74 6a                	je     801090 <pgfault+0xb2>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  801026:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80102b:	89 c3                	mov    %eax,%ebx

	r = sys_page_alloc(0, PFTEMP, PTE_P|PTE_U|PTE_W);
  80102d:	83 ec 04             	sub    $0x4,%esp
  801030:	6a 07                	push   $0x7
  801032:	68 00 f0 7f 00       	push   $0x7ff000
  801037:	6a 00                	push   $0x0
  801039:	e8 6e fd ff ff       	call   800dac <sys_page_alloc>
	if(r < 0){
  80103e:	83 c4 10             	add    $0x10,%esp
  801041:	85 c0                	test   %eax,%eax
  801043:	78 5f                	js     8010a4 <pgfault+0xc6>
		panic("pgfault: sys_page_alloc fail, r: %d", r);
	}

	memmove(PFTEMP, addr, PGSIZE);
  801045:	83 ec 04             	sub    $0x4,%esp
  801048:	68 00 10 00 00       	push   $0x1000
  80104d:	53                   	push   %ebx
  80104e:	68 00 f0 7f 00       	push   $0x7ff000
  801053:	e8 f0 fa ff ff       	call   800b48 <memmove>

	r = sys_page_map(0, PFTEMP, 0, addr, PTE_P|PTE_U|PTE_W);
  801058:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  80105f:	53                   	push   %ebx
  801060:	6a 00                	push   $0x0
  801062:	68 00 f0 7f 00       	push   $0x7ff000
  801067:	6a 00                	push   $0x0
  801069:	e8 81 fd ff ff       	call   800def <sys_page_map>
	if(r < 0){
  80106e:	83 c4 20             	add    $0x20,%esp
  801071:	85 c0                	test   %eax,%eax
  801073:	78 41                	js     8010b6 <pgfault+0xd8>
		panic("pgfault: sys_page_map fail, r: %d", r);
	}

	r = sys_page_unmap(0, PFTEMP);
  801075:	83 ec 08             	sub    $0x8,%esp
  801078:	68 00 f0 7f 00       	push   $0x7ff000
  80107d:	6a 00                	push   $0x0
  80107f:	e8 ad fd ff ff       	call   800e31 <sys_page_unmap>
	if(r < 0){
  801084:	83 c4 10             	add    $0x10,%esp
  801087:	85 c0                	test   %eax,%eax
  801089:	78 3d                	js     8010c8 <pgfault+0xea>
		panic("sys_page_unmap: %e", r);
	}
}
  80108b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80108e:	c9                   	leave  
  80108f:	c3                   	ret    
		panic("pgfault: 1\n");
  801090:	83 ec 04             	sub    $0x4,%esp
  801093:	68 6b 1c 80 00       	push   $0x801c6b
  801098:	6a 20                	push   $0x20
  80109a:	68 77 1c 80 00       	push   $0x801c77
  80109f:	e8 4b 04 00 00       	call   8014ef <_panic>
		panic("pgfault: sys_page_alloc fail, r: %d", r);
  8010a4:	50                   	push   %eax
  8010a5:	68 cc 1c 80 00       	push   $0x801ccc
  8010aa:	6a 2e                	push   $0x2e
  8010ac:	68 77 1c 80 00       	push   $0x801c77
  8010b1:	e8 39 04 00 00       	call   8014ef <_panic>
		panic("pgfault: sys_page_map fail, r: %d", r);
  8010b6:	50                   	push   %eax
  8010b7:	68 f0 1c 80 00       	push   $0x801cf0
  8010bc:	6a 35                	push   $0x35
  8010be:	68 77 1c 80 00       	push   $0x801c77
  8010c3:	e8 27 04 00 00       	call   8014ef <_panic>
		panic("sys_page_unmap: %e", r);
  8010c8:	50                   	push   %eax
  8010c9:	68 82 1c 80 00       	push   $0x801c82
  8010ce:	6a 3a                	push   $0x3a
  8010d0:	68 77 1c 80 00       	push   $0x801c77
  8010d5:	e8 15 04 00 00       	call   8014ef <_panic>

008010da <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8010da:	55                   	push   %ebp
  8010db:	89 e5                	mov    %esp,%ebp
  8010dd:	57                   	push   %edi
  8010de:	56                   	push   %esi
  8010df:	53                   	push   %ebx
  8010e0:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	// panic("fork not implemented");
	int r;
	set_pgfault_handler(pgfault);
  8010e3:	68 de 0f 80 00       	push   $0x800fde
  8010e8:	e8 48 04 00 00       	call   801535 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8010ed:	b8 07 00 00 00       	mov    $0x7,%eax
  8010f2:	cd 30                	int    $0x30
  8010f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int i;
	uintptr_t va;
	envid_t childid = sys_exofork();
	if (childid < 0){
  8010f7:	83 c4 10             	add    $0x10,%esp
  8010fa:	85 c0                	test   %eax,%eax
  8010fc:	78 2c                	js     80112a <fork+0x50>
  8010fe:	89 c7                	mov    %eax,%edi
	}

	extern volatile pde_t uvpd[];
	extern volatile pte_t uvpt[];

	for (va = UTEXT; va < USTACKTOP; va += PGSIZE){
  801100:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if (childid == 0) {
  801105:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801109:	75 72                	jne    80117d <fork+0xa3>
		thisenv = &envs[ENVX(sys_getenvid())];
  80110b:	e8 5e fc ff ff       	call   800d6e <sys_getenvid>
  801110:	25 ff 03 00 00       	and    $0x3ff,%eax
  801115:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80111b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801120:	a3 0c 20 80 00       	mov    %eax,0x80200c
		return 0;
  801125:	e9 36 01 00 00       	jmp    801260 <fork+0x186>
		panic("fork: child id < 0: %d", childid);
  80112a:	50                   	push   %eax
  80112b:	68 95 1c 80 00       	push   $0x801c95
  801130:	68 83 00 00 00       	push   $0x83
  801135:	68 77 1c 80 00       	push   $0x801c77
  80113a:	e8 b0 03 00 00       	call   8014ef <_panic>
			panic("sys_page_map: sys_page_map fail, r:%d\n", r);
  80113f:	50                   	push   %eax
  801140:	68 14 1d 80 00       	push   $0x801d14
  801145:	6a 56                	push   $0x56
  801147:	68 77 1c 80 00       	push   $0x801c77
  80114c:	e8 9e 03 00 00       	call   8014ef <_panic>
		r = sys_page_map((envid_t)0, va, envid, va, PTE_U | PTE_P);
  801151:	83 ec 0c             	sub    $0xc,%esp
  801154:	6a 05                	push   $0x5
  801156:	56                   	push   %esi
  801157:	57                   	push   %edi
  801158:	56                   	push   %esi
  801159:	6a 00                	push   $0x0
  80115b:	e8 8f fc ff ff       	call   800def <sys_page_map>
		if(r < 0){
  801160:	83 c4 20             	add    $0x20,%esp
  801163:	85 c0                	test   %eax,%eax
  801165:	0f 88 9f 00 00 00    	js     80120a <fork+0x130>
	for (va = UTEXT; va < USTACKTOP; va += PGSIZE){
  80116b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801171:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801177:	0f 84 9f 00 00 00    	je     80121c <fork+0x142>
		if ((uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_U)){
  80117d:	89 d8                	mov    %ebx,%eax
  80117f:	c1 e8 16             	shr    $0x16,%eax
  801182:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801189:	a8 01                	test   $0x1,%al
  80118b:	74 de                	je     80116b <fork+0x91>
  80118d:	89 d8                	mov    %ebx,%eax
  80118f:	c1 e8 0c             	shr    $0xc,%eax
  801192:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801199:	f6 c2 01             	test   $0x1,%dl
  80119c:	74 cd                	je     80116b <fork+0x91>
  80119e:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8011a5:	f6 c2 04             	test   $0x4,%dl
  8011a8:	74 c1                	je     80116b <fork+0x91>
	void * va = (void *)(pn * PGSIZE);
  8011aa:	89 c6                	mov    %eax,%esi
  8011ac:	c1 e6 0c             	shl    $0xc,%esi
	int perm = (uvpt[pn]);
  8011af:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (perm & (PTE_W | PTE_COW)) {
  8011b6:	a9 02 08 00 00       	test   $0x802,%eax
  8011bb:	74 94                	je     801151 <fork+0x77>
		r = sys_page_map((envid_t)0, va, envid, va, PTE_U | PTE_P | PTE_COW);
  8011bd:	83 ec 0c             	sub    $0xc,%esp
  8011c0:	68 05 08 00 00       	push   $0x805
  8011c5:	56                   	push   %esi
  8011c6:	57                   	push   %edi
  8011c7:	56                   	push   %esi
  8011c8:	6a 00                	push   $0x0
  8011ca:	e8 20 fc ff ff       	call   800def <sys_page_map>
		if(r < 0){
  8011cf:	83 c4 20             	add    $0x20,%esp
  8011d2:	85 c0                	test   %eax,%eax
  8011d4:	0f 88 65 ff ff ff    	js     80113f <fork+0x65>
		r = sys_page_map((envid_t)0, va, (envid_t)0, va, PTE_U | PTE_P | PTE_COW);
  8011da:	83 ec 0c             	sub    $0xc,%esp
  8011dd:	68 05 08 00 00       	push   $0x805
  8011e2:	56                   	push   %esi
  8011e3:	6a 00                	push   $0x0
  8011e5:	56                   	push   %esi
  8011e6:	6a 00                	push   $0x0
  8011e8:	e8 02 fc ff ff       	call   800def <sys_page_map>
		if(r < 0){
  8011ed:	83 c4 20             	add    $0x20,%esp
  8011f0:	85 c0                	test   %eax,%eax
  8011f2:	0f 89 73 ff ff ff    	jns    80116b <fork+0x91>
			panic("sys_page_map: sys_page_map fail, r:%d\n", r);
  8011f8:	50                   	push   %eax
  8011f9:	68 14 1d 80 00       	push   $0x801d14
  8011fe:	6a 5b                	push   $0x5b
  801200:	68 77 1c 80 00       	push   $0x801c77
  801205:	e8 e5 02 00 00       	call   8014ef <_panic>
			panic("sys_page_map: sys_page_map fail, r:%d\n", r);
  80120a:	50                   	push   %eax
  80120b:	68 14 1d 80 00       	push   $0x801d14
  801210:	6a 61                	push   $0x61
  801212:	68 77 1c 80 00       	push   $0x801c77
  801217:	e8 d3 02 00 00       	call   8014ef <_panic>
			duppage(childid, PGNUM(va));
		}
	}

	r = sys_page_alloc(childid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  80121c:	83 ec 04             	sub    $0x4,%esp
  80121f:	6a 07                	push   $0x7
  801221:	68 00 f0 bf ee       	push   $0xeebff000
  801226:	ff 75 e4             	pushl  -0x1c(%ebp)
  801229:	e8 7e fb ff ff       	call   800dac <sys_page_alloc>
	if (r < 0){
  80122e:	83 c4 10             	add    $0x10,%esp
  801231:	85 c0                	test   %eax,%eax
  801233:	78 36                	js     80126b <fork+0x191>
		panic("fork: allocate user exception stack for child env error, %d", r);
	}
	r = sys_env_set_pgfault_upcall(childid, _pgfault_upcall);
  801235:	83 ec 08             	sub    $0x8,%esp
  801238:	68 a0 15 80 00       	push   $0x8015a0
  80123d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801240:	e8 b2 fc ff ff       	call   800ef7 <sys_env_set_pgfault_upcall>
	if (r < 0){
  801245:	83 c4 10             	add    $0x10,%esp
  801248:	85 c0                	test   %eax,%eax
  80124a:	78 34                	js     801280 <fork+0x1a6>
		panic("fork: sys_env_set_pgfault_upcall error, %d", r);
	}
	r = sys_env_set_status(childid, ENV_RUNNABLE);
  80124c:	83 ec 08             	sub    $0x8,%esp
  80124f:	6a 02                	push   $0x2
  801251:	ff 75 e4             	pushl  -0x1c(%ebp)
  801254:	e8 1a fc ff ff       	call   800e73 <sys_env_set_status>
	if(r < 0){
  801259:	83 c4 10             	add    $0x10,%esp
  80125c:	85 c0                	test   %eax,%eax
  80125e:	78 35                	js     801295 <fork+0x1bb>
		panic("forK: sys_env_set_status, r%d", r);
	}
	return childid;
}
  801260:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801263:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801266:	5b                   	pop    %ebx
  801267:	5e                   	pop    %esi
  801268:	5f                   	pop    %edi
  801269:	5d                   	pop    %ebp
  80126a:	c3                   	ret    
		panic("fork: allocate user exception stack for child env error, %d", r);
  80126b:	50                   	push   %eax
  80126c:	68 3c 1d 80 00       	push   $0x801d3c
  801271:	68 96 00 00 00       	push   $0x96
  801276:	68 77 1c 80 00       	push   $0x801c77
  80127b:	e8 6f 02 00 00       	call   8014ef <_panic>
		panic("fork: sys_env_set_pgfault_upcall error, %d", r);
  801280:	50                   	push   %eax
  801281:	68 78 1d 80 00       	push   $0x801d78
  801286:	68 9a 00 00 00       	push   $0x9a
  80128b:	68 77 1c 80 00       	push   $0x801c77
  801290:	e8 5a 02 00 00       	call   8014ef <_panic>
		panic("forK: sys_env_set_status, r%d", r);
  801295:	50                   	push   %eax
  801296:	68 ac 1c 80 00       	push   $0x801cac
  80129b:	68 9e 00 00 00       	push   $0x9e
  8012a0:	68 77 1c 80 00       	push   $0x801c77
  8012a5:	e8 45 02 00 00       	call   8014ef <_panic>

008012aa <sfork>:

// Challenge!
int
sfork(void)
{
  8012aa:	55                   	push   %ebp
  8012ab:	89 e5                	mov    %esp,%ebp
  8012ad:	57                   	push   %edi
  8012ae:	56                   	push   %esi
  8012af:	53                   	push   %ebx
  8012b0:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// return -E_INVAL;
	set_pgfault_handler(pgfault);
  8012b3:	68 de 0f 80 00       	push   $0x800fde
  8012b8:	e8 78 02 00 00       	call   801535 <set_pgfault_handler>
  8012bd:	b8 07 00 00 00       	mov    $0x7,%eax
  8012c2:	cd 30                	int    $0x30
  8012c4:	89 c6                	mov    %eax,%esi
	int i;
	uintptr_t va;
	envid_t childid = sys_exofork();
	int r;
	if (childid < 0){
  8012c6:	83 c4 10             	add    $0x10,%esp
  8012c9:	85 c0                	test   %eax,%eax
  8012cb:	78 28                	js     8012f5 <sfork+0x4b>
  8012cd:	89 c7                	mov    %eax,%edi
	}

	extern volatile pde_t uvpd[];
	extern volatile pte_t uvpt[];

	for (va = 0; va < USTACKTOP; va += PGSIZE){
  8012cf:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (childid == 0) {
  8012d4:	75 42                	jne    801318 <sfork+0x6e>
		thisenv = &envs[ENVX(sys_getenvid())];
  8012d6:	e8 93 fa ff ff       	call   800d6e <sys_getenvid>
  8012db:	25 ff 03 00 00       	and    $0x3ff,%eax
  8012e0:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8012e6:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8012eb:	a3 0c 20 80 00       	mov    %eax,0x80200c
		return 0;
  8012f0:	e9 bc 00 00 00       	jmp    8013b1 <sfork+0x107>
		panic("fork: child id < 0: %d", childid);
  8012f5:	50                   	push   %eax
  8012f6:	68 95 1c 80 00       	push   $0x801c95
  8012fb:	68 af 00 00 00       	push   $0xaf
  801300:	68 77 1c 80 00       	push   $0x801c77
  801305:	e8 e5 01 00 00       	call   8014ef <_panic>
	for (va = 0; va < USTACKTOP; va += PGSIZE){
  80130a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801310:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801316:	74 5b                	je     801373 <sfork+0xc9>
		if ((uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_U)){
  801318:	89 d8                	mov    %ebx,%eax
  80131a:	c1 e8 16             	shr    $0x16,%eax
  80131d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801324:	a8 01                	test   $0x1,%al
  801326:	74 e2                	je     80130a <sfork+0x60>
  801328:	89 d8                	mov    %ebx,%eax
  80132a:	c1 e8 0c             	shr    $0xc,%eax
  80132d:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801334:	f6 c2 01             	test   $0x1,%dl
  801337:	74 d1                	je     80130a <sfork+0x60>
  801339:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801340:	f6 c2 04             	test   $0x4,%dl
  801343:	74 c5                	je     80130a <sfork+0x60>
			void *addr = (void *)(PGNUM(va) * PGSIZE);
  801345:	c1 e0 0c             	shl    $0xc,%eax
			struct PageInfo *page;
			pte_t *pte;
			
			// page = page_lookup((envid_t)0->env_pgdir, addr, &pte);
			// page_insert(dstenv->env_pgdir, page, addr, PTE_U | PTE_P);
			r = sys_page_map((envid_t)0, addr, childid, addr, PTE_U | PTE_P);
  801348:	83 ec 0c             	sub    $0xc,%esp
  80134b:	6a 05                	push   $0x5
  80134d:	50                   	push   %eax
  80134e:	57                   	push   %edi
  80134f:	50                   	push   %eax
  801350:	6a 00                	push   $0x0
  801352:	e8 98 fa ff ff       	call   800def <sys_page_map>
			if(r < 0){
  801357:	83 c4 20             	add    $0x20,%esp
  80135a:	85 c0                	test   %eax,%eax
  80135c:	79 ac                	jns    80130a <sfork+0x60>
				panic("sfork: sys_page_map fail, r:%d\n", r);
  80135e:	50                   	push   %eax
  80135f:	68 a4 1d 80 00       	push   $0x801da4
  801364:	68 c4 00 00 00       	push   $0xc4
  801369:	68 77 1c 80 00       	push   $0x801c77
  80136e:	e8 7c 01 00 00       	call   8014ef <_panic>
			}
		}
	}

	r = sys_page_alloc(childid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801373:	83 ec 04             	sub    $0x4,%esp
  801376:	6a 07                	push   $0x7
  801378:	68 00 f0 bf ee       	push   $0xeebff000
  80137d:	56                   	push   %esi
  80137e:	e8 29 fa ff ff       	call   800dac <sys_page_alloc>
	if (r < 0){
  801383:	83 c4 10             	add    $0x10,%esp
  801386:	85 c0                	test   %eax,%eax
  801388:	78 31                	js     8013bb <sfork+0x111>
		panic("sfork: allocate user exception stack for child env error, %d", r);
	}
	r = sys_env_set_pgfault_upcall(childid, _pgfault_upcall);
  80138a:	83 ec 08             	sub    $0x8,%esp
  80138d:	68 a0 15 80 00       	push   $0x8015a0
  801392:	56                   	push   %esi
  801393:	e8 5f fb ff ff       	call   800ef7 <sys_env_set_pgfault_upcall>
	if (r < 0){
  801398:	83 c4 10             	add    $0x10,%esp
  80139b:	85 c0                	test   %eax,%eax
  80139d:	78 31                	js     8013d0 <sfork+0x126>
		panic("sfork: sys_env_set_pgfault_upcall error, %d", r);
	}
	r = sys_env_set_status(childid, ENV_RUNNABLE);
  80139f:	83 ec 08             	sub    $0x8,%esp
  8013a2:	6a 02                	push   $0x2
  8013a4:	56                   	push   %esi
  8013a5:	e8 c9 fa ff ff       	call   800e73 <sys_env_set_status>
	if(r < 0){
  8013aa:	83 c4 10             	add    $0x10,%esp
  8013ad:	85 c0                	test   %eax,%eax
  8013af:	78 34                	js     8013e5 <sfork+0x13b>
		panic("sforK: sys_env_set_status, r%d", r);
	}
	return childid;
}
  8013b1:	89 f0                	mov    %esi,%eax
  8013b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013b6:	5b                   	pop    %ebx
  8013b7:	5e                   	pop    %esi
  8013b8:	5f                   	pop    %edi
  8013b9:	5d                   	pop    %ebp
  8013ba:	c3                   	ret    
		panic("sfork: allocate user exception stack for child env error, %d", r);
  8013bb:	50                   	push   %eax
  8013bc:	68 c4 1d 80 00       	push   $0x801dc4
  8013c1:	68 cb 00 00 00       	push   $0xcb
  8013c6:	68 77 1c 80 00       	push   $0x801c77
  8013cb:	e8 1f 01 00 00       	call   8014ef <_panic>
		panic("sfork: sys_env_set_pgfault_upcall error, %d", r);
  8013d0:	50                   	push   %eax
  8013d1:	68 04 1e 80 00       	push   $0x801e04
  8013d6:	68 cf 00 00 00       	push   $0xcf
  8013db:	68 77 1c 80 00       	push   $0x801c77
  8013e0:	e8 0a 01 00 00       	call   8014ef <_panic>
		panic("sforK: sys_env_set_status, r%d", r);
  8013e5:	50                   	push   %eax
  8013e6:	68 30 1e 80 00       	push   $0x801e30
  8013eb:	68 d3 00 00 00       	push   $0xd3
  8013f0:	68 77 1c 80 00       	push   $0x801c77
  8013f5:	e8 f5 00 00 00       	call   8014ef <_panic>

008013fa <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8013fa:	55                   	push   %ebp
  8013fb:	89 e5                	mov    %esp,%ebp
  8013fd:	56                   	push   %esi
  8013fe:	53                   	push   %ebx
  8013ff:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801402:	8b 45 0c             	mov    0xc(%ebp),%eax
  801405:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// return 0;
	if(!pg)
  801408:	85 c0                	test   %eax,%eax
		pg = (void*)UTOP;
  80140a:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80140f:	0f 44 c2             	cmove  %edx,%eax
	
	int ret;

	ret = sys_ipc_recv(pg);
  801412:	83 ec 0c             	sub    $0xc,%esp
  801415:	50                   	push   %eax
  801416:	e8 41 fb ff ff       	call   800f5c <sys_ipc_recv>
	if(ret < 0){
  80141b:	83 c4 10             	add    $0x10,%esp
  80141e:	85 c0                	test   %eax,%eax
  801420:	78 2b                	js     80144d <ipc_recv+0x53>
		if(perm_store) *perm_store = 0;
		if(from_env_store) *from_env_store = 0;
		return ret;
	}
	
	if(perm_store)
  801422:	85 f6                	test   %esi,%esi
  801424:	74 0a                	je     801430 <ipc_recv+0x36>
		*perm_store = thisenv->env_ipc_perm;
  801426:	a1 0c 20 80 00       	mov    0x80200c,%eax
  80142b:	8b 40 78             	mov    0x78(%eax),%eax
  80142e:	89 06                	mov    %eax,(%esi)
	if(from_env_store)
  801430:	85 db                	test   %ebx,%ebx
  801432:	74 0a                	je     80143e <ipc_recv+0x44>
		*from_env_store = thisenv->env_ipc_from;
  801434:	a1 0c 20 80 00       	mov    0x80200c,%eax
  801439:	8b 40 74             	mov    0x74(%eax),%eax
  80143c:	89 03                	mov    %eax,(%ebx)

	return thisenv->env_ipc_value;
  80143e:	a1 0c 20 80 00       	mov    0x80200c,%eax
  801443:	8b 40 70             	mov    0x70(%eax),%eax
}
  801446:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801449:	5b                   	pop    %ebx
  80144a:	5e                   	pop    %esi
  80144b:	5d                   	pop    %ebp
  80144c:	c3                   	ret    
		if(perm_store) *perm_store = 0;
  80144d:	85 f6                	test   %esi,%esi
  80144f:	74 06                	je     801457 <ipc_recv+0x5d>
  801451:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(from_env_store) *from_env_store = 0;
  801457:	85 db                	test   %ebx,%ebx
  801459:	74 eb                	je     801446 <ipc_recv+0x4c>
  80145b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801461:	eb e3                	jmp    801446 <ipc_recv+0x4c>

00801463 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801463:	55                   	push   %ebp
  801464:	89 e5                	mov    %esp,%ebp
  801466:	57                   	push   %edi
  801467:	56                   	push   %esi
  801468:	53                   	push   %ebx
  801469:	83 ec 0c             	sub    $0xc,%esp
  80146c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80146f:	8b 75 0c             	mov    0xc(%ebp),%esi
  801472:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
	if (!pg)
  801475:	85 db                	test   %ebx,%ebx
		pg = (void*)UTOP;
  801477:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80147c:	0f 44 d8             	cmove  %eax,%ebx

	int ret = -E_IPC_NOT_RECV;
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))) {
  80147f:	ff 75 14             	pushl  0x14(%ebp)
  801482:	53                   	push   %ebx
  801483:	56                   	push   %esi
  801484:	57                   	push   %edi
  801485:	e8 af fa ff ff       	call   800f39 <sys_ipc_try_send>
  80148a:	83 c4 10             	add    $0x10,%esp
  80148d:	85 c0                	test   %eax,%eax
  80148f:	74 17                	je     8014a8 <ipc_send+0x45>
		if(ret != -E_IPC_NOT_RECV){
  801491:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801494:	74 e9                	je     80147f <ipc_send+0x1c>
			panic("ipc_send: ret : %d", ret);
  801496:	50                   	push   %eax
  801497:	68 4f 1e 80 00       	push   $0x801e4f
  80149c:	6a 43                	push   $0x43
  80149e:	68 62 1e 80 00       	push   $0x801e62
  8014a3:	e8 47 00 00 00       	call   8014ef <_panic>
			sys_yield();
		}
	}
}
  8014a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014ab:	5b                   	pop    %ebx
  8014ac:	5e                   	pop    %esi
  8014ad:	5f                   	pop    %edi
  8014ae:	5d                   	pop    %ebp
  8014af:	c3                   	ret    

008014b0 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8014b0:	55                   	push   %ebp
  8014b1:	89 e5                	mov    %esp,%ebp
  8014b3:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8014b6:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8014bb:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  8014c1:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8014c7:	8b 52 50             	mov    0x50(%edx),%edx
  8014ca:	39 ca                	cmp    %ecx,%edx
  8014cc:	74 11                	je     8014df <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  8014ce:	83 c0 01             	add    $0x1,%eax
  8014d1:	3d 00 04 00 00       	cmp    $0x400,%eax
  8014d6:	75 e3                	jne    8014bb <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8014d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8014dd:	eb 0e                	jmp    8014ed <ipc_find_env+0x3d>
			return envs[i].env_id;
  8014df:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8014e5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8014ea:	8b 40 48             	mov    0x48(%eax),%eax
}
  8014ed:	5d                   	pop    %ebp
  8014ee:	c3                   	ret    

008014ef <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8014ef:	55                   	push   %ebp
  8014f0:	89 e5                	mov    %esp,%ebp
  8014f2:	56                   	push   %esi
  8014f3:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8014f4:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8014f7:	8b 35 08 20 80 00    	mov    0x802008,%esi
  8014fd:	e8 6c f8 ff ff       	call   800d6e <sys_getenvid>
  801502:	83 ec 0c             	sub    $0xc,%esp
  801505:	ff 75 0c             	pushl  0xc(%ebp)
  801508:	ff 75 08             	pushl  0x8(%ebp)
  80150b:	56                   	push   %esi
  80150c:	50                   	push   %eax
  80150d:	68 6c 1e 80 00       	push   $0x801e6c
  801512:	e8 7d ed ff ff       	call   800294 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801517:	83 c4 18             	add    $0x18,%esp
  80151a:	53                   	push   %ebx
  80151b:	ff 75 10             	pushl  0x10(%ebp)
  80151e:	e8 20 ed ff ff       	call   800243 <vcprintf>
	cprintf("\n");
  801523:	c7 04 24 75 1c 80 00 	movl   $0x801c75,(%esp)
  80152a:	e8 65 ed ff ff       	call   800294 <cprintf>
  80152f:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801532:	cc                   	int3   
  801533:	eb fd                	jmp    801532 <_panic+0x43>

00801535 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801535:	55                   	push   %ebp
  801536:	89 e5                	mov    %esp,%ebp
  801538:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80153b:	83 3d 10 20 80 00 00 	cmpl   $0x0,0x802010
  801542:	74 0a                	je     80154e <set_pgfault_handler+0x19>
			panic("set_pgfault_handler: sys_env_set_pgfault_upcall fail, ret:%d", ret);
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801544:	8b 45 08             	mov    0x8(%ebp),%eax
  801547:	a3 10 20 80 00       	mov    %eax,0x802010
}
  80154c:	c9                   	leave  
  80154d:	c3                   	ret    
		ret = sys_page_alloc((envid_t)0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W);
  80154e:	83 ec 04             	sub    $0x4,%esp
  801551:	6a 07                	push   $0x7
  801553:	68 00 f0 bf ee       	push   $0xeebff000
  801558:	6a 00                	push   $0x0
  80155a:	e8 4d f8 ff ff       	call   800dac <sys_page_alloc>
		if(ret < 0){
  80155f:	83 c4 10             	add    $0x10,%esp
  801562:	85 c0                	test   %eax,%eax
  801564:	78 28                	js     80158e <set_pgfault_handler+0x59>
    	ret = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  801566:	83 ec 08             	sub    $0x8,%esp
  801569:	68 a0 15 80 00       	push   $0x8015a0
  80156e:	6a 00                	push   $0x0
  801570:	e8 82 f9 ff ff       	call   800ef7 <sys_env_set_pgfault_upcall>
		if(ret < 0){
  801575:	83 c4 10             	add    $0x10,%esp
  801578:	85 c0                	test   %eax,%eax
  80157a:	79 c8                	jns    801544 <set_pgfault_handler+0xf>
			panic("set_pgfault_handler: sys_env_set_pgfault_upcall fail, ret:%d", ret);
  80157c:	50                   	push   %eax
  80157d:	68 c4 1e 80 00       	push   $0x801ec4
  801582:	6a 28                	push   $0x28
  801584:	68 04 1f 80 00       	push   $0x801f04
  801589:	e8 61 ff ff ff       	call   8014ef <_panic>
			panic("set_pgfault_handler: sys_page_alloc fail, ret:%d", ret);
  80158e:	50                   	push   %eax
  80158f:	68 90 1e 80 00       	push   $0x801e90
  801594:	6a 24                	push   $0x24
  801596:	68 04 1f 80 00       	push   $0x801f04
  80159b:	e8 4f ff ff ff       	call   8014ef <_panic>

008015a0 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8015a0:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8015a1:	a1 10 20 80 00       	mov    0x802010,%eax
	call *%eax
  8015a6:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8015a8:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %edi
  8015ab:	8b 7c 24 28          	mov    0x28(%esp),%edi
	movl 0x30(%esp), %esi
  8015af:	8b 74 24 30          	mov    0x30(%esp),%esi
	subl $4, %esi
  8015b3:	83 ee 04             	sub    $0x4,%esi
	movl %edi, (%esi)
  8015b6:	89 3e                	mov    %edi,(%esi)
	movl %esi, 0x30(%esp)
  8015b8:	89 74 24 30          	mov    %esi,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  8015bc:	83 c4 08             	add    $0x8,%esp
	popal
  8015bf:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8015c0:	83 c4 04             	add    $0x4,%esp
	popfl
  8015c3:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8015c4:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  8015c5:	c3                   	ret    
  8015c6:	66 90                	xchg   %ax,%ax
  8015c8:	66 90                	xchg   %ax,%ax
  8015ca:	66 90                	xchg   %ax,%ax
  8015cc:	66 90                	xchg   %ax,%ax
  8015ce:	66 90                	xchg   %ax,%ax

008015d0 <__udivdi3>:
  8015d0:	55                   	push   %ebp
  8015d1:	57                   	push   %edi
  8015d2:	56                   	push   %esi
  8015d3:	53                   	push   %ebx
  8015d4:	83 ec 1c             	sub    $0x1c,%esp
  8015d7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8015db:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8015df:	8b 74 24 34          	mov    0x34(%esp),%esi
  8015e3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8015e7:	85 d2                	test   %edx,%edx
  8015e9:	75 4d                	jne    801638 <__udivdi3+0x68>
  8015eb:	39 f3                	cmp    %esi,%ebx
  8015ed:	76 19                	jbe    801608 <__udivdi3+0x38>
  8015ef:	31 ff                	xor    %edi,%edi
  8015f1:	89 e8                	mov    %ebp,%eax
  8015f3:	89 f2                	mov    %esi,%edx
  8015f5:	f7 f3                	div    %ebx
  8015f7:	89 fa                	mov    %edi,%edx
  8015f9:	83 c4 1c             	add    $0x1c,%esp
  8015fc:	5b                   	pop    %ebx
  8015fd:	5e                   	pop    %esi
  8015fe:	5f                   	pop    %edi
  8015ff:	5d                   	pop    %ebp
  801600:	c3                   	ret    
  801601:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801608:	89 d9                	mov    %ebx,%ecx
  80160a:	85 db                	test   %ebx,%ebx
  80160c:	75 0b                	jne    801619 <__udivdi3+0x49>
  80160e:	b8 01 00 00 00       	mov    $0x1,%eax
  801613:	31 d2                	xor    %edx,%edx
  801615:	f7 f3                	div    %ebx
  801617:	89 c1                	mov    %eax,%ecx
  801619:	31 d2                	xor    %edx,%edx
  80161b:	89 f0                	mov    %esi,%eax
  80161d:	f7 f1                	div    %ecx
  80161f:	89 c6                	mov    %eax,%esi
  801621:	89 e8                	mov    %ebp,%eax
  801623:	89 f7                	mov    %esi,%edi
  801625:	f7 f1                	div    %ecx
  801627:	89 fa                	mov    %edi,%edx
  801629:	83 c4 1c             	add    $0x1c,%esp
  80162c:	5b                   	pop    %ebx
  80162d:	5e                   	pop    %esi
  80162e:	5f                   	pop    %edi
  80162f:	5d                   	pop    %ebp
  801630:	c3                   	ret    
  801631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801638:	39 f2                	cmp    %esi,%edx
  80163a:	77 1c                	ja     801658 <__udivdi3+0x88>
  80163c:	0f bd fa             	bsr    %edx,%edi
  80163f:	83 f7 1f             	xor    $0x1f,%edi
  801642:	75 2c                	jne    801670 <__udivdi3+0xa0>
  801644:	39 f2                	cmp    %esi,%edx
  801646:	72 06                	jb     80164e <__udivdi3+0x7e>
  801648:	31 c0                	xor    %eax,%eax
  80164a:	39 eb                	cmp    %ebp,%ebx
  80164c:	77 a9                	ja     8015f7 <__udivdi3+0x27>
  80164e:	b8 01 00 00 00       	mov    $0x1,%eax
  801653:	eb a2                	jmp    8015f7 <__udivdi3+0x27>
  801655:	8d 76 00             	lea    0x0(%esi),%esi
  801658:	31 ff                	xor    %edi,%edi
  80165a:	31 c0                	xor    %eax,%eax
  80165c:	89 fa                	mov    %edi,%edx
  80165e:	83 c4 1c             	add    $0x1c,%esp
  801661:	5b                   	pop    %ebx
  801662:	5e                   	pop    %esi
  801663:	5f                   	pop    %edi
  801664:	5d                   	pop    %ebp
  801665:	c3                   	ret    
  801666:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80166d:	8d 76 00             	lea    0x0(%esi),%esi
  801670:	89 f9                	mov    %edi,%ecx
  801672:	b8 20 00 00 00       	mov    $0x20,%eax
  801677:	29 f8                	sub    %edi,%eax
  801679:	d3 e2                	shl    %cl,%edx
  80167b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80167f:	89 c1                	mov    %eax,%ecx
  801681:	89 da                	mov    %ebx,%edx
  801683:	d3 ea                	shr    %cl,%edx
  801685:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801689:	09 d1                	or     %edx,%ecx
  80168b:	89 f2                	mov    %esi,%edx
  80168d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801691:	89 f9                	mov    %edi,%ecx
  801693:	d3 e3                	shl    %cl,%ebx
  801695:	89 c1                	mov    %eax,%ecx
  801697:	d3 ea                	shr    %cl,%edx
  801699:	89 f9                	mov    %edi,%ecx
  80169b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80169f:	89 eb                	mov    %ebp,%ebx
  8016a1:	d3 e6                	shl    %cl,%esi
  8016a3:	89 c1                	mov    %eax,%ecx
  8016a5:	d3 eb                	shr    %cl,%ebx
  8016a7:	09 de                	or     %ebx,%esi
  8016a9:	89 f0                	mov    %esi,%eax
  8016ab:	f7 74 24 08          	divl   0x8(%esp)
  8016af:	89 d6                	mov    %edx,%esi
  8016b1:	89 c3                	mov    %eax,%ebx
  8016b3:	f7 64 24 0c          	mull   0xc(%esp)
  8016b7:	39 d6                	cmp    %edx,%esi
  8016b9:	72 15                	jb     8016d0 <__udivdi3+0x100>
  8016bb:	89 f9                	mov    %edi,%ecx
  8016bd:	d3 e5                	shl    %cl,%ebp
  8016bf:	39 c5                	cmp    %eax,%ebp
  8016c1:	73 04                	jae    8016c7 <__udivdi3+0xf7>
  8016c3:	39 d6                	cmp    %edx,%esi
  8016c5:	74 09                	je     8016d0 <__udivdi3+0x100>
  8016c7:	89 d8                	mov    %ebx,%eax
  8016c9:	31 ff                	xor    %edi,%edi
  8016cb:	e9 27 ff ff ff       	jmp    8015f7 <__udivdi3+0x27>
  8016d0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8016d3:	31 ff                	xor    %edi,%edi
  8016d5:	e9 1d ff ff ff       	jmp    8015f7 <__udivdi3+0x27>
  8016da:	66 90                	xchg   %ax,%ax
  8016dc:	66 90                	xchg   %ax,%ax
  8016de:	66 90                	xchg   %ax,%ax

008016e0 <__umoddi3>:
  8016e0:	55                   	push   %ebp
  8016e1:	57                   	push   %edi
  8016e2:	56                   	push   %esi
  8016e3:	53                   	push   %ebx
  8016e4:	83 ec 1c             	sub    $0x1c,%esp
  8016e7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8016eb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8016ef:	8b 74 24 30          	mov    0x30(%esp),%esi
  8016f3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8016f7:	89 da                	mov    %ebx,%edx
  8016f9:	85 c0                	test   %eax,%eax
  8016fb:	75 43                	jne    801740 <__umoddi3+0x60>
  8016fd:	39 df                	cmp    %ebx,%edi
  8016ff:	76 17                	jbe    801718 <__umoddi3+0x38>
  801701:	89 f0                	mov    %esi,%eax
  801703:	f7 f7                	div    %edi
  801705:	89 d0                	mov    %edx,%eax
  801707:	31 d2                	xor    %edx,%edx
  801709:	83 c4 1c             	add    $0x1c,%esp
  80170c:	5b                   	pop    %ebx
  80170d:	5e                   	pop    %esi
  80170e:	5f                   	pop    %edi
  80170f:	5d                   	pop    %ebp
  801710:	c3                   	ret    
  801711:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801718:	89 fd                	mov    %edi,%ebp
  80171a:	85 ff                	test   %edi,%edi
  80171c:	75 0b                	jne    801729 <__umoddi3+0x49>
  80171e:	b8 01 00 00 00       	mov    $0x1,%eax
  801723:	31 d2                	xor    %edx,%edx
  801725:	f7 f7                	div    %edi
  801727:	89 c5                	mov    %eax,%ebp
  801729:	89 d8                	mov    %ebx,%eax
  80172b:	31 d2                	xor    %edx,%edx
  80172d:	f7 f5                	div    %ebp
  80172f:	89 f0                	mov    %esi,%eax
  801731:	f7 f5                	div    %ebp
  801733:	89 d0                	mov    %edx,%eax
  801735:	eb d0                	jmp    801707 <__umoddi3+0x27>
  801737:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80173e:	66 90                	xchg   %ax,%ax
  801740:	89 f1                	mov    %esi,%ecx
  801742:	39 d8                	cmp    %ebx,%eax
  801744:	76 0a                	jbe    801750 <__umoddi3+0x70>
  801746:	89 f0                	mov    %esi,%eax
  801748:	83 c4 1c             	add    $0x1c,%esp
  80174b:	5b                   	pop    %ebx
  80174c:	5e                   	pop    %esi
  80174d:	5f                   	pop    %edi
  80174e:	5d                   	pop    %ebp
  80174f:	c3                   	ret    
  801750:	0f bd e8             	bsr    %eax,%ebp
  801753:	83 f5 1f             	xor    $0x1f,%ebp
  801756:	75 20                	jne    801778 <__umoddi3+0x98>
  801758:	39 d8                	cmp    %ebx,%eax
  80175a:	0f 82 b0 00 00 00    	jb     801810 <__umoddi3+0x130>
  801760:	39 f7                	cmp    %esi,%edi
  801762:	0f 86 a8 00 00 00    	jbe    801810 <__umoddi3+0x130>
  801768:	89 c8                	mov    %ecx,%eax
  80176a:	83 c4 1c             	add    $0x1c,%esp
  80176d:	5b                   	pop    %ebx
  80176e:	5e                   	pop    %esi
  80176f:	5f                   	pop    %edi
  801770:	5d                   	pop    %ebp
  801771:	c3                   	ret    
  801772:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801778:	89 e9                	mov    %ebp,%ecx
  80177a:	ba 20 00 00 00       	mov    $0x20,%edx
  80177f:	29 ea                	sub    %ebp,%edx
  801781:	d3 e0                	shl    %cl,%eax
  801783:	89 44 24 08          	mov    %eax,0x8(%esp)
  801787:	89 d1                	mov    %edx,%ecx
  801789:	89 f8                	mov    %edi,%eax
  80178b:	d3 e8                	shr    %cl,%eax
  80178d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801791:	89 54 24 04          	mov    %edx,0x4(%esp)
  801795:	8b 54 24 04          	mov    0x4(%esp),%edx
  801799:	09 c1                	or     %eax,%ecx
  80179b:	89 d8                	mov    %ebx,%eax
  80179d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8017a1:	89 e9                	mov    %ebp,%ecx
  8017a3:	d3 e7                	shl    %cl,%edi
  8017a5:	89 d1                	mov    %edx,%ecx
  8017a7:	d3 e8                	shr    %cl,%eax
  8017a9:	89 e9                	mov    %ebp,%ecx
  8017ab:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8017af:	d3 e3                	shl    %cl,%ebx
  8017b1:	89 c7                	mov    %eax,%edi
  8017b3:	89 d1                	mov    %edx,%ecx
  8017b5:	89 f0                	mov    %esi,%eax
  8017b7:	d3 e8                	shr    %cl,%eax
  8017b9:	89 e9                	mov    %ebp,%ecx
  8017bb:	89 fa                	mov    %edi,%edx
  8017bd:	d3 e6                	shl    %cl,%esi
  8017bf:	09 d8                	or     %ebx,%eax
  8017c1:	f7 74 24 08          	divl   0x8(%esp)
  8017c5:	89 d1                	mov    %edx,%ecx
  8017c7:	89 f3                	mov    %esi,%ebx
  8017c9:	f7 64 24 0c          	mull   0xc(%esp)
  8017cd:	89 c6                	mov    %eax,%esi
  8017cf:	89 d7                	mov    %edx,%edi
  8017d1:	39 d1                	cmp    %edx,%ecx
  8017d3:	72 06                	jb     8017db <__umoddi3+0xfb>
  8017d5:	75 10                	jne    8017e7 <__umoddi3+0x107>
  8017d7:	39 c3                	cmp    %eax,%ebx
  8017d9:	73 0c                	jae    8017e7 <__umoddi3+0x107>
  8017db:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8017df:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8017e3:	89 d7                	mov    %edx,%edi
  8017e5:	89 c6                	mov    %eax,%esi
  8017e7:	89 ca                	mov    %ecx,%edx
  8017e9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8017ee:	29 f3                	sub    %esi,%ebx
  8017f0:	19 fa                	sbb    %edi,%edx
  8017f2:	89 d0                	mov    %edx,%eax
  8017f4:	d3 e0                	shl    %cl,%eax
  8017f6:	89 e9                	mov    %ebp,%ecx
  8017f8:	d3 eb                	shr    %cl,%ebx
  8017fa:	d3 ea                	shr    %cl,%edx
  8017fc:	09 d8                	or     %ebx,%eax
  8017fe:	83 c4 1c             	add    $0x1c,%esp
  801801:	5b                   	pop    %ebx
  801802:	5e                   	pop    %esi
  801803:	5f                   	pop    %edi
  801804:	5d                   	pop    %ebp
  801805:	c3                   	ret    
  801806:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80180d:	8d 76 00             	lea    0x0(%esi),%esi
  801810:	89 da                	mov    %ebx,%edx
  801812:	29 fe                	sub    %edi,%esi
  801814:	19 c2                	sbb    %eax,%edx
  801816:	89 f1                	mov    %esi,%ecx
  801818:	89 c8                	mov    %ecx,%eax
  80181a:	e9 4b ff ff ff       	jmp    80176a <__umoddi3+0x8a>
