
obj/user/cat.debug:     file format elf32-i386


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
  80002c:	e8 fc 00 00 00       	call   80012d <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <cat>:

char buf[8192];

void
cat(int f, char *s)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	8b 75 08             	mov    0x8(%ebp),%esi
	long n;
	int r;

	while ((n = read(f, buf, (long)sizeof(buf))) > 0)
  80003b:	83 ec 04             	sub    $0x4,%esp
  80003e:	68 00 20 00 00       	push   $0x2000
  800043:	68 20 40 80 00       	push   $0x804020
  800048:	56                   	push   %esi
  800049:	e8 43 12 00 00       	call   801291 <read>
  80004e:	89 c3                	mov    %eax,%ebx
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	85 c0                	test   %eax,%eax
  800055:	7e 2f                	jle    800086 <cat+0x53>
		if ((r = write(1, buf, n)) != n)
  800057:	83 ec 04             	sub    $0x4,%esp
  80005a:	53                   	push   %ebx
  80005b:	68 20 40 80 00       	push   $0x804020
  800060:	6a 01                	push   $0x1
  800062:	e8 f6 12 00 00       	call   80135d <write>
  800067:	83 c4 10             	add    $0x10,%esp
  80006a:	39 c3                	cmp    %eax,%ebx
  80006c:	74 cd                	je     80003b <cat+0x8>
			panic("write error copying %s: %e", s, r);
  80006e:	83 ec 0c             	sub    $0xc,%esp
  800071:	50                   	push   %eax
  800072:	ff 75 0c             	pushl  0xc(%ebp)
  800075:	68 e0 20 80 00       	push   $0x8020e0
  80007a:	6a 0d                	push   $0xd
  80007c:	68 fb 20 80 00       	push   $0x8020fb
  800081:	e8 02 01 00 00       	call   800188 <_panic>
	if (n < 0)
  800086:	78 07                	js     80008f <cat+0x5c>
		panic("error reading %s: %e", s, n);
}
  800088:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80008b:	5b                   	pop    %ebx
  80008c:	5e                   	pop    %esi
  80008d:	5d                   	pop    %ebp
  80008e:	c3                   	ret    
		panic("error reading %s: %e", s, n);
  80008f:	83 ec 0c             	sub    $0xc,%esp
  800092:	50                   	push   %eax
  800093:	ff 75 0c             	pushl  0xc(%ebp)
  800096:	68 06 21 80 00       	push   $0x802106
  80009b:	6a 0f                	push   $0xf
  80009d:	68 fb 20 80 00       	push   $0x8020fb
  8000a2:	e8 e1 00 00 00       	call   800188 <_panic>

008000a7 <umain>:

void
umain(int argc, char **argv)
{
  8000a7:	55                   	push   %ebp
  8000a8:	89 e5                	mov    %esp,%ebp
  8000aa:	57                   	push   %edi
  8000ab:	56                   	push   %esi
  8000ac:	53                   	push   %ebx
  8000ad:	83 ec 0c             	sub    $0xc,%esp
  8000b0:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int f, i;

	binaryname = "cat";
  8000b3:	c7 05 00 30 80 00 1b 	movl   $0x80211b,0x803000
  8000ba:	21 80 00 
	if (argc == 1)
		cat(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  8000bd:	bb 01 00 00 00       	mov    $0x1,%ebx
	if (argc == 1)
  8000c2:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8000c6:	75 31                	jne    8000f9 <umain+0x52>
		cat(0, "<stdin>");
  8000c8:	83 ec 08             	sub    $0x8,%esp
  8000cb:	68 1f 21 80 00       	push   $0x80211f
  8000d0:	6a 00                	push   $0x0
  8000d2:	e8 5c ff ff ff       	call   800033 <cat>
  8000d7:	83 c4 10             	add    $0x10,%esp
			else {
				cat(f, argv[i]);
				close(f);
			}
		}
}
  8000da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000dd:	5b                   	pop    %ebx
  8000de:	5e                   	pop    %esi
  8000df:	5f                   	pop    %edi
  8000e0:	5d                   	pop    %ebp
  8000e1:	c3                   	ret    
				printf("can't open %s: %e\n", argv[i], f);
  8000e2:	83 ec 04             	sub    $0x4,%esp
  8000e5:	50                   	push   %eax
  8000e6:	ff 34 9f             	pushl  (%edi,%ebx,4)
  8000e9:	68 27 21 80 00       	push   $0x802127
  8000ee:	e8 78 17 00 00       	call   80186b <printf>
  8000f3:	83 c4 10             	add    $0x10,%esp
		for (i = 1; i < argc; i++) {
  8000f6:	83 c3 01             	add    $0x1,%ebx
  8000f9:	3b 5d 08             	cmp    0x8(%ebp),%ebx
  8000fc:	7d dc                	jge    8000da <umain+0x33>
			f = open(argv[i], O_RDONLY);
  8000fe:	83 ec 08             	sub    $0x8,%esp
  800101:	6a 00                	push   $0x0
  800103:	ff 34 9f             	pushl  (%edi,%ebx,4)
  800106:	e8 bd 15 00 00       	call   8016c8 <open>
  80010b:	89 c6                	mov    %eax,%esi
			if (f < 0)
  80010d:	83 c4 10             	add    $0x10,%esp
  800110:	85 c0                	test   %eax,%eax
  800112:	78 ce                	js     8000e2 <umain+0x3b>
				cat(f, argv[i]);
  800114:	83 ec 08             	sub    $0x8,%esp
  800117:	ff 34 9f             	pushl  (%edi,%ebx,4)
  80011a:	50                   	push   %eax
  80011b:	e8 13 ff ff ff       	call   800033 <cat>
				close(f);
  800120:	89 34 24             	mov    %esi,(%esp)
  800123:	e8 2b 10 00 00       	call   801153 <close>
  800128:	83 c4 10             	add    $0x10,%esp
  80012b:	eb c9                	jmp    8000f6 <umain+0x4f>

0080012d <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80012d:	55                   	push   %ebp
  80012e:	89 e5                	mov    %esp,%ebp
  800130:	56                   	push   %esi
  800131:	53                   	push   %ebx
  800132:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800135:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	// thisenv = 0;
	thisenv = &(envs[ENVX(sys_getenvid())]);
  800138:	e8 00 0c 00 00       	call   800d3d <sys_getenvid>
  80013d:	25 ff 03 00 00       	and    $0x3ff,%eax
  800142:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  800148:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80014d:	a3 20 60 80 00       	mov    %eax,0x806020

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800152:	85 db                	test   %ebx,%ebx
  800154:	7e 07                	jle    80015d <libmain+0x30>
		binaryname = argv[0];
  800156:	8b 06                	mov    (%esi),%eax
  800158:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80015d:	83 ec 08             	sub    $0x8,%esp
  800160:	56                   	push   %esi
  800161:	53                   	push   %ebx
  800162:	e8 40 ff ff ff       	call   8000a7 <umain>

	// exit gracefully
	exit();
  800167:	e8 0a 00 00 00       	call   800176 <exit>
}
  80016c:	83 c4 10             	add    $0x10,%esp
  80016f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800172:	5b                   	pop    %ebx
  800173:	5e                   	pop    %esi
  800174:	5d                   	pop    %ebp
  800175:	c3                   	ret    

00800176 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800176:	55                   	push   %ebp
  800177:	89 e5                	mov    %esp,%ebp
  800179:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  80017c:	6a 00                	push   $0x0
  80017e:	e8 79 0b 00 00       	call   800cfc <sys_env_destroy>
}
  800183:	83 c4 10             	add    $0x10,%esp
  800186:	c9                   	leave  
  800187:	c3                   	ret    

00800188 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800188:	55                   	push   %ebp
  800189:	89 e5                	mov    %esp,%ebp
  80018b:	56                   	push   %esi
  80018c:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80018d:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800190:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800196:	e8 a2 0b 00 00       	call   800d3d <sys_getenvid>
  80019b:	83 ec 0c             	sub    $0xc,%esp
  80019e:	ff 75 0c             	pushl  0xc(%ebp)
  8001a1:	ff 75 08             	pushl  0x8(%ebp)
  8001a4:	56                   	push   %esi
  8001a5:	50                   	push   %eax
  8001a6:	68 44 21 80 00       	push   $0x802144
  8001ab:	e8 b3 00 00 00       	call   800263 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001b0:	83 c4 18             	add    $0x18,%esp
  8001b3:	53                   	push   %ebx
  8001b4:	ff 75 10             	pushl  0x10(%ebp)
  8001b7:	e8 56 00 00 00       	call   800212 <vcprintf>
	cprintf("\n");
  8001bc:	c7 04 24 05 26 80 00 	movl   $0x802605,(%esp)
  8001c3:	e8 9b 00 00 00       	call   800263 <cprintf>
  8001c8:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001cb:	cc                   	int3   
  8001cc:	eb fd                	jmp    8001cb <_panic+0x43>

008001ce <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001ce:	55                   	push   %ebp
  8001cf:	89 e5                	mov    %esp,%ebp
  8001d1:	53                   	push   %ebx
  8001d2:	83 ec 04             	sub    $0x4,%esp
  8001d5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001d8:	8b 13                	mov    (%ebx),%edx
  8001da:	8d 42 01             	lea    0x1(%edx),%eax
  8001dd:	89 03                	mov    %eax,(%ebx)
  8001df:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001e2:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001e6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001eb:	74 09                	je     8001f6 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001ed:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001f4:	c9                   	leave  
  8001f5:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001f6:	83 ec 08             	sub    $0x8,%esp
  8001f9:	68 ff 00 00 00       	push   $0xff
  8001fe:	8d 43 08             	lea    0x8(%ebx),%eax
  800201:	50                   	push   %eax
  800202:	e8 b8 0a 00 00       	call   800cbf <sys_cputs>
		b->idx = 0;
  800207:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80020d:	83 c4 10             	add    $0x10,%esp
  800210:	eb db                	jmp    8001ed <putch+0x1f>

00800212 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800212:	55                   	push   %ebp
  800213:	89 e5                	mov    %esp,%ebp
  800215:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80021b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800222:	00 00 00 
	b.cnt = 0;
  800225:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80022c:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80022f:	ff 75 0c             	pushl  0xc(%ebp)
  800232:	ff 75 08             	pushl  0x8(%ebp)
  800235:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80023b:	50                   	push   %eax
  80023c:	68 ce 01 80 00       	push   $0x8001ce
  800241:	e8 4a 01 00 00       	call   800390 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800246:	83 c4 08             	add    $0x8,%esp
  800249:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80024f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800255:	50                   	push   %eax
  800256:	e8 64 0a 00 00       	call   800cbf <sys_cputs>

	return b.cnt;
}
  80025b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800261:	c9                   	leave  
  800262:	c3                   	ret    

00800263 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800263:	55                   	push   %ebp
  800264:	89 e5                	mov    %esp,%ebp
  800266:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800269:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80026c:	50                   	push   %eax
  80026d:	ff 75 08             	pushl  0x8(%ebp)
  800270:	e8 9d ff ff ff       	call   800212 <vcprintf>
	va_end(ap);

	return cnt;
}
  800275:	c9                   	leave  
  800276:	c3                   	ret    

00800277 <printnum>:


static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800277:	55                   	push   %ebp
  800278:	89 e5                	mov    %esp,%ebp
  80027a:	57                   	push   %edi
  80027b:	56                   	push   %esi
  80027c:	53                   	push   %ebx
  80027d:	83 ec 1c             	sub    $0x1c,%esp
  800280:	89 c6                	mov    %eax,%esi
  800282:	89 d7                	mov    %edx,%edi
  800284:	8b 45 08             	mov    0x8(%ebp),%eax
  800287:	8b 55 0c             	mov    0xc(%ebp),%edx
  80028a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80028d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800290:	8b 45 10             	mov    0x10(%ebp),%eax
  800293:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	// to support '-'
	if(padc == '-'){
  800296:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80029a:	74 2c                	je     8002c8 <printnum+0x51>
		while (--width > 0)
			putch(' ', putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80029c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80029f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8002a6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002a9:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8002ac:	39 c2                	cmp    %eax,%edx
  8002ae:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8002b1:	73 43                	jae    8002f6 <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8002b3:	83 eb 01             	sub    $0x1,%ebx
  8002b6:	85 db                	test   %ebx,%ebx
  8002b8:	7e 6c                	jle    800326 <printnum+0xaf>
			putch(padc, putdat);
  8002ba:	83 ec 08             	sub    $0x8,%esp
  8002bd:	57                   	push   %edi
  8002be:	ff 75 18             	pushl  0x18(%ebp)
  8002c1:	ff d6                	call   *%esi
  8002c3:	83 c4 10             	add    $0x10,%esp
  8002c6:	eb eb                	jmp    8002b3 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8002c8:	83 ec 0c             	sub    $0xc,%esp
  8002cb:	6a 20                	push   $0x20
  8002cd:	6a 00                	push   $0x0
  8002cf:	50                   	push   %eax
  8002d0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002d3:	ff 75 e0             	pushl  -0x20(%ebp)
  8002d6:	89 fa                	mov    %edi,%edx
  8002d8:	89 f0                	mov    %esi,%eax
  8002da:	e8 98 ff ff ff       	call   800277 <printnum>
		while (--width > 0)
  8002df:	83 c4 20             	add    $0x20,%esp
  8002e2:	83 eb 01             	sub    $0x1,%ebx
  8002e5:	85 db                	test   %ebx,%ebx
  8002e7:	7e 65                	jle    80034e <printnum+0xd7>
			putch(' ', putdat);
  8002e9:	83 ec 08             	sub    $0x8,%esp
  8002ec:	57                   	push   %edi
  8002ed:	6a 20                	push   $0x20
  8002ef:	ff d6                	call   *%esi
  8002f1:	83 c4 10             	add    $0x10,%esp
  8002f4:	eb ec                	jmp    8002e2 <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002f6:	83 ec 0c             	sub    $0xc,%esp
  8002f9:	ff 75 18             	pushl  0x18(%ebp)
  8002fc:	83 eb 01             	sub    $0x1,%ebx
  8002ff:	53                   	push   %ebx
  800300:	50                   	push   %eax
  800301:	83 ec 08             	sub    $0x8,%esp
  800304:	ff 75 dc             	pushl  -0x24(%ebp)
  800307:	ff 75 d8             	pushl  -0x28(%ebp)
  80030a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80030d:	ff 75 e0             	pushl  -0x20(%ebp)
  800310:	e8 6b 1b 00 00       	call   801e80 <__udivdi3>
  800315:	83 c4 18             	add    $0x18,%esp
  800318:	52                   	push   %edx
  800319:	50                   	push   %eax
  80031a:	89 fa                	mov    %edi,%edx
  80031c:	89 f0                	mov    %esi,%eax
  80031e:	e8 54 ff ff ff       	call   800277 <printnum>
  800323:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800326:	83 ec 08             	sub    $0x8,%esp
  800329:	57                   	push   %edi
  80032a:	83 ec 04             	sub    $0x4,%esp
  80032d:	ff 75 dc             	pushl  -0x24(%ebp)
  800330:	ff 75 d8             	pushl  -0x28(%ebp)
  800333:	ff 75 e4             	pushl  -0x1c(%ebp)
  800336:	ff 75 e0             	pushl  -0x20(%ebp)
  800339:	e8 52 1c 00 00       	call   801f90 <__umoddi3>
  80033e:	83 c4 14             	add    $0x14,%esp
  800341:	0f be 80 67 21 80 00 	movsbl 0x802167(%eax),%eax
  800348:	50                   	push   %eax
  800349:	ff d6                	call   *%esi
  80034b:	83 c4 10             	add    $0x10,%esp
}
  80034e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800351:	5b                   	pop    %ebx
  800352:	5e                   	pop    %esi
  800353:	5f                   	pop    %edi
  800354:	5d                   	pop    %ebp
  800355:	c3                   	ret    

00800356 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800356:	55                   	push   %ebp
  800357:	89 e5                	mov    %esp,%ebp
  800359:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80035c:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800360:	8b 10                	mov    (%eax),%edx
  800362:	3b 50 04             	cmp    0x4(%eax),%edx
  800365:	73 0a                	jae    800371 <sprintputch+0x1b>
		*b->buf++ = ch;
  800367:	8d 4a 01             	lea    0x1(%edx),%ecx
  80036a:	89 08                	mov    %ecx,(%eax)
  80036c:	8b 45 08             	mov    0x8(%ebp),%eax
  80036f:	88 02                	mov    %al,(%edx)
}
  800371:	5d                   	pop    %ebp
  800372:	c3                   	ret    

00800373 <printfmt>:
{
  800373:	55                   	push   %ebp
  800374:	89 e5                	mov    %esp,%ebp
  800376:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800379:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80037c:	50                   	push   %eax
  80037d:	ff 75 10             	pushl  0x10(%ebp)
  800380:	ff 75 0c             	pushl  0xc(%ebp)
  800383:	ff 75 08             	pushl  0x8(%ebp)
  800386:	e8 05 00 00 00       	call   800390 <vprintfmt>
}
  80038b:	83 c4 10             	add    $0x10,%esp
  80038e:	c9                   	leave  
  80038f:	c3                   	ret    

00800390 <vprintfmt>:
{
  800390:	55                   	push   %ebp
  800391:	89 e5                	mov    %esp,%ebp
  800393:	57                   	push   %edi
  800394:	56                   	push   %esi
  800395:	53                   	push   %ebx
  800396:	83 ec 3c             	sub    $0x3c,%esp
  800399:	8b 75 08             	mov    0x8(%ebp),%esi
  80039c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80039f:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003a2:	e9 1e 04 00 00       	jmp    8007c5 <vprintfmt+0x435>
		posflag = 0;
  8003a7:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
		padc = ' ';
  8003ae:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8003b2:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8003b9:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8003c0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003c7:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  8003ce:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003d3:	8d 47 01             	lea    0x1(%edi),%eax
  8003d6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003d9:	0f b6 17             	movzbl (%edi),%edx
  8003dc:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003df:	3c 55                	cmp    $0x55,%al
  8003e1:	0f 87 d9 04 00 00    	ja     8008c0 <vprintfmt+0x530>
  8003e7:	0f b6 c0             	movzbl %al,%eax
  8003ea:	ff 24 85 40 23 80 00 	jmp    *0x802340(,%eax,4)
  8003f1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003f4:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8003f8:	eb d9                	jmp    8003d3 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003fa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posflag = 1;
  8003fd:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  800404:	eb cd                	jmp    8003d3 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800406:	0f b6 d2             	movzbl %dl,%edx
  800409:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80040c:	b8 00 00 00 00       	mov    $0x0,%eax
  800411:	89 75 08             	mov    %esi,0x8(%ebp)
  800414:	eb 0c                	jmp    800422 <vprintfmt+0x92>
		switch (ch = *(unsigned char *) fmt++) {
  800416:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800419:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  80041d:	eb b4                	jmp    8003d3 <vprintfmt+0x43>
			for (precision = 0; ; ++fmt) {
  80041f:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800422:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800425:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800429:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80042c:	8d 72 d0             	lea    -0x30(%edx),%esi
  80042f:	83 fe 09             	cmp    $0x9,%esi
  800432:	76 eb                	jbe    80041f <vprintfmt+0x8f>
  800434:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800437:	8b 75 08             	mov    0x8(%ebp),%esi
  80043a:	eb 14                	jmp    800450 <vprintfmt+0xc0>
			precision = va_arg(ap, int);
  80043c:	8b 45 14             	mov    0x14(%ebp),%eax
  80043f:	8b 00                	mov    (%eax),%eax
  800441:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800444:	8b 45 14             	mov    0x14(%ebp),%eax
  800447:	8d 40 04             	lea    0x4(%eax),%eax
  80044a:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80044d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800450:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800454:	0f 89 79 ff ff ff    	jns    8003d3 <vprintfmt+0x43>
				width = precision, precision = -1;
  80045a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80045d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800460:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800467:	e9 67 ff ff ff       	jmp    8003d3 <vprintfmt+0x43>
  80046c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80046f:	85 c0                	test   %eax,%eax
  800471:	0f 48 c1             	cmovs  %ecx,%eax
  800474:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800477:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80047a:	e9 54 ff ff ff       	jmp    8003d3 <vprintfmt+0x43>
  80047f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800482:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800489:	e9 45 ff ff ff       	jmp    8003d3 <vprintfmt+0x43>
			lflag++;
  80048e:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800492:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800495:	e9 39 ff ff ff       	jmp    8003d3 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  80049a:	8b 45 14             	mov    0x14(%ebp),%eax
  80049d:	8d 78 04             	lea    0x4(%eax),%edi
  8004a0:	83 ec 08             	sub    $0x8,%esp
  8004a3:	53                   	push   %ebx
  8004a4:	ff 30                	pushl  (%eax)
  8004a6:	ff d6                	call   *%esi
			break;
  8004a8:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004ab:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8004ae:	e9 0f 03 00 00       	jmp    8007c2 <vprintfmt+0x432>
			err = va_arg(ap, int);
  8004b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b6:	8d 78 04             	lea    0x4(%eax),%edi
  8004b9:	8b 00                	mov    (%eax),%eax
  8004bb:	99                   	cltd   
  8004bc:	31 d0                	xor    %edx,%eax
  8004be:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004c0:	83 f8 0f             	cmp    $0xf,%eax
  8004c3:	7f 23                	jg     8004e8 <vprintfmt+0x158>
  8004c5:	8b 14 85 a0 24 80 00 	mov    0x8024a0(,%eax,4),%edx
  8004cc:	85 d2                	test   %edx,%edx
  8004ce:	74 18                	je     8004e8 <vprintfmt+0x158>
				printfmt(putch, putdat, "%s", p);
  8004d0:	52                   	push   %edx
  8004d1:	68 de 25 80 00       	push   $0x8025de
  8004d6:	53                   	push   %ebx
  8004d7:	56                   	push   %esi
  8004d8:	e8 96 fe ff ff       	call   800373 <printfmt>
  8004dd:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004e0:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004e3:	e9 da 02 00 00       	jmp    8007c2 <vprintfmt+0x432>
				printfmt(putch, putdat, "error %d", err);
  8004e8:	50                   	push   %eax
  8004e9:	68 7f 21 80 00       	push   $0x80217f
  8004ee:	53                   	push   %ebx
  8004ef:	56                   	push   %esi
  8004f0:	e8 7e fe ff ff       	call   800373 <printfmt>
  8004f5:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004f8:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004fb:	e9 c2 02 00 00       	jmp    8007c2 <vprintfmt+0x432>
			if ((p = va_arg(ap, char *)) == NULL)
  800500:	8b 45 14             	mov    0x14(%ebp),%eax
  800503:	83 c0 04             	add    $0x4,%eax
  800506:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800509:	8b 45 14             	mov    0x14(%ebp),%eax
  80050c:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80050e:	85 c9                	test   %ecx,%ecx
  800510:	b8 78 21 80 00       	mov    $0x802178,%eax
  800515:	0f 45 c1             	cmovne %ecx,%eax
  800518:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80051b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80051f:	7e 06                	jle    800527 <vprintfmt+0x197>
  800521:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800525:	75 0d                	jne    800534 <vprintfmt+0x1a4>
				for (width -= strnlen(p, precision); width > 0; width--)
  800527:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80052a:	89 c7                	mov    %eax,%edi
  80052c:	03 45 e0             	add    -0x20(%ebp),%eax
  80052f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800532:	eb 53                	jmp    800587 <vprintfmt+0x1f7>
  800534:	83 ec 08             	sub    $0x8,%esp
  800537:	ff 75 d8             	pushl  -0x28(%ebp)
  80053a:	50                   	push   %eax
  80053b:	e8 28 04 00 00       	call   800968 <strnlen>
  800540:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800543:	29 c1                	sub    %eax,%ecx
  800545:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  800548:	83 c4 10             	add    $0x10,%esp
  80054b:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  80054d:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800551:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800554:	eb 0f                	jmp    800565 <vprintfmt+0x1d5>
					putch(padc, putdat);
  800556:	83 ec 08             	sub    $0x8,%esp
  800559:	53                   	push   %ebx
  80055a:	ff 75 e0             	pushl  -0x20(%ebp)
  80055d:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80055f:	83 ef 01             	sub    $0x1,%edi
  800562:	83 c4 10             	add    $0x10,%esp
  800565:	85 ff                	test   %edi,%edi
  800567:	7f ed                	jg     800556 <vprintfmt+0x1c6>
  800569:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  80056c:	85 c9                	test   %ecx,%ecx
  80056e:	b8 00 00 00 00       	mov    $0x0,%eax
  800573:	0f 49 c1             	cmovns %ecx,%eax
  800576:	29 c1                	sub    %eax,%ecx
  800578:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80057b:	eb aa                	jmp    800527 <vprintfmt+0x197>
					putch(ch, putdat);
  80057d:	83 ec 08             	sub    $0x8,%esp
  800580:	53                   	push   %ebx
  800581:	52                   	push   %edx
  800582:	ff d6                	call   *%esi
  800584:	83 c4 10             	add    $0x10,%esp
  800587:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80058a:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80058c:	83 c7 01             	add    $0x1,%edi
  80058f:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800593:	0f be d0             	movsbl %al,%edx
  800596:	85 d2                	test   %edx,%edx
  800598:	74 4b                	je     8005e5 <vprintfmt+0x255>
  80059a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80059e:	78 06                	js     8005a6 <vprintfmt+0x216>
  8005a0:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8005a4:	78 1e                	js     8005c4 <vprintfmt+0x234>
				if (altflag && (ch < ' ' || ch > '~'))
  8005a6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005aa:	74 d1                	je     80057d <vprintfmt+0x1ed>
  8005ac:	0f be c0             	movsbl %al,%eax
  8005af:	83 e8 20             	sub    $0x20,%eax
  8005b2:	83 f8 5e             	cmp    $0x5e,%eax
  8005b5:	76 c6                	jbe    80057d <vprintfmt+0x1ed>
					putch('?', putdat);
  8005b7:	83 ec 08             	sub    $0x8,%esp
  8005ba:	53                   	push   %ebx
  8005bb:	6a 3f                	push   $0x3f
  8005bd:	ff d6                	call   *%esi
  8005bf:	83 c4 10             	add    $0x10,%esp
  8005c2:	eb c3                	jmp    800587 <vprintfmt+0x1f7>
  8005c4:	89 cf                	mov    %ecx,%edi
  8005c6:	eb 0e                	jmp    8005d6 <vprintfmt+0x246>
				putch(' ', putdat);
  8005c8:	83 ec 08             	sub    $0x8,%esp
  8005cb:	53                   	push   %ebx
  8005cc:	6a 20                	push   $0x20
  8005ce:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005d0:	83 ef 01             	sub    $0x1,%edi
  8005d3:	83 c4 10             	add    $0x10,%esp
  8005d6:	85 ff                	test   %edi,%edi
  8005d8:	7f ee                	jg     8005c8 <vprintfmt+0x238>
			if ((p = va_arg(ap, char *)) == NULL)
  8005da:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8005dd:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e0:	e9 dd 01 00 00       	jmp    8007c2 <vprintfmt+0x432>
  8005e5:	89 cf                	mov    %ecx,%edi
  8005e7:	eb ed                	jmp    8005d6 <vprintfmt+0x246>
	if (lflag >= 2)
  8005e9:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8005ed:	7f 21                	jg     800610 <vprintfmt+0x280>
	else if (lflag)
  8005ef:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8005f3:	74 6a                	je     80065f <vprintfmt+0x2cf>
		return va_arg(*ap, long);
  8005f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f8:	8b 00                	mov    (%eax),%eax
  8005fa:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005fd:	89 c1                	mov    %eax,%ecx
  8005ff:	c1 f9 1f             	sar    $0x1f,%ecx
  800602:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800605:	8b 45 14             	mov    0x14(%ebp),%eax
  800608:	8d 40 04             	lea    0x4(%eax),%eax
  80060b:	89 45 14             	mov    %eax,0x14(%ebp)
  80060e:	eb 17                	jmp    800627 <vprintfmt+0x297>
		return va_arg(*ap, long long);
  800610:	8b 45 14             	mov    0x14(%ebp),%eax
  800613:	8b 50 04             	mov    0x4(%eax),%edx
  800616:	8b 00                	mov    (%eax),%eax
  800618:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80061b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80061e:	8b 45 14             	mov    0x14(%ebp),%eax
  800621:	8d 40 08             	lea    0x8(%eax),%eax
  800624:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800627:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  80062a:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  80062f:	85 d2                	test   %edx,%edx
  800631:	0f 89 5c 01 00 00    	jns    800793 <vprintfmt+0x403>
				putch('-', putdat);
  800637:	83 ec 08             	sub    $0x8,%esp
  80063a:	53                   	push   %ebx
  80063b:	6a 2d                	push   $0x2d
  80063d:	ff d6                	call   *%esi
				num = -(long long) num;
  80063f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800642:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800645:	f7 d8                	neg    %eax
  800647:	83 d2 00             	adc    $0x0,%edx
  80064a:	f7 da                	neg    %edx
  80064c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80064f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800652:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800655:	bf 0a 00 00 00       	mov    $0xa,%edi
  80065a:	e9 45 01 00 00       	jmp    8007a4 <vprintfmt+0x414>
		return va_arg(*ap, int);
  80065f:	8b 45 14             	mov    0x14(%ebp),%eax
  800662:	8b 00                	mov    (%eax),%eax
  800664:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800667:	89 c1                	mov    %eax,%ecx
  800669:	c1 f9 1f             	sar    $0x1f,%ecx
  80066c:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80066f:	8b 45 14             	mov    0x14(%ebp),%eax
  800672:	8d 40 04             	lea    0x4(%eax),%eax
  800675:	89 45 14             	mov    %eax,0x14(%ebp)
  800678:	eb ad                	jmp    800627 <vprintfmt+0x297>
	if (lflag >= 2)
  80067a:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  80067e:	7f 29                	jg     8006a9 <vprintfmt+0x319>
	else if (lflag)
  800680:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800684:	74 44                	je     8006ca <vprintfmt+0x33a>
		return va_arg(*ap, unsigned long);
  800686:	8b 45 14             	mov    0x14(%ebp),%eax
  800689:	8b 00                	mov    (%eax),%eax
  80068b:	ba 00 00 00 00       	mov    $0x0,%edx
  800690:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800693:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800696:	8b 45 14             	mov    0x14(%ebp),%eax
  800699:	8d 40 04             	lea    0x4(%eax),%eax
  80069c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80069f:	bf 0a 00 00 00       	mov    $0xa,%edi
  8006a4:	e9 ea 00 00 00       	jmp    800793 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  8006a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ac:	8b 50 04             	mov    0x4(%eax),%edx
  8006af:	8b 00                	mov    (%eax),%eax
  8006b1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006b4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ba:	8d 40 08             	lea    0x8(%eax),%eax
  8006bd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006c0:	bf 0a 00 00 00       	mov    $0xa,%edi
  8006c5:	e9 c9 00 00 00       	jmp    800793 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  8006ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cd:	8b 00                	mov    (%eax),%eax
  8006cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006d7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006da:	8b 45 14             	mov    0x14(%ebp),%eax
  8006dd:	8d 40 04             	lea    0x4(%eax),%eax
  8006e0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006e3:	bf 0a 00 00 00       	mov    $0xa,%edi
  8006e8:	e9 a6 00 00 00       	jmp    800793 <vprintfmt+0x403>
			putch('0', putdat);
  8006ed:	83 ec 08             	sub    $0x8,%esp
  8006f0:	53                   	push   %ebx
  8006f1:	6a 30                	push   $0x30
  8006f3:	ff d6                	call   *%esi
	if (lflag >= 2)
  8006f5:	83 c4 10             	add    $0x10,%esp
  8006f8:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8006fc:	7f 26                	jg     800724 <vprintfmt+0x394>
	else if (lflag)
  8006fe:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800702:	74 3e                	je     800742 <vprintfmt+0x3b2>
		return va_arg(*ap, unsigned long);
  800704:	8b 45 14             	mov    0x14(%ebp),%eax
  800707:	8b 00                	mov    (%eax),%eax
  800709:	ba 00 00 00 00       	mov    $0x0,%edx
  80070e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800711:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800714:	8b 45 14             	mov    0x14(%ebp),%eax
  800717:	8d 40 04             	lea    0x4(%eax),%eax
  80071a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80071d:	bf 08 00 00 00       	mov    $0x8,%edi
  800722:	eb 6f                	jmp    800793 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  800724:	8b 45 14             	mov    0x14(%ebp),%eax
  800727:	8b 50 04             	mov    0x4(%eax),%edx
  80072a:	8b 00                	mov    (%eax),%eax
  80072c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80072f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800732:	8b 45 14             	mov    0x14(%ebp),%eax
  800735:	8d 40 08             	lea    0x8(%eax),%eax
  800738:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80073b:	bf 08 00 00 00       	mov    $0x8,%edi
  800740:	eb 51                	jmp    800793 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  800742:	8b 45 14             	mov    0x14(%ebp),%eax
  800745:	8b 00                	mov    (%eax),%eax
  800747:	ba 00 00 00 00       	mov    $0x0,%edx
  80074c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80074f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800752:	8b 45 14             	mov    0x14(%ebp),%eax
  800755:	8d 40 04             	lea    0x4(%eax),%eax
  800758:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80075b:	bf 08 00 00 00       	mov    $0x8,%edi
  800760:	eb 31                	jmp    800793 <vprintfmt+0x403>
			putch('0', putdat);
  800762:	83 ec 08             	sub    $0x8,%esp
  800765:	53                   	push   %ebx
  800766:	6a 30                	push   $0x30
  800768:	ff d6                	call   *%esi
			putch('x', putdat);
  80076a:	83 c4 08             	add    $0x8,%esp
  80076d:	53                   	push   %ebx
  80076e:	6a 78                	push   $0x78
  800770:	ff d6                	call   *%esi
			num = (unsigned long long)
  800772:	8b 45 14             	mov    0x14(%ebp),%eax
  800775:	8b 00                	mov    (%eax),%eax
  800777:	ba 00 00 00 00       	mov    $0x0,%edx
  80077c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80077f:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800782:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800785:	8b 45 14             	mov    0x14(%ebp),%eax
  800788:	8d 40 04             	lea    0x4(%eax),%eax
  80078b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80078e:	bf 10 00 00 00       	mov    $0x10,%edi
			if(posflag)
  800793:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800797:	74 0b                	je     8007a4 <vprintfmt+0x414>
				putch('+', putdat);
  800799:	83 ec 08             	sub    $0x8,%esp
  80079c:	53                   	push   %ebx
  80079d:	6a 2b                	push   $0x2b
  80079f:	ff d6                	call   *%esi
  8007a1:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  8007a4:	83 ec 0c             	sub    $0xc,%esp
  8007a7:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8007ab:	50                   	push   %eax
  8007ac:	ff 75 e0             	pushl  -0x20(%ebp)
  8007af:	57                   	push   %edi
  8007b0:	ff 75 dc             	pushl  -0x24(%ebp)
  8007b3:	ff 75 d8             	pushl  -0x28(%ebp)
  8007b6:	89 da                	mov    %ebx,%edx
  8007b8:	89 f0                	mov    %esi,%eax
  8007ba:	e8 b8 fa ff ff       	call   800277 <printnum>
			break;
  8007bf:	83 c4 20             	add    $0x20,%esp
			char* cp = va_arg(ap, char *);
  8007c2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007c5:	83 c7 01             	add    $0x1,%edi
  8007c8:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007cc:	83 f8 25             	cmp    $0x25,%eax
  8007cf:	0f 84 d2 fb ff ff    	je     8003a7 <vprintfmt+0x17>
			if (ch == '\0')
  8007d5:	85 c0                	test   %eax,%eax
  8007d7:	0f 84 03 01 00 00    	je     8008e0 <vprintfmt+0x550>
			putch(ch, putdat);
  8007dd:	83 ec 08             	sub    $0x8,%esp
  8007e0:	53                   	push   %ebx
  8007e1:	50                   	push   %eax
  8007e2:	ff d6                	call   *%esi
  8007e4:	83 c4 10             	add    $0x10,%esp
  8007e7:	eb dc                	jmp    8007c5 <vprintfmt+0x435>
	if (lflag >= 2)
  8007e9:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8007ed:	7f 29                	jg     800818 <vprintfmt+0x488>
	else if (lflag)
  8007ef:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8007f3:	74 44                	je     800839 <vprintfmt+0x4a9>
		return va_arg(*ap, unsigned long);
  8007f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f8:	8b 00                	mov    (%eax),%eax
  8007fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8007ff:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800802:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800805:	8b 45 14             	mov    0x14(%ebp),%eax
  800808:	8d 40 04             	lea    0x4(%eax),%eax
  80080b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80080e:	bf 10 00 00 00       	mov    $0x10,%edi
  800813:	e9 7b ff ff ff       	jmp    800793 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  800818:	8b 45 14             	mov    0x14(%ebp),%eax
  80081b:	8b 50 04             	mov    0x4(%eax),%edx
  80081e:	8b 00                	mov    (%eax),%eax
  800820:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800823:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800826:	8b 45 14             	mov    0x14(%ebp),%eax
  800829:	8d 40 08             	lea    0x8(%eax),%eax
  80082c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80082f:	bf 10 00 00 00       	mov    $0x10,%edi
  800834:	e9 5a ff ff ff       	jmp    800793 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  800839:	8b 45 14             	mov    0x14(%ebp),%eax
  80083c:	8b 00                	mov    (%eax),%eax
  80083e:	ba 00 00 00 00       	mov    $0x0,%edx
  800843:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800846:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800849:	8b 45 14             	mov    0x14(%ebp),%eax
  80084c:	8d 40 04             	lea    0x4(%eax),%eax
  80084f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800852:	bf 10 00 00 00       	mov    $0x10,%edi
  800857:	e9 37 ff ff ff       	jmp    800793 <vprintfmt+0x403>
			char* cp = va_arg(ap, char *);
  80085c:	8b 45 14             	mov    0x14(%ebp),%eax
  80085f:	8d 78 04             	lea    0x4(%eax),%edi
  800862:	8b 00                	mov    (%eax),%eax
    			if (cp == NULL) {
  800864:	85 c0                	test   %eax,%eax
  800866:	74 2c                	je     800894 <vprintfmt+0x504>
    			*cp = *(int *)putdat;
  800868:	8b 13                	mov    (%ebx),%edx
  80086a:	88 10                	mov    %dl,(%eax)
			char* cp = va_arg(ap, char *);
  80086c:	89 7d 14             	mov    %edi,0x14(%ebp)
    			if ((*(int *) putdat) > 127)
  80086f:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  800872:	0f 8e 4a ff ff ff    	jle    8007c2 <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", overflow_error);
  800878:	68 d4 22 80 00       	push   $0x8022d4
  80087d:	68 de 25 80 00       	push   $0x8025de
  800882:	53                   	push   %ebx
  800883:	56                   	push   %esi
  800884:	e8 ea fa ff ff       	call   800373 <printfmt>
  800889:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  80088c:	89 7d 14             	mov    %edi,0x14(%ebp)
  80088f:	e9 2e ff ff ff       	jmp    8007c2 <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", null_error);
  800894:	68 9c 22 80 00       	push   $0x80229c
  800899:	68 de 25 80 00       	push   $0x8025de
  80089e:	53                   	push   %ebx
  80089f:	56                   	push   %esi
  8008a0:	e8 ce fa ff ff       	call   800373 <printfmt>
        		break;
  8008a5:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  8008a8:	89 7d 14             	mov    %edi,0x14(%ebp)
        		break;
  8008ab:	e9 12 ff ff ff       	jmp    8007c2 <vprintfmt+0x432>
			putch(ch, putdat);
  8008b0:	83 ec 08             	sub    $0x8,%esp
  8008b3:	53                   	push   %ebx
  8008b4:	6a 25                	push   $0x25
  8008b6:	ff d6                	call   *%esi
			break;
  8008b8:	83 c4 10             	add    $0x10,%esp
  8008bb:	e9 02 ff ff ff       	jmp    8007c2 <vprintfmt+0x432>
			putch('%', putdat);
  8008c0:	83 ec 08             	sub    $0x8,%esp
  8008c3:	53                   	push   %ebx
  8008c4:	6a 25                	push   $0x25
  8008c6:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008c8:	83 c4 10             	add    $0x10,%esp
  8008cb:	89 f8                	mov    %edi,%eax
  8008cd:	eb 03                	jmp    8008d2 <vprintfmt+0x542>
  8008cf:	83 e8 01             	sub    $0x1,%eax
  8008d2:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8008d6:	75 f7                	jne    8008cf <vprintfmt+0x53f>
  8008d8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008db:	e9 e2 fe ff ff       	jmp    8007c2 <vprintfmt+0x432>
}
  8008e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008e3:	5b                   	pop    %ebx
  8008e4:	5e                   	pop    %esi
  8008e5:	5f                   	pop    %edi
  8008e6:	5d                   	pop    %ebp
  8008e7:	c3                   	ret    

008008e8 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008e8:	55                   	push   %ebp
  8008e9:	89 e5                	mov    %esp,%ebp
  8008eb:	83 ec 18             	sub    $0x18,%esp
  8008ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f1:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008f7:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008fb:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800905:	85 c0                	test   %eax,%eax
  800907:	74 26                	je     80092f <vsnprintf+0x47>
  800909:	85 d2                	test   %edx,%edx
  80090b:	7e 22                	jle    80092f <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80090d:	ff 75 14             	pushl  0x14(%ebp)
  800910:	ff 75 10             	pushl  0x10(%ebp)
  800913:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800916:	50                   	push   %eax
  800917:	68 56 03 80 00       	push   $0x800356
  80091c:	e8 6f fa ff ff       	call   800390 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800921:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800924:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800927:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80092a:	83 c4 10             	add    $0x10,%esp
}
  80092d:	c9                   	leave  
  80092e:	c3                   	ret    
		return -E_INVAL;
  80092f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800934:	eb f7                	jmp    80092d <vsnprintf+0x45>

00800936 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800936:	55                   	push   %ebp
  800937:	89 e5                	mov    %esp,%ebp
  800939:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80093c:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80093f:	50                   	push   %eax
  800940:	ff 75 10             	pushl  0x10(%ebp)
  800943:	ff 75 0c             	pushl  0xc(%ebp)
  800946:	ff 75 08             	pushl  0x8(%ebp)
  800949:	e8 9a ff ff ff       	call   8008e8 <vsnprintf>
	va_end(ap);

	return rc;
}
  80094e:	c9                   	leave  
  80094f:	c3                   	ret    

00800950 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800950:	55                   	push   %ebp
  800951:	89 e5                	mov    %esp,%ebp
  800953:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800956:	b8 00 00 00 00       	mov    $0x0,%eax
  80095b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80095f:	74 05                	je     800966 <strlen+0x16>
		n++;
  800961:	83 c0 01             	add    $0x1,%eax
  800964:	eb f5                	jmp    80095b <strlen+0xb>
	return n;
}
  800966:	5d                   	pop    %ebp
  800967:	c3                   	ret    

00800968 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800968:	55                   	push   %ebp
  800969:	89 e5                	mov    %esp,%ebp
  80096b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80096e:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800971:	ba 00 00 00 00       	mov    $0x0,%edx
  800976:	39 c2                	cmp    %eax,%edx
  800978:	74 0d                	je     800987 <strnlen+0x1f>
  80097a:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  80097e:	74 05                	je     800985 <strnlen+0x1d>
		n++;
  800980:	83 c2 01             	add    $0x1,%edx
  800983:	eb f1                	jmp    800976 <strnlen+0xe>
  800985:	89 d0                	mov    %edx,%eax
	return n;
}
  800987:	5d                   	pop    %ebp
  800988:	c3                   	ret    

00800989 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800989:	55                   	push   %ebp
  80098a:	89 e5                	mov    %esp,%ebp
  80098c:	53                   	push   %ebx
  80098d:	8b 45 08             	mov    0x8(%ebp),%eax
  800990:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800993:	ba 00 00 00 00       	mov    $0x0,%edx
  800998:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80099c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  80099f:	83 c2 01             	add    $0x1,%edx
  8009a2:	84 c9                	test   %cl,%cl
  8009a4:	75 f2                	jne    800998 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8009a6:	5b                   	pop    %ebx
  8009a7:	5d                   	pop    %ebp
  8009a8:	c3                   	ret    

008009a9 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009a9:	55                   	push   %ebp
  8009aa:	89 e5                	mov    %esp,%ebp
  8009ac:	53                   	push   %ebx
  8009ad:	83 ec 10             	sub    $0x10,%esp
  8009b0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009b3:	53                   	push   %ebx
  8009b4:	e8 97 ff ff ff       	call   800950 <strlen>
  8009b9:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8009bc:	ff 75 0c             	pushl  0xc(%ebp)
  8009bf:	01 d8                	add    %ebx,%eax
  8009c1:	50                   	push   %eax
  8009c2:	e8 c2 ff ff ff       	call   800989 <strcpy>
	return dst;
}
  8009c7:	89 d8                	mov    %ebx,%eax
  8009c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009cc:	c9                   	leave  
  8009cd:	c3                   	ret    

008009ce <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009ce:	55                   	push   %ebp
  8009cf:	89 e5                	mov    %esp,%ebp
  8009d1:	56                   	push   %esi
  8009d2:	53                   	push   %ebx
  8009d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009d9:	89 c6                	mov    %eax,%esi
  8009db:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009de:	89 c2                	mov    %eax,%edx
  8009e0:	39 f2                	cmp    %esi,%edx
  8009e2:	74 11                	je     8009f5 <strncpy+0x27>
		*dst++ = *src;
  8009e4:	83 c2 01             	add    $0x1,%edx
  8009e7:	0f b6 19             	movzbl (%ecx),%ebx
  8009ea:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009ed:	80 fb 01             	cmp    $0x1,%bl
  8009f0:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8009f3:	eb eb                	jmp    8009e0 <strncpy+0x12>
	}
	return ret;
}
  8009f5:	5b                   	pop    %ebx
  8009f6:	5e                   	pop    %esi
  8009f7:	5d                   	pop    %ebp
  8009f8:	c3                   	ret    

008009f9 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009f9:	55                   	push   %ebp
  8009fa:	89 e5                	mov    %esp,%ebp
  8009fc:	56                   	push   %esi
  8009fd:	53                   	push   %ebx
  8009fe:	8b 75 08             	mov    0x8(%ebp),%esi
  800a01:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a04:	8b 55 10             	mov    0x10(%ebp),%edx
  800a07:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a09:	85 d2                	test   %edx,%edx
  800a0b:	74 21                	je     800a2e <strlcpy+0x35>
  800a0d:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a11:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800a13:	39 c2                	cmp    %eax,%edx
  800a15:	74 14                	je     800a2b <strlcpy+0x32>
  800a17:	0f b6 19             	movzbl (%ecx),%ebx
  800a1a:	84 db                	test   %bl,%bl
  800a1c:	74 0b                	je     800a29 <strlcpy+0x30>
			*dst++ = *src++;
  800a1e:	83 c1 01             	add    $0x1,%ecx
  800a21:	83 c2 01             	add    $0x1,%edx
  800a24:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a27:	eb ea                	jmp    800a13 <strlcpy+0x1a>
  800a29:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a2b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a2e:	29 f0                	sub    %esi,%eax
}
  800a30:	5b                   	pop    %ebx
  800a31:	5e                   	pop    %esi
  800a32:	5d                   	pop    %ebp
  800a33:	c3                   	ret    

00800a34 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a34:	55                   	push   %ebp
  800a35:	89 e5                	mov    %esp,%ebp
  800a37:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a3a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a3d:	0f b6 01             	movzbl (%ecx),%eax
  800a40:	84 c0                	test   %al,%al
  800a42:	74 0c                	je     800a50 <strcmp+0x1c>
  800a44:	3a 02                	cmp    (%edx),%al
  800a46:	75 08                	jne    800a50 <strcmp+0x1c>
		p++, q++;
  800a48:	83 c1 01             	add    $0x1,%ecx
  800a4b:	83 c2 01             	add    $0x1,%edx
  800a4e:	eb ed                	jmp    800a3d <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a50:	0f b6 c0             	movzbl %al,%eax
  800a53:	0f b6 12             	movzbl (%edx),%edx
  800a56:	29 d0                	sub    %edx,%eax
}
  800a58:	5d                   	pop    %ebp
  800a59:	c3                   	ret    

00800a5a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a5a:	55                   	push   %ebp
  800a5b:	89 e5                	mov    %esp,%ebp
  800a5d:	53                   	push   %ebx
  800a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a61:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a64:	89 c3                	mov    %eax,%ebx
  800a66:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a69:	eb 06                	jmp    800a71 <strncmp+0x17>
		n--, p++, q++;
  800a6b:	83 c0 01             	add    $0x1,%eax
  800a6e:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a71:	39 d8                	cmp    %ebx,%eax
  800a73:	74 16                	je     800a8b <strncmp+0x31>
  800a75:	0f b6 08             	movzbl (%eax),%ecx
  800a78:	84 c9                	test   %cl,%cl
  800a7a:	74 04                	je     800a80 <strncmp+0x26>
  800a7c:	3a 0a                	cmp    (%edx),%cl
  800a7e:	74 eb                	je     800a6b <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a80:	0f b6 00             	movzbl (%eax),%eax
  800a83:	0f b6 12             	movzbl (%edx),%edx
  800a86:	29 d0                	sub    %edx,%eax
}
  800a88:	5b                   	pop    %ebx
  800a89:	5d                   	pop    %ebp
  800a8a:	c3                   	ret    
		return 0;
  800a8b:	b8 00 00 00 00       	mov    $0x0,%eax
  800a90:	eb f6                	jmp    800a88 <strncmp+0x2e>

00800a92 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a92:	55                   	push   %ebp
  800a93:	89 e5                	mov    %esp,%ebp
  800a95:	8b 45 08             	mov    0x8(%ebp),%eax
  800a98:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a9c:	0f b6 10             	movzbl (%eax),%edx
  800a9f:	84 d2                	test   %dl,%dl
  800aa1:	74 09                	je     800aac <strchr+0x1a>
		if (*s == c)
  800aa3:	38 ca                	cmp    %cl,%dl
  800aa5:	74 0a                	je     800ab1 <strchr+0x1f>
	for (; *s; s++)
  800aa7:	83 c0 01             	add    $0x1,%eax
  800aaa:	eb f0                	jmp    800a9c <strchr+0xa>
			return (char *) s;
	return 0;
  800aac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ab1:	5d                   	pop    %ebp
  800ab2:	c3                   	ret    

00800ab3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ab3:	55                   	push   %ebp
  800ab4:	89 e5                	mov    %esp,%ebp
  800ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800abd:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800ac0:	38 ca                	cmp    %cl,%dl
  800ac2:	74 09                	je     800acd <strfind+0x1a>
  800ac4:	84 d2                	test   %dl,%dl
  800ac6:	74 05                	je     800acd <strfind+0x1a>
	for (; *s; s++)
  800ac8:	83 c0 01             	add    $0x1,%eax
  800acb:	eb f0                	jmp    800abd <strfind+0xa>
			break;
	return (char *) s;
}
  800acd:	5d                   	pop    %ebp
  800ace:	c3                   	ret    

00800acf <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800acf:	55                   	push   %ebp
  800ad0:	89 e5                	mov    %esp,%ebp
  800ad2:	57                   	push   %edi
  800ad3:	56                   	push   %esi
  800ad4:	53                   	push   %ebx
  800ad5:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ad8:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800adb:	85 c9                	test   %ecx,%ecx
  800add:	74 31                	je     800b10 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800adf:	89 f8                	mov    %edi,%eax
  800ae1:	09 c8                	or     %ecx,%eax
  800ae3:	a8 03                	test   $0x3,%al
  800ae5:	75 23                	jne    800b0a <memset+0x3b>
		c &= 0xFF;
  800ae7:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800aeb:	89 d3                	mov    %edx,%ebx
  800aed:	c1 e3 08             	shl    $0x8,%ebx
  800af0:	89 d0                	mov    %edx,%eax
  800af2:	c1 e0 18             	shl    $0x18,%eax
  800af5:	89 d6                	mov    %edx,%esi
  800af7:	c1 e6 10             	shl    $0x10,%esi
  800afa:	09 f0                	or     %esi,%eax
  800afc:	09 c2                	or     %eax,%edx
  800afe:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b00:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b03:	89 d0                	mov    %edx,%eax
  800b05:	fc                   	cld    
  800b06:	f3 ab                	rep stos %eax,%es:(%edi)
  800b08:	eb 06                	jmp    800b10 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0d:	fc                   	cld    
  800b0e:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b10:	89 f8                	mov    %edi,%eax
  800b12:	5b                   	pop    %ebx
  800b13:	5e                   	pop    %esi
  800b14:	5f                   	pop    %edi
  800b15:	5d                   	pop    %ebp
  800b16:	c3                   	ret    

00800b17 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b17:	55                   	push   %ebp
  800b18:	89 e5                	mov    %esp,%ebp
  800b1a:	57                   	push   %edi
  800b1b:	56                   	push   %esi
  800b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b22:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b25:	39 c6                	cmp    %eax,%esi
  800b27:	73 32                	jae    800b5b <memmove+0x44>
  800b29:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b2c:	39 c2                	cmp    %eax,%edx
  800b2e:	76 2b                	jbe    800b5b <memmove+0x44>
		s += n;
		d += n;
  800b30:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b33:	89 fe                	mov    %edi,%esi
  800b35:	09 ce                	or     %ecx,%esi
  800b37:	09 d6                	or     %edx,%esi
  800b39:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b3f:	75 0e                	jne    800b4f <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b41:	83 ef 04             	sub    $0x4,%edi
  800b44:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b47:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b4a:	fd                   	std    
  800b4b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b4d:	eb 09                	jmp    800b58 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b4f:	83 ef 01             	sub    $0x1,%edi
  800b52:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b55:	fd                   	std    
  800b56:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b58:	fc                   	cld    
  800b59:	eb 1a                	jmp    800b75 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b5b:	89 c2                	mov    %eax,%edx
  800b5d:	09 ca                	or     %ecx,%edx
  800b5f:	09 f2                	or     %esi,%edx
  800b61:	f6 c2 03             	test   $0x3,%dl
  800b64:	75 0a                	jne    800b70 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b66:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b69:	89 c7                	mov    %eax,%edi
  800b6b:	fc                   	cld    
  800b6c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b6e:	eb 05                	jmp    800b75 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b70:	89 c7                	mov    %eax,%edi
  800b72:	fc                   	cld    
  800b73:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b75:	5e                   	pop    %esi
  800b76:	5f                   	pop    %edi
  800b77:	5d                   	pop    %ebp
  800b78:	c3                   	ret    

00800b79 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b79:	55                   	push   %ebp
  800b7a:	89 e5                	mov    %esp,%ebp
  800b7c:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b7f:	ff 75 10             	pushl  0x10(%ebp)
  800b82:	ff 75 0c             	pushl  0xc(%ebp)
  800b85:	ff 75 08             	pushl  0x8(%ebp)
  800b88:	e8 8a ff ff ff       	call   800b17 <memmove>
}
  800b8d:	c9                   	leave  
  800b8e:	c3                   	ret    

00800b8f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b8f:	55                   	push   %ebp
  800b90:	89 e5                	mov    %esp,%ebp
  800b92:	56                   	push   %esi
  800b93:	53                   	push   %ebx
  800b94:	8b 45 08             	mov    0x8(%ebp),%eax
  800b97:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b9a:	89 c6                	mov    %eax,%esi
  800b9c:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b9f:	39 f0                	cmp    %esi,%eax
  800ba1:	74 1c                	je     800bbf <memcmp+0x30>
		if (*s1 != *s2)
  800ba3:	0f b6 08             	movzbl (%eax),%ecx
  800ba6:	0f b6 1a             	movzbl (%edx),%ebx
  800ba9:	38 d9                	cmp    %bl,%cl
  800bab:	75 08                	jne    800bb5 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800bad:	83 c0 01             	add    $0x1,%eax
  800bb0:	83 c2 01             	add    $0x1,%edx
  800bb3:	eb ea                	jmp    800b9f <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800bb5:	0f b6 c1             	movzbl %cl,%eax
  800bb8:	0f b6 db             	movzbl %bl,%ebx
  800bbb:	29 d8                	sub    %ebx,%eax
  800bbd:	eb 05                	jmp    800bc4 <memcmp+0x35>
	}

	return 0;
  800bbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bc4:	5b                   	pop    %ebx
  800bc5:	5e                   	pop    %esi
  800bc6:	5d                   	pop    %ebp
  800bc7:	c3                   	ret    

00800bc8 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800bc8:	55                   	push   %ebp
  800bc9:	89 e5                	mov    %esp,%ebp
  800bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800bd1:	89 c2                	mov    %eax,%edx
  800bd3:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bd6:	39 d0                	cmp    %edx,%eax
  800bd8:	73 09                	jae    800be3 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bda:	38 08                	cmp    %cl,(%eax)
  800bdc:	74 05                	je     800be3 <memfind+0x1b>
	for (; s < ends; s++)
  800bde:	83 c0 01             	add    $0x1,%eax
  800be1:	eb f3                	jmp    800bd6 <memfind+0xe>
			break;
	return (void *) s;
}
  800be3:	5d                   	pop    %ebp
  800be4:	c3                   	ret    

00800be5 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800be5:	55                   	push   %ebp
  800be6:	89 e5                	mov    %esp,%ebp
  800be8:	57                   	push   %edi
  800be9:	56                   	push   %esi
  800bea:	53                   	push   %ebx
  800beb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bee:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bf1:	eb 03                	jmp    800bf6 <strtol+0x11>
		s++;
  800bf3:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800bf6:	0f b6 01             	movzbl (%ecx),%eax
  800bf9:	3c 20                	cmp    $0x20,%al
  800bfb:	74 f6                	je     800bf3 <strtol+0xe>
  800bfd:	3c 09                	cmp    $0x9,%al
  800bff:	74 f2                	je     800bf3 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c01:	3c 2b                	cmp    $0x2b,%al
  800c03:	74 2a                	je     800c2f <strtol+0x4a>
	int neg = 0;
  800c05:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c0a:	3c 2d                	cmp    $0x2d,%al
  800c0c:	74 2b                	je     800c39 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c0e:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c14:	75 0f                	jne    800c25 <strtol+0x40>
  800c16:	80 39 30             	cmpb   $0x30,(%ecx)
  800c19:	74 28                	je     800c43 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c1b:	85 db                	test   %ebx,%ebx
  800c1d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c22:	0f 44 d8             	cmove  %eax,%ebx
  800c25:	b8 00 00 00 00       	mov    $0x0,%eax
  800c2a:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c2d:	eb 50                	jmp    800c7f <strtol+0x9a>
		s++;
  800c2f:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c32:	bf 00 00 00 00       	mov    $0x0,%edi
  800c37:	eb d5                	jmp    800c0e <strtol+0x29>
		s++, neg = 1;
  800c39:	83 c1 01             	add    $0x1,%ecx
  800c3c:	bf 01 00 00 00       	mov    $0x1,%edi
  800c41:	eb cb                	jmp    800c0e <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c43:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c47:	74 0e                	je     800c57 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c49:	85 db                	test   %ebx,%ebx
  800c4b:	75 d8                	jne    800c25 <strtol+0x40>
		s++, base = 8;
  800c4d:	83 c1 01             	add    $0x1,%ecx
  800c50:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c55:	eb ce                	jmp    800c25 <strtol+0x40>
		s += 2, base = 16;
  800c57:	83 c1 02             	add    $0x2,%ecx
  800c5a:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c5f:	eb c4                	jmp    800c25 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c61:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c64:	89 f3                	mov    %esi,%ebx
  800c66:	80 fb 19             	cmp    $0x19,%bl
  800c69:	77 29                	ja     800c94 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c6b:	0f be d2             	movsbl %dl,%edx
  800c6e:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c71:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c74:	7d 30                	jge    800ca6 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c76:	83 c1 01             	add    $0x1,%ecx
  800c79:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c7d:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c7f:	0f b6 11             	movzbl (%ecx),%edx
  800c82:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c85:	89 f3                	mov    %esi,%ebx
  800c87:	80 fb 09             	cmp    $0x9,%bl
  800c8a:	77 d5                	ja     800c61 <strtol+0x7c>
			dig = *s - '0';
  800c8c:	0f be d2             	movsbl %dl,%edx
  800c8f:	83 ea 30             	sub    $0x30,%edx
  800c92:	eb dd                	jmp    800c71 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c94:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c97:	89 f3                	mov    %esi,%ebx
  800c99:	80 fb 19             	cmp    $0x19,%bl
  800c9c:	77 08                	ja     800ca6 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c9e:	0f be d2             	movsbl %dl,%edx
  800ca1:	83 ea 37             	sub    $0x37,%edx
  800ca4:	eb cb                	jmp    800c71 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800ca6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800caa:	74 05                	je     800cb1 <strtol+0xcc>
		*endptr = (char *) s;
  800cac:	8b 75 0c             	mov    0xc(%ebp),%esi
  800caf:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800cb1:	89 c2                	mov    %eax,%edx
  800cb3:	f7 da                	neg    %edx
  800cb5:	85 ff                	test   %edi,%edi
  800cb7:	0f 45 c2             	cmovne %edx,%eax
}
  800cba:	5b                   	pop    %ebx
  800cbb:	5e                   	pop    %esi
  800cbc:	5f                   	pop    %edi
  800cbd:	5d                   	pop    %ebp
  800cbe:	c3                   	ret    

00800cbf <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800cbf:	55                   	push   %ebp
  800cc0:	89 e5                	mov    %esp,%ebp
  800cc2:	57                   	push   %edi
  800cc3:	56                   	push   %esi
  800cc4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cc5:	b8 00 00 00 00       	mov    $0x0,%eax
  800cca:	8b 55 08             	mov    0x8(%ebp),%edx
  800ccd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd0:	89 c3                	mov    %eax,%ebx
  800cd2:	89 c7                	mov    %eax,%edi
  800cd4:	89 c6                	mov    %eax,%esi
  800cd6:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cd8:	5b                   	pop    %ebx
  800cd9:	5e                   	pop    %esi
  800cda:	5f                   	pop    %edi
  800cdb:	5d                   	pop    %ebp
  800cdc:	c3                   	ret    

00800cdd <sys_cgetc>:

int
sys_cgetc(void)
{
  800cdd:	55                   	push   %ebp
  800cde:	89 e5                	mov    %esp,%ebp
  800ce0:	57                   	push   %edi
  800ce1:	56                   	push   %esi
  800ce2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ce3:	ba 00 00 00 00       	mov    $0x0,%edx
  800ce8:	b8 01 00 00 00       	mov    $0x1,%eax
  800ced:	89 d1                	mov    %edx,%ecx
  800cef:	89 d3                	mov    %edx,%ebx
  800cf1:	89 d7                	mov    %edx,%edi
  800cf3:	89 d6                	mov    %edx,%esi
  800cf5:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cf7:	5b                   	pop    %ebx
  800cf8:	5e                   	pop    %esi
  800cf9:	5f                   	pop    %edi
  800cfa:	5d                   	pop    %ebp
  800cfb:	c3                   	ret    

00800cfc <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cfc:	55                   	push   %ebp
  800cfd:	89 e5                	mov    %esp,%ebp
  800cff:	57                   	push   %edi
  800d00:	56                   	push   %esi
  800d01:	53                   	push   %ebx
  800d02:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d05:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d0a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d0d:	b8 03 00 00 00       	mov    $0x3,%eax
  800d12:	89 cb                	mov    %ecx,%ebx
  800d14:	89 cf                	mov    %ecx,%edi
  800d16:	89 ce                	mov    %ecx,%esi
  800d18:	cd 30                	int    $0x30
	if (check && ret > 0)
  800d1a:	85 c0                	test   %eax,%eax
  800d1c:	7f 08                	jg     800d26 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d21:	5b                   	pop    %ebx
  800d22:	5e                   	pop    %esi
  800d23:	5f                   	pop    %edi
  800d24:	5d                   	pop    %ebp
  800d25:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d26:	83 ec 0c             	sub    $0xc,%esp
  800d29:	50                   	push   %eax
  800d2a:	6a 03                	push   $0x3
  800d2c:	68 e0 24 80 00       	push   $0x8024e0
  800d31:	6a 4c                	push   $0x4c
  800d33:	68 fd 24 80 00       	push   $0x8024fd
  800d38:	e8 4b f4 ff ff       	call   800188 <_panic>

00800d3d <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d3d:	55                   	push   %ebp
  800d3e:	89 e5                	mov    %esp,%ebp
  800d40:	57                   	push   %edi
  800d41:	56                   	push   %esi
  800d42:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d43:	ba 00 00 00 00       	mov    $0x0,%edx
  800d48:	b8 02 00 00 00       	mov    $0x2,%eax
  800d4d:	89 d1                	mov    %edx,%ecx
  800d4f:	89 d3                	mov    %edx,%ebx
  800d51:	89 d7                	mov    %edx,%edi
  800d53:	89 d6                	mov    %edx,%esi
  800d55:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d57:	5b                   	pop    %ebx
  800d58:	5e                   	pop    %esi
  800d59:	5f                   	pop    %edi
  800d5a:	5d                   	pop    %ebp
  800d5b:	c3                   	ret    

00800d5c <sys_yield>:

void
sys_yield(void)
{
  800d5c:	55                   	push   %ebp
  800d5d:	89 e5                	mov    %esp,%ebp
  800d5f:	57                   	push   %edi
  800d60:	56                   	push   %esi
  800d61:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d62:	ba 00 00 00 00       	mov    $0x0,%edx
  800d67:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d6c:	89 d1                	mov    %edx,%ecx
  800d6e:	89 d3                	mov    %edx,%ebx
  800d70:	89 d7                	mov    %edx,%edi
  800d72:	89 d6                	mov    %edx,%esi
  800d74:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d76:	5b                   	pop    %ebx
  800d77:	5e                   	pop    %esi
  800d78:	5f                   	pop    %edi
  800d79:	5d                   	pop    %ebp
  800d7a:	c3                   	ret    

00800d7b <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d7b:	55                   	push   %ebp
  800d7c:	89 e5                	mov    %esp,%ebp
  800d7e:	57                   	push   %edi
  800d7f:	56                   	push   %esi
  800d80:	53                   	push   %ebx
  800d81:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d84:	be 00 00 00 00       	mov    $0x0,%esi
  800d89:	8b 55 08             	mov    0x8(%ebp),%edx
  800d8c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d8f:	b8 04 00 00 00       	mov    $0x4,%eax
  800d94:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d97:	89 f7                	mov    %esi,%edi
  800d99:	cd 30                	int    $0x30
	if (check && ret > 0)
  800d9b:	85 c0                	test   %eax,%eax
  800d9d:	7f 08                	jg     800da7 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d9f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800da2:	5b                   	pop    %ebx
  800da3:	5e                   	pop    %esi
  800da4:	5f                   	pop    %edi
  800da5:	5d                   	pop    %ebp
  800da6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800da7:	83 ec 0c             	sub    $0xc,%esp
  800daa:	50                   	push   %eax
  800dab:	6a 04                	push   $0x4
  800dad:	68 e0 24 80 00       	push   $0x8024e0
  800db2:	6a 4c                	push   $0x4c
  800db4:	68 fd 24 80 00       	push   $0x8024fd
  800db9:	e8 ca f3 ff ff       	call   800188 <_panic>

00800dbe <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800dbe:	55                   	push   %ebp
  800dbf:	89 e5                	mov    %esp,%ebp
  800dc1:	57                   	push   %edi
  800dc2:	56                   	push   %esi
  800dc3:	53                   	push   %ebx
  800dc4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dc7:	8b 55 08             	mov    0x8(%ebp),%edx
  800dca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dcd:	b8 05 00 00 00       	mov    $0x5,%eax
  800dd2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dd5:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dd8:	8b 75 18             	mov    0x18(%ebp),%esi
  800ddb:	cd 30                	int    $0x30
	if (check && ret > 0)
  800ddd:	85 c0                	test   %eax,%eax
  800ddf:	7f 08                	jg     800de9 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800de1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800de4:	5b                   	pop    %ebx
  800de5:	5e                   	pop    %esi
  800de6:	5f                   	pop    %edi
  800de7:	5d                   	pop    %ebp
  800de8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800de9:	83 ec 0c             	sub    $0xc,%esp
  800dec:	50                   	push   %eax
  800ded:	6a 05                	push   $0x5
  800def:	68 e0 24 80 00       	push   $0x8024e0
  800df4:	6a 4c                	push   $0x4c
  800df6:	68 fd 24 80 00       	push   $0x8024fd
  800dfb:	e8 88 f3 ff ff       	call   800188 <_panic>

00800e00 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e00:	55                   	push   %ebp
  800e01:	89 e5                	mov    %esp,%ebp
  800e03:	57                   	push   %edi
  800e04:	56                   	push   %esi
  800e05:	53                   	push   %ebx
  800e06:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e09:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e0e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e11:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e14:	b8 06 00 00 00       	mov    $0x6,%eax
  800e19:	89 df                	mov    %ebx,%edi
  800e1b:	89 de                	mov    %ebx,%esi
  800e1d:	cd 30                	int    $0x30
	if (check && ret > 0)
  800e1f:	85 c0                	test   %eax,%eax
  800e21:	7f 08                	jg     800e2b <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e23:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e26:	5b                   	pop    %ebx
  800e27:	5e                   	pop    %esi
  800e28:	5f                   	pop    %edi
  800e29:	5d                   	pop    %ebp
  800e2a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e2b:	83 ec 0c             	sub    $0xc,%esp
  800e2e:	50                   	push   %eax
  800e2f:	6a 06                	push   $0x6
  800e31:	68 e0 24 80 00       	push   $0x8024e0
  800e36:	6a 4c                	push   $0x4c
  800e38:	68 fd 24 80 00       	push   $0x8024fd
  800e3d:	e8 46 f3 ff ff       	call   800188 <_panic>

00800e42 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e42:	55                   	push   %ebp
  800e43:	89 e5                	mov    %esp,%ebp
  800e45:	57                   	push   %edi
  800e46:	56                   	push   %esi
  800e47:	53                   	push   %ebx
  800e48:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e4b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e50:	8b 55 08             	mov    0x8(%ebp),%edx
  800e53:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e56:	b8 08 00 00 00       	mov    $0x8,%eax
  800e5b:	89 df                	mov    %ebx,%edi
  800e5d:	89 de                	mov    %ebx,%esi
  800e5f:	cd 30                	int    $0x30
	if (check && ret > 0)
  800e61:	85 c0                	test   %eax,%eax
  800e63:	7f 08                	jg     800e6d <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e65:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e68:	5b                   	pop    %ebx
  800e69:	5e                   	pop    %esi
  800e6a:	5f                   	pop    %edi
  800e6b:	5d                   	pop    %ebp
  800e6c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e6d:	83 ec 0c             	sub    $0xc,%esp
  800e70:	50                   	push   %eax
  800e71:	6a 08                	push   $0x8
  800e73:	68 e0 24 80 00       	push   $0x8024e0
  800e78:	6a 4c                	push   $0x4c
  800e7a:	68 fd 24 80 00       	push   $0x8024fd
  800e7f:	e8 04 f3 ff ff       	call   800188 <_panic>

00800e84 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e84:	55                   	push   %ebp
  800e85:	89 e5                	mov    %esp,%ebp
  800e87:	57                   	push   %edi
  800e88:	56                   	push   %esi
  800e89:	53                   	push   %ebx
  800e8a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e8d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e92:	8b 55 08             	mov    0x8(%ebp),%edx
  800e95:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e98:	b8 09 00 00 00       	mov    $0x9,%eax
  800e9d:	89 df                	mov    %ebx,%edi
  800e9f:	89 de                	mov    %ebx,%esi
  800ea1:	cd 30                	int    $0x30
	if (check && ret > 0)
  800ea3:	85 c0                	test   %eax,%eax
  800ea5:	7f 08                	jg     800eaf <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ea7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eaa:	5b                   	pop    %ebx
  800eab:	5e                   	pop    %esi
  800eac:	5f                   	pop    %edi
  800ead:	5d                   	pop    %ebp
  800eae:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eaf:	83 ec 0c             	sub    $0xc,%esp
  800eb2:	50                   	push   %eax
  800eb3:	6a 09                	push   $0x9
  800eb5:	68 e0 24 80 00       	push   $0x8024e0
  800eba:	6a 4c                	push   $0x4c
  800ebc:	68 fd 24 80 00       	push   $0x8024fd
  800ec1:	e8 c2 f2 ff ff       	call   800188 <_panic>

00800ec6 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ec6:	55                   	push   %ebp
  800ec7:	89 e5                	mov    %esp,%ebp
  800ec9:	57                   	push   %edi
  800eca:	56                   	push   %esi
  800ecb:	53                   	push   %ebx
  800ecc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ecf:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ed4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eda:	b8 0a 00 00 00       	mov    $0xa,%eax
  800edf:	89 df                	mov    %ebx,%edi
  800ee1:	89 de                	mov    %ebx,%esi
  800ee3:	cd 30                	int    $0x30
	if (check && ret > 0)
  800ee5:	85 c0                	test   %eax,%eax
  800ee7:	7f 08                	jg     800ef1 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ee9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eec:	5b                   	pop    %ebx
  800eed:	5e                   	pop    %esi
  800eee:	5f                   	pop    %edi
  800eef:	5d                   	pop    %ebp
  800ef0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ef1:	83 ec 0c             	sub    $0xc,%esp
  800ef4:	50                   	push   %eax
  800ef5:	6a 0a                	push   $0xa
  800ef7:	68 e0 24 80 00       	push   $0x8024e0
  800efc:	6a 4c                	push   $0x4c
  800efe:	68 fd 24 80 00       	push   $0x8024fd
  800f03:	e8 80 f2 ff ff       	call   800188 <_panic>

00800f08 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f08:	55                   	push   %ebp
  800f09:	89 e5                	mov    %esp,%ebp
  800f0b:	57                   	push   %edi
  800f0c:	56                   	push   %esi
  800f0d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f0e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f11:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f14:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f19:	be 00 00 00 00       	mov    $0x0,%esi
  800f1e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f21:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f24:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f26:	5b                   	pop    %ebx
  800f27:	5e                   	pop    %esi
  800f28:	5f                   	pop    %edi
  800f29:	5d                   	pop    %ebp
  800f2a:	c3                   	ret    

00800f2b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f2b:	55                   	push   %ebp
  800f2c:	89 e5                	mov    %esp,%ebp
  800f2e:	57                   	push   %edi
  800f2f:	56                   	push   %esi
  800f30:	53                   	push   %ebx
  800f31:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f34:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f39:	8b 55 08             	mov    0x8(%ebp),%edx
  800f3c:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f41:	89 cb                	mov    %ecx,%ebx
  800f43:	89 cf                	mov    %ecx,%edi
  800f45:	89 ce                	mov    %ecx,%esi
  800f47:	cd 30                	int    $0x30
	if (check && ret > 0)
  800f49:	85 c0                	test   %eax,%eax
  800f4b:	7f 08                	jg     800f55 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f50:	5b                   	pop    %ebx
  800f51:	5e                   	pop    %esi
  800f52:	5f                   	pop    %edi
  800f53:	5d                   	pop    %ebp
  800f54:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f55:	83 ec 0c             	sub    $0xc,%esp
  800f58:	50                   	push   %eax
  800f59:	6a 0d                	push   $0xd
  800f5b:	68 e0 24 80 00       	push   $0x8024e0
  800f60:	6a 4c                	push   $0x4c
  800f62:	68 fd 24 80 00       	push   $0x8024fd
  800f67:	e8 1c f2 ff ff       	call   800188 <_panic>

00800f6c <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f6c:	55                   	push   %ebp
  800f6d:	89 e5                	mov    %esp,%ebp
  800f6f:	57                   	push   %edi
  800f70:	56                   	push   %esi
  800f71:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f72:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f77:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f7d:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f82:	89 df                	mov    %ebx,%edi
  800f84:	89 de                	mov    %ebx,%esi
  800f86:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f88:	5b                   	pop    %ebx
  800f89:	5e                   	pop    %esi
  800f8a:	5f                   	pop    %edi
  800f8b:	5d                   	pop    %ebp
  800f8c:	c3                   	ret    

00800f8d <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f8d:	55                   	push   %ebp
  800f8e:	89 e5                	mov    %esp,%ebp
  800f90:	57                   	push   %edi
  800f91:	56                   	push   %esi
  800f92:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f93:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f98:	8b 55 08             	mov    0x8(%ebp),%edx
  800f9b:	b8 0f 00 00 00       	mov    $0xf,%eax
  800fa0:	89 cb                	mov    %ecx,%ebx
  800fa2:	89 cf                	mov    %ecx,%edi
  800fa4:	89 ce                	mov    %ecx,%esi
  800fa6:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800fa8:	5b                   	pop    %ebx
  800fa9:	5e                   	pop    %esi
  800faa:	5f                   	pop    %edi
  800fab:	5d                   	pop    %ebp
  800fac:	c3                   	ret    

00800fad <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800fad:	55                   	push   %ebp
  800fae:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb3:	05 00 00 00 30       	add    $0x30000000,%eax
  800fb8:	c1 e8 0c             	shr    $0xc,%eax
}
  800fbb:	5d                   	pop    %ebp
  800fbc:	c3                   	ret    

00800fbd <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800fbd:	55                   	push   %ebp
  800fbe:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc3:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800fc8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800fcd:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800fd2:	5d                   	pop    %ebp
  800fd3:	c3                   	ret    

00800fd4 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800fd4:	55                   	push   %ebp
  800fd5:	89 e5                	mov    %esp,%ebp
  800fd7:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800fdc:	89 c2                	mov    %eax,%edx
  800fde:	c1 ea 16             	shr    $0x16,%edx
  800fe1:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800fe8:	f6 c2 01             	test   $0x1,%dl
  800feb:	74 2d                	je     80101a <fd_alloc+0x46>
  800fed:	89 c2                	mov    %eax,%edx
  800fef:	c1 ea 0c             	shr    $0xc,%edx
  800ff2:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800ff9:	f6 c2 01             	test   $0x1,%dl
  800ffc:	74 1c                	je     80101a <fd_alloc+0x46>
  800ffe:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801003:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801008:	75 d2                	jne    800fdc <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80100a:	8b 45 08             	mov    0x8(%ebp),%eax
  80100d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801013:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801018:	eb 0a                	jmp    801024 <fd_alloc+0x50>
			*fd_store = fd;
  80101a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80101d:	89 01                	mov    %eax,(%ecx)
			return 0;
  80101f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801024:	5d                   	pop    %ebp
  801025:	c3                   	ret    

00801026 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801026:	55                   	push   %ebp
  801027:	89 e5                	mov    %esp,%ebp
  801029:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80102c:	83 f8 1f             	cmp    $0x1f,%eax
  80102f:	77 30                	ja     801061 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801031:	c1 e0 0c             	shl    $0xc,%eax
  801034:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801039:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80103f:	f6 c2 01             	test   $0x1,%dl
  801042:	74 24                	je     801068 <fd_lookup+0x42>
  801044:	89 c2                	mov    %eax,%edx
  801046:	c1 ea 0c             	shr    $0xc,%edx
  801049:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801050:	f6 c2 01             	test   $0x1,%dl
  801053:	74 1a                	je     80106f <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801055:	8b 55 0c             	mov    0xc(%ebp),%edx
  801058:	89 02                	mov    %eax,(%edx)
	return 0;
  80105a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80105f:	5d                   	pop    %ebp
  801060:	c3                   	ret    
		return -E_INVAL;
  801061:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801066:	eb f7                	jmp    80105f <fd_lookup+0x39>
		return -E_INVAL;
  801068:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80106d:	eb f0                	jmp    80105f <fd_lookup+0x39>
  80106f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801074:	eb e9                	jmp    80105f <fd_lookup+0x39>

00801076 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801076:	55                   	push   %ebp
  801077:	89 e5                	mov    %esp,%ebp
  801079:	83 ec 08             	sub    $0x8,%esp
  80107c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80107f:	ba 8c 25 80 00       	mov    $0x80258c,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801084:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801089:	39 08                	cmp    %ecx,(%eax)
  80108b:	74 33                	je     8010c0 <dev_lookup+0x4a>
  80108d:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801090:	8b 02                	mov    (%edx),%eax
  801092:	85 c0                	test   %eax,%eax
  801094:	75 f3                	jne    801089 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801096:	a1 20 60 80 00       	mov    0x806020,%eax
  80109b:	8b 40 48             	mov    0x48(%eax),%eax
  80109e:	83 ec 04             	sub    $0x4,%esp
  8010a1:	51                   	push   %ecx
  8010a2:	50                   	push   %eax
  8010a3:	68 0c 25 80 00       	push   $0x80250c
  8010a8:	e8 b6 f1 ff ff       	call   800263 <cprintf>
	*dev = 0;
  8010ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8010b6:	83 c4 10             	add    $0x10,%esp
  8010b9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8010be:	c9                   	leave  
  8010bf:	c3                   	ret    
			*dev = devtab[i];
  8010c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010c3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8010ca:	eb f2                	jmp    8010be <dev_lookup+0x48>

008010cc <fd_close>:
{
  8010cc:	55                   	push   %ebp
  8010cd:	89 e5                	mov    %esp,%ebp
  8010cf:	57                   	push   %edi
  8010d0:	56                   	push   %esi
  8010d1:	53                   	push   %ebx
  8010d2:	83 ec 24             	sub    $0x24,%esp
  8010d5:	8b 75 08             	mov    0x8(%ebp),%esi
  8010d8:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010db:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8010de:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010df:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8010e5:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010e8:	50                   	push   %eax
  8010e9:	e8 38 ff ff ff       	call   801026 <fd_lookup>
  8010ee:	89 c3                	mov    %eax,%ebx
  8010f0:	83 c4 10             	add    $0x10,%esp
  8010f3:	85 c0                	test   %eax,%eax
  8010f5:	78 05                	js     8010fc <fd_close+0x30>
	    || fd != fd2)
  8010f7:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8010fa:	74 16                	je     801112 <fd_close+0x46>
		return (must_exist ? r : 0);
  8010fc:	89 f8                	mov    %edi,%eax
  8010fe:	84 c0                	test   %al,%al
  801100:	b8 00 00 00 00       	mov    $0x0,%eax
  801105:	0f 44 d8             	cmove  %eax,%ebx
}
  801108:	89 d8                	mov    %ebx,%eax
  80110a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80110d:	5b                   	pop    %ebx
  80110e:	5e                   	pop    %esi
  80110f:	5f                   	pop    %edi
  801110:	5d                   	pop    %ebp
  801111:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801112:	83 ec 08             	sub    $0x8,%esp
  801115:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801118:	50                   	push   %eax
  801119:	ff 36                	pushl  (%esi)
  80111b:	e8 56 ff ff ff       	call   801076 <dev_lookup>
  801120:	89 c3                	mov    %eax,%ebx
  801122:	83 c4 10             	add    $0x10,%esp
  801125:	85 c0                	test   %eax,%eax
  801127:	78 1a                	js     801143 <fd_close+0x77>
		if (dev->dev_close)
  801129:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80112c:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80112f:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801134:	85 c0                	test   %eax,%eax
  801136:	74 0b                	je     801143 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801138:	83 ec 0c             	sub    $0xc,%esp
  80113b:	56                   	push   %esi
  80113c:	ff d0                	call   *%eax
  80113e:	89 c3                	mov    %eax,%ebx
  801140:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801143:	83 ec 08             	sub    $0x8,%esp
  801146:	56                   	push   %esi
  801147:	6a 00                	push   $0x0
  801149:	e8 b2 fc ff ff       	call   800e00 <sys_page_unmap>
	return r;
  80114e:	83 c4 10             	add    $0x10,%esp
  801151:	eb b5                	jmp    801108 <fd_close+0x3c>

00801153 <close>:

int
close(int fdnum)
{
  801153:	55                   	push   %ebp
  801154:	89 e5                	mov    %esp,%ebp
  801156:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801159:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80115c:	50                   	push   %eax
  80115d:	ff 75 08             	pushl  0x8(%ebp)
  801160:	e8 c1 fe ff ff       	call   801026 <fd_lookup>
  801165:	83 c4 10             	add    $0x10,%esp
  801168:	85 c0                	test   %eax,%eax
  80116a:	79 02                	jns    80116e <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80116c:	c9                   	leave  
  80116d:	c3                   	ret    
		return fd_close(fd, 1);
  80116e:	83 ec 08             	sub    $0x8,%esp
  801171:	6a 01                	push   $0x1
  801173:	ff 75 f4             	pushl  -0xc(%ebp)
  801176:	e8 51 ff ff ff       	call   8010cc <fd_close>
  80117b:	83 c4 10             	add    $0x10,%esp
  80117e:	eb ec                	jmp    80116c <close+0x19>

00801180 <close_all>:

void
close_all(void)
{
  801180:	55                   	push   %ebp
  801181:	89 e5                	mov    %esp,%ebp
  801183:	53                   	push   %ebx
  801184:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801187:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80118c:	83 ec 0c             	sub    $0xc,%esp
  80118f:	53                   	push   %ebx
  801190:	e8 be ff ff ff       	call   801153 <close>
	for (i = 0; i < MAXFD; i++)
  801195:	83 c3 01             	add    $0x1,%ebx
  801198:	83 c4 10             	add    $0x10,%esp
  80119b:	83 fb 20             	cmp    $0x20,%ebx
  80119e:	75 ec                	jne    80118c <close_all+0xc>
}
  8011a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011a3:	c9                   	leave  
  8011a4:	c3                   	ret    

008011a5 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8011a5:	55                   	push   %ebp
  8011a6:	89 e5                	mov    %esp,%ebp
  8011a8:	57                   	push   %edi
  8011a9:	56                   	push   %esi
  8011aa:	53                   	push   %ebx
  8011ab:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8011ae:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011b1:	50                   	push   %eax
  8011b2:	ff 75 08             	pushl  0x8(%ebp)
  8011b5:	e8 6c fe ff ff       	call   801026 <fd_lookup>
  8011ba:	89 c3                	mov    %eax,%ebx
  8011bc:	83 c4 10             	add    $0x10,%esp
  8011bf:	85 c0                	test   %eax,%eax
  8011c1:	0f 88 81 00 00 00    	js     801248 <dup+0xa3>
		return r;
	close(newfdnum);
  8011c7:	83 ec 0c             	sub    $0xc,%esp
  8011ca:	ff 75 0c             	pushl  0xc(%ebp)
  8011cd:	e8 81 ff ff ff       	call   801153 <close>

	newfd = INDEX2FD(newfdnum);
  8011d2:	8b 75 0c             	mov    0xc(%ebp),%esi
  8011d5:	c1 e6 0c             	shl    $0xc,%esi
  8011d8:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8011de:	83 c4 04             	add    $0x4,%esp
  8011e1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011e4:	e8 d4 fd ff ff       	call   800fbd <fd2data>
  8011e9:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8011eb:	89 34 24             	mov    %esi,(%esp)
  8011ee:	e8 ca fd ff ff       	call   800fbd <fd2data>
  8011f3:	83 c4 10             	add    $0x10,%esp
  8011f6:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8011f8:	89 d8                	mov    %ebx,%eax
  8011fa:	c1 e8 16             	shr    $0x16,%eax
  8011fd:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801204:	a8 01                	test   $0x1,%al
  801206:	74 11                	je     801219 <dup+0x74>
  801208:	89 d8                	mov    %ebx,%eax
  80120a:	c1 e8 0c             	shr    $0xc,%eax
  80120d:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801214:	f6 c2 01             	test   $0x1,%dl
  801217:	75 39                	jne    801252 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801219:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80121c:	89 d0                	mov    %edx,%eax
  80121e:	c1 e8 0c             	shr    $0xc,%eax
  801221:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801228:	83 ec 0c             	sub    $0xc,%esp
  80122b:	25 07 0e 00 00       	and    $0xe07,%eax
  801230:	50                   	push   %eax
  801231:	56                   	push   %esi
  801232:	6a 00                	push   $0x0
  801234:	52                   	push   %edx
  801235:	6a 00                	push   $0x0
  801237:	e8 82 fb ff ff       	call   800dbe <sys_page_map>
  80123c:	89 c3                	mov    %eax,%ebx
  80123e:	83 c4 20             	add    $0x20,%esp
  801241:	85 c0                	test   %eax,%eax
  801243:	78 31                	js     801276 <dup+0xd1>
		goto err;

	return newfdnum;
  801245:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801248:	89 d8                	mov    %ebx,%eax
  80124a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80124d:	5b                   	pop    %ebx
  80124e:	5e                   	pop    %esi
  80124f:	5f                   	pop    %edi
  801250:	5d                   	pop    %ebp
  801251:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801252:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801259:	83 ec 0c             	sub    $0xc,%esp
  80125c:	25 07 0e 00 00       	and    $0xe07,%eax
  801261:	50                   	push   %eax
  801262:	57                   	push   %edi
  801263:	6a 00                	push   $0x0
  801265:	53                   	push   %ebx
  801266:	6a 00                	push   $0x0
  801268:	e8 51 fb ff ff       	call   800dbe <sys_page_map>
  80126d:	89 c3                	mov    %eax,%ebx
  80126f:	83 c4 20             	add    $0x20,%esp
  801272:	85 c0                	test   %eax,%eax
  801274:	79 a3                	jns    801219 <dup+0x74>
	sys_page_unmap(0, newfd);
  801276:	83 ec 08             	sub    $0x8,%esp
  801279:	56                   	push   %esi
  80127a:	6a 00                	push   $0x0
  80127c:	e8 7f fb ff ff       	call   800e00 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801281:	83 c4 08             	add    $0x8,%esp
  801284:	57                   	push   %edi
  801285:	6a 00                	push   $0x0
  801287:	e8 74 fb ff ff       	call   800e00 <sys_page_unmap>
	return r;
  80128c:	83 c4 10             	add    $0x10,%esp
  80128f:	eb b7                	jmp    801248 <dup+0xa3>

00801291 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801291:	55                   	push   %ebp
  801292:	89 e5                	mov    %esp,%ebp
  801294:	53                   	push   %ebx
  801295:	83 ec 1c             	sub    $0x1c,%esp
  801298:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80129b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80129e:	50                   	push   %eax
  80129f:	53                   	push   %ebx
  8012a0:	e8 81 fd ff ff       	call   801026 <fd_lookup>
  8012a5:	83 c4 10             	add    $0x10,%esp
  8012a8:	85 c0                	test   %eax,%eax
  8012aa:	78 3f                	js     8012eb <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012ac:	83 ec 08             	sub    $0x8,%esp
  8012af:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012b2:	50                   	push   %eax
  8012b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012b6:	ff 30                	pushl  (%eax)
  8012b8:	e8 b9 fd ff ff       	call   801076 <dev_lookup>
  8012bd:	83 c4 10             	add    $0x10,%esp
  8012c0:	85 c0                	test   %eax,%eax
  8012c2:	78 27                	js     8012eb <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8012c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012c7:	8b 42 08             	mov    0x8(%edx),%eax
  8012ca:	83 e0 03             	and    $0x3,%eax
  8012cd:	83 f8 01             	cmp    $0x1,%eax
  8012d0:	74 1e                	je     8012f0 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8012d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012d5:	8b 40 08             	mov    0x8(%eax),%eax
  8012d8:	85 c0                	test   %eax,%eax
  8012da:	74 35                	je     801311 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8012dc:	83 ec 04             	sub    $0x4,%esp
  8012df:	ff 75 10             	pushl  0x10(%ebp)
  8012e2:	ff 75 0c             	pushl  0xc(%ebp)
  8012e5:	52                   	push   %edx
  8012e6:	ff d0                	call   *%eax
  8012e8:	83 c4 10             	add    $0x10,%esp
}
  8012eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012ee:	c9                   	leave  
  8012ef:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8012f0:	a1 20 60 80 00       	mov    0x806020,%eax
  8012f5:	8b 40 48             	mov    0x48(%eax),%eax
  8012f8:	83 ec 04             	sub    $0x4,%esp
  8012fb:	53                   	push   %ebx
  8012fc:	50                   	push   %eax
  8012fd:	68 50 25 80 00       	push   $0x802550
  801302:	e8 5c ef ff ff       	call   800263 <cprintf>
		return -E_INVAL;
  801307:	83 c4 10             	add    $0x10,%esp
  80130a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80130f:	eb da                	jmp    8012eb <read+0x5a>
		return -E_NOT_SUPP;
  801311:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801316:	eb d3                	jmp    8012eb <read+0x5a>

00801318 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801318:	55                   	push   %ebp
  801319:	89 e5                	mov    %esp,%ebp
  80131b:	57                   	push   %edi
  80131c:	56                   	push   %esi
  80131d:	53                   	push   %ebx
  80131e:	83 ec 0c             	sub    $0xc,%esp
  801321:	8b 7d 08             	mov    0x8(%ebp),%edi
  801324:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801327:	bb 00 00 00 00       	mov    $0x0,%ebx
  80132c:	39 f3                	cmp    %esi,%ebx
  80132e:	73 23                	jae    801353 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801330:	83 ec 04             	sub    $0x4,%esp
  801333:	89 f0                	mov    %esi,%eax
  801335:	29 d8                	sub    %ebx,%eax
  801337:	50                   	push   %eax
  801338:	89 d8                	mov    %ebx,%eax
  80133a:	03 45 0c             	add    0xc(%ebp),%eax
  80133d:	50                   	push   %eax
  80133e:	57                   	push   %edi
  80133f:	e8 4d ff ff ff       	call   801291 <read>
		if (m < 0)
  801344:	83 c4 10             	add    $0x10,%esp
  801347:	85 c0                	test   %eax,%eax
  801349:	78 06                	js     801351 <readn+0x39>
			return m;
		if (m == 0)
  80134b:	74 06                	je     801353 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  80134d:	01 c3                	add    %eax,%ebx
  80134f:	eb db                	jmp    80132c <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801351:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801353:	89 d8                	mov    %ebx,%eax
  801355:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801358:	5b                   	pop    %ebx
  801359:	5e                   	pop    %esi
  80135a:	5f                   	pop    %edi
  80135b:	5d                   	pop    %ebp
  80135c:	c3                   	ret    

0080135d <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80135d:	55                   	push   %ebp
  80135e:	89 e5                	mov    %esp,%ebp
  801360:	53                   	push   %ebx
  801361:	83 ec 1c             	sub    $0x1c,%esp
  801364:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801367:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80136a:	50                   	push   %eax
  80136b:	53                   	push   %ebx
  80136c:	e8 b5 fc ff ff       	call   801026 <fd_lookup>
  801371:	83 c4 10             	add    $0x10,%esp
  801374:	85 c0                	test   %eax,%eax
  801376:	78 3a                	js     8013b2 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801378:	83 ec 08             	sub    $0x8,%esp
  80137b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80137e:	50                   	push   %eax
  80137f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801382:	ff 30                	pushl  (%eax)
  801384:	e8 ed fc ff ff       	call   801076 <dev_lookup>
  801389:	83 c4 10             	add    $0x10,%esp
  80138c:	85 c0                	test   %eax,%eax
  80138e:	78 22                	js     8013b2 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801390:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801393:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801397:	74 1e                	je     8013b7 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801399:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80139c:	8b 52 0c             	mov    0xc(%edx),%edx
  80139f:	85 d2                	test   %edx,%edx
  8013a1:	74 35                	je     8013d8 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8013a3:	83 ec 04             	sub    $0x4,%esp
  8013a6:	ff 75 10             	pushl  0x10(%ebp)
  8013a9:	ff 75 0c             	pushl  0xc(%ebp)
  8013ac:	50                   	push   %eax
  8013ad:	ff d2                	call   *%edx
  8013af:	83 c4 10             	add    $0x10,%esp
}
  8013b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013b5:	c9                   	leave  
  8013b6:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8013b7:	a1 20 60 80 00       	mov    0x806020,%eax
  8013bc:	8b 40 48             	mov    0x48(%eax),%eax
  8013bf:	83 ec 04             	sub    $0x4,%esp
  8013c2:	53                   	push   %ebx
  8013c3:	50                   	push   %eax
  8013c4:	68 6c 25 80 00       	push   $0x80256c
  8013c9:	e8 95 ee ff ff       	call   800263 <cprintf>
		return -E_INVAL;
  8013ce:	83 c4 10             	add    $0x10,%esp
  8013d1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013d6:	eb da                	jmp    8013b2 <write+0x55>
		return -E_NOT_SUPP;
  8013d8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013dd:	eb d3                	jmp    8013b2 <write+0x55>

008013df <seek>:

int
seek(int fdnum, off_t offset)
{
  8013df:	55                   	push   %ebp
  8013e0:	89 e5                	mov    %esp,%ebp
  8013e2:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013e8:	50                   	push   %eax
  8013e9:	ff 75 08             	pushl  0x8(%ebp)
  8013ec:	e8 35 fc ff ff       	call   801026 <fd_lookup>
  8013f1:	83 c4 10             	add    $0x10,%esp
  8013f4:	85 c0                	test   %eax,%eax
  8013f6:	78 0e                	js     801406 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8013f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013fe:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801401:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801406:	c9                   	leave  
  801407:	c3                   	ret    

00801408 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801408:	55                   	push   %ebp
  801409:	89 e5                	mov    %esp,%ebp
  80140b:	53                   	push   %ebx
  80140c:	83 ec 1c             	sub    $0x1c,%esp
  80140f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801412:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801415:	50                   	push   %eax
  801416:	53                   	push   %ebx
  801417:	e8 0a fc ff ff       	call   801026 <fd_lookup>
  80141c:	83 c4 10             	add    $0x10,%esp
  80141f:	85 c0                	test   %eax,%eax
  801421:	78 37                	js     80145a <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801423:	83 ec 08             	sub    $0x8,%esp
  801426:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801429:	50                   	push   %eax
  80142a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80142d:	ff 30                	pushl  (%eax)
  80142f:	e8 42 fc ff ff       	call   801076 <dev_lookup>
  801434:	83 c4 10             	add    $0x10,%esp
  801437:	85 c0                	test   %eax,%eax
  801439:	78 1f                	js     80145a <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80143b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80143e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801442:	74 1b                	je     80145f <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801444:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801447:	8b 52 18             	mov    0x18(%edx),%edx
  80144a:	85 d2                	test   %edx,%edx
  80144c:	74 32                	je     801480 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80144e:	83 ec 08             	sub    $0x8,%esp
  801451:	ff 75 0c             	pushl  0xc(%ebp)
  801454:	50                   	push   %eax
  801455:	ff d2                	call   *%edx
  801457:	83 c4 10             	add    $0x10,%esp
}
  80145a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80145d:	c9                   	leave  
  80145e:	c3                   	ret    
			thisenv->env_id, fdnum);
  80145f:	a1 20 60 80 00       	mov    0x806020,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801464:	8b 40 48             	mov    0x48(%eax),%eax
  801467:	83 ec 04             	sub    $0x4,%esp
  80146a:	53                   	push   %ebx
  80146b:	50                   	push   %eax
  80146c:	68 2c 25 80 00       	push   $0x80252c
  801471:	e8 ed ed ff ff       	call   800263 <cprintf>
		return -E_INVAL;
  801476:	83 c4 10             	add    $0x10,%esp
  801479:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80147e:	eb da                	jmp    80145a <ftruncate+0x52>
		return -E_NOT_SUPP;
  801480:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801485:	eb d3                	jmp    80145a <ftruncate+0x52>

00801487 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801487:	55                   	push   %ebp
  801488:	89 e5                	mov    %esp,%ebp
  80148a:	53                   	push   %ebx
  80148b:	83 ec 1c             	sub    $0x1c,%esp
  80148e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801491:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801494:	50                   	push   %eax
  801495:	ff 75 08             	pushl  0x8(%ebp)
  801498:	e8 89 fb ff ff       	call   801026 <fd_lookup>
  80149d:	83 c4 10             	add    $0x10,%esp
  8014a0:	85 c0                	test   %eax,%eax
  8014a2:	78 4b                	js     8014ef <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014a4:	83 ec 08             	sub    $0x8,%esp
  8014a7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014aa:	50                   	push   %eax
  8014ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014ae:	ff 30                	pushl  (%eax)
  8014b0:	e8 c1 fb ff ff       	call   801076 <dev_lookup>
  8014b5:	83 c4 10             	add    $0x10,%esp
  8014b8:	85 c0                	test   %eax,%eax
  8014ba:	78 33                	js     8014ef <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8014bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014bf:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8014c3:	74 2f                	je     8014f4 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8014c5:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8014c8:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8014cf:	00 00 00 
	stat->st_isdir = 0;
  8014d2:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8014d9:	00 00 00 
	stat->st_dev = dev;
  8014dc:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8014e2:	83 ec 08             	sub    $0x8,%esp
  8014e5:	53                   	push   %ebx
  8014e6:	ff 75 f0             	pushl  -0x10(%ebp)
  8014e9:	ff 50 14             	call   *0x14(%eax)
  8014ec:	83 c4 10             	add    $0x10,%esp
}
  8014ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014f2:	c9                   	leave  
  8014f3:	c3                   	ret    
		return -E_NOT_SUPP;
  8014f4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014f9:	eb f4                	jmp    8014ef <fstat+0x68>

008014fb <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8014fb:	55                   	push   %ebp
  8014fc:	89 e5                	mov    %esp,%ebp
  8014fe:	56                   	push   %esi
  8014ff:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801500:	83 ec 08             	sub    $0x8,%esp
  801503:	6a 00                	push   $0x0
  801505:	ff 75 08             	pushl  0x8(%ebp)
  801508:	e8 bb 01 00 00       	call   8016c8 <open>
  80150d:	89 c3                	mov    %eax,%ebx
  80150f:	83 c4 10             	add    $0x10,%esp
  801512:	85 c0                	test   %eax,%eax
  801514:	78 1b                	js     801531 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801516:	83 ec 08             	sub    $0x8,%esp
  801519:	ff 75 0c             	pushl  0xc(%ebp)
  80151c:	50                   	push   %eax
  80151d:	e8 65 ff ff ff       	call   801487 <fstat>
  801522:	89 c6                	mov    %eax,%esi
	close(fd);
  801524:	89 1c 24             	mov    %ebx,(%esp)
  801527:	e8 27 fc ff ff       	call   801153 <close>
	return r;
  80152c:	83 c4 10             	add    $0x10,%esp
  80152f:	89 f3                	mov    %esi,%ebx
}
  801531:	89 d8                	mov    %ebx,%eax
  801533:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801536:	5b                   	pop    %ebx
  801537:	5e                   	pop    %esi
  801538:	5d                   	pop    %ebp
  801539:	c3                   	ret    

0080153a <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80153a:	55                   	push   %ebp
  80153b:	89 e5                	mov    %esp,%ebp
  80153d:	56                   	push   %esi
  80153e:	53                   	push   %ebx
  80153f:	89 c6                	mov    %eax,%esi
  801541:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801543:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80154a:	74 27                	je     801573 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80154c:	6a 07                	push   $0x7
  80154e:	68 00 70 80 00       	push   $0x807000
  801553:	56                   	push   %esi
  801554:	ff 35 00 40 80 00    	pushl  0x804000
  80155a:	e8 4e 08 00 00       	call   801dad <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80155f:	83 c4 0c             	add    $0xc,%esp
  801562:	6a 00                	push   $0x0
  801564:	53                   	push   %ebx
  801565:	6a 00                	push   $0x0
  801567:	e8 d8 07 00 00       	call   801d44 <ipc_recv>
}
  80156c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80156f:	5b                   	pop    %ebx
  801570:	5e                   	pop    %esi
  801571:	5d                   	pop    %ebp
  801572:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801573:	83 ec 0c             	sub    $0xc,%esp
  801576:	6a 01                	push   $0x1
  801578:	e8 7d 08 00 00       	call   801dfa <ipc_find_env>
  80157d:	a3 00 40 80 00       	mov    %eax,0x804000
  801582:	83 c4 10             	add    $0x10,%esp
  801585:	eb c5                	jmp    80154c <fsipc+0x12>

00801587 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801587:	55                   	push   %ebp
  801588:	89 e5                	mov    %esp,%ebp
  80158a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80158d:	8b 45 08             	mov    0x8(%ebp),%eax
  801590:	8b 40 0c             	mov    0xc(%eax),%eax
  801593:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.set_size.req_size = newsize;
  801598:	8b 45 0c             	mov    0xc(%ebp),%eax
  80159b:	a3 04 70 80 00       	mov    %eax,0x807004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8015a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8015a5:	b8 02 00 00 00       	mov    $0x2,%eax
  8015aa:	e8 8b ff ff ff       	call   80153a <fsipc>
}
  8015af:	c9                   	leave  
  8015b0:	c3                   	ret    

008015b1 <devfile_flush>:
{
  8015b1:	55                   	push   %ebp
  8015b2:	89 e5                	mov    %esp,%ebp
  8015b4:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8015b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8015bd:	a3 00 70 80 00       	mov    %eax,0x807000
	return fsipc(FSREQ_FLUSH, NULL);
  8015c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8015c7:	b8 06 00 00 00       	mov    $0x6,%eax
  8015cc:	e8 69 ff ff ff       	call   80153a <fsipc>
}
  8015d1:	c9                   	leave  
  8015d2:	c3                   	ret    

008015d3 <devfile_stat>:
{
  8015d3:	55                   	push   %ebp
  8015d4:	89 e5                	mov    %esp,%ebp
  8015d6:	53                   	push   %ebx
  8015d7:	83 ec 04             	sub    $0x4,%esp
  8015da:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8015dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8015e3:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8015e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8015ed:	b8 05 00 00 00       	mov    $0x5,%eax
  8015f2:	e8 43 ff ff ff       	call   80153a <fsipc>
  8015f7:	85 c0                	test   %eax,%eax
  8015f9:	78 2c                	js     801627 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8015fb:	83 ec 08             	sub    $0x8,%esp
  8015fe:	68 00 70 80 00       	push   $0x807000
  801603:	53                   	push   %ebx
  801604:	e8 80 f3 ff ff       	call   800989 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801609:	a1 80 70 80 00       	mov    0x807080,%eax
  80160e:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801614:	a1 84 70 80 00       	mov    0x807084,%eax
  801619:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80161f:	83 c4 10             	add    $0x10,%esp
  801622:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801627:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80162a:	c9                   	leave  
  80162b:	c3                   	ret    

0080162c <devfile_write>:
{
  80162c:	55                   	push   %ebp
  80162d:	89 e5                	mov    %esp,%ebp
  80162f:	83 ec 0c             	sub    $0xc,%esp
	panic("devfile_write not implemented");
  801632:	68 9c 25 80 00       	push   $0x80259c
  801637:	68 90 00 00 00       	push   $0x90
  80163c:	68 ba 25 80 00       	push   $0x8025ba
  801641:	e8 42 eb ff ff       	call   800188 <_panic>

00801646 <devfile_read>:
{
  801646:	55                   	push   %ebp
  801647:	89 e5                	mov    %esp,%ebp
  801649:	56                   	push   %esi
  80164a:	53                   	push   %ebx
  80164b:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80164e:	8b 45 08             	mov    0x8(%ebp),%eax
  801651:	8b 40 0c             	mov    0xc(%eax),%eax
  801654:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.read.req_n = n;
  801659:	89 35 04 70 80 00    	mov    %esi,0x807004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80165f:	ba 00 00 00 00       	mov    $0x0,%edx
  801664:	b8 03 00 00 00       	mov    $0x3,%eax
  801669:	e8 cc fe ff ff       	call   80153a <fsipc>
  80166e:	89 c3                	mov    %eax,%ebx
  801670:	85 c0                	test   %eax,%eax
  801672:	78 1f                	js     801693 <devfile_read+0x4d>
	assert(r <= n);
  801674:	39 f0                	cmp    %esi,%eax
  801676:	77 24                	ja     80169c <devfile_read+0x56>
	assert(r <= PGSIZE);
  801678:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80167d:	7f 33                	jg     8016b2 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80167f:	83 ec 04             	sub    $0x4,%esp
  801682:	50                   	push   %eax
  801683:	68 00 70 80 00       	push   $0x807000
  801688:	ff 75 0c             	pushl  0xc(%ebp)
  80168b:	e8 87 f4 ff ff       	call   800b17 <memmove>
	return r;
  801690:	83 c4 10             	add    $0x10,%esp
}
  801693:	89 d8                	mov    %ebx,%eax
  801695:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801698:	5b                   	pop    %ebx
  801699:	5e                   	pop    %esi
  80169a:	5d                   	pop    %ebp
  80169b:	c3                   	ret    
	assert(r <= n);
  80169c:	68 c5 25 80 00       	push   $0x8025c5
  8016a1:	68 cc 25 80 00       	push   $0x8025cc
  8016a6:	6a 7c                	push   $0x7c
  8016a8:	68 ba 25 80 00       	push   $0x8025ba
  8016ad:	e8 d6 ea ff ff       	call   800188 <_panic>
	assert(r <= PGSIZE);
  8016b2:	68 e1 25 80 00       	push   $0x8025e1
  8016b7:	68 cc 25 80 00       	push   $0x8025cc
  8016bc:	6a 7d                	push   $0x7d
  8016be:	68 ba 25 80 00       	push   $0x8025ba
  8016c3:	e8 c0 ea ff ff       	call   800188 <_panic>

008016c8 <open>:
{
  8016c8:	55                   	push   %ebp
  8016c9:	89 e5                	mov    %esp,%ebp
  8016cb:	56                   	push   %esi
  8016cc:	53                   	push   %ebx
  8016cd:	83 ec 1c             	sub    $0x1c,%esp
  8016d0:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8016d3:	56                   	push   %esi
  8016d4:	e8 77 f2 ff ff       	call   800950 <strlen>
  8016d9:	83 c4 10             	add    $0x10,%esp
  8016dc:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8016e1:	7f 6c                	jg     80174f <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8016e3:	83 ec 0c             	sub    $0xc,%esp
  8016e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016e9:	50                   	push   %eax
  8016ea:	e8 e5 f8 ff ff       	call   800fd4 <fd_alloc>
  8016ef:	89 c3                	mov    %eax,%ebx
  8016f1:	83 c4 10             	add    $0x10,%esp
  8016f4:	85 c0                	test   %eax,%eax
  8016f6:	78 3c                	js     801734 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8016f8:	83 ec 08             	sub    $0x8,%esp
  8016fb:	56                   	push   %esi
  8016fc:	68 00 70 80 00       	push   $0x807000
  801701:	e8 83 f2 ff ff       	call   800989 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801706:	8b 45 0c             	mov    0xc(%ebp),%eax
  801709:	a3 00 74 80 00       	mov    %eax,0x807400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80170e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801711:	b8 01 00 00 00       	mov    $0x1,%eax
  801716:	e8 1f fe ff ff       	call   80153a <fsipc>
  80171b:	89 c3                	mov    %eax,%ebx
  80171d:	83 c4 10             	add    $0x10,%esp
  801720:	85 c0                	test   %eax,%eax
  801722:	78 19                	js     80173d <open+0x75>
	return fd2num(fd);
  801724:	83 ec 0c             	sub    $0xc,%esp
  801727:	ff 75 f4             	pushl  -0xc(%ebp)
  80172a:	e8 7e f8 ff ff       	call   800fad <fd2num>
  80172f:	89 c3                	mov    %eax,%ebx
  801731:	83 c4 10             	add    $0x10,%esp
}
  801734:	89 d8                	mov    %ebx,%eax
  801736:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801739:	5b                   	pop    %ebx
  80173a:	5e                   	pop    %esi
  80173b:	5d                   	pop    %ebp
  80173c:	c3                   	ret    
		fd_close(fd, 0);
  80173d:	83 ec 08             	sub    $0x8,%esp
  801740:	6a 00                	push   $0x0
  801742:	ff 75 f4             	pushl  -0xc(%ebp)
  801745:	e8 82 f9 ff ff       	call   8010cc <fd_close>
		return r;
  80174a:	83 c4 10             	add    $0x10,%esp
  80174d:	eb e5                	jmp    801734 <open+0x6c>
		return -E_BAD_PATH;
  80174f:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801754:	eb de                	jmp    801734 <open+0x6c>

00801756 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801756:	55                   	push   %ebp
  801757:	89 e5                	mov    %esp,%ebp
  801759:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80175c:	ba 00 00 00 00       	mov    $0x0,%edx
  801761:	b8 08 00 00 00       	mov    $0x8,%eax
  801766:	e8 cf fd ff ff       	call   80153a <fsipc>
}
  80176b:	c9                   	leave  
  80176c:	c3                   	ret    

0080176d <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  80176d:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801771:	7f 01                	jg     801774 <writebuf+0x7>
  801773:	c3                   	ret    
{
  801774:	55                   	push   %ebp
  801775:	89 e5                	mov    %esp,%ebp
  801777:	53                   	push   %ebx
  801778:	83 ec 08             	sub    $0x8,%esp
  80177b:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  80177d:	ff 70 04             	pushl  0x4(%eax)
  801780:	8d 40 10             	lea    0x10(%eax),%eax
  801783:	50                   	push   %eax
  801784:	ff 33                	pushl  (%ebx)
  801786:	e8 d2 fb ff ff       	call   80135d <write>
		if (result > 0)
  80178b:	83 c4 10             	add    $0x10,%esp
  80178e:	85 c0                	test   %eax,%eax
  801790:	7e 03                	jle    801795 <writebuf+0x28>
			b->result += result;
  801792:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801795:	39 43 04             	cmp    %eax,0x4(%ebx)
  801798:	74 0d                	je     8017a7 <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  80179a:	85 c0                	test   %eax,%eax
  80179c:	ba 00 00 00 00       	mov    $0x0,%edx
  8017a1:	0f 4f c2             	cmovg  %edx,%eax
  8017a4:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  8017a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017aa:	c9                   	leave  
  8017ab:	c3                   	ret    

008017ac <putch>:

static void
putch(int ch, void *thunk)
{
  8017ac:	55                   	push   %ebp
  8017ad:	89 e5                	mov    %esp,%ebp
  8017af:	53                   	push   %ebx
  8017b0:	83 ec 04             	sub    $0x4,%esp
  8017b3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  8017b6:	8b 53 04             	mov    0x4(%ebx),%edx
  8017b9:	8d 42 01             	lea    0x1(%edx),%eax
  8017bc:	89 43 04             	mov    %eax,0x4(%ebx)
  8017bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017c2:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  8017c6:	3d 00 01 00 00       	cmp    $0x100,%eax
  8017cb:	74 06                	je     8017d3 <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  8017cd:	83 c4 04             	add    $0x4,%esp
  8017d0:	5b                   	pop    %ebx
  8017d1:	5d                   	pop    %ebp
  8017d2:	c3                   	ret    
		writebuf(b);
  8017d3:	89 d8                	mov    %ebx,%eax
  8017d5:	e8 93 ff ff ff       	call   80176d <writebuf>
		b->idx = 0;
  8017da:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  8017e1:	eb ea                	jmp    8017cd <putch+0x21>

008017e3 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  8017e3:	55                   	push   %ebp
  8017e4:	89 e5                	mov    %esp,%ebp
  8017e6:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  8017ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ef:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  8017f5:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  8017fc:	00 00 00 
	b.result = 0;
  8017ff:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801806:	00 00 00 
	b.error = 1;
  801809:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801810:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801813:	ff 75 10             	pushl  0x10(%ebp)
  801816:	ff 75 0c             	pushl  0xc(%ebp)
  801819:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80181f:	50                   	push   %eax
  801820:	68 ac 17 80 00       	push   $0x8017ac
  801825:	e8 66 eb ff ff       	call   800390 <vprintfmt>
	if (b.idx > 0)
  80182a:	83 c4 10             	add    $0x10,%esp
  80182d:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801834:	7f 11                	jg     801847 <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  801836:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80183c:	85 c0                	test   %eax,%eax
  80183e:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801845:	c9                   	leave  
  801846:	c3                   	ret    
		writebuf(&b);
  801847:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80184d:	e8 1b ff ff ff       	call   80176d <writebuf>
  801852:	eb e2                	jmp    801836 <vfprintf+0x53>

00801854 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801854:	55                   	push   %ebp
  801855:	89 e5                	mov    %esp,%ebp
  801857:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80185a:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  80185d:	50                   	push   %eax
  80185e:	ff 75 0c             	pushl  0xc(%ebp)
  801861:	ff 75 08             	pushl  0x8(%ebp)
  801864:	e8 7a ff ff ff       	call   8017e3 <vfprintf>
	va_end(ap);

	return cnt;
}
  801869:	c9                   	leave  
  80186a:	c3                   	ret    

0080186b <printf>:

int
printf(const char *fmt, ...)
{
  80186b:	55                   	push   %ebp
  80186c:	89 e5                	mov    %esp,%ebp
  80186e:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801871:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801874:	50                   	push   %eax
  801875:	ff 75 08             	pushl  0x8(%ebp)
  801878:	6a 01                	push   $0x1
  80187a:	e8 64 ff ff ff       	call   8017e3 <vfprintf>
	va_end(ap);

	return cnt;
}
  80187f:	c9                   	leave  
  801880:	c3                   	ret    

00801881 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801881:	55                   	push   %ebp
  801882:	89 e5                	mov    %esp,%ebp
  801884:	56                   	push   %esi
  801885:	53                   	push   %ebx
  801886:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801889:	83 ec 0c             	sub    $0xc,%esp
  80188c:	ff 75 08             	pushl  0x8(%ebp)
  80188f:	e8 29 f7 ff ff       	call   800fbd <fd2data>
  801894:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801896:	83 c4 08             	add    $0x8,%esp
  801899:	68 ed 25 80 00       	push   $0x8025ed
  80189e:	53                   	push   %ebx
  80189f:	e8 e5 f0 ff ff       	call   800989 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8018a4:	8b 46 04             	mov    0x4(%esi),%eax
  8018a7:	2b 06                	sub    (%esi),%eax
  8018a9:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8018af:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8018b6:	00 00 00 
	stat->st_dev = &devpipe;
  8018b9:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  8018c0:	30 80 00 
	return 0;
}
  8018c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8018c8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018cb:	5b                   	pop    %ebx
  8018cc:	5e                   	pop    %esi
  8018cd:	5d                   	pop    %ebp
  8018ce:	c3                   	ret    

008018cf <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8018cf:	55                   	push   %ebp
  8018d0:	89 e5                	mov    %esp,%ebp
  8018d2:	53                   	push   %ebx
  8018d3:	83 ec 0c             	sub    $0xc,%esp
  8018d6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8018d9:	53                   	push   %ebx
  8018da:	6a 00                	push   $0x0
  8018dc:	e8 1f f5 ff ff       	call   800e00 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8018e1:	89 1c 24             	mov    %ebx,(%esp)
  8018e4:	e8 d4 f6 ff ff       	call   800fbd <fd2data>
  8018e9:	83 c4 08             	add    $0x8,%esp
  8018ec:	50                   	push   %eax
  8018ed:	6a 00                	push   $0x0
  8018ef:	e8 0c f5 ff ff       	call   800e00 <sys_page_unmap>
}
  8018f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018f7:	c9                   	leave  
  8018f8:	c3                   	ret    

008018f9 <_pipeisclosed>:
{
  8018f9:	55                   	push   %ebp
  8018fa:	89 e5                	mov    %esp,%ebp
  8018fc:	57                   	push   %edi
  8018fd:	56                   	push   %esi
  8018fe:	53                   	push   %ebx
  8018ff:	83 ec 1c             	sub    $0x1c,%esp
  801902:	89 c7                	mov    %eax,%edi
  801904:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801906:	a1 20 60 80 00       	mov    0x806020,%eax
  80190b:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80190e:	83 ec 0c             	sub    $0xc,%esp
  801911:	57                   	push   %edi
  801912:	e8 22 05 00 00       	call   801e39 <pageref>
  801917:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80191a:	89 34 24             	mov    %esi,(%esp)
  80191d:	e8 17 05 00 00       	call   801e39 <pageref>
		nn = thisenv->env_runs;
  801922:	8b 15 20 60 80 00    	mov    0x806020,%edx
  801928:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80192b:	83 c4 10             	add    $0x10,%esp
  80192e:	39 cb                	cmp    %ecx,%ebx
  801930:	74 1b                	je     80194d <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801932:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801935:	75 cf                	jne    801906 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801937:	8b 42 58             	mov    0x58(%edx),%eax
  80193a:	6a 01                	push   $0x1
  80193c:	50                   	push   %eax
  80193d:	53                   	push   %ebx
  80193e:	68 f4 25 80 00       	push   $0x8025f4
  801943:	e8 1b e9 ff ff       	call   800263 <cprintf>
  801948:	83 c4 10             	add    $0x10,%esp
  80194b:	eb b9                	jmp    801906 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  80194d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801950:	0f 94 c0             	sete   %al
  801953:	0f b6 c0             	movzbl %al,%eax
}
  801956:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801959:	5b                   	pop    %ebx
  80195a:	5e                   	pop    %esi
  80195b:	5f                   	pop    %edi
  80195c:	5d                   	pop    %ebp
  80195d:	c3                   	ret    

0080195e <devpipe_write>:
{
  80195e:	55                   	push   %ebp
  80195f:	89 e5                	mov    %esp,%ebp
  801961:	57                   	push   %edi
  801962:	56                   	push   %esi
  801963:	53                   	push   %ebx
  801964:	83 ec 28             	sub    $0x28,%esp
  801967:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80196a:	56                   	push   %esi
  80196b:	e8 4d f6 ff ff       	call   800fbd <fd2data>
  801970:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801972:	83 c4 10             	add    $0x10,%esp
  801975:	bf 00 00 00 00       	mov    $0x0,%edi
  80197a:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80197d:	74 4f                	je     8019ce <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80197f:	8b 43 04             	mov    0x4(%ebx),%eax
  801982:	8b 0b                	mov    (%ebx),%ecx
  801984:	8d 51 20             	lea    0x20(%ecx),%edx
  801987:	39 d0                	cmp    %edx,%eax
  801989:	72 14                	jb     80199f <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80198b:	89 da                	mov    %ebx,%edx
  80198d:	89 f0                	mov    %esi,%eax
  80198f:	e8 65 ff ff ff       	call   8018f9 <_pipeisclosed>
  801994:	85 c0                	test   %eax,%eax
  801996:	75 3b                	jne    8019d3 <devpipe_write+0x75>
			sys_yield();
  801998:	e8 bf f3 ff ff       	call   800d5c <sys_yield>
  80199d:	eb e0                	jmp    80197f <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80199f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019a2:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8019a6:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8019a9:	89 c2                	mov    %eax,%edx
  8019ab:	c1 fa 1f             	sar    $0x1f,%edx
  8019ae:	89 d1                	mov    %edx,%ecx
  8019b0:	c1 e9 1b             	shr    $0x1b,%ecx
  8019b3:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8019b6:	83 e2 1f             	and    $0x1f,%edx
  8019b9:	29 ca                	sub    %ecx,%edx
  8019bb:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8019bf:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8019c3:	83 c0 01             	add    $0x1,%eax
  8019c6:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8019c9:	83 c7 01             	add    $0x1,%edi
  8019cc:	eb ac                	jmp    80197a <devpipe_write+0x1c>
	return i;
  8019ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8019d1:	eb 05                	jmp    8019d8 <devpipe_write+0x7a>
				return 0;
  8019d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019db:	5b                   	pop    %ebx
  8019dc:	5e                   	pop    %esi
  8019dd:	5f                   	pop    %edi
  8019de:	5d                   	pop    %ebp
  8019df:	c3                   	ret    

008019e0 <devpipe_read>:
{
  8019e0:	55                   	push   %ebp
  8019e1:	89 e5                	mov    %esp,%ebp
  8019e3:	57                   	push   %edi
  8019e4:	56                   	push   %esi
  8019e5:	53                   	push   %ebx
  8019e6:	83 ec 18             	sub    $0x18,%esp
  8019e9:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8019ec:	57                   	push   %edi
  8019ed:	e8 cb f5 ff ff       	call   800fbd <fd2data>
  8019f2:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8019f4:	83 c4 10             	add    $0x10,%esp
  8019f7:	be 00 00 00 00       	mov    $0x0,%esi
  8019fc:	3b 75 10             	cmp    0x10(%ebp),%esi
  8019ff:	75 14                	jne    801a15 <devpipe_read+0x35>
	return i;
  801a01:	8b 45 10             	mov    0x10(%ebp),%eax
  801a04:	eb 02                	jmp    801a08 <devpipe_read+0x28>
				return i;
  801a06:	89 f0                	mov    %esi,%eax
}
  801a08:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a0b:	5b                   	pop    %ebx
  801a0c:	5e                   	pop    %esi
  801a0d:	5f                   	pop    %edi
  801a0e:	5d                   	pop    %ebp
  801a0f:	c3                   	ret    
			sys_yield();
  801a10:	e8 47 f3 ff ff       	call   800d5c <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801a15:	8b 03                	mov    (%ebx),%eax
  801a17:	3b 43 04             	cmp    0x4(%ebx),%eax
  801a1a:	75 18                	jne    801a34 <devpipe_read+0x54>
			if (i > 0)
  801a1c:	85 f6                	test   %esi,%esi
  801a1e:	75 e6                	jne    801a06 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801a20:	89 da                	mov    %ebx,%edx
  801a22:	89 f8                	mov    %edi,%eax
  801a24:	e8 d0 fe ff ff       	call   8018f9 <_pipeisclosed>
  801a29:	85 c0                	test   %eax,%eax
  801a2b:	74 e3                	je     801a10 <devpipe_read+0x30>
				return 0;
  801a2d:	b8 00 00 00 00       	mov    $0x0,%eax
  801a32:	eb d4                	jmp    801a08 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801a34:	99                   	cltd   
  801a35:	c1 ea 1b             	shr    $0x1b,%edx
  801a38:	01 d0                	add    %edx,%eax
  801a3a:	83 e0 1f             	and    $0x1f,%eax
  801a3d:	29 d0                	sub    %edx,%eax
  801a3f:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801a44:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a47:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801a4a:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801a4d:	83 c6 01             	add    $0x1,%esi
  801a50:	eb aa                	jmp    8019fc <devpipe_read+0x1c>

00801a52 <pipe>:
{
  801a52:	55                   	push   %ebp
  801a53:	89 e5                	mov    %esp,%ebp
  801a55:	56                   	push   %esi
  801a56:	53                   	push   %ebx
  801a57:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801a5a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a5d:	50                   	push   %eax
  801a5e:	e8 71 f5 ff ff       	call   800fd4 <fd_alloc>
  801a63:	89 c3                	mov    %eax,%ebx
  801a65:	83 c4 10             	add    $0x10,%esp
  801a68:	85 c0                	test   %eax,%eax
  801a6a:	0f 88 23 01 00 00    	js     801b93 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a70:	83 ec 04             	sub    $0x4,%esp
  801a73:	68 07 04 00 00       	push   $0x407
  801a78:	ff 75 f4             	pushl  -0xc(%ebp)
  801a7b:	6a 00                	push   $0x0
  801a7d:	e8 f9 f2 ff ff       	call   800d7b <sys_page_alloc>
  801a82:	89 c3                	mov    %eax,%ebx
  801a84:	83 c4 10             	add    $0x10,%esp
  801a87:	85 c0                	test   %eax,%eax
  801a89:	0f 88 04 01 00 00    	js     801b93 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801a8f:	83 ec 0c             	sub    $0xc,%esp
  801a92:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a95:	50                   	push   %eax
  801a96:	e8 39 f5 ff ff       	call   800fd4 <fd_alloc>
  801a9b:	89 c3                	mov    %eax,%ebx
  801a9d:	83 c4 10             	add    $0x10,%esp
  801aa0:	85 c0                	test   %eax,%eax
  801aa2:	0f 88 db 00 00 00    	js     801b83 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801aa8:	83 ec 04             	sub    $0x4,%esp
  801aab:	68 07 04 00 00       	push   $0x407
  801ab0:	ff 75 f0             	pushl  -0x10(%ebp)
  801ab3:	6a 00                	push   $0x0
  801ab5:	e8 c1 f2 ff ff       	call   800d7b <sys_page_alloc>
  801aba:	89 c3                	mov    %eax,%ebx
  801abc:	83 c4 10             	add    $0x10,%esp
  801abf:	85 c0                	test   %eax,%eax
  801ac1:	0f 88 bc 00 00 00    	js     801b83 <pipe+0x131>
	va = fd2data(fd0);
  801ac7:	83 ec 0c             	sub    $0xc,%esp
  801aca:	ff 75 f4             	pushl  -0xc(%ebp)
  801acd:	e8 eb f4 ff ff       	call   800fbd <fd2data>
  801ad2:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ad4:	83 c4 0c             	add    $0xc,%esp
  801ad7:	68 07 04 00 00       	push   $0x407
  801adc:	50                   	push   %eax
  801add:	6a 00                	push   $0x0
  801adf:	e8 97 f2 ff ff       	call   800d7b <sys_page_alloc>
  801ae4:	89 c3                	mov    %eax,%ebx
  801ae6:	83 c4 10             	add    $0x10,%esp
  801ae9:	85 c0                	test   %eax,%eax
  801aeb:	0f 88 82 00 00 00    	js     801b73 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801af1:	83 ec 0c             	sub    $0xc,%esp
  801af4:	ff 75 f0             	pushl  -0x10(%ebp)
  801af7:	e8 c1 f4 ff ff       	call   800fbd <fd2data>
  801afc:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801b03:	50                   	push   %eax
  801b04:	6a 00                	push   $0x0
  801b06:	56                   	push   %esi
  801b07:	6a 00                	push   $0x0
  801b09:	e8 b0 f2 ff ff       	call   800dbe <sys_page_map>
  801b0e:	89 c3                	mov    %eax,%ebx
  801b10:	83 c4 20             	add    $0x20,%esp
  801b13:	85 c0                	test   %eax,%eax
  801b15:	78 4e                	js     801b65 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801b17:	a1 20 30 80 00       	mov    0x803020,%eax
  801b1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b1f:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801b21:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b24:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801b2b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b2e:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801b30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b33:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801b3a:	83 ec 0c             	sub    $0xc,%esp
  801b3d:	ff 75 f4             	pushl  -0xc(%ebp)
  801b40:	e8 68 f4 ff ff       	call   800fad <fd2num>
  801b45:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b48:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801b4a:	83 c4 04             	add    $0x4,%esp
  801b4d:	ff 75 f0             	pushl  -0x10(%ebp)
  801b50:	e8 58 f4 ff ff       	call   800fad <fd2num>
  801b55:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b58:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801b5b:	83 c4 10             	add    $0x10,%esp
  801b5e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b63:	eb 2e                	jmp    801b93 <pipe+0x141>
	sys_page_unmap(0, va);
  801b65:	83 ec 08             	sub    $0x8,%esp
  801b68:	56                   	push   %esi
  801b69:	6a 00                	push   $0x0
  801b6b:	e8 90 f2 ff ff       	call   800e00 <sys_page_unmap>
  801b70:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801b73:	83 ec 08             	sub    $0x8,%esp
  801b76:	ff 75 f0             	pushl  -0x10(%ebp)
  801b79:	6a 00                	push   $0x0
  801b7b:	e8 80 f2 ff ff       	call   800e00 <sys_page_unmap>
  801b80:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801b83:	83 ec 08             	sub    $0x8,%esp
  801b86:	ff 75 f4             	pushl  -0xc(%ebp)
  801b89:	6a 00                	push   $0x0
  801b8b:	e8 70 f2 ff ff       	call   800e00 <sys_page_unmap>
  801b90:	83 c4 10             	add    $0x10,%esp
}
  801b93:	89 d8                	mov    %ebx,%eax
  801b95:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b98:	5b                   	pop    %ebx
  801b99:	5e                   	pop    %esi
  801b9a:	5d                   	pop    %ebp
  801b9b:	c3                   	ret    

00801b9c <pipeisclosed>:
{
  801b9c:	55                   	push   %ebp
  801b9d:	89 e5                	mov    %esp,%ebp
  801b9f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ba2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ba5:	50                   	push   %eax
  801ba6:	ff 75 08             	pushl  0x8(%ebp)
  801ba9:	e8 78 f4 ff ff       	call   801026 <fd_lookup>
  801bae:	83 c4 10             	add    $0x10,%esp
  801bb1:	85 c0                	test   %eax,%eax
  801bb3:	78 18                	js     801bcd <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801bb5:	83 ec 0c             	sub    $0xc,%esp
  801bb8:	ff 75 f4             	pushl  -0xc(%ebp)
  801bbb:	e8 fd f3 ff ff       	call   800fbd <fd2data>
	return _pipeisclosed(fd, p);
  801bc0:	89 c2                	mov    %eax,%edx
  801bc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bc5:	e8 2f fd ff ff       	call   8018f9 <_pipeisclosed>
  801bca:	83 c4 10             	add    $0x10,%esp
}
  801bcd:	c9                   	leave  
  801bce:	c3                   	ret    

00801bcf <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801bcf:	b8 00 00 00 00       	mov    $0x0,%eax
  801bd4:	c3                   	ret    

00801bd5 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801bd5:	55                   	push   %ebp
  801bd6:	89 e5                	mov    %esp,%ebp
  801bd8:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801bdb:	68 0c 26 80 00       	push   $0x80260c
  801be0:	ff 75 0c             	pushl  0xc(%ebp)
  801be3:	e8 a1 ed ff ff       	call   800989 <strcpy>
	return 0;
}
  801be8:	b8 00 00 00 00       	mov    $0x0,%eax
  801bed:	c9                   	leave  
  801bee:	c3                   	ret    

00801bef <devcons_write>:
{
  801bef:	55                   	push   %ebp
  801bf0:	89 e5                	mov    %esp,%ebp
  801bf2:	57                   	push   %edi
  801bf3:	56                   	push   %esi
  801bf4:	53                   	push   %ebx
  801bf5:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801bfb:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801c00:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801c06:	3b 75 10             	cmp    0x10(%ebp),%esi
  801c09:	73 31                	jae    801c3c <devcons_write+0x4d>
		m = n - tot;
  801c0b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801c0e:	29 f3                	sub    %esi,%ebx
  801c10:	83 fb 7f             	cmp    $0x7f,%ebx
  801c13:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801c18:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801c1b:	83 ec 04             	sub    $0x4,%esp
  801c1e:	53                   	push   %ebx
  801c1f:	89 f0                	mov    %esi,%eax
  801c21:	03 45 0c             	add    0xc(%ebp),%eax
  801c24:	50                   	push   %eax
  801c25:	57                   	push   %edi
  801c26:	e8 ec ee ff ff       	call   800b17 <memmove>
		sys_cputs(buf, m);
  801c2b:	83 c4 08             	add    $0x8,%esp
  801c2e:	53                   	push   %ebx
  801c2f:	57                   	push   %edi
  801c30:	e8 8a f0 ff ff       	call   800cbf <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801c35:	01 de                	add    %ebx,%esi
  801c37:	83 c4 10             	add    $0x10,%esp
  801c3a:	eb ca                	jmp    801c06 <devcons_write+0x17>
}
  801c3c:	89 f0                	mov    %esi,%eax
  801c3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c41:	5b                   	pop    %ebx
  801c42:	5e                   	pop    %esi
  801c43:	5f                   	pop    %edi
  801c44:	5d                   	pop    %ebp
  801c45:	c3                   	ret    

00801c46 <devcons_read>:
{
  801c46:	55                   	push   %ebp
  801c47:	89 e5                	mov    %esp,%ebp
  801c49:	83 ec 08             	sub    $0x8,%esp
  801c4c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801c51:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c55:	74 21                	je     801c78 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  801c57:	e8 81 f0 ff ff       	call   800cdd <sys_cgetc>
  801c5c:	85 c0                	test   %eax,%eax
  801c5e:	75 07                	jne    801c67 <devcons_read+0x21>
		sys_yield();
  801c60:	e8 f7 f0 ff ff       	call   800d5c <sys_yield>
  801c65:	eb f0                	jmp    801c57 <devcons_read+0x11>
	if (c < 0)
  801c67:	78 0f                	js     801c78 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  801c69:	83 f8 04             	cmp    $0x4,%eax
  801c6c:	74 0c                	je     801c7a <devcons_read+0x34>
	*(char*)vbuf = c;
  801c6e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c71:	88 02                	mov    %al,(%edx)
	return 1;
  801c73:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801c78:	c9                   	leave  
  801c79:	c3                   	ret    
		return 0;
  801c7a:	b8 00 00 00 00       	mov    $0x0,%eax
  801c7f:	eb f7                	jmp    801c78 <devcons_read+0x32>

00801c81 <cputchar>:
{
  801c81:	55                   	push   %ebp
  801c82:	89 e5                	mov    %esp,%ebp
  801c84:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801c87:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8a:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801c8d:	6a 01                	push   $0x1
  801c8f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801c92:	50                   	push   %eax
  801c93:	e8 27 f0 ff ff       	call   800cbf <sys_cputs>
}
  801c98:	83 c4 10             	add    $0x10,%esp
  801c9b:	c9                   	leave  
  801c9c:	c3                   	ret    

00801c9d <getchar>:
{
  801c9d:	55                   	push   %ebp
  801c9e:	89 e5                	mov    %esp,%ebp
  801ca0:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801ca3:	6a 01                	push   $0x1
  801ca5:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801ca8:	50                   	push   %eax
  801ca9:	6a 00                	push   $0x0
  801cab:	e8 e1 f5 ff ff       	call   801291 <read>
	if (r < 0)
  801cb0:	83 c4 10             	add    $0x10,%esp
  801cb3:	85 c0                	test   %eax,%eax
  801cb5:	78 06                	js     801cbd <getchar+0x20>
	if (r < 1)
  801cb7:	74 06                	je     801cbf <getchar+0x22>
	return c;
  801cb9:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801cbd:	c9                   	leave  
  801cbe:	c3                   	ret    
		return -E_EOF;
  801cbf:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801cc4:	eb f7                	jmp    801cbd <getchar+0x20>

00801cc6 <iscons>:
{
  801cc6:	55                   	push   %ebp
  801cc7:	89 e5                	mov    %esp,%ebp
  801cc9:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ccc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ccf:	50                   	push   %eax
  801cd0:	ff 75 08             	pushl  0x8(%ebp)
  801cd3:	e8 4e f3 ff ff       	call   801026 <fd_lookup>
  801cd8:	83 c4 10             	add    $0x10,%esp
  801cdb:	85 c0                	test   %eax,%eax
  801cdd:	78 11                	js     801cf0 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801cdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ce2:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801ce8:	39 10                	cmp    %edx,(%eax)
  801cea:	0f 94 c0             	sete   %al
  801ced:	0f b6 c0             	movzbl %al,%eax
}
  801cf0:	c9                   	leave  
  801cf1:	c3                   	ret    

00801cf2 <opencons>:
{
  801cf2:	55                   	push   %ebp
  801cf3:	89 e5                	mov    %esp,%ebp
  801cf5:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801cf8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cfb:	50                   	push   %eax
  801cfc:	e8 d3 f2 ff ff       	call   800fd4 <fd_alloc>
  801d01:	83 c4 10             	add    $0x10,%esp
  801d04:	85 c0                	test   %eax,%eax
  801d06:	78 3a                	js     801d42 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801d08:	83 ec 04             	sub    $0x4,%esp
  801d0b:	68 07 04 00 00       	push   $0x407
  801d10:	ff 75 f4             	pushl  -0xc(%ebp)
  801d13:	6a 00                	push   $0x0
  801d15:	e8 61 f0 ff ff       	call   800d7b <sys_page_alloc>
  801d1a:	83 c4 10             	add    $0x10,%esp
  801d1d:	85 c0                	test   %eax,%eax
  801d1f:	78 21                	js     801d42 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801d21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d24:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801d2a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801d2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d2f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801d36:	83 ec 0c             	sub    $0xc,%esp
  801d39:	50                   	push   %eax
  801d3a:	e8 6e f2 ff ff       	call   800fad <fd2num>
  801d3f:	83 c4 10             	add    $0x10,%esp
}
  801d42:	c9                   	leave  
  801d43:	c3                   	ret    

00801d44 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801d44:	55                   	push   %ebp
  801d45:	89 e5                	mov    %esp,%ebp
  801d47:	56                   	push   %esi
  801d48:	53                   	push   %ebx
  801d49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801d4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d4f:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// return 0;
	if(!pg)
  801d52:	85 c0                	test   %eax,%eax
		pg = (void*)UTOP;
  801d54:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801d59:	0f 44 c2             	cmove  %edx,%eax
	
	int ret;

	ret = sys_ipc_recv(pg);
  801d5c:	83 ec 0c             	sub    $0xc,%esp
  801d5f:	50                   	push   %eax
  801d60:	e8 c6 f1 ff ff       	call   800f2b <sys_ipc_recv>
	if(ret < 0){
  801d65:	83 c4 10             	add    $0x10,%esp
  801d68:	85 c0                	test   %eax,%eax
  801d6a:	78 2b                	js     801d97 <ipc_recv+0x53>
		if(perm_store) *perm_store = 0;
		if(from_env_store) *from_env_store = 0;
		return ret;
	}
	
	if(perm_store)
  801d6c:	85 f6                	test   %esi,%esi
  801d6e:	74 0a                	je     801d7a <ipc_recv+0x36>
		*perm_store = thisenv->env_ipc_perm;
  801d70:	a1 20 60 80 00       	mov    0x806020,%eax
  801d75:	8b 40 78             	mov    0x78(%eax),%eax
  801d78:	89 06                	mov    %eax,(%esi)
	if(from_env_store)
  801d7a:	85 db                	test   %ebx,%ebx
  801d7c:	74 0a                	je     801d88 <ipc_recv+0x44>
		*from_env_store = thisenv->env_ipc_from;
  801d7e:	a1 20 60 80 00       	mov    0x806020,%eax
  801d83:	8b 40 74             	mov    0x74(%eax),%eax
  801d86:	89 03                	mov    %eax,(%ebx)

	return thisenv->env_ipc_value;
  801d88:	a1 20 60 80 00       	mov    0x806020,%eax
  801d8d:	8b 40 70             	mov    0x70(%eax),%eax
}
  801d90:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d93:	5b                   	pop    %ebx
  801d94:	5e                   	pop    %esi
  801d95:	5d                   	pop    %ebp
  801d96:	c3                   	ret    
		if(perm_store) *perm_store = 0;
  801d97:	85 f6                	test   %esi,%esi
  801d99:	74 06                	je     801da1 <ipc_recv+0x5d>
  801d9b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(from_env_store) *from_env_store = 0;
  801da1:	85 db                	test   %ebx,%ebx
  801da3:	74 eb                	je     801d90 <ipc_recv+0x4c>
  801da5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801dab:	eb e3                	jmp    801d90 <ipc_recv+0x4c>

00801dad <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801dad:	55                   	push   %ebp
  801dae:	89 e5                	mov    %esp,%ebp
  801db0:	57                   	push   %edi
  801db1:	56                   	push   %esi
  801db2:	53                   	push   %ebx
  801db3:	83 ec 0c             	sub    $0xc,%esp
  801db6:	8b 7d 08             	mov    0x8(%ebp),%edi
  801db9:	8b 75 0c             	mov    0xc(%ebp),%esi
  801dbc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
	if (!pg)
  801dbf:	85 db                	test   %ebx,%ebx
		pg = (void*)UTOP;
  801dc1:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801dc6:	0f 44 d8             	cmove  %eax,%ebx

	int ret = -E_IPC_NOT_RECV;
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))) {
  801dc9:	ff 75 14             	pushl  0x14(%ebp)
  801dcc:	53                   	push   %ebx
  801dcd:	56                   	push   %esi
  801dce:	57                   	push   %edi
  801dcf:	e8 34 f1 ff ff       	call   800f08 <sys_ipc_try_send>
  801dd4:	83 c4 10             	add    $0x10,%esp
  801dd7:	85 c0                	test   %eax,%eax
  801dd9:	74 17                	je     801df2 <ipc_send+0x45>
		if(ret != -E_IPC_NOT_RECV){
  801ddb:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801dde:	74 e9                	je     801dc9 <ipc_send+0x1c>
			panic("ipc_send: ret : %d", ret);
  801de0:	50                   	push   %eax
  801de1:	68 18 26 80 00       	push   $0x802618
  801de6:	6a 43                	push   $0x43
  801de8:	68 2b 26 80 00       	push   $0x80262b
  801ded:	e8 96 e3 ff ff       	call   800188 <_panic>
			sys_yield();
		}
	}
}
  801df2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801df5:	5b                   	pop    %ebx
  801df6:	5e                   	pop    %esi
  801df7:	5f                   	pop    %edi
  801df8:	5d                   	pop    %ebp
  801df9:	c3                   	ret    

00801dfa <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801dfa:	55                   	push   %ebp
  801dfb:	89 e5                	mov    %esp,%ebp
  801dfd:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801e00:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801e05:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  801e0b:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801e11:	8b 52 50             	mov    0x50(%edx),%edx
  801e14:	39 ca                	cmp    %ecx,%edx
  801e16:	74 11                	je     801e29 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  801e18:	83 c0 01             	add    $0x1,%eax
  801e1b:	3d 00 04 00 00       	cmp    $0x400,%eax
  801e20:	75 e3                	jne    801e05 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801e22:	b8 00 00 00 00       	mov    $0x0,%eax
  801e27:	eb 0e                	jmp    801e37 <ipc_find_env+0x3d>
			return envs[i].env_id;
  801e29:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  801e2f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801e34:	8b 40 48             	mov    0x48(%eax),%eax
}
  801e37:	5d                   	pop    %ebp
  801e38:	c3                   	ret    

00801e39 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801e39:	55                   	push   %ebp
  801e3a:	89 e5                	mov    %esp,%ebp
  801e3c:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801e3f:	89 d0                	mov    %edx,%eax
  801e41:	c1 e8 16             	shr    $0x16,%eax
  801e44:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801e4b:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801e50:	f6 c1 01             	test   $0x1,%cl
  801e53:	74 1d                	je     801e72 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801e55:	c1 ea 0c             	shr    $0xc,%edx
  801e58:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801e5f:	f6 c2 01             	test   $0x1,%dl
  801e62:	74 0e                	je     801e72 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801e64:	c1 ea 0c             	shr    $0xc,%edx
  801e67:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801e6e:	ef 
  801e6f:	0f b7 c0             	movzwl %ax,%eax
}
  801e72:	5d                   	pop    %ebp
  801e73:	c3                   	ret    
  801e74:	66 90                	xchg   %ax,%ax
  801e76:	66 90                	xchg   %ax,%ax
  801e78:	66 90                	xchg   %ax,%ax
  801e7a:	66 90                	xchg   %ax,%ax
  801e7c:	66 90                	xchg   %ax,%ax
  801e7e:	66 90                	xchg   %ax,%ax

00801e80 <__udivdi3>:
  801e80:	55                   	push   %ebp
  801e81:	57                   	push   %edi
  801e82:	56                   	push   %esi
  801e83:	53                   	push   %ebx
  801e84:	83 ec 1c             	sub    $0x1c,%esp
  801e87:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801e8b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801e8f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801e93:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801e97:	85 d2                	test   %edx,%edx
  801e99:	75 4d                	jne    801ee8 <__udivdi3+0x68>
  801e9b:	39 f3                	cmp    %esi,%ebx
  801e9d:	76 19                	jbe    801eb8 <__udivdi3+0x38>
  801e9f:	31 ff                	xor    %edi,%edi
  801ea1:	89 e8                	mov    %ebp,%eax
  801ea3:	89 f2                	mov    %esi,%edx
  801ea5:	f7 f3                	div    %ebx
  801ea7:	89 fa                	mov    %edi,%edx
  801ea9:	83 c4 1c             	add    $0x1c,%esp
  801eac:	5b                   	pop    %ebx
  801ead:	5e                   	pop    %esi
  801eae:	5f                   	pop    %edi
  801eaf:	5d                   	pop    %ebp
  801eb0:	c3                   	ret    
  801eb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801eb8:	89 d9                	mov    %ebx,%ecx
  801eba:	85 db                	test   %ebx,%ebx
  801ebc:	75 0b                	jne    801ec9 <__udivdi3+0x49>
  801ebe:	b8 01 00 00 00       	mov    $0x1,%eax
  801ec3:	31 d2                	xor    %edx,%edx
  801ec5:	f7 f3                	div    %ebx
  801ec7:	89 c1                	mov    %eax,%ecx
  801ec9:	31 d2                	xor    %edx,%edx
  801ecb:	89 f0                	mov    %esi,%eax
  801ecd:	f7 f1                	div    %ecx
  801ecf:	89 c6                	mov    %eax,%esi
  801ed1:	89 e8                	mov    %ebp,%eax
  801ed3:	89 f7                	mov    %esi,%edi
  801ed5:	f7 f1                	div    %ecx
  801ed7:	89 fa                	mov    %edi,%edx
  801ed9:	83 c4 1c             	add    $0x1c,%esp
  801edc:	5b                   	pop    %ebx
  801edd:	5e                   	pop    %esi
  801ede:	5f                   	pop    %edi
  801edf:	5d                   	pop    %ebp
  801ee0:	c3                   	ret    
  801ee1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801ee8:	39 f2                	cmp    %esi,%edx
  801eea:	77 1c                	ja     801f08 <__udivdi3+0x88>
  801eec:	0f bd fa             	bsr    %edx,%edi
  801eef:	83 f7 1f             	xor    $0x1f,%edi
  801ef2:	75 2c                	jne    801f20 <__udivdi3+0xa0>
  801ef4:	39 f2                	cmp    %esi,%edx
  801ef6:	72 06                	jb     801efe <__udivdi3+0x7e>
  801ef8:	31 c0                	xor    %eax,%eax
  801efa:	39 eb                	cmp    %ebp,%ebx
  801efc:	77 a9                	ja     801ea7 <__udivdi3+0x27>
  801efe:	b8 01 00 00 00       	mov    $0x1,%eax
  801f03:	eb a2                	jmp    801ea7 <__udivdi3+0x27>
  801f05:	8d 76 00             	lea    0x0(%esi),%esi
  801f08:	31 ff                	xor    %edi,%edi
  801f0a:	31 c0                	xor    %eax,%eax
  801f0c:	89 fa                	mov    %edi,%edx
  801f0e:	83 c4 1c             	add    $0x1c,%esp
  801f11:	5b                   	pop    %ebx
  801f12:	5e                   	pop    %esi
  801f13:	5f                   	pop    %edi
  801f14:	5d                   	pop    %ebp
  801f15:	c3                   	ret    
  801f16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801f1d:	8d 76 00             	lea    0x0(%esi),%esi
  801f20:	89 f9                	mov    %edi,%ecx
  801f22:	b8 20 00 00 00       	mov    $0x20,%eax
  801f27:	29 f8                	sub    %edi,%eax
  801f29:	d3 e2                	shl    %cl,%edx
  801f2b:	89 54 24 08          	mov    %edx,0x8(%esp)
  801f2f:	89 c1                	mov    %eax,%ecx
  801f31:	89 da                	mov    %ebx,%edx
  801f33:	d3 ea                	shr    %cl,%edx
  801f35:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801f39:	09 d1                	or     %edx,%ecx
  801f3b:	89 f2                	mov    %esi,%edx
  801f3d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801f41:	89 f9                	mov    %edi,%ecx
  801f43:	d3 e3                	shl    %cl,%ebx
  801f45:	89 c1                	mov    %eax,%ecx
  801f47:	d3 ea                	shr    %cl,%edx
  801f49:	89 f9                	mov    %edi,%ecx
  801f4b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801f4f:	89 eb                	mov    %ebp,%ebx
  801f51:	d3 e6                	shl    %cl,%esi
  801f53:	89 c1                	mov    %eax,%ecx
  801f55:	d3 eb                	shr    %cl,%ebx
  801f57:	09 de                	or     %ebx,%esi
  801f59:	89 f0                	mov    %esi,%eax
  801f5b:	f7 74 24 08          	divl   0x8(%esp)
  801f5f:	89 d6                	mov    %edx,%esi
  801f61:	89 c3                	mov    %eax,%ebx
  801f63:	f7 64 24 0c          	mull   0xc(%esp)
  801f67:	39 d6                	cmp    %edx,%esi
  801f69:	72 15                	jb     801f80 <__udivdi3+0x100>
  801f6b:	89 f9                	mov    %edi,%ecx
  801f6d:	d3 e5                	shl    %cl,%ebp
  801f6f:	39 c5                	cmp    %eax,%ebp
  801f71:	73 04                	jae    801f77 <__udivdi3+0xf7>
  801f73:	39 d6                	cmp    %edx,%esi
  801f75:	74 09                	je     801f80 <__udivdi3+0x100>
  801f77:	89 d8                	mov    %ebx,%eax
  801f79:	31 ff                	xor    %edi,%edi
  801f7b:	e9 27 ff ff ff       	jmp    801ea7 <__udivdi3+0x27>
  801f80:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801f83:	31 ff                	xor    %edi,%edi
  801f85:	e9 1d ff ff ff       	jmp    801ea7 <__udivdi3+0x27>
  801f8a:	66 90                	xchg   %ax,%ax
  801f8c:	66 90                	xchg   %ax,%ax
  801f8e:	66 90                	xchg   %ax,%ax

00801f90 <__umoddi3>:
  801f90:	55                   	push   %ebp
  801f91:	57                   	push   %edi
  801f92:	56                   	push   %esi
  801f93:	53                   	push   %ebx
  801f94:	83 ec 1c             	sub    $0x1c,%esp
  801f97:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801f9b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801f9f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801fa3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801fa7:	89 da                	mov    %ebx,%edx
  801fa9:	85 c0                	test   %eax,%eax
  801fab:	75 43                	jne    801ff0 <__umoddi3+0x60>
  801fad:	39 df                	cmp    %ebx,%edi
  801faf:	76 17                	jbe    801fc8 <__umoddi3+0x38>
  801fb1:	89 f0                	mov    %esi,%eax
  801fb3:	f7 f7                	div    %edi
  801fb5:	89 d0                	mov    %edx,%eax
  801fb7:	31 d2                	xor    %edx,%edx
  801fb9:	83 c4 1c             	add    $0x1c,%esp
  801fbc:	5b                   	pop    %ebx
  801fbd:	5e                   	pop    %esi
  801fbe:	5f                   	pop    %edi
  801fbf:	5d                   	pop    %ebp
  801fc0:	c3                   	ret    
  801fc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801fc8:	89 fd                	mov    %edi,%ebp
  801fca:	85 ff                	test   %edi,%edi
  801fcc:	75 0b                	jne    801fd9 <__umoddi3+0x49>
  801fce:	b8 01 00 00 00       	mov    $0x1,%eax
  801fd3:	31 d2                	xor    %edx,%edx
  801fd5:	f7 f7                	div    %edi
  801fd7:	89 c5                	mov    %eax,%ebp
  801fd9:	89 d8                	mov    %ebx,%eax
  801fdb:	31 d2                	xor    %edx,%edx
  801fdd:	f7 f5                	div    %ebp
  801fdf:	89 f0                	mov    %esi,%eax
  801fe1:	f7 f5                	div    %ebp
  801fe3:	89 d0                	mov    %edx,%eax
  801fe5:	eb d0                	jmp    801fb7 <__umoddi3+0x27>
  801fe7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801fee:	66 90                	xchg   %ax,%ax
  801ff0:	89 f1                	mov    %esi,%ecx
  801ff2:	39 d8                	cmp    %ebx,%eax
  801ff4:	76 0a                	jbe    802000 <__umoddi3+0x70>
  801ff6:	89 f0                	mov    %esi,%eax
  801ff8:	83 c4 1c             	add    $0x1c,%esp
  801ffb:	5b                   	pop    %ebx
  801ffc:	5e                   	pop    %esi
  801ffd:	5f                   	pop    %edi
  801ffe:	5d                   	pop    %ebp
  801fff:	c3                   	ret    
  802000:	0f bd e8             	bsr    %eax,%ebp
  802003:	83 f5 1f             	xor    $0x1f,%ebp
  802006:	75 20                	jne    802028 <__umoddi3+0x98>
  802008:	39 d8                	cmp    %ebx,%eax
  80200a:	0f 82 b0 00 00 00    	jb     8020c0 <__umoddi3+0x130>
  802010:	39 f7                	cmp    %esi,%edi
  802012:	0f 86 a8 00 00 00    	jbe    8020c0 <__umoddi3+0x130>
  802018:	89 c8                	mov    %ecx,%eax
  80201a:	83 c4 1c             	add    $0x1c,%esp
  80201d:	5b                   	pop    %ebx
  80201e:	5e                   	pop    %esi
  80201f:	5f                   	pop    %edi
  802020:	5d                   	pop    %ebp
  802021:	c3                   	ret    
  802022:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802028:	89 e9                	mov    %ebp,%ecx
  80202a:	ba 20 00 00 00       	mov    $0x20,%edx
  80202f:	29 ea                	sub    %ebp,%edx
  802031:	d3 e0                	shl    %cl,%eax
  802033:	89 44 24 08          	mov    %eax,0x8(%esp)
  802037:	89 d1                	mov    %edx,%ecx
  802039:	89 f8                	mov    %edi,%eax
  80203b:	d3 e8                	shr    %cl,%eax
  80203d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802041:	89 54 24 04          	mov    %edx,0x4(%esp)
  802045:	8b 54 24 04          	mov    0x4(%esp),%edx
  802049:	09 c1                	or     %eax,%ecx
  80204b:	89 d8                	mov    %ebx,%eax
  80204d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802051:	89 e9                	mov    %ebp,%ecx
  802053:	d3 e7                	shl    %cl,%edi
  802055:	89 d1                	mov    %edx,%ecx
  802057:	d3 e8                	shr    %cl,%eax
  802059:	89 e9                	mov    %ebp,%ecx
  80205b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80205f:	d3 e3                	shl    %cl,%ebx
  802061:	89 c7                	mov    %eax,%edi
  802063:	89 d1                	mov    %edx,%ecx
  802065:	89 f0                	mov    %esi,%eax
  802067:	d3 e8                	shr    %cl,%eax
  802069:	89 e9                	mov    %ebp,%ecx
  80206b:	89 fa                	mov    %edi,%edx
  80206d:	d3 e6                	shl    %cl,%esi
  80206f:	09 d8                	or     %ebx,%eax
  802071:	f7 74 24 08          	divl   0x8(%esp)
  802075:	89 d1                	mov    %edx,%ecx
  802077:	89 f3                	mov    %esi,%ebx
  802079:	f7 64 24 0c          	mull   0xc(%esp)
  80207d:	89 c6                	mov    %eax,%esi
  80207f:	89 d7                	mov    %edx,%edi
  802081:	39 d1                	cmp    %edx,%ecx
  802083:	72 06                	jb     80208b <__umoddi3+0xfb>
  802085:	75 10                	jne    802097 <__umoddi3+0x107>
  802087:	39 c3                	cmp    %eax,%ebx
  802089:	73 0c                	jae    802097 <__umoddi3+0x107>
  80208b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80208f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802093:	89 d7                	mov    %edx,%edi
  802095:	89 c6                	mov    %eax,%esi
  802097:	89 ca                	mov    %ecx,%edx
  802099:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80209e:	29 f3                	sub    %esi,%ebx
  8020a0:	19 fa                	sbb    %edi,%edx
  8020a2:	89 d0                	mov    %edx,%eax
  8020a4:	d3 e0                	shl    %cl,%eax
  8020a6:	89 e9                	mov    %ebp,%ecx
  8020a8:	d3 eb                	shr    %cl,%ebx
  8020aa:	d3 ea                	shr    %cl,%edx
  8020ac:	09 d8                	or     %ebx,%eax
  8020ae:	83 c4 1c             	add    $0x1c,%esp
  8020b1:	5b                   	pop    %ebx
  8020b2:	5e                   	pop    %esi
  8020b3:	5f                   	pop    %edi
  8020b4:	5d                   	pop    %ebp
  8020b5:	c3                   	ret    
  8020b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8020bd:	8d 76 00             	lea    0x0(%esi),%esi
  8020c0:	89 da                	mov    %ebx,%edx
  8020c2:	29 fe                	sub    %edi,%esi
  8020c4:	19 c2                	sbb    %eax,%edx
  8020c6:	89 f1                	mov    %esi,%ecx
  8020c8:	89 c8                	mov    %ecx,%eax
  8020ca:	e9 4b ff ff ff       	jmp    80201a <__umoddi3+0x8a>
