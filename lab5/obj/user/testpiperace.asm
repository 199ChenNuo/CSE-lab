
obj/user/testpiperace.debug:     file format elf32-i386


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
  80002c:	e8 d0 01 00 00       	call   800201 <libmain>
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
  800038:	83 ec 1c             	sub    $0x1c,%esp
	int p[2], r, pid, i, max;
	void *va;
	struct Fd *fd;
	const volatile struct Env *kid;

	cprintf("testing for dup race...\n");
  80003b:	68 40 25 80 00       	push   $0x802540
  800040:	e8 f2 02 00 00       	call   800337 <cprintf>
	if ((r = pipe(p)) < 0)
  800045:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800048:	89 04 24             	mov    %eax,(%esp)
  80004b:	e8 0e 1f 00 00       	call   801f5e <pipe>
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	85 c0                	test   %eax,%eax
  800055:	0f 88 80 00 00 00    	js     8000db <umain+0xa8>
		panic("pipe: %e", r);
	max = 200;
	if ((r = fork()) < 0)
  80005b:	e8 1d 11 00 00       	call   80117d <fork>
  800060:	89 c6                	mov    %eax,%esi
  800062:	85 c0                	test   %eax,%eax
  800064:	0f 88 83 00 00 00    	js     8000ed <umain+0xba>
		panic("fork: %e", r);
	if (r == 0) {
  80006a:	0f 84 8f 00 00 00    	je     8000ff <umain+0xcc>
		}
		// do something to be not runnable besides exiting
		ipc_recv(0,0,0);
	}
	pid = r;
	cprintf("pid is %d\n", pid);
  800070:	83 ec 08             	sub    $0x8,%esp
  800073:	56                   	push   %esi
  800074:	68 9a 25 80 00       	push   $0x80259a
  800079:	e8 b9 02 00 00       	call   800337 <cprintf>
	va = 0;
	kid = &envs[ENVX(pid)];
  80007e:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
	cprintf("kid is %d\n", kid-envs);
  800084:	83 c4 08             	add    $0x8,%esp
  800087:	69 c6 84 00 00 00    	imul   $0x84,%esi,%eax
  80008d:	c1 f8 02             	sar    $0x2,%eax
  800090:	69 c0 e1 83 0f 3e    	imul   $0x3e0f83e1,%eax,%eax
  800096:	50                   	push   %eax
  800097:	68 a5 25 80 00       	push   $0x8025a5
  80009c:	e8 96 02 00 00       	call   800337 <cprintf>
	dup(p[0], 10);
  8000a1:	83 c4 08             	add    $0x8,%esp
  8000a4:	6a 0a                	push   $0xa
  8000a6:	ff 75 f0             	pushl  -0x10(%ebp)
  8000a9:	e8 dc 16 00 00       	call   80178a <dup>
	while (kid->env_status == ENV_RUNNABLE)
  8000ae:	83 c4 10             	add    $0x10,%esp
  8000b1:	69 de 84 00 00 00    	imul   $0x84,%esi,%ebx
  8000b7:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8000bd:	8b 53 54             	mov    0x54(%ebx),%edx
  8000c0:	83 fa 02             	cmp    $0x2,%edx
  8000c3:	0f 85 94 00 00 00    	jne    80015d <umain+0x12a>
		dup(p[0], 10);
  8000c9:	83 ec 08             	sub    $0x8,%esp
  8000cc:	6a 0a                	push   $0xa
  8000ce:	ff 75 f0             	pushl  -0x10(%ebp)
  8000d1:	e8 b4 16 00 00       	call   80178a <dup>
  8000d6:	83 c4 10             	add    $0x10,%esp
  8000d9:	eb e2                	jmp    8000bd <umain+0x8a>
		panic("pipe: %e", r);
  8000db:	50                   	push   %eax
  8000dc:	68 59 25 80 00       	push   $0x802559
  8000e1:	6a 0d                	push   $0xd
  8000e3:	68 62 25 80 00       	push   $0x802562
  8000e8:	e8 6f 01 00 00       	call   80025c <_panic>
		panic("fork: %e", r);
  8000ed:	50                   	push   %eax
  8000ee:	68 76 25 80 00       	push   $0x802576
  8000f3:	6a 10                	push   $0x10
  8000f5:	68 62 25 80 00       	push   $0x802562
  8000fa:	e8 5d 01 00 00       	call   80025c <_panic>
		close(p[1]);
  8000ff:	83 ec 0c             	sub    $0xc,%esp
  800102:	ff 75 f4             	pushl  -0xc(%ebp)
  800105:	e8 2e 16 00 00       	call   801738 <close>
  80010a:	83 c4 10             	add    $0x10,%esp
  80010d:	bb c8 00 00 00       	mov    $0xc8,%ebx
  800112:	eb 1f                	jmp    800133 <umain+0x100>
				cprintf("RACE: pipe appears closed\n");
  800114:	83 ec 0c             	sub    $0xc,%esp
  800117:	68 7f 25 80 00       	push   $0x80257f
  80011c:	e8 16 02 00 00       	call   800337 <cprintf>
				exit();
  800121:	e8 24 01 00 00       	call   80024a <exit>
  800126:	83 c4 10             	add    $0x10,%esp
			sys_yield();
  800129:	e8 02 0d 00 00       	call   800e30 <sys_yield>
		for (i=0; i<max; i++) {
  80012e:	83 eb 01             	sub    $0x1,%ebx
  800131:	74 14                	je     800147 <umain+0x114>
			if(pipeisclosed(p[0])){
  800133:	83 ec 0c             	sub    $0xc,%esp
  800136:	ff 75 f0             	pushl  -0x10(%ebp)
  800139:	e8 6a 1f 00 00       	call   8020a8 <pipeisclosed>
  80013e:	83 c4 10             	add    $0x10,%esp
  800141:	85 c0                	test   %eax,%eax
  800143:	74 e4                	je     800129 <umain+0xf6>
  800145:	eb cd                	jmp    800114 <umain+0xe1>
		ipc_recv(0,0,0);
  800147:	83 ec 04             	sub    $0x4,%esp
  80014a:	6a 00                	push   $0x0
  80014c:	6a 00                	push   $0x0
  80014e:	6a 00                	push   $0x0
  800150:	e8 48 13 00 00       	call   80149d <ipc_recv>
  800155:	83 c4 10             	add    $0x10,%esp
  800158:	e9 13 ff ff ff       	jmp    800070 <umain+0x3d>

	cprintf("child done with loop\n");
  80015d:	83 ec 0c             	sub    $0xc,%esp
  800160:	68 b0 25 80 00       	push   $0x8025b0
  800165:	e8 cd 01 00 00       	call   800337 <cprintf>
	if (pipeisclosed(p[0]))
  80016a:	83 c4 04             	add    $0x4,%esp
  80016d:	ff 75 f0             	pushl  -0x10(%ebp)
  800170:	e8 33 1f 00 00       	call   8020a8 <pipeisclosed>
  800175:	83 c4 10             	add    $0x10,%esp
  800178:	85 c0                	test   %eax,%eax
  80017a:	75 48                	jne    8001c4 <umain+0x191>
		panic("somehow the other end of p[0] got closed!");
	if ((r = fd_lookup(p[0], &fd)) < 0)
  80017c:	83 ec 08             	sub    $0x8,%esp
  80017f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800182:	50                   	push   %eax
  800183:	ff 75 f0             	pushl  -0x10(%ebp)
  800186:	e8 80 14 00 00       	call   80160b <fd_lookup>
  80018b:	83 c4 10             	add    $0x10,%esp
  80018e:	85 c0                	test   %eax,%eax
  800190:	78 46                	js     8001d8 <umain+0x1a5>
		panic("cannot look up p[0]: %e", r);
	va = fd2data(fd);
  800192:	83 ec 0c             	sub    $0xc,%esp
  800195:	ff 75 ec             	pushl  -0x14(%ebp)
  800198:	e8 05 14 00 00       	call   8015a2 <fd2data>
	if (pageref(va) != 3+1)
  80019d:	89 04 24             	mov    %eax,(%esp)
  8001a0:	e8 ad 1b 00 00       	call   801d52 <pageref>
  8001a5:	83 c4 10             	add    $0x10,%esp
  8001a8:	83 f8 04             	cmp    $0x4,%eax
  8001ab:	74 3d                	je     8001ea <umain+0x1b7>
		cprintf("\nchild detected race\n");
  8001ad:	83 ec 0c             	sub    $0xc,%esp
  8001b0:	68 de 25 80 00       	push   $0x8025de
  8001b5:	e8 7d 01 00 00       	call   800337 <cprintf>
  8001ba:	83 c4 10             	add    $0x10,%esp
	else
		cprintf("\nrace didn't happen\n", max);
}
  8001bd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001c0:	5b                   	pop    %ebx
  8001c1:	5e                   	pop    %esi
  8001c2:	5d                   	pop    %ebp
  8001c3:	c3                   	ret    
		panic("somehow the other end of p[0] got closed!");
  8001c4:	83 ec 04             	sub    $0x4,%esp
  8001c7:	68 0c 26 80 00       	push   $0x80260c
  8001cc:	6a 3a                	push   $0x3a
  8001ce:	68 62 25 80 00       	push   $0x802562
  8001d3:	e8 84 00 00 00       	call   80025c <_panic>
		panic("cannot look up p[0]: %e", r);
  8001d8:	50                   	push   %eax
  8001d9:	68 c6 25 80 00       	push   $0x8025c6
  8001de:	6a 3c                	push   $0x3c
  8001e0:	68 62 25 80 00       	push   $0x802562
  8001e5:	e8 72 00 00 00       	call   80025c <_panic>
		cprintf("\nrace didn't happen\n", max);
  8001ea:	83 ec 08             	sub    $0x8,%esp
  8001ed:	68 c8 00 00 00       	push   $0xc8
  8001f2:	68 f4 25 80 00       	push   $0x8025f4
  8001f7:	e8 3b 01 00 00       	call   800337 <cprintf>
  8001fc:	83 c4 10             	add    $0x10,%esp
}
  8001ff:	eb bc                	jmp    8001bd <umain+0x18a>

00800201 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800201:	55                   	push   %ebp
  800202:	89 e5                	mov    %esp,%ebp
  800204:	56                   	push   %esi
  800205:	53                   	push   %ebx
  800206:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800209:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	// thisenv = 0;
	thisenv = &(envs[ENVX(sys_getenvid())]);
  80020c:	e8 00 0c 00 00       	call   800e11 <sys_getenvid>
  800211:	25 ff 03 00 00       	and    $0x3ff,%eax
  800216:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80021c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800221:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800226:	85 db                	test   %ebx,%ebx
  800228:	7e 07                	jle    800231 <libmain+0x30>
		binaryname = argv[0];
  80022a:	8b 06                	mov    (%esi),%eax
  80022c:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800231:	83 ec 08             	sub    $0x8,%esp
  800234:	56                   	push   %esi
  800235:	53                   	push   %ebx
  800236:	e8 f8 fd ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80023b:	e8 0a 00 00 00       	call   80024a <exit>
}
  800240:	83 c4 10             	add    $0x10,%esp
  800243:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800246:	5b                   	pop    %ebx
  800247:	5e                   	pop    %esi
  800248:	5d                   	pop    %ebp
  800249:	c3                   	ret    

0080024a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80024a:	55                   	push   %ebp
  80024b:	89 e5                	mov    %esp,%ebp
  80024d:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  800250:	6a 00                	push   $0x0
  800252:	e8 79 0b 00 00       	call   800dd0 <sys_env_destroy>
}
  800257:	83 c4 10             	add    $0x10,%esp
  80025a:	c9                   	leave  
  80025b:	c3                   	ret    

0080025c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80025c:	55                   	push   %ebp
  80025d:	89 e5                	mov    %esp,%ebp
  80025f:	56                   	push   %esi
  800260:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800261:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800264:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80026a:	e8 a2 0b 00 00       	call   800e11 <sys_getenvid>
  80026f:	83 ec 0c             	sub    $0xc,%esp
  800272:	ff 75 0c             	pushl  0xc(%ebp)
  800275:	ff 75 08             	pushl  0x8(%ebp)
  800278:	56                   	push   %esi
  800279:	50                   	push   %eax
  80027a:	68 40 26 80 00       	push   $0x802640
  80027f:	e8 b3 00 00 00       	call   800337 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800284:	83 c4 18             	add    $0x18,%esp
  800287:	53                   	push   %ebx
  800288:	ff 75 10             	pushl  0x10(%ebp)
  80028b:	e8 56 00 00 00       	call   8002e6 <vcprintf>
	cprintf("\n");
  800290:	c7 04 24 57 25 80 00 	movl   $0x802557,(%esp)
  800297:	e8 9b 00 00 00       	call   800337 <cprintf>
  80029c:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80029f:	cc                   	int3   
  8002a0:	eb fd                	jmp    80029f <_panic+0x43>

008002a2 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002a2:	55                   	push   %ebp
  8002a3:	89 e5                	mov    %esp,%ebp
  8002a5:	53                   	push   %ebx
  8002a6:	83 ec 04             	sub    $0x4,%esp
  8002a9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002ac:	8b 13                	mov    (%ebx),%edx
  8002ae:	8d 42 01             	lea    0x1(%edx),%eax
  8002b1:	89 03                	mov    %eax,(%ebx)
  8002b3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002b6:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8002ba:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002bf:	74 09                	je     8002ca <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8002c1:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002c8:	c9                   	leave  
  8002c9:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8002ca:	83 ec 08             	sub    $0x8,%esp
  8002cd:	68 ff 00 00 00       	push   $0xff
  8002d2:	8d 43 08             	lea    0x8(%ebx),%eax
  8002d5:	50                   	push   %eax
  8002d6:	e8 b8 0a 00 00       	call   800d93 <sys_cputs>
		b->idx = 0;
  8002db:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002e1:	83 c4 10             	add    $0x10,%esp
  8002e4:	eb db                	jmp    8002c1 <putch+0x1f>

008002e6 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002e6:	55                   	push   %ebp
  8002e7:	89 e5                	mov    %esp,%ebp
  8002e9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002ef:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002f6:	00 00 00 
	b.cnt = 0;
  8002f9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800300:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800303:	ff 75 0c             	pushl  0xc(%ebp)
  800306:	ff 75 08             	pushl  0x8(%ebp)
  800309:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80030f:	50                   	push   %eax
  800310:	68 a2 02 80 00       	push   $0x8002a2
  800315:	e8 4a 01 00 00       	call   800464 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80031a:	83 c4 08             	add    $0x8,%esp
  80031d:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800323:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800329:	50                   	push   %eax
  80032a:	e8 64 0a 00 00       	call   800d93 <sys_cputs>

	return b.cnt;
}
  80032f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800335:	c9                   	leave  
  800336:	c3                   	ret    

00800337 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800337:	55                   	push   %ebp
  800338:	89 e5                	mov    %esp,%ebp
  80033a:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80033d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800340:	50                   	push   %eax
  800341:	ff 75 08             	pushl  0x8(%ebp)
  800344:	e8 9d ff ff ff       	call   8002e6 <vcprintf>
	va_end(ap);

	return cnt;
}
  800349:	c9                   	leave  
  80034a:	c3                   	ret    

0080034b <printnum>:


static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80034b:	55                   	push   %ebp
  80034c:	89 e5                	mov    %esp,%ebp
  80034e:	57                   	push   %edi
  80034f:	56                   	push   %esi
  800350:	53                   	push   %ebx
  800351:	83 ec 1c             	sub    $0x1c,%esp
  800354:	89 c6                	mov    %eax,%esi
  800356:	89 d7                	mov    %edx,%edi
  800358:	8b 45 08             	mov    0x8(%ebp),%eax
  80035b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80035e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800361:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800364:	8b 45 10             	mov    0x10(%ebp),%eax
  800367:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	// to support '-'
	if(padc == '-'){
  80036a:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80036e:	74 2c                	je     80039c <printnum+0x51>
		while (--width > 0)
			putch(' ', putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800370:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800373:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80037a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80037d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800380:	39 c2                	cmp    %eax,%edx
  800382:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800385:	73 43                	jae    8003ca <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800387:	83 eb 01             	sub    $0x1,%ebx
  80038a:	85 db                	test   %ebx,%ebx
  80038c:	7e 6c                	jle    8003fa <printnum+0xaf>
			putch(padc, putdat);
  80038e:	83 ec 08             	sub    $0x8,%esp
  800391:	57                   	push   %edi
  800392:	ff 75 18             	pushl  0x18(%ebp)
  800395:	ff d6                	call   *%esi
  800397:	83 c4 10             	add    $0x10,%esp
  80039a:	eb eb                	jmp    800387 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80039c:	83 ec 0c             	sub    $0xc,%esp
  80039f:	6a 20                	push   $0x20
  8003a1:	6a 00                	push   $0x0
  8003a3:	50                   	push   %eax
  8003a4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003a7:	ff 75 e0             	pushl  -0x20(%ebp)
  8003aa:	89 fa                	mov    %edi,%edx
  8003ac:	89 f0                	mov    %esi,%eax
  8003ae:	e8 98 ff ff ff       	call   80034b <printnum>
		while (--width > 0)
  8003b3:	83 c4 20             	add    $0x20,%esp
  8003b6:	83 eb 01             	sub    $0x1,%ebx
  8003b9:	85 db                	test   %ebx,%ebx
  8003bb:	7e 65                	jle    800422 <printnum+0xd7>
			putch(' ', putdat);
  8003bd:	83 ec 08             	sub    $0x8,%esp
  8003c0:	57                   	push   %edi
  8003c1:	6a 20                	push   $0x20
  8003c3:	ff d6                	call   *%esi
  8003c5:	83 c4 10             	add    $0x10,%esp
  8003c8:	eb ec                	jmp    8003b6 <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003ca:	83 ec 0c             	sub    $0xc,%esp
  8003cd:	ff 75 18             	pushl  0x18(%ebp)
  8003d0:	83 eb 01             	sub    $0x1,%ebx
  8003d3:	53                   	push   %ebx
  8003d4:	50                   	push   %eax
  8003d5:	83 ec 08             	sub    $0x8,%esp
  8003d8:	ff 75 dc             	pushl  -0x24(%ebp)
  8003db:	ff 75 d8             	pushl  -0x28(%ebp)
  8003de:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003e1:	ff 75 e0             	pushl  -0x20(%ebp)
  8003e4:	e8 07 1f 00 00       	call   8022f0 <__udivdi3>
  8003e9:	83 c4 18             	add    $0x18,%esp
  8003ec:	52                   	push   %edx
  8003ed:	50                   	push   %eax
  8003ee:	89 fa                	mov    %edi,%edx
  8003f0:	89 f0                	mov    %esi,%eax
  8003f2:	e8 54 ff ff ff       	call   80034b <printnum>
  8003f7:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003fa:	83 ec 08             	sub    $0x8,%esp
  8003fd:	57                   	push   %edi
  8003fe:	83 ec 04             	sub    $0x4,%esp
  800401:	ff 75 dc             	pushl  -0x24(%ebp)
  800404:	ff 75 d8             	pushl  -0x28(%ebp)
  800407:	ff 75 e4             	pushl  -0x1c(%ebp)
  80040a:	ff 75 e0             	pushl  -0x20(%ebp)
  80040d:	e8 ee 1f 00 00       	call   802400 <__umoddi3>
  800412:	83 c4 14             	add    $0x14,%esp
  800415:	0f be 80 63 26 80 00 	movsbl 0x802663(%eax),%eax
  80041c:	50                   	push   %eax
  80041d:	ff d6                	call   *%esi
  80041f:	83 c4 10             	add    $0x10,%esp
}
  800422:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800425:	5b                   	pop    %ebx
  800426:	5e                   	pop    %esi
  800427:	5f                   	pop    %edi
  800428:	5d                   	pop    %ebp
  800429:	c3                   	ret    

0080042a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80042a:	55                   	push   %ebp
  80042b:	89 e5                	mov    %esp,%ebp
  80042d:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800430:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800434:	8b 10                	mov    (%eax),%edx
  800436:	3b 50 04             	cmp    0x4(%eax),%edx
  800439:	73 0a                	jae    800445 <sprintputch+0x1b>
		*b->buf++ = ch;
  80043b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80043e:	89 08                	mov    %ecx,(%eax)
  800440:	8b 45 08             	mov    0x8(%ebp),%eax
  800443:	88 02                	mov    %al,(%edx)
}
  800445:	5d                   	pop    %ebp
  800446:	c3                   	ret    

00800447 <printfmt>:
{
  800447:	55                   	push   %ebp
  800448:	89 e5                	mov    %esp,%ebp
  80044a:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80044d:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800450:	50                   	push   %eax
  800451:	ff 75 10             	pushl  0x10(%ebp)
  800454:	ff 75 0c             	pushl  0xc(%ebp)
  800457:	ff 75 08             	pushl  0x8(%ebp)
  80045a:	e8 05 00 00 00       	call   800464 <vprintfmt>
}
  80045f:	83 c4 10             	add    $0x10,%esp
  800462:	c9                   	leave  
  800463:	c3                   	ret    

00800464 <vprintfmt>:
{
  800464:	55                   	push   %ebp
  800465:	89 e5                	mov    %esp,%ebp
  800467:	57                   	push   %edi
  800468:	56                   	push   %esi
  800469:	53                   	push   %ebx
  80046a:	83 ec 3c             	sub    $0x3c,%esp
  80046d:	8b 75 08             	mov    0x8(%ebp),%esi
  800470:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800473:	8b 7d 10             	mov    0x10(%ebp),%edi
  800476:	e9 1e 04 00 00       	jmp    800899 <vprintfmt+0x435>
		posflag = 0;
  80047b:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
		padc = ' ';
  800482:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800486:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  80048d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800494:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80049b:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  8004a2:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004a7:	8d 47 01             	lea    0x1(%edi),%eax
  8004aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004ad:	0f b6 17             	movzbl (%edi),%edx
  8004b0:	8d 42 dd             	lea    -0x23(%edx),%eax
  8004b3:	3c 55                	cmp    $0x55,%al
  8004b5:	0f 87 d9 04 00 00    	ja     800994 <vprintfmt+0x530>
  8004bb:	0f b6 c0             	movzbl %al,%eax
  8004be:	ff 24 85 40 28 80 00 	jmp    *0x802840(,%eax,4)
  8004c5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8004c8:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8004cc:	eb d9                	jmp    8004a7 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8004ce:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posflag = 1;
  8004d1:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  8004d8:	eb cd                	jmp    8004a7 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8004da:	0f b6 d2             	movzbl %dl,%edx
  8004dd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8004e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8004e5:	89 75 08             	mov    %esi,0x8(%ebp)
  8004e8:	eb 0c                	jmp    8004f6 <vprintfmt+0x92>
		switch (ch = *(unsigned char *) fmt++) {
  8004ea:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8004ed:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  8004f1:	eb b4                	jmp    8004a7 <vprintfmt+0x43>
			for (precision = 0; ; ++fmt) {
  8004f3:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8004f6:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8004f9:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8004fd:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800500:	8d 72 d0             	lea    -0x30(%edx),%esi
  800503:	83 fe 09             	cmp    $0x9,%esi
  800506:	76 eb                	jbe    8004f3 <vprintfmt+0x8f>
  800508:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80050b:	8b 75 08             	mov    0x8(%ebp),%esi
  80050e:	eb 14                	jmp    800524 <vprintfmt+0xc0>
			precision = va_arg(ap, int);
  800510:	8b 45 14             	mov    0x14(%ebp),%eax
  800513:	8b 00                	mov    (%eax),%eax
  800515:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800518:	8b 45 14             	mov    0x14(%ebp),%eax
  80051b:	8d 40 04             	lea    0x4(%eax),%eax
  80051e:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800521:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800524:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800528:	0f 89 79 ff ff ff    	jns    8004a7 <vprintfmt+0x43>
				width = precision, precision = -1;
  80052e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800531:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800534:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80053b:	e9 67 ff ff ff       	jmp    8004a7 <vprintfmt+0x43>
  800540:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800543:	85 c0                	test   %eax,%eax
  800545:	0f 48 c1             	cmovs  %ecx,%eax
  800548:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80054b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80054e:	e9 54 ff ff ff       	jmp    8004a7 <vprintfmt+0x43>
  800553:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800556:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80055d:	e9 45 ff ff ff       	jmp    8004a7 <vprintfmt+0x43>
			lflag++;
  800562:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800566:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800569:	e9 39 ff ff ff       	jmp    8004a7 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  80056e:	8b 45 14             	mov    0x14(%ebp),%eax
  800571:	8d 78 04             	lea    0x4(%eax),%edi
  800574:	83 ec 08             	sub    $0x8,%esp
  800577:	53                   	push   %ebx
  800578:	ff 30                	pushl  (%eax)
  80057a:	ff d6                	call   *%esi
			break;
  80057c:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80057f:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800582:	e9 0f 03 00 00       	jmp    800896 <vprintfmt+0x432>
			err = va_arg(ap, int);
  800587:	8b 45 14             	mov    0x14(%ebp),%eax
  80058a:	8d 78 04             	lea    0x4(%eax),%edi
  80058d:	8b 00                	mov    (%eax),%eax
  80058f:	99                   	cltd   
  800590:	31 d0                	xor    %edx,%eax
  800592:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800594:	83 f8 0f             	cmp    $0xf,%eax
  800597:	7f 23                	jg     8005bc <vprintfmt+0x158>
  800599:	8b 14 85 a0 29 80 00 	mov    0x8029a0(,%eax,4),%edx
  8005a0:	85 d2                	test   %edx,%edx
  8005a2:	74 18                	je     8005bc <vprintfmt+0x158>
				printfmt(putch, putdat, "%s", p);
  8005a4:	52                   	push   %edx
  8005a5:	68 da 2c 80 00       	push   $0x802cda
  8005aa:	53                   	push   %ebx
  8005ab:	56                   	push   %esi
  8005ac:	e8 96 fe ff ff       	call   800447 <printfmt>
  8005b1:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005b4:	89 7d 14             	mov    %edi,0x14(%ebp)
  8005b7:	e9 da 02 00 00       	jmp    800896 <vprintfmt+0x432>
				printfmt(putch, putdat, "error %d", err);
  8005bc:	50                   	push   %eax
  8005bd:	68 7b 26 80 00       	push   $0x80267b
  8005c2:	53                   	push   %ebx
  8005c3:	56                   	push   %esi
  8005c4:	e8 7e fe ff ff       	call   800447 <printfmt>
  8005c9:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005cc:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8005cf:	e9 c2 02 00 00       	jmp    800896 <vprintfmt+0x432>
			if ((p = va_arg(ap, char *)) == NULL)
  8005d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d7:	83 c0 04             	add    $0x4,%eax
  8005da:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8005dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e0:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8005e2:	85 c9                	test   %ecx,%ecx
  8005e4:	b8 74 26 80 00       	mov    $0x802674,%eax
  8005e9:	0f 45 c1             	cmovne %ecx,%eax
  8005ec:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8005ef:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005f3:	7e 06                	jle    8005fb <vprintfmt+0x197>
  8005f5:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8005f9:	75 0d                	jne    800608 <vprintfmt+0x1a4>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005fb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8005fe:	89 c7                	mov    %eax,%edi
  800600:	03 45 e0             	add    -0x20(%ebp),%eax
  800603:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800606:	eb 53                	jmp    80065b <vprintfmt+0x1f7>
  800608:	83 ec 08             	sub    $0x8,%esp
  80060b:	ff 75 d8             	pushl  -0x28(%ebp)
  80060e:	50                   	push   %eax
  80060f:	e8 28 04 00 00       	call   800a3c <strnlen>
  800614:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800617:	29 c1                	sub    %eax,%ecx
  800619:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  80061c:	83 c4 10             	add    $0x10,%esp
  80061f:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800621:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800625:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800628:	eb 0f                	jmp    800639 <vprintfmt+0x1d5>
					putch(padc, putdat);
  80062a:	83 ec 08             	sub    $0x8,%esp
  80062d:	53                   	push   %ebx
  80062e:	ff 75 e0             	pushl  -0x20(%ebp)
  800631:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800633:	83 ef 01             	sub    $0x1,%edi
  800636:	83 c4 10             	add    $0x10,%esp
  800639:	85 ff                	test   %edi,%edi
  80063b:	7f ed                	jg     80062a <vprintfmt+0x1c6>
  80063d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  800640:	85 c9                	test   %ecx,%ecx
  800642:	b8 00 00 00 00       	mov    $0x0,%eax
  800647:	0f 49 c1             	cmovns %ecx,%eax
  80064a:	29 c1                	sub    %eax,%ecx
  80064c:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80064f:	eb aa                	jmp    8005fb <vprintfmt+0x197>
					putch(ch, putdat);
  800651:	83 ec 08             	sub    $0x8,%esp
  800654:	53                   	push   %ebx
  800655:	52                   	push   %edx
  800656:	ff d6                	call   *%esi
  800658:	83 c4 10             	add    $0x10,%esp
  80065b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80065e:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800660:	83 c7 01             	add    $0x1,%edi
  800663:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800667:	0f be d0             	movsbl %al,%edx
  80066a:	85 d2                	test   %edx,%edx
  80066c:	74 4b                	je     8006b9 <vprintfmt+0x255>
  80066e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800672:	78 06                	js     80067a <vprintfmt+0x216>
  800674:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800678:	78 1e                	js     800698 <vprintfmt+0x234>
				if (altflag && (ch < ' ' || ch > '~'))
  80067a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80067e:	74 d1                	je     800651 <vprintfmt+0x1ed>
  800680:	0f be c0             	movsbl %al,%eax
  800683:	83 e8 20             	sub    $0x20,%eax
  800686:	83 f8 5e             	cmp    $0x5e,%eax
  800689:	76 c6                	jbe    800651 <vprintfmt+0x1ed>
					putch('?', putdat);
  80068b:	83 ec 08             	sub    $0x8,%esp
  80068e:	53                   	push   %ebx
  80068f:	6a 3f                	push   $0x3f
  800691:	ff d6                	call   *%esi
  800693:	83 c4 10             	add    $0x10,%esp
  800696:	eb c3                	jmp    80065b <vprintfmt+0x1f7>
  800698:	89 cf                	mov    %ecx,%edi
  80069a:	eb 0e                	jmp    8006aa <vprintfmt+0x246>
				putch(' ', putdat);
  80069c:	83 ec 08             	sub    $0x8,%esp
  80069f:	53                   	push   %ebx
  8006a0:	6a 20                	push   $0x20
  8006a2:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8006a4:	83 ef 01             	sub    $0x1,%edi
  8006a7:	83 c4 10             	add    $0x10,%esp
  8006aa:	85 ff                	test   %edi,%edi
  8006ac:	7f ee                	jg     80069c <vprintfmt+0x238>
			if ((p = va_arg(ap, char *)) == NULL)
  8006ae:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8006b1:	89 45 14             	mov    %eax,0x14(%ebp)
  8006b4:	e9 dd 01 00 00       	jmp    800896 <vprintfmt+0x432>
  8006b9:	89 cf                	mov    %ecx,%edi
  8006bb:	eb ed                	jmp    8006aa <vprintfmt+0x246>
	if (lflag >= 2)
  8006bd:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8006c1:	7f 21                	jg     8006e4 <vprintfmt+0x280>
	else if (lflag)
  8006c3:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8006c7:	74 6a                	je     800733 <vprintfmt+0x2cf>
		return va_arg(*ap, long);
  8006c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cc:	8b 00                	mov    (%eax),%eax
  8006ce:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006d1:	89 c1                	mov    %eax,%ecx
  8006d3:	c1 f9 1f             	sar    $0x1f,%ecx
  8006d6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006dc:	8d 40 04             	lea    0x4(%eax),%eax
  8006df:	89 45 14             	mov    %eax,0x14(%ebp)
  8006e2:	eb 17                	jmp    8006fb <vprintfmt+0x297>
		return va_arg(*ap, long long);
  8006e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e7:	8b 50 04             	mov    0x4(%eax),%edx
  8006ea:	8b 00                	mov    (%eax),%eax
  8006ec:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ef:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f5:	8d 40 08             	lea    0x8(%eax),%eax
  8006f8:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8006fb:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  8006fe:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800703:	85 d2                	test   %edx,%edx
  800705:	0f 89 5c 01 00 00    	jns    800867 <vprintfmt+0x403>
				putch('-', putdat);
  80070b:	83 ec 08             	sub    $0x8,%esp
  80070e:	53                   	push   %ebx
  80070f:	6a 2d                	push   $0x2d
  800711:	ff d6                	call   *%esi
				num = -(long long) num;
  800713:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800716:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800719:	f7 d8                	neg    %eax
  80071b:	83 d2 00             	adc    $0x0,%edx
  80071e:	f7 da                	neg    %edx
  800720:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800723:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800726:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800729:	bf 0a 00 00 00       	mov    $0xa,%edi
  80072e:	e9 45 01 00 00       	jmp    800878 <vprintfmt+0x414>
		return va_arg(*ap, int);
  800733:	8b 45 14             	mov    0x14(%ebp),%eax
  800736:	8b 00                	mov    (%eax),%eax
  800738:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80073b:	89 c1                	mov    %eax,%ecx
  80073d:	c1 f9 1f             	sar    $0x1f,%ecx
  800740:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800743:	8b 45 14             	mov    0x14(%ebp),%eax
  800746:	8d 40 04             	lea    0x4(%eax),%eax
  800749:	89 45 14             	mov    %eax,0x14(%ebp)
  80074c:	eb ad                	jmp    8006fb <vprintfmt+0x297>
	if (lflag >= 2)
  80074e:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800752:	7f 29                	jg     80077d <vprintfmt+0x319>
	else if (lflag)
  800754:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800758:	74 44                	je     80079e <vprintfmt+0x33a>
		return va_arg(*ap, unsigned long);
  80075a:	8b 45 14             	mov    0x14(%ebp),%eax
  80075d:	8b 00                	mov    (%eax),%eax
  80075f:	ba 00 00 00 00       	mov    $0x0,%edx
  800764:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800767:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80076a:	8b 45 14             	mov    0x14(%ebp),%eax
  80076d:	8d 40 04             	lea    0x4(%eax),%eax
  800770:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800773:	bf 0a 00 00 00       	mov    $0xa,%edi
  800778:	e9 ea 00 00 00       	jmp    800867 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  80077d:	8b 45 14             	mov    0x14(%ebp),%eax
  800780:	8b 50 04             	mov    0x4(%eax),%edx
  800783:	8b 00                	mov    (%eax),%eax
  800785:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800788:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80078b:	8b 45 14             	mov    0x14(%ebp),%eax
  80078e:	8d 40 08             	lea    0x8(%eax),%eax
  800791:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800794:	bf 0a 00 00 00       	mov    $0xa,%edi
  800799:	e9 c9 00 00 00       	jmp    800867 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  80079e:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a1:	8b 00                	mov    (%eax),%eax
  8007a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8007a8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007ab:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b1:	8d 40 04             	lea    0x4(%eax),%eax
  8007b4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007b7:	bf 0a 00 00 00       	mov    $0xa,%edi
  8007bc:	e9 a6 00 00 00       	jmp    800867 <vprintfmt+0x403>
			putch('0', putdat);
  8007c1:	83 ec 08             	sub    $0x8,%esp
  8007c4:	53                   	push   %ebx
  8007c5:	6a 30                	push   $0x30
  8007c7:	ff d6                	call   *%esi
	if (lflag >= 2)
  8007c9:	83 c4 10             	add    $0x10,%esp
  8007cc:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8007d0:	7f 26                	jg     8007f8 <vprintfmt+0x394>
	else if (lflag)
  8007d2:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8007d6:	74 3e                	je     800816 <vprintfmt+0x3b2>
		return va_arg(*ap, unsigned long);
  8007d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007db:	8b 00                	mov    (%eax),%eax
  8007dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8007e2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007e5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007eb:	8d 40 04             	lea    0x4(%eax),%eax
  8007ee:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007f1:	bf 08 00 00 00       	mov    $0x8,%edi
  8007f6:	eb 6f                	jmp    800867 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  8007f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fb:	8b 50 04             	mov    0x4(%eax),%edx
  8007fe:	8b 00                	mov    (%eax),%eax
  800800:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800803:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800806:	8b 45 14             	mov    0x14(%ebp),%eax
  800809:	8d 40 08             	lea    0x8(%eax),%eax
  80080c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80080f:	bf 08 00 00 00       	mov    $0x8,%edi
  800814:	eb 51                	jmp    800867 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  800816:	8b 45 14             	mov    0x14(%ebp),%eax
  800819:	8b 00                	mov    (%eax),%eax
  80081b:	ba 00 00 00 00       	mov    $0x0,%edx
  800820:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800823:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800826:	8b 45 14             	mov    0x14(%ebp),%eax
  800829:	8d 40 04             	lea    0x4(%eax),%eax
  80082c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80082f:	bf 08 00 00 00       	mov    $0x8,%edi
  800834:	eb 31                	jmp    800867 <vprintfmt+0x403>
			putch('0', putdat);
  800836:	83 ec 08             	sub    $0x8,%esp
  800839:	53                   	push   %ebx
  80083a:	6a 30                	push   $0x30
  80083c:	ff d6                	call   *%esi
			putch('x', putdat);
  80083e:	83 c4 08             	add    $0x8,%esp
  800841:	53                   	push   %ebx
  800842:	6a 78                	push   $0x78
  800844:	ff d6                	call   *%esi
			num = (unsigned long long)
  800846:	8b 45 14             	mov    0x14(%ebp),%eax
  800849:	8b 00                	mov    (%eax),%eax
  80084b:	ba 00 00 00 00       	mov    $0x0,%edx
  800850:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800853:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800856:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800859:	8b 45 14             	mov    0x14(%ebp),%eax
  80085c:	8d 40 04             	lea    0x4(%eax),%eax
  80085f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800862:	bf 10 00 00 00       	mov    $0x10,%edi
			if(posflag)
  800867:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80086b:	74 0b                	je     800878 <vprintfmt+0x414>
				putch('+', putdat);
  80086d:	83 ec 08             	sub    $0x8,%esp
  800870:	53                   	push   %ebx
  800871:	6a 2b                	push   $0x2b
  800873:	ff d6                	call   *%esi
  800875:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  800878:	83 ec 0c             	sub    $0xc,%esp
  80087b:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80087f:	50                   	push   %eax
  800880:	ff 75 e0             	pushl  -0x20(%ebp)
  800883:	57                   	push   %edi
  800884:	ff 75 dc             	pushl  -0x24(%ebp)
  800887:	ff 75 d8             	pushl  -0x28(%ebp)
  80088a:	89 da                	mov    %ebx,%edx
  80088c:	89 f0                	mov    %esi,%eax
  80088e:	e8 b8 fa ff ff       	call   80034b <printnum>
			break;
  800893:	83 c4 20             	add    $0x20,%esp
			char* cp = va_arg(ap, char *);
  800896:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800899:	83 c7 01             	add    $0x1,%edi
  80089c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008a0:	83 f8 25             	cmp    $0x25,%eax
  8008a3:	0f 84 d2 fb ff ff    	je     80047b <vprintfmt+0x17>
			if (ch == '\0')
  8008a9:	85 c0                	test   %eax,%eax
  8008ab:	0f 84 03 01 00 00    	je     8009b4 <vprintfmt+0x550>
			putch(ch, putdat);
  8008b1:	83 ec 08             	sub    $0x8,%esp
  8008b4:	53                   	push   %ebx
  8008b5:	50                   	push   %eax
  8008b6:	ff d6                	call   *%esi
  8008b8:	83 c4 10             	add    $0x10,%esp
  8008bb:	eb dc                	jmp    800899 <vprintfmt+0x435>
	if (lflag >= 2)
  8008bd:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8008c1:	7f 29                	jg     8008ec <vprintfmt+0x488>
	else if (lflag)
  8008c3:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8008c7:	74 44                	je     80090d <vprintfmt+0x4a9>
		return va_arg(*ap, unsigned long);
  8008c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cc:	8b 00                	mov    (%eax),%eax
  8008ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8008d3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008d6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008dc:	8d 40 04             	lea    0x4(%eax),%eax
  8008df:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008e2:	bf 10 00 00 00       	mov    $0x10,%edi
  8008e7:	e9 7b ff ff ff       	jmp    800867 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  8008ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ef:	8b 50 04             	mov    0x4(%eax),%edx
  8008f2:	8b 00                	mov    (%eax),%eax
  8008f4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008f7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8008fd:	8d 40 08             	lea    0x8(%eax),%eax
  800900:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800903:	bf 10 00 00 00       	mov    $0x10,%edi
  800908:	e9 5a ff ff ff       	jmp    800867 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  80090d:	8b 45 14             	mov    0x14(%ebp),%eax
  800910:	8b 00                	mov    (%eax),%eax
  800912:	ba 00 00 00 00       	mov    $0x0,%edx
  800917:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80091a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80091d:	8b 45 14             	mov    0x14(%ebp),%eax
  800920:	8d 40 04             	lea    0x4(%eax),%eax
  800923:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800926:	bf 10 00 00 00       	mov    $0x10,%edi
  80092b:	e9 37 ff ff ff       	jmp    800867 <vprintfmt+0x403>
			char* cp = va_arg(ap, char *);
  800930:	8b 45 14             	mov    0x14(%ebp),%eax
  800933:	8d 78 04             	lea    0x4(%eax),%edi
  800936:	8b 00                	mov    (%eax),%eax
    			if (cp == NULL) {
  800938:	85 c0                	test   %eax,%eax
  80093a:	74 2c                	je     800968 <vprintfmt+0x504>
    			*cp = *(int *)putdat;
  80093c:	8b 13                	mov    (%ebx),%edx
  80093e:	88 10                	mov    %dl,(%eax)
			char* cp = va_arg(ap, char *);
  800940:	89 7d 14             	mov    %edi,0x14(%ebp)
    			if ((*(int *) putdat) > 127)
  800943:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  800946:	0f 8e 4a ff ff ff    	jle    800896 <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", overflow_error);
  80094c:	68 d0 27 80 00       	push   $0x8027d0
  800951:	68 da 2c 80 00       	push   $0x802cda
  800956:	53                   	push   %ebx
  800957:	56                   	push   %esi
  800958:	e8 ea fa ff ff       	call   800447 <printfmt>
  80095d:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  800960:	89 7d 14             	mov    %edi,0x14(%ebp)
  800963:	e9 2e ff ff ff       	jmp    800896 <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", null_error);
  800968:	68 98 27 80 00       	push   $0x802798
  80096d:	68 da 2c 80 00       	push   $0x802cda
  800972:	53                   	push   %ebx
  800973:	56                   	push   %esi
  800974:	e8 ce fa ff ff       	call   800447 <printfmt>
        		break;
  800979:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  80097c:	89 7d 14             	mov    %edi,0x14(%ebp)
        		break;
  80097f:	e9 12 ff ff ff       	jmp    800896 <vprintfmt+0x432>
			putch(ch, putdat);
  800984:	83 ec 08             	sub    $0x8,%esp
  800987:	53                   	push   %ebx
  800988:	6a 25                	push   $0x25
  80098a:	ff d6                	call   *%esi
			break;
  80098c:	83 c4 10             	add    $0x10,%esp
  80098f:	e9 02 ff ff ff       	jmp    800896 <vprintfmt+0x432>
			putch('%', putdat);
  800994:	83 ec 08             	sub    $0x8,%esp
  800997:	53                   	push   %ebx
  800998:	6a 25                	push   $0x25
  80099a:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80099c:	83 c4 10             	add    $0x10,%esp
  80099f:	89 f8                	mov    %edi,%eax
  8009a1:	eb 03                	jmp    8009a6 <vprintfmt+0x542>
  8009a3:	83 e8 01             	sub    $0x1,%eax
  8009a6:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8009aa:	75 f7                	jne    8009a3 <vprintfmt+0x53f>
  8009ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009af:	e9 e2 fe ff ff       	jmp    800896 <vprintfmt+0x432>
}
  8009b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8009b7:	5b                   	pop    %ebx
  8009b8:	5e                   	pop    %esi
  8009b9:	5f                   	pop    %edi
  8009ba:	5d                   	pop    %ebp
  8009bb:	c3                   	ret    

008009bc <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009bc:	55                   	push   %ebp
  8009bd:	89 e5                	mov    %esp,%ebp
  8009bf:	83 ec 18             	sub    $0x18,%esp
  8009c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c5:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009c8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009cb:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8009cf:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8009d2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009d9:	85 c0                	test   %eax,%eax
  8009db:	74 26                	je     800a03 <vsnprintf+0x47>
  8009dd:	85 d2                	test   %edx,%edx
  8009df:	7e 22                	jle    800a03 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009e1:	ff 75 14             	pushl  0x14(%ebp)
  8009e4:	ff 75 10             	pushl  0x10(%ebp)
  8009e7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009ea:	50                   	push   %eax
  8009eb:	68 2a 04 80 00       	push   $0x80042a
  8009f0:	e8 6f fa ff ff       	call   800464 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009f8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009fe:	83 c4 10             	add    $0x10,%esp
}
  800a01:	c9                   	leave  
  800a02:	c3                   	ret    
		return -E_INVAL;
  800a03:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a08:	eb f7                	jmp    800a01 <vsnprintf+0x45>

00800a0a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a0a:	55                   	push   %ebp
  800a0b:	89 e5                	mov    %esp,%ebp
  800a0d:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a10:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a13:	50                   	push   %eax
  800a14:	ff 75 10             	pushl  0x10(%ebp)
  800a17:	ff 75 0c             	pushl  0xc(%ebp)
  800a1a:	ff 75 08             	pushl  0x8(%ebp)
  800a1d:	e8 9a ff ff ff       	call   8009bc <vsnprintf>
	va_end(ap);

	return rc;
}
  800a22:	c9                   	leave  
  800a23:	c3                   	ret    

00800a24 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a24:	55                   	push   %ebp
  800a25:	89 e5                	mov    %esp,%ebp
  800a27:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a2a:	b8 00 00 00 00       	mov    $0x0,%eax
  800a2f:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a33:	74 05                	je     800a3a <strlen+0x16>
		n++;
  800a35:	83 c0 01             	add    $0x1,%eax
  800a38:	eb f5                	jmp    800a2f <strlen+0xb>
	return n;
}
  800a3a:	5d                   	pop    %ebp
  800a3b:	c3                   	ret    

00800a3c <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a3c:	55                   	push   %ebp
  800a3d:	89 e5                	mov    %esp,%ebp
  800a3f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a42:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a45:	ba 00 00 00 00       	mov    $0x0,%edx
  800a4a:	39 c2                	cmp    %eax,%edx
  800a4c:	74 0d                	je     800a5b <strnlen+0x1f>
  800a4e:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800a52:	74 05                	je     800a59 <strnlen+0x1d>
		n++;
  800a54:	83 c2 01             	add    $0x1,%edx
  800a57:	eb f1                	jmp    800a4a <strnlen+0xe>
  800a59:	89 d0                	mov    %edx,%eax
	return n;
}
  800a5b:	5d                   	pop    %ebp
  800a5c:	c3                   	ret    

00800a5d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a5d:	55                   	push   %ebp
  800a5e:	89 e5                	mov    %esp,%ebp
  800a60:	53                   	push   %ebx
  800a61:	8b 45 08             	mov    0x8(%ebp),%eax
  800a64:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a67:	ba 00 00 00 00       	mov    $0x0,%edx
  800a6c:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800a70:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800a73:	83 c2 01             	add    $0x1,%edx
  800a76:	84 c9                	test   %cl,%cl
  800a78:	75 f2                	jne    800a6c <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800a7a:	5b                   	pop    %ebx
  800a7b:	5d                   	pop    %ebp
  800a7c:	c3                   	ret    

00800a7d <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a7d:	55                   	push   %ebp
  800a7e:	89 e5                	mov    %esp,%ebp
  800a80:	53                   	push   %ebx
  800a81:	83 ec 10             	sub    $0x10,%esp
  800a84:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a87:	53                   	push   %ebx
  800a88:	e8 97 ff ff ff       	call   800a24 <strlen>
  800a8d:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a90:	ff 75 0c             	pushl  0xc(%ebp)
  800a93:	01 d8                	add    %ebx,%eax
  800a95:	50                   	push   %eax
  800a96:	e8 c2 ff ff ff       	call   800a5d <strcpy>
	return dst;
}
  800a9b:	89 d8                	mov    %ebx,%eax
  800a9d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800aa0:	c9                   	leave  
  800aa1:	c3                   	ret    

00800aa2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800aa2:	55                   	push   %ebp
  800aa3:	89 e5                	mov    %esp,%ebp
  800aa5:	56                   	push   %esi
  800aa6:	53                   	push   %ebx
  800aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aaa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800aad:	89 c6                	mov    %eax,%esi
  800aaf:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ab2:	89 c2                	mov    %eax,%edx
  800ab4:	39 f2                	cmp    %esi,%edx
  800ab6:	74 11                	je     800ac9 <strncpy+0x27>
		*dst++ = *src;
  800ab8:	83 c2 01             	add    $0x1,%edx
  800abb:	0f b6 19             	movzbl (%ecx),%ebx
  800abe:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800ac1:	80 fb 01             	cmp    $0x1,%bl
  800ac4:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800ac7:	eb eb                	jmp    800ab4 <strncpy+0x12>
	}
	return ret;
}
  800ac9:	5b                   	pop    %ebx
  800aca:	5e                   	pop    %esi
  800acb:	5d                   	pop    %ebp
  800acc:	c3                   	ret    

00800acd <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800acd:	55                   	push   %ebp
  800ace:	89 e5                	mov    %esp,%ebp
  800ad0:	56                   	push   %esi
  800ad1:	53                   	push   %ebx
  800ad2:	8b 75 08             	mov    0x8(%ebp),%esi
  800ad5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ad8:	8b 55 10             	mov    0x10(%ebp),%edx
  800adb:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800add:	85 d2                	test   %edx,%edx
  800adf:	74 21                	je     800b02 <strlcpy+0x35>
  800ae1:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800ae5:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800ae7:	39 c2                	cmp    %eax,%edx
  800ae9:	74 14                	je     800aff <strlcpy+0x32>
  800aeb:	0f b6 19             	movzbl (%ecx),%ebx
  800aee:	84 db                	test   %bl,%bl
  800af0:	74 0b                	je     800afd <strlcpy+0x30>
			*dst++ = *src++;
  800af2:	83 c1 01             	add    $0x1,%ecx
  800af5:	83 c2 01             	add    $0x1,%edx
  800af8:	88 5a ff             	mov    %bl,-0x1(%edx)
  800afb:	eb ea                	jmp    800ae7 <strlcpy+0x1a>
  800afd:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800aff:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b02:	29 f0                	sub    %esi,%eax
}
  800b04:	5b                   	pop    %ebx
  800b05:	5e                   	pop    %esi
  800b06:	5d                   	pop    %ebp
  800b07:	c3                   	ret    

00800b08 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b08:	55                   	push   %ebp
  800b09:	89 e5                	mov    %esp,%ebp
  800b0b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b0e:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b11:	0f b6 01             	movzbl (%ecx),%eax
  800b14:	84 c0                	test   %al,%al
  800b16:	74 0c                	je     800b24 <strcmp+0x1c>
  800b18:	3a 02                	cmp    (%edx),%al
  800b1a:	75 08                	jne    800b24 <strcmp+0x1c>
		p++, q++;
  800b1c:	83 c1 01             	add    $0x1,%ecx
  800b1f:	83 c2 01             	add    $0x1,%edx
  800b22:	eb ed                	jmp    800b11 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b24:	0f b6 c0             	movzbl %al,%eax
  800b27:	0f b6 12             	movzbl (%edx),%edx
  800b2a:	29 d0                	sub    %edx,%eax
}
  800b2c:	5d                   	pop    %ebp
  800b2d:	c3                   	ret    

00800b2e <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b2e:	55                   	push   %ebp
  800b2f:	89 e5                	mov    %esp,%ebp
  800b31:	53                   	push   %ebx
  800b32:	8b 45 08             	mov    0x8(%ebp),%eax
  800b35:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b38:	89 c3                	mov    %eax,%ebx
  800b3a:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b3d:	eb 06                	jmp    800b45 <strncmp+0x17>
		n--, p++, q++;
  800b3f:	83 c0 01             	add    $0x1,%eax
  800b42:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b45:	39 d8                	cmp    %ebx,%eax
  800b47:	74 16                	je     800b5f <strncmp+0x31>
  800b49:	0f b6 08             	movzbl (%eax),%ecx
  800b4c:	84 c9                	test   %cl,%cl
  800b4e:	74 04                	je     800b54 <strncmp+0x26>
  800b50:	3a 0a                	cmp    (%edx),%cl
  800b52:	74 eb                	je     800b3f <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b54:	0f b6 00             	movzbl (%eax),%eax
  800b57:	0f b6 12             	movzbl (%edx),%edx
  800b5a:	29 d0                	sub    %edx,%eax
}
  800b5c:	5b                   	pop    %ebx
  800b5d:	5d                   	pop    %ebp
  800b5e:	c3                   	ret    
		return 0;
  800b5f:	b8 00 00 00 00       	mov    $0x0,%eax
  800b64:	eb f6                	jmp    800b5c <strncmp+0x2e>

00800b66 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b66:	55                   	push   %ebp
  800b67:	89 e5                	mov    %esp,%ebp
  800b69:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b70:	0f b6 10             	movzbl (%eax),%edx
  800b73:	84 d2                	test   %dl,%dl
  800b75:	74 09                	je     800b80 <strchr+0x1a>
		if (*s == c)
  800b77:	38 ca                	cmp    %cl,%dl
  800b79:	74 0a                	je     800b85 <strchr+0x1f>
	for (; *s; s++)
  800b7b:	83 c0 01             	add    $0x1,%eax
  800b7e:	eb f0                	jmp    800b70 <strchr+0xa>
			return (char *) s;
	return 0;
  800b80:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b85:	5d                   	pop    %ebp
  800b86:	c3                   	ret    

00800b87 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b87:	55                   	push   %ebp
  800b88:	89 e5                	mov    %esp,%ebp
  800b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b91:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b94:	38 ca                	cmp    %cl,%dl
  800b96:	74 09                	je     800ba1 <strfind+0x1a>
  800b98:	84 d2                	test   %dl,%dl
  800b9a:	74 05                	je     800ba1 <strfind+0x1a>
	for (; *s; s++)
  800b9c:	83 c0 01             	add    $0x1,%eax
  800b9f:	eb f0                	jmp    800b91 <strfind+0xa>
			break;
	return (char *) s;
}
  800ba1:	5d                   	pop    %ebp
  800ba2:	c3                   	ret    

00800ba3 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ba3:	55                   	push   %ebp
  800ba4:	89 e5                	mov    %esp,%ebp
  800ba6:	57                   	push   %edi
  800ba7:	56                   	push   %esi
  800ba8:	53                   	push   %ebx
  800ba9:	8b 7d 08             	mov    0x8(%ebp),%edi
  800bac:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800baf:	85 c9                	test   %ecx,%ecx
  800bb1:	74 31                	je     800be4 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800bb3:	89 f8                	mov    %edi,%eax
  800bb5:	09 c8                	or     %ecx,%eax
  800bb7:	a8 03                	test   $0x3,%al
  800bb9:	75 23                	jne    800bde <memset+0x3b>
		c &= 0xFF;
  800bbb:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800bbf:	89 d3                	mov    %edx,%ebx
  800bc1:	c1 e3 08             	shl    $0x8,%ebx
  800bc4:	89 d0                	mov    %edx,%eax
  800bc6:	c1 e0 18             	shl    $0x18,%eax
  800bc9:	89 d6                	mov    %edx,%esi
  800bcb:	c1 e6 10             	shl    $0x10,%esi
  800bce:	09 f0                	or     %esi,%eax
  800bd0:	09 c2                	or     %eax,%edx
  800bd2:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800bd4:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800bd7:	89 d0                	mov    %edx,%eax
  800bd9:	fc                   	cld    
  800bda:	f3 ab                	rep stos %eax,%es:(%edi)
  800bdc:	eb 06                	jmp    800be4 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800bde:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be1:	fc                   	cld    
  800be2:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800be4:	89 f8                	mov    %edi,%eax
  800be6:	5b                   	pop    %ebx
  800be7:	5e                   	pop    %esi
  800be8:	5f                   	pop    %edi
  800be9:	5d                   	pop    %ebp
  800bea:	c3                   	ret    

00800beb <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800beb:	55                   	push   %ebp
  800bec:	89 e5                	mov    %esp,%ebp
  800bee:	57                   	push   %edi
  800bef:	56                   	push   %esi
  800bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf3:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bf6:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bf9:	39 c6                	cmp    %eax,%esi
  800bfb:	73 32                	jae    800c2f <memmove+0x44>
  800bfd:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c00:	39 c2                	cmp    %eax,%edx
  800c02:	76 2b                	jbe    800c2f <memmove+0x44>
		s += n;
		d += n;
  800c04:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c07:	89 fe                	mov    %edi,%esi
  800c09:	09 ce                	or     %ecx,%esi
  800c0b:	09 d6                	or     %edx,%esi
  800c0d:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c13:	75 0e                	jne    800c23 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c15:	83 ef 04             	sub    $0x4,%edi
  800c18:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c1b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c1e:	fd                   	std    
  800c1f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c21:	eb 09                	jmp    800c2c <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c23:	83 ef 01             	sub    $0x1,%edi
  800c26:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c29:	fd                   	std    
  800c2a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c2c:	fc                   	cld    
  800c2d:	eb 1a                	jmp    800c49 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c2f:	89 c2                	mov    %eax,%edx
  800c31:	09 ca                	or     %ecx,%edx
  800c33:	09 f2                	or     %esi,%edx
  800c35:	f6 c2 03             	test   $0x3,%dl
  800c38:	75 0a                	jne    800c44 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c3a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c3d:	89 c7                	mov    %eax,%edi
  800c3f:	fc                   	cld    
  800c40:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c42:	eb 05                	jmp    800c49 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800c44:	89 c7                	mov    %eax,%edi
  800c46:	fc                   	cld    
  800c47:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c49:	5e                   	pop    %esi
  800c4a:	5f                   	pop    %edi
  800c4b:	5d                   	pop    %ebp
  800c4c:	c3                   	ret    

00800c4d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c4d:	55                   	push   %ebp
  800c4e:	89 e5                	mov    %esp,%ebp
  800c50:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c53:	ff 75 10             	pushl  0x10(%ebp)
  800c56:	ff 75 0c             	pushl  0xc(%ebp)
  800c59:	ff 75 08             	pushl  0x8(%ebp)
  800c5c:	e8 8a ff ff ff       	call   800beb <memmove>
}
  800c61:	c9                   	leave  
  800c62:	c3                   	ret    

00800c63 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c63:	55                   	push   %ebp
  800c64:	89 e5                	mov    %esp,%ebp
  800c66:	56                   	push   %esi
  800c67:	53                   	push   %ebx
  800c68:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c6e:	89 c6                	mov    %eax,%esi
  800c70:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c73:	39 f0                	cmp    %esi,%eax
  800c75:	74 1c                	je     800c93 <memcmp+0x30>
		if (*s1 != *s2)
  800c77:	0f b6 08             	movzbl (%eax),%ecx
  800c7a:	0f b6 1a             	movzbl (%edx),%ebx
  800c7d:	38 d9                	cmp    %bl,%cl
  800c7f:	75 08                	jne    800c89 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c81:	83 c0 01             	add    $0x1,%eax
  800c84:	83 c2 01             	add    $0x1,%edx
  800c87:	eb ea                	jmp    800c73 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c89:	0f b6 c1             	movzbl %cl,%eax
  800c8c:	0f b6 db             	movzbl %bl,%ebx
  800c8f:	29 d8                	sub    %ebx,%eax
  800c91:	eb 05                	jmp    800c98 <memcmp+0x35>
	}

	return 0;
  800c93:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c98:	5b                   	pop    %ebx
  800c99:	5e                   	pop    %esi
  800c9a:	5d                   	pop    %ebp
  800c9b:	c3                   	ret    

00800c9c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c9c:	55                   	push   %ebp
  800c9d:	89 e5                	mov    %esp,%ebp
  800c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ca5:	89 c2                	mov    %eax,%edx
  800ca7:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800caa:	39 d0                	cmp    %edx,%eax
  800cac:	73 09                	jae    800cb7 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800cae:	38 08                	cmp    %cl,(%eax)
  800cb0:	74 05                	je     800cb7 <memfind+0x1b>
	for (; s < ends; s++)
  800cb2:	83 c0 01             	add    $0x1,%eax
  800cb5:	eb f3                	jmp    800caa <memfind+0xe>
			break;
	return (void *) s;
}
  800cb7:	5d                   	pop    %ebp
  800cb8:	c3                   	ret    

00800cb9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800cb9:	55                   	push   %ebp
  800cba:	89 e5                	mov    %esp,%ebp
  800cbc:	57                   	push   %edi
  800cbd:	56                   	push   %esi
  800cbe:	53                   	push   %ebx
  800cbf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cc2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cc5:	eb 03                	jmp    800cca <strtol+0x11>
		s++;
  800cc7:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800cca:	0f b6 01             	movzbl (%ecx),%eax
  800ccd:	3c 20                	cmp    $0x20,%al
  800ccf:	74 f6                	je     800cc7 <strtol+0xe>
  800cd1:	3c 09                	cmp    $0x9,%al
  800cd3:	74 f2                	je     800cc7 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800cd5:	3c 2b                	cmp    $0x2b,%al
  800cd7:	74 2a                	je     800d03 <strtol+0x4a>
	int neg = 0;
  800cd9:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800cde:	3c 2d                	cmp    $0x2d,%al
  800ce0:	74 2b                	je     800d0d <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ce2:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ce8:	75 0f                	jne    800cf9 <strtol+0x40>
  800cea:	80 39 30             	cmpb   $0x30,(%ecx)
  800ced:	74 28                	je     800d17 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800cef:	85 db                	test   %ebx,%ebx
  800cf1:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cf6:	0f 44 d8             	cmove  %eax,%ebx
  800cf9:	b8 00 00 00 00       	mov    $0x0,%eax
  800cfe:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d01:	eb 50                	jmp    800d53 <strtol+0x9a>
		s++;
  800d03:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800d06:	bf 00 00 00 00       	mov    $0x0,%edi
  800d0b:	eb d5                	jmp    800ce2 <strtol+0x29>
		s++, neg = 1;
  800d0d:	83 c1 01             	add    $0x1,%ecx
  800d10:	bf 01 00 00 00       	mov    $0x1,%edi
  800d15:	eb cb                	jmp    800ce2 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d17:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d1b:	74 0e                	je     800d2b <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800d1d:	85 db                	test   %ebx,%ebx
  800d1f:	75 d8                	jne    800cf9 <strtol+0x40>
		s++, base = 8;
  800d21:	83 c1 01             	add    $0x1,%ecx
  800d24:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d29:	eb ce                	jmp    800cf9 <strtol+0x40>
		s += 2, base = 16;
  800d2b:	83 c1 02             	add    $0x2,%ecx
  800d2e:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d33:	eb c4                	jmp    800cf9 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d35:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d38:	89 f3                	mov    %esi,%ebx
  800d3a:	80 fb 19             	cmp    $0x19,%bl
  800d3d:	77 29                	ja     800d68 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800d3f:	0f be d2             	movsbl %dl,%edx
  800d42:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d45:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d48:	7d 30                	jge    800d7a <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800d4a:	83 c1 01             	add    $0x1,%ecx
  800d4d:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d51:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d53:	0f b6 11             	movzbl (%ecx),%edx
  800d56:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d59:	89 f3                	mov    %esi,%ebx
  800d5b:	80 fb 09             	cmp    $0x9,%bl
  800d5e:	77 d5                	ja     800d35 <strtol+0x7c>
			dig = *s - '0';
  800d60:	0f be d2             	movsbl %dl,%edx
  800d63:	83 ea 30             	sub    $0x30,%edx
  800d66:	eb dd                	jmp    800d45 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800d68:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d6b:	89 f3                	mov    %esi,%ebx
  800d6d:	80 fb 19             	cmp    $0x19,%bl
  800d70:	77 08                	ja     800d7a <strtol+0xc1>
			dig = *s - 'A' + 10;
  800d72:	0f be d2             	movsbl %dl,%edx
  800d75:	83 ea 37             	sub    $0x37,%edx
  800d78:	eb cb                	jmp    800d45 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d7a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d7e:	74 05                	je     800d85 <strtol+0xcc>
		*endptr = (char *) s;
  800d80:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d83:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d85:	89 c2                	mov    %eax,%edx
  800d87:	f7 da                	neg    %edx
  800d89:	85 ff                	test   %edi,%edi
  800d8b:	0f 45 c2             	cmovne %edx,%eax
}
  800d8e:	5b                   	pop    %ebx
  800d8f:	5e                   	pop    %esi
  800d90:	5f                   	pop    %edi
  800d91:	5d                   	pop    %ebp
  800d92:	c3                   	ret    

00800d93 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d93:	55                   	push   %ebp
  800d94:	89 e5                	mov    %esp,%ebp
  800d96:	57                   	push   %edi
  800d97:	56                   	push   %esi
  800d98:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d99:	b8 00 00 00 00       	mov    $0x0,%eax
  800d9e:	8b 55 08             	mov    0x8(%ebp),%edx
  800da1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da4:	89 c3                	mov    %eax,%ebx
  800da6:	89 c7                	mov    %eax,%edi
  800da8:	89 c6                	mov    %eax,%esi
  800daa:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800dac:	5b                   	pop    %ebx
  800dad:	5e                   	pop    %esi
  800dae:	5f                   	pop    %edi
  800daf:	5d                   	pop    %ebp
  800db0:	c3                   	ret    

00800db1 <sys_cgetc>:

int
sys_cgetc(void)
{
  800db1:	55                   	push   %ebp
  800db2:	89 e5                	mov    %esp,%ebp
  800db4:	57                   	push   %edi
  800db5:	56                   	push   %esi
  800db6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800db7:	ba 00 00 00 00       	mov    $0x0,%edx
  800dbc:	b8 01 00 00 00       	mov    $0x1,%eax
  800dc1:	89 d1                	mov    %edx,%ecx
  800dc3:	89 d3                	mov    %edx,%ebx
  800dc5:	89 d7                	mov    %edx,%edi
  800dc7:	89 d6                	mov    %edx,%esi
  800dc9:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800dcb:	5b                   	pop    %ebx
  800dcc:	5e                   	pop    %esi
  800dcd:	5f                   	pop    %edi
  800dce:	5d                   	pop    %ebp
  800dcf:	c3                   	ret    

00800dd0 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800dd0:	55                   	push   %ebp
  800dd1:	89 e5                	mov    %esp,%ebp
  800dd3:	57                   	push   %edi
  800dd4:	56                   	push   %esi
  800dd5:	53                   	push   %ebx
  800dd6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dd9:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dde:	8b 55 08             	mov    0x8(%ebp),%edx
  800de1:	b8 03 00 00 00       	mov    $0x3,%eax
  800de6:	89 cb                	mov    %ecx,%ebx
  800de8:	89 cf                	mov    %ecx,%edi
  800dea:	89 ce                	mov    %ecx,%esi
  800dec:	cd 30                	int    $0x30
	if (check && ret > 0)
  800dee:	85 c0                	test   %eax,%eax
  800df0:	7f 08                	jg     800dfa <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800df2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800df5:	5b                   	pop    %ebx
  800df6:	5e                   	pop    %esi
  800df7:	5f                   	pop    %edi
  800df8:	5d                   	pop    %ebp
  800df9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dfa:	83 ec 0c             	sub    $0xc,%esp
  800dfd:	50                   	push   %eax
  800dfe:	6a 03                	push   $0x3
  800e00:	68 e0 29 80 00       	push   $0x8029e0
  800e05:	6a 4c                	push   $0x4c
  800e07:	68 fd 29 80 00       	push   $0x8029fd
  800e0c:	e8 4b f4 ff ff       	call   80025c <_panic>

00800e11 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e11:	55                   	push   %ebp
  800e12:	89 e5                	mov    %esp,%ebp
  800e14:	57                   	push   %edi
  800e15:	56                   	push   %esi
  800e16:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e17:	ba 00 00 00 00       	mov    $0x0,%edx
  800e1c:	b8 02 00 00 00       	mov    $0x2,%eax
  800e21:	89 d1                	mov    %edx,%ecx
  800e23:	89 d3                	mov    %edx,%ebx
  800e25:	89 d7                	mov    %edx,%edi
  800e27:	89 d6                	mov    %edx,%esi
  800e29:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e2b:	5b                   	pop    %ebx
  800e2c:	5e                   	pop    %esi
  800e2d:	5f                   	pop    %edi
  800e2e:	5d                   	pop    %ebp
  800e2f:	c3                   	ret    

00800e30 <sys_yield>:

void
sys_yield(void)
{
  800e30:	55                   	push   %ebp
  800e31:	89 e5                	mov    %esp,%ebp
  800e33:	57                   	push   %edi
  800e34:	56                   	push   %esi
  800e35:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e36:	ba 00 00 00 00       	mov    $0x0,%edx
  800e3b:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e40:	89 d1                	mov    %edx,%ecx
  800e42:	89 d3                	mov    %edx,%ebx
  800e44:	89 d7                	mov    %edx,%edi
  800e46:	89 d6                	mov    %edx,%esi
  800e48:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e4a:	5b                   	pop    %ebx
  800e4b:	5e                   	pop    %esi
  800e4c:	5f                   	pop    %edi
  800e4d:	5d                   	pop    %ebp
  800e4e:	c3                   	ret    

00800e4f <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e4f:	55                   	push   %ebp
  800e50:	89 e5                	mov    %esp,%ebp
  800e52:	57                   	push   %edi
  800e53:	56                   	push   %esi
  800e54:	53                   	push   %ebx
  800e55:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e58:	be 00 00 00 00       	mov    $0x0,%esi
  800e5d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e60:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e63:	b8 04 00 00 00       	mov    $0x4,%eax
  800e68:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e6b:	89 f7                	mov    %esi,%edi
  800e6d:	cd 30                	int    $0x30
	if (check && ret > 0)
  800e6f:	85 c0                	test   %eax,%eax
  800e71:	7f 08                	jg     800e7b <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e73:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e76:	5b                   	pop    %ebx
  800e77:	5e                   	pop    %esi
  800e78:	5f                   	pop    %edi
  800e79:	5d                   	pop    %ebp
  800e7a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e7b:	83 ec 0c             	sub    $0xc,%esp
  800e7e:	50                   	push   %eax
  800e7f:	6a 04                	push   $0x4
  800e81:	68 e0 29 80 00       	push   $0x8029e0
  800e86:	6a 4c                	push   $0x4c
  800e88:	68 fd 29 80 00       	push   $0x8029fd
  800e8d:	e8 ca f3 ff ff       	call   80025c <_panic>

00800e92 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e92:	55                   	push   %ebp
  800e93:	89 e5                	mov    %esp,%ebp
  800e95:	57                   	push   %edi
  800e96:	56                   	push   %esi
  800e97:	53                   	push   %ebx
  800e98:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e9b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e9e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea1:	b8 05 00 00 00       	mov    $0x5,%eax
  800ea6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ea9:	8b 7d 14             	mov    0x14(%ebp),%edi
  800eac:	8b 75 18             	mov    0x18(%ebp),%esi
  800eaf:	cd 30                	int    $0x30
	if (check && ret > 0)
  800eb1:	85 c0                	test   %eax,%eax
  800eb3:	7f 08                	jg     800ebd <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800eb5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eb8:	5b                   	pop    %ebx
  800eb9:	5e                   	pop    %esi
  800eba:	5f                   	pop    %edi
  800ebb:	5d                   	pop    %ebp
  800ebc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ebd:	83 ec 0c             	sub    $0xc,%esp
  800ec0:	50                   	push   %eax
  800ec1:	6a 05                	push   $0x5
  800ec3:	68 e0 29 80 00       	push   $0x8029e0
  800ec8:	6a 4c                	push   $0x4c
  800eca:	68 fd 29 80 00       	push   $0x8029fd
  800ecf:	e8 88 f3 ff ff       	call   80025c <_panic>

00800ed4 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ed4:	55                   	push   %ebp
  800ed5:	89 e5                	mov    %esp,%ebp
  800ed7:	57                   	push   %edi
  800ed8:	56                   	push   %esi
  800ed9:	53                   	push   %ebx
  800eda:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800edd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ee2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee8:	b8 06 00 00 00       	mov    $0x6,%eax
  800eed:	89 df                	mov    %ebx,%edi
  800eef:	89 de                	mov    %ebx,%esi
  800ef1:	cd 30                	int    $0x30
	if (check && ret > 0)
  800ef3:	85 c0                	test   %eax,%eax
  800ef5:	7f 08                	jg     800eff <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800ef7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800efa:	5b                   	pop    %ebx
  800efb:	5e                   	pop    %esi
  800efc:	5f                   	pop    %edi
  800efd:	5d                   	pop    %ebp
  800efe:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eff:	83 ec 0c             	sub    $0xc,%esp
  800f02:	50                   	push   %eax
  800f03:	6a 06                	push   $0x6
  800f05:	68 e0 29 80 00       	push   $0x8029e0
  800f0a:	6a 4c                	push   $0x4c
  800f0c:	68 fd 29 80 00       	push   $0x8029fd
  800f11:	e8 46 f3 ff ff       	call   80025c <_panic>

00800f16 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f16:	55                   	push   %ebp
  800f17:	89 e5                	mov    %esp,%ebp
  800f19:	57                   	push   %edi
  800f1a:	56                   	push   %esi
  800f1b:	53                   	push   %ebx
  800f1c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f1f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f24:	8b 55 08             	mov    0x8(%ebp),%edx
  800f27:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f2a:	b8 08 00 00 00       	mov    $0x8,%eax
  800f2f:	89 df                	mov    %ebx,%edi
  800f31:	89 de                	mov    %ebx,%esi
  800f33:	cd 30                	int    $0x30
	if (check && ret > 0)
  800f35:	85 c0                	test   %eax,%eax
  800f37:	7f 08                	jg     800f41 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f39:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f3c:	5b                   	pop    %ebx
  800f3d:	5e                   	pop    %esi
  800f3e:	5f                   	pop    %edi
  800f3f:	5d                   	pop    %ebp
  800f40:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f41:	83 ec 0c             	sub    $0xc,%esp
  800f44:	50                   	push   %eax
  800f45:	6a 08                	push   $0x8
  800f47:	68 e0 29 80 00       	push   $0x8029e0
  800f4c:	6a 4c                	push   $0x4c
  800f4e:	68 fd 29 80 00       	push   $0x8029fd
  800f53:	e8 04 f3 ff ff       	call   80025c <_panic>

00800f58 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f58:	55                   	push   %ebp
  800f59:	89 e5                	mov    %esp,%ebp
  800f5b:	57                   	push   %edi
  800f5c:	56                   	push   %esi
  800f5d:	53                   	push   %ebx
  800f5e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f61:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f66:	8b 55 08             	mov    0x8(%ebp),%edx
  800f69:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f6c:	b8 09 00 00 00       	mov    $0x9,%eax
  800f71:	89 df                	mov    %ebx,%edi
  800f73:	89 de                	mov    %ebx,%esi
  800f75:	cd 30                	int    $0x30
	if (check && ret > 0)
  800f77:	85 c0                	test   %eax,%eax
  800f79:	7f 08                	jg     800f83 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f7e:	5b                   	pop    %ebx
  800f7f:	5e                   	pop    %esi
  800f80:	5f                   	pop    %edi
  800f81:	5d                   	pop    %ebp
  800f82:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f83:	83 ec 0c             	sub    $0xc,%esp
  800f86:	50                   	push   %eax
  800f87:	6a 09                	push   $0x9
  800f89:	68 e0 29 80 00       	push   $0x8029e0
  800f8e:	6a 4c                	push   $0x4c
  800f90:	68 fd 29 80 00       	push   $0x8029fd
  800f95:	e8 c2 f2 ff ff       	call   80025c <_panic>

00800f9a <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f9a:	55                   	push   %ebp
  800f9b:	89 e5                	mov    %esp,%ebp
  800f9d:	57                   	push   %edi
  800f9e:	56                   	push   %esi
  800f9f:	53                   	push   %ebx
  800fa0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fa3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fa8:	8b 55 08             	mov    0x8(%ebp),%edx
  800fab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fae:	b8 0a 00 00 00       	mov    $0xa,%eax
  800fb3:	89 df                	mov    %ebx,%edi
  800fb5:	89 de                	mov    %ebx,%esi
  800fb7:	cd 30                	int    $0x30
	if (check && ret > 0)
  800fb9:	85 c0                	test   %eax,%eax
  800fbb:	7f 08                	jg     800fc5 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800fbd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fc0:	5b                   	pop    %ebx
  800fc1:	5e                   	pop    %esi
  800fc2:	5f                   	pop    %edi
  800fc3:	5d                   	pop    %ebp
  800fc4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fc5:	83 ec 0c             	sub    $0xc,%esp
  800fc8:	50                   	push   %eax
  800fc9:	6a 0a                	push   $0xa
  800fcb:	68 e0 29 80 00       	push   $0x8029e0
  800fd0:	6a 4c                	push   $0x4c
  800fd2:	68 fd 29 80 00       	push   $0x8029fd
  800fd7:	e8 80 f2 ff ff       	call   80025c <_panic>

00800fdc <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800fdc:	55                   	push   %ebp
  800fdd:	89 e5                	mov    %esp,%ebp
  800fdf:	57                   	push   %edi
  800fe0:	56                   	push   %esi
  800fe1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fe2:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fe8:	b8 0c 00 00 00       	mov    $0xc,%eax
  800fed:	be 00 00 00 00       	mov    $0x0,%esi
  800ff2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ff5:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ff8:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ffa:	5b                   	pop    %ebx
  800ffb:	5e                   	pop    %esi
  800ffc:	5f                   	pop    %edi
  800ffd:	5d                   	pop    %ebp
  800ffe:	c3                   	ret    

00800fff <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800fff:	55                   	push   %ebp
  801000:	89 e5                	mov    %esp,%ebp
  801002:	57                   	push   %edi
  801003:	56                   	push   %esi
  801004:	53                   	push   %ebx
  801005:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801008:	b9 00 00 00 00       	mov    $0x0,%ecx
  80100d:	8b 55 08             	mov    0x8(%ebp),%edx
  801010:	b8 0d 00 00 00       	mov    $0xd,%eax
  801015:	89 cb                	mov    %ecx,%ebx
  801017:	89 cf                	mov    %ecx,%edi
  801019:	89 ce                	mov    %ecx,%esi
  80101b:	cd 30                	int    $0x30
	if (check && ret > 0)
  80101d:	85 c0                	test   %eax,%eax
  80101f:	7f 08                	jg     801029 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801021:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801024:	5b                   	pop    %ebx
  801025:	5e                   	pop    %esi
  801026:	5f                   	pop    %edi
  801027:	5d                   	pop    %ebp
  801028:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801029:	83 ec 0c             	sub    $0xc,%esp
  80102c:	50                   	push   %eax
  80102d:	6a 0d                	push   $0xd
  80102f:	68 e0 29 80 00       	push   $0x8029e0
  801034:	6a 4c                	push   $0x4c
  801036:	68 fd 29 80 00       	push   $0x8029fd
  80103b:	e8 1c f2 ff ff       	call   80025c <_panic>

00801040 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  801040:	55                   	push   %ebp
  801041:	89 e5                	mov    %esp,%ebp
  801043:	57                   	push   %edi
  801044:	56                   	push   %esi
  801045:	53                   	push   %ebx
	asm volatile("int %1\n"
  801046:	bb 00 00 00 00       	mov    $0x0,%ebx
  80104b:	8b 55 08             	mov    0x8(%ebp),%edx
  80104e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801051:	b8 0e 00 00 00       	mov    $0xe,%eax
  801056:	89 df                	mov    %ebx,%edi
  801058:	89 de                	mov    %ebx,%esi
  80105a:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  80105c:	5b                   	pop    %ebx
  80105d:	5e                   	pop    %esi
  80105e:	5f                   	pop    %edi
  80105f:	5d                   	pop    %ebp
  801060:	c3                   	ret    

00801061 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  801061:	55                   	push   %ebp
  801062:	89 e5                	mov    %esp,%ebp
  801064:	57                   	push   %edi
  801065:	56                   	push   %esi
  801066:	53                   	push   %ebx
	asm volatile("int %1\n"
  801067:	b9 00 00 00 00       	mov    $0x0,%ecx
  80106c:	8b 55 08             	mov    0x8(%ebp),%edx
  80106f:	b8 0f 00 00 00       	mov    $0xf,%eax
  801074:	89 cb                	mov    %ecx,%ebx
  801076:	89 cf                	mov    %ecx,%edi
  801078:	89 ce                	mov    %ecx,%esi
  80107a:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  80107c:	5b                   	pop    %ebx
  80107d:	5e                   	pop    %esi
  80107e:	5f                   	pop    %edi
  80107f:	5d                   	pop    %ebp
  801080:	c3                   	ret    

00801081 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801081:	55                   	push   %ebp
  801082:	89 e5                	mov    %esp,%ebp
  801084:	53                   	push   %ebx
  801085:	83 ec 04             	sub    $0x4,%esp
  801088:	8b 55 08             	mov    0x8(%ebp),%edx
	// cprintf("pgfault()\n");
	void *addr = (void *) utf->utf_fault_va;
  80108b:	8b 02                	mov    (%edx),%eax
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(!(err & FEC_WR) || !(uvpd[PDX(addr)] & PTE_P) || !(uvpt[PGNUM(addr)] & PTE_P) || !(uvpt[PGNUM(addr)] & PTE_COW))
  80108d:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801091:	0f 84 9c 00 00 00    	je     801133 <pgfault+0xb2>
  801097:	89 c2                	mov    %eax,%edx
  801099:	c1 ea 16             	shr    $0x16,%edx
  80109c:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010a3:	f6 c2 01             	test   $0x1,%dl
  8010a6:	0f 84 87 00 00 00    	je     801133 <pgfault+0xb2>
  8010ac:	89 c2                	mov    %eax,%edx
  8010ae:	c1 ea 0c             	shr    $0xc,%edx
  8010b1:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8010b8:	f6 c1 01             	test   $0x1,%cl
  8010bb:	74 76                	je     801133 <pgfault+0xb2>
  8010bd:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010c4:	f6 c6 08             	test   $0x8,%dh
  8010c7:	74 6a                	je     801133 <pgfault+0xb2>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  8010c9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010ce:	89 c3                	mov    %eax,%ebx

	r = sys_page_alloc(0, PFTEMP, PTE_P|PTE_U|PTE_W);
  8010d0:	83 ec 04             	sub    $0x4,%esp
  8010d3:	6a 07                	push   $0x7
  8010d5:	68 00 f0 7f 00       	push   $0x7ff000
  8010da:	6a 00                	push   $0x0
  8010dc:	e8 6e fd ff ff       	call   800e4f <sys_page_alloc>
	if(r < 0){
  8010e1:	83 c4 10             	add    $0x10,%esp
  8010e4:	85 c0                	test   %eax,%eax
  8010e6:	78 5f                	js     801147 <pgfault+0xc6>
		panic("pgfault: sys_page_alloc fail, r: %d", r);
	}

	memmove(PFTEMP, addr, PGSIZE);
  8010e8:	83 ec 04             	sub    $0x4,%esp
  8010eb:	68 00 10 00 00       	push   $0x1000
  8010f0:	53                   	push   %ebx
  8010f1:	68 00 f0 7f 00       	push   $0x7ff000
  8010f6:	e8 f0 fa ff ff       	call   800beb <memmove>

	r = sys_page_map(0, PFTEMP, 0, addr, PTE_P|PTE_U|PTE_W);
  8010fb:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801102:	53                   	push   %ebx
  801103:	6a 00                	push   $0x0
  801105:	68 00 f0 7f 00       	push   $0x7ff000
  80110a:	6a 00                	push   $0x0
  80110c:	e8 81 fd ff ff       	call   800e92 <sys_page_map>
	if(r < 0){
  801111:	83 c4 20             	add    $0x20,%esp
  801114:	85 c0                	test   %eax,%eax
  801116:	78 41                	js     801159 <pgfault+0xd8>
		panic("pgfault: sys_page_map fail, r: %d", r);
	}

	r = sys_page_unmap(0, PFTEMP);
  801118:	83 ec 08             	sub    $0x8,%esp
  80111b:	68 00 f0 7f 00       	push   $0x7ff000
  801120:	6a 00                	push   $0x0
  801122:	e8 ad fd ff ff       	call   800ed4 <sys_page_unmap>
	if(r < 0){
  801127:	83 c4 10             	add    $0x10,%esp
  80112a:	85 c0                	test   %eax,%eax
  80112c:	78 3d                	js     80116b <pgfault+0xea>
		panic("sys_page_unmap: %e", r);
	}
}
  80112e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801131:	c9                   	leave  
  801132:	c3                   	ret    
		panic("pgfault: 1\n");
  801133:	83 ec 04             	sub    $0x4,%esp
  801136:	68 0b 2a 80 00       	push   $0x802a0b
  80113b:	6a 20                	push   $0x20
  80113d:	68 17 2a 80 00       	push   $0x802a17
  801142:	e8 15 f1 ff ff       	call   80025c <_panic>
		panic("pgfault: sys_page_alloc fail, r: %d", r);
  801147:	50                   	push   %eax
  801148:	68 6c 2a 80 00       	push   $0x802a6c
  80114d:	6a 2e                	push   $0x2e
  80114f:	68 17 2a 80 00       	push   $0x802a17
  801154:	e8 03 f1 ff ff       	call   80025c <_panic>
		panic("pgfault: sys_page_map fail, r: %d", r);
  801159:	50                   	push   %eax
  80115a:	68 90 2a 80 00       	push   $0x802a90
  80115f:	6a 35                	push   $0x35
  801161:	68 17 2a 80 00       	push   $0x802a17
  801166:	e8 f1 f0 ff ff       	call   80025c <_panic>
		panic("sys_page_unmap: %e", r);
  80116b:	50                   	push   %eax
  80116c:	68 22 2a 80 00       	push   $0x802a22
  801171:	6a 3a                	push   $0x3a
  801173:	68 17 2a 80 00       	push   $0x802a17
  801178:	e8 df f0 ff ff       	call   80025c <_panic>

0080117d <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80117d:	55                   	push   %ebp
  80117e:	89 e5                	mov    %esp,%ebp
  801180:	57                   	push   %edi
  801181:	56                   	push   %esi
  801182:	53                   	push   %ebx
  801183:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	// panic("fork not implemented");
	int r;
	set_pgfault_handler(pgfault);
  801186:	68 81 10 80 00       	push   $0x801081
  80118b:	e8 c0 10 00 00       	call   802250 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801190:	b8 07 00 00 00       	mov    $0x7,%eax
  801195:	cd 30                	int    $0x30
  801197:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int i;
	uintptr_t va;
	envid_t childid = sys_exofork();
	if (childid < 0){
  80119a:	83 c4 10             	add    $0x10,%esp
  80119d:	85 c0                	test   %eax,%eax
  80119f:	78 2c                	js     8011cd <fork+0x50>
  8011a1:	89 c7                	mov    %eax,%edi
	}

	extern volatile pde_t uvpd[];
	extern volatile pte_t uvpt[];

	for (va = UTEXT; va < USTACKTOP; va += PGSIZE){
  8011a3:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if (childid == 0) {
  8011a8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8011ac:	75 72                	jne    801220 <fork+0xa3>
		thisenv = &envs[ENVX(sys_getenvid())];
  8011ae:	e8 5e fc ff ff       	call   800e11 <sys_getenvid>
  8011b3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8011b8:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8011be:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8011c3:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  8011c8:	e9 36 01 00 00       	jmp    801303 <fork+0x186>
		panic("fork: child id < 0: %d", childid);
  8011cd:	50                   	push   %eax
  8011ce:	68 35 2a 80 00       	push   $0x802a35
  8011d3:	68 83 00 00 00       	push   $0x83
  8011d8:	68 17 2a 80 00       	push   $0x802a17
  8011dd:	e8 7a f0 ff ff       	call   80025c <_panic>
			panic("sys_page_map: sys_page_map fail, r:%d\n", r);
  8011e2:	50                   	push   %eax
  8011e3:	68 b4 2a 80 00       	push   $0x802ab4
  8011e8:	6a 56                	push   $0x56
  8011ea:	68 17 2a 80 00       	push   $0x802a17
  8011ef:	e8 68 f0 ff ff       	call   80025c <_panic>
		r = sys_page_map((envid_t)0, va, envid, va, PTE_U | PTE_P);
  8011f4:	83 ec 0c             	sub    $0xc,%esp
  8011f7:	6a 05                	push   $0x5
  8011f9:	56                   	push   %esi
  8011fa:	57                   	push   %edi
  8011fb:	56                   	push   %esi
  8011fc:	6a 00                	push   $0x0
  8011fe:	e8 8f fc ff ff       	call   800e92 <sys_page_map>
		if(r < 0){
  801203:	83 c4 20             	add    $0x20,%esp
  801206:	85 c0                	test   %eax,%eax
  801208:	0f 88 9f 00 00 00    	js     8012ad <fork+0x130>
	for (va = UTEXT; va < USTACKTOP; va += PGSIZE){
  80120e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801214:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  80121a:	0f 84 9f 00 00 00    	je     8012bf <fork+0x142>
		if ((uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_U)){
  801220:	89 d8                	mov    %ebx,%eax
  801222:	c1 e8 16             	shr    $0x16,%eax
  801225:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80122c:	a8 01                	test   $0x1,%al
  80122e:	74 de                	je     80120e <fork+0x91>
  801230:	89 d8                	mov    %ebx,%eax
  801232:	c1 e8 0c             	shr    $0xc,%eax
  801235:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80123c:	f6 c2 01             	test   $0x1,%dl
  80123f:	74 cd                	je     80120e <fork+0x91>
  801241:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801248:	f6 c2 04             	test   $0x4,%dl
  80124b:	74 c1                	je     80120e <fork+0x91>
	void * va = (void *)(pn * PGSIZE);
  80124d:	89 c6                	mov    %eax,%esi
  80124f:	c1 e6 0c             	shl    $0xc,%esi
	int perm = (uvpt[pn]);
  801252:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (perm & (PTE_W | PTE_COW)) {
  801259:	a9 02 08 00 00       	test   $0x802,%eax
  80125e:	74 94                	je     8011f4 <fork+0x77>
		r = sys_page_map((envid_t)0, va, envid, va, PTE_U | PTE_P | PTE_COW);
  801260:	83 ec 0c             	sub    $0xc,%esp
  801263:	68 05 08 00 00       	push   $0x805
  801268:	56                   	push   %esi
  801269:	57                   	push   %edi
  80126a:	56                   	push   %esi
  80126b:	6a 00                	push   $0x0
  80126d:	e8 20 fc ff ff       	call   800e92 <sys_page_map>
		if(r < 0){
  801272:	83 c4 20             	add    $0x20,%esp
  801275:	85 c0                	test   %eax,%eax
  801277:	0f 88 65 ff ff ff    	js     8011e2 <fork+0x65>
		r = sys_page_map((envid_t)0, va, (envid_t)0, va, PTE_U | PTE_P | PTE_COW);
  80127d:	83 ec 0c             	sub    $0xc,%esp
  801280:	68 05 08 00 00       	push   $0x805
  801285:	56                   	push   %esi
  801286:	6a 00                	push   $0x0
  801288:	56                   	push   %esi
  801289:	6a 00                	push   $0x0
  80128b:	e8 02 fc ff ff       	call   800e92 <sys_page_map>
		if(r < 0){
  801290:	83 c4 20             	add    $0x20,%esp
  801293:	85 c0                	test   %eax,%eax
  801295:	0f 89 73 ff ff ff    	jns    80120e <fork+0x91>
			panic("sys_page_map: sys_page_map fail, r:%d\n", r);
  80129b:	50                   	push   %eax
  80129c:	68 b4 2a 80 00       	push   $0x802ab4
  8012a1:	6a 5b                	push   $0x5b
  8012a3:	68 17 2a 80 00       	push   $0x802a17
  8012a8:	e8 af ef ff ff       	call   80025c <_panic>
			panic("sys_page_map: sys_page_map fail, r:%d\n", r);
  8012ad:	50                   	push   %eax
  8012ae:	68 b4 2a 80 00       	push   $0x802ab4
  8012b3:	6a 61                	push   $0x61
  8012b5:	68 17 2a 80 00       	push   $0x802a17
  8012ba:	e8 9d ef ff ff       	call   80025c <_panic>
			duppage(childid, PGNUM(va));
		}
	}

	r = sys_page_alloc(childid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8012bf:	83 ec 04             	sub    $0x4,%esp
  8012c2:	6a 07                	push   $0x7
  8012c4:	68 00 f0 bf ee       	push   $0xeebff000
  8012c9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012cc:	e8 7e fb ff ff       	call   800e4f <sys_page_alloc>
	if (r < 0){
  8012d1:	83 c4 10             	add    $0x10,%esp
  8012d4:	85 c0                	test   %eax,%eax
  8012d6:	78 36                	js     80130e <fork+0x191>
		panic("fork: allocate user exception stack for child env error, %d", r);
	}
	r = sys_env_set_pgfault_upcall(childid, _pgfault_upcall);
  8012d8:	83 ec 08             	sub    $0x8,%esp
  8012db:	68 bb 22 80 00       	push   $0x8022bb
  8012e0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012e3:	e8 b2 fc ff ff       	call   800f9a <sys_env_set_pgfault_upcall>
	if (r < 0){
  8012e8:	83 c4 10             	add    $0x10,%esp
  8012eb:	85 c0                	test   %eax,%eax
  8012ed:	78 34                	js     801323 <fork+0x1a6>
		panic("fork: sys_env_set_pgfault_upcall error, %d", r);
	}
	r = sys_env_set_status(childid, ENV_RUNNABLE);
  8012ef:	83 ec 08             	sub    $0x8,%esp
  8012f2:	6a 02                	push   $0x2
  8012f4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012f7:	e8 1a fc ff ff       	call   800f16 <sys_env_set_status>
	if(r < 0){
  8012fc:	83 c4 10             	add    $0x10,%esp
  8012ff:	85 c0                	test   %eax,%eax
  801301:	78 35                	js     801338 <fork+0x1bb>
		panic("forK: sys_env_set_status, r%d", r);
	}
	return childid;
}
  801303:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801306:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801309:	5b                   	pop    %ebx
  80130a:	5e                   	pop    %esi
  80130b:	5f                   	pop    %edi
  80130c:	5d                   	pop    %ebp
  80130d:	c3                   	ret    
		panic("fork: allocate user exception stack for child env error, %d", r);
  80130e:	50                   	push   %eax
  80130f:	68 dc 2a 80 00       	push   $0x802adc
  801314:	68 96 00 00 00       	push   $0x96
  801319:	68 17 2a 80 00       	push   $0x802a17
  80131e:	e8 39 ef ff ff       	call   80025c <_panic>
		panic("fork: sys_env_set_pgfault_upcall error, %d", r);
  801323:	50                   	push   %eax
  801324:	68 18 2b 80 00       	push   $0x802b18
  801329:	68 9a 00 00 00       	push   $0x9a
  80132e:	68 17 2a 80 00       	push   $0x802a17
  801333:	e8 24 ef ff ff       	call   80025c <_panic>
		panic("forK: sys_env_set_status, r%d", r);
  801338:	50                   	push   %eax
  801339:	68 4c 2a 80 00       	push   $0x802a4c
  80133e:	68 9e 00 00 00       	push   $0x9e
  801343:	68 17 2a 80 00       	push   $0x802a17
  801348:	e8 0f ef ff ff       	call   80025c <_panic>

0080134d <sfork>:

// Challenge!
int
sfork(void)
{
  80134d:	55                   	push   %ebp
  80134e:	89 e5                	mov    %esp,%ebp
  801350:	57                   	push   %edi
  801351:	56                   	push   %esi
  801352:	53                   	push   %ebx
  801353:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// return -E_INVAL;
	set_pgfault_handler(pgfault);
  801356:	68 81 10 80 00       	push   $0x801081
  80135b:	e8 f0 0e 00 00       	call   802250 <set_pgfault_handler>
  801360:	b8 07 00 00 00       	mov    $0x7,%eax
  801365:	cd 30                	int    $0x30
  801367:	89 c6                	mov    %eax,%esi
	int i;
	uintptr_t va;
	envid_t childid = sys_exofork();
	int r;
	if (childid < 0){
  801369:	83 c4 10             	add    $0x10,%esp
  80136c:	85 c0                	test   %eax,%eax
  80136e:	78 28                	js     801398 <sfork+0x4b>
  801370:	89 c7                	mov    %eax,%edi
	}

	extern volatile pde_t uvpd[];
	extern volatile pte_t uvpt[];

	for (va = 0; va < USTACKTOP; va += PGSIZE){
  801372:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (childid == 0) {
  801377:	75 42                	jne    8013bb <sfork+0x6e>
		thisenv = &envs[ENVX(sys_getenvid())];
  801379:	e8 93 fa ff ff       	call   800e11 <sys_getenvid>
  80137e:	25 ff 03 00 00       	and    $0x3ff,%eax
  801383:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  801389:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80138e:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  801393:	e9 bc 00 00 00       	jmp    801454 <sfork+0x107>
		panic("fork: child id < 0: %d", childid);
  801398:	50                   	push   %eax
  801399:	68 35 2a 80 00       	push   $0x802a35
  80139e:	68 af 00 00 00       	push   $0xaf
  8013a3:	68 17 2a 80 00       	push   $0x802a17
  8013a8:	e8 af ee ff ff       	call   80025c <_panic>
	for (va = 0; va < USTACKTOP; va += PGSIZE){
  8013ad:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8013b3:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8013b9:	74 5b                	je     801416 <sfork+0xc9>
		if ((uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_U)){
  8013bb:	89 d8                	mov    %ebx,%eax
  8013bd:	c1 e8 16             	shr    $0x16,%eax
  8013c0:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8013c7:	a8 01                	test   $0x1,%al
  8013c9:	74 e2                	je     8013ad <sfork+0x60>
  8013cb:	89 d8                	mov    %ebx,%eax
  8013cd:	c1 e8 0c             	shr    $0xc,%eax
  8013d0:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8013d7:	f6 c2 01             	test   $0x1,%dl
  8013da:	74 d1                	je     8013ad <sfork+0x60>
  8013dc:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8013e3:	f6 c2 04             	test   $0x4,%dl
  8013e6:	74 c5                	je     8013ad <sfork+0x60>
			void *addr = (void *)(PGNUM(va) * PGSIZE);
  8013e8:	c1 e0 0c             	shl    $0xc,%eax
			struct PageInfo *page;
			pte_t *pte;
			
			// page = page_lookup((envid_t)0->env_pgdir, addr, &pte);
			// page_insert(dstenv->env_pgdir, page, addr, PTE_U | PTE_P);
			r = sys_page_map((envid_t)0, addr, childid, addr, PTE_U | PTE_P);
  8013eb:	83 ec 0c             	sub    $0xc,%esp
  8013ee:	6a 05                	push   $0x5
  8013f0:	50                   	push   %eax
  8013f1:	57                   	push   %edi
  8013f2:	50                   	push   %eax
  8013f3:	6a 00                	push   $0x0
  8013f5:	e8 98 fa ff ff       	call   800e92 <sys_page_map>
			if(r < 0){
  8013fa:	83 c4 20             	add    $0x20,%esp
  8013fd:	85 c0                	test   %eax,%eax
  8013ff:	79 ac                	jns    8013ad <sfork+0x60>
				panic("sfork: sys_page_map fail, r:%d\n", r);
  801401:	50                   	push   %eax
  801402:	68 44 2b 80 00       	push   $0x802b44
  801407:	68 c4 00 00 00       	push   $0xc4
  80140c:	68 17 2a 80 00       	push   $0x802a17
  801411:	e8 46 ee ff ff       	call   80025c <_panic>
			}
		}
	}

	r = sys_page_alloc(childid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801416:	83 ec 04             	sub    $0x4,%esp
  801419:	6a 07                	push   $0x7
  80141b:	68 00 f0 bf ee       	push   $0xeebff000
  801420:	56                   	push   %esi
  801421:	e8 29 fa ff ff       	call   800e4f <sys_page_alloc>
	if (r < 0){
  801426:	83 c4 10             	add    $0x10,%esp
  801429:	85 c0                	test   %eax,%eax
  80142b:	78 31                	js     80145e <sfork+0x111>
		panic("sfork: allocate user exception stack for child env error, %d", r);
	}
	r = sys_env_set_pgfault_upcall(childid, _pgfault_upcall);
  80142d:	83 ec 08             	sub    $0x8,%esp
  801430:	68 bb 22 80 00       	push   $0x8022bb
  801435:	56                   	push   %esi
  801436:	e8 5f fb ff ff       	call   800f9a <sys_env_set_pgfault_upcall>
	if (r < 0){
  80143b:	83 c4 10             	add    $0x10,%esp
  80143e:	85 c0                	test   %eax,%eax
  801440:	78 31                	js     801473 <sfork+0x126>
		panic("sfork: sys_env_set_pgfault_upcall error, %d", r);
	}
	r = sys_env_set_status(childid, ENV_RUNNABLE);
  801442:	83 ec 08             	sub    $0x8,%esp
  801445:	6a 02                	push   $0x2
  801447:	56                   	push   %esi
  801448:	e8 c9 fa ff ff       	call   800f16 <sys_env_set_status>
	if(r < 0){
  80144d:	83 c4 10             	add    $0x10,%esp
  801450:	85 c0                	test   %eax,%eax
  801452:	78 34                	js     801488 <sfork+0x13b>
		panic("sforK: sys_env_set_status, r%d", r);
	}
	return childid;
}
  801454:	89 f0                	mov    %esi,%eax
  801456:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801459:	5b                   	pop    %ebx
  80145a:	5e                   	pop    %esi
  80145b:	5f                   	pop    %edi
  80145c:	5d                   	pop    %ebp
  80145d:	c3                   	ret    
		panic("sfork: allocate user exception stack for child env error, %d", r);
  80145e:	50                   	push   %eax
  80145f:	68 64 2b 80 00       	push   $0x802b64
  801464:	68 cb 00 00 00       	push   $0xcb
  801469:	68 17 2a 80 00       	push   $0x802a17
  80146e:	e8 e9 ed ff ff       	call   80025c <_panic>
		panic("sfork: sys_env_set_pgfault_upcall error, %d", r);
  801473:	50                   	push   %eax
  801474:	68 a4 2b 80 00       	push   $0x802ba4
  801479:	68 cf 00 00 00       	push   $0xcf
  80147e:	68 17 2a 80 00       	push   $0x802a17
  801483:	e8 d4 ed ff ff       	call   80025c <_panic>
		panic("sforK: sys_env_set_status, r%d", r);
  801488:	50                   	push   %eax
  801489:	68 d0 2b 80 00       	push   $0x802bd0
  80148e:	68 d3 00 00 00       	push   $0xd3
  801493:	68 17 2a 80 00       	push   $0x802a17
  801498:	e8 bf ed ff ff       	call   80025c <_panic>

0080149d <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80149d:	55                   	push   %ebp
  80149e:	89 e5                	mov    %esp,%ebp
  8014a0:	56                   	push   %esi
  8014a1:	53                   	push   %ebx
  8014a2:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8014a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a8:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// return 0;
	if(!pg)
  8014ab:	85 c0                	test   %eax,%eax
		pg = (void*)UTOP;
  8014ad:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8014b2:	0f 44 c2             	cmove  %edx,%eax
	
	int ret;

	ret = sys_ipc_recv(pg);
  8014b5:	83 ec 0c             	sub    $0xc,%esp
  8014b8:	50                   	push   %eax
  8014b9:	e8 41 fb ff ff       	call   800fff <sys_ipc_recv>
	if(ret < 0){
  8014be:	83 c4 10             	add    $0x10,%esp
  8014c1:	85 c0                	test   %eax,%eax
  8014c3:	78 2b                	js     8014f0 <ipc_recv+0x53>
		if(perm_store) *perm_store = 0;
		if(from_env_store) *from_env_store = 0;
		return ret;
	}
	
	if(perm_store)
  8014c5:	85 f6                	test   %esi,%esi
  8014c7:	74 0a                	je     8014d3 <ipc_recv+0x36>
		*perm_store = thisenv->env_ipc_perm;
  8014c9:	a1 04 40 80 00       	mov    0x804004,%eax
  8014ce:	8b 40 78             	mov    0x78(%eax),%eax
  8014d1:	89 06                	mov    %eax,(%esi)
	if(from_env_store)
  8014d3:	85 db                	test   %ebx,%ebx
  8014d5:	74 0a                	je     8014e1 <ipc_recv+0x44>
		*from_env_store = thisenv->env_ipc_from;
  8014d7:	a1 04 40 80 00       	mov    0x804004,%eax
  8014dc:	8b 40 74             	mov    0x74(%eax),%eax
  8014df:	89 03                	mov    %eax,(%ebx)

	return thisenv->env_ipc_value;
  8014e1:	a1 04 40 80 00       	mov    0x804004,%eax
  8014e6:	8b 40 70             	mov    0x70(%eax),%eax
}
  8014e9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014ec:	5b                   	pop    %ebx
  8014ed:	5e                   	pop    %esi
  8014ee:	5d                   	pop    %ebp
  8014ef:	c3                   	ret    
		if(perm_store) *perm_store = 0;
  8014f0:	85 f6                	test   %esi,%esi
  8014f2:	74 06                	je     8014fa <ipc_recv+0x5d>
  8014f4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(from_env_store) *from_env_store = 0;
  8014fa:	85 db                	test   %ebx,%ebx
  8014fc:	74 eb                	je     8014e9 <ipc_recv+0x4c>
  8014fe:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801504:	eb e3                	jmp    8014e9 <ipc_recv+0x4c>

00801506 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801506:	55                   	push   %ebp
  801507:	89 e5                	mov    %esp,%ebp
  801509:	57                   	push   %edi
  80150a:	56                   	push   %esi
  80150b:	53                   	push   %ebx
  80150c:	83 ec 0c             	sub    $0xc,%esp
  80150f:	8b 7d 08             	mov    0x8(%ebp),%edi
  801512:	8b 75 0c             	mov    0xc(%ebp),%esi
  801515:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
	if (!pg)
  801518:	85 db                	test   %ebx,%ebx
		pg = (void*)UTOP;
  80151a:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80151f:	0f 44 d8             	cmove  %eax,%ebx

	int ret = -E_IPC_NOT_RECV;
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))) {
  801522:	ff 75 14             	pushl  0x14(%ebp)
  801525:	53                   	push   %ebx
  801526:	56                   	push   %esi
  801527:	57                   	push   %edi
  801528:	e8 af fa ff ff       	call   800fdc <sys_ipc_try_send>
  80152d:	83 c4 10             	add    $0x10,%esp
  801530:	85 c0                	test   %eax,%eax
  801532:	74 17                	je     80154b <ipc_send+0x45>
		if(ret != -E_IPC_NOT_RECV){
  801534:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801537:	74 e9                	je     801522 <ipc_send+0x1c>
			panic("ipc_send: ret : %d", ret);
  801539:	50                   	push   %eax
  80153a:	68 ef 2b 80 00       	push   $0x802bef
  80153f:	6a 43                	push   $0x43
  801541:	68 02 2c 80 00       	push   $0x802c02
  801546:	e8 11 ed ff ff       	call   80025c <_panic>
			sys_yield();
		}
	}
}
  80154b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80154e:	5b                   	pop    %ebx
  80154f:	5e                   	pop    %esi
  801550:	5f                   	pop    %edi
  801551:	5d                   	pop    %ebp
  801552:	c3                   	ret    

00801553 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801553:	55                   	push   %ebp
  801554:	89 e5                	mov    %esp,%ebp
  801556:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801559:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80155e:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  801564:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80156a:	8b 52 50             	mov    0x50(%edx),%edx
  80156d:	39 ca                	cmp    %ecx,%edx
  80156f:	74 11                	je     801582 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  801571:	83 c0 01             	add    $0x1,%eax
  801574:	3d 00 04 00 00       	cmp    $0x400,%eax
  801579:	75 e3                	jne    80155e <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80157b:	b8 00 00 00 00       	mov    $0x0,%eax
  801580:	eb 0e                	jmp    801590 <ipc_find_env+0x3d>
			return envs[i].env_id;
  801582:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  801588:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80158d:	8b 40 48             	mov    0x48(%eax),%eax
}
  801590:	5d                   	pop    %ebp
  801591:	c3                   	ret    

00801592 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801592:	55                   	push   %ebp
  801593:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801595:	8b 45 08             	mov    0x8(%ebp),%eax
  801598:	05 00 00 00 30       	add    $0x30000000,%eax
  80159d:	c1 e8 0c             	shr    $0xc,%eax
}
  8015a0:	5d                   	pop    %ebp
  8015a1:	c3                   	ret    

008015a2 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8015a2:	55                   	push   %ebp
  8015a3:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8015a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a8:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8015ad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015b2:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8015b7:	5d                   	pop    %ebp
  8015b8:	c3                   	ret    

008015b9 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8015b9:	55                   	push   %ebp
  8015ba:	89 e5                	mov    %esp,%ebp
  8015bc:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8015c1:	89 c2                	mov    %eax,%edx
  8015c3:	c1 ea 16             	shr    $0x16,%edx
  8015c6:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8015cd:	f6 c2 01             	test   $0x1,%dl
  8015d0:	74 2d                	je     8015ff <fd_alloc+0x46>
  8015d2:	89 c2                	mov    %eax,%edx
  8015d4:	c1 ea 0c             	shr    $0xc,%edx
  8015d7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8015de:	f6 c2 01             	test   $0x1,%dl
  8015e1:	74 1c                	je     8015ff <fd_alloc+0x46>
  8015e3:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8015e8:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8015ed:	75 d2                	jne    8015c1 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8015ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8015f8:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8015fd:	eb 0a                	jmp    801609 <fd_alloc+0x50>
			*fd_store = fd;
  8015ff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801602:	89 01                	mov    %eax,(%ecx)
			return 0;
  801604:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801609:	5d                   	pop    %ebp
  80160a:	c3                   	ret    

0080160b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80160b:	55                   	push   %ebp
  80160c:	89 e5                	mov    %esp,%ebp
  80160e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801611:	83 f8 1f             	cmp    $0x1f,%eax
  801614:	77 30                	ja     801646 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801616:	c1 e0 0c             	shl    $0xc,%eax
  801619:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80161e:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801624:	f6 c2 01             	test   $0x1,%dl
  801627:	74 24                	je     80164d <fd_lookup+0x42>
  801629:	89 c2                	mov    %eax,%edx
  80162b:	c1 ea 0c             	shr    $0xc,%edx
  80162e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801635:	f6 c2 01             	test   $0x1,%dl
  801638:	74 1a                	je     801654 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80163a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80163d:	89 02                	mov    %eax,(%edx)
	return 0;
  80163f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801644:	5d                   	pop    %ebp
  801645:	c3                   	ret    
		return -E_INVAL;
  801646:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80164b:	eb f7                	jmp    801644 <fd_lookup+0x39>
		return -E_INVAL;
  80164d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801652:	eb f0                	jmp    801644 <fd_lookup+0x39>
  801654:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801659:	eb e9                	jmp    801644 <fd_lookup+0x39>

0080165b <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80165b:	55                   	push   %ebp
  80165c:	89 e5                	mov    %esp,%ebp
  80165e:	83 ec 08             	sub    $0x8,%esp
  801661:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801664:	ba 88 2c 80 00       	mov    $0x802c88,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801669:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80166e:	39 08                	cmp    %ecx,(%eax)
  801670:	74 33                	je     8016a5 <dev_lookup+0x4a>
  801672:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801675:	8b 02                	mov    (%edx),%eax
  801677:	85 c0                	test   %eax,%eax
  801679:	75 f3                	jne    80166e <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80167b:	a1 04 40 80 00       	mov    0x804004,%eax
  801680:	8b 40 48             	mov    0x48(%eax),%eax
  801683:	83 ec 04             	sub    $0x4,%esp
  801686:	51                   	push   %ecx
  801687:	50                   	push   %eax
  801688:	68 0c 2c 80 00       	push   $0x802c0c
  80168d:	e8 a5 ec ff ff       	call   800337 <cprintf>
	*dev = 0;
  801692:	8b 45 0c             	mov    0xc(%ebp),%eax
  801695:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80169b:	83 c4 10             	add    $0x10,%esp
  80169e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8016a3:	c9                   	leave  
  8016a4:	c3                   	ret    
			*dev = devtab[i];
  8016a5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016a8:	89 01                	mov    %eax,(%ecx)
			return 0;
  8016aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8016af:	eb f2                	jmp    8016a3 <dev_lookup+0x48>

008016b1 <fd_close>:
{
  8016b1:	55                   	push   %ebp
  8016b2:	89 e5                	mov    %esp,%ebp
  8016b4:	57                   	push   %edi
  8016b5:	56                   	push   %esi
  8016b6:	53                   	push   %ebx
  8016b7:	83 ec 24             	sub    $0x24,%esp
  8016ba:	8b 75 08             	mov    0x8(%ebp),%esi
  8016bd:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8016c0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8016c3:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016c4:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8016ca:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8016cd:	50                   	push   %eax
  8016ce:	e8 38 ff ff ff       	call   80160b <fd_lookup>
  8016d3:	89 c3                	mov    %eax,%ebx
  8016d5:	83 c4 10             	add    $0x10,%esp
  8016d8:	85 c0                	test   %eax,%eax
  8016da:	78 05                	js     8016e1 <fd_close+0x30>
	    || fd != fd2)
  8016dc:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8016df:	74 16                	je     8016f7 <fd_close+0x46>
		return (must_exist ? r : 0);
  8016e1:	89 f8                	mov    %edi,%eax
  8016e3:	84 c0                	test   %al,%al
  8016e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ea:	0f 44 d8             	cmove  %eax,%ebx
}
  8016ed:	89 d8                	mov    %ebx,%eax
  8016ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016f2:	5b                   	pop    %ebx
  8016f3:	5e                   	pop    %esi
  8016f4:	5f                   	pop    %edi
  8016f5:	5d                   	pop    %ebp
  8016f6:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8016f7:	83 ec 08             	sub    $0x8,%esp
  8016fa:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8016fd:	50                   	push   %eax
  8016fe:	ff 36                	pushl  (%esi)
  801700:	e8 56 ff ff ff       	call   80165b <dev_lookup>
  801705:	89 c3                	mov    %eax,%ebx
  801707:	83 c4 10             	add    $0x10,%esp
  80170a:	85 c0                	test   %eax,%eax
  80170c:	78 1a                	js     801728 <fd_close+0x77>
		if (dev->dev_close)
  80170e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801711:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801714:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801719:	85 c0                	test   %eax,%eax
  80171b:	74 0b                	je     801728 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80171d:	83 ec 0c             	sub    $0xc,%esp
  801720:	56                   	push   %esi
  801721:	ff d0                	call   *%eax
  801723:	89 c3                	mov    %eax,%ebx
  801725:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801728:	83 ec 08             	sub    $0x8,%esp
  80172b:	56                   	push   %esi
  80172c:	6a 00                	push   $0x0
  80172e:	e8 a1 f7 ff ff       	call   800ed4 <sys_page_unmap>
	return r;
  801733:	83 c4 10             	add    $0x10,%esp
  801736:	eb b5                	jmp    8016ed <fd_close+0x3c>

00801738 <close>:

int
close(int fdnum)
{
  801738:	55                   	push   %ebp
  801739:	89 e5                	mov    %esp,%ebp
  80173b:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80173e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801741:	50                   	push   %eax
  801742:	ff 75 08             	pushl  0x8(%ebp)
  801745:	e8 c1 fe ff ff       	call   80160b <fd_lookup>
  80174a:	83 c4 10             	add    $0x10,%esp
  80174d:	85 c0                	test   %eax,%eax
  80174f:	79 02                	jns    801753 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801751:	c9                   	leave  
  801752:	c3                   	ret    
		return fd_close(fd, 1);
  801753:	83 ec 08             	sub    $0x8,%esp
  801756:	6a 01                	push   $0x1
  801758:	ff 75 f4             	pushl  -0xc(%ebp)
  80175b:	e8 51 ff ff ff       	call   8016b1 <fd_close>
  801760:	83 c4 10             	add    $0x10,%esp
  801763:	eb ec                	jmp    801751 <close+0x19>

00801765 <close_all>:

void
close_all(void)
{
  801765:	55                   	push   %ebp
  801766:	89 e5                	mov    %esp,%ebp
  801768:	53                   	push   %ebx
  801769:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80176c:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801771:	83 ec 0c             	sub    $0xc,%esp
  801774:	53                   	push   %ebx
  801775:	e8 be ff ff ff       	call   801738 <close>
	for (i = 0; i < MAXFD; i++)
  80177a:	83 c3 01             	add    $0x1,%ebx
  80177d:	83 c4 10             	add    $0x10,%esp
  801780:	83 fb 20             	cmp    $0x20,%ebx
  801783:	75 ec                	jne    801771 <close_all+0xc>
}
  801785:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801788:	c9                   	leave  
  801789:	c3                   	ret    

0080178a <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80178a:	55                   	push   %ebp
  80178b:	89 e5                	mov    %esp,%ebp
  80178d:	57                   	push   %edi
  80178e:	56                   	push   %esi
  80178f:	53                   	push   %ebx
  801790:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801793:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801796:	50                   	push   %eax
  801797:	ff 75 08             	pushl  0x8(%ebp)
  80179a:	e8 6c fe ff ff       	call   80160b <fd_lookup>
  80179f:	89 c3                	mov    %eax,%ebx
  8017a1:	83 c4 10             	add    $0x10,%esp
  8017a4:	85 c0                	test   %eax,%eax
  8017a6:	0f 88 81 00 00 00    	js     80182d <dup+0xa3>
		return r;
	close(newfdnum);
  8017ac:	83 ec 0c             	sub    $0xc,%esp
  8017af:	ff 75 0c             	pushl  0xc(%ebp)
  8017b2:	e8 81 ff ff ff       	call   801738 <close>

	newfd = INDEX2FD(newfdnum);
  8017b7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8017ba:	c1 e6 0c             	shl    $0xc,%esi
  8017bd:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8017c3:	83 c4 04             	add    $0x4,%esp
  8017c6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8017c9:	e8 d4 fd ff ff       	call   8015a2 <fd2data>
  8017ce:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8017d0:	89 34 24             	mov    %esi,(%esp)
  8017d3:	e8 ca fd ff ff       	call   8015a2 <fd2data>
  8017d8:	83 c4 10             	add    $0x10,%esp
  8017db:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8017dd:	89 d8                	mov    %ebx,%eax
  8017df:	c1 e8 16             	shr    $0x16,%eax
  8017e2:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8017e9:	a8 01                	test   $0x1,%al
  8017eb:	74 11                	je     8017fe <dup+0x74>
  8017ed:	89 d8                	mov    %ebx,%eax
  8017ef:	c1 e8 0c             	shr    $0xc,%eax
  8017f2:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8017f9:	f6 c2 01             	test   $0x1,%dl
  8017fc:	75 39                	jne    801837 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8017fe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801801:	89 d0                	mov    %edx,%eax
  801803:	c1 e8 0c             	shr    $0xc,%eax
  801806:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80180d:	83 ec 0c             	sub    $0xc,%esp
  801810:	25 07 0e 00 00       	and    $0xe07,%eax
  801815:	50                   	push   %eax
  801816:	56                   	push   %esi
  801817:	6a 00                	push   $0x0
  801819:	52                   	push   %edx
  80181a:	6a 00                	push   $0x0
  80181c:	e8 71 f6 ff ff       	call   800e92 <sys_page_map>
  801821:	89 c3                	mov    %eax,%ebx
  801823:	83 c4 20             	add    $0x20,%esp
  801826:	85 c0                	test   %eax,%eax
  801828:	78 31                	js     80185b <dup+0xd1>
		goto err;

	return newfdnum;
  80182a:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80182d:	89 d8                	mov    %ebx,%eax
  80182f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801832:	5b                   	pop    %ebx
  801833:	5e                   	pop    %esi
  801834:	5f                   	pop    %edi
  801835:	5d                   	pop    %ebp
  801836:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801837:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80183e:	83 ec 0c             	sub    $0xc,%esp
  801841:	25 07 0e 00 00       	and    $0xe07,%eax
  801846:	50                   	push   %eax
  801847:	57                   	push   %edi
  801848:	6a 00                	push   $0x0
  80184a:	53                   	push   %ebx
  80184b:	6a 00                	push   $0x0
  80184d:	e8 40 f6 ff ff       	call   800e92 <sys_page_map>
  801852:	89 c3                	mov    %eax,%ebx
  801854:	83 c4 20             	add    $0x20,%esp
  801857:	85 c0                	test   %eax,%eax
  801859:	79 a3                	jns    8017fe <dup+0x74>
	sys_page_unmap(0, newfd);
  80185b:	83 ec 08             	sub    $0x8,%esp
  80185e:	56                   	push   %esi
  80185f:	6a 00                	push   $0x0
  801861:	e8 6e f6 ff ff       	call   800ed4 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801866:	83 c4 08             	add    $0x8,%esp
  801869:	57                   	push   %edi
  80186a:	6a 00                	push   $0x0
  80186c:	e8 63 f6 ff ff       	call   800ed4 <sys_page_unmap>
	return r;
  801871:	83 c4 10             	add    $0x10,%esp
  801874:	eb b7                	jmp    80182d <dup+0xa3>

00801876 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801876:	55                   	push   %ebp
  801877:	89 e5                	mov    %esp,%ebp
  801879:	53                   	push   %ebx
  80187a:	83 ec 1c             	sub    $0x1c,%esp
  80187d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801880:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801883:	50                   	push   %eax
  801884:	53                   	push   %ebx
  801885:	e8 81 fd ff ff       	call   80160b <fd_lookup>
  80188a:	83 c4 10             	add    $0x10,%esp
  80188d:	85 c0                	test   %eax,%eax
  80188f:	78 3f                	js     8018d0 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801891:	83 ec 08             	sub    $0x8,%esp
  801894:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801897:	50                   	push   %eax
  801898:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80189b:	ff 30                	pushl  (%eax)
  80189d:	e8 b9 fd ff ff       	call   80165b <dev_lookup>
  8018a2:	83 c4 10             	add    $0x10,%esp
  8018a5:	85 c0                	test   %eax,%eax
  8018a7:	78 27                	js     8018d0 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8018a9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018ac:	8b 42 08             	mov    0x8(%edx),%eax
  8018af:	83 e0 03             	and    $0x3,%eax
  8018b2:	83 f8 01             	cmp    $0x1,%eax
  8018b5:	74 1e                	je     8018d5 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8018b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018ba:	8b 40 08             	mov    0x8(%eax),%eax
  8018bd:	85 c0                	test   %eax,%eax
  8018bf:	74 35                	je     8018f6 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8018c1:	83 ec 04             	sub    $0x4,%esp
  8018c4:	ff 75 10             	pushl  0x10(%ebp)
  8018c7:	ff 75 0c             	pushl  0xc(%ebp)
  8018ca:	52                   	push   %edx
  8018cb:	ff d0                	call   *%eax
  8018cd:	83 c4 10             	add    $0x10,%esp
}
  8018d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018d3:	c9                   	leave  
  8018d4:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8018d5:	a1 04 40 80 00       	mov    0x804004,%eax
  8018da:	8b 40 48             	mov    0x48(%eax),%eax
  8018dd:	83 ec 04             	sub    $0x4,%esp
  8018e0:	53                   	push   %ebx
  8018e1:	50                   	push   %eax
  8018e2:	68 4d 2c 80 00       	push   $0x802c4d
  8018e7:	e8 4b ea ff ff       	call   800337 <cprintf>
		return -E_INVAL;
  8018ec:	83 c4 10             	add    $0x10,%esp
  8018ef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018f4:	eb da                	jmp    8018d0 <read+0x5a>
		return -E_NOT_SUPP;
  8018f6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018fb:	eb d3                	jmp    8018d0 <read+0x5a>

008018fd <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8018fd:	55                   	push   %ebp
  8018fe:	89 e5                	mov    %esp,%ebp
  801900:	57                   	push   %edi
  801901:	56                   	push   %esi
  801902:	53                   	push   %ebx
  801903:	83 ec 0c             	sub    $0xc,%esp
  801906:	8b 7d 08             	mov    0x8(%ebp),%edi
  801909:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80190c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801911:	39 f3                	cmp    %esi,%ebx
  801913:	73 23                	jae    801938 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801915:	83 ec 04             	sub    $0x4,%esp
  801918:	89 f0                	mov    %esi,%eax
  80191a:	29 d8                	sub    %ebx,%eax
  80191c:	50                   	push   %eax
  80191d:	89 d8                	mov    %ebx,%eax
  80191f:	03 45 0c             	add    0xc(%ebp),%eax
  801922:	50                   	push   %eax
  801923:	57                   	push   %edi
  801924:	e8 4d ff ff ff       	call   801876 <read>
		if (m < 0)
  801929:	83 c4 10             	add    $0x10,%esp
  80192c:	85 c0                	test   %eax,%eax
  80192e:	78 06                	js     801936 <readn+0x39>
			return m;
		if (m == 0)
  801930:	74 06                	je     801938 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801932:	01 c3                	add    %eax,%ebx
  801934:	eb db                	jmp    801911 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801936:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801938:	89 d8                	mov    %ebx,%eax
  80193a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80193d:	5b                   	pop    %ebx
  80193e:	5e                   	pop    %esi
  80193f:	5f                   	pop    %edi
  801940:	5d                   	pop    %ebp
  801941:	c3                   	ret    

00801942 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801942:	55                   	push   %ebp
  801943:	89 e5                	mov    %esp,%ebp
  801945:	53                   	push   %ebx
  801946:	83 ec 1c             	sub    $0x1c,%esp
  801949:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80194c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80194f:	50                   	push   %eax
  801950:	53                   	push   %ebx
  801951:	e8 b5 fc ff ff       	call   80160b <fd_lookup>
  801956:	83 c4 10             	add    $0x10,%esp
  801959:	85 c0                	test   %eax,%eax
  80195b:	78 3a                	js     801997 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80195d:	83 ec 08             	sub    $0x8,%esp
  801960:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801963:	50                   	push   %eax
  801964:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801967:	ff 30                	pushl  (%eax)
  801969:	e8 ed fc ff ff       	call   80165b <dev_lookup>
  80196e:	83 c4 10             	add    $0x10,%esp
  801971:	85 c0                	test   %eax,%eax
  801973:	78 22                	js     801997 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801975:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801978:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80197c:	74 1e                	je     80199c <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80197e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801981:	8b 52 0c             	mov    0xc(%edx),%edx
  801984:	85 d2                	test   %edx,%edx
  801986:	74 35                	je     8019bd <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801988:	83 ec 04             	sub    $0x4,%esp
  80198b:	ff 75 10             	pushl  0x10(%ebp)
  80198e:	ff 75 0c             	pushl  0xc(%ebp)
  801991:	50                   	push   %eax
  801992:	ff d2                	call   *%edx
  801994:	83 c4 10             	add    $0x10,%esp
}
  801997:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80199a:	c9                   	leave  
  80199b:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80199c:	a1 04 40 80 00       	mov    0x804004,%eax
  8019a1:	8b 40 48             	mov    0x48(%eax),%eax
  8019a4:	83 ec 04             	sub    $0x4,%esp
  8019a7:	53                   	push   %ebx
  8019a8:	50                   	push   %eax
  8019a9:	68 69 2c 80 00       	push   $0x802c69
  8019ae:	e8 84 e9 ff ff       	call   800337 <cprintf>
		return -E_INVAL;
  8019b3:	83 c4 10             	add    $0x10,%esp
  8019b6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019bb:	eb da                	jmp    801997 <write+0x55>
		return -E_NOT_SUPP;
  8019bd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019c2:	eb d3                	jmp    801997 <write+0x55>

008019c4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8019c4:	55                   	push   %ebp
  8019c5:	89 e5                	mov    %esp,%ebp
  8019c7:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019ca:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019cd:	50                   	push   %eax
  8019ce:	ff 75 08             	pushl  0x8(%ebp)
  8019d1:	e8 35 fc ff ff       	call   80160b <fd_lookup>
  8019d6:	83 c4 10             	add    $0x10,%esp
  8019d9:	85 c0                	test   %eax,%eax
  8019db:	78 0e                	js     8019eb <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8019dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019e3:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8019e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019eb:	c9                   	leave  
  8019ec:	c3                   	ret    

008019ed <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8019ed:	55                   	push   %ebp
  8019ee:	89 e5                	mov    %esp,%ebp
  8019f0:	53                   	push   %ebx
  8019f1:	83 ec 1c             	sub    $0x1c,%esp
  8019f4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019f7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019fa:	50                   	push   %eax
  8019fb:	53                   	push   %ebx
  8019fc:	e8 0a fc ff ff       	call   80160b <fd_lookup>
  801a01:	83 c4 10             	add    $0x10,%esp
  801a04:	85 c0                	test   %eax,%eax
  801a06:	78 37                	js     801a3f <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a08:	83 ec 08             	sub    $0x8,%esp
  801a0b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a0e:	50                   	push   %eax
  801a0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a12:	ff 30                	pushl  (%eax)
  801a14:	e8 42 fc ff ff       	call   80165b <dev_lookup>
  801a19:	83 c4 10             	add    $0x10,%esp
  801a1c:	85 c0                	test   %eax,%eax
  801a1e:	78 1f                	js     801a3f <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a23:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a27:	74 1b                	je     801a44 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801a29:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a2c:	8b 52 18             	mov    0x18(%edx),%edx
  801a2f:	85 d2                	test   %edx,%edx
  801a31:	74 32                	je     801a65 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801a33:	83 ec 08             	sub    $0x8,%esp
  801a36:	ff 75 0c             	pushl  0xc(%ebp)
  801a39:	50                   	push   %eax
  801a3a:	ff d2                	call   *%edx
  801a3c:	83 c4 10             	add    $0x10,%esp
}
  801a3f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a42:	c9                   	leave  
  801a43:	c3                   	ret    
			thisenv->env_id, fdnum);
  801a44:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801a49:	8b 40 48             	mov    0x48(%eax),%eax
  801a4c:	83 ec 04             	sub    $0x4,%esp
  801a4f:	53                   	push   %ebx
  801a50:	50                   	push   %eax
  801a51:	68 2c 2c 80 00       	push   $0x802c2c
  801a56:	e8 dc e8 ff ff       	call   800337 <cprintf>
		return -E_INVAL;
  801a5b:	83 c4 10             	add    $0x10,%esp
  801a5e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a63:	eb da                	jmp    801a3f <ftruncate+0x52>
		return -E_NOT_SUPP;
  801a65:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a6a:	eb d3                	jmp    801a3f <ftruncate+0x52>

00801a6c <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801a6c:	55                   	push   %ebp
  801a6d:	89 e5                	mov    %esp,%ebp
  801a6f:	53                   	push   %ebx
  801a70:	83 ec 1c             	sub    $0x1c,%esp
  801a73:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a76:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a79:	50                   	push   %eax
  801a7a:	ff 75 08             	pushl  0x8(%ebp)
  801a7d:	e8 89 fb ff ff       	call   80160b <fd_lookup>
  801a82:	83 c4 10             	add    $0x10,%esp
  801a85:	85 c0                	test   %eax,%eax
  801a87:	78 4b                	js     801ad4 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a89:	83 ec 08             	sub    $0x8,%esp
  801a8c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a8f:	50                   	push   %eax
  801a90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a93:	ff 30                	pushl  (%eax)
  801a95:	e8 c1 fb ff ff       	call   80165b <dev_lookup>
  801a9a:	83 c4 10             	add    $0x10,%esp
  801a9d:	85 c0                	test   %eax,%eax
  801a9f:	78 33                	js     801ad4 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801aa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aa4:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801aa8:	74 2f                	je     801ad9 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801aaa:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801aad:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801ab4:	00 00 00 
	stat->st_isdir = 0;
  801ab7:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801abe:	00 00 00 
	stat->st_dev = dev;
  801ac1:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801ac7:	83 ec 08             	sub    $0x8,%esp
  801aca:	53                   	push   %ebx
  801acb:	ff 75 f0             	pushl  -0x10(%ebp)
  801ace:	ff 50 14             	call   *0x14(%eax)
  801ad1:	83 c4 10             	add    $0x10,%esp
}
  801ad4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ad7:	c9                   	leave  
  801ad8:	c3                   	ret    
		return -E_NOT_SUPP;
  801ad9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ade:	eb f4                	jmp    801ad4 <fstat+0x68>

00801ae0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801ae0:	55                   	push   %ebp
  801ae1:	89 e5                	mov    %esp,%ebp
  801ae3:	56                   	push   %esi
  801ae4:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801ae5:	83 ec 08             	sub    $0x8,%esp
  801ae8:	6a 00                	push   $0x0
  801aea:	ff 75 08             	pushl  0x8(%ebp)
  801aed:	e8 bb 01 00 00       	call   801cad <open>
  801af2:	89 c3                	mov    %eax,%ebx
  801af4:	83 c4 10             	add    $0x10,%esp
  801af7:	85 c0                	test   %eax,%eax
  801af9:	78 1b                	js     801b16 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801afb:	83 ec 08             	sub    $0x8,%esp
  801afe:	ff 75 0c             	pushl  0xc(%ebp)
  801b01:	50                   	push   %eax
  801b02:	e8 65 ff ff ff       	call   801a6c <fstat>
  801b07:	89 c6                	mov    %eax,%esi
	close(fd);
  801b09:	89 1c 24             	mov    %ebx,(%esp)
  801b0c:	e8 27 fc ff ff       	call   801738 <close>
	return r;
  801b11:	83 c4 10             	add    $0x10,%esp
  801b14:	89 f3                	mov    %esi,%ebx
}
  801b16:	89 d8                	mov    %ebx,%eax
  801b18:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b1b:	5b                   	pop    %ebx
  801b1c:	5e                   	pop    %esi
  801b1d:	5d                   	pop    %ebp
  801b1e:	c3                   	ret    

00801b1f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801b1f:	55                   	push   %ebp
  801b20:	89 e5                	mov    %esp,%ebp
  801b22:	56                   	push   %esi
  801b23:	53                   	push   %ebx
  801b24:	89 c6                	mov    %eax,%esi
  801b26:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801b28:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801b2f:	74 27                	je     801b58 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801b31:	6a 07                	push   $0x7
  801b33:	68 00 50 80 00       	push   $0x805000
  801b38:	56                   	push   %esi
  801b39:	ff 35 00 40 80 00    	pushl  0x804000
  801b3f:	e8 c2 f9 ff ff       	call   801506 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801b44:	83 c4 0c             	add    $0xc,%esp
  801b47:	6a 00                	push   $0x0
  801b49:	53                   	push   %ebx
  801b4a:	6a 00                	push   $0x0
  801b4c:	e8 4c f9 ff ff       	call   80149d <ipc_recv>
}
  801b51:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b54:	5b                   	pop    %ebx
  801b55:	5e                   	pop    %esi
  801b56:	5d                   	pop    %ebp
  801b57:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801b58:	83 ec 0c             	sub    $0xc,%esp
  801b5b:	6a 01                	push   $0x1
  801b5d:	e8 f1 f9 ff ff       	call   801553 <ipc_find_env>
  801b62:	a3 00 40 80 00       	mov    %eax,0x804000
  801b67:	83 c4 10             	add    $0x10,%esp
  801b6a:	eb c5                	jmp    801b31 <fsipc+0x12>

00801b6c <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801b6c:	55                   	push   %ebp
  801b6d:	89 e5                	mov    %esp,%ebp
  801b6f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801b72:	8b 45 08             	mov    0x8(%ebp),%eax
  801b75:	8b 40 0c             	mov    0xc(%eax),%eax
  801b78:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801b7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b80:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801b85:	ba 00 00 00 00       	mov    $0x0,%edx
  801b8a:	b8 02 00 00 00       	mov    $0x2,%eax
  801b8f:	e8 8b ff ff ff       	call   801b1f <fsipc>
}
  801b94:	c9                   	leave  
  801b95:	c3                   	ret    

00801b96 <devfile_flush>:
{
  801b96:	55                   	push   %ebp
  801b97:	89 e5                	mov    %esp,%ebp
  801b99:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801b9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9f:	8b 40 0c             	mov    0xc(%eax),%eax
  801ba2:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801ba7:	ba 00 00 00 00       	mov    $0x0,%edx
  801bac:	b8 06 00 00 00       	mov    $0x6,%eax
  801bb1:	e8 69 ff ff ff       	call   801b1f <fsipc>
}
  801bb6:	c9                   	leave  
  801bb7:	c3                   	ret    

00801bb8 <devfile_stat>:
{
  801bb8:	55                   	push   %ebp
  801bb9:	89 e5                	mov    %esp,%ebp
  801bbb:	53                   	push   %ebx
  801bbc:	83 ec 04             	sub    $0x4,%esp
  801bbf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc5:	8b 40 0c             	mov    0xc(%eax),%eax
  801bc8:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801bcd:	ba 00 00 00 00       	mov    $0x0,%edx
  801bd2:	b8 05 00 00 00       	mov    $0x5,%eax
  801bd7:	e8 43 ff ff ff       	call   801b1f <fsipc>
  801bdc:	85 c0                	test   %eax,%eax
  801bde:	78 2c                	js     801c0c <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801be0:	83 ec 08             	sub    $0x8,%esp
  801be3:	68 00 50 80 00       	push   $0x805000
  801be8:	53                   	push   %ebx
  801be9:	e8 6f ee ff ff       	call   800a5d <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801bee:	a1 80 50 80 00       	mov    0x805080,%eax
  801bf3:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801bf9:	a1 84 50 80 00       	mov    0x805084,%eax
  801bfe:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801c04:	83 c4 10             	add    $0x10,%esp
  801c07:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c0c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c0f:	c9                   	leave  
  801c10:	c3                   	ret    

00801c11 <devfile_write>:
{
  801c11:	55                   	push   %ebp
  801c12:	89 e5                	mov    %esp,%ebp
  801c14:	83 ec 0c             	sub    $0xc,%esp
	panic("devfile_write not implemented");
  801c17:	68 98 2c 80 00       	push   $0x802c98
  801c1c:	68 90 00 00 00       	push   $0x90
  801c21:	68 b6 2c 80 00       	push   $0x802cb6
  801c26:	e8 31 e6 ff ff       	call   80025c <_panic>

00801c2b <devfile_read>:
{
  801c2b:	55                   	push   %ebp
  801c2c:	89 e5                	mov    %esp,%ebp
  801c2e:	56                   	push   %esi
  801c2f:	53                   	push   %ebx
  801c30:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801c33:	8b 45 08             	mov    0x8(%ebp),%eax
  801c36:	8b 40 0c             	mov    0xc(%eax),%eax
  801c39:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801c3e:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801c44:	ba 00 00 00 00       	mov    $0x0,%edx
  801c49:	b8 03 00 00 00       	mov    $0x3,%eax
  801c4e:	e8 cc fe ff ff       	call   801b1f <fsipc>
  801c53:	89 c3                	mov    %eax,%ebx
  801c55:	85 c0                	test   %eax,%eax
  801c57:	78 1f                	js     801c78 <devfile_read+0x4d>
	assert(r <= n);
  801c59:	39 f0                	cmp    %esi,%eax
  801c5b:	77 24                	ja     801c81 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801c5d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c62:	7f 33                	jg     801c97 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801c64:	83 ec 04             	sub    $0x4,%esp
  801c67:	50                   	push   %eax
  801c68:	68 00 50 80 00       	push   $0x805000
  801c6d:	ff 75 0c             	pushl  0xc(%ebp)
  801c70:	e8 76 ef ff ff       	call   800beb <memmove>
	return r;
  801c75:	83 c4 10             	add    $0x10,%esp
}
  801c78:	89 d8                	mov    %ebx,%eax
  801c7a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c7d:	5b                   	pop    %ebx
  801c7e:	5e                   	pop    %esi
  801c7f:	5d                   	pop    %ebp
  801c80:	c3                   	ret    
	assert(r <= n);
  801c81:	68 c1 2c 80 00       	push   $0x802cc1
  801c86:	68 c8 2c 80 00       	push   $0x802cc8
  801c8b:	6a 7c                	push   $0x7c
  801c8d:	68 b6 2c 80 00       	push   $0x802cb6
  801c92:	e8 c5 e5 ff ff       	call   80025c <_panic>
	assert(r <= PGSIZE);
  801c97:	68 dd 2c 80 00       	push   $0x802cdd
  801c9c:	68 c8 2c 80 00       	push   $0x802cc8
  801ca1:	6a 7d                	push   $0x7d
  801ca3:	68 b6 2c 80 00       	push   $0x802cb6
  801ca8:	e8 af e5 ff ff       	call   80025c <_panic>

00801cad <open>:
{
  801cad:	55                   	push   %ebp
  801cae:	89 e5                	mov    %esp,%ebp
  801cb0:	56                   	push   %esi
  801cb1:	53                   	push   %ebx
  801cb2:	83 ec 1c             	sub    $0x1c,%esp
  801cb5:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801cb8:	56                   	push   %esi
  801cb9:	e8 66 ed ff ff       	call   800a24 <strlen>
  801cbe:	83 c4 10             	add    $0x10,%esp
  801cc1:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801cc6:	7f 6c                	jg     801d34 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801cc8:	83 ec 0c             	sub    $0xc,%esp
  801ccb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cce:	50                   	push   %eax
  801ccf:	e8 e5 f8 ff ff       	call   8015b9 <fd_alloc>
  801cd4:	89 c3                	mov    %eax,%ebx
  801cd6:	83 c4 10             	add    $0x10,%esp
  801cd9:	85 c0                	test   %eax,%eax
  801cdb:	78 3c                	js     801d19 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801cdd:	83 ec 08             	sub    $0x8,%esp
  801ce0:	56                   	push   %esi
  801ce1:	68 00 50 80 00       	push   $0x805000
  801ce6:	e8 72 ed ff ff       	call   800a5d <strcpy>
	fsipcbuf.open.req_omode = mode;
  801ceb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cee:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801cf3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cf6:	b8 01 00 00 00       	mov    $0x1,%eax
  801cfb:	e8 1f fe ff ff       	call   801b1f <fsipc>
  801d00:	89 c3                	mov    %eax,%ebx
  801d02:	83 c4 10             	add    $0x10,%esp
  801d05:	85 c0                	test   %eax,%eax
  801d07:	78 19                	js     801d22 <open+0x75>
	return fd2num(fd);
  801d09:	83 ec 0c             	sub    $0xc,%esp
  801d0c:	ff 75 f4             	pushl  -0xc(%ebp)
  801d0f:	e8 7e f8 ff ff       	call   801592 <fd2num>
  801d14:	89 c3                	mov    %eax,%ebx
  801d16:	83 c4 10             	add    $0x10,%esp
}
  801d19:	89 d8                	mov    %ebx,%eax
  801d1b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d1e:	5b                   	pop    %ebx
  801d1f:	5e                   	pop    %esi
  801d20:	5d                   	pop    %ebp
  801d21:	c3                   	ret    
		fd_close(fd, 0);
  801d22:	83 ec 08             	sub    $0x8,%esp
  801d25:	6a 00                	push   $0x0
  801d27:	ff 75 f4             	pushl  -0xc(%ebp)
  801d2a:	e8 82 f9 ff ff       	call   8016b1 <fd_close>
		return r;
  801d2f:	83 c4 10             	add    $0x10,%esp
  801d32:	eb e5                	jmp    801d19 <open+0x6c>
		return -E_BAD_PATH;
  801d34:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801d39:	eb de                	jmp    801d19 <open+0x6c>

00801d3b <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801d3b:	55                   	push   %ebp
  801d3c:	89 e5                	mov    %esp,%ebp
  801d3e:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801d41:	ba 00 00 00 00       	mov    $0x0,%edx
  801d46:	b8 08 00 00 00       	mov    $0x8,%eax
  801d4b:	e8 cf fd ff ff       	call   801b1f <fsipc>
}
  801d50:	c9                   	leave  
  801d51:	c3                   	ret    

00801d52 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801d52:	55                   	push   %ebp
  801d53:	89 e5                	mov    %esp,%ebp
  801d55:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801d58:	89 d0                	mov    %edx,%eax
  801d5a:	c1 e8 16             	shr    $0x16,%eax
  801d5d:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801d64:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801d69:	f6 c1 01             	test   $0x1,%cl
  801d6c:	74 1d                	je     801d8b <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801d6e:	c1 ea 0c             	shr    $0xc,%edx
  801d71:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801d78:	f6 c2 01             	test   $0x1,%dl
  801d7b:	74 0e                	je     801d8b <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801d7d:	c1 ea 0c             	shr    $0xc,%edx
  801d80:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801d87:	ef 
  801d88:	0f b7 c0             	movzwl %ax,%eax
}
  801d8b:	5d                   	pop    %ebp
  801d8c:	c3                   	ret    

00801d8d <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801d8d:	55                   	push   %ebp
  801d8e:	89 e5                	mov    %esp,%ebp
  801d90:	56                   	push   %esi
  801d91:	53                   	push   %ebx
  801d92:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801d95:	83 ec 0c             	sub    $0xc,%esp
  801d98:	ff 75 08             	pushl  0x8(%ebp)
  801d9b:	e8 02 f8 ff ff       	call   8015a2 <fd2data>
  801da0:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801da2:	83 c4 08             	add    $0x8,%esp
  801da5:	68 e9 2c 80 00       	push   $0x802ce9
  801daa:	53                   	push   %ebx
  801dab:	e8 ad ec ff ff       	call   800a5d <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801db0:	8b 46 04             	mov    0x4(%esi),%eax
  801db3:	2b 06                	sub    (%esi),%eax
  801db5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801dbb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801dc2:	00 00 00 
	stat->st_dev = &devpipe;
  801dc5:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801dcc:	30 80 00 
	return 0;
}
  801dcf:	b8 00 00 00 00       	mov    $0x0,%eax
  801dd4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dd7:	5b                   	pop    %ebx
  801dd8:	5e                   	pop    %esi
  801dd9:	5d                   	pop    %ebp
  801dda:	c3                   	ret    

00801ddb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801ddb:	55                   	push   %ebp
  801ddc:	89 e5                	mov    %esp,%ebp
  801dde:	53                   	push   %ebx
  801ddf:	83 ec 0c             	sub    $0xc,%esp
  801de2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801de5:	53                   	push   %ebx
  801de6:	6a 00                	push   $0x0
  801de8:	e8 e7 f0 ff ff       	call   800ed4 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801ded:	89 1c 24             	mov    %ebx,(%esp)
  801df0:	e8 ad f7 ff ff       	call   8015a2 <fd2data>
  801df5:	83 c4 08             	add    $0x8,%esp
  801df8:	50                   	push   %eax
  801df9:	6a 00                	push   $0x0
  801dfb:	e8 d4 f0 ff ff       	call   800ed4 <sys_page_unmap>
}
  801e00:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e03:	c9                   	leave  
  801e04:	c3                   	ret    

00801e05 <_pipeisclosed>:
{
  801e05:	55                   	push   %ebp
  801e06:	89 e5                	mov    %esp,%ebp
  801e08:	57                   	push   %edi
  801e09:	56                   	push   %esi
  801e0a:	53                   	push   %ebx
  801e0b:	83 ec 1c             	sub    $0x1c,%esp
  801e0e:	89 c7                	mov    %eax,%edi
  801e10:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801e12:	a1 04 40 80 00       	mov    0x804004,%eax
  801e17:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801e1a:	83 ec 0c             	sub    $0xc,%esp
  801e1d:	57                   	push   %edi
  801e1e:	e8 2f ff ff ff       	call   801d52 <pageref>
  801e23:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801e26:	89 34 24             	mov    %esi,(%esp)
  801e29:	e8 24 ff ff ff       	call   801d52 <pageref>
		nn = thisenv->env_runs;
  801e2e:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801e34:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801e37:	83 c4 10             	add    $0x10,%esp
  801e3a:	39 cb                	cmp    %ecx,%ebx
  801e3c:	74 1b                	je     801e59 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801e3e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e41:	75 cf                	jne    801e12 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801e43:	8b 42 58             	mov    0x58(%edx),%eax
  801e46:	6a 01                	push   $0x1
  801e48:	50                   	push   %eax
  801e49:	53                   	push   %ebx
  801e4a:	68 f0 2c 80 00       	push   $0x802cf0
  801e4f:	e8 e3 e4 ff ff       	call   800337 <cprintf>
  801e54:	83 c4 10             	add    $0x10,%esp
  801e57:	eb b9                	jmp    801e12 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801e59:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e5c:	0f 94 c0             	sete   %al
  801e5f:	0f b6 c0             	movzbl %al,%eax
}
  801e62:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e65:	5b                   	pop    %ebx
  801e66:	5e                   	pop    %esi
  801e67:	5f                   	pop    %edi
  801e68:	5d                   	pop    %ebp
  801e69:	c3                   	ret    

00801e6a <devpipe_write>:
{
  801e6a:	55                   	push   %ebp
  801e6b:	89 e5                	mov    %esp,%ebp
  801e6d:	57                   	push   %edi
  801e6e:	56                   	push   %esi
  801e6f:	53                   	push   %ebx
  801e70:	83 ec 28             	sub    $0x28,%esp
  801e73:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801e76:	56                   	push   %esi
  801e77:	e8 26 f7 ff ff       	call   8015a2 <fd2data>
  801e7c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e7e:	83 c4 10             	add    $0x10,%esp
  801e81:	bf 00 00 00 00       	mov    $0x0,%edi
  801e86:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801e89:	74 4f                	je     801eda <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801e8b:	8b 43 04             	mov    0x4(%ebx),%eax
  801e8e:	8b 0b                	mov    (%ebx),%ecx
  801e90:	8d 51 20             	lea    0x20(%ecx),%edx
  801e93:	39 d0                	cmp    %edx,%eax
  801e95:	72 14                	jb     801eab <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801e97:	89 da                	mov    %ebx,%edx
  801e99:	89 f0                	mov    %esi,%eax
  801e9b:	e8 65 ff ff ff       	call   801e05 <_pipeisclosed>
  801ea0:	85 c0                	test   %eax,%eax
  801ea2:	75 3b                	jne    801edf <devpipe_write+0x75>
			sys_yield();
  801ea4:	e8 87 ef ff ff       	call   800e30 <sys_yield>
  801ea9:	eb e0                	jmp    801e8b <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801eab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801eae:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801eb2:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801eb5:	89 c2                	mov    %eax,%edx
  801eb7:	c1 fa 1f             	sar    $0x1f,%edx
  801eba:	89 d1                	mov    %edx,%ecx
  801ebc:	c1 e9 1b             	shr    $0x1b,%ecx
  801ebf:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801ec2:	83 e2 1f             	and    $0x1f,%edx
  801ec5:	29 ca                	sub    %ecx,%edx
  801ec7:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801ecb:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801ecf:	83 c0 01             	add    $0x1,%eax
  801ed2:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801ed5:	83 c7 01             	add    $0x1,%edi
  801ed8:	eb ac                	jmp    801e86 <devpipe_write+0x1c>
	return i;
  801eda:	8b 45 10             	mov    0x10(%ebp),%eax
  801edd:	eb 05                	jmp    801ee4 <devpipe_write+0x7a>
				return 0;
  801edf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ee4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ee7:	5b                   	pop    %ebx
  801ee8:	5e                   	pop    %esi
  801ee9:	5f                   	pop    %edi
  801eea:	5d                   	pop    %ebp
  801eeb:	c3                   	ret    

00801eec <devpipe_read>:
{
  801eec:	55                   	push   %ebp
  801eed:	89 e5                	mov    %esp,%ebp
  801eef:	57                   	push   %edi
  801ef0:	56                   	push   %esi
  801ef1:	53                   	push   %ebx
  801ef2:	83 ec 18             	sub    $0x18,%esp
  801ef5:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801ef8:	57                   	push   %edi
  801ef9:	e8 a4 f6 ff ff       	call   8015a2 <fd2data>
  801efe:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801f00:	83 c4 10             	add    $0x10,%esp
  801f03:	be 00 00 00 00       	mov    $0x0,%esi
  801f08:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f0b:	75 14                	jne    801f21 <devpipe_read+0x35>
	return i;
  801f0d:	8b 45 10             	mov    0x10(%ebp),%eax
  801f10:	eb 02                	jmp    801f14 <devpipe_read+0x28>
				return i;
  801f12:	89 f0                	mov    %esi,%eax
}
  801f14:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f17:	5b                   	pop    %ebx
  801f18:	5e                   	pop    %esi
  801f19:	5f                   	pop    %edi
  801f1a:	5d                   	pop    %ebp
  801f1b:	c3                   	ret    
			sys_yield();
  801f1c:	e8 0f ef ff ff       	call   800e30 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801f21:	8b 03                	mov    (%ebx),%eax
  801f23:	3b 43 04             	cmp    0x4(%ebx),%eax
  801f26:	75 18                	jne    801f40 <devpipe_read+0x54>
			if (i > 0)
  801f28:	85 f6                	test   %esi,%esi
  801f2a:	75 e6                	jne    801f12 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801f2c:	89 da                	mov    %ebx,%edx
  801f2e:	89 f8                	mov    %edi,%eax
  801f30:	e8 d0 fe ff ff       	call   801e05 <_pipeisclosed>
  801f35:	85 c0                	test   %eax,%eax
  801f37:	74 e3                	je     801f1c <devpipe_read+0x30>
				return 0;
  801f39:	b8 00 00 00 00       	mov    $0x0,%eax
  801f3e:	eb d4                	jmp    801f14 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801f40:	99                   	cltd   
  801f41:	c1 ea 1b             	shr    $0x1b,%edx
  801f44:	01 d0                	add    %edx,%eax
  801f46:	83 e0 1f             	and    $0x1f,%eax
  801f49:	29 d0                	sub    %edx,%eax
  801f4b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801f50:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f53:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801f56:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801f59:	83 c6 01             	add    $0x1,%esi
  801f5c:	eb aa                	jmp    801f08 <devpipe_read+0x1c>

00801f5e <pipe>:
{
  801f5e:	55                   	push   %ebp
  801f5f:	89 e5                	mov    %esp,%ebp
  801f61:	56                   	push   %esi
  801f62:	53                   	push   %ebx
  801f63:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801f66:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f69:	50                   	push   %eax
  801f6a:	e8 4a f6 ff ff       	call   8015b9 <fd_alloc>
  801f6f:	89 c3                	mov    %eax,%ebx
  801f71:	83 c4 10             	add    $0x10,%esp
  801f74:	85 c0                	test   %eax,%eax
  801f76:	0f 88 23 01 00 00    	js     80209f <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f7c:	83 ec 04             	sub    $0x4,%esp
  801f7f:	68 07 04 00 00       	push   $0x407
  801f84:	ff 75 f4             	pushl  -0xc(%ebp)
  801f87:	6a 00                	push   $0x0
  801f89:	e8 c1 ee ff ff       	call   800e4f <sys_page_alloc>
  801f8e:	89 c3                	mov    %eax,%ebx
  801f90:	83 c4 10             	add    $0x10,%esp
  801f93:	85 c0                	test   %eax,%eax
  801f95:	0f 88 04 01 00 00    	js     80209f <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801f9b:	83 ec 0c             	sub    $0xc,%esp
  801f9e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801fa1:	50                   	push   %eax
  801fa2:	e8 12 f6 ff ff       	call   8015b9 <fd_alloc>
  801fa7:	89 c3                	mov    %eax,%ebx
  801fa9:	83 c4 10             	add    $0x10,%esp
  801fac:	85 c0                	test   %eax,%eax
  801fae:	0f 88 db 00 00 00    	js     80208f <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fb4:	83 ec 04             	sub    $0x4,%esp
  801fb7:	68 07 04 00 00       	push   $0x407
  801fbc:	ff 75 f0             	pushl  -0x10(%ebp)
  801fbf:	6a 00                	push   $0x0
  801fc1:	e8 89 ee ff ff       	call   800e4f <sys_page_alloc>
  801fc6:	89 c3                	mov    %eax,%ebx
  801fc8:	83 c4 10             	add    $0x10,%esp
  801fcb:	85 c0                	test   %eax,%eax
  801fcd:	0f 88 bc 00 00 00    	js     80208f <pipe+0x131>
	va = fd2data(fd0);
  801fd3:	83 ec 0c             	sub    $0xc,%esp
  801fd6:	ff 75 f4             	pushl  -0xc(%ebp)
  801fd9:	e8 c4 f5 ff ff       	call   8015a2 <fd2data>
  801fde:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fe0:	83 c4 0c             	add    $0xc,%esp
  801fe3:	68 07 04 00 00       	push   $0x407
  801fe8:	50                   	push   %eax
  801fe9:	6a 00                	push   $0x0
  801feb:	e8 5f ee ff ff       	call   800e4f <sys_page_alloc>
  801ff0:	89 c3                	mov    %eax,%ebx
  801ff2:	83 c4 10             	add    $0x10,%esp
  801ff5:	85 c0                	test   %eax,%eax
  801ff7:	0f 88 82 00 00 00    	js     80207f <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ffd:	83 ec 0c             	sub    $0xc,%esp
  802000:	ff 75 f0             	pushl  -0x10(%ebp)
  802003:	e8 9a f5 ff ff       	call   8015a2 <fd2data>
  802008:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80200f:	50                   	push   %eax
  802010:	6a 00                	push   $0x0
  802012:	56                   	push   %esi
  802013:	6a 00                	push   $0x0
  802015:	e8 78 ee ff ff       	call   800e92 <sys_page_map>
  80201a:	89 c3                	mov    %eax,%ebx
  80201c:	83 c4 20             	add    $0x20,%esp
  80201f:	85 c0                	test   %eax,%eax
  802021:	78 4e                	js     802071 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802023:	a1 20 30 80 00       	mov    0x803020,%eax
  802028:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80202b:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80202d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802030:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802037:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80203a:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80203c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80203f:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802046:	83 ec 0c             	sub    $0xc,%esp
  802049:	ff 75 f4             	pushl  -0xc(%ebp)
  80204c:	e8 41 f5 ff ff       	call   801592 <fd2num>
  802051:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802054:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802056:	83 c4 04             	add    $0x4,%esp
  802059:	ff 75 f0             	pushl  -0x10(%ebp)
  80205c:	e8 31 f5 ff ff       	call   801592 <fd2num>
  802061:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802064:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802067:	83 c4 10             	add    $0x10,%esp
  80206a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80206f:	eb 2e                	jmp    80209f <pipe+0x141>
	sys_page_unmap(0, va);
  802071:	83 ec 08             	sub    $0x8,%esp
  802074:	56                   	push   %esi
  802075:	6a 00                	push   $0x0
  802077:	e8 58 ee ff ff       	call   800ed4 <sys_page_unmap>
  80207c:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80207f:	83 ec 08             	sub    $0x8,%esp
  802082:	ff 75 f0             	pushl  -0x10(%ebp)
  802085:	6a 00                	push   $0x0
  802087:	e8 48 ee ff ff       	call   800ed4 <sys_page_unmap>
  80208c:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80208f:	83 ec 08             	sub    $0x8,%esp
  802092:	ff 75 f4             	pushl  -0xc(%ebp)
  802095:	6a 00                	push   $0x0
  802097:	e8 38 ee ff ff       	call   800ed4 <sys_page_unmap>
  80209c:	83 c4 10             	add    $0x10,%esp
}
  80209f:	89 d8                	mov    %ebx,%eax
  8020a1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020a4:	5b                   	pop    %ebx
  8020a5:	5e                   	pop    %esi
  8020a6:	5d                   	pop    %ebp
  8020a7:	c3                   	ret    

008020a8 <pipeisclosed>:
{
  8020a8:	55                   	push   %ebp
  8020a9:	89 e5                	mov    %esp,%ebp
  8020ab:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020ae:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020b1:	50                   	push   %eax
  8020b2:	ff 75 08             	pushl  0x8(%ebp)
  8020b5:	e8 51 f5 ff ff       	call   80160b <fd_lookup>
  8020ba:	83 c4 10             	add    $0x10,%esp
  8020bd:	85 c0                	test   %eax,%eax
  8020bf:	78 18                	js     8020d9 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8020c1:	83 ec 0c             	sub    $0xc,%esp
  8020c4:	ff 75 f4             	pushl  -0xc(%ebp)
  8020c7:	e8 d6 f4 ff ff       	call   8015a2 <fd2data>
	return _pipeisclosed(fd, p);
  8020cc:	89 c2                	mov    %eax,%edx
  8020ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d1:	e8 2f fd ff ff       	call   801e05 <_pipeisclosed>
  8020d6:	83 c4 10             	add    $0x10,%esp
}
  8020d9:	c9                   	leave  
  8020da:	c3                   	ret    

008020db <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8020db:	b8 00 00 00 00       	mov    $0x0,%eax
  8020e0:	c3                   	ret    

008020e1 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8020e1:	55                   	push   %ebp
  8020e2:	89 e5                	mov    %esp,%ebp
  8020e4:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8020e7:	68 08 2d 80 00       	push   $0x802d08
  8020ec:	ff 75 0c             	pushl  0xc(%ebp)
  8020ef:	e8 69 e9 ff ff       	call   800a5d <strcpy>
	return 0;
}
  8020f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f9:	c9                   	leave  
  8020fa:	c3                   	ret    

008020fb <devcons_write>:
{
  8020fb:	55                   	push   %ebp
  8020fc:	89 e5                	mov    %esp,%ebp
  8020fe:	57                   	push   %edi
  8020ff:	56                   	push   %esi
  802100:	53                   	push   %ebx
  802101:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802107:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80210c:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802112:	3b 75 10             	cmp    0x10(%ebp),%esi
  802115:	73 31                	jae    802148 <devcons_write+0x4d>
		m = n - tot;
  802117:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80211a:	29 f3                	sub    %esi,%ebx
  80211c:	83 fb 7f             	cmp    $0x7f,%ebx
  80211f:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802124:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802127:	83 ec 04             	sub    $0x4,%esp
  80212a:	53                   	push   %ebx
  80212b:	89 f0                	mov    %esi,%eax
  80212d:	03 45 0c             	add    0xc(%ebp),%eax
  802130:	50                   	push   %eax
  802131:	57                   	push   %edi
  802132:	e8 b4 ea ff ff       	call   800beb <memmove>
		sys_cputs(buf, m);
  802137:	83 c4 08             	add    $0x8,%esp
  80213a:	53                   	push   %ebx
  80213b:	57                   	push   %edi
  80213c:	e8 52 ec ff ff       	call   800d93 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802141:	01 de                	add    %ebx,%esi
  802143:	83 c4 10             	add    $0x10,%esp
  802146:	eb ca                	jmp    802112 <devcons_write+0x17>
}
  802148:	89 f0                	mov    %esi,%eax
  80214a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80214d:	5b                   	pop    %ebx
  80214e:	5e                   	pop    %esi
  80214f:	5f                   	pop    %edi
  802150:	5d                   	pop    %ebp
  802151:	c3                   	ret    

00802152 <devcons_read>:
{
  802152:	55                   	push   %ebp
  802153:	89 e5                	mov    %esp,%ebp
  802155:	83 ec 08             	sub    $0x8,%esp
  802158:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80215d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802161:	74 21                	je     802184 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802163:	e8 49 ec ff ff       	call   800db1 <sys_cgetc>
  802168:	85 c0                	test   %eax,%eax
  80216a:	75 07                	jne    802173 <devcons_read+0x21>
		sys_yield();
  80216c:	e8 bf ec ff ff       	call   800e30 <sys_yield>
  802171:	eb f0                	jmp    802163 <devcons_read+0x11>
	if (c < 0)
  802173:	78 0f                	js     802184 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802175:	83 f8 04             	cmp    $0x4,%eax
  802178:	74 0c                	je     802186 <devcons_read+0x34>
	*(char*)vbuf = c;
  80217a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80217d:	88 02                	mov    %al,(%edx)
	return 1;
  80217f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802184:	c9                   	leave  
  802185:	c3                   	ret    
		return 0;
  802186:	b8 00 00 00 00       	mov    $0x0,%eax
  80218b:	eb f7                	jmp    802184 <devcons_read+0x32>

0080218d <cputchar>:
{
  80218d:	55                   	push   %ebp
  80218e:	89 e5                	mov    %esp,%ebp
  802190:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802193:	8b 45 08             	mov    0x8(%ebp),%eax
  802196:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802199:	6a 01                	push   $0x1
  80219b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80219e:	50                   	push   %eax
  80219f:	e8 ef eb ff ff       	call   800d93 <sys_cputs>
}
  8021a4:	83 c4 10             	add    $0x10,%esp
  8021a7:	c9                   	leave  
  8021a8:	c3                   	ret    

008021a9 <getchar>:
{
  8021a9:	55                   	push   %ebp
  8021aa:	89 e5                	mov    %esp,%ebp
  8021ac:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8021af:	6a 01                	push   $0x1
  8021b1:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021b4:	50                   	push   %eax
  8021b5:	6a 00                	push   $0x0
  8021b7:	e8 ba f6 ff ff       	call   801876 <read>
	if (r < 0)
  8021bc:	83 c4 10             	add    $0x10,%esp
  8021bf:	85 c0                	test   %eax,%eax
  8021c1:	78 06                	js     8021c9 <getchar+0x20>
	if (r < 1)
  8021c3:	74 06                	je     8021cb <getchar+0x22>
	return c;
  8021c5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8021c9:	c9                   	leave  
  8021ca:	c3                   	ret    
		return -E_EOF;
  8021cb:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8021d0:	eb f7                	jmp    8021c9 <getchar+0x20>

008021d2 <iscons>:
{
  8021d2:	55                   	push   %ebp
  8021d3:	89 e5                	mov    %esp,%ebp
  8021d5:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021d8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021db:	50                   	push   %eax
  8021dc:	ff 75 08             	pushl  0x8(%ebp)
  8021df:	e8 27 f4 ff ff       	call   80160b <fd_lookup>
  8021e4:	83 c4 10             	add    $0x10,%esp
  8021e7:	85 c0                	test   %eax,%eax
  8021e9:	78 11                	js     8021fc <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8021eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ee:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8021f4:	39 10                	cmp    %edx,(%eax)
  8021f6:	0f 94 c0             	sete   %al
  8021f9:	0f b6 c0             	movzbl %al,%eax
}
  8021fc:	c9                   	leave  
  8021fd:	c3                   	ret    

008021fe <opencons>:
{
  8021fe:	55                   	push   %ebp
  8021ff:	89 e5                	mov    %esp,%ebp
  802201:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802204:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802207:	50                   	push   %eax
  802208:	e8 ac f3 ff ff       	call   8015b9 <fd_alloc>
  80220d:	83 c4 10             	add    $0x10,%esp
  802210:	85 c0                	test   %eax,%eax
  802212:	78 3a                	js     80224e <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802214:	83 ec 04             	sub    $0x4,%esp
  802217:	68 07 04 00 00       	push   $0x407
  80221c:	ff 75 f4             	pushl  -0xc(%ebp)
  80221f:	6a 00                	push   $0x0
  802221:	e8 29 ec ff ff       	call   800e4f <sys_page_alloc>
  802226:	83 c4 10             	add    $0x10,%esp
  802229:	85 c0                	test   %eax,%eax
  80222b:	78 21                	js     80224e <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80222d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802230:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802236:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802238:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802242:	83 ec 0c             	sub    $0xc,%esp
  802245:	50                   	push   %eax
  802246:	e8 47 f3 ff ff       	call   801592 <fd2num>
  80224b:	83 c4 10             	add    $0x10,%esp
}
  80224e:	c9                   	leave  
  80224f:	c3                   	ret    

00802250 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802250:	55                   	push   %ebp
  802251:	89 e5                	mov    %esp,%ebp
  802253:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802256:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  80225d:	74 0a                	je     802269 <set_pgfault_handler+0x19>
			panic("set_pgfault_handler: sys_env_set_pgfault_upcall fail, ret:%d", ret);
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80225f:	8b 45 08             	mov    0x8(%ebp),%eax
  802262:	a3 00 60 80 00       	mov    %eax,0x806000
}
  802267:	c9                   	leave  
  802268:	c3                   	ret    
		ret = sys_page_alloc((envid_t)0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W);
  802269:	83 ec 04             	sub    $0x4,%esp
  80226c:	6a 07                	push   $0x7
  80226e:	68 00 f0 bf ee       	push   $0xeebff000
  802273:	6a 00                	push   $0x0
  802275:	e8 d5 eb ff ff       	call   800e4f <sys_page_alloc>
		if(ret < 0){
  80227a:	83 c4 10             	add    $0x10,%esp
  80227d:	85 c0                	test   %eax,%eax
  80227f:	78 28                	js     8022a9 <set_pgfault_handler+0x59>
    	ret = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  802281:	83 ec 08             	sub    $0x8,%esp
  802284:	68 bb 22 80 00       	push   $0x8022bb
  802289:	6a 00                	push   $0x0
  80228b:	e8 0a ed ff ff       	call   800f9a <sys_env_set_pgfault_upcall>
		if(ret < 0){
  802290:	83 c4 10             	add    $0x10,%esp
  802293:	85 c0                	test   %eax,%eax
  802295:	79 c8                	jns    80225f <set_pgfault_handler+0xf>
			panic("set_pgfault_handler: sys_env_set_pgfault_upcall fail, ret:%d", ret);
  802297:	50                   	push   %eax
  802298:	68 48 2d 80 00       	push   $0x802d48
  80229d:	6a 28                	push   $0x28
  80229f:	68 88 2d 80 00       	push   $0x802d88
  8022a4:	e8 b3 df ff ff       	call   80025c <_panic>
			panic("set_pgfault_handler: sys_page_alloc fail, ret:%d", ret);
  8022a9:	50                   	push   %eax
  8022aa:	68 14 2d 80 00       	push   $0x802d14
  8022af:	6a 24                	push   $0x24
  8022b1:	68 88 2d 80 00       	push   $0x802d88
  8022b6:	e8 a1 df ff ff       	call   80025c <_panic>

008022bb <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8022bb:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8022bc:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  8022c1:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8022c3:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %edi
  8022c6:	8b 7c 24 28          	mov    0x28(%esp),%edi
	movl 0x30(%esp), %esi
  8022ca:	8b 74 24 30          	mov    0x30(%esp),%esi
	subl $4, %esi
  8022ce:	83 ee 04             	sub    $0x4,%esi
	movl %edi, (%esi)
  8022d1:	89 3e                	mov    %edi,(%esi)
	movl %esi, 0x30(%esp)
  8022d3:	89 74 24 30          	mov    %esi,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  8022d7:	83 c4 08             	add    $0x8,%esp
	popal
  8022da:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8022db:	83 c4 04             	add    $0x4,%esp
	popfl
  8022de:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8022df:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  8022e0:	c3                   	ret    
  8022e1:	66 90                	xchg   %ax,%ax
  8022e3:	66 90                	xchg   %ax,%ax
  8022e5:	66 90                	xchg   %ax,%ax
  8022e7:	66 90                	xchg   %ax,%ax
  8022e9:	66 90                	xchg   %ax,%ax
  8022eb:	66 90                	xchg   %ax,%ax
  8022ed:	66 90                	xchg   %ax,%ax
  8022ef:	90                   	nop

008022f0 <__udivdi3>:
  8022f0:	55                   	push   %ebp
  8022f1:	57                   	push   %edi
  8022f2:	56                   	push   %esi
  8022f3:	53                   	push   %ebx
  8022f4:	83 ec 1c             	sub    $0x1c,%esp
  8022f7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8022fb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8022ff:	8b 74 24 34          	mov    0x34(%esp),%esi
  802303:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802307:	85 d2                	test   %edx,%edx
  802309:	75 4d                	jne    802358 <__udivdi3+0x68>
  80230b:	39 f3                	cmp    %esi,%ebx
  80230d:	76 19                	jbe    802328 <__udivdi3+0x38>
  80230f:	31 ff                	xor    %edi,%edi
  802311:	89 e8                	mov    %ebp,%eax
  802313:	89 f2                	mov    %esi,%edx
  802315:	f7 f3                	div    %ebx
  802317:	89 fa                	mov    %edi,%edx
  802319:	83 c4 1c             	add    $0x1c,%esp
  80231c:	5b                   	pop    %ebx
  80231d:	5e                   	pop    %esi
  80231e:	5f                   	pop    %edi
  80231f:	5d                   	pop    %ebp
  802320:	c3                   	ret    
  802321:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802328:	89 d9                	mov    %ebx,%ecx
  80232a:	85 db                	test   %ebx,%ebx
  80232c:	75 0b                	jne    802339 <__udivdi3+0x49>
  80232e:	b8 01 00 00 00       	mov    $0x1,%eax
  802333:	31 d2                	xor    %edx,%edx
  802335:	f7 f3                	div    %ebx
  802337:	89 c1                	mov    %eax,%ecx
  802339:	31 d2                	xor    %edx,%edx
  80233b:	89 f0                	mov    %esi,%eax
  80233d:	f7 f1                	div    %ecx
  80233f:	89 c6                	mov    %eax,%esi
  802341:	89 e8                	mov    %ebp,%eax
  802343:	89 f7                	mov    %esi,%edi
  802345:	f7 f1                	div    %ecx
  802347:	89 fa                	mov    %edi,%edx
  802349:	83 c4 1c             	add    $0x1c,%esp
  80234c:	5b                   	pop    %ebx
  80234d:	5e                   	pop    %esi
  80234e:	5f                   	pop    %edi
  80234f:	5d                   	pop    %ebp
  802350:	c3                   	ret    
  802351:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802358:	39 f2                	cmp    %esi,%edx
  80235a:	77 1c                	ja     802378 <__udivdi3+0x88>
  80235c:	0f bd fa             	bsr    %edx,%edi
  80235f:	83 f7 1f             	xor    $0x1f,%edi
  802362:	75 2c                	jne    802390 <__udivdi3+0xa0>
  802364:	39 f2                	cmp    %esi,%edx
  802366:	72 06                	jb     80236e <__udivdi3+0x7e>
  802368:	31 c0                	xor    %eax,%eax
  80236a:	39 eb                	cmp    %ebp,%ebx
  80236c:	77 a9                	ja     802317 <__udivdi3+0x27>
  80236e:	b8 01 00 00 00       	mov    $0x1,%eax
  802373:	eb a2                	jmp    802317 <__udivdi3+0x27>
  802375:	8d 76 00             	lea    0x0(%esi),%esi
  802378:	31 ff                	xor    %edi,%edi
  80237a:	31 c0                	xor    %eax,%eax
  80237c:	89 fa                	mov    %edi,%edx
  80237e:	83 c4 1c             	add    $0x1c,%esp
  802381:	5b                   	pop    %ebx
  802382:	5e                   	pop    %esi
  802383:	5f                   	pop    %edi
  802384:	5d                   	pop    %ebp
  802385:	c3                   	ret    
  802386:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80238d:	8d 76 00             	lea    0x0(%esi),%esi
  802390:	89 f9                	mov    %edi,%ecx
  802392:	b8 20 00 00 00       	mov    $0x20,%eax
  802397:	29 f8                	sub    %edi,%eax
  802399:	d3 e2                	shl    %cl,%edx
  80239b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80239f:	89 c1                	mov    %eax,%ecx
  8023a1:	89 da                	mov    %ebx,%edx
  8023a3:	d3 ea                	shr    %cl,%edx
  8023a5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8023a9:	09 d1                	or     %edx,%ecx
  8023ab:	89 f2                	mov    %esi,%edx
  8023ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8023b1:	89 f9                	mov    %edi,%ecx
  8023b3:	d3 e3                	shl    %cl,%ebx
  8023b5:	89 c1                	mov    %eax,%ecx
  8023b7:	d3 ea                	shr    %cl,%edx
  8023b9:	89 f9                	mov    %edi,%ecx
  8023bb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8023bf:	89 eb                	mov    %ebp,%ebx
  8023c1:	d3 e6                	shl    %cl,%esi
  8023c3:	89 c1                	mov    %eax,%ecx
  8023c5:	d3 eb                	shr    %cl,%ebx
  8023c7:	09 de                	or     %ebx,%esi
  8023c9:	89 f0                	mov    %esi,%eax
  8023cb:	f7 74 24 08          	divl   0x8(%esp)
  8023cf:	89 d6                	mov    %edx,%esi
  8023d1:	89 c3                	mov    %eax,%ebx
  8023d3:	f7 64 24 0c          	mull   0xc(%esp)
  8023d7:	39 d6                	cmp    %edx,%esi
  8023d9:	72 15                	jb     8023f0 <__udivdi3+0x100>
  8023db:	89 f9                	mov    %edi,%ecx
  8023dd:	d3 e5                	shl    %cl,%ebp
  8023df:	39 c5                	cmp    %eax,%ebp
  8023e1:	73 04                	jae    8023e7 <__udivdi3+0xf7>
  8023e3:	39 d6                	cmp    %edx,%esi
  8023e5:	74 09                	je     8023f0 <__udivdi3+0x100>
  8023e7:	89 d8                	mov    %ebx,%eax
  8023e9:	31 ff                	xor    %edi,%edi
  8023eb:	e9 27 ff ff ff       	jmp    802317 <__udivdi3+0x27>
  8023f0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8023f3:	31 ff                	xor    %edi,%edi
  8023f5:	e9 1d ff ff ff       	jmp    802317 <__udivdi3+0x27>
  8023fa:	66 90                	xchg   %ax,%ax
  8023fc:	66 90                	xchg   %ax,%ax
  8023fe:	66 90                	xchg   %ax,%ax

00802400 <__umoddi3>:
  802400:	55                   	push   %ebp
  802401:	57                   	push   %edi
  802402:	56                   	push   %esi
  802403:	53                   	push   %ebx
  802404:	83 ec 1c             	sub    $0x1c,%esp
  802407:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80240b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80240f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802413:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802417:	89 da                	mov    %ebx,%edx
  802419:	85 c0                	test   %eax,%eax
  80241b:	75 43                	jne    802460 <__umoddi3+0x60>
  80241d:	39 df                	cmp    %ebx,%edi
  80241f:	76 17                	jbe    802438 <__umoddi3+0x38>
  802421:	89 f0                	mov    %esi,%eax
  802423:	f7 f7                	div    %edi
  802425:	89 d0                	mov    %edx,%eax
  802427:	31 d2                	xor    %edx,%edx
  802429:	83 c4 1c             	add    $0x1c,%esp
  80242c:	5b                   	pop    %ebx
  80242d:	5e                   	pop    %esi
  80242e:	5f                   	pop    %edi
  80242f:	5d                   	pop    %ebp
  802430:	c3                   	ret    
  802431:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802438:	89 fd                	mov    %edi,%ebp
  80243a:	85 ff                	test   %edi,%edi
  80243c:	75 0b                	jne    802449 <__umoddi3+0x49>
  80243e:	b8 01 00 00 00       	mov    $0x1,%eax
  802443:	31 d2                	xor    %edx,%edx
  802445:	f7 f7                	div    %edi
  802447:	89 c5                	mov    %eax,%ebp
  802449:	89 d8                	mov    %ebx,%eax
  80244b:	31 d2                	xor    %edx,%edx
  80244d:	f7 f5                	div    %ebp
  80244f:	89 f0                	mov    %esi,%eax
  802451:	f7 f5                	div    %ebp
  802453:	89 d0                	mov    %edx,%eax
  802455:	eb d0                	jmp    802427 <__umoddi3+0x27>
  802457:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80245e:	66 90                	xchg   %ax,%ax
  802460:	89 f1                	mov    %esi,%ecx
  802462:	39 d8                	cmp    %ebx,%eax
  802464:	76 0a                	jbe    802470 <__umoddi3+0x70>
  802466:	89 f0                	mov    %esi,%eax
  802468:	83 c4 1c             	add    $0x1c,%esp
  80246b:	5b                   	pop    %ebx
  80246c:	5e                   	pop    %esi
  80246d:	5f                   	pop    %edi
  80246e:	5d                   	pop    %ebp
  80246f:	c3                   	ret    
  802470:	0f bd e8             	bsr    %eax,%ebp
  802473:	83 f5 1f             	xor    $0x1f,%ebp
  802476:	75 20                	jne    802498 <__umoddi3+0x98>
  802478:	39 d8                	cmp    %ebx,%eax
  80247a:	0f 82 b0 00 00 00    	jb     802530 <__umoddi3+0x130>
  802480:	39 f7                	cmp    %esi,%edi
  802482:	0f 86 a8 00 00 00    	jbe    802530 <__umoddi3+0x130>
  802488:	89 c8                	mov    %ecx,%eax
  80248a:	83 c4 1c             	add    $0x1c,%esp
  80248d:	5b                   	pop    %ebx
  80248e:	5e                   	pop    %esi
  80248f:	5f                   	pop    %edi
  802490:	5d                   	pop    %ebp
  802491:	c3                   	ret    
  802492:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802498:	89 e9                	mov    %ebp,%ecx
  80249a:	ba 20 00 00 00       	mov    $0x20,%edx
  80249f:	29 ea                	sub    %ebp,%edx
  8024a1:	d3 e0                	shl    %cl,%eax
  8024a3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024a7:	89 d1                	mov    %edx,%ecx
  8024a9:	89 f8                	mov    %edi,%eax
  8024ab:	d3 e8                	shr    %cl,%eax
  8024ad:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8024b1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8024b5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8024b9:	09 c1                	or     %eax,%ecx
  8024bb:	89 d8                	mov    %ebx,%eax
  8024bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8024c1:	89 e9                	mov    %ebp,%ecx
  8024c3:	d3 e7                	shl    %cl,%edi
  8024c5:	89 d1                	mov    %edx,%ecx
  8024c7:	d3 e8                	shr    %cl,%eax
  8024c9:	89 e9                	mov    %ebp,%ecx
  8024cb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8024cf:	d3 e3                	shl    %cl,%ebx
  8024d1:	89 c7                	mov    %eax,%edi
  8024d3:	89 d1                	mov    %edx,%ecx
  8024d5:	89 f0                	mov    %esi,%eax
  8024d7:	d3 e8                	shr    %cl,%eax
  8024d9:	89 e9                	mov    %ebp,%ecx
  8024db:	89 fa                	mov    %edi,%edx
  8024dd:	d3 e6                	shl    %cl,%esi
  8024df:	09 d8                	or     %ebx,%eax
  8024e1:	f7 74 24 08          	divl   0x8(%esp)
  8024e5:	89 d1                	mov    %edx,%ecx
  8024e7:	89 f3                	mov    %esi,%ebx
  8024e9:	f7 64 24 0c          	mull   0xc(%esp)
  8024ed:	89 c6                	mov    %eax,%esi
  8024ef:	89 d7                	mov    %edx,%edi
  8024f1:	39 d1                	cmp    %edx,%ecx
  8024f3:	72 06                	jb     8024fb <__umoddi3+0xfb>
  8024f5:	75 10                	jne    802507 <__umoddi3+0x107>
  8024f7:	39 c3                	cmp    %eax,%ebx
  8024f9:	73 0c                	jae    802507 <__umoddi3+0x107>
  8024fb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8024ff:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802503:	89 d7                	mov    %edx,%edi
  802505:	89 c6                	mov    %eax,%esi
  802507:	89 ca                	mov    %ecx,%edx
  802509:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80250e:	29 f3                	sub    %esi,%ebx
  802510:	19 fa                	sbb    %edi,%edx
  802512:	89 d0                	mov    %edx,%eax
  802514:	d3 e0                	shl    %cl,%eax
  802516:	89 e9                	mov    %ebp,%ecx
  802518:	d3 eb                	shr    %cl,%ebx
  80251a:	d3 ea                	shr    %cl,%edx
  80251c:	09 d8                	or     %ebx,%eax
  80251e:	83 c4 1c             	add    $0x1c,%esp
  802521:	5b                   	pop    %ebx
  802522:	5e                   	pop    %esi
  802523:	5f                   	pop    %edi
  802524:	5d                   	pop    %ebp
  802525:	c3                   	ret    
  802526:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80252d:	8d 76 00             	lea    0x0(%esi),%esi
  802530:	89 da                	mov    %ebx,%edx
  802532:	29 fe                	sub    %edi,%esi
  802534:	19 c2                	sbb    %eax,%edx
  802536:	89 f1                	mov    %esi,%ecx
  802538:	89 c8                	mov    %ecx,%eax
  80253a:	e9 4b ff ff ff       	jmp    80248a <__umoddi3+0x8a>
