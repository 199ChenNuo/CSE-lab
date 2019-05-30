
obj/user/testshell.debug:     file format elf32-i386


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
  80002c:	e8 55 04 00 00       	call   800486 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <wrong>:
	breakpoint();
}

void
wrong(int rfd, int kfd, int off)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	81 ec 84 00 00 00    	sub    $0x84,%esp
  80003f:	8b 75 08             	mov    0x8(%ebp),%esi
  800042:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800045:	8b 5d 10             	mov    0x10(%ebp),%ebx
	char buf[100];
	int n;

	seek(rfd, off);
  800048:	53                   	push   %ebx
  800049:	56                   	push   %esi
  80004a:	e8 05 1b 00 00       	call   801b54 <seek>
	seek(kfd, off);
  80004f:	83 c4 08             	add    $0x8,%esp
  800052:	53                   	push   %ebx
  800053:	57                   	push   %edi
  800054:	e8 fb 1a 00 00       	call   801b54 <seek>

	cprintf("shell produced incorrect output.\n");
  800059:	c7 04 24 00 2c 80 00 	movl   $0x802c00,(%esp)
  800060:	e8 57 05 00 00       	call   8005bc <cprintf>
	cprintf("expected:\n===\n");
  800065:	c7 04 24 6b 2c 80 00 	movl   $0x802c6b,(%esp)
  80006c:	e8 4b 05 00 00       	call   8005bc <cprintf>
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  800071:	83 c4 10             	add    $0x10,%esp
  800074:	8d 5d 84             	lea    -0x7c(%ebp),%ebx
  800077:	83 ec 04             	sub    $0x4,%esp
  80007a:	6a 63                	push   $0x63
  80007c:	53                   	push   %ebx
  80007d:	57                   	push   %edi
  80007e:	e8 83 19 00 00       	call   801a06 <read>
  800083:	83 c4 10             	add    $0x10,%esp
  800086:	85 c0                	test   %eax,%eax
  800088:	7e 0f                	jle    800099 <wrong+0x66>
		sys_cputs(buf, n);
  80008a:	83 ec 08             	sub    $0x8,%esp
  80008d:	50                   	push   %eax
  80008e:	53                   	push   %ebx
  80008f:	e8 84 0f 00 00       	call   801018 <sys_cputs>
  800094:	83 c4 10             	add    $0x10,%esp
  800097:	eb de                	jmp    800077 <wrong+0x44>
	cprintf("===\ngot:\n===\n");
  800099:	83 ec 0c             	sub    $0xc,%esp
  80009c:	68 7a 2c 80 00       	push   $0x802c7a
  8000a1:	e8 16 05 00 00       	call   8005bc <cprintf>
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  8000a6:	83 c4 10             	add    $0x10,%esp
  8000a9:	8d 5d 84             	lea    -0x7c(%ebp),%ebx
  8000ac:	eb 0d                	jmp    8000bb <wrong+0x88>
		sys_cputs(buf, n);
  8000ae:	83 ec 08             	sub    $0x8,%esp
  8000b1:	50                   	push   %eax
  8000b2:	53                   	push   %ebx
  8000b3:	e8 60 0f 00 00       	call   801018 <sys_cputs>
  8000b8:	83 c4 10             	add    $0x10,%esp
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  8000bb:	83 ec 04             	sub    $0x4,%esp
  8000be:	6a 63                	push   $0x63
  8000c0:	53                   	push   %ebx
  8000c1:	56                   	push   %esi
  8000c2:	e8 3f 19 00 00       	call   801a06 <read>
  8000c7:	83 c4 10             	add    $0x10,%esp
  8000ca:	85 c0                	test   %eax,%eax
  8000cc:	7f e0                	jg     8000ae <wrong+0x7b>
	cprintf("===\n");
  8000ce:	83 ec 0c             	sub    $0xc,%esp
  8000d1:	68 75 2c 80 00       	push   $0x802c75
  8000d6:	e8 e1 04 00 00       	call   8005bc <cprintf>
	exit();
  8000db:	e8 ef 03 00 00       	call   8004cf <exit>
}
  8000e0:	83 c4 10             	add    $0x10,%esp
  8000e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000e6:	5b                   	pop    %ebx
  8000e7:	5e                   	pop    %esi
  8000e8:	5f                   	pop    %edi
  8000e9:	5d                   	pop    %ebp
  8000ea:	c3                   	ret    

008000eb <umain>:
{
  8000eb:	55                   	push   %ebp
  8000ec:	89 e5                	mov    %esp,%ebp
  8000ee:	57                   	push   %edi
  8000ef:	56                   	push   %esi
  8000f0:	53                   	push   %ebx
  8000f1:	83 ec 38             	sub    $0x38,%esp
	close(0);
  8000f4:	6a 00                	push   $0x0
  8000f6:	e8 cd 17 00 00       	call   8018c8 <close>
	close(1);
  8000fb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800102:	e8 c1 17 00 00       	call   8018c8 <close>
	opencons();
  800107:	e8 28 03 00 00       	call   800434 <opencons>
	opencons();
  80010c:	e8 23 03 00 00       	call   800434 <opencons>
	if ((rfd = open("testshell.sh", O_RDONLY)) < 0)
  800111:	83 c4 08             	add    $0x8,%esp
  800114:	6a 00                	push   $0x0
  800116:	68 88 2c 80 00       	push   $0x802c88
  80011b:	e8 1d 1d 00 00       	call   801e3d <open>
  800120:	89 c3                	mov    %eax,%ebx
  800122:	83 c4 10             	add    $0x10,%esp
  800125:	85 c0                	test   %eax,%eax
  800127:	0f 88 e7 00 00 00    	js     800214 <umain+0x129>
	if ((wfd = pipe(pfds)) < 0)
  80012d:	83 ec 0c             	sub    $0xc,%esp
  800130:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800133:	50                   	push   %eax
  800134:	e8 da 24 00 00       	call   802613 <pipe>
  800139:	83 c4 10             	add    $0x10,%esp
  80013c:	85 c0                	test   %eax,%eax
  80013e:	0f 88 e2 00 00 00    	js     800226 <umain+0x13b>
	wfd = pfds[1];
  800144:	8b 75 e0             	mov    -0x20(%ebp),%esi
	cprintf("running sh -x < testshell.sh | cat\n");
  800147:	83 ec 0c             	sub    $0xc,%esp
  80014a:	68 24 2c 80 00       	push   $0x802c24
  80014f:	e8 68 04 00 00       	call   8005bc <cprintf>
	if ((r = fork()) < 0)
  800154:	e8 a9 12 00 00       	call   801402 <fork>
  800159:	83 c4 10             	add    $0x10,%esp
  80015c:	85 c0                	test   %eax,%eax
  80015e:	0f 88 d4 00 00 00    	js     800238 <umain+0x14d>
	if (r == 0) {
  800164:	75 6f                	jne    8001d5 <umain+0xea>
		dup(rfd, 0);
  800166:	83 ec 08             	sub    $0x8,%esp
  800169:	6a 00                	push   $0x0
  80016b:	53                   	push   %ebx
  80016c:	e8 a9 17 00 00       	call   80191a <dup>
		dup(wfd, 1);
  800171:	83 c4 08             	add    $0x8,%esp
  800174:	6a 01                	push   $0x1
  800176:	56                   	push   %esi
  800177:	e8 9e 17 00 00       	call   80191a <dup>
		close(rfd);
  80017c:	89 1c 24             	mov    %ebx,(%esp)
  80017f:	e8 44 17 00 00       	call   8018c8 <close>
		close(wfd);
  800184:	89 34 24             	mov    %esi,(%esp)
  800187:	e8 3c 17 00 00       	call   8018c8 <close>
		if ((r = spawnl("/sh", "sh", "-x", 0)) < 0)
  80018c:	6a 00                	push   $0x0
  80018e:	68 ce 2c 80 00       	push   $0x802cce
  800193:	68 92 2c 80 00       	push   $0x802c92
  800198:	68 d1 2c 80 00       	push   $0x802cd1
  80019d:	e8 23 22 00 00       	call   8023c5 <spawnl>
  8001a2:	89 c7                	mov    %eax,%edi
  8001a4:	83 c4 20             	add    $0x20,%esp
  8001a7:	85 c0                	test   %eax,%eax
  8001a9:	0f 88 9b 00 00 00    	js     80024a <umain+0x15f>
		close(0);
  8001af:	83 ec 0c             	sub    $0xc,%esp
  8001b2:	6a 00                	push   $0x0
  8001b4:	e8 0f 17 00 00       	call   8018c8 <close>
		close(1);
  8001b9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8001c0:	e8 03 17 00 00       	call   8018c8 <close>
		wait(r);
  8001c5:	89 3c 24             	mov    %edi,(%esp)
  8001c8:	e8 c3 25 00 00       	call   802790 <wait>
		exit();
  8001cd:	e8 fd 02 00 00       	call   8004cf <exit>
  8001d2:	83 c4 10             	add    $0x10,%esp
	close(rfd);
  8001d5:	83 ec 0c             	sub    $0xc,%esp
  8001d8:	53                   	push   %ebx
  8001d9:	e8 ea 16 00 00       	call   8018c8 <close>
	close(wfd);
  8001de:	89 34 24             	mov    %esi,(%esp)
  8001e1:	e8 e2 16 00 00       	call   8018c8 <close>
	rfd = pfds[0];
  8001e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001e9:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if ((kfd = open("testshell.key", O_RDONLY)) < 0)
  8001ec:	83 c4 08             	add    $0x8,%esp
  8001ef:	6a 00                	push   $0x0
  8001f1:	68 df 2c 80 00       	push   $0x802cdf
  8001f6:	e8 42 1c 00 00       	call   801e3d <open>
  8001fb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8001fe:	83 c4 10             	add    $0x10,%esp
  800201:	85 c0                	test   %eax,%eax
  800203:	78 57                	js     80025c <umain+0x171>
  800205:	be 01 00 00 00       	mov    $0x1,%esi
	nloff = 0;
  80020a:	bf 00 00 00 00       	mov    $0x0,%edi
  80020f:	e9 9a 00 00 00       	jmp    8002ae <umain+0x1c3>
		panic("open testshell.sh: %e", rfd);
  800214:	50                   	push   %eax
  800215:	68 95 2c 80 00       	push   $0x802c95
  80021a:	6a 13                	push   $0x13
  80021c:	68 ab 2c 80 00       	push   $0x802cab
  800221:	e8 bb 02 00 00       	call   8004e1 <_panic>
		panic("pipe: %e", wfd);
  800226:	50                   	push   %eax
  800227:	68 bc 2c 80 00       	push   $0x802cbc
  80022c:	6a 15                	push   $0x15
  80022e:	68 ab 2c 80 00       	push   $0x802cab
  800233:	e8 a9 02 00 00       	call   8004e1 <_panic>
		panic("fork: %e", r);
  800238:	50                   	push   %eax
  800239:	68 c5 2c 80 00       	push   $0x802cc5
  80023e:	6a 1a                	push   $0x1a
  800240:	68 ab 2c 80 00       	push   $0x802cab
  800245:	e8 97 02 00 00       	call   8004e1 <_panic>
			panic("spawn: %e", r);
  80024a:	50                   	push   %eax
  80024b:	68 d5 2c 80 00       	push   $0x802cd5
  800250:	6a 21                	push   $0x21
  800252:	68 ab 2c 80 00       	push   $0x802cab
  800257:	e8 85 02 00 00       	call   8004e1 <_panic>
		panic("open testshell.key for reading: %e", kfd);
  80025c:	50                   	push   %eax
  80025d:	68 48 2c 80 00       	push   $0x802c48
  800262:	6a 2c                	push   $0x2c
  800264:	68 ab 2c 80 00       	push   $0x802cab
  800269:	e8 73 02 00 00       	call   8004e1 <_panic>
			panic("reading testshell.out: %e", n1);
  80026e:	53                   	push   %ebx
  80026f:	68 ed 2c 80 00       	push   $0x802ced
  800274:	6a 33                	push   $0x33
  800276:	68 ab 2c 80 00       	push   $0x802cab
  80027b:	e8 61 02 00 00       	call   8004e1 <_panic>
			panic("reading testshell.key: %e", n2);
  800280:	50                   	push   %eax
  800281:	68 07 2d 80 00       	push   $0x802d07
  800286:	6a 35                	push   $0x35
  800288:	68 ab 2c 80 00       	push   $0x802cab
  80028d:	e8 4f 02 00 00       	call   8004e1 <_panic>
			wrong(rfd, kfd, nloff);
  800292:	83 ec 04             	sub    $0x4,%esp
  800295:	57                   	push   %edi
  800296:	ff 75 d4             	pushl  -0x2c(%ebp)
  800299:	ff 75 d0             	pushl  -0x30(%ebp)
  80029c:	e8 92 fd ff ff       	call   800033 <wrong>
  8002a1:	83 c4 10             	add    $0x10,%esp
			nloff = off+1;
  8002a4:	80 7d e7 0a          	cmpb   $0xa,-0x19(%ebp)
  8002a8:	0f 44 fe             	cmove  %esi,%edi
  8002ab:	83 c6 01             	add    $0x1,%esi
		n1 = read(rfd, &c1, 1);
  8002ae:	83 ec 04             	sub    $0x4,%esp
  8002b1:	6a 01                	push   $0x1
  8002b3:	8d 45 e7             	lea    -0x19(%ebp),%eax
  8002b6:	50                   	push   %eax
  8002b7:	ff 75 d0             	pushl  -0x30(%ebp)
  8002ba:	e8 47 17 00 00       	call   801a06 <read>
  8002bf:	89 c3                	mov    %eax,%ebx
		n2 = read(kfd, &c2, 1);
  8002c1:	83 c4 0c             	add    $0xc,%esp
  8002c4:	6a 01                	push   $0x1
  8002c6:	8d 45 e6             	lea    -0x1a(%ebp),%eax
  8002c9:	50                   	push   %eax
  8002ca:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002cd:	e8 34 17 00 00       	call   801a06 <read>
		if (n1 < 0)
  8002d2:	83 c4 10             	add    $0x10,%esp
  8002d5:	85 db                	test   %ebx,%ebx
  8002d7:	78 95                	js     80026e <umain+0x183>
		if (n2 < 0)
  8002d9:	85 c0                	test   %eax,%eax
  8002db:	78 a3                	js     800280 <umain+0x195>
		if (n1 == 0 && n2 == 0)
  8002dd:	89 da                	mov    %ebx,%edx
  8002df:	09 c2                	or     %eax,%edx
  8002e1:	74 15                	je     8002f8 <umain+0x20d>
		if (n1 != 1 || n2 != 1 || c1 != c2)
  8002e3:	83 fb 01             	cmp    $0x1,%ebx
  8002e6:	75 aa                	jne    800292 <umain+0x1a7>
  8002e8:	83 f8 01             	cmp    $0x1,%eax
  8002eb:	75 a5                	jne    800292 <umain+0x1a7>
  8002ed:	0f b6 45 e6          	movzbl -0x1a(%ebp),%eax
  8002f1:	38 45 e7             	cmp    %al,-0x19(%ebp)
  8002f4:	75 9c                	jne    800292 <umain+0x1a7>
  8002f6:	eb ac                	jmp    8002a4 <umain+0x1b9>
	cprintf("shell ran correctly\n");
  8002f8:	83 ec 0c             	sub    $0xc,%esp
  8002fb:	68 21 2d 80 00       	push   $0x802d21
  800300:	e8 b7 02 00 00       	call   8005bc <cprintf>
#include <inc/types.h>

static inline void
breakpoint(void)
{
	asm volatile("int3");
  800305:	cc                   	int3   
}
  800306:	83 c4 10             	add    $0x10,%esp
  800309:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80030c:	5b                   	pop    %ebx
  80030d:	5e                   	pop    %esi
  80030e:	5f                   	pop    %edi
  80030f:	5d                   	pop    %ebp
  800310:	c3                   	ret    

00800311 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  800311:	b8 00 00 00 00       	mov    $0x0,%eax
  800316:	c3                   	ret    

00800317 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800317:	55                   	push   %ebp
  800318:	89 e5                	mov    %esp,%ebp
  80031a:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80031d:	68 36 2d 80 00       	push   $0x802d36
  800322:	ff 75 0c             	pushl  0xc(%ebp)
  800325:	e8 b8 09 00 00       	call   800ce2 <strcpy>
	return 0;
}
  80032a:	b8 00 00 00 00       	mov    $0x0,%eax
  80032f:	c9                   	leave  
  800330:	c3                   	ret    

00800331 <devcons_write>:
{
  800331:	55                   	push   %ebp
  800332:	89 e5                	mov    %esp,%ebp
  800334:	57                   	push   %edi
  800335:	56                   	push   %esi
  800336:	53                   	push   %ebx
  800337:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80033d:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  800342:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  800348:	3b 75 10             	cmp    0x10(%ebp),%esi
  80034b:	73 31                	jae    80037e <devcons_write+0x4d>
		m = n - tot;
  80034d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800350:	29 f3                	sub    %esi,%ebx
  800352:	83 fb 7f             	cmp    $0x7f,%ebx
  800355:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80035a:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80035d:	83 ec 04             	sub    $0x4,%esp
  800360:	53                   	push   %ebx
  800361:	89 f0                	mov    %esi,%eax
  800363:	03 45 0c             	add    0xc(%ebp),%eax
  800366:	50                   	push   %eax
  800367:	57                   	push   %edi
  800368:	e8 03 0b 00 00       	call   800e70 <memmove>
		sys_cputs(buf, m);
  80036d:	83 c4 08             	add    $0x8,%esp
  800370:	53                   	push   %ebx
  800371:	57                   	push   %edi
  800372:	e8 a1 0c 00 00       	call   801018 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  800377:	01 de                	add    %ebx,%esi
  800379:	83 c4 10             	add    $0x10,%esp
  80037c:	eb ca                	jmp    800348 <devcons_write+0x17>
}
  80037e:	89 f0                	mov    %esi,%eax
  800380:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800383:	5b                   	pop    %ebx
  800384:	5e                   	pop    %esi
  800385:	5f                   	pop    %edi
  800386:	5d                   	pop    %ebp
  800387:	c3                   	ret    

00800388 <devcons_read>:
{
  800388:	55                   	push   %ebp
  800389:	89 e5                	mov    %esp,%ebp
  80038b:	83 ec 08             	sub    $0x8,%esp
  80038e:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  800393:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800397:	74 21                	je     8003ba <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  800399:	e8 98 0c 00 00       	call   801036 <sys_cgetc>
  80039e:	85 c0                	test   %eax,%eax
  8003a0:	75 07                	jne    8003a9 <devcons_read+0x21>
		sys_yield();
  8003a2:	e8 0e 0d 00 00       	call   8010b5 <sys_yield>
  8003a7:	eb f0                	jmp    800399 <devcons_read+0x11>
	if (c < 0)
  8003a9:	78 0f                	js     8003ba <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8003ab:	83 f8 04             	cmp    $0x4,%eax
  8003ae:	74 0c                	je     8003bc <devcons_read+0x34>
	*(char*)vbuf = c;
  8003b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003b3:	88 02                	mov    %al,(%edx)
	return 1;
  8003b5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8003ba:	c9                   	leave  
  8003bb:	c3                   	ret    
		return 0;
  8003bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8003c1:	eb f7                	jmp    8003ba <devcons_read+0x32>

008003c3 <cputchar>:
{
  8003c3:	55                   	push   %ebp
  8003c4:	89 e5                	mov    %esp,%ebp
  8003c6:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8003c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003cc:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8003cf:	6a 01                	push   $0x1
  8003d1:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8003d4:	50                   	push   %eax
  8003d5:	e8 3e 0c 00 00       	call   801018 <sys_cputs>
}
  8003da:	83 c4 10             	add    $0x10,%esp
  8003dd:	c9                   	leave  
  8003de:	c3                   	ret    

008003df <getchar>:
{
  8003df:	55                   	push   %ebp
  8003e0:	89 e5                	mov    %esp,%ebp
  8003e2:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8003e5:	6a 01                	push   $0x1
  8003e7:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8003ea:	50                   	push   %eax
  8003eb:	6a 00                	push   $0x0
  8003ed:	e8 14 16 00 00       	call   801a06 <read>
	if (r < 0)
  8003f2:	83 c4 10             	add    $0x10,%esp
  8003f5:	85 c0                	test   %eax,%eax
  8003f7:	78 06                	js     8003ff <getchar+0x20>
	if (r < 1)
  8003f9:	74 06                	je     800401 <getchar+0x22>
	return c;
  8003fb:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8003ff:	c9                   	leave  
  800400:	c3                   	ret    
		return -E_EOF;
  800401:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  800406:	eb f7                	jmp    8003ff <getchar+0x20>

00800408 <iscons>:
{
  800408:	55                   	push   %ebp
  800409:	89 e5                	mov    %esp,%ebp
  80040b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80040e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800411:	50                   	push   %eax
  800412:	ff 75 08             	pushl  0x8(%ebp)
  800415:	e8 81 13 00 00       	call   80179b <fd_lookup>
  80041a:	83 c4 10             	add    $0x10,%esp
  80041d:	85 c0                	test   %eax,%eax
  80041f:	78 11                	js     800432 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  800421:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800424:	8b 15 00 40 80 00    	mov    0x804000,%edx
  80042a:	39 10                	cmp    %edx,(%eax)
  80042c:	0f 94 c0             	sete   %al
  80042f:	0f b6 c0             	movzbl %al,%eax
}
  800432:	c9                   	leave  
  800433:	c3                   	ret    

00800434 <opencons>:
{
  800434:	55                   	push   %ebp
  800435:	89 e5                	mov    %esp,%ebp
  800437:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80043a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80043d:	50                   	push   %eax
  80043e:	e8 06 13 00 00       	call   801749 <fd_alloc>
  800443:	83 c4 10             	add    $0x10,%esp
  800446:	85 c0                	test   %eax,%eax
  800448:	78 3a                	js     800484 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80044a:	83 ec 04             	sub    $0x4,%esp
  80044d:	68 07 04 00 00       	push   $0x407
  800452:	ff 75 f4             	pushl  -0xc(%ebp)
  800455:	6a 00                	push   $0x0
  800457:	e8 78 0c 00 00       	call   8010d4 <sys_page_alloc>
  80045c:	83 c4 10             	add    $0x10,%esp
  80045f:	85 c0                	test   %eax,%eax
  800461:	78 21                	js     800484 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  800463:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800466:	8b 15 00 40 80 00    	mov    0x804000,%edx
  80046c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80046e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800471:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800478:	83 ec 0c             	sub    $0xc,%esp
  80047b:	50                   	push   %eax
  80047c:	e8 a1 12 00 00       	call   801722 <fd2num>
  800481:	83 c4 10             	add    $0x10,%esp
}
  800484:	c9                   	leave  
  800485:	c3                   	ret    

00800486 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800486:	55                   	push   %ebp
  800487:	89 e5                	mov    %esp,%ebp
  800489:	56                   	push   %esi
  80048a:	53                   	push   %ebx
  80048b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80048e:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	// thisenv = 0;
	thisenv = &(envs[ENVX(sys_getenvid())]);
  800491:	e8 00 0c 00 00       	call   801096 <sys_getenvid>
  800496:	25 ff 03 00 00       	and    $0x3ff,%eax
  80049b:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8004a1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8004a6:	a3 04 50 80 00       	mov    %eax,0x805004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004ab:	85 db                	test   %ebx,%ebx
  8004ad:	7e 07                	jle    8004b6 <libmain+0x30>
		binaryname = argv[0];
  8004af:	8b 06                	mov    (%esi),%eax
  8004b1:	a3 1c 40 80 00       	mov    %eax,0x80401c

	// call user main routine
	umain(argc, argv);
  8004b6:	83 ec 08             	sub    $0x8,%esp
  8004b9:	56                   	push   %esi
  8004ba:	53                   	push   %ebx
  8004bb:	e8 2b fc ff ff       	call   8000eb <umain>

	// exit gracefully
	exit();
  8004c0:	e8 0a 00 00 00       	call   8004cf <exit>
}
  8004c5:	83 c4 10             	add    $0x10,%esp
  8004c8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8004cb:	5b                   	pop    %ebx
  8004cc:	5e                   	pop    %esi
  8004cd:	5d                   	pop    %ebp
  8004ce:	c3                   	ret    

008004cf <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8004cf:	55                   	push   %ebp
  8004d0:	89 e5                	mov    %esp,%ebp
  8004d2:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  8004d5:	6a 00                	push   $0x0
  8004d7:	e8 79 0b 00 00       	call   801055 <sys_env_destroy>
}
  8004dc:	83 c4 10             	add    $0x10,%esp
  8004df:	c9                   	leave  
  8004e0:	c3                   	ret    

008004e1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8004e1:	55                   	push   %ebp
  8004e2:	89 e5                	mov    %esp,%ebp
  8004e4:	56                   	push   %esi
  8004e5:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8004e6:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8004e9:	8b 35 1c 40 80 00    	mov    0x80401c,%esi
  8004ef:	e8 a2 0b 00 00       	call   801096 <sys_getenvid>
  8004f4:	83 ec 0c             	sub    $0xc,%esp
  8004f7:	ff 75 0c             	pushl  0xc(%ebp)
  8004fa:	ff 75 08             	pushl  0x8(%ebp)
  8004fd:	56                   	push   %esi
  8004fe:	50                   	push   %eax
  8004ff:	68 4c 2d 80 00       	push   $0x802d4c
  800504:	e8 b3 00 00 00       	call   8005bc <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800509:	83 c4 18             	add    $0x18,%esp
  80050c:	53                   	push   %ebx
  80050d:	ff 75 10             	pushl  0x10(%ebp)
  800510:	e8 56 00 00 00       	call   80056b <vcprintf>
	cprintf("\n");
  800515:	c7 04 24 15 31 80 00 	movl   $0x803115,(%esp)
  80051c:	e8 9b 00 00 00       	call   8005bc <cprintf>
  800521:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800524:	cc                   	int3   
  800525:	eb fd                	jmp    800524 <_panic+0x43>

00800527 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800527:	55                   	push   %ebp
  800528:	89 e5                	mov    %esp,%ebp
  80052a:	53                   	push   %ebx
  80052b:	83 ec 04             	sub    $0x4,%esp
  80052e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800531:	8b 13                	mov    (%ebx),%edx
  800533:	8d 42 01             	lea    0x1(%edx),%eax
  800536:	89 03                	mov    %eax,(%ebx)
  800538:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80053b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80053f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800544:	74 09                	je     80054f <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800546:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80054a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80054d:	c9                   	leave  
  80054e:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80054f:	83 ec 08             	sub    $0x8,%esp
  800552:	68 ff 00 00 00       	push   $0xff
  800557:	8d 43 08             	lea    0x8(%ebx),%eax
  80055a:	50                   	push   %eax
  80055b:	e8 b8 0a 00 00       	call   801018 <sys_cputs>
		b->idx = 0;
  800560:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800566:	83 c4 10             	add    $0x10,%esp
  800569:	eb db                	jmp    800546 <putch+0x1f>

0080056b <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80056b:	55                   	push   %ebp
  80056c:	89 e5                	mov    %esp,%ebp
  80056e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800574:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80057b:	00 00 00 
	b.cnt = 0;
  80057e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800585:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800588:	ff 75 0c             	pushl  0xc(%ebp)
  80058b:	ff 75 08             	pushl  0x8(%ebp)
  80058e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800594:	50                   	push   %eax
  800595:	68 27 05 80 00       	push   $0x800527
  80059a:	e8 4a 01 00 00       	call   8006e9 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80059f:	83 c4 08             	add    $0x8,%esp
  8005a2:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8005a8:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8005ae:	50                   	push   %eax
  8005af:	e8 64 0a 00 00       	call   801018 <sys_cputs>

	return b.cnt;
}
  8005b4:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8005ba:	c9                   	leave  
  8005bb:	c3                   	ret    

008005bc <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8005bc:	55                   	push   %ebp
  8005bd:	89 e5                	mov    %esp,%ebp
  8005bf:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005c2:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8005c5:	50                   	push   %eax
  8005c6:	ff 75 08             	pushl  0x8(%ebp)
  8005c9:	e8 9d ff ff ff       	call   80056b <vcprintf>
	va_end(ap);

	return cnt;
}
  8005ce:	c9                   	leave  
  8005cf:	c3                   	ret    

008005d0 <printnum>:


static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005d0:	55                   	push   %ebp
  8005d1:	89 e5                	mov    %esp,%ebp
  8005d3:	57                   	push   %edi
  8005d4:	56                   	push   %esi
  8005d5:	53                   	push   %ebx
  8005d6:	83 ec 1c             	sub    $0x1c,%esp
  8005d9:	89 c6                	mov    %eax,%esi
  8005db:	89 d7                	mov    %edx,%edi
  8005dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005e3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005e6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8005e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8005ec:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	// to support '-'
	if(padc == '-'){
  8005ef:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8005f3:	74 2c                	je     800621 <printnum+0x51>
		while (--width > 0)
			putch(' ', putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005f5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005f8:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8005ff:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800602:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800605:	39 c2                	cmp    %eax,%edx
  800607:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80060a:	73 43                	jae    80064f <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80060c:	83 eb 01             	sub    $0x1,%ebx
  80060f:	85 db                	test   %ebx,%ebx
  800611:	7e 6c                	jle    80067f <printnum+0xaf>
			putch(padc, putdat);
  800613:	83 ec 08             	sub    $0x8,%esp
  800616:	57                   	push   %edi
  800617:	ff 75 18             	pushl  0x18(%ebp)
  80061a:	ff d6                	call   *%esi
  80061c:	83 c4 10             	add    $0x10,%esp
  80061f:	eb eb                	jmp    80060c <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800621:	83 ec 0c             	sub    $0xc,%esp
  800624:	6a 20                	push   $0x20
  800626:	6a 00                	push   $0x0
  800628:	50                   	push   %eax
  800629:	ff 75 e4             	pushl  -0x1c(%ebp)
  80062c:	ff 75 e0             	pushl  -0x20(%ebp)
  80062f:	89 fa                	mov    %edi,%edx
  800631:	89 f0                	mov    %esi,%eax
  800633:	e8 98 ff ff ff       	call   8005d0 <printnum>
		while (--width > 0)
  800638:	83 c4 20             	add    $0x20,%esp
  80063b:	83 eb 01             	sub    $0x1,%ebx
  80063e:	85 db                	test   %ebx,%ebx
  800640:	7e 65                	jle    8006a7 <printnum+0xd7>
			putch(' ', putdat);
  800642:	83 ec 08             	sub    $0x8,%esp
  800645:	57                   	push   %edi
  800646:	6a 20                	push   $0x20
  800648:	ff d6                	call   *%esi
  80064a:	83 c4 10             	add    $0x10,%esp
  80064d:	eb ec                	jmp    80063b <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80064f:	83 ec 0c             	sub    $0xc,%esp
  800652:	ff 75 18             	pushl  0x18(%ebp)
  800655:	83 eb 01             	sub    $0x1,%ebx
  800658:	53                   	push   %ebx
  800659:	50                   	push   %eax
  80065a:	83 ec 08             	sub    $0x8,%esp
  80065d:	ff 75 dc             	pushl  -0x24(%ebp)
  800660:	ff 75 d8             	pushl  -0x28(%ebp)
  800663:	ff 75 e4             	pushl  -0x1c(%ebp)
  800666:	ff 75 e0             	pushl  -0x20(%ebp)
  800669:	e8 42 23 00 00       	call   8029b0 <__udivdi3>
  80066e:	83 c4 18             	add    $0x18,%esp
  800671:	52                   	push   %edx
  800672:	50                   	push   %eax
  800673:	89 fa                	mov    %edi,%edx
  800675:	89 f0                	mov    %esi,%eax
  800677:	e8 54 ff ff ff       	call   8005d0 <printnum>
  80067c:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80067f:	83 ec 08             	sub    $0x8,%esp
  800682:	57                   	push   %edi
  800683:	83 ec 04             	sub    $0x4,%esp
  800686:	ff 75 dc             	pushl  -0x24(%ebp)
  800689:	ff 75 d8             	pushl  -0x28(%ebp)
  80068c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80068f:	ff 75 e0             	pushl  -0x20(%ebp)
  800692:	e8 29 24 00 00       	call   802ac0 <__umoddi3>
  800697:	83 c4 14             	add    $0x14,%esp
  80069a:	0f be 80 6f 2d 80 00 	movsbl 0x802d6f(%eax),%eax
  8006a1:	50                   	push   %eax
  8006a2:	ff d6                	call   *%esi
  8006a4:	83 c4 10             	add    $0x10,%esp
}
  8006a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006aa:	5b                   	pop    %ebx
  8006ab:	5e                   	pop    %esi
  8006ac:	5f                   	pop    %edi
  8006ad:	5d                   	pop    %ebp
  8006ae:	c3                   	ret    

008006af <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8006af:	55                   	push   %ebp
  8006b0:	89 e5                	mov    %esp,%ebp
  8006b2:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8006b5:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8006b9:	8b 10                	mov    (%eax),%edx
  8006bb:	3b 50 04             	cmp    0x4(%eax),%edx
  8006be:	73 0a                	jae    8006ca <sprintputch+0x1b>
		*b->buf++ = ch;
  8006c0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8006c3:	89 08                	mov    %ecx,(%eax)
  8006c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c8:	88 02                	mov    %al,(%edx)
}
  8006ca:	5d                   	pop    %ebp
  8006cb:	c3                   	ret    

008006cc <printfmt>:
{
  8006cc:	55                   	push   %ebp
  8006cd:	89 e5                	mov    %esp,%ebp
  8006cf:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8006d2:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8006d5:	50                   	push   %eax
  8006d6:	ff 75 10             	pushl  0x10(%ebp)
  8006d9:	ff 75 0c             	pushl  0xc(%ebp)
  8006dc:	ff 75 08             	pushl  0x8(%ebp)
  8006df:	e8 05 00 00 00       	call   8006e9 <vprintfmt>
}
  8006e4:	83 c4 10             	add    $0x10,%esp
  8006e7:	c9                   	leave  
  8006e8:	c3                   	ret    

008006e9 <vprintfmt>:
{
  8006e9:	55                   	push   %ebp
  8006ea:	89 e5                	mov    %esp,%ebp
  8006ec:	57                   	push   %edi
  8006ed:	56                   	push   %esi
  8006ee:	53                   	push   %ebx
  8006ef:	83 ec 3c             	sub    $0x3c,%esp
  8006f2:	8b 75 08             	mov    0x8(%ebp),%esi
  8006f5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8006f8:	8b 7d 10             	mov    0x10(%ebp),%edi
  8006fb:	e9 1e 04 00 00       	jmp    800b1e <vprintfmt+0x435>
		posflag = 0;
  800700:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
		padc = ' ';
  800707:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80070b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800712:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800719:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800720:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  800727:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80072c:	8d 47 01             	lea    0x1(%edi),%eax
  80072f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800732:	0f b6 17             	movzbl (%edi),%edx
  800735:	8d 42 dd             	lea    -0x23(%edx),%eax
  800738:	3c 55                	cmp    $0x55,%al
  80073a:	0f 87 d9 04 00 00    	ja     800c19 <vprintfmt+0x530>
  800740:	0f b6 c0             	movzbl %al,%eax
  800743:	ff 24 85 40 2f 80 00 	jmp    *0x802f40(,%eax,4)
  80074a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80074d:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800751:	eb d9                	jmp    80072c <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800753:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posflag = 1;
  800756:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  80075d:	eb cd                	jmp    80072c <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80075f:	0f b6 d2             	movzbl %dl,%edx
  800762:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800765:	b8 00 00 00 00       	mov    $0x0,%eax
  80076a:	89 75 08             	mov    %esi,0x8(%ebp)
  80076d:	eb 0c                	jmp    80077b <vprintfmt+0x92>
		switch (ch = *(unsigned char *) fmt++) {
  80076f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800772:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  800776:	eb b4                	jmp    80072c <vprintfmt+0x43>
			for (precision = 0; ; ++fmt) {
  800778:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80077b:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80077e:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800782:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800785:	8d 72 d0             	lea    -0x30(%edx),%esi
  800788:	83 fe 09             	cmp    $0x9,%esi
  80078b:	76 eb                	jbe    800778 <vprintfmt+0x8f>
  80078d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800790:	8b 75 08             	mov    0x8(%ebp),%esi
  800793:	eb 14                	jmp    8007a9 <vprintfmt+0xc0>
			precision = va_arg(ap, int);
  800795:	8b 45 14             	mov    0x14(%ebp),%eax
  800798:	8b 00                	mov    (%eax),%eax
  80079a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80079d:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a0:	8d 40 04             	lea    0x4(%eax),%eax
  8007a3:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8007a6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8007a9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007ad:	0f 89 79 ff ff ff    	jns    80072c <vprintfmt+0x43>
				width = precision, precision = -1;
  8007b3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007b6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8007b9:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8007c0:	e9 67 ff ff ff       	jmp    80072c <vprintfmt+0x43>
  8007c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007c8:	85 c0                	test   %eax,%eax
  8007ca:	0f 48 c1             	cmovs  %ecx,%eax
  8007cd:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8007d0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8007d3:	e9 54 ff ff ff       	jmp    80072c <vprintfmt+0x43>
  8007d8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8007db:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8007e2:	e9 45 ff ff ff       	jmp    80072c <vprintfmt+0x43>
			lflag++;
  8007e7:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8007eb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8007ee:	e9 39 ff ff ff       	jmp    80072c <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8007f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f6:	8d 78 04             	lea    0x4(%eax),%edi
  8007f9:	83 ec 08             	sub    $0x8,%esp
  8007fc:	53                   	push   %ebx
  8007fd:	ff 30                	pushl  (%eax)
  8007ff:	ff d6                	call   *%esi
			break;
  800801:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800804:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800807:	e9 0f 03 00 00       	jmp    800b1b <vprintfmt+0x432>
			err = va_arg(ap, int);
  80080c:	8b 45 14             	mov    0x14(%ebp),%eax
  80080f:	8d 78 04             	lea    0x4(%eax),%edi
  800812:	8b 00                	mov    (%eax),%eax
  800814:	99                   	cltd   
  800815:	31 d0                	xor    %edx,%eax
  800817:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800819:	83 f8 0f             	cmp    $0xf,%eax
  80081c:	7f 23                	jg     800841 <vprintfmt+0x158>
  80081e:	8b 14 85 a0 30 80 00 	mov    0x8030a0(,%eax,4),%edx
  800825:	85 d2                	test   %edx,%edx
  800827:	74 18                	je     800841 <vprintfmt+0x158>
				printfmt(putch, putdat, "%s", p);
  800829:	52                   	push   %edx
  80082a:	68 be 33 80 00       	push   $0x8033be
  80082f:	53                   	push   %ebx
  800830:	56                   	push   %esi
  800831:	e8 96 fe ff ff       	call   8006cc <printfmt>
  800836:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800839:	89 7d 14             	mov    %edi,0x14(%ebp)
  80083c:	e9 da 02 00 00       	jmp    800b1b <vprintfmt+0x432>
				printfmt(putch, putdat, "error %d", err);
  800841:	50                   	push   %eax
  800842:	68 87 2d 80 00       	push   $0x802d87
  800847:	53                   	push   %ebx
  800848:	56                   	push   %esi
  800849:	e8 7e fe ff ff       	call   8006cc <printfmt>
  80084e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800851:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800854:	e9 c2 02 00 00       	jmp    800b1b <vprintfmt+0x432>
			if ((p = va_arg(ap, char *)) == NULL)
  800859:	8b 45 14             	mov    0x14(%ebp),%eax
  80085c:	83 c0 04             	add    $0x4,%eax
  80085f:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800862:	8b 45 14             	mov    0x14(%ebp),%eax
  800865:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800867:	85 c9                	test   %ecx,%ecx
  800869:	b8 80 2d 80 00       	mov    $0x802d80,%eax
  80086e:	0f 45 c1             	cmovne %ecx,%eax
  800871:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800874:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800878:	7e 06                	jle    800880 <vprintfmt+0x197>
  80087a:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80087e:	75 0d                	jne    80088d <vprintfmt+0x1a4>
				for (width -= strnlen(p, precision); width > 0; width--)
  800880:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800883:	89 c7                	mov    %eax,%edi
  800885:	03 45 e0             	add    -0x20(%ebp),%eax
  800888:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80088b:	eb 53                	jmp    8008e0 <vprintfmt+0x1f7>
  80088d:	83 ec 08             	sub    $0x8,%esp
  800890:	ff 75 d8             	pushl  -0x28(%ebp)
  800893:	50                   	push   %eax
  800894:	e8 28 04 00 00       	call   800cc1 <strnlen>
  800899:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80089c:	29 c1                	sub    %eax,%ecx
  80089e:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  8008a1:	83 c4 10             	add    $0x10,%esp
  8008a4:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8008a6:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8008aa:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8008ad:	eb 0f                	jmp    8008be <vprintfmt+0x1d5>
					putch(padc, putdat);
  8008af:	83 ec 08             	sub    $0x8,%esp
  8008b2:	53                   	push   %ebx
  8008b3:	ff 75 e0             	pushl  -0x20(%ebp)
  8008b6:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8008b8:	83 ef 01             	sub    $0x1,%edi
  8008bb:	83 c4 10             	add    $0x10,%esp
  8008be:	85 ff                	test   %edi,%edi
  8008c0:	7f ed                	jg     8008af <vprintfmt+0x1c6>
  8008c2:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  8008c5:	85 c9                	test   %ecx,%ecx
  8008c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8008cc:	0f 49 c1             	cmovns %ecx,%eax
  8008cf:	29 c1                	sub    %eax,%ecx
  8008d1:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8008d4:	eb aa                	jmp    800880 <vprintfmt+0x197>
					putch(ch, putdat);
  8008d6:	83 ec 08             	sub    $0x8,%esp
  8008d9:	53                   	push   %ebx
  8008da:	52                   	push   %edx
  8008db:	ff d6                	call   *%esi
  8008dd:	83 c4 10             	add    $0x10,%esp
  8008e0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8008e3:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008e5:	83 c7 01             	add    $0x1,%edi
  8008e8:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008ec:	0f be d0             	movsbl %al,%edx
  8008ef:	85 d2                	test   %edx,%edx
  8008f1:	74 4b                	je     80093e <vprintfmt+0x255>
  8008f3:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8008f7:	78 06                	js     8008ff <vprintfmt+0x216>
  8008f9:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8008fd:	78 1e                	js     80091d <vprintfmt+0x234>
				if (altflag && (ch < ' ' || ch > '~'))
  8008ff:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800903:	74 d1                	je     8008d6 <vprintfmt+0x1ed>
  800905:	0f be c0             	movsbl %al,%eax
  800908:	83 e8 20             	sub    $0x20,%eax
  80090b:	83 f8 5e             	cmp    $0x5e,%eax
  80090e:	76 c6                	jbe    8008d6 <vprintfmt+0x1ed>
					putch('?', putdat);
  800910:	83 ec 08             	sub    $0x8,%esp
  800913:	53                   	push   %ebx
  800914:	6a 3f                	push   $0x3f
  800916:	ff d6                	call   *%esi
  800918:	83 c4 10             	add    $0x10,%esp
  80091b:	eb c3                	jmp    8008e0 <vprintfmt+0x1f7>
  80091d:	89 cf                	mov    %ecx,%edi
  80091f:	eb 0e                	jmp    80092f <vprintfmt+0x246>
				putch(' ', putdat);
  800921:	83 ec 08             	sub    $0x8,%esp
  800924:	53                   	push   %ebx
  800925:	6a 20                	push   $0x20
  800927:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800929:	83 ef 01             	sub    $0x1,%edi
  80092c:	83 c4 10             	add    $0x10,%esp
  80092f:	85 ff                	test   %edi,%edi
  800931:	7f ee                	jg     800921 <vprintfmt+0x238>
			if ((p = va_arg(ap, char *)) == NULL)
  800933:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800936:	89 45 14             	mov    %eax,0x14(%ebp)
  800939:	e9 dd 01 00 00       	jmp    800b1b <vprintfmt+0x432>
  80093e:	89 cf                	mov    %ecx,%edi
  800940:	eb ed                	jmp    80092f <vprintfmt+0x246>
	if (lflag >= 2)
  800942:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800946:	7f 21                	jg     800969 <vprintfmt+0x280>
	else if (lflag)
  800948:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80094c:	74 6a                	je     8009b8 <vprintfmt+0x2cf>
		return va_arg(*ap, long);
  80094e:	8b 45 14             	mov    0x14(%ebp),%eax
  800951:	8b 00                	mov    (%eax),%eax
  800953:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800956:	89 c1                	mov    %eax,%ecx
  800958:	c1 f9 1f             	sar    $0x1f,%ecx
  80095b:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80095e:	8b 45 14             	mov    0x14(%ebp),%eax
  800961:	8d 40 04             	lea    0x4(%eax),%eax
  800964:	89 45 14             	mov    %eax,0x14(%ebp)
  800967:	eb 17                	jmp    800980 <vprintfmt+0x297>
		return va_arg(*ap, long long);
  800969:	8b 45 14             	mov    0x14(%ebp),%eax
  80096c:	8b 50 04             	mov    0x4(%eax),%edx
  80096f:	8b 00                	mov    (%eax),%eax
  800971:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800974:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800977:	8b 45 14             	mov    0x14(%ebp),%eax
  80097a:	8d 40 08             	lea    0x8(%eax),%eax
  80097d:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800980:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  800983:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800988:	85 d2                	test   %edx,%edx
  80098a:	0f 89 5c 01 00 00    	jns    800aec <vprintfmt+0x403>
				putch('-', putdat);
  800990:	83 ec 08             	sub    $0x8,%esp
  800993:	53                   	push   %ebx
  800994:	6a 2d                	push   $0x2d
  800996:	ff d6                	call   *%esi
				num = -(long long) num;
  800998:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80099b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80099e:	f7 d8                	neg    %eax
  8009a0:	83 d2 00             	adc    $0x0,%edx
  8009a3:	f7 da                	neg    %edx
  8009a5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009a8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009ab:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8009ae:	bf 0a 00 00 00       	mov    $0xa,%edi
  8009b3:	e9 45 01 00 00       	jmp    800afd <vprintfmt+0x414>
		return va_arg(*ap, int);
  8009b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8009bb:	8b 00                	mov    (%eax),%eax
  8009bd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009c0:	89 c1                	mov    %eax,%ecx
  8009c2:	c1 f9 1f             	sar    $0x1f,%ecx
  8009c5:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8009c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8009cb:	8d 40 04             	lea    0x4(%eax),%eax
  8009ce:	89 45 14             	mov    %eax,0x14(%ebp)
  8009d1:	eb ad                	jmp    800980 <vprintfmt+0x297>
	if (lflag >= 2)
  8009d3:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8009d7:	7f 29                	jg     800a02 <vprintfmt+0x319>
	else if (lflag)
  8009d9:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8009dd:	74 44                	je     800a23 <vprintfmt+0x33a>
		return va_arg(*ap, unsigned long);
  8009df:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e2:	8b 00                	mov    (%eax),%eax
  8009e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8009e9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009ec:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f2:	8d 40 04             	lea    0x4(%eax),%eax
  8009f5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8009f8:	bf 0a 00 00 00       	mov    $0xa,%edi
  8009fd:	e9 ea 00 00 00       	jmp    800aec <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  800a02:	8b 45 14             	mov    0x14(%ebp),%eax
  800a05:	8b 50 04             	mov    0x4(%eax),%edx
  800a08:	8b 00                	mov    (%eax),%eax
  800a0a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a0d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a10:	8b 45 14             	mov    0x14(%ebp),%eax
  800a13:	8d 40 08             	lea    0x8(%eax),%eax
  800a16:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800a19:	bf 0a 00 00 00       	mov    $0xa,%edi
  800a1e:	e9 c9 00 00 00       	jmp    800aec <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  800a23:	8b 45 14             	mov    0x14(%ebp),%eax
  800a26:	8b 00                	mov    (%eax),%eax
  800a28:	ba 00 00 00 00       	mov    $0x0,%edx
  800a2d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a30:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a33:	8b 45 14             	mov    0x14(%ebp),%eax
  800a36:	8d 40 04             	lea    0x4(%eax),%eax
  800a39:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800a3c:	bf 0a 00 00 00       	mov    $0xa,%edi
  800a41:	e9 a6 00 00 00       	jmp    800aec <vprintfmt+0x403>
			putch('0', putdat);
  800a46:	83 ec 08             	sub    $0x8,%esp
  800a49:	53                   	push   %ebx
  800a4a:	6a 30                	push   $0x30
  800a4c:	ff d6                	call   *%esi
	if (lflag >= 2)
  800a4e:	83 c4 10             	add    $0x10,%esp
  800a51:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800a55:	7f 26                	jg     800a7d <vprintfmt+0x394>
	else if (lflag)
  800a57:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800a5b:	74 3e                	je     800a9b <vprintfmt+0x3b2>
		return va_arg(*ap, unsigned long);
  800a5d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a60:	8b 00                	mov    (%eax),%eax
  800a62:	ba 00 00 00 00       	mov    $0x0,%edx
  800a67:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a6a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a6d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a70:	8d 40 04             	lea    0x4(%eax),%eax
  800a73:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800a76:	bf 08 00 00 00       	mov    $0x8,%edi
  800a7b:	eb 6f                	jmp    800aec <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  800a7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a80:	8b 50 04             	mov    0x4(%eax),%edx
  800a83:	8b 00                	mov    (%eax),%eax
  800a85:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a88:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a8b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a8e:	8d 40 08             	lea    0x8(%eax),%eax
  800a91:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800a94:	bf 08 00 00 00       	mov    $0x8,%edi
  800a99:	eb 51                	jmp    800aec <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  800a9b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9e:	8b 00                	mov    (%eax),%eax
  800aa0:	ba 00 00 00 00       	mov    $0x0,%edx
  800aa5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800aa8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800aab:	8b 45 14             	mov    0x14(%ebp),%eax
  800aae:	8d 40 04             	lea    0x4(%eax),%eax
  800ab1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800ab4:	bf 08 00 00 00       	mov    $0x8,%edi
  800ab9:	eb 31                	jmp    800aec <vprintfmt+0x403>
			putch('0', putdat);
  800abb:	83 ec 08             	sub    $0x8,%esp
  800abe:	53                   	push   %ebx
  800abf:	6a 30                	push   $0x30
  800ac1:	ff d6                	call   *%esi
			putch('x', putdat);
  800ac3:	83 c4 08             	add    $0x8,%esp
  800ac6:	53                   	push   %ebx
  800ac7:	6a 78                	push   $0x78
  800ac9:	ff d6                	call   *%esi
			num = (unsigned long long)
  800acb:	8b 45 14             	mov    0x14(%ebp),%eax
  800ace:	8b 00                	mov    (%eax),%eax
  800ad0:	ba 00 00 00 00       	mov    $0x0,%edx
  800ad5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ad8:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800adb:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800ade:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae1:	8d 40 04             	lea    0x4(%eax),%eax
  800ae4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800ae7:	bf 10 00 00 00       	mov    $0x10,%edi
			if(posflag)
  800aec:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800af0:	74 0b                	je     800afd <vprintfmt+0x414>
				putch('+', putdat);
  800af2:	83 ec 08             	sub    $0x8,%esp
  800af5:	53                   	push   %ebx
  800af6:	6a 2b                	push   $0x2b
  800af8:	ff d6                	call   *%esi
  800afa:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  800afd:	83 ec 0c             	sub    $0xc,%esp
  800b00:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800b04:	50                   	push   %eax
  800b05:	ff 75 e0             	pushl  -0x20(%ebp)
  800b08:	57                   	push   %edi
  800b09:	ff 75 dc             	pushl  -0x24(%ebp)
  800b0c:	ff 75 d8             	pushl  -0x28(%ebp)
  800b0f:	89 da                	mov    %ebx,%edx
  800b11:	89 f0                	mov    %esi,%eax
  800b13:	e8 b8 fa ff ff       	call   8005d0 <printnum>
			break;
  800b18:	83 c4 20             	add    $0x20,%esp
			char* cp = va_arg(ap, char *);
  800b1b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b1e:	83 c7 01             	add    $0x1,%edi
  800b21:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800b25:	83 f8 25             	cmp    $0x25,%eax
  800b28:	0f 84 d2 fb ff ff    	je     800700 <vprintfmt+0x17>
			if (ch == '\0')
  800b2e:	85 c0                	test   %eax,%eax
  800b30:	0f 84 03 01 00 00    	je     800c39 <vprintfmt+0x550>
			putch(ch, putdat);
  800b36:	83 ec 08             	sub    $0x8,%esp
  800b39:	53                   	push   %ebx
  800b3a:	50                   	push   %eax
  800b3b:	ff d6                	call   *%esi
  800b3d:	83 c4 10             	add    $0x10,%esp
  800b40:	eb dc                	jmp    800b1e <vprintfmt+0x435>
	if (lflag >= 2)
  800b42:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800b46:	7f 29                	jg     800b71 <vprintfmt+0x488>
	else if (lflag)
  800b48:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800b4c:	74 44                	je     800b92 <vprintfmt+0x4a9>
		return va_arg(*ap, unsigned long);
  800b4e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b51:	8b 00                	mov    (%eax),%eax
  800b53:	ba 00 00 00 00       	mov    $0x0,%edx
  800b58:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b5b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b5e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b61:	8d 40 04             	lea    0x4(%eax),%eax
  800b64:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800b67:	bf 10 00 00 00       	mov    $0x10,%edi
  800b6c:	e9 7b ff ff ff       	jmp    800aec <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  800b71:	8b 45 14             	mov    0x14(%ebp),%eax
  800b74:	8b 50 04             	mov    0x4(%eax),%edx
  800b77:	8b 00                	mov    (%eax),%eax
  800b79:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b7c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b7f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b82:	8d 40 08             	lea    0x8(%eax),%eax
  800b85:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800b88:	bf 10 00 00 00       	mov    $0x10,%edi
  800b8d:	e9 5a ff ff ff       	jmp    800aec <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  800b92:	8b 45 14             	mov    0x14(%ebp),%eax
  800b95:	8b 00                	mov    (%eax),%eax
  800b97:	ba 00 00 00 00       	mov    $0x0,%edx
  800b9c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b9f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ba2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ba5:	8d 40 04             	lea    0x4(%eax),%eax
  800ba8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800bab:	bf 10 00 00 00       	mov    $0x10,%edi
  800bb0:	e9 37 ff ff ff       	jmp    800aec <vprintfmt+0x403>
			char* cp = va_arg(ap, char *);
  800bb5:	8b 45 14             	mov    0x14(%ebp),%eax
  800bb8:	8d 78 04             	lea    0x4(%eax),%edi
  800bbb:	8b 00                	mov    (%eax),%eax
    			if (cp == NULL) {
  800bbd:	85 c0                	test   %eax,%eax
  800bbf:	74 2c                	je     800bed <vprintfmt+0x504>
    			*cp = *(int *)putdat;
  800bc1:	8b 13                	mov    (%ebx),%edx
  800bc3:	88 10                	mov    %dl,(%eax)
			char* cp = va_arg(ap, char *);
  800bc5:	89 7d 14             	mov    %edi,0x14(%ebp)
    			if ((*(int *) putdat) > 127)
  800bc8:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  800bcb:	0f 8e 4a ff ff ff    	jle    800b1b <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", overflow_error);
  800bd1:	68 dc 2e 80 00       	push   $0x802edc
  800bd6:	68 be 33 80 00       	push   $0x8033be
  800bdb:	53                   	push   %ebx
  800bdc:	56                   	push   %esi
  800bdd:	e8 ea fa ff ff       	call   8006cc <printfmt>
  800be2:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  800be5:	89 7d 14             	mov    %edi,0x14(%ebp)
  800be8:	e9 2e ff ff ff       	jmp    800b1b <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", null_error);
  800bed:	68 a4 2e 80 00       	push   $0x802ea4
  800bf2:	68 be 33 80 00       	push   $0x8033be
  800bf7:	53                   	push   %ebx
  800bf8:	56                   	push   %esi
  800bf9:	e8 ce fa ff ff       	call   8006cc <printfmt>
        		break;
  800bfe:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  800c01:	89 7d 14             	mov    %edi,0x14(%ebp)
        		break;
  800c04:	e9 12 ff ff ff       	jmp    800b1b <vprintfmt+0x432>
			putch(ch, putdat);
  800c09:	83 ec 08             	sub    $0x8,%esp
  800c0c:	53                   	push   %ebx
  800c0d:	6a 25                	push   $0x25
  800c0f:	ff d6                	call   *%esi
			break;
  800c11:	83 c4 10             	add    $0x10,%esp
  800c14:	e9 02 ff ff ff       	jmp    800b1b <vprintfmt+0x432>
			putch('%', putdat);
  800c19:	83 ec 08             	sub    $0x8,%esp
  800c1c:	53                   	push   %ebx
  800c1d:	6a 25                	push   $0x25
  800c1f:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c21:	83 c4 10             	add    $0x10,%esp
  800c24:	89 f8                	mov    %edi,%eax
  800c26:	eb 03                	jmp    800c2b <vprintfmt+0x542>
  800c28:	83 e8 01             	sub    $0x1,%eax
  800c2b:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800c2f:	75 f7                	jne    800c28 <vprintfmt+0x53f>
  800c31:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c34:	e9 e2 fe ff ff       	jmp    800b1b <vprintfmt+0x432>
}
  800c39:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c3c:	5b                   	pop    %ebx
  800c3d:	5e                   	pop    %esi
  800c3e:	5f                   	pop    %edi
  800c3f:	5d                   	pop    %ebp
  800c40:	c3                   	ret    

00800c41 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c41:	55                   	push   %ebp
  800c42:	89 e5                	mov    %esp,%ebp
  800c44:	83 ec 18             	sub    $0x18,%esp
  800c47:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4a:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c4d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c50:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800c54:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800c57:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c5e:	85 c0                	test   %eax,%eax
  800c60:	74 26                	je     800c88 <vsnprintf+0x47>
  800c62:	85 d2                	test   %edx,%edx
  800c64:	7e 22                	jle    800c88 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c66:	ff 75 14             	pushl  0x14(%ebp)
  800c69:	ff 75 10             	pushl  0x10(%ebp)
  800c6c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c6f:	50                   	push   %eax
  800c70:	68 af 06 80 00       	push   $0x8006af
  800c75:	e8 6f fa ff ff       	call   8006e9 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800c7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c7d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c83:	83 c4 10             	add    $0x10,%esp
}
  800c86:	c9                   	leave  
  800c87:	c3                   	ret    
		return -E_INVAL;
  800c88:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c8d:	eb f7                	jmp    800c86 <vsnprintf+0x45>

00800c8f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c8f:	55                   	push   %ebp
  800c90:	89 e5                	mov    %esp,%ebp
  800c92:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c95:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800c98:	50                   	push   %eax
  800c99:	ff 75 10             	pushl  0x10(%ebp)
  800c9c:	ff 75 0c             	pushl  0xc(%ebp)
  800c9f:	ff 75 08             	pushl  0x8(%ebp)
  800ca2:	e8 9a ff ff ff       	call   800c41 <vsnprintf>
	va_end(ap);

	return rc;
}
  800ca7:	c9                   	leave  
  800ca8:	c3                   	ret    

00800ca9 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800ca9:	55                   	push   %ebp
  800caa:	89 e5                	mov    %esp,%ebp
  800cac:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800caf:	b8 00 00 00 00       	mov    $0x0,%eax
  800cb4:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800cb8:	74 05                	je     800cbf <strlen+0x16>
		n++;
  800cba:	83 c0 01             	add    $0x1,%eax
  800cbd:	eb f5                	jmp    800cb4 <strlen+0xb>
	return n;
}
  800cbf:	5d                   	pop    %ebp
  800cc0:	c3                   	ret    

00800cc1 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800cc1:	55                   	push   %ebp
  800cc2:	89 e5                	mov    %esp,%ebp
  800cc4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cc7:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cca:	ba 00 00 00 00       	mov    $0x0,%edx
  800ccf:	39 c2                	cmp    %eax,%edx
  800cd1:	74 0d                	je     800ce0 <strnlen+0x1f>
  800cd3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800cd7:	74 05                	je     800cde <strnlen+0x1d>
		n++;
  800cd9:	83 c2 01             	add    $0x1,%edx
  800cdc:	eb f1                	jmp    800ccf <strnlen+0xe>
  800cde:	89 d0                	mov    %edx,%eax
	return n;
}
  800ce0:	5d                   	pop    %ebp
  800ce1:	c3                   	ret    

00800ce2 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ce2:	55                   	push   %ebp
  800ce3:	89 e5                	mov    %esp,%ebp
  800ce5:	53                   	push   %ebx
  800ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800cec:	ba 00 00 00 00       	mov    $0x0,%edx
  800cf1:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800cf5:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800cf8:	83 c2 01             	add    $0x1,%edx
  800cfb:	84 c9                	test   %cl,%cl
  800cfd:	75 f2                	jne    800cf1 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800cff:	5b                   	pop    %ebx
  800d00:	5d                   	pop    %ebp
  800d01:	c3                   	ret    

00800d02 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800d02:	55                   	push   %ebp
  800d03:	89 e5                	mov    %esp,%ebp
  800d05:	53                   	push   %ebx
  800d06:	83 ec 10             	sub    $0x10,%esp
  800d09:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800d0c:	53                   	push   %ebx
  800d0d:	e8 97 ff ff ff       	call   800ca9 <strlen>
  800d12:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800d15:	ff 75 0c             	pushl  0xc(%ebp)
  800d18:	01 d8                	add    %ebx,%eax
  800d1a:	50                   	push   %eax
  800d1b:	e8 c2 ff ff ff       	call   800ce2 <strcpy>
	return dst;
}
  800d20:	89 d8                	mov    %ebx,%eax
  800d22:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d25:	c9                   	leave  
  800d26:	c3                   	ret    

00800d27 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800d27:	55                   	push   %ebp
  800d28:	89 e5                	mov    %esp,%ebp
  800d2a:	56                   	push   %esi
  800d2b:	53                   	push   %ebx
  800d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d32:	89 c6                	mov    %eax,%esi
  800d34:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d37:	89 c2                	mov    %eax,%edx
  800d39:	39 f2                	cmp    %esi,%edx
  800d3b:	74 11                	je     800d4e <strncpy+0x27>
		*dst++ = *src;
  800d3d:	83 c2 01             	add    $0x1,%edx
  800d40:	0f b6 19             	movzbl (%ecx),%ebx
  800d43:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800d46:	80 fb 01             	cmp    $0x1,%bl
  800d49:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800d4c:	eb eb                	jmp    800d39 <strncpy+0x12>
	}
	return ret;
}
  800d4e:	5b                   	pop    %ebx
  800d4f:	5e                   	pop    %esi
  800d50:	5d                   	pop    %ebp
  800d51:	c3                   	ret    

00800d52 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800d52:	55                   	push   %ebp
  800d53:	89 e5                	mov    %esp,%ebp
  800d55:	56                   	push   %esi
  800d56:	53                   	push   %ebx
  800d57:	8b 75 08             	mov    0x8(%ebp),%esi
  800d5a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d5d:	8b 55 10             	mov    0x10(%ebp),%edx
  800d60:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800d62:	85 d2                	test   %edx,%edx
  800d64:	74 21                	je     800d87 <strlcpy+0x35>
  800d66:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800d6a:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800d6c:	39 c2                	cmp    %eax,%edx
  800d6e:	74 14                	je     800d84 <strlcpy+0x32>
  800d70:	0f b6 19             	movzbl (%ecx),%ebx
  800d73:	84 db                	test   %bl,%bl
  800d75:	74 0b                	je     800d82 <strlcpy+0x30>
			*dst++ = *src++;
  800d77:	83 c1 01             	add    $0x1,%ecx
  800d7a:	83 c2 01             	add    $0x1,%edx
  800d7d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800d80:	eb ea                	jmp    800d6c <strlcpy+0x1a>
  800d82:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800d84:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d87:	29 f0                	sub    %esi,%eax
}
  800d89:	5b                   	pop    %ebx
  800d8a:	5e                   	pop    %esi
  800d8b:	5d                   	pop    %ebp
  800d8c:	c3                   	ret    

00800d8d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d8d:	55                   	push   %ebp
  800d8e:	89 e5                	mov    %esp,%ebp
  800d90:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d93:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800d96:	0f b6 01             	movzbl (%ecx),%eax
  800d99:	84 c0                	test   %al,%al
  800d9b:	74 0c                	je     800da9 <strcmp+0x1c>
  800d9d:	3a 02                	cmp    (%edx),%al
  800d9f:	75 08                	jne    800da9 <strcmp+0x1c>
		p++, q++;
  800da1:	83 c1 01             	add    $0x1,%ecx
  800da4:	83 c2 01             	add    $0x1,%edx
  800da7:	eb ed                	jmp    800d96 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800da9:	0f b6 c0             	movzbl %al,%eax
  800dac:	0f b6 12             	movzbl (%edx),%edx
  800daf:	29 d0                	sub    %edx,%eax
}
  800db1:	5d                   	pop    %ebp
  800db2:	c3                   	ret    

00800db3 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800db3:	55                   	push   %ebp
  800db4:	89 e5                	mov    %esp,%ebp
  800db6:	53                   	push   %ebx
  800db7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dba:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dbd:	89 c3                	mov    %eax,%ebx
  800dbf:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800dc2:	eb 06                	jmp    800dca <strncmp+0x17>
		n--, p++, q++;
  800dc4:	83 c0 01             	add    $0x1,%eax
  800dc7:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800dca:	39 d8                	cmp    %ebx,%eax
  800dcc:	74 16                	je     800de4 <strncmp+0x31>
  800dce:	0f b6 08             	movzbl (%eax),%ecx
  800dd1:	84 c9                	test   %cl,%cl
  800dd3:	74 04                	je     800dd9 <strncmp+0x26>
  800dd5:	3a 0a                	cmp    (%edx),%cl
  800dd7:	74 eb                	je     800dc4 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800dd9:	0f b6 00             	movzbl (%eax),%eax
  800ddc:	0f b6 12             	movzbl (%edx),%edx
  800ddf:	29 d0                	sub    %edx,%eax
}
  800de1:	5b                   	pop    %ebx
  800de2:	5d                   	pop    %ebp
  800de3:	c3                   	ret    
		return 0;
  800de4:	b8 00 00 00 00       	mov    $0x0,%eax
  800de9:	eb f6                	jmp    800de1 <strncmp+0x2e>

00800deb <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800deb:	55                   	push   %ebp
  800dec:	89 e5                	mov    %esp,%ebp
  800dee:	8b 45 08             	mov    0x8(%ebp),%eax
  800df1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800df5:	0f b6 10             	movzbl (%eax),%edx
  800df8:	84 d2                	test   %dl,%dl
  800dfa:	74 09                	je     800e05 <strchr+0x1a>
		if (*s == c)
  800dfc:	38 ca                	cmp    %cl,%dl
  800dfe:	74 0a                	je     800e0a <strchr+0x1f>
	for (; *s; s++)
  800e00:	83 c0 01             	add    $0x1,%eax
  800e03:	eb f0                	jmp    800df5 <strchr+0xa>
			return (char *) s;
	return 0;
  800e05:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e0a:	5d                   	pop    %ebp
  800e0b:	c3                   	ret    

00800e0c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e0c:	55                   	push   %ebp
  800e0d:	89 e5                	mov    %esp,%ebp
  800e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e12:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800e16:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800e19:	38 ca                	cmp    %cl,%dl
  800e1b:	74 09                	je     800e26 <strfind+0x1a>
  800e1d:	84 d2                	test   %dl,%dl
  800e1f:	74 05                	je     800e26 <strfind+0x1a>
	for (; *s; s++)
  800e21:	83 c0 01             	add    $0x1,%eax
  800e24:	eb f0                	jmp    800e16 <strfind+0xa>
			break;
	return (char *) s;
}
  800e26:	5d                   	pop    %ebp
  800e27:	c3                   	ret    

00800e28 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800e28:	55                   	push   %ebp
  800e29:	89 e5                	mov    %esp,%ebp
  800e2b:	57                   	push   %edi
  800e2c:	56                   	push   %esi
  800e2d:	53                   	push   %ebx
  800e2e:	8b 7d 08             	mov    0x8(%ebp),%edi
  800e31:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800e34:	85 c9                	test   %ecx,%ecx
  800e36:	74 31                	je     800e69 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800e38:	89 f8                	mov    %edi,%eax
  800e3a:	09 c8                	or     %ecx,%eax
  800e3c:	a8 03                	test   $0x3,%al
  800e3e:	75 23                	jne    800e63 <memset+0x3b>
		c &= 0xFF;
  800e40:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800e44:	89 d3                	mov    %edx,%ebx
  800e46:	c1 e3 08             	shl    $0x8,%ebx
  800e49:	89 d0                	mov    %edx,%eax
  800e4b:	c1 e0 18             	shl    $0x18,%eax
  800e4e:	89 d6                	mov    %edx,%esi
  800e50:	c1 e6 10             	shl    $0x10,%esi
  800e53:	09 f0                	or     %esi,%eax
  800e55:	09 c2                	or     %eax,%edx
  800e57:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800e59:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800e5c:	89 d0                	mov    %edx,%eax
  800e5e:	fc                   	cld    
  800e5f:	f3 ab                	rep stos %eax,%es:(%edi)
  800e61:	eb 06                	jmp    800e69 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800e63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e66:	fc                   	cld    
  800e67:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800e69:	89 f8                	mov    %edi,%eax
  800e6b:	5b                   	pop    %ebx
  800e6c:	5e                   	pop    %esi
  800e6d:	5f                   	pop    %edi
  800e6e:	5d                   	pop    %ebp
  800e6f:	c3                   	ret    

00800e70 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800e70:	55                   	push   %ebp
  800e71:	89 e5                	mov    %esp,%ebp
  800e73:	57                   	push   %edi
  800e74:	56                   	push   %esi
  800e75:	8b 45 08             	mov    0x8(%ebp),%eax
  800e78:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e7b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e7e:	39 c6                	cmp    %eax,%esi
  800e80:	73 32                	jae    800eb4 <memmove+0x44>
  800e82:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800e85:	39 c2                	cmp    %eax,%edx
  800e87:	76 2b                	jbe    800eb4 <memmove+0x44>
		s += n;
		d += n;
  800e89:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e8c:	89 fe                	mov    %edi,%esi
  800e8e:	09 ce                	or     %ecx,%esi
  800e90:	09 d6                	or     %edx,%esi
  800e92:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800e98:	75 0e                	jne    800ea8 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800e9a:	83 ef 04             	sub    $0x4,%edi
  800e9d:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ea0:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800ea3:	fd                   	std    
  800ea4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ea6:	eb 09                	jmp    800eb1 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ea8:	83 ef 01             	sub    $0x1,%edi
  800eab:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800eae:	fd                   	std    
  800eaf:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800eb1:	fc                   	cld    
  800eb2:	eb 1a                	jmp    800ece <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800eb4:	89 c2                	mov    %eax,%edx
  800eb6:	09 ca                	or     %ecx,%edx
  800eb8:	09 f2                	or     %esi,%edx
  800eba:	f6 c2 03             	test   $0x3,%dl
  800ebd:	75 0a                	jne    800ec9 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ebf:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800ec2:	89 c7                	mov    %eax,%edi
  800ec4:	fc                   	cld    
  800ec5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ec7:	eb 05                	jmp    800ece <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800ec9:	89 c7                	mov    %eax,%edi
  800ecb:	fc                   	cld    
  800ecc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ece:	5e                   	pop    %esi
  800ecf:	5f                   	pop    %edi
  800ed0:	5d                   	pop    %ebp
  800ed1:	c3                   	ret    

00800ed2 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ed2:	55                   	push   %ebp
  800ed3:	89 e5                	mov    %esp,%ebp
  800ed5:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ed8:	ff 75 10             	pushl  0x10(%ebp)
  800edb:	ff 75 0c             	pushl  0xc(%ebp)
  800ede:	ff 75 08             	pushl  0x8(%ebp)
  800ee1:	e8 8a ff ff ff       	call   800e70 <memmove>
}
  800ee6:	c9                   	leave  
  800ee7:	c3                   	ret    

00800ee8 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ee8:	55                   	push   %ebp
  800ee9:	89 e5                	mov    %esp,%ebp
  800eeb:	56                   	push   %esi
  800eec:	53                   	push   %ebx
  800eed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ef3:	89 c6                	mov    %eax,%esi
  800ef5:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ef8:	39 f0                	cmp    %esi,%eax
  800efa:	74 1c                	je     800f18 <memcmp+0x30>
		if (*s1 != *s2)
  800efc:	0f b6 08             	movzbl (%eax),%ecx
  800eff:	0f b6 1a             	movzbl (%edx),%ebx
  800f02:	38 d9                	cmp    %bl,%cl
  800f04:	75 08                	jne    800f0e <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800f06:	83 c0 01             	add    $0x1,%eax
  800f09:	83 c2 01             	add    $0x1,%edx
  800f0c:	eb ea                	jmp    800ef8 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800f0e:	0f b6 c1             	movzbl %cl,%eax
  800f11:	0f b6 db             	movzbl %bl,%ebx
  800f14:	29 d8                	sub    %ebx,%eax
  800f16:	eb 05                	jmp    800f1d <memcmp+0x35>
	}

	return 0;
  800f18:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f1d:	5b                   	pop    %ebx
  800f1e:	5e                   	pop    %esi
  800f1f:	5d                   	pop    %ebp
  800f20:	c3                   	ret    

00800f21 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800f21:	55                   	push   %ebp
  800f22:	89 e5                	mov    %esp,%ebp
  800f24:	8b 45 08             	mov    0x8(%ebp),%eax
  800f27:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800f2a:	89 c2                	mov    %eax,%edx
  800f2c:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800f2f:	39 d0                	cmp    %edx,%eax
  800f31:	73 09                	jae    800f3c <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f33:	38 08                	cmp    %cl,(%eax)
  800f35:	74 05                	je     800f3c <memfind+0x1b>
	for (; s < ends; s++)
  800f37:	83 c0 01             	add    $0x1,%eax
  800f3a:	eb f3                	jmp    800f2f <memfind+0xe>
			break;
	return (void *) s;
}
  800f3c:	5d                   	pop    %ebp
  800f3d:	c3                   	ret    

00800f3e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f3e:	55                   	push   %ebp
  800f3f:	89 e5                	mov    %esp,%ebp
  800f41:	57                   	push   %edi
  800f42:	56                   	push   %esi
  800f43:	53                   	push   %ebx
  800f44:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f47:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f4a:	eb 03                	jmp    800f4f <strtol+0x11>
		s++;
  800f4c:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800f4f:	0f b6 01             	movzbl (%ecx),%eax
  800f52:	3c 20                	cmp    $0x20,%al
  800f54:	74 f6                	je     800f4c <strtol+0xe>
  800f56:	3c 09                	cmp    $0x9,%al
  800f58:	74 f2                	je     800f4c <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800f5a:	3c 2b                	cmp    $0x2b,%al
  800f5c:	74 2a                	je     800f88 <strtol+0x4a>
	int neg = 0;
  800f5e:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800f63:	3c 2d                	cmp    $0x2d,%al
  800f65:	74 2b                	je     800f92 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f67:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800f6d:	75 0f                	jne    800f7e <strtol+0x40>
  800f6f:	80 39 30             	cmpb   $0x30,(%ecx)
  800f72:	74 28                	je     800f9c <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800f74:	85 db                	test   %ebx,%ebx
  800f76:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f7b:	0f 44 d8             	cmove  %eax,%ebx
  800f7e:	b8 00 00 00 00       	mov    $0x0,%eax
  800f83:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800f86:	eb 50                	jmp    800fd8 <strtol+0x9a>
		s++;
  800f88:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800f8b:	bf 00 00 00 00       	mov    $0x0,%edi
  800f90:	eb d5                	jmp    800f67 <strtol+0x29>
		s++, neg = 1;
  800f92:	83 c1 01             	add    $0x1,%ecx
  800f95:	bf 01 00 00 00       	mov    $0x1,%edi
  800f9a:	eb cb                	jmp    800f67 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f9c:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800fa0:	74 0e                	je     800fb0 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800fa2:	85 db                	test   %ebx,%ebx
  800fa4:	75 d8                	jne    800f7e <strtol+0x40>
		s++, base = 8;
  800fa6:	83 c1 01             	add    $0x1,%ecx
  800fa9:	bb 08 00 00 00       	mov    $0x8,%ebx
  800fae:	eb ce                	jmp    800f7e <strtol+0x40>
		s += 2, base = 16;
  800fb0:	83 c1 02             	add    $0x2,%ecx
  800fb3:	bb 10 00 00 00       	mov    $0x10,%ebx
  800fb8:	eb c4                	jmp    800f7e <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800fba:	8d 72 9f             	lea    -0x61(%edx),%esi
  800fbd:	89 f3                	mov    %esi,%ebx
  800fbf:	80 fb 19             	cmp    $0x19,%bl
  800fc2:	77 29                	ja     800fed <strtol+0xaf>
			dig = *s - 'a' + 10;
  800fc4:	0f be d2             	movsbl %dl,%edx
  800fc7:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800fca:	3b 55 10             	cmp    0x10(%ebp),%edx
  800fcd:	7d 30                	jge    800fff <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800fcf:	83 c1 01             	add    $0x1,%ecx
  800fd2:	0f af 45 10          	imul   0x10(%ebp),%eax
  800fd6:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800fd8:	0f b6 11             	movzbl (%ecx),%edx
  800fdb:	8d 72 d0             	lea    -0x30(%edx),%esi
  800fde:	89 f3                	mov    %esi,%ebx
  800fe0:	80 fb 09             	cmp    $0x9,%bl
  800fe3:	77 d5                	ja     800fba <strtol+0x7c>
			dig = *s - '0';
  800fe5:	0f be d2             	movsbl %dl,%edx
  800fe8:	83 ea 30             	sub    $0x30,%edx
  800feb:	eb dd                	jmp    800fca <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800fed:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ff0:	89 f3                	mov    %esi,%ebx
  800ff2:	80 fb 19             	cmp    $0x19,%bl
  800ff5:	77 08                	ja     800fff <strtol+0xc1>
			dig = *s - 'A' + 10;
  800ff7:	0f be d2             	movsbl %dl,%edx
  800ffa:	83 ea 37             	sub    $0x37,%edx
  800ffd:	eb cb                	jmp    800fca <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800fff:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801003:	74 05                	je     80100a <strtol+0xcc>
		*endptr = (char *) s;
  801005:	8b 75 0c             	mov    0xc(%ebp),%esi
  801008:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  80100a:	89 c2                	mov    %eax,%edx
  80100c:	f7 da                	neg    %edx
  80100e:	85 ff                	test   %edi,%edi
  801010:	0f 45 c2             	cmovne %edx,%eax
}
  801013:	5b                   	pop    %ebx
  801014:	5e                   	pop    %esi
  801015:	5f                   	pop    %edi
  801016:	5d                   	pop    %ebp
  801017:	c3                   	ret    

00801018 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801018:	55                   	push   %ebp
  801019:	89 e5                	mov    %esp,%ebp
  80101b:	57                   	push   %edi
  80101c:	56                   	push   %esi
  80101d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80101e:	b8 00 00 00 00       	mov    $0x0,%eax
  801023:	8b 55 08             	mov    0x8(%ebp),%edx
  801026:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801029:	89 c3                	mov    %eax,%ebx
  80102b:	89 c7                	mov    %eax,%edi
  80102d:	89 c6                	mov    %eax,%esi
  80102f:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  801031:	5b                   	pop    %ebx
  801032:	5e                   	pop    %esi
  801033:	5f                   	pop    %edi
  801034:	5d                   	pop    %ebp
  801035:	c3                   	ret    

00801036 <sys_cgetc>:

int
sys_cgetc(void)
{
  801036:	55                   	push   %ebp
  801037:	89 e5                	mov    %esp,%ebp
  801039:	57                   	push   %edi
  80103a:	56                   	push   %esi
  80103b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80103c:	ba 00 00 00 00       	mov    $0x0,%edx
  801041:	b8 01 00 00 00       	mov    $0x1,%eax
  801046:	89 d1                	mov    %edx,%ecx
  801048:	89 d3                	mov    %edx,%ebx
  80104a:	89 d7                	mov    %edx,%edi
  80104c:	89 d6                	mov    %edx,%esi
  80104e:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  801050:	5b                   	pop    %ebx
  801051:	5e                   	pop    %esi
  801052:	5f                   	pop    %edi
  801053:	5d                   	pop    %ebp
  801054:	c3                   	ret    

00801055 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801055:	55                   	push   %ebp
  801056:	89 e5                	mov    %esp,%ebp
  801058:	57                   	push   %edi
  801059:	56                   	push   %esi
  80105a:	53                   	push   %ebx
  80105b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80105e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801063:	8b 55 08             	mov    0x8(%ebp),%edx
  801066:	b8 03 00 00 00       	mov    $0x3,%eax
  80106b:	89 cb                	mov    %ecx,%ebx
  80106d:	89 cf                	mov    %ecx,%edi
  80106f:	89 ce                	mov    %ecx,%esi
  801071:	cd 30                	int    $0x30
	if (check && ret > 0)
  801073:	85 c0                	test   %eax,%eax
  801075:	7f 08                	jg     80107f <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801077:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80107a:	5b                   	pop    %ebx
  80107b:	5e                   	pop    %esi
  80107c:	5f                   	pop    %edi
  80107d:	5d                   	pop    %ebp
  80107e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80107f:	83 ec 0c             	sub    $0xc,%esp
  801082:	50                   	push   %eax
  801083:	6a 03                	push   $0x3
  801085:	68 e0 30 80 00       	push   $0x8030e0
  80108a:	6a 4c                	push   $0x4c
  80108c:	68 fd 30 80 00       	push   $0x8030fd
  801091:	e8 4b f4 ff ff       	call   8004e1 <_panic>

00801096 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801096:	55                   	push   %ebp
  801097:	89 e5                	mov    %esp,%ebp
  801099:	57                   	push   %edi
  80109a:	56                   	push   %esi
  80109b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80109c:	ba 00 00 00 00       	mov    $0x0,%edx
  8010a1:	b8 02 00 00 00       	mov    $0x2,%eax
  8010a6:	89 d1                	mov    %edx,%ecx
  8010a8:	89 d3                	mov    %edx,%ebx
  8010aa:	89 d7                	mov    %edx,%edi
  8010ac:	89 d6                	mov    %edx,%esi
  8010ae:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8010b0:	5b                   	pop    %ebx
  8010b1:	5e                   	pop    %esi
  8010b2:	5f                   	pop    %edi
  8010b3:	5d                   	pop    %ebp
  8010b4:	c3                   	ret    

008010b5 <sys_yield>:

void
sys_yield(void)
{
  8010b5:	55                   	push   %ebp
  8010b6:	89 e5                	mov    %esp,%ebp
  8010b8:	57                   	push   %edi
  8010b9:	56                   	push   %esi
  8010ba:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8010c0:	b8 0b 00 00 00       	mov    $0xb,%eax
  8010c5:	89 d1                	mov    %edx,%ecx
  8010c7:	89 d3                	mov    %edx,%ebx
  8010c9:	89 d7                	mov    %edx,%edi
  8010cb:	89 d6                	mov    %edx,%esi
  8010cd:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8010cf:	5b                   	pop    %ebx
  8010d0:	5e                   	pop    %esi
  8010d1:	5f                   	pop    %edi
  8010d2:	5d                   	pop    %ebp
  8010d3:	c3                   	ret    

008010d4 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8010d4:	55                   	push   %ebp
  8010d5:	89 e5                	mov    %esp,%ebp
  8010d7:	57                   	push   %edi
  8010d8:	56                   	push   %esi
  8010d9:	53                   	push   %ebx
  8010da:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010dd:	be 00 00 00 00       	mov    $0x0,%esi
  8010e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8010e5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010e8:	b8 04 00 00 00       	mov    $0x4,%eax
  8010ed:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010f0:	89 f7                	mov    %esi,%edi
  8010f2:	cd 30                	int    $0x30
	if (check && ret > 0)
  8010f4:	85 c0                	test   %eax,%eax
  8010f6:	7f 08                	jg     801100 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8010f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010fb:	5b                   	pop    %ebx
  8010fc:	5e                   	pop    %esi
  8010fd:	5f                   	pop    %edi
  8010fe:	5d                   	pop    %ebp
  8010ff:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801100:	83 ec 0c             	sub    $0xc,%esp
  801103:	50                   	push   %eax
  801104:	6a 04                	push   $0x4
  801106:	68 e0 30 80 00       	push   $0x8030e0
  80110b:	6a 4c                	push   $0x4c
  80110d:	68 fd 30 80 00       	push   $0x8030fd
  801112:	e8 ca f3 ff ff       	call   8004e1 <_panic>

00801117 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801117:	55                   	push   %ebp
  801118:	89 e5                	mov    %esp,%ebp
  80111a:	57                   	push   %edi
  80111b:	56                   	push   %esi
  80111c:	53                   	push   %ebx
  80111d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801120:	8b 55 08             	mov    0x8(%ebp),%edx
  801123:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801126:	b8 05 00 00 00       	mov    $0x5,%eax
  80112b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80112e:	8b 7d 14             	mov    0x14(%ebp),%edi
  801131:	8b 75 18             	mov    0x18(%ebp),%esi
  801134:	cd 30                	int    $0x30
	if (check && ret > 0)
  801136:	85 c0                	test   %eax,%eax
  801138:	7f 08                	jg     801142 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80113a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80113d:	5b                   	pop    %ebx
  80113e:	5e                   	pop    %esi
  80113f:	5f                   	pop    %edi
  801140:	5d                   	pop    %ebp
  801141:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801142:	83 ec 0c             	sub    $0xc,%esp
  801145:	50                   	push   %eax
  801146:	6a 05                	push   $0x5
  801148:	68 e0 30 80 00       	push   $0x8030e0
  80114d:	6a 4c                	push   $0x4c
  80114f:	68 fd 30 80 00       	push   $0x8030fd
  801154:	e8 88 f3 ff ff       	call   8004e1 <_panic>

00801159 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801159:	55                   	push   %ebp
  80115a:	89 e5                	mov    %esp,%ebp
  80115c:	57                   	push   %edi
  80115d:	56                   	push   %esi
  80115e:	53                   	push   %ebx
  80115f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801162:	bb 00 00 00 00       	mov    $0x0,%ebx
  801167:	8b 55 08             	mov    0x8(%ebp),%edx
  80116a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80116d:	b8 06 00 00 00       	mov    $0x6,%eax
  801172:	89 df                	mov    %ebx,%edi
  801174:	89 de                	mov    %ebx,%esi
  801176:	cd 30                	int    $0x30
	if (check && ret > 0)
  801178:	85 c0                	test   %eax,%eax
  80117a:	7f 08                	jg     801184 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80117c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80117f:	5b                   	pop    %ebx
  801180:	5e                   	pop    %esi
  801181:	5f                   	pop    %edi
  801182:	5d                   	pop    %ebp
  801183:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801184:	83 ec 0c             	sub    $0xc,%esp
  801187:	50                   	push   %eax
  801188:	6a 06                	push   $0x6
  80118a:	68 e0 30 80 00       	push   $0x8030e0
  80118f:	6a 4c                	push   $0x4c
  801191:	68 fd 30 80 00       	push   $0x8030fd
  801196:	e8 46 f3 ff ff       	call   8004e1 <_panic>

0080119b <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80119b:	55                   	push   %ebp
  80119c:	89 e5                	mov    %esp,%ebp
  80119e:	57                   	push   %edi
  80119f:	56                   	push   %esi
  8011a0:	53                   	push   %ebx
  8011a1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011a4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8011ac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011af:	b8 08 00 00 00       	mov    $0x8,%eax
  8011b4:	89 df                	mov    %ebx,%edi
  8011b6:	89 de                	mov    %ebx,%esi
  8011b8:	cd 30                	int    $0x30
	if (check && ret > 0)
  8011ba:	85 c0                	test   %eax,%eax
  8011bc:	7f 08                	jg     8011c6 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8011be:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011c1:	5b                   	pop    %ebx
  8011c2:	5e                   	pop    %esi
  8011c3:	5f                   	pop    %edi
  8011c4:	5d                   	pop    %ebp
  8011c5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011c6:	83 ec 0c             	sub    $0xc,%esp
  8011c9:	50                   	push   %eax
  8011ca:	6a 08                	push   $0x8
  8011cc:	68 e0 30 80 00       	push   $0x8030e0
  8011d1:	6a 4c                	push   $0x4c
  8011d3:	68 fd 30 80 00       	push   $0x8030fd
  8011d8:	e8 04 f3 ff ff       	call   8004e1 <_panic>

008011dd <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8011dd:	55                   	push   %ebp
  8011de:	89 e5                	mov    %esp,%ebp
  8011e0:	57                   	push   %edi
  8011e1:	56                   	push   %esi
  8011e2:	53                   	push   %ebx
  8011e3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011e6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8011ee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011f1:	b8 09 00 00 00       	mov    $0x9,%eax
  8011f6:	89 df                	mov    %ebx,%edi
  8011f8:	89 de                	mov    %ebx,%esi
  8011fa:	cd 30                	int    $0x30
	if (check && ret > 0)
  8011fc:	85 c0                	test   %eax,%eax
  8011fe:	7f 08                	jg     801208 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801200:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801203:	5b                   	pop    %ebx
  801204:	5e                   	pop    %esi
  801205:	5f                   	pop    %edi
  801206:	5d                   	pop    %ebp
  801207:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801208:	83 ec 0c             	sub    $0xc,%esp
  80120b:	50                   	push   %eax
  80120c:	6a 09                	push   $0x9
  80120e:	68 e0 30 80 00       	push   $0x8030e0
  801213:	6a 4c                	push   $0x4c
  801215:	68 fd 30 80 00       	push   $0x8030fd
  80121a:	e8 c2 f2 ff ff       	call   8004e1 <_panic>

0080121f <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80121f:	55                   	push   %ebp
  801220:	89 e5                	mov    %esp,%ebp
  801222:	57                   	push   %edi
  801223:	56                   	push   %esi
  801224:	53                   	push   %ebx
  801225:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801228:	bb 00 00 00 00       	mov    $0x0,%ebx
  80122d:	8b 55 08             	mov    0x8(%ebp),%edx
  801230:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801233:	b8 0a 00 00 00       	mov    $0xa,%eax
  801238:	89 df                	mov    %ebx,%edi
  80123a:	89 de                	mov    %ebx,%esi
  80123c:	cd 30                	int    $0x30
	if (check && ret > 0)
  80123e:	85 c0                	test   %eax,%eax
  801240:	7f 08                	jg     80124a <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801242:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801245:	5b                   	pop    %ebx
  801246:	5e                   	pop    %esi
  801247:	5f                   	pop    %edi
  801248:	5d                   	pop    %ebp
  801249:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80124a:	83 ec 0c             	sub    $0xc,%esp
  80124d:	50                   	push   %eax
  80124e:	6a 0a                	push   $0xa
  801250:	68 e0 30 80 00       	push   $0x8030e0
  801255:	6a 4c                	push   $0x4c
  801257:	68 fd 30 80 00       	push   $0x8030fd
  80125c:	e8 80 f2 ff ff       	call   8004e1 <_panic>

00801261 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801261:	55                   	push   %ebp
  801262:	89 e5                	mov    %esp,%ebp
  801264:	57                   	push   %edi
  801265:	56                   	push   %esi
  801266:	53                   	push   %ebx
	asm volatile("int %1\n"
  801267:	8b 55 08             	mov    0x8(%ebp),%edx
  80126a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80126d:	b8 0c 00 00 00       	mov    $0xc,%eax
  801272:	be 00 00 00 00       	mov    $0x0,%esi
  801277:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80127a:	8b 7d 14             	mov    0x14(%ebp),%edi
  80127d:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80127f:	5b                   	pop    %ebx
  801280:	5e                   	pop    %esi
  801281:	5f                   	pop    %edi
  801282:	5d                   	pop    %ebp
  801283:	c3                   	ret    

00801284 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801284:	55                   	push   %ebp
  801285:	89 e5                	mov    %esp,%ebp
  801287:	57                   	push   %edi
  801288:	56                   	push   %esi
  801289:	53                   	push   %ebx
  80128a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80128d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801292:	8b 55 08             	mov    0x8(%ebp),%edx
  801295:	b8 0d 00 00 00       	mov    $0xd,%eax
  80129a:	89 cb                	mov    %ecx,%ebx
  80129c:	89 cf                	mov    %ecx,%edi
  80129e:	89 ce                	mov    %ecx,%esi
  8012a0:	cd 30                	int    $0x30
	if (check && ret > 0)
  8012a2:	85 c0                	test   %eax,%eax
  8012a4:	7f 08                	jg     8012ae <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8012a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012a9:	5b                   	pop    %ebx
  8012aa:	5e                   	pop    %esi
  8012ab:	5f                   	pop    %edi
  8012ac:	5d                   	pop    %ebp
  8012ad:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012ae:	83 ec 0c             	sub    $0xc,%esp
  8012b1:	50                   	push   %eax
  8012b2:	6a 0d                	push   $0xd
  8012b4:	68 e0 30 80 00       	push   $0x8030e0
  8012b9:	6a 4c                	push   $0x4c
  8012bb:	68 fd 30 80 00       	push   $0x8030fd
  8012c0:	e8 1c f2 ff ff       	call   8004e1 <_panic>

008012c5 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  8012c5:	55                   	push   %ebp
  8012c6:	89 e5                	mov    %esp,%ebp
  8012c8:	57                   	push   %edi
  8012c9:	56                   	push   %esi
  8012ca:	53                   	push   %ebx
	asm volatile("int %1\n"
  8012cb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8012d3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012d6:	b8 0e 00 00 00       	mov    $0xe,%eax
  8012db:	89 df                	mov    %ebx,%edi
  8012dd:	89 de                	mov    %ebx,%esi
  8012df:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8012e1:	5b                   	pop    %ebx
  8012e2:	5e                   	pop    %esi
  8012e3:	5f                   	pop    %edi
  8012e4:	5d                   	pop    %ebp
  8012e5:	c3                   	ret    

008012e6 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8012e6:	55                   	push   %ebp
  8012e7:	89 e5                	mov    %esp,%ebp
  8012e9:	57                   	push   %edi
  8012ea:	56                   	push   %esi
  8012eb:	53                   	push   %ebx
	asm volatile("int %1\n"
  8012ec:	b9 00 00 00 00       	mov    $0x0,%ecx
  8012f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8012f4:	b8 0f 00 00 00       	mov    $0xf,%eax
  8012f9:	89 cb                	mov    %ecx,%ebx
  8012fb:	89 cf                	mov    %ecx,%edi
  8012fd:	89 ce                	mov    %ecx,%esi
  8012ff:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801301:	5b                   	pop    %ebx
  801302:	5e                   	pop    %esi
  801303:	5f                   	pop    %edi
  801304:	5d                   	pop    %ebp
  801305:	c3                   	ret    

00801306 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801306:	55                   	push   %ebp
  801307:	89 e5                	mov    %esp,%ebp
  801309:	53                   	push   %ebx
  80130a:	83 ec 04             	sub    $0x4,%esp
  80130d:	8b 55 08             	mov    0x8(%ebp),%edx
	// cprintf("pgfault()\n");
	void *addr = (void *) utf->utf_fault_va;
  801310:	8b 02                	mov    (%edx),%eax
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(!(err & FEC_WR) || !(uvpd[PDX(addr)] & PTE_P) || !(uvpt[PGNUM(addr)] & PTE_P) || !(uvpt[PGNUM(addr)] & PTE_COW))
  801312:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801316:	0f 84 9c 00 00 00    	je     8013b8 <pgfault+0xb2>
  80131c:	89 c2                	mov    %eax,%edx
  80131e:	c1 ea 16             	shr    $0x16,%edx
  801321:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801328:	f6 c2 01             	test   $0x1,%dl
  80132b:	0f 84 87 00 00 00    	je     8013b8 <pgfault+0xb2>
  801331:	89 c2                	mov    %eax,%edx
  801333:	c1 ea 0c             	shr    $0xc,%edx
  801336:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80133d:	f6 c1 01             	test   $0x1,%cl
  801340:	74 76                	je     8013b8 <pgfault+0xb2>
  801342:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801349:	f6 c6 08             	test   $0x8,%dh
  80134c:	74 6a                	je     8013b8 <pgfault+0xb2>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  80134e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801353:	89 c3                	mov    %eax,%ebx

	r = sys_page_alloc(0, PFTEMP, PTE_P|PTE_U|PTE_W);
  801355:	83 ec 04             	sub    $0x4,%esp
  801358:	6a 07                	push   $0x7
  80135a:	68 00 f0 7f 00       	push   $0x7ff000
  80135f:	6a 00                	push   $0x0
  801361:	e8 6e fd ff ff       	call   8010d4 <sys_page_alloc>
	if(r < 0){
  801366:	83 c4 10             	add    $0x10,%esp
  801369:	85 c0                	test   %eax,%eax
  80136b:	78 5f                	js     8013cc <pgfault+0xc6>
		panic("pgfault: sys_page_alloc fail, r: %d", r);
	}

	memmove(PFTEMP, addr, PGSIZE);
  80136d:	83 ec 04             	sub    $0x4,%esp
  801370:	68 00 10 00 00       	push   $0x1000
  801375:	53                   	push   %ebx
  801376:	68 00 f0 7f 00       	push   $0x7ff000
  80137b:	e8 f0 fa ff ff       	call   800e70 <memmove>

	r = sys_page_map(0, PFTEMP, 0, addr, PTE_P|PTE_U|PTE_W);
  801380:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801387:	53                   	push   %ebx
  801388:	6a 00                	push   $0x0
  80138a:	68 00 f0 7f 00       	push   $0x7ff000
  80138f:	6a 00                	push   $0x0
  801391:	e8 81 fd ff ff       	call   801117 <sys_page_map>
	if(r < 0){
  801396:	83 c4 20             	add    $0x20,%esp
  801399:	85 c0                	test   %eax,%eax
  80139b:	78 41                	js     8013de <pgfault+0xd8>
		panic("pgfault: sys_page_map fail, r: %d", r);
	}

	r = sys_page_unmap(0, PFTEMP);
  80139d:	83 ec 08             	sub    $0x8,%esp
  8013a0:	68 00 f0 7f 00       	push   $0x7ff000
  8013a5:	6a 00                	push   $0x0
  8013a7:	e8 ad fd ff ff       	call   801159 <sys_page_unmap>
	if(r < 0){
  8013ac:	83 c4 10             	add    $0x10,%esp
  8013af:	85 c0                	test   %eax,%eax
  8013b1:	78 3d                	js     8013f0 <pgfault+0xea>
		panic("sys_page_unmap: %e", r);
	}
}
  8013b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013b6:	c9                   	leave  
  8013b7:	c3                   	ret    
		panic("pgfault: 1\n");
  8013b8:	83 ec 04             	sub    $0x4,%esp
  8013bb:	68 0b 31 80 00       	push   $0x80310b
  8013c0:	6a 20                	push   $0x20
  8013c2:	68 17 31 80 00       	push   $0x803117
  8013c7:	e8 15 f1 ff ff       	call   8004e1 <_panic>
		panic("pgfault: sys_page_alloc fail, r: %d", r);
  8013cc:	50                   	push   %eax
  8013cd:	68 6c 31 80 00       	push   $0x80316c
  8013d2:	6a 2e                	push   $0x2e
  8013d4:	68 17 31 80 00       	push   $0x803117
  8013d9:	e8 03 f1 ff ff       	call   8004e1 <_panic>
		panic("pgfault: sys_page_map fail, r: %d", r);
  8013de:	50                   	push   %eax
  8013df:	68 90 31 80 00       	push   $0x803190
  8013e4:	6a 35                	push   $0x35
  8013e6:	68 17 31 80 00       	push   $0x803117
  8013eb:	e8 f1 f0 ff ff       	call   8004e1 <_panic>
		panic("sys_page_unmap: %e", r);
  8013f0:	50                   	push   %eax
  8013f1:	68 22 31 80 00       	push   $0x803122
  8013f6:	6a 3a                	push   $0x3a
  8013f8:	68 17 31 80 00       	push   $0x803117
  8013fd:	e8 df f0 ff ff       	call   8004e1 <_panic>

00801402 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801402:	55                   	push   %ebp
  801403:	89 e5                	mov    %esp,%ebp
  801405:	57                   	push   %edi
  801406:	56                   	push   %esi
  801407:	53                   	push   %ebx
  801408:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	// panic("fork not implemented");
	int r;
	set_pgfault_handler(pgfault);
  80140b:	68 06 13 80 00       	push   $0x801306
  801410:	e8 cd 13 00 00       	call   8027e2 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801415:	b8 07 00 00 00       	mov    $0x7,%eax
  80141a:	cd 30                	int    $0x30
  80141c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int i;
	uintptr_t va;
	envid_t childid = sys_exofork();
	if (childid < 0){
  80141f:	83 c4 10             	add    $0x10,%esp
  801422:	85 c0                	test   %eax,%eax
  801424:	78 2c                	js     801452 <fork+0x50>
  801426:	89 c7                	mov    %eax,%edi
	}

	extern volatile pde_t uvpd[];
	extern volatile pte_t uvpt[];

	for (va = UTEXT; va < USTACKTOP; va += PGSIZE){
  801428:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if (childid == 0) {
  80142d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801431:	75 72                	jne    8014a5 <fork+0xa3>
		thisenv = &envs[ENVX(sys_getenvid())];
  801433:	e8 5e fc ff ff       	call   801096 <sys_getenvid>
  801438:	25 ff 03 00 00       	and    $0x3ff,%eax
  80143d:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  801443:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801448:	a3 04 50 80 00       	mov    %eax,0x805004
		return 0;
  80144d:	e9 36 01 00 00       	jmp    801588 <fork+0x186>
		panic("fork: child id < 0: %d", childid);
  801452:	50                   	push   %eax
  801453:	68 35 31 80 00       	push   $0x803135
  801458:	68 83 00 00 00       	push   $0x83
  80145d:	68 17 31 80 00       	push   $0x803117
  801462:	e8 7a f0 ff ff       	call   8004e1 <_panic>
			panic("sys_page_map: sys_page_map fail, r:%d\n", r);
  801467:	50                   	push   %eax
  801468:	68 b4 31 80 00       	push   $0x8031b4
  80146d:	6a 56                	push   $0x56
  80146f:	68 17 31 80 00       	push   $0x803117
  801474:	e8 68 f0 ff ff       	call   8004e1 <_panic>
		r = sys_page_map((envid_t)0, va, envid, va, PTE_U | PTE_P);
  801479:	83 ec 0c             	sub    $0xc,%esp
  80147c:	6a 05                	push   $0x5
  80147e:	56                   	push   %esi
  80147f:	57                   	push   %edi
  801480:	56                   	push   %esi
  801481:	6a 00                	push   $0x0
  801483:	e8 8f fc ff ff       	call   801117 <sys_page_map>
		if(r < 0){
  801488:	83 c4 20             	add    $0x20,%esp
  80148b:	85 c0                	test   %eax,%eax
  80148d:	0f 88 9f 00 00 00    	js     801532 <fork+0x130>
	for (va = UTEXT; va < USTACKTOP; va += PGSIZE){
  801493:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801499:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  80149f:	0f 84 9f 00 00 00    	je     801544 <fork+0x142>
		if ((uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_U)){
  8014a5:	89 d8                	mov    %ebx,%eax
  8014a7:	c1 e8 16             	shr    $0x16,%eax
  8014aa:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8014b1:	a8 01                	test   $0x1,%al
  8014b3:	74 de                	je     801493 <fork+0x91>
  8014b5:	89 d8                	mov    %ebx,%eax
  8014b7:	c1 e8 0c             	shr    $0xc,%eax
  8014ba:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8014c1:	f6 c2 01             	test   $0x1,%dl
  8014c4:	74 cd                	je     801493 <fork+0x91>
  8014c6:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8014cd:	f6 c2 04             	test   $0x4,%dl
  8014d0:	74 c1                	je     801493 <fork+0x91>
	void * va = (void *)(pn * PGSIZE);
  8014d2:	89 c6                	mov    %eax,%esi
  8014d4:	c1 e6 0c             	shl    $0xc,%esi
	int perm = (uvpt[pn]);
  8014d7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (perm & (PTE_W | PTE_COW)) {
  8014de:	a9 02 08 00 00       	test   $0x802,%eax
  8014e3:	74 94                	je     801479 <fork+0x77>
		r = sys_page_map((envid_t)0, va, envid, va, PTE_U | PTE_P | PTE_COW);
  8014e5:	83 ec 0c             	sub    $0xc,%esp
  8014e8:	68 05 08 00 00       	push   $0x805
  8014ed:	56                   	push   %esi
  8014ee:	57                   	push   %edi
  8014ef:	56                   	push   %esi
  8014f0:	6a 00                	push   $0x0
  8014f2:	e8 20 fc ff ff       	call   801117 <sys_page_map>
		if(r < 0){
  8014f7:	83 c4 20             	add    $0x20,%esp
  8014fa:	85 c0                	test   %eax,%eax
  8014fc:	0f 88 65 ff ff ff    	js     801467 <fork+0x65>
		r = sys_page_map((envid_t)0, va, (envid_t)0, va, PTE_U | PTE_P | PTE_COW);
  801502:	83 ec 0c             	sub    $0xc,%esp
  801505:	68 05 08 00 00       	push   $0x805
  80150a:	56                   	push   %esi
  80150b:	6a 00                	push   $0x0
  80150d:	56                   	push   %esi
  80150e:	6a 00                	push   $0x0
  801510:	e8 02 fc ff ff       	call   801117 <sys_page_map>
		if(r < 0){
  801515:	83 c4 20             	add    $0x20,%esp
  801518:	85 c0                	test   %eax,%eax
  80151a:	0f 89 73 ff ff ff    	jns    801493 <fork+0x91>
			panic("sys_page_map: sys_page_map fail, r:%d\n", r);
  801520:	50                   	push   %eax
  801521:	68 b4 31 80 00       	push   $0x8031b4
  801526:	6a 5b                	push   $0x5b
  801528:	68 17 31 80 00       	push   $0x803117
  80152d:	e8 af ef ff ff       	call   8004e1 <_panic>
			panic("sys_page_map: sys_page_map fail, r:%d\n", r);
  801532:	50                   	push   %eax
  801533:	68 b4 31 80 00       	push   $0x8031b4
  801538:	6a 61                	push   $0x61
  80153a:	68 17 31 80 00       	push   $0x803117
  80153f:	e8 9d ef ff ff       	call   8004e1 <_panic>
			duppage(childid, PGNUM(va));
		}
	}

	r = sys_page_alloc(childid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801544:	83 ec 04             	sub    $0x4,%esp
  801547:	6a 07                	push   $0x7
  801549:	68 00 f0 bf ee       	push   $0xeebff000
  80154e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801551:	e8 7e fb ff ff       	call   8010d4 <sys_page_alloc>
	if (r < 0){
  801556:	83 c4 10             	add    $0x10,%esp
  801559:	85 c0                	test   %eax,%eax
  80155b:	78 36                	js     801593 <fork+0x191>
		panic("fork: allocate user exception stack for child env error, %d", r);
	}
	r = sys_env_set_pgfault_upcall(childid, _pgfault_upcall);
  80155d:	83 ec 08             	sub    $0x8,%esp
  801560:	68 4d 28 80 00       	push   $0x80284d
  801565:	ff 75 e4             	pushl  -0x1c(%ebp)
  801568:	e8 b2 fc ff ff       	call   80121f <sys_env_set_pgfault_upcall>
	if (r < 0){
  80156d:	83 c4 10             	add    $0x10,%esp
  801570:	85 c0                	test   %eax,%eax
  801572:	78 34                	js     8015a8 <fork+0x1a6>
		panic("fork: sys_env_set_pgfault_upcall error, %d", r);
	}
	r = sys_env_set_status(childid, ENV_RUNNABLE);
  801574:	83 ec 08             	sub    $0x8,%esp
  801577:	6a 02                	push   $0x2
  801579:	ff 75 e4             	pushl  -0x1c(%ebp)
  80157c:	e8 1a fc ff ff       	call   80119b <sys_env_set_status>
	if(r < 0){
  801581:	83 c4 10             	add    $0x10,%esp
  801584:	85 c0                	test   %eax,%eax
  801586:	78 35                	js     8015bd <fork+0x1bb>
		panic("forK: sys_env_set_status, r%d", r);
	}
	return childid;
}
  801588:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80158b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80158e:	5b                   	pop    %ebx
  80158f:	5e                   	pop    %esi
  801590:	5f                   	pop    %edi
  801591:	5d                   	pop    %ebp
  801592:	c3                   	ret    
		panic("fork: allocate user exception stack for child env error, %d", r);
  801593:	50                   	push   %eax
  801594:	68 dc 31 80 00       	push   $0x8031dc
  801599:	68 96 00 00 00       	push   $0x96
  80159e:	68 17 31 80 00       	push   $0x803117
  8015a3:	e8 39 ef ff ff       	call   8004e1 <_panic>
		panic("fork: sys_env_set_pgfault_upcall error, %d", r);
  8015a8:	50                   	push   %eax
  8015a9:	68 18 32 80 00       	push   $0x803218
  8015ae:	68 9a 00 00 00       	push   $0x9a
  8015b3:	68 17 31 80 00       	push   $0x803117
  8015b8:	e8 24 ef ff ff       	call   8004e1 <_panic>
		panic("forK: sys_env_set_status, r%d", r);
  8015bd:	50                   	push   %eax
  8015be:	68 4c 31 80 00       	push   $0x80314c
  8015c3:	68 9e 00 00 00       	push   $0x9e
  8015c8:	68 17 31 80 00       	push   $0x803117
  8015cd:	e8 0f ef ff ff       	call   8004e1 <_panic>

008015d2 <sfork>:

// Challenge!
int
sfork(void)
{
  8015d2:	55                   	push   %ebp
  8015d3:	89 e5                	mov    %esp,%ebp
  8015d5:	57                   	push   %edi
  8015d6:	56                   	push   %esi
  8015d7:	53                   	push   %ebx
  8015d8:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// return -E_INVAL;
	set_pgfault_handler(pgfault);
  8015db:	68 06 13 80 00       	push   $0x801306
  8015e0:	e8 fd 11 00 00       	call   8027e2 <set_pgfault_handler>
  8015e5:	b8 07 00 00 00       	mov    $0x7,%eax
  8015ea:	cd 30                	int    $0x30
  8015ec:	89 c6                	mov    %eax,%esi
	int i;
	uintptr_t va;
	envid_t childid = sys_exofork();
	int r;
	if (childid < 0){
  8015ee:	83 c4 10             	add    $0x10,%esp
  8015f1:	85 c0                	test   %eax,%eax
  8015f3:	78 28                	js     80161d <sfork+0x4b>
  8015f5:	89 c7                	mov    %eax,%edi
	}

	extern volatile pde_t uvpd[];
	extern volatile pte_t uvpt[];

	for (va = 0; va < USTACKTOP; va += PGSIZE){
  8015f7:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (childid == 0) {
  8015fc:	75 42                	jne    801640 <sfork+0x6e>
		thisenv = &envs[ENVX(sys_getenvid())];
  8015fe:	e8 93 fa ff ff       	call   801096 <sys_getenvid>
  801603:	25 ff 03 00 00       	and    $0x3ff,%eax
  801608:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80160e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801613:	a3 04 50 80 00       	mov    %eax,0x805004
		return 0;
  801618:	e9 bc 00 00 00       	jmp    8016d9 <sfork+0x107>
		panic("fork: child id < 0: %d", childid);
  80161d:	50                   	push   %eax
  80161e:	68 35 31 80 00       	push   $0x803135
  801623:	68 af 00 00 00       	push   $0xaf
  801628:	68 17 31 80 00       	push   $0x803117
  80162d:	e8 af ee ff ff       	call   8004e1 <_panic>
	for (va = 0; va < USTACKTOP; va += PGSIZE){
  801632:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801638:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  80163e:	74 5b                	je     80169b <sfork+0xc9>
		if ((uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_U)){
  801640:	89 d8                	mov    %ebx,%eax
  801642:	c1 e8 16             	shr    $0x16,%eax
  801645:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80164c:	a8 01                	test   $0x1,%al
  80164e:	74 e2                	je     801632 <sfork+0x60>
  801650:	89 d8                	mov    %ebx,%eax
  801652:	c1 e8 0c             	shr    $0xc,%eax
  801655:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80165c:	f6 c2 01             	test   $0x1,%dl
  80165f:	74 d1                	je     801632 <sfork+0x60>
  801661:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801668:	f6 c2 04             	test   $0x4,%dl
  80166b:	74 c5                	je     801632 <sfork+0x60>
			void *addr = (void *)(PGNUM(va) * PGSIZE);
  80166d:	c1 e0 0c             	shl    $0xc,%eax
			struct PageInfo *page;
			pte_t *pte;
			
			// page = page_lookup((envid_t)0->env_pgdir, addr, &pte);
			// page_insert(dstenv->env_pgdir, page, addr, PTE_U | PTE_P);
			r = sys_page_map((envid_t)0, addr, childid, addr, PTE_U | PTE_P);
  801670:	83 ec 0c             	sub    $0xc,%esp
  801673:	6a 05                	push   $0x5
  801675:	50                   	push   %eax
  801676:	57                   	push   %edi
  801677:	50                   	push   %eax
  801678:	6a 00                	push   $0x0
  80167a:	e8 98 fa ff ff       	call   801117 <sys_page_map>
			if(r < 0){
  80167f:	83 c4 20             	add    $0x20,%esp
  801682:	85 c0                	test   %eax,%eax
  801684:	79 ac                	jns    801632 <sfork+0x60>
				panic("sfork: sys_page_map fail, r:%d\n", r);
  801686:	50                   	push   %eax
  801687:	68 44 32 80 00       	push   $0x803244
  80168c:	68 c4 00 00 00       	push   $0xc4
  801691:	68 17 31 80 00       	push   $0x803117
  801696:	e8 46 ee ff ff       	call   8004e1 <_panic>
			}
		}
	}

	r = sys_page_alloc(childid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  80169b:	83 ec 04             	sub    $0x4,%esp
  80169e:	6a 07                	push   $0x7
  8016a0:	68 00 f0 bf ee       	push   $0xeebff000
  8016a5:	56                   	push   %esi
  8016a6:	e8 29 fa ff ff       	call   8010d4 <sys_page_alloc>
	if (r < 0){
  8016ab:	83 c4 10             	add    $0x10,%esp
  8016ae:	85 c0                	test   %eax,%eax
  8016b0:	78 31                	js     8016e3 <sfork+0x111>
		panic("sfork: allocate user exception stack for child env error, %d", r);
	}
	r = sys_env_set_pgfault_upcall(childid, _pgfault_upcall);
  8016b2:	83 ec 08             	sub    $0x8,%esp
  8016b5:	68 4d 28 80 00       	push   $0x80284d
  8016ba:	56                   	push   %esi
  8016bb:	e8 5f fb ff ff       	call   80121f <sys_env_set_pgfault_upcall>
	if (r < 0){
  8016c0:	83 c4 10             	add    $0x10,%esp
  8016c3:	85 c0                	test   %eax,%eax
  8016c5:	78 31                	js     8016f8 <sfork+0x126>
		panic("sfork: sys_env_set_pgfault_upcall error, %d", r);
	}
	r = sys_env_set_status(childid, ENV_RUNNABLE);
  8016c7:	83 ec 08             	sub    $0x8,%esp
  8016ca:	6a 02                	push   $0x2
  8016cc:	56                   	push   %esi
  8016cd:	e8 c9 fa ff ff       	call   80119b <sys_env_set_status>
	if(r < 0){
  8016d2:	83 c4 10             	add    $0x10,%esp
  8016d5:	85 c0                	test   %eax,%eax
  8016d7:	78 34                	js     80170d <sfork+0x13b>
		panic("sforK: sys_env_set_status, r%d", r);
	}
	return childid;
}
  8016d9:	89 f0                	mov    %esi,%eax
  8016db:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016de:	5b                   	pop    %ebx
  8016df:	5e                   	pop    %esi
  8016e0:	5f                   	pop    %edi
  8016e1:	5d                   	pop    %ebp
  8016e2:	c3                   	ret    
		panic("sfork: allocate user exception stack for child env error, %d", r);
  8016e3:	50                   	push   %eax
  8016e4:	68 64 32 80 00       	push   $0x803264
  8016e9:	68 cb 00 00 00       	push   $0xcb
  8016ee:	68 17 31 80 00       	push   $0x803117
  8016f3:	e8 e9 ed ff ff       	call   8004e1 <_panic>
		panic("sfork: sys_env_set_pgfault_upcall error, %d", r);
  8016f8:	50                   	push   %eax
  8016f9:	68 a4 32 80 00       	push   $0x8032a4
  8016fe:	68 cf 00 00 00       	push   $0xcf
  801703:	68 17 31 80 00       	push   $0x803117
  801708:	e8 d4 ed ff ff       	call   8004e1 <_panic>
		panic("sforK: sys_env_set_status, r%d", r);
  80170d:	50                   	push   %eax
  80170e:	68 d0 32 80 00       	push   $0x8032d0
  801713:	68 d3 00 00 00       	push   $0xd3
  801718:	68 17 31 80 00       	push   $0x803117
  80171d:	e8 bf ed ff ff       	call   8004e1 <_panic>

00801722 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801722:	55                   	push   %ebp
  801723:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801725:	8b 45 08             	mov    0x8(%ebp),%eax
  801728:	05 00 00 00 30       	add    $0x30000000,%eax
  80172d:	c1 e8 0c             	shr    $0xc,%eax
}
  801730:	5d                   	pop    %ebp
  801731:	c3                   	ret    

00801732 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801732:	55                   	push   %ebp
  801733:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801735:	8b 45 08             	mov    0x8(%ebp),%eax
  801738:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80173d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801742:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801747:	5d                   	pop    %ebp
  801748:	c3                   	ret    

00801749 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801749:	55                   	push   %ebp
  80174a:	89 e5                	mov    %esp,%ebp
  80174c:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801751:	89 c2                	mov    %eax,%edx
  801753:	c1 ea 16             	shr    $0x16,%edx
  801756:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80175d:	f6 c2 01             	test   $0x1,%dl
  801760:	74 2d                	je     80178f <fd_alloc+0x46>
  801762:	89 c2                	mov    %eax,%edx
  801764:	c1 ea 0c             	shr    $0xc,%edx
  801767:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80176e:	f6 c2 01             	test   $0x1,%dl
  801771:	74 1c                	je     80178f <fd_alloc+0x46>
  801773:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801778:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80177d:	75 d2                	jne    801751 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80177f:	8b 45 08             	mov    0x8(%ebp),%eax
  801782:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801788:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80178d:	eb 0a                	jmp    801799 <fd_alloc+0x50>
			*fd_store = fd;
  80178f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801792:	89 01                	mov    %eax,(%ecx)
			return 0;
  801794:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801799:	5d                   	pop    %ebp
  80179a:	c3                   	ret    

0080179b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80179b:	55                   	push   %ebp
  80179c:	89 e5                	mov    %esp,%ebp
  80179e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8017a1:	83 f8 1f             	cmp    $0x1f,%eax
  8017a4:	77 30                	ja     8017d6 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8017a6:	c1 e0 0c             	shl    $0xc,%eax
  8017a9:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8017ae:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8017b4:	f6 c2 01             	test   $0x1,%dl
  8017b7:	74 24                	je     8017dd <fd_lookup+0x42>
  8017b9:	89 c2                	mov    %eax,%edx
  8017bb:	c1 ea 0c             	shr    $0xc,%edx
  8017be:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8017c5:	f6 c2 01             	test   $0x1,%dl
  8017c8:	74 1a                	je     8017e4 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8017ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017cd:	89 02                	mov    %eax,(%edx)
	return 0;
  8017cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017d4:	5d                   	pop    %ebp
  8017d5:	c3                   	ret    
		return -E_INVAL;
  8017d6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017db:	eb f7                	jmp    8017d4 <fd_lookup+0x39>
		return -E_INVAL;
  8017dd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017e2:	eb f0                	jmp    8017d4 <fd_lookup+0x39>
  8017e4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017e9:	eb e9                	jmp    8017d4 <fd_lookup+0x39>

008017eb <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8017eb:	55                   	push   %ebp
  8017ec:	89 e5                	mov    %esp,%ebp
  8017ee:	83 ec 08             	sub    $0x8,%esp
  8017f1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017f4:	ba 6c 33 80 00       	mov    $0x80336c,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8017f9:	b8 20 40 80 00       	mov    $0x804020,%eax
		if (devtab[i]->dev_id == dev_id) {
  8017fe:	39 08                	cmp    %ecx,(%eax)
  801800:	74 33                	je     801835 <dev_lookup+0x4a>
  801802:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801805:	8b 02                	mov    (%edx),%eax
  801807:	85 c0                	test   %eax,%eax
  801809:	75 f3                	jne    8017fe <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80180b:	a1 04 50 80 00       	mov    0x805004,%eax
  801810:	8b 40 48             	mov    0x48(%eax),%eax
  801813:	83 ec 04             	sub    $0x4,%esp
  801816:	51                   	push   %ecx
  801817:	50                   	push   %eax
  801818:	68 f0 32 80 00       	push   $0x8032f0
  80181d:	e8 9a ed ff ff       	call   8005bc <cprintf>
	*dev = 0;
  801822:	8b 45 0c             	mov    0xc(%ebp),%eax
  801825:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80182b:	83 c4 10             	add    $0x10,%esp
  80182e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801833:	c9                   	leave  
  801834:	c3                   	ret    
			*dev = devtab[i];
  801835:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801838:	89 01                	mov    %eax,(%ecx)
			return 0;
  80183a:	b8 00 00 00 00       	mov    $0x0,%eax
  80183f:	eb f2                	jmp    801833 <dev_lookup+0x48>

00801841 <fd_close>:
{
  801841:	55                   	push   %ebp
  801842:	89 e5                	mov    %esp,%ebp
  801844:	57                   	push   %edi
  801845:	56                   	push   %esi
  801846:	53                   	push   %ebx
  801847:	83 ec 24             	sub    $0x24,%esp
  80184a:	8b 75 08             	mov    0x8(%ebp),%esi
  80184d:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801850:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801853:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801854:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80185a:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80185d:	50                   	push   %eax
  80185e:	e8 38 ff ff ff       	call   80179b <fd_lookup>
  801863:	89 c3                	mov    %eax,%ebx
  801865:	83 c4 10             	add    $0x10,%esp
  801868:	85 c0                	test   %eax,%eax
  80186a:	78 05                	js     801871 <fd_close+0x30>
	    || fd != fd2)
  80186c:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80186f:	74 16                	je     801887 <fd_close+0x46>
		return (must_exist ? r : 0);
  801871:	89 f8                	mov    %edi,%eax
  801873:	84 c0                	test   %al,%al
  801875:	b8 00 00 00 00       	mov    $0x0,%eax
  80187a:	0f 44 d8             	cmove  %eax,%ebx
}
  80187d:	89 d8                	mov    %ebx,%eax
  80187f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801882:	5b                   	pop    %ebx
  801883:	5e                   	pop    %esi
  801884:	5f                   	pop    %edi
  801885:	5d                   	pop    %ebp
  801886:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801887:	83 ec 08             	sub    $0x8,%esp
  80188a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80188d:	50                   	push   %eax
  80188e:	ff 36                	pushl  (%esi)
  801890:	e8 56 ff ff ff       	call   8017eb <dev_lookup>
  801895:	89 c3                	mov    %eax,%ebx
  801897:	83 c4 10             	add    $0x10,%esp
  80189a:	85 c0                	test   %eax,%eax
  80189c:	78 1a                	js     8018b8 <fd_close+0x77>
		if (dev->dev_close)
  80189e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018a1:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8018a4:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8018a9:	85 c0                	test   %eax,%eax
  8018ab:	74 0b                	je     8018b8 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8018ad:	83 ec 0c             	sub    $0xc,%esp
  8018b0:	56                   	push   %esi
  8018b1:	ff d0                	call   *%eax
  8018b3:	89 c3                	mov    %eax,%ebx
  8018b5:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8018b8:	83 ec 08             	sub    $0x8,%esp
  8018bb:	56                   	push   %esi
  8018bc:	6a 00                	push   $0x0
  8018be:	e8 96 f8 ff ff       	call   801159 <sys_page_unmap>
	return r;
  8018c3:	83 c4 10             	add    $0x10,%esp
  8018c6:	eb b5                	jmp    80187d <fd_close+0x3c>

008018c8 <close>:

int
close(int fdnum)
{
  8018c8:	55                   	push   %ebp
  8018c9:	89 e5                	mov    %esp,%ebp
  8018cb:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018ce:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018d1:	50                   	push   %eax
  8018d2:	ff 75 08             	pushl  0x8(%ebp)
  8018d5:	e8 c1 fe ff ff       	call   80179b <fd_lookup>
  8018da:	83 c4 10             	add    $0x10,%esp
  8018dd:	85 c0                	test   %eax,%eax
  8018df:	79 02                	jns    8018e3 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8018e1:	c9                   	leave  
  8018e2:	c3                   	ret    
		return fd_close(fd, 1);
  8018e3:	83 ec 08             	sub    $0x8,%esp
  8018e6:	6a 01                	push   $0x1
  8018e8:	ff 75 f4             	pushl  -0xc(%ebp)
  8018eb:	e8 51 ff ff ff       	call   801841 <fd_close>
  8018f0:	83 c4 10             	add    $0x10,%esp
  8018f3:	eb ec                	jmp    8018e1 <close+0x19>

008018f5 <close_all>:

void
close_all(void)
{
  8018f5:	55                   	push   %ebp
  8018f6:	89 e5                	mov    %esp,%ebp
  8018f8:	53                   	push   %ebx
  8018f9:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8018fc:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801901:	83 ec 0c             	sub    $0xc,%esp
  801904:	53                   	push   %ebx
  801905:	e8 be ff ff ff       	call   8018c8 <close>
	for (i = 0; i < MAXFD; i++)
  80190a:	83 c3 01             	add    $0x1,%ebx
  80190d:	83 c4 10             	add    $0x10,%esp
  801910:	83 fb 20             	cmp    $0x20,%ebx
  801913:	75 ec                	jne    801901 <close_all+0xc>
}
  801915:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801918:	c9                   	leave  
  801919:	c3                   	ret    

0080191a <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80191a:	55                   	push   %ebp
  80191b:	89 e5                	mov    %esp,%ebp
  80191d:	57                   	push   %edi
  80191e:	56                   	push   %esi
  80191f:	53                   	push   %ebx
  801920:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801923:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801926:	50                   	push   %eax
  801927:	ff 75 08             	pushl  0x8(%ebp)
  80192a:	e8 6c fe ff ff       	call   80179b <fd_lookup>
  80192f:	89 c3                	mov    %eax,%ebx
  801931:	83 c4 10             	add    $0x10,%esp
  801934:	85 c0                	test   %eax,%eax
  801936:	0f 88 81 00 00 00    	js     8019bd <dup+0xa3>
		return r;
	close(newfdnum);
  80193c:	83 ec 0c             	sub    $0xc,%esp
  80193f:	ff 75 0c             	pushl  0xc(%ebp)
  801942:	e8 81 ff ff ff       	call   8018c8 <close>

	newfd = INDEX2FD(newfdnum);
  801947:	8b 75 0c             	mov    0xc(%ebp),%esi
  80194a:	c1 e6 0c             	shl    $0xc,%esi
  80194d:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801953:	83 c4 04             	add    $0x4,%esp
  801956:	ff 75 e4             	pushl  -0x1c(%ebp)
  801959:	e8 d4 fd ff ff       	call   801732 <fd2data>
  80195e:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801960:	89 34 24             	mov    %esi,(%esp)
  801963:	e8 ca fd ff ff       	call   801732 <fd2data>
  801968:	83 c4 10             	add    $0x10,%esp
  80196b:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80196d:	89 d8                	mov    %ebx,%eax
  80196f:	c1 e8 16             	shr    $0x16,%eax
  801972:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801979:	a8 01                	test   $0x1,%al
  80197b:	74 11                	je     80198e <dup+0x74>
  80197d:	89 d8                	mov    %ebx,%eax
  80197f:	c1 e8 0c             	shr    $0xc,%eax
  801982:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801989:	f6 c2 01             	test   $0x1,%dl
  80198c:	75 39                	jne    8019c7 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80198e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801991:	89 d0                	mov    %edx,%eax
  801993:	c1 e8 0c             	shr    $0xc,%eax
  801996:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80199d:	83 ec 0c             	sub    $0xc,%esp
  8019a0:	25 07 0e 00 00       	and    $0xe07,%eax
  8019a5:	50                   	push   %eax
  8019a6:	56                   	push   %esi
  8019a7:	6a 00                	push   $0x0
  8019a9:	52                   	push   %edx
  8019aa:	6a 00                	push   $0x0
  8019ac:	e8 66 f7 ff ff       	call   801117 <sys_page_map>
  8019b1:	89 c3                	mov    %eax,%ebx
  8019b3:	83 c4 20             	add    $0x20,%esp
  8019b6:	85 c0                	test   %eax,%eax
  8019b8:	78 31                	js     8019eb <dup+0xd1>
		goto err;

	return newfdnum;
  8019ba:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8019bd:	89 d8                	mov    %ebx,%eax
  8019bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019c2:	5b                   	pop    %ebx
  8019c3:	5e                   	pop    %esi
  8019c4:	5f                   	pop    %edi
  8019c5:	5d                   	pop    %ebp
  8019c6:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8019c7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8019ce:	83 ec 0c             	sub    $0xc,%esp
  8019d1:	25 07 0e 00 00       	and    $0xe07,%eax
  8019d6:	50                   	push   %eax
  8019d7:	57                   	push   %edi
  8019d8:	6a 00                	push   $0x0
  8019da:	53                   	push   %ebx
  8019db:	6a 00                	push   $0x0
  8019dd:	e8 35 f7 ff ff       	call   801117 <sys_page_map>
  8019e2:	89 c3                	mov    %eax,%ebx
  8019e4:	83 c4 20             	add    $0x20,%esp
  8019e7:	85 c0                	test   %eax,%eax
  8019e9:	79 a3                	jns    80198e <dup+0x74>
	sys_page_unmap(0, newfd);
  8019eb:	83 ec 08             	sub    $0x8,%esp
  8019ee:	56                   	push   %esi
  8019ef:	6a 00                	push   $0x0
  8019f1:	e8 63 f7 ff ff       	call   801159 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8019f6:	83 c4 08             	add    $0x8,%esp
  8019f9:	57                   	push   %edi
  8019fa:	6a 00                	push   $0x0
  8019fc:	e8 58 f7 ff ff       	call   801159 <sys_page_unmap>
	return r;
  801a01:	83 c4 10             	add    $0x10,%esp
  801a04:	eb b7                	jmp    8019bd <dup+0xa3>

00801a06 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801a06:	55                   	push   %ebp
  801a07:	89 e5                	mov    %esp,%ebp
  801a09:	53                   	push   %ebx
  801a0a:	83 ec 1c             	sub    $0x1c,%esp
  801a0d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a10:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a13:	50                   	push   %eax
  801a14:	53                   	push   %ebx
  801a15:	e8 81 fd ff ff       	call   80179b <fd_lookup>
  801a1a:	83 c4 10             	add    $0x10,%esp
  801a1d:	85 c0                	test   %eax,%eax
  801a1f:	78 3f                	js     801a60 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a21:	83 ec 08             	sub    $0x8,%esp
  801a24:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a27:	50                   	push   %eax
  801a28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a2b:	ff 30                	pushl  (%eax)
  801a2d:	e8 b9 fd ff ff       	call   8017eb <dev_lookup>
  801a32:	83 c4 10             	add    $0x10,%esp
  801a35:	85 c0                	test   %eax,%eax
  801a37:	78 27                	js     801a60 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801a39:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a3c:	8b 42 08             	mov    0x8(%edx),%eax
  801a3f:	83 e0 03             	and    $0x3,%eax
  801a42:	83 f8 01             	cmp    $0x1,%eax
  801a45:	74 1e                	je     801a65 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801a47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a4a:	8b 40 08             	mov    0x8(%eax),%eax
  801a4d:	85 c0                	test   %eax,%eax
  801a4f:	74 35                	je     801a86 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801a51:	83 ec 04             	sub    $0x4,%esp
  801a54:	ff 75 10             	pushl  0x10(%ebp)
  801a57:	ff 75 0c             	pushl  0xc(%ebp)
  801a5a:	52                   	push   %edx
  801a5b:	ff d0                	call   *%eax
  801a5d:	83 c4 10             	add    $0x10,%esp
}
  801a60:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a63:	c9                   	leave  
  801a64:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801a65:	a1 04 50 80 00       	mov    0x805004,%eax
  801a6a:	8b 40 48             	mov    0x48(%eax),%eax
  801a6d:	83 ec 04             	sub    $0x4,%esp
  801a70:	53                   	push   %ebx
  801a71:	50                   	push   %eax
  801a72:	68 31 33 80 00       	push   $0x803331
  801a77:	e8 40 eb ff ff       	call   8005bc <cprintf>
		return -E_INVAL;
  801a7c:	83 c4 10             	add    $0x10,%esp
  801a7f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a84:	eb da                	jmp    801a60 <read+0x5a>
		return -E_NOT_SUPP;
  801a86:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a8b:	eb d3                	jmp    801a60 <read+0x5a>

00801a8d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801a8d:	55                   	push   %ebp
  801a8e:	89 e5                	mov    %esp,%ebp
  801a90:	57                   	push   %edi
  801a91:	56                   	push   %esi
  801a92:	53                   	push   %ebx
  801a93:	83 ec 0c             	sub    $0xc,%esp
  801a96:	8b 7d 08             	mov    0x8(%ebp),%edi
  801a99:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801a9c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801aa1:	39 f3                	cmp    %esi,%ebx
  801aa3:	73 23                	jae    801ac8 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801aa5:	83 ec 04             	sub    $0x4,%esp
  801aa8:	89 f0                	mov    %esi,%eax
  801aaa:	29 d8                	sub    %ebx,%eax
  801aac:	50                   	push   %eax
  801aad:	89 d8                	mov    %ebx,%eax
  801aaf:	03 45 0c             	add    0xc(%ebp),%eax
  801ab2:	50                   	push   %eax
  801ab3:	57                   	push   %edi
  801ab4:	e8 4d ff ff ff       	call   801a06 <read>
		if (m < 0)
  801ab9:	83 c4 10             	add    $0x10,%esp
  801abc:	85 c0                	test   %eax,%eax
  801abe:	78 06                	js     801ac6 <readn+0x39>
			return m;
		if (m == 0)
  801ac0:	74 06                	je     801ac8 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801ac2:	01 c3                	add    %eax,%ebx
  801ac4:	eb db                	jmp    801aa1 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801ac6:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801ac8:	89 d8                	mov    %ebx,%eax
  801aca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801acd:	5b                   	pop    %ebx
  801ace:	5e                   	pop    %esi
  801acf:	5f                   	pop    %edi
  801ad0:	5d                   	pop    %ebp
  801ad1:	c3                   	ret    

00801ad2 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801ad2:	55                   	push   %ebp
  801ad3:	89 e5                	mov    %esp,%ebp
  801ad5:	53                   	push   %ebx
  801ad6:	83 ec 1c             	sub    $0x1c,%esp
  801ad9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801adc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801adf:	50                   	push   %eax
  801ae0:	53                   	push   %ebx
  801ae1:	e8 b5 fc ff ff       	call   80179b <fd_lookup>
  801ae6:	83 c4 10             	add    $0x10,%esp
  801ae9:	85 c0                	test   %eax,%eax
  801aeb:	78 3a                	js     801b27 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801aed:	83 ec 08             	sub    $0x8,%esp
  801af0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801af3:	50                   	push   %eax
  801af4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801af7:	ff 30                	pushl  (%eax)
  801af9:	e8 ed fc ff ff       	call   8017eb <dev_lookup>
  801afe:	83 c4 10             	add    $0x10,%esp
  801b01:	85 c0                	test   %eax,%eax
  801b03:	78 22                	js     801b27 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b08:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801b0c:	74 1e                	je     801b2c <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801b0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b11:	8b 52 0c             	mov    0xc(%edx),%edx
  801b14:	85 d2                	test   %edx,%edx
  801b16:	74 35                	je     801b4d <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801b18:	83 ec 04             	sub    $0x4,%esp
  801b1b:	ff 75 10             	pushl  0x10(%ebp)
  801b1e:	ff 75 0c             	pushl  0xc(%ebp)
  801b21:	50                   	push   %eax
  801b22:	ff d2                	call   *%edx
  801b24:	83 c4 10             	add    $0x10,%esp
}
  801b27:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b2a:	c9                   	leave  
  801b2b:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801b2c:	a1 04 50 80 00       	mov    0x805004,%eax
  801b31:	8b 40 48             	mov    0x48(%eax),%eax
  801b34:	83 ec 04             	sub    $0x4,%esp
  801b37:	53                   	push   %ebx
  801b38:	50                   	push   %eax
  801b39:	68 4d 33 80 00       	push   $0x80334d
  801b3e:	e8 79 ea ff ff       	call   8005bc <cprintf>
		return -E_INVAL;
  801b43:	83 c4 10             	add    $0x10,%esp
  801b46:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b4b:	eb da                	jmp    801b27 <write+0x55>
		return -E_NOT_SUPP;
  801b4d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b52:	eb d3                	jmp    801b27 <write+0x55>

00801b54 <seek>:

int
seek(int fdnum, off_t offset)
{
  801b54:	55                   	push   %ebp
  801b55:	89 e5                	mov    %esp,%ebp
  801b57:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b5a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b5d:	50                   	push   %eax
  801b5e:	ff 75 08             	pushl  0x8(%ebp)
  801b61:	e8 35 fc ff ff       	call   80179b <fd_lookup>
  801b66:	83 c4 10             	add    $0x10,%esp
  801b69:	85 c0                	test   %eax,%eax
  801b6b:	78 0e                	js     801b7b <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801b6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b73:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801b76:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b7b:	c9                   	leave  
  801b7c:	c3                   	ret    

00801b7d <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801b7d:	55                   	push   %ebp
  801b7e:	89 e5                	mov    %esp,%ebp
  801b80:	53                   	push   %ebx
  801b81:	83 ec 1c             	sub    $0x1c,%esp
  801b84:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b87:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b8a:	50                   	push   %eax
  801b8b:	53                   	push   %ebx
  801b8c:	e8 0a fc ff ff       	call   80179b <fd_lookup>
  801b91:	83 c4 10             	add    $0x10,%esp
  801b94:	85 c0                	test   %eax,%eax
  801b96:	78 37                	js     801bcf <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b98:	83 ec 08             	sub    $0x8,%esp
  801b9b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b9e:	50                   	push   %eax
  801b9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ba2:	ff 30                	pushl  (%eax)
  801ba4:	e8 42 fc ff ff       	call   8017eb <dev_lookup>
  801ba9:	83 c4 10             	add    $0x10,%esp
  801bac:	85 c0                	test   %eax,%eax
  801bae:	78 1f                	js     801bcf <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801bb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bb3:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801bb7:	74 1b                	je     801bd4 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801bb9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bbc:	8b 52 18             	mov    0x18(%edx),%edx
  801bbf:	85 d2                	test   %edx,%edx
  801bc1:	74 32                	je     801bf5 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801bc3:	83 ec 08             	sub    $0x8,%esp
  801bc6:	ff 75 0c             	pushl  0xc(%ebp)
  801bc9:	50                   	push   %eax
  801bca:	ff d2                	call   *%edx
  801bcc:	83 c4 10             	add    $0x10,%esp
}
  801bcf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bd2:	c9                   	leave  
  801bd3:	c3                   	ret    
			thisenv->env_id, fdnum);
  801bd4:	a1 04 50 80 00       	mov    0x805004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801bd9:	8b 40 48             	mov    0x48(%eax),%eax
  801bdc:	83 ec 04             	sub    $0x4,%esp
  801bdf:	53                   	push   %ebx
  801be0:	50                   	push   %eax
  801be1:	68 10 33 80 00       	push   $0x803310
  801be6:	e8 d1 e9 ff ff       	call   8005bc <cprintf>
		return -E_INVAL;
  801beb:	83 c4 10             	add    $0x10,%esp
  801bee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801bf3:	eb da                	jmp    801bcf <ftruncate+0x52>
		return -E_NOT_SUPP;
  801bf5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801bfa:	eb d3                	jmp    801bcf <ftruncate+0x52>

00801bfc <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801bfc:	55                   	push   %ebp
  801bfd:	89 e5                	mov    %esp,%ebp
  801bff:	53                   	push   %ebx
  801c00:	83 ec 1c             	sub    $0x1c,%esp
  801c03:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c06:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c09:	50                   	push   %eax
  801c0a:	ff 75 08             	pushl  0x8(%ebp)
  801c0d:	e8 89 fb ff ff       	call   80179b <fd_lookup>
  801c12:	83 c4 10             	add    $0x10,%esp
  801c15:	85 c0                	test   %eax,%eax
  801c17:	78 4b                	js     801c64 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c19:	83 ec 08             	sub    $0x8,%esp
  801c1c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c1f:	50                   	push   %eax
  801c20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c23:	ff 30                	pushl  (%eax)
  801c25:	e8 c1 fb ff ff       	call   8017eb <dev_lookup>
  801c2a:	83 c4 10             	add    $0x10,%esp
  801c2d:	85 c0                	test   %eax,%eax
  801c2f:	78 33                	js     801c64 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801c31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c34:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801c38:	74 2f                	je     801c69 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801c3a:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801c3d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801c44:	00 00 00 
	stat->st_isdir = 0;
  801c47:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c4e:	00 00 00 
	stat->st_dev = dev;
  801c51:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801c57:	83 ec 08             	sub    $0x8,%esp
  801c5a:	53                   	push   %ebx
  801c5b:	ff 75 f0             	pushl  -0x10(%ebp)
  801c5e:	ff 50 14             	call   *0x14(%eax)
  801c61:	83 c4 10             	add    $0x10,%esp
}
  801c64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c67:	c9                   	leave  
  801c68:	c3                   	ret    
		return -E_NOT_SUPP;
  801c69:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c6e:	eb f4                	jmp    801c64 <fstat+0x68>

00801c70 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801c70:	55                   	push   %ebp
  801c71:	89 e5                	mov    %esp,%ebp
  801c73:	56                   	push   %esi
  801c74:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801c75:	83 ec 08             	sub    $0x8,%esp
  801c78:	6a 00                	push   $0x0
  801c7a:	ff 75 08             	pushl  0x8(%ebp)
  801c7d:	e8 bb 01 00 00       	call   801e3d <open>
  801c82:	89 c3                	mov    %eax,%ebx
  801c84:	83 c4 10             	add    $0x10,%esp
  801c87:	85 c0                	test   %eax,%eax
  801c89:	78 1b                	js     801ca6 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801c8b:	83 ec 08             	sub    $0x8,%esp
  801c8e:	ff 75 0c             	pushl  0xc(%ebp)
  801c91:	50                   	push   %eax
  801c92:	e8 65 ff ff ff       	call   801bfc <fstat>
  801c97:	89 c6                	mov    %eax,%esi
	close(fd);
  801c99:	89 1c 24             	mov    %ebx,(%esp)
  801c9c:	e8 27 fc ff ff       	call   8018c8 <close>
	return r;
  801ca1:	83 c4 10             	add    $0x10,%esp
  801ca4:	89 f3                	mov    %esi,%ebx
}
  801ca6:	89 d8                	mov    %ebx,%eax
  801ca8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cab:	5b                   	pop    %ebx
  801cac:	5e                   	pop    %esi
  801cad:	5d                   	pop    %ebp
  801cae:	c3                   	ret    

00801caf <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801caf:	55                   	push   %ebp
  801cb0:	89 e5                	mov    %esp,%ebp
  801cb2:	56                   	push   %esi
  801cb3:	53                   	push   %ebx
  801cb4:	89 c6                	mov    %eax,%esi
  801cb6:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801cb8:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801cbf:	74 27                	je     801ce8 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801cc1:	6a 07                	push   $0x7
  801cc3:	68 00 60 80 00       	push   $0x806000
  801cc8:	56                   	push   %esi
  801cc9:	ff 35 00 50 80 00    	pushl  0x805000
  801ccf:	e8 08 0c 00 00       	call   8028dc <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801cd4:	83 c4 0c             	add    $0xc,%esp
  801cd7:	6a 00                	push   $0x0
  801cd9:	53                   	push   %ebx
  801cda:	6a 00                	push   $0x0
  801cdc:	e8 92 0b 00 00       	call   802873 <ipc_recv>
}
  801ce1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ce4:	5b                   	pop    %ebx
  801ce5:	5e                   	pop    %esi
  801ce6:	5d                   	pop    %ebp
  801ce7:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801ce8:	83 ec 0c             	sub    $0xc,%esp
  801ceb:	6a 01                	push   $0x1
  801ced:	e8 37 0c 00 00       	call   802929 <ipc_find_env>
  801cf2:	a3 00 50 80 00       	mov    %eax,0x805000
  801cf7:	83 c4 10             	add    $0x10,%esp
  801cfa:	eb c5                	jmp    801cc1 <fsipc+0x12>

00801cfc <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801cfc:	55                   	push   %ebp
  801cfd:	89 e5                	mov    %esp,%ebp
  801cff:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801d02:	8b 45 08             	mov    0x8(%ebp),%eax
  801d05:	8b 40 0c             	mov    0xc(%eax),%eax
  801d08:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801d0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d10:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801d15:	ba 00 00 00 00       	mov    $0x0,%edx
  801d1a:	b8 02 00 00 00       	mov    $0x2,%eax
  801d1f:	e8 8b ff ff ff       	call   801caf <fsipc>
}
  801d24:	c9                   	leave  
  801d25:	c3                   	ret    

00801d26 <devfile_flush>:
{
  801d26:	55                   	push   %ebp
  801d27:	89 e5                	mov    %esp,%ebp
  801d29:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2f:	8b 40 0c             	mov    0xc(%eax),%eax
  801d32:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801d37:	ba 00 00 00 00       	mov    $0x0,%edx
  801d3c:	b8 06 00 00 00       	mov    $0x6,%eax
  801d41:	e8 69 ff ff ff       	call   801caf <fsipc>
}
  801d46:	c9                   	leave  
  801d47:	c3                   	ret    

00801d48 <devfile_stat>:
{
  801d48:	55                   	push   %ebp
  801d49:	89 e5                	mov    %esp,%ebp
  801d4b:	53                   	push   %ebx
  801d4c:	83 ec 04             	sub    $0x4,%esp
  801d4f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801d52:	8b 45 08             	mov    0x8(%ebp),%eax
  801d55:	8b 40 0c             	mov    0xc(%eax),%eax
  801d58:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801d5d:	ba 00 00 00 00       	mov    $0x0,%edx
  801d62:	b8 05 00 00 00       	mov    $0x5,%eax
  801d67:	e8 43 ff ff ff       	call   801caf <fsipc>
  801d6c:	85 c0                	test   %eax,%eax
  801d6e:	78 2c                	js     801d9c <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801d70:	83 ec 08             	sub    $0x8,%esp
  801d73:	68 00 60 80 00       	push   $0x806000
  801d78:	53                   	push   %ebx
  801d79:	e8 64 ef ff ff       	call   800ce2 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801d7e:	a1 80 60 80 00       	mov    0x806080,%eax
  801d83:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801d89:	a1 84 60 80 00       	mov    0x806084,%eax
  801d8e:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801d94:	83 c4 10             	add    $0x10,%esp
  801d97:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d9c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d9f:	c9                   	leave  
  801da0:	c3                   	ret    

00801da1 <devfile_write>:
{
  801da1:	55                   	push   %ebp
  801da2:	89 e5                	mov    %esp,%ebp
  801da4:	83 ec 0c             	sub    $0xc,%esp
	panic("devfile_write not implemented");
  801da7:	68 7c 33 80 00       	push   $0x80337c
  801dac:	68 90 00 00 00       	push   $0x90
  801db1:	68 9a 33 80 00       	push   $0x80339a
  801db6:	e8 26 e7 ff ff       	call   8004e1 <_panic>

00801dbb <devfile_read>:
{
  801dbb:	55                   	push   %ebp
  801dbc:	89 e5                	mov    %esp,%ebp
  801dbe:	56                   	push   %esi
  801dbf:	53                   	push   %ebx
  801dc0:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc6:	8b 40 0c             	mov    0xc(%eax),%eax
  801dc9:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801dce:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801dd4:	ba 00 00 00 00       	mov    $0x0,%edx
  801dd9:	b8 03 00 00 00       	mov    $0x3,%eax
  801dde:	e8 cc fe ff ff       	call   801caf <fsipc>
  801de3:	89 c3                	mov    %eax,%ebx
  801de5:	85 c0                	test   %eax,%eax
  801de7:	78 1f                	js     801e08 <devfile_read+0x4d>
	assert(r <= n);
  801de9:	39 f0                	cmp    %esi,%eax
  801deb:	77 24                	ja     801e11 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801ded:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801df2:	7f 33                	jg     801e27 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801df4:	83 ec 04             	sub    $0x4,%esp
  801df7:	50                   	push   %eax
  801df8:	68 00 60 80 00       	push   $0x806000
  801dfd:	ff 75 0c             	pushl  0xc(%ebp)
  801e00:	e8 6b f0 ff ff       	call   800e70 <memmove>
	return r;
  801e05:	83 c4 10             	add    $0x10,%esp
}
  801e08:	89 d8                	mov    %ebx,%eax
  801e0a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e0d:	5b                   	pop    %ebx
  801e0e:	5e                   	pop    %esi
  801e0f:	5d                   	pop    %ebp
  801e10:	c3                   	ret    
	assert(r <= n);
  801e11:	68 a5 33 80 00       	push   $0x8033a5
  801e16:	68 ac 33 80 00       	push   $0x8033ac
  801e1b:	6a 7c                	push   $0x7c
  801e1d:	68 9a 33 80 00       	push   $0x80339a
  801e22:	e8 ba e6 ff ff       	call   8004e1 <_panic>
	assert(r <= PGSIZE);
  801e27:	68 c1 33 80 00       	push   $0x8033c1
  801e2c:	68 ac 33 80 00       	push   $0x8033ac
  801e31:	6a 7d                	push   $0x7d
  801e33:	68 9a 33 80 00       	push   $0x80339a
  801e38:	e8 a4 e6 ff ff       	call   8004e1 <_panic>

00801e3d <open>:
{
  801e3d:	55                   	push   %ebp
  801e3e:	89 e5                	mov    %esp,%ebp
  801e40:	56                   	push   %esi
  801e41:	53                   	push   %ebx
  801e42:	83 ec 1c             	sub    $0x1c,%esp
  801e45:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801e48:	56                   	push   %esi
  801e49:	e8 5b ee ff ff       	call   800ca9 <strlen>
  801e4e:	83 c4 10             	add    $0x10,%esp
  801e51:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801e56:	7f 6c                	jg     801ec4 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801e58:	83 ec 0c             	sub    $0xc,%esp
  801e5b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e5e:	50                   	push   %eax
  801e5f:	e8 e5 f8 ff ff       	call   801749 <fd_alloc>
  801e64:	89 c3                	mov    %eax,%ebx
  801e66:	83 c4 10             	add    $0x10,%esp
  801e69:	85 c0                	test   %eax,%eax
  801e6b:	78 3c                	js     801ea9 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801e6d:	83 ec 08             	sub    $0x8,%esp
  801e70:	56                   	push   %esi
  801e71:	68 00 60 80 00       	push   $0x806000
  801e76:	e8 67 ee ff ff       	call   800ce2 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801e7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e7e:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801e83:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e86:	b8 01 00 00 00       	mov    $0x1,%eax
  801e8b:	e8 1f fe ff ff       	call   801caf <fsipc>
  801e90:	89 c3                	mov    %eax,%ebx
  801e92:	83 c4 10             	add    $0x10,%esp
  801e95:	85 c0                	test   %eax,%eax
  801e97:	78 19                	js     801eb2 <open+0x75>
	return fd2num(fd);
  801e99:	83 ec 0c             	sub    $0xc,%esp
  801e9c:	ff 75 f4             	pushl  -0xc(%ebp)
  801e9f:	e8 7e f8 ff ff       	call   801722 <fd2num>
  801ea4:	89 c3                	mov    %eax,%ebx
  801ea6:	83 c4 10             	add    $0x10,%esp
}
  801ea9:	89 d8                	mov    %ebx,%eax
  801eab:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801eae:	5b                   	pop    %ebx
  801eaf:	5e                   	pop    %esi
  801eb0:	5d                   	pop    %ebp
  801eb1:	c3                   	ret    
		fd_close(fd, 0);
  801eb2:	83 ec 08             	sub    $0x8,%esp
  801eb5:	6a 00                	push   $0x0
  801eb7:	ff 75 f4             	pushl  -0xc(%ebp)
  801eba:	e8 82 f9 ff ff       	call   801841 <fd_close>
		return r;
  801ebf:	83 c4 10             	add    $0x10,%esp
  801ec2:	eb e5                	jmp    801ea9 <open+0x6c>
		return -E_BAD_PATH;
  801ec4:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801ec9:	eb de                	jmp    801ea9 <open+0x6c>

00801ecb <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801ecb:	55                   	push   %ebp
  801ecc:	89 e5                	mov    %esp,%ebp
  801ece:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801ed1:	ba 00 00 00 00       	mov    $0x0,%edx
  801ed6:	b8 08 00 00 00       	mov    $0x8,%eax
  801edb:	e8 cf fd ff ff       	call   801caf <fsipc>
}
  801ee0:	c9                   	leave  
  801ee1:	c3                   	ret    

00801ee2 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801ee2:	55                   	push   %ebp
  801ee3:	89 e5                	mov    %esp,%ebp
  801ee5:	57                   	push   %edi
  801ee6:	56                   	push   %esi
  801ee7:	53                   	push   %ebx
  801ee8:	81 ec 94 02 00 00    	sub    $0x294,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801eee:	6a 00                	push   $0x0
  801ef0:	ff 75 08             	pushl  0x8(%ebp)
  801ef3:	e8 45 ff ff ff       	call   801e3d <open>
  801ef8:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801efe:	83 c4 10             	add    $0x10,%esp
  801f01:	85 c0                	test   %eax,%eax
  801f03:	0f 88 72 04 00 00    	js     80237b <spawn+0x499>
  801f09:	89 c2                	mov    %eax,%edx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801f0b:	83 ec 04             	sub    $0x4,%esp
  801f0e:	68 00 02 00 00       	push   $0x200
  801f13:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801f19:	50                   	push   %eax
  801f1a:	52                   	push   %edx
  801f1b:	e8 6d fb ff ff       	call   801a8d <readn>
  801f20:	83 c4 10             	add    $0x10,%esp
  801f23:	3d 00 02 00 00       	cmp    $0x200,%eax
  801f28:	75 60                	jne    801f8a <spawn+0xa8>
	    || elf->e_magic != ELF_MAGIC) {
  801f2a:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801f31:	45 4c 46 
  801f34:	75 54                	jne    801f8a <spawn+0xa8>
  801f36:	b8 07 00 00 00       	mov    $0x7,%eax
  801f3b:	cd 30                	int    $0x30
  801f3d:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  801f43:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801f49:	85 c0                	test   %eax,%eax
  801f4b:	0f 88 1e 04 00 00    	js     80236f <spawn+0x48d>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801f51:	25 ff 03 00 00       	and    $0x3ff,%eax
  801f56:	69 f0 84 00 00 00    	imul   $0x84,%eax,%esi
  801f5c:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801f62:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801f68:	b9 11 00 00 00       	mov    $0x11,%ecx
  801f6d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801f6f:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801f75:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801f7b:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  801f80:	be 00 00 00 00       	mov    $0x0,%esi
  801f85:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801f88:	eb 4b                	jmp    801fd5 <spawn+0xf3>
		close(fd);
  801f8a:	83 ec 0c             	sub    $0xc,%esp
  801f8d:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801f93:	e8 30 f9 ff ff       	call   8018c8 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801f98:	83 c4 0c             	add    $0xc,%esp
  801f9b:	68 7f 45 4c 46       	push   $0x464c457f
  801fa0:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  801fa6:	68 cd 33 80 00       	push   $0x8033cd
  801fab:	e8 0c e6 ff ff       	call   8005bc <cprintf>
		return -E_NOT_EXEC;
  801fb0:	83 c4 10             	add    $0x10,%esp
  801fb3:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  801fba:	ff ff ff 
  801fbd:	e9 b9 03 00 00       	jmp    80237b <spawn+0x499>
		string_size += strlen(argv[argc]) + 1;
  801fc2:	83 ec 0c             	sub    $0xc,%esp
  801fc5:	50                   	push   %eax
  801fc6:	e8 de ec ff ff       	call   800ca9 <strlen>
  801fcb:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  801fcf:	83 c3 01             	add    $0x1,%ebx
  801fd2:	83 c4 10             	add    $0x10,%esp
  801fd5:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  801fdc:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801fdf:	85 c0                	test   %eax,%eax
  801fe1:	75 df                	jne    801fc2 <spawn+0xe0>
  801fe3:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  801fe9:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801fef:	bf 00 10 40 00       	mov    $0x401000,%edi
  801ff4:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801ff6:	89 fa                	mov    %edi,%edx
  801ff8:	83 e2 fc             	and    $0xfffffffc,%edx
  801ffb:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  802002:	29 c2                	sub    %eax,%edx
  802004:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  80200a:	8d 42 f8             	lea    -0x8(%edx),%eax
  80200d:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  802012:	0f 86 86 03 00 00    	jbe    80239e <spawn+0x4bc>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802018:	83 ec 04             	sub    $0x4,%esp
  80201b:	6a 07                	push   $0x7
  80201d:	68 00 00 40 00       	push   $0x400000
  802022:	6a 00                	push   $0x0
  802024:	e8 ab f0 ff ff       	call   8010d4 <sys_page_alloc>
  802029:	83 c4 10             	add    $0x10,%esp
  80202c:	85 c0                	test   %eax,%eax
  80202e:	0f 88 6f 03 00 00    	js     8023a3 <spawn+0x4c1>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  802034:	be 00 00 00 00       	mov    $0x0,%esi
  802039:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  80203f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  802042:	eb 30                	jmp    802074 <spawn+0x192>
		argv_store[i] = UTEMP2USTACK(string_store);
  802044:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  80204a:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  802050:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  802053:	83 ec 08             	sub    $0x8,%esp
  802056:	ff 34 b3             	pushl  (%ebx,%esi,4)
  802059:	57                   	push   %edi
  80205a:	e8 83 ec ff ff       	call   800ce2 <strcpy>
		string_store += strlen(argv[i]) + 1;
  80205f:	83 c4 04             	add    $0x4,%esp
  802062:	ff 34 b3             	pushl  (%ebx,%esi,4)
  802065:	e8 3f ec ff ff       	call   800ca9 <strlen>
  80206a:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  80206e:	83 c6 01             	add    $0x1,%esi
  802071:	83 c4 10             	add    $0x10,%esp
  802074:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  80207a:	7f c8                	jg     802044 <spawn+0x162>
	}
	argv_store[argc] = 0;
  80207c:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802082:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  802088:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  80208f:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  802095:	0f 85 86 00 00 00    	jne    802121 <spawn+0x23f>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  80209b:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  8020a1:	8d 81 00 d0 7f ee    	lea    -0x11803000(%ecx),%eax
  8020a7:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  8020aa:	89 c8                	mov    %ecx,%eax
  8020ac:	8b 8d 84 fd ff ff    	mov    -0x27c(%ebp),%ecx
  8020b2:	89 48 f8             	mov    %ecx,-0x8(%eax)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  8020b5:	2d 08 30 80 11       	sub    $0x11803008,%eax
  8020ba:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8020c0:	83 ec 0c             	sub    $0xc,%esp
  8020c3:	6a 07                	push   $0x7
  8020c5:	68 00 d0 bf ee       	push   $0xeebfd000
  8020ca:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8020d0:	68 00 00 40 00       	push   $0x400000
  8020d5:	6a 00                	push   $0x0
  8020d7:	e8 3b f0 ff ff       	call   801117 <sys_page_map>
  8020dc:	89 c3                	mov    %eax,%ebx
  8020de:	83 c4 20             	add    $0x20,%esp
  8020e1:	85 c0                	test   %eax,%eax
  8020e3:	0f 88 c2 02 00 00    	js     8023ab <spawn+0x4c9>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8020e9:	83 ec 08             	sub    $0x8,%esp
  8020ec:	68 00 00 40 00       	push   $0x400000
  8020f1:	6a 00                	push   $0x0
  8020f3:	e8 61 f0 ff ff       	call   801159 <sys_page_unmap>
  8020f8:	89 c3                	mov    %eax,%ebx
  8020fa:	83 c4 10             	add    $0x10,%esp
  8020fd:	85 c0                	test   %eax,%eax
  8020ff:	0f 88 a6 02 00 00    	js     8023ab <spawn+0x4c9>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  802105:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  80210b:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802112:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  802119:	00 00 00 
  80211c:	e9 4f 01 00 00       	jmp    802270 <spawn+0x38e>
	assert(string_store == (char*)UTEMP + PGSIZE);
  802121:	68 44 34 80 00       	push   $0x803444
  802126:	68 ac 33 80 00       	push   $0x8033ac
  80212b:	68 f2 00 00 00       	push   $0xf2
  802130:	68 e7 33 80 00       	push   $0x8033e7
  802135:	e8 a7 e3 ff ff       	call   8004e1 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80213a:	83 ec 04             	sub    $0x4,%esp
  80213d:	6a 07                	push   $0x7
  80213f:	68 00 00 40 00       	push   $0x400000
  802144:	6a 00                	push   $0x0
  802146:	e8 89 ef ff ff       	call   8010d4 <sys_page_alloc>
  80214b:	83 c4 10             	add    $0x10,%esp
  80214e:	85 c0                	test   %eax,%eax
  802150:	0f 88 33 02 00 00    	js     802389 <spawn+0x4a7>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  802156:	83 ec 08             	sub    $0x8,%esp
  802159:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  80215f:	01 f0                	add    %esi,%eax
  802161:	50                   	push   %eax
  802162:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802168:	e8 e7 f9 ff ff       	call   801b54 <seek>
  80216d:	83 c4 10             	add    $0x10,%esp
  802170:	85 c0                	test   %eax,%eax
  802172:	0f 88 18 02 00 00    	js     802390 <spawn+0x4ae>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  802178:	83 ec 04             	sub    $0x4,%esp
  80217b:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802181:	29 f0                	sub    %esi,%eax
  802183:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802188:	ba 00 10 00 00       	mov    $0x1000,%edx
  80218d:	0f 47 c2             	cmova  %edx,%eax
  802190:	50                   	push   %eax
  802191:	68 00 00 40 00       	push   $0x400000
  802196:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  80219c:	e8 ec f8 ff ff       	call   801a8d <readn>
  8021a1:	83 c4 10             	add    $0x10,%esp
  8021a4:	85 c0                	test   %eax,%eax
  8021a6:	0f 88 eb 01 00 00    	js     802397 <spawn+0x4b5>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  8021ac:	83 ec 0c             	sub    $0xc,%esp
  8021af:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  8021b5:	53                   	push   %ebx
  8021b6:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  8021bc:	68 00 00 40 00       	push   $0x400000
  8021c1:	6a 00                	push   $0x0
  8021c3:	e8 4f ef ff ff       	call   801117 <sys_page_map>
  8021c8:	83 c4 20             	add    $0x20,%esp
  8021cb:	85 c0                	test   %eax,%eax
  8021cd:	78 7c                	js     80224b <spawn+0x369>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  8021cf:	83 ec 08             	sub    $0x8,%esp
  8021d2:	68 00 00 40 00       	push   $0x400000
  8021d7:	6a 00                	push   $0x0
  8021d9:	e8 7b ef ff ff       	call   801159 <sys_page_unmap>
  8021de:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  8021e1:	81 c7 00 10 00 00    	add    $0x1000,%edi
  8021e7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8021ed:	89 fe                	mov    %edi,%esi
  8021ef:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  8021f5:	76 69                	jbe    802260 <spawn+0x37e>
		if (i >= filesz) {
  8021f7:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  8021fd:	0f 87 37 ff ff ff    	ja     80213a <spawn+0x258>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  802203:	83 ec 04             	sub    $0x4,%esp
  802206:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  80220c:	53                   	push   %ebx
  80220d:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  802213:	e8 bc ee ff ff       	call   8010d4 <sys_page_alloc>
  802218:	83 c4 10             	add    $0x10,%esp
  80221b:	85 c0                	test   %eax,%eax
  80221d:	79 c2                	jns    8021e1 <spawn+0x2ff>
  80221f:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  802221:	83 ec 0c             	sub    $0xc,%esp
  802224:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  80222a:	e8 26 ee ff ff       	call   801055 <sys_env_destroy>
	close(fd);
  80222f:	83 c4 04             	add    $0x4,%esp
  802232:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802238:	e8 8b f6 ff ff       	call   8018c8 <close>
	return r;
  80223d:	83 c4 10             	add    $0x10,%esp
  802240:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  802246:	e9 30 01 00 00       	jmp    80237b <spawn+0x499>
				panic("spawn: sys_page_map data: %e", r);
  80224b:	50                   	push   %eax
  80224c:	68 f3 33 80 00       	push   $0x8033f3
  802251:	68 25 01 00 00       	push   $0x125
  802256:	68 e7 33 80 00       	push   $0x8033e7
  80225b:	e8 81 e2 ff ff       	call   8004e1 <_panic>
  802260:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802266:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  80226d:	83 c6 20             	add    $0x20,%esi
  802270:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  802277:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  80227d:	7e 6d                	jle    8022ec <spawn+0x40a>
		if (ph->p_type != ELF_PROG_LOAD)
  80227f:	83 3e 01             	cmpl   $0x1,(%esi)
  802282:	75 e2                	jne    802266 <spawn+0x384>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802284:	8b 46 18             	mov    0x18(%esi),%eax
  802287:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  80228a:	83 f8 01             	cmp    $0x1,%eax
  80228d:	19 c0                	sbb    %eax,%eax
  80228f:	83 e0 fe             	and    $0xfffffffe,%eax
  802292:	83 c0 07             	add    $0x7,%eax
  802295:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  80229b:	8b 4e 04             	mov    0x4(%esi),%ecx
  80229e:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  8022a4:	8b 56 10             	mov    0x10(%esi),%edx
  8022a7:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  8022ad:	8b 7e 14             	mov    0x14(%esi),%edi
  8022b0:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  8022b6:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  8022b9:	89 d8                	mov    %ebx,%eax
  8022bb:	25 ff 0f 00 00       	and    $0xfff,%eax
  8022c0:	74 1a                	je     8022dc <spawn+0x3fa>
		va -= i;
  8022c2:	29 c3                	sub    %eax,%ebx
		memsz += i;
  8022c4:	01 c7                	add    %eax,%edi
  8022c6:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  8022cc:	01 c2                	add    %eax,%edx
  8022ce:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  8022d4:	29 c1                	sub    %eax,%ecx
  8022d6:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  8022dc:	bf 00 00 00 00       	mov    $0x0,%edi
  8022e1:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  8022e7:	e9 01 ff ff ff       	jmp    8021ed <spawn+0x30b>
	close(fd);
  8022ec:	83 ec 0c             	sub    $0xc,%esp
  8022ef:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8022f5:	e8 ce f5 ff ff       	call   8018c8 <close>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  8022fa:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  802301:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  802304:	83 c4 08             	add    $0x8,%esp
  802307:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  80230d:	50                   	push   %eax
  80230e:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802314:	e8 c4 ee ff ff       	call   8011dd <sys_env_set_trapframe>
  802319:	83 c4 10             	add    $0x10,%esp
  80231c:	85 c0                	test   %eax,%eax
  80231e:	78 25                	js     802345 <spawn+0x463>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802320:	83 ec 08             	sub    $0x8,%esp
  802323:	6a 02                	push   $0x2
  802325:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  80232b:	e8 6b ee ff ff       	call   80119b <sys_env_set_status>
  802330:	83 c4 10             	add    $0x10,%esp
  802333:	85 c0                	test   %eax,%eax
  802335:	78 23                	js     80235a <spawn+0x478>
	return child;
  802337:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  80233d:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  802343:	eb 36                	jmp    80237b <spawn+0x499>
		panic("sys_env_set_trapframe: %e", r);
  802345:	50                   	push   %eax
  802346:	68 10 34 80 00       	push   $0x803410
  80234b:	68 86 00 00 00       	push   $0x86
  802350:	68 e7 33 80 00       	push   $0x8033e7
  802355:	e8 87 e1 ff ff       	call   8004e1 <_panic>
		panic("sys_env_set_status: %e", r);
  80235a:	50                   	push   %eax
  80235b:	68 2a 34 80 00       	push   $0x80342a
  802360:	68 89 00 00 00       	push   $0x89
  802365:	68 e7 33 80 00       	push   $0x8033e7
  80236a:	e8 72 e1 ff ff       	call   8004e1 <_panic>
		return r;
  80236f:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802375:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  80237b:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  802381:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802384:	5b                   	pop    %ebx
  802385:	5e                   	pop    %esi
  802386:	5f                   	pop    %edi
  802387:	5d                   	pop    %ebp
  802388:	c3                   	ret    
  802389:	89 c7                	mov    %eax,%edi
  80238b:	e9 91 fe ff ff       	jmp    802221 <spawn+0x33f>
  802390:	89 c7                	mov    %eax,%edi
  802392:	e9 8a fe ff ff       	jmp    802221 <spawn+0x33f>
  802397:	89 c7                	mov    %eax,%edi
  802399:	e9 83 fe ff ff       	jmp    802221 <spawn+0x33f>
		return -E_NO_MEM;
  80239e:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8023a3:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  8023a9:	eb d0                	jmp    80237b <spawn+0x499>
	sys_page_unmap(0, UTEMP);
  8023ab:	83 ec 08             	sub    $0x8,%esp
  8023ae:	68 00 00 40 00       	push   $0x400000
  8023b3:	6a 00                	push   $0x0
  8023b5:	e8 9f ed ff ff       	call   801159 <sys_page_unmap>
  8023ba:	83 c4 10             	add    $0x10,%esp
  8023bd:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  8023c3:	eb b6                	jmp    80237b <spawn+0x499>

008023c5 <spawnl>:
{
  8023c5:	55                   	push   %ebp
  8023c6:	89 e5                	mov    %esp,%ebp
  8023c8:	57                   	push   %edi
  8023c9:	56                   	push   %esi
  8023ca:	53                   	push   %ebx
  8023cb:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  8023ce:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  8023d1:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  8023d6:	8d 4a 04             	lea    0x4(%edx),%ecx
  8023d9:	83 3a 00             	cmpl   $0x0,(%edx)
  8023dc:	74 07                	je     8023e5 <spawnl+0x20>
		argc++;
  8023de:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  8023e1:	89 ca                	mov    %ecx,%edx
  8023e3:	eb f1                	jmp    8023d6 <spawnl+0x11>
	const char *argv[argc+2];
  8023e5:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  8023ec:	83 e2 f0             	and    $0xfffffff0,%edx
  8023ef:	29 d4                	sub    %edx,%esp
  8023f1:	8d 54 24 03          	lea    0x3(%esp),%edx
  8023f5:	c1 ea 02             	shr    $0x2,%edx
  8023f8:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  8023ff:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  802401:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802404:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  80240b:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  802412:	00 
	va_start(vl, arg0);
  802413:	8d 4d 10             	lea    0x10(%ebp),%ecx
  802416:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  802418:	b8 00 00 00 00       	mov    $0x0,%eax
  80241d:	eb 0b                	jmp    80242a <spawnl+0x65>
		argv[i+1] = va_arg(vl, const char *);
  80241f:	83 c0 01             	add    $0x1,%eax
  802422:	8b 39                	mov    (%ecx),%edi
  802424:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  802427:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  80242a:	39 d0                	cmp    %edx,%eax
  80242c:	75 f1                	jne    80241f <spawnl+0x5a>
	return spawn(prog, argv);
  80242e:	83 ec 08             	sub    $0x8,%esp
  802431:	56                   	push   %esi
  802432:	ff 75 08             	pushl  0x8(%ebp)
  802435:	e8 a8 fa ff ff       	call   801ee2 <spawn>
}
  80243a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80243d:	5b                   	pop    %ebx
  80243e:	5e                   	pop    %esi
  80243f:	5f                   	pop    %edi
  802440:	5d                   	pop    %ebp
  802441:	c3                   	ret    

00802442 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802442:	55                   	push   %ebp
  802443:	89 e5                	mov    %esp,%ebp
  802445:	56                   	push   %esi
  802446:	53                   	push   %ebx
  802447:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80244a:	83 ec 0c             	sub    $0xc,%esp
  80244d:	ff 75 08             	pushl  0x8(%ebp)
  802450:	e8 dd f2 ff ff       	call   801732 <fd2data>
  802455:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802457:	83 c4 08             	add    $0x8,%esp
  80245a:	68 6a 34 80 00       	push   $0x80346a
  80245f:	53                   	push   %ebx
  802460:	e8 7d e8 ff ff       	call   800ce2 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802465:	8b 46 04             	mov    0x4(%esi),%eax
  802468:	2b 06                	sub    (%esi),%eax
  80246a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802470:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802477:	00 00 00 
	stat->st_dev = &devpipe;
  80247a:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  802481:	40 80 00 
	return 0;
}
  802484:	b8 00 00 00 00       	mov    $0x0,%eax
  802489:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80248c:	5b                   	pop    %ebx
  80248d:	5e                   	pop    %esi
  80248e:	5d                   	pop    %ebp
  80248f:	c3                   	ret    

00802490 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802490:	55                   	push   %ebp
  802491:	89 e5                	mov    %esp,%ebp
  802493:	53                   	push   %ebx
  802494:	83 ec 0c             	sub    $0xc,%esp
  802497:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80249a:	53                   	push   %ebx
  80249b:	6a 00                	push   $0x0
  80249d:	e8 b7 ec ff ff       	call   801159 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8024a2:	89 1c 24             	mov    %ebx,(%esp)
  8024a5:	e8 88 f2 ff ff       	call   801732 <fd2data>
  8024aa:	83 c4 08             	add    $0x8,%esp
  8024ad:	50                   	push   %eax
  8024ae:	6a 00                	push   $0x0
  8024b0:	e8 a4 ec ff ff       	call   801159 <sys_page_unmap>
}
  8024b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024b8:	c9                   	leave  
  8024b9:	c3                   	ret    

008024ba <_pipeisclosed>:
{
  8024ba:	55                   	push   %ebp
  8024bb:	89 e5                	mov    %esp,%ebp
  8024bd:	57                   	push   %edi
  8024be:	56                   	push   %esi
  8024bf:	53                   	push   %ebx
  8024c0:	83 ec 1c             	sub    $0x1c,%esp
  8024c3:	89 c7                	mov    %eax,%edi
  8024c5:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8024c7:	a1 04 50 80 00       	mov    0x805004,%eax
  8024cc:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8024cf:	83 ec 0c             	sub    $0xc,%esp
  8024d2:	57                   	push   %edi
  8024d3:	e8 90 04 00 00       	call   802968 <pageref>
  8024d8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8024db:	89 34 24             	mov    %esi,(%esp)
  8024de:	e8 85 04 00 00       	call   802968 <pageref>
		nn = thisenv->env_runs;
  8024e3:	8b 15 04 50 80 00    	mov    0x805004,%edx
  8024e9:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8024ec:	83 c4 10             	add    $0x10,%esp
  8024ef:	39 cb                	cmp    %ecx,%ebx
  8024f1:	74 1b                	je     80250e <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8024f3:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8024f6:	75 cf                	jne    8024c7 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8024f8:	8b 42 58             	mov    0x58(%edx),%eax
  8024fb:	6a 01                	push   $0x1
  8024fd:	50                   	push   %eax
  8024fe:	53                   	push   %ebx
  8024ff:	68 71 34 80 00       	push   $0x803471
  802504:	e8 b3 e0 ff ff       	call   8005bc <cprintf>
  802509:	83 c4 10             	add    $0x10,%esp
  80250c:	eb b9                	jmp    8024c7 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  80250e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802511:	0f 94 c0             	sete   %al
  802514:	0f b6 c0             	movzbl %al,%eax
}
  802517:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80251a:	5b                   	pop    %ebx
  80251b:	5e                   	pop    %esi
  80251c:	5f                   	pop    %edi
  80251d:	5d                   	pop    %ebp
  80251e:	c3                   	ret    

0080251f <devpipe_write>:
{
  80251f:	55                   	push   %ebp
  802520:	89 e5                	mov    %esp,%ebp
  802522:	57                   	push   %edi
  802523:	56                   	push   %esi
  802524:	53                   	push   %ebx
  802525:	83 ec 28             	sub    $0x28,%esp
  802528:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80252b:	56                   	push   %esi
  80252c:	e8 01 f2 ff ff       	call   801732 <fd2data>
  802531:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802533:	83 c4 10             	add    $0x10,%esp
  802536:	bf 00 00 00 00       	mov    $0x0,%edi
  80253b:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80253e:	74 4f                	je     80258f <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802540:	8b 43 04             	mov    0x4(%ebx),%eax
  802543:	8b 0b                	mov    (%ebx),%ecx
  802545:	8d 51 20             	lea    0x20(%ecx),%edx
  802548:	39 d0                	cmp    %edx,%eax
  80254a:	72 14                	jb     802560 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80254c:	89 da                	mov    %ebx,%edx
  80254e:	89 f0                	mov    %esi,%eax
  802550:	e8 65 ff ff ff       	call   8024ba <_pipeisclosed>
  802555:	85 c0                	test   %eax,%eax
  802557:	75 3b                	jne    802594 <devpipe_write+0x75>
			sys_yield();
  802559:	e8 57 eb ff ff       	call   8010b5 <sys_yield>
  80255e:	eb e0                	jmp    802540 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802560:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802563:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802567:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80256a:	89 c2                	mov    %eax,%edx
  80256c:	c1 fa 1f             	sar    $0x1f,%edx
  80256f:	89 d1                	mov    %edx,%ecx
  802571:	c1 e9 1b             	shr    $0x1b,%ecx
  802574:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802577:	83 e2 1f             	and    $0x1f,%edx
  80257a:	29 ca                	sub    %ecx,%edx
  80257c:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802580:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802584:	83 c0 01             	add    $0x1,%eax
  802587:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80258a:	83 c7 01             	add    $0x1,%edi
  80258d:	eb ac                	jmp    80253b <devpipe_write+0x1c>
	return i;
  80258f:	8b 45 10             	mov    0x10(%ebp),%eax
  802592:	eb 05                	jmp    802599 <devpipe_write+0x7a>
				return 0;
  802594:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802599:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80259c:	5b                   	pop    %ebx
  80259d:	5e                   	pop    %esi
  80259e:	5f                   	pop    %edi
  80259f:	5d                   	pop    %ebp
  8025a0:	c3                   	ret    

008025a1 <devpipe_read>:
{
  8025a1:	55                   	push   %ebp
  8025a2:	89 e5                	mov    %esp,%ebp
  8025a4:	57                   	push   %edi
  8025a5:	56                   	push   %esi
  8025a6:	53                   	push   %ebx
  8025a7:	83 ec 18             	sub    $0x18,%esp
  8025aa:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8025ad:	57                   	push   %edi
  8025ae:	e8 7f f1 ff ff       	call   801732 <fd2data>
  8025b3:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8025b5:	83 c4 10             	add    $0x10,%esp
  8025b8:	be 00 00 00 00       	mov    $0x0,%esi
  8025bd:	3b 75 10             	cmp    0x10(%ebp),%esi
  8025c0:	75 14                	jne    8025d6 <devpipe_read+0x35>
	return i;
  8025c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8025c5:	eb 02                	jmp    8025c9 <devpipe_read+0x28>
				return i;
  8025c7:	89 f0                	mov    %esi,%eax
}
  8025c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8025cc:	5b                   	pop    %ebx
  8025cd:	5e                   	pop    %esi
  8025ce:	5f                   	pop    %edi
  8025cf:	5d                   	pop    %ebp
  8025d0:	c3                   	ret    
			sys_yield();
  8025d1:	e8 df ea ff ff       	call   8010b5 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8025d6:	8b 03                	mov    (%ebx),%eax
  8025d8:	3b 43 04             	cmp    0x4(%ebx),%eax
  8025db:	75 18                	jne    8025f5 <devpipe_read+0x54>
			if (i > 0)
  8025dd:	85 f6                	test   %esi,%esi
  8025df:	75 e6                	jne    8025c7 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8025e1:	89 da                	mov    %ebx,%edx
  8025e3:	89 f8                	mov    %edi,%eax
  8025e5:	e8 d0 fe ff ff       	call   8024ba <_pipeisclosed>
  8025ea:	85 c0                	test   %eax,%eax
  8025ec:	74 e3                	je     8025d1 <devpipe_read+0x30>
				return 0;
  8025ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8025f3:	eb d4                	jmp    8025c9 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8025f5:	99                   	cltd   
  8025f6:	c1 ea 1b             	shr    $0x1b,%edx
  8025f9:	01 d0                	add    %edx,%eax
  8025fb:	83 e0 1f             	and    $0x1f,%eax
  8025fe:	29 d0                	sub    %edx,%eax
  802600:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802605:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802608:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80260b:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80260e:	83 c6 01             	add    $0x1,%esi
  802611:	eb aa                	jmp    8025bd <devpipe_read+0x1c>

00802613 <pipe>:
{
  802613:	55                   	push   %ebp
  802614:	89 e5                	mov    %esp,%ebp
  802616:	56                   	push   %esi
  802617:	53                   	push   %ebx
  802618:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80261b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80261e:	50                   	push   %eax
  80261f:	e8 25 f1 ff ff       	call   801749 <fd_alloc>
  802624:	89 c3                	mov    %eax,%ebx
  802626:	83 c4 10             	add    $0x10,%esp
  802629:	85 c0                	test   %eax,%eax
  80262b:	0f 88 23 01 00 00    	js     802754 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802631:	83 ec 04             	sub    $0x4,%esp
  802634:	68 07 04 00 00       	push   $0x407
  802639:	ff 75 f4             	pushl  -0xc(%ebp)
  80263c:	6a 00                	push   $0x0
  80263e:	e8 91 ea ff ff       	call   8010d4 <sys_page_alloc>
  802643:	89 c3                	mov    %eax,%ebx
  802645:	83 c4 10             	add    $0x10,%esp
  802648:	85 c0                	test   %eax,%eax
  80264a:	0f 88 04 01 00 00    	js     802754 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802650:	83 ec 0c             	sub    $0xc,%esp
  802653:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802656:	50                   	push   %eax
  802657:	e8 ed f0 ff ff       	call   801749 <fd_alloc>
  80265c:	89 c3                	mov    %eax,%ebx
  80265e:	83 c4 10             	add    $0x10,%esp
  802661:	85 c0                	test   %eax,%eax
  802663:	0f 88 db 00 00 00    	js     802744 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802669:	83 ec 04             	sub    $0x4,%esp
  80266c:	68 07 04 00 00       	push   $0x407
  802671:	ff 75 f0             	pushl  -0x10(%ebp)
  802674:	6a 00                	push   $0x0
  802676:	e8 59 ea ff ff       	call   8010d4 <sys_page_alloc>
  80267b:	89 c3                	mov    %eax,%ebx
  80267d:	83 c4 10             	add    $0x10,%esp
  802680:	85 c0                	test   %eax,%eax
  802682:	0f 88 bc 00 00 00    	js     802744 <pipe+0x131>
	va = fd2data(fd0);
  802688:	83 ec 0c             	sub    $0xc,%esp
  80268b:	ff 75 f4             	pushl  -0xc(%ebp)
  80268e:	e8 9f f0 ff ff       	call   801732 <fd2data>
  802693:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802695:	83 c4 0c             	add    $0xc,%esp
  802698:	68 07 04 00 00       	push   $0x407
  80269d:	50                   	push   %eax
  80269e:	6a 00                	push   $0x0
  8026a0:	e8 2f ea ff ff       	call   8010d4 <sys_page_alloc>
  8026a5:	89 c3                	mov    %eax,%ebx
  8026a7:	83 c4 10             	add    $0x10,%esp
  8026aa:	85 c0                	test   %eax,%eax
  8026ac:	0f 88 82 00 00 00    	js     802734 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8026b2:	83 ec 0c             	sub    $0xc,%esp
  8026b5:	ff 75 f0             	pushl  -0x10(%ebp)
  8026b8:	e8 75 f0 ff ff       	call   801732 <fd2data>
  8026bd:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8026c4:	50                   	push   %eax
  8026c5:	6a 00                	push   $0x0
  8026c7:	56                   	push   %esi
  8026c8:	6a 00                	push   $0x0
  8026ca:	e8 48 ea ff ff       	call   801117 <sys_page_map>
  8026cf:	89 c3                	mov    %eax,%ebx
  8026d1:	83 c4 20             	add    $0x20,%esp
  8026d4:	85 c0                	test   %eax,%eax
  8026d6:	78 4e                	js     802726 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8026d8:	a1 3c 40 80 00       	mov    0x80403c,%eax
  8026dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026e0:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8026e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026e5:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8026ec:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026ef:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8026f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026f4:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8026fb:	83 ec 0c             	sub    $0xc,%esp
  8026fe:	ff 75 f4             	pushl  -0xc(%ebp)
  802701:	e8 1c f0 ff ff       	call   801722 <fd2num>
  802706:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802709:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80270b:	83 c4 04             	add    $0x4,%esp
  80270e:	ff 75 f0             	pushl  -0x10(%ebp)
  802711:	e8 0c f0 ff ff       	call   801722 <fd2num>
  802716:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802719:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80271c:	83 c4 10             	add    $0x10,%esp
  80271f:	bb 00 00 00 00       	mov    $0x0,%ebx
  802724:	eb 2e                	jmp    802754 <pipe+0x141>
	sys_page_unmap(0, va);
  802726:	83 ec 08             	sub    $0x8,%esp
  802729:	56                   	push   %esi
  80272a:	6a 00                	push   $0x0
  80272c:	e8 28 ea ff ff       	call   801159 <sys_page_unmap>
  802731:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802734:	83 ec 08             	sub    $0x8,%esp
  802737:	ff 75 f0             	pushl  -0x10(%ebp)
  80273a:	6a 00                	push   $0x0
  80273c:	e8 18 ea ff ff       	call   801159 <sys_page_unmap>
  802741:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802744:	83 ec 08             	sub    $0x8,%esp
  802747:	ff 75 f4             	pushl  -0xc(%ebp)
  80274a:	6a 00                	push   $0x0
  80274c:	e8 08 ea ff ff       	call   801159 <sys_page_unmap>
  802751:	83 c4 10             	add    $0x10,%esp
}
  802754:	89 d8                	mov    %ebx,%eax
  802756:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802759:	5b                   	pop    %ebx
  80275a:	5e                   	pop    %esi
  80275b:	5d                   	pop    %ebp
  80275c:	c3                   	ret    

0080275d <pipeisclosed>:
{
  80275d:	55                   	push   %ebp
  80275e:	89 e5                	mov    %esp,%ebp
  802760:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802763:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802766:	50                   	push   %eax
  802767:	ff 75 08             	pushl  0x8(%ebp)
  80276a:	e8 2c f0 ff ff       	call   80179b <fd_lookup>
  80276f:	83 c4 10             	add    $0x10,%esp
  802772:	85 c0                	test   %eax,%eax
  802774:	78 18                	js     80278e <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802776:	83 ec 0c             	sub    $0xc,%esp
  802779:	ff 75 f4             	pushl  -0xc(%ebp)
  80277c:	e8 b1 ef ff ff       	call   801732 <fd2data>
	return _pipeisclosed(fd, p);
  802781:	89 c2                	mov    %eax,%edx
  802783:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802786:	e8 2f fd ff ff       	call   8024ba <_pipeisclosed>
  80278b:	83 c4 10             	add    $0x10,%esp
}
  80278e:	c9                   	leave  
  80278f:	c3                   	ret    

00802790 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802790:	55                   	push   %ebp
  802791:	89 e5                	mov    %esp,%ebp
  802793:	56                   	push   %esi
  802794:	53                   	push   %ebx
  802795:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  802798:	85 f6                	test   %esi,%esi
  80279a:	74 16                	je     8027b2 <wait+0x22>
	e = &envs[ENVX(envid)];
  80279c:	89 f3                	mov    %esi,%ebx
  80279e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8027a4:	69 db 84 00 00 00    	imul   $0x84,%ebx,%ebx
  8027aa:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8027b0:	eb 1b                	jmp    8027cd <wait+0x3d>
	assert(envid != 0);
  8027b2:	68 89 34 80 00       	push   $0x803489
  8027b7:	68 ac 33 80 00       	push   $0x8033ac
  8027bc:	6a 09                	push   $0x9
  8027be:	68 94 34 80 00       	push   $0x803494
  8027c3:	e8 19 dd ff ff       	call   8004e1 <_panic>
		sys_yield();
  8027c8:	e8 e8 e8 ff ff       	call   8010b5 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8027cd:	8b 43 48             	mov    0x48(%ebx),%eax
  8027d0:	39 f0                	cmp    %esi,%eax
  8027d2:	75 07                	jne    8027db <wait+0x4b>
  8027d4:	8b 43 54             	mov    0x54(%ebx),%eax
  8027d7:	85 c0                	test   %eax,%eax
  8027d9:	75 ed                	jne    8027c8 <wait+0x38>
}
  8027db:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8027de:	5b                   	pop    %ebx
  8027df:	5e                   	pop    %esi
  8027e0:	5d                   	pop    %ebp
  8027e1:	c3                   	ret    

008027e2 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8027e2:	55                   	push   %ebp
  8027e3:	89 e5                	mov    %esp,%ebp
  8027e5:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8027e8:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  8027ef:	74 0a                	je     8027fb <set_pgfault_handler+0x19>
			panic("set_pgfault_handler: sys_env_set_pgfault_upcall fail, ret:%d", ret);
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8027f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f4:	a3 00 70 80 00       	mov    %eax,0x807000
}
  8027f9:	c9                   	leave  
  8027fa:	c3                   	ret    
		ret = sys_page_alloc((envid_t)0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W);
  8027fb:	83 ec 04             	sub    $0x4,%esp
  8027fe:	6a 07                	push   $0x7
  802800:	68 00 f0 bf ee       	push   $0xeebff000
  802805:	6a 00                	push   $0x0
  802807:	e8 c8 e8 ff ff       	call   8010d4 <sys_page_alloc>
		if(ret < 0){
  80280c:	83 c4 10             	add    $0x10,%esp
  80280f:	85 c0                	test   %eax,%eax
  802811:	78 28                	js     80283b <set_pgfault_handler+0x59>
    	ret = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  802813:	83 ec 08             	sub    $0x8,%esp
  802816:	68 4d 28 80 00       	push   $0x80284d
  80281b:	6a 00                	push   $0x0
  80281d:	e8 fd e9 ff ff       	call   80121f <sys_env_set_pgfault_upcall>
		if(ret < 0){
  802822:	83 c4 10             	add    $0x10,%esp
  802825:	85 c0                	test   %eax,%eax
  802827:	79 c8                	jns    8027f1 <set_pgfault_handler+0xf>
			panic("set_pgfault_handler: sys_env_set_pgfault_upcall fail, ret:%d", ret);
  802829:	50                   	push   %eax
  80282a:	68 d4 34 80 00       	push   $0x8034d4
  80282f:	6a 28                	push   $0x28
  802831:	68 14 35 80 00       	push   $0x803514
  802836:	e8 a6 dc ff ff       	call   8004e1 <_panic>
			panic("set_pgfault_handler: sys_page_alloc fail, ret:%d", ret);
  80283b:	50                   	push   %eax
  80283c:	68 a0 34 80 00       	push   $0x8034a0
  802841:	6a 24                	push   $0x24
  802843:	68 14 35 80 00       	push   $0x803514
  802848:	e8 94 dc ff ff       	call   8004e1 <_panic>

0080284d <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80284d:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80284e:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  802853:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802855:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %edi
  802858:	8b 7c 24 28          	mov    0x28(%esp),%edi
	movl 0x30(%esp), %esi
  80285c:	8b 74 24 30          	mov    0x30(%esp),%esi
	subl $4, %esi
  802860:	83 ee 04             	sub    $0x4,%esi
	movl %edi, (%esi)
  802863:	89 3e                	mov    %edi,(%esi)
	movl %esi, 0x30(%esp)
  802865:	89 74 24 30          	mov    %esi,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  802869:	83 c4 08             	add    $0x8,%esp
	popal
  80286c:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  80286d:	83 c4 04             	add    $0x4,%esp
	popfl
  802870:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802871:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  802872:	c3                   	ret    

00802873 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802873:	55                   	push   %ebp
  802874:	89 e5                	mov    %esp,%ebp
  802876:	56                   	push   %esi
  802877:	53                   	push   %ebx
  802878:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80287b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80287e:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// return 0;
	if(!pg)
  802881:	85 c0                	test   %eax,%eax
		pg = (void*)UTOP;
  802883:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802888:	0f 44 c2             	cmove  %edx,%eax
	
	int ret;

	ret = sys_ipc_recv(pg);
  80288b:	83 ec 0c             	sub    $0xc,%esp
  80288e:	50                   	push   %eax
  80288f:	e8 f0 e9 ff ff       	call   801284 <sys_ipc_recv>
	if(ret < 0){
  802894:	83 c4 10             	add    $0x10,%esp
  802897:	85 c0                	test   %eax,%eax
  802899:	78 2b                	js     8028c6 <ipc_recv+0x53>
		if(perm_store) *perm_store = 0;
		if(from_env_store) *from_env_store = 0;
		return ret;
	}
	
	if(perm_store)
  80289b:	85 f6                	test   %esi,%esi
  80289d:	74 0a                	je     8028a9 <ipc_recv+0x36>
		*perm_store = thisenv->env_ipc_perm;
  80289f:	a1 04 50 80 00       	mov    0x805004,%eax
  8028a4:	8b 40 78             	mov    0x78(%eax),%eax
  8028a7:	89 06                	mov    %eax,(%esi)
	if(from_env_store)
  8028a9:	85 db                	test   %ebx,%ebx
  8028ab:	74 0a                	je     8028b7 <ipc_recv+0x44>
		*from_env_store = thisenv->env_ipc_from;
  8028ad:	a1 04 50 80 00       	mov    0x805004,%eax
  8028b2:	8b 40 74             	mov    0x74(%eax),%eax
  8028b5:	89 03                	mov    %eax,(%ebx)

	return thisenv->env_ipc_value;
  8028b7:	a1 04 50 80 00       	mov    0x805004,%eax
  8028bc:	8b 40 70             	mov    0x70(%eax),%eax
}
  8028bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8028c2:	5b                   	pop    %ebx
  8028c3:	5e                   	pop    %esi
  8028c4:	5d                   	pop    %ebp
  8028c5:	c3                   	ret    
		if(perm_store) *perm_store = 0;
  8028c6:	85 f6                	test   %esi,%esi
  8028c8:	74 06                	je     8028d0 <ipc_recv+0x5d>
  8028ca:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(from_env_store) *from_env_store = 0;
  8028d0:	85 db                	test   %ebx,%ebx
  8028d2:	74 eb                	je     8028bf <ipc_recv+0x4c>
  8028d4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8028da:	eb e3                	jmp    8028bf <ipc_recv+0x4c>

008028dc <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8028dc:	55                   	push   %ebp
  8028dd:	89 e5                	mov    %esp,%ebp
  8028df:	57                   	push   %edi
  8028e0:	56                   	push   %esi
  8028e1:	53                   	push   %ebx
  8028e2:	83 ec 0c             	sub    $0xc,%esp
  8028e5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8028e8:	8b 75 0c             	mov    0xc(%ebp),%esi
  8028eb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
	if (!pg)
  8028ee:	85 db                	test   %ebx,%ebx
		pg = (void*)UTOP;
  8028f0:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8028f5:	0f 44 d8             	cmove  %eax,%ebx

	int ret = -E_IPC_NOT_RECV;
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))) {
  8028f8:	ff 75 14             	pushl  0x14(%ebp)
  8028fb:	53                   	push   %ebx
  8028fc:	56                   	push   %esi
  8028fd:	57                   	push   %edi
  8028fe:	e8 5e e9 ff ff       	call   801261 <sys_ipc_try_send>
  802903:	83 c4 10             	add    $0x10,%esp
  802906:	85 c0                	test   %eax,%eax
  802908:	74 17                	je     802921 <ipc_send+0x45>
		if(ret != -E_IPC_NOT_RECV){
  80290a:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80290d:	74 e9                	je     8028f8 <ipc_send+0x1c>
			panic("ipc_send: ret : %d", ret);
  80290f:	50                   	push   %eax
  802910:	68 22 35 80 00       	push   $0x803522
  802915:	6a 43                	push   $0x43
  802917:	68 35 35 80 00       	push   $0x803535
  80291c:	e8 c0 db ff ff       	call   8004e1 <_panic>
			sys_yield();
		}
	}
}
  802921:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802924:	5b                   	pop    %ebx
  802925:	5e                   	pop    %esi
  802926:	5f                   	pop    %edi
  802927:	5d                   	pop    %ebp
  802928:	c3                   	ret    

00802929 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802929:	55                   	push   %ebp
  80292a:	89 e5                	mov    %esp,%ebp
  80292c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80292f:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802934:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  80293a:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802940:	8b 52 50             	mov    0x50(%edx),%edx
  802943:	39 ca                	cmp    %ecx,%edx
  802945:	74 11                	je     802958 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  802947:	83 c0 01             	add    $0x1,%eax
  80294a:	3d 00 04 00 00       	cmp    $0x400,%eax
  80294f:	75 e3                	jne    802934 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802951:	b8 00 00 00 00       	mov    $0x0,%eax
  802956:	eb 0e                	jmp    802966 <ipc_find_env+0x3d>
			return envs[i].env_id;
  802958:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80295e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802963:	8b 40 48             	mov    0x48(%eax),%eax
}
  802966:	5d                   	pop    %ebp
  802967:	c3                   	ret    

00802968 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802968:	55                   	push   %ebp
  802969:	89 e5                	mov    %esp,%ebp
  80296b:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80296e:	89 d0                	mov    %edx,%eax
  802970:	c1 e8 16             	shr    $0x16,%eax
  802973:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80297a:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80297f:	f6 c1 01             	test   $0x1,%cl
  802982:	74 1d                	je     8029a1 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802984:	c1 ea 0c             	shr    $0xc,%edx
  802987:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80298e:	f6 c2 01             	test   $0x1,%dl
  802991:	74 0e                	je     8029a1 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802993:	c1 ea 0c             	shr    $0xc,%edx
  802996:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80299d:	ef 
  80299e:	0f b7 c0             	movzwl %ax,%eax
}
  8029a1:	5d                   	pop    %ebp
  8029a2:	c3                   	ret    
  8029a3:	66 90                	xchg   %ax,%ax
  8029a5:	66 90                	xchg   %ax,%ax
  8029a7:	66 90                	xchg   %ax,%ax
  8029a9:	66 90                	xchg   %ax,%ax
  8029ab:	66 90                	xchg   %ax,%ax
  8029ad:	66 90                	xchg   %ax,%ax
  8029af:	90                   	nop

008029b0 <__udivdi3>:
  8029b0:	55                   	push   %ebp
  8029b1:	57                   	push   %edi
  8029b2:	56                   	push   %esi
  8029b3:	53                   	push   %ebx
  8029b4:	83 ec 1c             	sub    $0x1c,%esp
  8029b7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8029bb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8029bf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8029c3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8029c7:	85 d2                	test   %edx,%edx
  8029c9:	75 4d                	jne    802a18 <__udivdi3+0x68>
  8029cb:	39 f3                	cmp    %esi,%ebx
  8029cd:	76 19                	jbe    8029e8 <__udivdi3+0x38>
  8029cf:	31 ff                	xor    %edi,%edi
  8029d1:	89 e8                	mov    %ebp,%eax
  8029d3:	89 f2                	mov    %esi,%edx
  8029d5:	f7 f3                	div    %ebx
  8029d7:	89 fa                	mov    %edi,%edx
  8029d9:	83 c4 1c             	add    $0x1c,%esp
  8029dc:	5b                   	pop    %ebx
  8029dd:	5e                   	pop    %esi
  8029de:	5f                   	pop    %edi
  8029df:	5d                   	pop    %ebp
  8029e0:	c3                   	ret    
  8029e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029e8:	89 d9                	mov    %ebx,%ecx
  8029ea:	85 db                	test   %ebx,%ebx
  8029ec:	75 0b                	jne    8029f9 <__udivdi3+0x49>
  8029ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8029f3:	31 d2                	xor    %edx,%edx
  8029f5:	f7 f3                	div    %ebx
  8029f7:	89 c1                	mov    %eax,%ecx
  8029f9:	31 d2                	xor    %edx,%edx
  8029fb:	89 f0                	mov    %esi,%eax
  8029fd:	f7 f1                	div    %ecx
  8029ff:	89 c6                	mov    %eax,%esi
  802a01:	89 e8                	mov    %ebp,%eax
  802a03:	89 f7                	mov    %esi,%edi
  802a05:	f7 f1                	div    %ecx
  802a07:	89 fa                	mov    %edi,%edx
  802a09:	83 c4 1c             	add    $0x1c,%esp
  802a0c:	5b                   	pop    %ebx
  802a0d:	5e                   	pop    %esi
  802a0e:	5f                   	pop    %edi
  802a0f:	5d                   	pop    %ebp
  802a10:	c3                   	ret    
  802a11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a18:	39 f2                	cmp    %esi,%edx
  802a1a:	77 1c                	ja     802a38 <__udivdi3+0x88>
  802a1c:	0f bd fa             	bsr    %edx,%edi
  802a1f:	83 f7 1f             	xor    $0x1f,%edi
  802a22:	75 2c                	jne    802a50 <__udivdi3+0xa0>
  802a24:	39 f2                	cmp    %esi,%edx
  802a26:	72 06                	jb     802a2e <__udivdi3+0x7e>
  802a28:	31 c0                	xor    %eax,%eax
  802a2a:	39 eb                	cmp    %ebp,%ebx
  802a2c:	77 a9                	ja     8029d7 <__udivdi3+0x27>
  802a2e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a33:	eb a2                	jmp    8029d7 <__udivdi3+0x27>
  802a35:	8d 76 00             	lea    0x0(%esi),%esi
  802a38:	31 ff                	xor    %edi,%edi
  802a3a:	31 c0                	xor    %eax,%eax
  802a3c:	89 fa                	mov    %edi,%edx
  802a3e:	83 c4 1c             	add    $0x1c,%esp
  802a41:	5b                   	pop    %ebx
  802a42:	5e                   	pop    %esi
  802a43:	5f                   	pop    %edi
  802a44:	5d                   	pop    %ebp
  802a45:	c3                   	ret    
  802a46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a4d:	8d 76 00             	lea    0x0(%esi),%esi
  802a50:	89 f9                	mov    %edi,%ecx
  802a52:	b8 20 00 00 00       	mov    $0x20,%eax
  802a57:	29 f8                	sub    %edi,%eax
  802a59:	d3 e2                	shl    %cl,%edx
  802a5b:	89 54 24 08          	mov    %edx,0x8(%esp)
  802a5f:	89 c1                	mov    %eax,%ecx
  802a61:	89 da                	mov    %ebx,%edx
  802a63:	d3 ea                	shr    %cl,%edx
  802a65:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802a69:	09 d1                	or     %edx,%ecx
  802a6b:	89 f2                	mov    %esi,%edx
  802a6d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a71:	89 f9                	mov    %edi,%ecx
  802a73:	d3 e3                	shl    %cl,%ebx
  802a75:	89 c1                	mov    %eax,%ecx
  802a77:	d3 ea                	shr    %cl,%edx
  802a79:	89 f9                	mov    %edi,%ecx
  802a7b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802a7f:	89 eb                	mov    %ebp,%ebx
  802a81:	d3 e6                	shl    %cl,%esi
  802a83:	89 c1                	mov    %eax,%ecx
  802a85:	d3 eb                	shr    %cl,%ebx
  802a87:	09 de                	or     %ebx,%esi
  802a89:	89 f0                	mov    %esi,%eax
  802a8b:	f7 74 24 08          	divl   0x8(%esp)
  802a8f:	89 d6                	mov    %edx,%esi
  802a91:	89 c3                	mov    %eax,%ebx
  802a93:	f7 64 24 0c          	mull   0xc(%esp)
  802a97:	39 d6                	cmp    %edx,%esi
  802a99:	72 15                	jb     802ab0 <__udivdi3+0x100>
  802a9b:	89 f9                	mov    %edi,%ecx
  802a9d:	d3 e5                	shl    %cl,%ebp
  802a9f:	39 c5                	cmp    %eax,%ebp
  802aa1:	73 04                	jae    802aa7 <__udivdi3+0xf7>
  802aa3:	39 d6                	cmp    %edx,%esi
  802aa5:	74 09                	je     802ab0 <__udivdi3+0x100>
  802aa7:	89 d8                	mov    %ebx,%eax
  802aa9:	31 ff                	xor    %edi,%edi
  802aab:	e9 27 ff ff ff       	jmp    8029d7 <__udivdi3+0x27>
  802ab0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802ab3:	31 ff                	xor    %edi,%edi
  802ab5:	e9 1d ff ff ff       	jmp    8029d7 <__udivdi3+0x27>
  802aba:	66 90                	xchg   %ax,%ax
  802abc:	66 90                	xchg   %ax,%ax
  802abe:	66 90                	xchg   %ax,%ax

00802ac0 <__umoddi3>:
  802ac0:	55                   	push   %ebp
  802ac1:	57                   	push   %edi
  802ac2:	56                   	push   %esi
  802ac3:	53                   	push   %ebx
  802ac4:	83 ec 1c             	sub    $0x1c,%esp
  802ac7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802acb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802acf:	8b 74 24 30          	mov    0x30(%esp),%esi
  802ad3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802ad7:	89 da                	mov    %ebx,%edx
  802ad9:	85 c0                	test   %eax,%eax
  802adb:	75 43                	jne    802b20 <__umoddi3+0x60>
  802add:	39 df                	cmp    %ebx,%edi
  802adf:	76 17                	jbe    802af8 <__umoddi3+0x38>
  802ae1:	89 f0                	mov    %esi,%eax
  802ae3:	f7 f7                	div    %edi
  802ae5:	89 d0                	mov    %edx,%eax
  802ae7:	31 d2                	xor    %edx,%edx
  802ae9:	83 c4 1c             	add    $0x1c,%esp
  802aec:	5b                   	pop    %ebx
  802aed:	5e                   	pop    %esi
  802aee:	5f                   	pop    %edi
  802aef:	5d                   	pop    %ebp
  802af0:	c3                   	ret    
  802af1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802af8:	89 fd                	mov    %edi,%ebp
  802afa:	85 ff                	test   %edi,%edi
  802afc:	75 0b                	jne    802b09 <__umoddi3+0x49>
  802afe:	b8 01 00 00 00       	mov    $0x1,%eax
  802b03:	31 d2                	xor    %edx,%edx
  802b05:	f7 f7                	div    %edi
  802b07:	89 c5                	mov    %eax,%ebp
  802b09:	89 d8                	mov    %ebx,%eax
  802b0b:	31 d2                	xor    %edx,%edx
  802b0d:	f7 f5                	div    %ebp
  802b0f:	89 f0                	mov    %esi,%eax
  802b11:	f7 f5                	div    %ebp
  802b13:	89 d0                	mov    %edx,%eax
  802b15:	eb d0                	jmp    802ae7 <__umoddi3+0x27>
  802b17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b1e:	66 90                	xchg   %ax,%ax
  802b20:	89 f1                	mov    %esi,%ecx
  802b22:	39 d8                	cmp    %ebx,%eax
  802b24:	76 0a                	jbe    802b30 <__umoddi3+0x70>
  802b26:	89 f0                	mov    %esi,%eax
  802b28:	83 c4 1c             	add    $0x1c,%esp
  802b2b:	5b                   	pop    %ebx
  802b2c:	5e                   	pop    %esi
  802b2d:	5f                   	pop    %edi
  802b2e:	5d                   	pop    %ebp
  802b2f:	c3                   	ret    
  802b30:	0f bd e8             	bsr    %eax,%ebp
  802b33:	83 f5 1f             	xor    $0x1f,%ebp
  802b36:	75 20                	jne    802b58 <__umoddi3+0x98>
  802b38:	39 d8                	cmp    %ebx,%eax
  802b3a:	0f 82 b0 00 00 00    	jb     802bf0 <__umoddi3+0x130>
  802b40:	39 f7                	cmp    %esi,%edi
  802b42:	0f 86 a8 00 00 00    	jbe    802bf0 <__umoddi3+0x130>
  802b48:	89 c8                	mov    %ecx,%eax
  802b4a:	83 c4 1c             	add    $0x1c,%esp
  802b4d:	5b                   	pop    %ebx
  802b4e:	5e                   	pop    %esi
  802b4f:	5f                   	pop    %edi
  802b50:	5d                   	pop    %ebp
  802b51:	c3                   	ret    
  802b52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802b58:	89 e9                	mov    %ebp,%ecx
  802b5a:	ba 20 00 00 00       	mov    $0x20,%edx
  802b5f:	29 ea                	sub    %ebp,%edx
  802b61:	d3 e0                	shl    %cl,%eax
  802b63:	89 44 24 08          	mov    %eax,0x8(%esp)
  802b67:	89 d1                	mov    %edx,%ecx
  802b69:	89 f8                	mov    %edi,%eax
  802b6b:	d3 e8                	shr    %cl,%eax
  802b6d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802b71:	89 54 24 04          	mov    %edx,0x4(%esp)
  802b75:	8b 54 24 04          	mov    0x4(%esp),%edx
  802b79:	09 c1                	or     %eax,%ecx
  802b7b:	89 d8                	mov    %ebx,%eax
  802b7d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b81:	89 e9                	mov    %ebp,%ecx
  802b83:	d3 e7                	shl    %cl,%edi
  802b85:	89 d1                	mov    %edx,%ecx
  802b87:	d3 e8                	shr    %cl,%eax
  802b89:	89 e9                	mov    %ebp,%ecx
  802b8b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b8f:	d3 e3                	shl    %cl,%ebx
  802b91:	89 c7                	mov    %eax,%edi
  802b93:	89 d1                	mov    %edx,%ecx
  802b95:	89 f0                	mov    %esi,%eax
  802b97:	d3 e8                	shr    %cl,%eax
  802b99:	89 e9                	mov    %ebp,%ecx
  802b9b:	89 fa                	mov    %edi,%edx
  802b9d:	d3 e6                	shl    %cl,%esi
  802b9f:	09 d8                	or     %ebx,%eax
  802ba1:	f7 74 24 08          	divl   0x8(%esp)
  802ba5:	89 d1                	mov    %edx,%ecx
  802ba7:	89 f3                	mov    %esi,%ebx
  802ba9:	f7 64 24 0c          	mull   0xc(%esp)
  802bad:	89 c6                	mov    %eax,%esi
  802baf:	89 d7                	mov    %edx,%edi
  802bb1:	39 d1                	cmp    %edx,%ecx
  802bb3:	72 06                	jb     802bbb <__umoddi3+0xfb>
  802bb5:	75 10                	jne    802bc7 <__umoddi3+0x107>
  802bb7:	39 c3                	cmp    %eax,%ebx
  802bb9:	73 0c                	jae    802bc7 <__umoddi3+0x107>
  802bbb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802bbf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802bc3:	89 d7                	mov    %edx,%edi
  802bc5:	89 c6                	mov    %eax,%esi
  802bc7:	89 ca                	mov    %ecx,%edx
  802bc9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802bce:	29 f3                	sub    %esi,%ebx
  802bd0:	19 fa                	sbb    %edi,%edx
  802bd2:	89 d0                	mov    %edx,%eax
  802bd4:	d3 e0                	shl    %cl,%eax
  802bd6:	89 e9                	mov    %ebp,%ecx
  802bd8:	d3 eb                	shr    %cl,%ebx
  802bda:	d3 ea                	shr    %cl,%edx
  802bdc:	09 d8                	or     %ebx,%eax
  802bde:	83 c4 1c             	add    $0x1c,%esp
  802be1:	5b                   	pop    %ebx
  802be2:	5e                   	pop    %esi
  802be3:	5f                   	pop    %edi
  802be4:	5d                   	pop    %ebp
  802be5:	c3                   	ret    
  802be6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802bed:	8d 76 00             	lea    0x0(%esi),%esi
  802bf0:	89 da                	mov    %ebx,%edx
  802bf2:	29 fe                	sub    %edi,%esi
  802bf4:	19 c2                	sbb    %eax,%edx
  802bf6:	89 f1                	mov    %esi,%ecx
  802bf8:	89 c8                	mov    %ecx,%eax
  802bfa:	e9 4b ff ff ff       	jmp    802b4a <__umoddi3+0x8a>
