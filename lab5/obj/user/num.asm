
obj/user/num.debug:     file format elf32-i386


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
  80002c:	e8 50 01 00 00       	call   800181 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <num>:
int bol = 1;
int line = 0;

void
num(int f, const char *s)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	83 ec 10             	sub    $0x10,%esp
  80003b:	8b 75 08             	mov    0x8(%ebp),%esi
	long n;
	int r;
	char c;

	while ((n = read(f, &c, 1)) > 0) {
  80003e:	8d 5d f7             	lea    -0x9(%ebp),%ebx
  800041:	eb 43                	jmp    800086 <num+0x53>
		if (bol) {
			printf("%5d ", ++line);
  800043:	a1 00 40 80 00       	mov    0x804000,%eax
  800048:	83 c0 01             	add    $0x1,%eax
  80004b:	a3 00 40 80 00       	mov    %eax,0x804000
  800050:	83 ec 08             	sub    $0x8,%esp
  800053:	50                   	push   %eax
  800054:	68 20 21 80 00       	push   $0x802120
  800059:	e8 61 18 00 00       	call   8018bf <printf>
			bol = 0;
  80005e:	c7 05 00 30 80 00 00 	movl   $0x0,0x803000
  800065:	00 00 00 
  800068:	83 c4 10             	add    $0x10,%esp
		}
		if ((r = write(1, &c, 1)) != 1)
  80006b:	83 ec 04             	sub    $0x4,%esp
  80006e:	6a 01                	push   $0x1
  800070:	53                   	push   %ebx
  800071:	6a 01                	push   $0x1
  800073:	e8 39 13 00 00       	call   8013b1 <write>
  800078:	83 c4 10             	add    $0x10,%esp
  80007b:	83 f8 01             	cmp    $0x1,%eax
  80007e:	75 24                	jne    8000a4 <num+0x71>
			panic("write error copying %s: %e", s, r);
		if (c == '\n')
  800080:	80 7d f7 0a          	cmpb   $0xa,-0x9(%ebp)
  800084:	74 36                	je     8000bc <num+0x89>
	while ((n = read(f, &c, 1)) > 0) {
  800086:	83 ec 04             	sub    $0x4,%esp
  800089:	6a 01                	push   $0x1
  80008b:	53                   	push   %ebx
  80008c:	56                   	push   %esi
  80008d:	e8 53 12 00 00       	call   8012e5 <read>
  800092:	83 c4 10             	add    $0x10,%esp
  800095:	85 c0                	test   %eax,%eax
  800097:	7e 2f                	jle    8000c8 <num+0x95>
		if (bol) {
  800099:	83 3d 00 30 80 00 00 	cmpl   $0x0,0x803000
  8000a0:	74 c9                	je     80006b <num+0x38>
  8000a2:	eb 9f                	jmp    800043 <num+0x10>
			panic("write error copying %s: %e", s, r);
  8000a4:	83 ec 0c             	sub    $0xc,%esp
  8000a7:	50                   	push   %eax
  8000a8:	ff 75 0c             	pushl  0xc(%ebp)
  8000ab:	68 25 21 80 00       	push   $0x802125
  8000b0:	6a 13                	push   $0x13
  8000b2:	68 40 21 80 00       	push   $0x802140
  8000b7:	e8 20 01 00 00       	call   8001dc <_panic>
			bol = 1;
  8000bc:	c7 05 00 30 80 00 01 	movl   $0x1,0x803000
  8000c3:	00 00 00 
  8000c6:	eb be                	jmp    800086 <num+0x53>
	}
	if (n < 0)
  8000c8:	78 07                	js     8000d1 <num+0x9e>
		panic("error reading %s: %e", s, n);
}
  8000ca:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000cd:	5b                   	pop    %ebx
  8000ce:	5e                   	pop    %esi
  8000cf:	5d                   	pop    %ebp
  8000d0:	c3                   	ret    
		panic("error reading %s: %e", s, n);
  8000d1:	83 ec 0c             	sub    $0xc,%esp
  8000d4:	50                   	push   %eax
  8000d5:	ff 75 0c             	pushl  0xc(%ebp)
  8000d8:	68 4b 21 80 00       	push   $0x80214b
  8000dd:	6a 18                	push   $0x18
  8000df:	68 40 21 80 00       	push   $0x802140
  8000e4:	e8 f3 00 00 00       	call   8001dc <_panic>

008000e9 <umain>:

void
umain(int argc, char **argv)
{
  8000e9:	55                   	push   %ebp
  8000ea:	89 e5                	mov    %esp,%ebp
  8000ec:	57                   	push   %edi
  8000ed:	56                   	push   %esi
  8000ee:	53                   	push   %ebx
  8000ef:	83 ec 1c             	sub    $0x1c,%esp
	int f, i;

	binaryname = "num";
  8000f2:	c7 05 04 30 80 00 60 	movl   $0x802160,0x803004
  8000f9:	21 80 00 
	if (argc == 1)
  8000fc:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  800100:	74 46                	je     800148 <umain+0x5f>
  800102:	8b 45 0c             	mov    0xc(%ebp),%eax
  800105:	8d 58 04             	lea    0x4(%eax),%ebx
		num(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  800108:	bf 01 00 00 00       	mov    $0x1,%edi
  80010d:	3b 7d 08             	cmp    0x8(%ebp),%edi
  800110:	7d 48                	jge    80015a <umain+0x71>
			f = open(argv[i], O_RDONLY);
  800112:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800115:	83 ec 08             	sub    $0x8,%esp
  800118:	6a 00                	push   $0x0
  80011a:	ff 33                	pushl  (%ebx)
  80011c:	e8 fb 15 00 00       	call   80171c <open>
  800121:	89 c6                	mov    %eax,%esi
			if (f < 0)
  800123:	83 c4 10             	add    $0x10,%esp
  800126:	85 c0                	test   %eax,%eax
  800128:	78 3d                	js     800167 <umain+0x7e>
				panic("can't open %s: %e", argv[i], f);
			else {
				num(f, argv[i]);
  80012a:	83 ec 08             	sub    $0x8,%esp
  80012d:	ff 33                	pushl  (%ebx)
  80012f:	50                   	push   %eax
  800130:	e8 fe fe ff ff       	call   800033 <num>
				close(f);
  800135:	89 34 24             	mov    %esi,(%esp)
  800138:	e8 6a 10 00 00       	call   8011a7 <close>
		for (i = 1; i < argc; i++) {
  80013d:	83 c7 01             	add    $0x1,%edi
  800140:	83 c3 04             	add    $0x4,%ebx
  800143:	83 c4 10             	add    $0x10,%esp
  800146:	eb c5                	jmp    80010d <umain+0x24>
		num(0, "<stdin>");
  800148:	83 ec 08             	sub    $0x8,%esp
  80014b:	68 64 21 80 00       	push   $0x802164
  800150:	6a 00                	push   $0x0
  800152:	e8 dc fe ff ff       	call   800033 <num>
  800157:	83 c4 10             	add    $0x10,%esp
			}
		}
	exit();
  80015a:	e8 6b 00 00 00       	call   8001ca <exit>
}
  80015f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800162:	5b                   	pop    %ebx
  800163:	5e                   	pop    %esi
  800164:	5f                   	pop    %edi
  800165:	5d                   	pop    %ebp
  800166:	c3                   	ret    
				panic("can't open %s: %e", argv[i], f);
  800167:	83 ec 0c             	sub    $0xc,%esp
  80016a:	50                   	push   %eax
  80016b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80016e:	ff 30                	pushl  (%eax)
  800170:	68 6c 21 80 00       	push   $0x80216c
  800175:	6a 27                	push   $0x27
  800177:	68 40 21 80 00       	push   $0x802140
  80017c:	e8 5b 00 00 00       	call   8001dc <_panic>

00800181 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800181:	55                   	push   %ebp
  800182:	89 e5                	mov    %esp,%ebp
  800184:	56                   	push   %esi
  800185:	53                   	push   %ebx
  800186:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800189:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	// thisenv = 0;
	thisenv = &(envs[ENVX(sys_getenvid())]);
  80018c:	e8 00 0c 00 00       	call   800d91 <sys_getenvid>
  800191:	25 ff 03 00 00       	and    $0x3ff,%eax
  800196:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80019c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001a1:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001a6:	85 db                	test   %ebx,%ebx
  8001a8:	7e 07                	jle    8001b1 <libmain+0x30>
		binaryname = argv[0];
  8001aa:	8b 06                	mov    (%esi),%eax
  8001ac:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	umain(argc, argv);
  8001b1:	83 ec 08             	sub    $0x8,%esp
  8001b4:	56                   	push   %esi
  8001b5:	53                   	push   %ebx
  8001b6:	e8 2e ff ff ff       	call   8000e9 <umain>

	// exit gracefully
	exit();
  8001bb:	e8 0a 00 00 00       	call   8001ca <exit>
}
  8001c0:	83 c4 10             	add    $0x10,%esp
  8001c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001c6:	5b                   	pop    %ebx
  8001c7:	5e                   	pop    %esi
  8001c8:	5d                   	pop    %ebp
  8001c9:	c3                   	ret    

008001ca <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001ca:	55                   	push   %ebp
  8001cb:	89 e5                	mov    %esp,%ebp
  8001cd:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  8001d0:	6a 00                	push   $0x0
  8001d2:	e8 79 0b 00 00       	call   800d50 <sys_env_destroy>
}
  8001d7:	83 c4 10             	add    $0x10,%esp
  8001da:	c9                   	leave  
  8001db:	c3                   	ret    

008001dc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001dc:	55                   	push   %ebp
  8001dd:	89 e5                	mov    %esp,%ebp
  8001df:	56                   	push   %esi
  8001e0:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8001e1:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001e4:	8b 35 04 30 80 00    	mov    0x803004,%esi
  8001ea:	e8 a2 0b 00 00       	call   800d91 <sys_getenvid>
  8001ef:	83 ec 0c             	sub    $0xc,%esp
  8001f2:	ff 75 0c             	pushl  0xc(%ebp)
  8001f5:	ff 75 08             	pushl  0x8(%ebp)
  8001f8:	56                   	push   %esi
  8001f9:	50                   	push   %eax
  8001fa:	68 88 21 80 00       	push   $0x802188
  8001ff:	e8 b3 00 00 00       	call   8002b7 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800204:	83 c4 18             	add    $0x18,%esp
  800207:	53                   	push   %ebx
  800208:	ff 75 10             	pushl  0x10(%ebp)
  80020b:	e8 56 00 00 00       	call   800266 <vcprintf>
	cprintf("\n");
  800210:	c7 04 24 45 26 80 00 	movl   $0x802645,(%esp)
  800217:	e8 9b 00 00 00       	call   8002b7 <cprintf>
  80021c:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80021f:	cc                   	int3   
  800220:	eb fd                	jmp    80021f <_panic+0x43>

00800222 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800222:	55                   	push   %ebp
  800223:	89 e5                	mov    %esp,%ebp
  800225:	53                   	push   %ebx
  800226:	83 ec 04             	sub    $0x4,%esp
  800229:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80022c:	8b 13                	mov    (%ebx),%edx
  80022e:	8d 42 01             	lea    0x1(%edx),%eax
  800231:	89 03                	mov    %eax,(%ebx)
  800233:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800236:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80023a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80023f:	74 09                	je     80024a <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800241:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800245:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800248:	c9                   	leave  
  800249:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80024a:	83 ec 08             	sub    $0x8,%esp
  80024d:	68 ff 00 00 00       	push   $0xff
  800252:	8d 43 08             	lea    0x8(%ebx),%eax
  800255:	50                   	push   %eax
  800256:	e8 b8 0a 00 00       	call   800d13 <sys_cputs>
		b->idx = 0;
  80025b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800261:	83 c4 10             	add    $0x10,%esp
  800264:	eb db                	jmp    800241 <putch+0x1f>

00800266 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800266:	55                   	push   %ebp
  800267:	89 e5                	mov    %esp,%ebp
  800269:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80026f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800276:	00 00 00 
	b.cnt = 0;
  800279:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800280:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800283:	ff 75 0c             	pushl  0xc(%ebp)
  800286:	ff 75 08             	pushl  0x8(%ebp)
  800289:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80028f:	50                   	push   %eax
  800290:	68 22 02 80 00       	push   $0x800222
  800295:	e8 4a 01 00 00       	call   8003e4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80029a:	83 c4 08             	add    $0x8,%esp
  80029d:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002a3:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002a9:	50                   	push   %eax
  8002aa:	e8 64 0a 00 00       	call   800d13 <sys_cputs>

	return b.cnt;
}
  8002af:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002b5:	c9                   	leave  
  8002b6:	c3                   	ret    

008002b7 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002b7:	55                   	push   %ebp
  8002b8:	89 e5                	mov    %esp,%ebp
  8002ba:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002bd:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002c0:	50                   	push   %eax
  8002c1:	ff 75 08             	pushl  0x8(%ebp)
  8002c4:	e8 9d ff ff ff       	call   800266 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002c9:	c9                   	leave  
  8002ca:	c3                   	ret    

008002cb <printnum>:


static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002cb:	55                   	push   %ebp
  8002cc:	89 e5                	mov    %esp,%ebp
  8002ce:	57                   	push   %edi
  8002cf:	56                   	push   %esi
  8002d0:	53                   	push   %ebx
  8002d1:	83 ec 1c             	sub    $0x1c,%esp
  8002d4:	89 c6                	mov    %eax,%esi
  8002d6:	89 d7                	mov    %edx,%edi
  8002d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8002db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002de:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002e1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8002e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8002e7:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	// to support '-'
	if(padc == '-'){
  8002ea:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8002ee:	74 2c                	je     80031c <printnum+0x51>
		while (--width > 0)
			putch(' ', putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002f0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002f3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8002fa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002fd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800300:	39 c2                	cmp    %eax,%edx
  800302:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800305:	73 43                	jae    80034a <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800307:	83 eb 01             	sub    $0x1,%ebx
  80030a:	85 db                	test   %ebx,%ebx
  80030c:	7e 6c                	jle    80037a <printnum+0xaf>
			putch(padc, putdat);
  80030e:	83 ec 08             	sub    $0x8,%esp
  800311:	57                   	push   %edi
  800312:	ff 75 18             	pushl  0x18(%ebp)
  800315:	ff d6                	call   *%esi
  800317:	83 c4 10             	add    $0x10,%esp
  80031a:	eb eb                	jmp    800307 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80031c:	83 ec 0c             	sub    $0xc,%esp
  80031f:	6a 20                	push   $0x20
  800321:	6a 00                	push   $0x0
  800323:	50                   	push   %eax
  800324:	ff 75 e4             	pushl  -0x1c(%ebp)
  800327:	ff 75 e0             	pushl  -0x20(%ebp)
  80032a:	89 fa                	mov    %edi,%edx
  80032c:	89 f0                	mov    %esi,%eax
  80032e:	e8 98 ff ff ff       	call   8002cb <printnum>
		while (--width > 0)
  800333:	83 c4 20             	add    $0x20,%esp
  800336:	83 eb 01             	sub    $0x1,%ebx
  800339:	85 db                	test   %ebx,%ebx
  80033b:	7e 65                	jle    8003a2 <printnum+0xd7>
			putch(' ', putdat);
  80033d:	83 ec 08             	sub    $0x8,%esp
  800340:	57                   	push   %edi
  800341:	6a 20                	push   $0x20
  800343:	ff d6                	call   *%esi
  800345:	83 c4 10             	add    $0x10,%esp
  800348:	eb ec                	jmp    800336 <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80034a:	83 ec 0c             	sub    $0xc,%esp
  80034d:	ff 75 18             	pushl  0x18(%ebp)
  800350:	83 eb 01             	sub    $0x1,%ebx
  800353:	53                   	push   %ebx
  800354:	50                   	push   %eax
  800355:	83 ec 08             	sub    $0x8,%esp
  800358:	ff 75 dc             	pushl  -0x24(%ebp)
  80035b:	ff 75 d8             	pushl  -0x28(%ebp)
  80035e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800361:	ff 75 e0             	pushl  -0x20(%ebp)
  800364:	e8 67 1b 00 00       	call   801ed0 <__udivdi3>
  800369:	83 c4 18             	add    $0x18,%esp
  80036c:	52                   	push   %edx
  80036d:	50                   	push   %eax
  80036e:	89 fa                	mov    %edi,%edx
  800370:	89 f0                	mov    %esi,%eax
  800372:	e8 54 ff ff ff       	call   8002cb <printnum>
  800377:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80037a:	83 ec 08             	sub    $0x8,%esp
  80037d:	57                   	push   %edi
  80037e:	83 ec 04             	sub    $0x4,%esp
  800381:	ff 75 dc             	pushl  -0x24(%ebp)
  800384:	ff 75 d8             	pushl  -0x28(%ebp)
  800387:	ff 75 e4             	pushl  -0x1c(%ebp)
  80038a:	ff 75 e0             	pushl  -0x20(%ebp)
  80038d:	e8 4e 1c 00 00       	call   801fe0 <__umoddi3>
  800392:	83 c4 14             	add    $0x14,%esp
  800395:	0f be 80 ab 21 80 00 	movsbl 0x8021ab(%eax),%eax
  80039c:	50                   	push   %eax
  80039d:	ff d6                	call   *%esi
  80039f:	83 c4 10             	add    $0x10,%esp
}
  8003a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003a5:	5b                   	pop    %ebx
  8003a6:	5e                   	pop    %esi
  8003a7:	5f                   	pop    %edi
  8003a8:	5d                   	pop    %ebp
  8003a9:	c3                   	ret    

008003aa <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003aa:	55                   	push   %ebp
  8003ab:	89 e5                	mov    %esp,%ebp
  8003ad:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003b0:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003b4:	8b 10                	mov    (%eax),%edx
  8003b6:	3b 50 04             	cmp    0x4(%eax),%edx
  8003b9:	73 0a                	jae    8003c5 <sprintputch+0x1b>
		*b->buf++ = ch;
  8003bb:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003be:	89 08                	mov    %ecx,(%eax)
  8003c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c3:	88 02                	mov    %al,(%edx)
}
  8003c5:	5d                   	pop    %ebp
  8003c6:	c3                   	ret    

008003c7 <printfmt>:
{
  8003c7:	55                   	push   %ebp
  8003c8:	89 e5                	mov    %esp,%ebp
  8003ca:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003cd:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003d0:	50                   	push   %eax
  8003d1:	ff 75 10             	pushl  0x10(%ebp)
  8003d4:	ff 75 0c             	pushl  0xc(%ebp)
  8003d7:	ff 75 08             	pushl  0x8(%ebp)
  8003da:	e8 05 00 00 00       	call   8003e4 <vprintfmt>
}
  8003df:	83 c4 10             	add    $0x10,%esp
  8003e2:	c9                   	leave  
  8003e3:	c3                   	ret    

008003e4 <vprintfmt>:
{
  8003e4:	55                   	push   %ebp
  8003e5:	89 e5                	mov    %esp,%ebp
  8003e7:	57                   	push   %edi
  8003e8:	56                   	push   %esi
  8003e9:	53                   	push   %ebx
  8003ea:	83 ec 3c             	sub    $0x3c,%esp
  8003ed:	8b 75 08             	mov    0x8(%ebp),%esi
  8003f0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8003f3:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003f6:	e9 1e 04 00 00       	jmp    800819 <vprintfmt+0x435>
		posflag = 0;
  8003fb:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
		padc = ' ';
  800402:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800406:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  80040d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800414:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80041b:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  800422:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800427:	8d 47 01             	lea    0x1(%edi),%eax
  80042a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80042d:	0f b6 17             	movzbl (%edi),%edx
  800430:	8d 42 dd             	lea    -0x23(%edx),%eax
  800433:	3c 55                	cmp    $0x55,%al
  800435:	0f 87 d9 04 00 00    	ja     800914 <vprintfmt+0x530>
  80043b:	0f b6 c0             	movzbl %al,%eax
  80043e:	ff 24 85 80 23 80 00 	jmp    *0x802380(,%eax,4)
  800445:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800448:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80044c:	eb d9                	jmp    800427 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80044e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posflag = 1;
  800451:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  800458:	eb cd                	jmp    800427 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80045a:	0f b6 d2             	movzbl %dl,%edx
  80045d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800460:	b8 00 00 00 00       	mov    $0x0,%eax
  800465:	89 75 08             	mov    %esi,0x8(%ebp)
  800468:	eb 0c                	jmp    800476 <vprintfmt+0x92>
		switch (ch = *(unsigned char *) fmt++) {
  80046a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80046d:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  800471:	eb b4                	jmp    800427 <vprintfmt+0x43>
			for (precision = 0; ; ++fmt) {
  800473:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800476:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800479:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80047d:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800480:	8d 72 d0             	lea    -0x30(%edx),%esi
  800483:	83 fe 09             	cmp    $0x9,%esi
  800486:	76 eb                	jbe    800473 <vprintfmt+0x8f>
  800488:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80048b:	8b 75 08             	mov    0x8(%ebp),%esi
  80048e:	eb 14                	jmp    8004a4 <vprintfmt+0xc0>
			precision = va_arg(ap, int);
  800490:	8b 45 14             	mov    0x14(%ebp),%eax
  800493:	8b 00                	mov    (%eax),%eax
  800495:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800498:	8b 45 14             	mov    0x14(%ebp),%eax
  80049b:	8d 40 04             	lea    0x4(%eax),%eax
  80049e:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004a1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004a4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004a8:	0f 89 79 ff ff ff    	jns    800427 <vprintfmt+0x43>
				width = precision, precision = -1;
  8004ae:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004b4:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8004bb:	e9 67 ff ff ff       	jmp    800427 <vprintfmt+0x43>
  8004c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004c3:	85 c0                	test   %eax,%eax
  8004c5:	0f 48 c1             	cmovs  %ecx,%eax
  8004c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004cb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004ce:	e9 54 ff ff ff       	jmp    800427 <vprintfmt+0x43>
  8004d3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8004d6:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8004dd:	e9 45 ff ff ff       	jmp    800427 <vprintfmt+0x43>
			lflag++;
  8004e2:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004e6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004e9:	e9 39 ff ff ff       	jmp    800427 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8004ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f1:	8d 78 04             	lea    0x4(%eax),%edi
  8004f4:	83 ec 08             	sub    $0x8,%esp
  8004f7:	53                   	push   %ebx
  8004f8:	ff 30                	pushl  (%eax)
  8004fa:	ff d6                	call   *%esi
			break;
  8004fc:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004ff:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800502:	e9 0f 03 00 00       	jmp    800816 <vprintfmt+0x432>
			err = va_arg(ap, int);
  800507:	8b 45 14             	mov    0x14(%ebp),%eax
  80050a:	8d 78 04             	lea    0x4(%eax),%edi
  80050d:	8b 00                	mov    (%eax),%eax
  80050f:	99                   	cltd   
  800510:	31 d0                	xor    %edx,%eax
  800512:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800514:	83 f8 0f             	cmp    $0xf,%eax
  800517:	7f 23                	jg     80053c <vprintfmt+0x158>
  800519:	8b 14 85 e0 24 80 00 	mov    0x8024e0(,%eax,4),%edx
  800520:	85 d2                	test   %edx,%edx
  800522:	74 18                	je     80053c <vprintfmt+0x158>
				printfmt(putch, putdat, "%s", p);
  800524:	52                   	push   %edx
  800525:	68 1e 26 80 00       	push   $0x80261e
  80052a:	53                   	push   %ebx
  80052b:	56                   	push   %esi
  80052c:	e8 96 fe ff ff       	call   8003c7 <printfmt>
  800531:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800534:	89 7d 14             	mov    %edi,0x14(%ebp)
  800537:	e9 da 02 00 00       	jmp    800816 <vprintfmt+0x432>
				printfmt(putch, putdat, "error %d", err);
  80053c:	50                   	push   %eax
  80053d:	68 c3 21 80 00       	push   $0x8021c3
  800542:	53                   	push   %ebx
  800543:	56                   	push   %esi
  800544:	e8 7e fe ff ff       	call   8003c7 <printfmt>
  800549:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80054c:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80054f:	e9 c2 02 00 00       	jmp    800816 <vprintfmt+0x432>
			if ((p = va_arg(ap, char *)) == NULL)
  800554:	8b 45 14             	mov    0x14(%ebp),%eax
  800557:	83 c0 04             	add    $0x4,%eax
  80055a:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80055d:	8b 45 14             	mov    0x14(%ebp),%eax
  800560:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800562:	85 c9                	test   %ecx,%ecx
  800564:	b8 bc 21 80 00       	mov    $0x8021bc,%eax
  800569:	0f 45 c1             	cmovne %ecx,%eax
  80056c:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80056f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800573:	7e 06                	jle    80057b <vprintfmt+0x197>
  800575:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800579:	75 0d                	jne    800588 <vprintfmt+0x1a4>
				for (width -= strnlen(p, precision); width > 0; width--)
  80057b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80057e:	89 c7                	mov    %eax,%edi
  800580:	03 45 e0             	add    -0x20(%ebp),%eax
  800583:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800586:	eb 53                	jmp    8005db <vprintfmt+0x1f7>
  800588:	83 ec 08             	sub    $0x8,%esp
  80058b:	ff 75 d8             	pushl  -0x28(%ebp)
  80058e:	50                   	push   %eax
  80058f:	e8 28 04 00 00       	call   8009bc <strnlen>
  800594:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800597:	29 c1                	sub    %eax,%ecx
  800599:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  80059c:	83 c4 10             	add    $0x10,%esp
  80059f:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8005a1:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8005a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8005a8:	eb 0f                	jmp    8005b9 <vprintfmt+0x1d5>
					putch(padc, putdat);
  8005aa:	83 ec 08             	sub    $0x8,%esp
  8005ad:	53                   	push   %ebx
  8005ae:	ff 75 e0             	pushl  -0x20(%ebp)
  8005b1:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005b3:	83 ef 01             	sub    $0x1,%edi
  8005b6:	83 c4 10             	add    $0x10,%esp
  8005b9:	85 ff                	test   %edi,%edi
  8005bb:	7f ed                	jg     8005aa <vprintfmt+0x1c6>
  8005bd:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  8005c0:	85 c9                	test   %ecx,%ecx
  8005c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8005c7:	0f 49 c1             	cmovns %ecx,%eax
  8005ca:	29 c1                	sub    %eax,%ecx
  8005cc:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8005cf:	eb aa                	jmp    80057b <vprintfmt+0x197>
					putch(ch, putdat);
  8005d1:	83 ec 08             	sub    $0x8,%esp
  8005d4:	53                   	push   %ebx
  8005d5:	52                   	push   %edx
  8005d6:	ff d6                	call   *%esi
  8005d8:	83 c4 10             	add    $0x10,%esp
  8005db:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005de:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005e0:	83 c7 01             	add    $0x1,%edi
  8005e3:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005e7:	0f be d0             	movsbl %al,%edx
  8005ea:	85 d2                	test   %edx,%edx
  8005ec:	74 4b                	je     800639 <vprintfmt+0x255>
  8005ee:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005f2:	78 06                	js     8005fa <vprintfmt+0x216>
  8005f4:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8005f8:	78 1e                	js     800618 <vprintfmt+0x234>
				if (altflag && (ch < ' ' || ch > '~'))
  8005fa:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005fe:	74 d1                	je     8005d1 <vprintfmt+0x1ed>
  800600:	0f be c0             	movsbl %al,%eax
  800603:	83 e8 20             	sub    $0x20,%eax
  800606:	83 f8 5e             	cmp    $0x5e,%eax
  800609:	76 c6                	jbe    8005d1 <vprintfmt+0x1ed>
					putch('?', putdat);
  80060b:	83 ec 08             	sub    $0x8,%esp
  80060e:	53                   	push   %ebx
  80060f:	6a 3f                	push   $0x3f
  800611:	ff d6                	call   *%esi
  800613:	83 c4 10             	add    $0x10,%esp
  800616:	eb c3                	jmp    8005db <vprintfmt+0x1f7>
  800618:	89 cf                	mov    %ecx,%edi
  80061a:	eb 0e                	jmp    80062a <vprintfmt+0x246>
				putch(' ', putdat);
  80061c:	83 ec 08             	sub    $0x8,%esp
  80061f:	53                   	push   %ebx
  800620:	6a 20                	push   $0x20
  800622:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800624:	83 ef 01             	sub    $0x1,%edi
  800627:	83 c4 10             	add    $0x10,%esp
  80062a:	85 ff                	test   %edi,%edi
  80062c:	7f ee                	jg     80061c <vprintfmt+0x238>
			if ((p = va_arg(ap, char *)) == NULL)
  80062e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800631:	89 45 14             	mov    %eax,0x14(%ebp)
  800634:	e9 dd 01 00 00       	jmp    800816 <vprintfmt+0x432>
  800639:	89 cf                	mov    %ecx,%edi
  80063b:	eb ed                	jmp    80062a <vprintfmt+0x246>
	if (lflag >= 2)
  80063d:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800641:	7f 21                	jg     800664 <vprintfmt+0x280>
	else if (lflag)
  800643:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800647:	74 6a                	je     8006b3 <vprintfmt+0x2cf>
		return va_arg(*ap, long);
  800649:	8b 45 14             	mov    0x14(%ebp),%eax
  80064c:	8b 00                	mov    (%eax),%eax
  80064e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800651:	89 c1                	mov    %eax,%ecx
  800653:	c1 f9 1f             	sar    $0x1f,%ecx
  800656:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800659:	8b 45 14             	mov    0x14(%ebp),%eax
  80065c:	8d 40 04             	lea    0x4(%eax),%eax
  80065f:	89 45 14             	mov    %eax,0x14(%ebp)
  800662:	eb 17                	jmp    80067b <vprintfmt+0x297>
		return va_arg(*ap, long long);
  800664:	8b 45 14             	mov    0x14(%ebp),%eax
  800667:	8b 50 04             	mov    0x4(%eax),%edx
  80066a:	8b 00                	mov    (%eax),%eax
  80066c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80066f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800672:	8b 45 14             	mov    0x14(%ebp),%eax
  800675:	8d 40 08             	lea    0x8(%eax),%eax
  800678:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80067b:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  80067e:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800683:	85 d2                	test   %edx,%edx
  800685:	0f 89 5c 01 00 00    	jns    8007e7 <vprintfmt+0x403>
				putch('-', putdat);
  80068b:	83 ec 08             	sub    $0x8,%esp
  80068e:	53                   	push   %ebx
  80068f:	6a 2d                	push   $0x2d
  800691:	ff d6                	call   *%esi
				num = -(long long) num;
  800693:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800696:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800699:	f7 d8                	neg    %eax
  80069b:	83 d2 00             	adc    $0x0,%edx
  80069e:	f7 da                	neg    %edx
  8006a0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006a3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006a6:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006a9:	bf 0a 00 00 00       	mov    $0xa,%edi
  8006ae:	e9 45 01 00 00       	jmp    8007f8 <vprintfmt+0x414>
		return va_arg(*ap, int);
  8006b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b6:	8b 00                	mov    (%eax),%eax
  8006b8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006bb:	89 c1                	mov    %eax,%ecx
  8006bd:	c1 f9 1f             	sar    $0x1f,%ecx
  8006c0:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c6:	8d 40 04             	lea    0x4(%eax),%eax
  8006c9:	89 45 14             	mov    %eax,0x14(%ebp)
  8006cc:	eb ad                	jmp    80067b <vprintfmt+0x297>
	if (lflag >= 2)
  8006ce:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8006d2:	7f 29                	jg     8006fd <vprintfmt+0x319>
	else if (lflag)
  8006d4:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8006d8:	74 44                	je     80071e <vprintfmt+0x33a>
		return va_arg(*ap, unsigned long);
  8006da:	8b 45 14             	mov    0x14(%ebp),%eax
  8006dd:	8b 00                	mov    (%eax),%eax
  8006df:	ba 00 00 00 00       	mov    $0x0,%edx
  8006e4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006e7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ed:	8d 40 04             	lea    0x4(%eax),%eax
  8006f0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006f3:	bf 0a 00 00 00       	mov    $0xa,%edi
  8006f8:	e9 ea 00 00 00       	jmp    8007e7 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  8006fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800700:	8b 50 04             	mov    0x4(%eax),%edx
  800703:	8b 00                	mov    (%eax),%eax
  800705:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800708:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80070b:	8b 45 14             	mov    0x14(%ebp),%eax
  80070e:	8d 40 08             	lea    0x8(%eax),%eax
  800711:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800714:	bf 0a 00 00 00       	mov    $0xa,%edi
  800719:	e9 c9 00 00 00       	jmp    8007e7 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  80071e:	8b 45 14             	mov    0x14(%ebp),%eax
  800721:	8b 00                	mov    (%eax),%eax
  800723:	ba 00 00 00 00       	mov    $0x0,%edx
  800728:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80072b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80072e:	8b 45 14             	mov    0x14(%ebp),%eax
  800731:	8d 40 04             	lea    0x4(%eax),%eax
  800734:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800737:	bf 0a 00 00 00       	mov    $0xa,%edi
  80073c:	e9 a6 00 00 00       	jmp    8007e7 <vprintfmt+0x403>
			putch('0', putdat);
  800741:	83 ec 08             	sub    $0x8,%esp
  800744:	53                   	push   %ebx
  800745:	6a 30                	push   $0x30
  800747:	ff d6                	call   *%esi
	if (lflag >= 2)
  800749:	83 c4 10             	add    $0x10,%esp
  80074c:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800750:	7f 26                	jg     800778 <vprintfmt+0x394>
	else if (lflag)
  800752:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800756:	74 3e                	je     800796 <vprintfmt+0x3b2>
		return va_arg(*ap, unsigned long);
  800758:	8b 45 14             	mov    0x14(%ebp),%eax
  80075b:	8b 00                	mov    (%eax),%eax
  80075d:	ba 00 00 00 00       	mov    $0x0,%edx
  800762:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800765:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800768:	8b 45 14             	mov    0x14(%ebp),%eax
  80076b:	8d 40 04             	lea    0x4(%eax),%eax
  80076e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800771:	bf 08 00 00 00       	mov    $0x8,%edi
  800776:	eb 6f                	jmp    8007e7 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  800778:	8b 45 14             	mov    0x14(%ebp),%eax
  80077b:	8b 50 04             	mov    0x4(%eax),%edx
  80077e:	8b 00                	mov    (%eax),%eax
  800780:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800783:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800786:	8b 45 14             	mov    0x14(%ebp),%eax
  800789:	8d 40 08             	lea    0x8(%eax),%eax
  80078c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80078f:	bf 08 00 00 00       	mov    $0x8,%edi
  800794:	eb 51                	jmp    8007e7 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  800796:	8b 45 14             	mov    0x14(%ebp),%eax
  800799:	8b 00                	mov    (%eax),%eax
  80079b:	ba 00 00 00 00       	mov    $0x0,%edx
  8007a0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a9:	8d 40 04             	lea    0x4(%eax),%eax
  8007ac:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007af:	bf 08 00 00 00       	mov    $0x8,%edi
  8007b4:	eb 31                	jmp    8007e7 <vprintfmt+0x403>
			putch('0', putdat);
  8007b6:	83 ec 08             	sub    $0x8,%esp
  8007b9:	53                   	push   %ebx
  8007ba:	6a 30                	push   $0x30
  8007bc:	ff d6                	call   *%esi
			putch('x', putdat);
  8007be:	83 c4 08             	add    $0x8,%esp
  8007c1:	53                   	push   %ebx
  8007c2:	6a 78                	push   $0x78
  8007c4:	ff d6                	call   *%esi
			num = (unsigned long long)
  8007c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c9:	8b 00                	mov    (%eax),%eax
  8007cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8007d0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007d3:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8007d6:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007dc:	8d 40 04             	lea    0x4(%eax),%eax
  8007df:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007e2:	bf 10 00 00 00       	mov    $0x10,%edi
			if(posflag)
  8007e7:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007eb:	74 0b                	je     8007f8 <vprintfmt+0x414>
				putch('+', putdat);
  8007ed:	83 ec 08             	sub    $0x8,%esp
  8007f0:	53                   	push   %ebx
  8007f1:	6a 2b                	push   $0x2b
  8007f3:	ff d6                	call   *%esi
  8007f5:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  8007f8:	83 ec 0c             	sub    $0xc,%esp
  8007fb:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8007ff:	50                   	push   %eax
  800800:	ff 75 e0             	pushl  -0x20(%ebp)
  800803:	57                   	push   %edi
  800804:	ff 75 dc             	pushl  -0x24(%ebp)
  800807:	ff 75 d8             	pushl  -0x28(%ebp)
  80080a:	89 da                	mov    %ebx,%edx
  80080c:	89 f0                	mov    %esi,%eax
  80080e:	e8 b8 fa ff ff       	call   8002cb <printnum>
			break;
  800813:	83 c4 20             	add    $0x20,%esp
			char* cp = va_arg(ap, char *);
  800816:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800819:	83 c7 01             	add    $0x1,%edi
  80081c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800820:	83 f8 25             	cmp    $0x25,%eax
  800823:	0f 84 d2 fb ff ff    	je     8003fb <vprintfmt+0x17>
			if (ch == '\0')
  800829:	85 c0                	test   %eax,%eax
  80082b:	0f 84 03 01 00 00    	je     800934 <vprintfmt+0x550>
			putch(ch, putdat);
  800831:	83 ec 08             	sub    $0x8,%esp
  800834:	53                   	push   %ebx
  800835:	50                   	push   %eax
  800836:	ff d6                	call   *%esi
  800838:	83 c4 10             	add    $0x10,%esp
  80083b:	eb dc                	jmp    800819 <vprintfmt+0x435>
	if (lflag >= 2)
  80083d:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800841:	7f 29                	jg     80086c <vprintfmt+0x488>
	else if (lflag)
  800843:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800847:	74 44                	je     80088d <vprintfmt+0x4a9>
		return va_arg(*ap, unsigned long);
  800849:	8b 45 14             	mov    0x14(%ebp),%eax
  80084c:	8b 00                	mov    (%eax),%eax
  80084e:	ba 00 00 00 00       	mov    $0x0,%edx
  800853:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800856:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800859:	8b 45 14             	mov    0x14(%ebp),%eax
  80085c:	8d 40 04             	lea    0x4(%eax),%eax
  80085f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800862:	bf 10 00 00 00       	mov    $0x10,%edi
  800867:	e9 7b ff ff ff       	jmp    8007e7 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  80086c:	8b 45 14             	mov    0x14(%ebp),%eax
  80086f:	8b 50 04             	mov    0x4(%eax),%edx
  800872:	8b 00                	mov    (%eax),%eax
  800874:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800877:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80087a:	8b 45 14             	mov    0x14(%ebp),%eax
  80087d:	8d 40 08             	lea    0x8(%eax),%eax
  800880:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800883:	bf 10 00 00 00       	mov    $0x10,%edi
  800888:	e9 5a ff ff ff       	jmp    8007e7 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  80088d:	8b 45 14             	mov    0x14(%ebp),%eax
  800890:	8b 00                	mov    (%eax),%eax
  800892:	ba 00 00 00 00       	mov    $0x0,%edx
  800897:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80089a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80089d:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a0:	8d 40 04             	lea    0x4(%eax),%eax
  8008a3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008a6:	bf 10 00 00 00       	mov    $0x10,%edi
  8008ab:	e9 37 ff ff ff       	jmp    8007e7 <vprintfmt+0x403>
			char* cp = va_arg(ap, char *);
  8008b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b3:	8d 78 04             	lea    0x4(%eax),%edi
  8008b6:	8b 00                	mov    (%eax),%eax
    			if (cp == NULL) {
  8008b8:	85 c0                	test   %eax,%eax
  8008ba:	74 2c                	je     8008e8 <vprintfmt+0x504>
    			*cp = *(int *)putdat;
  8008bc:	8b 13                	mov    (%ebx),%edx
  8008be:	88 10                	mov    %dl,(%eax)
			char* cp = va_arg(ap, char *);
  8008c0:	89 7d 14             	mov    %edi,0x14(%ebp)
    			if ((*(int *) putdat) > 127)
  8008c3:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  8008c6:	0f 8e 4a ff ff ff    	jle    800816 <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", overflow_error);
  8008cc:	68 18 23 80 00       	push   $0x802318
  8008d1:	68 1e 26 80 00       	push   $0x80261e
  8008d6:	53                   	push   %ebx
  8008d7:	56                   	push   %esi
  8008d8:	e8 ea fa ff ff       	call   8003c7 <printfmt>
  8008dd:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  8008e0:	89 7d 14             	mov    %edi,0x14(%ebp)
  8008e3:	e9 2e ff ff ff       	jmp    800816 <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", null_error);
  8008e8:	68 e0 22 80 00       	push   $0x8022e0
  8008ed:	68 1e 26 80 00       	push   $0x80261e
  8008f2:	53                   	push   %ebx
  8008f3:	56                   	push   %esi
  8008f4:	e8 ce fa ff ff       	call   8003c7 <printfmt>
        		break;
  8008f9:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  8008fc:	89 7d 14             	mov    %edi,0x14(%ebp)
        		break;
  8008ff:	e9 12 ff ff ff       	jmp    800816 <vprintfmt+0x432>
			putch(ch, putdat);
  800904:	83 ec 08             	sub    $0x8,%esp
  800907:	53                   	push   %ebx
  800908:	6a 25                	push   $0x25
  80090a:	ff d6                	call   *%esi
			break;
  80090c:	83 c4 10             	add    $0x10,%esp
  80090f:	e9 02 ff ff ff       	jmp    800816 <vprintfmt+0x432>
			putch('%', putdat);
  800914:	83 ec 08             	sub    $0x8,%esp
  800917:	53                   	push   %ebx
  800918:	6a 25                	push   $0x25
  80091a:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80091c:	83 c4 10             	add    $0x10,%esp
  80091f:	89 f8                	mov    %edi,%eax
  800921:	eb 03                	jmp    800926 <vprintfmt+0x542>
  800923:	83 e8 01             	sub    $0x1,%eax
  800926:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80092a:	75 f7                	jne    800923 <vprintfmt+0x53f>
  80092c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80092f:	e9 e2 fe ff ff       	jmp    800816 <vprintfmt+0x432>
}
  800934:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800937:	5b                   	pop    %ebx
  800938:	5e                   	pop    %esi
  800939:	5f                   	pop    %edi
  80093a:	5d                   	pop    %ebp
  80093b:	c3                   	ret    

0080093c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80093c:	55                   	push   %ebp
  80093d:	89 e5                	mov    %esp,%ebp
  80093f:	83 ec 18             	sub    $0x18,%esp
  800942:	8b 45 08             	mov    0x8(%ebp),%eax
  800945:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800948:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80094b:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80094f:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800952:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800959:	85 c0                	test   %eax,%eax
  80095b:	74 26                	je     800983 <vsnprintf+0x47>
  80095d:	85 d2                	test   %edx,%edx
  80095f:	7e 22                	jle    800983 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800961:	ff 75 14             	pushl  0x14(%ebp)
  800964:	ff 75 10             	pushl  0x10(%ebp)
  800967:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80096a:	50                   	push   %eax
  80096b:	68 aa 03 80 00       	push   $0x8003aa
  800970:	e8 6f fa ff ff       	call   8003e4 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800975:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800978:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80097b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80097e:	83 c4 10             	add    $0x10,%esp
}
  800981:	c9                   	leave  
  800982:	c3                   	ret    
		return -E_INVAL;
  800983:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800988:	eb f7                	jmp    800981 <vsnprintf+0x45>

0080098a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80098a:	55                   	push   %ebp
  80098b:	89 e5                	mov    %esp,%ebp
  80098d:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800990:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800993:	50                   	push   %eax
  800994:	ff 75 10             	pushl  0x10(%ebp)
  800997:	ff 75 0c             	pushl  0xc(%ebp)
  80099a:	ff 75 08             	pushl  0x8(%ebp)
  80099d:	e8 9a ff ff ff       	call   80093c <vsnprintf>
	va_end(ap);

	return rc;
}
  8009a2:	c9                   	leave  
  8009a3:	c3                   	ret    

008009a4 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009a4:	55                   	push   %ebp
  8009a5:	89 e5                	mov    %esp,%ebp
  8009a7:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8009af:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8009b3:	74 05                	je     8009ba <strlen+0x16>
		n++;
  8009b5:	83 c0 01             	add    $0x1,%eax
  8009b8:	eb f5                	jmp    8009af <strlen+0xb>
	return n;
}
  8009ba:	5d                   	pop    %ebp
  8009bb:	c3                   	ret    

008009bc <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8009bc:	55                   	push   %ebp
  8009bd:	89 e5                	mov    %esp,%ebp
  8009bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009c2:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8009ca:	39 c2                	cmp    %eax,%edx
  8009cc:	74 0d                	je     8009db <strnlen+0x1f>
  8009ce:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8009d2:	74 05                	je     8009d9 <strnlen+0x1d>
		n++;
  8009d4:	83 c2 01             	add    $0x1,%edx
  8009d7:	eb f1                	jmp    8009ca <strnlen+0xe>
  8009d9:	89 d0                	mov    %edx,%eax
	return n;
}
  8009db:	5d                   	pop    %ebp
  8009dc:	c3                   	ret    

008009dd <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009dd:	55                   	push   %ebp
  8009de:	89 e5                	mov    %esp,%ebp
  8009e0:	53                   	push   %ebx
  8009e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8009ec:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8009f0:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8009f3:	83 c2 01             	add    $0x1,%edx
  8009f6:	84 c9                	test   %cl,%cl
  8009f8:	75 f2                	jne    8009ec <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8009fa:	5b                   	pop    %ebx
  8009fb:	5d                   	pop    %ebp
  8009fc:	c3                   	ret    

008009fd <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009fd:	55                   	push   %ebp
  8009fe:	89 e5                	mov    %esp,%ebp
  800a00:	53                   	push   %ebx
  800a01:	83 ec 10             	sub    $0x10,%esp
  800a04:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a07:	53                   	push   %ebx
  800a08:	e8 97 ff ff ff       	call   8009a4 <strlen>
  800a0d:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a10:	ff 75 0c             	pushl  0xc(%ebp)
  800a13:	01 d8                	add    %ebx,%eax
  800a15:	50                   	push   %eax
  800a16:	e8 c2 ff ff ff       	call   8009dd <strcpy>
	return dst;
}
  800a1b:	89 d8                	mov    %ebx,%eax
  800a1d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a20:	c9                   	leave  
  800a21:	c3                   	ret    

00800a22 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a22:	55                   	push   %ebp
  800a23:	89 e5                	mov    %esp,%ebp
  800a25:	56                   	push   %esi
  800a26:	53                   	push   %ebx
  800a27:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a2d:	89 c6                	mov    %eax,%esi
  800a2f:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a32:	89 c2                	mov    %eax,%edx
  800a34:	39 f2                	cmp    %esi,%edx
  800a36:	74 11                	je     800a49 <strncpy+0x27>
		*dst++ = *src;
  800a38:	83 c2 01             	add    $0x1,%edx
  800a3b:	0f b6 19             	movzbl (%ecx),%ebx
  800a3e:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a41:	80 fb 01             	cmp    $0x1,%bl
  800a44:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800a47:	eb eb                	jmp    800a34 <strncpy+0x12>
	}
	return ret;
}
  800a49:	5b                   	pop    %ebx
  800a4a:	5e                   	pop    %esi
  800a4b:	5d                   	pop    %ebp
  800a4c:	c3                   	ret    

00800a4d <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a4d:	55                   	push   %ebp
  800a4e:	89 e5                	mov    %esp,%ebp
  800a50:	56                   	push   %esi
  800a51:	53                   	push   %ebx
  800a52:	8b 75 08             	mov    0x8(%ebp),%esi
  800a55:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a58:	8b 55 10             	mov    0x10(%ebp),%edx
  800a5b:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a5d:	85 d2                	test   %edx,%edx
  800a5f:	74 21                	je     800a82 <strlcpy+0x35>
  800a61:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a65:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800a67:	39 c2                	cmp    %eax,%edx
  800a69:	74 14                	je     800a7f <strlcpy+0x32>
  800a6b:	0f b6 19             	movzbl (%ecx),%ebx
  800a6e:	84 db                	test   %bl,%bl
  800a70:	74 0b                	je     800a7d <strlcpy+0x30>
			*dst++ = *src++;
  800a72:	83 c1 01             	add    $0x1,%ecx
  800a75:	83 c2 01             	add    $0x1,%edx
  800a78:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a7b:	eb ea                	jmp    800a67 <strlcpy+0x1a>
  800a7d:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a7f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a82:	29 f0                	sub    %esi,%eax
}
  800a84:	5b                   	pop    %ebx
  800a85:	5e                   	pop    %esi
  800a86:	5d                   	pop    %ebp
  800a87:	c3                   	ret    

00800a88 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a88:	55                   	push   %ebp
  800a89:	89 e5                	mov    %esp,%ebp
  800a8b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a8e:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a91:	0f b6 01             	movzbl (%ecx),%eax
  800a94:	84 c0                	test   %al,%al
  800a96:	74 0c                	je     800aa4 <strcmp+0x1c>
  800a98:	3a 02                	cmp    (%edx),%al
  800a9a:	75 08                	jne    800aa4 <strcmp+0x1c>
		p++, q++;
  800a9c:	83 c1 01             	add    $0x1,%ecx
  800a9f:	83 c2 01             	add    $0x1,%edx
  800aa2:	eb ed                	jmp    800a91 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800aa4:	0f b6 c0             	movzbl %al,%eax
  800aa7:	0f b6 12             	movzbl (%edx),%edx
  800aaa:	29 d0                	sub    %edx,%eax
}
  800aac:	5d                   	pop    %ebp
  800aad:	c3                   	ret    

00800aae <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800aae:	55                   	push   %ebp
  800aaf:	89 e5                	mov    %esp,%ebp
  800ab1:	53                   	push   %ebx
  800ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ab8:	89 c3                	mov    %eax,%ebx
  800aba:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800abd:	eb 06                	jmp    800ac5 <strncmp+0x17>
		n--, p++, q++;
  800abf:	83 c0 01             	add    $0x1,%eax
  800ac2:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800ac5:	39 d8                	cmp    %ebx,%eax
  800ac7:	74 16                	je     800adf <strncmp+0x31>
  800ac9:	0f b6 08             	movzbl (%eax),%ecx
  800acc:	84 c9                	test   %cl,%cl
  800ace:	74 04                	je     800ad4 <strncmp+0x26>
  800ad0:	3a 0a                	cmp    (%edx),%cl
  800ad2:	74 eb                	je     800abf <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ad4:	0f b6 00             	movzbl (%eax),%eax
  800ad7:	0f b6 12             	movzbl (%edx),%edx
  800ada:	29 d0                	sub    %edx,%eax
}
  800adc:	5b                   	pop    %ebx
  800add:	5d                   	pop    %ebp
  800ade:	c3                   	ret    
		return 0;
  800adf:	b8 00 00 00 00       	mov    $0x0,%eax
  800ae4:	eb f6                	jmp    800adc <strncmp+0x2e>

00800ae6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ae6:	55                   	push   %ebp
  800ae7:	89 e5                	mov    %esp,%ebp
  800ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  800aec:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800af0:	0f b6 10             	movzbl (%eax),%edx
  800af3:	84 d2                	test   %dl,%dl
  800af5:	74 09                	je     800b00 <strchr+0x1a>
		if (*s == c)
  800af7:	38 ca                	cmp    %cl,%dl
  800af9:	74 0a                	je     800b05 <strchr+0x1f>
	for (; *s; s++)
  800afb:	83 c0 01             	add    $0x1,%eax
  800afe:	eb f0                	jmp    800af0 <strchr+0xa>
			return (char *) s;
	return 0;
  800b00:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b05:	5d                   	pop    %ebp
  800b06:	c3                   	ret    

00800b07 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b07:	55                   	push   %ebp
  800b08:	89 e5                	mov    %esp,%ebp
  800b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b11:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b14:	38 ca                	cmp    %cl,%dl
  800b16:	74 09                	je     800b21 <strfind+0x1a>
  800b18:	84 d2                	test   %dl,%dl
  800b1a:	74 05                	je     800b21 <strfind+0x1a>
	for (; *s; s++)
  800b1c:	83 c0 01             	add    $0x1,%eax
  800b1f:	eb f0                	jmp    800b11 <strfind+0xa>
			break;
	return (char *) s;
}
  800b21:	5d                   	pop    %ebp
  800b22:	c3                   	ret    

00800b23 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b23:	55                   	push   %ebp
  800b24:	89 e5                	mov    %esp,%ebp
  800b26:	57                   	push   %edi
  800b27:	56                   	push   %esi
  800b28:	53                   	push   %ebx
  800b29:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b2c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b2f:	85 c9                	test   %ecx,%ecx
  800b31:	74 31                	je     800b64 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b33:	89 f8                	mov    %edi,%eax
  800b35:	09 c8                	or     %ecx,%eax
  800b37:	a8 03                	test   $0x3,%al
  800b39:	75 23                	jne    800b5e <memset+0x3b>
		c &= 0xFF;
  800b3b:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b3f:	89 d3                	mov    %edx,%ebx
  800b41:	c1 e3 08             	shl    $0x8,%ebx
  800b44:	89 d0                	mov    %edx,%eax
  800b46:	c1 e0 18             	shl    $0x18,%eax
  800b49:	89 d6                	mov    %edx,%esi
  800b4b:	c1 e6 10             	shl    $0x10,%esi
  800b4e:	09 f0                	or     %esi,%eax
  800b50:	09 c2                	or     %eax,%edx
  800b52:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b54:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b57:	89 d0                	mov    %edx,%eax
  800b59:	fc                   	cld    
  800b5a:	f3 ab                	rep stos %eax,%es:(%edi)
  800b5c:	eb 06                	jmp    800b64 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b61:	fc                   	cld    
  800b62:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b64:	89 f8                	mov    %edi,%eax
  800b66:	5b                   	pop    %ebx
  800b67:	5e                   	pop    %esi
  800b68:	5f                   	pop    %edi
  800b69:	5d                   	pop    %ebp
  800b6a:	c3                   	ret    

00800b6b <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b6b:	55                   	push   %ebp
  800b6c:	89 e5                	mov    %esp,%ebp
  800b6e:	57                   	push   %edi
  800b6f:	56                   	push   %esi
  800b70:	8b 45 08             	mov    0x8(%ebp),%eax
  800b73:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b76:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b79:	39 c6                	cmp    %eax,%esi
  800b7b:	73 32                	jae    800baf <memmove+0x44>
  800b7d:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b80:	39 c2                	cmp    %eax,%edx
  800b82:	76 2b                	jbe    800baf <memmove+0x44>
		s += n;
		d += n;
  800b84:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b87:	89 fe                	mov    %edi,%esi
  800b89:	09 ce                	or     %ecx,%esi
  800b8b:	09 d6                	or     %edx,%esi
  800b8d:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b93:	75 0e                	jne    800ba3 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b95:	83 ef 04             	sub    $0x4,%edi
  800b98:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b9b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b9e:	fd                   	std    
  800b9f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ba1:	eb 09                	jmp    800bac <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ba3:	83 ef 01             	sub    $0x1,%edi
  800ba6:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ba9:	fd                   	std    
  800baa:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800bac:	fc                   	cld    
  800bad:	eb 1a                	jmp    800bc9 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800baf:	89 c2                	mov    %eax,%edx
  800bb1:	09 ca                	or     %ecx,%edx
  800bb3:	09 f2                	or     %esi,%edx
  800bb5:	f6 c2 03             	test   $0x3,%dl
  800bb8:	75 0a                	jne    800bc4 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800bba:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800bbd:	89 c7                	mov    %eax,%edi
  800bbf:	fc                   	cld    
  800bc0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bc2:	eb 05                	jmp    800bc9 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800bc4:	89 c7                	mov    %eax,%edi
  800bc6:	fc                   	cld    
  800bc7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800bc9:	5e                   	pop    %esi
  800bca:	5f                   	pop    %edi
  800bcb:	5d                   	pop    %ebp
  800bcc:	c3                   	ret    

00800bcd <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800bcd:	55                   	push   %ebp
  800bce:	89 e5                	mov    %esp,%ebp
  800bd0:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800bd3:	ff 75 10             	pushl  0x10(%ebp)
  800bd6:	ff 75 0c             	pushl  0xc(%ebp)
  800bd9:	ff 75 08             	pushl  0x8(%ebp)
  800bdc:	e8 8a ff ff ff       	call   800b6b <memmove>
}
  800be1:	c9                   	leave  
  800be2:	c3                   	ret    

00800be3 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800be3:	55                   	push   %ebp
  800be4:	89 e5                	mov    %esp,%ebp
  800be6:	56                   	push   %esi
  800be7:	53                   	push   %ebx
  800be8:	8b 45 08             	mov    0x8(%ebp),%eax
  800beb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bee:	89 c6                	mov    %eax,%esi
  800bf0:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bf3:	39 f0                	cmp    %esi,%eax
  800bf5:	74 1c                	je     800c13 <memcmp+0x30>
		if (*s1 != *s2)
  800bf7:	0f b6 08             	movzbl (%eax),%ecx
  800bfa:	0f b6 1a             	movzbl (%edx),%ebx
  800bfd:	38 d9                	cmp    %bl,%cl
  800bff:	75 08                	jne    800c09 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c01:	83 c0 01             	add    $0x1,%eax
  800c04:	83 c2 01             	add    $0x1,%edx
  800c07:	eb ea                	jmp    800bf3 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c09:	0f b6 c1             	movzbl %cl,%eax
  800c0c:	0f b6 db             	movzbl %bl,%ebx
  800c0f:	29 d8                	sub    %ebx,%eax
  800c11:	eb 05                	jmp    800c18 <memcmp+0x35>
	}

	return 0;
  800c13:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c18:	5b                   	pop    %ebx
  800c19:	5e                   	pop    %esi
  800c1a:	5d                   	pop    %ebp
  800c1b:	c3                   	ret    

00800c1c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c1c:	55                   	push   %ebp
  800c1d:	89 e5                	mov    %esp,%ebp
  800c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c22:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c25:	89 c2                	mov    %eax,%edx
  800c27:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c2a:	39 d0                	cmp    %edx,%eax
  800c2c:	73 09                	jae    800c37 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c2e:	38 08                	cmp    %cl,(%eax)
  800c30:	74 05                	je     800c37 <memfind+0x1b>
	for (; s < ends; s++)
  800c32:	83 c0 01             	add    $0x1,%eax
  800c35:	eb f3                	jmp    800c2a <memfind+0xe>
			break;
	return (void *) s;
}
  800c37:	5d                   	pop    %ebp
  800c38:	c3                   	ret    

00800c39 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c39:	55                   	push   %ebp
  800c3a:	89 e5                	mov    %esp,%ebp
  800c3c:	57                   	push   %edi
  800c3d:	56                   	push   %esi
  800c3e:	53                   	push   %ebx
  800c3f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c42:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c45:	eb 03                	jmp    800c4a <strtol+0x11>
		s++;
  800c47:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c4a:	0f b6 01             	movzbl (%ecx),%eax
  800c4d:	3c 20                	cmp    $0x20,%al
  800c4f:	74 f6                	je     800c47 <strtol+0xe>
  800c51:	3c 09                	cmp    $0x9,%al
  800c53:	74 f2                	je     800c47 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c55:	3c 2b                	cmp    $0x2b,%al
  800c57:	74 2a                	je     800c83 <strtol+0x4a>
	int neg = 0;
  800c59:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c5e:	3c 2d                	cmp    $0x2d,%al
  800c60:	74 2b                	je     800c8d <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c62:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c68:	75 0f                	jne    800c79 <strtol+0x40>
  800c6a:	80 39 30             	cmpb   $0x30,(%ecx)
  800c6d:	74 28                	je     800c97 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c6f:	85 db                	test   %ebx,%ebx
  800c71:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c76:	0f 44 d8             	cmove  %eax,%ebx
  800c79:	b8 00 00 00 00       	mov    $0x0,%eax
  800c7e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c81:	eb 50                	jmp    800cd3 <strtol+0x9a>
		s++;
  800c83:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c86:	bf 00 00 00 00       	mov    $0x0,%edi
  800c8b:	eb d5                	jmp    800c62 <strtol+0x29>
		s++, neg = 1;
  800c8d:	83 c1 01             	add    $0x1,%ecx
  800c90:	bf 01 00 00 00       	mov    $0x1,%edi
  800c95:	eb cb                	jmp    800c62 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c97:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c9b:	74 0e                	je     800cab <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c9d:	85 db                	test   %ebx,%ebx
  800c9f:	75 d8                	jne    800c79 <strtol+0x40>
		s++, base = 8;
  800ca1:	83 c1 01             	add    $0x1,%ecx
  800ca4:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ca9:	eb ce                	jmp    800c79 <strtol+0x40>
		s += 2, base = 16;
  800cab:	83 c1 02             	add    $0x2,%ecx
  800cae:	bb 10 00 00 00       	mov    $0x10,%ebx
  800cb3:	eb c4                	jmp    800c79 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800cb5:	8d 72 9f             	lea    -0x61(%edx),%esi
  800cb8:	89 f3                	mov    %esi,%ebx
  800cba:	80 fb 19             	cmp    $0x19,%bl
  800cbd:	77 29                	ja     800ce8 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800cbf:	0f be d2             	movsbl %dl,%edx
  800cc2:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800cc5:	3b 55 10             	cmp    0x10(%ebp),%edx
  800cc8:	7d 30                	jge    800cfa <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800cca:	83 c1 01             	add    $0x1,%ecx
  800ccd:	0f af 45 10          	imul   0x10(%ebp),%eax
  800cd1:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800cd3:	0f b6 11             	movzbl (%ecx),%edx
  800cd6:	8d 72 d0             	lea    -0x30(%edx),%esi
  800cd9:	89 f3                	mov    %esi,%ebx
  800cdb:	80 fb 09             	cmp    $0x9,%bl
  800cde:	77 d5                	ja     800cb5 <strtol+0x7c>
			dig = *s - '0';
  800ce0:	0f be d2             	movsbl %dl,%edx
  800ce3:	83 ea 30             	sub    $0x30,%edx
  800ce6:	eb dd                	jmp    800cc5 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800ce8:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ceb:	89 f3                	mov    %esi,%ebx
  800ced:	80 fb 19             	cmp    $0x19,%bl
  800cf0:	77 08                	ja     800cfa <strtol+0xc1>
			dig = *s - 'A' + 10;
  800cf2:	0f be d2             	movsbl %dl,%edx
  800cf5:	83 ea 37             	sub    $0x37,%edx
  800cf8:	eb cb                	jmp    800cc5 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800cfa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cfe:	74 05                	je     800d05 <strtol+0xcc>
		*endptr = (char *) s;
  800d00:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d03:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d05:	89 c2                	mov    %eax,%edx
  800d07:	f7 da                	neg    %edx
  800d09:	85 ff                	test   %edi,%edi
  800d0b:	0f 45 c2             	cmovne %edx,%eax
}
  800d0e:	5b                   	pop    %ebx
  800d0f:	5e                   	pop    %esi
  800d10:	5f                   	pop    %edi
  800d11:	5d                   	pop    %ebp
  800d12:	c3                   	ret    

00800d13 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d13:	55                   	push   %ebp
  800d14:	89 e5                	mov    %esp,%ebp
  800d16:	57                   	push   %edi
  800d17:	56                   	push   %esi
  800d18:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d19:	b8 00 00 00 00       	mov    $0x0,%eax
  800d1e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d21:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d24:	89 c3                	mov    %eax,%ebx
  800d26:	89 c7                	mov    %eax,%edi
  800d28:	89 c6                	mov    %eax,%esi
  800d2a:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d2c:	5b                   	pop    %ebx
  800d2d:	5e                   	pop    %esi
  800d2e:	5f                   	pop    %edi
  800d2f:	5d                   	pop    %ebp
  800d30:	c3                   	ret    

00800d31 <sys_cgetc>:

int
sys_cgetc(void)
{
  800d31:	55                   	push   %ebp
  800d32:	89 e5                	mov    %esp,%ebp
  800d34:	57                   	push   %edi
  800d35:	56                   	push   %esi
  800d36:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d37:	ba 00 00 00 00       	mov    $0x0,%edx
  800d3c:	b8 01 00 00 00       	mov    $0x1,%eax
  800d41:	89 d1                	mov    %edx,%ecx
  800d43:	89 d3                	mov    %edx,%ebx
  800d45:	89 d7                	mov    %edx,%edi
  800d47:	89 d6                	mov    %edx,%esi
  800d49:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d4b:	5b                   	pop    %ebx
  800d4c:	5e                   	pop    %esi
  800d4d:	5f                   	pop    %edi
  800d4e:	5d                   	pop    %ebp
  800d4f:	c3                   	ret    

00800d50 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d50:	55                   	push   %ebp
  800d51:	89 e5                	mov    %esp,%ebp
  800d53:	57                   	push   %edi
  800d54:	56                   	push   %esi
  800d55:	53                   	push   %ebx
  800d56:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d59:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d5e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d61:	b8 03 00 00 00       	mov    $0x3,%eax
  800d66:	89 cb                	mov    %ecx,%ebx
  800d68:	89 cf                	mov    %ecx,%edi
  800d6a:	89 ce                	mov    %ecx,%esi
  800d6c:	cd 30                	int    $0x30
	if (check && ret > 0)
  800d6e:	85 c0                	test   %eax,%eax
  800d70:	7f 08                	jg     800d7a <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d72:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d75:	5b                   	pop    %ebx
  800d76:	5e                   	pop    %esi
  800d77:	5f                   	pop    %edi
  800d78:	5d                   	pop    %ebp
  800d79:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d7a:	83 ec 0c             	sub    $0xc,%esp
  800d7d:	50                   	push   %eax
  800d7e:	6a 03                	push   $0x3
  800d80:	68 20 25 80 00       	push   $0x802520
  800d85:	6a 4c                	push   $0x4c
  800d87:	68 3d 25 80 00       	push   $0x80253d
  800d8c:	e8 4b f4 ff ff       	call   8001dc <_panic>

00800d91 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d91:	55                   	push   %ebp
  800d92:	89 e5                	mov    %esp,%ebp
  800d94:	57                   	push   %edi
  800d95:	56                   	push   %esi
  800d96:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d97:	ba 00 00 00 00       	mov    $0x0,%edx
  800d9c:	b8 02 00 00 00       	mov    $0x2,%eax
  800da1:	89 d1                	mov    %edx,%ecx
  800da3:	89 d3                	mov    %edx,%ebx
  800da5:	89 d7                	mov    %edx,%edi
  800da7:	89 d6                	mov    %edx,%esi
  800da9:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800dab:	5b                   	pop    %ebx
  800dac:	5e                   	pop    %esi
  800dad:	5f                   	pop    %edi
  800dae:	5d                   	pop    %ebp
  800daf:	c3                   	ret    

00800db0 <sys_yield>:

void
sys_yield(void)
{
  800db0:	55                   	push   %ebp
  800db1:	89 e5                	mov    %esp,%ebp
  800db3:	57                   	push   %edi
  800db4:	56                   	push   %esi
  800db5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800db6:	ba 00 00 00 00       	mov    $0x0,%edx
  800dbb:	b8 0b 00 00 00       	mov    $0xb,%eax
  800dc0:	89 d1                	mov    %edx,%ecx
  800dc2:	89 d3                	mov    %edx,%ebx
  800dc4:	89 d7                	mov    %edx,%edi
  800dc6:	89 d6                	mov    %edx,%esi
  800dc8:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800dca:	5b                   	pop    %ebx
  800dcb:	5e                   	pop    %esi
  800dcc:	5f                   	pop    %edi
  800dcd:	5d                   	pop    %ebp
  800dce:	c3                   	ret    

00800dcf <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800dcf:	55                   	push   %ebp
  800dd0:	89 e5                	mov    %esp,%ebp
  800dd2:	57                   	push   %edi
  800dd3:	56                   	push   %esi
  800dd4:	53                   	push   %ebx
  800dd5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dd8:	be 00 00 00 00       	mov    $0x0,%esi
  800ddd:	8b 55 08             	mov    0x8(%ebp),%edx
  800de0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de3:	b8 04 00 00 00       	mov    $0x4,%eax
  800de8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800deb:	89 f7                	mov    %esi,%edi
  800ded:	cd 30                	int    $0x30
	if (check && ret > 0)
  800def:	85 c0                	test   %eax,%eax
  800df1:	7f 08                	jg     800dfb <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800df3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800df6:	5b                   	pop    %ebx
  800df7:	5e                   	pop    %esi
  800df8:	5f                   	pop    %edi
  800df9:	5d                   	pop    %ebp
  800dfa:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dfb:	83 ec 0c             	sub    $0xc,%esp
  800dfe:	50                   	push   %eax
  800dff:	6a 04                	push   $0x4
  800e01:	68 20 25 80 00       	push   $0x802520
  800e06:	6a 4c                	push   $0x4c
  800e08:	68 3d 25 80 00       	push   $0x80253d
  800e0d:	e8 ca f3 ff ff       	call   8001dc <_panic>

00800e12 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e12:	55                   	push   %ebp
  800e13:	89 e5                	mov    %esp,%ebp
  800e15:	57                   	push   %edi
  800e16:	56                   	push   %esi
  800e17:	53                   	push   %ebx
  800e18:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e1b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e21:	b8 05 00 00 00       	mov    $0x5,%eax
  800e26:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e29:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e2c:	8b 75 18             	mov    0x18(%ebp),%esi
  800e2f:	cd 30                	int    $0x30
	if (check && ret > 0)
  800e31:	85 c0                	test   %eax,%eax
  800e33:	7f 08                	jg     800e3d <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e35:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e38:	5b                   	pop    %ebx
  800e39:	5e                   	pop    %esi
  800e3a:	5f                   	pop    %edi
  800e3b:	5d                   	pop    %ebp
  800e3c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e3d:	83 ec 0c             	sub    $0xc,%esp
  800e40:	50                   	push   %eax
  800e41:	6a 05                	push   $0x5
  800e43:	68 20 25 80 00       	push   $0x802520
  800e48:	6a 4c                	push   $0x4c
  800e4a:	68 3d 25 80 00       	push   $0x80253d
  800e4f:	e8 88 f3 ff ff       	call   8001dc <_panic>

00800e54 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e54:	55                   	push   %ebp
  800e55:	89 e5                	mov    %esp,%ebp
  800e57:	57                   	push   %edi
  800e58:	56                   	push   %esi
  800e59:	53                   	push   %ebx
  800e5a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e5d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e62:	8b 55 08             	mov    0x8(%ebp),%edx
  800e65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e68:	b8 06 00 00 00       	mov    $0x6,%eax
  800e6d:	89 df                	mov    %ebx,%edi
  800e6f:	89 de                	mov    %ebx,%esi
  800e71:	cd 30                	int    $0x30
	if (check && ret > 0)
  800e73:	85 c0                	test   %eax,%eax
  800e75:	7f 08                	jg     800e7f <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e77:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e7a:	5b                   	pop    %ebx
  800e7b:	5e                   	pop    %esi
  800e7c:	5f                   	pop    %edi
  800e7d:	5d                   	pop    %ebp
  800e7e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e7f:	83 ec 0c             	sub    $0xc,%esp
  800e82:	50                   	push   %eax
  800e83:	6a 06                	push   $0x6
  800e85:	68 20 25 80 00       	push   $0x802520
  800e8a:	6a 4c                	push   $0x4c
  800e8c:	68 3d 25 80 00       	push   $0x80253d
  800e91:	e8 46 f3 ff ff       	call   8001dc <_panic>

00800e96 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e96:	55                   	push   %ebp
  800e97:	89 e5                	mov    %esp,%ebp
  800e99:	57                   	push   %edi
  800e9a:	56                   	push   %esi
  800e9b:	53                   	push   %ebx
  800e9c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e9f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ea4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eaa:	b8 08 00 00 00       	mov    $0x8,%eax
  800eaf:	89 df                	mov    %ebx,%edi
  800eb1:	89 de                	mov    %ebx,%esi
  800eb3:	cd 30                	int    $0x30
	if (check && ret > 0)
  800eb5:	85 c0                	test   %eax,%eax
  800eb7:	7f 08                	jg     800ec1 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800eb9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ebc:	5b                   	pop    %ebx
  800ebd:	5e                   	pop    %esi
  800ebe:	5f                   	pop    %edi
  800ebf:	5d                   	pop    %ebp
  800ec0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec1:	83 ec 0c             	sub    $0xc,%esp
  800ec4:	50                   	push   %eax
  800ec5:	6a 08                	push   $0x8
  800ec7:	68 20 25 80 00       	push   $0x802520
  800ecc:	6a 4c                	push   $0x4c
  800ece:	68 3d 25 80 00       	push   $0x80253d
  800ed3:	e8 04 f3 ff ff       	call   8001dc <_panic>

00800ed8 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ed8:	55                   	push   %ebp
  800ed9:	89 e5                	mov    %esp,%ebp
  800edb:	57                   	push   %edi
  800edc:	56                   	push   %esi
  800edd:	53                   	push   %ebx
  800ede:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ee1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ee6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eec:	b8 09 00 00 00       	mov    $0x9,%eax
  800ef1:	89 df                	mov    %ebx,%edi
  800ef3:	89 de                	mov    %ebx,%esi
  800ef5:	cd 30                	int    $0x30
	if (check && ret > 0)
  800ef7:	85 c0                	test   %eax,%eax
  800ef9:	7f 08                	jg     800f03 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800efb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800efe:	5b                   	pop    %ebx
  800eff:	5e                   	pop    %esi
  800f00:	5f                   	pop    %edi
  800f01:	5d                   	pop    %ebp
  800f02:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f03:	83 ec 0c             	sub    $0xc,%esp
  800f06:	50                   	push   %eax
  800f07:	6a 09                	push   $0x9
  800f09:	68 20 25 80 00       	push   $0x802520
  800f0e:	6a 4c                	push   $0x4c
  800f10:	68 3d 25 80 00       	push   $0x80253d
  800f15:	e8 c2 f2 ff ff       	call   8001dc <_panic>

00800f1a <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f1a:	55                   	push   %ebp
  800f1b:	89 e5                	mov    %esp,%ebp
  800f1d:	57                   	push   %edi
  800f1e:	56                   	push   %esi
  800f1f:	53                   	push   %ebx
  800f20:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f23:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f28:	8b 55 08             	mov    0x8(%ebp),%edx
  800f2b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f2e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f33:	89 df                	mov    %ebx,%edi
  800f35:	89 de                	mov    %ebx,%esi
  800f37:	cd 30                	int    $0x30
	if (check && ret > 0)
  800f39:	85 c0                	test   %eax,%eax
  800f3b:	7f 08                	jg     800f45 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f40:	5b                   	pop    %ebx
  800f41:	5e                   	pop    %esi
  800f42:	5f                   	pop    %edi
  800f43:	5d                   	pop    %ebp
  800f44:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f45:	83 ec 0c             	sub    $0xc,%esp
  800f48:	50                   	push   %eax
  800f49:	6a 0a                	push   $0xa
  800f4b:	68 20 25 80 00       	push   $0x802520
  800f50:	6a 4c                	push   $0x4c
  800f52:	68 3d 25 80 00       	push   $0x80253d
  800f57:	e8 80 f2 ff ff       	call   8001dc <_panic>

00800f5c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f5c:	55                   	push   %ebp
  800f5d:	89 e5                	mov    %esp,%ebp
  800f5f:	57                   	push   %edi
  800f60:	56                   	push   %esi
  800f61:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f62:	8b 55 08             	mov    0x8(%ebp),%edx
  800f65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f68:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f6d:	be 00 00 00 00       	mov    $0x0,%esi
  800f72:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f75:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f78:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f7a:	5b                   	pop    %ebx
  800f7b:	5e                   	pop    %esi
  800f7c:	5f                   	pop    %edi
  800f7d:	5d                   	pop    %ebp
  800f7e:	c3                   	ret    

00800f7f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f7f:	55                   	push   %ebp
  800f80:	89 e5                	mov    %esp,%ebp
  800f82:	57                   	push   %edi
  800f83:	56                   	push   %esi
  800f84:	53                   	push   %ebx
  800f85:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f88:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f8d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f90:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f95:	89 cb                	mov    %ecx,%ebx
  800f97:	89 cf                	mov    %ecx,%edi
  800f99:	89 ce                	mov    %ecx,%esi
  800f9b:	cd 30                	int    $0x30
	if (check && ret > 0)
  800f9d:	85 c0                	test   %eax,%eax
  800f9f:	7f 08                	jg     800fa9 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800fa1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fa4:	5b                   	pop    %ebx
  800fa5:	5e                   	pop    %esi
  800fa6:	5f                   	pop    %edi
  800fa7:	5d                   	pop    %ebp
  800fa8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fa9:	83 ec 0c             	sub    $0xc,%esp
  800fac:	50                   	push   %eax
  800fad:	6a 0d                	push   $0xd
  800faf:	68 20 25 80 00       	push   $0x802520
  800fb4:	6a 4c                	push   $0x4c
  800fb6:	68 3d 25 80 00       	push   $0x80253d
  800fbb:	e8 1c f2 ff ff       	call   8001dc <_panic>

00800fc0 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800fc0:	55                   	push   %ebp
  800fc1:	89 e5                	mov    %esp,%ebp
  800fc3:	57                   	push   %edi
  800fc4:	56                   	push   %esi
  800fc5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fc6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fcb:	8b 55 08             	mov    0x8(%ebp),%edx
  800fce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd1:	b8 0e 00 00 00       	mov    $0xe,%eax
  800fd6:	89 df                	mov    %ebx,%edi
  800fd8:	89 de                	mov    %ebx,%esi
  800fda:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800fdc:	5b                   	pop    %ebx
  800fdd:	5e                   	pop    %esi
  800fde:	5f                   	pop    %edi
  800fdf:	5d                   	pop    %ebp
  800fe0:	c3                   	ret    

00800fe1 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800fe1:	55                   	push   %ebp
  800fe2:	89 e5                	mov    %esp,%ebp
  800fe4:	57                   	push   %edi
  800fe5:	56                   	push   %esi
  800fe6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fe7:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fec:	8b 55 08             	mov    0x8(%ebp),%edx
  800fef:	b8 0f 00 00 00       	mov    $0xf,%eax
  800ff4:	89 cb                	mov    %ecx,%ebx
  800ff6:	89 cf                	mov    %ecx,%edi
  800ff8:	89 ce                	mov    %ecx,%esi
  800ffa:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800ffc:	5b                   	pop    %ebx
  800ffd:	5e                   	pop    %esi
  800ffe:	5f                   	pop    %edi
  800fff:	5d                   	pop    %ebp
  801000:	c3                   	ret    

00801001 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801001:	55                   	push   %ebp
  801002:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801004:	8b 45 08             	mov    0x8(%ebp),%eax
  801007:	05 00 00 00 30       	add    $0x30000000,%eax
  80100c:	c1 e8 0c             	shr    $0xc,%eax
}
  80100f:	5d                   	pop    %ebp
  801010:	c3                   	ret    

00801011 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801011:	55                   	push   %ebp
  801012:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801014:	8b 45 08             	mov    0x8(%ebp),%eax
  801017:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80101c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801021:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801026:	5d                   	pop    %ebp
  801027:	c3                   	ret    

00801028 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801028:	55                   	push   %ebp
  801029:	89 e5                	mov    %esp,%ebp
  80102b:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801030:	89 c2                	mov    %eax,%edx
  801032:	c1 ea 16             	shr    $0x16,%edx
  801035:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80103c:	f6 c2 01             	test   $0x1,%dl
  80103f:	74 2d                	je     80106e <fd_alloc+0x46>
  801041:	89 c2                	mov    %eax,%edx
  801043:	c1 ea 0c             	shr    $0xc,%edx
  801046:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80104d:	f6 c2 01             	test   $0x1,%dl
  801050:	74 1c                	je     80106e <fd_alloc+0x46>
  801052:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801057:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80105c:	75 d2                	jne    801030 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80105e:	8b 45 08             	mov    0x8(%ebp),%eax
  801061:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801067:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80106c:	eb 0a                	jmp    801078 <fd_alloc+0x50>
			*fd_store = fd;
  80106e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801071:	89 01                	mov    %eax,(%ecx)
			return 0;
  801073:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801078:	5d                   	pop    %ebp
  801079:	c3                   	ret    

0080107a <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80107a:	55                   	push   %ebp
  80107b:	89 e5                	mov    %esp,%ebp
  80107d:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801080:	83 f8 1f             	cmp    $0x1f,%eax
  801083:	77 30                	ja     8010b5 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801085:	c1 e0 0c             	shl    $0xc,%eax
  801088:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80108d:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801093:	f6 c2 01             	test   $0x1,%dl
  801096:	74 24                	je     8010bc <fd_lookup+0x42>
  801098:	89 c2                	mov    %eax,%edx
  80109a:	c1 ea 0c             	shr    $0xc,%edx
  80109d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010a4:	f6 c2 01             	test   $0x1,%dl
  8010a7:	74 1a                	je     8010c3 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8010a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010ac:	89 02                	mov    %eax,(%edx)
	return 0;
  8010ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010b3:	5d                   	pop    %ebp
  8010b4:	c3                   	ret    
		return -E_INVAL;
  8010b5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010ba:	eb f7                	jmp    8010b3 <fd_lookup+0x39>
		return -E_INVAL;
  8010bc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010c1:	eb f0                	jmp    8010b3 <fd_lookup+0x39>
  8010c3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010c8:	eb e9                	jmp    8010b3 <fd_lookup+0x39>

008010ca <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8010ca:	55                   	push   %ebp
  8010cb:	89 e5                	mov    %esp,%ebp
  8010cd:	83 ec 08             	sub    $0x8,%esp
  8010d0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010d3:	ba cc 25 80 00       	mov    $0x8025cc,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8010d8:	b8 08 30 80 00       	mov    $0x803008,%eax
		if (devtab[i]->dev_id == dev_id) {
  8010dd:	39 08                	cmp    %ecx,(%eax)
  8010df:	74 33                	je     801114 <dev_lookup+0x4a>
  8010e1:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8010e4:	8b 02                	mov    (%edx),%eax
  8010e6:	85 c0                	test   %eax,%eax
  8010e8:	75 f3                	jne    8010dd <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8010ea:	a1 08 40 80 00       	mov    0x804008,%eax
  8010ef:	8b 40 48             	mov    0x48(%eax),%eax
  8010f2:	83 ec 04             	sub    $0x4,%esp
  8010f5:	51                   	push   %ecx
  8010f6:	50                   	push   %eax
  8010f7:	68 4c 25 80 00       	push   $0x80254c
  8010fc:	e8 b6 f1 ff ff       	call   8002b7 <cprintf>
	*dev = 0;
  801101:	8b 45 0c             	mov    0xc(%ebp),%eax
  801104:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80110a:	83 c4 10             	add    $0x10,%esp
  80110d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801112:	c9                   	leave  
  801113:	c3                   	ret    
			*dev = devtab[i];
  801114:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801117:	89 01                	mov    %eax,(%ecx)
			return 0;
  801119:	b8 00 00 00 00       	mov    $0x0,%eax
  80111e:	eb f2                	jmp    801112 <dev_lookup+0x48>

00801120 <fd_close>:
{
  801120:	55                   	push   %ebp
  801121:	89 e5                	mov    %esp,%ebp
  801123:	57                   	push   %edi
  801124:	56                   	push   %esi
  801125:	53                   	push   %ebx
  801126:	83 ec 24             	sub    $0x24,%esp
  801129:	8b 75 08             	mov    0x8(%ebp),%esi
  80112c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80112f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801132:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801133:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801139:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80113c:	50                   	push   %eax
  80113d:	e8 38 ff ff ff       	call   80107a <fd_lookup>
  801142:	89 c3                	mov    %eax,%ebx
  801144:	83 c4 10             	add    $0x10,%esp
  801147:	85 c0                	test   %eax,%eax
  801149:	78 05                	js     801150 <fd_close+0x30>
	    || fd != fd2)
  80114b:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80114e:	74 16                	je     801166 <fd_close+0x46>
		return (must_exist ? r : 0);
  801150:	89 f8                	mov    %edi,%eax
  801152:	84 c0                	test   %al,%al
  801154:	b8 00 00 00 00       	mov    $0x0,%eax
  801159:	0f 44 d8             	cmove  %eax,%ebx
}
  80115c:	89 d8                	mov    %ebx,%eax
  80115e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801161:	5b                   	pop    %ebx
  801162:	5e                   	pop    %esi
  801163:	5f                   	pop    %edi
  801164:	5d                   	pop    %ebp
  801165:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801166:	83 ec 08             	sub    $0x8,%esp
  801169:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80116c:	50                   	push   %eax
  80116d:	ff 36                	pushl  (%esi)
  80116f:	e8 56 ff ff ff       	call   8010ca <dev_lookup>
  801174:	89 c3                	mov    %eax,%ebx
  801176:	83 c4 10             	add    $0x10,%esp
  801179:	85 c0                	test   %eax,%eax
  80117b:	78 1a                	js     801197 <fd_close+0x77>
		if (dev->dev_close)
  80117d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801180:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801183:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801188:	85 c0                	test   %eax,%eax
  80118a:	74 0b                	je     801197 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80118c:	83 ec 0c             	sub    $0xc,%esp
  80118f:	56                   	push   %esi
  801190:	ff d0                	call   *%eax
  801192:	89 c3                	mov    %eax,%ebx
  801194:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801197:	83 ec 08             	sub    $0x8,%esp
  80119a:	56                   	push   %esi
  80119b:	6a 00                	push   $0x0
  80119d:	e8 b2 fc ff ff       	call   800e54 <sys_page_unmap>
	return r;
  8011a2:	83 c4 10             	add    $0x10,%esp
  8011a5:	eb b5                	jmp    80115c <fd_close+0x3c>

008011a7 <close>:

int
close(int fdnum)
{
  8011a7:	55                   	push   %ebp
  8011a8:	89 e5                	mov    %esp,%ebp
  8011aa:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011ad:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011b0:	50                   	push   %eax
  8011b1:	ff 75 08             	pushl  0x8(%ebp)
  8011b4:	e8 c1 fe ff ff       	call   80107a <fd_lookup>
  8011b9:	83 c4 10             	add    $0x10,%esp
  8011bc:	85 c0                	test   %eax,%eax
  8011be:	79 02                	jns    8011c2 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8011c0:	c9                   	leave  
  8011c1:	c3                   	ret    
		return fd_close(fd, 1);
  8011c2:	83 ec 08             	sub    $0x8,%esp
  8011c5:	6a 01                	push   $0x1
  8011c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8011ca:	e8 51 ff ff ff       	call   801120 <fd_close>
  8011cf:	83 c4 10             	add    $0x10,%esp
  8011d2:	eb ec                	jmp    8011c0 <close+0x19>

008011d4 <close_all>:

void
close_all(void)
{
  8011d4:	55                   	push   %ebp
  8011d5:	89 e5                	mov    %esp,%ebp
  8011d7:	53                   	push   %ebx
  8011d8:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8011db:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8011e0:	83 ec 0c             	sub    $0xc,%esp
  8011e3:	53                   	push   %ebx
  8011e4:	e8 be ff ff ff       	call   8011a7 <close>
	for (i = 0; i < MAXFD; i++)
  8011e9:	83 c3 01             	add    $0x1,%ebx
  8011ec:	83 c4 10             	add    $0x10,%esp
  8011ef:	83 fb 20             	cmp    $0x20,%ebx
  8011f2:	75 ec                	jne    8011e0 <close_all+0xc>
}
  8011f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011f7:	c9                   	leave  
  8011f8:	c3                   	ret    

008011f9 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8011f9:	55                   	push   %ebp
  8011fa:	89 e5                	mov    %esp,%ebp
  8011fc:	57                   	push   %edi
  8011fd:	56                   	push   %esi
  8011fe:	53                   	push   %ebx
  8011ff:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801202:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801205:	50                   	push   %eax
  801206:	ff 75 08             	pushl  0x8(%ebp)
  801209:	e8 6c fe ff ff       	call   80107a <fd_lookup>
  80120e:	89 c3                	mov    %eax,%ebx
  801210:	83 c4 10             	add    $0x10,%esp
  801213:	85 c0                	test   %eax,%eax
  801215:	0f 88 81 00 00 00    	js     80129c <dup+0xa3>
		return r;
	close(newfdnum);
  80121b:	83 ec 0c             	sub    $0xc,%esp
  80121e:	ff 75 0c             	pushl  0xc(%ebp)
  801221:	e8 81 ff ff ff       	call   8011a7 <close>

	newfd = INDEX2FD(newfdnum);
  801226:	8b 75 0c             	mov    0xc(%ebp),%esi
  801229:	c1 e6 0c             	shl    $0xc,%esi
  80122c:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801232:	83 c4 04             	add    $0x4,%esp
  801235:	ff 75 e4             	pushl  -0x1c(%ebp)
  801238:	e8 d4 fd ff ff       	call   801011 <fd2data>
  80123d:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80123f:	89 34 24             	mov    %esi,(%esp)
  801242:	e8 ca fd ff ff       	call   801011 <fd2data>
  801247:	83 c4 10             	add    $0x10,%esp
  80124a:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80124c:	89 d8                	mov    %ebx,%eax
  80124e:	c1 e8 16             	shr    $0x16,%eax
  801251:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801258:	a8 01                	test   $0x1,%al
  80125a:	74 11                	je     80126d <dup+0x74>
  80125c:	89 d8                	mov    %ebx,%eax
  80125e:	c1 e8 0c             	shr    $0xc,%eax
  801261:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801268:	f6 c2 01             	test   $0x1,%dl
  80126b:	75 39                	jne    8012a6 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80126d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801270:	89 d0                	mov    %edx,%eax
  801272:	c1 e8 0c             	shr    $0xc,%eax
  801275:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80127c:	83 ec 0c             	sub    $0xc,%esp
  80127f:	25 07 0e 00 00       	and    $0xe07,%eax
  801284:	50                   	push   %eax
  801285:	56                   	push   %esi
  801286:	6a 00                	push   $0x0
  801288:	52                   	push   %edx
  801289:	6a 00                	push   $0x0
  80128b:	e8 82 fb ff ff       	call   800e12 <sys_page_map>
  801290:	89 c3                	mov    %eax,%ebx
  801292:	83 c4 20             	add    $0x20,%esp
  801295:	85 c0                	test   %eax,%eax
  801297:	78 31                	js     8012ca <dup+0xd1>
		goto err;

	return newfdnum;
  801299:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80129c:	89 d8                	mov    %ebx,%eax
  80129e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012a1:	5b                   	pop    %ebx
  8012a2:	5e                   	pop    %esi
  8012a3:	5f                   	pop    %edi
  8012a4:	5d                   	pop    %ebp
  8012a5:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8012a6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012ad:	83 ec 0c             	sub    $0xc,%esp
  8012b0:	25 07 0e 00 00       	and    $0xe07,%eax
  8012b5:	50                   	push   %eax
  8012b6:	57                   	push   %edi
  8012b7:	6a 00                	push   $0x0
  8012b9:	53                   	push   %ebx
  8012ba:	6a 00                	push   $0x0
  8012bc:	e8 51 fb ff ff       	call   800e12 <sys_page_map>
  8012c1:	89 c3                	mov    %eax,%ebx
  8012c3:	83 c4 20             	add    $0x20,%esp
  8012c6:	85 c0                	test   %eax,%eax
  8012c8:	79 a3                	jns    80126d <dup+0x74>
	sys_page_unmap(0, newfd);
  8012ca:	83 ec 08             	sub    $0x8,%esp
  8012cd:	56                   	push   %esi
  8012ce:	6a 00                	push   $0x0
  8012d0:	e8 7f fb ff ff       	call   800e54 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8012d5:	83 c4 08             	add    $0x8,%esp
  8012d8:	57                   	push   %edi
  8012d9:	6a 00                	push   $0x0
  8012db:	e8 74 fb ff ff       	call   800e54 <sys_page_unmap>
	return r;
  8012e0:	83 c4 10             	add    $0x10,%esp
  8012e3:	eb b7                	jmp    80129c <dup+0xa3>

008012e5 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8012e5:	55                   	push   %ebp
  8012e6:	89 e5                	mov    %esp,%ebp
  8012e8:	53                   	push   %ebx
  8012e9:	83 ec 1c             	sub    $0x1c,%esp
  8012ec:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012ef:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012f2:	50                   	push   %eax
  8012f3:	53                   	push   %ebx
  8012f4:	e8 81 fd ff ff       	call   80107a <fd_lookup>
  8012f9:	83 c4 10             	add    $0x10,%esp
  8012fc:	85 c0                	test   %eax,%eax
  8012fe:	78 3f                	js     80133f <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801300:	83 ec 08             	sub    $0x8,%esp
  801303:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801306:	50                   	push   %eax
  801307:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80130a:	ff 30                	pushl  (%eax)
  80130c:	e8 b9 fd ff ff       	call   8010ca <dev_lookup>
  801311:	83 c4 10             	add    $0x10,%esp
  801314:	85 c0                	test   %eax,%eax
  801316:	78 27                	js     80133f <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801318:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80131b:	8b 42 08             	mov    0x8(%edx),%eax
  80131e:	83 e0 03             	and    $0x3,%eax
  801321:	83 f8 01             	cmp    $0x1,%eax
  801324:	74 1e                	je     801344 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801326:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801329:	8b 40 08             	mov    0x8(%eax),%eax
  80132c:	85 c0                	test   %eax,%eax
  80132e:	74 35                	je     801365 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801330:	83 ec 04             	sub    $0x4,%esp
  801333:	ff 75 10             	pushl  0x10(%ebp)
  801336:	ff 75 0c             	pushl  0xc(%ebp)
  801339:	52                   	push   %edx
  80133a:	ff d0                	call   *%eax
  80133c:	83 c4 10             	add    $0x10,%esp
}
  80133f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801342:	c9                   	leave  
  801343:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801344:	a1 08 40 80 00       	mov    0x804008,%eax
  801349:	8b 40 48             	mov    0x48(%eax),%eax
  80134c:	83 ec 04             	sub    $0x4,%esp
  80134f:	53                   	push   %ebx
  801350:	50                   	push   %eax
  801351:	68 90 25 80 00       	push   $0x802590
  801356:	e8 5c ef ff ff       	call   8002b7 <cprintf>
		return -E_INVAL;
  80135b:	83 c4 10             	add    $0x10,%esp
  80135e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801363:	eb da                	jmp    80133f <read+0x5a>
		return -E_NOT_SUPP;
  801365:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80136a:	eb d3                	jmp    80133f <read+0x5a>

0080136c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80136c:	55                   	push   %ebp
  80136d:	89 e5                	mov    %esp,%ebp
  80136f:	57                   	push   %edi
  801370:	56                   	push   %esi
  801371:	53                   	push   %ebx
  801372:	83 ec 0c             	sub    $0xc,%esp
  801375:	8b 7d 08             	mov    0x8(%ebp),%edi
  801378:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80137b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801380:	39 f3                	cmp    %esi,%ebx
  801382:	73 23                	jae    8013a7 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801384:	83 ec 04             	sub    $0x4,%esp
  801387:	89 f0                	mov    %esi,%eax
  801389:	29 d8                	sub    %ebx,%eax
  80138b:	50                   	push   %eax
  80138c:	89 d8                	mov    %ebx,%eax
  80138e:	03 45 0c             	add    0xc(%ebp),%eax
  801391:	50                   	push   %eax
  801392:	57                   	push   %edi
  801393:	e8 4d ff ff ff       	call   8012e5 <read>
		if (m < 0)
  801398:	83 c4 10             	add    $0x10,%esp
  80139b:	85 c0                	test   %eax,%eax
  80139d:	78 06                	js     8013a5 <readn+0x39>
			return m;
		if (m == 0)
  80139f:	74 06                	je     8013a7 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8013a1:	01 c3                	add    %eax,%ebx
  8013a3:	eb db                	jmp    801380 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013a5:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8013a7:	89 d8                	mov    %ebx,%eax
  8013a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013ac:	5b                   	pop    %ebx
  8013ad:	5e                   	pop    %esi
  8013ae:	5f                   	pop    %edi
  8013af:	5d                   	pop    %ebp
  8013b0:	c3                   	ret    

008013b1 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8013b1:	55                   	push   %ebp
  8013b2:	89 e5                	mov    %esp,%ebp
  8013b4:	53                   	push   %ebx
  8013b5:	83 ec 1c             	sub    $0x1c,%esp
  8013b8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013bb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013be:	50                   	push   %eax
  8013bf:	53                   	push   %ebx
  8013c0:	e8 b5 fc ff ff       	call   80107a <fd_lookup>
  8013c5:	83 c4 10             	add    $0x10,%esp
  8013c8:	85 c0                	test   %eax,%eax
  8013ca:	78 3a                	js     801406 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013cc:	83 ec 08             	sub    $0x8,%esp
  8013cf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013d2:	50                   	push   %eax
  8013d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013d6:	ff 30                	pushl  (%eax)
  8013d8:	e8 ed fc ff ff       	call   8010ca <dev_lookup>
  8013dd:	83 c4 10             	add    $0x10,%esp
  8013e0:	85 c0                	test   %eax,%eax
  8013e2:	78 22                	js     801406 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013e7:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013eb:	74 1e                	je     80140b <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8013ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013f0:	8b 52 0c             	mov    0xc(%edx),%edx
  8013f3:	85 d2                	test   %edx,%edx
  8013f5:	74 35                	je     80142c <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8013f7:	83 ec 04             	sub    $0x4,%esp
  8013fa:	ff 75 10             	pushl  0x10(%ebp)
  8013fd:	ff 75 0c             	pushl  0xc(%ebp)
  801400:	50                   	push   %eax
  801401:	ff d2                	call   *%edx
  801403:	83 c4 10             	add    $0x10,%esp
}
  801406:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801409:	c9                   	leave  
  80140a:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80140b:	a1 08 40 80 00       	mov    0x804008,%eax
  801410:	8b 40 48             	mov    0x48(%eax),%eax
  801413:	83 ec 04             	sub    $0x4,%esp
  801416:	53                   	push   %ebx
  801417:	50                   	push   %eax
  801418:	68 ac 25 80 00       	push   $0x8025ac
  80141d:	e8 95 ee ff ff       	call   8002b7 <cprintf>
		return -E_INVAL;
  801422:	83 c4 10             	add    $0x10,%esp
  801425:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80142a:	eb da                	jmp    801406 <write+0x55>
		return -E_NOT_SUPP;
  80142c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801431:	eb d3                	jmp    801406 <write+0x55>

00801433 <seek>:

int
seek(int fdnum, off_t offset)
{
  801433:	55                   	push   %ebp
  801434:	89 e5                	mov    %esp,%ebp
  801436:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801439:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80143c:	50                   	push   %eax
  80143d:	ff 75 08             	pushl  0x8(%ebp)
  801440:	e8 35 fc ff ff       	call   80107a <fd_lookup>
  801445:	83 c4 10             	add    $0x10,%esp
  801448:	85 c0                	test   %eax,%eax
  80144a:	78 0e                	js     80145a <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80144c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80144f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801452:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801455:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80145a:	c9                   	leave  
  80145b:	c3                   	ret    

0080145c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80145c:	55                   	push   %ebp
  80145d:	89 e5                	mov    %esp,%ebp
  80145f:	53                   	push   %ebx
  801460:	83 ec 1c             	sub    $0x1c,%esp
  801463:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801466:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801469:	50                   	push   %eax
  80146a:	53                   	push   %ebx
  80146b:	e8 0a fc ff ff       	call   80107a <fd_lookup>
  801470:	83 c4 10             	add    $0x10,%esp
  801473:	85 c0                	test   %eax,%eax
  801475:	78 37                	js     8014ae <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801477:	83 ec 08             	sub    $0x8,%esp
  80147a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80147d:	50                   	push   %eax
  80147e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801481:	ff 30                	pushl  (%eax)
  801483:	e8 42 fc ff ff       	call   8010ca <dev_lookup>
  801488:	83 c4 10             	add    $0x10,%esp
  80148b:	85 c0                	test   %eax,%eax
  80148d:	78 1f                	js     8014ae <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80148f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801492:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801496:	74 1b                	je     8014b3 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801498:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80149b:	8b 52 18             	mov    0x18(%edx),%edx
  80149e:	85 d2                	test   %edx,%edx
  8014a0:	74 32                	je     8014d4 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8014a2:	83 ec 08             	sub    $0x8,%esp
  8014a5:	ff 75 0c             	pushl  0xc(%ebp)
  8014a8:	50                   	push   %eax
  8014a9:	ff d2                	call   *%edx
  8014ab:	83 c4 10             	add    $0x10,%esp
}
  8014ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014b1:	c9                   	leave  
  8014b2:	c3                   	ret    
			thisenv->env_id, fdnum);
  8014b3:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8014b8:	8b 40 48             	mov    0x48(%eax),%eax
  8014bb:	83 ec 04             	sub    $0x4,%esp
  8014be:	53                   	push   %ebx
  8014bf:	50                   	push   %eax
  8014c0:	68 6c 25 80 00       	push   $0x80256c
  8014c5:	e8 ed ed ff ff       	call   8002b7 <cprintf>
		return -E_INVAL;
  8014ca:	83 c4 10             	add    $0x10,%esp
  8014cd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014d2:	eb da                	jmp    8014ae <ftruncate+0x52>
		return -E_NOT_SUPP;
  8014d4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014d9:	eb d3                	jmp    8014ae <ftruncate+0x52>

008014db <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8014db:	55                   	push   %ebp
  8014dc:	89 e5                	mov    %esp,%ebp
  8014de:	53                   	push   %ebx
  8014df:	83 ec 1c             	sub    $0x1c,%esp
  8014e2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014e5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014e8:	50                   	push   %eax
  8014e9:	ff 75 08             	pushl  0x8(%ebp)
  8014ec:	e8 89 fb ff ff       	call   80107a <fd_lookup>
  8014f1:	83 c4 10             	add    $0x10,%esp
  8014f4:	85 c0                	test   %eax,%eax
  8014f6:	78 4b                	js     801543 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014f8:	83 ec 08             	sub    $0x8,%esp
  8014fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014fe:	50                   	push   %eax
  8014ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801502:	ff 30                	pushl  (%eax)
  801504:	e8 c1 fb ff ff       	call   8010ca <dev_lookup>
  801509:	83 c4 10             	add    $0x10,%esp
  80150c:	85 c0                	test   %eax,%eax
  80150e:	78 33                	js     801543 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801510:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801513:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801517:	74 2f                	je     801548 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801519:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80151c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801523:	00 00 00 
	stat->st_isdir = 0;
  801526:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80152d:	00 00 00 
	stat->st_dev = dev;
  801530:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801536:	83 ec 08             	sub    $0x8,%esp
  801539:	53                   	push   %ebx
  80153a:	ff 75 f0             	pushl  -0x10(%ebp)
  80153d:	ff 50 14             	call   *0x14(%eax)
  801540:	83 c4 10             	add    $0x10,%esp
}
  801543:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801546:	c9                   	leave  
  801547:	c3                   	ret    
		return -E_NOT_SUPP;
  801548:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80154d:	eb f4                	jmp    801543 <fstat+0x68>

0080154f <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80154f:	55                   	push   %ebp
  801550:	89 e5                	mov    %esp,%ebp
  801552:	56                   	push   %esi
  801553:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801554:	83 ec 08             	sub    $0x8,%esp
  801557:	6a 00                	push   $0x0
  801559:	ff 75 08             	pushl  0x8(%ebp)
  80155c:	e8 bb 01 00 00       	call   80171c <open>
  801561:	89 c3                	mov    %eax,%ebx
  801563:	83 c4 10             	add    $0x10,%esp
  801566:	85 c0                	test   %eax,%eax
  801568:	78 1b                	js     801585 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80156a:	83 ec 08             	sub    $0x8,%esp
  80156d:	ff 75 0c             	pushl  0xc(%ebp)
  801570:	50                   	push   %eax
  801571:	e8 65 ff ff ff       	call   8014db <fstat>
  801576:	89 c6                	mov    %eax,%esi
	close(fd);
  801578:	89 1c 24             	mov    %ebx,(%esp)
  80157b:	e8 27 fc ff ff       	call   8011a7 <close>
	return r;
  801580:	83 c4 10             	add    $0x10,%esp
  801583:	89 f3                	mov    %esi,%ebx
}
  801585:	89 d8                	mov    %ebx,%eax
  801587:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80158a:	5b                   	pop    %ebx
  80158b:	5e                   	pop    %esi
  80158c:	5d                   	pop    %ebp
  80158d:	c3                   	ret    

0080158e <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80158e:	55                   	push   %ebp
  80158f:	89 e5                	mov    %esp,%ebp
  801591:	56                   	push   %esi
  801592:	53                   	push   %ebx
  801593:	89 c6                	mov    %eax,%esi
  801595:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801597:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  80159e:	74 27                	je     8015c7 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8015a0:	6a 07                	push   $0x7
  8015a2:	68 00 50 80 00       	push   $0x805000
  8015a7:	56                   	push   %esi
  8015a8:	ff 35 04 40 80 00    	pushl  0x804004
  8015ae:	e8 4e 08 00 00       	call   801e01 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8015b3:	83 c4 0c             	add    $0xc,%esp
  8015b6:	6a 00                	push   $0x0
  8015b8:	53                   	push   %ebx
  8015b9:	6a 00                	push   $0x0
  8015bb:	e8 d8 07 00 00       	call   801d98 <ipc_recv>
}
  8015c0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015c3:	5b                   	pop    %ebx
  8015c4:	5e                   	pop    %esi
  8015c5:	5d                   	pop    %ebp
  8015c6:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8015c7:	83 ec 0c             	sub    $0xc,%esp
  8015ca:	6a 01                	push   $0x1
  8015cc:	e8 7d 08 00 00       	call   801e4e <ipc_find_env>
  8015d1:	a3 04 40 80 00       	mov    %eax,0x804004
  8015d6:	83 c4 10             	add    $0x10,%esp
  8015d9:	eb c5                	jmp    8015a0 <fsipc+0x12>

008015db <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8015db:	55                   	push   %ebp
  8015dc:	89 e5                	mov    %esp,%ebp
  8015de:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8015e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e4:	8b 40 0c             	mov    0xc(%eax),%eax
  8015e7:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8015ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ef:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8015f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8015f9:	b8 02 00 00 00       	mov    $0x2,%eax
  8015fe:	e8 8b ff ff ff       	call   80158e <fsipc>
}
  801603:	c9                   	leave  
  801604:	c3                   	ret    

00801605 <devfile_flush>:
{
  801605:	55                   	push   %ebp
  801606:	89 e5                	mov    %esp,%ebp
  801608:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80160b:	8b 45 08             	mov    0x8(%ebp),%eax
  80160e:	8b 40 0c             	mov    0xc(%eax),%eax
  801611:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801616:	ba 00 00 00 00       	mov    $0x0,%edx
  80161b:	b8 06 00 00 00       	mov    $0x6,%eax
  801620:	e8 69 ff ff ff       	call   80158e <fsipc>
}
  801625:	c9                   	leave  
  801626:	c3                   	ret    

00801627 <devfile_stat>:
{
  801627:	55                   	push   %ebp
  801628:	89 e5                	mov    %esp,%ebp
  80162a:	53                   	push   %ebx
  80162b:	83 ec 04             	sub    $0x4,%esp
  80162e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801631:	8b 45 08             	mov    0x8(%ebp),%eax
  801634:	8b 40 0c             	mov    0xc(%eax),%eax
  801637:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80163c:	ba 00 00 00 00       	mov    $0x0,%edx
  801641:	b8 05 00 00 00       	mov    $0x5,%eax
  801646:	e8 43 ff ff ff       	call   80158e <fsipc>
  80164b:	85 c0                	test   %eax,%eax
  80164d:	78 2c                	js     80167b <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80164f:	83 ec 08             	sub    $0x8,%esp
  801652:	68 00 50 80 00       	push   $0x805000
  801657:	53                   	push   %ebx
  801658:	e8 80 f3 ff ff       	call   8009dd <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80165d:	a1 80 50 80 00       	mov    0x805080,%eax
  801662:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801668:	a1 84 50 80 00       	mov    0x805084,%eax
  80166d:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801673:	83 c4 10             	add    $0x10,%esp
  801676:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80167b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80167e:	c9                   	leave  
  80167f:	c3                   	ret    

00801680 <devfile_write>:
{
  801680:	55                   	push   %ebp
  801681:	89 e5                	mov    %esp,%ebp
  801683:	83 ec 0c             	sub    $0xc,%esp
	panic("devfile_write not implemented");
  801686:	68 dc 25 80 00       	push   $0x8025dc
  80168b:	68 90 00 00 00       	push   $0x90
  801690:	68 fa 25 80 00       	push   $0x8025fa
  801695:	e8 42 eb ff ff       	call   8001dc <_panic>

0080169a <devfile_read>:
{
  80169a:	55                   	push   %ebp
  80169b:	89 e5                	mov    %esp,%ebp
  80169d:	56                   	push   %esi
  80169e:	53                   	push   %ebx
  80169f:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8016a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8016a8:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8016ad:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8016b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8016b8:	b8 03 00 00 00       	mov    $0x3,%eax
  8016bd:	e8 cc fe ff ff       	call   80158e <fsipc>
  8016c2:	89 c3                	mov    %eax,%ebx
  8016c4:	85 c0                	test   %eax,%eax
  8016c6:	78 1f                	js     8016e7 <devfile_read+0x4d>
	assert(r <= n);
  8016c8:	39 f0                	cmp    %esi,%eax
  8016ca:	77 24                	ja     8016f0 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8016cc:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016d1:	7f 33                	jg     801706 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8016d3:	83 ec 04             	sub    $0x4,%esp
  8016d6:	50                   	push   %eax
  8016d7:	68 00 50 80 00       	push   $0x805000
  8016dc:	ff 75 0c             	pushl  0xc(%ebp)
  8016df:	e8 87 f4 ff ff       	call   800b6b <memmove>
	return r;
  8016e4:	83 c4 10             	add    $0x10,%esp
}
  8016e7:	89 d8                	mov    %ebx,%eax
  8016e9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016ec:	5b                   	pop    %ebx
  8016ed:	5e                   	pop    %esi
  8016ee:	5d                   	pop    %ebp
  8016ef:	c3                   	ret    
	assert(r <= n);
  8016f0:	68 05 26 80 00       	push   $0x802605
  8016f5:	68 0c 26 80 00       	push   $0x80260c
  8016fa:	6a 7c                	push   $0x7c
  8016fc:	68 fa 25 80 00       	push   $0x8025fa
  801701:	e8 d6 ea ff ff       	call   8001dc <_panic>
	assert(r <= PGSIZE);
  801706:	68 21 26 80 00       	push   $0x802621
  80170b:	68 0c 26 80 00       	push   $0x80260c
  801710:	6a 7d                	push   $0x7d
  801712:	68 fa 25 80 00       	push   $0x8025fa
  801717:	e8 c0 ea ff ff       	call   8001dc <_panic>

0080171c <open>:
{
  80171c:	55                   	push   %ebp
  80171d:	89 e5                	mov    %esp,%ebp
  80171f:	56                   	push   %esi
  801720:	53                   	push   %ebx
  801721:	83 ec 1c             	sub    $0x1c,%esp
  801724:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801727:	56                   	push   %esi
  801728:	e8 77 f2 ff ff       	call   8009a4 <strlen>
  80172d:	83 c4 10             	add    $0x10,%esp
  801730:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801735:	7f 6c                	jg     8017a3 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801737:	83 ec 0c             	sub    $0xc,%esp
  80173a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80173d:	50                   	push   %eax
  80173e:	e8 e5 f8 ff ff       	call   801028 <fd_alloc>
  801743:	89 c3                	mov    %eax,%ebx
  801745:	83 c4 10             	add    $0x10,%esp
  801748:	85 c0                	test   %eax,%eax
  80174a:	78 3c                	js     801788 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80174c:	83 ec 08             	sub    $0x8,%esp
  80174f:	56                   	push   %esi
  801750:	68 00 50 80 00       	push   $0x805000
  801755:	e8 83 f2 ff ff       	call   8009dd <strcpy>
	fsipcbuf.open.req_omode = mode;
  80175a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80175d:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801762:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801765:	b8 01 00 00 00       	mov    $0x1,%eax
  80176a:	e8 1f fe ff ff       	call   80158e <fsipc>
  80176f:	89 c3                	mov    %eax,%ebx
  801771:	83 c4 10             	add    $0x10,%esp
  801774:	85 c0                	test   %eax,%eax
  801776:	78 19                	js     801791 <open+0x75>
	return fd2num(fd);
  801778:	83 ec 0c             	sub    $0xc,%esp
  80177b:	ff 75 f4             	pushl  -0xc(%ebp)
  80177e:	e8 7e f8 ff ff       	call   801001 <fd2num>
  801783:	89 c3                	mov    %eax,%ebx
  801785:	83 c4 10             	add    $0x10,%esp
}
  801788:	89 d8                	mov    %ebx,%eax
  80178a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80178d:	5b                   	pop    %ebx
  80178e:	5e                   	pop    %esi
  80178f:	5d                   	pop    %ebp
  801790:	c3                   	ret    
		fd_close(fd, 0);
  801791:	83 ec 08             	sub    $0x8,%esp
  801794:	6a 00                	push   $0x0
  801796:	ff 75 f4             	pushl  -0xc(%ebp)
  801799:	e8 82 f9 ff ff       	call   801120 <fd_close>
		return r;
  80179e:	83 c4 10             	add    $0x10,%esp
  8017a1:	eb e5                	jmp    801788 <open+0x6c>
		return -E_BAD_PATH;
  8017a3:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8017a8:	eb de                	jmp    801788 <open+0x6c>

008017aa <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8017aa:	55                   	push   %ebp
  8017ab:	89 e5                	mov    %esp,%ebp
  8017ad:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8017b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8017b5:	b8 08 00 00 00       	mov    $0x8,%eax
  8017ba:	e8 cf fd ff ff       	call   80158e <fsipc>
}
  8017bf:	c9                   	leave  
  8017c0:	c3                   	ret    

008017c1 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  8017c1:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  8017c5:	7f 01                	jg     8017c8 <writebuf+0x7>
  8017c7:	c3                   	ret    
{
  8017c8:	55                   	push   %ebp
  8017c9:	89 e5                	mov    %esp,%ebp
  8017cb:	53                   	push   %ebx
  8017cc:	83 ec 08             	sub    $0x8,%esp
  8017cf:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  8017d1:	ff 70 04             	pushl  0x4(%eax)
  8017d4:	8d 40 10             	lea    0x10(%eax),%eax
  8017d7:	50                   	push   %eax
  8017d8:	ff 33                	pushl  (%ebx)
  8017da:	e8 d2 fb ff ff       	call   8013b1 <write>
		if (result > 0)
  8017df:	83 c4 10             	add    $0x10,%esp
  8017e2:	85 c0                	test   %eax,%eax
  8017e4:	7e 03                	jle    8017e9 <writebuf+0x28>
			b->result += result;
  8017e6:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  8017e9:	39 43 04             	cmp    %eax,0x4(%ebx)
  8017ec:	74 0d                	je     8017fb <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  8017ee:	85 c0                	test   %eax,%eax
  8017f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8017f5:	0f 4f c2             	cmovg  %edx,%eax
  8017f8:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  8017fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017fe:	c9                   	leave  
  8017ff:	c3                   	ret    

00801800 <putch>:

static void
putch(int ch, void *thunk)
{
  801800:	55                   	push   %ebp
  801801:	89 e5                	mov    %esp,%ebp
  801803:	53                   	push   %ebx
  801804:	83 ec 04             	sub    $0x4,%esp
  801807:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  80180a:	8b 53 04             	mov    0x4(%ebx),%edx
  80180d:	8d 42 01             	lea    0x1(%edx),%eax
  801810:	89 43 04             	mov    %eax,0x4(%ebx)
  801813:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801816:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  80181a:	3d 00 01 00 00       	cmp    $0x100,%eax
  80181f:	74 06                	je     801827 <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  801821:	83 c4 04             	add    $0x4,%esp
  801824:	5b                   	pop    %ebx
  801825:	5d                   	pop    %ebp
  801826:	c3                   	ret    
		writebuf(b);
  801827:	89 d8                	mov    %ebx,%eax
  801829:	e8 93 ff ff ff       	call   8017c1 <writebuf>
		b->idx = 0;
  80182e:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  801835:	eb ea                	jmp    801821 <putch+0x21>

00801837 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801837:	55                   	push   %ebp
  801838:	89 e5                	mov    %esp,%ebp
  80183a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  801840:	8b 45 08             	mov    0x8(%ebp),%eax
  801843:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801849:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801850:	00 00 00 
	b.result = 0;
  801853:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80185a:	00 00 00 
	b.error = 1;
  80185d:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801864:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801867:	ff 75 10             	pushl  0x10(%ebp)
  80186a:	ff 75 0c             	pushl  0xc(%ebp)
  80186d:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801873:	50                   	push   %eax
  801874:	68 00 18 80 00       	push   $0x801800
  801879:	e8 66 eb ff ff       	call   8003e4 <vprintfmt>
	if (b.idx > 0)
  80187e:	83 c4 10             	add    $0x10,%esp
  801881:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801888:	7f 11                	jg     80189b <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  80188a:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801890:	85 c0                	test   %eax,%eax
  801892:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801899:	c9                   	leave  
  80189a:	c3                   	ret    
		writebuf(&b);
  80189b:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8018a1:	e8 1b ff ff ff       	call   8017c1 <writebuf>
  8018a6:	eb e2                	jmp    80188a <vfprintf+0x53>

008018a8 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  8018a8:	55                   	push   %ebp
  8018a9:	89 e5                	mov    %esp,%ebp
  8018ab:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8018ae:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  8018b1:	50                   	push   %eax
  8018b2:	ff 75 0c             	pushl  0xc(%ebp)
  8018b5:	ff 75 08             	pushl  0x8(%ebp)
  8018b8:	e8 7a ff ff ff       	call   801837 <vfprintf>
	va_end(ap);

	return cnt;
}
  8018bd:	c9                   	leave  
  8018be:	c3                   	ret    

008018bf <printf>:

int
printf(const char *fmt, ...)
{
  8018bf:	55                   	push   %ebp
  8018c0:	89 e5                	mov    %esp,%ebp
  8018c2:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8018c5:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  8018c8:	50                   	push   %eax
  8018c9:	ff 75 08             	pushl  0x8(%ebp)
  8018cc:	6a 01                	push   $0x1
  8018ce:	e8 64 ff ff ff       	call   801837 <vfprintf>
	va_end(ap);

	return cnt;
}
  8018d3:	c9                   	leave  
  8018d4:	c3                   	ret    

008018d5 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8018d5:	55                   	push   %ebp
  8018d6:	89 e5                	mov    %esp,%ebp
  8018d8:	56                   	push   %esi
  8018d9:	53                   	push   %ebx
  8018da:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8018dd:	83 ec 0c             	sub    $0xc,%esp
  8018e0:	ff 75 08             	pushl  0x8(%ebp)
  8018e3:	e8 29 f7 ff ff       	call   801011 <fd2data>
  8018e8:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8018ea:	83 c4 08             	add    $0x8,%esp
  8018ed:	68 2d 26 80 00       	push   $0x80262d
  8018f2:	53                   	push   %ebx
  8018f3:	e8 e5 f0 ff ff       	call   8009dd <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8018f8:	8b 46 04             	mov    0x4(%esi),%eax
  8018fb:	2b 06                	sub    (%esi),%eax
  8018fd:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801903:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80190a:	00 00 00 
	stat->st_dev = &devpipe;
  80190d:	c7 83 88 00 00 00 24 	movl   $0x803024,0x88(%ebx)
  801914:	30 80 00 
	return 0;
}
  801917:	b8 00 00 00 00       	mov    $0x0,%eax
  80191c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80191f:	5b                   	pop    %ebx
  801920:	5e                   	pop    %esi
  801921:	5d                   	pop    %ebp
  801922:	c3                   	ret    

00801923 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801923:	55                   	push   %ebp
  801924:	89 e5                	mov    %esp,%ebp
  801926:	53                   	push   %ebx
  801927:	83 ec 0c             	sub    $0xc,%esp
  80192a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80192d:	53                   	push   %ebx
  80192e:	6a 00                	push   $0x0
  801930:	e8 1f f5 ff ff       	call   800e54 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801935:	89 1c 24             	mov    %ebx,(%esp)
  801938:	e8 d4 f6 ff ff       	call   801011 <fd2data>
  80193d:	83 c4 08             	add    $0x8,%esp
  801940:	50                   	push   %eax
  801941:	6a 00                	push   $0x0
  801943:	e8 0c f5 ff ff       	call   800e54 <sys_page_unmap>
}
  801948:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80194b:	c9                   	leave  
  80194c:	c3                   	ret    

0080194d <_pipeisclosed>:
{
  80194d:	55                   	push   %ebp
  80194e:	89 e5                	mov    %esp,%ebp
  801950:	57                   	push   %edi
  801951:	56                   	push   %esi
  801952:	53                   	push   %ebx
  801953:	83 ec 1c             	sub    $0x1c,%esp
  801956:	89 c7                	mov    %eax,%edi
  801958:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80195a:	a1 08 40 80 00       	mov    0x804008,%eax
  80195f:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801962:	83 ec 0c             	sub    $0xc,%esp
  801965:	57                   	push   %edi
  801966:	e8 22 05 00 00       	call   801e8d <pageref>
  80196b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80196e:	89 34 24             	mov    %esi,(%esp)
  801971:	e8 17 05 00 00       	call   801e8d <pageref>
		nn = thisenv->env_runs;
  801976:	8b 15 08 40 80 00    	mov    0x804008,%edx
  80197c:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80197f:	83 c4 10             	add    $0x10,%esp
  801982:	39 cb                	cmp    %ecx,%ebx
  801984:	74 1b                	je     8019a1 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801986:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801989:	75 cf                	jne    80195a <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80198b:	8b 42 58             	mov    0x58(%edx),%eax
  80198e:	6a 01                	push   $0x1
  801990:	50                   	push   %eax
  801991:	53                   	push   %ebx
  801992:	68 34 26 80 00       	push   $0x802634
  801997:	e8 1b e9 ff ff       	call   8002b7 <cprintf>
  80199c:	83 c4 10             	add    $0x10,%esp
  80199f:	eb b9                	jmp    80195a <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8019a1:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8019a4:	0f 94 c0             	sete   %al
  8019a7:	0f b6 c0             	movzbl %al,%eax
}
  8019aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019ad:	5b                   	pop    %ebx
  8019ae:	5e                   	pop    %esi
  8019af:	5f                   	pop    %edi
  8019b0:	5d                   	pop    %ebp
  8019b1:	c3                   	ret    

008019b2 <devpipe_write>:
{
  8019b2:	55                   	push   %ebp
  8019b3:	89 e5                	mov    %esp,%ebp
  8019b5:	57                   	push   %edi
  8019b6:	56                   	push   %esi
  8019b7:	53                   	push   %ebx
  8019b8:	83 ec 28             	sub    $0x28,%esp
  8019bb:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8019be:	56                   	push   %esi
  8019bf:	e8 4d f6 ff ff       	call   801011 <fd2data>
  8019c4:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8019c6:	83 c4 10             	add    $0x10,%esp
  8019c9:	bf 00 00 00 00       	mov    $0x0,%edi
  8019ce:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8019d1:	74 4f                	je     801a22 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8019d3:	8b 43 04             	mov    0x4(%ebx),%eax
  8019d6:	8b 0b                	mov    (%ebx),%ecx
  8019d8:	8d 51 20             	lea    0x20(%ecx),%edx
  8019db:	39 d0                	cmp    %edx,%eax
  8019dd:	72 14                	jb     8019f3 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8019df:	89 da                	mov    %ebx,%edx
  8019e1:	89 f0                	mov    %esi,%eax
  8019e3:	e8 65 ff ff ff       	call   80194d <_pipeisclosed>
  8019e8:	85 c0                	test   %eax,%eax
  8019ea:	75 3b                	jne    801a27 <devpipe_write+0x75>
			sys_yield();
  8019ec:	e8 bf f3 ff ff       	call   800db0 <sys_yield>
  8019f1:	eb e0                	jmp    8019d3 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8019f3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019f6:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8019fa:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8019fd:	89 c2                	mov    %eax,%edx
  8019ff:	c1 fa 1f             	sar    $0x1f,%edx
  801a02:	89 d1                	mov    %edx,%ecx
  801a04:	c1 e9 1b             	shr    $0x1b,%ecx
  801a07:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801a0a:	83 e2 1f             	and    $0x1f,%edx
  801a0d:	29 ca                	sub    %ecx,%edx
  801a0f:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801a13:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801a17:	83 c0 01             	add    $0x1,%eax
  801a1a:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801a1d:	83 c7 01             	add    $0x1,%edi
  801a20:	eb ac                	jmp    8019ce <devpipe_write+0x1c>
	return i;
  801a22:	8b 45 10             	mov    0x10(%ebp),%eax
  801a25:	eb 05                	jmp    801a2c <devpipe_write+0x7a>
				return 0;
  801a27:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a2f:	5b                   	pop    %ebx
  801a30:	5e                   	pop    %esi
  801a31:	5f                   	pop    %edi
  801a32:	5d                   	pop    %ebp
  801a33:	c3                   	ret    

00801a34 <devpipe_read>:
{
  801a34:	55                   	push   %ebp
  801a35:	89 e5                	mov    %esp,%ebp
  801a37:	57                   	push   %edi
  801a38:	56                   	push   %esi
  801a39:	53                   	push   %ebx
  801a3a:	83 ec 18             	sub    $0x18,%esp
  801a3d:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801a40:	57                   	push   %edi
  801a41:	e8 cb f5 ff ff       	call   801011 <fd2data>
  801a46:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801a48:	83 c4 10             	add    $0x10,%esp
  801a4b:	be 00 00 00 00       	mov    $0x0,%esi
  801a50:	3b 75 10             	cmp    0x10(%ebp),%esi
  801a53:	75 14                	jne    801a69 <devpipe_read+0x35>
	return i;
  801a55:	8b 45 10             	mov    0x10(%ebp),%eax
  801a58:	eb 02                	jmp    801a5c <devpipe_read+0x28>
				return i;
  801a5a:	89 f0                	mov    %esi,%eax
}
  801a5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a5f:	5b                   	pop    %ebx
  801a60:	5e                   	pop    %esi
  801a61:	5f                   	pop    %edi
  801a62:	5d                   	pop    %ebp
  801a63:	c3                   	ret    
			sys_yield();
  801a64:	e8 47 f3 ff ff       	call   800db0 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801a69:	8b 03                	mov    (%ebx),%eax
  801a6b:	3b 43 04             	cmp    0x4(%ebx),%eax
  801a6e:	75 18                	jne    801a88 <devpipe_read+0x54>
			if (i > 0)
  801a70:	85 f6                	test   %esi,%esi
  801a72:	75 e6                	jne    801a5a <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801a74:	89 da                	mov    %ebx,%edx
  801a76:	89 f8                	mov    %edi,%eax
  801a78:	e8 d0 fe ff ff       	call   80194d <_pipeisclosed>
  801a7d:	85 c0                	test   %eax,%eax
  801a7f:	74 e3                	je     801a64 <devpipe_read+0x30>
				return 0;
  801a81:	b8 00 00 00 00       	mov    $0x0,%eax
  801a86:	eb d4                	jmp    801a5c <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801a88:	99                   	cltd   
  801a89:	c1 ea 1b             	shr    $0x1b,%edx
  801a8c:	01 d0                	add    %edx,%eax
  801a8e:	83 e0 1f             	and    $0x1f,%eax
  801a91:	29 d0                	sub    %edx,%eax
  801a93:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801a98:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a9b:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801a9e:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801aa1:	83 c6 01             	add    $0x1,%esi
  801aa4:	eb aa                	jmp    801a50 <devpipe_read+0x1c>

00801aa6 <pipe>:
{
  801aa6:	55                   	push   %ebp
  801aa7:	89 e5                	mov    %esp,%ebp
  801aa9:	56                   	push   %esi
  801aaa:	53                   	push   %ebx
  801aab:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801aae:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ab1:	50                   	push   %eax
  801ab2:	e8 71 f5 ff ff       	call   801028 <fd_alloc>
  801ab7:	89 c3                	mov    %eax,%ebx
  801ab9:	83 c4 10             	add    $0x10,%esp
  801abc:	85 c0                	test   %eax,%eax
  801abe:	0f 88 23 01 00 00    	js     801be7 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ac4:	83 ec 04             	sub    $0x4,%esp
  801ac7:	68 07 04 00 00       	push   $0x407
  801acc:	ff 75 f4             	pushl  -0xc(%ebp)
  801acf:	6a 00                	push   $0x0
  801ad1:	e8 f9 f2 ff ff       	call   800dcf <sys_page_alloc>
  801ad6:	89 c3                	mov    %eax,%ebx
  801ad8:	83 c4 10             	add    $0x10,%esp
  801adb:	85 c0                	test   %eax,%eax
  801add:	0f 88 04 01 00 00    	js     801be7 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801ae3:	83 ec 0c             	sub    $0xc,%esp
  801ae6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ae9:	50                   	push   %eax
  801aea:	e8 39 f5 ff ff       	call   801028 <fd_alloc>
  801aef:	89 c3                	mov    %eax,%ebx
  801af1:	83 c4 10             	add    $0x10,%esp
  801af4:	85 c0                	test   %eax,%eax
  801af6:	0f 88 db 00 00 00    	js     801bd7 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801afc:	83 ec 04             	sub    $0x4,%esp
  801aff:	68 07 04 00 00       	push   $0x407
  801b04:	ff 75 f0             	pushl  -0x10(%ebp)
  801b07:	6a 00                	push   $0x0
  801b09:	e8 c1 f2 ff ff       	call   800dcf <sys_page_alloc>
  801b0e:	89 c3                	mov    %eax,%ebx
  801b10:	83 c4 10             	add    $0x10,%esp
  801b13:	85 c0                	test   %eax,%eax
  801b15:	0f 88 bc 00 00 00    	js     801bd7 <pipe+0x131>
	va = fd2data(fd0);
  801b1b:	83 ec 0c             	sub    $0xc,%esp
  801b1e:	ff 75 f4             	pushl  -0xc(%ebp)
  801b21:	e8 eb f4 ff ff       	call   801011 <fd2data>
  801b26:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b28:	83 c4 0c             	add    $0xc,%esp
  801b2b:	68 07 04 00 00       	push   $0x407
  801b30:	50                   	push   %eax
  801b31:	6a 00                	push   $0x0
  801b33:	e8 97 f2 ff ff       	call   800dcf <sys_page_alloc>
  801b38:	89 c3                	mov    %eax,%ebx
  801b3a:	83 c4 10             	add    $0x10,%esp
  801b3d:	85 c0                	test   %eax,%eax
  801b3f:	0f 88 82 00 00 00    	js     801bc7 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b45:	83 ec 0c             	sub    $0xc,%esp
  801b48:	ff 75 f0             	pushl  -0x10(%ebp)
  801b4b:	e8 c1 f4 ff ff       	call   801011 <fd2data>
  801b50:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801b57:	50                   	push   %eax
  801b58:	6a 00                	push   $0x0
  801b5a:	56                   	push   %esi
  801b5b:	6a 00                	push   $0x0
  801b5d:	e8 b0 f2 ff ff       	call   800e12 <sys_page_map>
  801b62:	89 c3                	mov    %eax,%ebx
  801b64:	83 c4 20             	add    $0x20,%esp
  801b67:	85 c0                	test   %eax,%eax
  801b69:	78 4e                	js     801bb9 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801b6b:	a1 24 30 80 00       	mov    0x803024,%eax
  801b70:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b73:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801b75:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b78:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801b7f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b82:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801b84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b87:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801b8e:	83 ec 0c             	sub    $0xc,%esp
  801b91:	ff 75 f4             	pushl  -0xc(%ebp)
  801b94:	e8 68 f4 ff ff       	call   801001 <fd2num>
  801b99:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b9c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801b9e:	83 c4 04             	add    $0x4,%esp
  801ba1:	ff 75 f0             	pushl  -0x10(%ebp)
  801ba4:	e8 58 f4 ff ff       	call   801001 <fd2num>
  801ba9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801bac:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801baf:	83 c4 10             	add    $0x10,%esp
  801bb2:	bb 00 00 00 00       	mov    $0x0,%ebx
  801bb7:	eb 2e                	jmp    801be7 <pipe+0x141>
	sys_page_unmap(0, va);
  801bb9:	83 ec 08             	sub    $0x8,%esp
  801bbc:	56                   	push   %esi
  801bbd:	6a 00                	push   $0x0
  801bbf:	e8 90 f2 ff ff       	call   800e54 <sys_page_unmap>
  801bc4:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801bc7:	83 ec 08             	sub    $0x8,%esp
  801bca:	ff 75 f0             	pushl  -0x10(%ebp)
  801bcd:	6a 00                	push   $0x0
  801bcf:	e8 80 f2 ff ff       	call   800e54 <sys_page_unmap>
  801bd4:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801bd7:	83 ec 08             	sub    $0x8,%esp
  801bda:	ff 75 f4             	pushl  -0xc(%ebp)
  801bdd:	6a 00                	push   $0x0
  801bdf:	e8 70 f2 ff ff       	call   800e54 <sys_page_unmap>
  801be4:	83 c4 10             	add    $0x10,%esp
}
  801be7:	89 d8                	mov    %ebx,%eax
  801be9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bec:	5b                   	pop    %ebx
  801bed:	5e                   	pop    %esi
  801bee:	5d                   	pop    %ebp
  801bef:	c3                   	ret    

00801bf0 <pipeisclosed>:
{
  801bf0:	55                   	push   %ebp
  801bf1:	89 e5                	mov    %esp,%ebp
  801bf3:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801bf6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bf9:	50                   	push   %eax
  801bfa:	ff 75 08             	pushl  0x8(%ebp)
  801bfd:	e8 78 f4 ff ff       	call   80107a <fd_lookup>
  801c02:	83 c4 10             	add    $0x10,%esp
  801c05:	85 c0                	test   %eax,%eax
  801c07:	78 18                	js     801c21 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801c09:	83 ec 0c             	sub    $0xc,%esp
  801c0c:	ff 75 f4             	pushl  -0xc(%ebp)
  801c0f:	e8 fd f3 ff ff       	call   801011 <fd2data>
	return _pipeisclosed(fd, p);
  801c14:	89 c2                	mov    %eax,%edx
  801c16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c19:	e8 2f fd ff ff       	call   80194d <_pipeisclosed>
  801c1e:	83 c4 10             	add    $0x10,%esp
}
  801c21:	c9                   	leave  
  801c22:	c3                   	ret    

00801c23 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801c23:	b8 00 00 00 00       	mov    $0x0,%eax
  801c28:	c3                   	ret    

00801c29 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801c29:	55                   	push   %ebp
  801c2a:	89 e5                	mov    %esp,%ebp
  801c2c:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801c2f:	68 4c 26 80 00       	push   $0x80264c
  801c34:	ff 75 0c             	pushl  0xc(%ebp)
  801c37:	e8 a1 ed ff ff       	call   8009dd <strcpy>
	return 0;
}
  801c3c:	b8 00 00 00 00       	mov    $0x0,%eax
  801c41:	c9                   	leave  
  801c42:	c3                   	ret    

00801c43 <devcons_write>:
{
  801c43:	55                   	push   %ebp
  801c44:	89 e5                	mov    %esp,%ebp
  801c46:	57                   	push   %edi
  801c47:	56                   	push   %esi
  801c48:	53                   	push   %ebx
  801c49:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801c4f:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801c54:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801c5a:	3b 75 10             	cmp    0x10(%ebp),%esi
  801c5d:	73 31                	jae    801c90 <devcons_write+0x4d>
		m = n - tot;
  801c5f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801c62:	29 f3                	sub    %esi,%ebx
  801c64:	83 fb 7f             	cmp    $0x7f,%ebx
  801c67:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801c6c:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801c6f:	83 ec 04             	sub    $0x4,%esp
  801c72:	53                   	push   %ebx
  801c73:	89 f0                	mov    %esi,%eax
  801c75:	03 45 0c             	add    0xc(%ebp),%eax
  801c78:	50                   	push   %eax
  801c79:	57                   	push   %edi
  801c7a:	e8 ec ee ff ff       	call   800b6b <memmove>
		sys_cputs(buf, m);
  801c7f:	83 c4 08             	add    $0x8,%esp
  801c82:	53                   	push   %ebx
  801c83:	57                   	push   %edi
  801c84:	e8 8a f0 ff ff       	call   800d13 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801c89:	01 de                	add    %ebx,%esi
  801c8b:	83 c4 10             	add    $0x10,%esp
  801c8e:	eb ca                	jmp    801c5a <devcons_write+0x17>
}
  801c90:	89 f0                	mov    %esi,%eax
  801c92:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c95:	5b                   	pop    %ebx
  801c96:	5e                   	pop    %esi
  801c97:	5f                   	pop    %edi
  801c98:	5d                   	pop    %ebp
  801c99:	c3                   	ret    

00801c9a <devcons_read>:
{
  801c9a:	55                   	push   %ebp
  801c9b:	89 e5                	mov    %esp,%ebp
  801c9d:	83 ec 08             	sub    $0x8,%esp
  801ca0:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801ca5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ca9:	74 21                	je     801ccc <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  801cab:	e8 81 f0 ff ff       	call   800d31 <sys_cgetc>
  801cb0:	85 c0                	test   %eax,%eax
  801cb2:	75 07                	jne    801cbb <devcons_read+0x21>
		sys_yield();
  801cb4:	e8 f7 f0 ff ff       	call   800db0 <sys_yield>
  801cb9:	eb f0                	jmp    801cab <devcons_read+0x11>
	if (c < 0)
  801cbb:	78 0f                	js     801ccc <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  801cbd:	83 f8 04             	cmp    $0x4,%eax
  801cc0:	74 0c                	je     801cce <devcons_read+0x34>
	*(char*)vbuf = c;
  801cc2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cc5:	88 02                	mov    %al,(%edx)
	return 1;
  801cc7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801ccc:	c9                   	leave  
  801ccd:	c3                   	ret    
		return 0;
  801cce:	b8 00 00 00 00       	mov    $0x0,%eax
  801cd3:	eb f7                	jmp    801ccc <devcons_read+0x32>

00801cd5 <cputchar>:
{
  801cd5:	55                   	push   %ebp
  801cd6:	89 e5                	mov    %esp,%ebp
  801cd8:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cde:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801ce1:	6a 01                	push   $0x1
  801ce3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801ce6:	50                   	push   %eax
  801ce7:	e8 27 f0 ff ff       	call   800d13 <sys_cputs>
}
  801cec:	83 c4 10             	add    $0x10,%esp
  801cef:	c9                   	leave  
  801cf0:	c3                   	ret    

00801cf1 <getchar>:
{
  801cf1:	55                   	push   %ebp
  801cf2:	89 e5                	mov    %esp,%ebp
  801cf4:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801cf7:	6a 01                	push   $0x1
  801cf9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801cfc:	50                   	push   %eax
  801cfd:	6a 00                	push   $0x0
  801cff:	e8 e1 f5 ff ff       	call   8012e5 <read>
	if (r < 0)
  801d04:	83 c4 10             	add    $0x10,%esp
  801d07:	85 c0                	test   %eax,%eax
  801d09:	78 06                	js     801d11 <getchar+0x20>
	if (r < 1)
  801d0b:	74 06                	je     801d13 <getchar+0x22>
	return c;
  801d0d:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801d11:	c9                   	leave  
  801d12:	c3                   	ret    
		return -E_EOF;
  801d13:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801d18:	eb f7                	jmp    801d11 <getchar+0x20>

00801d1a <iscons>:
{
  801d1a:	55                   	push   %ebp
  801d1b:	89 e5                	mov    %esp,%ebp
  801d1d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d20:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d23:	50                   	push   %eax
  801d24:	ff 75 08             	pushl  0x8(%ebp)
  801d27:	e8 4e f3 ff ff       	call   80107a <fd_lookup>
  801d2c:	83 c4 10             	add    $0x10,%esp
  801d2f:	85 c0                	test   %eax,%eax
  801d31:	78 11                	js     801d44 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801d33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d36:	8b 15 40 30 80 00    	mov    0x803040,%edx
  801d3c:	39 10                	cmp    %edx,(%eax)
  801d3e:	0f 94 c0             	sete   %al
  801d41:	0f b6 c0             	movzbl %al,%eax
}
  801d44:	c9                   	leave  
  801d45:	c3                   	ret    

00801d46 <opencons>:
{
  801d46:	55                   	push   %ebp
  801d47:	89 e5                	mov    %esp,%ebp
  801d49:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801d4c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d4f:	50                   	push   %eax
  801d50:	e8 d3 f2 ff ff       	call   801028 <fd_alloc>
  801d55:	83 c4 10             	add    $0x10,%esp
  801d58:	85 c0                	test   %eax,%eax
  801d5a:	78 3a                	js     801d96 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801d5c:	83 ec 04             	sub    $0x4,%esp
  801d5f:	68 07 04 00 00       	push   $0x407
  801d64:	ff 75 f4             	pushl  -0xc(%ebp)
  801d67:	6a 00                	push   $0x0
  801d69:	e8 61 f0 ff ff       	call   800dcf <sys_page_alloc>
  801d6e:	83 c4 10             	add    $0x10,%esp
  801d71:	85 c0                	test   %eax,%eax
  801d73:	78 21                	js     801d96 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d78:	8b 15 40 30 80 00    	mov    0x803040,%edx
  801d7e:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d83:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801d8a:	83 ec 0c             	sub    $0xc,%esp
  801d8d:	50                   	push   %eax
  801d8e:	e8 6e f2 ff ff       	call   801001 <fd2num>
  801d93:	83 c4 10             	add    $0x10,%esp
}
  801d96:	c9                   	leave  
  801d97:	c3                   	ret    

00801d98 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801d98:	55                   	push   %ebp
  801d99:	89 e5                	mov    %esp,%ebp
  801d9b:	56                   	push   %esi
  801d9c:	53                   	push   %ebx
  801d9d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801da0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801da3:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// return 0;
	if(!pg)
  801da6:	85 c0                	test   %eax,%eax
		pg = (void*)UTOP;
  801da8:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801dad:	0f 44 c2             	cmove  %edx,%eax
	
	int ret;

	ret = sys_ipc_recv(pg);
  801db0:	83 ec 0c             	sub    $0xc,%esp
  801db3:	50                   	push   %eax
  801db4:	e8 c6 f1 ff ff       	call   800f7f <sys_ipc_recv>
	if(ret < 0){
  801db9:	83 c4 10             	add    $0x10,%esp
  801dbc:	85 c0                	test   %eax,%eax
  801dbe:	78 2b                	js     801deb <ipc_recv+0x53>
		if(perm_store) *perm_store = 0;
		if(from_env_store) *from_env_store = 0;
		return ret;
	}
	
	if(perm_store)
  801dc0:	85 f6                	test   %esi,%esi
  801dc2:	74 0a                	je     801dce <ipc_recv+0x36>
		*perm_store = thisenv->env_ipc_perm;
  801dc4:	a1 08 40 80 00       	mov    0x804008,%eax
  801dc9:	8b 40 78             	mov    0x78(%eax),%eax
  801dcc:	89 06                	mov    %eax,(%esi)
	if(from_env_store)
  801dce:	85 db                	test   %ebx,%ebx
  801dd0:	74 0a                	je     801ddc <ipc_recv+0x44>
		*from_env_store = thisenv->env_ipc_from;
  801dd2:	a1 08 40 80 00       	mov    0x804008,%eax
  801dd7:	8b 40 74             	mov    0x74(%eax),%eax
  801dda:	89 03                	mov    %eax,(%ebx)

	return thisenv->env_ipc_value;
  801ddc:	a1 08 40 80 00       	mov    0x804008,%eax
  801de1:	8b 40 70             	mov    0x70(%eax),%eax
}
  801de4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801de7:	5b                   	pop    %ebx
  801de8:	5e                   	pop    %esi
  801de9:	5d                   	pop    %ebp
  801dea:	c3                   	ret    
		if(perm_store) *perm_store = 0;
  801deb:	85 f6                	test   %esi,%esi
  801ded:	74 06                	je     801df5 <ipc_recv+0x5d>
  801def:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(from_env_store) *from_env_store = 0;
  801df5:	85 db                	test   %ebx,%ebx
  801df7:	74 eb                	je     801de4 <ipc_recv+0x4c>
  801df9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801dff:	eb e3                	jmp    801de4 <ipc_recv+0x4c>

00801e01 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801e01:	55                   	push   %ebp
  801e02:	89 e5                	mov    %esp,%ebp
  801e04:	57                   	push   %edi
  801e05:	56                   	push   %esi
  801e06:	53                   	push   %ebx
  801e07:	83 ec 0c             	sub    $0xc,%esp
  801e0a:	8b 7d 08             	mov    0x8(%ebp),%edi
  801e0d:	8b 75 0c             	mov    0xc(%ebp),%esi
  801e10:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
	if (!pg)
  801e13:	85 db                	test   %ebx,%ebx
		pg = (void*)UTOP;
  801e15:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801e1a:	0f 44 d8             	cmove  %eax,%ebx

	int ret = -E_IPC_NOT_RECV;
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))) {
  801e1d:	ff 75 14             	pushl  0x14(%ebp)
  801e20:	53                   	push   %ebx
  801e21:	56                   	push   %esi
  801e22:	57                   	push   %edi
  801e23:	e8 34 f1 ff ff       	call   800f5c <sys_ipc_try_send>
  801e28:	83 c4 10             	add    $0x10,%esp
  801e2b:	85 c0                	test   %eax,%eax
  801e2d:	74 17                	je     801e46 <ipc_send+0x45>
		if(ret != -E_IPC_NOT_RECV){
  801e2f:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801e32:	74 e9                	je     801e1d <ipc_send+0x1c>
			panic("ipc_send: ret : %d", ret);
  801e34:	50                   	push   %eax
  801e35:	68 58 26 80 00       	push   $0x802658
  801e3a:	6a 43                	push   $0x43
  801e3c:	68 6b 26 80 00       	push   $0x80266b
  801e41:	e8 96 e3 ff ff       	call   8001dc <_panic>
			sys_yield();
		}
	}
}
  801e46:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e49:	5b                   	pop    %ebx
  801e4a:	5e                   	pop    %esi
  801e4b:	5f                   	pop    %edi
  801e4c:	5d                   	pop    %ebp
  801e4d:	c3                   	ret    

00801e4e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801e4e:	55                   	push   %ebp
  801e4f:	89 e5                	mov    %esp,%ebp
  801e51:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801e54:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801e59:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  801e5f:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801e65:	8b 52 50             	mov    0x50(%edx),%edx
  801e68:	39 ca                	cmp    %ecx,%edx
  801e6a:	74 11                	je     801e7d <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  801e6c:	83 c0 01             	add    $0x1,%eax
  801e6f:	3d 00 04 00 00       	cmp    $0x400,%eax
  801e74:	75 e3                	jne    801e59 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801e76:	b8 00 00 00 00       	mov    $0x0,%eax
  801e7b:	eb 0e                	jmp    801e8b <ipc_find_env+0x3d>
			return envs[i].env_id;
  801e7d:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  801e83:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801e88:	8b 40 48             	mov    0x48(%eax),%eax
}
  801e8b:	5d                   	pop    %ebp
  801e8c:	c3                   	ret    

00801e8d <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801e8d:	55                   	push   %ebp
  801e8e:	89 e5                	mov    %esp,%ebp
  801e90:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801e93:	89 d0                	mov    %edx,%eax
  801e95:	c1 e8 16             	shr    $0x16,%eax
  801e98:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801e9f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801ea4:	f6 c1 01             	test   $0x1,%cl
  801ea7:	74 1d                	je     801ec6 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801ea9:	c1 ea 0c             	shr    $0xc,%edx
  801eac:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801eb3:	f6 c2 01             	test   $0x1,%dl
  801eb6:	74 0e                	je     801ec6 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801eb8:	c1 ea 0c             	shr    $0xc,%edx
  801ebb:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801ec2:	ef 
  801ec3:	0f b7 c0             	movzwl %ax,%eax
}
  801ec6:	5d                   	pop    %ebp
  801ec7:	c3                   	ret    
  801ec8:	66 90                	xchg   %ax,%ax
  801eca:	66 90                	xchg   %ax,%ax
  801ecc:	66 90                	xchg   %ax,%ax
  801ece:	66 90                	xchg   %ax,%ax

00801ed0 <__udivdi3>:
  801ed0:	55                   	push   %ebp
  801ed1:	57                   	push   %edi
  801ed2:	56                   	push   %esi
  801ed3:	53                   	push   %ebx
  801ed4:	83 ec 1c             	sub    $0x1c,%esp
  801ed7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801edb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801edf:	8b 74 24 34          	mov    0x34(%esp),%esi
  801ee3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801ee7:	85 d2                	test   %edx,%edx
  801ee9:	75 4d                	jne    801f38 <__udivdi3+0x68>
  801eeb:	39 f3                	cmp    %esi,%ebx
  801eed:	76 19                	jbe    801f08 <__udivdi3+0x38>
  801eef:	31 ff                	xor    %edi,%edi
  801ef1:	89 e8                	mov    %ebp,%eax
  801ef3:	89 f2                	mov    %esi,%edx
  801ef5:	f7 f3                	div    %ebx
  801ef7:	89 fa                	mov    %edi,%edx
  801ef9:	83 c4 1c             	add    $0x1c,%esp
  801efc:	5b                   	pop    %ebx
  801efd:	5e                   	pop    %esi
  801efe:	5f                   	pop    %edi
  801eff:	5d                   	pop    %ebp
  801f00:	c3                   	ret    
  801f01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801f08:	89 d9                	mov    %ebx,%ecx
  801f0a:	85 db                	test   %ebx,%ebx
  801f0c:	75 0b                	jne    801f19 <__udivdi3+0x49>
  801f0e:	b8 01 00 00 00       	mov    $0x1,%eax
  801f13:	31 d2                	xor    %edx,%edx
  801f15:	f7 f3                	div    %ebx
  801f17:	89 c1                	mov    %eax,%ecx
  801f19:	31 d2                	xor    %edx,%edx
  801f1b:	89 f0                	mov    %esi,%eax
  801f1d:	f7 f1                	div    %ecx
  801f1f:	89 c6                	mov    %eax,%esi
  801f21:	89 e8                	mov    %ebp,%eax
  801f23:	89 f7                	mov    %esi,%edi
  801f25:	f7 f1                	div    %ecx
  801f27:	89 fa                	mov    %edi,%edx
  801f29:	83 c4 1c             	add    $0x1c,%esp
  801f2c:	5b                   	pop    %ebx
  801f2d:	5e                   	pop    %esi
  801f2e:	5f                   	pop    %edi
  801f2f:	5d                   	pop    %ebp
  801f30:	c3                   	ret    
  801f31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801f38:	39 f2                	cmp    %esi,%edx
  801f3a:	77 1c                	ja     801f58 <__udivdi3+0x88>
  801f3c:	0f bd fa             	bsr    %edx,%edi
  801f3f:	83 f7 1f             	xor    $0x1f,%edi
  801f42:	75 2c                	jne    801f70 <__udivdi3+0xa0>
  801f44:	39 f2                	cmp    %esi,%edx
  801f46:	72 06                	jb     801f4e <__udivdi3+0x7e>
  801f48:	31 c0                	xor    %eax,%eax
  801f4a:	39 eb                	cmp    %ebp,%ebx
  801f4c:	77 a9                	ja     801ef7 <__udivdi3+0x27>
  801f4e:	b8 01 00 00 00       	mov    $0x1,%eax
  801f53:	eb a2                	jmp    801ef7 <__udivdi3+0x27>
  801f55:	8d 76 00             	lea    0x0(%esi),%esi
  801f58:	31 ff                	xor    %edi,%edi
  801f5a:	31 c0                	xor    %eax,%eax
  801f5c:	89 fa                	mov    %edi,%edx
  801f5e:	83 c4 1c             	add    $0x1c,%esp
  801f61:	5b                   	pop    %ebx
  801f62:	5e                   	pop    %esi
  801f63:	5f                   	pop    %edi
  801f64:	5d                   	pop    %ebp
  801f65:	c3                   	ret    
  801f66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801f6d:	8d 76 00             	lea    0x0(%esi),%esi
  801f70:	89 f9                	mov    %edi,%ecx
  801f72:	b8 20 00 00 00       	mov    $0x20,%eax
  801f77:	29 f8                	sub    %edi,%eax
  801f79:	d3 e2                	shl    %cl,%edx
  801f7b:	89 54 24 08          	mov    %edx,0x8(%esp)
  801f7f:	89 c1                	mov    %eax,%ecx
  801f81:	89 da                	mov    %ebx,%edx
  801f83:	d3 ea                	shr    %cl,%edx
  801f85:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801f89:	09 d1                	or     %edx,%ecx
  801f8b:	89 f2                	mov    %esi,%edx
  801f8d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801f91:	89 f9                	mov    %edi,%ecx
  801f93:	d3 e3                	shl    %cl,%ebx
  801f95:	89 c1                	mov    %eax,%ecx
  801f97:	d3 ea                	shr    %cl,%edx
  801f99:	89 f9                	mov    %edi,%ecx
  801f9b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801f9f:	89 eb                	mov    %ebp,%ebx
  801fa1:	d3 e6                	shl    %cl,%esi
  801fa3:	89 c1                	mov    %eax,%ecx
  801fa5:	d3 eb                	shr    %cl,%ebx
  801fa7:	09 de                	or     %ebx,%esi
  801fa9:	89 f0                	mov    %esi,%eax
  801fab:	f7 74 24 08          	divl   0x8(%esp)
  801faf:	89 d6                	mov    %edx,%esi
  801fb1:	89 c3                	mov    %eax,%ebx
  801fb3:	f7 64 24 0c          	mull   0xc(%esp)
  801fb7:	39 d6                	cmp    %edx,%esi
  801fb9:	72 15                	jb     801fd0 <__udivdi3+0x100>
  801fbb:	89 f9                	mov    %edi,%ecx
  801fbd:	d3 e5                	shl    %cl,%ebp
  801fbf:	39 c5                	cmp    %eax,%ebp
  801fc1:	73 04                	jae    801fc7 <__udivdi3+0xf7>
  801fc3:	39 d6                	cmp    %edx,%esi
  801fc5:	74 09                	je     801fd0 <__udivdi3+0x100>
  801fc7:	89 d8                	mov    %ebx,%eax
  801fc9:	31 ff                	xor    %edi,%edi
  801fcb:	e9 27 ff ff ff       	jmp    801ef7 <__udivdi3+0x27>
  801fd0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801fd3:	31 ff                	xor    %edi,%edi
  801fd5:	e9 1d ff ff ff       	jmp    801ef7 <__udivdi3+0x27>
  801fda:	66 90                	xchg   %ax,%ax
  801fdc:	66 90                	xchg   %ax,%ax
  801fde:	66 90                	xchg   %ax,%ax

00801fe0 <__umoddi3>:
  801fe0:	55                   	push   %ebp
  801fe1:	57                   	push   %edi
  801fe2:	56                   	push   %esi
  801fe3:	53                   	push   %ebx
  801fe4:	83 ec 1c             	sub    $0x1c,%esp
  801fe7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801feb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801fef:	8b 74 24 30          	mov    0x30(%esp),%esi
  801ff3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ff7:	89 da                	mov    %ebx,%edx
  801ff9:	85 c0                	test   %eax,%eax
  801ffb:	75 43                	jne    802040 <__umoddi3+0x60>
  801ffd:	39 df                	cmp    %ebx,%edi
  801fff:	76 17                	jbe    802018 <__umoddi3+0x38>
  802001:	89 f0                	mov    %esi,%eax
  802003:	f7 f7                	div    %edi
  802005:	89 d0                	mov    %edx,%eax
  802007:	31 d2                	xor    %edx,%edx
  802009:	83 c4 1c             	add    $0x1c,%esp
  80200c:	5b                   	pop    %ebx
  80200d:	5e                   	pop    %esi
  80200e:	5f                   	pop    %edi
  80200f:	5d                   	pop    %ebp
  802010:	c3                   	ret    
  802011:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802018:	89 fd                	mov    %edi,%ebp
  80201a:	85 ff                	test   %edi,%edi
  80201c:	75 0b                	jne    802029 <__umoddi3+0x49>
  80201e:	b8 01 00 00 00       	mov    $0x1,%eax
  802023:	31 d2                	xor    %edx,%edx
  802025:	f7 f7                	div    %edi
  802027:	89 c5                	mov    %eax,%ebp
  802029:	89 d8                	mov    %ebx,%eax
  80202b:	31 d2                	xor    %edx,%edx
  80202d:	f7 f5                	div    %ebp
  80202f:	89 f0                	mov    %esi,%eax
  802031:	f7 f5                	div    %ebp
  802033:	89 d0                	mov    %edx,%eax
  802035:	eb d0                	jmp    802007 <__umoddi3+0x27>
  802037:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80203e:	66 90                	xchg   %ax,%ax
  802040:	89 f1                	mov    %esi,%ecx
  802042:	39 d8                	cmp    %ebx,%eax
  802044:	76 0a                	jbe    802050 <__umoddi3+0x70>
  802046:	89 f0                	mov    %esi,%eax
  802048:	83 c4 1c             	add    $0x1c,%esp
  80204b:	5b                   	pop    %ebx
  80204c:	5e                   	pop    %esi
  80204d:	5f                   	pop    %edi
  80204e:	5d                   	pop    %ebp
  80204f:	c3                   	ret    
  802050:	0f bd e8             	bsr    %eax,%ebp
  802053:	83 f5 1f             	xor    $0x1f,%ebp
  802056:	75 20                	jne    802078 <__umoddi3+0x98>
  802058:	39 d8                	cmp    %ebx,%eax
  80205a:	0f 82 b0 00 00 00    	jb     802110 <__umoddi3+0x130>
  802060:	39 f7                	cmp    %esi,%edi
  802062:	0f 86 a8 00 00 00    	jbe    802110 <__umoddi3+0x130>
  802068:	89 c8                	mov    %ecx,%eax
  80206a:	83 c4 1c             	add    $0x1c,%esp
  80206d:	5b                   	pop    %ebx
  80206e:	5e                   	pop    %esi
  80206f:	5f                   	pop    %edi
  802070:	5d                   	pop    %ebp
  802071:	c3                   	ret    
  802072:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802078:	89 e9                	mov    %ebp,%ecx
  80207a:	ba 20 00 00 00       	mov    $0x20,%edx
  80207f:	29 ea                	sub    %ebp,%edx
  802081:	d3 e0                	shl    %cl,%eax
  802083:	89 44 24 08          	mov    %eax,0x8(%esp)
  802087:	89 d1                	mov    %edx,%ecx
  802089:	89 f8                	mov    %edi,%eax
  80208b:	d3 e8                	shr    %cl,%eax
  80208d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802091:	89 54 24 04          	mov    %edx,0x4(%esp)
  802095:	8b 54 24 04          	mov    0x4(%esp),%edx
  802099:	09 c1                	or     %eax,%ecx
  80209b:	89 d8                	mov    %ebx,%eax
  80209d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8020a1:	89 e9                	mov    %ebp,%ecx
  8020a3:	d3 e7                	shl    %cl,%edi
  8020a5:	89 d1                	mov    %edx,%ecx
  8020a7:	d3 e8                	shr    %cl,%eax
  8020a9:	89 e9                	mov    %ebp,%ecx
  8020ab:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8020af:	d3 e3                	shl    %cl,%ebx
  8020b1:	89 c7                	mov    %eax,%edi
  8020b3:	89 d1                	mov    %edx,%ecx
  8020b5:	89 f0                	mov    %esi,%eax
  8020b7:	d3 e8                	shr    %cl,%eax
  8020b9:	89 e9                	mov    %ebp,%ecx
  8020bb:	89 fa                	mov    %edi,%edx
  8020bd:	d3 e6                	shl    %cl,%esi
  8020bf:	09 d8                	or     %ebx,%eax
  8020c1:	f7 74 24 08          	divl   0x8(%esp)
  8020c5:	89 d1                	mov    %edx,%ecx
  8020c7:	89 f3                	mov    %esi,%ebx
  8020c9:	f7 64 24 0c          	mull   0xc(%esp)
  8020cd:	89 c6                	mov    %eax,%esi
  8020cf:	89 d7                	mov    %edx,%edi
  8020d1:	39 d1                	cmp    %edx,%ecx
  8020d3:	72 06                	jb     8020db <__umoddi3+0xfb>
  8020d5:	75 10                	jne    8020e7 <__umoddi3+0x107>
  8020d7:	39 c3                	cmp    %eax,%ebx
  8020d9:	73 0c                	jae    8020e7 <__umoddi3+0x107>
  8020db:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8020df:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8020e3:	89 d7                	mov    %edx,%edi
  8020e5:	89 c6                	mov    %eax,%esi
  8020e7:	89 ca                	mov    %ecx,%edx
  8020e9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8020ee:	29 f3                	sub    %esi,%ebx
  8020f0:	19 fa                	sbb    %edi,%edx
  8020f2:	89 d0                	mov    %edx,%eax
  8020f4:	d3 e0                	shl    %cl,%eax
  8020f6:	89 e9                	mov    %ebp,%ecx
  8020f8:	d3 eb                	shr    %cl,%ebx
  8020fa:	d3 ea                	shr    %cl,%edx
  8020fc:	09 d8                	or     %ebx,%eax
  8020fe:	83 c4 1c             	add    $0x1c,%esp
  802101:	5b                   	pop    %ebx
  802102:	5e                   	pop    %esi
  802103:	5f                   	pop    %edi
  802104:	5d                   	pop    %ebp
  802105:	c3                   	ret    
  802106:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80210d:	8d 76 00             	lea    0x0(%esi),%esi
  802110:	89 da                	mov    %ebx,%edx
  802112:	29 fe                	sub    %edi,%esi
  802114:	19 c2                	sbb    %eax,%edx
  802116:	89 f1                	mov    %esi,%ecx
  802118:	89 c8                	mov    %ecx,%eax
  80211a:	e9 4b ff ff ff       	jmp    80206a <__umoddi3+0x8a>
