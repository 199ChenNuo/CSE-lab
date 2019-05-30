
obj/user/primespipe.debug:     file format elf32-i386


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
  80002c:	e8 00 02 00 00       	call   800231 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(int fd)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 1c             	sub    $0x1c,%esp
  80003c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i, id, p, pfd[2], wfd, r;

	// fetch a prime from our left neighbor
top:
	if ((r = readn(fd, &p, 4)) != 4)
  80003f:	8d 75 e0             	lea    -0x20(%ebp),%esi
		panic("primeproc could not read initial prime: %d, %e", r, r >= 0 ? 0 : r);

	cprintf("%d\n", p);

	// fork a right neighbor to continue the chain
	if ((i=pipe(pfd)) < 0)
  800042:	8d 7d d8             	lea    -0x28(%ebp),%edi
  800045:	eb 5e                	jmp    8000a5 <primeproc+0x72>
		panic("primeproc could not read initial prime: %d, %e", r, r >= 0 ? 0 : r);
  800047:	83 ec 0c             	sub    $0xc,%esp
  80004a:	85 c0                	test   %eax,%eax
  80004c:	ba 00 00 00 00       	mov    $0x0,%edx
  800051:	0f 4e d0             	cmovle %eax,%edx
  800054:	52                   	push   %edx
  800055:	50                   	push   %eax
  800056:	68 80 25 80 00       	push   $0x802580
  80005b:	6a 15                	push   $0x15
  80005d:	68 af 25 80 00       	push   $0x8025af
  800062:	e8 25 02 00 00       	call   80028c <_panic>
		panic("pipe: %e", i);
  800067:	50                   	push   %eax
  800068:	68 c5 25 80 00       	push   $0x8025c5
  80006d:	6a 1b                	push   $0x1b
  80006f:	68 af 25 80 00       	push   $0x8025af
  800074:	e8 13 02 00 00       	call   80028c <_panic>
	if ((id = fork()) < 0)
		panic("fork: %e", id);
  800079:	50                   	push   %eax
  80007a:	68 ce 25 80 00       	push   $0x8025ce
  80007f:	6a 1d                	push   $0x1d
  800081:	68 af 25 80 00       	push   $0x8025af
  800086:	e8 01 02 00 00       	call   80028c <_panic>
	if (id == 0) {
		close(fd);
  80008b:	83 ec 0c             	sub    $0xc,%esp
  80008e:	53                   	push   %ebx
  80008f:	e8 df 15 00 00       	call   801673 <close>
		close(pfd[1]);
  800094:	83 c4 04             	add    $0x4,%esp
  800097:	ff 75 dc             	pushl  -0x24(%ebp)
  80009a:	e8 d4 15 00 00       	call   801673 <close>
		fd = pfd[0];
  80009f:	8b 5d d8             	mov    -0x28(%ebp),%ebx
		goto top;
  8000a2:	83 c4 10             	add    $0x10,%esp
	if ((r = readn(fd, &p, 4)) != 4)
  8000a5:	83 ec 04             	sub    $0x4,%esp
  8000a8:	6a 04                	push   $0x4
  8000aa:	56                   	push   %esi
  8000ab:	53                   	push   %ebx
  8000ac:	e8 87 17 00 00       	call   801838 <readn>
  8000b1:	83 c4 10             	add    $0x10,%esp
  8000b4:	83 f8 04             	cmp    $0x4,%eax
  8000b7:	75 8e                	jne    800047 <primeproc+0x14>
	cprintf("%d\n", p);
  8000b9:	83 ec 08             	sub    $0x8,%esp
  8000bc:	ff 75 e0             	pushl  -0x20(%ebp)
  8000bf:	68 c1 25 80 00       	push   $0x8025c1
  8000c4:	e8 9e 02 00 00       	call   800367 <cprintf>
	if ((i=pipe(pfd)) < 0)
  8000c9:	89 3c 24             	mov    %edi,(%esp)
  8000cc:	e8 8d 1d 00 00       	call   801e5e <pipe>
  8000d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8000d4:	83 c4 10             	add    $0x10,%esp
  8000d7:	85 c0                	test   %eax,%eax
  8000d9:	78 8c                	js     800067 <primeproc+0x34>
	if ((id = fork()) < 0)
  8000db:	e8 cd 10 00 00       	call   8011ad <fork>
  8000e0:	85 c0                	test   %eax,%eax
  8000e2:	78 95                	js     800079 <primeproc+0x46>
	if (id == 0) {
  8000e4:	74 a5                	je     80008b <primeproc+0x58>
	}

	close(pfd[0]);
  8000e6:	83 ec 0c             	sub    $0xc,%esp
  8000e9:	ff 75 d8             	pushl  -0x28(%ebp)
  8000ec:	e8 82 15 00 00       	call   801673 <close>
	wfd = pfd[1];
  8000f1:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8000f4:	83 c4 10             	add    $0x10,%esp

	// filter out multiples of our prime
	for (;;) {
		if ((r=readn(fd, &i, 4)) != 4)
  8000f7:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  8000fa:	83 ec 04             	sub    $0x4,%esp
  8000fd:	6a 04                	push   $0x4
  8000ff:	56                   	push   %esi
  800100:	53                   	push   %ebx
  800101:	e8 32 17 00 00       	call   801838 <readn>
  800106:	83 c4 10             	add    $0x10,%esp
  800109:	83 f8 04             	cmp    $0x4,%eax
  80010c:	75 42                	jne    800150 <primeproc+0x11d>
			panic("primeproc %d readn %d %d %e", p, fd, r, r >= 0 ? 0 : r);
		if (i%p)
  80010e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800111:	99                   	cltd   
  800112:	f7 7d e0             	idivl  -0x20(%ebp)
  800115:	85 d2                	test   %edx,%edx
  800117:	74 e1                	je     8000fa <primeproc+0xc7>
			if ((r=write(wfd, &i, 4)) != 4)
  800119:	83 ec 04             	sub    $0x4,%esp
  80011c:	6a 04                	push   $0x4
  80011e:	56                   	push   %esi
  80011f:	57                   	push   %edi
  800120:	e8 58 17 00 00       	call   80187d <write>
  800125:	83 c4 10             	add    $0x10,%esp
  800128:	83 f8 04             	cmp    $0x4,%eax
  80012b:	74 cd                	je     8000fa <primeproc+0xc7>
				panic("primeproc %d write: %d %e", p, r, r >= 0 ? 0 : r);
  80012d:	83 ec 08             	sub    $0x8,%esp
  800130:	85 c0                	test   %eax,%eax
  800132:	ba 00 00 00 00       	mov    $0x0,%edx
  800137:	0f 4e d0             	cmovle %eax,%edx
  80013a:	52                   	push   %edx
  80013b:	50                   	push   %eax
  80013c:	ff 75 e0             	pushl  -0x20(%ebp)
  80013f:	68 f3 25 80 00       	push   $0x8025f3
  800144:	6a 2e                	push   $0x2e
  800146:	68 af 25 80 00       	push   $0x8025af
  80014b:	e8 3c 01 00 00       	call   80028c <_panic>
			panic("primeproc %d readn %d %d %e", p, fd, r, r >= 0 ? 0 : r);
  800150:	83 ec 04             	sub    $0x4,%esp
  800153:	85 c0                	test   %eax,%eax
  800155:	ba 00 00 00 00       	mov    $0x0,%edx
  80015a:	0f 4e d0             	cmovle %eax,%edx
  80015d:	52                   	push   %edx
  80015e:	50                   	push   %eax
  80015f:	53                   	push   %ebx
  800160:	ff 75 e0             	pushl  -0x20(%ebp)
  800163:	68 d7 25 80 00       	push   $0x8025d7
  800168:	6a 2b                	push   $0x2b
  80016a:	68 af 25 80 00       	push   $0x8025af
  80016f:	e8 18 01 00 00       	call   80028c <_panic>

00800174 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  800174:	55                   	push   %ebp
  800175:	89 e5                	mov    %esp,%ebp
  800177:	53                   	push   %ebx
  800178:	83 ec 20             	sub    $0x20,%esp
	int i, id, p[2], r;

	binaryname = "primespipe";
  80017b:	c7 05 00 30 80 00 0d 	movl   $0x80260d,0x803000
  800182:	26 80 00 

	if ((i=pipe(p)) < 0)
  800185:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800188:	50                   	push   %eax
  800189:	e8 d0 1c 00 00       	call   801e5e <pipe>
  80018e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800191:	83 c4 10             	add    $0x10,%esp
  800194:	85 c0                	test   %eax,%eax
  800196:	78 21                	js     8001b9 <umain+0x45>
		panic("pipe: %e", i);

	// fork the first prime process in the chain
	if ((id=fork()) < 0)
  800198:	e8 10 10 00 00       	call   8011ad <fork>
  80019d:	85 c0                	test   %eax,%eax
  80019f:	78 2a                	js     8001cb <umain+0x57>
		panic("fork: %e", id);

	if (id == 0) {
  8001a1:	75 3a                	jne    8001dd <umain+0x69>
		close(p[1]);
  8001a3:	83 ec 0c             	sub    $0xc,%esp
  8001a6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a9:	e8 c5 14 00 00       	call   801673 <close>
		primeproc(p[0]);
  8001ae:	83 c4 04             	add    $0x4,%esp
  8001b1:	ff 75 ec             	pushl  -0x14(%ebp)
  8001b4:	e8 7a fe ff ff       	call   800033 <primeproc>
		panic("pipe: %e", i);
  8001b9:	50                   	push   %eax
  8001ba:	68 c5 25 80 00       	push   $0x8025c5
  8001bf:	6a 3a                	push   $0x3a
  8001c1:	68 af 25 80 00       	push   $0x8025af
  8001c6:	e8 c1 00 00 00       	call   80028c <_panic>
		panic("fork: %e", id);
  8001cb:	50                   	push   %eax
  8001cc:	68 ce 25 80 00       	push   $0x8025ce
  8001d1:	6a 3e                	push   $0x3e
  8001d3:	68 af 25 80 00       	push   $0x8025af
  8001d8:	e8 af 00 00 00       	call   80028c <_panic>
	}

	close(p[0]);
  8001dd:	83 ec 0c             	sub    $0xc,%esp
  8001e0:	ff 75 ec             	pushl  -0x14(%ebp)
  8001e3:	e8 8b 14 00 00       	call   801673 <close>

	// feed all the integers through
	for (i=2;; i++)
  8001e8:	c7 45 f4 02 00 00 00 	movl   $0x2,-0xc(%ebp)
  8001ef:	83 c4 10             	add    $0x10,%esp
		if ((r=write(p[1], &i, 4)) != 4)
  8001f2:	8d 5d f4             	lea    -0xc(%ebp),%ebx
  8001f5:	83 ec 04             	sub    $0x4,%esp
  8001f8:	6a 04                	push   $0x4
  8001fa:	53                   	push   %ebx
  8001fb:	ff 75 f0             	pushl  -0x10(%ebp)
  8001fe:	e8 7a 16 00 00       	call   80187d <write>
  800203:	83 c4 10             	add    $0x10,%esp
  800206:	83 f8 04             	cmp    $0x4,%eax
  800209:	75 06                	jne    800211 <umain+0x9d>
	for (i=2;; i++)
  80020b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
		if ((r=write(p[1], &i, 4)) != 4)
  80020f:	eb e4                	jmp    8001f5 <umain+0x81>
			panic("generator write: %d, %e", r, r >= 0 ? 0 : r);
  800211:	83 ec 0c             	sub    $0xc,%esp
  800214:	85 c0                	test   %eax,%eax
  800216:	ba 00 00 00 00       	mov    $0x0,%edx
  80021b:	0f 4e d0             	cmovle %eax,%edx
  80021e:	52                   	push   %edx
  80021f:	50                   	push   %eax
  800220:	68 18 26 80 00       	push   $0x802618
  800225:	6a 4a                	push   $0x4a
  800227:	68 af 25 80 00       	push   $0x8025af
  80022c:	e8 5b 00 00 00       	call   80028c <_panic>

00800231 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800231:	55                   	push   %ebp
  800232:	89 e5                	mov    %esp,%ebp
  800234:	56                   	push   %esi
  800235:	53                   	push   %ebx
  800236:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800239:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	// thisenv = 0;
	thisenv = &(envs[ENVX(sys_getenvid())]);
  80023c:	e8 00 0c 00 00       	call   800e41 <sys_getenvid>
  800241:	25 ff 03 00 00       	and    $0x3ff,%eax
  800246:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80024c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800251:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800256:	85 db                	test   %ebx,%ebx
  800258:	7e 07                	jle    800261 <libmain+0x30>
		binaryname = argv[0];
  80025a:	8b 06                	mov    (%esi),%eax
  80025c:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800261:	83 ec 08             	sub    $0x8,%esp
  800264:	56                   	push   %esi
  800265:	53                   	push   %ebx
  800266:	e8 09 ff ff ff       	call   800174 <umain>

	// exit gracefully
	exit();
  80026b:	e8 0a 00 00 00       	call   80027a <exit>
}
  800270:	83 c4 10             	add    $0x10,%esp
  800273:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800276:	5b                   	pop    %ebx
  800277:	5e                   	pop    %esi
  800278:	5d                   	pop    %ebp
  800279:	c3                   	ret    

0080027a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80027a:	55                   	push   %ebp
  80027b:	89 e5                	mov    %esp,%ebp
  80027d:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  800280:	6a 00                	push   $0x0
  800282:	e8 79 0b 00 00       	call   800e00 <sys_env_destroy>
}
  800287:	83 c4 10             	add    $0x10,%esp
  80028a:	c9                   	leave  
  80028b:	c3                   	ret    

0080028c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80028c:	55                   	push   %ebp
  80028d:	89 e5                	mov    %esp,%ebp
  80028f:	56                   	push   %esi
  800290:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800291:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800294:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80029a:	e8 a2 0b 00 00       	call   800e41 <sys_getenvid>
  80029f:	83 ec 0c             	sub    $0xc,%esp
  8002a2:	ff 75 0c             	pushl  0xc(%ebp)
  8002a5:	ff 75 08             	pushl  0x8(%ebp)
  8002a8:	56                   	push   %esi
  8002a9:	50                   	push   %eax
  8002aa:	68 3c 26 80 00       	push   $0x80263c
  8002af:	e8 b3 00 00 00       	call   800367 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002b4:	83 c4 18             	add    $0x18,%esp
  8002b7:	53                   	push   %ebx
  8002b8:	ff 75 10             	pushl  0x10(%ebp)
  8002bb:	e8 56 00 00 00       	call   800316 <vcprintf>
	cprintf("\n");
  8002c0:	c7 04 24 15 2a 80 00 	movl   $0x802a15,(%esp)
  8002c7:	e8 9b 00 00 00       	call   800367 <cprintf>
  8002cc:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002cf:	cc                   	int3   
  8002d0:	eb fd                	jmp    8002cf <_panic+0x43>

008002d2 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002d2:	55                   	push   %ebp
  8002d3:	89 e5                	mov    %esp,%ebp
  8002d5:	53                   	push   %ebx
  8002d6:	83 ec 04             	sub    $0x4,%esp
  8002d9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002dc:	8b 13                	mov    (%ebx),%edx
  8002de:	8d 42 01             	lea    0x1(%edx),%eax
  8002e1:	89 03                	mov    %eax,(%ebx)
  8002e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002e6:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8002ea:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002ef:	74 09                	je     8002fa <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8002f1:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002f8:	c9                   	leave  
  8002f9:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8002fa:	83 ec 08             	sub    $0x8,%esp
  8002fd:	68 ff 00 00 00       	push   $0xff
  800302:	8d 43 08             	lea    0x8(%ebx),%eax
  800305:	50                   	push   %eax
  800306:	e8 b8 0a 00 00       	call   800dc3 <sys_cputs>
		b->idx = 0;
  80030b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800311:	83 c4 10             	add    $0x10,%esp
  800314:	eb db                	jmp    8002f1 <putch+0x1f>

00800316 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800316:	55                   	push   %ebp
  800317:	89 e5                	mov    %esp,%ebp
  800319:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80031f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800326:	00 00 00 
	b.cnt = 0;
  800329:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800330:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800333:	ff 75 0c             	pushl  0xc(%ebp)
  800336:	ff 75 08             	pushl  0x8(%ebp)
  800339:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80033f:	50                   	push   %eax
  800340:	68 d2 02 80 00       	push   $0x8002d2
  800345:	e8 4a 01 00 00       	call   800494 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80034a:	83 c4 08             	add    $0x8,%esp
  80034d:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800353:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800359:	50                   	push   %eax
  80035a:	e8 64 0a 00 00       	call   800dc3 <sys_cputs>

	return b.cnt;
}
  80035f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800365:	c9                   	leave  
  800366:	c3                   	ret    

00800367 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800367:	55                   	push   %ebp
  800368:	89 e5                	mov    %esp,%ebp
  80036a:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80036d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800370:	50                   	push   %eax
  800371:	ff 75 08             	pushl  0x8(%ebp)
  800374:	e8 9d ff ff ff       	call   800316 <vcprintf>
	va_end(ap);

	return cnt;
}
  800379:	c9                   	leave  
  80037a:	c3                   	ret    

0080037b <printnum>:


static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80037b:	55                   	push   %ebp
  80037c:	89 e5                	mov    %esp,%ebp
  80037e:	57                   	push   %edi
  80037f:	56                   	push   %esi
  800380:	53                   	push   %ebx
  800381:	83 ec 1c             	sub    $0x1c,%esp
  800384:	89 c6                	mov    %eax,%esi
  800386:	89 d7                	mov    %edx,%edi
  800388:	8b 45 08             	mov    0x8(%ebp),%eax
  80038b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80038e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800391:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800394:	8b 45 10             	mov    0x10(%ebp),%eax
  800397:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	// to support '-'
	if(padc == '-'){
  80039a:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80039e:	74 2c                	je     8003cc <printnum+0x51>
		while (--width > 0)
			putch(' ', putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003a0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003a3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8003aa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003ad:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003b0:	39 c2                	cmp    %eax,%edx
  8003b2:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8003b5:	73 43                	jae    8003fa <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003b7:	83 eb 01             	sub    $0x1,%ebx
  8003ba:	85 db                	test   %ebx,%ebx
  8003bc:	7e 6c                	jle    80042a <printnum+0xaf>
			putch(padc, putdat);
  8003be:	83 ec 08             	sub    $0x8,%esp
  8003c1:	57                   	push   %edi
  8003c2:	ff 75 18             	pushl  0x18(%ebp)
  8003c5:	ff d6                	call   *%esi
  8003c7:	83 c4 10             	add    $0x10,%esp
  8003ca:	eb eb                	jmp    8003b7 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8003cc:	83 ec 0c             	sub    $0xc,%esp
  8003cf:	6a 20                	push   $0x20
  8003d1:	6a 00                	push   $0x0
  8003d3:	50                   	push   %eax
  8003d4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003d7:	ff 75 e0             	pushl  -0x20(%ebp)
  8003da:	89 fa                	mov    %edi,%edx
  8003dc:	89 f0                	mov    %esi,%eax
  8003de:	e8 98 ff ff ff       	call   80037b <printnum>
		while (--width > 0)
  8003e3:	83 c4 20             	add    $0x20,%esp
  8003e6:	83 eb 01             	sub    $0x1,%ebx
  8003e9:	85 db                	test   %ebx,%ebx
  8003eb:	7e 65                	jle    800452 <printnum+0xd7>
			putch(' ', putdat);
  8003ed:	83 ec 08             	sub    $0x8,%esp
  8003f0:	57                   	push   %edi
  8003f1:	6a 20                	push   $0x20
  8003f3:	ff d6                	call   *%esi
  8003f5:	83 c4 10             	add    $0x10,%esp
  8003f8:	eb ec                	jmp    8003e6 <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003fa:	83 ec 0c             	sub    $0xc,%esp
  8003fd:	ff 75 18             	pushl  0x18(%ebp)
  800400:	83 eb 01             	sub    $0x1,%ebx
  800403:	53                   	push   %ebx
  800404:	50                   	push   %eax
  800405:	83 ec 08             	sub    $0x8,%esp
  800408:	ff 75 dc             	pushl  -0x24(%ebp)
  80040b:	ff 75 d8             	pushl  -0x28(%ebp)
  80040e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800411:	ff 75 e0             	pushl  -0x20(%ebp)
  800414:	e8 07 1f 00 00       	call   802320 <__udivdi3>
  800419:	83 c4 18             	add    $0x18,%esp
  80041c:	52                   	push   %edx
  80041d:	50                   	push   %eax
  80041e:	89 fa                	mov    %edi,%edx
  800420:	89 f0                	mov    %esi,%eax
  800422:	e8 54 ff ff ff       	call   80037b <printnum>
  800427:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80042a:	83 ec 08             	sub    $0x8,%esp
  80042d:	57                   	push   %edi
  80042e:	83 ec 04             	sub    $0x4,%esp
  800431:	ff 75 dc             	pushl  -0x24(%ebp)
  800434:	ff 75 d8             	pushl  -0x28(%ebp)
  800437:	ff 75 e4             	pushl  -0x1c(%ebp)
  80043a:	ff 75 e0             	pushl  -0x20(%ebp)
  80043d:	e8 ee 1f 00 00       	call   802430 <__umoddi3>
  800442:	83 c4 14             	add    $0x14,%esp
  800445:	0f be 80 5f 26 80 00 	movsbl 0x80265f(%eax),%eax
  80044c:	50                   	push   %eax
  80044d:	ff d6                	call   *%esi
  80044f:	83 c4 10             	add    $0x10,%esp
}
  800452:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800455:	5b                   	pop    %ebx
  800456:	5e                   	pop    %esi
  800457:	5f                   	pop    %edi
  800458:	5d                   	pop    %ebp
  800459:	c3                   	ret    

0080045a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80045a:	55                   	push   %ebp
  80045b:	89 e5                	mov    %esp,%ebp
  80045d:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800460:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800464:	8b 10                	mov    (%eax),%edx
  800466:	3b 50 04             	cmp    0x4(%eax),%edx
  800469:	73 0a                	jae    800475 <sprintputch+0x1b>
		*b->buf++ = ch;
  80046b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80046e:	89 08                	mov    %ecx,(%eax)
  800470:	8b 45 08             	mov    0x8(%ebp),%eax
  800473:	88 02                	mov    %al,(%edx)
}
  800475:	5d                   	pop    %ebp
  800476:	c3                   	ret    

00800477 <printfmt>:
{
  800477:	55                   	push   %ebp
  800478:	89 e5                	mov    %esp,%ebp
  80047a:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80047d:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800480:	50                   	push   %eax
  800481:	ff 75 10             	pushl  0x10(%ebp)
  800484:	ff 75 0c             	pushl  0xc(%ebp)
  800487:	ff 75 08             	pushl  0x8(%ebp)
  80048a:	e8 05 00 00 00       	call   800494 <vprintfmt>
}
  80048f:	83 c4 10             	add    $0x10,%esp
  800492:	c9                   	leave  
  800493:	c3                   	ret    

00800494 <vprintfmt>:
{
  800494:	55                   	push   %ebp
  800495:	89 e5                	mov    %esp,%ebp
  800497:	57                   	push   %edi
  800498:	56                   	push   %esi
  800499:	53                   	push   %ebx
  80049a:	83 ec 3c             	sub    $0x3c,%esp
  80049d:	8b 75 08             	mov    0x8(%ebp),%esi
  8004a0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004a3:	8b 7d 10             	mov    0x10(%ebp),%edi
  8004a6:	e9 1e 04 00 00       	jmp    8008c9 <vprintfmt+0x435>
		posflag = 0;
  8004ab:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
		padc = ' ';
  8004b2:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8004b6:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8004bd:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8004c4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004cb:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  8004d2:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004d7:	8d 47 01             	lea    0x1(%edi),%eax
  8004da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004dd:	0f b6 17             	movzbl (%edi),%edx
  8004e0:	8d 42 dd             	lea    -0x23(%edx),%eax
  8004e3:	3c 55                	cmp    $0x55,%al
  8004e5:	0f 87 d9 04 00 00    	ja     8009c4 <vprintfmt+0x530>
  8004eb:	0f b6 c0             	movzbl %al,%eax
  8004ee:	ff 24 85 40 28 80 00 	jmp    *0x802840(,%eax,4)
  8004f5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8004f8:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8004fc:	eb d9                	jmp    8004d7 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8004fe:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posflag = 1;
  800501:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  800508:	eb cd                	jmp    8004d7 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80050a:	0f b6 d2             	movzbl %dl,%edx
  80050d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800510:	b8 00 00 00 00       	mov    $0x0,%eax
  800515:	89 75 08             	mov    %esi,0x8(%ebp)
  800518:	eb 0c                	jmp    800526 <vprintfmt+0x92>
		switch (ch = *(unsigned char *) fmt++) {
  80051a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80051d:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  800521:	eb b4                	jmp    8004d7 <vprintfmt+0x43>
			for (precision = 0; ; ++fmt) {
  800523:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800526:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800529:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80052d:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800530:	8d 72 d0             	lea    -0x30(%edx),%esi
  800533:	83 fe 09             	cmp    $0x9,%esi
  800536:	76 eb                	jbe    800523 <vprintfmt+0x8f>
  800538:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80053b:	8b 75 08             	mov    0x8(%ebp),%esi
  80053e:	eb 14                	jmp    800554 <vprintfmt+0xc0>
			precision = va_arg(ap, int);
  800540:	8b 45 14             	mov    0x14(%ebp),%eax
  800543:	8b 00                	mov    (%eax),%eax
  800545:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800548:	8b 45 14             	mov    0x14(%ebp),%eax
  80054b:	8d 40 04             	lea    0x4(%eax),%eax
  80054e:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800551:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800554:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800558:	0f 89 79 ff ff ff    	jns    8004d7 <vprintfmt+0x43>
				width = precision, precision = -1;
  80055e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800561:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800564:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80056b:	e9 67 ff ff ff       	jmp    8004d7 <vprintfmt+0x43>
  800570:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800573:	85 c0                	test   %eax,%eax
  800575:	0f 48 c1             	cmovs  %ecx,%eax
  800578:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80057b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80057e:	e9 54 ff ff ff       	jmp    8004d7 <vprintfmt+0x43>
  800583:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800586:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80058d:	e9 45 ff ff ff       	jmp    8004d7 <vprintfmt+0x43>
			lflag++;
  800592:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800596:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800599:	e9 39 ff ff ff       	jmp    8004d7 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  80059e:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a1:	8d 78 04             	lea    0x4(%eax),%edi
  8005a4:	83 ec 08             	sub    $0x8,%esp
  8005a7:	53                   	push   %ebx
  8005a8:	ff 30                	pushl  (%eax)
  8005aa:	ff d6                	call   *%esi
			break;
  8005ac:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8005af:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8005b2:	e9 0f 03 00 00       	jmp    8008c6 <vprintfmt+0x432>
			err = va_arg(ap, int);
  8005b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ba:	8d 78 04             	lea    0x4(%eax),%edi
  8005bd:	8b 00                	mov    (%eax),%eax
  8005bf:	99                   	cltd   
  8005c0:	31 d0                	xor    %edx,%eax
  8005c2:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005c4:	83 f8 0f             	cmp    $0xf,%eax
  8005c7:	7f 23                	jg     8005ec <vprintfmt+0x158>
  8005c9:	8b 14 85 a0 29 80 00 	mov    0x8029a0(,%eax,4),%edx
  8005d0:	85 d2                	test   %edx,%edx
  8005d2:	74 18                	je     8005ec <vprintfmt+0x158>
				printfmt(putch, putdat, "%s", p);
  8005d4:	52                   	push   %edx
  8005d5:	68 be 2c 80 00       	push   $0x802cbe
  8005da:	53                   	push   %ebx
  8005db:	56                   	push   %esi
  8005dc:	e8 96 fe ff ff       	call   800477 <printfmt>
  8005e1:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005e4:	89 7d 14             	mov    %edi,0x14(%ebp)
  8005e7:	e9 da 02 00 00       	jmp    8008c6 <vprintfmt+0x432>
				printfmt(putch, putdat, "error %d", err);
  8005ec:	50                   	push   %eax
  8005ed:	68 77 26 80 00       	push   $0x802677
  8005f2:	53                   	push   %ebx
  8005f3:	56                   	push   %esi
  8005f4:	e8 7e fe ff ff       	call   800477 <printfmt>
  8005f9:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005fc:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8005ff:	e9 c2 02 00 00       	jmp    8008c6 <vprintfmt+0x432>
			if ((p = va_arg(ap, char *)) == NULL)
  800604:	8b 45 14             	mov    0x14(%ebp),%eax
  800607:	83 c0 04             	add    $0x4,%eax
  80060a:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80060d:	8b 45 14             	mov    0x14(%ebp),%eax
  800610:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800612:	85 c9                	test   %ecx,%ecx
  800614:	b8 70 26 80 00       	mov    $0x802670,%eax
  800619:	0f 45 c1             	cmovne %ecx,%eax
  80061c:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80061f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800623:	7e 06                	jle    80062b <vprintfmt+0x197>
  800625:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800629:	75 0d                	jne    800638 <vprintfmt+0x1a4>
				for (width -= strnlen(p, precision); width > 0; width--)
  80062b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80062e:	89 c7                	mov    %eax,%edi
  800630:	03 45 e0             	add    -0x20(%ebp),%eax
  800633:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800636:	eb 53                	jmp    80068b <vprintfmt+0x1f7>
  800638:	83 ec 08             	sub    $0x8,%esp
  80063b:	ff 75 d8             	pushl  -0x28(%ebp)
  80063e:	50                   	push   %eax
  80063f:	e8 28 04 00 00       	call   800a6c <strnlen>
  800644:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800647:	29 c1                	sub    %eax,%ecx
  800649:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  80064c:	83 c4 10             	add    $0x10,%esp
  80064f:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800651:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800655:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800658:	eb 0f                	jmp    800669 <vprintfmt+0x1d5>
					putch(padc, putdat);
  80065a:	83 ec 08             	sub    $0x8,%esp
  80065d:	53                   	push   %ebx
  80065e:	ff 75 e0             	pushl  -0x20(%ebp)
  800661:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800663:	83 ef 01             	sub    $0x1,%edi
  800666:	83 c4 10             	add    $0x10,%esp
  800669:	85 ff                	test   %edi,%edi
  80066b:	7f ed                	jg     80065a <vprintfmt+0x1c6>
  80066d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  800670:	85 c9                	test   %ecx,%ecx
  800672:	b8 00 00 00 00       	mov    $0x0,%eax
  800677:	0f 49 c1             	cmovns %ecx,%eax
  80067a:	29 c1                	sub    %eax,%ecx
  80067c:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80067f:	eb aa                	jmp    80062b <vprintfmt+0x197>
					putch(ch, putdat);
  800681:	83 ec 08             	sub    $0x8,%esp
  800684:	53                   	push   %ebx
  800685:	52                   	push   %edx
  800686:	ff d6                	call   *%esi
  800688:	83 c4 10             	add    $0x10,%esp
  80068b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80068e:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800690:	83 c7 01             	add    $0x1,%edi
  800693:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800697:	0f be d0             	movsbl %al,%edx
  80069a:	85 d2                	test   %edx,%edx
  80069c:	74 4b                	je     8006e9 <vprintfmt+0x255>
  80069e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8006a2:	78 06                	js     8006aa <vprintfmt+0x216>
  8006a4:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8006a8:	78 1e                	js     8006c8 <vprintfmt+0x234>
				if (altflag && (ch < ' ' || ch > '~'))
  8006aa:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8006ae:	74 d1                	je     800681 <vprintfmt+0x1ed>
  8006b0:	0f be c0             	movsbl %al,%eax
  8006b3:	83 e8 20             	sub    $0x20,%eax
  8006b6:	83 f8 5e             	cmp    $0x5e,%eax
  8006b9:	76 c6                	jbe    800681 <vprintfmt+0x1ed>
					putch('?', putdat);
  8006bb:	83 ec 08             	sub    $0x8,%esp
  8006be:	53                   	push   %ebx
  8006bf:	6a 3f                	push   $0x3f
  8006c1:	ff d6                	call   *%esi
  8006c3:	83 c4 10             	add    $0x10,%esp
  8006c6:	eb c3                	jmp    80068b <vprintfmt+0x1f7>
  8006c8:	89 cf                	mov    %ecx,%edi
  8006ca:	eb 0e                	jmp    8006da <vprintfmt+0x246>
				putch(' ', putdat);
  8006cc:	83 ec 08             	sub    $0x8,%esp
  8006cf:	53                   	push   %ebx
  8006d0:	6a 20                	push   $0x20
  8006d2:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8006d4:	83 ef 01             	sub    $0x1,%edi
  8006d7:	83 c4 10             	add    $0x10,%esp
  8006da:	85 ff                	test   %edi,%edi
  8006dc:	7f ee                	jg     8006cc <vprintfmt+0x238>
			if ((p = va_arg(ap, char *)) == NULL)
  8006de:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8006e1:	89 45 14             	mov    %eax,0x14(%ebp)
  8006e4:	e9 dd 01 00 00       	jmp    8008c6 <vprintfmt+0x432>
  8006e9:	89 cf                	mov    %ecx,%edi
  8006eb:	eb ed                	jmp    8006da <vprintfmt+0x246>
	if (lflag >= 2)
  8006ed:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8006f1:	7f 21                	jg     800714 <vprintfmt+0x280>
	else if (lflag)
  8006f3:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8006f7:	74 6a                	je     800763 <vprintfmt+0x2cf>
		return va_arg(*ap, long);
  8006f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fc:	8b 00                	mov    (%eax),%eax
  8006fe:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800701:	89 c1                	mov    %eax,%ecx
  800703:	c1 f9 1f             	sar    $0x1f,%ecx
  800706:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800709:	8b 45 14             	mov    0x14(%ebp),%eax
  80070c:	8d 40 04             	lea    0x4(%eax),%eax
  80070f:	89 45 14             	mov    %eax,0x14(%ebp)
  800712:	eb 17                	jmp    80072b <vprintfmt+0x297>
		return va_arg(*ap, long long);
  800714:	8b 45 14             	mov    0x14(%ebp),%eax
  800717:	8b 50 04             	mov    0x4(%eax),%edx
  80071a:	8b 00                	mov    (%eax),%eax
  80071c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80071f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800722:	8b 45 14             	mov    0x14(%ebp),%eax
  800725:	8d 40 08             	lea    0x8(%eax),%eax
  800728:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80072b:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  80072e:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800733:	85 d2                	test   %edx,%edx
  800735:	0f 89 5c 01 00 00    	jns    800897 <vprintfmt+0x403>
				putch('-', putdat);
  80073b:	83 ec 08             	sub    $0x8,%esp
  80073e:	53                   	push   %ebx
  80073f:	6a 2d                	push   $0x2d
  800741:	ff d6                	call   *%esi
				num = -(long long) num;
  800743:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800746:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800749:	f7 d8                	neg    %eax
  80074b:	83 d2 00             	adc    $0x0,%edx
  80074e:	f7 da                	neg    %edx
  800750:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800753:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800756:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800759:	bf 0a 00 00 00       	mov    $0xa,%edi
  80075e:	e9 45 01 00 00       	jmp    8008a8 <vprintfmt+0x414>
		return va_arg(*ap, int);
  800763:	8b 45 14             	mov    0x14(%ebp),%eax
  800766:	8b 00                	mov    (%eax),%eax
  800768:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80076b:	89 c1                	mov    %eax,%ecx
  80076d:	c1 f9 1f             	sar    $0x1f,%ecx
  800770:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800773:	8b 45 14             	mov    0x14(%ebp),%eax
  800776:	8d 40 04             	lea    0x4(%eax),%eax
  800779:	89 45 14             	mov    %eax,0x14(%ebp)
  80077c:	eb ad                	jmp    80072b <vprintfmt+0x297>
	if (lflag >= 2)
  80077e:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800782:	7f 29                	jg     8007ad <vprintfmt+0x319>
	else if (lflag)
  800784:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800788:	74 44                	je     8007ce <vprintfmt+0x33a>
		return va_arg(*ap, unsigned long);
  80078a:	8b 45 14             	mov    0x14(%ebp),%eax
  80078d:	8b 00                	mov    (%eax),%eax
  80078f:	ba 00 00 00 00       	mov    $0x0,%edx
  800794:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800797:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80079a:	8b 45 14             	mov    0x14(%ebp),%eax
  80079d:	8d 40 04             	lea    0x4(%eax),%eax
  8007a0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007a3:	bf 0a 00 00 00       	mov    $0xa,%edi
  8007a8:	e9 ea 00 00 00       	jmp    800897 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  8007ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b0:	8b 50 04             	mov    0x4(%eax),%edx
  8007b3:	8b 00                	mov    (%eax),%eax
  8007b5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007b8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007be:	8d 40 08             	lea    0x8(%eax),%eax
  8007c1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007c4:	bf 0a 00 00 00       	mov    $0xa,%edi
  8007c9:	e9 c9 00 00 00       	jmp    800897 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  8007ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d1:	8b 00                	mov    (%eax),%eax
  8007d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8007d8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007db:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007de:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e1:	8d 40 04             	lea    0x4(%eax),%eax
  8007e4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007e7:	bf 0a 00 00 00       	mov    $0xa,%edi
  8007ec:	e9 a6 00 00 00       	jmp    800897 <vprintfmt+0x403>
			putch('0', putdat);
  8007f1:	83 ec 08             	sub    $0x8,%esp
  8007f4:	53                   	push   %ebx
  8007f5:	6a 30                	push   $0x30
  8007f7:	ff d6                	call   *%esi
	if (lflag >= 2)
  8007f9:	83 c4 10             	add    $0x10,%esp
  8007fc:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800800:	7f 26                	jg     800828 <vprintfmt+0x394>
	else if (lflag)
  800802:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800806:	74 3e                	je     800846 <vprintfmt+0x3b2>
		return va_arg(*ap, unsigned long);
  800808:	8b 45 14             	mov    0x14(%ebp),%eax
  80080b:	8b 00                	mov    (%eax),%eax
  80080d:	ba 00 00 00 00       	mov    $0x0,%edx
  800812:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800815:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800818:	8b 45 14             	mov    0x14(%ebp),%eax
  80081b:	8d 40 04             	lea    0x4(%eax),%eax
  80081e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800821:	bf 08 00 00 00       	mov    $0x8,%edi
  800826:	eb 6f                	jmp    800897 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  800828:	8b 45 14             	mov    0x14(%ebp),%eax
  80082b:	8b 50 04             	mov    0x4(%eax),%edx
  80082e:	8b 00                	mov    (%eax),%eax
  800830:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800833:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800836:	8b 45 14             	mov    0x14(%ebp),%eax
  800839:	8d 40 08             	lea    0x8(%eax),%eax
  80083c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80083f:	bf 08 00 00 00       	mov    $0x8,%edi
  800844:	eb 51                	jmp    800897 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  800846:	8b 45 14             	mov    0x14(%ebp),%eax
  800849:	8b 00                	mov    (%eax),%eax
  80084b:	ba 00 00 00 00       	mov    $0x0,%edx
  800850:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800853:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800856:	8b 45 14             	mov    0x14(%ebp),%eax
  800859:	8d 40 04             	lea    0x4(%eax),%eax
  80085c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80085f:	bf 08 00 00 00       	mov    $0x8,%edi
  800864:	eb 31                	jmp    800897 <vprintfmt+0x403>
			putch('0', putdat);
  800866:	83 ec 08             	sub    $0x8,%esp
  800869:	53                   	push   %ebx
  80086a:	6a 30                	push   $0x30
  80086c:	ff d6                	call   *%esi
			putch('x', putdat);
  80086e:	83 c4 08             	add    $0x8,%esp
  800871:	53                   	push   %ebx
  800872:	6a 78                	push   $0x78
  800874:	ff d6                	call   *%esi
			num = (unsigned long long)
  800876:	8b 45 14             	mov    0x14(%ebp),%eax
  800879:	8b 00                	mov    (%eax),%eax
  80087b:	ba 00 00 00 00       	mov    $0x0,%edx
  800880:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800883:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800886:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800889:	8b 45 14             	mov    0x14(%ebp),%eax
  80088c:	8d 40 04             	lea    0x4(%eax),%eax
  80088f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800892:	bf 10 00 00 00       	mov    $0x10,%edi
			if(posflag)
  800897:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80089b:	74 0b                	je     8008a8 <vprintfmt+0x414>
				putch('+', putdat);
  80089d:	83 ec 08             	sub    $0x8,%esp
  8008a0:	53                   	push   %ebx
  8008a1:	6a 2b                	push   $0x2b
  8008a3:	ff d6                	call   *%esi
  8008a5:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  8008a8:	83 ec 0c             	sub    $0xc,%esp
  8008ab:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8008af:	50                   	push   %eax
  8008b0:	ff 75 e0             	pushl  -0x20(%ebp)
  8008b3:	57                   	push   %edi
  8008b4:	ff 75 dc             	pushl  -0x24(%ebp)
  8008b7:	ff 75 d8             	pushl  -0x28(%ebp)
  8008ba:	89 da                	mov    %ebx,%edx
  8008bc:	89 f0                	mov    %esi,%eax
  8008be:	e8 b8 fa ff ff       	call   80037b <printnum>
			break;
  8008c3:	83 c4 20             	add    $0x20,%esp
			char* cp = va_arg(ap, char *);
  8008c6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008c9:	83 c7 01             	add    $0x1,%edi
  8008cc:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008d0:	83 f8 25             	cmp    $0x25,%eax
  8008d3:	0f 84 d2 fb ff ff    	je     8004ab <vprintfmt+0x17>
			if (ch == '\0')
  8008d9:	85 c0                	test   %eax,%eax
  8008db:	0f 84 03 01 00 00    	je     8009e4 <vprintfmt+0x550>
			putch(ch, putdat);
  8008e1:	83 ec 08             	sub    $0x8,%esp
  8008e4:	53                   	push   %ebx
  8008e5:	50                   	push   %eax
  8008e6:	ff d6                	call   *%esi
  8008e8:	83 c4 10             	add    $0x10,%esp
  8008eb:	eb dc                	jmp    8008c9 <vprintfmt+0x435>
	if (lflag >= 2)
  8008ed:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8008f1:	7f 29                	jg     80091c <vprintfmt+0x488>
	else if (lflag)
  8008f3:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8008f7:	74 44                	je     80093d <vprintfmt+0x4a9>
		return va_arg(*ap, unsigned long);
  8008f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008fc:	8b 00                	mov    (%eax),%eax
  8008fe:	ba 00 00 00 00       	mov    $0x0,%edx
  800903:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800906:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800909:	8b 45 14             	mov    0x14(%ebp),%eax
  80090c:	8d 40 04             	lea    0x4(%eax),%eax
  80090f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800912:	bf 10 00 00 00       	mov    $0x10,%edi
  800917:	e9 7b ff ff ff       	jmp    800897 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  80091c:	8b 45 14             	mov    0x14(%ebp),%eax
  80091f:	8b 50 04             	mov    0x4(%eax),%edx
  800922:	8b 00                	mov    (%eax),%eax
  800924:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800927:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80092a:	8b 45 14             	mov    0x14(%ebp),%eax
  80092d:	8d 40 08             	lea    0x8(%eax),%eax
  800930:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800933:	bf 10 00 00 00       	mov    $0x10,%edi
  800938:	e9 5a ff ff ff       	jmp    800897 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  80093d:	8b 45 14             	mov    0x14(%ebp),%eax
  800940:	8b 00                	mov    (%eax),%eax
  800942:	ba 00 00 00 00       	mov    $0x0,%edx
  800947:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80094a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80094d:	8b 45 14             	mov    0x14(%ebp),%eax
  800950:	8d 40 04             	lea    0x4(%eax),%eax
  800953:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800956:	bf 10 00 00 00       	mov    $0x10,%edi
  80095b:	e9 37 ff ff ff       	jmp    800897 <vprintfmt+0x403>
			char* cp = va_arg(ap, char *);
  800960:	8b 45 14             	mov    0x14(%ebp),%eax
  800963:	8d 78 04             	lea    0x4(%eax),%edi
  800966:	8b 00                	mov    (%eax),%eax
    			if (cp == NULL) {
  800968:	85 c0                	test   %eax,%eax
  80096a:	74 2c                	je     800998 <vprintfmt+0x504>
    			*cp = *(int *)putdat;
  80096c:	8b 13                	mov    (%ebx),%edx
  80096e:	88 10                	mov    %dl,(%eax)
			char* cp = va_arg(ap, char *);
  800970:	89 7d 14             	mov    %edi,0x14(%ebp)
    			if ((*(int *) putdat) > 127)
  800973:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  800976:	0f 8e 4a ff ff ff    	jle    8008c6 <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", overflow_error);
  80097c:	68 cc 27 80 00       	push   $0x8027cc
  800981:	68 be 2c 80 00       	push   $0x802cbe
  800986:	53                   	push   %ebx
  800987:	56                   	push   %esi
  800988:	e8 ea fa ff ff       	call   800477 <printfmt>
  80098d:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  800990:	89 7d 14             	mov    %edi,0x14(%ebp)
  800993:	e9 2e ff ff ff       	jmp    8008c6 <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", null_error);
  800998:	68 94 27 80 00       	push   $0x802794
  80099d:	68 be 2c 80 00       	push   $0x802cbe
  8009a2:	53                   	push   %ebx
  8009a3:	56                   	push   %esi
  8009a4:	e8 ce fa ff ff       	call   800477 <printfmt>
        		break;
  8009a9:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  8009ac:	89 7d 14             	mov    %edi,0x14(%ebp)
        		break;
  8009af:	e9 12 ff ff ff       	jmp    8008c6 <vprintfmt+0x432>
			putch(ch, putdat);
  8009b4:	83 ec 08             	sub    $0x8,%esp
  8009b7:	53                   	push   %ebx
  8009b8:	6a 25                	push   $0x25
  8009ba:	ff d6                	call   *%esi
			break;
  8009bc:	83 c4 10             	add    $0x10,%esp
  8009bf:	e9 02 ff ff ff       	jmp    8008c6 <vprintfmt+0x432>
			putch('%', putdat);
  8009c4:	83 ec 08             	sub    $0x8,%esp
  8009c7:	53                   	push   %ebx
  8009c8:	6a 25                	push   $0x25
  8009ca:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009cc:	83 c4 10             	add    $0x10,%esp
  8009cf:	89 f8                	mov    %edi,%eax
  8009d1:	eb 03                	jmp    8009d6 <vprintfmt+0x542>
  8009d3:	83 e8 01             	sub    $0x1,%eax
  8009d6:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8009da:	75 f7                	jne    8009d3 <vprintfmt+0x53f>
  8009dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009df:	e9 e2 fe ff ff       	jmp    8008c6 <vprintfmt+0x432>
}
  8009e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8009e7:	5b                   	pop    %ebx
  8009e8:	5e                   	pop    %esi
  8009e9:	5f                   	pop    %edi
  8009ea:	5d                   	pop    %ebp
  8009eb:	c3                   	ret    

008009ec <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009ec:	55                   	push   %ebp
  8009ed:	89 e5                	mov    %esp,%ebp
  8009ef:	83 ec 18             	sub    $0x18,%esp
  8009f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f5:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009f8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009fb:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8009ff:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800a02:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a09:	85 c0                	test   %eax,%eax
  800a0b:	74 26                	je     800a33 <vsnprintf+0x47>
  800a0d:	85 d2                	test   %edx,%edx
  800a0f:	7e 22                	jle    800a33 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a11:	ff 75 14             	pushl  0x14(%ebp)
  800a14:	ff 75 10             	pushl  0x10(%ebp)
  800a17:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a1a:	50                   	push   %eax
  800a1b:	68 5a 04 80 00       	push   $0x80045a
  800a20:	e8 6f fa ff ff       	call   800494 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a28:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a2e:	83 c4 10             	add    $0x10,%esp
}
  800a31:	c9                   	leave  
  800a32:	c3                   	ret    
		return -E_INVAL;
  800a33:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a38:	eb f7                	jmp    800a31 <vsnprintf+0x45>

00800a3a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a3a:	55                   	push   %ebp
  800a3b:	89 e5                	mov    %esp,%ebp
  800a3d:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a40:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a43:	50                   	push   %eax
  800a44:	ff 75 10             	pushl  0x10(%ebp)
  800a47:	ff 75 0c             	pushl  0xc(%ebp)
  800a4a:	ff 75 08             	pushl  0x8(%ebp)
  800a4d:	e8 9a ff ff ff       	call   8009ec <vsnprintf>
	va_end(ap);

	return rc;
}
  800a52:	c9                   	leave  
  800a53:	c3                   	ret    

00800a54 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a54:	55                   	push   %ebp
  800a55:	89 e5                	mov    %esp,%ebp
  800a57:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a5a:	b8 00 00 00 00       	mov    $0x0,%eax
  800a5f:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a63:	74 05                	je     800a6a <strlen+0x16>
		n++;
  800a65:	83 c0 01             	add    $0x1,%eax
  800a68:	eb f5                	jmp    800a5f <strlen+0xb>
	return n;
}
  800a6a:	5d                   	pop    %ebp
  800a6b:	c3                   	ret    

00800a6c <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a6c:	55                   	push   %ebp
  800a6d:	89 e5                	mov    %esp,%ebp
  800a6f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a72:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a75:	ba 00 00 00 00       	mov    $0x0,%edx
  800a7a:	39 c2                	cmp    %eax,%edx
  800a7c:	74 0d                	je     800a8b <strnlen+0x1f>
  800a7e:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800a82:	74 05                	je     800a89 <strnlen+0x1d>
		n++;
  800a84:	83 c2 01             	add    $0x1,%edx
  800a87:	eb f1                	jmp    800a7a <strnlen+0xe>
  800a89:	89 d0                	mov    %edx,%eax
	return n;
}
  800a8b:	5d                   	pop    %ebp
  800a8c:	c3                   	ret    

00800a8d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a8d:	55                   	push   %ebp
  800a8e:	89 e5                	mov    %esp,%ebp
  800a90:	53                   	push   %ebx
  800a91:	8b 45 08             	mov    0x8(%ebp),%eax
  800a94:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a97:	ba 00 00 00 00       	mov    $0x0,%edx
  800a9c:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800aa0:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800aa3:	83 c2 01             	add    $0x1,%edx
  800aa6:	84 c9                	test   %cl,%cl
  800aa8:	75 f2                	jne    800a9c <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800aaa:	5b                   	pop    %ebx
  800aab:	5d                   	pop    %ebp
  800aac:	c3                   	ret    

00800aad <strcat>:

char *
strcat(char *dst, const char *src)
{
  800aad:	55                   	push   %ebp
  800aae:	89 e5                	mov    %esp,%ebp
  800ab0:	53                   	push   %ebx
  800ab1:	83 ec 10             	sub    $0x10,%esp
  800ab4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800ab7:	53                   	push   %ebx
  800ab8:	e8 97 ff ff ff       	call   800a54 <strlen>
  800abd:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800ac0:	ff 75 0c             	pushl  0xc(%ebp)
  800ac3:	01 d8                	add    %ebx,%eax
  800ac5:	50                   	push   %eax
  800ac6:	e8 c2 ff ff ff       	call   800a8d <strcpy>
	return dst;
}
  800acb:	89 d8                	mov    %ebx,%eax
  800acd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ad0:	c9                   	leave  
  800ad1:	c3                   	ret    

00800ad2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800ad2:	55                   	push   %ebp
  800ad3:	89 e5                	mov    %esp,%ebp
  800ad5:	56                   	push   %esi
  800ad6:	53                   	push   %ebx
  800ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  800ada:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800add:	89 c6                	mov    %eax,%esi
  800adf:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ae2:	89 c2                	mov    %eax,%edx
  800ae4:	39 f2                	cmp    %esi,%edx
  800ae6:	74 11                	je     800af9 <strncpy+0x27>
		*dst++ = *src;
  800ae8:	83 c2 01             	add    $0x1,%edx
  800aeb:	0f b6 19             	movzbl (%ecx),%ebx
  800aee:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800af1:	80 fb 01             	cmp    $0x1,%bl
  800af4:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800af7:	eb eb                	jmp    800ae4 <strncpy+0x12>
	}
	return ret;
}
  800af9:	5b                   	pop    %ebx
  800afa:	5e                   	pop    %esi
  800afb:	5d                   	pop    %ebp
  800afc:	c3                   	ret    

00800afd <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800afd:	55                   	push   %ebp
  800afe:	89 e5                	mov    %esp,%ebp
  800b00:	56                   	push   %esi
  800b01:	53                   	push   %ebx
  800b02:	8b 75 08             	mov    0x8(%ebp),%esi
  800b05:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b08:	8b 55 10             	mov    0x10(%ebp),%edx
  800b0b:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b0d:	85 d2                	test   %edx,%edx
  800b0f:	74 21                	je     800b32 <strlcpy+0x35>
  800b11:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800b15:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800b17:	39 c2                	cmp    %eax,%edx
  800b19:	74 14                	je     800b2f <strlcpy+0x32>
  800b1b:	0f b6 19             	movzbl (%ecx),%ebx
  800b1e:	84 db                	test   %bl,%bl
  800b20:	74 0b                	je     800b2d <strlcpy+0x30>
			*dst++ = *src++;
  800b22:	83 c1 01             	add    $0x1,%ecx
  800b25:	83 c2 01             	add    $0x1,%edx
  800b28:	88 5a ff             	mov    %bl,-0x1(%edx)
  800b2b:	eb ea                	jmp    800b17 <strlcpy+0x1a>
  800b2d:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800b2f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b32:	29 f0                	sub    %esi,%eax
}
  800b34:	5b                   	pop    %ebx
  800b35:	5e                   	pop    %esi
  800b36:	5d                   	pop    %ebp
  800b37:	c3                   	ret    

00800b38 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b38:	55                   	push   %ebp
  800b39:	89 e5                	mov    %esp,%ebp
  800b3b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b3e:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b41:	0f b6 01             	movzbl (%ecx),%eax
  800b44:	84 c0                	test   %al,%al
  800b46:	74 0c                	je     800b54 <strcmp+0x1c>
  800b48:	3a 02                	cmp    (%edx),%al
  800b4a:	75 08                	jne    800b54 <strcmp+0x1c>
		p++, q++;
  800b4c:	83 c1 01             	add    $0x1,%ecx
  800b4f:	83 c2 01             	add    $0x1,%edx
  800b52:	eb ed                	jmp    800b41 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b54:	0f b6 c0             	movzbl %al,%eax
  800b57:	0f b6 12             	movzbl (%edx),%edx
  800b5a:	29 d0                	sub    %edx,%eax
}
  800b5c:	5d                   	pop    %ebp
  800b5d:	c3                   	ret    

00800b5e <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b5e:	55                   	push   %ebp
  800b5f:	89 e5                	mov    %esp,%ebp
  800b61:	53                   	push   %ebx
  800b62:	8b 45 08             	mov    0x8(%ebp),%eax
  800b65:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b68:	89 c3                	mov    %eax,%ebx
  800b6a:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b6d:	eb 06                	jmp    800b75 <strncmp+0x17>
		n--, p++, q++;
  800b6f:	83 c0 01             	add    $0x1,%eax
  800b72:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b75:	39 d8                	cmp    %ebx,%eax
  800b77:	74 16                	je     800b8f <strncmp+0x31>
  800b79:	0f b6 08             	movzbl (%eax),%ecx
  800b7c:	84 c9                	test   %cl,%cl
  800b7e:	74 04                	je     800b84 <strncmp+0x26>
  800b80:	3a 0a                	cmp    (%edx),%cl
  800b82:	74 eb                	je     800b6f <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b84:	0f b6 00             	movzbl (%eax),%eax
  800b87:	0f b6 12             	movzbl (%edx),%edx
  800b8a:	29 d0                	sub    %edx,%eax
}
  800b8c:	5b                   	pop    %ebx
  800b8d:	5d                   	pop    %ebp
  800b8e:	c3                   	ret    
		return 0;
  800b8f:	b8 00 00 00 00       	mov    $0x0,%eax
  800b94:	eb f6                	jmp    800b8c <strncmp+0x2e>

00800b96 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b96:	55                   	push   %ebp
  800b97:	89 e5                	mov    %esp,%ebp
  800b99:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ba0:	0f b6 10             	movzbl (%eax),%edx
  800ba3:	84 d2                	test   %dl,%dl
  800ba5:	74 09                	je     800bb0 <strchr+0x1a>
		if (*s == c)
  800ba7:	38 ca                	cmp    %cl,%dl
  800ba9:	74 0a                	je     800bb5 <strchr+0x1f>
	for (; *s; s++)
  800bab:	83 c0 01             	add    $0x1,%eax
  800bae:	eb f0                	jmp    800ba0 <strchr+0xa>
			return (char *) s;
	return 0;
  800bb0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bb5:	5d                   	pop    %ebp
  800bb6:	c3                   	ret    

00800bb7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800bb7:	55                   	push   %ebp
  800bb8:	89 e5                	mov    %esp,%ebp
  800bba:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbd:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bc1:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800bc4:	38 ca                	cmp    %cl,%dl
  800bc6:	74 09                	je     800bd1 <strfind+0x1a>
  800bc8:	84 d2                	test   %dl,%dl
  800bca:	74 05                	je     800bd1 <strfind+0x1a>
	for (; *s; s++)
  800bcc:	83 c0 01             	add    $0x1,%eax
  800bcf:	eb f0                	jmp    800bc1 <strfind+0xa>
			break;
	return (char *) s;
}
  800bd1:	5d                   	pop    %ebp
  800bd2:	c3                   	ret    

00800bd3 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800bd3:	55                   	push   %ebp
  800bd4:	89 e5                	mov    %esp,%ebp
  800bd6:	57                   	push   %edi
  800bd7:	56                   	push   %esi
  800bd8:	53                   	push   %ebx
  800bd9:	8b 7d 08             	mov    0x8(%ebp),%edi
  800bdc:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800bdf:	85 c9                	test   %ecx,%ecx
  800be1:	74 31                	je     800c14 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800be3:	89 f8                	mov    %edi,%eax
  800be5:	09 c8                	or     %ecx,%eax
  800be7:	a8 03                	test   $0x3,%al
  800be9:	75 23                	jne    800c0e <memset+0x3b>
		c &= 0xFF;
  800beb:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800bef:	89 d3                	mov    %edx,%ebx
  800bf1:	c1 e3 08             	shl    $0x8,%ebx
  800bf4:	89 d0                	mov    %edx,%eax
  800bf6:	c1 e0 18             	shl    $0x18,%eax
  800bf9:	89 d6                	mov    %edx,%esi
  800bfb:	c1 e6 10             	shl    $0x10,%esi
  800bfe:	09 f0                	or     %esi,%eax
  800c00:	09 c2                	or     %eax,%edx
  800c02:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800c04:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800c07:	89 d0                	mov    %edx,%eax
  800c09:	fc                   	cld    
  800c0a:	f3 ab                	rep stos %eax,%es:(%edi)
  800c0c:	eb 06                	jmp    800c14 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c11:	fc                   	cld    
  800c12:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c14:	89 f8                	mov    %edi,%eax
  800c16:	5b                   	pop    %ebx
  800c17:	5e                   	pop    %esi
  800c18:	5f                   	pop    %edi
  800c19:	5d                   	pop    %ebp
  800c1a:	c3                   	ret    

00800c1b <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c1b:	55                   	push   %ebp
  800c1c:	89 e5                	mov    %esp,%ebp
  800c1e:	57                   	push   %edi
  800c1f:	56                   	push   %esi
  800c20:	8b 45 08             	mov    0x8(%ebp),%eax
  800c23:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c26:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c29:	39 c6                	cmp    %eax,%esi
  800c2b:	73 32                	jae    800c5f <memmove+0x44>
  800c2d:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c30:	39 c2                	cmp    %eax,%edx
  800c32:	76 2b                	jbe    800c5f <memmove+0x44>
		s += n;
		d += n;
  800c34:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c37:	89 fe                	mov    %edi,%esi
  800c39:	09 ce                	or     %ecx,%esi
  800c3b:	09 d6                	or     %edx,%esi
  800c3d:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c43:	75 0e                	jne    800c53 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c45:	83 ef 04             	sub    $0x4,%edi
  800c48:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c4b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c4e:	fd                   	std    
  800c4f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c51:	eb 09                	jmp    800c5c <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c53:	83 ef 01             	sub    $0x1,%edi
  800c56:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c59:	fd                   	std    
  800c5a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c5c:	fc                   	cld    
  800c5d:	eb 1a                	jmp    800c79 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c5f:	89 c2                	mov    %eax,%edx
  800c61:	09 ca                	or     %ecx,%edx
  800c63:	09 f2                	or     %esi,%edx
  800c65:	f6 c2 03             	test   $0x3,%dl
  800c68:	75 0a                	jne    800c74 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c6a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c6d:	89 c7                	mov    %eax,%edi
  800c6f:	fc                   	cld    
  800c70:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c72:	eb 05                	jmp    800c79 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800c74:	89 c7                	mov    %eax,%edi
  800c76:	fc                   	cld    
  800c77:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c79:	5e                   	pop    %esi
  800c7a:	5f                   	pop    %edi
  800c7b:	5d                   	pop    %ebp
  800c7c:	c3                   	ret    

00800c7d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c7d:	55                   	push   %ebp
  800c7e:	89 e5                	mov    %esp,%ebp
  800c80:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c83:	ff 75 10             	pushl  0x10(%ebp)
  800c86:	ff 75 0c             	pushl  0xc(%ebp)
  800c89:	ff 75 08             	pushl  0x8(%ebp)
  800c8c:	e8 8a ff ff ff       	call   800c1b <memmove>
}
  800c91:	c9                   	leave  
  800c92:	c3                   	ret    

00800c93 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c93:	55                   	push   %ebp
  800c94:	89 e5                	mov    %esp,%ebp
  800c96:	56                   	push   %esi
  800c97:	53                   	push   %ebx
  800c98:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c9e:	89 c6                	mov    %eax,%esi
  800ca0:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ca3:	39 f0                	cmp    %esi,%eax
  800ca5:	74 1c                	je     800cc3 <memcmp+0x30>
		if (*s1 != *s2)
  800ca7:	0f b6 08             	movzbl (%eax),%ecx
  800caa:	0f b6 1a             	movzbl (%edx),%ebx
  800cad:	38 d9                	cmp    %bl,%cl
  800caf:	75 08                	jne    800cb9 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800cb1:	83 c0 01             	add    $0x1,%eax
  800cb4:	83 c2 01             	add    $0x1,%edx
  800cb7:	eb ea                	jmp    800ca3 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800cb9:	0f b6 c1             	movzbl %cl,%eax
  800cbc:	0f b6 db             	movzbl %bl,%ebx
  800cbf:	29 d8                	sub    %ebx,%eax
  800cc1:	eb 05                	jmp    800cc8 <memcmp+0x35>
	}

	return 0;
  800cc3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cc8:	5b                   	pop    %ebx
  800cc9:	5e                   	pop    %esi
  800cca:	5d                   	pop    %ebp
  800ccb:	c3                   	ret    

00800ccc <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ccc:	55                   	push   %ebp
  800ccd:	89 e5                	mov    %esp,%ebp
  800ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800cd5:	89 c2                	mov    %eax,%edx
  800cd7:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800cda:	39 d0                	cmp    %edx,%eax
  800cdc:	73 09                	jae    800ce7 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800cde:	38 08                	cmp    %cl,(%eax)
  800ce0:	74 05                	je     800ce7 <memfind+0x1b>
	for (; s < ends; s++)
  800ce2:	83 c0 01             	add    $0x1,%eax
  800ce5:	eb f3                	jmp    800cda <memfind+0xe>
			break;
	return (void *) s;
}
  800ce7:	5d                   	pop    %ebp
  800ce8:	c3                   	ret    

00800ce9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ce9:	55                   	push   %ebp
  800cea:	89 e5                	mov    %esp,%ebp
  800cec:	57                   	push   %edi
  800ced:	56                   	push   %esi
  800cee:	53                   	push   %ebx
  800cef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cf2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cf5:	eb 03                	jmp    800cfa <strtol+0x11>
		s++;
  800cf7:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800cfa:	0f b6 01             	movzbl (%ecx),%eax
  800cfd:	3c 20                	cmp    $0x20,%al
  800cff:	74 f6                	je     800cf7 <strtol+0xe>
  800d01:	3c 09                	cmp    $0x9,%al
  800d03:	74 f2                	je     800cf7 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800d05:	3c 2b                	cmp    $0x2b,%al
  800d07:	74 2a                	je     800d33 <strtol+0x4a>
	int neg = 0;
  800d09:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800d0e:	3c 2d                	cmp    $0x2d,%al
  800d10:	74 2b                	je     800d3d <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d12:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800d18:	75 0f                	jne    800d29 <strtol+0x40>
  800d1a:	80 39 30             	cmpb   $0x30,(%ecx)
  800d1d:	74 28                	je     800d47 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d1f:	85 db                	test   %ebx,%ebx
  800d21:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d26:	0f 44 d8             	cmove  %eax,%ebx
  800d29:	b8 00 00 00 00       	mov    $0x0,%eax
  800d2e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d31:	eb 50                	jmp    800d83 <strtol+0x9a>
		s++;
  800d33:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800d36:	bf 00 00 00 00       	mov    $0x0,%edi
  800d3b:	eb d5                	jmp    800d12 <strtol+0x29>
		s++, neg = 1;
  800d3d:	83 c1 01             	add    $0x1,%ecx
  800d40:	bf 01 00 00 00       	mov    $0x1,%edi
  800d45:	eb cb                	jmp    800d12 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d47:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d4b:	74 0e                	je     800d5b <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800d4d:	85 db                	test   %ebx,%ebx
  800d4f:	75 d8                	jne    800d29 <strtol+0x40>
		s++, base = 8;
  800d51:	83 c1 01             	add    $0x1,%ecx
  800d54:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d59:	eb ce                	jmp    800d29 <strtol+0x40>
		s += 2, base = 16;
  800d5b:	83 c1 02             	add    $0x2,%ecx
  800d5e:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d63:	eb c4                	jmp    800d29 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d65:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d68:	89 f3                	mov    %esi,%ebx
  800d6a:	80 fb 19             	cmp    $0x19,%bl
  800d6d:	77 29                	ja     800d98 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800d6f:	0f be d2             	movsbl %dl,%edx
  800d72:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d75:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d78:	7d 30                	jge    800daa <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800d7a:	83 c1 01             	add    $0x1,%ecx
  800d7d:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d81:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d83:	0f b6 11             	movzbl (%ecx),%edx
  800d86:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d89:	89 f3                	mov    %esi,%ebx
  800d8b:	80 fb 09             	cmp    $0x9,%bl
  800d8e:	77 d5                	ja     800d65 <strtol+0x7c>
			dig = *s - '0';
  800d90:	0f be d2             	movsbl %dl,%edx
  800d93:	83 ea 30             	sub    $0x30,%edx
  800d96:	eb dd                	jmp    800d75 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800d98:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d9b:	89 f3                	mov    %esi,%ebx
  800d9d:	80 fb 19             	cmp    $0x19,%bl
  800da0:	77 08                	ja     800daa <strtol+0xc1>
			dig = *s - 'A' + 10;
  800da2:	0f be d2             	movsbl %dl,%edx
  800da5:	83 ea 37             	sub    $0x37,%edx
  800da8:	eb cb                	jmp    800d75 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800daa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dae:	74 05                	je     800db5 <strtol+0xcc>
		*endptr = (char *) s;
  800db0:	8b 75 0c             	mov    0xc(%ebp),%esi
  800db3:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800db5:	89 c2                	mov    %eax,%edx
  800db7:	f7 da                	neg    %edx
  800db9:	85 ff                	test   %edi,%edi
  800dbb:	0f 45 c2             	cmovne %edx,%eax
}
  800dbe:	5b                   	pop    %ebx
  800dbf:	5e                   	pop    %esi
  800dc0:	5f                   	pop    %edi
  800dc1:	5d                   	pop    %ebp
  800dc2:	c3                   	ret    

00800dc3 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800dc3:	55                   	push   %ebp
  800dc4:	89 e5                	mov    %esp,%ebp
  800dc6:	57                   	push   %edi
  800dc7:	56                   	push   %esi
  800dc8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dc9:	b8 00 00 00 00       	mov    $0x0,%eax
  800dce:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd4:	89 c3                	mov    %eax,%ebx
  800dd6:	89 c7                	mov    %eax,%edi
  800dd8:	89 c6                	mov    %eax,%esi
  800dda:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ddc:	5b                   	pop    %ebx
  800ddd:	5e                   	pop    %esi
  800dde:	5f                   	pop    %edi
  800ddf:	5d                   	pop    %ebp
  800de0:	c3                   	ret    

00800de1 <sys_cgetc>:

int
sys_cgetc(void)
{
  800de1:	55                   	push   %ebp
  800de2:	89 e5                	mov    %esp,%ebp
  800de4:	57                   	push   %edi
  800de5:	56                   	push   %esi
  800de6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800de7:	ba 00 00 00 00       	mov    $0x0,%edx
  800dec:	b8 01 00 00 00       	mov    $0x1,%eax
  800df1:	89 d1                	mov    %edx,%ecx
  800df3:	89 d3                	mov    %edx,%ebx
  800df5:	89 d7                	mov    %edx,%edi
  800df7:	89 d6                	mov    %edx,%esi
  800df9:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800dfb:	5b                   	pop    %ebx
  800dfc:	5e                   	pop    %esi
  800dfd:	5f                   	pop    %edi
  800dfe:	5d                   	pop    %ebp
  800dff:	c3                   	ret    

00800e00 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800e00:	55                   	push   %ebp
  800e01:	89 e5                	mov    %esp,%ebp
  800e03:	57                   	push   %edi
  800e04:	56                   	push   %esi
  800e05:	53                   	push   %ebx
  800e06:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e09:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e0e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e11:	b8 03 00 00 00       	mov    $0x3,%eax
  800e16:	89 cb                	mov    %ecx,%ebx
  800e18:	89 cf                	mov    %ecx,%edi
  800e1a:	89 ce                	mov    %ecx,%esi
  800e1c:	cd 30                	int    $0x30
	if (check && ret > 0)
  800e1e:	85 c0                	test   %eax,%eax
  800e20:	7f 08                	jg     800e2a <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e22:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e25:	5b                   	pop    %ebx
  800e26:	5e                   	pop    %esi
  800e27:	5f                   	pop    %edi
  800e28:	5d                   	pop    %ebp
  800e29:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e2a:	83 ec 0c             	sub    $0xc,%esp
  800e2d:	50                   	push   %eax
  800e2e:	6a 03                	push   $0x3
  800e30:	68 e0 29 80 00       	push   $0x8029e0
  800e35:	6a 4c                	push   $0x4c
  800e37:	68 fd 29 80 00       	push   $0x8029fd
  800e3c:	e8 4b f4 ff ff       	call   80028c <_panic>

00800e41 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e41:	55                   	push   %ebp
  800e42:	89 e5                	mov    %esp,%ebp
  800e44:	57                   	push   %edi
  800e45:	56                   	push   %esi
  800e46:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e47:	ba 00 00 00 00       	mov    $0x0,%edx
  800e4c:	b8 02 00 00 00       	mov    $0x2,%eax
  800e51:	89 d1                	mov    %edx,%ecx
  800e53:	89 d3                	mov    %edx,%ebx
  800e55:	89 d7                	mov    %edx,%edi
  800e57:	89 d6                	mov    %edx,%esi
  800e59:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e5b:	5b                   	pop    %ebx
  800e5c:	5e                   	pop    %esi
  800e5d:	5f                   	pop    %edi
  800e5e:	5d                   	pop    %ebp
  800e5f:	c3                   	ret    

00800e60 <sys_yield>:

void
sys_yield(void)
{
  800e60:	55                   	push   %ebp
  800e61:	89 e5                	mov    %esp,%ebp
  800e63:	57                   	push   %edi
  800e64:	56                   	push   %esi
  800e65:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e66:	ba 00 00 00 00       	mov    $0x0,%edx
  800e6b:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e70:	89 d1                	mov    %edx,%ecx
  800e72:	89 d3                	mov    %edx,%ebx
  800e74:	89 d7                	mov    %edx,%edi
  800e76:	89 d6                	mov    %edx,%esi
  800e78:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e7a:	5b                   	pop    %ebx
  800e7b:	5e                   	pop    %esi
  800e7c:	5f                   	pop    %edi
  800e7d:	5d                   	pop    %ebp
  800e7e:	c3                   	ret    

00800e7f <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e7f:	55                   	push   %ebp
  800e80:	89 e5                	mov    %esp,%ebp
  800e82:	57                   	push   %edi
  800e83:	56                   	push   %esi
  800e84:	53                   	push   %ebx
  800e85:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e88:	be 00 00 00 00       	mov    $0x0,%esi
  800e8d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e90:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e93:	b8 04 00 00 00       	mov    $0x4,%eax
  800e98:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e9b:	89 f7                	mov    %esi,%edi
  800e9d:	cd 30                	int    $0x30
	if (check && ret > 0)
  800e9f:	85 c0                	test   %eax,%eax
  800ea1:	7f 08                	jg     800eab <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800ea3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ea6:	5b                   	pop    %ebx
  800ea7:	5e                   	pop    %esi
  800ea8:	5f                   	pop    %edi
  800ea9:	5d                   	pop    %ebp
  800eaa:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eab:	83 ec 0c             	sub    $0xc,%esp
  800eae:	50                   	push   %eax
  800eaf:	6a 04                	push   $0x4
  800eb1:	68 e0 29 80 00       	push   $0x8029e0
  800eb6:	6a 4c                	push   $0x4c
  800eb8:	68 fd 29 80 00       	push   $0x8029fd
  800ebd:	e8 ca f3 ff ff       	call   80028c <_panic>

00800ec2 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ec2:	55                   	push   %ebp
  800ec3:	89 e5                	mov    %esp,%ebp
  800ec5:	57                   	push   %edi
  800ec6:	56                   	push   %esi
  800ec7:	53                   	push   %ebx
  800ec8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ecb:	8b 55 08             	mov    0x8(%ebp),%edx
  800ece:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed1:	b8 05 00 00 00       	mov    $0x5,%eax
  800ed6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ed9:	8b 7d 14             	mov    0x14(%ebp),%edi
  800edc:	8b 75 18             	mov    0x18(%ebp),%esi
  800edf:	cd 30                	int    $0x30
	if (check && ret > 0)
  800ee1:	85 c0                	test   %eax,%eax
  800ee3:	7f 08                	jg     800eed <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ee5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ee8:	5b                   	pop    %ebx
  800ee9:	5e                   	pop    %esi
  800eea:	5f                   	pop    %edi
  800eeb:	5d                   	pop    %ebp
  800eec:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eed:	83 ec 0c             	sub    $0xc,%esp
  800ef0:	50                   	push   %eax
  800ef1:	6a 05                	push   $0x5
  800ef3:	68 e0 29 80 00       	push   $0x8029e0
  800ef8:	6a 4c                	push   $0x4c
  800efa:	68 fd 29 80 00       	push   $0x8029fd
  800eff:	e8 88 f3 ff ff       	call   80028c <_panic>

00800f04 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800f04:	55                   	push   %ebp
  800f05:	89 e5                	mov    %esp,%ebp
  800f07:	57                   	push   %edi
  800f08:	56                   	push   %esi
  800f09:	53                   	push   %ebx
  800f0a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f0d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f12:	8b 55 08             	mov    0x8(%ebp),%edx
  800f15:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f18:	b8 06 00 00 00       	mov    $0x6,%eax
  800f1d:	89 df                	mov    %ebx,%edi
  800f1f:	89 de                	mov    %ebx,%esi
  800f21:	cd 30                	int    $0x30
	if (check && ret > 0)
  800f23:	85 c0                	test   %eax,%eax
  800f25:	7f 08                	jg     800f2f <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f27:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f2a:	5b                   	pop    %ebx
  800f2b:	5e                   	pop    %esi
  800f2c:	5f                   	pop    %edi
  800f2d:	5d                   	pop    %ebp
  800f2e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f2f:	83 ec 0c             	sub    $0xc,%esp
  800f32:	50                   	push   %eax
  800f33:	6a 06                	push   $0x6
  800f35:	68 e0 29 80 00       	push   $0x8029e0
  800f3a:	6a 4c                	push   $0x4c
  800f3c:	68 fd 29 80 00       	push   $0x8029fd
  800f41:	e8 46 f3 ff ff       	call   80028c <_panic>

00800f46 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f46:	55                   	push   %ebp
  800f47:	89 e5                	mov    %esp,%ebp
  800f49:	57                   	push   %edi
  800f4a:	56                   	push   %esi
  800f4b:	53                   	push   %ebx
  800f4c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f4f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f54:	8b 55 08             	mov    0x8(%ebp),%edx
  800f57:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f5a:	b8 08 00 00 00       	mov    $0x8,%eax
  800f5f:	89 df                	mov    %ebx,%edi
  800f61:	89 de                	mov    %ebx,%esi
  800f63:	cd 30                	int    $0x30
	if (check && ret > 0)
  800f65:	85 c0                	test   %eax,%eax
  800f67:	7f 08                	jg     800f71 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f69:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f6c:	5b                   	pop    %ebx
  800f6d:	5e                   	pop    %esi
  800f6e:	5f                   	pop    %edi
  800f6f:	5d                   	pop    %ebp
  800f70:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f71:	83 ec 0c             	sub    $0xc,%esp
  800f74:	50                   	push   %eax
  800f75:	6a 08                	push   $0x8
  800f77:	68 e0 29 80 00       	push   $0x8029e0
  800f7c:	6a 4c                	push   $0x4c
  800f7e:	68 fd 29 80 00       	push   $0x8029fd
  800f83:	e8 04 f3 ff ff       	call   80028c <_panic>

00800f88 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f88:	55                   	push   %ebp
  800f89:	89 e5                	mov    %esp,%ebp
  800f8b:	57                   	push   %edi
  800f8c:	56                   	push   %esi
  800f8d:	53                   	push   %ebx
  800f8e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f91:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f96:	8b 55 08             	mov    0x8(%ebp),%edx
  800f99:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f9c:	b8 09 00 00 00       	mov    $0x9,%eax
  800fa1:	89 df                	mov    %ebx,%edi
  800fa3:	89 de                	mov    %ebx,%esi
  800fa5:	cd 30                	int    $0x30
	if (check && ret > 0)
  800fa7:	85 c0                	test   %eax,%eax
  800fa9:	7f 08                	jg     800fb3 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800fab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fae:	5b                   	pop    %ebx
  800faf:	5e                   	pop    %esi
  800fb0:	5f                   	pop    %edi
  800fb1:	5d                   	pop    %ebp
  800fb2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fb3:	83 ec 0c             	sub    $0xc,%esp
  800fb6:	50                   	push   %eax
  800fb7:	6a 09                	push   $0x9
  800fb9:	68 e0 29 80 00       	push   $0x8029e0
  800fbe:	6a 4c                	push   $0x4c
  800fc0:	68 fd 29 80 00       	push   $0x8029fd
  800fc5:	e8 c2 f2 ff ff       	call   80028c <_panic>

00800fca <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800fca:	55                   	push   %ebp
  800fcb:	89 e5                	mov    %esp,%ebp
  800fcd:	57                   	push   %edi
  800fce:	56                   	push   %esi
  800fcf:	53                   	push   %ebx
  800fd0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fd3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fd8:	8b 55 08             	mov    0x8(%ebp),%edx
  800fdb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fde:	b8 0a 00 00 00       	mov    $0xa,%eax
  800fe3:	89 df                	mov    %ebx,%edi
  800fe5:	89 de                	mov    %ebx,%esi
  800fe7:	cd 30                	int    $0x30
	if (check && ret > 0)
  800fe9:	85 c0                	test   %eax,%eax
  800feb:	7f 08                	jg     800ff5 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800fed:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ff0:	5b                   	pop    %ebx
  800ff1:	5e                   	pop    %esi
  800ff2:	5f                   	pop    %edi
  800ff3:	5d                   	pop    %ebp
  800ff4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ff5:	83 ec 0c             	sub    $0xc,%esp
  800ff8:	50                   	push   %eax
  800ff9:	6a 0a                	push   $0xa
  800ffb:	68 e0 29 80 00       	push   $0x8029e0
  801000:	6a 4c                	push   $0x4c
  801002:	68 fd 29 80 00       	push   $0x8029fd
  801007:	e8 80 f2 ff ff       	call   80028c <_panic>

0080100c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80100c:	55                   	push   %ebp
  80100d:	89 e5                	mov    %esp,%ebp
  80100f:	57                   	push   %edi
  801010:	56                   	push   %esi
  801011:	53                   	push   %ebx
	asm volatile("int %1\n"
  801012:	8b 55 08             	mov    0x8(%ebp),%edx
  801015:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801018:	b8 0c 00 00 00       	mov    $0xc,%eax
  80101d:	be 00 00 00 00       	mov    $0x0,%esi
  801022:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801025:	8b 7d 14             	mov    0x14(%ebp),%edi
  801028:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80102a:	5b                   	pop    %ebx
  80102b:	5e                   	pop    %esi
  80102c:	5f                   	pop    %edi
  80102d:	5d                   	pop    %ebp
  80102e:	c3                   	ret    

0080102f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80102f:	55                   	push   %ebp
  801030:	89 e5                	mov    %esp,%ebp
  801032:	57                   	push   %edi
  801033:	56                   	push   %esi
  801034:	53                   	push   %ebx
  801035:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801038:	b9 00 00 00 00       	mov    $0x0,%ecx
  80103d:	8b 55 08             	mov    0x8(%ebp),%edx
  801040:	b8 0d 00 00 00       	mov    $0xd,%eax
  801045:	89 cb                	mov    %ecx,%ebx
  801047:	89 cf                	mov    %ecx,%edi
  801049:	89 ce                	mov    %ecx,%esi
  80104b:	cd 30                	int    $0x30
	if (check && ret > 0)
  80104d:	85 c0                	test   %eax,%eax
  80104f:	7f 08                	jg     801059 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801051:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801054:	5b                   	pop    %ebx
  801055:	5e                   	pop    %esi
  801056:	5f                   	pop    %edi
  801057:	5d                   	pop    %ebp
  801058:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801059:	83 ec 0c             	sub    $0xc,%esp
  80105c:	50                   	push   %eax
  80105d:	6a 0d                	push   $0xd
  80105f:	68 e0 29 80 00       	push   $0x8029e0
  801064:	6a 4c                	push   $0x4c
  801066:	68 fd 29 80 00       	push   $0x8029fd
  80106b:	e8 1c f2 ff ff       	call   80028c <_panic>

00801070 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  801070:	55                   	push   %ebp
  801071:	89 e5                	mov    %esp,%ebp
  801073:	57                   	push   %edi
  801074:	56                   	push   %esi
  801075:	53                   	push   %ebx
	asm volatile("int %1\n"
  801076:	bb 00 00 00 00       	mov    $0x0,%ebx
  80107b:	8b 55 08             	mov    0x8(%ebp),%edx
  80107e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801081:	b8 0e 00 00 00       	mov    $0xe,%eax
  801086:	89 df                	mov    %ebx,%edi
  801088:	89 de                	mov    %ebx,%esi
  80108a:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  80108c:	5b                   	pop    %ebx
  80108d:	5e                   	pop    %esi
  80108e:	5f                   	pop    %edi
  80108f:	5d                   	pop    %ebp
  801090:	c3                   	ret    

00801091 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  801091:	55                   	push   %ebp
  801092:	89 e5                	mov    %esp,%ebp
  801094:	57                   	push   %edi
  801095:	56                   	push   %esi
  801096:	53                   	push   %ebx
	asm volatile("int %1\n"
  801097:	b9 00 00 00 00       	mov    $0x0,%ecx
  80109c:	8b 55 08             	mov    0x8(%ebp),%edx
  80109f:	b8 0f 00 00 00       	mov    $0xf,%eax
  8010a4:	89 cb                	mov    %ecx,%ebx
  8010a6:	89 cf                	mov    %ecx,%edi
  8010a8:	89 ce                	mov    %ecx,%esi
  8010aa:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8010ac:	5b                   	pop    %ebx
  8010ad:	5e                   	pop    %esi
  8010ae:	5f                   	pop    %edi
  8010af:	5d                   	pop    %ebp
  8010b0:	c3                   	ret    

008010b1 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8010b1:	55                   	push   %ebp
  8010b2:	89 e5                	mov    %esp,%ebp
  8010b4:	53                   	push   %ebx
  8010b5:	83 ec 04             	sub    $0x4,%esp
  8010b8:	8b 55 08             	mov    0x8(%ebp),%edx
	// cprintf("pgfault()\n");
	void *addr = (void *) utf->utf_fault_va;
  8010bb:	8b 02                	mov    (%edx),%eax
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(!(err & FEC_WR) || !(uvpd[PDX(addr)] & PTE_P) || !(uvpt[PGNUM(addr)] & PTE_P) || !(uvpt[PGNUM(addr)] & PTE_COW))
  8010bd:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  8010c1:	0f 84 9c 00 00 00    	je     801163 <pgfault+0xb2>
  8010c7:	89 c2                	mov    %eax,%edx
  8010c9:	c1 ea 16             	shr    $0x16,%edx
  8010cc:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010d3:	f6 c2 01             	test   $0x1,%dl
  8010d6:	0f 84 87 00 00 00    	je     801163 <pgfault+0xb2>
  8010dc:	89 c2                	mov    %eax,%edx
  8010de:	c1 ea 0c             	shr    $0xc,%edx
  8010e1:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8010e8:	f6 c1 01             	test   $0x1,%cl
  8010eb:	74 76                	je     801163 <pgfault+0xb2>
  8010ed:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010f4:	f6 c6 08             	test   $0x8,%dh
  8010f7:	74 6a                	je     801163 <pgfault+0xb2>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  8010f9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010fe:	89 c3                	mov    %eax,%ebx

	r = sys_page_alloc(0, PFTEMP, PTE_P|PTE_U|PTE_W);
  801100:	83 ec 04             	sub    $0x4,%esp
  801103:	6a 07                	push   $0x7
  801105:	68 00 f0 7f 00       	push   $0x7ff000
  80110a:	6a 00                	push   $0x0
  80110c:	e8 6e fd ff ff       	call   800e7f <sys_page_alloc>
	if(r < 0){
  801111:	83 c4 10             	add    $0x10,%esp
  801114:	85 c0                	test   %eax,%eax
  801116:	78 5f                	js     801177 <pgfault+0xc6>
		panic("pgfault: sys_page_alloc fail, r: %d", r);
	}

	memmove(PFTEMP, addr, PGSIZE);
  801118:	83 ec 04             	sub    $0x4,%esp
  80111b:	68 00 10 00 00       	push   $0x1000
  801120:	53                   	push   %ebx
  801121:	68 00 f0 7f 00       	push   $0x7ff000
  801126:	e8 f0 fa ff ff       	call   800c1b <memmove>

	r = sys_page_map(0, PFTEMP, 0, addr, PTE_P|PTE_U|PTE_W);
  80112b:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801132:	53                   	push   %ebx
  801133:	6a 00                	push   $0x0
  801135:	68 00 f0 7f 00       	push   $0x7ff000
  80113a:	6a 00                	push   $0x0
  80113c:	e8 81 fd ff ff       	call   800ec2 <sys_page_map>
	if(r < 0){
  801141:	83 c4 20             	add    $0x20,%esp
  801144:	85 c0                	test   %eax,%eax
  801146:	78 41                	js     801189 <pgfault+0xd8>
		panic("pgfault: sys_page_map fail, r: %d", r);
	}

	r = sys_page_unmap(0, PFTEMP);
  801148:	83 ec 08             	sub    $0x8,%esp
  80114b:	68 00 f0 7f 00       	push   $0x7ff000
  801150:	6a 00                	push   $0x0
  801152:	e8 ad fd ff ff       	call   800f04 <sys_page_unmap>
	if(r < 0){
  801157:	83 c4 10             	add    $0x10,%esp
  80115a:	85 c0                	test   %eax,%eax
  80115c:	78 3d                	js     80119b <pgfault+0xea>
		panic("sys_page_unmap: %e", r);
	}
}
  80115e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801161:	c9                   	leave  
  801162:	c3                   	ret    
		panic("pgfault: 1\n");
  801163:	83 ec 04             	sub    $0x4,%esp
  801166:	68 0b 2a 80 00       	push   $0x802a0b
  80116b:	6a 20                	push   $0x20
  80116d:	68 17 2a 80 00       	push   $0x802a17
  801172:	e8 15 f1 ff ff       	call   80028c <_panic>
		panic("pgfault: sys_page_alloc fail, r: %d", r);
  801177:	50                   	push   %eax
  801178:	68 6c 2a 80 00       	push   $0x802a6c
  80117d:	6a 2e                	push   $0x2e
  80117f:	68 17 2a 80 00       	push   $0x802a17
  801184:	e8 03 f1 ff ff       	call   80028c <_panic>
		panic("pgfault: sys_page_map fail, r: %d", r);
  801189:	50                   	push   %eax
  80118a:	68 90 2a 80 00       	push   $0x802a90
  80118f:	6a 35                	push   $0x35
  801191:	68 17 2a 80 00       	push   $0x802a17
  801196:	e8 f1 f0 ff ff       	call   80028c <_panic>
		panic("sys_page_unmap: %e", r);
  80119b:	50                   	push   %eax
  80119c:	68 22 2a 80 00       	push   $0x802a22
  8011a1:	6a 3a                	push   $0x3a
  8011a3:	68 17 2a 80 00       	push   $0x802a17
  8011a8:	e8 df f0 ff ff       	call   80028c <_panic>

008011ad <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8011ad:	55                   	push   %ebp
  8011ae:	89 e5                	mov    %esp,%ebp
  8011b0:	57                   	push   %edi
  8011b1:	56                   	push   %esi
  8011b2:	53                   	push   %ebx
  8011b3:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	// panic("fork not implemented");
	int r;
	set_pgfault_handler(pgfault);
  8011b6:	68 b1 10 80 00       	push   $0x8010b1
  8011bb:	e8 90 0f 00 00       	call   802150 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8011c0:	b8 07 00 00 00       	mov    $0x7,%eax
  8011c5:	cd 30                	int    $0x30
  8011c7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int i;
	uintptr_t va;
	envid_t childid = sys_exofork();
	if (childid < 0){
  8011ca:	83 c4 10             	add    $0x10,%esp
  8011cd:	85 c0                	test   %eax,%eax
  8011cf:	78 2c                	js     8011fd <fork+0x50>
  8011d1:	89 c7                	mov    %eax,%edi
	}

	extern volatile pde_t uvpd[];
	extern volatile pte_t uvpt[];

	for (va = UTEXT; va < USTACKTOP; va += PGSIZE){
  8011d3:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if (childid == 0) {
  8011d8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8011dc:	75 72                	jne    801250 <fork+0xa3>
		thisenv = &envs[ENVX(sys_getenvid())];
  8011de:	e8 5e fc ff ff       	call   800e41 <sys_getenvid>
  8011e3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8011e8:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8011ee:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8011f3:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  8011f8:	e9 36 01 00 00       	jmp    801333 <fork+0x186>
		panic("fork: child id < 0: %d", childid);
  8011fd:	50                   	push   %eax
  8011fe:	68 35 2a 80 00       	push   $0x802a35
  801203:	68 83 00 00 00       	push   $0x83
  801208:	68 17 2a 80 00       	push   $0x802a17
  80120d:	e8 7a f0 ff ff       	call   80028c <_panic>
			panic("sys_page_map: sys_page_map fail, r:%d\n", r);
  801212:	50                   	push   %eax
  801213:	68 b4 2a 80 00       	push   $0x802ab4
  801218:	6a 56                	push   $0x56
  80121a:	68 17 2a 80 00       	push   $0x802a17
  80121f:	e8 68 f0 ff ff       	call   80028c <_panic>
		r = sys_page_map((envid_t)0, va, envid, va, PTE_U | PTE_P);
  801224:	83 ec 0c             	sub    $0xc,%esp
  801227:	6a 05                	push   $0x5
  801229:	56                   	push   %esi
  80122a:	57                   	push   %edi
  80122b:	56                   	push   %esi
  80122c:	6a 00                	push   $0x0
  80122e:	e8 8f fc ff ff       	call   800ec2 <sys_page_map>
		if(r < 0){
  801233:	83 c4 20             	add    $0x20,%esp
  801236:	85 c0                	test   %eax,%eax
  801238:	0f 88 9f 00 00 00    	js     8012dd <fork+0x130>
	for (va = UTEXT; va < USTACKTOP; va += PGSIZE){
  80123e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801244:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  80124a:	0f 84 9f 00 00 00    	je     8012ef <fork+0x142>
		if ((uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_U)){
  801250:	89 d8                	mov    %ebx,%eax
  801252:	c1 e8 16             	shr    $0x16,%eax
  801255:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80125c:	a8 01                	test   $0x1,%al
  80125e:	74 de                	je     80123e <fork+0x91>
  801260:	89 d8                	mov    %ebx,%eax
  801262:	c1 e8 0c             	shr    $0xc,%eax
  801265:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80126c:	f6 c2 01             	test   $0x1,%dl
  80126f:	74 cd                	je     80123e <fork+0x91>
  801271:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801278:	f6 c2 04             	test   $0x4,%dl
  80127b:	74 c1                	je     80123e <fork+0x91>
	void * va = (void *)(pn * PGSIZE);
  80127d:	89 c6                	mov    %eax,%esi
  80127f:	c1 e6 0c             	shl    $0xc,%esi
	int perm = (uvpt[pn]);
  801282:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (perm & (PTE_W | PTE_COW)) {
  801289:	a9 02 08 00 00       	test   $0x802,%eax
  80128e:	74 94                	je     801224 <fork+0x77>
		r = sys_page_map((envid_t)0, va, envid, va, PTE_U | PTE_P | PTE_COW);
  801290:	83 ec 0c             	sub    $0xc,%esp
  801293:	68 05 08 00 00       	push   $0x805
  801298:	56                   	push   %esi
  801299:	57                   	push   %edi
  80129a:	56                   	push   %esi
  80129b:	6a 00                	push   $0x0
  80129d:	e8 20 fc ff ff       	call   800ec2 <sys_page_map>
		if(r < 0){
  8012a2:	83 c4 20             	add    $0x20,%esp
  8012a5:	85 c0                	test   %eax,%eax
  8012a7:	0f 88 65 ff ff ff    	js     801212 <fork+0x65>
		r = sys_page_map((envid_t)0, va, (envid_t)0, va, PTE_U | PTE_P | PTE_COW);
  8012ad:	83 ec 0c             	sub    $0xc,%esp
  8012b0:	68 05 08 00 00       	push   $0x805
  8012b5:	56                   	push   %esi
  8012b6:	6a 00                	push   $0x0
  8012b8:	56                   	push   %esi
  8012b9:	6a 00                	push   $0x0
  8012bb:	e8 02 fc ff ff       	call   800ec2 <sys_page_map>
		if(r < 0){
  8012c0:	83 c4 20             	add    $0x20,%esp
  8012c3:	85 c0                	test   %eax,%eax
  8012c5:	0f 89 73 ff ff ff    	jns    80123e <fork+0x91>
			panic("sys_page_map: sys_page_map fail, r:%d\n", r);
  8012cb:	50                   	push   %eax
  8012cc:	68 b4 2a 80 00       	push   $0x802ab4
  8012d1:	6a 5b                	push   $0x5b
  8012d3:	68 17 2a 80 00       	push   $0x802a17
  8012d8:	e8 af ef ff ff       	call   80028c <_panic>
			panic("sys_page_map: sys_page_map fail, r:%d\n", r);
  8012dd:	50                   	push   %eax
  8012de:	68 b4 2a 80 00       	push   $0x802ab4
  8012e3:	6a 61                	push   $0x61
  8012e5:	68 17 2a 80 00       	push   $0x802a17
  8012ea:	e8 9d ef ff ff       	call   80028c <_panic>
			duppage(childid, PGNUM(va));
		}
	}

	r = sys_page_alloc(childid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8012ef:	83 ec 04             	sub    $0x4,%esp
  8012f2:	6a 07                	push   $0x7
  8012f4:	68 00 f0 bf ee       	push   $0xeebff000
  8012f9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012fc:	e8 7e fb ff ff       	call   800e7f <sys_page_alloc>
	if (r < 0){
  801301:	83 c4 10             	add    $0x10,%esp
  801304:	85 c0                	test   %eax,%eax
  801306:	78 36                	js     80133e <fork+0x191>
		panic("fork: allocate user exception stack for child env error, %d", r);
	}
	r = sys_env_set_pgfault_upcall(childid, _pgfault_upcall);
  801308:	83 ec 08             	sub    $0x8,%esp
  80130b:	68 bb 21 80 00       	push   $0x8021bb
  801310:	ff 75 e4             	pushl  -0x1c(%ebp)
  801313:	e8 b2 fc ff ff       	call   800fca <sys_env_set_pgfault_upcall>
	if (r < 0){
  801318:	83 c4 10             	add    $0x10,%esp
  80131b:	85 c0                	test   %eax,%eax
  80131d:	78 34                	js     801353 <fork+0x1a6>
		panic("fork: sys_env_set_pgfault_upcall error, %d", r);
	}
	r = sys_env_set_status(childid, ENV_RUNNABLE);
  80131f:	83 ec 08             	sub    $0x8,%esp
  801322:	6a 02                	push   $0x2
  801324:	ff 75 e4             	pushl  -0x1c(%ebp)
  801327:	e8 1a fc ff ff       	call   800f46 <sys_env_set_status>
	if(r < 0){
  80132c:	83 c4 10             	add    $0x10,%esp
  80132f:	85 c0                	test   %eax,%eax
  801331:	78 35                	js     801368 <fork+0x1bb>
		panic("forK: sys_env_set_status, r%d", r);
	}
	return childid;
}
  801333:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801336:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801339:	5b                   	pop    %ebx
  80133a:	5e                   	pop    %esi
  80133b:	5f                   	pop    %edi
  80133c:	5d                   	pop    %ebp
  80133d:	c3                   	ret    
		panic("fork: allocate user exception stack for child env error, %d", r);
  80133e:	50                   	push   %eax
  80133f:	68 dc 2a 80 00       	push   $0x802adc
  801344:	68 96 00 00 00       	push   $0x96
  801349:	68 17 2a 80 00       	push   $0x802a17
  80134e:	e8 39 ef ff ff       	call   80028c <_panic>
		panic("fork: sys_env_set_pgfault_upcall error, %d", r);
  801353:	50                   	push   %eax
  801354:	68 18 2b 80 00       	push   $0x802b18
  801359:	68 9a 00 00 00       	push   $0x9a
  80135e:	68 17 2a 80 00       	push   $0x802a17
  801363:	e8 24 ef ff ff       	call   80028c <_panic>
		panic("forK: sys_env_set_status, r%d", r);
  801368:	50                   	push   %eax
  801369:	68 4c 2a 80 00       	push   $0x802a4c
  80136e:	68 9e 00 00 00       	push   $0x9e
  801373:	68 17 2a 80 00       	push   $0x802a17
  801378:	e8 0f ef ff ff       	call   80028c <_panic>

0080137d <sfork>:

// Challenge!
int
sfork(void)
{
  80137d:	55                   	push   %ebp
  80137e:	89 e5                	mov    %esp,%ebp
  801380:	57                   	push   %edi
  801381:	56                   	push   %esi
  801382:	53                   	push   %ebx
  801383:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// return -E_INVAL;
	set_pgfault_handler(pgfault);
  801386:	68 b1 10 80 00       	push   $0x8010b1
  80138b:	e8 c0 0d 00 00       	call   802150 <set_pgfault_handler>
  801390:	b8 07 00 00 00       	mov    $0x7,%eax
  801395:	cd 30                	int    $0x30
  801397:	89 c6                	mov    %eax,%esi
	int i;
	uintptr_t va;
	envid_t childid = sys_exofork();
	int r;
	if (childid < 0){
  801399:	83 c4 10             	add    $0x10,%esp
  80139c:	85 c0                	test   %eax,%eax
  80139e:	78 28                	js     8013c8 <sfork+0x4b>
  8013a0:	89 c7                	mov    %eax,%edi
	}

	extern volatile pde_t uvpd[];
	extern volatile pte_t uvpt[];

	for (va = 0; va < USTACKTOP; va += PGSIZE){
  8013a2:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (childid == 0) {
  8013a7:	75 42                	jne    8013eb <sfork+0x6e>
		thisenv = &envs[ENVX(sys_getenvid())];
  8013a9:	e8 93 fa ff ff       	call   800e41 <sys_getenvid>
  8013ae:	25 ff 03 00 00       	and    $0x3ff,%eax
  8013b3:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8013b9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8013be:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  8013c3:	e9 bc 00 00 00       	jmp    801484 <sfork+0x107>
		panic("fork: child id < 0: %d", childid);
  8013c8:	50                   	push   %eax
  8013c9:	68 35 2a 80 00       	push   $0x802a35
  8013ce:	68 af 00 00 00       	push   $0xaf
  8013d3:	68 17 2a 80 00       	push   $0x802a17
  8013d8:	e8 af ee ff ff       	call   80028c <_panic>
	for (va = 0; va < USTACKTOP; va += PGSIZE){
  8013dd:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8013e3:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8013e9:	74 5b                	je     801446 <sfork+0xc9>
		if ((uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_U)){
  8013eb:	89 d8                	mov    %ebx,%eax
  8013ed:	c1 e8 16             	shr    $0x16,%eax
  8013f0:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8013f7:	a8 01                	test   $0x1,%al
  8013f9:	74 e2                	je     8013dd <sfork+0x60>
  8013fb:	89 d8                	mov    %ebx,%eax
  8013fd:	c1 e8 0c             	shr    $0xc,%eax
  801400:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801407:	f6 c2 01             	test   $0x1,%dl
  80140a:	74 d1                	je     8013dd <sfork+0x60>
  80140c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801413:	f6 c2 04             	test   $0x4,%dl
  801416:	74 c5                	je     8013dd <sfork+0x60>
			void *addr = (void *)(PGNUM(va) * PGSIZE);
  801418:	c1 e0 0c             	shl    $0xc,%eax
			struct PageInfo *page;
			pte_t *pte;
			
			// page = page_lookup((envid_t)0->env_pgdir, addr, &pte);
			// page_insert(dstenv->env_pgdir, page, addr, PTE_U | PTE_P);
			r = sys_page_map((envid_t)0, addr, childid, addr, PTE_U | PTE_P);
  80141b:	83 ec 0c             	sub    $0xc,%esp
  80141e:	6a 05                	push   $0x5
  801420:	50                   	push   %eax
  801421:	57                   	push   %edi
  801422:	50                   	push   %eax
  801423:	6a 00                	push   $0x0
  801425:	e8 98 fa ff ff       	call   800ec2 <sys_page_map>
			if(r < 0){
  80142a:	83 c4 20             	add    $0x20,%esp
  80142d:	85 c0                	test   %eax,%eax
  80142f:	79 ac                	jns    8013dd <sfork+0x60>
				panic("sfork: sys_page_map fail, r:%d\n", r);
  801431:	50                   	push   %eax
  801432:	68 44 2b 80 00       	push   $0x802b44
  801437:	68 c4 00 00 00       	push   $0xc4
  80143c:	68 17 2a 80 00       	push   $0x802a17
  801441:	e8 46 ee ff ff       	call   80028c <_panic>
			}
		}
	}

	r = sys_page_alloc(childid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801446:	83 ec 04             	sub    $0x4,%esp
  801449:	6a 07                	push   $0x7
  80144b:	68 00 f0 bf ee       	push   $0xeebff000
  801450:	56                   	push   %esi
  801451:	e8 29 fa ff ff       	call   800e7f <sys_page_alloc>
	if (r < 0){
  801456:	83 c4 10             	add    $0x10,%esp
  801459:	85 c0                	test   %eax,%eax
  80145b:	78 31                	js     80148e <sfork+0x111>
		panic("sfork: allocate user exception stack for child env error, %d", r);
	}
	r = sys_env_set_pgfault_upcall(childid, _pgfault_upcall);
  80145d:	83 ec 08             	sub    $0x8,%esp
  801460:	68 bb 21 80 00       	push   $0x8021bb
  801465:	56                   	push   %esi
  801466:	e8 5f fb ff ff       	call   800fca <sys_env_set_pgfault_upcall>
	if (r < 0){
  80146b:	83 c4 10             	add    $0x10,%esp
  80146e:	85 c0                	test   %eax,%eax
  801470:	78 31                	js     8014a3 <sfork+0x126>
		panic("sfork: sys_env_set_pgfault_upcall error, %d", r);
	}
	r = sys_env_set_status(childid, ENV_RUNNABLE);
  801472:	83 ec 08             	sub    $0x8,%esp
  801475:	6a 02                	push   $0x2
  801477:	56                   	push   %esi
  801478:	e8 c9 fa ff ff       	call   800f46 <sys_env_set_status>
	if(r < 0){
  80147d:	83 c4 10             	add    $0x10,%esp
  801480:	85 c0                	test   %eax,%eax
  801482:	78 34                	js     8014b8 <sfork+0x13b>
		panic("sforK: sys_env_set_status, r%d", r);
	}
	return childid;
}
  801484:	89 f0                	mov    %esi,%eax
  801486:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801489:	5b                   	pop    %ebx
  80148a:	5e                   	pop    %esi
  80148b:	5f                   	pop    %edi
  80148c:	5d                   	pop    %ebp
  80148d:	c3                   	ret    
		panic("sfork: allocate user exception stack for child env error, %d", r);
  80148e:	50                   	push   %eax
  80148f:	68 64 2b 80 00       	push   $0x802b64
  801494:	68 cb 00 00 00       	push   $0xcb
  801499:	68 17 2a 80 00       	push   $0x802a17
  80149e:	e8 e9 ed ff ff       	call   80028c <_panic>
		panic("sfork: sys_env_set_pgfault_upcall error, %d", r);
  8014a3:	50                   	push   %eax
  8014a4:	68 a4 2b 80 00       	push   $0x802ba4
  8014a9:	68 cf 00 00 00       	push   $0xcf
  8014ae:	68 17 2a 80 00       	push   $0x802a17
  8014b3:	e8 d4 ed ff ff       	call   80028c <_panic>
		panic("sforK: sys_env_set_status, r%d", r);
  8014b8:	50                   	push   %eax
  8014b9:	68 d0 2b 80 00       	push   $0x802bd0
  8014be:	68 d3 00 00 00       	push   $0xd3
  8014c3:	68 17 2a 80 00       	push   $0x802a17
  8014c8:	e8 bf ed ff ff       	call   80028c <_panic>

008014cd <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8014cd:	55                   	push   %ebp
  8014ce:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d3:	05 00 00 00 30       	add    $0x30000000,%eax
  8014d8:	c1 e8 0c             	shr    $0xc,%eax
}
  8014db:	5d                   	pop    %ebp
  8014dc:	c3                   	ret    

008014dd <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8014dd:	55                   	push   %ebp
  8014de:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e3:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8014e8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014ed:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8014f2:	5d                   	pop    %ebp
  8014f3:	c3                   	ret    

008014f4 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8014f4:	55                   	push   %ebp
  8014f5:	89 e5                	mov    %esp,%ebp
  8014f7:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8014fc:	89 c2                	mov    %eax,%edx
  8014fe:	c1 ea 16             	shr    $0x16,%edx
  801501:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801508:	f6 c2 01             	test   $0x1,%dl
  80150b:	74 2d                	je     80153a <fd_alloc+0x46>
  80150d:	89 c2                	mov    %eax,%edx
  80150f:	c1 ea 0c             	shr    $0xc,%edx
  801512:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801519:	f6 c2 01             	test   $0x1,%dl
  80151c:	74 1c                	je     80153a <fd_alloc+0x46>
  80151e:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801523:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801528:	75 d2                	jne    8014fc <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80152a:	8b 45 08             	mov    0x8(%ebp),%eax
  80152d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801533:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801538:	eb 0a                	jmp    801544 <fd_alloc+0x50>
			*fd_store = fd;
  80153a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80153d:	89 01                	mov    %eax,(%ecx)
			return 0;
  80153f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801544:	5d                   	pop    %ebp
  801545:	c3                   	ret    

00801546 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801546:	55                   	push   %ebp
  801547:	89 e5                	mov    %esp,%ebp
  801549:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80154c:	83 f8 1f             	cmp    $0x1f,%eax
  80154f:	77 30                	ja     801581 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801551:	c1 e0 0c             	shl    $0xc,%eax
  801554:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801559:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80155f:	f6 c2 01             	test   $0x1,%dl
  801562:	74 24                	je     801588 <fd_lookup+0x42>
  801564:	89 c2                	mov    %eax,%edx
  801566:	c1 ea 0c             	shr    $0xc,%edx
  801569:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801570:	f6 c2 01             	test   $0x1,%dl
  801573:	74 1a                	je     80158f <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801575:	8b 55 0c             	mov    0xc(%ebp),%edx
  801578:	89 02                	mov    %eax,(%edx)
	return 0;
  80157a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80157f:	5d                   	pop    %ebp
  801580:	c3                   	ret    
		return -E_INVAL;
  801581:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801586:	eb f7                	jmp    80157f <fd_lookup+0x39>
		return -E_INVAL;
  801588:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80158d:	eb f0                	jmp    80157f <fd_lookup+0x39>
  80158f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801594:	eb e9                	jmp    80157f <fd_lookup+0x39>

00801596 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801596:	55                   	push   %ebp
  801597:	89 e5                	mov    %esp,%ebp
  801599:	83 ec 08             	sub    $0x8,%esp
  80159c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80159f:	ba 6c 2c 80 00       	mov    $0x802c6c,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8015a4:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8015a9:	39 08                	cmp    %ecx,(%eax)
  8015ab:	74 33                	je     8015e0 <dev_lookup+0x4a>
  8015ad:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8015b0:	8b 02                	mov    (%edx),%eax
  8015b2:	85 c0                	test   %eax,%eax
  8015b4:	75 f3                	jne    8015a9 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8015b6:	a1 04 40 80 00       	mov    0x804004,%eax
  8015bb:	8b 40 48             	mov    0x48(%eax),%eax
  8015be:	83 ec 04             	sub    $0x4,%esp
  8015c1:	51                   	push   %ecx
  8015c2:	50                   	push   %eax
  8015c3:	68 f0 2b 80 00       	push   $0x802bf0
  8015c8:	e8 9a ed ff ff       	call   800367 <cprintf>
	*dev = 0;
  8015cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8015d6:	83 c4 10             	add    $0x10,%esp
  8015d9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8015de:	c9                   	leave  
  8015df:	c3                   	ret    
			*dev = devtab[i];
  8015e0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015e3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8015e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8015ea:	eb f2                	jmp    8015de <dev_lookup+0x48>

008015ec <fd_close>:
{
  8015ec:	55                   	push   %ebp
  8015ed:	89 e5                	mov    %esp,%ebp
  8015ef:	57                   	push   %edi
  8015f0:	56                   	push   %esi
  8015f1:	53                   	push   %ebx
  8015f2:	83 ec 24             	sub    $0x24,%esp
  8015f5:	8b 75 08             	mov    0x8(%ebp),%esi
  8015f8:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8015fb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8015fe:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8015ff:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801605:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801608:	50                   	push   %eax
  801609:	e8 38 ff ff ff       	call   801546 <fd_lookup>
  80160e:	89 c3                	mov    %eax,%ebx
  801610:	83 c4 10             	add    $0x10,%esp
  801613:	85 c0                	test   %eax,%eax
  801615:	78 05                	js     80161c <fd_close+0x30>
	    || fd != fd2)
  801617:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80161a:	74 16                	je     801632 <fd_close+0x46>
		return (must_exist ? r : 0);
  80161c:	89 f8                	mov    %edi,%eax
  80161e:	84 c0                	test   %al,%al
  801620:	b8 00 00 00 00       	mov    $0x0,%eax
  801625:	0f 44 d8             	cmove  %eax,%ebx
}
  801628:	89 d8                	mov    %ebx,%eax
  80162a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80162d:	5b                   	pop    %ebx
  80162e:	5e                   	pop    %esi
  80162f:	5f                   	pop    %edi
  801630:	5d                   	pop    %ebp
  801631:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801632:	83 ec 08             	sub    $0x8,%esp
  801635:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801638:	50                   	push   %eax
  801639:	ff 36                	pushl  (%esi)
  80163b:	e8 56 ff ff ff       	call   801596 <dev_lookup>
  801640:	89 c3                	mov    %eax,%ebx
  801642:	83 c4 10             	add    $0x10,%esp
  801645:	85 c0                	test   %eax,%eax
  801647:	78 1a                	js     801663 <fd_close+0x77>
		if (dev->dev_close)
  801649:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80164c:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80164f:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801654:	85 c0                	test   %eax,%eax
  801656:	74 0b                	je     801663 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801658:	83 ec 0c             	sub    $0xc,%esp
  80165b:	56                   	push   %esi
  80165c:	ff d0                	call   *%eax
  80165e:	89 c3                	mov    %eax,%ebx
  801660:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801663:	83 ec 08             	sub    $0x8,%esp
  801666:	56                   	push   %esi
  801667:	6a 00                	push   $0x0
  801669:	e8 96 f8 ff ff       	call   800f04 <sys_page_unmap>
	return r;
  80166e:	83 c4 10             	add    $0x10,%esp
  801671:	eb b5                	jmp    801628 <fd_close+0x3c>

00801673 <close>:

int
close(int fdnum)
{
  801673:	55                   	push   %ebp
  801674:	89 e5                	mov    %esp,%ebp
  801676:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801679:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80167c:	50                   	push   %eax
  80167d:	ff 75 08             	pushl  0x8(%ebp)
  801680:	e8 c1 fe ff ff       	call   801546 <fd_lookup>
  801685:	83 c4 10             	add    $0x10,%esp
  801688:	85 c0                	test   %eax,%eax
  80168a:	79 02                	jns    80168e <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80168c:	c9                   	leave  
  80168d:	c3                   	ret    
		return fd_close(fd, 1);
  80168e:	83 ec 08             	sub    $0x8,%esp
  801691:	6a 01                	push   $0x1
  801693:	ff 75 f4             	pushl  -0xc(%ebp)
  801696:	e8 51 ff ff ff       	call   8015ec <fd_close>
  80169b:	83 c4 10             	add    $0x10,%esp
  80169e:	eb ec                	jmp    80168c <close+0x19>

008016a0 <close_all>:

void
close_all(void)
{
  8016a0:	55                   	push   %ebp
  8016a1:	89 e5                	mov    %esp,%ebp
  8016a3:	53                   	push   %ebx
  8016a4:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8016a7:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8016ac:	83 ec 0c             	sub    $0xc,%esp
  8016af:	53                   	push   %ebx
  8016b0:	e8 be ff ff ff       	call   801673 <close>
	for (i = 0; i < MAXFD; i++)
  8016b5:	83 c3 01             	add    $0x1,%ebx
  8016b8:	83 c4 10             	add    $0x10,%esp
  8016bb:	83 fb 20             	cmp    $0x20,%ebx
  8016be:	75 ec                	jne    8016ac <close_all+0xc>
}
  8016c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016c3:	c9                   	leave  
  8016c4:	c3                   	ret    

008016c5 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8016c5:	55                   	push   %ebp
  8016c6:	89 e5                	mov    %esp,%ebp
  8016c8:	57                   	push   %edi
  8016c9:	56                   	push   %esi
  8016ca:	53                   	push   %ebx
  8016cb:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8016ce:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8016d1:	50                   	push   %eax
  8016d2:	ff 75 08             	pushl  0x8(%ebp)
  8016d5:	e8 6c fe ff ff       	call   801546 <fd_lookup>
  8016da:	89 c3                	mov    %eax,%ebx
  8016dc:	83 c4 10             	add    $0x10,%esp
  8016df:	85 c0                	test   %eax,%eax
  8016e1:	0f 88 81 00 00 00    	js     801768 <dup+0xa3>
		return r;
	close(newfdnum);
  8016e7:	83 ec 0c             	sub    $0xc,%esp
  8016ea:	ff 75 0c             	pushl  0xc(%ebp)
  8016ed:	e8 81 ff ff ff       	call   801673 <close>

	newfd = INDEX2FD(newfdnum);
  8016f2:	8b 75 0c             	mov    0xc(%ebp),%esi
  8016f5:	c1 e6 0c             	shl    $0xc,%esi
  8016f8:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8016fe:	83 c4 04             	add    $0x4,%esp
  801701:	ff 75 e4             	pushl  -0x1c(%ebp)
  801704:	e8 d4 fd ff ff       	call   8014dd <fd2data>
  801709:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80170b:	89 34 24             	mov    %esi,(%esp)
  80170e:	e8 ca fd ff ff       	call   8014dd <fd2data>
  801713:	83 c4 10             	add    $0x10,%esp
  801716:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801718:	89 d8                	mov    %ebx,%eax
  80171a:	c1 e8 16             	shr    $0x16,%eax
  80171d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801724:	a8 01                	test   $0x1,%al
  801726:	74 11                	je     801739 <dup+0x74>
  801728:	89 d8                	mov    %ebx,%eax
  80172a:	c1 e8 0c             	shr    $0xc,%eax
  80172d:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801734:	f6 c2 01             	test   $0x1,%dl
  801737:	75 39                	jne    801772 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801739:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80173c:	89 d0                	mov    %edx,%eax
  80173e:	c1 e8 0c             	shr    $0xc,%eax
  801741:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801748:	83 ec 0c             	sub    $0xc,%esp
  80174b:	25 07 0e 00 00       	and    $0xe07,%eax
  801750:	50                   	push   %eax
  801751:	56                   	push   %esi
  801752:	6a 00                	push   $0x0
  801754:	52                   	push   %edx
  801755:	6a 00                	push   $0x0
  801757:	e8 66 f7 ff ff       	call   800ec2 <sys_page_map>
  80175c:	89 c3                	mov    %eax,%ebx
  80175e:	83 c4 20             	add    $0x20,%esp
  801761:	85 c0                	test   %eax,%eax
  801763:	78 31                	js     801796 <dup+0xd1>
		goto err;

	return newfdnum;
  801765:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801768:	89 d8                	mov    %ebx,%eax
  80176a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80176d:	5b                   	pop    %ebx
  80176e:	5e                   	pop    %esi
  80176f:	5f                   	pop    %edi
  801770:	5d                   	pop    %ebp
  801771:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801772:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801779:	83 ec 0c             	sub    $0xc,%esp
  80177c:	25 07 0e 00 00       	and    $0xe07,%eax
  801781:	50                   	push   %eax
  801782:	57                   	push   %edi
  801783:	6a 00                	push   $0x0
  801785:	53                   	push   %ebx
  801786:	6a 00                	push   $0x0
  801788:	e8 35 f7 ff ff       	call   800ec2 <sys_page_map>
  80178d:	89 c3                	mov    %eax,%ebx
  80178f:	83 c4 20             	add    $0x20,%esp
  801792:	85 c0                	test   %eax,%eax
  801794:	79 a3                	jns    801739 <dup+0x74>
	sys_page_unmap(0, newfd);
  801796:	83 ec 08             	sub    $0x8,%esp
  801799:	56                   	push   %esi
  80179a:	6a 00                	push   $0x0
  80179c:	e8 63 f7 ff ff       	call   800f04 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8017a1:	83 c4 08             	add    $0x8,%esp
  8017a4:	57                   	push   %edi
  8017a5:	6a 00                	push   $0x0
  8017a7:	e8 58 f7 ff ff       	call   800f04 <sys_page_unmap>
	return r;
  8017ac:	83 c4 10             	add    $0x10,%esp
  8017af:	eb b7                	jmp    801768 <dup+0xa3>

008017b1 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8017b1:	55                   	push   %ebp
  8017b2:	89 e5                	mov    %esp,%ebp
  8017b4:	53                   	push   %ebx
  8017b5:	83 ec 1c             	sub    $0x1c,%esp
  8017b8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017bb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017be:	50                   	push   %eax
  8017bf:	53                   	push   %ebx
  8017c0:	e8 81 fd ff ff       	call   801546 <fd_lookup>
  8017c5:	83 c4 10             	add    $0x10,%esp
  8017c8:	85 c0                	test   %eax,%eax
  8017ca:	78 3f                	js     80180b <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017cc:	83 ec 08             	sub    $0x8,%esp
  8017cf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017d2:	50                   	push   %eax
  8017d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017d6:	ff 30                	pushl  (%eax)
  8017d8:	e8 b9 fd ff ff       	call   801596 <dev_lookup>
  8017dd:	83 c4 10             	add    $0x10,%esp
  8017e0:	85 c0                	test   %eax,%eax
  8017e2:	78 27                	js     80180b <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8017e4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017e7:	8b 42 08             	mov    0x8(%edx),%eax
  8017ea:	83 e0 03             	and    $0x3,%eax
  8017ed:	83 f8 01             	cmp    $0x1,%eax
  8017f0:	74 1e                	je     801810 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8017f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017f5:	8b 40 08             	mov    0x8(%eax),%eax
  8017f8:	85 c0                	test   %eax,%eax
  8017fa:	74 35                	je     801831 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8017fc:	83 ec 04             	sub    $0x4,%esp
  8017ff:	ff 75 10             	pushl  0x10(%ebp)
  801802:	ff 75 0c             	pushl  0xc(%ebp)
  801805:	52                   	push   %edx
  801806:	ff d0                	call   *%eax
  801808:	83 c4 10             	add    $0x10,%esp
}
  80180b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80180e:	c9                   	leave  
  80180f:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801810:	a1 04 40 80 00       	mov    0x804004,%eax
  801815:	8b 40 48             	mov    0x48(%eax),%eax
  801818:	83 ec 04             	sub    $0x4,%esp
  80181b:	53                   	push   %ebx
  80181c:	50                   	push   %eax
  80181d:	68 31 2c 80 00       	push   $0x802c31
  801822:	e8 40 eb ff ff       	call   800367 <cprintf>
		return -E_INVAL;
  801827:	83 c4 10             	add    $0x10,%esp
  80182a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80182f:	eb da                	jmp    80180b <read+0x5a>
		return -E_NOT_SUPP;
  801831:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801836:	eb d3                	jmp    80180b <read+0x5a>

00801838 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801838:	55                   	push   %ebp
  801839:	89 e5                	mov    %esp,%ebp
  80183b:	57                   	push   %edi
  80183c:	56                   	push   %esi
  80183d:	53                   	push   %ebx
  80183e:	83 ec 0c             	sub    $0xc,%esp
  801841:	8b 7d 08             	mov    0x8(%ebp),%edi
  801844:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801847:	bb 00 00 00 00       	mov    $0x0,%ebx
  80184c:	39 f3                	cmp    %esi,%ebx
  80184e:	73 23                	jae    801873 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801850:	83 ec 04             	sub    $0x4,%esp
  801853:	89 f0                	mov    %esi,%eax
  801855:	29 d8                	sub    %ebx,%eax
  801857:	50                   	push   %eax
  801858:	89 d8                	mov    %ebx,%eax
  80185a:	03 45 0c             	add    0xc(%ebp),%eax
  80185d:	50                   	push   %eax
  80185e:	57                   	push   %edi
  80185f:	e8 4d ff ff ff       	call   8017b1 <read>
		if (m < 0)
  801864:	83 c4 10             	add    $0x10,%esp
  801867:	85 c0                	test   %eax,%eax
  801869:	78 06                	js     801871 <readn+0x39>
			return m;
		if (m == 0)
  80186b:	74 06                	je     801873 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  80186d:	01 c3                	add    %eax,%ebx
  80186f:	eb db                	jmp    80184c <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801871:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801873:	89 d8                	mov    %ebx,%eax
  801875:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801878:	5b                   	pop    %ebx
  801879:	5e                   	pop    %esi
  80187a:	5f                   	pop    %edi
  80187b:	5d                   	pop    %ebp
  80187c:	c3                   	ret    

0080187d <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80187d:	55                   	push   %ebp
  80187e:	89 e5                	mov    %esp,%ebp
  801880:	53                   	push   %ebx
  801881:	83 ec 1c             	sub    $0x1c,%esp
  801884:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801887:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80188a:	50                   	push   %eax
  80188b:	53                   	push   %ebx
  80188c:	e8 b5 fc ff ff       	call   801546 <fd_lookup>
  801891:	83 c4 10             	add    $0x10,%esp
  801894:	85 c0                	test   %eax,%eax
  801896:	78 3a                	js     8018d2 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801898:	83 ec 08             	sub    $0x8,%esp
  80189b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80189e:	50                   	push   %eax
  80189f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018a2:	ff 30                	pushl  (%eax)
  8018a4:	e8 ed fc ff ff       	call   801596 <dev_lookup>
  8018a9:	83 c4 10             	add    $0x10,%esp
  8018ac:	85 c0                	test   %eax,%eax
  8018ae:	78 22                	js     8018d2 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8018b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018b3:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8018b7:	74 1e                	je     8018d7 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8018b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018bc:	8b 52 0c             	mov    0xc(%edx),%edx
  8018bf:	85 d2                	test   %edx,%edx
  8018c1:	74 35                	je     8018f8 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8018c3:	83 ec 04             	sub    $0x4,%esp
  8018c6:	ff 75 10             	pushl  0x10(%ebp)
  8018c9:	ff 75 0c             	pushl  0xc(%ebp)
  8018cc:	50                   	push   %eax
  8018cd:	ff d2                	call   *%edx
  8018cf:	83 c4 10             	add    $0x10,%esp
}
  8018d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018d5:	c9                   	leave  
  8018d6:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8018d7:	a1 04 40 80 00       	mov    0x804004,%eax
  8018dc:	8b 40 48             	mov    0x48(%eax),%eax
  8018df:	83 ec 04             	sub    $0x4,%esp
  8018e2:	53                   	push   %ebx
  8018e3:	50                   	push   %eax
  8018e4:	68 4d 2c 80 00       	push   $0x802c4d
  8018e9:	e8 79 ea ff ff       	call   800367 <cprintf>
		return -E_INVAL;
  8018ee:	83 c4 10             	add    $0x10,%esp
  8018f1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018f6:	eb da                	jmp    8018d2 <write+0x55>
		return -E_NOT_SUPP;
  8018f8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018fd:	eb d3                	jmp    8018d2 <write+0x55>

008018ff <seek>:

int
seek(int fdnum, off_t offset)
{
  8018ff:	55                   	push   %ebp
  801900:	89 e5                	mov    %esp,%ebp
  801902:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801905:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801908:	50                   	push   %eax
  801909:	ff 75 08             	pushl  0x8(%ebp)
  80190c:	e8 35 fc ff ff       	call   801546 <fd_lookup>
  801911:	83 c4 10             	add    $0x10,%esp
  801914:	85 c0                	test   %eax,%eax
  801916:	78 0e                	js     801926 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801918:	8b 55 0c             	mov    0xc(%ebp),%edx
  80191b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80191e:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801921:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801926:	c9                   	leave  
  801927:	c3                   	ret    

00801928 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801928:	55                   	push   %ebp
  801929:	89 e5                	mov    %esp,%ebp
  80192b:	53                   	push   %ebx
  80192c:	83 ec 1c             	sub    $0x1c,%esp
  80192f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801932:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801935:	50                   	push   %eax
  801936:	53                   	push   %ebx
  801937:	e8 0a fc ff ff       	call   801546 <fd_lookup>
  80193c:	83 c4 10             	add    $0x10,%esp
  80193f:	85 c0                	test   %eax,%eax
  801941:	78 37                	js     80197a <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801943:	83 ec 08             	sub    $0x8,%esp
  801946:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801949:	50                   	push   %eax
  80194a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80194d:	ff 30                	pushl  (%eax)
  80194f:	e8 42 fc ff ff       	call   801596 <dev_lookup>
  801954:	83 c4 10             	add    $0x10,%esp
  801957:	85 c0                	test   %eax,%eax
  801959:	78 1f                	js     80197a <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80195b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80195e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801962:	74 1b                	je     80197f <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801964:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801967:	8b 52 18             	mov    0x18(%edx),%edx
  80196a:	85 d2                	test   %edx,%edx
  80196c:	74 32                	je     8019a0 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80196e:	83 ec 08             	sub    $0x8,%esp
  801971:	ff 75 0c             	pushl  0xc(%ebp)
  801974:	50                   	push   %eax
  801975:	ff d2                	call   *%edx
  801977:	83 c4 10             	add    $0x10,%esp
}
  80197a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80197d:	c9                   	leave  
  80197e:	c3                   	ret    
			thisenv->env_id, fdnum);
  80197f:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801984:	8b 40 48             	mov    0x48(%eax),%eax
  801987:	83 ec 04             	sub    $0x4,%esp
  80198a:	53                   	push   %ebx
  80198b:	50                   	push   %eax
  80198c:	68 10 2c 80 00       	push   $0x802c10
  801991:	e8 d1 e9 ff ff       	call   800367 <cprintf>
		return -E_INVAL;
  801996:	83 c4 10             	add    $0x10,%esp
  801999:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80199e:	eb da                	jmp    80197a <ftruncate+0x52>
		return -E_NOT_SUPP;
  8019a0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019a5:	eb d3                	jmp    80197a <ftruncate+0x52>

008019a7 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8019a7:	55                   	push   %ebp
  8019a8:	89 e5                	mov    %esp,%ebp
  8019aa:	53                   	push   %ebx
  8019ab:	83 ec 1c             	sub    $0x1c,%esp
  8019ae:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019b1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019b4:	50                   	push   %eax
  8019b5:	ff 75 08             	pushl  0x8(%ebp)
  8019b8:	e8 89 fb ff ff       	call   801546 <fd_lookup>
  8019bd:	83 c4 10             	add    $0x10,%esp
  8019c0:	85 c0                	test   %eax,%eax
  8019c2:	78 4b                	js     801a0f <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019c4:	83 ec 08             	sub    $0x8,%esp
  8019c7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019ca:	50                   	push   %eax
  8019cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019ce:	ff 30                	pushl  (%eax)
  8019d0:	e8 c1 fb ff ff       	call   801596 <dev_lookup>
  8019d5:	83 c4 10             	add    $0x10,%esp
  8019d8:	85 c0                	test   %eax,%eax
  8019da:	78 33                	js     801a0f <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8019dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019df:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8019e3:	74 2f                	je     801a14 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8019e5:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8019e8:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8019ef:	00 00 00 
	stat->st_isdir = 0;
  8019f2:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8019f9:	00 00 00 
	stat->st_dev = dev;
  8019fc:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801a02:	83 ec 08             	sub    $0x8,%esp
  801a05:	53                   	push   %ebx
  801a06:	ff 75 f0             	pushl  -0x10(%ebp)
  801a09:	ff 50 14             	call   *0x14(%eax)
  801a0c:	83 c4 10             	add    $0x10,%esp
}
  801a0f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a12:	c9                   	leave  
  801a13:	c3                   	ret    
		return -E_NOT_SUPP;
  801a14:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a19:	eb f4                	jmp    801a0f <fstat+0x68>

00801a1b <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801a1b:	55                   	push   %ebp
  801a1c:	89 e5                	mov    %esp,%ebp
  801a1e:	56                   	push   %esi
  801a1f:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801a20:	83 ec 08             	sub    $0x8,%esp
  801a23:	6a 00                	push   $0x0
  801a25:	ff 75 08             	pushl  0x8(%ebp)
  801a28:	e8 bb 01 00 00       	call   801be8 <open>
  801a2d:	89 c3                	mov    %eax,%ebx
  801a2f:	83 c4 10             	add    $0x10,%esp
  801a32:	85 c0                	test   %eax,%eax
  801a34:	78 1b                	js     801a51 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801a36:	83 ec 08             	sub    $0x8,%esp
  801a39:	ff 75 0c             	pushl  0xc(%ebp)
  801a3c:	50                   	push   %eax
  801a3d:	e8 65 ff ff ff       	call   8019a7 <fstat>
  801a42:	89 c6                	mov    %eax,%esi
	close(fd);
  801a44:	89 1c 24             	mov    %ebx,(%esp)
  801a47:	e8 27 fc ff ff       	call   801673 <close>
	return r;
  801a4c:	83 c4 10             	add    $0x10,%esp
  801a4f:	89 f3                	mov    %esi,%ebx
}
  801a51:	89 d8                	mov    %ebx,%eax
  801a53:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a56:	5b                   	pop    %ebx
  801a57:	5e                   	pop    %esi
  801a58:	5d                   	pop    %ebp
  801a59:	c3                   	ret    

00801a5a <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801a5a:	55                   	push   %ebp
  801a5b:	89 e5                	mov    %esp,%ebp
  801a5d:	56                   	push   %esi
  801a5e:	53                   	push   %ebx
  801a5f:	89 c6                	mov    %eax,%esi
  801a61:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801a63:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801a6a:	74 27                	je     801a93 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801a6c:	6a 07                	push   $0x7
  801a6e:	68 00 50 80 00       	push   $0x805000
  801a73:	56                   	push   %esi
  801a74:	ff 35 00 40 80 00    	pushl  0x804000
  801a7a:	e8 cb 07 00 00       	call   80224a <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801a7f:	83 c4 0c             	add    $0xc,%esp
  801a82:	6a 00                	push   $0x0
  801a84:	53                   	push   %ebx
  801a85:	6a 00                	push   $0x0
  801a87:	e8 55 07 00 00       	call   8021e1 <ipc_recv>
}
  801a8c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a8f:	5b                   	pop    %ebx
  801a90:	5e                   	pop    %esi
  801a91:	5d                   	pop    %ebp
  801a92:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801a93:	83 ec 0c             	sub    $0xc,%esp
  801a96:	6a 01                	push   $0x1
  801a98:	e8 fa 07 00 00       	call   802297 <ipc_find_env>
  801a9d:	a3 00 40 80 00       	mov    %eax,0x804000
  801aa2:	83 c4 10             	add    $0x10,%esp
  801aa5:	eb c5                	jmp    801a6c <fsipc+0x12>

00801aa7 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801aa7:	55                   	push   %ebp
  801aa8:	89 e5                	mov    %esp,%ebp
  801aaa:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801aad:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab0:	8b 40 0c             	mov    0xc(%eax),%eax
  801ab3:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801ab8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801abb:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801ac0:	ba 00 00 00 00       	mov    $0x0,%edx
  801ac5:	b8 02 00 00 00       	mov    $0x2,%eax
  801aca:	e8 8b ff ff ff       	call   801a5a <fsipc>
}
  801acf:	c9                   	leave  
  801ad0:	c3                   	ret    

00801ad1 <devfile_flush>:
{
  801ad1:	55                   	push   %ebp
  801ad2:	89 e5                	mov    %esp,%ebp
  801ad4:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  801ada:	8b 40 0c             	mov    0xc(%eax),%eax
  801add:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801ae2:	ba 00 00 00 00       	mov    $0x0,%edx
  801ae7:	b8 06 00 00 00       	mov    $0x6,%eax
  801aec:	e8 69 ff ff ff       	call   801a5a <fsipc>
}
  801af1:	c9                   	leave  
  801af2:	c3                   	ret    

00801af3 <devfile_stat>:
{
  801af3:	55                   	push   %ebp
  801af4:	89 e5                	mov    %esp,%ebp
  801af6:	53                   	push   %ebx
  801af7:	83 ec 04             	sub    $0x4,%esp
  801afa:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801afd:	8b 45 08             	mov    0x8(%ebp),%eax
  801b00:	8b 40 0c             	mov    0xc(%eax),%eax
  801b03:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801b08:	ba 00 00 00 00       	mov    $0x0,%edx
  801b0d:	b8 05 00 00 00       	mov    $0x5,%eax
  801b12:	e8 43 ff ff ff       	call   801a5a <fsipc>
  801b17:	85 c0                	test   %eax,%eax
  801b19:	78 2c                	js     801b47 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801b1b:	83 ec 08             	sub    $0x8,%esp
  801b1e:	68 00 50 80 00       	push   $0x805000
  801b23:	53                   	push   %ebx
  801b24:	e8 64 ef ff ff       	call   800a8d <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801b29:	a1 80 50 80 00       	mov    0x805080,%eax
  801b2e:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801b34:	a1 84 50 80 00       	mov    0x805084,%eax
  801b39:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801b3f:	83 c4 10             	add    $0x10,%esp
  801b42:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b47:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b4a:	c9                   	leave  
  801b4b:	c3                   	ret    

00801b4c <devfile_write>:
{
  801b4c:	55                   	push   %ebp
  801b4d:	89 e5                	mov    %esp,%ebp
  801b4f:	83 ec 0c             	sub    $0xc,%esp
	panic("devfile_write not implemented");
  801b52:	68 7c 2c 80 00       	push   $0x802c7c
  801b57:	68 90 00 00 00       	push   $0x90
  801b5c:	68 9a 2c 80 00       	push   $0x802c9a
  801b61:	e8 26 e7 ff ff       	call   80028c <_panic>

00801b66 <devfile_read>:
{
  801b66:	55                   	push   %ebp
  801b67:	89 e5                	mov    %esp,%ebp
  801b69:	56                   	push   %esi
  801b6a:	53                   	push   %ebx
  801b6b:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b71:	8b 40 0c             	mov    0xc(%eax),%eax
  801b74:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801b79:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801b7f:	ba 00 00 00 00       	mov    $0x0,%edx
  801b84:	b8 03 00 00 00       	mov    $0x3,%eax
  801b89:	e8 cc fe ff ff       	call   801a5a <fsipc>
  801b8e:	89 c3                	mov    %eax,%ebx
  801b90:	85 c0                	test   %eax,%eax
  801b92:	78 1f                	js     801bb3 <devfile_read+0x4d>
	assert(r <= n);
  801b94:	39 f0                	cmp    %esi,%eax
  801b96:	77 24                	ja     801bbc <devfile_read+0x56>
	assert(r <= PGSIZE);
  801b98:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b9d:	7f 33                	jg     801bd2 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801b9f:	83 ec 04             	sub    $0x4,%esp
  801ba2:	50                   	push   %eax
  801ba3:	68 00 50 80 00       	push   $0x805000
  801ba8:	ff 75 0c             	pushl  0xc(%ebp)
  801bab:	e8 6b f0 ff ff       	call   800c1b <memmove>
	return r;
  801bb0:	83 c4 10             	add    $0x10,%esp
}
  801bb3:	89 d8                	mov    %ebx,%eax
  801bb5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bb8:	5b                   	pop    %ebx
  801bb9:	5e                   	pop    %esi
  801bba:	5d                   	pop    %ebp
  801bbb:	c3                   	ret    
	assert(r <= n);
  801bbc:	68 a5 2c 80 00       	push   $0x802ca5
  801bc1:	68 ac 2c 80 00       	push   $0x802cac
  801bc6:	6a 7c                	push   $0x7c
  801bc8:	68 9a 2c 80 00       	push   $0x802c9a
  801bcd:	e8 ba e6 ff ff       	call   80028c <_panic>
	assert(r <= PGSIZE);
  801bd2:	68 c1 2c 80 00       	push   $0x802cc1
  801bd7:	68 ac 2c 80 00       	push   $0x802cac
  801bdc:	6a 7d                	push   $0x7d
  801bde:	68 9a 2c 80 00       	push   $0x802c9a
  801be3:	e8 a4 e6 ff ff       	call   80028c <_panic>

00801be8 <open>:
{
  801be8:	55                   	push   %ebp
  801be9:	89 e5                	mov    %esp,%ebp
  801beb:	56                   	push   %esi
  801bec:	53                   	push   %ebx
  801bed:	83 ec 1c             	sub    $0x1c,%esp
  801bf0:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801bf3:	56                   	push   %esi
  801bf4:	e8 5b ee ff ff       	call   800a54 <strlen>
  801bf9:	83 c4 10             	add    $0x10,%esp
  801bfc:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801c01:	7f 6c                	jg     801c6f <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801c03:	83 ec 0c             	sub    $0xc,%esp
  801c06:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c09:	50                   	push   %eax
  801c0a:	e8 e5 f8 ff ff       	call   8014f4 <fd_alloc>
  801c0f:	89 c3                	mov    %eax,%ebx
  801c11:	83 c4 10             	add    $0x10,%esp
  801c14:	85 c0                	test   %eax,%eax
  801c16:	78 3c                	js     801c54 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801c18:	83 ec 08             	sub    $0x8,%esp
  801c1b:	56                   	push   %esi
  801c1c:	68 00 50 80 00       	push   $0x805000
  801c21:	e8 67 ee ff ff       	call   800a8d <strcpy>
	fsipcbuf.open.req_omode = mode;
  801c26:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c29:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801c2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c31:	b8 01 00 00 00       	mov    $0x1,%eax
  801c36:	e8 1f fe ff ff       	call   801a5a <fsipc>
  801c3b:	89 c3                	mov    %eax,%ebx
  801c3d:	83 c4 10             	add    $0x10,%esp
  801c40:	85 c0                	test   %eax,%eax
  801c42:	78 19                	js     801c5d <open+0x75>
	return fd2num(fd);
  801c44:	83 ec 0c             	sub    $0xc,%esp
  801c47:	ff 75 f4             	pushl  -0xc(%ebp)
  801c4a:	e8 7e f8 ff ff       	call   8014cd <fd2num>
  801c4f:	89 c3                	mov    %eax,%ebx
  801c51:	83 c4 10             	add    $0x10,%esp
}
  801c54:	89 d8                	mov    %ebx,%eax
  801c56:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c59:	5b                   	pop    %ebx
  801c5a:	5e                   	pop    %esi
  801c5b:	5d                   	pop    %ebp
  801c5c:	c3                   	ret    
		fd_close(fd, 0);
  801c5d:	83 ec 08             	sub    $0x8,%esp
  801c60:	6a 00                	push   $0x0
  801c62:	ff 75 f4             	pushl  -0xc(%ebp)
  801c65:	e8 82 f9 ff ff       	call   8015ec <fd_close>
		return r;
  801c6a:	83 c4 10             	add    $0x10,%esp
  801c6d:	eb e5                	jmp    801c54 <open+0x6c>
		return -E_BAD_PATH;
  801c6f:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801c74:	eb de                	jmp    801c54 <open+0x6c>

00801c76 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801c76:	55                   	push   %ebp
  801c77:	89 e5                	mov    %esp,%ebp
  801c79:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801c7c:	ba 00 00 00 00       	mov    $0x0,%edx
  801c81:	b8 08 00 00 00       	mov    $0x8,%eax
  801c86:	e8 cf fd ff ff       	call   801a5a <fsipc>
}
  801c8b:	c9                   	leave  
  801c8c:	c3                   	ret    

00801c8d <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801c8d:	55                   	push   %ebp
  801c8e:	89 e5                	mov    %esp,%ebp
  801c90:	56                   	push   %esi
  801c91:	53                   	push   %ebx
  801c92:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801c95:	83 ec 0c             	sub    $0xc,%esp
  801c98:	ff 75 08             	pushl  0x8(%ebp)
  801c9b:	e8 3d f8 ff ff       	call   8014dd <fd2data>
  801ca0:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801ca2:	83 c4 08             	add    $0x8,%esp
  801ca5:	68 cd 2c 80 00       	push   $0x802ccd
  801caa:	53                   	push   %ebx
  801cab:	e8 dd ed ff ff       	call   800a8d <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801cb0:	8b 46 04             	mov    0x4(%esi),%eax
  801cb3:	2b 06                	sub    (%esi),%eax
  801cb5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801cbb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801cc2:	00 00 00 
	stat->st_dev = &devpipe;
  801cc5:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801ccc:	30 80 00 
	return 0;
}
  801ccf:	b8 00 00 00 00       	mov    $0x0,%eax
  801cd4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cd7:	5b                   	pop    %ebx
  801cd8:	5e                   	pop    %esi
  801cd9:	5d                   	pop    %ebp
  801cda:	c3                   	ret    

00801cdb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801cdb:	55                   	push   %ebp
  801cdc:	89 e5                	mov    %esp,%ebp
  801cde:	53                   	push   %ebx
  801cdf:	83 ec 0c             	sub    $0xc,%esp
  801ce2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801ce5:	53                   	push   %ebx
  801ce6:	6a 00                	push   $0x0
  801ce8:	e8 17 f2 ff ff       	call   800f04 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801ced:	89 1c 24             	mov    %ebx,(%esp)
  801cf0:	e8 e8 f7 ff ff       	call   8014dd <fd2data>
  801cf5:	83 c4 08             	add    $0x8,%esp
  801cf8:	50                   	push   %eax
  801cf9:	6a 00                	push   $0x0
  801cfb:	e8 04 f2 ff ff       	call   800f04 <sys_page_unmap>
}
  801d00:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d03:	c9                   	leave  
  801d04:	c3                   	ret    

00801d05 <_pipeisclosed>:
{
  801d05:	55                   	push   %ebp
  801d06:	89 e5                	mov    %esp,%ebp
  801d08:	57                   	push   %edi
  801d09:	56                   	push   %esi
  801d0a:	53                   	push   %ebx
  801d0b:	83 ec 1c             	sub    $0x1c,%esp
  801d0e:	89 c7                	mov    %eax,%edi
  801d10:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801d12:	a1 04 40 80 00       	mov    0x804004,%eax
  801d17:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d1a:	83 ec 0c             	sub    $0xc,%esp
  801d1d:	57                   	push   %edi
  801d1e:	e8 b3 05 00 00       	call   8022d6 <pageref>
  801d23:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d26:	89 34 24             	mov    %esi,(%esp)
  801d29:	e8 a8 05 00 00       	call   8022d6 <pageref>
		nn = thisenv->env_runs;
  801d2e:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801d34:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801d37:	83 c4 10             	add    $0x10,%esp
  801d3a:	39 cb                	cmp    %ecx,%ebx
  801d3c:	74 1b                	je     801d59 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801d3e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d41:	75 cf                	jne    801d12 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d43:	8b 42 58             	mov    0x58(%edx),%eax
  801d46:	6a 01                	push   $0x1
  801d48:	50                   	push   %eax
  801d49:	53                   	push   %ebx
  801d4a:	68 d4 2c 80 00       	push   $0x802cd4
  801d4f:	e8 13 e6 ff ff       	call   800367 <cprintf>
  801d54:	83 c4 10             	add    $0x10,%esp
  801d57:	eb b9                	jmp    801d12 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d59:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d5c:	0f 94 c0             	sete   %al
  801d5f:	0f b6 c0             	movzbl %al,%eax
}
  801d62:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d65:	5b                   	pop    %ebx
  801d66:	5e                   	pop    %esi
  801d67:	5f                   	pop    %edi
  801d68:	5d                   	pop    %ebp
  801d69:	c3                   	ret    

00801d6a <devpipe_write>:
{
  801d6a:	55                   	push   %ebp
  801d6b:	89 e5                	mov    %esp,%ebp
  801d6d:	57                   	push   %edi
  801d6e:	56                   	push   %esi
  801d6f:	53                   	push   %ebx
  801d70:	83 ec 28             	sub    $0x28,%esp
  801d73:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801d76:	56                   	push   %esi
  801d77:	e8 61 f7 ff ff       	call   8014dd <fd2data>
  801d7c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d7e:	83 c4 10             	add    $0x10,%esp
  801d81:	bf 00 00 00 00       	mov    $0x0,%edi
  801d86:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801d89:	74 4f                	je     801dda <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801d8b:	8b 43 04             	mov    0x4(%ebx),%eax
  801d8e:	8b 0b                	mov    (%ebx),%ecx
  801d90:	8d 51 20             	lea    0x20(%ecx),%edx
  801d93:	39 d0                	cmp    %edx,%eax
  801d95:	72 14                	jb     801dab <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801d97:	89 da                	mov    %ebx,%edx
  801d99:	89 f0                	mov    %esi,%eax
  801d9b:	e8 65 ff ff ff       	call   801d05 <_pipeisclosed>
  801da0:	85 c0                	test   %eax,%eax
  801da2:	75 3b                	jne    801ddf <devpipe_write+0x75>
			sys_yield();
  801da4:	e8 b7 f0 ff ff       	call   800e60 <sys_yield>
  801da9:	eb e0                	jmp    801d8b <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801dab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801dae:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801db2:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801db5:	89 c2                	mov    %eax,%edx
  801db7:	c1 fa 1f             	sar    $0x1f,%edx
  801dba:	89 d1                	mov    %edx,%ecx
  801dbc:	c1 e9 1b             	shr    $0x1b,%ecx
  801dbf:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801dc2:	83 e2 1f             	and    $0x1f,%edx
  801dc5:	29 ca                	sub    %ecx,%edx
  801dc7:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801dcb:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801dcf:	83 c0 01             	add    $0x1,%eax
  801dd2:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801dd5:	83 c7 01             	add    $0x1,%edi
  801dd8:	eb ac                	jmp    801d86 <devpipe_write+0x1c>
	return i;
  801dda:	8b 45 10             	mov    0x10(%ebp),%eax
  801ddd:	eb 05                	jmp    801de4 <devpipe_write+0x7a>
				return 0;
  801ddf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801de4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801de7:	5b                   	pop    %ebx
  801de8:	5e                   	pop    %esi
  801de9:	5f                   	pop    %edi
  801dea:	5d                   	pop    %ebp
  801deb:	c3                   	ret    

00801dec <devpipe_read>:
{
  801dec:	55                   	push   %ebp
  801ded:	89 e5                	mov    %esp,%ebp
  801def:	57                   	push   %edi
  801df0:	56                   	push   %esi
  801df1:	53                   	push   %ebx
  801df2:	83 ec 18             	sub    $0x18,%esp
  801df5:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801df8:	57                   	push   %edi
  801df9:	e8 df f6 ff ff       	call   8014dd <fd2data>
  801dfe:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e00:	83 c4 10             	add    $0x10,%esp
  801e03:	be 00 00 00 00       	mov    $0x0,%esi
  801e08:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e0b:	75 14                	jne    801e21 <devpipe_read+0x35>
	return i;
  801e0d:	8b 45 10             	mov    0x10(%ebp),%eax
  801e10:	eb 02                	jmp    801e14 <devpipe_read+0x28>
				return i;
  801e12:	89 f0                	mov    %esi,%eax
}
  801e14:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e17:	5b                   	pop    %ebx
  801e18:	5e                   	pop    %esi
  801e19:	5f                   	pop    %edi
  801e1a:	5d                   	pop    %ebp
  801e1b:	c3                   	ret    
			sys_yield();
  801e1c:	e8 3f f0 ff ff       	call   800e60 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801e21:	8b 03                	mov    (%ebx),%eax
  801e23:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e26:	75 18                	jne    801e40 <devpipe_read+0x54>
			if (i > 0)
  801e28:	85 f6                	test   %esi,%esi
  801e2a:	75 e6                	jne    801e12 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801e2c:	89 da                	mov    %ebx,%edx
  801e2e:	89 f8                	mov    %edi,%eax
  801e30:	e8 d0 fe ff ff       	call   801d05 <_pipeisclosed>
  801e35:	85 c0                	test   %eax,%eax
  801e37:	74 e3                	je     801e1c <devpipe_read+0x30>
				return 0;
  801e39:	b8 00 00 00 00       	mov    $0x0,%eax
  801e3e:	eb d4                	jmp    801e14 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e40:	99                   	cltd   
  801e41:	c1 ea 1b             	shr    $0x1b,%edx
  801e44:	01 d0                	add    %edx,%eax
  801e46:	83 e0 1f             	and    $0x1f,%eax
  801e49:	29 d0                	sub    %edx,%eax
  801e4b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e50:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e53:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e56:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e59:	83 c6 01             	add    $0x1,%esi
  801e5c:	eb aa                	jmp    801e08 <devpipe_read+0x1c>

00801e5e <pipe>:
{
  801e5e:	55                   	push   %ebp
  801e5f:	89 e5                	mov    %esp,%ebp
  801e61:	56                   	push   %esi
  801e62:	53                   	push   %ebx
  801e63:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801e66:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e69:	50                   	push   %eax
  801e6a:	e8 85 f6 ff ff       	call   8014f4 <fd_alloc>
  801e6f:	89 c3                	mov    %eax,%ebx
  801e71:	83 c4 10             	add    $0x10,%esp
  801e74:	85 c0                	test   %eax,%eax
  801e76:	0f 88 23 01 00 00    	js     801f9f <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e7c:	83 ec 04             	sub    $0x4,%esp
  801e7f:	68 07 04 00 00       	push   $0x407
  801e84:	ff 75 f4             	pushl  -0xc(%ebp)
  801e87:	6a 00                	push   $0x0
  801e89:	e8 f1 ef ff ff       	call   800e7f <sys_page_alloc>
  801e8e:	89 c3                	mov    %eax,%ebx
  801e90:	83 c4 10             	add    $0x10,%esp
  801e93:	85 c0                	test   %eax,%eax
  801e95:	0f 88 04 01 00 00    	js     801f9f <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801e9b:	83 ec 0c             	sub    $0xc,%esp
  801e9e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ea1:	50                   	push   %eax
  801ea2:	e8 4d f6 ff ff       	call   8014f4 <fd_alloc>
  801ea7:	89 c3                	mov    %eax,%ebx
  801ea9:	83 c4 10             	add    $0x10,%esp
  801eac:	85 c0                	test   %eax,%eax
  801eae:	0f 88 db 00 00 00    	js     801f8f <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801eb4:	83 ec 04             	sub    $0x4,%esp
  801eb7:	68 07 04 00 00       	push   $0x407
  801ebc:	ff 75 f0             	pushl  -0x10(%ebp)
  801ebf:	6a 00                	push   $0x0
  801ec1:	e8 b9 ef ff ff       	call   800e7f <sys_page_alloc>
  801ec6:	89 c3                	mov    %eax,%ebx
  801ec8:	83 c4 10             	add    $0x10,%esp
  801ecb:	85 c0                	test   %eax,%eax
  801ecd:	0f 88 bc 00 00 00    	js     801f8f <pipe+0x131>
	va = fd2data(fd0);
  801ed3:	83 ec 0c             	sub    $0xc,%esp
  801ed6:	ff 75 f4             	pushl  -0xc(%ebp)
  801ed9:	e8 ff f5 ff ff       	call   8014dd <fd2data>
  801ede:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ee0:	83 c4 0c             	add    $0xc,%esp
  801ee3:	68 07 04 00 00       	push   $0x407
  801ee8:	50                   	push   %eax
  801ee9:	6a 00                	push   $0x0
  801eeb:	e8 8f ef ff ff       	call   800e7f <sys_page_alloc>
  801ef0:	89 c3                	mov    %eax,%ebx
  801ef2:	83 c4 10             	add    $0x10,%esp
  801ef5:	85 c0                	test   %eax,%eax
  801ef7:	0f 88 82 00 00 00    	js     801f7f <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801efd:	83 ec 0c             	sub    $0xc,%esp
  801f00:	ff 75 f0             	pushl  -0x10(%ebp)
  801f03:	e8 d5 f5 ff ff       	call   8014dd <fd2data>
  801f08:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801f0f:	50                   	push   %eax
  801f10:	6a 00                	push   $0x0
  801f12:	56                   	push   %esi
  801f13:	6a 00                	push   $0x0
  801f15:	e8 a8 ef ff ff       	call   800ec2 <sys_page_map>
  801f1a:	89 c3                	mov    %eax,%ebx
  801f1c:	83 c4 20             	add    $0x20,%esp
  801f1f:	85 c0                	test   %eax,%eax
  801f21:	78 4e                	js     801f71 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801f23:	a1 20 30 80 00       	mov    0x803020,%eax
  801f28:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f2b:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801f2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f30:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801f37:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f3a:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801f3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f3f:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f46:	83 ec 0c             	sub    $0xc,%esp
  801f49:	ff 75 f4             	pushl  -0xc(%ebp)
  801f4c:	e8 7c f5 ff ff       	call   8014cd <fd2num>
  801f51:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f54:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f56:	83 c4 04             	add    $0x4,%esp
  801f59:	ff 75 f0             	pushl  -0x10(%ebp)
  801f5c:	e8 6c f5 ff ff       	call   8014cd <fd2num>
  801f61:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f64:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f67:	83 c4 10             	add    $0x10,%esp
  801f6a:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f6f:	eb 2e                	jmp    801f9f <pipe+0x141>
	sys_page_unmap(0, va);
  801f71:	83 ec 08             	sub    $0x8,%esp
  801f74:	56                   	push   %esi
  801f75:	6a 00                	push   $0x0
  801f77:	e8 88 ef ff ff       	call   800f04 <sys_page_unmap>
  801f7c:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801f7f:	83 ec 08             	sub    $0x8,%esp
  801f82:	ff 75 f0             	pushl  -0x10(%ebp)
  801f85:	6a 00                	push   $0x0
  801f87:	e8 78 ef ff ff       	call   800f04 <sys_page_unmap>
  801f8c:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801f8f:	83 ec 08             	sub    $0x8,%esp
  801f92:	ff 75 f4             	pushl  -0xc(%ebp)
  801f95:	6a 00                	push   $0x0
  801f97:	e8 68 ef ff ff       	call   800f04 <sys_page_unmap>
  801f9c:	83 c4 10             	add    $0x10,%esp
}
  801f9f:	89 d8                	mov    %ebx,%eax
  801fa1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fa4:	5b                   	pop    %ebx
  801fa5:	5e                   	pop    %esi
  801fa6:	5d                   	pop    %ebp
  801fa7:	c3                   	ret    

00801fa8 <pipeisclosed>:
{
  801fa8:	55                   	push   %ebp
  801fa9:	89 e5                	mov    %esp,%ebp
  801fab:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fae:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fb1:	50                   	push   %eax
  801fb2:	ff 75 08             	pushl  0x8(%ebp)
  801fb5:	e8 8c f5 ff ff       	call   801546 <fd_lookup>
  801fba:	83 c4 10             	add    $0x10,%esp
  801fbd:	85 c0                	test   %eax,%eax
  801fbf:	78 18                	js     801fd9 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801fc1:	83 ec 0c             	sub    $0xc,%esp
  801fc4:	ff 75 f4             	pushl  -0xc(%ebp)
  801fc7:	e8 11 f5 ff ff       	call   8014dd <fd2data>
	return _pipeisclosed(fd, p);
  801fcc:	89 c2                	mov    %eax,%edx
  801fce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd1:	e8 2f fd ff ff       	call   801d05 <_pipeisclosed>
  801fd6:	83 c4 10             	add    $0x10,%esp
}
  801fd9:	c9                   	leave  
  801fda:	c3                   	ret    

00801fdb <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801fdb:	b8 00 00 00 00       	mov    $0x0,%eax
  801fe0:	c3                   	ret    

00801fe1 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801fe1:	55                   	push   %ebp
  801fe2:	89 e5                	mov    %esp,%ebp
  801fe4:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801fe7:	68 e7 2c 80 00       	push   $0x802ce7
  801fec:	ff 75 0c             	pushl  0xc(%ebp)
  801fef:	e8 99 ea ff ff       	call   800a8d <strcpy>
	return 0;
}
  801ff4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ff9:	c9                   	leave  
  801ffa:	c3                   	ret    

00801ffb <devcons_write>:
{
  801ffb:	55                   	push   %ebp
  801ffc:	89 e5                	mov    %esp,%ebp
  801ffe:	57                   	push   %edi
  801fff:	56                   	push   %esi
  802000:	53                   	push   %ebx
  802001:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802007:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80200c:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802012:	3b 75 10             	cmp    0x10(%ebp),%esi
  802015:	73 31                	jae    802048 <devcons_write+0x4d>
		m = n - tot;
  802017:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80201a:	29 f3                	sub    %esi,%ebx
  80201c:	83 fb 7f             	cmp    $0x7f,%ebx
  80201f:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802024:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802027:	83 ec 04             	sub    $0x4,%esp
  80202a:	53                   	push   %ebx
  80202b:	89 f0                	mov    %esi,%eax
  80202d:	03 45 0c             	add    0xc(%ebp),%eax
  802030:	50                   	push   %eax
  802031:	57                   	push   %edi
  802032:	e8 e4 eb ff ff       	call   800c1b <memmove>
		sys_cputs(buf, m);
  802037:	83 c4 08             	add    $0x8,%esp
  80203a:	53                   	push   %ebx
  80203b:	57                   	push   %edi
  80203c:	e8 82 ed ff ff       	call   800dc3 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802041:	01 de                	add    %ebx,%esi
  802043:	83 c4 10             	add    $0x10,%esp
  802046:	eb ca                	jmp    802012 <devcons_write+0x17>
}
  802048:	89 f0                	mov    %esi,%eax
  80204a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80204d:	5b                   	pop    %ebx
  80204e:	5e                   	pop    %esi
  80204f:	5f                   	pop    %edi
  802050:	5d                   	pop    %ebp
  802051:	c3                   	ret    

00802052 <devcons_read>:
{
  802052:	55                   	push   %ebp
  802053:	89 e5                	mov    %esp,%ebp
  802055:	83 ec 08             	sub    $0x8,%esp
  802058:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80205d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802061:	74 21                	je     802084 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802063:	e8 79 ed ff ff       	call   800de1 <sys_cgetc>
  802068:	85 c0                	test   %eax,%eax
  80206a:	75 07                	jne    802073 <devcons_read+0x21>
		sys_yield();
  80206c:	e8 ef ed ff ff       	call   800e60 <sys_yield>
  802071:	eb f0                	jmp    802063 <devcons_read+0x11>
	if (c < 0)
  802073:	78 0f                	js     802084 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802075:	83 f8 04             	cmp    $0x4,%eax
  802078:	74 0c                	je     802086 <devcons_read+0x34>
	*(char*)vbuf = c;
  80207a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80207d:	88 02                	mov    %al,(%edx)
	return 1;
  80207f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802084:	c9                   	leave  
  802085:	c3                   	ret    
		return 0;
  802086:	b8 00 00 00 00       	mov    $0x0,%eax
  80208b:	eb f7                	jmp    802084 <devcons_read+0x32>

0080208d <cputchar>:
{
  80208d:	55                   	push   %ebp
  80208e:	89 e5                	mov    %esp,%ebp
  802090:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802093:	8b 45 08             	mov    0x8(%ebp),%eax
  802096:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802099:	6a 01                	push   $0x1
  80209b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80209e:	50                   	push   %eax
  80209f:	e8 1f ed ff ff       	call   800dc3 <sys_cputs>
}
  8020a4:	83 c4 10             	add    $0x10,%esp
  8020a7:	c9                   	leave  
  8020a8:	c3                   	ret    

008020a9 <getchar>:
{
  8020a9:	55                   	push   %ebp
  8020aa:	89 e5                	mov    %esp,%ebp
  8020ac:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8020af:	6a 01                	push   $0x1
  8020b1:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020b4:	50                   	push   %eax
  8020b5:	6a 00                	push   $0x0
  8020b7:	e8 f5 f6 ff ff       	call   8017b1 <read>
	if (r < 0)
  8020bc:	83 c4 10             	add    $0x10,%esp
  8020bf:	85 c0                	test   %eax,%eax
  8020c1:	78 06                	js     8020c9 <getchar+0x20>
	if (r < 1)
  8020c3:	74 06                	je     8020cb <getchar+0x22>
	return c;
  8020c5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8020c9:	c9                   	leave  
  8020ca:	c3                   	ret    
		return -E_EOF;
  8020cb:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8020d0:	eb f7                	jmp    8020c9 <getchar+0x20>

008020d2 <iscons>:
{
  8020d2:	55                   	push   %ebp
  8020d3:	89 e5                	mov    %esp,%ebp
  8020d5:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020d8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020db:	50                   	push   %eax
  8020dc:	ff 75 08             	pushl  0x8(%ebp)
  8020df:	e8 62 f4 ff ff       	call   801546 <fd_lookup>
  8020e4:	83 c4 10             	add    $0x10,%esp
  8020e7:	85 c0                	test   %eax,%eax
  8020e9:	78 11                	js     8020fc <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8020eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ee:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8020f4:	39 10                	cmp    %edx,(%eax)
  8020f6:	0f 94 c0             	sete   %al
  8020f9:	0f b6 c0             	movzbl %al,%eax
}
  8020fc:	c9                   	leave  
  8020fd:	c3                   	ret    

008020fe <opencons>:
{
  8020fe:	55                   	push   %ebp
  8020ff:	89 e5                	mov    %esp,%ebp
  802101:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802104:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802107:	50                   	push   %eax
  802108:	e8 e7 f3 ff ff       	call   8014f4 <fd_alloc>
  80210d:	83 c4 10             	add    $0x10,%esp
  802110:	85 c0                	test   %eax,%eax
  802112:	78 3a                	js     80214e <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802114:	83 ec 04             	sub    $0x4,%esp
  802117:	68 07 04 00 00       	push   $0x407
  80211c:	ff 75 f4             	pushl  -0xc(%ebp)
  80211f:	6a 00                	push   $0x0
  802121:	e8 59 ed ff ff       	call   800e7f <sys_page_alloc>
  802126:	83 c4 10             	add    $0x10,%esp
  802129:	85 c0                	test   %eax,%eax
  80212b:	78 21                	js     80214e <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80212d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802130:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802136:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802138:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80213b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802142:	83 ec 0c             	sub    $0xc,%esp
  802145:	50                   	push   %eax
  802146:	e8 82 f3 ff ff       	call   8014cd <fd2num>
  80214b:	83 c4 10             	add    $0x10,%esp
}
  80214e:	c9                   	leave  
  80214f:	c3                   	ret    

00802150 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802150:	55                   	push   %ebp
  802151:	89 e5                	mov    %esp,%ebp
  802153:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802156:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  80215d:	74 0a                	je     802169 <set_pgfault_handler+0x19>
			panic("set_pgfault_handler: sys_env_set_pgfault_upcall fail, ret:%d", ret);
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80215f:	8b 45 08             	mov    0x8(%ebp),%eax
  802162:	a3 00 60 80 00       	mov    %eax,0x806000
}
  802167:	c9                   	leave  
  802168:	c3                   	ret    
		ret = sys_page_alloc((envid_t)0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W);
  802169:	83 ec 04             	sub    $0x4,%esp
  80216c:	6a 07                	push   $0x7
  80216e:	68 00 f0 bf ee       	push   $0xeebff000
  802173:	6a 00                	push   $0x0
  802175:	e8 05 ed ff ff       	call   800e7f <sys_page_alloc>
		if(ret < 0){
  80217a:	83 c4 10             	add    $0x10,%esp
  80217d:	85 c0                	test   %eax,%eax
  80217f:	78 28                	js     8021a9 <set_pgfault_handler+0x59>
    	ret = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  802181:	83 ec 08             	sub    $0x8,%esp
  802184:	68 bb 21 80 00       	push   $0x8021bb
  802189:	6a 00                	push   $0x0
  80218b:	e8 3a ee ff ff       	call   800fca <sys_env_set_pgfault_upcall>
		if(ret < 0){
  802190:	83 c4 10             	add    $0x10,%esp
  802193:	85 c0                	test   %eax,%eax
  802195:	79 c8                	jns    80215f <set_pgfault_handler+0xf>
			panic("set_pgfault_handler: sys_env_set_pgfault_upcall fail, ret:%d", ret);
  802197:	50                   	push   %eax
  802198:	68 28 2d 80 00       	push   $0x802d28
  80219d:	6a 28                	push   $0x28
  80219f:	68 68 2d 80 00       	push   $0x802d68
  8021a4:	e8 e3 e0 ff ff       	call   80028c <_panic>
			panic("set_pgfault_handler: sys_page_alloc fail, ret:%d", ret);
  8021a9:	50                   	push   %eax
  8021aa:	68 f4 2c 80 00       	push   $0x802cf4
  8021af:	6a 24                	push   $0x24
  8021b1:	68 68 2d 80 00       	push   $0x802d68
  8021b6:	e8 d1 e0 ff ff       	call   80028c <_panic>

008021bb <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8021bb:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8021bc:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  8021c1:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8021c3:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %edi
  8021c6:	8b 7c 24 28          	mov    0x28(%esp),%edi
	movl 0x30(%esp), %esi
  8021ca:	8b 74 24 30          	mov    0x30(%esp),%esi
	subl $4, %esi
  8021ce:	83 ee 04             	sub    $0x4,%esi
	movl %edi, (%esi)
  8021d1:	89 3e                	mov    %edi,(%esi)
	movl %esi, 0x30(%esp)
  8021d3:	89 74 24 30          	mov    %esi,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  8021d7:	83 c4 08             	add    $0x8,%esp
	popal
  8021da:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8021db:	83 c4 04             	add    $0x4,%esp
	popfl
  8021de:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8021df:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  8021e0:	c3                   	ret    

008021e1 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8021e1:	55                   	push   %ebp
  8021e2:	89 e5                	mov    %esp,%ebp
  8021e4:	56                   	push   %esi
  8021e5:	53                   	push   %ebx
  8021e6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8021e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ec:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// return 0;
	if(!pg)
  8021ef:	85 c0                	test   %eax,%eax
		pg = (void*)UTOP;
  8021f1:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8021f6:	0f 44 c2             	cmove  %edx,%eax
	
	int ret;

	ret = sys_ipc_recv(pg);
  8021f9:	83 ec 0c             	sub    $0xc,%esp
  8021fc:	50                   	push   %eax
  8021fd:	e8 2d ee ff ff       	call   80102f <sys_ipc_recv>
	if(ret < 0){
  802202:	83 c4 10             	add    $0x10,%esp
  802205:	85 c0                	test   %eax,%eax
  802207:	78 2b                	js     802234 <ipc_recv+0x53>
		if(perm_store) *perm_store = 0;
		if(from_env_store) *from_env_store = 0;
		return ret;
	}
	
	if(perm_store)
  802209:	85 f6                	test   %esi,%esi
  80220b:	74 0a                	je     802217 <ipc_recv+0x36>
		*perm_store = thisenv->env_ipc_perm;
  80220d:	a1 04 40 80 00       	mov    0x804004,%eax
  802212:	8b 40 78             	mov    0x78(%eax),%eax
  802215:	89 06                	mov    %eax,(%esi)
	if(from_env_store)
  802217:	85 db                	test   %ebx,%ebx
  802219:	74 0a                	je     802225 <ipc_recv+0x44>
		*from_env_store = thisenv->env_ipc_from;
  80221b:	a1 04 40 80 00       	mov    0x804004,%eax
  802220:	8b 40 74             	mov    0x74(%eax),%eax
  802223:	89 03                	mov    %eax,(%ebx)

	return thisenv->env_ipc_value;
  802225:	a1 04 40 80 00       	mov    0x804004,%eax
  80222a:	8b 40 70             	mov    0x70(%eax),%eax
}
  80222d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802230:	5b                   	pop    %ebx
  802231:	5e                   	pop    %esi
  802232:	5d                   	pop    %ebp
  802233:	c3                   	ret    
		if(perm_store) *perm_store = 0;
  802234:	85 f6                	test   %esi,%esi
  802236:	74 06                	je     80223e <ipc_recv+0x5d>
  802238:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(from_env_store) *from_env_store = 0;
  80223e:	85 db                	test   %ebx,%ebx
  802240:	74 eb                	je     80222d <ipc_recv+0x4c>
  802242:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802248:	eb e3                	jmp    80222d <ipc_recv+0x4c>

0080224a <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80224a:	55                   	push   %ebp
  80224b:	89 e5                	mov    %esp,%ebp
  80224d:	57                   	push   %edi
  80224e:	56                   	push   %esi
  80224f:	53                   	push   %ebx
  802250:	83 ec 0c             	sub    $0xc,%esp
  802253:	8b 7d 08             	mov    0x8(%ebp),%edi
  802256:	8b 75 0c             	mov    0xc(%ebp),%esi
  802259:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
	if (!pg)
  80225c:	85 db                	test   %ebx,%ebx
		pg = (void*)UTOP;
  80225e:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802263:	0f 44 d8             	cmove  %eax,%ebx

	int ret = -E_IPC_NOT_RECV;
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))) {
  802266:	ff 75 14             	pushl  0x14(%ebp)
  802269:	53                   	push   %ebx
  80226a:	56                   	push   %esi
  80226b:	57                   	push   %edi
  80226c:	e8 9b ed ff ff       	call   80100c <sys_ipc_try_send>
  802271:	83 c4 10             	add    $0x10,%esp
  802274:	85 c0                	test   %eax,%eax
  802276:	74 17                	je     80228f <ipc_send+0x45>
		if(ret != -E_IPC_NOT_RECV){
  802278:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80227b:	74 e9                	je     802266 <ipc_send+0x1c>
			panic("ipc_send: ret : %d", ret);
  80227d:	50                   	push   %eax
  80227e:	68 76 2d 80 00       	push   $0x802d76
  802283:	6a 43                	push   $0x43
  802285:	68 89 2d 80 00       	push   $0x802d89
  80228a:	e8 fd df ff ff       	call   80028c <_panic>
			sys_yield();
		}
	}
}
  80228f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802292:	5b                   	pop    %ebx
  802293:	5e                   	pop    %esi
  802294:	5f                   	pop    %edi
  802295:	5d                   	pop    %ebp
  802296:	c3                   	ret    

00802297 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802297:	55                   	push   %ebp
  802298:	89 e5                	mov    %esp,%ebp
  80229a:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80229d:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8022a2:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  8022a8:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8022ae:	8b 52 50             	mov    0x50(%edx),%edx
  8022b1:	39 ca                	cmp    %ecx,%edx
  8022b3:	74 11                	je     8022c6 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  8022b5:	83 c0 01             	add    $0x1,%eax
  8022b8:	3d 00 04 00 00       	cmp    $0x400,%eax
  8022bd:	75 e3                	jne    8022a2 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8022bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8022c4:	eb 0e                	jmp    8022d4 <ipc_find_env+0x3d>
			return envs[i].env_id;
  8022c6:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8022cc:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8022d1:	8b 40 48             	mov    0x48(%eax),%eax
}
  8022d4:	5d                   	pop    %ebp
  8022d5:	c3                   	ret    

008022d6 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8022d6:	55                   	push   %ebp
  8022d7:	89 e5                	mov    %esp,%ebp
  8022d9:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8022dc:	89 d0                	mov    %edx,%eax
  8022de:	c1 e8 16             	shr    $0x16,%eax
  8022e1:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8022e8:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8022ed:	f6 c1 01             	test   $0x1,%cl
  8022f0:	74 1d                	je     80230f <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8022f2:	c1 ea 0c             	shr    $0xc,%edx
  8022f5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8022fc:	f6 c2 01             	test   $0x1,%dl
  8022ff:	74 0e                	je     80230f <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802301:	c1 ea 0c             	shr    $0xc,%edx
  802304:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80230b:	ef 
  80230c:	0f b7 c0             	movzwl %ax,%eax
}
  80230f:	5d                   	pop    %ebp
  802310:	c3                   	ret    
  802311:	66 90                	xchg   %ax,%ax
  802313:	66 90                	xchg   %ax,%ax
  802315:	66 90                	xchg   %ax,%ax
  802317:	66 90                	xchg   %ax,%ax
  802319:	66 90                	xchg   %ax,%ax
  80231b:	66 90                	xchg   %ax,%ax
  80231d:	66 90                	xchg   %ax,%ax
  80231f:	90                   	nop

00802320 <__udivdi3>:
  802320:	55                   	push   %ebp
  802321:	57                   	push   %edi
  802322:	56                   	push   %esi
  802323:	53                   	push   %ebx
  802324:	83 ec 1c             	sub    $0x1c,%esp
  802327:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80232b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80232f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802333:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802337:	85 d2                	test   %edx,%edx
  802339:	75 4d                	jne    802388 <__udivdi3+0x68>
  80233b:	39 f3                	cmp    %esi,%ebx
  80233d:	76 19                	jbe    802358 <__udivdi3+0x38>
  80233f:	31 ff                	xor    %edi,%edi
  802341:	89 e8                	mov    %ebp,%eax
  802343:	89 f2                	mov    %esi,%edx
  802345:	f7 f3                	div    %ebx
  802347:	89 fa                	mov    %edi,%edx
  802349:	83 c4 1c             	add    $0x1c,%esp
  80234c:	5b                   	pop    %ebx
  80234d:	5e                   	pop    %esi
  80234e:	5f                   	pop    %edi
  80234f:	5d                   	pop    %ebp
  802350:	c3                   	ret    
  802351:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802358:	89 d9                	mov    %ebx,%ecx
  80235a:	85 db                	test   %ebx,%ebx
  80235c:	75 0b                	jne    802369 <__udivdi3+0x49>
  80235e:	b8 01 00 00 00       	mov    $0x1,%eax
  802363:	31 d2                	xor    %edx,%edx
  802365:	f7 f3                	div    %ebx
  802367:	89 c1                	mov    %eax,%ecx
  802369:	31 d2                	xor    %edx,%edx
  80236b:	89 f0                	mov    %esi,%eax
  80236d:	f7 f1                	div    %ecx
  80236f:	89 c6                	mov    %eax,%esi
  802371:	89 e8                	mov    %ebp,%eax
  802373:	89 f7                	mov    %esi,%edi
  802375:	f7 f1                	div    %ecx
  802377:	89 fa                	mov    %edi,%edx
  802379:	83 c4 1c             	add    $0x1c,%esp
  80237c:	5b                   	pop    %ebx
  80237d:	5e                   	pop    %esi
  80237e:	5f                   	pop    %edi
  80237f:	5d                   	pop    %ebp
  802380:	c3                   	ret    
  802381:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802388:	39 f2                	cmp    %esi,%edx
  80238a:	77 1c                	ja     8023a8 <__udivdi3+0x88>
  80238c:	0f bd fa             	bsr    %edx,%edi
  80238f:	83 f7 1f             	xor    $0x1f,%edi
  802392:	75 2c                	jne    8023c0 <__udivdi3+0xa0>
  802394:	39 f2                	cmp    %esi,%edx
  802396:	72 06                	jb     80239e <__udivdi3+0x7e>
  802398:	31 c0                	xor    %eax,%eax
  80239a:	39 eb                	cmp    %ebp,%ebx
  80239c:	77 a9                	ja     802347 <__udivdi3+0x27>
  80239e:	b8 01 00 00 00       	mov    $0x1,%eax
  8023a3:	eb a2                	jmp    802347 <__udivdi3+0x27>
  8023a5:	8d 76 00             	lea    0x0(%esi),%esi
  8023a8:	31 ff                	xor    %edi,%edi
  8023aa:	31 c0                	xor    %eax,%eax
  8023ac:	89 fa                	mov    %edi,%edx
  8023ae:	83 c4 1c             	add    $0x1c,%esp
  8023b1:	5b                   	pop    %ebx
  8023b2:	5e                   	pop    %esi
  8023b3:	5f                   	pop    %edi
  8023b4:	5d                   	pop    %ebp
  8023b5:	c3                   	ret    
  8023b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023bd:	8d 76 00             	lea    0x0(%esi),%esi
  8023c0:	89 f9                	mov    %edi,%ecx
  8023c2:	b8 20 00 00 00       	mov    $0x20,%eax
  8023c7:	29 f8                	sub    %edi,%eax
  8023c9:	d3 e2                	shl    %cl,%edx
  8023cb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8023cf:	89 c1                	mov    %eax,%ecx
  8023d1:	89 da                	mov    %ebx,%edx
  8023d3:	d3 ea                	shr    %cl,%edx
  8023d5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8023d9:	09 d1                	or     %edx,%ecx
  8023db:	89 f2                	mov    %esi,%edx
  8023dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8023e1:	89 f9                	mov    %edi,%ecx
  8023e3:	d3 e3                	shl    %cl,%ebx
  8023e5:	89 c1                	mov    %eax,%ecx
  8023e7:	d3 ea                	shr    %cl,%edx
  8023e9:	89 f9                	mov    %edi,%ecx
  8023eb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8023ef:	89 eb                	mov    %ebp,%ebx
  8023f1:	d3 e6                	shl    %cl,%esi
  8023f3:	89 c1                	mov    %eax,%ecx
  8023f5:	d3 eb                	shr    %cl,%ebx
  8023f7:	09 de                	or     %ebx,%esi
  8023f9:	89 f0                	mov    %esi,%eax
  8023fb:	f7 74 24 08          	divl   0x8(%esp)
  8023ff:	89 d6                	mov    %edx,%esi
  802401:	89 c3                	mov    %eax,%ebx
  802403:	f7 64 24 0c          	mull   0xc(%esp)
  802407:	39 d6                	cmp    %edx,%esi
  802409:	72 15                	jb     802420 <__udivdi3+0x100>
  80240b:	89 f9                	mov    %edi,%ecx
  80240d:	d3 e5                	shl    %cl,%ebp
  80240f:	39 c5                	cmp    %eax,%ebp
  802411:	73 04                	jae    802417 <__udivdi3+0xf7>
  802413:	39 d6                	cmp    %edx,%esi
  802415:	74 09                	je     802420 <__udivdi3+0x100>
  802417:	89 d8                	mov    %ebx,%eax
  802419:	31 ff                	xor    %edi,%edi
  80241b:	e9 27 ff ff ff       	jmp    802347 <__udivdi3+0x27>
  802420:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802423:	31 ff                	xor    %edi,%edi
  802425:	e9 1d ff ff ff       	jmp    802347 <__udivdi3+0x27>
  80242a:	66 90                	xchg   %ax,%ax
  80242c:	66 90                	xchg   %ax,%ax
  80242e:	66 90                	xchg   %ax,%ax

00802430 <__umoddi3>:
  802430:	55                   	push   %ebp
  802431:	57                   	push   %edi
  802432:	56                   	push   %esi
  802433:	53                   	push   %ebx
  802434:	83 ec 1c             	sub    $0x1c,%esp
  802437:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80243b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80243f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802443:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802447:	89 da                	mov    %ebx,%edx
  802449:	85 c0                	test   %eax,%eax
  80244b:	75 43                	jne    802490 <__umoddi3+0x60>
  80244d:	39 df                	cmp    %ebx,%edi
  80244f:	76 17                	jbe    802468 <__umoddi3+0x38>
  802451:	89 f0                	mov    %esi,%eax
  802453:	f7 f7                	div    %edi
  802455:	89 d0                	mov    %edx,%eax
  802457:	31 d2                	xor    %edx,%edx
  802459:	83 c4 1c             	add    $0x1c,%esp
  80245c:	5b                   	pop    %ebx
  80245d:	5e                   	pop    %esi
  80245e:	5f                   	pop    %edi
  80245f:	5d                   	pop    %ebp
  802460:	c3                   	ret    
  802461:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802468:	89 fd                	mov    %edi,%ebp
  80246a:	85 ff                	test   %edi,%edi
  80246c:	75 0b                	jne    802479 <__umoddi3+0x49>
  80246e:	b8 01 00 00 00       	mov    $0x1,%eax
  802473:	31 d2                	xor    %edx,%edx
  802475:	f7 f7                	div    %edi
  802477:	89 c5                	mov    %eax,%ebp
  802479:	89 d8                	mov    %ebx,%eax
  80247b:	31 d2                	xor    %edx,%edx
  80247d:	f7 f5                	div    %ebp
  80247f:	89 f0                	mov    %esi,%eax
  802481:	f7 f5                	div    %ebp
  802483:	89 d0                	mov    %edx,%eax
  802485:	eb d0                	jmp    802457 <__umoddi3+0x27>
  802487:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80248e:	66 90                	xchg   %ax,%ax
  802490:	89 f1                	mov    %esi,%ecx
  802492:	39 d8                	cmp    %ebx,%eax
  802494:	76 0a                	jbe    8024a0 <__umoddi3+0x70>
  802496:	89 f0                	mov    %esi,%eax
  802498:	83 c4 1c             	add    $0x1c,%esp
  80249b:	5b                   	pop    %ebx
  80249c:	5e                   	pop    %esi
  80249d:	5f                   	pop    %edi
  80249e:	5d                   	pop    %ebp
  80249f:	c3                   	ret    
  8024a0:	0f bd e8             	bsr    %eax,%ebp
  8024a3:	83 f5 1f             	xor    $0x1f,%ebp
  8024a6:	75 20                	jne    8024c8 <__umoddi3+0x98>
  8024a8:	39 d8                	cmp    %ebx,%eax
  8024aa:	0f 82 b0 00 00 00    	jb     802560 <__umoddi3+0x130>
  8024b0:	39 f7                	cmp    %esi,%edi
  8024b2:	0f 86 a8 00 00 00    	jbe    802560 <__umoddi3+0x130>
  8024b8:	89 c8                	mov    %ecx,%eax
  8024ba:	83 c4 1c             	add    $0x1c,%esp
  8024bd:	5b                   	pop    %ebx
  8024be:	5e                   	pop    %esi
  8024bf:	5f                   	pop    %edi
  8024c0:	5d                   	pop    %ebp
  8024c1:	c3                   	ret    
  8024c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8024c8:	89 e9                	mov    %ebp,%ecx
  8024ca:	ba 20 00 00 00       	mov    $0x20,%edx
  8024cf:	29 ea                	sub    %ebp,%edx
  8024d1:	d3 e0                	shl    %cl,%eax
  8024d3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024d7:	89 d1                	mov    %edx,%ecx
  8024d9:	89 f8                	mov    %edi,%eax
  8024db:	d3 e8                	shr    %cl,%eax
  8024dd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8024e1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8024e5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8024e9:	09 c1                	or     %eax,%ecx
  8024eb:	89 d8                	mov    %ebx,%eax
  8024ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8024f1:	89 e9                	mov    %ebp,%ecx
  8024f3:	d3 e7                	shl    %cl,%edi
  8024f5:	89 d1                	mov    %edx,%ecx
  8024f7:	d3 e8                	shr    %cl,%eax
  8024f9:	89 e9                	mov    %ebp,%ecx
  8024fb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8024ff:	d3 e3                	shl    %cl,%ebx
  802501:	89 c7                	mov    %eax,%edi
  802503:	89 d1                	mov    %edx,%ecx
  802505:	89 f0                	mov    %esi,%eax
  802507:	d3 e8                	shr    %cl,%eax
  802509:	89 e9                	mov    %ebp,%ecx
  80250b:	89 fa                	mov    %edi,%edx
  80250d:	d3 e6                	shl    %cl,%esi
  80250f:	09 d8                	or     %ebx,%eax
  802511:	f7 74 24 08          	divl   0x8(%esp)
  802515:	89 d1                	mov    %edx,%ecx
  802517:	89 f3                	mov    %esi,%ebx
  802519:	f7 64 24 0c          	mull   0xc(%esp)
  80251d:	89 c6                	mov    %eax,%esi
  80251f:	89 d7                	mov    %edx,%edi
  802521:	39 d1                	cmp    %edx,%ecx
  802523:	72 06                	jb     80252b <__umoddi3+0xfb>
  802525:	75 10                	jne    802537 <__umoddi3+0x107>
  802527:	39 c3                	cmp    %eax,%ebx
  802529:	73 0c                	jae    802537 <__umoddi3+0x107>
  80252b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80252f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802533:	89 d7                	mov    %edx,%edi
  802535:	89 c6                	mov    %eax,%esi
  802537:	89 ca                	mov    %ecx,%edx
  802539:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80253e:	29 f3                	sub    %esi,%ebx
  802540:	19 fa                	sbb    %edi,%edx
  802542:	89 d0                	mov    %edx,%eax
  802544:	d3 e0                	shl    %cl,%eax
  802546:	89 e9                	mov    %ebp,%ecx
  802548:	d3 eb                	shr    %cl,%ebx
  80254a:	d3 ea                	shr    %cl,%edx
  80254c:	09 d8                	or     %ebx,%eax
  80254e:	83 c4 1c             	add    $0x1c,%esp
  802551:	5b                   	pop    %ebx
  802552:	5e                   	pop    %esi
  802553:	5f                   	pop    %edi
  802554:	5d                   	pop    %ebp
  802555:	c3                   	ret    
  802556:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80255d:	8d 76 00             	lea    0x0(%esi),%esi
  802560:	89 da                	mov    %ebx,%edx
  802562:	29 fe                	sub    %edi,%esi
  802564:	19 c2                	sbb    %eax,%edx
  802566:	89 f1                	mov    %esi,%ecx
  802568:	89 c8                	mov    %ecx,%eax
  80256a:	e9 4b ff ff ff       	jmp    8024ba <__umoddi3+0x8a>
