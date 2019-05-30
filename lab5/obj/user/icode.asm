
obj/user/icode.debug:     file format elf32-i386


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
  80002c:	e8 03 01 00 00       	call   800134 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	81 ec 1c 02 00 00    	sub    $0x21c,%esp
	int fd, n, r;
	char buf[512+1];

	binaryname = "icode";
  80003e:	c7 05 00 30 80 00 20 	movl   $0x802520,0x803000
  800045:	25 80 00 

	cprintf("icode startup\n");
  800048:	68 26 25 80 00       	push   $0x802526
  80004d:	e8 18 02 00 00       	call   80026a <cprintf>

	cprintf("icode: open /motd\n");
  800052:	c7 04 24 35 25 80 00 	movl   $0x802535,(%esp)
  800059:	e8 0c 02 00 00       	call   80026a <cprintf>
	if ((fd = open("/motd", O_RDONLY)) < 0)
  80005e:	83 c4 08             	add    $0x8,%esp
  800061:	6a 00                	push   $0x0
  800063:	68 48 25 80 00       	push   $0x802548
  800068:	e8 62 16 00 00       	call   8016cf <open>
  80006d:	89 c6                	mov    %eax,%esi
  80006f:	83 c4 10             	add    $0x10,%esp
  800072:	85 c0                	test   %eax,%eax
  800074:	78 3b                	js     8000b1 <umain+0x7e>
		panic("icode: open /motd: %e", fd);

	cprintf("icode: read /motd\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 71 25 80 00       	push   $0x802571
  80007e:	e8 e7 01 00 00       	call   80026a <cprintf>
	while ((n = read(fd, buf, sizeof buf-1)) > 0)
  800083:	83 c4 10             	add    $0x10,%esp
  800086:	8d 9d f7 fd ff ff    	lea    -0x209(%ebp),%ebx
  80008c:	83 ec 04             	sub    $0x4,%esp
  80008f:	68 00 02 00 00       	push   $0x200
  800094:	53                   	push   %ebx
  800095:	56                   	push   %esi
  800096:	e8 fd 11 00 00       	call   801298 <read>
  80009b:	83 c4 10             	add    $0x10,%esp
  80009e:	85 c0                	test   %eax,%eax
  8000a0:	7e 21                	jle    8000c3 <umain+0x90>
		sys_cputs(buf, n);
  8000a2:	83 ec 08             	sub    $0x8,%esp
  8000a5:	50                   	push   %eax
  8000a6:	53                   	push   %ebx
  8000a7:	e8 1a 0c 00 00       	call   800cc6 <sys_cputs>
  8000ac:	83 c4 10             	add    $0x10,%esp
  8000af:	eb db                	jmp    80008c <umain+0x59>
		panic("icode: open /motd: %e", fd);
  8000b1:	50                   	push   %eax
  8000b2:	68 4e 25 80 00       	push   $0x80254e
  8000b7:	6a 0f                	push   $0xf
  8000b9:	68 64 25 80 00       	push   $0x802564
  8000be:	e8 cc 00 00 00       	call   80018f <_panic>

	cprintf("icode: close /motd\n");
  8000c3:	83 ec 0c             	sub    $0xc,%esp
  8000c6:	68 84 25 80 00       	push   $0x802584
  8000cb:	e8 9a 01 00 00       	call   80026a <cprintf>
	close(fd);
  8000d0:	89 34 24             	mov    %esi,(%esp)
  8000d3:	e8 82 10 00 00       	call   80115a <close>

	cprintf("icode: spawn /init\n");
  8000d8:	c7 04 24 98 25 80 00 	movl   $0x802598,(%esp)
  8000df:	e8 86 01 00 00       	call   80026a <cprintf>
	if ((r = spawnl("/init", "init", "initarg1", "initarg2", (char*)0)) < 0)
  8000e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000eb:	68 ac 25 80 00       	push   $0x8025ac
  8000f0:	68 b5 25 80 00       	push   $0x8025b5
  8000f5:	68 bf 25 80 00       	push   $0x8025bf
  8000fa:	68 be 25 80 00       	push   $0x8025be
  8000ff:	e8 53 1b 00 00       	call   801c57 <spawnl>
  800104:	83 c4 20             	add    $0x20,%esp
  800107:	85 c0                	test   %eax,%eax
  800109:	78 17                	js     800122 <umain+0xef>
		panic("icode: spawn /init: %e", r);

	cprintf("icode: exiting\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 db 25 80 00       	push   $0x8025db
  800113:	e8 52 01 00 00       	call   80026a <cprintf>
}
  800118:	83 c4 10             	add    $0x10,%esp
  80011b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80011e:	5b                   	pop    %ebx
  80011f:	5e                   	pop    %esi
  800120:	5d                   	pop    %ebp
  800121:	c3                   	ret    
		panic("icode: spawn /init: %e", r);
  800122:	50                   	push   %eax
  800123:	68 c4 25 80 00       	push   $0x8025c4
  800128:	6a 1a                	push   $0x1a
  80012a:	68 64 25 80 00       	push   $0x802564
  80012f:	e8 5b 00 00 00       	call   80018f <_panic>

00800134 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800134:	55                   	push   %ebp
  800135:	89 e5                	mov    %esp,%ebp
  800137:	56                   	push   %esi
  800138:	53                   	push   %ebx
  800139:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80013c:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	// thisenv = 0;
	thisenv = &(envs[ENVX(sys_getenvid())]);
  80013f:	e8 00 0c 00 00       	call   800d44 <sys_getenvid>
  800144:	25 ff 03 00 00       	and    $0x3ff,%eax
  800149:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80014f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800154:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800159:	85 db                	test   %ebx,%ebx
  80015b:	7e 07                	jle    800164 <libmain+0x30>
		binaryname = argv[0];
  80015d:	8b 06                	mov    (%esi),%eax
  80015f:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800164:	83 ec 08             	sub    $0x8,%esp
  800167:	56                   	push   %esi
  800168:	53                   	push   %ebx
  800169:	e8 c5 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80016e:	e8 0a 00 00 00       	call   80017d <exit>
}
  800173:	83 c4 10             	add    $0x10,%esp
  800176:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800179:	5b                   	pop    %ebx
  80017a:	5e                   	pop    %esi
  80017b:	5d                   	pop    %ebp
  80017c:	c3                   	ret    

0080017d <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80017d:	55                   	push   %ebp
  80017e:	89 e5                	mov    %esp,%ebp
  800180:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  800183:	6a 00                	push   $0x0
  800185:	e8 79 0b 00 00       	call   800d03 <sys_env_destroy>
}
  80018a:	83 c4 10             	add    $0x10,%esp
  80018d:	c9                   	leave  
  80018e:	c3                   	ret    

0080018f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80018f:	55                   	push   %ebp
  800190:	89 e5                	mov    %esp,%ebp
  800192:	56                   	push   %esi
  800193:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800194:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800197:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80019d:	e8 a2 0b 00 00       	call   800d44 <sys_getenvid>
  8001a2:	83 ec 0c             	sub    $0xc,%esp
  8001a5:	ff 75 0c             	pushl  0xc(%ebp)
  8001a8:	ff 75 08             	pushl  0x8(%ebp)
  8001ab:	56                   	push   %esi
  8001ac:	50                   	push   %eax
  8001ad:	68 f8 25 80 00       	push   $0x8025f8
  8001b2:	e8 b3 00 00 00       	call   80026a <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001b7:	83 c4 18             	add    $0x18,%esp
  8001ba:	53                   	push   %ebx
  8001bb:	ff 75 10             	pushl  0x10(%ebp)
  8001be:	e8 56 00 00 00       	call   800219 <vcprintf>
	cprintf("\n");
  8001c3:	c7 04 24 60 2b 80 00 	movl   $0x802b60,(%esp)
  8001ca:	e8 9b 00 00 00       	call   80026a <cprintf>
  8001cf:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001d2:	cc                   	int3   
  8001d3:	eb fd                	jmp    8001d2 <_panic+0x43>

008001d5 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001d5:	55                   	push   %ebp
  8001d6:	89 e5                	mov    %esp,%ebp
  8001d8:	53                   	push   %ebx
  8001d9:	83 ec 04             	sub    $0x4,%esp
  8001dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001df:	8b 13                	mov    (%ebx),%edx
  8001e1:	8d 42 01             	lea    0x1(%edx),%eax
  8001e4:	89 03                	mov    %eax,(%ebx)
  8001e6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001e9:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001ed:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001f2:	74 09                	je     8001fd <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001f4:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001fb:	c9                   	leave  
  8001fc:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001fd:	83 ec 08             	sub    $0x8,%esp
  800200:	68 ff 00 00 00       	push   $0xff
  800205:	8d 43 08             	lea    0x8(%ebx),%eax
  800208:	50                   	push   %eax
  800209:	e8 b8 0a 00 00       	call   800cc6 <sys_cputs>
		b->idx = 0;
  80020e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800214:	83 c4 10             	add    $0x10,%esp
  800217:	eb db                	jmp    8001f4 <putch+0x1f>

00800219 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800219:	55                   	push   %ebp
  80021a:	89 e5                	mov    %esp,%ebp
  80021c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800222:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800229:	00 00 00 
	b.cnt = 0;
  80022c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800233:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800236:	ff 75 0c             	pushl  0xc(%ebp)
  800239:	ff 75 08             	pushl  0x8(%ebp)
  80023c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800242:	50                   	push   %eax
  800243:	68 d5 01 80 00       	push   $0x8001d5
  800248:	e8 4a 01 00 00       	call   800397 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80024d:	83 c4 08             	add    $0x8,%esp
  800250:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800256:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80025c:	50                   	push   %eax
  80025d:	e8 64 0a 00 00       	call   800cc6 <sys_cputs>

	return b.cnt;
}
  800262:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800268:	c9                   	leave  
  800269:	c3                   	ret    

0080026a <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80026a:	55                   	push   %ebp
  80026b:	89 e5                	mov    %esp,%ebp
  80026d:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800270:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800273:	50                   	push   %eax
  800274:	ff 75 08             	pushl  0x8(%ebp)
  800277:	e8 9d ff ff ff       	call   800219 <vcprintf>
	va_end(ap);

	return cnt;
}
  80027c:	c9                   	leave  
  80027d:	c3                   	ret    

0080027e <printnum>:


static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80027e:	55                   	push   %ebp
  80027f:	89 e5                	mov    %esp,%ebp
  800281:	57                   	push   %edi
  800282:	56                   	push   %esi
  800283:	53                   	push   %ebx
  800284:	83 ec 1c             	sub    $0x1c,%esp
  800287:	89 c6                	mov    %eax,%esi
  800289:	89 d7                	mov    %edx,%edi
  80028b:	8b 45 08             	mov    0x8(%ebp),%eax
  80028e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800291:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800294:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800297:	8b 45 10             	mov    0x10(%ebp),%eax
  80029a:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	// to support '-'
	if(padc == '-'){
  80029d:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8002a1:	74 2c                	je     8002cf <printnum+0x51>
		while (--width > 0)
			putch(' ', putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002a3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002a6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8002ad:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002b0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8002b3:	39 c2                	cmp    %eax,%edx
  8002b5:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8002b8:	73 43                	jae    8002fd <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8002ba:	83 eb 01             	sub    $0x1,%ebx
  8002bd:	85 db                	test   %ebx,%ebx
  8002bf:	7e 6c                	jle    80032d <printnum+0xaf>
			putch(padc, putdat);
  8002c1:	83 ec 08             	sub    $0x8,%esp
  8002c4:	57                   	push   %edi
  8002c5:	ff 75 18             	pushl  0x18(%ebp)
  8002c8:	ff d6                	call   *%esi
  8002ca:	83 c4 10             	add    $0x10,%esp
  8002cd:	eb eb                	jmp    8002ba <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8002cf:	83 ec 0c             	sub    $0xc,%esp
  8002d2:	6a 20                	push   $0x20
  8002d4:	6a 00                	push   $0x0
  8002d6:	50                   	push   %eax
  8002d7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002da:	ff 75 e0             	pushl  -0x20(%ebp)
  8002dd:	89 fa                	mov    %edi,%edx
  8002df:	89 f0                	mov    %esi,%eax
  8002e1:	e8 98 ff ff ff       	call   80027e <printnum>
		while (--width > 0)
  8002e6:	83 c4 20             	add    $0x20,%esp
  8002e9:	83 eb 01             	sub    $0x1,%ebx
  8002ec:	85 db                	test   %ebx,%ebx
  8002ee:	7e 65                	jle    800355 <printnum+0xd7>
			putch(' ', putdat);
  8002f0:	83 ec 08             	sub    $0x8,%esp
  8002f3:	57                   	push   %edi
  8002f4:	6a 20                	push   $0x20
  8002f6:	ff d6                	call   *%esi
  8002f8:	83 c4 10             	add    $0x10,%esp
  8002fb:	eb ec                	jmp    8002e9 <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002fd:	83 ec 0c             	sub    $0xc,%esp
  800300:	ff 75 18             	pushl  0x18(%ebp)
  800303:	83 eb 01             	sub    $0x1,%ebx
  800306:	53                   	push   %ebx
  800307:	50                   	push   %eax
  800308:	83 ec 08             	sub    $0x8,%esp
  80030b:	ff 75 dc             	pushl  -0x24(%ebp)
  80030e:	ff 75 d8             	pushl  -0x28(%ebp)
  800311:	ff 75 e4             	pushl  -0x1c(%ebp)
  800314:	ff 75 e0             	pushl  -0x20(%ebp)
  800317:	e8 b4 1f 00 00       	call   8022d0 <__udivdi3>
  80031c:	83 c4 18             	add    $0x18,%esp
  80031f:	52                   	push   %edx
  800320:	50                   	push   %eax
  800321:	89 fa                	mov    %edi,%edx
  800323:	89 f0                	mov    %esi,%eax
  800325:	e8 54 ff ff ff       	call   80027e <printnum>
  80032a:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80032d:	83 ec 08             	sub    $0x8,%esp
  800330:	57                   	push   %edi
  800331:	83 ec 04             	sub    $0x4,%esp
  800334:	ff 75 dc             	pushl  -0x24(%ebp)
  800337:	ff 75 d8             	pushl  -0x28(%ebp)
  80033a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80033d:	ff 75 e0             	pushl  -0x20(%ebp)
  800340:	e8 9b 20 00 00       	call   8023e0 <__umoddi3>
  800345:	83 c4 14             	add    $0x14,%esp
  800348:	0f be 80 1b 26 80 00 	movsbl 0x80261b(%eax),%eax
  80034f:	50                   	push   %eax
  800350:	ff d6                	call   *%esi
  800352:	83 c4 10             	add    $0x10,%esp
}
  800355:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800358:	5b                   	pop    %ebx
  800359:	5e                   	pop    %esi
  80035a:	5f                   	pop    %edi
  80035b:	5d                   	pop    %ebp
  80035c:	c3                   	ret    

0080035d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80035d:	55                   	push   %ebp
  80035e:	89 e5                	mov    %esp,%ebp
  800360:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800363:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800367:	8b 10                	mov    (%eax),%edx
  800369:	3b 50 04             	cmp    0x4(%eax),%edx
  80036c:	73 0a                	jae    800378 <sprintputch+0x1b>
		*b->buf++ = ch;
  80036e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800371:	89 08                	mov    %ecx,(%eax)
  800373:	8b 45 08             	mov    0x8(%ebp),%eax
  800376:	88 02                	mov    %al,(%edx)
}
  800378:	5d                   	pop    %ebp
  800379:	c3                   	ret    

0080037a <printfmt>:
{
  80037a:	55                   	push   %ebp
  80037b:	89 e5                	mov    %esp,%ebp
  80037d:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800380:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800383:	50                   	push   %eax
  800384:	ff 75 10             	pushl  0x10(%ebp)
  800387:	ff 75 0c             	pushl  0xc(%ebp)
  80038a:	ff 75 08             	pushl  0x8(%ebp)
  80038d:	e8 05 00 00 00       	call   800397 <vprintfmt>
}
  800392:	83 c4 10             	add    $0x10,%esp
  800395:	c9                   	leave  
  800396:	c3                   	ret    

00800397 <vprintfmt>:
{
  800397:	55                   	push   %ebp
  800398:	89 e5                	mov    %esp,%ebp
  80039a:	57                   	push   %edi
  80039b:	56                   	push   %esi
  80039c:	53                   	push   %ebx
  80039d:	83 ec 3c             	sub    $0x3c,%esp
  8003a0:	8b 75 08             	mov    0x8(%ebp),%esi
  8003a3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8003a6:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003a9:	e9 1e 04 00 00       	jmp    8007cc <vprintfmt+0x435>
		posflag = 0;
  8003ae:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
		padc = ' ';
  8003b5:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8003b9:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8003c0:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8003c7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003ce:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  8003d5:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003da:	8d 47 01             	lea    0x1(%edi),%eax
  8003dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003e0:	0f b6 17             	movzbl (%edi),%edx
  8003e3:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003e6:	3c 55                	cmp    $0x55,%al
  8003e8:	0f 87 d9 04 00 00    	ja     8008c7 <vprintfmt+0x530>
  8003ee:	0f b6 c0             	movzbl %al,%eax
  8003f1:	ff 24 85 00 28 80 00 	jmp    *0x802800(,%eax,4)
  8003f8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003fb:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8003ff:	eb d9                	jmp    8003da <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800401:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posflag = 1;
  800404:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  80040b:	eb cd                	jmp    8003da <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80040d:	0f b6 d2             	movzbl %dl,%edx
  800410:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800413:	b8 00 00 00 00       	mov    $0x0,%eax
  800418:	89 75 08             	mov    %esi,0x8(%ebp)
  80041b:	eb 0c                	jmp    800429 <vprintfmt+0x92>
		switch (ch = *(unsigned char *) fmt++) {
  80041d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800420:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  800424:	eb b4                	jmp    8003da <vprintfmt+0x43>
			for (precision = 0; ; ++fmt) {
  800426:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800429:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80042c:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800430:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800433:	8d 72 d0             	lea    -0x30(%edx),%esi
  800436:	83 fe 09             	cmp    $0x9,%esi
  800439:	76 eb                	jbe    800426 <vprintfmt+0x8f>
  80043b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80043e:	8b 75 08             	mov    0x8(%ebp),%esi
  800441:	eb 14                	jmp    800457 <vprintfmt+0xc0>
			precision = va_arg(ap, int);
  800443:	8b 45 14             	mov    0x14(%ebp),%eax
  800446:	8b 00                	mov    (%eax),%eax
  800448:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80044b:	8b 45 14             	mov    0x14(%ebp),%eax
  80044e:	8d 40 04             	lea    0x4(%eax),%eax
  800451:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800454:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800457:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80045b:	0f 89 79 ff ff ff    	jns    8003da <vprintfmt+0x43>
				width = precision, precision = -1;
  800461:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800464:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800467:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80046e:	e9 67 ff ff ff       	jmp    8003da <vprintfmt+0x43>
  800473:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800476:	85 c0                	test   %eax,%eax
  800478:	0f 48 c1             	cmovs  %ecx,%eax
  80047b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80047e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800481:	e9 54 ff ff ff       	jmp    8003da <vprintfmt+0x43>
  800486:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800489:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800490:	e9 45 ff ff ff       	jmp    8003da <vprintfmt+0x43>
			lflag++;
  800495:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800499:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80049c:	e9 39 ff ff ff       	jmp    8003da <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8004a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a4:	8d 78 04             	lea    0x4(%eax),%edi
  8004a7:	83 ec 08             	sub    $0x8,%esp
  8004aa:	53                   	push   %ebx
  8004ab:	ff 30                	pushl  (%eax)
  8004ad:	ff d6                	call   *%esi
			break;
  8004af:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004b2:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8004b5:	e9 0f 03 00 00       	jmp    8007c9 <vprintfmt+0x432>
			err = va_arg(ap, int);
  8004ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8004bd:	8d 78 04             	lea    0x4(%eax),%edi
  8004c0:	8b 00                	mov    (%eax),%eax
  8004c2:	99                   	cltd   
  8004c3:	31 d0                	xor    %edx,%eax
  8004c5:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004c7:	83 f8 0f             	cmp    $0xf,%eax
  8004ca:	7f 23                	jg     8004ef <vprintfmt+0x158>
  8004cc:	8b 14 85 60 29 80 00 	mov    0x802960(,%eax,4),%edx
  8004d3:	85 d2                	test   %edx,%edx
  8004d5:	74 18                	je     8004ef <vprintfmt+0x158>
				printfmt(putch, putdat, "%s", p);
  8004d7:	52                   	push   %edx
  8004d8:	68 9a 2a 80 00       	push   $0x802a9a
  8004dd:	53                   	push   %ebx
  8004de:	56                   	push   %esi
  8004df:	e8 96 fe ff ff       	call   80037a <printfmt>
  8004e4:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004e7:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004ea:	e9 da 02 00 00       	jmp    8007c9 <vprintfmt+0x432>
				printfmt(putch, putdat, "error %d", err);
  8004ef:	50                   	push   %eax
  8004f0:	68 33 26 80 00       	push   $0x802633
  8004f5:	53                   	push   %ebx
  8004f6:	56                   	push   %esi
  8004f7:	e8 7e fe ff ff       	call   80037a <printfmt>
  8004fc:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004ff:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800502:	e9 c2 02 00 00       	jmp    8007c9 <vprintfmt+0x432>
			if ((p = va_arg(ap, char *)) == NULL)
  800507:	8b 45 14             	mov    0x14(%ebp),%eax
  80050a:	83 c0 04             	add    $0x4,%eax
  80050d:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800510:	8b 45 14             	mov    0x14(%ebp),%eax
  800513:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800515:	85 c9                	test   %ecx,%ecx
  800517:	b8 2c 26 80 00       	mov    $0x80262c,%eax
  80051c:	0f 45 c1             	cmovne %ecx,%eax
  80051f:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800522:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800526:	7e 06                	jle    80052e <vprintfmt+0x197>
  800528:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80052c:	75 0d                	jne    80053b <vprintfmt+0x1a4>
				for (width -= strnlen(p, precision); width > 0; width--)
  80052e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800531:	89 c7                	mov    %eax,%edi
  800533:	03 45 e0             	add    -0x20(%ebp),%eax
  800536:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800539:	eb 53                	jmp    80058e <vprintfmt+0x1f7>
  80053b:	83 ec 08             	sub    $0x8,%esp
  80053e:	ff 75 d8             	pushl  -0x28(%ebp)
  800541:	50                   	push   %eax
  800542:	e8 28 04 00 00       	call   80096f <strnlen>
  800547:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80054a:	29 c1                	sub    %eax,%ecx
  80054c:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  80054f:	83 c4 10             	add    $0x10,%esp
  800552:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800554:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800558:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80055b:	eb 0f                	jmp    80056c <vprintfmt+0x1d5>
					putch(padc, putdat);
  80055d:	83 ec 08             	sub    $0x8,%esp
  800560:	53                   	push   %ebx
  800561:	ff 75 e0             	pushl  -0x20(%ebp)
  800564:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800566:	83 ef 01             	sub    $0x1,%edi
  800569:	83 c4 10             	add    $0x10,%esp
  80056c:	85 ff                	test   %edi,%edi
  80056e:	7f ed                	jg     80055d <vprintfmt+0x1c6>
  800570:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  800573:	85 c9                	test   %ecx,%ecx
  800575:	b8 00 00 00 00       	mov    $0x0,%eax
  80057a:	0f 49 c1             	cmovns %ecx,%eax
  80057d:	29 c1                	sub    %eax,%ecx
  80057f:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800582:	eb aa                	jmp    80052e <vprintfmt+0x197>
					putch(ch, putdat);
  800584:	83 ec 08             	sub    $0x8,%esp
  800587:	53                   	push   %ebx
  800588:	52                   	push   %edx
  800589:	ff d6                	call   *%esi
  80058b:	83 c4 10             	add    $0x10,%esp
  80058e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800591:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800593:	83 c7 01             	add    $0x1,%edi
  800596:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80059a:	0f be d0             	movsbl %al,%edx
  80059d:	85 d2                	test   %edx,%edx
  80059f:	74 4b                	je     8005ec <vprintfmt+0x255>
  8005a1:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005a5:	78 06                	js     8005ad <vprintfmt+0x216>
  8005a7:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8005ab:	78 1e                	js     8005cb <vprintfmt+0x234>
				if (altflag && (ch < ' ' || ch > '~'))
  8005ad:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005b1:	74 d1                	je     800584 <vprintfmt+0x1ed>
  8005b3:	0f be c0             	movsbl %al,%eax
  8005b6:	83 e8 20             	sub    $0x20,%eax
  8005b9:	83 f8 5e             	cmp    $0x5e,%eax
  8005bc:	76 c6                	jbe    800584 <vprintfmt+0x1ed>
					putch('?', putdat);
  8005be:	83 ec 08             	sub    $0x8,%esp
  8005c1:	53                   	push   %ebx
  8005c2:	6a 3f                	push   $0x3f
  8005c4:	ff d6                	call   *%esi
  8005c6:	83 c4 10             	add    $0x10,%esp
  8005c9:	eb c3                	jmp    80058e <vprintfmt+0x1f7>
  8005cb:	89 cf                	mov    %ecx,%edi
  8005cd:	eb 0e                	jmp    8005dd <vprintfmt+0x246>
				putch(' ', putdat);
  8005cf:	83 ec 08             	sub    $0x8,%esp
  8005d2:	53                   	push   %ebx
  8005d3:	6a 20                	push   $0x20
  8005d5:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005d7:	83 ef 01             	sub    $0x1,%edi
  8005da:	83 c4 10             	add    $0x10,%esp
  8005dd:	85 ff                	test   %edi,%edi
  8005df:	7f ee                	jg     8005cf <vprintfmt+0x238>
			if ((p = va_arg(ap, char *)) == NULL)
  8005e1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8005e4:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e7:	e9 dd 01 00 00       	jmp    8007c9 <vprintfmt+0x432>
  8005ec:	89 cf                	mov    %ecx,%edi
  8005ee:	eb ed                	jmp    8005dd <vprintfmt+0x246>
	if (lflag >= 2)
  8005f0:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8005f4:	7f 21                	jg     800617 <vprintfmt+0x280>
	else if (lflag)
  8005f6:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8005fa:	74 6a                	je     800666 <vprintfmt+0x2cf>
		return va_arg(*ap, long);
  8005fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ff:	8b 00                	mov    (%eax),%eax
  800601:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800604:	89 c1                	mov    %eax,%ecx
  800606:	c1 f9 1f             	sar    $0x1f,%ecx
  800609:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80060c:	8b 45 14             	mov    0x14(%ebp),%eax
  80060f:	8d 40 04             	lea    0x4(%eax),%eax
  800612:	89 45 14             	mov    %eax,0x14(%ebp)
  800615:	eb 17                	jmp    80062e <vprintfmt+0x297>
		return va_arg(*ap, long long);
  800617:	8b 45 14             	mov    0x14(%ebp),%eax
  80061a:	8b 50 04             	mov    0x4(%eax),%edx
  80061d:	8b 00                	mov    (%eax),%eax
  80061f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800622:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800625:	8b 45 14             	mov    0x14(%ebp),%eax
  800628:	8d 40 08             	lea    0x8(%eax),%eax
  80062b:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80062e:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  800631:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800636:	85 d2                	test   %edx,%edx
  800638:	0f 89 5c 01 00 00    	jns    80079a <vprintfmt+0x403>
				putch('-', putdat);
  80063e:	83 ec 08             	sub    $0x8,%esp
  800641:	53                   	push   %ebx
  800642:	6a 2d                	push   $0x2d
  800644:	ff d6                	call   *%esi
				num = -(long long) num;
  800646:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800649:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80064c:	f7 d8                	neg    %eax
  80064e:	83 d2 00             	adc    $0x0,%edx
  800651:	f7 da                	neg    %edx
  800653:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800656:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800659:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80065c:	bf 0a 00 00 00       	mov    $0xa,%edi
  800661:	e9 45 01 00 00       	jmp    8007ab <vprintfmt+0x414>
		return va_arg(*ap, int);
  800666:	8b 45 14             	mov    0x14(%ebp),%eax
  800669:	8b 00                	mov    (%eax),%eax
  80066b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80066e:	89 c1                	mov    %eax,%ecx
  800670:	c1 f9 1f             	sar    $0x1f,%ecx
  800673:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800676:	8b 45 14             	mov    0x14(%ebp),%eax
  800679:	8d 40 04             	lea    0x4(%eax),%eax
  80067c:	89 45 14             	mov    %eax,0x14(%ebp)
  80067f:	eb ad                	jmp    80062e <vprintfmt+0x297>
	if (lflag >= 2)
  800681:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800685:	7f 29                	jg     8006b0 <vprintfmt+0x319>
	else if (lflag)
  800687:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80068b:	74 44                	je     8006d1 <vprintfmt+0x33a>
		return va_arg(*ap, unsigned long);
  80068d:	8b 45 14             	mov    0x14(%ebp),%eax
  800690:	8b 00                	mov    (%eax),%eax
  800692:	ba 00 00 00 00       	mov    $0x0,%edx
  800697:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80069a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80069d:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a0:	8d 40 04             	lea    0x4(%eax),%eax
  8006a3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006a6:	bf 0a 00 00 00       	mov    $0xa,%edi
  8006ab:	e9 ea 00 00 00       	jmp    80079a <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  8006b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b3:	8b 50 04             	mov    0x4(%eax),%edx
  8006b6:	8b 00                	mov    (%eax),%eax
  8006b8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006bb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006be:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c1:	8d 40 08             	lea    0x8(%eax),%eax
  8006c4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006c7:	bf 0a 00 00 00       	mov    $0xa,%edi
  8006cc:	e9 c9 00 00 00       	jmp    80079a <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  8006d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d4:	8b 00                	mov    (%eax),%eax
  8006d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8006db:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006de:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e4:	8d 40 04             	lea    0x4(%eax),%eax
  8006e7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006ea:	bf 0a 00 00 00       	mov    $0xa,%edi
  8006ef:	e9 a6 00 00 00       	jmp    80079a <vprintfmt+0x403>
			putch('0', putdat);
  8006f4:	83 ec 08             	sub    $0x8,%esp
  8006f7:	53                   	push   %ebx
  8006f8:	6a 30                	push   $0x30
  8006fa:	ff d6                	call   *%esi
	if (lflag >= 2)
  8006fc:	83 c4 10             	add    $0x10,%esp
  8006ff:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800703:	7f 26                	jg     80072b <vprintfmt+0x394>
	else if (lflag)
  800705:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800709:	74 3e                	je     800749 <vprintfmt+0x3b2>
		return va_arg(*ap, unsigned long);
  80070b:	8b 45 14             	mov    0x14(%ebp),%eax
  80070e:	8b 00                	mov    (%eax),%eax
  800710:	ba 00 00 00 00       	mov    $0x0,%edx
  800715:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800718:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80071b:	8b 45 14             	mov    0x14(%ebp),%eax
  80071e:	8d 40 04             	lea    0x4(%eax),%eax
  800721:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800724:	bf 08 00 00 00       	mov    $0x8,%edi
  800729:	eb 6f                	jmp    80079a <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  80072b:	8b 45 14             	mov    0x14(%ebp),%eax
  80072e:	8b 50 04             	mov    0x4(%eax),%edx
  800731:	8b 00                	mov    (%eax),%eax
  800733:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800736:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800739:	8b 45 14             	mov    0x14(%ebp),%eax
  80073c:	8d 40 08             	lea    0x8(%eax),%eax
  80073f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800742:	bf 08 00 00 00       	mov    $0x8,%edi
  800747:	eb 51                	jmp    80079a <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  800749:	8b 45 14             	mov    0x14(%ebp),%eax
  80074c:	8b 00                	mov    (%eax),%eax
  80074e:	ba 00 00 00 00       	mov    $0x0,%edx
  800753:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800756:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800759:	8b 45 14             	mov    0x14(%ebp),%eax
  80075c:	8d 40 04             	lea    0x4(%eax),%eax
  80075f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800762:	bf 08 00 00 00       	mov    $0x8,%edi
  800767:	eb 31                	jmp    80079a <vprintfmt+0x403>
			putch('0', putdat);
  800769:	83 ec 08             	sub    $0x8,%esp
  80076c:	53                   	push   %ebx
  80076d:	6a 30                	push   $0x30
  80076f:	ff d6                	call   *%esi
			putch('x', putdat);
  800771:	83 c4 08             	add    $0x8,%esp
  800774:	53                   	push   %ebx
  800775:	6a 78                	push   $0x78
  800777:	ff d6                	call   *%esi
			num = (unsigned long long)
  800779:	8b 45 14             	mov    0x14(%ebp),%eax
  80077c:	8b 00                	mov    (%eax),%eax
  80077e:	ba 00 00 00 00       	mov    $0x0,%edx
  800783:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800786:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800789:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80078c:	8b 45 14             	mov    0x14(%ebp),%eax
  80078f:	8d 40 04             	lea    0x4(%eax),%eax
  800792:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800795:	bf 10 00 00 00       	mov    $0x10,%edi
			if(posflag)
  80079a:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80079e:	74 0b                	je     8007ab <vprintfmt+0x414>
				putch('+', putdat);
  8007a0:	83 ec 08             	sub    $0x8,%esp
  8007a3:	53                   	push   %ebx
  8007a4:	6a 2b                	push   $0x2b
  8007a6:	ff d6                	call   *%esi
  8007a8:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  8007ab:	83 ec 0c             	sub    $0xc,%esp
  8007ae:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8007b2:	50                   	push   %eax
  8007b3:	ff 75 e0             	pushl  -0x20(%ebp)
  8007b6:	57                   	push   %edi
  8007b7:	ff 75 dc             	pushl  -0x24(%ebp)
  8007ba:	ff 75 d8             	pushl  -0x28(%ebp)
  8007bd:	89 da                	mov    %ebx,%edx
  8007bf:	89 f0                	mov    %esi,%eax
  8007c1:	e8 b8 fa ff ff       	call   80027e <printnum>
			break;
  8007c6:	83 c4 20             	add    $0x20,%esp
			char* cp = va_arg(ap, char *);
  8007c9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007cc:	83 c7 01             	add    $0x1,%edi
  8007cf:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007d3:	83 f8 25             	cmp    $0x25,%eax
  8007d6:	0f 84 d2 fb ff ff    	je     8003ae <vprintfmt+0x17>
			if (ch == '\0')
  8007dc:	85 c0                	test   %eax,%eax
  8007de:	0f 84 03 01 00 00    	je     8008e7 <vprintfmt+0x550>
			putch(ch, putdat);
  8007e4:	83 ec 08             	sub    $0x8,%esp
  8007e7:	53                   	push   %ebx
  8007e8:	50                   	push   %eax
  8007e9:	ff d6                	call   *%esi
  8007eb:	83 c4 10             	add    $0x10,%esp
  8007ee:	eb dc                	jmp    8007cc <vprintfmt+0x435>
	if (lflag >= 2)
  8007f0:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8007f4:	7f 29                	jg     80081f <vprintfmt+0x488>
	else if (lflag)
  8007f6:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8007fa:	74 44                	je     800840 <vprintfmt+0x4a9>
		return va_arg(*ap, unsigned long);
  8007fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ff:	8b 00                	mov    (%eax),%eax
  800801:	ba 00 00 00 00       	mov    $0x0,%edx
  800806:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800809:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80080c:	8b 45 14             	mov    0x14(%ebp),%eax
  80080f:	8d 40 04             	lea    0x4(%eax),%eax
  800812:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800815:	bf 10 00 00 00       	mov    $0x10,%edi
  80081a:	e9 7b ff ff ff       	jmp    80079a <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  80081f:	8b 45 14             	mov    0x14(%ebp),%eax
  800822:	8b 50 04             	mov    0x4(%eax),%edx
  800825:	8b 00                	mov    (%eax),%eax
  800827:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80082a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80082d:	8b 45 14             	mov    0x14(%ebp),%eax
  800830:	8d 40 08             	lea    0x8(%eax),%eax
  800833:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800836:	bf 10 00 00 00       	mov    $0x10,%edi
  80083b:	e9 5a ff ff ff       	jmp    80079a <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  800840:	8b 45 14             	mov    0x14(%ebp),%eax
  800843:	8b 00                	mov    (%eax),%eax
  800845:	ba 00 00 00 00       	mov    $0x0,%edx
  80084a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80084d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800850:	8b 45 14             	mov    0x14(%ebp),%eax
  800853:	8d 40 04             	lea    0x4(%eax),%eax
  800856:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800859:	bf 10 00 00 00       	mov    $0x10,%edi
  80085e:	e9 37 ff ff ff       	jmp    80079a <vprintfmt+0x403>
			char* cp = va_arg(ap, char *);
  800863:	8b 45 14             	mov    0x14(%ebp),%eax
  800866:	8d 78 04             	lea    0x4(%eax),%edi
  800869:	8b 00                	mov    (%eax),%eax
    			if (cp == NULL) {
  80086b:	85 c0                	test   %eax,%eax
  80086d:	74 2c                	je     80089b <vprintfmt+0x504>
    			*cp = *(int *)putdat;
  80086f:	8b 13                	mov    (%ebx),%edx
  800871:	88 10                	mov    %dl,(%eax)
			char* cp = va_arg(ap, char *);
  800873:	89 7d 14             	mov    %edi,0x14(%ebp)
    			if ((*(int *) putdat) > 127)
  800876:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  800879:	0f 8e 4a ff ff ff    	jle    8007c9 <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", overflow_error);
  80087f:	68 88 27 80 00       	push   $0x802788
  800884:	68 9a 2a 80 00       	push   $0x802a9a
  800889:	53                   	push   %ebx
  80088a:	56                   	push   %esi
  80088b:	e8 ea fa ff ff       	call   80037a <printfmt>
  800890:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  800893:	89 7d 14             	mov    %edi,0x14(%ebp)
  800896:	e9 2e ff ff ff       	jmp    8007c9 <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", null_error);
  80089b:	68 50 27 80 00       	push   $0x802750
  8008a0:	68 9a 2a 80 00       	push   $0x802a9a
  8008a5:	53                   	push   %ebx
  8008a6:	56                   	push   %esi
  8008a7:	e8 ce fa ff ff       	call   80037a <printfmt>
        		break;
  8008ac:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  8008af:	89 7d 14             	mov    %edi,0x14(%ebp)
        		break;
  8008b2:	e9 12 ff ff ff       	jmp    8007c9 <vprintfmt+0x432>
			putch(ch, putdat);
  8008b7:	83 ec 08             	sub    $0x8,%esp
  8008ba:	53                   	push   %ebx
  8008bb:	6a 25                	push   $0x25
  8008bd:	ff d6                	call   *%esi
			break;
  8008bf:	83 c4 10             	add    $0x10,%esp
  8008c2:	e9 02 ff ff ff       	jmp    8007c9 <vprintfmt+0x432>
			putch('%', putdat);
  8008c7:	83 ec 08             	sub    $0x8,%esp
  8008ca:	53                   	push   %ebx
  8008cb:	6a 25                	push   $0x25
  8008cd:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008cf:	83 c4 10             	add    $0x10,%esp
  8008d2:	89 f8                	mov    %edi,%eax
  8008d4:	eb 03                	jmp    8008d9 <vprintfmt+0x542>
  8008d6:	83 e8 01             	sub    $0x1,%eax
  8008d9:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8008dd:	75 f7                	jne    8008d6 <vprintfmt+0x53f>
  8008df:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008e2:	e9 e2 fe ff ff       	jmp    8007c9 <vprintfmt+0x432>
}
  8008e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008ea:	5b                   	pop    %ebx
  8008eb:	5e                   	pop    %esi
  8008ec:	5f                   	pop    %edi
  8008ed:	5d                   	pop    %ebp
  8008ee:	c3                   	ret    

008008ef <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008ef:	55                   	push   %ebp
  8008f0:	89 e5                	mov    %esp,%ebp
  8008f2:	83 ec 18             	sub    $0x18,%esp
  8008f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f8:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008fe:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800902:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800905:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80090c:	85 c0                	test   %eax,%eax
  80090e:	74 26                	je     800936 <vsnprintf+0x47>
  800910:	85 d2                	test   %edx,%edx
  800912:	7e 22                	jle    800936 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800914:	ff 75 14             	pushl  0x14(%ebp)
  800917:	ff 75 10             	pushl  0x10(%ebp)
  80091a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80091d:	50                   	push   %eax
  80091e:	68 5d 03 80 00       	push   $0x80035d
  800923:	e8 6f fa ff ff       	call   800397 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800928:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80092b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80092e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800931:	83 c4 10             	add    $0x10,%esp
}
  800934:	c9                   	leave  
  800935:	c3                   	ret    
		return -E_INVAL;
  800936:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80093b:	eb f7                	jmp    800934 <vsnprintf+0x45>

0080093d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80093d:	55                   	push   %ebp
  80093e:	89 e5                	mov    %esp,%ebp
  800940:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800943:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800946:	50                   	push   %eax
  800947:	ff 75 10             	pushl  0x10(%ebp)
  80094a:	ff 75 0c             	pushl  0xc(%ebp)
  80094d:	ff 75 08             	pushl  0x8(%ebp)
  800950:	e8 9a ff ff ff       	call   8008ef <vsnprintf>
	va_end(ap);

	return rc;
}
  800955:	c9                   	leave  
  800956:	c3                   	ret    

00800957 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800957:	55                   	push   %ebp
  800958:	89 e5                	mov    %esp,%ebp
  80095a:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80095d:	b8 00 00 00 00       	mov    $0x0,%eax
  800962:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800966:	74 05                	je     80096d <strlen+0x16>
		n++;
  800968:	83 c0 01             	add    $0x1,%eax
  80096b:	eb f5                	jmp    800962 <strlen+0xb>
	return n;
}
  80096d:	5d                   	pop    %ebp
  80096e:	c3                   	ret    

0080096f <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80096f:	55                   	push   %ebp
  800970:	89 e5                	mov    %esp,%ebp
  800972:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800975:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800978:	ba 00 00 00 00       	mov    $0x0,%edx
  80097d:	39 c2                	cmp    %eax,%edx
  80097f:	74 0d                	je     80098e <strnlen+0x1f>
  800981:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800985:	74 05                	je     80098c <strnlen+0x1d>
		n++;
  800987:	83 c2 01             	add    $0x1,%edx
  80098a:	eb f1                	jmp    80097d <strnlen+0xe>
  80098c:	89 d0                	mov    %edx,%eax
	return n;
}
  80098e:	5d                   	pop    %ebp
  80098f:	c3                   	ret    

00800990 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800990:	55                   	push   %ebp
  800991:	89 e5                	mov    %esp,%ebp
  800993:	53                   	push   %ebx
  800994:	8b 45 08             	mov    0x8(%ebp),%eax
  800997:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80099a:	ba 00 00 00 00       	mov    $0x0,%edx
  80099f:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8009a3:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8009a6:	83 c2 01             	add    $0x1,%edx
  8009a9:	84 c9                	test   %cl,%cl
  8009ab:	75 f2                	jne    80099f <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8009ad:	5b                   	pop    %ebx
  8009ae:	5d                   	pop    %ebp
  8009af:	c3                   	ret    

008009b0 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009b0:	55                   	push   %ebp
  8009b1:	89 e5                	mov    %esp,%ebp
  8009b3:	53                   	push   %ebx
  8009b4:	83 ec 10             	sub    $0x10,%esp
  8009b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009ba:	53                   	push   %ebx
  8009bb:	e8 97 ff ff ff       	call   800957 <strlen>
  8009c0:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8009c3:	ff 75 0c             	pushl  0xc(%ebp)
  8009c6:	01 d8                	add    %ebx,%eax
  8009c8:	50                   	push   %eax
  8009c9:	e8 c2 ff ff ff       	call   800990 <strcpy>
	return dst;
}
  8009ce:	89 d8                	mov    %ebx,%eax
  8009d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009d3:	c9                   	leave  
  8009d4:	c3                   	ret    

008009d5 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009d5:	55                   	push   %ebp
  8009d6:	89 e5                	mov    %esp,%ebp
  8009d8:	56                   	push   %esi
  8009d9:	53                   	push   %ebx
  8009da:	8b 45 08             	mov    0x8(%ebp),%eax
  8009dd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009e0:	89 c6                	mov    %eax,%esi
  8009e2:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009e5:	89 c2                	mov    %eax,%edx
  8009e7:	39 f2                	cmp    %esi,%edx
  8009e9:	74 11                	je     8009fc <strncpy+0x27>
		*dst++ = *src;
  8009eb:	83 c2 01             	add    $0x1,%edx
  8009ee:	0f b6 19             	movzbl (%ecx),%ebx
  8009f1:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009f4:	80 fb 01             	cmp    $0x1,%bl
  8009f7:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8009fa:	eb eb                	jmp    8009e7 <strncpy+0x12>
	}
	return ret;
}
  8009fc:	5b                   	pop    %ebx
  8009fd:	5e                   	pop    %esi
  8009fe:	5d                   	pop    %ebp
  8009ff:	c3                   	ret    

00800a00 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a00:	55                   	push   %ebp
  800a01:	89 e5                	mov    %esp,%ebp
  800a03:	56                   	push   %esi
  800a04:	53                   	push   %ebx
  800a05:	8b 75 08             	mov    0x8(%ebp),%esi
  800a08:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a0b:	8b 55 10             	mov    0x10(%ebp),%edx
  800a0e:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a10:	85 d2                	test   %edx,%edx
  800a12:	74 21                	je     800a35 <strlcpy+0x35>
  800a14:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a18:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800a1a:	39 c2                	cmp    %eax,%edx
  800a1c:	74 14                	je     800a32 <strlcpy+0x32>
  800a1e:	0f b6 19             	movzbl (%ecx),%ebx
  800a21:	84 db                	test   %bl,%bl
  800a23:	74 0b                	je     800a30 <strlcpy+0x30>
			*dst++ = *src++;
  800a25:	83 c1 01             	add    $0x1,%ecx
  800a28:	83 c2 01             	add    $0x1,%edx
  800a2b:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a2e:	eb ea                	jmp    800a1a <strlcpy+0x1a>
  800a30:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a32:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a35:	29 f0                	sub    %esi,%eax
}
  800a37:	5b                   	pop    %ebx
  800a38:	5e                   	pop    %esi
  800a39:	5d                   	pop    %ebp
  800a3a:	c3                   	ret    

00800a3b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a3b:	55                   	push   %ebp
  800a3c:	89 e5                	mov    %esp,%ebp
  800a3e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a41:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a44:	0f b6 01             	movzbl (%ecx),%eax
  800a47:	84 c0                	test   %al,%al
  800a49:	74 0c                	je     800a57 <strcmp+0x1c>
  800a4b:	3a 02                	cmp    (%edx),%al
  800a4d:	75 08                	jne    800a57 <strcmp+0x1c>
		p++, q++;
  800a4f:	83 c1 01             	add    $0x1,%ecx
  800a52:	83 c2 01             	add    $0x1,%edx
  800a55:	eb ed                	jmp    800a44 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a57:	0f b6 c0             	movzbl %al,%eax
  800a5a:	0f b6 12             	movzbl (%edx),%edx
  800a5d:	29 d0                	sub    %edx,%eax
}
  800a5f:	5d                   	pop    %ebp
  800a60:	c3                   	ret    

00800a61 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a61:	55                   	push   %ebp
  800a62:	89 e5                	mov    %esp,%ebp
  800a64:	53                   	push   %ebx
  800a65:	8b 45 08             	mov    0x8(%ebp),%eax
  800a68:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a6b:	89 c3                	mov    %eax,%ebx
  800a6d:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a70:	eb 06                	jmp    800a78 <strncmp+0x17>
		n--, p++, q++;
  800a72:	83 c0 01             	add    $0x1,%eax
  800a75:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a78:	39 d8                	cmp    %ebx,%eax
  800a7a:	74 16                	je     800a92 <strncmp+0x31>
  800a7c:	0f b6 08             	movzbl (%eax),%ecx
  800a7f:	84 c9                	test   %cl,%cl
  800a81:	74 04                	je     800a87 <strncmp+0x26>
  800a83:	3a 0a                	cmp    (%edx),%cl
  800a85:	74 eb                	je     800a72 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a87:	0f b6 00             	movzbl (%eax),%eax
  800a8a:	0f b6 12             	movzbl (%edx),%edx
  800a8d:	29 d0                	sub    %edx,%eax
}
  800a8f:	5b                   	pop    %ebx
  800a90:	5d                   	pop    %ebp
  800a91:	c3                   	ret    
		return 0;
  800a92:	b8 00 00 00 00       	mov    $0x0,%eax
  800a97:	eb f6                	jmp    800a8f <strncmp+0x2e>

00800a99 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a99:	55                   	push   %ebp
  800a9a:	89 e5                	mov    %esp,%ebp
  800a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800aa3:	0f b6 10             	movzbl (%eax),%edx
  800aa6:	84 d2                	test   %dl,%dl
  800aa8:	74 09                	je     800ab3 <strchr+0x1a>
		if (*s == c)
  800aaa:	38 ca                	cmp    %cl,%dl
  800aac:	74 0a                	je     800ab8 <strchr+0x1f>
	for (; *s; s++)
  800aae:	83 c0 01             	add    $0x1,%eax
  800ab1:	eb f0                	jmp    800aa3 <strchr+0xa>
			return (char *) s;
	return 0;
  800ab3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ab8:	5d                   	pop    %ebp
  800ab9:	c3                   	ret    

00800aba <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800aba:	55                   	push   %ebp
  800abb:	89 e5                	mov    %esp,%ebp
  800abd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ac4:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800ac7:	38 ca                	cmp    %cl,%dl
  800ac9:	74 09                	je     800ad4 <strfind+0x1a>
  800acb:	84 d2                	test   %dl,%dl
  800acd:	74 05                	je     800ad4 <strfind+0x1a>
	for (; *s; s++)
  800acf:	83 c0 01             	add    $0x1,%eax
  800ad2:	eb f0                	jmp    800ac4 <strfind+0xa>
			break;
	return (char *) s;
}
  800ad4:	5d                   	pop    %ebp
  800ad5:	c3                   	ret    

00800ad6 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ad6:	55                   	push   %ebp
  800ad7:	89 e5                	mov    %esp,%ebp
  800ad9:	57                   	push   %edi
  800ada:	56                   	push   %esi
  800adb:	53                   	push   %ebx
  800adc:	8b 7d 08             	mov    0x8(%ebp),%edi
  800adf:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ae2:	85 c9                	test   %ecx,%ecx
  800ae4:	74 31                	je     800b17 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ae6:	89 f8                	mov    %edi,%eax
  800ae8:	09 c8                	or     %ecx,%eax
  800aea:	a8 03                	test   $0x3,%al
  800aec:	75 23                	jne    800b11 <memset+0x3b>
		c &= 0xFF;
  800aee:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800af2:	89 d3                	mov    %edx,%ebx
  800af4:	c1 e3 08             	shl    $0x8,%ebx
  800af7:	89 d0                	mov    %edx,%eax
  800af9:	c1 e0 18             	shl    $0x18,%eax
  800afc:	89 d6                	mov    %edx,%esi
  800afe:	c1 e6 10             	shl    $0x10,%esi
  800b01:	09 f0                	or     %esi,%eax
  800b03:	09 c2                	or     %eax,%edx
  800b05:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b07:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b0a:	89 d0                	mov    %edx,%eax
  800b0c:	fc                   	cld    
  800b0d:	f3 ab                	rep stos %eax,%es:(%edi)
  800b0f:	eb 06                	jmp    800b17 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b14:	fc                   	cld    
  800b15:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b17:	89 f8                	mov    %edi,%eax
  800b19:	5b                   	pop    %ebx
  800b1a:	5e                   	pop    %esi
  800b1b:	5f                   	pop    %edi
  800b1c:	5d                   	pop    %ebp
  800b1d:	c3                   	ret    

00800b1e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b1e:	55                   	push   %ebp
  800b1f:	89 e5                	mov    %esp,%ebp
  800b21:	57                   	push   %edi
  800b22:	56                   	push   %esi
  800b23:	8b 45 08             	mov    0x8(%ebp),%eax
  800b26:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b29:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b2c:	39 c6                	cmp    %eax,%esi
  800b2e:	73 32                	jae    800b62 <memmove+0x44>
  800b30:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b33:	39 c2                	cmp    %eax,%edx
  800b35:	76 2b                	jbe    800b62 <memmove+0x44>
		s += n;
		d += n;
  800b37:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b3a:	89 fe                	mov    %edi,%esi
  800b3c:	09 ce                	or     %ecx,%esi
  800b3e:	09 d6                	or     %edx,%esi
  800b40:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b46:	75 0e                	jne    800b56 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b48:	83 ef 04             	sub    $0x4,%edi
  800b4b:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b4e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b51:	fd                   	std    
  800b52:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b54:	eb 09                	jmp    800b5f <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b56:	83 ef 01             	sub    $0x1,%edi
  800b59:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b5c:	fd                   	std    
  800b5d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b5f:	fc                   	cld    
  800b60:	eb 1a                	jmp    800b7c <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b62:	89 c2                	mov    %eax,%edx
  800b64:	09 ca                	or     %ecx,%edx
  800b66:	09 f2                	or     %esi,%edx
  800b68:	f6 c2 03             	test   $0x3,%dl
  800b6b:	75 0a                	jne    800b77 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b6d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b70:	89 c7                	mov    %eax,%edi
  800b72:	fc                   	cld    
  800b73:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b75:	eb 05                	jmp    800b7c <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b77:	89 c7                	mov    %eax,%edi
  800b79:	fc                   	cld    
  800b7a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b7c:	5e                   	pop    %esi
  800b7d:	5f                   	pop    %edi
  800b7e:	5d                   	pop    %ebp
  800b7f:	c3                   	ret    

00800b80 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b80:	55                   	push   %ebp
  800b81:	89 e5                	mov    %esp,%ebp
  800b83:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b86:	ff 75 10             	pushl  0x10(%ebp)
  800b89:	ff 75 0c             	pushl  0xc(%ebp)
  800b8c:	ff 75 08             	pushl  0x8(%ebp)
  800b8f:	e8 8a ff ff ff       	call   800b1e <memmove>
}
  800b94:	c9                   	leave  
  800b95:	c3                   	ret    

00800b96 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b96:	55                   	push   %ebp
  800b97:	89 e5                	mov    %esp,%ebp
  800b99:	56                   	push   %esi
  800b9a:	53                   	push   %ebx
  800b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ba1:	89 c6                	mov    %eax,%esi
  800ba3:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ba6:	39 f0                	cmp    %esi,%eax
  800ba8:	74 1c                	je     800bc6 <memcmp+0x30>
		if (*s1 != *s2)
  800baa:	0f b6 08             	movzbl (%eax),%ecx
  800bad:	0f b6 1a             	movzbl (%edx),%ebx
  800bb0:	38 d9                	cmp    %bl,%cl
  800bb2:	75 08                	jne    800bbc <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800bb4:	83 c0 01             	add    $0x1,%eax
  800bb7:	83 c2 01             	add    $0x1,%edx
  800bba:	eb ea                	jmp    800ba6 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800bbc:	0f b6 c1             	movzbl %cl,%eax
  800bbf:	0f b6 db             	movzbl %bl,%ebx
  800bc2:	29 d8                	sub    %ebx,%eax
  800bc4:	eb 05                	jmp    800bcb <memcmp+0x35>
	}

	return 0;
  800bc6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bcb:	5b                   	pop    %ebx
  800bcc:	5e                   	pop    %esi
  800bcd:	5d                   	pop    %ebp
  800bce:	c3                   	ret    

00800bcf <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800bcf:	55                   	push   %ebp
  800bd0:	89 e5                	mov    %esp,%ebp
  800bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800bd8:	89 c2                	mov    %eax,%edx
  800bda:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bdd:	39 d0                	cmp    %edx,%eax
  800bdf:	73 09                	jae    800bea <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800be1:	38 08                	cmp    %cl,(%eax)
  800be3:	74 05                	je     800bea <memfind+0x1b>
	for (; s < ends; s++)
  800be5:	83 c0 01             	add    $0x1,%eax
  800be8:	eb f3                	jmp    800bdd <memfind+0xe>
			break;
	return (void *) s;
}
  800bea:	5d                   	pop    %ebp
  800beb:	c3                   	ret    

00800bec <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bec:	55                   	push   %ebp
  800bed:	89 e5                	mov    %esp,%ebp
  800bef:	57                   	push   %edi
  800bf0:	56                   	push   %esi
  800bf1:	53                   	push   %ebx
  800bf2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bf5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bf8:	eb 03                	jmp    800bfd <strtol+0x11>
		s++;
  800bfa:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800bfd:	0f b6 01             	movzbl (%ecx),%eax
  800c00:	3c 20                	cmp    $0x20,%al
  800c02:	74 f6                	je     800bfa <strtol+0xe>
  800c04:	3c 09                	cmp    $0x9,%al
  800c06:	74 f2                	je     800bfa <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c08:	3c 2b                	cmp    $0x2b,%al
  800c0a:	74 2a                	je     800c36 <strtol+0x4a>
	int neg = 0;
  800c0c:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c11:	3c 2d                	cmp    $0x2d,%al
  800c13:	74 2b                	je     800c40 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c15:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c1b:	75 0f                	jne    800c2c <strtol+0x40>
  800c1d:	80 39 30             	cmpb   $0x30,(%ecx)
  800c20:	74 28                	je     800c4a <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c22:	85 db                	test   %ebx,%ebx
  800c24:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c29:	0f 44 d8             	cmove  %eax,%ebx
  800c2c:	b8 00 00 00 00       	mov    $0x0,%eax
  800c31:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c34:	eb 50                	jmp    800c86 <strtol+0x9a>
		s++;
  800c36:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c39:	bf 00 00 00 00       	mov    $0x0,%edi
  800c3e:	eb d5                	jmp    800c15 <strtol+0x29>
		s++, neg = 1;
  800c40:	83 c1 01             	add    $0x1,%ecx
  800c43:	bf 01 00 00 00       	mov    $0x1,%edi
  800c48:	eb cb                	jmp    800c15 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c4a:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c4e:	74 0e                	je     800c5e <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c50:	85 db                	test   %ebx,%ebx
  800c52:	75 d8                	jne    800c2c <strtol+0x40>
		s++, base = 8;
  800c54:	83 c1 01             	add    $0x1,%ecx
  800c57:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c5c:	eb ce                	jmp    800c2c <strtol+0x40>
		s += 2, base = 16;
  800c5e:	83 c1 02             	add    $0x2,%ecx
  800c61:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c66:	eb c4                	jmp    800c2c <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c68:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c6b:	89 f3                	mov    %esi,%ebx
  800c6d:	80 fb 19             	cmp    $0x19,%bl
  800c70:	77 29                	ja     800c9b <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c72:	0f be d2             	movsbl %dl,%edx
  800c75:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c78:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c7b:	7d 30                	jge    800cad <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c7d:	83 c1 01             	add    $0x1,%ecx
  800c80:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c84:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c86:	0f b6 11             	movzbl (%ecx),%edx
  800c89:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c8c:	89 f3                	mov    %esi,%ebx
  800c8e:	80 fb 09             	cmp    $0x9,%bl
  800c91:	77 d5                	ja     800c68 <strtol+0x7c>
			dig = *s - '0';
  800c93:	0f be d2             	movsbl %dl,%edx
  800c96:	83 ea 30             	sub    $0x30,%edx
  800c99:	eb dd                	jmp    800c78 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c9b:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c9e:	89 f3                	mov    %esi,%ebx
  800ca0:	80 fb 19             	cmp    $0x19,%bl
  800ca3:	77 08                	ja     800cad <strtol+0xc1>
			dig = *s - 'A' + 10;
  800ca5:	0f be d2             	movsbl %dl,%edx
  800ca8:	83 ea 37             	sub    $0x37,%edx
  800cab:	eb cb                	jmp    800c78 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800cad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cb1:	74 05                	je     800cb8 <strtol+0xcc>
		*endptr = (char *) s;
  800cb3:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cb6:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800cb8:	89 c2                	mov    %eax,%edx
  800cba:	f7 da                	neg    %edx
  800cbc:	85 ff                	test   %edi,%edi
  800cbe:	0f 45 c2             	cmovne %edx,%eax
}
  800cc1:	5b                   	pop    %ebx
  800cc2:	5e                   	pop    %esi
  800cc3:	5f                   	pop    %edi
  800cc4:	5d                   	pop    %ebp
  800cc5:	c3                   	ret    

00800cc6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800cc6:	55                   	push   %ebp
  800cc7:	89 e5                	mov    %esp,%ebp
  800cc9:	57                   	push   %edi
  800cca:	56                   	push   %esi
  800ccb:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ccc:	b8 00 00 00 00       	mov    $0x0,%eax
  800cd1:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd7:	89 c3                	mov    %eax,%ebx
  800cd9:	89 c7                	mov    %eax,%edi
  800cdb:	89 c6                	mov    %eax,%esi
  800cdd:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cdf:	5b                   	pop    %ebx
  800ce0:	5e                   	pop    %esi
  800ce1:	5f                   	pop    %edi
  800ce2:	5d                   	pop    %ebp
  800ce3:	c3                   	ret    

00800ce4 <sys_cgetc>:

int
sys_cgetc(void)
{
  800ce4:	55                   	push   %ebp
  800ce5:	89 e5                	mov    %esp,%ebp
  800ce7:	57                   	push   %edi
  800ce8:	56                   	push   %esi
  800ce9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cea:	ba 00 00 00 00       	mov    $0x0,%edx
  800cef:	b8 01 00 00 00       	mov    $0x1,%eax
  800cf4:	89 d1                	mov    %edx,%ecx
  800cf6:	89 d3                	mov    %edx,%ebx
  800cf8:	89 d7                	mov    %edx,%edi
  800cfa:	89 d6                	mov    %edx,%esi
  800cfc:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cfe:	5b                   	pop    %ebx
  800cff:	5e                   	pop    %esi
  800d00:	5f                   	pop    %edi
  800d01:	5d                   	pop    %ebp
  800d02:	c3                   	ret    

00800d03 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d03:	55                   	push   %ebp
  800d04:	89 e5                	mov    %esp,%ebp
  800d06:	57                   	push   %edi
  800d07:	56                   	push   %esi
  800d08:	53                   	push   %ebx
  800d09:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d0c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d11:	8b 55 08             	mov    0x8(%ebp),%edx
  800d14:	b8 03 00 00 00       	mov    $0x3,%eax
  800d19:	89 cb                	mov    %ecx,%ebx
  800d1b:	89 cf                	mov    %ecx,%edi
  800d1d:	89 ce                	mov    %ecx,%esi
  800d1f:	cd 30                	int    $0x30
	if (check && ret > 0)
  800d21:	85 c0                	test   %eax,%eax
  800d23:	7f 08                	jg     800d2d <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d25:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d28:	5b                   	pop    %ebx
  800d29:	5e                   	pop    %esi
  800d2a:	5f                   	pop    %edi
  800d2b:	5d                   	pop    %ebp
  800d2c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d2d:	83 ec 0c             	sub    $0xc,%esp
  800d30:	50                   	push   %eax
  800d31:	6a 03                	push   $0x3
  800d33:	68 a0 29 80 00       	push   $0x8029a0
  800d38:	6a 4c                	push   $0x4c
  800d3a:	68 bd 29 80 00       	push   $0x8029bd
  800d3f:	e8 4b f4 ff ff       	call   80018f <_panic>

00800d44 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d44:	55                   	push   %ebp
  800d45:	89 e5                	mov    %esp,%ebp
  800d47:	57                   	push   %edi
  800d48:	56                   	push   %esi
  800d49:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d4a:	ba 00 00 00 00       	mov    $0x0,%edx
  800d4f:	b8 02 00 00 00       	mov    $0x2,%eax
  800d54:	89 d1                	mov    %edx,%ecx
  800d56:	89 d3                	mov    %edx,%ebx
  800d58:	89 d7                	mov    %edx,%edi
  800d5a:	89 d6                	mov    %edx,%esi
  800d5c:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d5e:	5b                   	pop    %ebx
  800d5f:	5e                   	pop    %esi
  800d60:	5f                   	pop    %edi
  800d61:	5d                   	pop    %ebp
  800d62:	c3                   	ret    

00800d63 <sys_yield>:

void
sys_yield(void)
{
  800d63:	55                   	push   %ebp
  800d64:	89 e5                	mov    %esp,%ebp
  800d66:	57                   	push   %edi
  800d67:	56                   	push   %esi
  800d68:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d69:	ba 00 00 00 00       	mov    $0x0,%edx
  800d6e:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d73:	89 d1                	mov    %edx,%ecx
  800d75:	89 d3                	mov    %edx,%ebx
  800d77:	89 d7                	mov    %edx,%edi
  800d79:	89 d6                	mov    %edx,%esi
  800d7b:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d7d:	5b                   	pop    %ebx
  800d7e:	5e                   	pop    %esi
  800d7f:	5f                   	pop    %edi
  800d80:	5d                   	pop    %ebp
  800d81:	c3                   	ret    

00800d82 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d82:	55                   	push   %ebp
  800d83:	89 e5                	mov    %esp,%ebp
  800d85:	57                   	push   %edi
  800d86:	56                   	push   %esi
  800d87:	53                   	push   %ebx
  800d88:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d8b:	be 00 00 00 00       	mov    $0x0,%esi
  800d90:	8b 55 08             	mov    0x8(%ebp),%edx
  800d93:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d96:	b8 04 00 00 00       	mov    $0x4,%eax
  800d9b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d9e:	89 f7                	mov    %esi,%edi
  800da0:	cd 30                	int    $0x30
	if (check && ret > 0)
  800da2:	85 c0                	test   %eax,%eax
  800da4:	7f 08                	jg     800dae <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800da6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800da9:	5b                   	pop    %ebx
  800daa:	5e                   	pop    %esi
  800dab:	5f                   	pop    %edi
  800dac:	5d                   	pop    %ebp
  800dad:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dae:	83 ec 0c             	sub    $0xc,%esp
  800db1:	50                   	push   %eax
  800db2:	6a 04                	push   $0x4
  800db4:	68 a0 29 80 00       	push   $0x8029a0
  800db9:	6a 4c                	push   $0x4c
  800dbb:	68 bd 29 80 00       	push   $0x8029bd
  800dc0:	e8 ca f3 ff ff       	call   80018f <_panic>

00800dc5 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800dc5:	55                   	push   %ebp
  800dc6:	89 e5                	mov    %esp,%ebp
  800dc8:	57                   	push   %edi
  800dc9:	56                   	push   %esi
  800dca:	53                   	push   %ebx
  800dcb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dce:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd4:	b8 05 00 00 00       	mov    $0x5,%eax
  800dd9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ddc:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ddf:	8b 75 18             	mov    0x18(%ebp),%esi
  800de2:	cd 30                	int    $0x30
	if (check && ret > 0)
  800de4:	85 c0                	test   %eax,%eax
  800de6:	7f 08                	jg     800df0 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800de8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800deb:	5b                   	pop    %ebx
  800dec:	5e                   	pop    %esi
  800ded:	5f                   	pop    %edi
  800dee:	5d                   	pop    %ebp
  800def:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800df0:	83 ec 0c             	sub    $0xc,%esp
  800df3:	50                   	push   %eax
  800df4:	6a 05                	push   $0x5
  800df6:	68 a0 29 80 00       	push   $0x8029a0
  800dfb:	6a 4c                	push   $0x4c
  800dfd:	68 bd 29 80 00       	push   $0x8029bd
  800e02:	e8 88 f3 ff ff       	call   80018f <_panic>

00800e07 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e07:	55                   	push   %ebp
  800e08:	89 e5                	mov    %esp,%ebp
  800e0a:	57                   	push   %edi
  800e0b:	56                   	push   %esi
  800e0c:	53                   	push   %ebx
  800e0d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e10:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e15:	8b 55 08             	mov    0x8(%ebp),%edx
  800e18:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e1b:	b8 06 00 00 00       	mov    $0x6,%eax
  800e20:	89 df                	mov    %ebx,%edi
  800e22:	89 de                	mov    %ebx,%esi
  800e24:	cd 30                	int    $0x30
	if (check && ret > 0)
  800e26:	85 c0                	test   %eax,%eax
  800e28:	7f 08                	jg     800e32 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e2d:	5b                   	pop    %ebx
  800e2e:	5e                   	pop    %esi
  800e2f:	5f                   	pop    %edi
  800e30:	5d                   	pop    %ebp
  800e31:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e32:	83 ec 0c             	sub    $0xc,%esp
  800e35:	50                   	push   %eax
  800e36:	6a 06                	push   $0x6
  800e38:	68 a0 29 80 00       	push   $0x8029a0
  800e3d:	6a 4c                	push   $0x4c
  800e3f:	68 bd 29 80 00       	push   $0x8029bd
  800e44:	e8 46 f3 ff ff       	call   80018f <_panic>

00800e49 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e49:	55                   	push   %ebp
  800e4a:	89 e5                	mov    %esp,%ebp
  800e4c:	57                   	push   %edi
  800e4d:	56                   	push   %esi
  800e4e:	53                   	push   %ebx
  800e4f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e52:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e57:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e5d:	b8 08 00 00 00       	mov    $0x8,%eax
  800e62:	89 df                	mov    %ebx,%edi
  800e64:	89 de                	mov    %ebx,%esi
  800e66:	cd 30                	int    $0x30
	if (check && ret > 0)
  800e68:	85 c0                	test   %eax,%eax
  800e6a:	7f 08                	jg     800e74 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e6f:	5b                   	pop    %ebx
  800e70:	5e                   	pop    %esi
  800e71:	5f                   	pop    %edi
  800e72:	5d                   	pop    %ebp
  800e73:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e74:	83 ec 0c             	sub    $0xc,%esp
  800e77:	50                   	push   %eax
  800e78:	6a 08                	push   $0x8
  800e7a:	68 a0 29 80 00       	push   $0x8029a0
  800e7f:	6a 4c                	push   $0x4c
  800e81:	68 bd 29 80 00       	push   $0x8029bd
  800e86:	e8 04 f3 ff ff       	call   80018f <_panic>

00800e8b <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e8b:	55                   	push   %ebp
  800e8c:	89 e5                	mov    %esp,%ebp
  800e8e:	57                   	push   %edi
  800e8f:	56                   	push   %esi
  800e90:	53                   	push   %ebx
  800e91:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e94:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e99:	8b 55 08             	mov    0x8(%ebp),%edx
  800e9c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e9f:	b8 09 00 00 00       	mov    $0x9,%eax
  800ea4:	89 df                	mov    %ebx,%edi
  800ea6:	89 de                	mov    %ebx,%esi
  800ea8:	cd 30                	int    $0x30
	if (check && ret > 0)
  800eaa:	85 c0                	test   %eax,%eax
  800eac:	7f 08                	jg     800eb6 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800eae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eb1:	5b                   	pop    %ebx
  800eb2:	5e                   	pop    %esi
  800eb3:	5f                   	pop    %edi
  800eb4:	5d                   	pop    %ebp
  800eb5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb6:	83 ec 0c             	sub    $0xc,%esp
  800eb9:	50                   	push   %eax
  800eba:	6a 09                	push   $0x9
  800ebc:	68 a0 29 80 00       	push   $0x8029a0
  800ec1:	6a 4c                	push   $0x4c
  800ec3:	68 bd 29 80 00       	push   $0x8029bd
  800ec8:	e8 c2 f2 ff ff       	call   80018f <_panic>

00800ecd <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ecd:	55                   	push   %ebp
  800ece:	89 e5                	mov    %esp,%ebp
  800ed0:	57                   	push   %edi
  800ed1:	56                   	push   %esi
  800ed2:	53                   	push   %ebx
  800ed3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ed6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800edb:	8b 55 08             	mov    0x8(%ebp),%edx
  800ede:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee1:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ee6:	89 df                	mov    %ebx,%edi
  800ee8:	89 de                	mov    %ebx,%esi
  800eea:	cd 30                	int    $0x30
	if (check && ret > 0)
  800eec:	85 c0                	test   %eax,%eax
  800eee:	7f 08                	jg     800ef8 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ef0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ef3:	5b                   	pop    %ebx
  800ef4:	5e                   	pop    %esi
  800ef5:	5f                   	pop    %edi
  800ef6:	5d                   	pop    %ebp
  800ef7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ef8:	83 ec 0c             	sub    $0xc,%esp
  800efb:	50                   	push   %eax
  800efc:	6a 0a                	push   $0xa
  800efe:	68 a0 29 80 00       	push   $0x8029a0
  800f03:	6a 4c                	push   $0x4c
  800f05:	68 bd 29 80 00       	push   $0x8029bd
  800f0a:	e8 80 f2 ff ff       	call   80018f <_panic>

00800f0f <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f0f:	55                   	push   %ebp
  800f10:	89 e5                	mov    %esp,%ebp
  800f12:	57                   	push   %edi
  800f13:	56                   	push   %esi
  800f14:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f15:	8b 55 08             	mov    0x8(%ebp),%edx
  800f18:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f1b:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f20:	be 00 00 00 00       	mov    $0x0,%esi
  800f25:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f28:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f2b:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f2d:	5b                   	pop    %ebx
  800f2e:	5e                   	pop    %esi
  800f2f:	5f                   	pop    %edi
  800f30:	5d                   	pop    %ebp
  800f31:	c3                   	ret    

00800f32 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f32:	55                   	push   %ebp
  800f33:	89 e5                	mov    %esp,%ebp
  800f35:	57                   	push   %edi
  800f36:	56                   	push   %esi
  800f37:	53                   	push   %ebx
  800f38:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f3b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f40:	8b 55 08             	mov    0x8(%ebp),%edx
  800f43:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f48:	89 cb                	mov    %ecx,%ebx
  800f4a:	89 cf                	mov    %ecx,%edi
  800f4c:	89 ce                	mov    %ecx,%esi
  800f4e:	cd 30                	int    $0x30
	if (check && ret > 0)
  800f50:	85 c0                	test   %eax,%eax
  800f52:	7f 08                	jg     800f5c <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f54:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f57:	5b                   	pop    %ebx
  800f58:	5e                   	pop    %esi
  800f59:	5f                   	pop    %edi
  800f5a:	5d                   	pop    %ebp
  800f5b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f5c:	83 ec 0c             	sub    $0xc,%esp
  800f5f:	50                   	push   %eax
  800f60:	6a 0d                	push   $0xd
  800f62:	68 a0 29 80 00       	push   $0x8029a0
  800f67:	6a 4c                	push   $0x4c
  800f69:	68 bd 29 80 00       	push   $0x8029bd
  800f6e:	e8 1c f2 ff ff       	call   80018f <_panic>

00800f73 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f73:	55                   	push   %ebp
  800f74:	89 e5                	mov    %esp,%ebp
  800f76:	57                   	push   %edi
  800f77:	56                   	push   %esi
  800f78:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f79:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f7e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f81:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f84:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f89:	89 df                	mov    %ebx,%edi
  800f8b:	89 de                	mov    %ebx,%esi
  800f8d:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f8f:	5b                   	pop    %ebx
  800f90:	5e                   	pop    %esi
  800f91:	5f                   	pop    %edi
  800f92:	5d                   	pop    %ebp
  800f93:	c3                   	ret    

00800f94 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f94:	55                   	push   %ebp
  800f95:	89 e5                	mov    %esp,%ebp
  800f97:	57                   	push   %edi
  800f98:	56                   	push   %esi
  800f99:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f9a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f9f:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa2:	b8 0f 00 00 00       	mov    $0xf,%eax
  800fa7:	89 cb                	mov    %ecx,%ebx
  800fa9:	89 cf                	mov    %ecx,%edi
  800fab:	89 ce                	mov    %ecx,%esi
  800fad:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800faf:	5b                   	pop    %ebx
  800fb0:	5e                   	pop    %esi
  800fb1:	5f                   	pop    %edi
  800fb2:	5d                   	pop    %ebp
  800fb3:	c3                   	ret    

00800fb4 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800fb4:	55                   	push   %ebp
  800fb5:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fba:	05 00 00 00 30       	add    $0x30000000,%eax
  800fbf:	c1 e8 0c             	shr    $0xc,%eax
}
  800fc2:	5d                   	pop    %ebp
  800fc3:	c3                   	ret    

00800fc4 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800fc4:	55                   	push   %ebp
  800fc5:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fca:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800fcf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800fd4:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800fd9:	5d                   	pop    %ebp
  800fda:	c3                   	ret    

00800fdb <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800fdb:	55                   	push   %ebp
  800fdc:	89 e5                	mov    %esp,%ebp
  800fde:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800fe3:	89 c2                	mov    %eax,%edx
  800fe5:	c1 ea 16             	shr    $0x16,%edx
  800fe8:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800fef:	f6 c2 01             	test   $0x1,%dl
  800ff2:	74 2d                	je     801021 <fd_alloc+0x46>
  800ff4:	89 c2                	mov    %eax,%edx
  800ff6:	c1 ea 0c             	shr    $0xc,%edx
  800ff9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801000:	f6 c2 01             	test   $0x1,%dl
  801003:	74 1c                	je     801021 <fd_alloc+0x46>
  801005:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80100a:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80100f:	75 d2                	jne    800fe3 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801011:	8b 45 08             	mov    0x8(%ebp),%eax
  801014:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80101a:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80101f:	eb 0a                	jmp    80102b <fd_alloc+0x50>
			*fd_store = fd;
  801021:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801024:	89 01                	mov    %eax,(%ecx)
			return 0;
  801026:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80102b:	5d                   	pop    %ebp
  80102c:	c3                   	ret    

0080102d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80102d:	55                   	push   %ebp
  80102e:	89 e5                	mov    %esp,%ebp
  801030:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801033:	83 f8 1f             	cmp    $0x1f,%eax
  801036:	77 30                	ja     801068 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801038:	c1 e0 0c             	shl    $0xc,%eax
  80103b:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801040:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801046:	f6 c2 01             	test   $0x1,%dl
  801049:	74 24                	je     80106f <fd_lookup+0x42>
  80104b:	89 c2                	mov    %eax,%edx
  80104d:	c1 ea 0c             	shr    $0xc,%edx
  801050:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801057:	f6 c2 01             	test   $0x1,%dl
  80105a:	74 1a                	je     801076 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80105c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80105f:	89 02                	mov    %eax,(%edx)
	return 0;
  801061:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801066:	5d                   	pop    %ebp
  801067:	c3                   	ret    
		return -E_INVAL;
  801068:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80106d:	eb f7                	jmp    801066 <fd_lookup+0x39>
		return -E_INVAL;
  80106f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801074:	eb f0                	jmp    801066 <fd_lookup+0x39>
  801076:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80107b:	eb e9                	jmp    801066 <fd_lookup+0x39>

0080107d <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80107d:	55                   	push   %ebp
  80107e:	89 e5                	mov    %esp,%ebp
  801080:	83 ec 08             	sub    $0x8,%esp
  801083:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801086:	ba 48 2a 80 00       	mov    $0x802a48,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  80108b:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801090:	39 08                	cmp    %ecx,(%eax)
  801092:	74 33                	je     8010c7 <dev_lookup+0x4a>
  801094:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801097:	8b 02                	mov    (%edx),%eax
  801099:	85 c0                	test   %eax,%eax
  80109b:	75 f3                	jne    801090 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80109d:	a1 04 40 80 00       	mov    0x804004,%eax
  8010a2:	8b 40 48             	mov    0x48(%eax),%eax
  8010a5:	83 ec 04             	sub    $0x4,%esp
  8010a8:	51                   	push   %ecx
  8010a9:	50                   	push   %eax
  8010aa:	68 cc 29 80 00       	push   $0x8029cc
  8010af:	e8 b6 f1 ff ff       	call   80026a <cprintf>
	*dev = 0;
  8010b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8010bd:	83 c4 10             	add    $0x10,%esp
  8010c0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8010c5:	c9                   	leave  
  8010c6:	c3                   	ret    
			*dev = devtab[i];
  8010c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010ca:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8010d1:	eb f2                	jmp    8010c5 <dev_lookup+0x48>

008010d3 <fd_close>:
{
  8010d3:	55                   	push   %ebp
  8010d4:	89 e5                	mov    %esp,%ebp
  8010d6:	57                   	push   %edi
  8010d7:	56                   	push   %esi
  8010d8:	53                   	push   %ebx
  8010d9:	83 ec 24             	sub    $0x24,%esp
  8010dc:	8b 75 08             	mov    0x8(%ebp),%esi
  8010df:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010e2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8010e5:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010e6:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8010ec:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010ef:	50                   	push   %eax
  8010f0:	e8 38 ff ff ff       	call   80102d <fd_lookup>
  8010f5:	89 c3                	mov    %eax,%ebx
  8010f7:	83 c4 10             	add    $0x10,%esp
  8010fa:	85 c0                	test   %eax,%eax
  8010fc:	78 05                	js     801103 <fd_close+0x30>
	    || fd != fd2)
  8010fe:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801101:	74 16                	je     801119 <fd_close+0x46>
		return (must_exist ? r : 0);
  801103:	89 f8                	mov    %edi,%eax
  801105:	84 c0                	test   %al,%al
  801107:	b8 00 00 00 00       	mov    $0x0,%eax
  80110c:	0f 44 d8             	cmove  %eax,%ebx
}
  80110f:	89 d8                	mov    %ebx,%eax
  801111:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801114:	5b                   	pop    %ebx
  801115:	5e                   	pop    %esi
  801116:	5f                   	pop    %edi
  801117:	5d                   	pop    %ebp
  801118:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801119:	83 ec 08             	sub    $0x8,%esp
  80111c:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80111f:	50                   	push   %eax
  801120:	ff 36                	pushl  (%esi)
  801122:	e8 56 ff ff ff       	call   80107d <dev_lookup>
  801127:	89 c3                	mov    %eax,%ebx
  801129:	83 c4 10             	add    $0x10,%esp
  80112c:	85 c0                	test   %eax,%eax
  80112e:	78 1a                	js     80114a <fd_close+0x77>
		if (dev->dev_close)
  801130:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801133:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801136:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80113b:	85 c0                	test   %eax,%eax
  80113d:	74 0b                	je     80114a <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80113f:	83 ec 0c             	sub    $0xc,%esp
  801142:	56                   	push   %esi
  801143:	ff d0                	call   *%eax
  801145:	89 c3                	mov    %eax,%ebx
  801147:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80114a:	83 ec 08             	sub    $0x8,%esp
  80114d:	56                   	push   %esi
  80114e:	6a 00                	push   $0x0
  801150:	e8 b2 fc ff ff       	call   800e07 <sys_page_unmap>
	return r;
  801155:	83 c4 10             	add    $0x10,%esp
  801158:	eb b5                	jmp    80110f <fd_close+0x3c>

0080115a <close>:

int
close(int fdnum)
{
  80115a:	55                   	push   %ebp
  80115b:	89 e5                	mov    %esp,%ebp
  80115d:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801160:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801163:	50                   	push   %eax
  801164:	ff 75 08             	pushl  0x8(%ebp)
  801167:	e8 c1 fe ff ff       	call   80102d <fd_lookup>
  80116c:	83 c4 10             	add    $0x10,%esp
  80116f:	85 c0                	test   %eax,%eax
  801171:	79 02                	jns    801175 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801173:	c9                   	leave  
  801174:	c3                   	ret    
		return fd_close(fd, 1);
  801175:	83 ec 08             	sub    $0x8,%esp
  801178:	6a 01                	push   $0x1
  80117a:	ff 75 f4             	pushl  -0xc(%ebp)
  80117d:	e8 51 ff ff ff       	call   8010d3 <fd_close>
  801182:	83 c4 10             	add    $0x10,%esp
  801185:	eb ec                	jmp    801173 <close+0x19>

00801187 <close_all>:

void
close_all(void)
{
  801187:	55                   	push   %ebp
  801188:	89 e5                	mov    %esp,%ebp
  80118a:	53                   	push   %ebx
  80118b:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80118e:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801193:	83 ec 0c             	sub    $0xc,%esp
  801196:	53                   	push   %ebx
  801197:	e8 be ff ff ff       	call   80115a <close>
	for (i = 0; i < MAXFD; i++)
  80119c:	83 c3 01             	add    $0x1,%ebx
  80119f:	83 c4 10             	add    $0x10,%esp
  8011a2:	83 fb 20             	cmp    $0x20,%ebx
  8011a5:	75 ec                	jne    801193 <close_all+0xc>
}
  8011a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011aa:	c9                   	leave  
  8011ab:	c3                   	ret    

008011ac <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8011ac:	55                   	push   %ebp
  8011ad:	89 e5                	mov    %esp,%ebp
  8011af:	57                   	push   %edi
  8011b0:	56                   	push   %esi
  8011b1:	53                   	push   %ebx
  8011b2:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8011b5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011b8:	50                   	push   %eax
  8011b9:	ff 75 08             	pushl  0x8(%ebp)
  8011bc:	e8 6c fe ff ff       	call   80102d <fd_lookup>
  8011c1:	89 c3                	mov    %eax,%ebx
  8011c3:	83 c4 10             	add    $0x10,%esp
  8011c6:	85 c0                	test   %eax,%eax
  8011c8:	0f 88 81 00 00 00    	js     80124f <dup+0xa3>
		return r;
	close(newfdnum);
  8011ce:	83 ec 0c             	sub    $0xc,%esp
  8011d1:	ff 75 0c             	pushl  0xc(%ebp)
  8011d4:	e8 81 ff ff ff       	call   80115a <close>

	newfd = INDEX2FD(newfdnum);
  8011d9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8011dc:	c1 e6 0c             	shl    $0xc,%esi
  8011df:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8011e5:	83 c4 04             	add    $0x4,%esp
  8011e8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011eb:	e8 d4 fd ff ff       	call   800fc4 <fd2data>
  8011f0:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8011f2:	89 34 24             	mov    %esi,(%esp)
  8011f5:	e8 ca fd ff ff       	call   800fc4 <fd2data>
  8011fa:	83 c4 10             	add    $0x10,%esp
  8011fd:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8011ff:	89 d8                	mov    %ebx,%eax
  801201:	c1 e8 16             	shr    $0x16,%eax
  801204:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80120b:	a8 01                	test   $0x1,%al
  80120d:	74 11                	je     801220 <dup+0x74>
  80120f:	89 d8                	mov    %ebx,%eax
  801211:	c1 e8 0c             	shr    $0xc,%eax
  801214:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80121b:	f6 c2 01             	test   $0x1,%dl
  80121e:	75 39                	jne    801259 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801220:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801223:	89 d0                	mov    %edx,%eax
  801225:	c1 e8 0c             	shr    $0xc,%eax
  801228:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80122f:	83 ec 0c             	sub    $0xc,%esp
  801232:	25 07 0e 00 00       	and    $0xe07,%eax
  801237:	50                   	push   %eax
  801238:	56                   	push   %esi
  801239:	6a 00                	push   $0x0
  80123b:	52                   	push   %edx
  80123c:	6a 00                	push   $0x0
  80123e:	e8 82 fb ff ff       	call   800dc5 <sys_page_map>
  801243:	89 c3                	mov    %eax,%ebx
  801245:	83 c4 20             	add    $0x20,%esp
  801248:	85 c0                	test   %eax,%eax
  80124a:	78 31                	js     80127d <dup+0xd1>
		goto err;

	return newfdnum;
  80124c:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80124f:	89 d8                	mov    %ebx,%eax
  801251:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801254:	5b                   	pop    %ebx
  801255:	5e                   	pop    %esi
  801256:	5f                   	pop    %edi
  801257:	5d                   	pop    %ebp
  801258:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801259:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801260:	83 ec 0c             	sub    $0xc,%esp
  801263:	25 07 0e 00 00       	and    $0xe07,%eax
  801268:	50                   	push   %eax
  801269:	57                   	push   %edi
  80126a:	6a 00                	push   $0x0
  80126c:	53                   	push   %ebx
  80126d:	6a 00                	push   $0x0
  80126f:	e8 51 fb ff ff       	call   800dc5 <sys_page_map>
  801274:	89 c3                	mov    %eax,%ebx
  801276:	83 c4 20             	add    $0x20,%esp
  801279:	85 c0                	test   %eax,%eax
  80127b:	79 a3                	jns    801220 <dup+0x74>
	sys_page_unmap(0, newfd);
  80127d:	83 ec 08             	sub    $0x8,%esp
  801280:	56                   	push   %esi
  801281:	6a 00                	push   $0x0
  801283:	e8 7f fb ff ff       	call   800e07 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801288:	83 c4 08             	add    $0x8,%esp
  80128b:	57                   	push   %edi
  80128c:	6a 00                	push   $0x0
  80128e:	e8 74 fb ff ff       	call   800e07 <sys_page_unmap>
	return r;
  801293:	83 c4 10             	add    $0x10,%esp
  801296:	eb b7                	jmp    80124f <dup+0xa3>

00801298 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801298:	55                   	push   %ebp
  801299:	89 e5                	mov    %esp,%ebp
  80129b:	53                   	push   %ebx
  80129c:	83 ec 1c             	sub    $0x1c,%esp
  80129f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012a2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012a5:	50                   	push   %eax
  8012a6:	53                   	push   %ebx
  8012a7:	e8 81 fd ff ff       	call   80102d <fd_lookup>
  8012ac:	83 c4 10             	add    $0x10,%esp
  8012af:	85 c0                	test   %eax,%eax
  8012b1:	78 3f                	js     8012f2 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012b3:	83 ec 08             	sub    $0x8,%esp
  8012b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012b9:	50                   	push   %eax
  8012ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012bd:	ff 30                	pushl  (%eax)
  8012bf:	e8 b9 fd ff ff       	call   80107d <dev_lookup>
  8012c4:	83 c4 10             	add    $0x10,%esp
  8012c7:	85 c0                	test   %eax,%eax
  8012c9:	78 27                	js     8012f2 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8012cb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012ce:	8b 42 08             	mov    0x8(%edx),%eax
  8012d1:	83 e0 03             	and    $0x3,%eax
  8012d4:	83 f8 01             	cmp    $0x1,%eax
  8012d7:	74 1e                	je     8012f7 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8012d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012dc:	8b 40 08             	mov    0x8(%eax),%eax
  8012df:	85 c0                	test   %eax,%eax
  8012e1:	74 35                	je     801318 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8012e3:	83 ec 04             	sub    $0x4,%esp
  8012e6:	ff 75 10             	pushl  0x10(%ebp)
  8012e9:	ff 75 0c             	pushl  0xc(%ebp)
  8012ec:	52                   	push   %edx
  8012ed:	ff d0                	call   *%eax
  8012ef:	83 c4 10             	add    $0x10,%esp
}
  8012f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012f5:	c9                   	leave  
  8012f6:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8012f7:	a1 04 40 80 00       	mov    0x804004,%eax
  8012fc:	8b 40 48             	mov    0x48(%eax),%eax
  8012ff:	83 ec 04             	sub    $0x4,%esp
  801302:	53                   	push   %ebx
  801303:	50                   	push   %eax
  801304:	68 0d 2a 80 00       	push   $0x802a0d
  801309:	e8 5c ef ff ff       	call   80026a <cprintf>
		return -E_INVAL;
  80130e:	83 c4 10             	add    $0x10,%esp
  801311:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801316:	eb da                	jmp    8012f2 <read+0x5a>
		return -E_NOT_SUPP;
  801318:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80131d:	eb d3                	jmp    8012f2 <read+0x5a>

0080131f <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80131f:	55                   	push   %ebp
  801320:	89 e5                	mov    %esp,%ebp
  801322:	57                   	push   %edi
  801323:	56                   	push   %esi
  801324:	53                   	push   %ebx
  801325:	83 ec 0c             	sub    $0xc,%esp
  801328:	8b 7d 08             	mov    0x8(%ebp),%edi
  80132b:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80132e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801333:	39 f3                	cmp    %esi,%ebx
  801335:	73 23                	jae    80135a <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801337:	83 ec 04             	sub    $0x4,%esp
  80133a:	89 f0                	mov    %esi,%eax
  80133c:	29 d8                	sub    %ebx,%eax
  80133e:	50                   	push   %eax
  80133f:	89 d8                	mov    %ebx,%eax
  801341:	03 45 0c             	add    0xc(%ebp),%eax
  801344:	50                   	push   %eax
  801345:	57                   	push   %edi
  801346:	e8 4d ff ff ff       	call   801298 <read>
		if (m < 0)
  80134b:	83 c4 10             	add    $0x10,%esp
  80134e:	85 c0                	test   %eax,%eax
  801350:	78 06                	js     801358 <readn+0x39>
			return m;
		if (m == 0)
  801352:	74 06                	je     80135a <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801354:	01 c3                	add    %eax,%ebx
  801356:	eb db                	jmp    801333 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801358:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80135a:	89 d8                	mov    %ebx,%eax
  80135c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80135f:	5b                   	pop    %ebx
  801360:	5e                   	pop    %esi
  801361:	5f                   	pop    %edi
  801362:	5d                   	pop    %ebp
  801363:	c3                   	ret    

00801364 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801364:	55                   	push   %ebp
  801365:	89 e5                	mov    %esp,%ebp
  801367:	53                   	push   %ebx
  801368:	83 ec 1c             	sub    $0x1c,%esp
  80136b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80136e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801371:	50                   	push   %eax
  801372:	53                   	push   %ebx
  801373:	e8 b5 fc ff ff       	call   80102d <fd_lookup>
  801378:	83 c4 10             	add    $0x10,%esp
  80137b:	85 c0                	test   %eax,%eax
  80137d:	78 3a                	js     8013b9 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80137f:	83 ec 08             	sub    $0x8,%esp
  801382:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801385:	50                   	push   %eax
  801386:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801389:	ff 30                	pushl  (%eax)
  80138b:	e8 ed fc ff ff       	call   80107d <dev_lookup>
  801390:	83 c4 10             	add    $0x10,%esp
  801393:	85 c0                	test   %eax,%eax
  801395:	78 22                	js     8013b9 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801397:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80139a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80139e:	74 1e                	je     8013be <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8013a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013a3:	8b 52 0c             	mov    0xc(%edx),%edx
  8013a6:	85 d2                	test   %edx,%edx
  8013a8:	74 35                	je     8013df <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8013aa:	83 ec 04             	sub    $0x4,%esp
  8013ad:	ff 75 10             	pushl  0x10(%ebp)
  8013b0:	ff 75 0c             	pushl  0xc(%ebp)
  8013b3:	50                   	push   %eax
  8013b4:	ff d2                	call   *%edx
  8013b6:	83 c4 10             	add    $0x10,%esp
}
  8013b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013bc:	c9                   	leave  
  8013bd:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8013be:	a1 04 40 80 00       	mov    0x804004,%eax
  8013c3:	8b 40 48             	mov    0x48(%eax),%eax
  8013c6:	83 ec 04             	sub    $0x4,%esp
  8013c9:	53                   	push   %ebx
  8013ca:	50                   	push   %eax
  8013cb:	68 29 2a 80 00       	push   $0x802a29
  8013d0:	e8 95 ee ff ff       	call   80026a <cprintf>
		return -E_INVAL;
  8013d5:	83 c4 10             	add    $0x10,%esp
  8013d8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013dd:	eb da                	jmp    8013b9 <write+0x55>
		return -E_NOT_SUPP;
  8013df:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013e4:	eb d3                	jmp    8013b9 <write+0x55>

008013e6 <seek>:

int
seek(int fdnum, off_t offset)
{
  8013e6:	55                   	push   %ebp
  8013e7:	89 e5                	mov    %esp,%ebp
  8013e9:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013ec:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013ef:	50                   	push   %eax
  8013f0:	ff 75 08             	pushl  0x8(%ebp)
  8013f3:	e8 35 fc ff ff       	call   80102d <fd_lookup>
  8013f8:	83 c4 10             	add    $0x10,%esp
  8013fb:	85 c0                	test   %eax,%eax
  8013fd:	78 0e                	js     80140d <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8013ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801402:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801405:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801408:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80140d:	c9                   	leave  
  80140e:	c3                   	ret    

0080140f <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80140f:	55                   	push   %ebp
  801410:	89 e5                	mov    %esp,%ebp
  801412:	53                   	push   %ebx
  801413:	83 ec 1c             	sub    $0x1c,%esp
  801416:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801419:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80141c:	50                   	push   %eax
  80141d:	53                   	push   %ebx
  80141e:	e8 0a fc ff ff       	call   80102d <fd_lookup>
  801423:	83 c4 10             	add    $0x10,%esp
  801426:	85 c0                	test   %eax,%eax
  801428:	78 37                	js     801461 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80142a:	83 ec 08             	sub    $0x8,%esp
  80142d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801430:	50                   	push   %eax
  801431:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801434:	ff 30                	pushl  (%eax)
  801436:	e8 42 fc ff ff       	call   80107d <dev_lookup>
  80143b:	83 c4 10             	add    $0x10,%esp
  80143e:	85 c0                	test   %eax,%eax
  801440:	78 1f                	js     801461 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801442:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801445:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801449:	74 1b                	je     801466 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80144b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80144e:	8b 52 18             	mov    0x18(%edx),%edx
  801451:	85 d2                	test   %edx,%edx
  801453:	74 32                	je     801487 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801455:	83 ec 08             	sub    $0x8,%esp
  801458:	ff 75 0c             	pushl  0xc(%ebp)
  80145b:	50                   	push   %eax
  80145c:	ff d2                	call   *%edx
  80145e:	83 c4 10             	add    $0x10,%esp
}
  801461:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801464:	c9                   	leave  
  801465:	c3                   	ret    
			thisenv->env_id, fdnum);
  801466:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80146b:	8b 40 48             	mov    0x48(%eax),%eax
  80146e:	83 ec 04             	sub    $0x4,%esp
  801471:	53                   	push   %ebx
  801472:	50                   	push   %eax
  801473:	68 ec 29 80 00       	push   $0x8029ec
  801478:	e8 ed ed ff ff       	call   80026a <cprintf>
		return -E_INVAL;
  80147d:	83 c4 10             	add    $0x10,%esp
  801480:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801485:	eb da                	jmp    801461 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801487:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80148c:	eb d3                	jmp    801461 <ftruncate+0x52>

0080148e <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80148e:	55                   	push   %ebp
  80148f:	89 e5                	mov    %esp,%ebp
  801491:	53                   	push   %ebx
  801492:	83 ec 1c             	sub    $0x1c,%esp
  801495:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801498:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80149b:	50                   	push   %eax
  80149c:	ff 75 08             	pushl  0x8(%ebp)
  80149f:	e8 89 fb ff ff       	call   80102d <fd_lookup>
  8014a4:	83 c4 10             	add    $0x10,%esp
  8014a7:	85 c0                	test   %eax,%eax
  8014a9:	78 4b                	js     8014f6 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014ab:	83 ec 08             	sub    $0x8,%esp
  8014ae:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014b1:	50                   	push   %eax
  8014b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014b5:	ff 30                	pushl  (%eax)
  8014b7:	e8 c1 fb ff ff       	call   80107d <dev_lookup>
  8014bc:	83 c4 10             	add    $0x10,%esp
  8014bf:	85 c0                	test   %eax,%eax
  8014c1:	78 33                	js     8014f6 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8014c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014c6:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8014ca:	74 2f                	je     8014fb <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8014cc:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8014cf:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8014d6:	00 00 00 
	stat->st_isdir = 0;
  8014d9:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8014e0:	00 00 00 
	stat->st_dev = dev;
  8014e3:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8014e9:	83 ec 08             	sub    $0x8,%esp
  8014ec:	53                   	push   %ebx
  8014ed:	ff 75 f0             	pushl  -0x10(%ebp)
  8014f0:	ff 50 14             	call   *0x14(%eax)
  8014f3:	83 c4 10             	add    $0x10,%esp
}
  8014f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014f9:	c9                   	leave  
  8014fa:	c3                   	ret    
		return -E_NOT_SUPP;
  8014fb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801500:	eb f4                	jmp    8014f6 <fstat+0x68>

00801502 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801502:	55                   	push   %ebp
  801503:	89 e5                	mov    %esp,%ebp
  801505:	56                   	push   %esi
  801506:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801507:	83 ec 08             	sub    $0x8,%esp
  80150a:	6a 00                	push   $0x0
  80150c:	ff 75 08             	pushl  0x8(%ebp)
  80150f:	e8 bb 01 00 00       	call   8016cf <open>
  801514:	89 c3                	mov    %eax,%ebx
  801516:	83 c4 10             	add    $0x10,%esp
  801519:	85 c0                	test   %eax,%eax
  80151b:	78 1b                	js     801538 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80151d:	83 ec 08             	sub    $0x8,%esp
  801520:	ff 75 0c             	pushl  0xc(%ebp)
  801523:	50                   	push   %eax
  801524:	e8 65 ff ff ff       	call   80148e <fstat>
  801529:	89 c6                	mov    %eax,%esi
	close(fd);
  80152b:	89 1c 24             	mov    %ebx,(%esp)
  80152e:	e8 27 fc ff ff       	call   80115a <close>
	return r;
  801533:	83 c4 10             	add    $0x10,%esp
  801536:	89 f3                	mov    %esi,%ebx
}
  801538:	89 d8                	mov    %ebx,%eax
  80153a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80153d:	5b                   	pop    %ebx
  80153e:	5e                   	pop    %esi
  80153f:	5d                   	pop    %ebp
  801540:	c3                   	ret    

00801541 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801541:	55                   	push   %ebp
  801542:	89 e5                	mov    %esp,%ebp
  801544:	56                   	push   %esi
  801545:	53                   	push   %ebx
  801546:	89 c6                	mov    %eax,%esi
  801548:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80154a:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801551:	74 27                	je     80157a <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801553:	6a 07                	push   $0x7
  801555:	68 00 50 80 00       	push   $0x805000
  80155a:	56                   	push   %esi
  80155b:	ff 35 00 40 80 00    	pushl  0x804000
  801561:	e8 9a 0c 00 00       	call   802200 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801566:	83 c4 0c             	add    $0xc,%esp
  801569:	6a 00                	push   $0x0
  80156b:	53                   	push   %ebx
  80156c:	6a 00                	push   $0x0
  80156e:	e8 24 0c 00 00       	call   802197 <ipc_recv>
}
  801573:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801576:	5b                   	pop    %ebx
  801577:	5e                   	pop    %esi
  801578:	5d                   	pop    %ebp
  801579:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80157a:	83 ec 0c             	sub    $0xc,%esp
  80157d:	6a 01                	push   $0x1
  80157f:	e8 c9 0c 00 00       	call   80224d <ipc_find_env>
  801584:	a3 00 40 80 00       	mov    %eax,0x804000
  801589:	83 c4 10             	add    $0x10,%esp
  80158c:	eb c5                	jmp    801553 <fsipc+0x12>

0080158e <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80158e:	55                   	push   %ebp
  80158f:	89 e5                	mov    %esp,%ebp
  801591:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801594:	8b 45 08             	mov    0x8(%ebp),%eax
  801597:	8b 40 0c             	mov    0xc(%eax),%eax
  80159a:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80159f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a2:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8015a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8015ac:	b8 02 00 00 00       	mov    $0x2,%eax
  8015b1:	e8 8b ff ff ff       	call   801541 <fsipc>
}
  8015b6:	c9                   	leave  
  8015b7:	c3                   	ret    

008015b8 <devfile_flush>:
{
  8015b8:	55                   	push   %ebp
  8015b9:	89 e5                	mov    %esp,%ebp
  8015bb:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8015be:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8015c4:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8015c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8015ce:	b8 06 00 00 00       	mov    $0x6,%eax
  8015d3:	e8 69 ff ff ff       	call   801541 <fsipc>
}
  8015d8:	c9                   	leave  
  8015d9:	c3                   	ret    

008015da <devfile_stat>:
{
  8015da:	55                   	push   %ebp
  8015db:	89 e5                	mov    %esp,%ebp
  8015dd:	53                   	push   %ebx
  8015de:	83 ec 04             	sub    $0x4,%esp
  8015e1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8015e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8015ea:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8015ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8015f4:	b8 05 00 00 00       	mov    $0x5,%eax
  8015f9:	e8 43 ff ff ff       	call   801541 <fsipc>
  8015fe:	85 c0                	test   %eax,%eax
  801600:	78 2c                	js     80162e <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801602:	83 ec 08             	sub    $0x8,%esp
  801605:	68 00 50 80 00       	push   $0x805000
  80160a:	53                   	push   %ebx
  80160b:	e8 80 f3 ff ff       	call   800990 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801610:	a1 80 50 80 00       	mov    0x805080,%eax
  801615:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80161b:	a1 84 50 80 00       	mov    0x805084,%eax
  801620:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801626:	83 c4 10             	add    $0x10,%esp
  801629:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80162e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801631:	c9                   	leave  
  801632:	c3                   	ret    

00801633 <devfile_write>:
{
  801633:	55                   	push   %ebp
  801634:	89 e5                	mov    %esp,%ebp
  801636:	83 ec 0c             	sub    $0xc,%esp
	panic("devfile_write not implemented");
  801639:	68 58 2a 80 00       	push   $0x802a58
  80163e:	68 90 00 00 00       	push   $0x90
  801643:	68 76 2a 80 00       	push   $0x802a76
  801648:	e8 42 eb ff ff       	call   80018f <_panic>

0080164d <devfile_read>:
{
  80164d:	55                   	push   %ebp
  80164e:	89 e5                	mov    %esp,%ebp
  801650:	56                   	push   %esi
  801651:	53                   	push   %ebx
  801652:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801655:	8b 45 08             	mov    0x8(%ebp),%eax
  801658:	8b 40 0c             	mov    0xc(%eax),%eax
  80165b:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801660:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801666:	ba 00 00 00 00       	mov    $0x0,%edx
  80166b:	b8 03 00 00 00       	mov    $0x3,%eax
  801670:	e8 cc fe ff ff       	call   801541 <fsipc>
  801675:	89 c3                	mov    %eax,%ebx
  801677:	85 c0                	test   %eax,%eax
  801679:	78 1f                	js     80169a <devfile_read+0x4d>
	assert(r <= n);
  80167b:	39 f0                	cmp    %esi,%eax
  80167d:	77 24                	ja     8016a3 <devfile_read+0x56>
	assert(r <= PGSIZE);
  80167f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801684:	7f 33                	jg     8016b9 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801686:	83 ec 04             	sub    $0x4,%esp
  801689:	50                   	push   %eax
  80168a:	68 00 50 80 00       	push   $0x805000
  80168f:	ff 75 0c             	pushl  0xc(%ebp)
  801692:	e8 87 f4 ff ff       	call   800b1e <memmove>
	return r;
  801697:	83 c4 10             	add    $0x10,%esp
}
  80169a:	89 d8                	mov    %ebx,%eax
  80169c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80169f:	5b                   	pop    %ebx
  8016a0:	5e                   	pop    %esi
  8016a1:	5d                   	pop    %ebp
  8016a2:	c3                   	ret    
	assert(r <= n);
  8016a3:	68 81 2a 80 00       	push   $0x802a81
  8016a8:	68 88 2a 80 00       	push   $0x802a88
  8016ad:	6a 7c                	push   $0x7c
  8016af:	68 76 2a 80 00       	push   $0x802a76
  8016b4:	e8 d6 ea ff ff       	call   80018f <_panic>
	assert(r <= PGSIZE);
  8016b9:	68 9d 2a 80 00       	push   $0x802a9d
  8016be:	68 88 2a 80 00       	push   $0x802a88
  8016c3:	6a 7d                	push   $0x7d
  8016c5:	68 76 2a 80 00       	push   $0x802a76
  8016ca:	e8 c0 ea ff ff       	call   80018f <_panic>

008016cf <open>:
{
  8016cf:	55                   	push   %ebp
  8016d0:	89 e5                	mov    %esp,%ebp
  8016d2:	56                   	push   %esi
  8016d3:	53                   	push   %ebx
  8016d4:	83 ec 1c             	sub    $0x1c,%esp
  8016d7:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8016da:	56                   	push   %esi
  8016db:	e8 77 f2 ff ff       	call   800957 <strlen>
  8016e0:	83 c4 10             	add    $0x10,%esp
  8016e3:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8016e8:	7f 6c                	jg     801756 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8016ea:	83 ec 0c             	sub    $0xc,%esp
  8016ed:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016f0:	50                   	push   %eax
  8016f1:	e8 e5 f8 ff ff       	call   800fdb <fd_alloc>
  8016f6:	89 c3                	mov    %eax,%ebx
  8016f8:	83 c4 10             	add    $0x10,%esp
  8016fb:	85 c0                	test   %eax,%eax
  8016fd:	78 3c                	js     80173b <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8016ff:	83 ec 08             	sub    $0x8,%esp
  801702:	56                   	push   %esi
  801703:	68 00 50 80 00       	push   $0x805000
  801708:	e8 83 f2 ff ff       	call   800990 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80170d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801710:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801715:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801718:	b8 01 00 00 00       	mov    $0x1,%eax
  80171d:	e8 1f fe ff ff       	call   801541 <fsipc>
  801722:	89 c3                	mov    %eax,%ebx
  801724:	83 c4 10             	add    $0x10,%esp
  801727:	85 c0                	test   %eax,%eax
  801729:	78 19                	js     801744 <open+0x75>
	return fd2num(fd);
  80172b:	83 ec 0c             	sub    $0xc,%esp
  80172e:	ff 75 f4             	pushl  -0xc(%ebp)
  801731:	e8 7e f8 ff ff       	call   800fb4 <fd2num>
  801736:	89 c3                	mov    %eax,%ebx
  801738:	83 c4 10             	add    $0x10,%esp
}
  80173b:	89 d8                	mov    %ebx,%eax
  80173d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801740:	5b                   	pop    %ebx
  801741:	5e                   	pop    %esi
  801742:	5d                   	pop    %ebp
  801743:	c3                   	ret    
		fd_close(fd, 0);
  801744:	83 ec 08             	sub    $0x8,%esp
  801747:	6a 00                	push   $0x0
  801749:	ff 75 f4             	pushl  -0xc(%ebp)
  80174c:	e8 82 f9 ff ff       	call   8010d3 <fd_close>
		return r;
  801751:	83 c4 10             	add    $0x10,%esp
  801754:	eb e5                	jmp    80173b <open+0x6c>
		return -E_BAD_PATH;
  801756:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80175b:	eb de                	jmp    80173b <open+0x6c>

0080175d <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80175d:	55                   	push   %ebp
  80175e:	89 e5                	mov    %esp,%ebp
  801760:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801763:	ba 00 00 00 00       	mov    $0x0,%edx
  801768:	b8 08 00 00 00       	mov    $0x8,%eax
  80176d:	e8 cf fd ff ff       	call   801541 <fsipc>
}
  801772:	c9                   	leave  
  801773:	c3                   	ret    

00801774 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801774:	55                   	push   %ebp
  801775:	89 e5                	mov    %esp,%ebp
  801777:	57                   	push   %edi
  801778:	56                   	push   %esi
  801779:	53                   	push   %ebx
  80177a:	81 ec 94 02 00 00    	sub    $0x294,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801780:	6a 00                	push   $0x0
  801782:	ff 75 08             	pushl  0x8(%ebp)
  801785:	e8 45 ff ff ff       	call   8016cf <open>
  80178a:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801790:	83 c4 10             	add    $0x10,%esp
  801793:	85 c0                	test   %eax,%eax
  801795:	0f 88 72 04 00 00    	js     801c0d <spawn+0x499>
  80179b:	89 c2                	mov    %eax,%edx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  80179d:	83 ec 04             	sub    $0x4,%esp
  8017a0:	68 00 02 00 00       	push   $0x200
  8017a5:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  8017ab:	50                   	push   %eax
  8017ac:	52                   	push   %edx
  8017ad:	e8 6d fb ff ff       	call   80131f <readn>
  8017b2:	83 c4 10             	add    $0x10,%esp
  8017b5:	3d 00 02 00 00       	cmp    $0x200,%eax
  8017ba:	75 60                	jne    80181c <spawn+0xa8>
	    || elf->e_magic != ELF_MAGIC) {
  8017bc:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  8017c3:	45 4c 46 
  8017c6:	75 54                	jne    80181c <spawn+0xa8>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8017c8:	b8 07 00 00 00       	mov    $0x7,%eax
  8017cd:	cd 30                	int    $0x30
  8017cf:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  8017d5:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  8017db:	85 c0                	test   %eax,%eax
  8017dd:	0f 88 1e 04 00 00    	js     801c01 <spawn+0x48d>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  8017e3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8017e8:	69 f0 84 00 00 00    	imul   $0x84,%eax,%esi
  8017ee:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  8017f4:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  8017fa:	b9 11 00 00 00       	mov    $0x11,%ecx
  8017ff:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801801:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801807:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  80180d:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  801812:	be 00 00 00 00       	mov    $0x0,%esi
  801817:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80181a:	eb 4b                	jmp    801867 <spawn+0xf3>
		close(fd);
  80181c:	83 ec 0c             	sub    $0xc,%esp
  80181f:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801825:	e8 30 f9 ff ff       	call   80115a <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  80182a:	83 c4 0c             	add    $0xc,%esp
  80182d:	68 7f 45 4c 46       	push   $0x464c457f
  801832:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  801838:	68 a9 2a 80 00       	push   $0x802aa9
  80183d:	e8 28 ea ff ff       	call   80026a <cprintf>
		return -E_NOT_EXEC;
  801842:	83 c4 10             	add    $0x10,%esp
  801845:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  80184c:	ff ff ff 
  80184f:	e9 b9 03 00 00       	jmp    801c0d <spawn+0x499>
		string_size += strlen(argv[argc]) + 1;
  801854:	83 ec 0c             	sub    $0xc,%esp
  801857:	50                   	push   %eax
  801858:	e8 fa f0 ff ff       	call   800957 <strlen>
  80185d:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  801861:	83 c3 01             	add    $0x1,%ebx
  801864:	83 c4 10             	add    $0x10,%esp
  801867:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  80186e:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801871:	85 c0                	test   %eax,%eax
  801873:	75 df                	jne    801854 <spawn+0xe0>
  801875:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  80187b:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801881:	bf 00 10 40 00       	mov    $0x401000,%edi
  801886:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801888:	89 fa                	mov    %edi,%edx
  80188a:	83 e2 fc             	and    $0xfffffffc,%edx
  80188d:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801894:	29 c2                	sub    %eax,%edx
  801896:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  80189c:	8d 42 f8             	lea    -0x8(%edx),%eax
  80189f:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  8018a4:	0f 86 86 03 00 00    	jbe    801c30 <spawn+0x4bc>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8018aa:	83 ec 04             	sub    $0x4,%esp
  8018ad:	6a 07                	push   $0x7
  8018af:	68 00 00 40 00       	push   $0x400000
  8018b4:	6a 00                	push   $0x0
  8018b6:	e8 c7 f4 ff ff       	call   800d82 <sys_page_alloc>
  8018bb:	83 c4 10             	add    $0x10,%esp
  8018be:	85 c0                	test   %eax,%eax
  8018c0:	0f 88 6f 03 00 00    	js     801c35 <spawn+0x4c1>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8018c6:	be 00 00 00 00       	mov    $0x0,%esi
  8018cb:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  8018d1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8018d4:	eb 30                	jmp    801906 <spawn+0x192>
		argv_store[i] = UTEMP2USTACK(string_store);
  8018d6:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  8018dc:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  8018e2:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  8018e5:	83 ec 08             	sub    $0x8,%esp
  8018e8:	ff 34 b3             	pushl  (%ebx,%esi,4)
  8018eb:	57                   	push   %edi
  8018ec:	e8 9f f0 ff ff       	call   800990 <strcpy>
		string_store += strlen(argv[i]) + 1;
  8018f1:	83 c4 04             	add    $0x4,%esp
  8018f4:	ff 34 b3             	pushl  (%ebx,%esi,4)
  8018f7:	e8 5b f0 ff ff       	call   800957 <strlen>
  8018fc:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  801900:	83 c6 01             	add    $0x1,%esi
  801903:	83 c4 10             	add    $0x10,%esp
  801906:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  80190c:	7f c8                	jg     8018d6 <spawn+0x162>
	}
	argv_store[argc] = 0;
  80190e:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801914:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  80191a:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801921:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801927:	0f 85 86 00 00 00    	jne    8019b3 <spawn+0x23f>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  80192d:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  801933:	8d 81 00 d0 7f ee    	lea    -0x11803000(%ecx),%eax
  801939:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  80193c:	89 c8                	mov    %ecx,%eax
  80193e:	8b 8d 84 fd ff ff    	mov    -0x27c(%ebp),%ecx
  801944:	89 48 f8             	mov    %ecx,-0x8(%eax)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801947:	2d 08 30 80 11       	sub    $0x11803008,%eax
  80194c:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801952:	83 ec 0c             	sub    $0xc,%esp
  801955:	6a 07                	push   $0x7
  801957:	68 00 d0 bf ee       	push   $0xeebfd000
  80195c:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801962:	68 00 00 40 00       	push   $0x400000
  801967:	6a 00                	push   $0x0
  801969:	e8 57 f4 ff ff       	call   800dc5 <sys_page_map>
  80196e:	89 c3                	mov    %eax,%ebx
  801970:	83 c4 20             	add    $0x20,%esp
  801973:	85 c0                	test   %eax,%eax
  801975:	0f 88 c2 02 00 00    	js     801c3d <spawn+0x4c9>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  80197b:	83 ec 08             	sub    $0x8,%esp
  80197e:	68 00 00 40 00       	push   $0x400000
  801983:	6a 00                	push   $0x0
  801985:	e8 7d f4 ff ff       	call   800e07 <sys_page_unmap>
  80198a:	89 c3                	mov    %eax,%ebx
  80198c:	83 c4 10             	add    $0x10,%esp
  80198f:	85 c0                	test   %eax,%eax
  801991:	0f 88 a6 02 00 00    	js     801c3d <spawn+0x4c9>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801997:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  80199d:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8019a4:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  8019ab:	00 00 00 
  8019ae:	e9 4f 01 00 00       	jmp    801b02 <spawn+0x38e>
	assert(string_store == (char*)UTEMP + PGSIZE);
  8019b3:	68 20 2b 80 00       	push   $0x802b20
  8019b8:	68 88 2a 80 00       	push   $0x802a88
  8019bd:	68 f2 00 00 00       	push   $0xf2
  8019c2:	68 c3 2a 80 00       	push   $0x802ac3
  8019c7:	e8 c3 e7 ff ff       	call   80018f <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8019cc:	83 ec 04             	sub    $0x4,%esp
  8019cf:	6a 07                	push   $0x7
  8019d1:	68 00 00 40 00       	push   $0x400000
  8019d6:	6a 00                	push   $0x0
  8019d8:	e8 a5 f3 ff ff       	call   800d82 <sys_page_alloc>
  8019dd:	83 c4 10             	add    $0x10,%esp
  8019e0:	85 c0                	test   %eax,%eax
  8019e2:	0f 88 33 02 00 00    	js     801c1b <spawn+0x4a7>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  8019e8:	83 ec 08             	sub    $0x8,%esp
  8019eb:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  8019f1:	01 f0                	add    %esi,%eax
  8019f3:	50                   	push   %eax
  8019f4:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8019fa:	e8 e7 f9 ff ff       	call   8013e6 <seek>
  8019ff:	83 c4 10             	add    $0x10,%esp
  801a02:	85 c0                	test   %eax,%eax
  801a04:	0f 88 18 02 00 00    	js     801c22 <spawn+0x4ae>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801a0a:	83 ec 04             	sub    $0x4,%esp
  801a0d:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801a13:	29 f0                	sub    %esi,%eax
  801a15:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a1a:	ba 00 10 00 00       	mov    $0x1000,%edx
  801a1f:	0f 47 c2             	cmova  %edx,%eax
  801a22:	50                   	push   %eax
  801a23:	68 00 00 40 00       	push   $0x400000
  801a28:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801a2e:	e8 ec f8 ff ff       	call   80131f <readn>
  801a33:	83 c4 10             	add    $0x10,%esp
  801a36:	85 c0                	test   %eax,%eax
  801a38:	0f 88 eb 01 00 00    	js     801c29 <spawn+0x4b5>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801a3e:	83 ec 0c             	sub    $0xc,%esp
  801a41:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801a47:	53                   	push   %ebx
  801a48:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801a4e:	68 00 00 40 00       	push   $0x400000
  801a53:	6a 00                	push   $0x0
  801a55:	e8 6b f3 ff ff       	call   800dc5 <sys_page_map>
  801a5a:	83 c4 20             	add    $0x20,%esp
  801a5d:	85 c0                	test   %eax,%eax
  801a5f:	78 7c                	js     801add <spawn+0x369>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  801a61:	83 ec 08             	sub    $0x8,%esp
  801a64:	68 00 00 40 00       	push   $0x400000
  801a69:	6a 00                	push   $0x0
  801a6b:	e8 97 f3 ff ff       	call   800e07 <sys_page_unmap>
  801a70:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  801a73:	81 c7 00 10 00 00    	add    $0x1000,%edi
  801a79:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801a7f:	89 fe                	mov    %edi,%esi
  801a81:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  801a87:	76 69                	jbe    801af2 <spawn+0x37e>
		if (i >= filesz) {
  801a89:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  801a8f:	0f 87 37 ff ff ff    	ja     8019cc <spawn+0x258>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801a95:	83 ec 04             	sub    $0x4,%esp
  801a98:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801a9e:	53                   	push   %ebx
  801a9f:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801aa5:	e8 d8 f2 ff ff       	call   800d82 <sys_page_alloc>
  801aaa:	83 c4 10             	add    $0x10,%esp
  801aad:	85 c0                	test   %eax,%eax
  801aaf:	79 c2                	jns    801a73 <spawn+0x2ff>
  801ab1:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  801ab3:	83 ec 0c             	sub    $0xc,%esp
  801ab6:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801abc:	e8 42 f2 ff ff       	call   800d03 <sys_env_destroy>
	close(fd);
  801ac1:	83 c4 04             	add    $0x4,%esp
  801ac4:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801aca:	e8 8b f6 ff ff       	call   80115a <close>
	return r;
  801acf:	83 c4 10             	add    $0x10,%esp
  801ad2:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  801ad8:	e9 30 01 00 00       	jmp    801c0d <spawn+0x499>
				panic("spawn: sys_page_map data: %e", r);
  801add:	50                   	push   %eax
  801ade:	68 cf 2a 80 00       	push   $0x802acf
  801ae3:	68 25 01 00 00       	push   $0x125
  801ae8:	68 c3 2a 80 00       	push   $0x802ac3
  801aed:	e8 9d e6 ff ff       	call   80018f <_panic>
  801af2:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801af8:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  801aff:	83 c6 20             	add    $0x20,%esi
  801b02:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801b09:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  801b0f:	7e 6d                	jle    801b7e <spawn+0x40a>
		if (ph->p_type != ELF_PROG_LOAD)
  801b11:	83 3e 01             	cmpl   $0x1,(%esi)
  801b14:	75 e2                	jne    801af8 <spawn+0x384>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801b16:	8b 46 18             	mov    0x18(%esi),%eax
  801b19:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  801b1c:	83 f8 01             	cmp    $0x1,%eax
  801b1f:	19 c0                	sbb    %eax,%eax
  801b21:	83 e0 fe             	and    $0xfffffffe,%eax
  801b24:	83 c0 07             	add    $0x7,%eax
  801b27:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801b2d:	8b 4e 04             	mov    0x4(%esi),%ecx
  801b30:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  801b36:	8b 56 10             	mov    0x10(%esi),%edx
  801b39:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  801b3f:	8b 7e 14             	mov    0x14(%esi),%edi
  801b42:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  801b48:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  801b4b:	89 d8                	mov    %ebx,%eax
  801b4d:	25 ff 0f 00 00       	and    $0xfff,%eax
  801b52:	74 1a                	je     801b6e <spawn+0x3fa>
		va -= i;
  801b54:	29 c3                	sub    %eax,%ebx
		memsz += i;
  801b56:	01 c7                	add    %eax,%edi
  801b58:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  801b5e:	01 c2                	add    %eax,%edx
  801b60:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  801b66:	29 c1                	sub    %eax,%ecx
  801b68:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  801b6e:	bf 00 00 00 00       	mov    $0x0,%edi
  801b73:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  801b79:	e9 01 ff ff ff       	jmp    801a7f <spawn+0x30b>
	close(fd);
  801b7e:	83 ec 0c             	sub    $0xc,%esp
  801b81:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801b87:	e8 ce f5 ff ff       	call   80115a <close>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  801b8c:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  801b93:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801b96:	83 c4 08             	add    $0x8,%esp
  801b99:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801b9f:	50                   	push   %eax
  801ba0:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801ba6:	e8 e0 f2 ff ff       	call   800e8b <sys_env_set_trapframe>
  801bab:	83 c4 10             	add    $0x10,%esp
  801bae:	85 c0                	test   %eax,%eax
  801bb0:	78 25                	js     801bd7 <spawn+0x463>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801bb2:	83 ec 08             	sub    $0x8,%esp
  801bb5:	6a 02                	push   $0x2
  801bb7:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801bbd:	e8 87 f2 ff ff       	call   800e49 <sys_env_set_status>
  801bc2:	83 c4 10             	add    $0x10,%esp
  801bc5:	85 c0                	test   %eax,%eax
  801bc7:	78 23                	js     801bec <spawn+0x478>
	return child;
  801bc9:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801bcf:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801bd5:	eb 36                	jmp    801c0d <spawn+0x499>
		panic("sys_env_set_trapframe: %e", r);
  801bd7:	50                   	push   %eax
  801bd8:	68 ec 2a 80 00       	push   $0x802aec
  801bdd:	68 86 00 00 00       	push   $0x86
  801be2:	68 c3 2a 80 00       	push   $0x802ac3
  801be7:	e8 a3 e5 ff ff       	call   80018f <_panic>
		panic("sys_env_set_status: %e", r);
  801bec:	50                   	push   %eax
  801bed:	68 06 2b 80 00       	push   $0x802b06
  801bf2:	68 89 00 00 00       	push   $0x89
  801bf7:	68 c3 2a 80 00       	push   $0x802ac3
  801bfc:	e8 8e e5 ff ff       	call   80018f <_panic>
		return r;
  801c01:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801c07:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  801c0d:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801c13:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c16:	5b                   	pop    %ebx
  801c17:	5e                   	pop    %esi
  801c18:	5f                   	pop    %edi
  801c19:	5d                   	pop    %ebp
  801c1a:	c3                   	ret    
  801c1b:	89 c7                	mov    %eax,%edi
  801c1d:	e9 91 fe ff ff       	jmp    801ab3 <spawn+0x33f>
  801c22:	89 c7                	mov    %eax,%edi
  801c24:	e9 8a fe ff ff       	jmp    801ab3 <spawn+0x33f>
  801c29:	89 c7                	mov    %eax,%edi
  801c2b:	e9 83 fe ff ff       	jmp    801ab3 <spawn+0x33f>
		return -E_NO_MEM;
  801c30:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801c35:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801c3b:	eb d0                	jmp    801c0d <spawn+0x499>
	sys_page_unmap(0, UTEMP);
  801c3d:	83 ec 08             	sub    $0x8,%esp
  801c40:	68 00 00 40 00       	push   $0x400000
  801c45:	6a 00                	push   $0x0
  801c47:	e8 bb f1 ff ff       	call   800e07 <sys_page_unmap>
  801c4c:	83 c4 10             	add    $0x10,%esp
  801c4f:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  801c55:	eb b6                	jmp    801c0d <spawn+0x499>

00801c57 <spawnl>:
{
  801c57:	55                   	push   %ebp
  801c58:	89 e5                	mov    %esp,%ebp
  801c5a:	57                   	push   %edi
  801c5b:	56                   	push   %esi
  801c5c:	53                   	push   %ebx
  801c5d:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  801c60:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  801c63:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  801c68:	8d 4a 04             	lea    0x4(%edx),%ecx
  801c6b:	83 3a 00             	cmpl   $0x0,(%edx)
  801c6e:	74 07                	je     801c77 <spawnl+0x20>
		argc++;
  801c70:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  801c73:	89 ca                	mov    %ecx,%edx
  801c75:	eb f1                	jmp    801c68 <spawnl+0x11>
	const char *argv[argc+2];
  801c77:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  801c7e:	83 e2 f0             	and    $0xfffffff0,%edx
  801c81:	29 d4                	sub    %edx,%esp
  801c83:	8d 54 24 03          	lea    0x3(%esp),%edx
  801c87:	c1 ea 02             	shr    $0x2,%edx
  801c8a:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  801c91:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  801c93:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c96:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  801c9d:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  801ca4:	00 
	va_start(vl, arg0);
  801ca5:	8d 4d 10             	lea    0x10(%ebp),%ecx
  801ca8:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  801caa:	b8 00 00 00 00       	mov    $0x0,%eax
  801caf:	eb 0b                	jmp    801cbc <spawnl+0x65>
		argv[i+1] = va_arg(vl, const char *);
  801cb1:	83 c0 01             	add    $0x1,%eax
  801cb4:	8b 39                	mov    (%ecx),%edi
  801cb6:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  801cb9:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  801cbc:	39 d0                	cmp    %edx,%eax
  801cbe:	75 f1                	jne    801cb1 <spawnl+0x5a>
	return spawn(prog, argv);
  801cc0:	83 ec 08             	sub    $0x8,%esp
  801cc3:	56                   	push   %esi
  801cc4:	ff 75 08             	pushl  0x8(%ebp)
  801cc7:	e8 a8 fa ff ff       	call   801774 <spawn>
}
  801ccc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ccf:	5b                   	pop    %ebx
  801cd0:	5e                   	pop    %esi
  801cd1:	5f                   	pop    %edi
  801cd2:	5d                   	pop    %ebp
  801cd3:	c3                   	ret    

00801cd4 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801cd4:	55                   	push   %ebp
  801cd5:	89 e5                	mov    %esp,%ebp
  801cd7:	56                   	push   %esi
  801cd8:	53                   	push   %ebx
  801cd9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801cdc:	83 ec 0c             	sub    $0xc,%esp
  801cdf:	ff 75 08             	pushl  0x8(%ebp)
  801ce2:	e8 dd f2 ff ff       	call   800fc4 <fd2data>
  801ce7:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801ce9:	83 c4 08             	add    $0x8,%esp
  801cec:	68 48 2b 80 00       	push   $0x802b48
  801cf1:	53                   	push   %ebx
  801cf2:	e8 99 ec ff ff       	call   800990 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801cf7:	8b 46 04             	mov    0x4(%esi),%eax
  801cfa:	2b 06                	sub    (%esi),%eax
  801cfc:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801d02:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d09:	00 00 00 
	stat->st_dev = &devpipe;
  801d0c:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801d13:	30 80 00 
	return 0;
}
  801d16:	b8 00 00 00 00       	mov    $0x0,%eax
  801d1b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d1e:	5b                   	pop    %ebx
  801d1f:	5e                   	pop    %esi
  801d20:	5d                   	pop    %ebp
  801d21:	c3                   	ret    

00801d22 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d22:	55                   	push   %ebp
  801d23:	89 e5                	mov    %esp,%ebp
  801d25:	53                   	push   %ebx
  801d26:	83 ec 0c             	sub    $0xc,%esp
  801d29:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d2c:	53                   	push   %ebx
  801d2d:	6a 00                	push   $0x0
  801d2f:	e8 d3 f0 ff ff       	call   800e07 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d34:	89 1c 24             	mov    %ebx,(%esp)
  801d37:	e8 88 f2 ff ff       	call   800fc4 <fd2data>
  801d3c:	83 c4 08             	add    $0x8,%esp
  801d3f:	50                   	push   %eax
  801d40:	6a 00                	push   $0x0
  801d42:	e8 c0 f0 ff ff       	call   800e07 <sys_page_unmap>
}
  801d47:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d4a:	c9                   	leave  
  801d4b:	c3                   	ret    

00801d4c <_pipeisclosed>:
{
  801d4c:	55                   	push   %ebp
  801d4d:	89 e5                	mov    %esp,%ebp
  801d4f:	57                   	push   %edi
  801d50:	56                   	push   %esi
  801d51:	53                   	push   %ebx
  801d52:	83 ec 1c             	sub    $0x1c,%esp
  801d55:	89 c7                	mov    %eax,%edi
  801d57:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801d59:	a1 04 40 80 00       	mov    0x804004,%eax
  801d5e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d61:	83 ec 0c             	sub    $0xc,%esp
  801d64:	57                   	push   %edi
  801d65:	e8 22 05 00 00       	call   80228c <pageref>
  801d6a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d6d:	89 34 24             	mov    %esi,(%esp)
  801d70:	e8 17 05 00 00       	call   80228c <pageref>
		nn = thisenv->env_runs;
  801d75:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801d7b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801d7e:	83 c4 10             	add    $0x10,%esp
  801d81:	39 cb                	cmp    %ecx,%ebx
  801d83:	74 1b                	je     801da0 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801d85:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d88:	75 cf                	jne    801d59 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d8a:	8b 42 58             	mov    0x58(%edx),%eax
  801d8d:	6a 01                	push   $0x1
  801d8f:	50                   	push   %eax
  801d90:	53                   	push   %ebx
  801d91:	68 4f 2b 80 00       	push   $0x802b4f
  801d96:	e8 cf e4 ff ff       	call   80026a <cprintf>
  801d9b:	83 c4 10             	add    $0x10,%esp
  801d9e:	eb b9                	jmp    801d59 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801da0:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801da3:	0f 94 c0             	sete   %al
  801da6:	0f b6 c0             	movzbl %al,%eax
}
  801da9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801dac:	5b                   	pop    %ebx
  801dad:	5e                   	pop    %esi
  801dae:	5f                   	pop    %edi
  801daf:	5d                   	pop    %ebp
  801db0:	c3                   	ret    

00801db1 <devpipe_write>:
{
  801db1:	55                   	push   %ebp
  801db2:	89 e5                	mov    %esp,%ebp
  801db4:	57                   	push   %edi
  801db5:	56                   	push   %esi
  801db6:	53                   	push   %ebx
  801db7:	83 ec 28             	sub    $0x28,%esp
  801dba:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801dbd:	56                   	push   %esi
  801dbe:	e8 01 f2 ff ff       	call   800fc4 <fd2data>
  801dc3:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801dc5:	83 c4 10             	add    $0x10,%esp
  801dc8:	bf 00 00 00 00       	mov    $0x0,%edi
  801dcd:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801dd0:	74 4f                	je     801e21 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801dd2:	8b 43 04             	mov    0x4(%ebx),%eax
  801dd5:	8b 0b                	mov    (%ebx),%ecx
  801dd7:	8d 51 20             	lea    0x20(%ecx),%edx
  801dda:	39 d0                	cmp    %edx,%eax
  801ddc:	72 14                	jb     801df2 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801dde:	89 da                	mov    %ebx,%edx
  801de0:	89 f0                	mov    %esi,%eax
  801de2:	e8 65 ff ff ff       	call   801d4c <_pipeisclosed>
  801de7:	85 c0                	test   %eax,%eax
  801de9:	75 3b                	jne    801e26 <devpipe_write+0x75>
			sys_yield();
  801deb:	e8 73 ef ff ff       	call   800d63 <sys_yield>
  801df0:	eb e0                	jmp    801dd2 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801df2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801df5:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801df9:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801dfc:	89 c2                	mov    %eax,%edx
  801dfe:	c1 fa 1f             	sar    $0x1f,%edx
  801e01:	89 d1                	mov    %edx,%ecx
  801e03:	c1 e9 1b             	shr    $0x1b,%ecx
  801e06:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801e09:	83 e2 1f             	and    $0x1f,%edx
  801e0c:	29 ca                	sub    %ecx,%edx
  801e0e:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801e12:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801e16:	83 c0 01             	add    $0x1,%eax
  801e19:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801e1c:	83 c7 01             	add    $0x1,%edi
  801e1f:	eb ac                	jmp    801dcd <devpipe_write+0x1c>
	return i;
  801e21:	8b 45 10             	mov    0x10(%ebp),%eax
  801e24:	eb 05                	jmp    801e2b <devpipe_write+0x7a>
				return 0;
  801e26:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e2b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e2e:	5b                   	pop    %ebx
  801e2f:	5e                   	pop    %esi
  801e30:	5f                   	pop    %edi
  801e31:	5d                   	pop    %ebp
  801e32:	c3                   	ret    

00801e33 <devpipe_read>:
{
  801e33:	55                   	push   %ebp
  801e34:	89 e5                	mov    %esp,%ebp
  801e36:	57                   	push   %edi
  801e37:	56                   	push   %esi
  801e38:	53                   	push   %ebx
  801e39:	83 ec 18             	sub    $0x18,%esp
  801e3c:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801e3f:	57                   	push   %edi
  801e40:	e8 7f f1 ff ff       	call   800fc4 <fd2data>
  801e45:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e47:	83 c4 10             	add    $0x10,%esp
  801e4a:	be 00 00 00 00       	mov    $0x0,%esi
  801e4f:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e52:	75 14                	jne    801e68 <devpipe_read+0x35>
	return i;
  801e54:	8b 45 10             	mov    0x10(%ebp),%eax
  801e57:	eb 02                	jmp    801e5b <devpipe_read+0x28>
				return i;
  801e59:	89 f0                	mov    %esi,%eax
}
  801e5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e5e:	5b                   	pop    %ebx
  801e5f:	5e                   	pop    %esi
  801e60:	5f                   	pop    %edi
  801e61:	5d                   	pop    %ebp
  801e62:	c3                   	ret    
			sys_yield();
  801e63:	e8 fb ee ff ff       	call   800d63 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801e68:	8b 03                	mov    (%ebx),%eax
  801e6a:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e6d:	75 18                	jne    801e87 <devpipe_read+0x54>
			if (i > 0)
  801e6f:	85 f6                	test   %esi,%esi
  801e71:	75 e6                	jne    801e59 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801e73:	89 da                	mov    %ebx,%edx
  801e75:	89 f8                	mov    %edi,%eax
  801e77:	e8 d0 fe ff ff       	call   801d4c <_pipeisclosed>
  801e7c:	85 c0                	test   %eax,%eax
  801e7e:	74 e3                	je     801e63 <devpipe_read+0x30>
				return 0;
  801e80:	b8 00 00 00 00       	mov    $0x0,%eax
  801e85:	eb d4                	jmp    801e5b <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e87:	99                   	cltd   
  801e88:	c1 ea 1b             	shr    $0x1b,%edx
  801e8b:	01 d0                	add    %edx,%eax
  801e8d:	83 e0 1f             	and    $0x1f,%eax
  801e90:	29 d0                	sub    %edx,%eax
  801e92:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e97:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e9a:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e9d:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801ea0:	83 c6 01             	add    $0x1,%esi
  801ea3:	eb aa                	jmp    801e4f <devpipe_read+0x1c>

00801ea5 <pipe>:
{
  801ea5:	55                   	push   %ebp
  801ea6:	89 e5                	mov    %esp,%ebp
  801ea8:	56                   	push   %esi
  801ea9:	53                   	push   %ebx
  801eaa:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801ead:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801eb0:	50                   	push   %eax
  801eb1:	e8 25 f1 ff ff       	call   800fdb <fd_alloc>
  801eb6:	89 c3                	mov    %eax,%ebx
  801eb8:	83 c4 10             	add    $0x10,%esp
  801ebb:	85 c0                	test   %eax,%eax
  801ebd:	0f 88 23 01 00 00    	js     801fe6 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ec3:	83 ec 04             	sub    $0x4,%esp
  801ec6:	68 07 04 00 00       	push   $0x407
  801ecb:	ff 75 f4             	pushl  -0xc(%ebp)
  801ece:	6a 00                	push   $0x0
  801ed0:	e8 ad ee ff ff       	call   800d82 <sys_page_alloc>
  801ed5:	89 c3                	mov    %eax,%ebx
  801ed7:	83 c4 10             	add    $0x10,%esp
  801eda:	85 c0                	test   %eax,%eax
  801edc:	0f 88 04 01 00 00    	js     801fe6 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801ee2:	83 ec 0c             	sub    $0xc,%esp
  801ee5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ee8:	50                   	push   %eax
  801ee9:	e8 ed f0 ff ff       	call   800fdb <fd_alloc>
  801eee:	89 c3                	mov    %eax,%ebx
  801ef0:	83 c4 10             	add    $0x10,%esp
  801ef3:	85 c0                	test   %eax,%eax
  801ef5:	0f 88 db 00 00 00    	js     801fd6 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801efb:	83 ec 04             	sub    $0x4,%esp
  801efe:	68 07 04 00 00       	push   $0x407
  801f03:	ff 75 f0             	pushl  -0x10(%ebp)
  801f06:	6a 00                	push   $0x0
  801f08:	e8 75 ee ff ff       	call   800d82 <sys_page_alloc>
  801f0d:	89 c3                	mov    %eax,%ebx
  801f0f:	83 c4 10             	add    $0x10,%esp
  801f12:	85 c0                	test   %eax,%eax
  801f14:	0f 88 bc 00 00 00    	js     801fd6 <pipe+0x131>
	va = fd2data(fd0);
  801f1a:	83 ec 0c             	sub    $0xc,%esp
  801f1d:	ff 75 f4             	pushl  -0xc(%ebp)
  801f20:	e8 9f f0 ff ff       	call   800fc4 <fd2data>
  801f25:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f27:	83 c4 0c             	add    $0xc,%esp
  801f2a:	68 07 04 00 00       	push   $0x407
  801f2f:	50                   	push   %eax
  801f30:	6a 00                	push   $0x0
  801f32:	e8 4b ee ff ff       	call   800d82 <sys_page_alloc>
  801f37:	89 c3                	mov    %eax,%ebx
  801f39:	83 c4 10             	add    $0x10,%esp
  801f3c:	85 c0                	test   %eax,%eax
  801f3e:	0f 88 82 00 00 00    	js     801fc6 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f44:	83 ec 0c             	sub    $0xc,%esp
  801f47:	ff 75 f0             	pushl  -0x10(%ebp)
  801f4a:	e8 75 f0 ff ff       	call   800fc4 <fd2data>
  801f4f:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801f56:	50                   	push   %eax
  801f57:	6a 00                	push   $0x0
  801f59:	56                   	push   %esi
  801f5a:	6a 00                	push   $0x0
  801f5c:	e8 64 ee ff ff       	call   800dc5 <sys_page_map>
  801f61:	89 c3                	mov    %eax,%ebx
  801f63:	83 c4 20             	add    $0x20,%esp
  801f66:	85 c0                	test   %eax,%eax
  801f68:	78 4e                	js     801fb8 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801f6a:	a1 20 30 80 00       	mov    0x803020,%eax
  801f6f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f72:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801f74:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f77:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801f7e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f81:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801f83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f86:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f8d:	83 ec 0c             	sub    $0xc,%esp
  801f90:	ff 75 f4             	pushl  -0xc(%ebp)
  801f93:	e8 1c f0 ff ff       	call   800fb4 <fd2num>
  801f98:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f9b:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f9d:	83 c4 04             	add    $0x4,%esp
  801fa0:	ff 75 f0             	pushl  -0x10(%ebp)
  801fa3:	e8 0c f0 ff ff       	call   800fb4 <fd2num>
  801fa8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fab:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801fae:	83 c4 10             	add    $0x10,%esp
  801fb1:	bb 00 00 00 00       	mov    $0x0,%ebx
  801fb6:	eb 2e                	jmp    801fe6 <pipe+0x141>
	sys_page_unmap(0, va);
  801fb8:	83 ec 08             	sub    $0x8,%esp
  801fbb:	56                   	push   %esi
  801fbc:	6a 00                	push   $0x0
  801fbe:	e8 44 ee ff ff       	call   800e07 <sys_page_unmap>
  801fc3:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801fc6:	83 ec 08             	sub    $0x8,%esp
  801fc9:	ff 75 f0             	pushl  -0x10(%ebp)
  801fcc:	6a 00                	push   $0x0
  801fce:	e8 34 ee ff ff       	call   800e07 <sys_page_unmap>
  801fd3:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801fd6:	83 ec 08             	sub    $0x8,%esp
  801fd9:	ff 75 f4             	pushl  -0xc(%ebp)
  801fdc:	6a 00                	push   $0x0
  801fde:	e8 24 ee ff ff       	call   800e07 <sys_page_unmap>
  801fe3:	83 c4 10             	add    $0x10,%esp
}
  801fe6:	89 d8                	mov    %ebx,%eax
  801fe8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801feb:	5b                   	pop    %ebx
  801fec:	5e                   	pop    %esi
  801fed:	5d                   	pop    %ebp
  801fee:	c3                   	ret    

00801fef <pipeisclosed>:
{
  801fef:	55                   	push   %ebp
  801ff0:	89 e5                	mov    %esp,%ebp
  801ff2:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ff5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ff8:	50                   	push   %eax
  801ff9:	ff 75 08             	pushl  0x8(%ebp)
  801ffc:	e8 2c f0 ff ff       	call   80102d <fd_lookup>
  802001:	83 c4 10             	add    $0x10,%esp
  802004:	85 c0                	test   %eax,%eax
  802006:	78 18                	js     802020 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802008:	83 ec 0c             	sub    $0xc,%esp
  80200b:	ff 75 f4             	pushl  -0xc(%ebp)
  80200e:	e8 b1 ef ff ff       	call   800fc4 <fd2data>
	return _pipeisclosed(fd, p);
  802013:	89 c2                	mov    %eax,%edx
  802015:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802018:	e8 2f fd ff ff       	call   801d4c <_pipeisclosed>
  80201d:	83 c4 10             	add    $0x10,%esp
}
  802020:	c9                   	leave  
  802021:	c3                   	ret    

00802022 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802022:	b8 00 00 00 00       	mov    $0x0,%eax
  802027:	c3                   	ret    

00802028 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802028:	55                   	push   %ebp
  802029:	89 e5                	mov    %esp,%ebp
  80202b:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80202e:	68 67 2b 80 00       	push   $0x802b67
  802033:	ff 75 0c             	pushl  0xc(%ebp)
  802036:	e8 55 e9 ff ff       	call   800990 <strcpy>
	return 0;
}
  80203b:	b8 00 00 00 00       	mov    $0x0,%eax
  802040:	c9                   	leave  
  802041:	c3                   	ret    

00802042 <devcons_write>:
{
  802042:	55                   	push   %ebp
  802043:	89 e5                	mov    %esp,%ebp
  802045:	57                   	push   %edi
  802046:	56                   	push   %esi
  802047:	53                   	push   %ebx
  802048:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80204e:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802053:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802059:	3b 75 10             	cmp    0x10(%ebp),%esi
  80205c:	73 31                	jae    80208f <devcons_write+0x4d>
		m = n - tot;
  80205e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802061:	29 f3                	sub    %esi,%ebx
  802063:	83 fb 7f             	cmp    $0x7f,%ebx
  802066:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80206b:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80206e:	83 ec 04             	sub    $0x4,%esp
  802071:	53                   	push   %ebx
  802072:	89 f0                	mov    %esi,%eax
  802074:	03 45 0c             	add    0xc(%ebp),%eax
  802077:	50                   	push   %eax
  802078:	57                   	push   %edi
  802079:	e8 a0 ea ff ff       	call   800b1e <memmove>
		sys_cputs(buf, m);
  80207e:	83 c4 08             	add    $0x8,%esp
  802081:	53                   	push   %ebx
  802082:	57                   	push   %edi
  802083:	e8 3e ec ff ff       	call   800cc6 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802088:	01 de                	add    %ebx,%esi
  80208a:	83 c4 10             	add    $0x10,%esp
  80208d:	eb ca                	jmp    802059 <devcons_write+0x17>
}
  80208f:	89 f0                	mov    %esi,%eax
  802091:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802094:	5b                   	pop    %ebx
  802095:	5e                   	pop    %esi
  802096:	5f                   	pop    %edi
  802097:	5d                   	pop    %ebp
  802098:	c3                   	ret    

00802099 <devcons_read>:
{
  802099:	55                   	push   %ebp
  80209a:	89 e5                	mov    %esp,%ebp
  80209c:	83 ec 08             	sub    $0x8,%esp
  80209f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8020a4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020a8:	74 21                	je     8020cb <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8020aa:	e8 35 ec ff ff       	call   800ce4 <sys_cgetc>
  8020af:	85 c0                	test   %eax,%eax
  8020b1:	75 07                	jne    8020ba <devcons_read+0x21>
		sys_yield();
  8020b3:	e8 ab ec ff ff       	call   800d63 <sys_yield>
  8020b8:	eb f0                	jmp    8020aa <devcons_read+0x11>
	if (c < 0)
  8020ba:	78 0f                	js     8020cb <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8020bc:	83 f8 04             	cmp    $0x4,%eax
  8020bf:	74 0c                	je     8020cd <devcons_read+0x34>
	*(char*)vbuf = c;
  8020c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020c4:	88 02                	mov    %al,(%edx)
	return 1;
  8020c6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8020cb:	c9                   	leave  
  8020cc:	c3                   	ret    
		return 0;
  8020cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8020d2:	eb f7                	jmp    8020cb <devcons_read+0x32>

008020d4 <cputchar>:
{
  8020d4:	55                   	push   %ebp
  8020d5:	89 e5                	mov    %esp,%ebp
  8020d7:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8020da:	8b 45 08             	mov    0x8(%ebp),%eax
  8020dd:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8020e0:	6a 01                	push   $0x1
  8020e2:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020e5:	50                   	push   %eax
  8020e6:	e8 db eb ff ff       	call   800cc6 <sys_cputs>
}
  8020eb:	83 c4 10             	add    $0x10,%esp
  8020ee:	c9                   	leave  
  8020ef:	c3                   	ret    

008020f0 <getchar>:
{
  8020f0:	55                   	push   %ebp
  8020f1:	89 e5                	mov    %esp,%ebp
  8020f3:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8020f6:	6a 01                	push   $0x1
  8020f8:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020fb:	50                   	push   %eax
  8020fc:	6a 00                	push   $0x0
  8020fe:	e8 95 f1 ff ff       	call   801298 <read>
	if (r < 0)
  802103:	83 c4 10             	add    $0x10,%esp
  802106:	85 c0                	test   %eax,%eax
  802108:	78 06                	js     802110 <getchar+0x20>
	if (r < 1)
  80210a:	74 06                	je     802112 <getchar+0x22>
	return c;
  80210c:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802110:	c9                   	leave  
  802111:	c3                   	ret    
		return -E_EOF;
  802112:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802117:	eb f7                	jmp    802110 <getchar+0x20>

00802119 <iscons>:
{
  802119:	55                   	push   %ebp
  80211a:	89 e5                	mov    %esp,%ebp
  80211c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80211f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802122:	50                   	push   %eax
  802123:	ff 75 08             	pushl  0x8(%ebp)
  802126:	e8 02 ef ff ff       	call   80102d <fd_lookup>
  80212b:	83 c4 10             	add    $0x10,%esp
  80212e:	85 c0                	test   %eax,%eax
  802130:	78 11                	js     802143 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802132:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802135:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80213b:	39 10                	cmp    %edx,(%eax)
  80213d:	0f 94 c0             	sete   %al
  802140:	0f b6 c0             	movzbl %al,%eax
}
  802143:	c9                   	leave  
  802144:	c3                   	ret    

00802145 <opencons>:
{
  802145:	55                   	push   %ebp
  802146:	89 e5                	mov    %esp,%ebp
  802148:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80214b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80214e:	50                   	push   %eax
  80214f:	e8 87 ee ff ff       	call   800fdb <fd_alloc>
  802154:	83 c4 10             	add    $0x10,%esp
  802157:	85 c0                	test   %eax,%eax
  802159:	78 3a                	js     802195 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80215b:	83 ec 04             	sub    $0x4,%esp
  80215e:	68 07 04 00 00       	push   $0x407
  802163:	ff 75 f4             	pushl  -0xc(%ebp)
  802166:	6a 00                	push   $0x0
  802168:	e8 15 ec ff ff       	call   800d82 <sys_page_alloc>
  80216d:	83 c4 10             	add    $0x10,%esp
  802170:	85 c0                	test   %eax,%eax
  802172:	78 21                	js     802195 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802174:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802177:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80217d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80217f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802182:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802189:	83 ec 0c             	sub    $0xc,%esp
  80218c:	50                   	push   %eax
  80218d:	e8 22 ee ff ff       	call   800fb4 <fd2num>
  802192:	83 c4 10             	add    $0x10,%esp
}
  802195:	c9                   	leave  
  802196:	c3                   	ret    

00802197 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802197:	55                   	push   %ebp
  802198:	89 e5                	mov    %esp,%ebp
  80219a:	56                   	push   %esi
  80219b:	53                   	push   %ebx
  80219c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80219f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021a2:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// return 0;
	if(!pg)
  8021a5:	85 c0                	test   %eax,%eax
		pg = (void*)UTOP;
  8021a7:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8021ac:	0f 44 c2             	cmove  %edx,%eax
	
	int ret;

	ret = sys_ipc_recv(pg);
  8021af:	83 ec 0c             	sub    $0xc,%esp
  8021b2:	50                   	push   %eax
  8021b3:	e8 7a ed ff ff       	call   800f32 <sys_ipc_recv>
	if(ret < 0){
  8021b8:	83 c4 10             	add    $0x10,%esp
  8021bb:	85 c0                	test   %eax,%eax
  8021bd:	78 2b                	js     8021ea <ipc_recv+0x53>
		if(perm_store) *perm_store = 0;
		if(from_env_store) *from_env_store = 0;
		return ret;
	}
	
	if(perm_store)
  8021bf:	85 f6                	test   %esi,%esi
  8021c1:	74 0a                	je     8021cd <ipc_recv+0x36>
		*perm_store = thisenv->env_ipc_perm;
  8021c3:	a1 04 40 80 00       	mov    0x804004,%eax
  8021c8:	8b 40 78             	mov    0x78(%eax),%eax
  8021cb:	89 06                	mov    %eax,(%esi)
	if(from_env_store)
  8021cd:	85 db                	test   %ebx,%ebx
  8021cf:	74 0a                	je     8021db <ipc_recv+0x44>
		*from_env_store = thisenv->env_ipc_from;
  8021d1:	a1 04 40 80 00       	mov    0x804004,%eax
  8021d6:	8b 40 74             	mov    0x74(%eax),%eax
  8021d9:	89 03                	mov    %eax,(%ebx)

	return thisenv->env_ipc_value;
  8021db:	a1 04 40 80 00       	mov    0x804004,%eax
  8021e0:	8b 40 70             	mov    0x70(%eax),%eax
}
  8021e3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021e6:	5b                   	pop    %ebx
  8021e7:	5e                   	pop    %esi
  8021e8:	5d                   	pop    %ebp
  8021e9:	c3                   	ret    
		if(perm_store) *perm_store = 0;
  8021ea:	85 f6                	test   %esi,%esi
  8021ec:	74 06                	je     8021f4 <ipc_recv+0x5d>
  8021ee:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(from_env_store) *from_env_store = 0;
  8021f4:	85 db                	test   %ebx,%ebx
  8021f6:	74 eb                	je     8021e3 <ipc_recv+0x4c>
  8021f8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8021fe:	eb e3                	jmp    8021e3 <ipc_recv+0x4c>

00802200 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802200:	55                   	push   %ebp
  802201:	89 e5                	mov    %esp,%ebp
  802203:	57                   	push   %edi
  802204:	56                   	push   %esi
  802205:	53                   	push   %ebx
  802206:	83 ec 0c             	sub    $0xc,%esp
  802209:	8b 7d 08             	mov    0x8(%ebp),%edi
  80220c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80220f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
	if (!pg)
  802212:	85 db                	test   %ebx,%ebx
		pg = (void*)UTOP;
  802214:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802219:	0f 44 d8             	cmove  %eax,%ebx

	int ret = -E_IPC_NOT_RECV;
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))) {
  80221c:	ff 75 14             	pushl  0x14(%ebp)
  80221f:	53                   	push   %ebx
  802220:	56                   	push   %esi
  802221:	57                   	push   %edi
  802222:	e8 e8 ec ff ff       	call   800f0f <sys_ipc_try_send>
  802227:	83 c4 10             	add    $0x10,%esp
  80222a:	85 c0                	test   %eax,%eax
  80222c:	74 17                	je     802245 <ipc_send+0x45>
		if(ret != -E_IPC_NOT_RECV){
  80222e:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802231:	74 e9                	je     80221c <ipc_send+0x1c>
			panic("ipc_send: ret : %d", ret);
  802233:	50                   	push   %eax
  802234:	68 73 2b 80 00       	push   $0x802b73
  802239:	6a 43                	push   $0x43
  80223b:	68 86 2b 80 00       	push   $0x802b86
  802240:	e8 4a df ff ff       	call   80018f <_panic>
			sys_yield();
		}
	}
}
  802245:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802248:	5b                   	pop    %ebx
  802249:	5e                   	pop    %esi
  80224a:	5f                   	pop    %edi
  80224b:	5d                   	pop    %ebp
  80224c:	c3                   	ret    

0080224d <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80224d:	55                   	push   %ebp
  80224e:	89 e5                	mov    %esp,%ebp
  802250:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802253:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802258:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  80225e:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802264:	8b 52 50             	mov    0x50(%edx),%edx
  802267:	39 ca                	cmp    %ecx,%edx
  802269:	74 11                	je     80227c <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  80226b:	83 c0 01             	add    $0x1,%eax
  80226e:	3d 00 04 00 00       	cmp    $0x400,%eax
  802273:	75 e3                	jne    802258 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802275:	b8 00 00 00 00       	mov    $0x0,%eax
  80227a:	eb 0e                	jmp    80228a <ipc_find_env+0x3d>
			return envs[i].env_id;
  80227c:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  802282:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802287:	8b 40 48             	mov    0x48(%eax),%eax
}
  80228a:	5d                   	pop    %ebp
  80228b:	c3                   	ret    

0080228c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80228c:	55                   	push   %ebp
  80228d:	89 e5                	mov    %esp,%ebp
  80228f:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802292:	89 d0                	mov    %edx,%eax
  802294:	c1 e8 16             	shr    $0x16,%eax
  802297:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80229e:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8022a3:	f6 c1 01             	test   $0x1,%cl
  8022a6:	74 1d                	je     8022c5 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8022a8:	c1 ea 0c             	shr    $0xc,%edx
  8022ab:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8022b2:	f6 c2 01             	test   $0x1,%dl
  8022b5:	74 0e                	je     8022c5 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8022b7:	c1 ea 0c             	shr    $0xc,%edx
  8022ba:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8022c1:	ef 
  8022c2:	0f b7 c0             	movzwl %ax,%eax
}
  8022c5:	5d                   	pop    %ebp
  8022c6:	c3                   	ret    
  8022c7:	66 90                	xchg   %ax,%ax
  8022c9:	66 90                	xchg   %ax,%ax
  8022cb:	66 90                	xchg   %ax,%ax
  8022cd:	66 90                	xchg   %ax,%ax
  8022cf:	90                   	nop

008022d0 <__udivdi3>:
  8022d0:	55                   	push   %ebp
  8022d1:	57                   	push   %edi
  8022d2:	56                   	push   %esi
  8022d3:	53                   	push   %ebx
  8022d4:	83 ec 1c             	sub    $0x1c,%esp
  8022d7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8022db:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8022df:	8b 74 24 34          	mov    0x34(%esp),%esi
  8022e3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8022e7:	85 d2                	test   %edx,%edx
  8022e9:	75 4d                	jne    802338 <__udivdi3+0x68>
  8022eb:	39 f3                	cmp    %esi,%ebx
  8022ed:	76 19                	jbe    802308 <__udivdi3+0x38>
  8022ef:	31 ff                	xor    %edi,%edi
  8022f1:	89 e8                	mov    %ebp,%eax
  8022f3:	89 f2                	mov    %esi,%edx
  8022f5:	f7 f3                	div    %ebx
  8022f7:	89 fa                	mov    %edi,%edx
  8022f9:	83 c4 1c             	add    $0x1c,%esp
  8022fc:	5b                   	pop    %ebx
  8022fd:	5e                   	pop    %esi
  8022fe:	5f                   	pop    %edi
  8022ff:	5d                   	pop    %ebp
  802300:	c3                   	ret    
  802301:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802308:	89 d9                	mov    %ebx,%ecx
  80230a:	85 db                	test   %ebx,%ebx
  80230c:	75 0b                	jne    802319 <__udivdi3+0x49>
  80230e:	b8 01 00 00 00       	mov    $0x1,%eax
  802313:	31 d2                	xor    %edx,%edx
  802315:	f7 f3                	div    %ebx
  802317:	89 c1                	mov    %eax,%ecx
  802319:	31 d2                	xor    %edx,%edx
  80231b:	89 f0                	mov    %esi,%eax
  80231d:	f7 f1                	div    %ecx
  80231f:	89 c6                	mov    %eax,%esi
  802321:	89 e8                	mov    %ebp,%eax
  802323:	89 f7                	mov    %esi,%edi
  802325:	f7 f1                	div    %ecx
  802327:	89 fa                	mov    %edi,%edx
  802329:	83 c4 1c             	add    $0x1c,%esp
  80232c:	5b                   	pop    %ebx
  80232d:	5e                   	pop    %esi
  80232e:	5f                   	pop    %edi
  80232f:	5d                   	pop    %ebp
  802330:	c3                   	ret    
  802331:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802338:	39 f2                	cmp    %esi,%edx
  80233a:	77 1c                	ja     802358 <__udivdi3+0x88>
  80233c:	0f bd fa             	bsr    %edx,%edi
  80233f:	83 f7 1f             	xor    $0x1f,%edi
  802342:	75 2c                	jne    802370 <__udivdi3+0xa0>
  802344:	39 f2                	cmp    %esi,%edx
  802346:	72 06                	jb     80234e <__udivdi3+0x7e>
  802348:	31 c0                	xor    %eax,%eax
  80234a:	39 eb                	cmp    %ebp,%ebx
  80234c:	77 a9                	ja     8022f7 <__udivdi3+0x27>
  80234e:	b8 01 00 00 00       	mov    $0x1,%eax
  802353:	eb a2                	jmp    8022f7 <__udivdi3+0x27>
  802355:	8d 76 00             	lea    0x0(%esi),%esi
  802358:	31 ff                	xor    %edi,%edi
  80235a:	31 c0                	xor    %eax,%eax
  80235c:	89 fa                	mov    %edi,%edx
  80235e:	83 c4 1c             	add    $0x1c,%esp
  802361:	5b                   	pop    %ebx
  802362:	5e                   	pop    %esi
  802363:	5f                   	pop    %edi
  802364:	5d                   	pop    %ebp
  802365:	c3                   	ret    
  802366:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80236d:	8d 76 00             	lea    0x0(%esi),%esi
  802370:	89 f9                	mov    %edi,%ecx
  802372:	b8 20 00 00 00       	mov    $0x20,%eax
  802377:	29 f8                	sub    %edi,%eax
  802379:	d3 e2                	shl    %cl,%edx
  80237b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80237f:	89 c1                	mov    %eax,%ecx
  802381:	89 da                	mov    %ebx,%edx
  802383:	d3 ea                	shr    %cl,%edx
  802385:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802389:	09 d1                	or     %edx,%ecx
  80238b:	89 f2                	mov    %esi,%edx
  80238d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802391:	89 f9                	mov    %edi,%ecx
  802393:	d3 e3                	shl    %cl,%ebx
  802395:	89 c1                	mov    %eax,%ecx
  802397:	d3 ea                	shr    %cl,%edx
  802399:	89 f9                	mov    %edi,%ecx
  80239b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80239f:	89 eb                	mov    %ebp,%ebx
  8023a1:	d3 e6                	shl    %cl,%esi
  8023a3:	89 c1                	mov    %eax,%ecx
  8023a5:	d3 eb                	shr    %cl,%ebx
  8023a7:	09 de                	or     %ebx,%esi
  8023a9:	89 f0                	mov    %esi,%eax
  8023ab:	f7 74 24 08          	divl   0x8(%esp)
  8023af:	89 d6                	mov    %edx,%esi
  8023b1:	89 c3                	mov    %eax,%ebx
  8023b3:	f7 64 24 0c          	mull   0xc(%esp)
  8023b7:	39 d6                	cmp    %edx,%esi
  8023b9:	72 15                	jb     8023d0 <__udivdi3+0x100>
  8023bb:	89 f9                	mov    %edi,%ecx
  8023bd:	d3 e5                	shl    %cl,%ebp
  8023bf:	39 c5                	cmp    %eax,%ebp
  8023c1:	73 04                	jae    8023c7 <__udivdi3+0xf7>
  8023c3:	39 d6                	cmp    %edx,%esi
  8023c5:	74 09                	je     8023d0 <__udivdi3+0x100>
  8023c7:	89 d8                	mov    %ebx,%eax
  8023c9:	31 ff                	xor    %edi,%edi
  8023cb:	e9 27 ff ff ff       	jmp    8022f7 <__udivdi3+0x27>
  8023d0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8023d3:	31 ff                	xor    %edi,%edi
  8023d5:	e9 1d ff ff ff       	jmp    8022f7 <__udivdi3+0x27>
  8023da:	66 90                	xchg   %ax,%ax
  8023dc:	66 90                	xchg   %ax,%ax
  8023de:	66 90                	xchg   %ax,%ax

008023e0 <__umoddi3>:
  8023e0:	55                   	push   %ebp
  8023e1:	57                   	push   %edi
  8023e2:	56                   	push   %esi
  8023e3:	53                   	push   %ebx
  8023e4:	83 ec 1c             	sub    $0x1c,%esp
  8023e7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8023eb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8023ef:	8b 74 24 30          	mov    0x30(%esp),%esi
  8023f3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8023f7:	89 da                	mov    %ebx,%edx
  8023f9:	85 c0                	test   %eax,%eax
  8023fb:	75 43                	jne    802440 <__umoddi3+0x60>
  8023fd:	39 df                	cmp    %ebx,%edi
  8023ff:	76 17                	jbe    802418 <__umoddi3+0x38>
  802401:	89 f0                	mov    %esi,%eax
  802403:	f7 f7                	div    %edi
  802405:	89 d0                	mov    %edx,%eax
  802407:	31 d2                	xor    %edx,%edx
  802409:	83 c4 1c             	add    $0x1c,%esp
  80240c:	5b                   	pop    %ebx
  80240d:	5e                   	pop    %esi
  80240e:	5f                   	pop    %edi
  80240f:	5d                   	pop    %ebp
  802410:	c3                   	ret    
  802411:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802418:	89 fd                	mov    %edi,%ebp
  80241a:	85 ff                	test   %edi,%edi
  80241c:	75 0b                	jne    802429 <__umoddi3+0x49>
  80241e:	b8 01 00 00 00       	mov    $0x1,%eax
  802423:	31 d2                	xor    %edx,%edx
  802425:	f7 f7                	div    %edi
  802427:	89 c5                	mov    %eax,%ebp
  802429:	89 d8                	mov    %ebx,%eax
  80242b:	31 d2                	xor    %edx,%edx
  80242d:	f7 f5                	div    %ebp
  80242f:	89 f0                	mov    %esi,%eax
  802431:	f7 f5                	div    %ebp
  802433:	89 d0                	mov    %edx,%eax
  802435:	eb d0                	jmp    802407 <__umoddi3+0x27>
  802437:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80243e:	66 90                	xchg   %ax,%ax
  802440:	89 f1                	mov    %esi,%ecx
  802442:	39 d8                	cmp    %ebx,%eax
  802444:	76 0a                	jbe    802450 <__umoddi3+0x70>
  802446:	89 f0                	mov    %esi,%eax
  802448:	83 c4 1c             	add    $0x1c,%esp
  80244b:	5b                   	pop    %ebx
  80244c:	5e                   	pop    %esi
  80244d:	5f                   	pop    %edi
  80244e:	5d                   	pop    %ebp
  80244f:	c3                   	ret    
  802450:	0f bd e8             	bsr    %eax,%ebp
  802453:	83 f5 1f             	xor    $0x1f,%ebp
  802456:	75 20                	jne    802478 <__umoddi3+0x98>
  802458:	39 d8                	cmp    %ebx,%eax
  80245a:	0f 82 b0 00 00 00    	jb     802510 <__umoddi3+0x130>
  802460:	39 f7                	cmp    %esi,%edi
  802462:	0f 86 a8 00 00 00    	jbe    802510 <__umoddi3+0x130>
  802468:	89 c8                	mov    %ecx,%eax
  80246a:	83 c4 1c             	add    $0x1c,%esp
  80246d:	5b                   	pop    %ebx
  80246e:	5e                   	pop    %esi
  80246f:	5f                   	pop    %edi
  802470:	5d                   	pop    %ebp
  802471:	c3                   	ret    
  802472:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802478:	89 e9                	mov    %ebp,%ecx
  80247a:	ba 20 00 00 00       	mov    $0x20,%edx
  80247f:	29 ea                	sub    %ebp,%edx
  802481:	d3 e0                	shl    %cl,%eax
  802483:	89 44 24 08          	mov    %eax,0x8(%esp)
  802487:	89 d1                	mov    %edx,%ecx
  802489:	89 f8                	mov    %edi,%eax
  80248b:	d3 e8                	shr    %cl,%eax
  80248d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802491:	89 54 24 04          	mov    %edx,0x4(%esp)
  802495:	8b 54 24 04          	mov    0x4(%esp),%edx
  802499:	09 c1                	or     %eax,%ecx
  80249b:	89 d8                	mov    %ebx,%eax
  80249d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8024a1:	89 e9                	mov    %ebp,%ecx
  8024a3:	d3 e7                	shl    %cl,%edi
  8024a5:	89 d1                	mov    %edx,%ecx
  8024a7:	d3 e8                	shr    %cl,%eax
  8024a9:	89 e9                	mov    %ebp,%ecx
  8024ab:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8024af:	d3 e3                	shl    %cl,%ebx
  8024b1:	89 c7                	mov    %eax,%edi
  8024b3:	89 d1                	mov    %edx,%ecx
  8024b5:	89 f0                	mov    %esi,%eax
  8024b7:	d3 e8                	shr    %cl,%eax
  8024b9:	89 e9                	mov    %ebp,%ecx
  8024bb:	89 fa                	mov    %edi,%edx
  8024bd:	d3 e6                	shl    %cl,%esi
  8024bf:	09 d8                	or     %ebx,%eax
  8024c1:	f7 74 24 08          	divl   0x8(%esp)
  8024c5:	89 d1                	mov    %edx,%ecx
  8024c7:	89 f3                	mov    %esi,%ebx
  8024c9:	f7 64 24 0c          	mull   0xc(%esp)
  8024cd:	89 c6                	mov    %eax,%esi
  8024cf:	89 d7                	mov    %edx,%edi
  8024d1:	39 d1                	cmp    %edx,%ecx
  8024d3:	72 06                	jb     8024db <__umoddi3+0xfb>
  8024d5:	75 10                	jne    8024e7 <__umoddi3+0x107>
  8024d7:	39 c3                	cmp    %eax,%ebx
  8024d9:	73 0c                	jae    8024e7 <__umoddi3+0x107>
  8024db:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8024df:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8024e3:	89 d7                	mov    %edx,%edi
  8024e5:	89 c6                	mov    %eax,%esi
  8024e7:	89 ca                	mov    %ecx,%edx
  8024e9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8024ee:	29 f3                	sub    %esi,%ebx
  8024f0:	19 fa                	sbb    %edi,%edx
  8024f2:	89 d0                	mov    %edx,%eax
  8024f4:	d3 e0                	shl    %cl,%eax
  8024f6:	89 e9                	mov    %ebp,%ecx
  8024f8:	d3 eb                	shr    %cl,%ebx
  8024fa:	d3 ea                	shr    %cl,%edx
  8024fc:	09 d8                	or     %ebx,%eax
  8024fe:	83 c4 1c             	add    $0x1c,%esp
  802501:	5b                   	pop    %ebx
  802502:	5e                   	pop    %esi
  802503:	5f                   	pop    %edi
  802504:	5d                   	pop    %ebp
  802505:	c3                   	ret    
  802506:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80250d:	8d 76 00             	lea    0x0(%esi),%esi
  802510:	89 da                	mov    %ebx,%edx
  802512:	29 fe                	sub    %edi,%esi
  802514:	19 c2                	sbb    %eax,%edx
  802516:	89 f1                	mov    %esi,%ecx
  802518:	89 c8                	mov    %ecx,%eax
  80251a:	e9 4b ff ff ff       	jmp    80246a <__umoddi3+0x8a>
