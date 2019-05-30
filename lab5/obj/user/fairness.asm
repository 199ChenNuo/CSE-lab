
obj/user/fairness.debug:     file format elf32-i386


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
  80002c:	e8 70 00 00 00       	call   8000a1 <libmain>
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
  800038:	83 ec 10             	sub    $0x10,%esp
	envid_t who, id;

	id = sys_getenvid();
  80003b:	e8 2b 0c 00 00       	call   800c6b <sys_getenvid>
  800040:	89 c3                	mov    %eax,%ebx

	if (thisenv == &envs[1]) {
  800042:	81 3d 04 20 80 00 84 	cmpl   $0xeec00084,0x802004
  800049:	00 c0 ee 
  80004c:	74 2d                	je     80007b <umain+0x48>
		while (1) {
			ipc_recv(&who, 0, 0);
			cprintf("%x recv from %x\n", id, who);
		}
	} else {
		cprintf("%x loop sending to %x\n", id, envs[1].env_id);
  80004e:	a1 cc 00 c0 ee       	mov    0xeec000cc,%eax
  800053:	83 ec 04             	sub    $0x4,%esp
  800056:	50                   	push   %eax
  800057:	53                   	push   %ebx
  800058:	68 91 12 80 00       	push   $0x801291
  80005d:	e8 2f 01 00 00       	call   800191 <cprintf>
  800062:	83 c4 10             	add    $0x10,%esp
		while (1)
			ipc_send(envs[1].env_id, 0, 0, 0);
  800065:	a1 cc 00 c0 ee       	mov    0xeec000cc,%eax
  80006a:	6a 00                	push   $0x0
  80006c:	6a 00                	push   $0x0
  80006e:	6a 00                	push   $0x0
  800070:	50                   	push   %eax
  800071:	e8 ce 0e 00 00       	call   800f44 <ipc_send>
  800076:	83 c4 10             	add    $0x10,%esp
  800079:	eb ea                	jmp    800065 <umain+0x32>
			ipc_recv(&who, 0, 0);
  80007b:	8d 75 f4             	lea    -0xc(%ebp),%esi
  80007e:	83 ec 04             	sub    $0x4,%esp
  800081:	6a 00                	push   $0x0
  800083:	6a 00                	push   $0x0
  800085:	56                   	push   %esi
  800086:	e8 50 0e 00 00       	call   800edb <ipc_recv>
			cprintf("%x recv from %x\n", id, who);
  80008b:	83 c4 0c             	add    $0xc,%esp
  80008e:	ff 75 f4             	pushl  -0xc(%ebp)
  800091:	53                   	push   %ebx
  800092:	68 80 12 80 00       	push   $0x801280
  800097:	e8 f5 00 00 00       	call   800191 <cprintf>
  80009c:	83 c4 10             	add    $0x10,%esp
  80009f:	eb dd                	jmp    80007e <umain+0x4b>

008000a1 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000a1:	55                   	push   %ebp
  8000a2:	89 e5                	mov    %esp,%ebp
  8000a4:	56                   	push   %esi
  8000a5:	53                   	push   %ebx
  8000a6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000a9:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	// thisenv = 0;
	thisenv = &(envs[ENVX(sys_getenvid())]);
  8000ac:	e8 ba 0b 00 00       	call   800c6b <sys_getenvid>
  8000b1:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000b6:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8000bc:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000c1:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000c6:	85 db                	test   %ebx,%ebx
  8000c8:	7e 07                	jle    8000d1 <libmain+0x30>
		binaryname = argv[0];
  8000ca:	8b 06                	mov    (%esi),%eax
  8000cc:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  8000d1:	83 ec 08             	sub    $0x8,%esp
  8000d4:	56                   	push   %esi
  8000d5:	53                   	push   %ebx
  8000d6:	e8 58 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000db:	e8 0a 00 00 00       	call   8000ea <exit>
}
  8000e0:	83 c4 10             	add    $0x10,%esp
  8000e3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000e6:	5b                   	pop    %ebx
  8000e7:	5e                   	pop    %esi
  8000e8:	5d                   	pop    %ebp
  8000e9:	c3                   	ret    

008000ea <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000ea:	55                   	push   %ebp
  8000eb:	89 e5                	mov    %esp,%ebp
  8000ed:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  8000f0:	6a 00                	push   $0x0
  8000f2:	e8 33 0b 00 00       	call   800c2a <sys_env_destroy>
}
  8000f7:	83 c4 10             	add    $0x10,%esp
  8000fa:	c9                   	leave  
  8000fb:	c3                   	ret    

008000fc <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000fc:	55                   	push   %ebp
  8000fd:	89 e5                	mov    %esp,%ebp
  8000ff:	53                   	push   %ebx
  800100:	83 ec 04             	sub    $0x4,%esp
  800103:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800106:	8b 13                	mov    (%ebx),%edx
  800108:	8d 42 01             	lea    0x1(%edx),%eax
  80010b:	89 03                	mov    %eax,(%ebx)
  80010d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800110:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800114:	3d ff 00 00 00       	cmp    $0xff,%eax
  800119:	74 09                	je     800124 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80011b:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80011f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800122:	c9                   	leave  
  800123:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800124:	83 ec 08             	sub    $0x8,%esp
  800127:	68 ff 00 00 00       	push   $0xff
  80012c:	8d 43 08             	lea    0x8(%ebx),%eax
  80012f:	50                   	push   %eax
  800130:	e8 b8 0a 00 00       	call   800bed <sys_cputs>
		b->idx = 0;
  800135:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80013b:	83 c4 10             	add    $0x10,%esp
  80013e:	eb db                	jmp    80011b <putch+0x1f>

00800140 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800140:	55                   	push   %ebp
  800141:	89 e5                	mov    %esp,%ebp
  800143:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800149:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800150:	00 00 00 
	b.cnt = 0;
  800153:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80015a:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80015d:	ff 75 0c             	pushl  0xc(%ebp)
  800160:	ff 75 08             	pushl  0x8(%ebp)
  800163:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800169:	50                   	push   %eax
  80016a:	68 fc 00 80 00       	push   $0x8000fc
  80016f:	e8 4a 01 00 00       	call   8002be <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800174:	83 c4 08             	add    $0x8,%esp
  800177:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80017d:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800183:	50                   	push   %eax
  800184:	e8 64 0a 00 00       	call   800bed <sys_cputs>

	return b.cnt;
}
  800189:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80018f:	c9                   	leave  
  800190:	c3                   	ret    

00800191 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800191:	55                   	push   %ebp
  800192:	89 e5                	mov    %esp,%ebp
  800194:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800197:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80019a:	50                   	push   %eax
  80019b:	ff 75 08             	pushl  0x8(%ebp)
  80019e:	e8 9d ff ff ff       	call   800140 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001a3:	c9                   	leave  
  8001a4:	c3                   	ret    

008001a5 <printnum>:


static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001a5:	55                   	push   %ebp
  8001a6:	89 e5                	mov    %esp,%ebp
  8001a8:	57                   	push   %edi
  8001a9:	56                   	push   %esi
  8001aa:	53                   	push   %ebx
  8001ab:	83 ec 1c             	sub    $0x1c,%esp
  8001ae:	89 c6                	mov    %eax,%esi
  8001b0:	89 d7                	mov    %edx,%edi
  8001b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8001b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001b8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001bb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8001be:	8b 45 10             	mov    0x10(%ebp),%eax
  8001c1:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	// to support '-'
	if(padc == '-'){
  8001c4:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8001c8:	74 2c                	je     8001f6 <printnum+0x51>
		while (--width > 0)
			putch(' ', putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001ca:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001cd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8001d4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8001d7:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8001da:	39 c2                	cmp    %eax,%edx
  8001dc:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8001df:	73 43                	jae    800224 <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8001e1:	83 eb 01             	sub    $0x1,%ebx
  8001e4:	85 db                	test   %ebx,%ebx
  8001e6:	7e 6c                	jle    800254 <printnum+0xaf>
			putch(padc, putdat);
  8001e8:	83 ec 08             	sub    $0x8,%esp
  8001eb:	57                   	push   %edi
  8001ec:	ff 75 18             	pushl  0x18(%ebp)
  8001ef:	ff d6                	call   *%esi
  8001f1:	83 c4 10             	add    $0x10,%esp
  8001f4:	eb eb                	jmp    8001e1 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8001f6:	83 ec 0c             	sub    $0xc,%esp
  8001f9:	6a 20                	push   $0x20
  8001fb:	6a 00                	push   $0x0
  8001fd:	50                   	push   %eax
  8001fe:	ff 75 e4             	pushl  -0x1c(%ebp)
  800201:	ff 75 e0             	pushl  -0x20(%ebp)
  800204:	89 fa                	mov    %edi,%edx
  800206:	89 f0                	mov    %esi,%eax
  800208:	e8 98 ff ff ff       	call   8001a5 <printnum>
		while (--width > 0)
  80020d:	83 c4 20             	add    $0x20,%esp
  800210:	83 eb 01             	sub    $0x1,%ebx
  800213:	85 db                	test   %ebx,%ebx
  800215:	7e 65                	jle    80027c <printnum+0xd7>
			putch(' ', putdat);
  800217:	83 ec 08             	sub    $0x8,%esp
  80021a:	57                   	push   %edi
  80021b:	6a 20                	push   $0x20
  80021d:	ff d6                	call   *%esi
  80021f:	83 c4 10             	add    $0x10,%esp
  800222:	eb ec                	jmp    800210 <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800224:	83 ec 0c             	sub    $0xc,%esp
  800227:	ff 75 18             	pushl  0x18(%ebp)
  80022a:	83 eb 01             	sub    $0x1,%ebx
  80022d:	53                   	push   %ebx
  80022e:	50                   	push   %eax
  80022f:	83 ec 08             	sub    $0x8,%esp
  800232:	ff 75 dc             	pushl  -0x24(%ebp)
  800235:	ff 75 d8             	pushl  -0x28(%ebp)
  800238:	ff 75 e4             	pushl  -0x1c(%ebp)
  80023b:	ff 75 e0             	pushl  -0x20(%ebp)
  80023e:	e8 dd 0d 00 00       	call   801020 <__udivdi3>
  800243:	83 c4 18             	add    $0x18,%esp
  800246:	52                   	push   %edx
  800247:	50                   	push   %eax
  800248:	89 fa                	mov    %edi,%edx
  80024a:	89 f0                	mov    %esi,%eax
  80024c:	e8 54 ff ff ff       	call   8001a5 <printnum>
  800251:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800254:	83 ec 08             	sub    $0x8,%esp
  800257:	57                   	push   %edi
  800258:	83 ec 04             	sub    $0x4,%esp
  80025b:	ff 75 dc             	pushl  -0x24(%ebp)
  80025e:	ff 75 d8             	pushl  -0x28(%ebp)
  800261:	ff 75 e4             	pushl  -0x1c(%ebp)
  800264:	ff 75 e0             	pushl  -0x20(%ebp)
  800267:	e8 c4 0e 00 00       	call   801130 <__umoddi3>
  80026c:	83 c4 14             	add    $0x14,%esp
  80026f:	0f be 80 b2 12 80 00 	movsbl 0x8012b2(%eax),%eax
  800276:	50                   	push   %eax
  800277:	ff d6                	call   *%esi
  800279:	83 c4 10             	add    $0x10,%esp
}
  80027c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80027f:	5b                   	pop    %ebx
  800280:	5e                   	pop    %esi
  800281:	5f                   	pop    %edi
  800282:	5d                   	pop    %ebp
  800283:	c3                   	ret    

00800284 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800284:	55                   	push   %ebp
  800285:	89 e5                	mov    %esp,%ebp
  800287:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80028a:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80028e:	8b 10                	mov    (%eax),%edx
  800290:	3b 50 04             	cmp    0x4(%eax),%edx
  800293:	73 0a                	jae    80029f <sprintputch+0x1b>
		*b->buf++ = ch;
  800295:	8d 4a 01             	lea    0x1(%edx),%ecx
  800298:	89 08                	mov    %ecx,(%eax)
  80029a:	8b 45 08             	mov    0x8(%ebp),%eax
  80029d:	88 02                	mov    %al,(%edx)
}
  80029f:	5d                   	pop    %ebp
  8002a0:	c3                   	ret    

008002a1 <printfmt>:
{
  8002a1:	55                   	push   %ebp
  8002a2:	89 e5                	mov    %esp,%ebp
  8002a4:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002a7:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002aa:	50                   	push   %eax
  8002ab:	ff 75 10             	pushl  0x10(%ebp)
  8002ae:	ff 75 0c             	pushl  0xc(%ebp)
  8002b1:	ff 75 08             	pushl  0x8(%ebp)
  8002b4:	e8 05 00 00 00       	call   8002be <vprintfmt>
}
  8002b9:	83 c4 10             	add    $0x10,%esp
  8002bc:	c9                   	leave  
  8002bd:	c3                   	ret    

008002be <vprintfmt>:
{
  8002be:	55                   	push   %ebp
  8002bf:	89 e5                	mov    %esp,%ebp
  8002c1:	57                   	push   %edi
  8002c2:	56                   	push   %esi
  8002c3:	53                   	push   %ebx
  8002c4:	83 ec 3c             	sub    $0x3c,%esp
  8002c7:	8b 75 08             	mov    0x8(%ebp),%esi
  8002ca:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002cd:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002d0:	e9 1e 04 00 00       	jmp    8006f3 <vprintfmt+0x435>
		posflag = 0;
  8002d5:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
		padc = ' ';
  8002dc:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8002e0:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8002e7:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8002ee:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002f5:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  8002fc:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800301:	8d 47 01             	lea    0x1(%edi),%eax
  800304:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800307:	0f b6 17             	movzbl (%edi),%edx
  80030a:	8d 42 dd             	lea    -0x23(%edx),%eax
  80030d:	3c 55                	cmp    $0x55,%al
  80030f:	0f 87 d9 04 00 00    	ja     8007ee <vprintfmt+0x530>
  800315:	0f b6 c0             	movzbl %al,%eax
  800318:	ff 24 85 a0 14 80 00 	jmp    *0x8014a0(,%eax,4)
  80031f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800322:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800326:	eb d9                	jmp    800301 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800328:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posflag = 1;
  80032b:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  800332:	eb cd                	jmp    800301 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800334:	0f b6 d2             	movzbl %dl,%edx
  800337:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80033a:	b8 00 00 00 00       	mov    $0x0,%eax
  80033f:	89 75 08             	mov    %esi,0x8(%ebp)
  800342:	eb 0c                	jmp    800350 <vprintfmt+0x92>
		switch (ch = *(unsigned char *) fmt++) {
  800344:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800347:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  80034b:	eb b4                	jmp    800301 <vprintfmt+0x43>
			for (precision = 0; ; ++fmt) {
  80034d:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800350:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800353:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800357:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80035a:	8d 72 d0             	lea    -0x30(%edx),%esi
  80035d:	83 fe 09             	cmp    $0x9,%esi
  800360:	76 eb                	jbe    80034d <vprintfmt+0x8f>
  800362:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800365:	8b 75 08             	mov    0x8(%ebp),%esi
  800368:	eb 14                	jmp    80037e <vprintfmt+0xc0>
			precision = va_arg(ap, int);
  80036a:	8b 45 14             	mov    0x14(%ebp),%eax
  80036d:	8b 00                	mov    (%eax),%eax
  80036f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800372:	8b 45 14             	mov    0x14(%ebp),%eax
  800375:	8d 40 04             	lea    0x4(%eax),%eax
  800378:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80037b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80037e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800382:	0f 89 79 ff ff ff    	jns    800301 <vprintfmt+0x43>
				width = precision, precision = -1;
  800388:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80038b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80038e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800395:	e9 67 ff ff ff       	jmp    800301 <vprintfmt+0x43>
  80039a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80039d:	85 c0                	test   %eax,%eax
  80039f:	0f 48 c1             	cmovs  %ecx,%eax
  8003a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003a5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003a8:	e9 54 ff ff ff       	jmp    800301 <vprintfmt+0x43>
  8003ad:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003b0:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8003b7:	e9 45 ff ff ff       	jmp    800301 <vprintfmt+0x43>
			lflag++;
  8003bc:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003c0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003c3:	e9 39 ff ff ff       	jmp    800301 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8003c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8003cb:	8d 78 04             	lea    0x4(%eax),%edi
  8003ce:	83 ec 08             	sub    $0x8,%esp
  8003d1:	53                   	push   %ebx
  8003d2:	ff 30                	pushl  (%eax)
  8003d4:	ff d6                	call   *%esi
			break;
  8003d6:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003d9:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003dc:	e9 0f 03 00 00       	jmp    8006f0 <vprintfmt+0x432>
			err = va_arg(ap, int);
  8003e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e4:	8d 78 04             	lea    0x4(%eax),%edi
  8003e7:	8b 00                	mov    (%eax),%eax
  8003e9:	99                   	cltd   
  8003ea:	31 d0                	xor    %edx,%eax
  8003ec:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003ee:	83 f8 0f             	cmp    $0xf,%eax
  8003f1:	7f 23                	jg     800416 <vprintfmt+0x158>
  8003f3:	8b 14 85 00 16 80 00 	mov    0x801600(,%eax,4),%edx
  8003fa:	85 d2                	test   %edx,%edx
  8003fc:	74 18                	je     800416 <vprintfmt+0x158>
				printfmt(putch, putdat, "%s", p);
  8003fe:	52                   	push   %edx
  8003ff:	68 d3 12 80 00       	push   $0x8012d3
  800404:	53                   	push   %ebx
  800405:	56                   	push   %esi
  800406:	e8 96 fe ff ff       	call   8002a1 <printfmt>
  80040b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80040e:	89 7d 14             	mov    %edi,0x14(%ebp)
  800411:	e9 da 02 00 00       	jmp    8006f0 <vprintfmt+0x432>
				printfmt(putch, putdat, "error %d", err);
  800416:	50                   	push   %eax
  800417:	68 ca 12 80 00       	push   $0x8012ca
  80041c:	53                   	push   %ebx
  80041d:	56                   	push   %esi
  80041e:	e8 7e fe ff ff       	call   8002a1 <printfmt>
  800423:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800426:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800429:	e9 c2 02 00 00       	jmp    8006f0 <vprintfmt+0x432>
			if ((p = va_arg(ap, char *)) == NULL)
  80042e:	8b 45 14             	mov    0x14(%ebp),%eax
  800431:	83 c0 04             	add    $0x4,%eax
  800434:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800437:	8b 45 14             	mov    0x14(%ebp),%eax
  80043a:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80043c:	85 c9                	test   %ecx,%ecx
  80043e:	b8 c3 12 80 00       	mov    $0x8012c3,%eax
  800443:	0f 45 c1             	cmovne %ecx,%eax
  800446:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800449:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80044d:	7e 06                	jle    800455 <vprintfmt+0x197>
  80044f:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800453:	75 0d                	jne    800462 <vprintfmt+0x1a4>
				for (width -= strnlen(p, precision); width > 0; width--)
  800455:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800458:	89 c7                	mov    %eax,%edi
  80045a:	03 45 e0             	add    -0x20(%ebp),%eax
  80045d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800460:	eb 53                	jmp    8004b5 <vprintfmt+0x1f7>
  800462:	83 ec 08             	sub    $0x8,%esp
  800465:	ff 75 d8             	pushl  -0x28(%ebp)
  800468:	50                   	push   %eax
  800469:	e8 28 04 00 00       	call   800896 <strnlen>
  80046e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800471:	29 c1                	sub    %eax,%ecx
  800473:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  800476:	83 c4 10             	add    $0x10,%esp
  800479:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  80047b:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80047f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800482:	eb 0f                	jmp    800493 <vprintfmt+0x1d5>
					putch(padc, putdat);
  800484:	83 ec 08             	sub    $0x8,%esp
  800487:	53                   	push   %ebx
  800488:	ff 75 e0             	pushl  -0x20(%ebp)
  80048b:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80048d:	83 ef 01             	sub    $0x1,%edi
  800490:	83 c4 10             	add    $0x10,%esp
  800493:	85 ff                	test   %edi,%edi
  800495:	7f ed                	jg     800484 <vprintfmt+0x1c6>
  800497:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  80049a:	85 c9                	test   %ecx,%ecx
  80049c:	b8 00 00 00 00       	mov    $0x0,%eax
  8004a1:	0f 49 c1             	cmovns %ecx,%eax
  8004a4:	29 c1                	sub    %eax,%ecx
  8004a6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8004a9:	eb aa                	jmp    800455 <vprintfmt+0x197>
					putch(ch, putdat);
  8004ab:	83 ec 08             	sub    $0x8,%esp
  8004ae:	53                   	push   %ebx
  8004af:	52                   	push   %edx
  8004b0:	ff d6                	call   *%esi
  8004b2:	83 c4 10             	add    $0x10,%esp
  8004b5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004b8:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004ba:	83 c7 01             	add    $0x1,%edi
  8004bd:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004c1:	0f be d0             	movsbl %al,%edx
  8004c4:	85 d2                	test   %edx,%edx
  8004c6:	74 4b                	je     800513 <vprintfmt+0x255>
  8004c8:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004cc:	78 06                	js     8004d4 <vprintfmt+0x216>
  8004ce:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004d2:	78 1e                	js     8004f2 <vprintfmt+0x234>
				if (altflag && (ch < ' ' || ch > '~'))
  8004d4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004d8:	74 d1                	je     8004ab <vprintfmt+0x1ed>
  8004da:	0f be c0             	movsbl %al,%eax
  8004dd:	83 e8 20             	sub    $0x20,%eax
  8004e0:	83 f8 5e             	cmp    $0x5e,%eax
  8004e3:	76 c6                	jbe    8004ab <vprintfmt+0x1ed>
					putch('?', putdat);
  8004e5:	83 ec 08             	sub    $0x8,%esp
  8004e8:	53                   	push   %ebx
  8004e9:	6a 3f                	push   $0x3f
  8004eb:	ff d6                	call   *%esi
  8004ed:	83 c4 10             	add    $0x10,%esp
  8004f0:	eb c3                	jmp    8004b5 <vprintfmt+0x1f7>
  8004f2:	89 cf                	mov    %ecx,%edi
  8004f4:	eb 0e                	jmp    800504 <vprintfmt+0x246>
				putch(' ', putdat);
  8004f6:	83 ec 08             	sub    $0x8,%esp
  8004f9:	53                   	push   %ebx
  8004fa:	6a 20                	push   $0x20
  8004fc:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004fe:	83 ef 01             	sub    $0x1,%edi
  800501:	83 c4 10             	add    $0x10,%esp
  800504:	85 ff                	test   %edi,%edi
  800506:	7f ee                	jg     8004f6 <vprintfmt+0x238>
			if ((p = va_arg(ap, char *)) == NULL)
  800508:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80050b:	89 45 14             	mov    %eax,0x14(%ebp)
  80050e:	e9 dd 01 00 00       	jmp    8006f0 <vprintfmt+0x432>
  800513:	89 cf                	mov    %ecx,%edi
  800515:	eb ed                	jmp    800504 <vprintfmt+0x246>
	if (lflag >= 2)
  800517:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  80051b:	7f 21                	jg     80053e <vprintfmt+0x280>
	else if (lflag)
  80051d:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800521:	74 6a                	je     80058d <vprintfmt+0x2cf>
		return va_arg(*ap, long);
  800523:	8b 45 14             	mov    0x14(%ebp),%eax
  800526:	8b 00                	mov    (%eax),%eax
  800528:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80052b:	89 c1                	mov    %eax,%ecx
  80052d:	c1 f9 1f             	sar    $0x1f,%ecx
  800530:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800533:	8b 45 14             	mov    0x14(%ebp),%eax
  800536:	8d 40 04             	lea    0x4(%eax),%eax
  800539:	89 45 14             	mov    %eax,0x14(%ebp)
  80053c:	eb 17                	jmp    800555 <vprintfmt+0x297>
		return va_arg(*ap, long long);
  80053e:	8b 45 14             	mov    0x14(%ebp),%eax
  800541:	8b 50 04             	mov    0x4(%eax),%edx
  800544:	8b 00                	mov    (%eax),%eax
  800546:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800549:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80054c:	8b 45 14             	mov    0x14(%ebp),%eax
  80054f:	8d 40 08             	lea    0x8(%eax),%eax
  800552:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800555:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  800558:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  80055d:	85 d2                	test   %edx,%edx
  80055f:	0f 89 5c 01 00 00    	jns    8006c1 <vprintfmt+0x403>
				putch('-', putdat);
  800565:	83 ec 08             	sub    $0x8,%esp
  800568:	53                   	push   %ebx
  800569:	6a 2d                	push   $0x2d
  80056b:	ff d6                	call   *%esi
				num = -(long long) num;
  80056d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800570:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800573:	f7 d8                	neg    %eax
  800575:	83 d2 00             	adc    $0x0,%edx
  800578:	f7 da                	neg    %edx
  80057a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80057d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800580:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800583:	bf 0a 00 00 00       	mov    $0xa,%edi
  800588:	e9 45 01 00 00       	jmp    8006d2 <vprintfmt+0x414>
		return va_arg(*ap, int);
  80058d:	8b 45 14             	mov    0x14(%ebp),%eax
  800590:	8b 00                	mov    (%eax),%eax
  800592:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800595:	89 c1                	mov    %eax,%ecx
  800597:	c1 f9 1f             	sar    $0x1f,%ecx
  80059a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80059d:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a0:	8d 40 04             	lea    0x4(%eax),%eax
  8005a3:	89 45 14             	mov    %eax,0x14(%ebp)
  8005a6:	eb ad                	jmp    800555 <vprintfmt+0x297>
	if (lflag >= 2)
  8005a8:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8005ac:	7f 29                	jg     8005d7 <vprintfmt+0x319>
	else if (lflag)
  8005ae:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8005b2:	74 44                	je     8005f8 <vprintfmt+0x33a>
		return va_arg(*ap, unsigned long);
  8005b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b7:	8b 00                	mov    (%eax),%eax
  8005b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8005be:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005c1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c7:	8d 40 04             	lea    0x4(%eax),%eax
  8005ca:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005cd:	bf 0a 00 00 00       	mov    $0xa,%edi
  8005d2:	e9 ea 00 00 00       	jmp    8006c1 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  8005d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005da:	8b 50 04             	mov    0x4(%eax),%edx
  8005dd:	8b 00                	mov    (%eax),%eax
  8005df:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005e2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e8:	8d 40 08             	lea    0x8(%eax),%eax
  8005eb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005ee:	bf 0a 00 00 00       	mov    $0xa,%edi
  8005f3:	e9 c9 00 00 00       	jmp    8006c1 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  8005f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fb:	8b 00                	mov    (%eax),%eax
  8005fd:	ba 00 00 00 00       	mov    $0x0,%edx
  800602:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800605:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800608:	8b 45 14             	mov    0x14(%ebp),%eax
  80060b:	8d 40 04             	lea    0x4(%eax),%eax
  80060e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800611:	bf 0a 00 00 00       	mov    $0xa,%edi
  800616:	e9 a6 00 00 00       	jmp    8006c1 <vprintfmt+0x403>
			putch('0', putdat);
  80061b:	83 ec 08             	sub    $0x8,%esp
  80061e:	53                   	push   %ebx
  80061f:	6a 30                	push   $0x30
  800621:	ff d6                	call   *%esi
	if (lflag >= 2)
  800623:	83 c4 10             	add    $0x10,%esp
  800626:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  80062a:	7f 26                	jg     800652 <vprintfmt+0x394>
	else if (lflag)
  80062c:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800630:	74 3e                	je     800670 <vprintfmt+0x3b2>
		return va_arg(*ap, unsigned long);
  800632:	8b 45 14             	mov    0x14(%ebp),%eax
  800635:	8b 00                	mov    (%eax),%eax
  800637:	ba 00 00 00 00       	mov    $0x0,%edx
  80063c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80063f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800642:	8b 45 14             	mov    0x14(%ebp),%eax
  800645:	8d 40 04             	lea    0x4(%eax),%eax
  800648:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80064b:	bf 08 00 00 00       	mov    $0x8,%edi
  800650:	eb 6f                	jmp    8006c1 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  800652:	8b 45 14             	mov    0x14(%ebp),%eax
  800655:	8b 50 04             	mov    0x4(%eax),%edx
  800658:	8b 00                	mov    (%eax),%eax
  80065a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80065d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800660:	8b 45 14             	mov    0x14(%ebp),%eax
  800663:	8d 40 08             	lea    0x8(%eax),%eax
  800666:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800669:	bf 08 00 00 00       	mov    $0x8,%edi
  80066e:	eb 51                	jmp    8006c1 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  800670:	8b 45 14             	mov    0x14(%ebp),%eax
  800673:	8b 00                	mov    (%eax),%eax
  800675:	ba 00 00 00 00       	mov    $0x0,%edx
  80067a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80067d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800680:	8b 45 14             	mov    0x14(%ebp),%eax
  800683:	8d 40 04             	lea    0x4(%eax),%eax
  800686:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800689:	bf 08 00 00 00       	mov    $0x8,%edi
  80068e:	eb 31                	jmp    8006c1 <vprintfmt+0x403>
			putch('0', putdat);
  800690:	83 ec 08             	sub    $0x8,%esp
  800693:	53                   	push   %ebx
  800694:	6a 30                	push   $0x30
  800696:	ff d6                	call   *%esi
			putch('x', putdat);
  800698:	83 c4 08             	add    $0x8,%esp
  80069b:	53                   	push   %ebx
  80069c:	6a 78                	push   $0x78
  80069e:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a3:	8b 00                	mov    (%eax),%eax
  8006a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8006aa:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ad:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8006b0:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b6:	8d 40 04             	lea    0x4(%eax),%eax
  8006b9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006bc:	bf 10 00 00 00       	mov    $0x10,%edi
			if(posflag)
  8006c1:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006c5:	74 0b                	je     8006d2 <vprintfmt+0x414>
				putch('+', putdat);
  8006c7:	83 ec 08             	sub    $0x8,%esp
  8006ca:	53                   	push   %ebx
  8006cb:	6a 2b                	push   $0x2b
  8006cd:	ff d6                	call   *%esi
  8006cf:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  8006d2:	83 ec 0c             	sub    $0xc,%esp
  8006d5:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8006d9:	50                   	push   %eax
  8006da:	ff 75 e0             	pushl  -0x20(%ebp)
  8006dd:	57                   	push   %edi
  8006de:	ff 75 dc             	pushl  -0x24(%ebp)
  8006e1:	ff 75 d8             	pushl  -0x28(%ebp)
  8006e4:	89 da                	mov    %ebx,%edx
  8006e6:	89 f0                	mov    %esi,%eax
  8006e8:	e8 b8 fa ff ff       	call   8001a5 <printnum>
			break;
  8006ed:	83 c4 20             	add    $0x20,%esp
			char* cp = va_arg(ap, char *);
  8006f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006f3:	83 c7 01             	add    $0x1,%edi
  8006f6:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006fa:	83 f8 25             	cmp    $0x25,%eax
  8006fd:	0f 84 d2 fb ff ff    	je     8002d5 <vprintfmt+0x17>
			if (ch == '\0')
  800703:	85 c0                	test   %eax,%eax
  800705:	0f 84 03 01 00 00    	je     80080e <vprintfmt+0x550>
			putch(ch, putdat);
  80070b:	83 ec 08             	sub    $0x8,%esp
  80070e:	53                   	push   %ebx
  80070f:	50                   	push   %eax
  800710:	ff d6                	call   *%esi
  800712:	83 c4 10             	add    $0x10,%esp
  800715:	eb dc                	jmp    8006f3 <vprintfmt+0x435>
	if (lflag >= 2)
  800717:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  80071b:	7f 29                	jg     800746 <vprintfmt+0x488>
	else if (lflag)
  80071d:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800721:	74 44                	je     800767 <vprintfmt+0x4a9>
		return va_arg(*ap, unsigned long);
  800723:	8b 45 14             	mov    0x14(%ebp),%eax
  800726:	8b 00                	mov    (%eax),%eax
  800728:	ba 00 00 00 00       	mov    $0x0,%edx
  80072d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800730:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800733:	8b 45 14             	mov    0x14(%ebp),%eax
  800736:	8d 40 04             	lea    0x4(%eax),%eax
  800739:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80073c:	bf 10 00 00 00       	mov    $0x10,%edi
  800741:	e9 7b ff ff ff       	jmp    8006c1 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  800746:	8b 45 14             	mov    0x14(%ebp),%eax
  800749:	8b 50 04             	mov    0x4(%eax),%edx
  80074c:	8b 00                	mov    (%eax),%eax
  80074e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800751:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800754:	8b 45 14             	mov    0x14(%ebp),%eax
  800757:	8d 40 08             	lea    0x8(%eax),%eax
  80075a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80075d:	bf 10 00 00 00       	mov    $0x10,%edi
  800762:	e9 5a ff ff ff       	jmp    8006c1 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  800767:	8b 45 14             	mov    0x14(%ebp),%eax
  80076a:	8b 00                	mov    (%eax),%eax
  80076c:	ba 00 00 00 00       	mov    $0x0,%edx
  800771:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800774:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800777:	8b 45 14             	mov    0x14(%ebp),%eax
  80077a:	8d 40 04             	lea    0x4(%eax),%eax
  80077d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800780:	bf 10 00 00 00       	mov    $0x10,%edi
  800785:	e9 37 ff ff ff       	jmp    8006c1 <vprintfmt+0x403>
			char* cp = va_arg(ap, char *);
  80078a:	8b 45 14             	mov    0x14(%ebp),%eax
  80078d:	8d 78 04             	lea    0x4(%eax),%edi
  800790:	8b 00                	mov    (%eax),%eax
    			if (cp == NULL) {
  800792:	85 c0                	test   %eax,%eax
  800794:	74 2c                	je     8007c2 <vprintfmt+0x504>
    			*cp = *(int *)putdat;
  800796:	8b 13                	mov    (%ebx),%edx
  800798:	88 10                	mov    %dl,(%eax)
			char* cp = va_arg(ap, char *);
  80079a:	89 7d 14             	mov    %edi,0x14(%ebp)
    			if ((*(int *) putdat) > 127)
  80079d:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  8007a0:	0f 8e 4a ff ff ff    	jle    8006f0 <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", overflow_error);
  8007a6:	68 20 14 80 00       	push   $0x801420
  8007ab:	68 d3 12 80 00       	push   $0x8012d3
  8007b0:	53                   	push   %ebx
  8007b1:	56                   	push   %esi
  8007b2:	e8 ea fa ff ff       	call   8002a1 <printfmt>
  8007b7:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  8007ba:	89 7d 14             	mov    %edi,0x14(%ebp)
  8007bd:	e9 2e ff ff ff       	jmp    8006f0 <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", null_error);
  8007c2:	68 e8 13 80 00       	push   $0x8013e8
  8007c7:	68 d3 12 80 00       	push   $0x8012d3
  8007cc:	53                   	push   %ebx
  8007cd:	56                   	push   %esi
  8007ce:	e8 ce fa ff ff       	call   8002a1 <printfmt>
        		break;
  8007d3:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  8007d6:	89 7d 14             	mov    %edi,0x14(%ebp)
        		break;
  8007d9:	e9 12 ff ff ff       	jmp    8006f0 <vprintfmt+0x432>
			putch(ch, putdat);
  8007de:	83 ec 08             	sub    $0x8,%esp
  8007e1:	53                   	push   %ebx
  8007e2:	6a 25                	push   $0x25
  8007e4:	ff d6                	call   *%esi
			break;
  8007e6:	83 c4 10             	add    $0x10,%esp
  8007e9:	e9 02 ff ff ff       	jmp    8006f0 <vprintfmt+0x432>
			putch('%', putdat);
  8007ee:	83 ec 08             	sub    $0x8,%esp
  8007f1:	53                   	push   %ebx
  8007f2:	6a 25                	push   $0x25
  8007f4:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007f6:	83 c4 10             	add    $0x10,%esp
  8007f9:	89 f8                	mov    %edi,%eax
  8007fb:	eb 03                	jmp    800800 <vprintfmt+0x542>
  8007fd:	83 e8 01             	sub    $0x1,%eax
  800800:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800804:	75 f7                	jne    8007fd <vprintfmt+0x53f>
  800806:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800809:	e9 e2 fe ff ff       	jmp    8006f0 <vprintfmt+0x432>
}
  80080e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800811:	5b                   	pop    %ebx
  800812:	5e                   	pop    %esi
  800813:	5f                   	pop    %edi
  800814:	5d                   	pop    %ebp
  800815:	c3                   	ret    

00800816 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800816:	55                   	push   %ebp
  800817:	89 e5                	mov    %esp,%ebp
  800819:	83 ec 18             	sub    $0x18,%esp
  80081c:	8b 45 08             	mov    0x8(%ebp),%eax
  80081f:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800822:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800825:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800829:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80082c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800833:	85 c0                	test   %eax,%eax
  800835:	74 26                	je     80085d <vsnprintf+0x47>
  800837:	85 d2                	test   %edx,%edx
  800839:	7e 22                	jle    80085d <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80083b:	ff 75 14             	pushl  0x14(%ebp)
  80083e:	ff 75 10             	pushl  0x10(%ebp)
  800841:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800844:	50                   	push   %eax
  800845:	68 84 02 80 00       	push   $0x800284
  80084a:	e8 6f fa ff ff       	call   8002be <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80084f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800852:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800855:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800858:	83 c4 10             	add    $0x10,%esp
}
  80085b:	c9                   	leave  
  80085c:	c3                   	ret    
		return -E_INVAL;
  80085d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800862:	eb f7                	jmp    80085b <vsnprintf+0x45>

00800864 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800864:	55                   	push   %ebp
  800865:	89 e5                	mov    %esp,%ebp
  800867:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80086a:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80086d:	50                   	push   %eax
  80086e:	ff 75 10             	pushl  0x10(%ebp)
  800871:	ff 75 0c             	pushl  0xc(%ebp)
  800874:	ff 75 08             	pushl  0x8(%ebp)
  800877:	e8 9a ff ff ff       	call   800816 <vsnprintf>
	va_end(ap);

	return rc;
}
  80087c:	c9                   	leave  
  80087d:	c3                   	ret    

0080087e <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80087e:	55                   	push   %ebp
  80087f:	89 e5                	mov    %esp,%ebp
  800881:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800884:	b8 00 00 00 00       	mov    $0x0,%eax
  800889:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80088d:	74 05                	je     800894 <strlen+0x16>
		n++;
  80088f:	83 c0 01             	add    $0x1,%eax
  800892:	eb f5                	jmp    800889 <strlen+0xb>
	return n;
}
  800894:	5d                   	pop    %ebp
  800895:	c3                   	ret    

00800896 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800896:	55                   	push   %ebp
  800897:	89 e5                	mov    %esp,%ebp
  800899:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80089c:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80089f:	ba 00 00 00 00       	mov    $0x0,%edx
  8008a4:	39 c2                	cmp    %eax,%edx
  8008a6:	74 0d                	je     8008b5 <strnlen+0x1f>
  8008a8:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8008ac:	74 05                	je     8008b3 <strnlen+0x1d>
		n++;
  8008ae:	83 c2 01             	add    $0x1,%edx
  8008b1:	eb f1                	jmp    8008a4 <strnlen+0xe>
  8008b3:	89 d0                	mov    %edx,%eax
	return n;
}
  8008b5:	5d                   	pop    %ebp
  8008b6:	c3                   	ret    

008008b7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008b7:	55                   	push   %ebp
  8008b8:	89 e5                	mov    %esp,%ebp
  8008ba:	53                   	push   %ebx
  8008bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008be:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8008c6:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8008ca:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8008cd:	83 c2 01             	add    $0x1,%edx
  8008d0:	84 c9                	test   %cl,%cl
  8008d2:	75 f2                	jne    8008c6 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8008d4:	5b                   	pop    %ebx
  8008d5:	5d                   	pop    %ebp
  8008d6:	c3                   	ret    

008008d7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008d7:	55                   	push   %ebp
  8008d8:	89 e5                	mov    %esp,%ebp
  8008da:	53                   	push   %ebx
  8008db:	83 ec 10             	sub    $0x10,%esp
  8008de:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008e1:	53                   	push   %ebx
  8008e2:	e8 97 ff ff ff       	call   80087e <strlen>
  8008e7:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8008ea:	ff 75 0c             	pushl  0xc(%ebp)
  8008ed:	01 d8                	add    %ebx,%eax
  8008ef:	50                   	push   %eax
  8008f0:	e8 c2 ff ff ff       	call   8008b7 <strcpy>
	return dst;
}
  8008f5:	89 d8                	mov    %ebx,%eax
  8008f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008fa:	c9                   	leave  
  8008fb:	c3                   	ret    

008008fc <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008fc:	55                   	push   %ebp
  8008fd:	89 e5                	mov    %esp,%ebp
  8008ff:	56                   	push   %esi
  800900:	53                   	push   %ebx
  800901:	8b 45 08             	mov    0x8(%ebp),%eax
  800904:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800907:	89 c6                	mov    %eax,%esi
  800909:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80090c:	89 c2                	mov    %eax,%edx
  80090e:	39 f2                	cmp    %esi,%edx
  800910:	74 11                	je     800923 <strncpy+0x27>
		*dst++ = *src;
  800912:	83 c2 01             	add    $0x1,%edx
  800915:	0f b6 19             	movzbl (%ecx),%ebx
  800918:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80091b:	80 fb 01             	cmp    $0x1,%bl
  80091e:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800921:	eb eb                	jmp    80090e <strncpy+0x12>
	}
	return ret;
}
  800923:	5b                   	pop    %ebx
  800924:	5e                   	pop    %esi
  800925:	5d                   	pop    %ebp
  800926:	c3                   	ret    

00800927 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800927:	55                   	push   %ebp
  800928:	89 e5                	mov    %esp,%ebp
  80092a:	56                   	push   %esi
  80092b:	53                   	push   %ebx
  80092c:	8b 75 08             	mov    0x8(%ebp),%esi
  80092f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800932:	8b 55 10             	mov    0x10(%ebp),%edx
  800935:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800937:	85 d2                	test   %edx,%edx
  800939:	74 21                	je     80095c <strlcpy+0x35>
  80093b:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80093f:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800941:	39 c2                	cmp    %eax,%edx
  800943:	74 14                	je     800959 <strlcpy+0x32>
  800945:	0f b6 19             	movzbl (%ecx),%ebx
  800948:	84 db                	test   %bl,%bl
  80094a:	74 0b                	je     800957 <strlcpy+0x30>
			*dst++ = *src++;
  80094c:	83 c1 01             	add    $0x1,%ecx
  80094f:	83 c2 01             	add    $0x1,%edx
  800952:	88 5a ff             	mov    %bl,-0x1(%edx)
  800955:	eb ea                	jmp    800941 <strlcpy+0x1a>
  800957:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800959:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80095c:	29 f0                	sub    %esi,%eax
}
  80095e:	5b                   	pop    %ebx
  80095f:	5e                   	pop    %esi
  800960:	5d                   	pop    %ebp
  800961:	c3                   	ret    

00800962 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800962:	55                   	push   %ebp
  800963:	89 e5                	mov    %esp,%ebp
  800965:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800968:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80096b:	0f b6 01             	movzbl (%ecx),%eax
  80096e:	84 c0                	test   %al,%al
  800970:	74 0c                	je     80097e <strcmp+0x1c>
  800972:	3a 02                	cmp    (%edx),%al
  800974:	75 08                	jne    80097e <strcmp+0x1c>
		p++, q++;
  800976:	83 c1 01             	add    $0x1,%ecx
  800979:	83 c2 01             	add    $0x1,%edx
  80097c:	eb ed                	jmp    80096b <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80097e:	0f b6 c0             	movzbl %al,%eax
  800981:	0f b6 12             	movzbl (%edx),%edx
  800984:	29 d0                	sub    %edx,%eax
}
  800986:	5d                   	pop    %ebp
  800987:	c3                   	ret    

00800988 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800988:	55                   	push   %ebp
  800989:	89 e5                	mov    %esp,%ebp
  80098b:	53                   	push   %ebx
  80098c:	8b 45 08             	mov    0x8(%ebp),%eax
  80098f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800992:	89 c3                	mov    %eax,%ebx
  800994:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800997:	eb 06                	jmp    80099f <strncmp+0x17>
		n--, p++, q++;
  800999:	83 c0 01             	add    $0x1,%eax
  80099c:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80099f:	39 d8                	cmp    %ebx,%eax
  8009a1:	74 16                	je     8009b9 <strncmp+0x31>
  8009a3:	0f b6 08             	movzbl (%eax),%ecx
  8009a6:	84 c9                	test   %cl,%cl
  8009a8:	74 04                	je     8009ae <strncmp+0x26>
  8009aa:	3a 0a                	cmp    (%edx),%cl
  8009ac:	74 eb                	je     800999 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009ae:	0f b6 00             	movzbl (%eax),%eax
  8009b1:	0f b6 12             	movzbl (%edx),%edx
  8009b4:	29 d0                	sub    %edx,%eax
}
  8009b6:	5b                   	pop    %ebx
  8009b7:	5d                   	pop    %ebp
  8009b8:	c3                   	ret    
		return 0;
  8009b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8009be:	eb f6                	jmp    8009b6 <strncmp+0x2e>

008009c0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009c0:	55                   	push   %ebp
  8009c1:	89 e5                	mov    %esp,%ebp
  8009c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009ca:	0f b6 10             	movzbl (%eax),%edx
  8009cd:	84 d2                	test   %dl,%dl
  8009cf:	74 09                	je     8009da <strchr+0x1a>
		if (*s == c)
  8009d1:	38 ca                	cmp    %cl,%dl
  8009d3:	74 0a                	je     8009df <strchr+0x1f>
	for (; *s; s++)
  8009d5:	83 c0 01             	add    $0x1,%eax
  8009d8:	eb f0                	jmp    8009ca <strchr+0xa>
			return (char *) s;
	return 0;
  8009da:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009df:	5d                   	pop    %ebp
  8009e0:	c3                   	ret    

008009e1 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009e1:	55                   	push   %ebp
  8009e2:	89 e5                	mov    %esp,%ebp
  8009e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e7:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009eb:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009ee:	38 ca                	cmp    %cl,%dl
  8009f0:	74 09                	je     8009fb <strfind+0x1a>
  8009f2:	84 d2                	test   %dl,%dl
  8009f4:	74 05                	je     8009fb <strfind+0x1a>
	for (; *s; s++)
  8009f6:	83 c0 01             	add    $0x1,%eax
  8009f9:	eb f0                	jmp    8009eb <strfind+0xa>
			break;
	return (char *) s;
}
  8009fb:	5d                   	pop    %ebp
  8009fc:	c3                   	ret    

008009fd <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009fd:	55                   	push   %ebp
  8009fe:	89 e5                	mov    %esp,%ebp
  800a00:	57                   	push   %edi
  800a01:	56                   	push   %esi
  800a02:	53                   	push   %ebx
  800a03:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a06:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a09:	85 c9                	test   %ecx,%ecx
  800a0b:	74 31                	je     800a3e <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a0d:	89 f8                	mov    %edi,%eax
  800a0f:	09 c8                	or     %ecx,%eax
  800a11:	a8 03                	test   $0x3,%al
  800a13:	75 23                	jne    800a38 <memset+0x3b>
		c &= 0xFF;
  800a15:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a19:	89 d3                	mov    %edx,%ebx
  800a1b:	c1 e3 08             	shl    $0x8,%ebx
  800a1e:	89 d0                	mov    %edx,%eax
  800a20:	c1 e0 18             	shl    $0x18,%eax
  800a23:	89 d6                	mov    %edx,%esi
  800a25:	c1 e6 10             	shl    $0x10,%esi
  800a28:	09 f0                	or     %esi,%eax
  800a2a:	09 c2                	or     %eax,%edx
  800a2c:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a2e:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a31:	89 d0                	mov    %edx,%eax
  800a33:	fc                   	cld    
  800a34:	f3 ab                	rep stos %eax,%es:(%edi)
  800a36:	eb 06                	jmp    800a3e <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a3b:	fc                   	cld    
  800a3c:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a3e:	89 f8                	mov    %edi,%eax
  800a40:	5b                   	pop    %ebx
  800a41:	5e                   	pop    %esi
  800a42:	5f                   	pop    %edi
  800a43:	5d                   	pop    %ebp
  800a44:	c3                   	ret    

00800a45 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a45:	55                   	push   %ebp
  800a46:	89 e5                	mov    %esp,%ebp
  800a48:	57                   	push   %edi
  800a49:	56                   	push   %esi
  800a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4d:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a50:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a53:	39 c6                	cmp    %eax,%esi
  800a55:	73 32                	jae    800a89 <memmove+0x44>
  800a57:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a5a:	39 c2                	cmp    %eax,%edx
  800a5c:	76 2b                	jbe    800a89 <memmove+0x44>
		s += n;
		d += n;
  800a5e:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a61:	89 fe                	mov    %edi,%esi
  800a63:	09 ce                	or     %ecx,%esi
  800a65:	09 d6                	or     %edx,%esi
  800a67:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a6d:	75 0e                	jne    800a7d <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a6f:	83 ef 04             	sub    $0x4,%edi
  800a72:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a75:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a78:	fd                   	std    
  800a79:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a7b:	eb 09                	jmp    800a86 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a7d:	83 ef 01             	sub    $0x1,%edi
  800a80:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a83:	fd                   	std    
  800a84:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a86:	fc                   	cld    
  800a87:	eb 1a                	jmp    800aa3 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a89:	89 c2                	mov    %eax,%edx
  800a8b:	09 ca                	or     %ecx,%edx
  800a8d:	09 f2                	or     %esi,%edx
  800a8f:	f6 c2 03             	test   $0x3,%dl
  800a92:	75 0a                	jne    800a9e <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a94:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a97:	89 c7                	mov    %eax,%edi
  800a99:	fc                   	cld    
  800a9a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a9c:	eb 05                	jmp    800aa3 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800a9e:	89 c7                	mov    %eax,%edi
  800aa0:	fc                   	cld    
  800aa1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800aa3:	5e                   	pop    %esi
  800aa4:	5f                   	pop    %edi
  800aa5:	5d                   	pop    %ebp
  800aa6:	c3                   	ret    

00800aa7 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800aa7:	55                   	push   %ebp
  800aa8:	89 e5                	mov    %esp,%ebp
  800aaa:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800aad:	ff 75 10             	pushl  0x10(%ebp)
  800ab0:	ff 75 0c             	pushl  0xc(%ebp)
  800ab3:	ff 75 08             	pushl  0x8(%ebp)
  800ab6:	e8 8a ff ff ff       	call   800a45 <memmove>
}
  800abb:	c9                   	leave  
  800abc:	c3                   	ret    

00800abd <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800abd:	55                   	push   %ebp
  800abe:	89 e5                	mov    %esp,%ebp
  800ac0:	56                   	push   %esi
  800ac1:	53                   	push   %ebx
  800ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ac8:	89 c6                	mov    %eax,%esi
  800aca:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800acd:	39 f0                	cmp    %esi,%eax
  800acf:	74 1c                	je     800aed <memcmp+0x30>
		if (*s1 != *s2)
  800ad1:	0f b6 08             	movzbl (%eax),%ecx
  800ad4:	0f b6 1a             	movzbl (%edx),%ebx
  800ad7:	38 d9                	cmp    %bl,%cl
  800ad9:	75 08                	jne    800ae3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800adb:	83 c0 01             	add    $0x1,%eax
  800ade:	83 c2 01             	add    $0x1,%edx
  800ae1:	eb ea                	jmp    800acd <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800ae3:	0f b6 c1             	movzbl %cl,%eax
  800ae6:	0f b6 db             	movzbl %bl,%ebx
  800ae9:	29 d8                	sub    %ebx,%eax
  800aeb:	eb 05                	jmp    800af2 <memcmp+0x35>
	}

	return 0;
  800aed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800af2:	5b                   	pop    %ebx
  800af3:	5e                   	pop    %esi
  800af4:	5d                   	pop    %ebp
  800af5:	c3                   	ret    

00800af6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800af6:	55                   	push   %ebp
  800af7:	89 e5                	mov    %esp,%ebp
  800af9:	8b 45 08             	mov    0x8(%ebp),%eax
  800afc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800aff:	89 c2                	mov    %eax,%edx
  800b01:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b04:	39 d0                	cmp    %edx,%eax
  800b06:	73 09                	jae    800b11 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b08:	38 08                	cmp    %cl,(%eax)
  800b0a:	74 05                	je     800b11 <memfind+0x1b>
	for (; s < ends; s++)
  800b0c:	83 c0 01             	add    $0x1,%eax
  800b0f:	eb f3                	jmp    800b04 <memfind+0xe>
			break;
	return (void *) s;
}
  800b11:	5d                   	pop    %ebp
  800b12:	c3                   	ret    

00800b13 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b13:	55                   	push   %ebp
  800b14:	89 e5                	mov    %esp,%ebp
  800b16:	57                   	push   %edi
  800b17:	56                   	push   %esi
  800b18:	53                   	push   %ebx
  800b19:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b1c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b1f:	eb 03                	jmp    800b24 <strtol+0x11>
		s++;
  800b21:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b24:	0f b6 01             	movzbl (%ecx),%eax
  800b27:	3c 20                	cmp    $0x20,%al
  800b29:	74 f6                	je     800b21 <strtol+0xe>
  800b2b:	3c 09                	cmp    $0x9,%al
  800b2d:	74 f2                	je     800b21 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b2f:	3c 2b                	cmp    $0x2b,%al
  800b31:	74 2a                	je     800b5d <strtol+0x4a>
	int neg = 0;
  800b33:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b38:	3c 2d                	cmp    $0x2d,%al
  800b3a:	74 2b                	je     800b67 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b3c:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b42:	75 0f                	jne    800b53 <strtol+0x40>
  800b44:	80 39 30             	cmpb   $0x30,(%ecx)
  800b47:	74 28                	je     800b71 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b49:	85 db                	test   %ebx,%ebx
  800b4b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b50:	0f 44 d8             	cmove  %eax,%ebx
  800b53:	b8 00 00 00 00       	mov    $0x0,%eax
  800b58:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b5b:	eb 50                	jmp    800bad <strtol+0x9a>
		s++;
  800b5d:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b60:	bf 00 00 00 00       	mov    $0x0,%edi
  800b65:	eb d5                	jmp    800b3c <strtol+0x29>
		s++, neg = 1;
  800b67:	83 c1 01             	add    $0x1,%ecx
  800b6a:	bf 01 00 00 00       	mov    $0x1,%edi
  800b6f:	eb cb                	jmp    800b3c <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b71:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b75:	74 0e                	je     800b85 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800b77:	85 db                	test   %ebx,%ebx
  800b79:	75 d8                	jne    800b53 <strtol+0x40>
		s++, base = 8;
  800b7b:	83 c1 01             	add    $0x1,%ecx
  800b7e:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b83:	eb ce                	jmp    800b53 <strtol+0x40>
		s += 2, base = 16;
  800b85:	83 c1 02             	add    $0x2,%ecx
  800b88:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b8d:	eb c4                	jmp    800b53 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b8f:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b92:	89 f3                	mov    %esi,%ebx
  800b94:	80 fb 19             	cmp    $0x19,%bl
  800b97:	77 29                	ja     800bc2 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800b99:	0f be d2             	movsbl %dl,%edx
  800b9c:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b9f:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ba2:	7d 30                	jge    800bd4 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800ba4:	83 c1 01             	add    $0x1,%ecx
  800ba7:	0f af 45 10          	imul   0x10(%ebp),%eax
  800bab:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800bad:	0f b6 11             	movzbl (%ecx),%edx
  800bb0:	8d 72 d0             	lea    -0x30(%edx),%esi
  800bb3:	89 f3                	mov    %esi,%ebx
  800bb5:	80 fb 09             	cmp    $0x9,%bl
  800bb8:	77 d5                	ja     800b8f <strtol+0x7c>
			dig = *s - '0';
  800bba:	0f be d2             	movsbl %dl,%edx
  800bbd:	83 ea 30             	sub    $0x30,%edx
  800bc0:	eb dd                	jmp    800b9f <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800bc2:	8d 72 bf             	lea    -0x41(%edx),%esi
  800bc5:	89 f3                	mov    %esi,%ebx
  800bc7:	80 fb 19             	cmp    $0x19,%bl
  800bca:	77 08                	ja     800bd4 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800bcc:	0f be d2             	movsbl %dl,%edx
  800bcf:	83 ea 37             	sub    $0x37,%edx
  800bd2:	eb cb                	jmp    800b9f <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800bd4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bd8:	74 05                	je     800bdf <strtol+0xcc>
		*endptr = (char *) s;
  800bda:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bdd:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800bdf:	89 c2                	mov    %eax,%edx
  800be1:	f7 da                	neg    %edx
  800be3:	85 ff                	test   %edi,%edi
  800be5:	0f 45 c2             	cmovne %edx,%eax
}
  800be8:	5b                   	pop    %ebx
  800be9:	5e                   	pop    %esi
  800bea:	5f                   	pop    %edi
  800beb:	5d                   	pop    %ebp
  800bec:	c3                   	ret    

00800bed <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bed:	55                   	push   %ebp
  800bee:	89 e5                	mov    %esp,%ebp
  800bf0:	57                   	push   %edi
  800bf1:	56                   	push   %esi
  800bf2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bf3:	b8 00 00 00 00       	mov    $0x0,%eax
  800bf8:	8b 55 08             	mov    0x8(%ebp),%edx
  800bfb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bfe:	89 c3                	mov    %eax,%ebx
  800c00:	89 c7                	mov    %eax,%edi
  800c02:	89 c6                	mov    %eax,%esi
  800c04:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c06:	5b                   	pop    %ebx
  800c07:	5e                   	pop    %esi
  800c08:	5f                   	pop    %edi
  800c09:	5d                   	pop    %ebp
  800c0a:	c3                   	ret    

00800c0b <sys_cgetc>:

int
sys_cgetc(void)
{
  800c0b:	55                   	push   %ebp
  800c0c:	89 e5                	mov    %esp,%ebp
  800c0e:	57                   	push   %edi
  800c0f:	56                   	push   %esi
  800c10:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c11:	ba 00 00 00 00       	mov    $0x0,%edx
  800c16:	b8 01 00 00 00       	mov    $0x1,%eax
  800c1b:	89 d1                	mov    %edx,%ecx
  800c1d:	89 d3                	mov    %edx,%ebx
  800c1f:	89 d7                	mov    %edx,%edi
  800c21:	89 d6                	mov    %edx,%esi
  800c23:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c25:	5b                   	pop    %ebx
  800c26:	5e                   	pop    %esi
  800c27:	5f                   	pop    %edi
  800c28:	5d                   	pop    %ebp
  800c29:	c3                   	ret    

00800c2a <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c2a:	55                   	push   %ebp
  800c2b:	89 e5                	mov    %esp,%ebp
  800c2d:	57                   	push   %edi
  800c2e:	56                   	push   %esi
  800c2f:	53                   	push   %ebx
  800c30:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c33:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c38:	8b 55 08             	mov    0x8(%ebp),%edx
  800c3b:	b8 03 00 00 00       	mov    $0x3,%eax
  800c40:	89 cb                	mov    %ecx,%ebx
  800c42:	89 cf                	mov    %ecx,%edi
  800c44:	89 ce                	mov    %ecx,%esi
  800c46:	cd 30                	int    $0x30
	if (check && ret > 0)
  800c48:	85 c0                	test   %eax,%eax
  800c4a:	7f 08                	jg     800c54 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c4f:	5b                   	pop    %ebx
  800c50:	5e                   	pop    %esi
  800c51:	5f                   	pop    %edi
  800c52:	5d                   	pop    %ebp
  800c53:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c54:	83 ec 0c             	sub    $0xc,%esp
  800c57:	50                   	push   %eax
  800c58:	6a 03                	push   $0x3
  800c5a:	68 40 16 80 00       	push   $0x801640
  800c5f:	6a 4c                	push   $0x4c
  800c61:	68 5d 16 80 00       	push   $0x80165d
  800c66:	e8 65 03 00 00       	call   800fd0 <_panic>

00800c6b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c6b:	55                   	push   %ebp
  800c6c:	89 e5                	mov    %esp,%ebp
  800c6e:	57                   	push   %edi
  800c6f:	56                   	push   %esi
  800c70:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c71:	ba 00 00 00 00       	mov    $0x0,%edx
  800c76:	b8 02 00 00 00       	mov    $0x2,%eax
  800c7b:	89 d1                	mov    %edx,%ecx
  800c7d:	89 d3                	mov    %edx,%ebx
  800c7f:	89 d7                	mov    %edx,%edi
  800c81:	89 d6                	mov    %edx,%esi
  800c83:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c85:	5b                   	pop    %ebx
  800c86:	5e                   	pop    %esi
  800c87:	5f                   	pop    %edi
  800c88:	5d                   	pop    %ebp
  800c89:	c3                   	ret    

00800c8a <sys_yield>:

void
sys_yield(void)
{
  800c8a:	55                   	push   %ebp
  800c8b:	89 e5                	mov    %esp,%ebp
  800c8d:	57                   	push   %edi
  800c8e:	56                   	push   %esi
  800c8f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c90:	ba 00 00 00 00       	mov    $0x0,%edx
  800c95:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c9a:	89 d1                	mov    %edx,%ecx
  800c9c:	89 d3                	mov    %edx,%ebx
  800c9e:	89 d7                	mov    %edx,%edi
  800ca0:	89 d6                	mov    %edx,%esi
  800ca2:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800ca4:	5b                   	pop    %ebx
  800ca5:	5e                   	pop    %esi
  800ca6:	5f                   	pop    %edi
  800ca7:	5d                   	pop    %ebp
  800ca8:	c3                   	ret    

00800ca9 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800ca9:	55                   	push   %ebp
  800caa:	89 e5                	mov    %esp,%ebp
  800cac:	57                   	push   %edi
  800cad:	56                   	push   %esi
  800cae:	53                   	push   %ebx
  800caf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cb2:	be 00 00 00 00       	mov    $0x0,%esi
  800cb7:	8b 55 08             	mov    0x8(%ebp),%edx
  800cba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cbd:	b8 04 00 00 00       	mov    $0x4,%eax
  800cc2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cc5:	89 f7                	mov    %esi,%edi
  800cc7:	cd 30                	int    $0x30
	if (check && ret > 0)
  800cc9:	85 c0                	test   %eax,%eax
  800ccb:	7f 08                	jg     800cd5 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800ccd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cd0:	5b                   	pop    %ebx
  800cd1:	5e                   	pop    %esi
  800cd2:	5f                   	pop    %edi
  800cd3:	5d                   	pop    %ebp
  800cd4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cd5:	83 ec 0c             	sub    $0xc,%esp
  800cd8:	50                   	push   %eax
  800cd9:	6a 04                	push   $0x4
  800cdb:	68 40 16 80 00       	push   $0x801640
  800ce0:	6a 4c                	push   $0x4c
  800ce2:	68 5d 16 80 00       	push   $0x80165d
  800ce7:	e8 e4 02 00 00       	call   800fd0 <_panic>

00800cec <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cec:	55                   	push   %ebp
  800ced:	89 e5                	mov    %esp,%ebp
  800cef:	57                   	push   %edi
  800cf0:	56                   	push   %esi
  800cf1:	53                   	push   %ebx
  800cf2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cf5:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cfb:	b8 05 00 00 00       	mov    $0x5,%eax
  800d00:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d03:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d06:	8b 75 18             	mov    0x18(%ebp),%esi
  800d09:	cd 30                	int    $0x30
	if (check && ret > 0)
  800d0b:	85 c0                	test   %eax,%eax
  800d0d:	7f 08                	jg     800d17 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
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
  800d1b:	6a 05                	push   $0x5
  800d1d:	68 40 16 80 00       	push   $0x801640
  800d22:	6a 4c                	push   $0x4c
  800d24:	68 5d 16 80 00       	push   $0x80165d
  800d29:	e8 a2 02 00 00       	call   800fd0 <_panic>

00800d2e <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d2e:	55                   	push   %ebp
  800d2f:	89 e5                	mov    %esp,%ebp
  800d31:	57                   	push   %edi
  800d32:	56                   	push   %esi
  800d33:	53                   	push   %ebx
  800d34:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d37:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d3c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d3f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d42:	b8 06 00 00 00       	mov    $0x6,%eax
  800d47:	89 df                	mov    %ebx,%edi
  800d49:	89 de                	mov    %ebx,%esi
  800d4b:	cd 30                	int    $0x30
	if (check && ret > 0)
  800d4d:	85 c0                	test   %eax,%eax
  800d4f:	7f 08                	jg     800d59 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
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
  800d5d:	6a 06                	push   $0x6
  800d5f:	68 40 16 80 00       	push   $0x801640
  800d64:	6a 4c                	push   $0x4c
  800d66:	68 5d 16 80 00       	push   $0x80165d
  800d6b:	e8 60 02 00 00       	call   800fd0 <_panic>

00800d70 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
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
  800d84:	b8 08 00 00 00       	mov    $0x8,%eax
  800d89:	89 df                	mov    %ebx,%edi
  800d8b:	89 de                	mov    %ebx,%esi
  800d8d:	cd 30                	int    $0x30
	if (check && ret > 0)
  800d8f:	85 c0                	test   %eax,%eax
  800d91:	7f 08                	jg     800d9b <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
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
  800d9f:	6a 08                	push   $0x8
  800da1:	68 40 16 80 00       	push   $0x801640
  800da6:	6a 4c                	push   $0x4c
  800da8:	68 5d 16 80 00       	push   $0x80165d
  800dad:	e8 1e 02 00 00       	call   800fd0 <_panic>

00800db2 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
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
  800dc6:	b8 09 00 00 00       	mov    $0x9,%eax
  800dcb:	89 df                	mov    %ebx,%edi
  800dcd:	89 de                	mov    %ebx,%esi
  800dcf:	cd 30                	int    $0x30
	if (check && ret > 0)
  800dd1:	85 c0                	test   %eax,%eax
  800dd3:	7f 08                	jg     800ddd <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
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
  800de1:	6a 09                	push   $0x9
  800de3:	68 40 16 80 00       	push   $0x801640
  800de8:	6a 4c                	push   $0x4c
  800dea:	68 5d 16 80 00       	push   $0x80165d
  800def:	e8 dc 01 00 00       	call   800fd0 <_panic>

00800df4 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
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
  800e08:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e0d:	89 df                	mov    %ebx,%edi
  800e0f:	89 de                	mov    %ebx,%esi
  800e11:	cd 30                	int    $0x30
	if (check && ret > 0)
  800e13:	85 c0                	test   %eax,%eax
  800e15:	7f 08                	jg     800e1f <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
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
  800e23:	6a 0a                	push   $0xa
  800e25:	68 40 16 80 00       	push   $0x801640
  800e2a:	6a 4c                	push   $0x4c
  800e2c:	68 5d 16 80 00       	push   $0x80165d
  800e31:	e8 9a 01 00 00       	call   800fd0 <_panic>

00800e36 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e36:	55                   	push   %ebp
  800e37:	89 e5                	mov    %esp,%ebp
  800e39:	57                   	push   %edi
  800e3a:	56                   	push   %esi
  800e3b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e3c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e3f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e42:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e47:	be 00 00 00 00       	mov    $0x0,%esi
  800e4c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e4f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e52:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e54:	5b                   	pop    %ebx
  800e55:	5e                   	pop    %esi
  800e56:	5f                   	pop    %edi
  800e57:	5d                   	pop    %ebp
  800e58:	c3                   	ret    

00800e59 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e59:	55                   	push   %ebp
  800e5a:	89 e5                	mov    %esp,%ebp
  800e5c:	57                   	push   %edi
  800e5d:	56                   	push   %esi
  800e5e:	53                   	push   %ebx
  800e5f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e62:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e67:	8b 55 08             	mov    0x8(%ebp),%edx
  800e6a:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e6f:	89 cb                	mov    %ecx,%ebx
  800e71:	89 cf                	mov    %ecx,%edi
  800e73:	89 ce                	mov    %ecx,%esi
  800e75:	cd 30                	int    $0x30
	if (check && ret > 0)
  800e77:	85 c0                	test   %eax,%eax
  800e79:	7f 08                	jg     800e83 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e7e:	5b                   	pop    %ebx
  800e7f:	5e                   	pop    %esi
  800e80:	5f                   	pop    %edi
  800e81:	5d                   	pop    %ebp
  800e82:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e83:	83 ec 0c             	sub    $0xc,%esp
  800e86:	50                   	push   %eax
  800e87:	6a 0d                	push   $0xd
  800e89:	68 40 16 80 00       	push   $0x801640
  800e8e:	6a 4c                	push   $0x4c
  800e90:	68 5d 16 80 00       	push   $0x80165d
  800e95:	e8 36 01 00 00       	call   800fd0 <_panic>

00800e9a <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800e9a:	55                   	push   %ebp
  800e9b:	89 e5                	mov    %esp,%ebp
  800e9d:	57                   	push   %edi
  800e9e:	56                   	push   %esi
  800e9f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ea0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ea5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eab:	b8 0e 00 00 00       	mov    $0xe,%eax
  800eb0:	89 df                	mov    %ebx,%edi
  800eb2:	89 de                	mov    %ebx,%esi
  800eb4:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800eb6:	5b                   	pop    %ebx
  800eb7:	5e                   	pop    %esi
  800eb8:	5f                   	pop    %edi
  800eb9:	5d                   	pop    %ebp
  800eba:	c3                   	ret    

00800ebb <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800ebb:	55                   	push   %ebp
  800ebc:	89 e5                	mov    %esp,%ebp
  800ebe:	57                   	push   %edi
  800ebf:	56                   	push   %esi
  800ec0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ec1:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ec6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec9:	b8 0f 00 00 00       	mov    $0xf,%eax
  800ece:	89 cb                	mov    %ecx,%ebx
  800ed0:	89 cf                	mov    %ecx,%edi
  800ed2:	89 ce                	mov    %ecx,%esi
  800ed4:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800ed6:	5b                   	pop    %ebx
  800ed7:	5e                   	pop    %esi
  800ed8:	5f                   	pop    %edi
  800ed9:	5d                   	pop    %ebp
  800eda:	c3                   	ret    

00800edb <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  800edb:	55                   	push   %ebp
  800edc:	89 e5                	mov    %esp,%ebp
  800ede:	56                   	push   %esi
  800edf:	53                   	push   %ebx
  800ee0:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800ee3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee6:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// return 0;
	if(!pg)
  800ee9:	85 c0                	test   %eax,%eax
		pg = (void*)UTOP;
  800eeb:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  800ef0:	0f 44 c2             	cmove  %edx,%eax
	
	int ret;

	ret = sys_ipc_recv(pg);
  800ef3:	83 ec 0c             	sub    $0xc,%esp
  800ef6:	50                   	push   %eax
  800ef7:	e8 5d ff ff ff       	call   800e59 <sys_ipc_recv>
	if(ret < 0){
  800efc:	83 c4 10             	add    $0x10,%esp
  800eff:	85 c0                	test   %eax,%eax
  800f01:	78 2b                	js     800f2e <ipc_recv+0x53>
		if(perm_store) *perm_store = 0;
		if(from_env_store) *from_env_store = 0;
		return ret;
	}
	
	if(perm_store)
  800f03:	85 f6                	test   %esi,%esi
  800f05:	74 0a                	je     800f11 <ipc_recv+0x36>
		*perm_store = thisenv->env_ipc_perm;
  800f07:	a1 04 20 80 00       	mov    0x802004,%eax
  800f0c:	8b 40 78             	mov    0x78(%eax),%eax
  800f0f:	89 06                	mov    %eax,(%esi)
	if(from_env_store)
  800f11:	85 db                	test   %ebx,%ebx
  800f13:	74 0a                	je     800f1f <ipc_recv+0x44>
		*from_env_store = thisenv->env_ipc_from;
  800f15:	a1 04 20 80 00       	mov    0x802004,%eax
  800f1a:	8b 40 74             	mov    0x74(%eax),%eax
  800f1d:	89 03                	mov    %eax,(%ebx)

	return thisenv->env_ipc_value;
  800f1f:	a1 04 20 80 00       	mov    0x802004,%eax
  800f24:	8b 40 70             	mov    0x70(%eax),%eax
}
  800f27:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f2a:	5b                   	pop    %ebx
  800f2b:	5e                   	pop    %esi
  800f2c:	5d                   	pop    %ebp
  800f2d:	c3                   	ret    
		if(perm_store) *perm_store = 0;
  800f2e:	85 f6                	test   %esi,%esi
  800f30:	74 06                	je     800f38 <ipc_recv+0x5d>
  800f32:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(from_env_store) *from_env_store = 0;
  800f38:	85 db                	test   %ebx,%ebx
  800f3a:	74 eb                	je     800f27 <ipc_recv+0x4c>
  800f3c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800f42:	eb e3                	jmp    800f27 <ipc_recv+0x4c>

00800f44 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  800f44:	55                   	push   %ebp
  800f45:	89 e5                	mov    %esp,%ebp
  800f47:	57                   	push   %edi
  800f48:	56                   	push   %esi
  800f49:	53                   	push   %ebx
  800f4a:	83 ec 0c             	sub    $0xc,%esp
  800f4d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800f50:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f53:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
	if (!pg)
  800f56:	85 db                	test   %ebx,%ebx
		pg = (void*)UTOP;
  800f58:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  800f5d:	0f 44 d8             	cmove  %eax,%ebx

	int ret = -E_IPC_NOT_RECV;
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))) {
  800f60:	ff 75 14             	pushl  0x14(%ebp)
  800f63:	53                   	push   %ebx
  800f64:	56                   	push   %esi
  800f65:	57                   	push   %edi
  800f66:	e8 cb fe ff ff       	call   800e36 <sys_ipc_try_send>
  800f6b:	83 c4 10             	add    $0x10,%esp
  800f6e:	85 c0                	test   %eax,%eax
  800f70:	74 17                	je     800f89 <ipc_send+0x45>
		if(ret != -E_IPC_NOT_RECV){
  800f72:	83 f8 f9             	cmp    $0xfffffff9,%eax
  800f75:	74 e9                	je     800f60 <ipc_send+0x1c>
			panic("ipc_send: ret : %d", ret);
  800f77:	50                   	push   %eax
  800f78:	68 6b 16 80 00       	push   $0x80166b
  800f7d:	6a 43                	push   $0x43
  800f7f:	68 7e 16 80 00       	push   $0x80167e
  800f84:	e8 47 00 00 00       	call   800fd0 <_panic>
			sys_yield();
		}
	}
}
  800f89:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f8c:	5b                   	pop    %ebx
  800f8d:	5e                   	pop    %esi
  800f8e:	5f                   	pop    %edi
  800f8f:	5d                   	pop    %ebp
  800f90:	c3                   	ret    

00800f91 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  800f91:	55                   	push   %ebp
  800f92:	89 e5                	mov    %esp,%ebp
  800f94:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  800f97:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  800f9c:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  800fa2:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  800fa8:	8b 52 50             	mov    0x50(%edx),%edx
  800fab:	39 ca                	cmp    %ecx,%edx
  800fad:	74 11                	je     800fc0 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  800faf:	83 c0 01             	add    $0x1,%eax
  800fb2:	3d 00 04 00 00       	cmp    $0x400,%eax
  800fb7:	75 e3                	jne    800f9c <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  800fb9:	b8 00 00 00 00       	mov    $0x0,%eax
  800fbe:	eb 0e                	jmp    800fce <ipc_find_env+0x3d>
			return envs[i].env_id;
  800fc0:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  800fc6:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800fcb:	8b 40 48             	mov    0x48(%eax),%eax
}
  800fce:	5d                   	pop    %ebp
  800fcf:	c3                   	ret    

00800fd0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800fd0:	55                   	push   %ebp
  800fd1:	89 e5                	mov    %esp,%ebp
  800fd3:	56                   	push   %esi
  800fd4:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800fd5:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800fd8:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800fde:	e8 88 fc ff ff       	call   800c6b <sys_getenvid>
  800fe3:	83 ec 0c             	sub    $0xc,%esp
  800fe6:	ff 75 0c             	pushl  0xc(%ebp)
  800fe9:	ff 75 08             	pushl  0x8(%ebp)
  800fec:	56                   	push   %esi
  800fed:	50                   	push   %eax
  800fee:	68 88 16 80 00       	push   $0x801688
  800ff3:	e8 99 f1 ff ff       	call   800191 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800ff8:	83 c4 18             	add    $0x18,%esp
  800ffb:	53                   	push   %ebx
  800ffc:	ff 75 10             	pushl  0x10(%ebp)
  800fff:	e8 3c f1 ff ff       	call   800140 <vcprintf>
	cprintf("\n");
  801004:	c7 04 24 8f 12 80 00 	movl   $0x80128f,(%esp)
  80100b:	e8 81 f1 ff ff       	call   800191 <cprintf>
  801010:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801013:	cc                   	int3   
  801014:	eb fd                	jmp    801013 <_panic+0x43>
  801016:	66 90                	xchg   %ax,%ax
  801018:	66 90                	xchg   %ax,%ax
  80101a:	66 90                	xchg   %ax,%ax
  80101c:	66 90                	xchg   %ax,%ax
  80101e:	66 90                	xchg   %ax,%ax

00801020 <__udivdi3>:
  801020:	55                   	push   %ebp
  801021:	57                   	push   %edi
  801022:	56                   	push   %esi
  801023:	53                   	push   %ebx
  801024:	83 ec 1c             	sub    $0x1c,%esp
  801027:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80102b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80102f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801033:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801037:	85 d2                	test   %edx,%edx
  801039:	75 4d                	jne    801088 <__udivdi3+0x68>
  80103b:	39 f3                	cmp    %esi,%ebx
  80103d:	76 19                	jbe    801058 <__udivdi3+0x38>
  80103f:	31 ff                	xor    %edi,%edi
  801041:	89 e8                	mov    %ebp,%eax
  801043:	89 f2                	mov    %esi,%edx
  801045:	f7 f3                	div    %ebx
  801047:	89 fa                	mov    %edi,%edx
  801049:	83 c4 1c             	add    $0x1c,%esp
  80104c:	5b                   	pop    %ebx
  80104d:	5e                   	pop    %esi
  80104e:	5f                   	pop    %edi
  80104f:	5d                   	pop    %ebp
  801050:	c3                   	ret    
  801051:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801058:	89 d9                	mov    %ebx,%ecx
  80105a:	85 db                	test   %ebx,%ebx
  80105c:	75 0b                	jne    801069 <__udivdi3+0x49>
  80105e:	b8 01 00 00 00       	mov    $0x1,%eax
  801063:	31 d2                	xor    %edx,%edx
  801065:	f7 f3                	div    %ebx
  801067:	89 c1                	mov    %eax,%ecx
  801069:	31 d2                	xor    %edx,%edx
  80106b:	89 f0                	mov    %esi,%eax
  80106d:	f7 f1                	div    %ecx
  80106f:	89 c6                	mov    %eax,%esi
  801071:	89 e8                	mov    %ebp,%eax
  801073:	89 f7                	mov    %esi,%edi
  801075:	f7 f1                	div    %ecx
  801077:	89 fa                	mov    %edi,%edx
  801079:	83 c4 1c             	add    $0x1c,%esp
  80107c:	5b                   	pop    %ebx
  80107d:	5e                   	pop    %esi
  80107e:	5f                   	pop    %edi
  80107f:	5d                   	pop    %ebp
  801080:	c3                   	ret    
  801081:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801088:	39 f2                	cmp    %esi,%edx
  80108a:	77 1c                	ja     8010a8 <__udivdi3+0x88>
  80108c:	0f bd fa             	bsr    %edx,%edi
  80108f:	83 f7 1f             	xor    $0x1f,%edi
  801092:	75 2c                	jne    8010c0 <__udivdi3+0xa0>
  801094:	39 f2                	cmp    %esi,%edx
  801096:	72 06                	jb     80109e <__udivdi3+0x7e>
  801098:	31 c0                	xor    %eax,%eax
  80109a:	39 eb                	cmp    %ebp,%ebx
  80109c:	77 a9                	ja     801047 <__udivdi3+0x27>
  80109e:	b8 01 00 00 00       	mov    $0x1,%eax
  8010a3:	eb a2                	jmp    801047 <__udivdi3+0x27>
  8010a5:	8d 76 00             	lea    0x0(%esi),%esi
  8010a8:	31 ff                	xor    %edi,%edi
  8010aa:	31 c0                	xor    %eax,%eax
  8010ac:	89 fa                	mov    %edi,%edx
  8010ae:	83 c4 1c             	add    $0x1c,%esp
  8010b1:	5b                   	pop    %ebx
  8010b2:	5e                   	pop    %esi
  8010b3:	5f                   	pop    %edi
  8010b4:	5d                   	pop    %ebp
  8010b5:	c3                   	ret    
  8010b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8010bd:	8d 76 00             	lea    0x0(%esi),%esi
  8010c0:	89 f9                	mov    %edi,%ecx
  8010c2:	b8 20 00 00 00       	mov    $0x20,%eax
  8010c7:	29 f8                	sub    %edi,%eax
  8010c9:	d3 e2                	shl    %cl,%edx
  8010cb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8010cf:	89 c1                	mov    %eax,%ecx
  8010d1:	89 da                	mov    %ebx,%edx
  8010d3:	d3 ea                	shr    %cl,%edx
  8010d5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8010d9:	09 d1                	or     %edx,%ecx
  8010db:	89 f2                	mov    %esi,%edx
  8010dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8010e1:	89 f9                	mov    %edi,%ecx
  8010e3:	d3 e3                	shl    %cl,%ebx
  8010e5:	89 c1                	mov    %eax,%ecx
  8010e7:	d3 ea                	shr    %cl,%edx
  8010e9:	89 f9                	mov    %edi,%ecx
  8010eb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8010ef:	89 eb                	mov    %ebp,%ebx
  8010f1:	d3 e6                	shl    %cl,%esi
  8010f3:	89 c1                	mov    %eax,%ecx
  8010f5:	d3 eb                	shr    %cl,%ebx
  8010f7:	09 de                	or     %ebx,%esi
  8010f9:	89 f0                	mov    %esi,%eax
  8010fb:	f7 74 24 08          	divl   0x8(%esp)
  8010ff:	89 d6                	mov    %edx,%esi
  801101:	89 c3                	mov    %eax,%ebx
  801103:	f7 64 24 0c          	mull   0xc(%esp)
  801107:	39 d6                	cmp    %edx,%esi
  801109:	72 15                	jb     801120 <__udivdi3+0x100>
  80110b:	89 f9                	mov    %edi,%ecx
  80110d:	d3 e5                	shl    %cl,%ebp
  80110f:	39 c5                	cmp    %eax,%ebp
  801111:	73 04                	jae    801117 <__udivdi3+0xf7>
  801113:	39 d6                	cmp    %edx,%esi
  801115:	74 09                	je     801120 <__udivdi3+0x100>
  801117:	89 d8                	mov    %ebx,%eax
  801119:	31 ff                	xor    %edi,%edi
  80111b:	e9 27 ff ff ff       	jmp    801047 <__udivdi3+0x27>
  801120:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801123:	31 ff                	xor    %edi,%edi
  801125:	e9 1d ff ff ff       	jmp    801047 <__udivdi3+0x27>
  80112a:	66 90                	xchg   %ax,%ax
  80112c:	66 90                	xchg   %ax,%ax
  80112e:	66 90                	xchg   %ax,%ax

00801130 <__umoddi3>:
  801130:	55                   	push   %ebp
  801131:	57                   	push   %edi
  801132:	56                   	push   %esi
  801133:	53                   	push   %ebx
  801134:	83 ec 1c             	sub    $0x1c,%esp
  801137:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80113b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80113f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801143:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801147:	89 da                	mov    %ebx,%edx
  801149:	85 c0                	test   %eax,%eax
  80114b:	75 43                	jne    801190 <__umoddi3+0x60>
  80114d:	39 df                	cmp    %ebx,%edi
  80114f:	76 17                	jbe    801168 <__umoddi3+0x38>
  801151:	89 f0                	mov    %esi,%eax
  801153:	f7 f7                	div    %edi
  801155:	89 d0                	mov    %edx,%eax
  801157:	31 d2                	xor    %edx,%edx
  801159:	83 c4 1c             	add    $0x1c,%esp
  80115c:	5b                   	pop    %ebx
  80115d:	5e                   	pop    %esi
  80115e:	5f                   	pop    %edi
  80115f:	5d                   	pop    %ebp
  801160:	c3                   	ret    
  801161:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801168:	89 fd                	mov    %edi,%ebp
  80116a:	85 ff                	test   %edi,%edi
  80116c:	75 0b                	jne    801179 <__umoddi3+0x49>
  80116e:	b8 01 00 00 00       	mov    $0x1,%eax
  801173:	31 d2                	xor    %edx,%edx
  801175:	f7 f7                	div    %edi
  801177:	89 c5                	mov    %eax,%ebp
  801179:	89 d8                	mov    %ebx,%eax
  80117b:	31 d2                	xor    %edx,%edx
  80117d:	f7 f5                	div    %ebp
  80117f:	89 f0                	mov    %esi,%eax
  801181:	f7 f5                	div    %ebp
  801183:	89 d0                	mov    %edx,%eax
  801185:	eb d0                	jmp    801157 <__umoddi3+0x27>
  801187:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80118e:	66 90                	xchg   %ax,%ax
  801190:	89 f1                	mov    %esi,%ecx
  801192:	39 d8                	cmp    %ebx,%eax
  801194:	76 0a                	jbe    8011a0 <__umoddi3+0x70>
  801196:	89 f0                	mov    %esi,%eax
  801198:	83 c4 1c             	add    $0x1c,%esp
  80119b:	5b                   	pop    %ebx
  80119c:	5e                   	pop    %esi
  80119d:	5f                   	pop    %edi
  80119e:	5d                   	pop    %ebp
  80119f:	c3                   	ret    
  8011a0:	0f bd e8             	bsr    %eax,%ebp
  8011a3:	83 f5 1f             	xor    $0x1f,%ebp
  8011a6:	75 20                	jne    8011c8 <__umoddi3+0x98>
  8011a8:	39 d8                	cmp    %ebx,%eax
  8011aa:	0f 82 b0 00 00 00    	jb     801260 <__umoddi3+0x130>
  8011b0:	39 f7                	cmp    %esi,%edi
  8011b2:	0f 86 a8 00 00 00    	jbe    801260 <__umoddi3+0x130>
  8011b8:	89 c8                	mov    %ecx,%eax
  8011ba:	83 c4 1c             	add    $0x1c,%esp
  8011bd:	5b                   	pop    %ebx
  8011be:	5e                   	pop    %esi
  8011bf:	5f                   	pop    %edi
  8011c0:	5d                   	pop    %ebp
  8011c1:	c3                   	ret    
  8011c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8011c8:	89 e9                	mov    %ebp,%ecx
  8011ca:	ba 20 00 00 00       	mov    $0x20,%edx
  8011cf:	29 ea                	sub    %ebp,%edx
  8011d1:	d3 e0                	shl    %cl,%eax
  8011d3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8011d7:	89 d1                	mov    %edx,%ecx
  8011d9:	89 f8                	mov    %edi,%eax
  8011db:	d3 e8                	shr    %cl,%eax
  8011dd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8011e1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8011e5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8011e9:	09 c1                	or     %eax,%ecx
  8011eb:	89 d8                	mov    %ebx,%eax
  8011ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8011f1:	89 e9                	mov    %ebp,%ecx
  8011f3:	d3 e7                	shl    %cl,%edi
  8011f5:	89 d1                	mov    %edx,%ecx
  8011f7:	d3 e8                	shr    %cl,%eax
  8011f9:	89 e9                	mov    %ebp,%ecx
  8011fb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8011ff:	d3 e3                	shl    %cl,%ebx
  801201:	89 c7                	mov    %eax,%edi
  801203:	89 d1                	mov    %edx,%ecx
  801205:	89 f0                	mov    %esi,%eax
  801207:	d3 e8                	shr    %cl,%eax
  801209:	89 e9                	mov    %ebp,%ecx
  80120b:	89 fa                	mov    %edi,%edx
  80120d:	d3 e6                	shl    %cl,%esi
  80120f:	09 d8                	or     %ebx,%eax
  801211:	f7 74 24 08          	divl   0x8(%esp)
  801215:	89 d1                	mov    %edx,%ecx
  801217:	89 f3                	mov    %esi,%ebx
  801219:	f7 64 24 0c          	mull   0xc(%esp)
  80121d:	89 c6                	mov    %eax,%esi
  80121f:	89 d7                	mov    %edx,%edi
  801221:	39 d1                	cmp    %edx,%ecx
  801223:	72 06                	jb     80122b <__umoddi3+0xfb>
  801225:	75 10                	jne    801237 <__umoddi3+0x107>
  801227:	39 c3                	cmp    %eax,%ebx
  801229:	73 0c                	jae    801237 <__umoddi3+0x107>
  80122b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80122f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801233:	89 d7                	mov    %edx,%edi
  801235:	89 c6                	mov    %eax,%esi
  801237:	89 ca                	mov    %ecx,%edx
  801239:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80123e:	29 f3                	sub    %esi,%ebx
  801240:	19 fa                	sbb    %edi,%edx
  801242:	89 d0                	mov    %edx,%eax
  801244:	d3 e0                	shl    %cl,%eax
  801246:	89 e9                	mov    %ebp,%ecx
  801248:	d3 eb                	shr    %cl,%ebx
  80124a:	d3 ea                	shr    %cl,%edx
  80124c:	09 d8                	or     %ebx,%eax
  80124e:	83 c4 1c             	add    $0x1c,%esp
  801251:	5b                   	pop    %ebx
  801252:	5e                   	pop    %esi
  801253:	5f                   	pop    %edi
  801254:	5d                   	pop    %ebp
  801255:	c3                   	ret    
  801256:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80125d:	8d 76 00             	lea    0x0(%esi),%esi
  801260:	89 da                	mov    %ebx,%edx
  801262:	29 fe                	sub    %edi,%esi
  801264:	19 c2                	sbb    %eax,%edx
  801266:	89 f1                	mov    %esi,%ecx
  801268:	89 c8                	mov    %ecx,%eax
  80126a:	e9 4b ff ff ff       	jmp    8011ba <__umoddi3+0x8a>
