
obj/user/pingpongs.debug:     file format elf32-i386


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
  80002c:	e8 d2 00 00 00       	call   800103 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

uint32_t val;

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 2c             	sub    $0x2c,%esp
	envid_t who;
	uint32_t i;

	i = 0;
	if ((who = sfork()) != 0) {
  80003c:	e8 c8 11 00 00       	call   801209 <sfork>
  800041:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800044:	85 c0                	test   %eax,%eax
  800046:	75 74                	jne    8000bc <umain+0x89>
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
		ipc_send(who, 0, 0, 0);
	}

	while (1) {
		ipc_recv(&who, 0, 0);
  800048:	83 ec 04             	sub    $0x4,%esp
  80004b:	6a 00                	push   $0x0
  80004d:	6a 00                	push   $0x0
  80004f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800052:	50                   	push   %eax
  800053:	e8 01 13 00 00       	call   801359 <ipc_recv>
		cprintf("%x got %d from %x (thisenv is %p %x)\n", sys_getenvid(), val, who, thisenv, thisenv->env_id);
  800058:	8b 1d 08 20 80 00    	mov    0x802008,%ebx
  80005e:	8b 7b 48             	mov    0x48(%ebx),%edi
  800061:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  800064:	a1 04 20 80 00       	mov    0x802004,%eax
  800069:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80006c:	e8 5c 0c 00 00       	call   800ccd <sys_getenvid>
  800071:	83 c4 08             	add    $0x8,%esp
  800074:	57                   	push   %edi
  800075:	53                   	push   %ebx
  800076:	56                   	push   %esi
  800077:	ff 75 d4             	pushl  -0x2c(%ebp)
  80007a:	50                   	push   %eax
  80007b:	68 b0 17 80 00       	push   $0x8017b0
  800080:	e8 6e 01 00 00       	call   8001f3 <cprintf>
		if (val == 10)
  800085:	a1 04 20 80 00       	mov    0x802004,%eax
  80008a:	83 c4 20             	add    $0x20,%esp
  80008d:	83 f8 0a             	cmp    $0xa,%eax
  800090:	74 22                	je     8000b4 <umain+0x81>
			return;
		++val;
  800092:	83 c0 01             	add    $0x1,%eax
  800095:	a3 04 20 80 00       	mov    %eax,0x802004
		ipc_send(who, 0, 0, 0);
  80009a:	6a 00                	push   $0x0
  80009c:	6a 00                	push   $0x0
  80009e:	6a 00                	push   $0x0
  8000a0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000a3:	e8 1a 13 00 00       	call   8013c2 <ipc_send>
		if (val == 10)
  8000a8:	83 c4 10             	add    $0x10,%esp
  8000ab:	83 3d 04 20 80 00 0a 	cmpl   $0xa,0x802004
  8000b2:	75 94                	jne    800048 <umain+0x15>
			return;
	}

}
  8000b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000b7:	5b                   	pop    %ebx
  8000b8:	5e                   	pop    %esi
  8000b9:	5f                   	pop    %edi
  8000ba:	5d                   	pop    %ebp
  8000bb:	c3                   	ret    
		cprintf("i am %08x; thisenv is %p\n", sys_getenvid(), thisenv);
  8000bc:	8b 1d 08 20 80 00    	mov    0x802008,%ebx
  8000c2:	e8 06 0c 00 00       	call   800ccd <sys_getenvid>
  8000c7:	83 ec 04             	sub    $0x4,%esp
  8000ca:	53                   	push   %ebx
  8000cb:	50                   	push   %eax
  8000cc:	68 80 17 80 00       	push   $0x801780
  8000d1:	e8 1d 01 00 00       	call   8001f3 <cprintf>
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  8000d6:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8000d9:	e8 ef 0b 00 00       	call   800ccd <sys_getenvid>
  8000de:	83 c4 0c             	add    $0xc,%esp
  8000e1:	53                   	push   %ebx
  8000e2:	50                   	push   %eax
  8000e3:	68 9a 17 80 00       	push   $0x80179a
  8000e8:	e8 06 01 00 00       	call   8001f3 <cprintf>
		ipc_send(who, 0, 0, 0);
  8000ed:	6a 00                	push   $0x0
  8000ef:	6a 00                	push   $0x0
  8000f1:	6a 00                	push   $0x0
  8000f3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000f6:	e8 c7 12 00 00       	call   8013c2 <ipc_send>
  8000fb:	83 c4 20             	add    $0x20,%esp
  8000fe:	e9 45 ff ff ff       	jmp    800048 <umain+0x15>

00800103 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800103:	55                   	push   %ebp
  800104:	89 e5                	mov    %esp,%ebp
  800106:	56                   	push   %esi
  800107:	53                   	push   %ebx
  800108:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80010b:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	// thisenv = 0;
	thisenv = &(envs[ENVX(sys_getenvid())]);
  80010e:	e8 ba 0b 00 00       	call   800ccd <sys_getenvid>
  800113:	25 ff 03 00 00       	and    $0x3ff,%eax
  800118:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80011e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800123:	a3 08 20 80 00       	mov    %eax,0x802008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800128:	85 db                	test   %ebx,%ebx
  80012a:	7e 07                	jle    800133 <libmain+0x30>
		binaryname = argv[0];
  80012c:	8b 06                	mov    (%esi),%eax
  80012e:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800133:	83 ec 08             	sub    $0x8,%esp
  800136:	56                   	push   %esi
  800137:	53                   	push   %ebx
  800138:	e8 f6 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80013d:	e8 0a 00 00 00       	call   80014c <exit>
}
  800142:	83 c4 10             	add    $0x10,%esp
  800145:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800148:	5b                   	pop    %ebx
  800149:	5e                   	pop    %esi
  80014a:	5d                   	pop    %ebp
  80014b:	c3                   	ret    

0080014c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80014c:	55                   	push   %ebp
  80014d:	89 e5                	mov    %esp,%ebp
  80014f:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  800152:	6a 00                	push   $0x0
  800154:	e8 33 0b 00 00       	call   800c8c <sys_env_destroy>
}
  800159:	83 c4 10             	add    $0x10,%esp
  80015c:	c9                   	leave  
  80015d:	c3                   	ret    

0080015e <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80015e:	55                   	push   %ebp
  80015f:	89 e5                	mov    %esp,%ebp
  800161:	53                   	push   %ebx
  800162:	83 ec 04             	sub    $0x4,%esp
  800165:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800168:	8b 13                	mov    (%ebx),%edx
  80016a:	8d 42 01             	lea    0x1(%edx),%eax
  80016d:	89 03                	mov    %eax,(%ebx)
  80016f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800172:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800176:	3d ff 00 00 00       	cmp    $0xff,%eax
  80017b:	74 09                	je     800186 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80017d:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800181:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800184:	c9                   	leave  
  800185:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800186:	83 ec 08             	sub    $0x8,%esp
  800189:	68 ff 00 00 00       	push   $0xff
  80018e:	8d 43 08             	lea    0x8(%ebx),%eax
  800191:	50                   	push   %eax
  800192:	e8 b8 0a 00 00       	call   800c4f <sys_cputs>
		b->idx = 0;
  800197:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80019d:	83 c4 10             	add    $0x10,%esp
  8001a0:	eb db                	jmp    80017d <putch+0x1f>

008001a2 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001a2:	55                   	push   %ebp
  8001a3:	89 e5                	mov    %esp,%ebp
  8001a5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001ab:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001b2:	00 00 00 
	b.cnt = 0;
  8001b5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001bc:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001bf:	ff 75 0c             	pushl  0xc(%ebp)
  8001c2:	ff 75 08             	pushl  0x8(%ebp)
  8001c5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001cb:	50                   	push   %eax
  8001cc:	68 5e 01 80 00       	push   $0x80015e
  8001d1:	e8 4a 01 00 00       	call   800320 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001d6:	83 c4 08             	add    $0x8,%esp
  8001d9:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001df:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001e5:	50                   	push   %eax
  8001e6:	e8 64 0a 00 00       	call   800c4f <sys_cputs>

	return b.cnt;
}
  8001eb:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001f1:	c9                   	leave  
  8001f2:	c3                   	ret    

008001f3 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001f3:	55                   	push   %ebp
  8001f4:	89 e5                	mov    %esp,%ebp
  8001f6:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001f9:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001fc:	50                   	push   %eax
  8001fd:	ff 75 08             	pushl  0x8(%ebp)
  800200:	e8 9d ff ff ff       	call   8001a2 <vcprintf>
	va_end(ap);

	return cnt;
}
  800205:	c9                   	leave  
  800206:	c3                   	ret    

00800207 <printnum>:


static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800207:	55                   	push   %ebp
  800208:	89 e5                	mov    %esp,%ebp
  80020a:	57                   	push   %edi
  80020b:	56                   	push   %esi
  80020c:	53                   	push   %ebx
  80020d:	83 ec 1c             	sub    $0x1c,%esp
  800210:	89 c6                	mov    %eax,%esi
  800212:	89 d7                	mov    %edx,%edi
  800214:	8b 45 08             	mov    0x8(%ebp),%eax
  800217:	8b 55 0c             	mov    0xc(%ebp),%edx
  80021a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80021d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800220:	8b 45 10             	mov    0x10(%ebp),%eax
  800223:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	// to support '-'
	if(padc == '-'){
  800226:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80022a:	74 2c                	je     800258 <printnum+0x51>
		while (--width > 0)
			putch(' ', putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80022c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80022f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800236:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800239:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80023c:	39 c2                	cmp    %eax,%edx
  80023e:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800241:	73 43                	jae    800286 <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800243:	83 eb 01             	sub    $0x1,%ebx
  800246:	85 db                	test   %ebx,%ebx
  800248:	7e 6c                	jle    8002b6 <printnum+0xaf>
			putch(padc, putdat);
  80024a:	83 ec 08             	sub    $0x8,%esp
  80024d:	57                   	push   %edi
  80024e:	ff 75 18             	pushl  0x18(%ebp)
  800251:	ff d6                	call   *%esi
  800253:	83 c4 10             	add    $0x10,%esp
  800256:	eb eb                	jmp    800243 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800258:	83 ec 0c             	sub    $0xc,%esp
  80025b:	6a 20                	push   $0x20
  80025d:	6a 00                	push   $0x0
  80025f:	50                   	push   %eax
  800260:	ff 75 e4             	pushl  -0x1c(%ebp)
  800263:	ff 75 e0             	pushl  -0x20(%ebp)
  800266:	89 fa                	mov    %edi,%edx
  800268:	89 f0                	mov    %esi,%eax
  80026a:	e8 98 ff ff ff       	call   800207 <printnum>
		while (--width > 0)
  80026f:	83 c4 20             	add    $0x20,%esp
  800272:	83 eb 01             	sub    $0x1,%ebx
  800275:	85 db                	test   %ebx,%ebx
  800277:	7e 65                	jle    8002de <printnum+0xd7>
			putch(' ', putdat);
  800279:	83 ec 08             	sub    $0x8,%esp
  80027c:	57                   	push   %edi
  80027d:	6a 20                	push   $0x20
  80027f:	ff d6                	call   *%esi
  800281:	83 c4 10             	add    $0x10,%esp
  800284:	eb ec                	jmp    800272 <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800286:	83 ec 0c             	sub    $0xc,%esp
  800289:	ff 75 18             	pushl  0x18(%ebp)
  80028c:	83 eb 01             	sub    $0x1,%ebx
  80028f:	53                   	push   %ebx
  800290:	50                   	push   %eax
  800291:	83 ec 08             	sub    $0x8,%esp
  800294:	ff 75 dc             	pushl  -0x24(%ebp)
  800297:	ff 75 d8             	pushl  -0x28(%ebp)
  80029a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80029d:	ff 75 e0             	pushl  -0x20(%ebp)
  8002a0:	e8 8b 12 00 00       	call   801530 <__udivdi3>
  8002a5:	83 c4 18             	add    $0x18,%esp
  8002a8:	52                   	push   %edx
  8002a9:	50                   	push   %eax
  8002aa:	89 fa                	mov    %edi,%edx
  8002ac:	89 f0                	mov    %esi,%eax
  8002ae:	e8 54 ff ff ff       	call   800207 <printnum>
  8002b3:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002b6:	83 ec 08             	sub    $0x8,%esp
  8002b9:	57                   	push   %edi
  8002ba:	83 ec 04             	sub    $0x4,%esp
  8002bd:	ff 75 dc             	pushl  -0x24(%ebp)
  8002c0:	ff 75 d8             	pushl  -0x28(%ebp)
  8002c3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002c6:	ff 75 e0             	pushl  -0x20(%ebp)
  8002c9:	e8 72 13 00 00       	call   801640 <__umoddi3>
  8002ce:	83 c4 14             	add    $0x14,%esp
  8002d1:	0f be 80 e0 17 80 00 	movsbl 0x8017e0(%eax),%eax
  8002d8:	50                   	push   %eax
  8002d9:	ff d6                	call   *%esi
  8002db:	83 c4 10             	add    $0x10,%esp
}
  8002de:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002e1:	5b                   	pop    %ebx
  8002e2:	5e                   	pop    %esi
  8002e3:	5f                   	pop    %edi
  8002e4:	5d                   	pop    %ebp
  8002e5:	c3                   	ret    

008002e6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002e6:	55                   	push   %ebp
  8002e7:	89 e5                	mov    %esp,%ebp
  8002e9:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002ec:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002f0:	8b 10                	mov    (%eax),%edx
  8002f2:	3b 50 04             	cmp    0x4(%eax),%edx
  8002f5:	73 0a                	jae    800301 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002f7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002fa:	89 08                	mov    %ecx,(%eax)
  8002fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ff:	88 02                	mov    %al,(%edx)
}
  800301:	5d                   	pop    %ebp
  800302:	c3                   	ret    

00800303 <printfmt>:
{
  800303:	55                   	push   %ebp
  800304:	89 e5                	mov    %esp,%ebp
  800306:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800309:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80030c:	50                   	push   %eax
  80030d:	ff 75 10             	pushl  0x10(%ebp)
  800310:	ff 75 0c             	pushl  0xc(%ebp)
  800313:	ff 75 08             	pushl  0x8(%ebp)
  800316:	e8 05 00 00 00       	call   800320 <vprintfmt>
}
  80031b:	83 c4 10             	add    $0x10,%esp
  80031e:	c9                   	leave  
  80031f:	c3                   	ret    

00800320 <vprintfmt>:
{
  800320:	55                   	push   %ebp
  800321:	89 e5                	mov    %esp,%ebp
  800323:	57                   	push   %edi
  800324:	56                   	push   %esi
  800325:	53                   	push   %ebx
  800326:	83 ec 3c             	sub    $0x3c,%esp
  800329:	8b 75 08             	mov    0x8(%ebp),%esi
  80032c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80032f:	8b 7d 10             	mov    0x10(%ebp),%edi
  800332:	e9 1e 04 00 00       	jmp    800755 <vprintfmt+0x435>
		posflag = 0;
  800337:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
		padc = ' ';
  80033e:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800342:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800349:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800350:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800357:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  80035e:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800363:	8d 47 01             	lea    0x1(%edi),%eax
  800366:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800369:	0f b6 17             	movzbl (%edi),%edx
  80036c:	8d 42 dd             	lea    -0x23(%edx),%eax
  80036f:	3c 55                	cmp    $0x55,%al
  800371:	0f 87 d9 04 00 00    	ja     800850 <vprintfmt+0x530>
  800377:	0f b6 c0             	movzbl %al,%eax
  80037a:	ff 24 85 c0 19 80 00 	jmp    *0x8019c0(,%eax,4)
  800381:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800384:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800388:	eb d9                	jmp    800363 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80038a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posflag = 1;
  80038d:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  800394:	eb cd                	jmp    800363 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800396:	0f b6 d2             	movzbl %dl,%edx
  800399:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80039c:	b8 00 00 00 00       	mov    $0x0,%eax
  8003a1:	89 75 08             	mov    %esi,0x8(%ebp)
  8003a4:	eb 0c                	jmp    8003b2 <vprintfmt+0x92>
		switch (ch = *(unsigned char *) fmt++) {
  8003a6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003a9:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  8003ad:	eb b4                	jmp    800363 <vprintfmt+0x43>
			for (precision = 0; ; ++fmt) {
  8003af:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003b2:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003b5:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003b9:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003bc:	8d 72 d0             	lea    -0x30(%edx),%esi
  8003bf:	83 fe 09             	cmp    $0x9,%esi
  8003c2:	76 eb                	jbe    8003af <vprintfmt+0x8f>
  8003c4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003c7:	8b 75 08             	mov    0x8(%ebp),%esi
  8003ca:	eb 14                	jmp    8003e0 <vprintfmt+0xc0>
			precision = va_arg(ap, int);
  8003cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8003cf:	8b 00                	mov    (%eax),%eax
  8003d1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8003d7:	8d 40 04             	lea    0x4(%eax),%eax
  8003da:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003dd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003e0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003e4:	0f 89 79 ff ff ff    	jns    800363 <vprintfmt+0x43>
				width = precision, precision = -1;
  8003ea:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003ed:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003f0:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003f7:	e9 67 ff ff ff       	jmp    800363 <vprintfmt+0x43>
  8003fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003ff:	85 c0                	test   %eax,%eax
  800401:	0f 48 c1             	cmovs  %ecx,%eax
  800404:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800407:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80040a:	e9 54 ff ff ff       	jmp    800363 <vprintfmt+0x43>
  80040f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800412:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800419:	e9 45 ff ff ff       	jmp    800363 <vprintfmt+0x43>
			lflag++;
  80041e:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800422:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800425:	e9 39 ff ff ff       	jmp    800363 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  80042a:	8b 45 14             	mov    0x14(%ebp),%eax
  80042d:	8d 78 04             	lea    0x4(%eax),%edi
  800430:	83 ec 08             	sub    $0x8,%esp
  800433:	53                   	push   %ebx
  800434:	ff 30                	pushl  (%eax)
  800436:	ff d6                	call   *%esi
			break;
  800438:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80043b:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80043e:	e9 0f 03 00 00       	jmp    800752 <vprintfmt+0x432>
			err = va_arg(ap, int);
  800443:	8b 45 14             	mov    0x14(%ebp),%eax
  800446:	8d 78 04             	lea    0x4(%eax),%edi
  800449:	8b 00                	mov    (%eax),%eax
  80044b:	99                   	cltd   
  80044c:	31 d0                	xor    %edx,%eax
  80044e:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800450:	83 f8 0f             	cmp    $0xf,%eax
  800453:	7f 23                	jg     800478 <vprintfmt+0x158>
  800455:	8b 14 85 20 1b 80 00 	mov    0x801b20(,%eax,4),%edx
  80045c:	85 d2                	test   %edx,%edx
  80045e:	74 18                	je     800478 <vprintfmt+0x158>
				printfmt(putch, putdat, "%s", p);
  800460:	52                   	push   %edx
  800461:	68 01 18 80 00       	push   $0x801801
  800466:	53                   	push   %ebx
  800467:	56                   	push   %esi
  800468:	e8 96 fe ff ff       	call   800303 <printfmt>
  80046d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800470:	89 7d 14             	mov    %edi,0x14(%ebp)
  800473:	e9 da 02 00 00       	jmp    800752 <vprintfmt+0x432>
				printfmt(putch, putdat, "error %d", err);
  800478:	50                   	push   %eax
  800479:	68 f8 17 80 00       	push   $0x8017f8
  80047e:	53                   	push   %ebx
  80047f:	56                   	push   %esi
  800480:	e8 7e fe ff ff       	call   800303 <printfmt>
  800485:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800488:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80048b:	e9 c2 02 00 00       	jmp    800752 <vprintfmt+0x432>
			if ((p = va_arg(ap, char *)) == NULL)
  800490:	8b 45 14             	mov    0x14(%ebp),%eax
  800493:	83 c0 04             	add    $0x4,%eax
  800496:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800499:	8b 45 14             	mov    0x14(%ebp),%eax
  80049c:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80049e:	85 c9                	test   %ecx,%ecx
  8004a0:	b8 f1 17 80 00       	mov    $0x8017f1,%eax
  8004a5:	0f 45 c1             	cmovne %ecx,%eax
  8004a8:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8004ab:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004af:	7e 06                	jle    8004b7 <vprintfmt+0x197>
  8004b1:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8004b5:	75 0d                	jne    8004c4 <vprintfmt+0x1a4>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004b7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004ba:	89 c7                	mov    %eax,%edi
  8004bc:	03 45 e0             	add    -0x20(%ebp),%eax
  8004bf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004c2:	eb 53                	jmp    800517 <vprintfmt+0x1f7>
  8004c4:	83 ec 08             	sub    $0x8,%esp
  8004c7:	ff 75 d8             	pushl  -0x28(%ebp)
  8004ca:	50                   	push   %eax
  8004cb:	e8 28 04 00 00       	call   8008f8 <strnlen>
  8004d0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004d3:	29 c1                	sub    %eax,%ecx
  8004d5:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  8004d8:	83 c4 10             	add    $0x10,%esp
  8004db:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8004dd:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8004e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004e4:	eb 0f                	jmp    8004f5 <vprintfmt+0x1d5>
					putch(padc, putdat);
  8004e6:	83 ec 08             	sub    $0x8,%esp
  8004e9:	53                   	push   %ebx
  8004ea:	ff 75 e0             	pushl  -0x20(%ebp)
  8004ed:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004ef:	83 ef 01             	sub    $0x1,%edi
  8004f2:	83 c4 10             	add    $0x10,%esp
  8004f5:	85 ff                	test   %edi,%edi
  8004f7:	7f ed                	jg     8004e6 <vprintfmt+0x1c6>
  8004f9:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  8004fc:	85 c9                	test   %ecx,%ecx
  8004fe:	b8 00 00 00 00       	mov    $0x0,%eax
  800503:	0f 49 c1             	cmovns %ecx,%eax
  800506:	29 c1                	sub    %eax,%ecx
  800508:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80050b:	eb aa                	jmp    8004b7 <vprintfmt+0x197>
					putch(ch, putdat);
  80050d:	83 ec 08             	sub    $0x8,%esp
  800510:	53                   	push   %ebx
  800511:	52                   	push   %edx
  800512:	ff d6                	call   *%esi
  800514:	83 c4 10             	add    $0x10,%esp
  800517:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80051a:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80051c:	83 c7 01             	add    $0x1,%edi
  80051f:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800523:	0f be d0             	movsbl %al,%edx
  800526:	85 d2                	test   %edx,%edx
  800528:	74 4b                	je     800575 <vprintfmt+0x255>
  80052a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80052e:	78 06                	js     800536 <vprintfmt+0x216>
  800530:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800534:	78 1e                	js     800554 <vprintfmt+0x234>
				if (altflag && (ch < ' ' || ch > '~'))
  800536:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80053a:	74 d1                	je     80050d <vprintfmt+0x1ed>
  80053c:	0f be c0             	movsbl %al,%eax
  80053f:	83 e8 20             	sub    $0x20,%eax
  800542:	83 f8 5e             	cmp    $0x5e,%eax
  800545:	76 c6                	jbe    80050d <vprintfmt+0x1ed>
					putch('?', putdat);
  800547:	83 ec 08             	sub    $0x8,%esp
  80054a:	53                   	push   %ebx
  80054b:	6a 3f                	push   $0x3f
  80054d:	ff d6                	call   *%esi
  80054f:	83 c4 10             	add    $0x10,%esp
  800552:	eb c3                	jmp    800517 <vprintfmt+0x1f7>
  800554:	89 cf                	mov    %ecx,%edi
  800556:	eb 0e                	jmp    800566 <vprintfmt+0x246>
				putch(' ', putdat);
  800558:	83 ec 08             	sub    $0x8,%esp
  80055b:	53                   	push   %ebx
  80055c:	6a 20                	push   $0x20
  80055e:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800560:	83 ef 01             	sub    $0x1,%edi
  800563:	83 c4 10             	add    $0x10,%esp
  800566:	85 ff                	test   %edi,%edi
  800568:	7f ee                	jg     800558 <vprintfmt+0x238>
			if ((p = va_arg(ap, char *)) == NULL)
  80056a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80056d:	89 45 14             	mov    %eax,0x14(%ebp)
  800570:	e9 dd 01 00 00       	jmp    800752 <vprintfmt+0x432>
  800575:	89 cf                	mov    %ecx,%edi
  800577:	eb ed                	jmp    800566 <vprintfmt+0x246>
	if (lflag >= 2)
  800579:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  80057d:	7f 21                	jg     8005a0 <vprintfmt+0x280>
	else if (lflag)
  80057f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800583:	74 6a                	je     8005ef <vprintfmt+0x2cf>
		return va_arg(*ap, long);
  800585:	8b 45 14             	mov    0x14(%ebp),%eax
  800588:	8b 00                	mov    (%eax),%eax
  80058a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80058d:	89 c1                	mov    %eax,%ecx
  80058f:	c1 f9 1f             	sar    $0x1f,%ecx
  800592:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800595:	8b 45 14             	mov    0x14(%ebp),%eax
  800598:	8d 40 04             	lea    0x4(%eax),%eax
  80059b:	89 45 14             	mov    %eax,0x14(%ebp)
  80059e:	eb 17                	jmp    8005b7 <vprintfmt+0x297>
		return va_arg(*ap, long long);
  8005a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a3:	8b 50 04             	mov    0x4(%eax),%edx
  8005a6:	8b 00                	mov    (%eax),%eax
  8005a8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ab:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b1:	8d 40 08             	lea    0x8(%eax),%eax
  8005b4:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8005b7:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  8005ba:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  8005bf:	85 d2                	test   %edx,%edx
  8005c1:	0f 89 5c 01 00 00    	jns    800723 <vprintfmt+0x403>
				putch('-', putdat);
  8005c7:	83 ec 08             	sub    $0x8,%esp
  8005ca:	53                   	push   %ebx
  8005cb:	6a 2d                	push   $0x2d
  8005cd:	ff d6                	call   *%esi
				num = -(long long) num;
  8005cf:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005d2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8005d5:	f7 d8                	neg    %eax
  8005d7:	83 d2 00             	adc    $0x0,%edx
  8005da:	f7 da                	neg    %edx
  8005dc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005df:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005e2:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005e5:	bf 0a 00 00 00       	mov    $0xa,%edi
  8005ea:	e9 45 01 00 00       	jmp    800734 <vprintfmt+0x414>
		return va_arg(*ap, int);
  8005ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f2:	8b 00                	mov    (%eax),%eax
  8005f4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005f7:	89 c1                	mov    %eax,%ecx
  8005f9:	c1 f9 1f             	sar    $0x1f,%ecx
  8005fc:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800602:	8d 40 04             	lea    0x4(%eax),%eax
  800605:	89 45 14             	mov    %eax,0x14(%ebp)
  800608:	eb ad                	jmp    8005b7 <vprintfmt+0x297>
	if (lflag >= 2)
  80060a:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  80060e:	7f 29                	jg     800639 <vprintfmt+0x319>
	else if (lflag)
  800610:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800614:	74 44                	je     80065a <vprintfmt+0x33a>
		return va_arg(*ap, unsigned long);
  800616:	8b 45 14             	mov    0x14(%ebp),%eax
  800619:	8b 00                	mov    (%eax),%eax
  80061b:	ba 00 00 00 00       	mov    $0x0,%edx
  800620:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800623:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800626:	8b 45 14             	mov    0x14(%ebp),%eax
  800629:	8d 40 04             	lea    0x4(%eax),%eax
  80062c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80062f:	bf 0a 00 00 00       	mov    $0xa,%edi
  800634:	e9 ea 00 00 00       	jmp    800723 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  800639:	8b 45 14             	mov    0x14(%ebp),%eax
  80063c:	8b 50 04             	mov    0x4(%eax),%edx
  80063f:	8b 00                	mov    (%eax),%eax
  800641:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800644:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800647:	8b 45 14             	mov    0x14(%ebp),%eax
  80064a:	8d 40 08             	lea    0x8(%eax),%eax
  80064d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800650:	bf 0a 00 00 00       	mov    $0xa,%edi
  800655:	e9 c9 00 00 00       	jmp    800723 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  80065a:	8b 45 14             	mov    0x14(%ebp),%eax
  80065d:	8b 00                	mov    (%eax),%eax
  80065f:	ba 00 00 00 00       	mov    $0x0,%edx
  800664:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800667:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80066a:	8b 45 14             	mov    0x14(%ebp),%eax
  80066d:	8d 40 04             	lea    0x4(%eax),%eax
  800670:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800673:	bf 0a 00 00 00       	mov    $0xa,%edi
  800678:	e9 a6 00 00 00       	jmp    800723 <vprintfmt+0x403>
			putch('0', putdat);
  80067d:	83 ec 08             	sub    $0x8,%esp
  800680:	53                   	push   %ebx
  800681:	6a 30                	push   $0x30
  800683:	ff d6                	call   *%esi
	if (lflag >= 2)
  800685:	83 c4 10             	add    $0x10,%esp
  800688:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  80068c:	7f 26                	jg     8006b4 <vprintfmt+0x394>
	else if (lflag)
  80068e:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800692:	74 3e                	je     8006d2 <vprintfmt+0x3b2>
		return va_arg(*ap, unsigned long);
  800694:	8b 45 14             	mov    0x14(%ebp),%eax
  800697:	8b 00                	mov    (%eax),%eax
  800699:	ba 00 00 00 00       	mov    $0x0,%edx
  80069e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006a1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a7:	8d 40 04             	lea    0x4(%eax),%eax
  8006aa:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006ad:	bf 08 00 00 00       	mov    $0x8,%edi
  8006b2:	eb 6f                	jmp    800723 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  8006b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b7:	8b 50 04             	mov    0x4(%eax),%edx
  8006ba:	8b 00                	mov    (%eax),%eax
  8006bc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006bf:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c5:	8d 40 08             	lea    0x8(%eax),%eax
  8006c8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006cb:	bf 08 00 00 00       	mov    $0x8,%edi
  8006d0:	eb 51                	jmp    800723 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  8006d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d5:	8b 00                	mov    (%eax),%eax
  8006d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8006dc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006df:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e5:	8d 40 04             	lea    0x4(%eax),%eax
  8006e8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006eb:	bf 08 00 00 00       	mov    $0x8,%edi
  8006f0:	eb 31                	jmp    800723 <vprintfmt+0x403>
			putch('0', putdat);
  8006f2:	83 ec 08             	sub    $0x8,%esp
  8006f5:	53                   	push   %ebx
  8006f6:	6a 30                	push   $0x30
  8006f8:	ff d6                	call   *%esi
			putch('x', putdat);
  8006fa:	83 c4 08             	add    $0x8,%esp
  8006fd:	53                   	push   %ebx
  8006fe:	6a 78                	push   $0x78
  800700:	ff d6                	call   *%esi
			num = (unsigned long long)
  800702:	8b 45 14             	mov    0x14(%ebp),%eax
  800705:	8b 00                	mov    (%eax),%eax
  800707:	ba 00 00 00 00       	mov    $0x0,%edx
  80070c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80070f:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800712:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800715:	8b 45 14             	mov    0x14(%ebp),%eax
  800718:	8d 40 04             	lea    0x4(%eax),%eax
  80071b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80071e:	bf 10 00 00 00       	mov    $0x10,%edi
			if(posflag)
  800723:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800727:	74 0b                	je     800734 <vprintfmt+0x414>
				putch('+', putdat);
  800729:	83 ec 08             	sub    $0x8,%esp
  80072c:	53                   	push   %ebx
  80072d:	6a 2b                	push   $0x2b
  80072f:	ff d6                	call   *%esi
  800731:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  800734:	83 ec 0c             	sub    $0xc,%esp
  800737:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80073b:	50                   	push   %eax
  80073c:	ff 75 e0             	pushl  -0x20(%ebp)
  80073f:	57                   	push   %edi
  800740:	ff 75 dc             	pushl  -0x24(%ebp)
  800743:	ff 75 d8             	pushl  -0x28(%ebp)
  800746:	89 da                	mov    %ebx,%edx
  800748:	89 f0                	mov    %esi,%eax
  80074a:	e8 b8 fa ff ff       	call   800207 <printnum>
			break;
  80074f:	83 c4 20             	add    $0x20,%esp
			char* cp = va_arg(ap, char *);
  800752:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800755:	83 c7 01             	add    $0x1,%edi
  800758:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80075c:	83 f8 25             	cmp    $0x25,%eax
  80075f:	0f 84 d2 fb ff ff    	je     800337 <vprintfmt+0x17>
			if (ch == '\0')
  800765:	85 c0                	test   %eax,%eax
  800767:	0f 84 03 01 00 00    	je     800870 <vprintfmt+0x550>
			putch(ch, putdat);
  80076d:	83 ec 08             	sub    $0x8,%esp
  800770:	53                   	push   %ebx
  800771:	50                   	push   %eax
  800772:	ff d6                	call   *%esi
  800774:	83 c4 10             	add    $0x10,%esp
  800777:	eb dc                	jmp    800755 <vprintfmt+0x435>
	if (lflag >= 2)
  800779:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  80077d:	7f 29                	jg     8007a8 <vprintfmt+0x488>
	else if (lflag)
  80077f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800783:	74 44                	je     8007c9 <vprintfmt+0x4a9>
		return va_arg(*ap, unsigned long);
  800785:	8b 45 14             	mov    0x14(%ebp),%eax
  800788:	8b 00                	mov    (%eax),%eax
  80078a:	ba 00 00 00 00       	mov    $0x0,%edx
  80078f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800792:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800795:	8b 45 14             	mov    0x14(%ebp),%eax
  800798:	8d 40 04             	lea    0x4(%eax),%eax
  80079b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80079e:	bf 10 00 00 00       	mov    $0x10,%edi
  8007a3:	e9 7b ff ff ff       	jmp    800723 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  8007a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ab:	8b 50 04             	mov    0x4(%eax),%edx
  8007ae:	8b 00                	mov    (%eax),%eax
  8007b0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007b3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b9:	8d 40 08             	lea    0x8(%eax),%eax
  8007bc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007bf:	bf 10 00 00 00       	mov    $0x10,%edi
  8007c4:	e9 5a ff ff ff       	jmp    800723 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  8007c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cc:	8b 00                	mov    (%eax),%eax
  8007ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8007d3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007d6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007dc:	8d 40 04             	lea    0x4(%eax),%eax
  8007df:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007e2:	bf 10 00 00 00       	mov    $0x10,%edi
  8007e7:	e9 37 ff ff ff       	jmp    800723 <vprintfmt+0x403>
			char* cp = va_arg(ap, char *);
  8007ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ef:	8d 78 04             	lea    0x4(%eax),%edi
  8007f2:	8b 00                	mov    (%eax),%eax
    			if (cp == NULL) {
  8007f4:	85 c0                	test   %eax,%eax
  8007f6:	74 2c                	je     800824 <vprintfmt+0x504>
    			*cp = *(int *)putdat;
  8007f8:	8b 13                	mov    (%ebx),%edx
  8007fa:	88 10                	mov    %dl,(%eax)
			char* cp = va_arg(ap, char *);
  8007fc:	89 7d 14             	mov    %edi,0x14(%ebp)
    			if ((*(int *) putdat) > 127)
  8007ff:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  800802:	0f 8e 4a ff ff ff    	jle    800752 <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", overflow_error);
  800808:	68 50 19 80 00       	push   $0x801950
  80080d:	68 01 18 80 00       	push   $0x801801
  800812:	53                   	push   %ebx
  800813:	56                   	push   %esi
  800814:	e8 ea fa ff ff       	call   800303 <printfmt>
  800819:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  80081c:	89 7d 14             	mov    %edi,0x14(%ebp)
  80081f:	e9 2e ff ff ff       	jmp    800752 <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", null_error);
  800824:	68 18 19 80 00       	push   $0x801918
  800829:	68 01 18 80 00       	push   $0x801801
  80082e:	53                   	push   %ebx
  80082f:	56                   	push   %esi
  800830:	e8 ce fa ff ff       	call   800303 <printfmt>
        		break;
  800835:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  800838:	89 7d 14             	mov    %edi,0x14(%ebp)
        		break;
  80083b:	e9 12 ff ff ff       	jmp    800752 <vprintfmt+0x432>
			putch(ch, putdat);
  800840:	83 ec 08             	sub    $0x8,%esp
  800843:	53                   	push   %ebx
  800844:	6a 25                	push   $0x25
  800846:	ff d6                	call   *%esi
			break;
  800848:	83 c4 10             	add    $0x10,%esp
  80084b:	e9 02 ff ff ff       	jmp    800752 <vprintfmt+0x432>
			putch('%', putdat);
  800850:	83 ec 08             	sub    $0x8,%esp
  800853:	53                   	push   %ebx
  800854:	6a 25                	push   $0x25
  800856:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800858:	83 c4 10             	add    $0x10,%esp
  80085b:	89 f8                	mov    %edi,%eax
  80085d:	eb 03                	jmp    800862 <vprintfmt+0x542>
  80085f:	83 e8 01             	sub    $0x1,%eax
  800862:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800866:	75 f7                	jne    80085f <vprintfmt+0x53f>
  800868:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80086b:	e9 e2 fe ff ff       	jmp    800752 <vprintfmt+0x432>
}
  800870:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800873:	5b                   	pop    %ebx
  800874:	5e                   	pop    %esi
  800875:	5f                   	pop    %edi
  800876:	5d                   	pop    %ebp
  800877:	c3                   	ret    

00800878 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800878:	55                   	push   %ebp
  800879:	89 e5                	mov    %esp,%ebp
  80087b:	83 ec 18             	sub    $0x18,%esp
  80087e:	8b 45 08             	mov    0x8(%ebp),%eax
  800881:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800884:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800887:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80088b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80088e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800895:	85 c0                	test   %eax,%eax
  800897:	74 26                	je     8008bf <vsnprintf+0x47>
  800899:	85 d2                	test   %edx,%edx
  80089b:	7e 22                	jle    8008bf <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80089d:	ff 75 14             	pushl  0x14(%ebp)
  8008a0:	ff 75 10             	pushl  0x10(%ebp)
  8008a3:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008a6:	50                   	push   %eax
  8008a7:	68 e6 02 80 00       	push   $0x8002e6
  8008ac:	e8 6f fa ff ff       	call   800320 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008b4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008ba:	83 c4 10             	add    $0x10,%esp
}
  8008bd:	c9                   	leave  
  8008be:	c3                   	ret    
		return -E_INVAL;
  8008bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008c4:	eb f7                	jmp    8008bd <vsnprintf+0x45>

008008c6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008c6:	55                   	push   %ebp
  8008c7:	89 e5                	mov    %esp,%ebp
  8008c9:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008cc:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008cf:	50                   	push   %eax
  8008d0:	ff 75 10             	pushl  0x10(%ebp)
  8008d3:	ff 75 0c             	pushl  0xc(%ebp)
  8008d6:	ff 75 08             	pushl  0x8(%ebp)
  8008d9:	e8 9a ff ff ff       	call   800878 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008de:	c9                   	leave  
  8008df:	c3                   	ret    

008008e0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008e0:	55                   	push   %ebp
  8008e1:	89 e5                	mov    %esp,%ebp
  8008e3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8008eb:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008ef:	74 05                	je     8008f6 <strlen+0x16>
		n++;
  8008f1:	83 c0 01             	add    $0x1,%eax
  8008f4:	eb f5                	jmp    8008eb <strlen+0xb>
	return n;
}
  8008f6:	5d                   	pop    %ebp
  8008f7:	c3                   	ret    

008008f8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008f8:	55                   	push   %ebp
  8008f9:	89 e5                	mov    %esp,%ebp
  8008fb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008fe:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800901:	ba 00 00 00 00       	mov    $0x0,%edx
  800906:	39 c2                	cmp    %eax,%edx
  800908:	74 0d                	je     800917 <strnlen+0x1f>
  80090a:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  80090e:	74 05                	je     800915 <strnlen+0x1d>
		n++;
  800910:	83 c2 01             	add    $0x1,%edx
  800913:	eb f1                	jmp    800906 <strnlen+0xe>
  800915:	89 d0                	mov    %edx,%eax
	return n;
}
  800917:	5d                   	pop    %ebp
  800918:	c3                   	ret    

00800919 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800919:	55                   	push   %ebp
  80091a:	89 e5                	mov    %esp,%ebp
  80091c:	53                   	push   %ebx
  80091d:	8b 45 08             	mov    0x8(%ebp),%eax
  800920:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800923:	ba 00 00 00 00       	mov    $0x0,%edx
  800928:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80092c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  80092f:	83 c2 01             	add    $0x1,%edx
  800932:	84 c9                	test   %cl,%cl
  800934:	75 f2                	jne    800928 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800936:	5b                   	pop    %ebx
  800937:	5d                   	pop    %ebp
  800938:	c3                   	ret    

00800939 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800939:	55                   	push   %ebp
  80093a:	89 e5                	mov    %esp,%ebp
  80093c:	53                   	push   %ebx
  80093d:	83 ec 10             	sub    $0x10,%esp
  800940:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800943:	53                   	push   %ebx
  800944:	e8 97 ff ff ff       	call   8008e0 <strlen>
  800949:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80094c:	ff 75 0c             	pushl  0xc(%ebp)
  80094f:	01 d8                	add    %ebx,%eax
  800951:	50                   	push   %eax
  800952:	e8 c2 ff ff ff       	call   800919 <strcpy>
	return dst;
}
  800957:	89 d8                	mov    %ebx,%eax
  800959:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80095c:	c9                   	leave  
  80095d:	c3                   	ret    

0080095e <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80095e:	55                   	push   %ebp
  80095f:	89 e5                	mov    %esp,%ebp
  800961:	56                   	push   %esi
  800962:	53                   	push   %ebx
  800963:	8b 45 08             	mov    0x8(%ebp),%eax
  800966:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800969:	89 c6                	mov    %eax,%esi
  80096b:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80096e:	89 c2                	mov    %eax,%edx
  800970:	39 f2                	cmp    %esi,%edx
  800972:	74 11                	je     800985 <strncpy+0x27>
		*dst++ = *src;
  800974:	83 c2 01             	add    $0x1,%edx
  800977:	0f b6 19             	movzbl (%ecx),%ebx
  80097a:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80097d:	80 fb 01             	cmp    $0x1,%bl
  800980:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800983:	eb eb                	jmp    800970 <strncpy+0x12>
	}
	return ret;
}
  800985:	5b                   	pop    %ebx
  800986:	5e                   	pop    %esi
  800987:	5d                   	pop    %ebp
  800988:	c3                   	ret    

00800989 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800989:	55                   	push   %ebp
  80098a:	89 e5                	mov    %esp,%ebp
  80098c:	56                   	push   %esi
  80098d:	53                   	push   %ebx
  80098e:	8b 75 08             	mov    0x8(%ebp),%esi
  800991:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800994:	8b 55 10             	mov    0x10(%ebp),%edx
  800997:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800999:	85 d2                	test   %edx,%edx
  80099b:	74 21                	je     8009be <strlcpy+0x35>
  80099d:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009a1:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8009a3:	39 c2                	cmp    %eax,%edx
  8009a5:	74 14                	je     8009bb <strlcpy+0x32>
  8009a7:	0f b6 19             	movzbl (%ecx),%ebx
  8009aa:	84 db                	test   %bl,%bl
  8009ac:	74 0b                	je     8009b9 <strlcpy+0x30>
			*dst++ = *src++;
  8009ae:	83 c1 01             	add    $0x1,%ecx
  8009b1:	83 c2 01             	add    $0x1,%edx
  8009b4:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009b7:	eb ea                	jmp    8009a3 <strlcpy+0x1a>
  8009b9:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009bb:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009be:	29 f0                	sub    %esi,%eax
}
  8009c0:	5b                   	pop    %ebx
  8009c1:	5e                   	pop    %esi
  8009c2:	5d                   	pop    %ebp
  8009c3:	c3                   	ret    

008009c4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009c4:	55                   	push   %ebp
  8009c5:	89 e5                	mov    %esp,%ebp
  8009c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009ca:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009cd:	0f b6 01             	movzbl (%ecx),%eax
  8009d0:	84 c0                	test   %al,%al
  8009d2:	74 0c                	je     8009e0 <strcmp+0x1c>
  8009d4:	3a 02                	cmp    (%edx),%al
  8009d6:	75 08                	jne    8009e0 <strcmp+0x1c>
		p++, q++;
  8009d8:	83 c1 01             	add    $0x1,%ecx
  8009db:	83 c2 01             	add    $0x1,%edx
  8009de:	eb ed                	jmp    8009cd <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009e0:	0f b6 c0             	movzbl %al,%eax
  8009e3:	0f b6 12             	movzbl (%edx),%edx
  8009e6:	29 d0                	sub    %edx,%eax
}
  8009e8:	5d                   	pop    %ebp
  8009e9:	c3                   	ret    

008009ea <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009ea:	55                   	push   %ebp
  8009eb:	89 e5                	mov    %esp,%ebp
  8009ed:	53                   	push   %ebx
  8009ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009f4:	89 c3                	mov    %eax,%ebx
  8009f6:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009f9:	eb 06                	jmp    800a01 <strncmp+0x17>
		n--, p++, q++;
  8009fb:	83 c0 01             	add    $0x1,%eax
  8009fe:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a01:	39 d8                	cmp    %ebx,%eax
  800a03:	74 16                	je     800a1b <strncmp+0x31>
  800a05:	0f b6 08             	movzbl (%eax),%ecx
  800a08:	84 c9                	test   %cl,%cl
  800a0a:	74 04                	je     800a10 <strncmp+0x26>
  800a0c:	3a 0a                	cmp    (%edx),%cl
  800a0e:	74 eb                	je     8009fb <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a10:	0f b6 00             	movzbl (%eax),%eax
  800a13:	0f b6 12             	movzbl (%edx),%edx
  800a16:	29 d0                	sub    %edx,%eax
}
  800a18:	5b                   	pop    %ebx
  800a19:	5d                   	pop    %ebp
  800a1a:	c3                   	ret    
		return 0;
  800a1b:	b8 00 00 00 00       	mov    $0x0,%eax
  800a20:	eb f6                	jmp    800a18 <strncmp+0x2e>

00800a22 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a22:	55                   	push   %ebp
  800a23:	89 e5                	mov    %esp,%ebp
  800a25:	8b 45 08             	mov    0x8(%ebp),%eax
  800a28:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a2c:	0f b6 10             	movzbl (%eax),%edx
  800a2f:	84 d2                	test   %dl,%dl
  800a31:	74 09                	je     800a3c <strchr+0x1a>
		if (*s == c)
  800a33:	38 ca                	cmp    %cl,%dl
  800a35:	74 0a                	je     800a41 <strchr+0x1f>
	for (; *s; s++)
  800a37:	83 c0 01             	add    $0x1,%eax
  800a3a:	eb f0                	jmp    800a2c <strchr+0xa>
			return (char *) s;
	return 0;
  800a3c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a41:	5d                   	pop    %ebp
  800a42:	c3                   	ret    

00800a43 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a43:	55                   	push   %ebp
  800a44:	89 e5                	mov    %esp,%ebp
  800a46:	8b 45 08             	mov    0x8(%ebp),%eax
  800a49:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a4d:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a50:	38 ca                	cmp    %cl,%dl
  800a52:	74 09                	je     800a5d <strfind+0x1a>
  800a54:	84 d2                	test   %dl,%dl
  800a56:	74 05                	je     800a5d <strfind+0x1a>
	for (; *s; s++)
  800a58:	83 c0 01             	add    $0x1,%eax
  800a5b:	eb f0                	jmp    800a4d <strfind+0xa>
			break;
	return (char *) s;
}
  800a5d:	5d                   	pop    %ebp
  800a5e:	c3                   	ret    

00800a5f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a5f:	55                   	push   %ebp
  800a60:	89 e5                	mov    %esp,%ebp
  800a62:	57                   	push   %edi
  800a63:	56                   	push   %esi
  800a64:	53                   	push   %ebx
  800a65:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a68:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a6b:	85 c9                	test   %ecx,%ecx
  800a6d:	74 31                	je     800aa0 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a6f:	89 f8                	mov    %edi,%eax
  800a71:	09 c8                	or     %ecx,%eax
  800a73:	a8 03                	test   $0x3,%al
  800a75:	75 23                	jne    800a9a <memset+0x3b>
		c &= 0xFF;
  800a77:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a7b:	89 d3                	mov    %edx,%ebx
  800a7d:	c1 e3 08             	shl    $0x8,%ebx
  800a80:	89 d0                	mov    %edx,%eax
  800a82:	c1 e0 18             	shl    $0x18,%eax
  800a85:	89 d6                	mov    %edx,%esi
  800a87:	c1 e6 10             	shl    $0x10,%esi
  800a8a:	09 f0                	or     %esi,%eax
  800a8c:	09 c2                	or     %eax,%edx
  800a8e:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a90:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a93:	89 d0                	mov    %edx,%eax
  800a95:	fc                   	cld    
  800a96:	f3 ab                	rep stos %eax,%es:(%edi)
  800a98:	eb 06                	jmp    800aa0 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a9d:	fc                   	cld    
  800a9e:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800aa0:	89 f8                	mov    %edi,%eax
  800aa2:	5b                   	pop    %ebx
  800aa3:	5e                   	pop    %esi
  800aa4:	5f                   	pop    %edi
  800aa5:	5d                   	pop    %ebp
  800aa6:	c3                   	ret    

00800aa7 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800aa7:	55                   	push   %ebp
  800aa8:	89 e5                	mov    %esp,%ebp
  800aaa:	57                   	push   %edi
  800aab:	56                   	push   %esi
  800aac:	8b 45 08             	mov    0x8(%ebp),%eax
  800aaf:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ab2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ab5:	39 c6                	cmp    %eax,%esi
  800ab7:	73 32                	jae    800aeb <memmove+0x44>
  800ab9:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800abc:	39 c2                	cmp    %eax,%edx
  800abe:	76 2b                	jbe    800aeb <memmove+0x44>
		s += n;
		d += n;
  800ac0:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ac3:	89 fe                	mov    %edi,%esi
  800ac5:	09 ce                	or     %ecx,%esi
  800ac7:	09 d6                	or     %edx,%esi
  800ac9:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800acf:	75 0e                	jne    800adf <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ad1:	83 ef 04             	sub    $0x4,%edi
  800ad4:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ad7:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800ada:	fd                   	std    
  800adb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800add:	eb 09                	jmp    800ae8 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800adf:	83 ef 01             	sub    $0x1,%edi
  800ae2:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ae5:	fd                   	std    
  800ae6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ae8:	fc                   	cld    
  800ae9:	eb 1a                	jmp    800b05 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aeb:	89 c2                	mov    %eax,%edx
  800aed:	09 ca                	or     %ecx,%edx
  800aef:	09 f2                	or     %esi,%edx
  800af1:	f6 c2 03             	test   $0x3,%dl
  800af4:	75 0a                	jne    800b00 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800af6:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800af9:	89 c7                	mov    %eax,%edi
  800afb:	fc                   	cld    
  800afc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800afe:	eb 05                	jmp    800b05 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b00:	89 c7                	mov    %eax,%edi
  800b02:	fc                   	cld    
  800b03:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b05:	5e                   	pop    %esi
  800b06:	5f                   	pop    %edi
  800b07:	5d                   	pop    %ebp
  800b08:	c3                   	ret    

00800b09 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b09:	55                   	push   %ebp
  800b0a:	89 e5                	mov    %esp,%ebp
  800b0c:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b0f:	ff 75 10             	pushl  0x10(%ebp)
  800b12:	ff 75 0c             	pushl  0xc(%ebp)
  800b15:	ff 75 08             	pushl  0x8(%ebp)
  800b18:	e8 8a ff ff ff       	call   800aa7 <memmove>
}
  800b1d:	c9                   	leave  
  800b1e:	c3                   	ret    

00800b1f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b1f:	55                   	push   %ebp
  800b20:	89 e5                	mov    %esp,%ebp
  800b22:	56                   	push   %esi
  800b23:	53                   	push   %ebx
  800b24:	8b 45 08             	mov    0x8(%ebp),%eax
  800b27:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b2a:	89 c6                	mov    %eax,%esi
  800b2c:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b2f:	39 f0                	cmp    %esi,%eax
  800b31:	74 1c                	je     800b4f <memcmp+0x30>
		if (*s1 != *s2)
  800b33:	0f b6 08             	movzbl (%eax),%ecx
  800b36:	0f b6 1a             	movzbl (%edx),%ebx
  800b39:	38 d9                	cmp    %bl,%cl
  800b3b:	75 08                	jne    800b45 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b3d:	83 c0 01             	add    $0x1,%eax
  800b40:	83 c2 01             	add    $0x1,%edx
  800b43:	eb ea                	jmp    800b2f <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b45:	0f b6 c1             	movzbl %cl,%eax
  800b48:	0f b6 db             	movzbl %bl,%ebx
  800b4b:	29 d8                	sub    %ebx,%eax
  800b4d:	eb 05                	jmp    800b54 <memcmp+0x35>
	}

	return 0;
  800b4f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b54:	5b                   	pop    %ebx
  800b55:	5e                   	pop    %esi
  800b56:	5d                   	pop    %ebp
  800b57:	c3                   	ret    

00800b58 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b58:	55                   	push   %ebp
  800b59:	89 e5                	mov    %esp,%ebp
  800b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b61:	89 c2                	mov    %eax,%edx
  800b63:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b66:	39 d0                	cmp    %edx,%eax
  800b68:	73 09                	jae    800b73 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b6a:	38 08                	cmp    %cl,(%eax)
  800b6c:	74 05                	je     800b73 <memfind+0x1b>
	for (; s < ends; s++)
  800b6e:	83 c0 01             	add    $0x1,%eax
  800b71:	eb f3                	jmp    800b66 <memfind+0xe>
			break;
	return (void *) s;
}
  800b73:	5d                   	pop    %ebp
  800b74:	c3                   	ret    

00800b75 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b75:	55                   	push   %ebp
  800b76:	89 e5                	mov    %esp,%ebp
  800b78:	57                   	push   %edi
  800b79:	56                   	push   %esi
  800b7a:	53                   	push   %ebx
  800b7b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b7e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b81:	eb 03                	jmp    800b86 <strtol+0x11>
		s++;
  800b83:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b86:	0f b6 01             	movzbl (%ecx),%eax
  800b89:	3c 20                	cmp    $0x20,%al
  800b8b:	74 f6                	je     800b83 <strtol+0xe>
  800b8d:	3c 09                	cmp    $0x9,%al
  800b8f:	74 f2                	je     800b83 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b91:	3c 2b                	cmp    $0x2b,%al
  800b93:	74 2a                	je     800bbf <strtol+0x4a>
	int neg = 0;
  800b95:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b9a:	3c 2d                	cmp    $0x2d,%al
  800b9c:	74 2b                	je     800bc9 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b9e:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ba4:	75 0f                	jne    800bb5 <strtol+0x40>
  800ba6:	80 39 30             	cmpb   $0x30,(%ecx)
  800ba9:	74 28                	je     800bd3 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bab:	85 db                	test   %ebx,%ebx
  800bad:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bb2:	0f 44 d8             	cmove  %eax,%ebx
  800bb5:	b8 00 00 00 00       	mov    $0x0,%eax
  800bba:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bbd:	eb 50                	jmp    800c0f <strtol+0x9a>
		s++;
  800bbf:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800bc2:	bf 00 00 00 00       	mov    $0x0,%edi
  800bc7:	eb d5                	jmp    800b9e <strtol+0x29>
		s++, neg = 1;
  800bc9:	83 c1 01             	add    $0x1,%ecx
  800bcc:	bf 01 00 00 00       	mov    $0x1,%edi
  800bd1:	eb cb                	jmp    800b9e <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bd3:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bd7:	74 0e                	je     800be7 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800bd9:	85 db                	test   %ebx,%ebx
  800bdb:	75 d8                	jne    800bb5 <strtol+0x40>
		s++, base = 8;
  800bdd:	83 c1 01             	add    $0x1,%ecx
  800be0:	bb 08 00 00 00       	mov    $0x8,%ebx
  800be5:	eb ce                	jmp    800bb5 <strtol+0x40>
		s += 2, base = 16;
  800be7:	83 c1 02             	add    $0x2,%ecx
  800bea:	bb 10 00 00 00       	mov    $0x10,%ebx
  800bef:	eb c4                	jmp    800bb5 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800bf1:	8d 72 9f             	lea    -0x61(%edx),%esi
  800bf4:	89 f3                	mov    %esi,%ebx
  800bf6:	80 fb 19             	cmp    $0x19,%bl
  800bf9:	77 29                	ja     800c24 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800bfb:	0f be d2             	movsbl %dl,%edx
  800bfe:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c01:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c04:	7d 30                	jge    800c36 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c06:	83 c1 01             	add    $0x1,%ecx
  800c09:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c0d:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c0f:	0f b6 11             	movzbl (%ecx),%edx
  800c12:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c15:	89 f3                	mov    %esi,%ebx
  800c17:	80 fb 09             	cmp    $0x9,%bl
  800c1a:	77 d5                	ja     800bf1 <strtol+0x7c>
			dig = *s - '0';
  800c1c:	0f be d2             	movsbl %dl,%edx
  800c1f:	83 ea 30             	sub    $0x30,%edx
  800c22:	eb dd                	jmp    800c01 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c24:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c27:	89 f3                	mov    %esi,%ebx
  800c29:	80 fb 19             	cmp    $0x19,%bl
  800c2c:	77 08                	ja     800c36 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c2e:	0f be d2             	movsbl %dl,%edx
  800c31:	83 ea 37             	sub    $0x37,%edx
  800c34:	eb cb                	jmp    800c01 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c36:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c3a:	74 05                	je     800c41 <strtol+0xcc>
		*endptr = (char *) s;
  800c3c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c3f:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c41:	89 c2                	mov    %eax,%edx
  800c43:	f7 da                	neg    %edx
  800c45:	85 ff                	test   %edi,%edi
  800c47:	0f 45 c2             	cmovne %edx,%eax
}
  800c4a:	5b                   	pop    %ebx
  800c4b:	5e                   	pop    %esi
  800c4c:	5f                   	pop    %edi
  800c4d:	5d                   	pop    %ebp
  800c4e:	c3                   	ret    

00800c4f <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c4f:	55                   	push   %ebp
  800c50:	89 e5                	mov    %esp,%ebp
  800c52:	57                   	push   %edi
  800c53:	56                   	push   %esi
  800c54:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c55:	b8 00 00 00 00       	mov    $0x0,%eax
  800c5a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c5d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c60:	89 c3                	mov    %eax,%ebx
  800c62:	89 c7                	mov    %eax,%edi
  800c64:	89 c6                	mov    %eax,%esi
  800c66:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c68:	5b                   	pop    %ebx
  800c69:	5e                   	pop    %esi
  800c6a:	5f                   	pop    %edi
  800c6b:	5d                   	pop    %ebp
  800c6c:	c3                   	ret    

00800c6d <sys_cgetc>:

int
sys_cgetc(void)
{
  800c6d:	55                   	push   %ebp
  800c6e:	89 e5                	mov    %esp,%ebp
  800c70:	57                   	push   %edi
  800c71:	56                   	push   %esi
  800c72:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c73:	ba 00 00 00 00       	mov    $0x0,%edx
  800c78:	b8 01 00 00 00       	mov    $0x1,%eax
  800c7d:	89 d1                	mov    %edx,%ecx
  800c7f:	89 d3                	mov    %edx,%ebx
  800c81:	89 d7                	mov    %edx,%edi
  800c83:	89 d6                	mov    %edx,%esi
  800c85:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c87:	5b                   	pop    %ebx
  800c88:	5e                   	pop    %esi
  800c89:	5f                   	pop    %edi
  800c8a:	5d                   	pop    %ebp
  800c8b:	c3                   	ret    

00800c8c <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c8c:	55                   	push   %ebp
  800c8d:	89 e5                	mov    %esp,%ebp
  800c8f:	57                   	push   %edi
  800c90:	56                   	push   %esi
  800c91:	53                   	push   %ebx
  800c92:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c95:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c9a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c9d:	b8 03 00 00 00       	mov    $0x3,%eax
  800ca2:	89 cb                	mov    %ecx,%ebx
  800ca4:	89 cf                	mov    %ecx,%edi
  800ca6:	89 ce                	mov    %ecx,%esi
  800ca8:	cd 30                	int    $0x30
	if (check && ret > 0)
  800caa:	85 c0                	test   %eax,%eax
  800cac:	7f 08                	jg     800cb6 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cb1:	5b                   	pop    %ebx
  800cb2:	5e                   	pop    %esi
  800cb3:	5f                   	pop    %edi
  800cb4:	5d                   	pop    %ebp
  800cb5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cb6:	83 ec 0c             	sub    $0xc,%esp
  800cb9:	50                   	push   %eax
  800cba:	6a 03                	push   $0x3
  800cbc:	68 60 1b 80 00       	push   $0x801b60
  800cc1:	6a 4c                	push   $0x4c
  800cc3:	68 7d 1b 80 00       	push   $0x801b7d
  800cc8:	e8 81 07 00 00       	call   80144e <_panic>

00800ccd <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800ccd:	55                   	push   %ebp
  800cce:	89 e5                	mov    %esp,%ebp
  800cd0:	57                   	push   %edi
  800cd1:	56                   	push   %esi
  800cd2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cd3:	ba 00 00 00 00       	mov    $0x0,%edx
  800cd8:	b8 02 00 00 00       	mov    $0x2,%eax
  800cdd:	89 d1                	mov    %edx,%ecx
  800cdf:	89 d3                	mov    %edx,%ebx
  800ce1:	89 d7                	mov    %edx,%edi
  800ce3:	89 d6                	mov    %edx,%esi
  800ce5:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800ce7:	5b                   	pop    %ebx
  800ce8:	5e                   	pop    %esi
  800ce9:	5f                   	pop    %edi
  800cea:	5d                   	pop    %ebp
  800ceb:	c3                   	ret    

00800cec <sys_yield>:

void
sys_yield(void)
{
  800cec:	55                   	push   %ebp
  800ced:	89 e5                	mov    %esp,%ebp
  800cef:	57                   	push   %edi
  800cf0:	56                   	push   %esi
  800cf1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cf2:	ba 00 00 00 00       	mov    $0x0,%edx
  800cf7:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cfc:	89 d1                	mov    %edx,%ecx
  800cfe:	89 d3                	mov    %edx,%ebx
  800d00:	89 d7                	mov    %edx,%edi
  800d02:	89 d6                	mov    %edx,%esi
  800d04:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d06:	5b                   	pop    %ebx
  800d07:	5e                   	pop    %esi
  800d08:	5f                   	pop    %edi
  800d09:	5d                   	pop    %ebp
  800d0a:	c3                   	ret    

00800d0b <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d0b:	55                   	push   %ebp
  800d0c:	89 e5                	mov    %esp,%ebp
  800d0e:	57                   	push   %edi
  800d0f:	56                   	push   %esi
  800d10:	53                   	push   %ebx
  800d11:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d14:	be 00 00 00 00       	mov    $0x0,%esi
  800d19:	8b 55 08             	mov    0x8(%ebp),%edx
  800d1c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d1f:	b8 04 00 00 00       	mov    $0x4,%eax
  800d24:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d27:	89 f7                	mov    %esi,%edi
  800d29:	cd 30                	int    $0x30
	if (check && ret > 0)
  800d2b:	85 c0                	test   %eax,%eax
  800d2d:	7f 08                	jg     800d37 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d2f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d32:	5b                   	pop    %ebx
  800d33:	5e                   	pop    %esi
  800d34:	5f                   	pop    %edi
  800d35:	5d                   	pop    %ebp
  800d36:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d37:	83 ec 0c             	sub    $0xc,%esp
  800d3a:	50                   	push   %eax
  800d3b:	6a 04                	push   $0x4
  800d3d:	68 60 1b 80 00       	push   $0x801b60
  800d42:	6a 4c                	push   $0x4c
  800d44:	68 7d 1b 80 00       	push   $0x801b7d
  800d49:	e8 00 07 00 00       	call   80144e <_panic>

00800d4e <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d4e:	55                   	push   %ebp
  800d4f:	89 e5                	mov    %esp,%ebp
  800d51:	57                   	push   %edi
  800d52:	56                   	push   %esi
  800d53:	53                   	push   %ebx
  800d54:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d57:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d5d:	b8 05 00 00 00       	mov    $0x5,%eax
  800d62:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d65:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d68:	8b 75 18             	mov    0x18(%ebp),%esi
  800d6b:	cd 30                	int    $0x30
	if (check && ret > 0)
  800d6d:	85 c0                	test   %eax,%eax
  800d6f:	7f 08                	jg     800d79 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d71:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d74:	5b                   	pop    %ebx
  800d75:	5e                   	pop    %esi
  800d76:	5f                   	pop    %edi
  800d77:	5d                   	pop    %ebp
  800d78:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d79:	83 ec 0c             	sub    $0xc,%esp
  800d7c:	50                   	push   %eax
  800d7d:	6a 05                	push   $0x5
  800d7f:	68 60 1b 80 00       	push   $0x801b60
  800d84:	6a 4c                	push   $0x4c
  800d86:	68 7d 1b 80 00       	push   $0x801b7d
  800d8b:	e8 be 06 00 00       	call   80144e <_panic>

00800d90 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d90:	55                   	push   %ebp
  800d91:	89 e5                	mov    %esp,%ebp
  800d93:	57                   	push   %edi
  800d94:	56                   	push   %esi
  800d95:	53                   	push   %ebx
  800d96:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d99:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d9e:	8b 55 08             	mov    0x8(%ebp),%edx
  800da1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da4:	b8 06 00 00 00       	mov    $0x6,%eax
  800da9:	89 df                	mov    %ebx,%edi
  800dab:	89 de                	mov    %ebx,%esi
  800dad:	cd 30                	int    $0x30
	if (check && ret > 0)
  800daf:	85 c0                	test   %eax,%eax
  800db1:	7f 08                	jg     800dbb <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800db3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800db6:	5b                   	pop    %ebx
  800db7:	5e                   	pop    %esi
  800db8:	5f                   	pop    %edi
  800db9:	5d                   	pop    %ebp
  800dba:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dbb:	83 ec 0c             	sub    $0xc,%esp
  800dbe:	50                   	push   %eax
  800dbf:	6a 06                	push   $0x6
  800dc1:	68 60 1b 80 00       	push   $0x801b60
  800dc6:	6a 4c                	push   $0x4c
  800dc8:	68 7d 1b 80 00       	push   $0x801b7d
  800dcd:	e8 7c 06 00 00       	call   80144e <_panic>

00800dd2 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800dd2:	55                   	push   %ebp
  800dd3:	89 e5                	mov    %esp,%ebp
  800dd5:	57                   	push   %edi
  800dd6:	56                   	push   %esi
  800dd7:	53                   	push   %ebx
  800dd8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ddb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800de0:	8b 55 08             	mov    0x8(%ebp),%edx
  800de3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de6:	b8 08 00 00 00       	mov    $0x8,%eax
  800deb:	89 df                	mov    %ebx,%edi
  800ded:	89 de                	mov    %ebx,%esi
  800def:	cd 30                	int    $0x30
	if (check && ret > 0)
  800df1:	85 c0                	test   %eax,%eax
  800df3:	7f 08                	jg     800dfd <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800df5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800df8:	5b                   	pop    %ebx
  800df9:	5e                   	pop    %esi
  800dfa:	5f                   	pop    %edi
  800dfb:	5d                   	pop    %ebp
  800dfc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dfd:	83 ec 0c             	sub    $0xc,%esp
  800e00:	50                   	push   %eax
  800e01:	6a 08                	push   $0x8
  800e03:	68 60 1b 80 00       	push   $0x801b60
  800e08:	6a 4c                	push   $0x4c
  800e0a:	68 7d 1b 80 00       	push   $0x801b7d
  800e0f:	e8 3a 06 00 00       	call   80144e <_panic>

00800e14 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e14:	55                   	push   %ebp
  800e15:	89 e5                	mov    %esp,%ebp
  800e17:	57                   	push   %edi
  800e18:	56                   	push   %esi
  800e19:	53                   	push   %ebx
  800e1a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e1d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e22:	8b 55 08             	mov    0x8(%ebp),%edx
  800e25:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e28:	b8 09 00 00 00       	mov    $0x9,%eax
  800e2d:	89 df                	mov    %ebx,%edi
  800e2f:	89 de                	mov    %ebx,%esi
  800e31:	cd 30                	int    $0x30
	if (check && ret > 0)
  800e33:	85 c0                	test   %eax,%eax
  800e35:	7f 08                	jg     800e3f <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e37:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e3a:	5b                   	pop    %ebx
  800e3b:	5e                   	pop    %esi
  800e3c:	5f                   	pop    %edi
  800e3d:	5d                   	pop    %ebp
  800e3e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e3f:	83 ec 0c             	sub    $0xc,%esp
  800e42:	50                   	push   %eax
  800e43:	6a 09                	push   $0x9
  800e45:	68 60 1b 80 00       	push   $0x801b60
  800e4a:	6a 4c                	push   $0x4c
  800e4c:	68 7d 1b 80 00       	push   $0x801b7d
  800e51:	e8 f8 05 00 00       	call   80144e <_panic>

00800e56 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e56:	55                   	push   %ebp
  800e57:	89 e5                	mov    %esp,%ebp
  800e59:	57                   	push   %edi
  800e5a:	56                   	push   %esi
  800e5b:	53                   	push   %ebx
  800e5c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e5f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e64:	8b 55 08             	mov    0x8(%ebp),%edx
  800e67:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e6a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e6f:	89 df                	mov    %ebx,%edi
  800e71:	89 de                	mov    %ebx,%esi
  800e73:	cd 30                	int    $0x30
	if (check && ret > 0)
  800e75:	85 c0                	test   %eax,%eax
  800e77:	7f 08                	jg     800e81 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e79:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e7c:	5b                   	pop    %ebx
  800e7d:	5e                   	pop    %esi
  800e7e:	5f                   	pop    %edi
  800e7f:	5d                   	pop    %ebp
  800e80:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e81:	83 ec 0c             	sub    $0xc,%esp
  800e84:	50                   	push   %eax
  800e85:	6a 0a                	push   $0xa
  800e87:	68 60 1b 80 00       	push   $0x801b60
  800e8c:	6a 4c                	push   $0x4c
  800e8e:	68 7d 1b 80 00       	push   $0x801b7d
  800e93:	e8 b6 05 00 00       	call   80144e <_panic>

00800e98 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e98:	55                   	push   %ebp
  800e99:	89 e5                	mov    %esp,%ebp
  800e9b:	57                   	push   %edi
  800e9c:	56                   	push   %esi
  800e9d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e9e:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea4:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ea9:	be 00 00 00 00       	mov    $0x0,%esi
  800eae:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800eb1:	8b 7d 14             	mov    0x14(%ebp),%edi
  800eb4:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800eb6:	5b                   	pop    %ebx
  800eb7:	5e                   	pop    %esi
  800eb8:	5f                   	pop    %edi
  800eb9:	5d                   	pop    %ebp
  800eba:	c3                   	ret    

00800ebb <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ebb:	55                   	push   %ebp
  800ebc:	89 e5                	mov    %esp,%ebp
  800ebe:	57                   	push   %edi
  800ebf:	56                   	push   %esi
  800ec0:	53                   	push   %ebx
  800ec1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ec4:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ec9:	8b 55 08             	mov    0x8(%ebp),%edx
  800ecc:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ed1:	89 cb                	mov    %ecx,%ebx
  800ed3:	89 cf                	mov    %ecx,%edi
  800ed5:	89 ce                	mov    %ecx,%esi
  800ed7:	cd 30                	int    $0x30
	if (check && ret > 0)
  800ed9:	85 c0                	test   %eax,%eax
  800edb:	7f 08                	jg     800ee5 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800edd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ee0:	5b                   	pop    %ebx
  800ee1:	5e                   	pop    %esi
  800ee2:	5f                   	pop    %edi
  800ee3:	5d                   	pop    %ebp
  800ee4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ee5:	83 ec 0c             	sub    $0xc,%esp
  800ee8:	50                   	push   %eax
  800ee9:	6a 0d                	push   $0xd
  800eeb:	68 60 1b 80 00       	push   $0x801b60
  800ef0:	6a 4c                	push   $0x4c
  800ef2:	68 7d 1b 80 00       	push   $0x801b7d
  800ef7:	e8 52 05 00 00       	call   80144e <_panic>

00800efc <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800efc:	55                   	push   %ebp
  800efd:	89 e5                	mov    %esp,%ebp
  800eff:	57                   	push   %edi
  800f00:	56                   	push   %esi
  800f01:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f02:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f07:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f0d:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f12:	89 df                	mov    %ebx,%edi
  800f14:	89 de                	mov    %ebx,%esi
  800f16:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f18:	5b                   	pop    %ebx
  800f19:	5e                   	pop    %esi
  800f1a:	5f                   	pop    %edi
  800f1b:	5d                   	pop    %ebp
  800f1c:	c3                   	ret    

00800f1d <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f1d:	55                   	push   %ebp
  800f1e:	89 e5                	mov    %esp,%ebp
  800f20:	57                   	push   %edi
  800f21:	56                   	push   %esi
  800f22:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f23:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f28:	8b 55 08             	mov    0x8(%ebp),%edx
  800f2b:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f30:	89 cb                	mov    %ecx,%ebx
  800f32:	89 cf                	mov    %ecx,%edi
  800f34:	89 ce                	mov    %ecx,%esi
  800f36:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f38:	5b                   	pop    %ebx
  800f39:	5e                   	pop    %esi
  800f3a:	5f                   	pop    %edi
  800f3b:	5d                   	pop    %ebp
  800f3c:	c3                   	ret    

00800f3d <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800f3d:	55                   	push   %ebp
  800f3e:	89 e5                	mov    %esp,%ebp
  800f40:	53                   	push   %ebx
  800f41:	83 ec 04             	sub    $0x4,%esp
  800f44:	8b 55 08             	mov    0x8(%ebp),%edx
	// cprintf("pgfault()\n");
	void *addr = (void *) utf->utf_fault_va;
  800f47:	8b 02                	mov    (%edx),%eax
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(!(err & FEC_WR) || !(uvpd[PDX(addr)] & PTE_P) || !(uvpt[PGNUM(addr)] & PTE_P) || !(uvpt[PGNUM(addr)] & PTE_COW))
  800f49:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  800f4d:	0f 84 9c 00 00 00    	je     800fef <pgfault+0xb2>
  800f53:	89 c2                	mov    %eax,%edx
  800f55:	c1 ea 16             	shr    $0x16,%edx
  800f58:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f5f:	f6 c2 01             	test   $0x1,%dl
  800f62:	0f 84 87 00 00 00    	je     800fef <pgfault+0xb2>
  800f68:	89 c2                	mov    %eax,%edx
  800f6a:	c1 ea 0c             	shr    $0xc,%edx
  800f6d:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  800f74:	f6 c1 01             	test   $0x1,%cl
  800f77:	74 76                	je     800fef <pgfault+0xb2>
  800f79:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f80:	f6 c6 08             	test   $0x8,%dh
  800f83:	74 6a                	je     800fef <pgfault+0xb2>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  800f85:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f8a:	89 c3                	mov    %eax,%ebx

	r = sys_page_alloc(0, PFTEMP, PTE_P|PTE_U|PTE_W);
  800f8c:	83 ec 04             	sub    $0x4,%esp
  800f8f:	6a 07                	push   $0x7
  800f91:	68 00 f0 7f 00       	push   $0x7ff000
  800f96:	6a 00                	push   $0x0
  800f98:	e8 6e fd ff ff       	call   800d0b <sys_page_alloc>
	if(r < 0){
  800f9d:	83 c4 10             	add    $0x10,%esp
  800fa0:	85 c0                	test   %eax,%eax
  800fa2:	78 5f                	js     801003 <pgfault+0xc6>
		panic("pgfault: sys_page_alloc fail, r: %d", r);
	}

	memmove(PFTEMP, addr, PGSIZE);
  800fa4:	83 ec 04             	sub    $0x4,%esp
  800fa7:	68 00 10 00 00       	push   $0x1000
  800fac:	53                   	push   %ebx
  800fad:	68 00 f0 7f 00       	push   $0x7ff000
  800fb2:	e8 f0 fa ff ff       	call   800aa7 <memmove>

	r = sys_page_map(0, PFTEMP, 0, addr, PTE_P|PTE_U|PTE_W);
  800fb7:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800fbe:	53                   	push   %ebx
  800fbf:	6a 00                	push   $0x0
  800fc1:	68 00 f0 7f 00       	push   $0x7ff000
  800fc6:	6a 00                	push   $0x0
  800fc8:	e8 81 fd ff ff       	call   800d4e <sys_page_map>
	if(r < 0){
  800fcd:	83 c4 20             	add    $0x20,%esp
  800fd0:	85 c0                	test   %eax,%eax
  800fd2:	78 41                	js     801015 <pgfault+0xd8>
		panic("pgfault: sys_page_map fail, r: %d", r);
	}

	r = sys_page_unmap(0, PFTEMP);
  800fd4:	83 ec 08             	sub    $0x8,%esp
  800fd7:	68 00 f0 7f 00       	push   $0x7ff000
  800fdc:	6a 00                	push   $0x0
  800fde:	e8 ad fd ff ff       	call   800d90 <sys_page_unmap>
	if(r < 0){
  800fe3:	83 c4 10             	add    $0x10,%esp
  800fe6:	85 c0                	test   %eax,%eax
  800fe8:	78 3d                	js     801027 <pgfault+0xea>
		panic("sys_page_unmap: %e", r);
	}
}
  800fea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800fed:	c9                   	leave  
  800fee:	c3                   	ret    
		panic("pgfault: 1\n");
  800fef:	83 ec 04             	sub    $0x4,%esp
  800ff2:	68 8b 1b 80 00       	push   $0x801b8b
  800ff7:	6a 20                	push   $0x20
  800ff9:	68 97 1b 80 00       	push   $0x801b97
  800ffe:	e8 4b 04 00 00       	call   80144e <_panic>
		panic("pgfault: sys_page_alloc fail, r: %d", r);
  801003:	50                   	push   %eax
  801004:	68 ec 1b 80 00       	push   $0x801bec
  801009:	6a 2e                	push   $0x2e
  80100b:	68 97 1b 80 00       	push   $0x801b97
  801010:	e8 39 04 00 00       	call   80144e <_panic>
		panic("pgfault: sys_page_map fail, r: %d", r);
  801015:	50                   	push   %eax
  801016:	68 10 1c 80 00       	push   $0x801c10
  80101b:	6a 35                	push   $0x35
  80101d:	68 97 1b 80 00       	push   $0x801b97
  801022:	e8 27 04 00 00       	call   80144e <_panic>
		panic("sys_page_unmap: %e", r);
  801027:	50                   	push   %eax
  801028:	68 a2 1b 80 00       	push   $0x801ba2
  80102d:	6a 3a                	push   $0x3a
  80102f:	68 97 1b 80 00       	push   $0x801b97
  801034:	e8 15 04 00 00       	call   80144e <_panic>

00801039 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801039:	55                   	push   %ebp
  80103a:	89 e5                	mov    %esp,%ebp
  80103c:	57                   	push   %edi
  80103d:	56                   	push   %esi
  80103e:	53                   	push   %ebx
  80103f:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	// panic("fork not implemented");
	int r;
	set_pgfault_handler(pgfault);
  801042:	68 3d 0f 80 00       	push   $0x800f3d
  801047:	e8 48 04 00 00       	call   801494 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  80104c:	b8 07 00 00 00       	mov    $0x7,%eax
  801051:	cd 30                	int    $0x30
  801053:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int i;
	uintptr_t va;
	envid_t childid = sys_exofork();
	if (childid < 0){
  801056:	83 c4 10             	add    $0x10,%esp
  801059:	85 c0                	test   %eax,%eax
  80105b:	78 2c                	js     801089 <fork+0x50>
  80105d:	89 c7                	mov    %eax,%edi
	}

	extern volatile pde_t uvpd[];
	extern volatile pte_t uvpt[];

	for (va = UTEXT; va < USTACKTOP; va += PGSIZE){
  80105f:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if (childid == 0) {
  801064:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801068:	75 72                	jne    8010dc <fork+0xa3>
		thisenv = &envs[ENVX(sys_getenvid())];
  80106a:	e8 5e fc ff ff       	call   800ccd <sys_getenvid>
  80106f:	25 ff 03 00 00       	and    $0x3ff,%eax
  801074:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80107a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80107f:	a3 08 20 80 00       	mov    %eax,0x802008
		return 0;
  801084:	e9 36 01 00 00       	jmp    8011bf <fork+0x186>
		panic("fork: child id < 0: %d", childid);
  801089:	50                   	push   %eax
  80108a:	68 b5 1b 80 00       	push   $0x801bb5
  80108f:	68 83 00 00 00       	push   $0x83
  801094:	68 97 1b 80 00       	push   $0x801b97
  801099:	e8 b0 03 00 00       	call   80144e <_panic>
			panic("sys_page_map: sys_page_map fail, r:%d\n", r);
  80109e:	50                   	push   %eax
  80109f:	68 34 1c 80 00       	push   $0x801c34
  8010a4:	6a 56                	push   $0x56
  8010a6:	68 97 1b 80 00       	push   $0x801b97
  8010ab:	e8 9e 03 00 00       	call   80144e <_panic>
		r = sys_page_map((envid_t)0, va, envid, va, PTE_U | PTE_P);
  8010b0:	83 ec 0c             	sub    $0xc,%esp
  8010b3:	6a 05                	push   $0x5
  8010b5:	56                   	push   %esi
  8010b6:	57                   	push   %edi
  8010b7:	56                   	push   %esi
  8010b8:	6a 00                	push   $0x0
  8010ba:	e8 8f fc ff ff       	call   800d4e <sys_page_map>
		if(r < 0){
  8010bf:	83 c4 20             	add    $0x20,%esp
  8010c2:	85 c0                	test   %eax,%eax
  8010c4:	0f 88 9f 00 00 00    	js     801169 <fork+0x130>
	for (va = UTEXT; va < USTACKTOP; va += PGSIZE){
  8010ca:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8010d0:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8010d6:	0f 84 9f 00 00 00    	je     80117b <fork+0x142>
		if ((uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_U)){
  8010dc:	89 d8                	mov    %ebx,%eax
  8010de:	c1 e8 16             	shr    $0x16,%eax
  8010e1:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8010e8:	a8 01                	test   $0x1,%al
  8010ea:	74 de                	je     8010ca <fork+0x91>
  8010ec:	89 d8                	mov    %ebx,%eax
  8010ee:	c1 e8 0c             	shr    $0xc,%eax
  8010f1:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8010f8:	f6 c2 01             	test   $0x1,%dl
  8010fb:	74 cd                	je     8010ca <fork+0x91>
  8010fd:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801104:	f6 c2 04             	test   $0x4,%dl
  801107:	74 c1                	je     8010ca <fork+0x91>
	void * va = (void *)(pn * PGSIZE);
  801109:	89 c6                	mov    %eax,%esi
  80110b:	c1 e6 0c             	shl    $0xc,%esi
	int perm = (uvpt[pn]);
  80110e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (perm & (PTE_W | PTE_COW)) {
  801115:	a9 02 08 00 00       	test   $0x802,%eax
  80111a:	74 94                	je     8010b0 <fork+0x77>
		r = sys_page_map((envid_t)0, va, envid, va, PTE_U | PTE_P | PTE_COW);
  80111c:	83 ec 0c             	sub    $0xc,%esp
  80111f:	68 05 08 00 00       	push   $0x805
  801124:	56                   	push   %esi
  801125:	57                   	push   %edi
  801126:	56                   	push   %esi
  801127:	6a 00                	push   $0x0
  801129:	e8 20 fc ff ff       	call   800d4e <sys_page_map>
		if(r < 0){
  80112e:	83 c4 20             	add    $0x20,%esp
  801131:	85 c0                	test   %eax,%eax
  801133:	0f 88 65 ff ff ff    	js     80109e <fork+0x65>
		r = sys_page_map((envid_t)0, va, (envid_t)0, va, PTE_U | PTE_P | PTE_COW);
  801139:	83 ec 0c             	sub    $0xc,%esp
  80113c:	68 05 08 00 00       	push   $0x805
  801141:	56                   	push   %esi
  801142:	6a 00                	push   $0x0
  801144:	56                   	push   %esi
  801145:	6a 00                	push   $0x0
  801147:	e8 02 fc ff ff       	call   800d4e <sys_page_map>
		if(r < 0){
  80114c:	83 c4 20             	add    $0x20,%esp
  80114f:	85 c0                	test   %eax,%eax
  801151:	0f 89 73 ff ff ff    	jns    8010ca <fork+0x91>
			panic("sys_page_map: sys_page_map fail, r:%d\n", r);
  801157:	50                   	push   %eax
  801158:	68 34 1c 80 00       	push   $0x801c34
  80115d:	6a 5b                	push   $0x5b
  80115f:	68 97 1b 80 00       	push   $0x801b97
  801164:	e8 e5 02 00 00       	call   80144e <_panic>
			panic("sys_page_map: sys_page_map fail, r:%d\n", r);
  801169:	50                   	push   %eax
  80116a:	68 34 1c 80 00       	push   $0x801c34
  80116f:	6a 61                	push   $0x61
  801171:	68 97 1b 80 00       	push   $0x801b97
  801176:	e8 d3 02 00 00       	call   80144e <_panic>
			duppage(childid, PGNUM(va));
		}
	}

	r = sys_page_alloc(childid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  80117b:	83 ec 04             	sub    $0x4,%esp
  80117e:	6a 07                	push   $0x7
  801180:	68 00 f0 bf ee       	push   $0xeebff000
  801185:	ff 75 e4             	pushl  -0x1c(%ebp)
  801188:	e8 7e fb ff ff       	call   800d0b <sys_page_alloc>
	if (r < 0){
  80118d:	83 c4 10             	add    $0x10,%esp
  801190:	85 c0                	test   %eax,%eax
  801192:	78 36                	js     8011ca <fork+0x191>
		panic("fork: allocate user exception stack for child env error, %d", r);
	}
	r = sys_env_set_pgfault_upcall(childid, _pgfault_upcall);
  801194:	83 ec 08             	sub    $0x8,%esp
  801197:	68 ff 14 80 00       	push   $0x8014ff
  80119c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80119f:	e8 b2 fc ff ff       	call   800e56 <sys_env_set_pgfault_upcall>
	if (r < 0){
  8011a4:	83 c4 10             	add    $0x10,%esp
  8011a7:	85 c0                	test   %eax,%eax
  8011a9:	78 34                	js     8011df <fork+0x1a6>
		panic("fork: sys_env_set_pgfault_upcall error, %d", r);
	}
	r = sys_env_set_status(childid, ENV_RUNNABLE);
  8011ab:	83 ec 08             	sub    $0x8,%esp
  8011ae:	6a 02                	push   $0x2
  8011b0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011b3:	e8 1a fc ff ff       	call   800dd2 <sys_env_set_status>
	if(r < 0){
  8011b8:	83 c4 10             	add    $0x10,%esp
  8011bb:	85 c0                	test   %eax,%eax
  8011bd:	78 35                	js     8011f4 <fork+0x1bb>
		panic("forK: sys_env_set_status, r%d", r);
	}
	return childid;
}
  8011bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011c5:	5b                   	pop    %ebx
  8011c6:	5e                   	pop    %esi
  8011c7:	5f                   	pop    %edi
  8011c8:	5d                   	pop    %ebp
  8011c9:	c3                   	ret    
		panic("fork: allocate user exception stack for child env error, %d", r);
  8011ca:	50                   	push   %eax
  8011cb:	68 5c 1c 80 00       	push   $0x801c5c
  8011d0:	68 96 00 00 00       	push   $0x96
  8011d5:	68 97 1b 80 00       	push   $0x801b97
  8011da:	e8 6f 02 00 00       	call   80144e <_panic>
		panic("fork: sys_env_set_pgfault_upcall error, %d", r);
  8011df:	50                   	push   %eax
  8011e0:	68 98 1c 80 00       	push   $0x801c98
  8011e5:	68 9a 00 00 00       	push   $0x9a
  8011ea:	68 97 1b 80 00       	push   $0x801b97
  8011ef:	e8 5a 02 00 00       	call   80144e <_panic>
		panic("forK: sys_env_set_status, r%d", r);
  8011f4:	50                   	push   %eax
  8011f5:	68 cc 1b 80 00       	push   $0x801bcc
  8011fa:	68 9e 00 00 00       	push   $0x9e
  8011ff:	68 97 1b 80 00       	push   $0x801b97
  801204:	e8 45 02 00 00       	call   80144e <_panic>

00801209 <sfork>:

// Challenge!
int
sfork(void)
{
  801209:	55                   	push   %ebp
  80120a:	89 e5                	mov    %esp,%ebp
  80120c:	57                   	push   %edi
  80120d:	56                   	push   %esi
  80120e:	53                   	push   %ebx
  80120f:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// return -E_INVAL;
	set_pgfault_handler(pgfault);
  801212:	68 3d 0f 80 00       	push   $0x800f3d
  801217:	e8 78 02 00 00       	call   801494 <set_pgfault_handler>
  80121c:	b8 07 00 00 00       	mov    $0x7,%eax
  801221:	cd 30                	int    $0x30
  801223:	89 c6                	mov    %eax,%esi
	int i;
	uintptr_t va;
	envid_t childid = sys_exofork();
	int r;
	if (childid < 0){
  801225:	83 c4 10             	add    $0x10,%esp
  801228:	85 c0                	test   %eax,%eax
  80122a:	78 28                	js     801254 <sfork+0x4b>
  80122c:	89 c7                	mov    %eax,%edi
	}

	extern volatile pde_t uvpd[];
	extern volatile pte_t uvpt[];

	for (va = 0; va < USTACKTOP; va += PGSIZE){
  80122e:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (childid == 0) {
  801233:	75 42                	jne    801277 <sfork+0x6e>
		thisenv = &envs[ENVX(sys_getenvid())];
  801235:	e8 93 fa ff ff       	call   800ccd <sys_getenvid>
  80123a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80123f:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  801245:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80124a:	a3 08 20 80 00       	mov    %eax,0x802008
		return 0;
  80124f:	e9 bc 00 00 00       	jmp    801310 <sfork+0x107>
		panic("fork: child id < 0: %d", childid);
  801254:	50                   	push   %eax
  801255:	68 b5 1b 80 00       	push   $0x801bb5
  80125a:	68 af 00 00 00       	push   $0xaf
  80125f:	68 97 1b 80 00       	push   $0x801b97
  801264:	e8 e5 01 00 00       	call   80144e <_panic>
	for (va = 0; va < USTACKTOP; va += PGSIZE){
  801269:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80126f:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801275:	74 5b                	je     8012d2 <sfork+0xc9>
		if ((uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_U)){
  801277:	89 d8                	mov    %ebx,%eax
  801279:	c1 e8 16             	shr    $0x16,%eax
  80127c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801283:	a8 01                	test   $0x1,%al
  801285:	74 e2                	je     801269 <sfork+0x60>
  801287:	89 d8                	mov    %ebx,%eax
  801289:	c1 e8 0c             	shr    $0xc,%eax
  80128c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801293:	f6 c2 01             	test   $0x1,%dl
  801296:	74 d1                	je     801269 <sfork+0x60>
  801298:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80129f:	f6 c2 04             	test   $0x4,%dl
  8012a2:	74 c5                	je     801269 <sfork+0x60>
			void *addr = (void *)(PGNUM(va) * PGSIZE);
  8012a4:	c1 e0 0c             	shl    $0xc,%eax
			struct PageInfo *page;
			pte_t *pte;
			
			// page = page_lookup((envid_t)0->env_pgdir, addr, &pte);
			// page_insert(dstenv->env_pgdir, page, addr, PTE_U | PTE_P);
			r = sys_page_map((envid_t)0, addr, childid, addr, PTE_U | PTE_P);
  8012a7:	83 ec 0c             	sub    $0xc,%esp
  8012aa:	6a 05                	push   $0x5
  8012ac:	50                   	push   %eax
  8012ad:	57                   	push   %edi
  8012ae:	50                   	push   %eax
  8012af:	6a 00                	push   $0x0
  8012b1:	e8 98 fa ff ff       	call   800d4e <sys_page_map>
			if(r < 0){
  8012b6:	83 c4 20             	add    $0x20,%esp
  8012b9:	85 c0                	test   %eax,%eax
  8012bb:	79 ac                	jns    801269 <sfork+0x60>
				panic("sfork: sys_page_map fail, r:%d\n", r);
  8012bd:	50                   	push   %eax
  8012be:	68 c4 1c 80 00       	push   $0x801cc4
  8012c3:	68 c4 00 00 00       	push   $0xc4
  8012c8:	68 97 1b 80 00       	push   $0x801b97
  8012cd:	e8 7c 01 00 00       	call   80144e <_panic>
			}
		}
	}

	r = sys_page_alloc(childid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8012d2:	83 ec 04             	sub    $0x4,%esp
  8012d5:	6a 07                	push   $0x7
  8012d7:	68 00 f0 bf ee       	push   $0xeebff000
  8012dc:	56                   	push   %esi
  8012dd:	e8 29 fa ff ff       	call   800d0b <sys_page_alloc>
	if (r < 0){
  8012e2:	83 c4 10             	add    $0x10,%esp
  8012e5:	85 c0                	test   %eax,%eax
  8012e7:	78 31                	js     80131a <sfork+0x111>
		panic("sfork: allocate user exception stack for child env error, %d", r);
	}
	r = sys_env_set_pgfault_upcall(childid, _pgfault_upcall);
  8012e9:	83 ec 08             	sub    $0x8,%esp
  8012ec:	68 ff 14 80 00       	push   $0x8014ff
  8012f1:	56                   	push   %esi
  8012f2:	e8 5f fb ff ff       	call   800e56 <sys_env_set_pgfault_upcall>
	if (r < 0){
  8012f7:	83 c4 10             	add    $0x10,%esp
  8012fa:	85 c0                	test   %eax,%eax
  8012fc:	78 31                	js     80132f <sfork+0x126>
		panic("sfork: sys_env_set_pgfault_upcall error, %d", r);
	}
	r = sys_env_set_status(childid, ENV_RUNNABLE);
  8012fe:	83 ec 08             	sub    $0x8,%esp
  801301:	6a 02                	push   $0x2
  801303:	56                   	push   %esi
  801304:	e8 c9 fa ff ff       	call   800dd2 <sys_env_set_status>
	if(r < 0){
  801309:	83 c4 10             	add    $0x10,%esp
  80130c:	85 c0                	test   %eax,%eax
  80130e:	78 34                	js     801344 <sfork+0x13b>
		panic("sforK: sys_env_set_status, r%d", r);
	}
	return childid;
}
  801310:	89 f0                	mov    %esi,%eax
  801312:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801315:	5b                   	pop    %ebx
  801316:	5e                   	pop    %esi
  801317:	5f                   	pop    %edi
  801318:	5d                   	pop    %ebp
  801319:	c3                   	ret    
		panic("sfork: allocate user exception stack for child env error, %d", r);
  80131a:	50                   	push   %eax
  80131b:	68 e4 1c 80 00       	push   $0x801ce4
  801320:	68 cb 00 00 00       	push   $0xcb
  801325:	68 97 1b 80 00       	push   $0x801b97
  80132a:	e8 1f 01 00 00       	call   80144e <_panic>
		panic("sfork: sys_env_set_pgfault_upcall error, %d", r);
  80132f:	50                   	push   %eax
  801330:	68 24 1d 80 00       	push   $0x801d24
  801335:	68 cf 00 00 00       	push   $0xcf
  80133a:	68 97 1b 80 00       	push   $0x801b97
  80133f:	e8 0a 01 00 00       	call   80144e <_panic>
		panic("sforK: sys_env_set_status, r%d", r);
  801344:	50                   	push   %eax
  801345:	68 50 1d 80 00       	push   $0x801d50
  80134a:	68 d3 00 00 00       	push   $0xd3
  80134f:	68 97 1b 80 00       	push   $0x801b97
  801354:	e8 f5 00 00 00       	call   80144e <_panic>

00801359 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801359:	55                   	push   %ebp
  80135a:	89 e5                	mov    %esp,%ebp
  80135c:	56                   	push   %esi
  80135d:	53                   	push   %ebx
  80135e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801361:	8b 45 0c             	mov    0xc(%ebp),%eax
  801364:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// return 0;
	if(!pg)
  801367:	85 c0                	test   %eax,%eax
		pg = (void*)UTOP;
  801369:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80136e:	0f 44 c2             	cmove  %edx,%eax
	
	int ret;

	ret = sys_ipc_recv(pg);
  801371:	83 ec 0c             	sub    $0xc,%esp
  801374:	50                   	push   %eax
  801375:	e8 41 fb ff ff       	call   800ebb <sys_ipc_recv>
	if(ret < 0){
  80137a:	83 c4 10             	add    $0x10,%esp
  80137d:	85 c0                	test   %eax,%eax
  80137f:	78 2b                	js     8013ac <ipc_recv+0x53>
		if(perm_store) *perm_store = 0;
		if(from_env_store) *from_env_store = 0;
		return ret;
	}
	
	if(perm_store)
  801381:	85 f6                	test   %esi,%esi
  801383:	74 0a                	je     80138f <ipc_recv+0x36>
		*perm_store = thisenv->env_ipc_perm;
  801385:	a1 08 20 80 00       	mov    0x802008,%eax
  80138a:	8b 40 78             	mov    0x78(%eax),%eax
  80138d:	89 06                	mov    %eax,(%esi)
	if(from_env_store)
  80138f:	85 db                	test   %ebx,%ebx
  801391:	74 0a                	je     80139d <ipc_recv+0x44>
		*from_env_store = thisenv->env_ipc_from;
  801393:	a1 08 20 80 00       	mov    0x802008,%eax
  801398:	8b 40 74             	mov    0x74(%eax),%eax
  80139b:	89 03                	mov    %eax,(%ebx)

	return thisenv->env_ipc_value;
  80139d:	a1 08 20 80 00       	mov    0x802008,%eax
  8013a2:	8b 40 70             	mov    0x70(%eax),%eax
}
  8013a5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013a8:	5b                   	pop    %ebx
  8013a9:	5e                   	pop    %esi
  8013aa:	5d                   	pop    %ebp
  8013ab:	c3                   	ret    
		if(perm_store) *perm_store = 0;
  8013ac:	85 f6                	test   %esi,%esi
  8013ae:	74 06                	je     8013b6 <ipc_recv+0x5d>
  8013b0:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(from_env_store) *from_env_store = 0;
  8013b6:	85 db                	test   %ebx,%ebx
  8013b8:	74 eb                	je     8013a5 <ipc_recv+0x4c>
  8013ba:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8013c0:	eb e3                	jmp    8013a5 <ipc_recv+0x4c>

008013c2 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8013c2:	55                   	push   %ebp
  8013c3:	89 e5                	mov    %esp,%ebp
  8013c5:	57                   	push   %edi
  8013c6:	56                   	push   %esi
  8013c7:	53                   	push   %ebx
  8013c8:	83 ec 0c             	sub    $0xc,%esp
  8013cb:	8b 7d 08             	mov    0x8(%ebp),%edi
  8013ce:	8b 75 0c             	mov    0xc(%ebp),%esi
  8013d1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
	if (!pg)
  8013d4:	85 db                	test   %ebx,%ebx
		pg = (void*)UTOP;
  8013d6:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8013db:	0f 44 d8             	cmove  %eax,%ebx

	int ret = -E_IPC_NOT_RECV;
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))) {
  8013de:	ff 75 14             	pushl  0x14(%ebp)
  8013e1:	53                   	push   %ebx
  8013e2:	56                   	push   %esi
  8013e3:	57                   	push   %edi
  8013e4:	e8 af fa ff ff       	call   800e98 <sys_ipc_try_send>
  8013e9:	83 c4 10             	add    $0x10,%esp
  8013ec:	85 c0                	test   %eax,%eax
  8013ee:	74 17                	je     801407 <ipc_send+0x45>
		if(ret != -E_IPC_NOT_RECV){
  8013f0:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8013f3:	74 e9                	je     8013de <ipc_send+0x1c>
			panic("ipc_send: ret : %d", ret);
  8013f5:	50                   	push   %eax
  8013f6:	68 6f 1d 80 00       	push   $0x801d6f
  8013fb:	6a 43                	push   $0x43
  8013fd:	68 82 1d 80 00       	push   $0x801d82
  801402:	e8 47 00 00 00       	call   80144e <_panic>
			sys_yield();
		}
	}
}
  801407:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80140a:	5b                   	pop    %ebx
  80140b:	5e                   	pop    %esi
  80140c:	5f                   	pop    %edi
  80140d:	5d                   	pop    %ebp
  80140e:	c3                   	ret    

0080140f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80140f:	55                   	push   %ebp
  801410:	89 e5                	mov    %esp,%ebp
  801412:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801415:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80141a:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  801420:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801426:	8b 52 50             	mov    0x50(%edx),%edx
  801429:	39 ca                	cmp    %ecx,%edx
  80142b:	74 11                	je     80143e <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  80142d:	83 c0 01             	add    $0x1,%eax
  801430:	3d 00 04 00 00       	cmp    $0x400,%eax
  801435:	75 e3                	jne    80141a <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801437:	b8 00 00 00 00       	mov    $0x0,%eax
  80143c:	eb 0e                	jmp    80144c <ipc_find_env+0x3d>
			return envs[i].env_id;
  80143e:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  801444:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801449:	8b 40 48             	mov    0x48(%eax),%eax
}
  80144c:	5d                   	pop    %ebp
  80144d:	c3                   	ret    

0080144e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80144e:	55                   	push   %ebp
  80144f:	89 e5                	mov    %esp,%ebp
  801451:	56                   	push   %esi
  801452:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801453:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801456:	8b 35 00 20 80 00    	mov    0x802000,%esi
  80145c:	e8 6c f8 ff ff       	call   800ccd <sys_getenvid>
  801461:	83 ec 0c             	sub    $0xc,%esp
  801464:	ff 75 0c             	pushl  0xc(%ebp)
  801467:	ff 75 08             	pushl  0x8(%ebp)
  80146a:	56                   	push   %esi
  80146b:	50                   	push   %eax
  80146c:	68 8c 1d 80 00       	push   $0x801d8c
  801471:	e8 7d ed ff ff       	call   8001f3 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801476:	83 c4 18             	add    $0x18,%esp
  801479:	53                   	push   %ebx
  80147a:	ff 75 10             	pushl  0x10(%ebp)
  80147d:	e8 20 ed ff ff       	call   8001a2 <vcprintf>
	cprintf("\n");
  801482:	c7 04 24 95 1b 80 00 	movl   $0x801b95,(%esp)
  801489:	e8 65 ed ff ff       	call   8001f3 <cprintf>
  80148e:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801491:	cc                   	int3   
  801492:	eb fd                	jmp    801491 <_panic+0x43>

00801494 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801494:	55                   	push   %ebp
  801495:	89 e5                	mov    %esp,%ebp
  801497:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80149a:	83 3d 0c 20 80 00 00 	cmpl   $0x0,0x80200c
  8014a1:	74 0a                	je     8014ad <set_pgfault_handler+0x19>
			panic("set_pgfault_handler: sys_env_set_pgfault_upcall fail, ret:%d", ret);
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8014a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a6:	a3 0c 20 80 00       	mov    %eax,0x80200c
}
  8014ab:	c9                   	leave  
  8014ac:	c3                   	ret    
		ret = sys_page_alloc((envid_t)0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W);
  8014ad:	83 ec 04             	sub    $0x4,%esp
  8014b0:	6a 07                	push   $0x7
  8014b2:	68 00 f0 bf ee       	push   $0xeebff000
  8014b7:	6a 00                	push   $0x0
  8014b9:	e8 4d f8 ff ff       	call   800d0b <sys_page_alloc>
		if(ret < 0){
  8014be:	83 c4 10             	add    $0x10,%esp
  8014c1:	85 c0                	test   %eax,%eax
  8014c3:	78 28                	js     8014ed <set_pgfault_handler+0x59>
    	ret = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  8014c5:	83 ec 08             	sub    $0x8,%esp
  8014c8:	68 ff 14 80 00       	push   $0x8014ff
  8014cd:	6a 00                	push   $0x0
  8014cf:	e8 82 f9 ff ff       	call   800e56 <sys_env_set_pgfault_upcall>
		if(ret < 0){
  8014d4:	83 c4 10             	add    $0x10,%esp
  8014d7:	85 c0                	test   %eax,%eax
  8014d9:	79 c8                	jns    8014a3 <set_pgfault_handler+0xf>
			panic("set_pgfault_handler: sys_env_set_pgfault_upcall fail, ret:%d", ret);
  8014db:	50                   	push   %eax
  8014dc:	68 e4 1d 80 00       	push   $0x801de4
  8014e1:	6a 28                	push   $0x28
  8014e3:	68 24 1e 80 00       	push   $0x801e24
  8014e8:	e8 61 ff ff ff       	call   80144e <_panic>
			panic("set_pgfault_handler: sys_page_alloc fail, ret:%d", ret);
  8014ed:	50                   	push   %eax
  8014ee:	68 b0 1d 80 00       	push   $0x801db0
  8014f3:	6a 24                	push   $0x24
  8014f5:	68 24 1e 80 00       	push   $0x801e24
  8014fa:	e8 4f ff ff ff       	call   80144e <_panic>

008014ff <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8014ff:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801500:	a1 0c 20 80 00       	mov    0x80200c,%eax
	call *%eax
  801505:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801507:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %edi
  80150a:	8b 7c 24 28          	mov    0x28(%esp),%edi
	movl 0x30(%esp), %esi
  80150e:	8b 74 24 30          	mov    0x30(%esp),%esi
	subl $4, %esi
  801512:	83 ee 04             	sub    $0x4,%esi
	movl %edi, (%esi)
  801515:	89 3e                	mov    %edi,(%esi)
	movl %esi, 0x30(%esp)
  801517:	89 74 24 30          	mov    %esi,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  80151b:	83 c4 08             	add    $0x8,%esp
	popal
  80151e:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  80151f:	83 c4 04             	add    $0x4,%esp
	popfl
  801522:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  801523:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  801524:	c3                   	ret    
  801525:	66 90                	xchg   %ax,%ax
  801527:	66 90                	xchg   %ax,%ax
  801529:	66 90                	xchg   %ax,%ax
  80152b:	66 90                	xchg   %ax,%ax
  80152d:	66 90                	xchg   %ax,%ax
  80152f:	90                   	nop

00801530 <__udivdi3>:
  801530:	55                   	push   %ebp
  801531:	57                   	push   %edi
  801532:	56                   	push   %esi
  801533:	53                   	push   %ebx
  801534:	83 ec 1c             	sub    $0x1c,%esp
  801537:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80153b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80153f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801543:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801547:	85 d2                	test   %edx,%edx
  801549:	75 4d                	jne    801598 <__udivdi3+0x68>
  80154b:	39 f3                	cmp    %esi,%ebx
  80154d:	76 19                	jbe    801568 <__udivdi3+0x38>
  80154f:	31 ff                	xor    %edi,%edi
  801551:	89 e8                	mov    %ebp,%eax
  801553:	89 f2                	mov    %esi,%edx
  801555:	f7 f3                	div    %ebx
  801557:	89 fa                	mov    %edi,%edx
  801559:	83 c4 1c             	add    $0x1c,%esp
  80155c:	5b                   	pop    %ebx
  80155d:	5e                   	pop    %esi
  80155e:	5f                   	pop    %edi
  80155f:	5d                   	pop    %ebp
  801560:	c3                   	ret    
  801561:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801568:	89 d9                	mov    %ebx,%ecx
  80156a:	85 db                	test   %ebx,%ebx
  80156c:	75 0b                	jne    801579 <__udivdi3+0x49>
  80156e:	b8 01 00 00 00       	mov    $0x1,%eax
  801573:	31 d2                	xor    %edx,%edx
  801575:	f7 f3                	div    %ebx
  801577:	89 c1                	mov    %eax,%ecx
  801579:	31 d2                	xor    %edx,%edx
  80157b:	89 f0                	mov    %esi,%eax
  80157d:	f7 f1                	div    %ecx
  80157f:	89 c6                	mov    %eax,%esi
  801581:	89 e8                	mov    %ebp,%eax
  801583:	89 f7                	mov    %esi,%edi
  801585:	f7 f1                	div    %ecx
  801587:	89 fa                	mov    %edi,%edx
  801589:	83 c4 1c             	add    $0x1c,%esp
  80158c:	5b                   	pop    %ebx
  80158d:	5e                   	pop    %esi
  80158e:	5f                   	pop    %edi
  80158f:	5d                   	pop    %ebp
  801590:	c3                   	ret    
  801591:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801598:	39 f2                	cmp    %esi,%edx
  80159a:	77 1c                	ja     8015b8 <__udivdi3+0x88>
  80159c:	0f bd fa             	bsr    %edx,%edi
  80159f:	83 f7 1f             	xor    $0x1f,%edi
  8015a2:	75 2c                	jne    8015d0 <__udivdi3+0xa0>
  8015a4:	39 f2                	cmp    %esi,%edx
  8015a6:	72 06                	jb     8015ae <__udivdi3+0x7e>
  8015a8:	31 c0                	xor    %eax,%eax
  8015aa:	39 eb                	cmp    %ebp,%ebx
  8015ac:	77 a9                	ja     801557 <__udivdi3+0x27>
  8015ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8015b3:	eb a2                	jmp    801557 <__udivdi3+0x27>
  8015b5:	8d 76 00             	lea    0x0(%esi),%esi
  8015b8:	31 ff                	xor    %edi,%edi
  8015ba:	31 c0                	xor    %eax,%eax
  8015bc:	89 fa                	mov    %edi,%edx
  8015be:	83 c4 1c             	add    $0x1c,%esp
  8015c1:	5b                   	pop    %ebx
  8015c2:	5e                   	pop    %esi
  8015c3:	5f                   	pop    %edi
  8015c4:	5d                   	pop    %ebp
  8015c5:	c3                   	ret    
  8015c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8015cd:	8d 76 00             	lea    0x0(%esi),%esi
  8015d0:	89 f9                	mov    %edi,%ecx
  8015d2:	b8 20 00 00 00       	mov    $0x20,%eax
  8015d7:	29 f8                	sub    %edi,%eax
  8015d9:	d3 e2                	shl    %cl,%edx
  8015db:	89 54 24 08          	mov    %edx,0x8(%esp)
  8015df:	89 c1                	mov    %eax,%ecx
  8015e1:	89 da                	mov    %ebx,%edx
  8015e3:	d3 ea                	shr    %cl,%edx
  8015e5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8015e9:	09 d1                	or     %edx,%ecx
  8015eb:	89 f2                	mov    %esi,%edx
  8015ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8015f1:	89 f9                	mov    %edi,%ecx
  8015f3:	d3 e3                	shl    %cl,%ebx
  8015f5:	89 c1                	mov    %eax,%ecx
  8015f7:	d3 ea                	shr    %cl,%edx
  8015f9:	89 f9                	mov    %edi,%ecx
  8015fb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8015ff:	89 eb                	mov    %ebp,%ebx
  801601:	d3 e6                	shl    %cl,%esi
  801603:	89 c1                	mov    %eax,%ecx
  801605:	d3 eb                	shr    %cl,%ebx
  801607:	09 de                	or     %ebx,%esi
  801609:	89 f0                	mov    %esi,%eax
  80160b:	f7 74 24 08          	divl   0x8(%esp)
  80160f:	89 d6                	mov    %edx,%esi
  801611:	89 c3                	mov    %eax,%ebx
  801613:	f7 64 24 0c          	mull   0xc(%esp)
  801617:	39 d6                	cmp    %edx,%esi
  801619:	72 15                	jb     801630 <__udivdi3+0x100>
  80161b:	89 f9                	mov    %edi,%ecx
  80161d:	d3 e5                	shl    %cl,%ebp
  80161f:	39 c5                	cmp    %eax,%ebp
  801621:	73 04                	jae    801627 <__udivdi3+0xf7>
  801623:	39 d6                	cmp    %edx,%esi
  801625:	74 09                	je     801630 <__udivdi3+0x100>
  801627:	89 d8                	mov    %ebx,%eax
  801629:	31 ff                	xor    %edi,%edi
  80162b:	e9 27 ff ff ff       	jmp    801557 <__udivdi3+0x27>
  801630:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801633:	31 ff                	xor    %edi,%edi
  801635:	e9 1d ff ff ff       	jmp    801557 <__udivdi3+0x27>
  80163a:	66 90                	xchg   %ax,%ax
  80163c:	66 90                	xchg   %ax,%ax
  80163e:	66 90                	xchg   %ax,%ax

00801640 <__umoddi3>:
  801640:	55                   	push   %ebp
  801641:	57                   	push   %edi
  801642:	56                   	push   %esi
  801643:	53                   	push   %ebx
  801644:	83 ec 1c             	sub    $0x1c,%esp
  801647:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80164b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80164f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801653:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801657:	89 da                	mov    %ebx,%edx
  801659:	85 c0                	test   %eax,%eax
  80165b:	75 43                	jne    8016a0 <__umoddi3+0x60>
  80165d:	39 df                	cmp    %ebx,%edi
  80165f:	76 17                	jbe    801678 <__umoddi3+0x38>
  801661:	89 f0                	mov    %esi,%eax
  801663:	f7 f7                	div    %edi
  801665:	89 d0                	mov    %edx,%eax
  801667:	31 d2                	xor    %edx,%edx
  801669:	83 c4 1c             	add    $0x1c,%esp
  80166c:	5b                   	pop    %ebx
  80166d:	5e                   	pop    %esi
  80166e:	5f                   	pop    %edi
  80166f:	5d                   	pop    %ebp
  801670:	c3                   	ret    
  801671:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801678:	89 fd                	mov    %edi,%ebp
  80167a:	85 ff                	test   %edi,%edi
  80167c:	75 0b                	jne    801689 <__umoddi3+0x49>
  80167e:	b8 01 00 00 00       	mov    $0x1,%eax
  801683:	31 d2                	xor    %edx,%edx
  801685:	f7 f7                	div    %edi
  801687:	89 c5                	mov    %eax,%ebp
  801689:	89 d8                	mov    %ebx,%eax
  80168b:	31 d2                	xor    %edx,%edx
  80168d:	f7 f5                	div    %ebp
  80168f:	89 f0                	mov    %esi,%eax
  801691:	f7 f5                	div    %ebp
  801693:	89 d0                	mov    %edx,%eax
  801695:	eb d0                	jmp    801667 <__umoddi3+0x27>
  801697:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80169e:	66 90                	xchg   %ax,%ax
  8016a0:	89 f1                	mov    %esi,%ecx
  8016a2:	39 d8                	cmp    %ebx,%eax
  8016a4:	76 0a                	jbe    8016b0 <__umoddi3+0x70>
  8016a6:	89 f0                	mov    %esi,%eax
  8016a8:	83 c4 1c             	add    $0x1c,%esp
  8016ab:	5b                   	pop    %ebx
  8016ac:	5e                   	pop    %esi
  8016ad:	5f                   	pop    %edi
  8016ae:	5d                   	pop    %ebp
  8016af:	c3                   	ret    
  8016b0:	0f bd e8             	bsr    %eax,%ebp
  8016b3:	83 f5 1f             	xor    $0x1f,%ebp
  8016b6:	75 20                	jne    8016d8 <__umoddi3+0x98>
  8016b8:	39 d8                	cmp    %ebx,%eax
  8016ba:	0f 82 b0 00 00 00    	jb     801770 <__umoddi3+0x130>
  8016c0:	39 f7                	cmp    %esi,%edi
  8016c2:	0f 86 a8 00 00 00    	jbe    801770 <__umoddi3+0x130>
  8016c8:	89 c8                	mov    %ecx,%eax
  8016ca:	83 c4 1c             	add    $0x1c,%esp
  8016cd:	5b                   	pop    %ebx
  8016ce:	5e                   	pop    %esi
  8016cf:	5f                   	pop    %edi
  8016d0:	5d                   	pop    %ebp
  8016d1:	c3                   	ret    
  8016d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8016d8:	89 e9                	mov    %ebp,%ecx
  8016da:	ba 20 00 00 00       	mov    $0x20,%edx
  8016df:	29 ea                	sub    %ebp,%edx
  8016e1:	d3 e0                	shl    %cl,%eax
  8016e3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8016e7:	89 d1                	mov    %edx,%ecx
  8016e9:	89 f8                	mov    %edi,%eax
  8016eb:	d3 e8                	shr    %cl,%eax
  8016ed:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8016f1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8016f5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8016f9:	09 c1                	or     %eax,%ecx
  8016fb:	89 d8                	mov    %ebx,%eax
  8016fd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801701:	89 e9                	mov    %ebp,%ecx
  801703:	d3 e7                	shl    %cl,%edi
  801705:	89 d1                	mov    %edx,%ecx
  801707:	d3 e8                	shr    %cl,%eax
  801709:	89 e9                	mov    %ebp,%ecx
  80170b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80170f:	d3 e3                	shl    %cl,%ebx
  801711:	89 c7                	mov    %eax,%edi
  801713:	89 d1                	mov    %edx,%ecx
  801715:	89 f0                	mov    %esi,%eax
  801717:	d3 e8                	shr    %cl,%eax
  801719:	89 e9                	mov    %ebp,%ecx
  80171b:	89 fa                	mov    %edi,%edx
  80171d:	d3 e6                	shl    %cl,%esi
  80171f:	09 d8                	or     %ebx,%eax
  801721:	f7 74 24 08          	divl   0x8(%esp)
  801725:	89 d1                	mov    %edx,%ecx
  801727:	89 f3                	mov    %esi,%ebx
  801729:	f7 64 24 0c          	mull   0xc(%esp)
  80172d:	89 c6                	mov    %eax,%esi
  80172f:	89 d7                	mov    %edx,%edi
  801731:	39 d1                	cmp    %edx,%ecx
  801733:	72 06                	jb     80173b <__umoddi3+0xfb>
  801735:	75 10                	jne    801747 <__umoddi3+0x107>
  801737:	39 c3                	cmp    %eax,%ebx
  801739:	73 0c                	jae    801747 <__umoddi3+0x107>
  80173b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80173f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801743:	89 d7                	mov    %edx,%edi
  801745:	89 c6                	mov    %eax,%esi
  801747:	89 ca                	mov    %ecx,%edx
  801749:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80174e:	29 f3                	sub    %esi,%ebx
  801750:	19 fa                	sbb    %edi,%edx
  801752:	89 d0                	mov    %edx,%eax
  801754:	d3 e0                	shl    %cl,%eax
  801756:	89 e9                	mov    %ebp,%ecx
  801758:	d3 eb                	shr    %cl,%ebx
  80175a:	d3 ea                	shr    %cl,%edx
  80175c:	09 d8                	or     %ebx,%eax
  80175e:	83 c4 1c             	add    $0x1c,%esp
  801761:	5b                   	pop    %ebx
  801762:	5e                   	pop    %esi
  801763:	5f                   	pop    %edi
  801764:	5d                   	pop    %ebp
  801765:	c3                   	ret    
  801766:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80176d:	8d 76 00             	lea    0x0(%esi),%esi
  801770:	89 da                	mov    %ebx,%edx
  801772:	29 fe                	sub    %edi,%esi
  801774:	19 c2                	sbb    %eax,%edx
  801776:	89 f1                	mov    %esi,%ecx
  801778:	89 c8                	mov    %ecx,%eax
  80177a:	e9 4b ff ff ff       	jmp    8016ca <__umoddi3+0x8a>
