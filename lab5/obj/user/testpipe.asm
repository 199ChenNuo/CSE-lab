
obj/user/testpipe.debug:     file format elf32-i386


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
  80002c:	e8 a1 02 00 00       	call   8002d2 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

char *msg = "Now is the time for all good men to come to the aid of their party.";

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	83 ec 7c             	sub    $0x7c,%esp
	char buf[100];
	int i, pid, p[2];

	binaryname = "pipereadeof";
  80003b:	c7 05 04 30 80 00 60 	movl   $0x802660,0x803004
  800042:	26 80 00 

	if ((i = pipe(p)) < 0)
  800045:	8d 45 8c             	lea    -0x74(%ebp),%eax
  800048:	50                   	push   %eax
  800049:	e8 b1 1e 00 00       	call   801eff <pipe>
  80004e:	89 c6                	mov    %eax,%esi
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	85 c0                	test   %eax,%eax
  800055:	0f 88 1b 01 00 00    	js     800176 <umain+0x143>
		panic("pipe: %e", i);

	if ((pid = fork()) < 0)
  80005b:	e8 ee 11 00 00       	call   80124e <fork>
  800060:	89 c3                	mov    %eax,%ebx
  800062:	85 c0                	test   %eax,%eax
  800064:	0f 88 1e 01 00 00    	js     800188 <umain+0x155>
		panic("fork: %e", i);

	if (pid == 0) {
  80006a:	0f 85 56 01 00 00    	jne    8001c6 <umain+0x193>
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[1]);
  800070:	a1 04 40 80 00       	mov    0x804004,%eax
  800075:	8b 40 48             	mov    0x48(%eax),%eax
  800078:	83 ec 04             	sub    $0x4,%esp
  80007b:	ff 75 90             	pushl  -0x70(%ebp)
  80007e:	50                   	push   %eax
  80007f:	68 8e 26 80 00       	push   $0x80268e
  800084:	e8 7f 03 00 00       	call   800408 <cprintf>
		close(p[1]);
  800089:	83 c4 04             	add    $0x4,%esp
  80008c:	ff 75 90             	pushl  -0x70(%ebp)
  80008f:	e8 80 16 00 00       	call   801714 <close>
		cprintf("[%08x] pipereadeof readn %d\n", thisenv->env_id, p[0]);
  800094:	a1 04 40 80 00       	mov    0x804004,%eax
  800099:	8b 40 48             	mov    0x48(%eax),%eax
  80009c:	83 c4 0c             	add    $0xc,%esp
  80009f:	ff 75 8c             	pushl  -0x74(%ebp)
  8000a2:	50                   	push   %eax
  8000a3:	68 ab 26 80 00       	push   $0x8026ab
  8000a8:	e8 5b 03 00 00       	call   800408 <cprintf>
		i = readn(p[0], buf, sizeof buf-1);
  8000ad:	83 c4 0c             	add    $0xc,%esp
  8000b0:	6a 63                	push   $0x63
  8000b2:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8000b5:	50                   	push   %eax
  8000b6:	ff 75 8c             	pushl  -0x74(%ebp)
  8000b9:	e8 1b 18 00 00       	call   8018d9 <readn>
  8000be:	89 c6                	mov    %eax,%esi
		if (i < 0)
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	85 c0                	test   %eax,%eax
  8000c5:	0f 88 cf 00 00 00    	js     80019a <umain+0x167>
			panic("read: %e", i);
		buf[i] = 0;
  8000cb:	c6 44 05 94 00       	movb   $0x0,-0x6c(%ebp,%eax,1)
		if (strcmp(buf, msg) == 0)
  8000d0:	83 ec 08             	sub    $0x8,%esp
  8000d3:	ff 35 00 30 80 00    	pushl  0x803000
  8000d9:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8000dc:	50                   	push   %eax
  8000dd:	e8 f7 0a 00 00       	call   800bd9 <strcmp>
  8000e2:	83 c4 10             	add    $0x10,%esp
  8000e5:	85 c0                	test   %eax,%eax
  8000e7:	0f 85 bf 00 00 00    	jne    8001ac <umain+0x179>
			cprintf("\npipe read closed properly\n");
  8000ed:	83 ec 0c             	sub    $0xc,%esp
  8000f0:	68 d1 26 80 00       	push   $0x8026d1
  8000f5:	e8 0e 03 00 00       	call   800408 <cprintf>
  8000fa:	83 c4 10             	add    $0x10,%esp
		else
			cprintf("\ngot %d bytes: %s\n", i, buf);
		exit();
  8000fd:	e8 19 02 00 00       	call   80031b <exit>
		cprintf("[%08x] pipereadeof write %d\n", thisenv->env_id, p[1]);
		if ((i = write(p[1], msg, strlen(msg))) != strlen(msg))
			panic("write: %e", i);
		close(p[1]);
	}
	wait(pid);
  800102:	83 ec 0c             	sub    $0xc,%esp
  800105:	53                   	push   %ebx
  800106:	e8 71 1f 00 00       	call   80207c <wait>

	binaryname = "pipewriteeof";
  80010b:	c7 05 04 30 80 00 27 	movl   $0x802727,0x803004
  800112:	27 80 00 
	if ((i = pipe(p)) < 0)
  800115:	8d 45 8c             	lea    -0x74(%ebp),%eax
  800118:	89 04 24             	mov    %eax,(%esp)
  80011b:	e8 df 1d 00 00       	call   801eff <pipe>
  800120:	89 c6                	mov    %eax,%esi
  800122:	83 c4 10             	add    $0x10,%esp
  800125:	85 c0                	test   %eax,%eax
  800127:	0f 88 32 01 00 00    	js     80025f <umain+0x22c>
		panic("pipe: %e", i);

	if ((pid = fork()) < 0)
  80012d:	e8 1c 11 00 00       	call   80124e <fork>
  800132:	89 c3                	mov    %eax,%ebx
  800134:	85 c0                	test   %eax,%eax
  800136:	0f 88 35 01 00 00    	js     800271 <umain+0x23e>
		panic("fork: %e", i);

	if (pid == 0) {
  80013c:	0f 84 41 01 00 00    	je     800283 <umain+0x250>
				break;
		}
		cprintf("\npipe write closed properly\n");
		exit();
	}
	close(p[0]);
  800142:	83 ec 0c             	sub    $0xc,%esp
  800145:	ff 75 8c             	pushl  -0x74(%ebp)
  800148:	e8 c7 15 00 00       	call   801714 <close>
	close(p[1]);
  80014d:	83 c4 04             	add    $0x4,%esp
  800150:	ff 75 90             	pushl  -0x70(%ebp)
  800153:	e8 bc 15 00 00       	call   801714 <close>
	wait(pid);
  800158:	89 1c 24             	mov    %ebx,(%esp)
  80015b:	e8 1c 1f 00 00       	call   80207c <wait>

	cprintf("pipe tests passed\n");
  800160:	c7 04 24 55 27 80 00 	movl   $0x802755,(%esp)
  800167:	e8 9c 02 00 00       	call   800408 <cprintf>
}
  80016c:	83 c4 10             	add    $0x10,%esp
  80016f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800172:	5b                   	pop    %ebx
  800173:	5e                   	pop    %esi
  800174:	5d                   	pop    %ebp
  800175:	c3                   	ret    
		panic("pipe: %e", i);
  800176:	50                   	push   %eax
  800177:	68 6c 26 80 00       	push   $0x80266c
  80017c:	6a 0e                	push   $0xe
  80017e:	68 75 26 80 00       	push   $0x802675
  800183:	e8 a5 01 00 00       	call   80032d <_panic>
		panic("fork: %e", i);
  800188:	56                   	push   %esi
  800189:	68 85 26 80 00       	push   $0x802685
  80018e:	6a 11                	push   $0x11
  800190:	68 75 26 80 00       	push   $0x802675
  800195:	e8 93 01 00 00       	call   80032d <_panic>
			panic("read: %e", i);
  80019a:	50                   	push   %eax
  80019b:	68 c8 26 80 00       	push   $0x8026c8
  8001a0:	6a 19                	push   $0x19
  8001a2:	68 75 26 80 00       	push   $0x802675
  8001a7:	e8 81 01 00 00       	call   80032d <_panic>
			cprintf("\ngot %d bytes: %s\n", i, buf);
  8001ac:	83 ec 04             	sub    $0x4,%esp
  8001af:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8001b2:	50                   	push   %eax
  8001b3:	56                   	push   %esi
  8001b4:	68 ed 26 80 00       	push   $0x8026ed
  8001b9:	e8 4a 02 00 00       	call   800408 <cprintf>
  8001be:	83 c4 10             	add    $0x10,%esp
  8001c1:	e9 37 ff ff ff       	jmp    8000fd <umain+0xca>
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[0]);
  8001c6:	a1 04 40 80 00       	mov    0x804004,%eax
  8001cb:	8b 40 48             	mov    0x48(%eax),%eax
  8001ce:	83 ec 04             	sub    $0x4,%esp
  8001d1:	ff 75 8c             	pushl  -0x74(%ebp)
  8001d4:	50                   	push   %eax
  8001d5:	68 8e 26 80 00       	push   $0x80268e
  8001da:	e8 29 02 00 00       	call   800408 <cprintf>
		close(p[0]);
  8001df:	83 c4 04             	add    $0x4,%esp
  8001e2:	ff 75 8c             	pushl  -0x74(%ebp)
  8001e5:	e8 2a 15 00 00       	call   801714 <close>
		cprintf("[%08x] pipereadeof write %d\n", thisenv->env_id, p[1]);
  8001ea:	a1 04 40 80 00       	mov    0x804004,%eax
  8001ef:	8b 40 48             	mov    0x48(%eax),%eax
  8001f2:	83 c4 0c             	add    $0xc,%esp
  8001f5:	ff 75 90             	pushl  -0x70(%ebp)
  8001f8:	50                   	push   %eax
  8001f9:	68 00 27 80 00       	push   $0x802700
  8001fe:	e8 05 02 00 00       	call   800408 <cprintf>
		if ((i = write(p[1], msg, strlen(msg))) != strlen(msg))
  800203:	83 c4 04             	add    $0x4,%esp
  800206:	ff 35 00 30 80 00    	pushl  0x803000
  80020c:	e8 e4 08 00 00       	call   800af5 <strlen>
  800211:	83 c4 0c             	add    $0xc,%esp
  800214:	50                   	push   %eax
  800215:	ff 35 00 30 80 00    	pushl  0x803000
  80021b:	ff 75 90             	pushl  -0x70(%ebp)
  80021e:	e8 fb 16 00 00       	call   80191e <write>
  800223:	89 c6                	mov    %eax,%esi
  800225:	83 c4 04             	add    $0x4,%esp
  800228:	ff 35 00 30 80 00    	pushl  0x803000
  80022e:	e8 c2 08 00 00       	call   800af5 <strlen>
  800233:	83 c4 10             	add    $0x10,%esp
  800236:	39 f0                	cmp    %esi,%eax
  800238:	75 13                	jne    80024d <umain+0x21a>
		close(p[1]);
  80023a:	83 ec 0c             	sub    $0xc,%esp
  80023d:	ff 75 90             	pushl  -0x70(%ebp)
  800240:	e8 cf 14 00 00       	call   801714 <close>
  800245:	83 c4 10             	add    $0x10,%esp
  800248:	e9 b5 fe ff ff       	jmp    800102 <umain+0xcf>
			panic("write: %e", i);
  80024d:	56                   	push   %esi
  80024e:	68 1d 27 80 00       	push   $0x80271d
  800253:	6a 25                	push   $0x25
  800255:	68 75 26 80 00       	push   $0x802675
  80025a:	e8 ce 00 00 00       	call   80032d <_panic>
		panic("pipe: %e", i);
  80025f:	50                   	push   %eax
  800260:	68 6c 26 80 00       	push   $0x80266c
  800265:	6a 2c                	push   $0x2c
  800267:	68 75 26 80 00       	push   $0x802675
  80026c:	e8 bc 00 00 00       	call   80032d <_panic>
		panic("fork: %e", i);
  800271:	56                   	push   %esi
  800272:	68 85 26 80 00       	push   $0x802685
  800277:	6a 2f                	push   $0x2f
  800279:	68 75 26 80 00       	push   $0x802675
  80027e:	e8 aa 00 00 00       	call   80032d <_panic>
		close(p[0]);
  800283:	83 ec 0c             	sub    $0xc,%esp
  800286:	ff 75 8c             	pushl  -0x74(%ebp)
  800289:	e8 86 14 00 00       	call   801714 <close>
  80028e:	83 c4 10             	add    $0x10,%esp
			cprintf(".");
  800291:	83 ec 0c             	sub    $0xc,%esp
  800294:	68 34 27 80 00       	push   $0x802734
  800299:	e8 6a 01 00 00       	call   800408 <cprintf>
			if (write(p[1], "x", 1) != 1)
  80029e:	83 c4 0c             	add    $0xc,%esp
  8002a1:	6a 01                	push   $0x1
  8002a3:	68 36 27 80 00       	push   $0x802736
  8002a8:	ff 75 90             	pushl  -0x70(%ebp)
  8002ab:	e8 6e 16 00 00       	call   80191e <write>
  8002b0:	83 c4 10             	add    $0x10,%esp
  8002b3:	83 f8 01             	cmp    $0x1,%eax
  8002b6:	74 d9                	je     800291 <umain+0x25e>
		cprintf("\npipe write closed properly\n");
  8002b8:	83 ec 0c             	sub    $0xc,%esp
  8002bb:	68 38 27 80 00       	push   $0x802738
  8002c0:	e8 43 01 00 00       	call   800408 <cprintf>
		exit();
  8002c5:	e8 51 00 00 00       	call   80031b <exit>
  8002ca:	83 c4 10             	add    $0x10,%esp
  8002cd:	e9 70 fe ff ff       	jmp    800142 <umain+0x10f>

008002d2 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002d2:	55                   	push   %ebp
  8002d3:	89 e5                	mov    %esp,%ebp
  8002d5:	56                   	push   %esi
  8002d6:	53                   	push   %ebx
  8002d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8002da:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	// thisenv = 0;
	thisenv = &(envs[ENVX(sys_getenvid())]);
  8002dd:	e8 00 0c 00 00       	call   800ee2 <sys_getenvid>
  8002e2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002e7:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8002ed:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002f2:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002f7:	85 db                	test   %ebx,%ebx
  8002f9:	7e 07                	jle    800302 <libmain+0x30>
		binaryname = argv[0];
  8002fb:	8b 06                	mov    (%esi),%eax
  8002fd:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	umain(argc, argv);
  800302:	83 ec 08             	sub    $0x8,%esp
  800305:	56                   	push   %esi
  800306:	53                   	push   %ebx
  800307:	e8 27 fd ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80030c:	e8 0a 00 00 00       	call   80031b <exit>
}
  800311:	83 c4 10             	add    $0x10,%esp
  800314:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800317:	5b                   	pop    %ebx
  800318:	5e                   	pop    %esi
  800319:	5d                   	pop    %ebp
  80031a:	c3                   	ret    

0080031b <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80031b:	55                   	push   %ebp
  80031c:	89 e5                	mov    %esp,%ebp
  80031e:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  800321:	6a 00                	push   $0x0
  800323:	e8 79 0b 00 00       	call   800ea1 <sys_env_destroy>
}
  800328:	83 c4 10             	add    $0x10,%esp
  80032b:	c9                   	leave  
  80032c:	c3                   	ret    

0080032d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80032d:	55                   	push   %ebp
  80032e:	89 e5                	mov    %esp,%ebp
  800330:	56                   	push   %esi
  800331:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800332:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800335:	8b 35 04 30 80 00    	mov    0x803004,%esi
  80033b:	e8 a2 0b 00 00       	call   800ee2 <sys_getenvid>
  800340:	83 ec 0c             	sub    $0xc,%esp
  800343:	ff 75 0c             	pushl  0xc(%ebp)
  800346:	ff 75 08             	pushl  0x8(%ebp)
  800349:	56                   	push   %esi
  80034a:	50                   	push   %eax
  80034b:	68 b8 27 80 00       	push   $0x8027b8
  800350:	e8 b3 00 00 00       	call   800408 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800355:	83 c4 18             	add    $0x18,%esp
  800358:	53                   	push   %ebx
  800359:	ff 75 10             	pushl  0x10(%ebp)
  80035c:	e8 56 00 00 00       	call   8003b7 <vcprintf>
	cprintf("\n");
  800361:	c7 04 24 95 2b 80 00 	movl   $0x802b95,(%esp)
  800368:	e8 9b 00 00 00       	call   800408 <cprintf>
  80036d:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800370:	cc                   	int3   
  800371:	eb fd                	jmp    800370 <_panic+0x43>

00800373 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800373:	55                   	push   %ebp
  800374:	89 e5                	mov    %esp,%ebp
  800376:	53                   	push   %ebx
  800377:	83 ec 04             	sub    $0x4,%esp
  80037a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80037d:	8b 13                	mov    (%ebx),%edx
  80037f:	8d 42 01             	lea    0x1(%edx),%eax
  800382:	89 03                	mov    %eax,(%ebx)
  800384:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800387:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80038b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800390:	74 09                	je     80039b <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800392:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800396:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800399:	c9                   	leave  
  80039a:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80039b:	83 ec 08             	sub    $0x8,%esp
  80039e:	68 ff 00 00 00       	push   $0xff
  8003a3:	8d 43 08             	lea    0x8(%ebx),%eax
  8003a6:	50                   	push   %eax
  8003a7:	e8 b8 0a 00 00       	call   800e64 <sys_cputs>
		b->idx = 0;
  8003ac:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8003b2:	83 c4 10             	add    $0x10,%esp
  8003b5:	eb db                	jmp    800392 <putch+0x1f>

008003b7 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003b7:	55                   	push   %ebp
  8003b8:	89 e5                	mov    %esp,%ebp
  8003ba:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003c0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003c7:	00 00 00 
	b.cnt = 0;
  8003ca:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003d1:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003d4:	ff 75 0c             	pushl  0xc(%ebp)
  8003d7:	ff 75 08             	pushl  0x8(%ebp)
  8003da:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003e0:	50                   	push   %eax
  8003e1:	68 73 03 80 00       	push   $0x800373
  8003e6:	e8 4a 01 00 00       	call   800535 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8003eb:	83 c4 08             	add    $0x8,%esp
  8003ee:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8003f4:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8003fa:	50                   	push   %eax
  8003fb:	e8 64 0a 00 00       	call   800e64 <sys_cputs>

	return b.cnt;
}
  800400:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800406:	c9                   	leave  
  800407:	c3                   	ret    

00800408 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800408:	55                   	push   %ebp
  800409:	89 e5                	mov    %esp,%ebp
  80040b:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80040e:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800411:	50                   	push   %eax
  800412:	ff 75 08             	pushl  0x8(%ebp)
  800415:	e8 9d ff ff ff       	call   8003b7 <vcprintf>
	va_end(ap);

	return cnt;
}
  80041a:	c9                   	leave  
  80041b:	c3                   	ret    

0080041c <printnum>:


static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80041c:	55                   	push   %ebp
  80041d:	89 e5                	mov    %esp,%ebp
  80041f:	57                   	push   %edi
  800420:	56                   	push   %esi
  800421:	53                   	push   %ebx
  800422:	83 ec 1c             	sub    $0x1c,%esp
  800425:	89 c6                	mov    %eax,%esi
  800427:	89 d7                	mov    %edx,%edi
  800429:	8b 45 08             	mov    0x8(%ebp),%eax
  80042c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80042f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800432:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800435:	8b 45 10             	mov    0x10(%ebp),%eax
  800438:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	// to support '-'
	if(padc == '-'){
  80043b:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80043f:	74 2c                	je     80046d <printnum+0x51>
		while (--width > 0)
			putch(' ', putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800441:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800444:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80044b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80044e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800451:	39 c2                	cmp    %eax,%edx
  800453:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800456:	73 43                	jae    80049b <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800458:	83 eb 01             	sub    $0x1,%ebx
  80045b:	85 db                	test   %ebx,%ebx
  80045d:	7e 6c                	jle    8004cb <printnum+0xaf>
			putch(padc, putdat);
  80045f:	83 ec 08             	sub    $0x8,%esp
  800462:	57                   	push   %edi
  800463:	ff 75 18             	pushl  0x18(%ebp)
  800466:	ff d6                	call   *%esi
  800468:	83 c4 10             	add    $0x10,%esp
  80046b:	eb eb                	jmp    800458 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80046d:	83 ec 0c             	sub    $0xc,%esp
  800470:	6a 20                	push   $0x20
  800472:	6a 00                	push   $0x0
  800474:	50                   	push   %eax
  800475:	ff 75 e4             	pushl  -0x1c(%ebp)
  800478:	ff 75 e0             	pushl  -0x20(%ebp)
  80047b:	89 fa                	mov    %edi,%edx
  80047d:	89 f0                	mov    %esi,%eax
  80047f:	e8 98 ff ff ff       	call   80041c <printnum>
		while (--width > 0)
  800484:	83 c4 20             	add    $0x20,%esp
  800487:	83 eb 01             	sub    $0x1,%ebx
  80048a:	85 db                	test   %ebx,%ebx
  80048c:	7e 65                	jle    8004f3 <printnum+0xd7>
			putch(' ', putdat);
  80048e:	83 ec 08             	sub    $0x8,%esp
  800491:	57                   	push   %edi
  800492:	6a 20                	push   $0x20
  800494:	ff d6                	call   *%esi
  800496:	83 c4 10             	add    $0x10,%esp
  800499:	eb ec                	jmp    800487 <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80049b:	83 ec 0c             	sub    $0xc,%esp
  80049e:	ff 75 18             	pushl  0x18(%ebp)
  8004a1:	83 eb 01             	sub    $0x1,%ebx
  8004a4:	53                   	push   %ebx
  8004a5:	50                   	push   %eax
  8004a6:	83 ec 08             	sub    $0x8,%esp
  8004a9:	ff 75 dc             	pushl  -0x24(%ebp)
  8004ac:	ff 75 d8             	pushl  -0x28(%ebp)
  8004af:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004b2:	ff 75 e0             	pushl  -0x20(%ebp)
  8004b5:	e8 56 1f 00 00       	call   802410 <__udivdi3>
  8004ba:	83 c4 18             	add    $0x18,%esp
  8004bd:	52                   	push   %edx
  8004be:	50                   	push   %eax
  8004bf:	89 fa                	mov    %edi,%edx
  8004c1:	89 f0                	mov    %esi,%eax
  8004c3:	e8 54 ff ff ff       	call   80041c <printnum>
  8004c8:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004cb:	83 ec 08             	sub    $0x8,%esp
  8004ce:	57                   	push   %edi
  8004cf:	83 ec 04             	sub    $0x4,%esp
  8004d2:	ff 75 dc             	pushl  -0x24(%ebp)
  8004d5:	ff 75 d8             	pushl  -0x28(%ebp)
  8004d8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004db:	ff 75 e0             	pushl  -0x20(%ebp)
  8004de:	e8 3d 20 00 00       	call   802520 <__umoddi3>
  8004e3:	83 c4 14             	add    $0x14,%esp
  8004e6:	0f be 80 db 27 80 00 	movsbl 0x8027db(%eax),%eax
  8004ed:	50                   	push   %eax
  8004ee:	ff d6                	call   *%esi
  8004f0:	83 c4 10             	add    $0x10,%esp
}
  8004f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004f6:	5b                   	pop    %ebx
  8004f7:	5e                   	pop    %esi
  8004f8:	5f                   	pop    %edi
  8004f9:	5d                   	pop    %ebp
  8004fa:	c3                   	ret    

008004fb <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004fb:	55                   	push   %ebp
  8004fc:	89 e5                	mov    %esp,%ebp
  8004fe:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800501:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800505:	8b 10                	mov    (%eax),%edx
  800507:	3b 50 04             	cmp    0x4(%eax),%edx
  80050a:	73 0a                	jae    800516 <sprintputch+0x1b>
		*b->buf++ = ch;
  80050c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80050f:	89 08                	mov    %ecx,(%eax)
  800511:	8b 45 08             	mov    0x8(%ebp),%eax
  800514:	88 02                	mov    %al,(%edx)
}
  800516:	5d                   	pop    %ebp
  800517:	c3                   	ret    

00800518 <printfmt>:
{
  800518:	55                   	push   %ebp
  800519:	89 e5                	mov    %esp,%ebp
  80051b:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80051e:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800521:	50                   	push   %eax
  800522:	ff 75 10             	pushl  0x10(%ebp)
  800525:	ff 75 0c             	pushl  0xc(%ebp)
  800528:	ff 75 08             	pushl  0x8(%ebp)
  80052b:	e8 05 00 00 00       	call   800535 <vprintfmt>
}
  800530:	83 c4 10             	add    $0x10,%esp
  800533:	c9                   	leave  
  800534:	c3                   	ret    

00800535 <vprintfmt>:
{
  800535:	55                   	push   %ebp
  800536:	89 e5                	mov    %esp,%ebp
  800538:	57                   	push   %edi
  800539:	56                   	push   %esi
  80053a:	53                   	push   %ebx
  80053b:	83 ec 3c             	sub    $0x3c,%esp
  80053e:	8b 75 08             	mov    0x8(%ebp),%esi
  800541:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800544:	8b 7d 10             	mov    0x10(%ebp),%edi
  800547:	e9 1e 04 00 00       	jmp    80096a <vprintfmt+0x435>
		posflag = 0;
  80054c:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
		padc = ' ';
  800553:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800557:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  80055e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800565:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80056c:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  800573:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800578:	8d 47 01             	lea    0x1(%edi),%eax
  80057b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80057e:	0f b6 17             	movzbl (%edi),%edx
  800581:	8d 42 dd             	lea    -0x23(%edx),%eax
  800584:	3c 55                	cmp    $0x55,%al
  800586:	0f 87 d9 04 00 00    	ja     800a65 <vprintfmt+0x530>
  80058c:	0f b6 c0             	movzbl %al,%eax
  80058f:	ff 24 85 c0 29 80 00 	jmp    *0x8029c0(,%eax,4)
  800596:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800599:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80059d:	eb d9                	jmp    800578 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80059f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posflag = 1;
  8005a2:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  8005a9:	eb cd                	jmp    800578 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8005ab:	0f b6 d2             	movzbl %dl,%edx
  8005ae:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8005b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8005b6:	89 75 08             	mov    %esi,0x8(%ebp)
  8005b9:	eb 0c                	jmp    8005c7 <vprintfmt+0x92>
		switch (ch = *(unsigned char *) fmt++) {
  8005bb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8005be:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  8005c2:	eb b4                	jmp    800578 <vprintfmt+0x43>
			for (precision = 0; ; ++fmt) {
  8005c4:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8005c7:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8005ca:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8005ce:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8005d1:	8d 72 d0             	lea    -0x30(%edx),%esi
  8005d4:	83 fe 09             	cmp    $0x9,%esi
  8005d7:	76 eb                	jbe    8005c4 <vprintfmt+0x8f>
  8005d9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005dc:	8b 75 08             	mov    0x8(%ebp),%esi
  8005df:	eb 14                	jmp    8005f5 <vprintfmt+0xc0>
			precision = va_arg(ap, int);
  8005e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e4:	8b 00                	mov    (%eax),%eax
  8005e6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ec:	8d 40 04             	lea    0x4(%eax),%eax
  8005ef:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005f2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8005f5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005f9:	0f 89 79 ff ff ff    	jns    800578 <vprintfmt+0x43>
				width = precision, precision = -1;
  8005ff:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800602:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800605:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80060c:	e9 67 ff ff ff       	jmp    800578 <vprintfmt+0x43>
  800611:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800614:	85 c0                	test   %eax,%eax
  800616:	0f 48 c1             	cmovs  %ecx,%eax
  800619:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80061c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80061f:	e9 54 ff ff ff       	jmp    800578 <vprintfmt+0x43>
  800624:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800627:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80062e:	e9 45 ff ff ff       	jmp    800578 <vprintfmt+0x43>
			lflag++;
  800633:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800637:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80063a:	e9 39 ff ff ff       	jmp    800578 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  80063f:	8b 45 14             	mov    0x14(%ebp),%eax
  800642:	8d 78 04             	lea    0x4(%eax),%edi
  800645:	83 ec 08             	sub    $0x8,%esp
  800648:	53                   	push   %ebx
  800649:	ff 30                	pushl  (%eax)
  80064b:	ff d6                	call   *%esi
			break;
  80064d:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800650:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800653:	e9 0f 03 00 00       	jmp    800967 <vprintfmt+0x432>
			err = va_arg(ap, int);
  800658:	8b 45 14             	mov    0x14(%ebp),%eax
  80065b:	8d 78 04             	lea    0x4(%eax),%edi
  80065e:	8b 00                	mov    (%eax),%eax
  800660:	99                   	cltd   
  800661:	31 d0                	xor    %edx,%eax
  800663:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800665:	83 f8 0f             	cmp    $0xf,%eax
  800668:	7f 23                	jg     80068d <vprintfmt+0x158>
  80066a:	8b 14 85 20 2b 80 00 	mov    0x802b20(,%eax,4),%edx
  800671:	85 d2                	test   %edx,%edx
  800673:	74 18                	je     80068d <vprintfmt+0x158>
				printfmt(putch, putdat, "%s", p);
  800675:	52                   	push   %edx
  800676:	68 3e 2e 80 00       	push   $0x802e3e
  80067b:	53                   	push   %ebx
  80067c:	56                   	push   %esi
  80067d:	e8 96 fe ff ff       	call   800518 <printfmt>
  800682:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800685:	89 7d 14             	mov    %edi,0x14(%ebp)
  800688:	e9 da 02 00 00       	jmp    800967 <vprintfmt+0x432>
				printfmt(putch, putdat, "error %d", err);
  80068d:	50                   	push   %eax
  80068e:	68 f3 27 80 00       	push   $0x8027f3
  800693:	53                   	push   %ebx
  800694:	56                   	push   %esi
  800695:	e8 7e fe ff ff       	call   800518 <printfmt>
  80069a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80069d:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8006a0:	e9 c2 02 00 00       	jmp    800967 <vprintfmt+0x432>
			if ((p = va_arg(ap, char *)) == NULL)
  8006a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a8:	83 c0 04             	add    $0x4,%eax
  8006ab:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8006ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b1:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8006b3:	85 c9                	test   %ecx,%ecx
  8006b5:	b8 ec 27 80 00       	mov    $0x8027ec,%eax
  8006ba:	0f 45 c1             	cmovne %ecx,%eax
  8006bd:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8006c0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006c4:	7e 06                	jle    8006cc <vprintfmt+0x197>
  8006c6:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8006ca:	75 0d                	jne    8006d9 <vprintfmt+0x1a4>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006cc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8006cf:	89 c7                	mov    %eax,%edi
  8006d1:	03 45 e0             	add    -0x20(%ebp),%eax
  8006d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006d7:	eb 53                	jmp    80072c <vprintfmt+0x1f7>
  8006d9:	83 ec 08             	sub    $0x8,%esp
  8006dc:	ff 75 d8             	pushl  -0x28(%ebp)
  8006df:	50                   	push   %eax
  8006e0:	e8 28 04 00 00       	call   800b0d <strnlen>
  8006e5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8006e8:	29 c1                	sub    %eax,%ecx
  8006ea:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  8006ed:	83 c4 10             	add    $0x10,%esp
  8006f0:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8006f2:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8006f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8006f9:	eb 0f                	jmp    80070a <vprintfmt+0x1d5>
					putch(padc, putdat);
  8006fb:	83 ec 08             	sub    $0x8,%esp
  8006fe:	53                   	push   %ebx
  8006ff:	ff 75 e0             	pushl  -0x20(%ebp)
  800702:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800704:	83 ef 01             	sub    $0x1,%edi
  800707:	83 c4 10             	add    $0x10,%esp
  80070a:	85 ff                	test   %edi,%edi
  80070c:	7f ed                	jg     8006fb <vprintfmt+0x1c6>
  80070e:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  800711:	85 c9                	test   %ecx,%ecx
  800713:	b8 00 00 00 00       	mov    $0x0,%eax
  800718:	0f 49 c1             	cmovns %ecx,%eax
  80071b:	29 c1                	sub    %eax,%ecx
  80071d:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800720:	eb aa                	jmp    8006cc <vprintfmt+0x197>
					putch(ch, putdat);
  800722:	83 ec 08             	sub    $0x8,%esp
  800725:	53                   	push   %ebx
  800726:	52                   	push   %edx
  800727:	ff d6                	call   *%esi
  800729:	83 c4 10             	add    $0x10,%esp
  80072c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80072f:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800731:	83 c7 01             	add    $0x1,%edi
  800734:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800738:	0f be d0             	movsbl %al,%edx
  80073b:	85 d2                	test   %edx,%edx
  80073d:	74 4b                	je     80078a <vprintfmt+0x255>
  80073f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800743:	78 06                	js     80074b <vprintfmt+0x216>
  800745:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800749:	78 1e                	js     800769 <vprintfmt+0x234>
				if (altflag && (ch < ' ' || ch > '~'))
  80074b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80074f:	74 d1                	je     800722 <vprintfmt+0x1ed>
  800751:	0f be c0             	movsbl %al,%eax
  800754:	83 e8 20             	sub    $0x20,%eax
  800757:	83 f8 5e             	cmp    $0x5e,%eax
  80075a:	76 c6                	jbe    800722 <vprintfmt+0x1ed>
					putch('?', putdat);
  80075c:	83 ec 08             	sub    $0x8,%esp
  80075f:	53                   	push   %ebx
  800760:	6a 3f                	push   $0x3f
  800762:	ff d6                	call   *%esi
  800764:	83 c4 10             	add    $0x10,%esp
  800767:	eb c3                	jmp    80072c <vprintfmt+0x1f7>
  800769:	89 cf                	mov    %ecx,%edi
  80076b:	eb 0e                	jmp    80077b <vprintfmt+0x246>
				putch(' ', putdat);
  80076d:	83 ec 08             	sub    $0x8,%esp
  800770:	53                   	push   %ebx
  800771:	6a 20                	push   $0x20
  800773:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800775:	83 ef 01             	sub    $0x1,%edi
  800778:	83 c4 10             	add    $0x10,%esp
  80077b:	85 ff                	test   %edi,%edi
  80077d:	7f ee                	jg     80076d <vprintfmt+0x238>
			if ((p = va_arg(ap, char *)) == NULL)
  80077f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800782:	89 45 14             	mov    %eax,0x14(%ebp)
  800785:	e9 dd 01 00 00       	jmp    800967 <vprintfmt+0x432>
  80078a:	89 cf                	mov    %ecx,%edi
  80078c:	eb ed                	jmp    80077b <vprintfmt+0x246>
	if (lflag >= 2)
  80078e:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800792:	7f 21                	jg     8007b5 <vprintfmt+0x280>
	else if (lflag)
  800794:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800798:	74 6a                	je     800804 <vprintfmt+0x2cf>
		return va_arg(*ap, long);
  80079a:	8b 45 14             	mov    0x14(%ebp),%eax
  80079d:	8b 00                	mov    (%eax),%eax
  80079f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a2:	89 c1                	mov    %eax,%ecx
  8007a4:	c1 f9 1f             	sar    $0x1f,%ecx
  8007a7:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8007aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ad:	8d 40 04             	lea    0x4(%eax),%eax
  8007b0:	89 45 14             	mov    %eax,0x14(%ebp)
  8007b3:	eb 17                	jmp    8007cc <vprintfmt+0x297>
		return va_arg(*ap, long long);
  8007b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b8:	8b 50 04             	mov    0x4(%eax),%edx
  8007bb:	8b 00                	mov    (%eax),%eax
  8007bd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007c0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c6:	8d 40 08             	lea    0x8(%eax),%eax
  8007c9:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8007cc:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  8007cf:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  8007d4:	85 d2                	test   %edx,%edx
  8007d6:	0f 89 5c 01 00 00    	jns    800938 <vprintfmt+0x403>
				putch('-', putdat);
  8007dc:	83 ec 08             	sub    $0x8,%esp
  8007df:	53                   	push   %ebx
  8007e0:	6a 2d                	push   $0x2d
  8007e2:	ff d6                	call   *%esi
				num = -(long long) num;
  8007e4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007e7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8007ea:	f7 d8                	neg    %eax
  8007ec:	83 d2 00             	adc    $0x0,%edx
  8007ef:	f7 da                	neg    %edx
  8007f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007f4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007f7:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8007fa:	bf 0a 00 00 00       	mov    $0xa,%edi
  8007ff:	e9 45 01 00 00       	jmp    800949 <vprintfmt+0x414>
		return va_arg(*ap, int);
  800804:	8b 45 14             	mov    0x14(%ebp),%eax
  800807:	8b 00                	mov    (%eax),%eax
  800809:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80080c:	89 c1                	mov    %eax,%ecx
  80080e:	c1 f9 1f             	sar    $0x1f,%ecx
  800811:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800814:	8b 45 14             	mov    0x14(%ebp),%eax
  800817:	8d 40 04             	lea    0x4(%eax),%eax
  80081a:	89 45 14             	mov    %eax,0x14(%ebp)
  80081d:	eb ad                	jmp    8007cc <vprintfmt+0x297>
	if (lflag >= 2)
  80081f:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800823:	7f 29                	jg     80084e <vprintfmt+0x319>
	else if (lflag)
  800825:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800829:	74 44                	je     80086f <vprintfmt+0x33a>
		return va_arg(*ap, unsigned long);
  80082b:	8b 45 14             	mov    0x14(%ebp),%eax
  80082e:	8b 00                	mov    (%eax),%eax
  800830:	ba 00 00 00 00       	mov    $0x0,%edx
  800835:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800838:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80083b:	8b 45 14             	mov    0x14(%ebp),%eax
  80083e:	8d 40 04             	lea    0x4(%eax),%eax
  800841:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800844:	bf 0a 00 00 00       	mov    $0xa,%edi
  800849:	e9 ea 00 00 00       	jmp    800938 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  80084e:	8b 45 14             	mov    0x14(%ebp),%eax
  800851:	8b 50 04             	mov    0x4(%eax),%edx
  800854:	8b 00                	mov    (%eax),%eax
  800856:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800859:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80085c:	8b 45 14             	mov    0x14(%ebp),%eax
  80085f:	8d 40 08             	lea    0x8(%eax),%eax
  800862:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800865:	bf 0a 00 00 00       	mov    $0xa,%edi
  80086a:	e9 c9 00 00 00       	jmp    800938 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  80086f:	8b 45 14             	mov    0x14(%ebp),%eax
  800872:	8b 00                	mov    (%eax),%eax
  800874:	ba 00 00 00 00       	mov    $0x0,%edx
  800879:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80087c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80087f:	8b 45 14             	mov    0x14(%ebp),%eax
  800882:	8d 40 04             	lea    0x4(%eax),%eax
  800885:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800888:	bf 0a 00 00 00       	mov    $0xa,%edi
  80088d:	e9 a6 00 00 00       	jmp    800938 <vprintfmt+0x403>
			putch('0', putdat);
  800892:	83 ec 08             	sub    $0x8,%esp
  800895:	53                   	push   %ebx
  800896:	6a 30                	push   $0x30
  800898:	ff d6                	call   *%esi
	if (lflag >= 2)
  80089a:	83 c4 10             	add    $0x10,%esp
  80089d:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8008a1:	7f 26                	jg     8008c9 <vprintfmt+0x394>
	else if (lflag)
  8008a3:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8008a7:	74 3e                	je     8008e7 <vprintfmt+0x3b2>
		return va_arg(*ap, unsigned long);
  8008a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ac:	8b 00                	mov    (%eax),%eax
  8008ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8008b3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008b6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008bc:	8d 40 04             	lea    0x4(%eax),%eax
  8008bf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8008c2:	bf 08 00 00 00       	mov    $0x8,%edi
  8008c7:	eb 6f                	jmp    800938 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  8008c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cc:	8b 50 04             	mov    0x4(%eax),%edx
  8008cf:	8b 00                	mov    (%eax),%eax
  8008d1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008d4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008da:	8d 40 08             	lea    0x8(%eax),%eax
  8008dd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8008e0:	bf 08 00 00 00       	mov    $0x8,%edi
  8008e5:	eb 51                	jmp    800938 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  8008e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ea:	8b 00                	mov    (%eax),%eax
  8008ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8008f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008f4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008fa:	8d 40 04             	lea    0x4(%eax),%eax
  8008fd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800900:	bf 08 00 00 00       	mov    $0x8,%edi
  800905:	eb 31                	jmp    800938 <vprintfmt+0x403>
			putch('0', putdat);
  800907:	83 ec 08             	sub    $0x8,%esp
  80090a:	53                   	push   %ebx
  80090b:	6a 30                	push   $0x30
  80090d:	ff d6                	call   *%esi
			putch('x', putdat);
  80090f:	83 c4 08             	add    $0x8,%esp
  800912:	53                   	push   %ebx
  800913:	6a 78                	push   $0x78
  800915:	ff d6                	call   *%esi
			num = (unsigned long long)
  800917:	8b 45 14             	mov    0x14(%ebp),%eax
  80091a:	8b 00                	mov    (%eax),%eax
  80091c:	ba 00 00 00 00       	mov    $0x0,%edx
  800921:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800924:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800927:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80092a:	8b 45 14             	mov    0x14(%ebp),%eax
  80092d:	8d 40 04             	lea    0x4(%eax),%eax
  800930:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800933:	bf 10 00 00 00       	mov    $0x10,%edi
			if(posflag)
  800938:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80093c:	74 0b                	je     800949 <vprintfmt+0x414>
				putch('+', putdat);
  80093e:	83 ec 08             	sub    $0x8,%esp
  800941:	53                   	push   %ebx
  800942:	6a 2b                	push   $0x2b
  800944:	ff d6                	call   *%esi
  800946:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  800949:	83 ec 0c             	sub    $0xc,%esp
  80094c:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800950:	50                   	push   %eax
  800951:	ff 75 e0             	pushl  -0x20(%ebp)
  800954:	57                   	push   %edi
  800955:	ff 75 dc             	pushl  -0x24(%ebp)
  800958:	ff 75 d8             	pushl  -0x28(%ebp)
  80095b:	89 da                	mov    %ebx,%edx
  80095d:	89 f0                	mov    %esi,%eax
  80095f:	e8 b8 fa ff ff       	call   80041c <printnum>
			break;
  800964:	83 c4 20             	add    $0x20,%esp
			char* cp = va_arg(ap, char *);
  800967:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80096a:	83 c7 01             	add    $0x1,%edi
  80096d:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800971:	83 f8 25             	cmp    $0x25,%eax
  800974:	0f 84 d2 fb ff ff    	je     80054c <vprintfmt+0x17>
			if (ch == '\0')
  80097a:	85 c0                	test   %eax,%eax
  80097c:	0f 84 03 01 00 00    	je     800a85 <vprintfmt+0x550>
			putch(ch, putdat);
  800982:	83 ec 08             	sub    $0x8,%esp
  800985:	53                   	push   %ebx
  800986:	50                   	push   %eax
  800987:	ff d6                	call   *%esi
  800989:	83 c4 10             	add    $0x10,%esp
  80098c:	eb dc                	jmp    80096a <vprintfmt+0x435>
	if (lflag >= 2)
  80098e:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800992:	7f 29                	jg     8009bd <vprintfmt+0x488>
	else if (lflag)
  800994:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800998:	74 44                	je     8009de <vprintfmt+0x4a9>
		return va_arg(*ap, unsigned long);
  80099a:	8b 45 14             	mov    0x14(%ebp),%eax
  80099d:	8b 00                	mov    (%eax),%eax
  80099f:	ba 00 00 00 00       	mov    $0x0,%edx
  8009a4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009a7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ad:	8d 40 04             	lea    0x4(%eax),%eax
  8009b0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009b3:	bf 10 00 00 00       	mov    $0x10,%edi
  8009b8:	e9 7b ff ff ff       	jmp    800938 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  8009bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c0:	8b 50 04             	mov    0x4(%eax),%edx
  8009c3:	8b 00                	mov    (%eax),%eax
  8009c5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009c8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ce:	8d 40 08             	lea    0x8(%eax),%eax
  8009d1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009d4:	bf 10 00 00 00       	mov    $0x10,%edi
  8009d9:	e9 5a ff ff ff       	jmp    800938 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  8009de:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e1:	8b 00                	mov    (%eax),%eax
  8009e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8009e8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009eb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f1:	8d 40 04             	lea    0x4(%eax),%eax
  8009f4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009f7:	bf 10 00 00 00       	mov    $0x10,%edi
  8009fc:	e9 37 ff ff ff       	jmp    800938 <vprintfmt+0x403>
			char* cp = va_arg(ap, char *);
  800a01:	8b 45 14             	mov    0x14(%ebp),%eax
  800a04:	8d 78 04             	lea    0x4(%eax),%edi
  800a07:	8b 00                	mov    (%eax),%eax
    			if (cp == NULL) {
  800a09:	85 c0                	test   %eax,%eax
  800a0b:	74 2c                	je     800a39 <vprintfmt+0x504>
    			*cp = *(int *)putdat;
  800a0d:	8b 13                	mov    (%ebx),%edx
  800a0f:	88 10                	mov    %dl,(%eax)
			char* cp = va_arg(ap, char *);
  800a11:	89 7d 14             	mov    %edi,0x14(%ebp)
    			if ((*(int *) putdat) > 127)
  800a14:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  800a17:	0f 8e 4a ff ff ff    	jle    800967 <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", overflow_error);
  800a1d:	68 48 29 80 00       	push   $0x802948
  800a22:	68 3e 2e 80 00       	push   $0x802e3e
  800a27:	53                   	push   %ebx
  800a28:	56                   	push   %esi
  800a29:	e8 ea fa ff ff       	call   800518 <printfmt>
  800a2e:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  800a31:	89 7d 14             	mov    %edi,0x14(%ebp)
  800a34:	e9 2e ff ff ff       	jmp    800967 <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", null_error);
  800a39:	68 10 29 80 00       	push   $0x802910
  800a3e:	68 3e 2e 80 00       	push   $0x802e3e
  800a43:	53                   	push   %ebx
  800a44:	56                   	push   %esi
  800a45:	e8 ce fa ff ff       	call   800518 <printfmt>
        		break;
  800a4a:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  800a4d:	89 7d 14             	mov    %edi,0x14(%ebp)
        		break;
  800a50:	e9 12 ff ff ff       	jmp    800967 <vprintfmt+0x432>
			putch(ch, putdat);
  800a55:	83 ec 08             	sub    $0x8,%esp
  800a58:	53                   	push   %ebx
  800a59:	6a 25                	push   $0x25
  800a5b:	ff d6                	call   *%esi
			break;
  800a5d:	83 c4 10             	add    $0x10,%esp
  800a60:	e9 02 ff ff ff       	jmp    800967 <vprintfmt+0x432>
			putch('%', putdat);
  800a65:	83 ec 08             	sub    $0x8,%esp
  800a68:	53                   	push   %ebx
  800a69:	6a 25                	push   $0x25
  800a6b:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a6d:	83 c4 10             	add    $0x10,%esp
  800a70:	89 f8                	mov    %edi,%eax
  800a72:	eb 03                	jmp    800a77 <vprintfmt+0x542>
  800a74:	83 e8 01             	sub    $0x1,%eax
  800a77:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800a7b:	75 f7                	jne    800a74 <vprintfmt+0x53f>
  800a7d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a80:	e9 e2 fe ff ff       	jmp    800967 <vprintfmt+0x432>
}
  800a85:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a88:	5b                   	pop    %ebx
  800a89:	5e                   	pop    %esi
  800a8a:	5f                   	pop    %edi
  800a8b:	5d                   	pop    %ebp
  800a8c:	c3                   	ret    

00800a8d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a8d:	55                   	push   %ebp
  800a8e:	89 e5                	mov    %esp,%ebp
  800a90:	83 ec 18             	sub    $0x18,%esp
  800a93:	8b 45 08             	mov    0x8(%ebp),%eax
  800a96:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a99:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a9c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800aa0:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800aa3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800aaa:	85 c0                	test   %eax,%eax
  800aac:	74 26                	je     800ad4 <vsnprintf+0x47>
  800aae:	85 d2                	test   %edx,%edx
  800ab0:	7e 22                	jle    800ad4 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ab2:	ff 75 14             	pushl  0x14(%ebp)
  800ab5:	ff 75 10             	pushl  0x10(%ebp)
  800ab8:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800abb:	50                   	push   %eax
  800abc:	68 fb 04 80 00       	push   $0x8004fb
  800ac1:	e8 6f fa ff ff       	call   800535 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800ac6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ac9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800acc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800acf:	83 c4 10             	add    $0x10,%esp
}
  800ad2:	c9                   	leave  
  800ad3:	c3                   	ret    
		return -E_INVAL;
  800ad4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ad9:	eb f7                	jmp    800ad2 <vsnprintf+0x45>

00800adb <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800adb:	55                   	push   %ebp
  800adc:	89 e5                	mov    %esp,%ebp
  800ade:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ae1:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800ae4:	50                   	push   %eax
  800ae5:	ff 75 10             	pushl  0x10(%ebp)
  800ae8:	ff 75 0c             	pushl  0xc(%ebp)
  800aeb:	ff 75 08             	pushl  0x8(%ebp)
  800aee:	e8 9a ff ff ff       	call   800a8d <vsnprintf>
	va_end(ap);

	return rc;
}
  800af3:	c9                   	leave  
  800af4:	c3                   	ret    

00800af5 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800af5:	55                   	push   %ebp
  800af6:	89 e5                	mov    %esp,%ebp
  800af8:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800afb:	b8 00 00 00 00       	mov    $0x0,%eax
  800b00:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800b04:	74 05                	je     800b0b <strlen+0x16>
		n++;
  800b06:	83 c0 01             	add    $0x1,%eax
  800b09:	eb f5                	jmp    800b00 <strlen+0xb>
	return n;
}
  800b0b:	5d                   	pop    %ebp
  800b0c:	c3                   	ret    

00800b0d <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800b0d:	55                   	push   %ebp
  800b0e:	89 e5                	mov    %esp,%ebp
  800b10:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b13:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b16:	ba 00 00 00 00       	mov    $0x0,%edx
  800b1b:	39 c2                	cmp    %eax,%edx
  800b1d:	74 0d                	je     800b2c <strnlen+0x1f>
  800b1f:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800b23:	74 05                	je     800b2a <strnlen+0x1d>
		n++;
  800b25:	83 c2 01             	add    $0x1,%edx
  800b28:	eb f1                	jmp    800b1b <strnlen+0xe>
  800b2a:	89 d0                	mov    %edx,%eax
	return n;
}
  800b2c:	5d                   	pop    %ebp
  800b2d:	c3                   	ret    

00800b2e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b2e:	55                   	push   %ebp
  800b2f:	89 e5                	mov    %esp,%ebp
  800b31:	53                   	push   %ebx
  800b32:	8b 45 08             	mov    0x8(%ebp),%eax
  800b35:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800b38:	ba 00 00 00 00       	mov    $0x0,%edx
  800b3d:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800b41:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800b44:	83 c2 01             	add    $0x1,%edx
  800b47:	84 c9                	test   %cl,%cl
  800b49:	75 f2                	jne    800b3d <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800b4b:	5b                   	pop    %ebx
  800b4c:	5d                   	pop    %ebp
  800b4d:	c3                   	ret    

00800b4e <strcat>:

char *
strcat(char *dst, const char *src)
{
  800b4e:	55                   	push   %ebp
  800b4f:	89 e5                	mov    %esp,%ebp
  800b51:	53                   	push   %ebx
  800b52:	83 ec 10             	sub    $0x10,%esp
  800b55:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800b58:	53                   	push   %ebx
  800b59:	e8 97 ff ff ff       	call   800af5 <strlen>
  800b5e:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800b61:	ff 75 0c             	pushl  0xc(%ebp)
  800b64:	01 d8                	add    %ebx,%eax
  800b66:	50                   	push   %eax
  800b67:	e8 c2 ff ff ff       	call   800b2e <strcpy>
	return dst;
}
  800b6c:	89 d8                	mov    %ebx,%eax
  800b6e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b71:	c9                   	leave  
  800b72:	c3                   	ret    

00800b73 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b73:	55                   	push   %ebp
  800b74:	89 e5                	mov    %esp,%ebp
  800b76:	56                   	push   %esi
  800b77:	53                   	push   %ebx
  800b78:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b7e:	89 c6                	mov    %eax,%esi
  800b80:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b83:	89 c2                	mov    %eax,%edx
  800b85:	39 f2                	cmp    %esi,%edx
  800b87:	74 11                	je     800b9a <strncpy+0x27>
		*dst++ = *src;
  800b89:	83 c2 01             	add    $0x1,%edx
  800b8c:	0f b6 19             	movzbl (%ecx),%ebx
  800b8f:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b92:	80 fb 01             	cmp    $0x1,%bl
  800b95:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800b98:	eb eb                	jmp    800b85 <strncpy+0x12>
	}
	return ret;
}
  800b9a:	5b                   	pop    %ebx
  800b9b:	5e                   	pop    %esi
  800b9c:	5d                   	pop    %ebp
  800b9d:	c3                   	ret    

00800b9e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b9e:	55                   	push   %ebp
  800b9f:	89 e5                	mov    %esp,%ebp
  800ba1:	56                   	push   %esi
  800ba2:	53                   	push   %ebx
  800ba3:	8b 75 08             	mov    0x8(%ebp),%esi
  800ba6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ba9:	8b 55 10             	mov    0x10(%ebp),%edx
  800bac:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800bae:	85 d2                	test   %edx,%edx
  800bb0:	74 21                	je     800bd3 <strlcpy+0x35>
  800bb2:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800bb6:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800bb8:	39 c2                	cmp    %eax,%edx
  800bba:	74 14                	je     800bd0 <strlcpy+0x32>
  800bbc:	0f b6 19             	movzbl (%ecx),%ebx
  800bbf:	84 db                	test   %bl,%bl
  800bc1:	74 0b                	je     800bce <strlcpy+0x30>
			*dst++ = *src++;
  800bc3:	83 c1 01             	add    $0x1,%ecx
  800bc6:	83 c2 01             	add    $0x1,%edx
  800bc9:	88 5a ff             	mov    %bl,-0x1(%edx)
  800bcc:	eb ea                	jmp    800bb8 <strlcpy+0x1a>
  800bce:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800bd0:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800bd3:	29 f0                	sub    %esi,%eax
}
  800bd5:	5b                   	pop    %ebx
  800bd6:	5e                   	pop    %esi
  800bd7:	5d                   	pop    %ebp
  800bd8:	c3                   	ret    

00800bd9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800bd9:	55                   	push   %ebp
  800bda:	89 e5                	mov    %esp,%ebp
  800bdc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bdf:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800be2:	0f b6 01             	movzbl (%ecx),%eax
  800be5:	84 c0                	test   %al,%al
  800be7:	74 0c                	je     800bf5 <strcmp+0x1c>
  800be9:	3a 02                	cmp    (%edx),%al
  800beb:	75 08                	jne    800bf5 <strcmp+0x1c>
		p++, q++;
  800bed:	83 c1 01             	add    $0x1,%ecx
  800bf0:	83 c2 01             	add    $0x1,%edx
  800bf3:	eb ed                	jmp    800be2 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800bf5:	0f b6 c0             	movzbl %al,%eax
  800bf8:	0f b6 12             	movzbl (%edx),%edx
  800bfb:	29 d0                	sub    %edx,%eax
}
  800bfd:	5d                   	pop    %ebp
  800bfe:	c3                   	ret    

00800bff <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800bff:	55                   	push   %ebp
  800c00:	89 e5                	mov    %esp,%ebp
  800c02:	53                   	push   %ebx
  800c03:	8b 45 08             	mov    0x8(%ebp),%eax
  800c06:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c09:	89 c3                	mov    %eax,%ebx
  800c0b:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800c0e:	eb 06                	jmp    800c16 <strncmp+0x17>
		n--, p++, q++;
  800c10:	83 c0 01             	add    $0x1,%eax
  800c13:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800c16:	39 d8                	cmp    %ebx,%eax
  800c18:	74 16                	je     800c30 <strncmp+0x31>
  800c1a:	0f b6 08             	movzbl (%eax),%ecx
  800c1d:	84 c9                	test   %cl,%cl
  800c1f:	74 04                	je     800c25 <strncmp+0x26>
  800c21:	3a 0a                	cmp    (%edx),%cl
  800c23:	74 eb                	je     800c10 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c25:	0f b6 00             	movzbl (%eax),%eax
  800c28:	0f b6 12             	movzbl (%edx),%edx
  800c2b:	29 d0                	sub    %edx,%eax
}
  800c2d:	5b                   	pop    %ebx
  800c2e:	5d                   	pop    %ebp
  800c2f:	c3                   	ret    
		return 0;
  800c30:	b8 00 00 00 00       	mov    $0x0,%eax
  800c35:	eb f6                	jmp    800c2d <strncmp+0x2e>

00800c37 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c37:	55                   	push   %ebp
  800c38:	89 e5                	mov    %esp,%ebp
  800c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c41:	0f b6 10             	movzbl (%eax),%edx
  800c44:	84 d2                	test   %dl,%dl
  800c46:	74 09                	je     800c51 <strchr+0x1a>
		if (*s == c)
  800c48:	38 ca                	cmp    %cl,%dl
  800c4a:	74 0a                	je     800c56 <strchr+0x1f>
	for (; *s; s++)
  800c4c:	83 c0 01             	add    $0x1,%eax
  800c4f:	eb f0                	jmp    800c41 <strchr+0xa>
			return (char *) s;
	return 0;
  800c51:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c56:	5d                   	pop    %ebp
  800c57:	c3                   	ret    

00800c58 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c58:	55                   	push   %ebp
  800c59:	89 e5                	mov    %esp,%ebp
  800c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c62:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800c65:	38 ca                	cmp    %cl,%dl
  800c67:	74 09                	je     800c72 <strfind+0x1a>
  800c69:	84 d2                	test   %dl,%dl
  800c6b:	74 05                	je     800c72 <strfind+0x1a>
	for (; *s; s++)
  800c6d:	83 c0 01             	add    $0x1,%eax
  800c70:	eb f0                	jmp    800c62 <strfind+0xa>
			break;
	return (char *) s;
}
  800c72:	5d                   	pop    %ebp
  800c73:	c3                   	ret    

00800c74 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c74:	55                   	push   %ebp
  800c75:	89 e5                	mov    %esp,%ebp
  800c77:	57                   	push   %edi
  800c78:	56                   	push   %esi
  800c79:	53                   	push   %ebx
  800c7a:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c7d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c80:	85 c9                	test   %ecx,%ecx
  800c82:	74 31                	je     800cb5 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c84:	89 f8                	mov    %edi,%eax
  800c86:	09 c8                	or     %ecx,%eax
  800c88:	a8 03                	test   $0x3,%al
  800c8a:	75 23                	jne    800caf <memset+0x3b>
		c &= 0xFF;
  800c8c:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c90:	89 d3                	mov    %edx,%ebx
  800c92:	c1 e3 08             	shl    $0x8,%ebx
  800c95:	89 d0                	mov    %edx,%eax
  800c97:	c1 e0 18             	shl    $0x18,%eax
  800c9a:	89 d6                	mov    %edx,%esi
  800c9c:	c1 e6 10             	shl    $0x10,%esi
  800c9f:	09 f0                	or     %esi,%eax
  800ca1:	09 c2                	or     %eax,%edx
  800ca3:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800ca5:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ca8:	89 d0                	mov    %edx,%eax
  800caa:	fc                   	cld    
  800cab:	f3 ab                	rep stos %eax,%es:(%edi)
  800cad:	eb 06                	jmp    800cb5 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800caf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb2:	fc                   	cld    
  800cb3:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800cb5:	89 f8                	mov    %edi,%eax
  800cb7:	5b                   	pop    %ebx
  800cb8:	5e                   	pop    %esi
  800cb9:	5f                   	pop    %edi
  800cba:	5d                   	pop    %ebp
  800cbb:	c3                   	ret    

00800cbc <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800cbc:	55                   	push   %ebp
  800cbd:	89 e5                	mov    %esp,%ebp
  800cbf:	57                   	push   %edi
  800cc0:	56                   	push   %esi
  800cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc4:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cc7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800cca:	39 c6                	cmp    %eax,%esi
  800ccc:	73 32                	jae    800d00 <memmove+0x44>
  800cce:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800cd1:	39 c2                	cmp    %eax,%edx
  800cd3:	76 2b                	jbe    800d00 <memmove+0x44>
		s += n;
		d += n;
  800cd5:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800cd8:	89 fe                	mov    %edi,%esi
  800cda:	09 ce                	or     %ecx,%esi
  800cdc:	09 d6                	or     %edx,%esi
  800cde:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ce4:	75 0e                	jne    800cf4 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ce6:	83 ef 04             	sub    $0x4,%edi
  800ce9:	8d 72 fc             	lea    -0x4(%edx),%esi
  800cec:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800cef:	fd                   	std    
  800cf0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800cf2:	eb 09                	jmp    800cfd <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800cf4:	83 ef 01             	sub    $0x1,%edi
  800cf7:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800cfa:	fd                   	std    
  800cfb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800cfd:	fc                   	cld    
  800cfe:	eb 1a                	jmp    800d1a <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d00:	89 c2                	mov    %eax,%edx
  800d02:	09 ca                	or     %ecx,%edx
  800d04:	09 f2                	or     %esi,%edx
  800d06:	f6 c2 03             	test   $0x3,%dl
  800d09:	75 0a                	jne    800d15 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800d0b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800d0e:	89 c7                	mov    %eax,%edi
  800d10:	fc                   	cld    
  800d11:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d13:	eb 05                	jmp    800d1a <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800d15:	89 c7                	mov    %eax,%edi
  800d17:	fc                   	cld    
  800d18:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800d1a:	5e                   	pop    %esi
  800d1b:	5f                   	pop    %edi
  800d1c:	5d                   	pop    %ebp
  800d1d:	c3                   	ret    

00800d1e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800d1e:	55                   	push   %ebp
  800d1f:	89 e5                	mov    %esp,%ebp
  800d21:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800d24:	ff 75 10             	pushl  0x10(%ebp)
  800d27:	ff 75 0c             	pushl  0xc(%ebp)
  800d2a:	ff 75 08             	pushl  0x8(%ebp)
  800d2d:	e8 8a ff ff ff       	call   800cbc <memmove>
}
  800d32:	c9                   	leave  
  800d33:	c3                   	ret    

00800d34 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800d34:	55                   	push   %ebp
  800d35:	89 e5                	mov    %esp,%ebp
  800d37:	56                   	push   %esi
  800d38:	53                   	push   %ebx
  800d39:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d3f:	89 c6                	mov    %eax,%esi
  800d41:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d44:	39 f0                	cmp    %esi,%eax
  800d46:	74 1c                	je     800d64 <memcmp+0x30>
		if (*s1 != *s2)
  800d48:	0f b6 08             	movzbl (%eax),%ecx
  800d4b:	0f b6 1a             	movzbl (%edx),%ebx
  800d4e:	38 d9                	cmp    %bl,%cl
  800d50:	75 08                	jne    800d5a <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800d52:	83 c0 01             	add    $0x1,%eax
  800d55:	83 c2 01             	add    $0x1,%edx
  800d58:	eb ea                	jmp    800d44 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800d5a:	0f b6 c1             	movzbl %cl,%eax
  800d5d:	0f b6 db             	movzbl %bl,%ebx
  800d60:	29 d8                	sub    %ebx,%eax
  800d62:	eb 05                	jmp    800d69 <memcmp+0x35>
	}

	return 0;
  800d64:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d69:	5b                   	pop    %ebx
  800d6a:	5e                   	pop    %esi
  800d6b:	5d                   	pop    %ebp
  800d6c:	c3                   	ret    

00800d6d <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d6d:	55                   	push   %ebp
  800d6e:	89 e5                	mov    %esp,%ebp
  800d70:	8b 45 08             	mov    0x8(%ebp),%eax
  800d73:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800d76:	89 c2                	mov    %eax,%edx
  800d78:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d7b:	39 d0                	cmp    %edx,%eax
  800d7d:	73 09                	jae    800d88 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d7f:	38 08                	cmp    %cl,(%eax)
  800d81:	74 05                	je     800d88 <memfind+0x1b>
	for (; s < ends; s++)
  800d83:	83 c0 01             	add    $0x1,%eax
  800d86:	eb f3                	jmp    800d7b <memfind+0xe>
			break;
	return (void *) s;
}
  800d88:	5d                   	pop    %ebp
  800d89:	c3                   	ret    

00800d8a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d8a:	55                   	push   %ebp
  800d8b:	89 e5                	mov    %esp,%ebp
  800d8d:	57                   	push   %edi
  800d8e:	56                   	push   %esi
  800d8f:	53                   	push   %ebx
  800d90:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d93:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d96:	eb 03                	jmp    800d9b <strtol+0x11>
		s++;
  800d98:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800d9b:	0f b6 01             	movzbl (%ecx),%eax
  800d9e:	3c 20                	cmp    $0x20,%al
  800da0:	74 f6                	je     800d98 <strtol+0xe>
  800da2:	3c 09                	cmp    $0x9,%al
  800da4:	74 f2                	je     800d98 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800da6:	3c 2b                	cmp    $0x2b,%al
  800da8:	74 2a                	je     800dd4 <strtol+0x4a>
	int neg = 0;
  800daa:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800daf:	3c 2d                	cmp    $0x2d,%al
  800db1:	74 2b                	je     800dde <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800db3:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800db9:	75 0f                	jne    800dca <strtol+0x40>
  800dbb:	80 39 30             	cmpb   $0x30,(%ecx)
  800dbe:	74 28                	je     800de8 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800dc0:	85 db                	test   %ebx,%ebx
  800dc2:	b8 0a 00 00 00       	mov    $0xa,%eax
  800dc7:	0f 44 d8             	cmove  %eax,%ebx
  800dca:	b8 00 00 00 00       	mov    $0x0,%eax
  800dcf:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800dd2:	eb 50                	jmp    800e24 <strtol+0x9a>
		s++;
  800dd4:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800dd7:	bf 00 00 00 00       	mov    $0x0,%edi
  800ddc:	eb d5                	jmp    800db3 <strtol+0x29>
		s++, neg = 1;
  800dde:	83 c1 01             	add    $0x1,%ecx
  800de1:	bf 01 00 00 00       	mov    $0x1,%edi
  800de6:	eb cb                	jmp    800db3 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800de8:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800dec:	74 0e                	je     800dfc <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800dee:	85 db                	test   %ebx,%ebx
  800df0:	75 d8                	jne    800dca <strtol+0x40>
		s++, base = 8;
  800df2:	83 c1 01             	add    $0x1,%ecx
  800df5:	bb 08 00 00 00       	mov    $0x8,%ebx
  800dfa:	eb ce                	jmp    800dca <strtol+0x40>
		s += 2, base = 16;
  800dfc:	83 c1 02             	add    $0x2,%ecx
  800dff:	bb 10 00 00 00       	mov    $0x10,%ebx
  800e04:	eb c4                	jmp    800dca <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800e06:	8d 72 9f             	lea    -0x61(%edx),%esi
  800e09:	89 f3                	mov    %esi,%ebx
  800e0b:	80 fb 19             	cmp    $0x19,%bl
  800e0e:	77 29                	ja     800e39 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800e10:	0f be d2             	movsbl %dl,%edx
  800e13:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800e16:	3b 55 10             	cmp    0x10(%ebp),%edx
  800e19:	7d 30                	jge    800e4b <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800e1b:	83 c1 01             	add    $0x1,%ecx
  800e1e:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e22:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800e24:	0f b6 11             	movzbl (%ecx),%edx
  800e27:	8d 72 d0             	lea    -0x30(%edx),%esi
  800e2a:	89 f3                	mov    %esi,%ebx
  800e2c:	80 fb 09             	cmp    $0x9,%bl
  800e2f:	77 d5                	ja     800e06 <strtol+0x7c>
			dig = *s - '0';
  800e31:	0f be d2             	movsbl %dl,%edx
  800e34:	83 ea 30             	sub    $0x30,%edx
  800e37:	eb dd                	jmp    800e16 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800e39:	8d 72 bf             	lea    -0x41(%edx),%esi
  800e3c:	89 f3                	mov    %esi,%ebx
  800e3e:	80 fb 19             	cmp    $0x19,%bl
  800e41:	77 08                	ja     800e4b <strtol+0xc1>
			dig = *s - 'A' + 10;
  800e43:	0f be d2             	movsbl %dl,%edx
  800e46:	83 ea 37             	sub    $0x37,%edx
  800e49:	eb cb                	jmp    800e16 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800e4b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e4f:	74 05                	je     800e56 <strtol+0xcc>
		*endptr = (char *) s;
  800e51:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e54:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800e56:	89 c2                	mov    %eax,%edx
  800e58:	f7 da                	neg    %edx
  800e5a:	85 ff                	test   %edi,%edi
  800e5c:	0f 45 c2             	cmovne %edx,%eax
}
  800e5f:	5b                   	pop    %ebx
  800e60:	5e                   	pop    %esi
  800e61:	5f                   	pop    %edi
  800e62:	5d                   	pop    %ebp
  800e63:	c3                   	ret    

00800e64 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800e64:	55                   	push   %ebp
  800e65:	89 e5                	mov    %esp,%ebp
  800e67:	57                   	push   %edi
  800e68:	56                   	push   %esi
  800e69:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e6a:	b8 00 00 00 00       	mov    $0x0,%eax
  800e6f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e72:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e75:	89 c3                	mov    %eax,%ebx
  800e77:	89 c7                	mov    %eax,%edi
  800e79:	89 c6                	mov    %eax,%esi
  800e7b:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800e7d:	5b                   	pop    %ebx
  800e7e:	5e                   	pop    %esi
  800e7f:	5f                   	pop    %edi
  800e80:	5d                   	pop    %ebp
  800e81:	c3                   	ret    

00800e82 <sys_cgetc>:

int
sys_cgetc(void)
{
  800e82:	55                   	push   %ebp
  800e83:	89 e5                	mov    %esp,%ebp
  800e85:	57                   	push   %edi
  800e86:	56                   	push   %esi
  800e87:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e88:	ba 00 00 00 00       	mov    $0x0,%edx
  800e8d:	b8 01 00 00 00       	mov    $0x1,%eax
  800e92:	89 d1                	mov    %edx,%ecx
  800e94:	89 d3                	mov    %edx,%ebx
  800e96:	89 d7                	mov    %edx,%edi
  800e98:	89 d6                	mov    %edx,%esi
  800e9a:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800e9c:	5b                   	pop    %ebx
  800e9d:	5e                   	pop    %esi
  800e9e:	5f                   	pop    %edi
  800e9f:	5d                   	pop    %ebp
  800ea0:	c3                   	ret    

00800ea1 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ea1:	55                   	push   %ebp
  800ea2:	89 e5                	mov    %esp,%ebp
  800ea4:	57                   	push   %edi
  800ea5:	56                   	push   %esi
  800ea6:	53                   	push   %ebx
  800ea7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eaa:	b9 00 00 00 00       	mov    $0x0,%ecx
  800eaf:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb2:	b8 03 00 00 00       	mov    $0x3,%eax
  800eb7:	89 cb                	mov    %ecx,%ebx
  800eb9:	89 cf                	mov    %ecx,%edi
  800ebb:	89 ce                	mov    %ecx,%esi
  800ebd:	cd 30                	int    $0x30
	if (check && ret > 0)
  800ebf:	85 c0                	test   %eax,%eax
  800ec1:	7f 08                	jg     800ecb <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ec3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ec6:	5b                   	pop    %ebx
  800ec7:	5e                   	pop    %esi
  800ec8:	5f                   	pop    %edi
  800ec9:	5d                   	pop    %ebp
  800eca:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ecb:	83 ec 0c             	sub    $0xc,%esp
  800ece:	50                   	push   %eax
  800ecf:	6a 03                	push   $0x3
  800ed1:	68 60 2b 80 00       	push   $0x802b60
  800ed6:	6a 4c                	push   $0x4c
  800ed8:	68 7d 2b 80 00       	push   $0x802b7d
  800edd:	e8 4b f4 ff ff       	call   80032d <_panic>

00800ee2 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800ee2:	55                   	push   %ebp
  800ee3:	89 e5                	mov    %esp,%ebp
  800ee5:	57                   	push   %edi
  800ee6:	56                   	push   %esi
  800ee7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ee8:	ba 00 00 00 00       	mov    $0x0,%edx
  800eed:	b8 02 00 00 00       	mov    $0x2,%eax
  800ef2:	89 d1                	mov    %edx,%ecx
  800ef4:	89 d3                	mov    %edx,%ebx
  800ef6:	89 d7                	mov    %edx,%edi
  800ef8:	89 d6                	mov    %edx,%esi
  800efa:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800efc:	5b                   	pop    %ebx
  800efd:	5e                   	pop    %esi
  800efe:	5f                   	pop    %edi
  800eff:	5d                   	pop    %ebp
  800f00:	c3                   	ret    

00800f01 <sys_yield>:

void
sys_yield(void)
{
  800f01:	55                   	push   %ebp
  800f02:	89 e5                	mov    %esp,%ebp
  800f04:	57                   	push   %edi
  800f05:	56                   	push   %esi
  800f06:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f07:	ba 00 00 00 00       	mov    $0x0,%edx
  800f0c:	b8 0b 00 00 00       	mov    $0xb,%eax
  800f11:	89 d1                	mov    %edx,%ecx
  800f13:	89 d3                	mov    %edx,%ebx
  800f15:	89 d7                	mov    %edx,%edi
  800f17:	89 d6                	mov    %edx,%esi
  800f19:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800f1b:	5b                   	pop    %ebx
  800f1c:	5e                   	pop    %esi
  800f1d:	5f                   	pop    %edi
  800f1e:	5d                   	pop    %ebp
  800f1f:	c3                   	ret    

00800f20 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800f20:	55                   	push   %ebp
  800f21:	89 e5                	mov    %esp,%ebp
  800f23:	57                   	push   %edi
  800f24:	56                   	push   %esi
  800f25:	53                   	push   %ebx
  800f26:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f29:	be 00 00 00 00       	mov    $0x0,%esi
  800f2e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f31:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f34:	b8 04 00 00 00       	mov    $0x4,%eax
  800f39:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f3c:	89 f7                	mov    %esi,%edi
  800f3e:	cd 30                	int    $0x30
	if (check && ret > 0)
  800f40:	85 c0                	test   %eax,%eax
  800f42:	7f 08                	jg     800f4c <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800f44:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f47:	5b                   	pop    %ebx
  800f48:	5e                   	pop    %esi
  800f49:	5f                   	pop    %edi
  800f4a:	5d                   	pop    %ebp
  800f4b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f4c:	83 ec 0c             	sub    $0xc,%esp
  800f4f:	50                   	push   %eax
  800f50:	6a 04                	push   $0x4
  800f52:	68 60 2b 80 00       	push   $0x802b60
  800f57:	6a 4c                	push   $0x4c
  800f59:	68 7d 2b 80 00       	push   $0x802b7d
  800f5e:	e8 ca f3 ff ff       	call   80032d <_panic>

00800f63 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800f63:	55                   	push   %ebp
  800f64:	89 e5                	mov    %esp,%ebp
  800f66:	57                   	push   %edi
  800f67:	56                   	push   %esi
  800f68:	53                   	push   %ebx
  800f69:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f6c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f72:	b8 05 00 00 00       	mov    $0x5,%eax
  800f77:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f7a:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f7d:	8b 75 18             	mov    0x18(%ebp),%esi
  800f80:	cd 30                	int    $0x30
	if (check && ret > 0)
  800f82:	85 c0                	test   %eax,%eax
  800f84:	7f 08                	jg     800f8e <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800f86:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f89:	5b                   	pop    %ebx
  800f8a:	5e                   	pop    %esi
  800f8b:	5f                   	pop    %edi
  800f8c:	5d                   	pop    %ebp
  800f8d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f8e:	83 ec 0c             	sub    $0xc,%esp
  800f91:	50                   	push   %eax
  800f92:	6a 05                	push   $0x5
  800f94:	68 60 2b 80 00       	push   $0x802b60
  800f99:	6a 4c                	push   $0x4c
  800f9b:	68 7d 2b 80 00       	push   $0x802b7d
  800fa0:	e8 88 f3 ff ff       	call   80032d <_panic>

00800fa5 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800fa5:	55                   	push   %ebp
  800fa6:	89 e5                	mov    %esp,%ebp
  800fa8:	57                   	push   %edi
  800fa9:	56                   	push   %esi
  800faa:	53                   	push   %ebx
  800fab:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fae:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fb3:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb9:	b8 06 00 00 00       	mov    $0x6,%eax
  800fbe:	89 df                	mov    %ebx,%edi
  800fc0:	89 de                	mov    %ebx,%esi
  800fc2:	cd 30                	int    $0x30
	if (check && ret > 0)
  800fc4:	85 c0                	test   %eax,%eax
  800fc6:	7f 08                	jg     800fd0 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800fc8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fcb:	5b                   	pop    %ebx
  800fcc:	5e                   	pop    %esi
  800fcd:	5f                   	pop    %edi
  800fce:	5d                   	pop    %ebp
  800fcf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fd0:	83 ec 0c             	sub    $0xc,%esp
  800fd3:	50                   	push   %eax
  800fd4:	6a 06                	push   $0x6
  800fd6:	68 60 2b 80 00       	push   $0x802b60
  800fdb:	6a 4c                	push   $0x4c
  800fdd:	68 7d 2b 80 00       	push   $0x802b7d
  800fe2:	e8 46 f3 ff ff       	call   80032d <_panic>

00800fe7 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800fe7:	55                   	push   %ebp
  800fe8:	89 e5                	mov    %esp,%ebp
  800fea:	57                   	push   %edi
  800feb:	56                   	push   %esi
  800fec:	53                   	push   %ebx
  800fed:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ff0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ff5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ffb:	b8 08 00 00 00       	mov    $0x8,%eax
  801000:	89 df                	mov    %ebx,%edi
  801002:	89 de                	mov    %ebx,%esi
  801004:	cd 30                	int    $0x30
	if (check && ret > 0)
  801006:	85 c0                	test   %eax,%eax
  801008:	7f 08                	jg     801012 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80100a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80100d:	5b                   	pop    %ebx
  80100e:	5e                   	pop    %esi
  80100f:	5f                   	pop    %edi
  801010:	5d                   	pop    %ebp
  801011:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801012:	83 ec 0c             	sub    $0xc,%esp
  801015:	50                   	push   %eax
  801016:	6a 08                	push   $0x8
  801018:	68 60 2b 80 00       	push   $0x802b60
  80101d:	6a 4c                	push   $0x4c
  80101f:	68 7d 2b 80 00       	push   $0x802b7d
  801024:	e8 04 f3 ff ff       	call   80032d <_panic>

00801029 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801029:	55                   	push   %ebp
  80102a:	89 e5                	mov    %esp,%ebp
  80102c:	57                   	push   %edi
  80102d:	56                   	push   %esi
  80102e:	53                   	push   %ebx
  80102f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801032:	bb 00 00 00 00       	mov    $0x0,%ebx
  801037:	8b 55 08             	mov    0x8(%ebp),%edx
  80103a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80103d:	b8 09 00 00 00       	mov    $0x9,%eax
  801042:	89 df                	mov    %ebx,%edi
  801044:	89 de                	mov    %ebx,%esi
  801046:	cd 30                	int    $0x30
	if (check && ret > 0)
  801048:	85 c0                	test   %eax,%eax
  80104a:	7f 08                	jg     801054 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80104c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80104f:	5b                   	pop    %ebx
  801050:	5e                   	pop    %esi
  801051:	5f                   	pop    %edi
  801052:	5d                   	pop    %ebp
  801053:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801054:	83 ec 0c             	sub    $0xc,%esp
  801057:	50                   	push   %eax
  801058:	6a 09                	push   $0x9
  80105a:	68 60 2b 80 00       	push   $0x802b60
  80105f:	6a 4c                	push   $0x4c
  801061:	68 7d 2b 80 00       	push   $0x802b7d
  801066:	e8 c2 f2 ff ff       	call   80032d <_panic>

0080106b <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80106b:	55                   	push   %ebp
  80106c:	89 e5                	mov    %esp,%ebp
  80106e:	57                   	push   %edi
  80106f:	56                   	push   %esi
  801070:	53                   	push   %ebx
  801071:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801074:	bb 00 00 00 00       	mov    $0x0,%ebx
  801079:	8b 55 08             	mov    0x8(%ebp),%edx
  80107c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80107f:	b8 0a 00 00 00       	mov    $0xa,%eax
  801084:	89 df                	mov    %ebx,%edi
  801086:	89 de                	mov    %ebx,%esi
  801088:	cd 30                	int    $0x30
	if (check && ret > 0)
  80108a:	85 c0                	test   %eax,%eax
  80108c:	7f 08                	jg     801096 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80108e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801091:	5b                   	pop    %ebx
  801092:	5e                   	pop    %esi
  801093:	5f                   	pop    %edi
  801094:	5d                   	pop    %ebp
  801095:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801096:	83 ec 0c             	sub    $0xc,%esp
  801099:	50                   	push   %eax
  80109a:	6a 0a                	push   $0xa
  80109c:	68 60 2b 80 00       	push   $0x802b60
  8010a1:	6a 4c                	push   $0x4c
  8010a3:	68 7d 2b 80 00       	push   $0x802b7d
  8010a8:	e8 80 f2 ff ff       	call   80032d <_panic>

008010ad <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8010ad:	55                   	push   %ebp
  8010ae:	89 e5                	mov    %esp,%ebp
  8010b0:	57                   	push   %edi
  8010b1:	56                   	push   %esi
  8010b2:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010b9:	b8 0c 00 00 00       	mov    $0xc,%eax
  8010be:	be 00 00 00 00       	mov    $0x0,%esi
  8010c3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010c6:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010c9:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8010cb:	5b                   	pop    %ebx
  8010cc:	5e                   	pop    %esi
  8010cd:	5f                   	pop    %edi
  8010ce:	5d                   	pop    %ebp
  8010cf:	c3                   	ret    

008010d0 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8010d0:	55                   	push   %ebp
  8010d1:	89 e5                	mov    %esp,%ebp
  8010d3:	57                   	push   %edi
  8010d4:	56                   	push   %esi
  8010d5:	53                   	push   %ebx
  8010d6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010d9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010de:	8b 55 08             	mov    0x8(%ebp),%edx
  8010e1:	b8 0d 00 00 00       	mov    $0xd,%eax
  8010e6:	89 cb                	mov    %ecx,%ebx
  8010e8:	89 cf                	mov    %ecx,%edi
  8010ea:	89 ce                	mov    %ecx,%esi
  8010ec:	cd 30                	int    $0x30
	if (check && ret > 0)
  8010ee:	85 c0                	test   %eax,%eax
  8010f0:	7f 08                	jg     8010fa <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8010f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010f5:	5b                   	pop    %ebx
  8010f6:	5e                   	pop    %esi
  8010f7:	5f                   	pop    %edi
  8010f8:	5d                   	pop    %ebp
  8010f9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010fa:	83 ec 0c             	sub    $0xc,%esp
  8010fd:	50                   	push   %eax
  8010fe:	6a 0d                	push   $0xd
  801100:	68 60 2b 80 00       	push   $0x802b60
  801105:	6a 4c                	push   $0x4c
  801107:	68 7d 2b 80 00       	push   $0x802b7d
  80110c:	e8 1c f2 ff ff       	call   80032d <_panic>

00801111 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  801111:	55                   	push   %ebp
  801112:	89 e5                	mov    %esp,%ebp
  801114:	57                   	push   %edi
  801115:	56                   	push   %esi
  801116:	53                   	push   %ebx
	asm volatile("int %1\n"
  801117:	bb 00 00 00 00       	mov    $0x0,%ebx
  80111c:	8b 55 08             	mov    0x8(%ebp),%edx
  80111f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801122:	b8 0e 00 00 00       	mov    $0xe,%eax
  801127:	89 df                	mov    %ebx,%edi
  801129:	89 de                	mov    %ebx,%esi
  80112b:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  80112d:	5b                   	pop    %ebx
  80112e:	5e                   	pop    %esi
  80112f:	5f                   	pop    %edi
  801130:	5d                   	pop    %ebp
  801131:	c3                   	ret    

00801132 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  801132:	55                   	push   %ebp
  801133:	89 e5                	mov    %esp,%ebp
  801135:	57                   	push   %edi
  801136:	56                   	push   %esi
  801137:	53                   	push   %ebx
	asm volatile("int %1\n"
  801138:	b9 00 00 00 00       	mov    $0x0,%ecx
  80113d:	8b 55 08             	mov    0x8(%ebp),%edx
  801140:	b8 0f 00 00 00       	mov    $0xf,%eax
  801145:	89 cb                	mov    %ecx,%ebx
  801147:	89 cf                	mov    %ecx,%edi
  801149:	89 ce                	mov    %ecx,%esi
  80114b:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  80114d:	5b                   	pop    %ebx
  80114e:	5e                   	pop    %esi
  80114f:	5f                   	pop    %edi
  801150:	5d                   	pop    %ebp
  801151:	c3                   	ret    

00801152 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801152:	55                   	push   %ebp
  801153:	89 e5                	mov    %esp,%ebp
  801155:	53                   	push   %ebx
  801156:	83 ec 04             	sub    $0x4,%esp
  801159:	8b 55 08             	mov    0x8(%ebp),%edx
	// cprintf("pgfault()\n");
	void *addr = (void *) utf->utf_fault_va;
  80115c:	8b 02                	mov    (%edx),%eax
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(!(err & FEC_WR) || !(uvpd[PDX(addr)] & PTE_P) || !(uvpt[PGNUM(addr)] & PTE_P) || !(uvpt[PGNUM(addr)] & PTE_COW))
  80115e:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801162:	0f 84 9c 00 00 00    	je     801204 <pgfault+0xb2>
  801168:	89 c2                	mov    %eax,%edx
  80116a:	c1 ea 16             	shr    $0x16,%edx
  80116d:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801174:	f6 c2 01             	test   $0x1,%dl
  801177:	0f 84 87 00 00 00    	je     801204 <pgfault+0xb2>
  80117d:	89 c2                	mov    %eax,%edx
  80117f:	c1 ea 0c             	shr    $0xc,%edx
  801182:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801189:	f6 c1 01             	test   $0x1,%cl
  80118c:	74 76                	je     801204 <pgfault+0xb2>
  80118e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801195:	f6 c6 08             	test   $0x8,%dh
  801198:	74 6a                	je     801204 <pgfault+0xb2>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  80119a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80119f:	89 c3                	mov    %eax,%ebx

	r = sys_page_alloc(0, PFTEMP, PTE_P|PTE_U|PTE_W);
  8011a1:	83 ec 04             	sub    $0x4,%esp
  8011a4:	6a 07                	push   $0x7
  8011a6:	68 00 f0 7f 00       	push   $0x7ff000
  8011ab:	6a 00                	push   $0x0
  8011ad:	e8 6e fd ff ff       	call   800f20 <sys_page_alloc>
	if(r < 0){
  8011b2:	83 c4 10             	add    $0x10,%esp
  8011b5:	85 c0                	test   %eax,%eax
  8011b7:	78 5f                	js     801218 <pgfault+0xc6>
		panic("pgfault: sys_page_alloc fail, r: %d", r);
	}

	memmove(PFTEMP, addr, PGSIZE);
  8011b9:	83 ec 04             	sub    $0x4,%esp
  8011bc:	68 00 10 00 00       	push   $0x1000
  8011c1:	53                   	push   %ebx
  8011c2:	68 00 f0 7f 00       	push   $0x7ff000
  8011c7:	e8 f0 fa ff ff       	call   800cbc <memmove>

	r = sys_page_map(0, PFTEMP, 0, addr, PTE_P|PTE_U|PTE_W);
  8011cc:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  8011d3:	53                   	push   %ebx
  8011d4:	6a 00                	push   $0x0
  8011d6:	68 00 f0 7f 00       	push   $0x7ff000
  8011db:	6a 00                	push   $0x0
  8011dd:	e8 81 fd ff ff       	call   800f63 <sys_page_map>
	if(r < 0){
  8011e2:	83 c4 20             	add    $0x20,%esp
  8011e5:	85 c0                	test   %eax,%eax
  8011e7:	78 41                	js     80122a <pgfault+0xd8>
		panic("pgfault: sys_page_map fail, r: %d", r);
	}

	r = sys_page_unmap(0, PFTEMP);
  8011e9:	83 ec 08             	sub    $0x8,%esp
  8011ec:	68 00 f0 7f 00       	push   $0x7ff000
  8011f1:	6a 00                	push   $0x0
  8011f3:	e8 ad fd ff ff       	call   800fa5 <sys_page_unmap>
	if(r < 0){
  8011f8:	83 c4 10             	add    $0x10,%esp
  8011fb:	85 c0                	test   %eax,%eax
  8011fd:	78 3d                	js     80123c <pgfault+0xea>
		panic("sys_page_unmap: %e", r);
	}
}
  8011ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801202:	c9                   	leave  
  801203:	c3                   	ret    
		panic("pgfault: 1\n");
  801204:	83 ec 04             	sub    $0x4,%esp
  801207:	68 8b 2b 80 00       	push   $0x802b8b
  80120c:	6a 20                	push   $0x20
  80120e:	68 97 2b 80 00       	push   $0x802b97
  801213:	e8 15 f1 ff ff       	call   80032d <_panic>
		panic("pgfault: sys_page_alloc fail, r: %d", r);
  801218:	50                   	push   %eax
  801219:	68 ec 2b 80 00       	push   $0x802bec
  80121e:	6a 2e                	push   $0x2e
  801220:	68 97 2b 80 00       	push   $0x802b97
  801225:	e8 03 f1 ff ff       	call   80032d <_panic>
		panic("pgfault: sys_page_map fail, r: %d", r);
  80122a:	50                   	push   %eax
  80122b:	68 10 2c 80 00       	push   $0x802c10
  801230:	6a 35                	push   $0x35
  801232:	68 97 2b 80 00       	push   $0x802b97
  801237:	e8 f1 f0 ff ff       	call   80032d <_panic>
		panic("sys_page_unmap: %e", r);
  80123c:	50                   	push   %eax
  80123d:	68 a2 2b 80 00       	push   $0x802ba2
  801242:	6a 3a                	push   $0x3a
  801244:	68 97 2b 80 00       	push   $0x802b97
  801249:	e8 df f0 ff ff       	call   80032d <_panic>

0080124e <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80124e:	55                   	push   %ebp
  80124f:	89 e5                	mov    %esp,%ebp
  801251:	57                   	push   %edi
  801252:	56                   	push   %esi
  801253:	53                   	push   %ebx
  801254:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	// panic("fork not implemented");
	int r;
	set_pgfault_handler(pgfault);
  801257:	68 52 11 80 00       	push   $0x801152
  80125c:	e8 e2 0f 00 00       	call   802243 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801261:	b8 07 00 00 00       	mov    $0x7,%eax
  801266:	cd 30                	int    $0x30
  801268:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int i;
	uintptr_t va;
	envid_t childid = sys_exofork();
	if (childid < 0){
  80126b:	83 c4 10             	add    $0x10,%esp
  80126e:	85 c0                	test   %eax,%eax
  801270:	78 2c                	js     80129e <fork+0x50>
  801272:	89 c7                	mov    %eax,%edi
	}

	extern volatile pde_t uvpd[];
	extern volatile pte_t uvpt[];

	for (va = UTEXT; va < USTACKTOP; va += PGSIZE){
  801274:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if (childid == 0) {
  801279:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80127d:	75 72                	jne    8012f1 <fork+0xa3>
		thisenv = &envs[ENVX(sys_getenvid())];
  80127f:	e8 5e fc ff ff       	call   800ee2 <sys_getenvid>
  801284:	25 ff 03 00 00       	and    $0x3ff,%eax
  801289:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80128f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801294:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  801299:	e9 36 01 00 00       	jmp    8013d4 <fork+0x186>
		panic("fork: child id < 0: %d", childid);
  80129e:	50                   	push   %eax
  80129f:	68 b5 2b 80 00       	push   $0x802bb5
  8012a4:	68 83 00 00 00       	push   $0x83
  8012a9:	68 97 2b 80 00       	push   $0x802b97
  8012ae:	e8 7a f0 ff ff       	call   80032d <_panic>
			panic("sys_page_map: sys_page_map fail, r:%d\n", r);
  8012b3:	50                   	push   %eax
  8012b4:	68 34 2c 80 00       	push   $0x802c34
  8012b9:	6a 56                	push   $0x56
  8012bb:	68 97 2b 80 00       	push   $0x802b97
  8012c0:	e8 68 f0 ff ff       	call   80032d <_panic>
		r = sys_page_map((envid_t)0, va, envid, va, PTE_U | PTE_P);
  8012c5:	83 ec 0c             	sub    $0xc,%esp
  8012c8:	6a 05                	push   $0x5
  8012ca:	56                   	push   %esi
  8012cb:	57                   	push   %edi
  8012cc:	56                   	push   %esi
  8012cd:	6a 00                	push   $0x0
  8012cf:	e8 8f fc ff ff       	call   800f63 <sys_page_map>
		if(r < 0){
  8012d4:	83 c4 20             	add    $0x20,%esp
  8012d7:	85 c0                	test   %eax,%eax
  8012d9:	0f 88 9f 00 00 00    	js     80137e <fork+0x130>
	for (va = UTEXT; va < USTACKTOP; va += PGSIZE){
  8012df:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8012e5:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8012eb:	0f 84 9f 00 00 00    	je     801390 <fork+0x142>
		if ((uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_U)){
  8012f1:	89 d8                	mov    %ebx,%eax
  8012f3:	c1 e8 16             	shr    $0x16,%eax
  8012f6:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8012fd:	a8 01                	test   $0x1,%al
  8012ff:	74 de                	je     8012df <fork+0x91>
  801301:	89 d8                	mov    %ebx,%eax
  801303:	c1 e8 0c             	shr    $0xc,%eax
  801306:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80130d:	f6 c2 01             	test   $0x1,%dl
  801310:	74 cd                	je     8012df <fork+0x91>
  801312:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801319:	f6 c2 04             	test   $0x4,%dl
  80131c:	74 c1                	je     8012df <fork+0x91>
	void * va = (void *)(pn * PGSIZE);
  80131e:	89 c6                	mov    %eax,%esi
  801320:	c1 e6 0c             	shl    $0xc,%esi
	int perm = (uvpt[pn]);
  801323:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (perm & (PTE_W | PTE_COW)) {
  80132a:	a9 02 08 00 00       	test   $0x802,%eax
  80132f:	74 94                	je     8012c5 <fork+0x77>
		r = sys_page_map((envid_t)0, va, envid, va, PTE_U | PTE_P | PTE_COW);
  801331:	83 ec 0c             	sub    $0xc,%esp
  801334:	68 05 08 00 00       	push   $0x805
  801339:	56                   	push   %esi
  80133a:	57                   	push   %edi
  80133b:	56                   	push   %esi
  80133c:	6a 00                	push   $0x0
  80133e:	e8 20 fc ff ff       	call   800f63 <sys_page_map>
		if(r < 0){
  801343:	83 c4 20             	add    $0x20,%esp
  801346:	85 c0                	test   %eax,%eax
  801348:	0f 88 65 ff ff ff    	js     8012b3 <fork+0x65>
		r = sys_page_map((envid_t)0, va, (envid_t)0, va, PTE_U | PTE_P | PTE_COW);
  80134e:	83 ec 0c             	sub    $0xc,%esp
  801351:	68 05 08 00 00       	push   $0x805
  801356:	56                   	push   %esi
  801357:	6a 00                	push   $0x0
  801359:	56                   	push   %esi
  80135a:	6a 00                	push   $0x0
  80135c:	e8 02 fc ff ff       	call   800f63 <sys_page_map>
		if(r < 0){
  801361:	83 c4 20             	add    $0x20,%esp
  801364:	85 c0                	test   %eax,%eax
  801366:	0f 89 73 ff ff ff    	jns    8012df <fork+0x91>
			panic("sys_page_map: sys_page_map fail, r:%d\n", r);
  80136c:	50                   	push   %eax
  80136d:	68 34 2c 80 00       	push   $0x802c34
  801372:	6a 5b                	push   $0x5b
  801374:	68 97 2b 80 00       	push   $0x802b97
  801379:	e8 af ef ff ff       	call   80032d <_panic>
			panic("sys_page_map: sys_page_map fail, r:%d\n", r);
  80137e:	50                   	push   %eax
  80137f:	68 34 2c 80 00       	push   $0x802c34
  801384:	6a 61                	push   $0x61
  801386:	68 97 2b 80 00       	push   $0x802b97
  80138b:	e8 9d ef ff ff       	call   80032d <_panic>
			duppage(childid, PGNUM(va));
		}
	}

	r = sys_page_alloc(childid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801390:	83 ec 04             	sub    $0x4,%esp
  801393:	6a 07                	push   $0x7
  801395:	68 00 f0 bf ee       	push   $0xeebff000
  80139a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80139d:	e8 7e fb ff ff       	call   800f20 <sys_page_alloc>
	if (r < 0){
  8013a2:	83 c4 10             	add    $0x10,%esp
  8013a5:	85 c0                	test   %eax,%eax
  8013a7:	78 36                	js     8013df <fork+0x191>
		panic("fork: allocate user exception stack for child env error, %d", r);
	}
	r = sys_env_set_pgfault_upcall(childid, _pgfault_upcall);
  8013a9:	83 ec 08             	sub    $0x8,%esp
  8013ac:	68 ae 22 80 00       	push   $0x8022ae
  8013b1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8013b4:	e8 b2 fc ff ff       	call   80106b <sys_env_set_pgfault_upcall>
	if (r < 0){
  8013b9:	83 c4 10             	add    $0x10,%esp
  8013bc:	85 c0                	test   %eax,%eax
  8013be:	78 34                	js     8013f4 <fork+0x1a6>
		panic("fork: sys_env_set_pgfault_upcall error, %d", r);
	}
	r = sys_env_set_status(childid, ENV_RUNNABLE);
  8013c0:	83 ec 08             	sub    $0x8,%esp
  8013c3:	6a 02                	push   $0x2
  8013c5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8013c8:	e8 1a fc ff ff       	call   800fe7 <sys_env_set_status>
	if(r < 0){
  8013cd:	83 c4 10             	add    $0x10,%esp
  8013d0:	85 c0                	test   %eax,%eax
  8013d2:	78 35                	js     801409 <fork+0x1bb>
		panic("forK: sys_env_set_status, r%d", r);
	}
	return childid;
}
  8013d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013da:	5b                   	pop    %ebx
  8013db:	5e                   	pop    %esi
  8013dc:	5f                   	pop    %edi
  8013dd:	5d                   	pop    %ebp
  8013de:	c3                   	ret    
		panic("fork: allocate user exception stack for child env error, %d", r);
  8013df:	50                   	push   %eax
  8013e0:	68 5c 2c 80 00       	push   $0x802c5c
  8013e5:	68 96 00 00 00       	push   $0x96
  8013ea:	68 97 2b 80 00       	push   $0x802b97
  8013ef:	e8 39 ef ff ff       	call   80032d <_panic>
		panic("fork: sys_env_set_pgfault_upcall error, %d", r);
  8013f4:	50                   	push   %eax
  8013f5:	68 98 2c 80 00       	push   $0x802c98
  8013fa:	68 9a 00 00 00       	push   $0x9a
  8013ff:	68 97 2b 80 00       	push   $0x802b97
  801404:	e8 24 ef ff ff       	call   80032d <_panic>
		panic("forK: sys_env_set_status, r%d", r);
  801409:	50                   	push   %eax
  80140a:	68 cc 2b 80 00       	push   $0x802bcc
  80140f:	68 9e 00 00 00       	push   $0x9e
  801414:	68 97 2b 80 00       	push   $0x802b97
  801419:	e8 0f ef ff ff       	call   80032d <_panic>

0080141e <sfork>:

// Challenge!
int
sfork(void)
{
  80141e:	55                   	push   %ebp
  80141f:	89 e5                	mov    %esp,%ebp
  801421:	57                   	push   %edi
  801422:	56                   	push   %esi
  801423:	53                   	push   %ebx
  801424:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// return -E_INVAL;
	set_pgfault_handler(pgfault);
  801427:	68 52 11 80 00       	push   $0x801152
  80142c:	e8 12 0e 00 00       	call   802243 <set_pgfault_handler>
  801431:	b8 07 00 00 00       	mov    $0x7,%eax
  801436:	cd 30                	int    $0x30
  801438:	89 c6                	mov    %eax,%esi
	int i;
	uintptr_t va;
	envid_t childid = sys_exofork();
	int r;
	if (childid < 0){
  80143a:	83 c4 10             	add    $0x10,%esp
  80143d:	85 c0                	test   %eax,%eax
  80143f:	78 28                	js     801469 <sfork+0x4b>
  801441:	89 c7                	mov    %eax,%edi
	}

	extern volatile pde_t uvpd[];
	extern volatile pte_t uvpt[];

	for (va = 0; va < USTACKTOP; va += PGSIZE){
  801443:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (childid == 0) {
  801448:	75 42                	jne    80148c <sfork+0x6e>
		thisenv = &envs[ENVX(sys_getenvid())];
  80144a:	e8 93 fa ff ff       	call   800ee2 <sys_getenvid>
  80144f:	25 ff 03 00 00       	and    $0x3ff,%eax
  801454:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80145a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80145f:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  801464:	e9 bc 00 00 00       	jmp    801525 <sfork+0x107>
		panic("fork: child id < 0: %d", childid);
  801469:	50                   	push   %eax
  80146a:	68 b5 2b 80 00       	push   $0x802bb5
  80146f:	68 af 00 00 00       	push   $0xaf
  801474:	68 97 2b 80 00       	push   $0x802b97
  801479:	e8 af ee ff ff       	call   80032d <_panic>
	for (va = 0; va < USTACKTOP; va += PGSIZE){
  80147e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801484:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  80148a:	74 5b                	je     8014e7 <sfork+0xc9>
		if ((uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_U)){
  80148c:	89 d8                	mov    %ebx,%eax
  80148e:	c1 e8 16             	shr    $0x16,%eax
  801491:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801498:	a8 01                	test   $0x1,%al
  80149a:	74 e2                	je     80147e <sfork+0x60>
  80149c:	89 d8                	mov    %ebx,%eax
  80149e:	c1 e8 0c             	shr    $0xc,%eax
  8014a1:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8014a8:	f6 c2 01             	test   $0x1,%dl
  8014ab:	74 d1                	je     80147e <sfork+0x60>
  8014ad:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8014b4:	f6 c2 04             	test   $0x4,%dl
  8014b7:	74 c5                	je     80147e <sfork+0x60>
			void *addr = (void *)(PGNUM(va) * PGSIZE);
  8014b9:	c1 e0 0c             	shl    $0xc,%eax
			struct PageInfo *page;
			pte_t *pte;
			
			// page = page_lookup((envid_t)0->env_pgdir, addr, &pte);
			// page_insert(dstenv->env_pgdir, page, addr, PTE_U | PTE_P);
			r = sys_page_map((envid_t)0, addr, childid, addr, PTE_U | PTE_P);
  8014bc:	83 ec 0c             	sub    $0xc,%esp
  8014bf:	6a 05                	push   $0x5
  8014c1:	50                   	push   %eax
  8014c2:	57                   	push   %edi
  8014c3:	50                   	push   %eax
  8014c4:	6a 00                	push   $0x0
  8014c6:	e8 98 fa ff ff       	call   800f63 <sys_page_map>
			if(r < 0){
  8014cb:	83 c4 20             	add    $0x20,%esp
  8014ce:	85 c0                	test   %eax,%eax
  8014d0:	79 ac                	jns    80147e <sfork+0x60>
				panic("sfork: sys_page_map fail, r:%d\n", r);
  8014d2:	50                   	push   %eax
  8014d3:	68 c4 2c 80 00       	push   $0x802cc4
  8014d8:	68 c4 00 00 00       	push   $0xc4
  8014dd:	68 97 2b 80 00       	push   $0x802b97
  8014e2:	e8 46 ee ff ff       	call   80032d <_panic>
			}
		}
	}

	r = sys_page_alloc(childid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8014e7:	83 ec 04             	sub    $0x4,%esp
  8014ea:	6a 07                	push   $0x7
  8014ec:	68 00 f0 bf ee       	push   $0xeebff000
  8014f1:	56                   	push   %esi
  8014f2:	e8 29 fa ff ff       	call   800f20 <sys_page_alloc>
	if (r < 0){
  8014f7:	83 c4 10             	add    $0x10,%esp
  8014fa:	85 c0                	test   %eax,%eax
  8014fc:	78 31                	js     80152f <sfork+0x111>
		panic("sfork: allocate user exception stack for child env error, %d", r);
	}
	r = sys_env_set_pgfault_upcall(childid, _pgfault_upcall);
  8014fe:	83 ec 08             	sub    $0x8,%esp
  801501:	68 ae 22 80 00       	push   $0x8022ae
  801506:	56                   	push   %esi
  801507:	e8 5f fb ff ff       	call   80106b <sys_env_set_pgfault_upcall>
	if (r < 0){
  80150c:	83 c4 10             	add    $0x10,%esp
  80150f:	85 c0                	test   %eax,%eax
  801511:	78 31                	js     801544 <sfork+0x126>
		panic("sfork: sys_env_set_pgfault_upcall error, %d", r);
	}
	r = sys_env_set_status(childid, ENV_RUNNABLE);
  801513:	83 ec 08             	sub    $0x8,%esp
  801516:	6a 02                	push   $0x2
  801518:	56                   	push   %esi
  801519:	e8 c9 fa ff ff       	call   800fe7 <sys_env_set_status>
	if(r < 0){
  80151e:	83 c4 10             	add    $0x10,%esp
  801521:	85 c0                	test   %eax,%eax
  801523:	78 34                	js     801559 <sfork+0x13b>
		panic("sforK: sys_env_set_status, r%d", r);
	}
	return childid;
}
  801525:	89 f0                	mov    %esi,%eax
  801527:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80152a:	5b                   	pop    %ebx
  80152b:	5e                   	pop    %esi
  80152c:	5f                   	pop    %edi
  80152d:	5d                   	pop    %ebp
  80152e:	c3                   	ret    
		panic("sfork: allocate user exception stack for child env error, %d", r);
  80152f:	50                   	push   %eax
  801530:	68 e4 2c 80 00       	push   $0x802ce4
  801535:	68 cb 00 00 00       	push   $0xcb
  80153a:	68 97 2b 80 00       	push   $0x802b97
  80153f:	e8 e9 ed ff ff       	call   80032d <_panic>
		panic("sfork: sys_env_set_pgfault_upcall error, %d", r);
  801544:	50                   	push   %eax
  801545:	68 24 2d 80 00       	push   $0x802d24
  80154a:	68 cf 00 00 00       	push   $0xcf
  80154f:	68 97 2b 80 00       	push   $0x802b97
  801554:	e8 d4 ed ff ff       	call   80032d <_panic>
		panic("sforK: sys_env_set_status, r%d", r);
  801559:	50                   	push   %eax
  80155a:	68 50 2d 80 00       	push   $0x802d50
  80155f:	68 d3 00 00 00       	push   $0xd3
  801564:	68 97 2b 80 00       	push   $0x802b97
  801569:	e8 bf ed ff ff       	call   80032d <_panic>

0080156e <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80156e:	55                   	push   %ebp
  80156f:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801571:	8b 45 08             	mov    0x8(%ebp),%eax
  801574:	05 00 00 00 30       	add    $0x30000000,%eax
  801579:	c1 e8 0c             	shr    $0xc,%eax
}
  80157c:	5d                   	pop    %ebp
  80157d:	c3                   	ret    

0080157e <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80157e:	55                   	push   %ebp
  80157f:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801581:	8b 45 08             	mov    0x8(%ebp),%eax
  801584:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801589:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80158e:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801593:	5d                   	pop    %ebp
  801594:	c3                   	ret    

00801595 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801595:	55                   	push   %ebp
  801596:	89 e5                	mov    %esp,%ebp
  801598:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80159d:	89 c2                	mov    %eax,%edx
  80159f:	c1 ea 16             	shr    $0x16,%edx
  8015a2:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8015a9:	f6 c2 01             	test   $0x1,%dl
  8015ac:	74 2d                	je     8015db <fd_alloc+0x46>
  8015ae:	89 c2                	mov    %eax,%edx
  8015b0:	c1 ea 0c             	shr    $0xc,%edx
  8015b3:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8015ba:	f6 c2 01             	test   $0x1,%dl
  8015bd:	74 1c                	je     8015db <fd_alloc+0x46>
  8015bf:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8015c4:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8015c9:	75 d2                	jne    80159d <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8015cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8015d4:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8015d9:	eb 0a                	jmp    8015e5 <fd_alloc+0x50>
			*fd_store = fd;
  8015db:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015de:	89 01                	mov    %eax,(%ecx)
			return 0;
  8015e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015e5:	5d                   	pop    %ebp
  8015e6:	c3                   	ret    

008015e7 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8015e7:	55                   	push   %ebp
  8015e8:	89 e5                	mov    %esp,%ebp
  8015ea:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8015ed:	83 f8 1f             	cmp    $0x1f,%eax
  8015f0:	77 30                	ja     801622 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8015f2:	c1 e0 0c             	shl    $0xc,%eax
  8015f5:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8015fa:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801600:	f6 c2 01             	test   $0x1,%dl
  801603:	74 24                	je     801629 <fd_lookup+0x42>
  801605:	89 c2                	mov    %eax,%edx
  801607:	c1 ea 0c             	shr    $0xc,%edx
  80160a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801611:	f6 c2 01             	test   $0x1,%dl
  801614:	74 1a                	je     801630 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801616:	8b 55 0c             	mov    0xc(%ebp),%edx
  801619:	89 02                	mov    %eax,(%edx)
	return 0;
  80161b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801620:	5d                   	pop    %ebp
  801621:	c3                   	ret    
		return -E_INVAL;
  801622:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801627:	eb f7                	jmp    801620 <fd_lookup+0x39>
		return -E_INVAL;
  801629:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80162e:	eb f0                	jmp    801620 <fd_lookup+0x39>
  801630:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801635:	eb e9                	jmp    801620 <fd_lookup+0x39>

00801637 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801637:	55                   	push   %ebp
  801638:	89 e5                	mov    %esp,%ebp
  80163a:	83 ec 08             	sub    $0x8,%esp
  80163d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801640:	ba ec 2d 80 00       	mov    $0x802dec,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801645:	b8 08 30 80 00       	mov    $0x803008,%eax
		if (devtab[i]->dev_id == dev_id) {
  80164a:	39 08                	cmp    %ecx,(%eax)
  80164c:	74 33                	je     801681 <dev_lookup+0x4a>
  80164e:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801651:	8b 02                	mov    (%edx),%eax
  801653:	85 c0                	test   %eax,%eax
  801655:	75 f3                	jne    80164a <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801657:	a1 04 40 80 00       	mov    0x804004,%eax
  80165c:	8b 40 48             	mov    0x48(%eax),%eax
  80165f:	83 ec 04             	sub    $0x4,%esp
  801662:	51                   	push   %ecx
  801663:	50                   	push   %eax
  801664:	68 70 2d 80 00       	push   $0x802d70
  801669:	e8 9a ed ff ff       	call   800408 <cprintf>
	*dev = 0;
  80166e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801671:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801677:	83 c4 10             	add    $0x10,%esp
  80167a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80167f:	c9                   	leave  
  801680:	c3                   	ret    
			*dev = devtab[i];
  801681:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801684:	89 01                	mov    %eax,(%ecx)
			return 0;
  801686:	b8 00 00 00 00       	mov    $0x0,%eax
  80168b:	eb f2                	jmp    80167f <dev_lookup+0x48>

0080168d <fd_close>:
{
  80168d:	55                   	push   %ebp
  80168e:	89 e5                	mov    %esp,%ebp
  801690:	57                   	push   %edi
  801691:	56                   	push   %esi
  801692:	53                   	push   %ebx
  801693:	83 ec 24             	sub    $0x24,%esp
  801696:	8b 75 08             	mov    0x8(%ebp),%esi
  801699:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80169c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80169f:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016a0:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8016a6:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8016a9:	50                   	push   %eax
  8016aa:	e8 38 ff ff ff       	call   8015e7 <fd_lookup>
  8016af:	89 c3                	mov    %eax,%ebx
  8016b1:	83 c4 10             	add    $0x10,%esp
  8016b4:	85 c0                	test   %eax,%eax
  8016b6:	78 05                	js     8016bd <fd_close+0x30>
	    || fd != fd2)
  8016b8:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8016bb:	74 16                	je     8016d3 <fd_close+0x46>
		return (must_exist ? r : 0);
  8016bd:	89 f8                	mov    %edi,%eax
  8016bf:	84 c0                	test   %al,%al
  8016c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8016c6:	0f 44 d8             	cmove  %eax,%ebx
}
  8016c9:	89 d8                	mov    %ebx,%eax
  8016cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016ce:	5b                   	pop    %ebx
  8016cf:	5e                   	pop    %esi
  8016d0:	5f                   	pop    %edi
  8016d1:	5d                   	pop    %ebp
  8016d2:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8016d3:	83 ec 08             	sub    $0x8,%esp
  8016d6:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8016d9:	50                   	push   %eax
  8016da:	ff 36                	pushl  (%esi)
  8016dc:	e8 56 ff ff ff       	call   801637 <dev_lookup>
  8016e1:	89 c3                	mov    %eax,%ebx
  8016e3:	83 c4 10             	add    $0x10,%esp
  8016e6:	85 c0                	test   %eax,%eax
  8016e8:	78 1a                	js     801704 <fd_close+0x77>
		if (dev->dev_close)
  8016ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016ed:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8016f0:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8016f5:	85 c0                	test   %eax,%eax
  8016f7:	74 0b                	je     801704 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8016f9:	83 ec 0c             	sub    $0xc,%esp
  8016fc:	56                   	push   %esi
  8016fd:	ff d0                	call   *%eax
  8016ff:	89 c3                	mov    %eax,%ebx
  801701:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801704:	83 ec 08             	sub    $0x8,%esp
  801707:	56                   	push   %esi
  801708:	6a 00                	push   $0x0
  80170a:	e8 96 f8 ff ff       	call   800fa5 <sys_page_unmap>
	return r;
  80170f:	83 c4 10             	add    $0x10,%esp
  801712:	eb b5                	jmp    8016c9 <fd_close+0x3c>

00801714 <close>:

int
close(int fdnum)
{
  801714:	55                   	push   %ebp
  801715:	89 e5                	mov    %esp,%ebp
  801717:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80171a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80171d:	50                   	push   %eax
  80171e:	ff 75 08             	pushl  0x8(%ebp)
  801721:	e8 c1 fe ff ff       	call   8015e7 <fd_lookup>
  801726:	83 c4 10             	add    $0x10,%esp
  801729:	85 c0                	test   %eax,%eax
  80172b:	79 02                	jns    80172f <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80172d:	c9                   	leave  
  80172e:	c3                   	ret    
		return fd_close(fd, 1);
  80172f:	83 ec 08             	sub    $0x8,%esp
  801732:	6a 01                	push   $0x1
  801734:	ff 75 f4             	pushl  -0xc(%ebp)
  801737:	e8 51 ff ff ff       	call   80168d <fd_close>
  80173c:	83 c4 10             	add    $0x10,%esp
  80173f:	eb ec                	jmp    80172d <close+0x19>

00801741 <close_all>:

void
close_all(void)
{
  801741:	55                   	push   %ebp
  801742:	89 e5                	mov    %esp,%ebp
  801744:	53                   	push   %ebx
  801745:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801748:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80174d:	83 ec 0c             	sub    $0xc,%esp
  801750:	53                   	push   %ebx
  801751:	e8 be ff ff ff       	call   801714 <close>
	for (i = 0; i < MAXFD; i++)
  801756:	83 c3 01             	add    $0x1,%ebx
  801759:	83 c4 10             	add    $0x10,%esp
  80175c:	83 fb 20             	cmp    $0x20,%ebx
  80175f:	75 ec                	jne    80174d <close_all+0xc>
}
  801761:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801764:	c9                   	leave  
  801765:	c3                   	ret    

00801766 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801766:	55                   	push   %ebp
  801767:	89 e5                	mov    %esp,%ebp
  801769:	57                   	push   %edi
  80176a:	56                   	push   %esi
  80176b:	53                   	push   %ebx
  80176c:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80176f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801772:	50                   	push   %eax
  801773:	ff 75 08             	pushl  0x8(%ebp)
  801776:	e8 6c fe ff ff       	call   8015e7 <fd_lookup>
  80177b:	89 c3                	mov    %eax,%ebx
  80177d:	83 c4 10             	add    $0x10,%esp
  801780:	85 c0                	test   %eax,%eax
  801782:	0f 88 81 00 00 00    	js     801809 <dup+0xa3>
		return r;
	close(newfdnum);
  801788:	83 ec 0c             	sub    $0xc,%esp
  80178b:	ff 75 0c             	pushl  0xc(%ebp)
  80178e:	e8 81 ff ff ff       	call   801714 <close>

	newfd = INDEX2FD(newfdnum);
  801793:	8b 75 0c             	mov    0xc(%ebp),%esi
  801796:	c1 e6 0c             	shl    $0xc,%esi
  801799:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80179f:	83 c4 04             	add    $0x4,%esp
  8017a2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8017a5:	e8 d4 fd ff ff       	call   80157e <fd2data>
  8017aa:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8017ac:	89 34 24             	mov    %esi,(%esp)
  8017af:	e8 ca fd ff ff       	call   80157e <fd2data>
  8017b4:	83 c4 10             	add    $0x10,%esp
  8017b7:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8017b9:	89 d8                	mov    %ebx,%eax
  8017bb:	c1 e8 16             	shr    $0x16,%eax
  8017be:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8017c5:	a8 01                	test   $0x1,%al
  8017c7:	74 11                	je     8017da <dup+0x74>
  8017c9:	89 d8                	mov    %ebx,%eax
  8017cb:	c1 e8 0c             	shr    $0xc,%eax
  8017ce:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8017d5:	f6 c2 01             	test   $0x1,%dl
  8017d8:	75 39                	jne    801813 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8017da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8017dd:	89 d0                	mov    %edx,%eax
  8017df:	c1 e8 0c             	shr    $0xc,%eax
  8017e2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8017e9:	83 ec 0c             	sub    $0xc,%esp
  8017ec:	25 07 0e 00 00       	and    $0xe07,%eax
  8017f1:	50                   	push   %eax
  8017f2:	56                   	push   %esi
  8017f3:	6a 00                	push   $0x0
  8017f5:	52                   	push   %edx
  8017f6:	6a 00                	push   $0x0
  8017f8:	e8 66 f7 ff ff       	call   800f63 <sys_page_map>
  8017fd:	89 c3                	mov    %eax,%ebx
  8017ff:	83 c4 20             	add    $0x20,%esp
  801802:	85 c0                	test   %eax,%eax
  801804:	78 31                	js     801837 <dup+0xd1>
		goto err;

	return newfdnum;
  801806:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801809:	89 d8                	mov    %ebx,%eax
  80180b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80180e:	5b                   	pop    %ebx
  80180f:	5e                   	pop    %esi
  801810:	5f                   	pop    %edi
  801811:	5d                   	pop    %ebp
  801812:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801813:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80181a:	83 ec 0c             	sub    $0xc,%esp
  80181d:	25 07 0e 00 00       	and    $0xe07,%eax
  801822:	50                   	push   %eax
  801823:	57                   	push   %edi
  801824:	6a 00                	push   $0x0
  801826:	53                   	push   %ebx
  801827:	6a 00                	push   $0x0
  801829:	e8 35 f7 ff ff       	call   800f63 <sys_page_map>
  80182e:	89 c3                	mov    %eax,%ebx
  801830:	83 c4 20             	add    $0x20,%esp
  801833:	85 c0                	test   %eax,%eax
  801835:	79 a3                	jns    8017da <dup+0x74>
	sys_page_unmap(0, newfd);
  801837:	83 ec 08             	sub    $0x8,%esp
  80183a:	56                   	push   %esi
  80183b:	6a 00                	push   $0x0
  80183d:	e8 63 f7 ff ff       	call   800fa5 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801842:	83 c4 08             	add    $0x8,%esp
  801845:	57                   	push   %edi
  801846:	6a 00                	push   $0x0
  801848:	e8 58 f7 ff ff       	call   800fa5 <sys_page_unmap>
	return r;
  80184d:	83 c4 10             	add    $0x10,%esp
  801850:	eb b7                	jmp    801809 <dup+0xa3>

00801852 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801852:	55                   	push   %ebp
  801853:	89 e5                	mov    %esp,%ebp
  801855:	53                   	push   %ebx
  801856:	83 ec 1c             	sub    $0x1c,%esp
  801859:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80185c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80185f:	50                   	push   %eax
  801860:	53                   	push   %ebx
  801861:	e8 81 fd ff ff       	call   8015e7 <fd_lookup>
  801866:	83 c4 10             	add    $0x10,%esp
  801869:	85 c0                	test   %eax,%eax
  80186b:	78 3f                	js     8018ac <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80186d:	83 ec 08             	sub    $0x8,%esp
  801870:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801873:	50                   	push   %eax
  801874:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801877:	ff 30                	pushl  (%eax)
  801879:	e8 b9 fd ff ff       	call   801637 <dev_lookup>
  80187e:	83 c4 10             	add    $0x10,%esp
  801881:	85 c0                	test   %eax,%eax
  801883:	78 27                	js     8018ac <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801885:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801888:	8b 42 08             	mov    0x8(%edx),%eax
  80188b:	83 e0 03             	and    $0x3,%eax
  80188e:	83 f8 01             	cmp    $0x1,%eax
  801891:	74 1e                	je     8018b1 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801893:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801896:	8b 40 08             	mov    0x8(%eax),%eax
  801899:	85 c0                	test   %eax,%eax
  80189b:	74 35                	je     8018d2 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80189d:	83 ec 04             	sub    $0x4,%esp
  8018a0:	ff 75 10             	pushl  0x10(%ebp)
  8018a3:	ff 75 0c             	pushl  0xc(%ebp)
  8018a6:	52                   	push   %edx
  8018a7:	ff d0                	call   *%eax
  8018a9:	83 c4 10             	add    $0x10,%esp
}
  8018ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018af:	c9                   	leave  
  8018b0:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8018b1:	a1 04 40 80 00       	mov    0x804004,%eax
  8018b6:	8b 40 48             	mov    0x48(%eax),%eax
  8018b9:	83 ec 04             	sub    $0x4,%esp
  8018bc:	53                   	push   %ebx
  8018bd:	50                   	push   %eax
  8018be:	68 b1 2d 80 00       	push   $0x802db1
  8018c3:	e8 40 eb ff ff       	call   800408 <cprintf>
		return -E_INVAL;
  8018c8:	83 c4 10             	add    $0x10,%esp
  8018cb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018d0:	eb da                	jmp    8018ac <read+0x5a>
		return -E_NOT_SUPP;
  8018d2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018d7:	eb d3                	jmp    8018ac <read+0x5a>

008018d9 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8018d9:	55                   	push   %ebp
  8018da:	89 e5                	mov    %esp,%ebp
  8018dc:	57                   	push   %edi
  8018dd:	56                   	push   %esi
  8018de:	53                   	push   %ebx
  8018df:	83 ec 0c             	sub    $0xc,%esp
  8018e2:	8b 7d 08             	mov    0x8(%ebp),%edi
  8018e5:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8018e8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018ed:	39 f3                	cmp    %esi,%ebx
  8018ef:	73 23                	jae    801914 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8018f1:	83 ec 04             	sub    $0x4,%esp
  8018f4:	89 f0                	mov    %esi,%eax
  8018f6:	29 d8                	sub    %ebx,%eax
  8018f8:	50                   	push   %eax
  8018f9:	89 d8                	mov    %ebx,%eax
  8018fb:	03 45 0c             	add    0xc(%ebp),%eax
  8018fe:	50                   	push   %eax
  8018ff:	57                   	push   %edi
  801900:	e8 4d ff ff ff       	call   801852 <read>
		if (m < 0)
  801905:	83 c4 10             	add    $0x10,%esp
  801908:	85 c0                	test   %eax,%eax
  80190a:	78 06                	js     801912 <readn+0x39>
			return m;
		if (m == 0)
  80190c:	74 06                	je     801914 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  80190e:	01 c3                	add    %eax,%ebx
  801910:	eb db                	jmp    8018ed <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801912:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801914:	89 d8                	mov    %ebx,%eax
  801916:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801919:	5b                   	pop    %ebx
  80191a:	5e                   	pop    %esi
  80191b:	5f                   	pop    %edi
  80191c:	5d                   	pop    %ebp
  80191d:	c3                   	ret    

0080191e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80191e:	55                   	push   %ebp
  80191f:	89 e5                	mov    %esp,%ebp
  801921:	53                   	push   %ebx
  801922:	83 ec 1c             	sub    $0x1c,%esp
  801925:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801928:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80192b:	50                   	push   %eax
  80192c:	53                   	push   %ebx
  80192d:	e8 b5 fc ff ff       	call   8015e7 <fd_lookup>
  801932:	83 c4 10             	add    $0x10,%esp
  801935:	85 c0                	test   %eax,%eax
  801937:	78 3a                	js     801973 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801939:	83 ec 08             	sub    $0x8,%esp
  80193c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80193f:	50                   	push   %eax
  801940:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801943:	ff 30                	pushl  (%eax)
  801945:	e8 ed fc ff ff       	call   801637 <dev_lookup>
  80194a:	83 c4 10             	add    $0x10,%esp
  80194d:	85 c0                	test   %eax,%eax
  80194f:	78 22                	js     801973 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801951:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801954:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801958:	74 1e                	je     801978 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80195a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80195d:	8b 52 0c             	mov    0xc(%edx),%edx
  801960:	85 d2                	test   %edx,%edx
  801962:	74 35                	je     801999 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801964:	83 ec 04             	sub    $0x4,%esp
  801967:	ff 75 10             	pushl  0x10(%ebp)
  80196a:	ff 75 0c             	pushl  0xc(%ebp)
  80196d:	50                   	push   %eax
  80196e:	ff d2                	call   *%edx
  801970:	83 c4 10             	add    $0x10,%esp
}
  801973:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801976:	c9                   	leave  
  801977:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801978:	a1 04 40 80 00       	mov    0x804004,%eax
  80197d:	8b 40 48             	mov    0x48(%eax),%eax
  801980:	83 ec 04             	sub    $0x4,%esp
  801983:	53                   	push   %ebx
  801984:	50                   	push   %eax
  801985:	68 cd 2d 80 00       	push   $0x802dcd
  80198a:	e8 79 ea ff ff       	call   800408 <cprintf>
		return -E_INVAL;
  80198f:	83 c4 10             	add    $0x10,%esp
  801992:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801997:	eb da                	jmp    801973 <write+0x55>
		return -E_NOT_SUPP;
  801999:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80199e:	eb d3                	jmp    801973 <write+0x55>

008019a0 <seek>:

int
seek(int fdnum, off_t offset)
{
  8019a0:	55                   	push   %ebp
  8019a1:	89 e5                	mov    %esp,%ebp
  8019a3:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019a9:	50                   	push   %eax
  8019aa:	ff 75 08             	pushl  0x8(%ebp)
  8019ad:	e8 35 fc ff ff       	call   8015e7 <fd_lookup>
  8019b2:	83 c4 10             	add    $0x10,%esp
  8019b5:	85 c0                	test   %eax,%eax
  8019b7:	78 0e                	js     8019c7 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8019b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019bf:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8019c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019c7:	c9                   	leave  
  8019c8:	c3                   	ret    

008019c9 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8019c9:	55                   	push   %ebp
  8019ca:	89 e5                	mov    %esp,%ebp
  8019cc:	53                   	push   %ebx
  8019cd:	83 ec 1c             	sub    $0x1c,%esp
  8019d0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019d3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019d6:	50                   	push   %eax
  8019d7:	53                   	push   %ebx
  8019d8:	e8 0a fc ff ff       	call   8015e7 <fd_lookup>
  8019dd:	83 c4 10             	add    $0x10,%esp
  8019e0:	85 c0                	test   %eax,%eax
  8019e2:	78 37                	js     801a1b <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019e4:	83 ec 08             	sub    $0x8,%esp
  8019e7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019ea:	50                   	push   %eax
  8019eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019ee:	ff 30                	pushl  (%eax)
  8019f0:	e8 42 fc ff ff       	call   801637 <dev_lookup>
  8019f5:	83 c4 10             	add    $0x10,%esp
  8019f8:	85 c0                	test   %eax,%eax
  8019fa:	78 1f                	js     801a1b <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8019fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019ff:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a03:	74 1b                	je     801a20 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801a05:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a08:	8b 52 18             	mov    0x18(%edx),%edx
  801a0b:	85 d2                	test   %edx,%edx
  801a0d:	74 32                	je     801a41 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801a0f:	83 ec 08             	sub    $0x8,%esp
  801a12:	ff 75 0c             	pushl  0xc(%ebp)
  801a15:	50                   	push   %eax
  801a16:	ff d2                	call   *%edx
  801a18:	83 c4 10             	add    $0x10,%esp
}
  801a1b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a1e:	c9                   	leave  
  801a1f:	c3                   	ret    
			thisenv->env_id, fdnum);
  801a20:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801a25:	8b 40 48             	mov    0x48(%eax),%eax
  801a28:	83 ec 04             	sub    $0x4,%esp
  801a2b:	53                   	push   %ebx
  801a2c:	50                   	push   %eax
  801a2d:	68 90 2d 80 00       	push   $0x802d90
  801a32:	e8 d1 e9 ff ff       	call   800408 <cprintf>
		return -E_INVAL;
  801a37:	83 c4 10             	add    $0x10,%esp
  801a3a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a3f:	eb da                	jmp    801a1b <ftruncate+0x52>
		return -E_NOT_SUPP;
  801a41:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a46:	eb d3                	jmp    801a1b <ftruncate+0x52>

00801a48 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801a48:	55                   	push   %ebp
  801a49:	89 e5                	mov    %esp,%ebp
  801a4b:	53                   	push   %ebx
  801a4c:	83 ec 1c             	sub    $0x1c,%esp
  801a4f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a52:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a55:	50                   	push   %eax
  801a56:	ff 75 08             	pushl  0x8(%ebp)
  801a59:	e8 89 fb ff ff       	call   8015e7 <fd_lookup>
  801a5e:	83 c4 10             	add    $0x10,%esp
  801a61:	85 c0                	test   %eax,%eax
  801a63:	78 4b                	js     801ab0 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a65:	83 ec 08             	sub    $0x8,%esp
  801a68:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a6b:	50                   	push   %eax
  801a6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a6f:	ff 30                	pushl  (%eax)
  801a71:	e8 c1 fb ff ff       	call   801637 <dev_lookup>
  801a76:	83 c4 10             	add    $0x10,%esp
  801a79:	85 c0                	test   %eax,%eax
  801a7b:	78 33                	js     801ab0 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801a7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a80:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801a84:	74 2f                	je     801ab5 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801a86:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801a89:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801a90:	00 00 00 
	stat->st_isdir = 0;
  801a93:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801a9a:	00 00 00 
	stat->st_dev = dev;
  801a9d:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801aa3:	83 ec 08             	sub    $0x8,%esp
  801aa6:	53                   	push   %ebx
  801aa7:	ff 75 f0             	pushl  -0x10(%ebp)
  801aaa:	ff 50 14             	call   *0x14(%eax)
  801aad:	83 c4 10             	add    $0x10,%esp
}
  801ab0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ab3:	c9                   	leave  
  801ab4:	c3                   	ret    
		return -E_NOT_SUPP;
  801ab5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801aba:	eb f4                	jmp    801ab0 <fstat+0x68>

00801abc <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801abc:	55                   	push   %ebp
  801abd:	89 e5                	mov    %esp,%ebp
  801abf:	56                   	push   %esi
  801ac0:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801ac1:	83 ec 08             	sub    $0x8,%esp
  801ac4:	6a 00                	push   $0x0
  801ac6:	ff 75 08             	pushl  0x8(%ebp)
  801ac9:	e8 bb 01 00 00       	call   801c89 <open>
  801ace:	89 c3                	mov    %eax,%ebx
  801ad0:	83 c4 10             	add    $0x10,%esp
  801ad3:	85 c0                	test   %eax,%eax
  801ad5:	78 1b                	js     801af2 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801ad7:	83 ec 08             	sub    $0x8,%esp
  801ada:	ff 75 0c             	pushl  0xc(%ebp)
  801add:	50                   	push   %eax
  801ade:	e8 65 ff ff ff       	call   801a48 <fstat>
  801ae3:	89 c6                	mov    %eax,%esi
	close(fd);
  801ae5:	89 1c 24             	mov    %ebx,(%esp)
  801ae8:	e8 27 fc ff ff       	call   801714 <close>
	return r;
  801aed:	83 c4 10             	add    $0x10,%esp
  801af0:	89 f3                	mov    %esi,%ebx
}
  801af2:	89 d8                	mov    %ebx,%eax
  801af4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801af7:	5b                   	pop    %ebx
  801af8:	5e                   	pop    %esi
  801af9:	5d                   	pop    %ebp
  801afa:	c3                   	ret    

00801afb <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801afb:	55                   	push   %ebp
  801afc:	89 e5                	mov    %esp,%ebp
  801afe:	56                   	push   %esi
  801aff:	53                   	push   %ebx
  801b00:	89 c6                	mov    %eax,%esi
  801b02:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801b04:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801b0b:	74 27                	je     801b34 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801b0d:	6a 07                	push   $0x7
  801b0f:	68 00 50 80 00       	push   $0x805000
  801b14:	56                   	push   %esi
  801b15:	ff 35 00 40 80 00    	pushl  0x804000
  801b1b:	e8 1d 08 00 00       	call   80233d <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801b20:	83 c4 0c             	add    $0xc,%esp
  801b23:	6a 00                	push   $0x0
  801b25:	53                   	push   %ebx
  801b26:	6a 00                	push   $0x0
  801b28:	e8 a7 07 00 00       	call   8022d4 <ipc_recv>
}
  801b2d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b30:	5b                   	pop    %ebx
  801b31:	5e                   	pop    %esi
  801b32:	5d                   	pop    %ebp
  801b33:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801b34:	83 ec 0c             	sub    $0xc,%esp
  801b37:	6a 01                	push   $0x1
  801b39:	e8 4c 08 00 00       	call   80238a <ipc_find_env>
  801b3e:	a3 00 40 80 00       	mov    %eax,0x804000
  801b43:	83 c4 10             	add    $0x10,%esp
  801b46:	eb c5                	jmp    801b0d <fsipc+0x12>

00801b48 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801b48:	55                   	push   %ebp
  801b49:	89 e5                	mov    %esp,%ebp
  801b4b:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b51:	8b 40 0c             	mov    0xc(%eax),%eax
  801b54:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801b59:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b5c:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801b61:	ba 00 00 00 00       	mov    $0x0,%edx
  801b66:	b8 02 00 00 00       	mov    $0x2,%eax
  801b6b:	e8 8b ff ff ff       	call   801afb <fsipc>
}
  801b70:	c9                   	leave  
  801b71:	c3                   	ret    

00801b72 <devfile_flush>:
{
  801b72:	55                   	push   %ebp
  801b73:	89 e5                	mov    %esp,%ebp
  801b75:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801b78:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7b:	8b 40 0c             	mov    0xc(%eax),%eax
  801b7e:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801b83:	ba 00 00 00 00       	mov    $0x0,%edx
  801b88:	b8 06 00 00 00       	mov    $0x6,%eax
  801b8d:	e8 69 ff ff ff       	call   801afb <fsipc>
}
  801b92:	c9                   	leave  
  801b93:	c3                   	ret    

00801b94 <devfile_stat>:
{
  801b94:	55                   	push   %ebp
  801b95:	89 e5                	mov    %esp,%ebp
  801b97:	53                   	push   %ebx
  801b98:	83 ec 04             	sub    $0x4,%esp
  801b9b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba1:	8b 40 0c             	mov    0xc(%eax),%eax
  801ba4:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801ba9:	ba 00 00 00 00       	mov    $0x0,%edx
  801bae:	b8 05 00 00 00       	mov    $0x5,%eax
  801bb3:	e8 43 ff ff ff       	call   801afb <fsipc>
  801bb8:	85 c0                	test   %eax,%eax
  801bba:	78 2c                	js     801be8 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801bbc:	83 ec 08             	sub    $0x8,%esp
  801bbf:	68 00 50 80 00       	push   $0x805000
  801bc4:	53                   	push   %ebx
  801bc5:	e8 64 ef ff ff       	call   800b2e <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801bca:	a1 80 50 80 00       	mov    0x805080,%eax
  801bcf:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801bd5:	a1 84 50 80 00       	mov    0x805084,%eax
  801bda:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801be0:	83 c4 10             	add    $0x10,%esp
  801be3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801be8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801beb:	c9                   	leave  
  801bec:	c3                   	ret    

00801bed <devfile_write>:
{
  801bed:	55                   	push   %ebp
  801bee:	89 e5                	mov    %esp,%ebp
  801bf0:	83 ec 0c             	sub    $0xc,%esp
	panic("devfile_write not implemented");
  801bf3:	68 fc 2d 80 00       	push   $0x802dfc
  801bf8:	68 90 00 00 00       	push   $0x90
  801bfd:	68 1a 2e 80 00       	push   $0x802e1a
  801c02:	e8 26 e7 ff ff       	call   80032d <_panic>

00801c07 <devfile_read>:
{
  801c07:	55                   	push   %ebp
  801c08:	89 e5                	mov    %esp,%ebp
  801c0a:	56                   	push   %esi
  801c0b:	53                   	push   %ebx
  801c0c:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c12:	8b 40 0c             	mov    0xc(%eax),%eax
  801c15:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801c1a:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801c20:	ba 00 00 00 00       	mov    $0x0,%edx
  801c25:	b8 03 00 00 00       	mov    $0x3,%eax
  801c2a:	e8 cc fe ff ff       	call   801afb <fsipc>
  801c2f:	89 c3                	mov    %eax,%ebx
  801c31:	85 c0                	test   %eax,%eax
  801c33:	78 1f                	js     801c54 <devfile_read+0x4d>
	assert(r <= n);
  801c35:	39 f0                	cmp    %esi,%eax
  801c37:	77 24                	ja     801c5d <devfile_read+0x56>
	assert(r <= PGSIZE);
  801c39:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c3e:	7f 33                	jg     801c73 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801c40:	83 ec 04             	sub    $0x4,%esp
  801c43:	50                   	push   %eax
  801c44:	68 00 50 80 00       	push   $0x805000
  801c49:	ff 75 0c             	pushl  0xc(%ebp)
  801c4c:	e8 6b f0 ff ff       	call   800cbc <memmove>
	return r;
  801c51:	83 c4 10             	add    $0x10,%esp
}
  801c54:	89 d8                	mov    %ebx,%eax
  801c56:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c59:	5b                   	pop    %ebx
  801c5a:	5e                   	pop    %esi
  801c5b:	5d                   	pop    %ebp
  801c5c:	c3                   	ret    
	assert(r <= n);
  801c5d:	68 25 2e 80 00       	push   $0x802e25
  801c62:	68 2c 2e 80 00       	push   $0x802e2c
  801c67:	6a 7c                	push   $0x7c
  801c69:	68 1a 2e 80 00       	push   $0x802e1a
  801c6e:	e8 ba e6 ff ff       	call   80032d <_panic>
	assert(r <= PGSIZE);
  801c73:	68 41 2e 80 00       	push   $0x802e41
  801c78:	68 2c 2e 80 00       	push   $0x802e2c
  801c7d:	6a 7d                	push   $0x7d
  801c7f:	68 1a 2e 80 00       	push   $0x802e1a
  801c84:	e8 a4 e6 ff ff       	call   80032d <_panic>

00801c89 <open>:
{
  801c89:	55                   	push   %ebp
  801c8a:	89 e5                	mov    %esp,%ebp
  801c8c:	56                   	push   %esi
  801c8d:	53                   	push   %ebx
  801c8e:	83 ec 1c             	sub    $0x1c,%esp
  801c91:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801c94:	56                   	push   %esi
  801c95:	e8 5b ee ff ff       	call   800af5 <strlen>
  801c9a:	83 c4 10             	add    $0x10,%esp
  801c9d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801ca2:	7f 6c                	jg     801d10 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801ca4:	83 ec 0c             	sub    $0xc,%esp
  801ca7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801caa:	50                   	push   %eax
  801cab:	e8 e5 f8 ff ff       	call   801595 <fd_alloc>
  801cb0:	89 c3                	mov    %eax,%ebx
  801cb2:	83 c4 10             	add    $0x10,%esp
  801cb5:	85 c0                	test   %eax,%eax
  801cb7:	78 3c                	js     801cf5 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801cb9:	83 ec 08             	sub    $0x8,%esp
  801cbc:	56                   	push   %esi
  801cbd:	68 00 50 80 00       	push   $0x805000
  801cc2:	e8 67 ee ff ff       	call   800b2e <strcpy>
	fsipcbuf.open.req_omode = mode;
  801cc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cca:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801ccf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cd2:	b8 01 00 00 00       	mov    $0x1,%eax
  801cd7:	e8 1f fe ff ff       	call   801afb <fsipc>
  801cdc:	89 c3                	mov    %eax,%ebx
  801cde:	83 c4 10             	add    $0x10,%esp
  801ce1:	85 c0                	test   %eax,%eax
  801ce3:	78 19                	js     801cfe <open+0x75>
	return fd2num(fd);
  801ce5:	83 ec 0c             	sub    $0xc,%esp
  801ce8:	ff 75 f4             	pushl  -0xc(%ebp)
  801ceb:	e8 7e f8 ff ff       	call   80156e <fd2num>
  801cf0:	89 c3                	mov    %eax,%ebx
  801cf2:	83 c4 10             	add    $0x10,%esp
}
  801cf5:	89 d8                	mov    %ebx,%eax
  801cf7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cfa:	5b                   	pop    %ebx
  801cfb:	5e                   	pop    %esi
  801cfc:	5d                   	pop    %ebp
  801cfd:	c3                   	ret    
		fd_close(fd, 0);
  801cfe:	83 ec 08             	sub    $0x8,%esp
  801d01:	6a 00                	push   $0x0
  801d03:	ff 75 f4             	pushl  -0xc(%ebp)
  801d06:	e8 82 f9 ff ff       	call   80168d <fd_close>
		return r;
  801d0b:	83 c4 10             	add    $0x10,%esp
  801d0e:	eb e5                	jmp    801cf5 <open+0x6c>
		return -E_BAD_PATH;
  801d10:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801d15:	eb de                	jmp    801cf5 <open+0x6c>

00801d17 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801d17:	55                   	push   %ebp
  801d18:	89 e5                	mov    %esp,%ebp
  801d1a:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801d1d:	ba 00 00 00 00       	mov    $0x0,%edx
  801d22:	b8 08 00 00 00       	mov    $0x8,%eax
  801d27:	e8 cf fd ff ff       	call   801afb <fsipc>
}
  801d2c:	c9                   	leave  
  801d2d:	c3                   	ret    

00801d2e <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801d2e:	55                   	push   %ebp
  801d2f:	89 e5                	mov    %esp,%ebp
  801d31:	56                   	push   %esi
  801d32:	53                   	push   %ebx
  801d33:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801d36:	83 ec 0c             	sub    $0xc,%esp
  801d39:	ff 75 08             	pushl  0x8(%ebp)
  801d3c:	e8 3d f8 ff ff       	call   80157e <fd2data>
  801d41:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801d43:	83 c4 08             	add    $0x8,%esp
  801d46:	68 4d 2e 80 00       	push   $0x802e4d
  801d4b:	53                   	push   %ebx
  801d4c:	e8 dd ed ff ff       	call   800b2e <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801d51:	8b 46 04             	mov    0x4(%esi),%eax
  801d54:	2b 06                	sub    (%esi),%eax
  801d56:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801d5c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d63:	00 00 00 
	stat->st_dev = &devpipe;
  801d66:	c7 83 88 00 00 00 24 	movl   $0x803024,0x88(%ebx)
  801d6d:	30 80 00 
	return 0;
}
  801d70:	b8 00 00 00 00       	mov    $0x0,%eax
  801d75:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d78:	5b                   	pop    %ebx
  801d79:	5e                   	pop    %esi
  801d7a:	5d                   	pop    %ebp
  801d7b:	c3                   	ret    

00801d7c <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d7c:	55                   	push   %ebp
  801d7d:	89 e5                	mov    %esp,%ebp
  801d7f:	53                   	push   %ebx
  801d80:	83 ec 0c             	sub    $0xc,%esp
  801d83:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d86:	53                   	push   %ebx
  801d87:	6a 00                	push   $0x0
  801d89:	e8 17 f2 ff ff       	call   800fa5 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d8e:	89 1c 24             	mov    %ebx,(%esp)
  801d91:	e8 e8 f7 ff ff       	call   80157e <fd2data>
  801d96:	83 c4 08             	add    $0x8,%esp
  801d99:	50                   	push   %eax
  801d9a:	6a 00                	push   $0x0
  801d9c:	e8 04 f2 ff ff       	call   800fa5 <sys_page_unmap>
}
  801da1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801da4:	c9                   	leave  
  801da5:	c3                   	ret    

00801da6 <_pipeisclosed>:
{
  801da6:	55                   	push   %ebp
  801da7:	89 e5                	mov    %esp,%ebp
  801da9:	57                   	push   %edi
  801daa:	56                   	push   %esi
  801dab:	53                   	push   %ebx
  801dac:	83 ec 1c             	sub    $0x1c,%esp
  801daf:	89 c7                	mov    %eax,%edi
  801db1:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801db3:	a1 04 40 80 00       	mov    0x804004,%eax
  801db8:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801dbb:	83 ec 0c             	sub    $0xc,%esp
  801dbe:	57                   	push   %edi
  801dbf:	e8 05 06 00 00       	call   8023c9 <pageref>
  801dc4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801dc7:	89 34 24             	mov    %esi,(%esp)
  801dca:	e8 fa 05 00 00       	call   8023c9 <pageref>
		nn = thisenv->env_runs;
  801dcf:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801dd5:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801dd8:	83 c4 10             	add    $0x10,%esp
  801ddb:	39 cb                	cmp    %ecx,%ebx
  801ddd:	74 1b                	je     801dfa <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801ddf:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801de2:	75 cf                	jne    801db3 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801de4:	8b 42 58             	mov    0x58(%edx),%eax
  801de7:	6a 01                	push   $0x1
  801de9:	50                   	push   %eax
  801dea:	53                   	push   %ebx
  801deb:	68 54 2e 80 00       	push   $0x802e54
  801df0:	e8 13 e6 ff ff       	call   800408 <cprintf>
  801df5:	83 c4 10             	add    $0x10,%esp
  801df8:	eb b9                	jmp    801db3 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801dfa:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801dfd:	0f 94 c0             	sete   %al
  801e00:	0f b6 c0             	movzbl %al,%eax
}
  801e03:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e06:	5b                   	pop    %ebx
  801e07:	5e                   	pop    %esi
  801e08:	5f                   	pop    %edi
  801e09:	5d                   	pop    %ebp
  801e0a:	c3                   	ret    

00801e0b <devpipe_write>:
{
  801e0b:	55                   	push   %ebp
  801e0c:	89 e5                	mov    %esp,%ebp
  801e0e:	57                   	push   %edi
  801e0f:	56                   	push   %esi
  801e10:	53                   	push   %ebx
  801e11:	83 ec 28             	sub    $0x28,%esp
  801e14:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801e17:	56                   	push   %esi
  801e18:	e8 61 f7 ff ff       	call   80157e <fd2data>
  801e1d:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e1f:	83 c4 10             	add    $0x10,%esp
  801e22:	bf 00 00 00 00       	mov    $0x0,%edi
  801e27:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801e2a:	74 4f                	je     801e7b <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801e2c:	8b 43 04             	mov    0x4(%ebx),%eax
  801e2f:	8b 0b                	mov    (%ebx),%ecx
  801e31:	8d 51 20             	lea    0x20(%ecx),%edx
  801e34:	39 d0                	cmp    %edx,%eax
  801e36:	72 14                	jb     801e4c <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801e38:	89 da                	mov    %ebx,%edx
  801e3a:	89 f0                	mov    %esi,%eax
  801e3c:	e8 65 ff ff ff       	call   801da6 <_pipeisclosed>
  801e41:	85 c0                	test   %eax,%eax
  801e43:	75 3b                	jne    801e80 <devpipe_write+0x75>
			sys_yield();
  801e45:	e8 b7 f0 ff ff       	call   800f01 <sys_yield>
  801e4a:	eb e0                	jmp    801e2c <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801e4c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e4f:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801e53:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801e56:	89 c2                	mov    %eax,%edx
  801e58:	c1 fa 1f             	sar    $0x1f,%edx
  801e5b:	89 d1                	mov    %edx,%ecx
  801e5d:	c1 e9 1b             	shr    $0x1b,%ecx
  801e60:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801e63:	83 e2 1f             	and    $0x1f,%edx
  801e66:	29 ca                	sub    %ecx,%edx
  801e68:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801e6c:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801e70:	83 c0 01             	add    $0x1,%eax
  801e73:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801e76:	83 c7 01             	add    $0x1,%edi
  801e79:	eb ac                	jmp    801e27 <devpipe_write+0x1c>
	return i;
  801e7b:	8b 45 10             	mov    0x10(%ebp),%eax
  801e7e:	eb 05                	jmp    801e85 <devpipe_write+0x7a>
				return 0;
  801e80:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e85:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e88:	5b                   	pop    %ebx
  801e89:	5e                   	pop    %esi
  801e8a:	5f                   	pop    %edi
  801e8b:	5d                   	pop    %ebp
  801e8c:	c3                   	ret    

00801e8d <devpipe_read>:
{
  801e8d:	55                   	push   %ebp
  801e8e:	89 e5                	mov    %esp,%ebp
  801e90:	57                   	push   %edi
  801e91:	56                   	push   %esi
  801e92:	53                   	push   %ebx
  801e93:	83 ec 18             	sub    $0x18,%esp
  801e96:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801e99:	57                   	push   %edi
  801e9a:	e8 df f6 ff ff       	call   80157e <fd2data>
  801e9f:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801ea1:	83 c4 10             	add    $0x10,%esp
  801ea4:	be 00 00 00 00       	mov    $0x0,%esi
  801ea9:	3b 75 10             	cmp    0x10(%ebp),%esi
  801eac:	75 14                	jne    801ec2 <devpipe_read+0x35>
	return i;
  801eae:	8b 45 10             	mov    0x10(%ebp),%eax
  801eb1:	eb 02                	jmp    801eb5 <devpipe_read+0x28>
				return i;
  801eb3:	89 f0                	mov    %esi,%eax
}
  801eb5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801eb8:	5b                   	pop    %ebx
  801eb9:	5e                   	pop    %esi
  801eba:	5f                   	pop    %edi
  801ebb:	5d                   	pop    %ebp
  801ebc:	c3                   	ret    
			sys_yield();
  801ebd:	e8 3f f0 ff ff       	call   800f01 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801ec2:	8b 03                	mov    (%ebx),%eax
  801ec4:	3b 43 04             	cmp    0x4(%ebx),%eax
  801ec7:	75 18                	jne    801ee1 <devpipe_read+0x54>
			if (i > 0)
  801ec9:	85 f6                	test   %esi,%esi
  801ecb:	75 e6                	jne    801eb3 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801ecd:	89 da                	mov    %ebx,%edx
  801ecf:	89 f8                	mov    %edi,%eax
  801ed1:	e8 d0 fe ff ff       	call   801da6 <_pipeisclosed>
  801ed6:	85 c0                	test   %eax,%eax
  801ed8:	74 e3                	je     801ebd <devpipe_read+0x30>
				return 0;
  801eda:	b8 00 00 00 00       	mov    $0x0,%eax
  801edf:	eb d4                	jmp    801eb5 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801ee1:	99                   	cltd   
  801ee2:	c1 ea 1b             	shr    $0x1b,%edx
  801ee5:	01 d0                	add    %edx,%eax
  801ee7:	83 e0 1f             	and    $0x1f,%eax
  801eea:	29 d0                	sub    %edx,%eax
  801eec:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801ef1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ef4:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801ef7:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801efa:	83 c6 01             	add    $0x1,%esi
  801efd:	eb aa                	jmp    801ea9 <devpipe_read+0x1c>

00801eff <pipe>:
{
  801eff:	55                   	push   %ebp
  801f00:	89 e5                	mov    %esp,%ebp
  801f02:	56                   	push   %esi
  801f03:	53                   	push   %ebx
  801f04:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801f07:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f0a:	50                   	push   %eax
  801f0b:	e8 85 f6 ff ff       	call   801595 <fd_alloc>
  801f10:	89 c3                	mov    %eax,%ebx
  801f12:	83 c4 10             	add    $0x10,%esp
  801f15:	85 c0                	test   %eax,%eax
  801f17:	0f 88 23 01 00 00    	js     802040 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f1d:	83 ec 04             	sub    $0x4,%esp
  801f20:	68 07 04 00 00       	push   $0x407
  801f25:	ff 75 f4             	pushl  -0xc(%ebp)
  801f28:	6a 00                	push   $0x0
  801f2a:	e8 f1 ef ff ff       	call   800f20 <sys_page_alloc>
  801f2f:	89 c3                	mov    %eax,%ebx
  801f31:	83 c4 10             	add    $0x10,%esp
  801f34:	85 c0                	test   %eax,%eax
  801f36:	0f 88 04 01 00 00    	js     802040 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801f3c:	83 ec 0c             	sub    $0xc,%esp
  801f3f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801f42:	50                   	push   %eax
  801f43:	e8 4d f6 ff ff       	call   801595 <fd_alloc>
  801f48:	89 c3                	mov    %eax,%ebx
  801f4a:	83 c4 10             	add    $0x10,%esp
  801f4d:	85 c0                	test   %eax,%eax
  801f4f:	0f 88 db 00 00 00    	js     802030 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f55:	83 ec 04             	sub    $0x4,%esp
  801f58:	68 07 04 00 00       	push   $0x407
  801f5d:	ff 75 f0             	pushl  -0x10(%ebp)
  801f60:	6a 00                	push   $0x0
  801f62:	e8 b9 ef ff ff       	call   800f20 <sys_page_alloc>
  801f67:	89 c3                	mov    %eax,%ebx
  801f69:	83 c4 10             	add    $0x10,%esp
  801f6c:	85 c0                	test   %eax,%eax
  801f6e:	0f 88 bc 00 00 00    	js     802030 <pipe+0x131>
	va = fd2data(fd0);
  801f74:	83 ec 0c             	sub    $0xc,%esp
  801f77:	ff 75 f4             	pushl  -0xc(%ebp)
  801f7a:	e8 ff f5 ff ff       	call   80157e <fd2data>
  801f7f:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f81:	83 c4 0c             	add    $0xc,%esp
  801f84:	68 07 04 00 00       	push   $0x407
  801f89:	50                   	push   %eax
  801f8a:	6a 00                	push   $0x0
  801f8c:	e8 8f ef ff ff       	call   800f20 <sys_page_alloc>
  801f91:	89 c3                	mov    %eax,%ebx
  801f93:	83 c4 10             	add    $0x10,%esp
  801f96:	85 c0                	test   %eax,%eax
  801f98:	0f 88 82 00 00 00    	js     802020 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f9e:	83 ec 0c             	sub    $0xc,%esp
  801fa1:	ff 75 f0             	pushl  -0x10(%ebp)
  801fa4:	e8 d5 f5 ff ff       	call   80157e <fd2data>
  801fa9:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801fb0:	50                   	push   %eax
  801fb1:	6a 00                	push   $0x0
  801fb3:	56                   	push   %esi
  801fb4:	6a 00                	push   $0x0
  801fb6:	e8 a8 ef ff ff       	call   800f63 <sys_page_map>
  801fbb:	89 c3                	mov    %eax,%ebx
  801fbd:	83 c4 20             	add    $0x20,%esp
  801fc0:	85 c0                	test   %eax,%eax
  801fc2:	78 4e                	js     802012 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801fc4:	a1 24 30 80 00       	mov    0x803024,%eax
  801fc9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fcc:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801fce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fd1:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801fd8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801fdb:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801fdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fe0:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801fe7:	83 ec 0c             	sub    $0xc,%esp
  801fea:	ff 75 f4             	pushl  -0xc(%ebp)
  801fed:	e8 7c f5 ff ff       	call   80156e <fd2num>
  801ff2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ff5:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801ff7:	83 c4 04             	add    $0x4,%esp
  801ffa:	ff 75 f0             	pushl  -0x10(%ebp)
  801ffd:	e8 6c f5 ff ff       	call   80156e <fd2num>
  802002:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802005:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802008:	83 c4 10             	add    $0x10,%esp
  80200b:	bb 00 00 00 00       	mov    $0x0,%ebx
  802010:	eb 2e                	jmp    802040 <pipe+0x141>
	sys_page_unmap(0, va);
  802012:	83 ec 08             	sub    $0x8,%esp
  802015:	56                   	push   %esi
  802016:	6a 00                	push   $0x0
  802018:	e8 88 ef ff ff       	call   800fa5 <sys_page_unmap>
  80201d:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802020:	83 ec 08             	sub    $0x8,%esp
  802023:	ff 75 f0             	pushl  -0x10(%ebp)
  802026:	6a 00                	push   $0x0
  802028:	e8 78 ef ff ff       	call   800fa5 <sys_page_unmap>
  80202d:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802030:	83 ec 08             	sub    $0x8,%esp
  802033:	ff 75 f4             	pushl  -0xc(%ebp)
  802036:	6a 00                	push   $0x0
  802038:	e8 68 ef ff ff       	call   800fa5 <sys_page_unmap>
  80203d:	83 c4 10             	add    $0x10,%esp
}
  802040:	89 d8                	mov    %ebx,%eax
  802042:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802045:	5b                   	pop    %ebx
  802046:	5e                   	pop    %esi
  802047:	5d                   	pop    %ebp
  802048:	c3                   	ret    

00802049 <pipeisclosed>:
{
  802049:	55                   	push   %ebp
  80204a:	89 e5                	mov    %esp,%ebp
  80204c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80204f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802052:	50                   	push   %eax
  802053:	ff 75 08             	pushl  0x8(%ebp)
  802056:	e8 8c f5 ff ff       	call   8015e7 <fd_lookup>
  80205b:	83 c4 10             	add    $0x10,%esp
  80205e:	85 c0                	test   %eax,%eax
  802060:	78 18                	js     80207a <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802062:	83 ec 0c             	sub    $0xc,%esp
  802065:	ff 75 f4             	pushl  -0xc(%ebp)
  802068:	e8 11 f5 ff ff       	call   80157e <fd2data>
	return _pipeisclosed(fd, p);
  80206d:	89 c2                	mov    %eax,%edx
  80206f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802072:	e8 2f fd ff ff       	call   801da6 <_pipeisclosed>
  802077:	83 c4 10             	add    $0x10,%esp
}
  80207a:	c9                   	leave  
  80207b:	c3                   	ret    

0080207c <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  80207c:	55                   	push   %ebp
  80207d:	89 e5                	mov    %esp,%ebp
  80207f:	56                   	push   %esi
  802080:	53                   	push   %ebx
  802081:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  802084:	85 f6                	test   %esi,%esi
  802086:	74 16                	je     80209e <wait+0x22>
	e = &envs[ENVX(envid)];
  802088:	89 f3                	mov    %esi,%ebx
  80208a:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802090:	69 db 84 00 00 00    	imul   $0x84,%ebx,%ebx
  802096:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  80209c:	eb 1b                	jmp    8020b9 <wait+0x3d>
	assert(envid != 0);
  80209e:	68 6c 2e 80 00       	push   $0x802e6c
  8020a3:	68 2c 2e 80 00       	push   $0x802e2c
  8020a8:	6a 09                	push   $0x9
  8020aa:	68 77 2e 80 00       	push   $0x802e77
  8020af:	e8 79 e2 ff ff       	call   80032d <_panic>
		sys_yield();
  8020b4:	e8 48 ee ff ff       	call   800f01 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8020b9:	8b 43 48             	mov    0x48(%ebx),%eax
  8020bc:	39 f0                	cmp    %esi,%eax
  8020be:	75 07                	jne    8020c7 <wait+0x4b>
  8020c0:	8b 43 54             	mov    0x54(%ebx),%eax
  8020c3:	85 c0                	test   %eax,%eax
  8020c5:	75 ed                	jne    8020b4 <wait+0x38>
}
  8020c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020ca:	5b                   	pop    %ebx
  8020cb:	5e                   	pop    %esi
  8020cc:	5d                   	pop    %ebp
  8020cd:	c3                   	ret    

008020ce <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8020ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8020d3:	c3                   	ret    

008020d4 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8020d4:	55                   	push   %ebp
  8020d5:	89 e5                	mov    %esp,%ebp
  8020d7:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8020da:	68 82 2e 80 00       	push   $0x802e82
  8020df:	ff 75 0c             	pushl  0xc(%ebp)
  8020e2:	e8 47 ea ff ff       	call   800b2e <strcpy>
	return 0;
}
  8020e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ec:	c9                   	leave  
  8020ed:	c3                   	ret    

008020ee <devcons_write>:
{
  8020ee:	55                   	push   %ebp
  8020ef:	89 e5                	mov    %esp,%ebp
  8020f1:	57                   	push   %edi
  8020f2:	56                   	push   %esi
  8020f3:	53                   	push   %ebx
  8020f4:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8020fa:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8020ff:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802105:	3b 75 10             	cmp    0x10(%ebp),%esi
  802108:	73 31                	jae    80213b <devcons_write+0x4d>
		m = n - tot;
  80210a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80210d:	29 f3                	sub    %esi,%ebx
  80210f:	83 fb 7f             	cmp    $0x7f,%ebx
  802112:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802117:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80211a:	83 ec 04             	sub    $0x4,%esp
  80211d:	53                   	push   %ebx
  80211e:	89 f0                	mov    %esi,%eax
  802120:	03 45 0c             	add    0xc(%ebp),%eax
  802123:	50                   	push   %eax
  802124:	57                   	push   %edi
  802125:	e8 92 eb ff ff       	call   800cbc <memmove>
		sys_cputs(buf, m);
  80212a:	83 c4 08             	add    $0x8,%esp
  80212d:	53                   	push   %ebx
  80212e:	57                   	push   %edi
  80212f:	e8 30 ed ff ff       	call   800e64 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802134:	01 de                	add    %ebx,%esi
  802136:	83 c4 10             	add    $0x10,%esp
  802139:	eb ca                	jmp    802105 <devcons_write+0x17>
}
  80213b:	89 f0                	mov    %esi,%eax
  80213d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802140:	5b                   	pop    %ebx
  802141:	5e                   	pop    %esi
  802142:	5f                   	pop    %edi
  802143:	5d                   	pop    %ebp
  802144:	c3                   	ret    

00802145 <devcons_read>:
{
  802145:	55                   	push   %ebp
  802146:	89 e5                	mov    %esp,%ebp
  802148:	83 ec 08             	sub    $0x8,%esp
  80214b:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802150:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802154:	74 21                	je     802177 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802156:	e8 27 ed ff ff       	call   800e82 <sys_cgetc>
  80215b:	85 c0                	test   %eax,%eax
  80215d:	75 07                	jne    802166 <devcons_read+0x21>
		sys_yield();
  80215f:	e8 9d ed ff ff       	call   800f01 <sys_yield>
  802164:	eb f0                	jmp    802156 <devcons_read+0x11>
	if (c < 0)
  802166:	78 0f                	js     802177 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802168:	83 f8 04             	cmp    $0x4,%eax
  80216b:	74 0c                	je     802179 <devcons_read+0x34>
	*(char*)vbuf = c;
  80216d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802170:	88 02                	mov    %al,(%edx)
	return 1;
  802172:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802177:	c9                   	leave  
  802178:	c3                   	ret    
		return 0;
  802179:	b8 00 00 00 00       	mov    $0x0,%eax
  80217e:	eb f7                	jmp    802177 <devcons_read+0x32>

00802180 <cputchar>:
{
  802180:	55                   	push   %ebp
  802181:	89 e5                	mov    %esp,%ebp
  802183:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802186:	8b 45 08             	mov    0x8(%ebp),%eax
  802189:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80218c:	6a 01                	push   $0x1
  80218e:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802191:	50                   	push   %eax
  802192:	e8 cd ec ff ff       	call   800e64 <sys_cputs>
}
  802197:	83 c4 10             	add    $0x10,%esp
  80219a:	c9                   	leave  
  80219b:	c3                   	ret    

0080219c <getchar>:
{
  80219c:	55                   	push   %ebp
  80219d:	89 e5                	mov    %esp,%ebp
  80219f:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8021a2:	6a 01                	push   $0x1
  8021a4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021a7:	50                   	push   %eax
  8021a8:	6a 00                	push   $0x0
  8021aa:	e8 a3 f6 ff ff       	call   801852 <read>
	if (r < 0)
  8021af:	83 c4 10             	add    $0x10,%esp
  8021b2:	85 c0                	test   %eax,%eax
  8021b4:	78 06                	js     8021bc <getchar+0x20>
	if (r < 1)
  8021b6:	74 06                	je     8021be <getchar+0x22>
	return c;
  8021b8:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8021bc:	c9                   	leave  
  8021bd:	c3                   	ret    
		return -E_EOF;
  8021be:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8021c3:	eb f7                	jmp    8021bc <getchar+0x20>

008021c5 <iscons>:
{
  8021c5:	55                   	push   %ebp
  8021c6:	89 e5                	mov    %esp,%ebp
  8021c8:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021ce:	50                   	push   %eax
  8021cf:	ff 75 08             	pushl  0x8(%ebp)
  8021d2:	e8 10 f4 ff ff       	call   8015e7 <fd_lookup>
  8021d7:	83 c4 10             	add    $0x10,%esp
  8021da:	85 c0                	test   %eax,%eax
  8021dc:	78 11                	js     8021ef <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8021de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e1:	8b 15 40 30 80 00    	mov    0x803040,%edx
  8021e7:	39 10                	cmp    %edx,(%eax)
  8021e9:	0f 94 c0             	sete   %al
  8021ec:	0f b6 c0             	movzbl %al,%eax
}
  8021ef:	c9                   	leave  
  8021f0:	c3                   	ret    

008021f1 <opencons>:
{
  8021f1:	55                   	push   %ebp
  8021f2:	89 e5                	mov    %esp,%ebp
  8021f4:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8021f7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021fa:	50                   	push   %eax
  8021fb:	e8 95 f3 ff ff       	call   801595 <fd_alloc>
  802200:	83 c4 10             	add    $0x10,%esp
  802203:	85 c0                	test   %eax,%eax
  802205:	78 3a                	js     802241 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802207:	83 ec 04             	sub    $0x4,%esp
  80220a:	68 07 04 00 00       	push   $0x407
  80220f:	ff 75 f4             	pushl  -0xc(%ebp)
  802212:	6a 00                	push   $0x0
  802214:	e8 07 ed ff ff       	call   800f20 <sys_page_alloc>
  802219:	83 c4 10             	add    $0x10,%esp
  80221c:	85 c0                	test   %eax,%eax
  80221e:	78 21                	js     802241 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802220:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802223:	8b 15 40 30 80 00    	mov    0x803040,%edx
  802229:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80222b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802235:	83 ec 0c             	sub    $0xc,%esp
  802238:	50                   	push   %eax
  802239:	e8 30 f3 ff ff       	call   80156e <fd2num>
  80223e:	83 c4 10             	add    $0x10,%esp
}
  802241:	c9                   	leave  
  802242:	c3                   	ret    

00802243 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802243:	55                   	push   %ebp
  802244:	89 e5                	mov    %esp,%ebp
  802246:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802249:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  802250:	74 0a                	je     80225c <set_pgfault_handler+0x19>
			panic("set_pgfault_handler: sys_env_set_pgfault_upcall fail, ret:%d", ret);
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802252:	8b 45 08             	mov    0x8(%ebp),%eax
  802255:	a3 00 60 80 00       	mov    %eax,0x806000
}
  80225a:	c9                   	leave  
  80225b:	c3                   	ret    
		ret = sys_page_alloc((envid_t)0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W);
  80225c:	83 ec 04             	sub    $0x4,%esp
  80225f:	6a 07                	push   $0x7
  802261:	68 00 f0 bf ee       	push   $0xeebff000
  802266:	6a 00                	push   $0x0
  802268:	e8 b3 ec ff ff       	call   800f20 <sys_page_alloc>
		if(ret < 0){
  80226d:	83 c4 10             	add    $0x10,%esp
  802270:	85 c0                	test   %eax,%eax
  802272:	78 28                	js     80229c <set_pgfault_handler+0x59>
    	ret = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  802274:	83 ec 08             	sub    $0x8,%esp
  802277:	68 ae 22 80 00       	push   $0x8022ae
  80227c:	6a 00                	push   $0x0
  80227e:	e8 e8 ed ff ff       	call   80106b <sys_env_set_pgfault_upcall>
		if(ret < 0){
  802283:	83 c4 10             	add    $0x10,%esp
  802286:	85 c0                	test   %eax,%eax
  802288:	79 c8                	jns    802252 <set_pgfault_handler+0xf>
			panic("set_pgfault_handler: sys_env_set_pgfault_upcall fail, ret:%d", ret);
  80228a:	50                   	push   %eax
  80228b:	68 c4 2e 80 00       	push   $0x802ec4
  802290:	6a 28                	push   $0x28
  802292:	68 04 2f 80 00       	push   $0x802f04
  802297:	e8 91 e0 ff ff       	call   80032d <_panic>
			panic("set_pgfault_handler: sys_page_alloc fail, ret:%d", ret);
  80229c:	50                   	push   %eax
  80229d:	68 90 2e 80 00       	push   $0x802e90
  8022a2:	6a 24                	push   $0x24
  8022a4:	68 04 2f 80 00       	push   $0x802f04
  8022a9:	e8 7f e0 ff ff       	call   80032d <_panic>

008022ae <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8022ae:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8022af:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  8022b4:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8022b6:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %edi
  8022b9:	8b 7c 24 28          	mov    0x28(%esp),%edi
	movl 0x30(%esp), %esi
  8022bd:	8b 74 24 30          	mov    0x30(%esp),%esi
	subl $4, %esi
  8022c1:	83 ee 04             	sub    $0x4,%esi
	movl %edi, (%esi)
  8022c4:	89 3e                	mov    %edi,(%esi)
	movl %esi, 0x30(%esp)
  8022c6:	89 74 24 30          	mov    %esi,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  8022ca:	83 c4 08             	add    $0x8,%esp
	popal
  8022cd:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8022ce:	83 c4 04             	add    $0x4,%esp
	popfl
  8022d1:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8022d2:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  8022d3:	c3                   	ret    

008022d4 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8022d4:	55                   	push   %ebp
  8022d5:	89 e5                	mov    %esp,%ebp
  8022d7:	56                   	push   %esi
  8022d8:	53                   	push   %ebx
  8022d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8022dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022df:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// return 0;
	if(!pg)
  8022e2:	85 c0                	test   %eax,%eax
		pg = (void*)UTOP;
  8022e4:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8022e9:	0f 44 c2             	cmove  %edx,%eax
	
	int ret;

	ret = sys_ipc_recv(pg);
  8022ec:	83 ec 0c             	sub    $0xc,%esp
  8022ef:	50                   	push   %eax
  8022f0:	e8 db ed ff ff       	call   8010d0 <sys_ipc_recv>
	if(ret < 0){
  8022f5:	83 c4 10             	add    $0x10,%esp
  8022f8:	85 c0                	test   %eax,%eax
  8022fa:	78 2b                	js     802327 <ipc_recv+0x53>
		if(perm_store) *perm_store = 0;
		if(from_env_store) *from_env_store = 0;
		return ret;
	}
	
	if(perm_store)
  8022fc:	85 f6                	test   %esi,%esi
  8022fe:	74 0a                	je     80230a <ipc_recv+0x36>
		*perm_store = thisenv->env_ipc_perm;
  802300:	a1 04 40 80 00       	mov    0x804004,%eax
  802305:	8b 40 78             	mov    0x78(%eax),%eax
  802308:	89 06                	mov    %eax,(%esi)
	if(from_env_store)
  80230a:	85 db                	test   %ebx,%ebx
  80230c:	74 0a                	je     802318 <ipc_recv+0x44>
		*from_env_store = thisenv->env_ipc_from;
  80230e:	a1 04 40 80 00       	mov    0x804004,%eax
  802313:	8b 40 74             	mov    0x74(%eax),%eax
  802316:	89 03                	mov    %eax,(%ebx)

	return thisenv->env_ipc_value;
  802318:	a1 04 40 80 00       	mov    0x804004,%eax
  80231d:	8b 40 70             	mov    0x70(%eax),%eax
}
  802320:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802323:	5b                   	pop    %ebx
  802324:	5e                   	pop    %esi
  802325:	5d                   	pop    %ebp
  802326:	c3                   	ret    
		if(perm_store) *perm_store = 0;
  802327:	85 f6                	test   %esi,%esi
  802329:	74 06                	je     802331 <ipc_recv+0x5d>
  80232b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(from_env_store) *from_env_store = 0;
  802331:	85 db                	test   %ebx,%ebx
  802333:	74 eb                	je     802320 <ipc_recv+0x4c>
  802335:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80233b:	eb e3                	jmp    802320 <ipc_recv+0x4c>

0080233d <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80233d:	55                   	push   %ebp
  80233e:	89 e5                	mov    %esp,%ebp
  802340:	57                   	push   %edi
  802341:	56                   	push   %esi
  802342:	53                   	push   %ebx
  802343:	83 ec 0c             	sub    $0xc,%esp
  802346:	8b 7d 08             	mov    0x8(%ebp),%edi
  802349:	8b 75 0c             	mov    0xc(%ebp),%esi
  80234c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
	if (!pg)
  80234f:	85 db                	test   %ebx,%ebx
		pg = (void*)UTOP;
  802351:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802356:	0f 44 d8             	cmove  %eax,%ebx

	int ret = -E_IPC_NOT_RECV;
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))) {
  802359:	ff 75 14             	pushl  0x14(%ebp)
  80235c:	53                   	push   %ebx
  80235d:	56                   	push   %esi
  80235e:	57                   	push   %edi
  80235f:	e8 49 ed ff ff       	call   8010ad <sys_ipc_try_send>
  802364:	83 c4 10             	add    $0x10,%esp
  802367:	85 c0                	test   %eax,%eax
  802369:	74 17                	je     802382 <ipc_send+0x45>
		if(ret != -E_IPC_NOT_RECV){
  80236b:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80236e:	74 e9                	je     802359 <ipc_send+0x1c>
			panic("ipc_send: ret : %d", ret);
  802370:	50                   	push   %eax
  802371:	68 12 2f 80 00       	push   $0x802f12
  802376:	6a 43                	push   $0x43
  802378:	68 25 2f 80 00       	push   $0x802f25
  80237d:	e8 ab df ff ff       	call   80032d <_panic>
			sys_yield();
		}
	}
}
  802382:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802385:	5b                   	pop    %ebx
  802386:	5e                   	pop    %esi
  802387:	5f                   	pop    %edi
  802388:	5d                   	pop    %ebp
  802389:	c3                   	ret    

0080238a <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80238a:	55                   	push   %ebp
  80238b:	89 e5                	mov    %esp,%ebp
  80238d:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802390:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802395:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  80239b:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8023a1:	8b 52 50             	mov    0x50(%edx),%edx
  8023a4:	39 ca                	cmp    %ecx,%edx
  8023a6:	74 11                	je     8023b9 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  8023a8:	83 c0 01             	add    $0x1,%eax
  8023ab:	3d 00 04 00 00       	cmp    $0x400,%eax
  8023b0:	75 e3                	jne    802395 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8023b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8023b7:	eb 0e                	jmp    8023c7 <ipc_find_env+0x3d>
			return envs[i].env_id;
  8023b9:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8023bf:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8023c4:	8b 40 48             	mov    0x48(%eax),%eax
}
  8023c7:	5d                   	pop    %ebp
  8023c8:	c3                   	ret    

008023c9 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8023c9:	55                   	push   %ebp
  8023ca:	89 e5                	mov    %esp,%ebp
  8023cc:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8023cf:	89 d0                	mov    %edx,%eax
  8023d1:	c1 e8 16             	shr    $0x16,%eax
  8023d4:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8023db:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8023e0:	f6 c1 01             	test   $0x1,%cl
  8023e3:	74 1d                	je     802402 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8023e5:	c1 ea 0c             	shr    $0xc,%edx
  8023e8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8023ef:	f6 c2 01             	test   $0x1,%dl
  8023f2:	74 0e                	je     802402 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8023f4:	c1 ea 0c             	shr    $0xc,%edx
  8023f7:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8023fe:	ef 
  8023ff:	0f b7 c0             	movzwl %ax,%eax
}
  802402:	5d                   	pop    %ebp
  802403:	c3                   	ret    
  802404:	66 90                	xchg   %ax,%ax
  802406:	66 90                	xchg   %ax,%ax
  802408:	66 90                	xchg   %ax,%ax
  80240a:	66 90                	xchg   %ax,%ax
  80240c:	66 90                	xchg   %ax,%ax
  80240e:	66 90                	xchg   %ax,%ax

00802410 <__udivdi3>:
  802410:	55                   	push   %ebp
  802411:	57                   	push   %edi
  802412:	56                   	push   %esi
  802413:	53                   	push   %ebx
  802414:	83 ec 1c             	sub    $0x1c,%esp
  802417:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80241b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80241f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802423:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802427:	85 d2                	test   %edx,%edx
  802429:	75 4d                	jne    802478 <__udivdi3+0x68>
  80242b:	39 f3                	cmp    %esi,%ebx
  80242d:	76 19                	jbe    802448 <__udivdi3+0x38>
  80242f:	31 ff                	xor    %edi,%edi
  802431:	89 e8                	mov    %ebp,%eax
  802433:	89 f2                	mov    %esi,%edx
  802435:	f7 f3                	div    %ebx
  802437:	89 fa                	mov    %edi,%edx
  802439:	83 c4 1c             	add    $0x1c,%esp
  80243c:	5b                   	pop    %ebx
  80243d:	5e                   	pop    %esi
  80243e:	5f                   	pop    %edi
  80243f:	5d                   	pop    %ebp
  802440:	c3                   	ret    
  802441:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802448:	89 d9                	mov    %ebx,%ecx
  80244a:	85 db                	test   %ebx,%ebx
  80244c:	75 0b                	jne    802459 <__udivdi3+0x49>
  80244e:	b8 01 00 00 00       	mov    $0x1,%eax
  802453:	31 d2                	xor    %edx,%edx
  802455:	f7 f3                	div    %ebx
  802457:	89 c1                	mov    %eax,%ecx
  802459:	31 d2                	xor    %edx,%edx
  80245b:	89 f0                	mov    %esi,%eax
  80245d:	f7 f1                	div    %ecx
  80245f:	89 c6                	mov    %eax,%esi
  802461:	89 e8                	mov    %ebp,%eax
  802463:	89 f7                	mov    %esi,%edi
  802465:	f7 f1                	div    %ecx
  802467:	89 fa                	mov    %edi,%edx
  802469:	83 c4 1c             	add    $0x1c,%esp
  80246c:	5b                   	pop    %ebx
  80246d:	5e                   	pop    %esi
  80246e:	5f                   	pop    %edi
  80246f:	5d                   	pop    %ebp
  802470:	c3                   	ret    
  802471:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802478:	39 f2                	cmp    %esi,%edx
  80247a:	77 1c                	ja     802498 <__udivdi3+0x88>
  80247c:	0f bd fa             	bsr    %edx,%edi
  80247f:	83 f7 1f             	xor    $0x1f,%edi
  802482:	75 2c                	jne    8024b0 <__udivdi3+0xa0>
  802484:	39 f2                	cmp    %esi,%edx
  802486:	72 06                	jb     80248e <__udivdi3+0x7e>
  802488:	31 c0                	xor    %eax,%eax
  80248a:	39 eb                	cmp    %ebp,%ebx
  80248c:	77 a9                	ja     802437 <__udivdi3+0x27>
  80248e:	b8 01 00 00 00       	mov    $0x1,%eax
  802493:	eb a2                	jmp    802437 <__udivdi3+0x27>
  802495:	8d 76 00             	lea    0x0(%esi),%esi
  802498:	31 ff                	xor    %edi,%edi
  80249a:	31 c0                	xor    %eax,%eax
  80249c:	89 fa                	mov    %edi,%edx
  80249e:	83 c4 1c             	add    $0x1c,%esp
  8024a1:	5b                   	pop    %ebx
  8024a2:	5e                   	pop    %esi
  8024a3:	5f                   	pop    %edi
  8024a4:	5d                   	pop    %ebp
  8024a5:	c3                   	ret    
  8024a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024ad:	8d 76 00             	lea    0x0(%esi),%esi
  8024b0:	89 f9                	mov    %edi,%ecx
  8024b2:	b8 20 00 00 00       	mov    $0x20,%eax
  8024b7:	29 f8                	sub    %edi,%eax
  8024b9:	d3 e2                	shl    %cl,%edx
  8024bb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8024bf:	89 c1                	mov    %eax,%ecx
  8024c1:	89 da                	mov    %ebx,%edx
  8024c3:	d3 ea                	shr    %cl,%edx
  8024c5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8024c9:	09 d1                	or     %edx,%ecx
  8024cb:	89 f2                	mov    %esi,%edx
  8024cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8024d1:	89 f9                	mov    %edi,%ecx
  8024d3:	d3 e3                	shl    %cl,%ebx
  8024d5:	89 c1                	mov    %eax,%ecx
  8024d7:	d3 ea                	shr    %cl,%edx
  8024d9:	89 f9                	mov    %edi,%ecx
  8024db:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8024df:	89 eb                	mov    %ebp,%ebx
  8024e1:	d3 e6                	shl    %cl,%esi
  8024e3:	89 c1                	mov    %eax,%ecx
  8024e5:	d3 eb                	shr    %cl,%ebx
  8024e7:	09 de                	or     %ebx,%esi
  8024e9:	89 f0                	mov    %esi,%eax
  8024eb:	f7 74 24 08          	divl   0x8(%esp)
  8024ef:	89 d6                	mov    %edx,%esi
  8024f1:	89 c3                	mov    %eax,%ebx
  8024f3:	f7 64 24 0c          	mull   0xc(%esp)
  8024f7:	39 d6                	cmp    %edx,%esi
  8024f9:	72 15                	jb     802510 <__udivdi3+0x100>
  8024fb:	89 f9                	mov    %edi,%ecx
  8024fd:	d3 e5                	shl    %cl,%ebp
  8024ff:	39 c5                	cmp    %eax,%ebp
  802501:	73 04                	jae    802507 <__udivdi3+0xf7>
  802503:	39 d6                	cmp    %edx,%esi
  802505:	74 09                	je     802510 <__udivdi3+0x100>
  802507:	89 d8                	mov    %ebx,%eax
  802509:	31 ff                	xor    %edi,%edi
  80250b:	e9 27 ff ff ff       	jmp    802437 <__udivdi3+0x27>
  802510:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802513:	31 ff                	xor    %edi,%edi
  802515:	e9 1d ff ff ff       	jmp    802437 <__udivdi3+0x27>
  80251a:	66 90                	xchg   %ax,%ax
  80251c:	66 90                	xchg   %ax,%ax
  80251e:	66 90                	xchg   %ax,%ax

00802520 <__umoddi3>:
  802520:	55                   	push   %ebp
  802521:	57                   	push   %edi
  802522:	56                   	push   %esi
  802523:	53                   	push   %ebx
  802524:	83 ec 1c             	sub    $0x1c,%esp
  802527:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80252b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80252f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802533:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802537:	89 da                	mov    %ebx,%edx
  802539:	85 c0                	test   %eax,%eax
  80253b:	75 43                	jne    802580 <__umoddi3+0x60>
  80253d:	39 df                	cmp    %ebx,%edi
  80253f:	76 17                	jbe    802558 <__umoddi3+0x38>
  802541:	89 f0                	mov    %esi,%eax
  802543:	f7 f7                	div    %edi
  802545:	89 d0                	mov    %edx,%eax
  802547:	31 d2                	xor    %edx,%edx
  802549:	83 c4 1c             	add    $0x1c,%esp
  80254c:	5b                   	pop    %ebx
  80254d:	5e                   	pop    %esi
  80254e:	5f                   	pop    %edi
  80254f:	5d                   	pop    %ebp
  802550:	c3                   	ret    
  802551:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802558:	89 fd                	mov    %edi,%ebp
  80255a:	85 ff                	test   %edi,%edi
  80255c:	75 0b                	jne    802569 <__umoddi3+0x49>
  80255e:	b8 01 00 00 00       	mov    $0x1,%eax
  802563:	31 d2                	xor    %edx,%edx
  802565:	f7 f7                	div    %edi
  802567:	89 c5                	mov    %eax,%ebp
  802569:	89 d8                	mov    %ebx,%eax
  80256b:	31 d2                	xor    %edx,%edx
  80256d:	f7 f5                	div    %ebp
  80256f:	89 f0                	mov    %esi,%eax
  802571:	f7 f5                	div    %ebp
  802573:	89 d0                	mov    %edx,%eax
  802575:	eb d0                	jmp    802547 <__umoddi3+0x27>
  802577:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80257e:	66 90                	xchg   %ax,%ax
  802580:	89 f1                	mov    %esi,%ecx
  802582:	39 d8                	cmp    %ebx,%eax
  802584:	76 0a                	jbe    802590 <__umoddi3+0x70>
  802586:	89 f0                	mov    %esi,%eax
  802588:	83 c4 1c             	add    $0x1c,%esp
  80258b:	5b                   	pop    %ebx
  80258c:	5e                   	pop    %esi
  80258d:	5f                   	pop    %edi
  80258e:	5d                   	pop    %ebp
  80258f:	c3                   	ret    
  802590:	0f bd e8             	bsr    %eax,%ebp
  802593:	83 f5 1f             	xor    $0x1f,%ebp
  802596:	75 20                	jne    8025b8 <__umoddi3+0x98>
  802598:	39 d8                	cmp    %ebx,%eax
  80259a:	0f 82 b0 00 00 00    	jb     802650 <__umoddi3+0x130>
  8025a0:	39 f7                	cmp    %esi,%edi
  8025a2:	0f 86 a8 00 00 00    	jbe    802650 <__umoddi3+0x130>
  8025a8:	89 c8                	mov    %ecx,%eax
  8025aa:	83 c4 1c             	add    $0x1c,%esp
  8025ad:	5b                   	pop    %ebx
  8025ae:	5e                   	pop    %esi
  8025af:	5f                   	pop    %edi
  8025b0:	5d                   	pop    %ebp
  8025b1:	c3                   	ret    
  8025b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8025b8:	89 e9                	mov    %ebp,%ecx
  8025ba:	ba 20 00 00 00       	mov    $0x20,%edx
  8025bf:	29 ea                	sub    %ebp,%edx
  8025c1:	d3 e0                	shl    %cl,%eax
  8025c3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8025c7:	89 d1                	mov    %edx,%ecx
  8025c9:	89 f8                	mov    %edi,%eax
  8025cb:	d3 e8                	shr    %cl,%eax
  8025cd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8025d1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8025d5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8025d9:	09 c1                	or     %eax,%ecx
  8025db:	89 d8                	mov    %ebx,%eax
  8025dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025e1:	89 e9                	mov    %ebp,%ecx
  8025e3:	d3 e7                	shl    %cl,%edi
  8025e5:	89 d1                	mov    %edx,%ecx
  8025e7:	d3 e8                	shr    %cl,%eax
  8025e9:	89 e9                	mov    %ebp,%ecx
  8025eb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8025ef:	d3 e3                	shl    %cl,%ebx
  8025f1:	89 c7                	mov    %eax,%edi
  8025f3:	89 d1                	mov    %edx,%ecx
  8025f5:	89 f0                	mov    %esi,%eax
  8025f7:	d3 e8                	shr    %cl,%eax
  8025f9:	89 e9                	mov    %ebp,%ecx
  8025fb:	89 fa                	mov    %edi,%edx
  8025fd:	d3 e6                	shl    %cl,%esi
  8025ff:	09 d8                	or     %ebx,%eax
  802601:	f7 74 24 08          	divl   0x8(%esp)
  802605:	89 d1                	mov    %edx,%ecx
  802607:	89 f3                	mov    %esi,%ebx
  802609:	f7 64 24 0c          	mull   0xc(%esp)
  80260d:	89 c6                	mov    %eax,%esi
  80260f:	89 d7                	mov    %edx,%edi
  802611:	39 d1                	cmp    %edx,%ecx
  802613:	72 06                	jb     80261b <__umoddi3+0xfb>
  802615:	75 10                	jne    802627 <__umoddi3+0x107>
  802617:	39 c3                	cmp    %eax,%ebx
  802619:	73 0c                	jae    802627 <__umoddi3+0x107>
  80261b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80261f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802623:	89 d7                	mov    %edx,%edi
  802625:	89 c6                	mov    %eax,%esi
  802627:	89 ca                	mov    %ecx,%edx
  802629:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80262e:	29 f3                	sub    %esi,%ebx
  802630:	19 fa                	sbb    %edi,%edx
  802632:	89 d0                	mov    %edx,%eax
  802634:	d3 e0                	shl    %cl,%eax
  802636:	89 e9                	mov    %ebp,%ecx
  802638:	d3 eb                	shr    %cl,%ebx
  80263a:	d3 ea                	shr    %cl,%edx
  80263c:	09 d8                	or     %ebx,%eax
  80263e:	83 c4 1c             	add    $0x1c,%esp
  802641:	5b                   	pop    %ebx
  802642:	5e                   	pop    %esi
  802643:	5f                   	pop    %edi
  802644:	5d                   	pop    %ebp
  802645:	c3                   	ret    
  802646:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80264d:	8d 76 00             	lea    0x0(%esi),%esi
  802650:	89 da                	mov    %ebx,%edx
  802652:	29 fe                	sub    %edi,%esi
  802654:	19 c2                	sbb    %eax,%edx
  802656:	89 f1                	mov    %esi,%ecx
  802658:	89 c8                	mov    %ecx,%eax
  80265a:	e9 4b ff ff ff       	jmp    8025aa <__umoddi3+0x8a>
