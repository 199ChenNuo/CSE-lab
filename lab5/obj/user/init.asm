
obj/user/init.debug:     file format elf32-i386


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
  80002c:	e8 65 03 00 00       	call   800396 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <sum>:

char bss[6000];

int
sum(const char *s, int n)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	8b 75 08             	mov    0x8(%ebp),%esi
  80003b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i, tot = 0;
  80003e:	b8 00 00 00 00       	mov    $0x0,%eax
	for (i = 0; i < n; i++)
  800043:	ba 00 00 00 00       	mov    $0x0,%edx
  800048:	39 da                	cmp    %ebx,%edx
  80004a:	7d 0e                	jge    80005a <sum+0x27>
		tot ^= i * s[i];
  80004c:	0f be 0c 16          	movsbl (%esi,%edx,1),%ecx
  800050:	0f af ca             	imul   %edx,%ecx
  800053:	31 c8                	xor    %ecx,%eax
	for (i = 0; i < n; i++)
  800055:	83 c2 01             	add    $0x1,%edx
  800058:	eb ee                	jmp    800048 <sum+0x15>
	return tot;
}
  80005a:	5b                   	pop    %ebx
  80005b:	5e                   	pop    %esi
  80005c:	5d                   	pop    %ebp
  80005d:	c3                   	ret    

0080005e <umain>:

void
umain(int argc, char **argv)
{
  80005e:	55                   	push   %ebp
  80005f:	89 e5                	mov    %esp,%ebp
  800061:	57                   	push   %edi
  800062:	56                   	push   %esi
  800063:	53                   	push   %ebx
  800064:	81 ec 18 01 00 00    	sub    $0x118,%esp
  80006a:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i, r, x, want;
	char args[256];

	cprintf("init: running\n");
  80006d:	68 60 26 80 00       	push   $0x802660
  800072:	e8 55 04 00 00       	call   8004cc <cprintf>

	want = 0xf989e;
	if ((x = sum((char*)&data, sizeof data)) != want)
  800077:	83 c4 08             	add    $0x8,%esp
  80007a:	68 70 17 00 00       	push   $0x1770
  80007f:	68 00 30 80 00       	push   $0x803000
  800084:	e8 aa ff ff ff       	call   800033 <sum>
  800089:	83 c4 10             	add    $0x10,%esp
  80008c:	3d 9e 98 0f 00       	cmp    $0xf989e,%eax
  800091:	0f 84 99 00 00 00    	je     800130 <umain+0xd2>
		cprintf("init: data is not initialized: got sum %08x wanted %08x\n",
  800097:	83 ec 04             	sub    $0x4,%esp
  80009a:	68 9e 98 0f 00       	push   $0xf989e
  80009f:	50                   	push   %eax
  8000a0:	68 28 27 80 00       	push   $0x802728
  8000a5:	e8 22 04 00 00       	call   8004cc <cprintf>
  8000aa:	83 c4 10             	add    $0x10,%esp
			x, want);
	else
		cprintf("init: data seems okay\n");
	if ((x = sum(bss, sizeof bss)) != 0)
  8000ad:	83 ec 08             	sub    $0x8,%esp
  8000b0:	68 70 17 00 00       	push   $0x1770
  8000b5:	68 20 50 80 00       	push   $0x805020
  8000ba:	e8 74 ff ff ff       	call   800033 <sum>
  8000bf:	83 c4 10             	add    $0x10,%esp
  8000c2:	85 c0                	test   %eax,%eax
  8000c4:	74 7f                	je     800145 <umain+0xe7>
		cprintf("bss is not initialized: wanted sum 0 got %08x\n", x);
  8000c6:	83 ec 08             	sub    $0x8,%esp
  8000c9:	50                   	push   %eax
  8000ca:	68 64 27 80 00       	push   $0x802764
  8000cf:	e8 f8 03 00 00       	call   8004cc <cprintf>
  8000d4:	83 c4 10             	add    $0x10,%esp
	else
		cprintf("init: bss seems okay\n");

	// output in one syscall per line to avoid output interleaving 
	strcat(args, "init: args:");
  8000d7:	83 ec 08             	sub    $0x8,%esp
  8000da:	68 9c 26 80 00       	push   $0x80269c
  8000df:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8000e5:	50                   	push   %eax
  8000e6:	e8 27 0b 00 00       	call   800c12 <strcat>
	for (i = 0; i < argc; i++) {
  8000eb:	83 c4 10             	add    $0x10,%esp
  8000ee:	bb 00 00 00 00       	mov    $0x0,%ebx
		strcat(args, " '");
  8000f3:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
	for (i = 0; i < argc; i++) {
  8000f9:	39 fb                	cmp    %edi,%ebx
  8000fb:	7d 5a                	jge    800157 <umain+0xf9>
		strcat(args, " '");
  8000fd:	83 ec 08             	sub    $0x8,%esp
  800100:	68 a8 26 80 00       	push   $0x8026a8
  800105:	56                   	push   %esi
  800106:	e8 07 0b 00 00       	call   800c12 <strcat>
		strcat(args, argv[i]);
  80010b:	83 c4 08             	add    $0x8,%esp
  80010e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800111:	ff 34 98             	pushl  (%eax,%ebx,4)
  800114:	56                   	push   %esi
  800115:	e8 f8 0a 00 00       	call   800c12 <strcat>
		strcat(args, "'");
  80011a:	83 c4 08             	add    $0x8,%esp
  80011d:	68 a9 26 80 00       	push   $0x8026a9
  800122:	56                   	push   %esi
  800123:	e8 ea 0a 00 00       	call   800c12 <strcat>
	for (i = 0; i < argc; i++) {
  800128:	83 c3 01             	add    $0x1,%ebx
  80012b:	83 c4 10             	add    $0x10,%esp
  80012e:	eb c9                	jmp    8000f9 <umain+0x9b>
		cprintf("init: data seems okay\n");
  800130:	83 ec 0c             	sub    $0xc,%esp
  800133:	68 6f 26 80 00       	push   $0x80266f
  800138:	e8 8f 03 00 00       	call   8004cc <cprintf>
  80013d:	83 c4 10             	add    $0x10,%esp
  800140:	e9 68 ff ff ff       	jmp    8000ad <umain+0x4f>
		cprintf("init: bss seems okay\n");
  800145:	83 ec 0c             	sub    $0xc,%esp
  800148:	68 86 26 80 00       	push   $0x802686
  80014d:	e8 7a 03 00 00       	call   8004cc <cprintf>
  800152:	83 c4 10             	add    $0x10,%esp
  800155:	eb 80                	jmp    8000d7 <umain+0x79>
	}
	cprintf("%s\n", args);
  800157:	83 ec 08             	sub    $0x8,%esp
  80015a:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  800160:	50                   	push   %eax
  800161:	68 ab 26 80 00       	push   $0x8026ab
  800166:	e8 61 03 00 00       	call   8004cc <cprintf>

	cprintf("init: running sh\n");
  80016b:	c7 04 24 af 26 80 00 	movl   $0x8026af,(%esp)
  800172:	e8 55 03 00 00       	call   8004cc <cprintf>

	// being run directly from kernel, so no file descriptors open yet
	close(0);
  800177:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80017e:	e8 39 12 00 00       	call   8013bc <close>
	if ((r = opencons()) < 0)
  800183:	e8 bc 01 00 00       	call   800344 <opencons>
  800188:	83 c4 10             	add    $0x10,%esp
  80018b:	85 c0                	test   %eax,%eax
  80018d:	78 14                	js     8001a3 <umain+0x145>
		panic("opencons: %e", r);
	if (r != 0)
  80018f:	74 24                	je     8001b5 <umain+0x157>
		panic("first opencons used fd %d", r);
  800191:	50                   	push   %eax
  800192:	68 da 26 80 00       	push   $0x8026da
  800197:	6a 39                	push   $0x39
  800199:	68 ce 26 80 00       	push   $0x8026ce
  80019e:	e8 4e 02 00 00       	call   8003f1 <_panic>
		panic("opencons: %e", r);
  8001a3:	50                   	push   %eax
  8001a4:	68 c1 26 80 00       	push   $0x8026c1
  8001a9:	6a 37                	push   $0x37
  8001ab:	68 ce 26 80 00       	push   $0x8026ce
  8001b0:	e8 3c 02 00 00       	call   8003f1 <_panic>
	if ((r = dup(0, 1)) < 0)
  8001b5:	83 ec 08             	sub    $0x8,%esp
  8001b8:	6a 01                	push   $0x1
  8001ba:	6a 00                	push   $0x0
  8001bc:	e8 4d 12 00 00       	call   80140e <dup>
  8001c1:	83 c4 10             	add    $0x10,%esp
  8001c4:	85 c0                	test   %eax,%eax
  8001c6:	79 23                	jns    8001eb <umain+0x18d>
		panic("dup: %e", r);
  8001c8:	50                   	push   %eax
  8001c9:	68 f4 26 80 00       	push   $0x8026f4
  8001ce:	6a 3b                	push   $0x3b
  8001d0:	68 ce 26 80 00       	push   $0x8026ce
  8001d5:	e8 17 02 00 00       	call   8003f1 <_panic>
	while (1) {
		cprintf("init: starting sh\n");
		r = spawnl("/sh", "sh", (char*)0);
		if (r < 0) {
			cprintf("init: spawn sh: %e\n", r);
  8001da:	83 ec 08             	sub    $0x8,%esp
  8001dd:	50                   	push   %eax
  8001de:	68 13 27 80 00       	push   $0x802713
  8001e3:	e8 e4 02 00 00       	call   8004cc <cprintf>
			continue;
  8001e8:	83 c4 10             	add    $0x10,%esp
		cprintf("init: starting sh\n");
  8001eb:	83 ec 0c             	sub    $0xc,%esp
  8001ee:	68 fc 26 80 00       	push   $0x8026fc
  8001f3:	e8 d4 02 00 00       	call   8004cc <cprintf>
		r = spawnl("/sh", "sh", (char*)0);
  8001f8:	83 c4 0c             	add    $0xc,%esp
  8001fb:	6a 00                	push   $0x0
  8001fd:	68 10 27 80 00       	push   $0x802710
  800202:	68 0f 27 80 00       	push   $0x80270f
  800207:	e8 ad 1c 00 00       	call   801eb9 <spawnl>
		if (r < 0) {
  80020c:	83 c4 10             	add    $0x10,%esp
  80020f:	85 c0                	test   %eax,%eax
  800211:	78 c7                	js     8001da <umain+0x17c>
		}
		wait(r);
  800213:	83 ec 0c             	sub    $0xc,%esp
  800216:	50                   	push   %eax
  800217:	e8 68 20 00 00       	call   802284 <wait>
  80021c:	83 c4 10             	add    $0x10,%esp
  80021f:	eb ca                	jmp    8001eb <umain+0x18d>

00800221 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  800221:	b8 00 00 00 00       	mov    $0x0,%eax
  800226:	c3                   	ret    

00800227 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800227:	55                   	push   %ebp
  800228:	89 e5                	mov    %esp,%ebp
  80022a:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80022d:	68 93 27 80 00       	push   $0x802793
  800232:	ff 75 0c             	pushl  0xc(%ebp)
  800235:	e8 b8 09 00 00       	call   800bf2 <strcpy>
	return 0;
}
  80023a:	b8 00 00 00 00       	mov    $0x0,%eax
  80023f:	c9                   	leave  
  800240:	c3                   	ret    

00800241 <devcons_write>:
{
  800241:	55                   	push   %ebp
  800242:	89 e5                	mov    %esp,%ebp
  800244:	57                   	push   %edi
  800245:	56                   	push   %esi
  800246:	53                   	push   %ebx
  800247:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80024d:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  800252:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  800258:	3b 75 10             	cmp    0x10(%ebp),%esi
  80025b:	73 31                	jae    80028e <devcons_write+0x4d>
		m = n - tot;
  80025d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800260:	29 f3                	sub    %esi,%ebx
  800262:	83 fb 7f             	cmp    $0x7f,%ebx
  800265:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80026a:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80026d:	83 ec 04             	sub    $0x4,%esp
  800270:	53                   	push   %ebx
  800271:	89 f0                	mov    %esi,%eax
  800273:	03 45 0c             	add    0xc(%ebp),%eax
  800276:	50                   	push   %eax
  800277:	57                   	push   %edi
  800278:	e8 03 0b 00 00       	call   800d80 <memmove>
		sys_cputs(buf, m);
  80027d:	83 c4 08             	add    $0x8,%esp
  800280:	53                   	push   %ebx
  800281:	57                   	push   %edi
  800282:	e8 a1 0c 00 00       	call   800f28 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  800287:	01 de                	add    %ebx,%esi
  800289:	83 c4 10             	add    $0x10,%esp
  80028c:	eb ca                	jmp    800258 <devcons_write+0x17>
}
  80028e:	89 f0                	mov    %esi,%eax
  800290:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800293:	5b                   	pop    %ebx
  800294:	5e                   	pop    %esi
  800295:	5f                   	pop    %edi
  800296:	5d                   	pop    %ebp
  800297:	c3                   	ret    

00800298 <devcons_read>:
{
  800298:	55                   	push   %ebp
  800299:	89 e5                	mov    %esp,%ebp
  80029b:	83 ec 08             	sub    $0x8,%esp
  80029e:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8002a3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8002a7:	74 21                	je     8002ca <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8002a9:	e8 98 0c 00 00       	call   800f46 <sys_cgetc>
  8002ae:	85 c0                	test   %eax,%eax
  8002b0:	75 07                	jne    8002b9 <devcons_read+0x21>
		sys_yield();
  8002b2:	e8 0e 0d 00 00       	call   800fc5 <sys_yield>
  8002b7:	eb f0                	jmp    8002a9 <devcons_read+0x11>
	if (c < 0)
  8002b9:	78 0f                	js     8002ca <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8002bb:	83 f8 04             	cmp    $0x4,%eax
  8002be:	74 0c                	je     8002cc <devcons_read+0x34>
	*(char*)vbuf = c;
  8002c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002c3:	88 02                	mov    %al,(%edx)
	return 1;
  8002c5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8002ca:	c9                   	leave  
  8002cb:	c3                   	ret    
		return 0;
  8002cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8002d1:	eb f7                	jmp    8002ca <devcons_read+0x32>

008002d3 <cputchar>:
{
  8002d3:	55                   	push   %ebp
  8002d4:	89 e5                	mov    %esp,%ebp
  8002d6:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8002d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8002dc:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8002df:	6a 01                	push   $0x1
  8002e1:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8002e4:	50                   	push   %eax
  8002e5:	e8 3e 0c 00 00       	call   800f28 <sys_cputs>
}
  8002ea:	83 c4 10             	add    $0x10,%esp
  8002ed:	c9                   	leave  
  8002ee:	c3                   	ret    

008002ef <getchar>:
{
  8002ef:	55                   	push   %ebp
  8002f0:	89 e5                	mov    %esp,%ebp
  8002f2:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8002f5:	6a 01                	push   $0x1
  8002f7:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8002fa:	50                   	push   %eax
  8002fb:	6a 00                	push   $0x0
  8002fd:	e8 f8 11 00 00       	call   8014fa <read>
	if (r < 0)
  800302:	83 c4 10             	add    $0x10,%esp
  800305:	85 c0                	test   %eax,%eax
  800307:	78 06                	js     80030f <getchar+0x20>
	if (r < 1)
  800309:	74 06                	je     800311 <getchar+0x22>
	return c;
  80030b:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80030f:	c9                   	leave  
  800310:	c3                   	ret    
		return -E_EOF;
  800311:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  800316:	eb f7                	jmp    80030f <getchar+0x20>

00800318 <iscons>:
{
  800318:	55                   	push   %ebp
  800319:	89 e5                	mov    %esp,%ebp
  80031b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80031e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800321:	50                   	push   %eax
  800322:	ff 75 08             	pushl  0x8(%ebp)
  800325:	e8 65 0f 00 00       	call   80128f <fd_lookup>
  80032a:	83 c4 10             	add    $0x10,%esp
  80032d:	85 c0                	test   %eax,%eax
  80032f:	78 11                	js     800342 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  800331:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800334:	8b 15 70 47 80 00    	mov    0x804770,%edx
  80033a:	39 10                	cmp    %edx,(%eax)
  80033c:	0f 94 c0             	sete   %al
  80033f:	0f b6 c0             	movzbl %al,%eax
}
  800342:	c9                   	leave  
  800343:	c3                   	ret    

00800344 <opencons>:
{
  800344:	55                   	push   %ebp
  800345:	89 e5                	mov    %esp,%ebp
  800347:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80034a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80034d:	50                   	push   %eax
  80034e:	e8 ea 0e 00 00       	call   80123d <fd_alloc>
  800353:	83 c4 10             	add    $0x10,%esp
  800356:	85 c0                	test   %eax,%eax
  800358:	78 3a                	js     800394 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80035a:	83 ec 04             	sub    $0x4,%esp
  80035d:	68 07 04 00 00       	push   $0x407
  800362:	ff 75 f4             	pushl  -0xc(%ebp)
  800365:	6a 00                	push   $0x0
  800367:	e8 78 0c 00 00       	call   800fe4 <sys_page_alloc>
  80036c:	83 c4 10             	add    $0x10,%esp
  80036f:	85 c0                	test   %eax,%eax
  800371:	78 21                	js     800394 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  800373:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800376:	8b 15 70 47 80 00    	mov    0x804770,%edx
  80037c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80037e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800381:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800388:	83 ec 0c             	sub    $0xc,%esp
  80038b:	50                   	push   %eax
  80038c:	e8 85 0e 00 00       	call   801216 <fd2num>
  800391:	83 c4 10             	add    $0x10,%esp
}
  800394:	c9                   	leave  
  800395:	c3                   	ret    

00800396 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800396:	55                   	push   %ebp
  800397:	89 e5                	mov    %esp,%ebp
  800399:	56                   	push   %esi
  80039a:	53                   	push   %ebx
  80039b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80039e:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	// thisenv = 0;
	thisenv = &(envs[ENVX(sys_getenvid())]);
  8003a1:	e8 00 0c 00 00       	call   800fa6 <sys_getenvid>
  8003a6:	25 ff 03 00 00       	and    $0x3ff,%eax
  8003ab:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8003b1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8003b6:	a3 90 67 80 00       	mov    %eax,0x806790

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003bb:	85 db                	test   %ebx,%ebx
  8003bd:	7e 07                	jle    8003c6 <libmain+0x30>
		binaryname = argv[0];
  8003bf:	8b 06                	mov    (%esi),%eax
  8003c1:	a3 8c 47 80 00       	mov    %eax,0x80478c

	// call user main routine
	umain(argc, argv);
  8003c6:	83 ec 08             	sub    $0x8,%esp
  8003c9:	56                   	push   %esi
  8003ca:	53                   	push   %ebx
  8003cb:	e8 8e fc ff ff       	call   80005e <umain>

	// exit gracefully
	exit();
  8003d0:	e8 0a 00 00 00       	call   8003df <exit>
}
  8003d5:	83 c4 10             	add    $0x10,%esp
  8003d8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8003db:	5b                   	pop    %ebx
  8003dc:	5e                   	pop    %esi
  8003dd:	5d                   	pop    %ebp
  8003de:	c3                   	ret    

008003df <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8003df:	55                   	push   %ebp
  8003e0:	89 e5                	mov    %esp,%ebp
  8003e2:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  8003e5:	6a 00                	push   $0x0
  8003e7:	e8 79 0b 00 00       	call   800f65 <sys_env_destroy>
}
  8003ec:	83 c4 10             	add    $0x10,%esp
  8003ef:	c9                   	leave  
  8003f0:	c3                   	ret    

008003f1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8003f1:	55                   	push   %ebp
  8003f2:	89 e5                	mov    %esp,%ebp
  8003f4:	56                   	push   %esi
  8003f5:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8003f6:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8003f9:	8b 35 8c 47 80 00    	mov    0x80478c,%esi
  8003ff:	e8 a2 0b 00 00       	call   800fa6 <sys_getenvid>
  800404:	83 ec 0c             	sub    $0xc,%esp
  800407:	ff 75 0c             	pushl  0xc(%ebp)
  80040a:	ff 75 08             	pushl  0x8(%ebp)
  80040d:	56                   	push   %esi
  80040e:	50                   	push   %eax
  80040f:	68 ac 27 80 00       	push   $0x8027ac
  800414:	e8 b3 00 00 00       	call   8004cc <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800419:	83 c4 18             	add    $0x18,%esp
  80041c:	53                   	push   %ebx
  80041d:	ff 75 10             	pushl  0x10(%ebp)
  800420:	e8 56 00 00 00       	call   80047b <vcprintf>
	cprintf("\n");
  800425:	c7 04 24 00 2d 80 00 	movl   $0x802d00,(%esp)
  80042c:	e8 9b 00 00 00       	call   8004cc <cprintf>
  800431:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800434:	cc                   	int3   
  800435:	eb fd                	jmp    800434 <_panic+0x43>

00800437 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800437:	55                   	push   %ebp
  800438:	89 e5                	mov    %esp,%ebp
  80043a:	53                   	push   %ebx
  80043b:	83 ec 04             	sub    $0x4,%esp
  80043e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800441:	8b 13                	mov    (%ebx),%edx
  800443:	8d 42 01             	lea    0x1(%edx),%eax
  800446:	89 03                	mov    %eax,(%ebx)
  800448:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80044b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80044f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800454:	74 09                	je     80045f <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800456:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80045a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80045d:	c9                   	leave  
  80045e:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80045f:	83 ec 08             	sub    $0x8,%esp
  800462:	68 ff 00 00 00       	push   $0xff
  800467:	8d 43 08             	lea    0x8(%ebx),%eax
  80046a:	50                   	push   %eax
  80046b:	e8 b8 0a 00 00       	call   800f28 <sys_cputs>
		b->idx = 0;
  800470:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800476:	83 c4 10             	add    $0x10,%esp
  800479:	eb db                	jmp    800456 <putch+0x1f>

0080047b <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80047b:	55                   	push   %ebp
  80047c:	89 e5                	mov    %esp,%ebp
  80047e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800484:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80048b:	00 00 00 
	b.cnt = 0;
  80048e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800495:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800498:	ff 75 0c             	pushl  0xc(%ebp)
  80049b:	ff 75 08             	pushl  0x8(%ebp)
  80049e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004a4:	50                   	push   %eax
  8004a5:	68 37 04 80 00       	push   $0x800437
  8004aa:	e8 4a 01 00 00       	call   8005f9 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8004af:	83 c4 08             	add    $0x8,%esp
  8004b2:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8004b8:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8004be:	50                   	push   %eax
  8004bf:	e8 64 0a 00 00       	call   800f28 <sys_cputs>

	return b.cnt;
}
  8004c4:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8004ca:	c9                   	leave  
  8004cb:	c3                   	ret    

008004cc <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8004cc:	55                   	push   %ebp
  8004cd:	89 e5                	mov    %esp,%ebp
  8004cf:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8004d2:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8004d5:	50                   	push   %eax
  8004d6:	ff 75 08             	pushl  0x8(%ebp)
  8004d9:	e8 9d ff ff ff       	call   80047b <vcprintf>
	va_end(ap);

	return cnt;
}
  8004de:	c9                   	leave  
  8004df:	c3                   	ret    

008004e0 <printnum>:


static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004e0:	55                   	push   %ebp
  8004e1:	89 e5                	mov    %esp,%ebp
  8004e3:	57                   	push   %edi
  8004e4:	56                   	push   %esi
  8004e5:	53                   	push   %ebx
  8004e6:	83 ec 1c             	sub    $0x1c,%esp
  8004e9:	89 c6                	mov    %eax,%esi
  8004eb:	89 d7                	mov    %edx,%edi
  8004ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004f3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004f6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8004f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8004fc:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	// to support '-'
	if(padc == '-'){
  8004ff:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800503:	74 2c                	je     800531 <printnum+0x51>
		while (--width > 0)
			putch(' ', putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800505:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800508:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80050f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800512:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800515:	39 c2                	cmp    %eax,%edx
  800517:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80051a:	73 43                	jae    80055f <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80051c:	83 eb 01             	sub    $0x1,%ebx
  80051f:	85 db                	test   %ebx,%ebx
  800521:	7e 6c                	jle    80058f <printnum+0xaf>
			putch(padc, putdat);
  800523:	83 ec 08             	sub    $0x8,%esp
  800526:	57                   	push   %edi
  800527:	ff 75 18             	pushl  0x18(%ebp)
  80052a:	ff d6                	call   *%esi
  80052c:	83 c4 10             	add    $0x10,%esp
  80052f:	eb eb                	jmp    80051c <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800531:	83 ec 0c             	sub    $0xc,%esp
  800534:	6a 20                	push   $0x20
  800536:	6a 00                	push   $0x0
  800538:	50                   	push   %eax
  800539:	ff 75 e4             	pushl  -0x1c(%ebp)
  80053c:	ff 75 e0             	pushl  -0x20(%ebp)
  80053f:	89 fa                	mov    %edi,%edx
  800541:	89 f0                	mov    %esi,%eax
  800543:	e8 98 ff ff ff       	call   8004e0 <printnum>
		while (--width > 0)
  800548:	83 c4 20             	add    $0x20,%esp
  80054b:	83 eb 01             	sub    $0x1,%ebx
  80054e:	85 db                	test   %ebx,%ebx
  800550:	7e 65                	jle    8005b7 <printnum+0xd7>
			putch(' ', putdat);
  800552:	83 ec 08             	sub    $0x8,%esp
  800555:	57                   	push   %edi
  800556:	6a 20                	push   $0x20
  800558:	ff d6                	call   *%esi
  80055a:	83 c4 10             	add    $0x10,%esp
  80055d:	eb ec                	jmp    80054b <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80055f:	83 ec 0c             	sub    $0xc,%esp
  800562:	ff 75 18             	pushl  0x18(%ebp)
  800565:	83 eb 01             	sub    $0x1,%ebx
  800568:	53                   	push   %ebx
  800569:	50                   	push   %eax
  80056a:	83 ec 08             	sub    $0x8,%esp
  80056d:	ff 75 dc             	pushl  -0x24(%ebp)
  800570:	ff 75 d8             	pushl  -0x28(%ebp)
  800573:	ff 75 e4             	pushl  -0x1c(%ebp)
  800576:	ff 75 e0             	pushl  -0x20(%ebp)
  800579:	e8 92 1e 00 00       	call   802410 <__udivdi3>
  80057e:	83 c4 18             	add    $0x18,%esp
  800581:	52                   	push   %edx
  800582:	50                   	push   %eax
  800583:	89 fa                	mov    %edi,%edx
  800585:	89 f0                	mov    %esi,%eax
  800587:	e8 54 ff ff ff       	call   8004e0 <printnum>
  80058c:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80058f:	83 ec 08             	sub    $0x8,%esp
  800592:	57                   	push   %edi
  800593:	83 ec 04             	sub    $0x4,%esp
  800596:	ff 75 dc             	pushl  -0x24(%ebp)
  800599:	ff 75 d8             	pushl  -0x28(%ebp)
  80059c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80059f:	ff 75 e0             	pushl  -0x20(%ebp)
  8005a2:	e8 79 1f 00 00       	call   802520 <__umoddi3>
  8005a7:	83 c4 14             	add    $0x14,%esp
  8005aa:	0f be 80 cf 27 80 00 	movsbl 0x8027cf(%eax),%eax
  8005b1:	50                   	push   %eax
  8005b2:	ff d6                	call   *%esi
  8005b4:	83 c4 10             	add    $0x10,%esp
}
  8005b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005ba:	5b                   	pop    %ebx
  8005bb:	5e                   	pop    %esi
  8005bc:	5f                   	pop    %edi
  8005bd:	5d                   	pop    %ebp
  8005be:	c3                   	ret    

008005bf <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8005bf:	55                   	push   %ebp
  8005c0:	89 e5                	mov    %esp,%ebp
  8005c2:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8005c5:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8005c9:	8b 10                	mov    (%eax),%edx
  8005cb:	3b 50 04             	cmp    0x4(%eax),%edx
  8005ce:	73 0a                	jae    8005da <sprintputch+0x1b>
		*b->buf++ = ch;
  8005d0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8005d3:	89 08                	mov    %ecx,(%eax)
  8005d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d8:	88 02                	mov    %al,(%edx)
}
  8005da:	5d                   	pop    %ebp
  8005db:	c3                   	ret    

008005dc <printfmt>:
{
  8005dc:	55                   	push   %ebp
  8005dd:	89 e5                	mov    %esp,%ebp
  8005df:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8005e2:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8005e5:	50                   	push   %eax
  8005e6:	ff 75 10             	pushl  0x10(%ebp)
  8005e9:	ff 75 0c             	pushl  0xc(%ebp)
  8005ec:	ff 75 08             	pushl  0x8(%ebp)
  8005ef:	e8 05 00 00 00       	call   8005f9 <vprintfmt>
}
  8005f4:	83 c4 10             	add    $0x10,%esp
  8005f7:	c9                   	leave  
  8005f8:	c3                   	ret    

008005f9 <vprintfmt>:
{
  8005f9:	55                   	push   %ebp
  8005fa:	89 e5                	mov    %esp,%ebp
  8005fc:	57                   	push   %edi
  8005fd:	56                   	push   %esi
  8005fe:	53                   	push   %ebx
  8005ff:	83 ec 3c             	sub    $0x3c,%esp
  800602:	8b 75 08             	mov    0x8(%ebp),%esi
  800605:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800608:	8b 7d 10             	mov    0x10(%ebp),%edi
  80060b:	e9 1e 04 00 00       	jmp    800a2e <vprintfmt+0x435>
		posflag = 0;
  800610:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
		padc = ' ';
  800617:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80061b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800622:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800629:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800630:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  800637:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80063c:	8d 47 01             	lea    0x1(%edi),%eax
  80063f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800642:	0f b6 17             	movzbl (%edi),%edx
  800645:	8d 42 dd             	lea    -0x23(%edx),%eax
  800648:	3c 55                	cmp    $0x55,%al
  80064a:	0f 87 d9 04 00 00    	ja     800b29 <vprintfmt+0x530>
  800650:	0f b6 c0             	movzbl %al,%eax
  800653:	ff 24 85 a0 29 80 00 	jmp    *0x8029a0(,%eax,4)
  80065a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80065d:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800661:	eb d9                	jmp    80063c <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800663:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posflag = 1;
  800666:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  80066d:	eb cd                	jmp    80063c <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80066f:	0f b6 d2             	movzbl %dl,%edx
  800672:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800675:	b8 00 00 00 00       	mov    $0x0,%eax
  80067a:	89 75 08             	mov    %esi,0x8(%ebp)
  80067d:	eb 0c                	jmp    80068b <vprintfmt+0x92>
		switch (ch = *(unsigned char *) fmt++) {
  80067f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800682:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  800686:	eb b4                	jmp    80063c <vprintfmt+0x43>
			for (precision = 0; ; ++fmt) {
  800688:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80068b:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80068e:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800692:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800695:	8d 72 d0             	lea    -0x30(%edx),%esi
  800698:	83 fe 09             	cmp    $0x9,%esi
  80069b:	76 eb                	jbe    800688 <vprintfmt+0x8f>
  80069d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006a0:	8b 75 08             	mov    0x8(%ebp),%esi
  8006a3:	eb 14                	jmp    8006b9 <vprintfmt+0xc0>
			precision = va_arg(ap, int);
  8006a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a8:	8b 00                	mov    (%eax),%eax
  8006aa:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b0:	8d 40 04             	lea    0x4(%eax),%eax
  8006b3:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006b6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8006b9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006bd:	0f 89 79 ff ff ff    	jns    80063c <vprintfmt+0x43>
				width = precision, precision = -1;
  8006c3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006c9:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8006d0:	e9 67 ff ff ff       	jmp    80063c <vprintfmt+0x43>
  8006d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006d8:	85 c0                	test   %eax,%eax
  8006da:	0f 48 c1             	cmovs  %ecx,%eax
  8006dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006e0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8006e3:	e9 54 ff ff ff       	jmp    80063c <vprintfmt+0x43>
  8006e8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8006eb:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8006f2:	e9 45 ff ff ff       	jmp    80063c <vprintfmt+0x43>
			lflag++;
  8006f7:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006fb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8006fe:	e9 39 ff ff ff       	jmp    80063c <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800703:	8b 45 14             	mov    0x14(%ebp),%eax
  800706:	8d 78 04             	lea    0x4(%eax),%edi
  800709:	83 ec 08             	sub    $0x8,%esp
  80070c:	53                   	push   %ebx
  80070d:	ff 30                	pushl  (%eax)
  80070f:	ff d6                	call   *%esi
			break;
  800711:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800714:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800717:	e9 0f 03 00 00       	jmp    800a2b <vprintfmt+0x432>
			err = va_arg(ap, int);
  80071c:	8b 45 14             	mov    0x14(%ebp),%eax
  80071f:	8d 78 04             	lea    0x4(%eax),%edi
  800722:	8b 00                	mov    (%eax),%eax
  800724:	99                   	cltd   
  800725:	31 d0                	xor    %edx,%eax
  800727:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800729:	83 f8 0f             	cmp    $0xf,%eax
  80072c:	7f 23                	jg     800751 <vprintfmt+0x158>
  80072e:	8b 14 85 00 2b 80 00 	mov    0x802b00(,%eax,4),%edx
  800735:	85 d2                	test   %edx,%edx
  800737:	74 18                	je     800751 <vprintfmt+0x158>
				printfmt(putch, putdat, "%s", p);
  800739:	52                   	push   %edx
  80073a:	68 3a 2c 80 00       	push   $0x802c3a
  80073f:	53                   	push   %ebx
  800740:	56                   	push   %esi
  800741:	e8 96 fe ff ff       	call   8005dc <printfmt>
  800746:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800749:	89 7d 14             	mov    %edi,0x14(%ebp)
  80074c:	e9 da 02 00 00       	jmp    800a2b <vprintfmt+0x432>
				printfmt(putch, putdat, "error %d", err);
  800751:	50                   	push   %eax
  800752:	68 e7 27 80 00       	push   $0x8027e7
  800757:	53                   	push   %ebx
  800758:	56                   	push   %esi
  800759:	e8 7e fe ff ff       	call   8005dc <printfmt>
  80075e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800761:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800764:	e9 c2 02 00 00       	jmp    800a2b <vprintfmt+0x432>
			if ((p = va_arg(ap, char *)) == NULL)
  800769:	8b 45 14             	mov    0x14(%ebp),%eax
  80076c:	83 c0 04             	add    $0x4,%eax
  80076f:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800772:	8b 45 14             	mov    0x14(%ebp),%eax
  800775:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800777:	85 c9                	test   %ecx,%ecx
  800779:	b8 e0 27 80 00       	mov    $0x8027e0,%eax
  80077e:	0f 45 c1             	cmovne %ecx,%eax
  800781:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800784:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800788:	7e 06                	jle    800790 <vprintfmt+0x197>
  80078a:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80078e:	75 0d                	jne    80079d <vprintfmt+0x1a4>
				for (width -= strnlen(p, precision); width > 0; width--)
  800790:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800793:	89 c7                	mov    %eax,%edi
  800795:	03 45 e0             	add    -0x20(%ebp),%eax
  800798:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80079b:	eb 53                	jmp    8007f0 <vprintfmt+0x1f7>
  80079d:	83 ec 08             	sub    $0x8,%esp
  8007a0:	ff 75 d8             	pushl  -0x28(%ebp)
  8007a3:	50                   	push   %eax
  8007a4:	e8 28 04 00 00       	call   800bd1 <strnlen>
  8007a9:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8007ac:	29 c1                	sub    %eax,%ecx
  8007ae:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  8007b1:	83 c4 10             	add    $0x10,%esp
  8007b4:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8007b6:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8007ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8007bd:	eb 0f                	jmp    8007ce <vprintfmt+0x1d5>
					putch(padc, putdat);
  8007bf:	83 ec 08             	sub    $0x8,%esp
  8007c2:	53                   	push   %ebx
  8007c3:	ff 75 e0             	pushl  -0x20(%ebp)
  8007c6:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8007c8:	83 ef 01             	sub    $0x1,%edi
  8007cb:	83 c4 10             	add    $0x10,%esp
  8007ce:	85 ff                	test   %edi,%edi
  8007d0:	7f ed                	jg     8007bf <vprintfmt+0x1c6>
  8007d2:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  8007d5:	85 c9                	test   %ecx,%ecx
  8007d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8007dc:	0f 49 c1             	cmovns %ecx,%eax
  8007df:	29 c1                	sub    %eax,%ecx
  8007e1:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8007e4:	eb aa                	jmp    800790 <vprintfmt+0x197>
					putch(ch, putdat);
  8007e6:	83 ec 08             	sub    $0x8,%esp
  8007e9:	53                   	push   %ebx
  8007ea:	52                   	push   %edx
  8007eb:	ff d6                	call   *%esi
  8007ed:	83 c4 10             	add    $0x10,%esp
  8007f0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8007f3:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007f5:	83 c7 01             	add    $0x1,%edi
  8007f8:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007fc:	0f be d0             	movsbl %al,%edx
  8007ff:	85 d2                	test   %edx,%edx
  800801:	74 4b                	je     80084e <vprintfmt+0x255>
  800803:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800807:	78 06                	js     80080f <vprintfmt+0x216>
  800809:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80080d:	78 1e                	js     80082d <vprintfmt+0x234>
				if (altflag && (ch < ' ' || ch > '~'))
  80080f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800813:	74 d1                	je     8007e6 <vprintfmt+0x1ed>
  800815:	0f be c0             	movsbl %al,%eax
  800818:	83 e8 20             	sub    $0x20,%eax
  80081b:	83 f8 5e             	cmp    $0x5e,%eax
  80081e:	76 c6                	jbe    8007e6 <vprintfmt+0x1ed>
					putch('?', putdat);
  800820:	83 ec 08             	sub    $0x8,%esp
  800823:	53                   	push   %ebx
  800824:	6a 3f                	push   $0x3f
  800826:	ff d6                	call   *%esi
  800828:	83 c4 10             	add    $0x10,%esp
  80082b:	eb c3                	jmp    8007f0 <vprintfmt+0x1f7>
  80082d:	89 cf                	mov    %ecx,%edi
  80082f:	eb 0e                	jmp    80083f <vprintfmt+0x246>
				putch(' ', putdat);
  800831:	83 ec 08             	sub    $0x8,%esp
  800834:	53                   	push   %ebx
  800835:	6a 20                	push   $0x20
  800837:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800839:	83 ef 01             	sub    $0x1,%edi
  80083c:	83 c4 10             	add    $0x10,%esp
  80083f:	85 ff                	test   %edi,%edi
  800841:	7f ee                	jg     800831 <vprintfmt+0x238>
			if ((p = va_arg(ap, char *)) == NULL)
  800843:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800846:	89 45 14             	mov    %eax,0x14(%ebp)
  800849:	e9 dd 01 00 00       	jmp    800a2b <vprintfmt+0x432>
  80084e:	89 cf                	mov    %ecx,%edi
  800850:	eb ed                	jmp    80083f <vprintfmt+0x246>
	if (lflag >= 2)
  800852:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800856:	7f 21                	jg     800879 <vprintfmt+0x280>
	else if (lflag)
  800858:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80085c:	74 6a                	je     8008c8 <vprintfmt+0x2cf>
		return va_arg(*ap, long);
  80085e:	8b 45 14             	mov    0x14(%ebp),%eax
  800861:	8b 00                	mov    (%eax),%eax
  800863:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800866:	89 c1                	mov    %eax,%ecx
  800868:	c1 f9 1f             	sar    $0x1f,%ecx
  80086b:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80086e:	8b 45 14             	mov    0x14(%ebp),%eax
  800871:	8d 40 04             	lea    0x4(%eax),%eax
  800874:	89 45 14             	mov    %eax,0x14(%ebp)
  800877:	eb 17                	jmp    800890 <vprintfmt+0x297>
		return va_arg(*ap, long long);
  800879:	8b 45 14             	mov    0x14(%ebp),%eax
  80087c:	8b 50 04             	mov    0x4(%eax),%edx
  80087f:	8b 00                	mov    (%eax),%eax
  800881:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800884:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800887:	8b 45 14             	mov    0x14(%ebp),%eax
  80088a:	8d 40 08             	lea    0x8(%eax),%eax
  80088d:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800890:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  800893:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800898:	85 d2                	test   %edx,%edx
  80089a:	0f 89 5c 01 00 00    	jns    8009fc <vprintfmt+0x403>
				putch('-', putdat);
  8008a0:	83 ec 08             	sub    $0x8,%esp
  8008a3:	53                   	push   %ebx
  8008a4:	6a 2d                	push   $0x2d
  8008a6:	ff d6                	call   *%esi
				num = -(long long) num;
  8008a8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008ab:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8008ae:	f7 d8                	neg    %eax
  8008b0:	83 d2 00             	adc    $0x0,%edx
  8008b3:	f7 da                	neg    %edx
  8008b5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008b8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008bb:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8008be:	bf 0a 00 00 00       	mov    $0xa,%edi
  8008c3:	e9 45 01 00 00       	jmp    800a0d <vprintfmt+0x414>
		return va_arg(*ap, int);
  8008c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cb:	8b 00                	mov    (%eax),%eax
  8008cd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008d0:	89 c1                	mov    %eax,%ecx
  8008d2:	c1 f9 1f             	sar    $0x1f,%ecx
  8008d5:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8008d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008db:	8d 40 04             	lea    0x4(%eax),%eax
  8008de:	89 45 14             	mov    %eax,0x14(%ebp)
  8008e1:	eb ad                	jmp    800890 <vprintfmt+0x297>
	if (lflag >= 2)
  8008e3:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8008e7:	7f 29                	jg     800912 <vprintfmt+0x319>
	else if (lflag)
  8008e9:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8008ed:	74 44                	je     800933 <vprintfmt+0x33a>
		return va_arg(*ap, unsigned long);
  8008ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f2:	8b 00                	mov    (%eax),%eax
  8008f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8008f9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008fc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800902:	8d 40 04             	lea    0x4(%eax),%eax
  800905:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800908:	bf 0a 00 00 00       	mov    $0xa,%edi
  80090d:	e9 ea 00 00 00       	jmp    8009fc <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  800912:	8b 45 14             	mov    0x14(%ebp),%eax
  800915:	8b 50 04             	mov    0x4(%eax),%edx
  800918:	8b 00                	mov    (%eax),%eax
  80091a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80091d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800920:	8b 45 14             	mov    0x14(%ebp),%eax
  800923:	8d 40 08             	lea    0x8(%eax),%eax
  800926:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800929:	bf 0a 00 00 00       	mov    $0xa,%edi
  80092e:	e9 c9 00 00 00       	jmp    8009fc <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  800933:	8b 45 14             	mov    0x14(%ebp),%eax
  800936:	8b 00                	mov    (%eax),%eax
  800938:	ba 00 00 00 00       	mov    $0x0,%edx
  80093d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800940:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800943:	8b 45 14             	mov    0x14(%ebp),%eax
  800946:	8d 40 04             	lea    0x4(%eax),%eax
  800949:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80094c:	bf 0a 00 00 00       	mov    $0xa,%edi
  800951:	e9 a6 00 00 00       	jmp    8009fc <vprintfmt+0x403>
			putch('0', putdat);
  800956:	83 ec 08             	sub    $0x8,%esp
  800959:	53                   	push   %ebx
  80095a:	6a 30                	push   $0x30
  80095c:	ff d6                	call   *%esi
	if (lflag >= 2)
  80095e:	83 c4 10             	add    $0x10,%esp
  800961:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800965:	7f 26                	jg     80098d <vprintfmt+0x394>
	else if (lflag)
  800967:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80096b:	74 3e                	je     8009ab <vprintfmt+0x3b2>
		return va_arg(*ap, unsigned long);
  80096d:	8b 45 14             	mov    0x14(%ebp),%eax
  800970:	8b 00                	mov    (%eax),%eax
  800972:	ba 00 00 00 00       	mov    $0x0,%edx
  800977:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80097a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80097d:	8b 45 14             	mov    0x14(%ebp),%eax
  800980:	8d 40 04             	lea    0x4(%eax),%eax
  800983:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800986:	bf 08 00 00 00       	mov    $0x8,%edi
  80098b:	eb 6f                	jmp    8009fc <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  80098d:	8b 45 14             	mov    0x14(%ebp),%eax
  800990:	8b 50 04             	mov    0x4(%eax),%edx
  800993:	8b 00                	mov    (%eax),%eax
  800995:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800998:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80099b:	8b 45 14             	mov    0x14(%ebp),%eax
  80099e:	8d 40 08             	lea    0x8(%eax),%eax
  8009a1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8009a4:	bf 08 00 00 00       	mov    $0x8,%edi
  8009a9:	eb 51                	jmp    8009fc <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  8009ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ae:	8b 00                	mov    (%eax),%eax
  8009b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8009b5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009b8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8009be:	8d 40 04             	lea    0x4(%eax),%eax
  8009c1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8009c4:	bf 08 00 00 00       	mov    $0x8,%edi
  8009c9:	eb 31                	jmp    8009fc <vprintfmt+0x403>
			putch('0', putdat);
  8009cb:	83 ec 08             	sub    $0x8,%esp
  8009ce:	53                   	push   %ebx
  8009cf:	6a 30                	push   $0x30
  8009d1:	ff d6                	call   *%esi
			putch('x', putdat);
  8009d3:	83 c4 08             	add    $0x8,%esp
  8009d6:	53                   	push   %ebx
  8009d7:	6a 78                	push   $0x78
  8009d9:	ff d6                	call   *%esi
			num = (unsigned long long)
  8009db:	8b 45 14             	mov    0x14(%ebp),%eax
  8009de:	8b 00                	mov    (%eax),%eax
  8009e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8009e5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009e8:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8009eb:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8009ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f1:	8d 40 04             	lea    0x4(%eax),%eax
  8009f4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009f7:	bf 10 00 00 00       	mov    $0x10,%edi
			if(posflag)
  8009fc:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800a00:	74 0b                	je     800a0d <vprintfmt+0x414>
				putch('+', putdat);
  800a02:	83 ec 08             	sub    $0x8,%esp
  800a05:	53                   	push   %ebx
  800a06:	6a 2b                	push   $0x2b
  800a08:	ff d6                	call   *%esi
  800a0a:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  800a0d:	83 ec 0c             	sub    $0xc,%esp
  800a10:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800a14:	50                   	push   %eax
  800a15:	ff 75 e0             	pushl  -0x20(%ebp)
  800a18:	57                   	push   %edi
  800a19:	ff 75 dc             	pushl  -0x24(%ebp)
  800a1c:	ff 75 d8             	pushl  -0x28(%ebp)
  800a1f:	89 da                	mov    %ebx,%edx
  800a21:	89 f0                	mov    %esi,%eax
  800a23:	e8 b8 fa ff ff       	call   8004e0 <printnum>
			break;
  800a28:	83 c4 20             	add    $0x20,%esp
			char* cp = va_arg(ap, char *);
  800a2b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a2e:	83 c7 01             	add    $0x1,%edi
  800a31:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800a35:	83 f8 25             	cmp    $0x25,%eax
  800a38:	0f 84 d2 fb ff ff    	je     800610 <vprintfmt+0x17>
			if (ch == '\0')
  800a3e:	85 c0                	test   %eax,%eax
  800a40:	0f 84 03 01 00 00    	je     800b49 <vprintfmt+0x550>
			putch(ch, putdat);
  800a46:	83 ec 08             	sub    $0x8,%esp
  800a49:	53                   	push   %ebx
  800a4a:	50                   	push   %eax
  800a4b:	ff d6                	call   *%esi
  800a4d:	83 c4 10             	add    $0x10,%esp
  800a50:	eb dc                	jmp    800a2e <vprintfmt+0x435>
	if (lflag >= 2)
  800a52:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800a56:	7f 29                	jg     800a81 <vprintfmt+0x488>
	else if (lflag)
  800a58:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800a5c:	74 44                	je     800aa2 <vprintfmt+0x4a9>
		return va_arg(*ap, unsigned long);
  800a5e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a61:	8b 00                	mov    (%eax),%eax
  800a63:	ba 00 00 00 00       	mov    $0x0,%edx
  800a68:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a6b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a6e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a71:	8d 40 04             	lea    0x4(%eax),%eax
  800a74:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a77:	bf 10 00 00 00       	mov    $0x10,%edi
  800a7c:	e9 7b ff ff ff       	jmp    8009fc <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  800a81:	8b 45 14             	mov    0x14(%ebp),%eax
  800a84:	8b 50 04             	mov    0x4(%eax),%edx
  800a87:	8b 00                	mov    (%eax),%eax
  800a89:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a8c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a8f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a92:	8d 40 08             	lea    0x8(%eax),%eax
  800a95:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a98:	bf 10 00 00 00       	mov    $0x10,%edi
  800a9d:	e9 5a ff ff ff       	jmp    8009fc <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  800aa2:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa5:	8b 00                	mov    (%eax),%eax
  800aa7:	ba 00 00 00 00       	mov    $0x0,%edx
  800aac:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800aaf:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ab2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab5:	8d 40 04             	lea    0x4(%eax),%eax
  800ab8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800abb:	bf 10 00 00 00       	mov    $0x10,%edi
  800ac0:	e9 37 ff ff ff       	jmp    8009fc <vprintfmt+0x403>
			char* cp = va_arg(ap, char *);
  800ac5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac8:	8d 78 04             	lea    0x4(%eax),%edi
  800acb:	8b 00                	mov    (%eax),%eax
    			if (cp == NULL) {
  800acd:	85 c0                	test   %eax,%eax
  800acf:	74 2c                	je     800afd <vprintfmt+0x504>
    			*cp = *(int *)putdat;
  800ad1:	8b 13                	mov    (%ebx),%edx
  800ad3:	88 10                	mov    %dl,(%eax)
			char* cp = va_arg(ap, char *);
  800ad5:	89 7d 14             	mov    %edi,0x14(%ebp)
    			if ((*(int *) putdat) > 127)
  800ad8:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  800adb:	0f 8e 4a ff ff ff    	jle    800a2b <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", overflow_error);
  800ae1:	68 3c 29 80 00       	push   $0x80293c
  800ae6:	68 3a 2c 80 00       	push   $0x802c3a
  800aeb:	53                   	push   %ebx
  800aec:	56                   	push   %esi
  800aed:	e8 ea fa ff ff       	call   8005dc <printfmt>
  800af2:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  800af5:	89 7d 14             	mov    %edi,0x14(%ebp)
  800af8:	e9 2e ff ff ff       	jmp    800a2b <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", null_error);
  800afd:	68 04 29 80 00       	push   $0x802904
  800b02:	68 3a 2c 80 00       	push   $0x802c3a
  800b07:	53                   	push   %ebx
  800b08:	56                   	push   %esi
  800b09:	e8 ce fa ff ff       	call   8005dc <printfmt>
        		break;
  800b0e:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  800b11:	89 7d 14             	mov    %edi,0x14(%ebp)
        		break;
  800b14:	e9 12 ff ff ff       	jmp    800a2b <vprintfmt+0x432>
			putch(ch, putdat);
  800b19:	83 ec 08             	sub    $0x8,%esp
  800b1c:	53                   	push   %ebx
  800b1d:	6a 25                	push   $0x25
  800b1f:	ff d6                	call   *%esi
			break;
  800b21:	83 c4 10             	add    $0x10,%esp
  800b24:	e9 02 ff ff ff       	jmp    800a2b <vprintfmt+0x432>
			putch('%', putdat);
  800b29:	83 ec 08             	sub    $0x8,%esp
  800b2c:	53                   	push   %ebx
  800b2d:	6a 25                	push   $0x25
  800b2f:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b31:	83 c4 10             	add    $0x10,%esp
  800b34:	89 f8                	mov    %edi,%eax
  800b36:	eb 03                	jmp    800b3b <vprintfmt+0x542>
  800b38:	83 e8 01             	sub    $0x1,%eax
  800b3b:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800b3f:	75 f7                	jne    800b38 <vprintfmt+0x53f>
  800b41:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b44:	e9 e2 fe ff ff       	jmp    800a2b <vprintfmt+0x432>
}
  800b49:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b4c:	5b                   	pop    %ebx
  800b4d:	5e                   	pop    %esi
  800b4e:	5f                   	pop    %edi
  800b4f:	5d                   	pop    %ebp
  800b50:	c3                   	ret    

00800b51 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b51:	55                   	push   %ebp
  800b52:	89 e5                	mov    %esp,%ebp
  800b54:	83 ec 18             	sub    $0x18,%esp
  800b57:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5a:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b5d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b60:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800b64:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800b67:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b6e:	85 c0                	test   %eax,%eax
  800b70:	74 26                	je     800b98 <vsnprintf+0x47>
  800b72:	85 d2                	test   %edx,%edx
  800b74:	7e 22                	jle    800b98 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b76:	ff 75 14             	pushl  0x14(%ebp)
  800b79:	ff 75 10             	pushl  0x10(%ebp)
  800b7c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b7f:	50                   	push   %eax
  800b80:	68 bf 05 80 00       	push   $0x8005bf
  800b85:	e8 6f fa ff ff       	call   8005f9 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800b8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b8d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b93:	83 c4 10             	add    $0x10,%esp
}
  800b96:	c9                   	leave  
  800b97:	c3                   	ret    
		return -E_INVAL;
  800b98:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b9d:	eb f7                	jmp    800b96 <vsnprintf+0x45>

00800b9f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b9f:	55                   	push   %ebp
  800ba0:	89 e5                	mov    %esp,%ebp
  800ba2:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ba5:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800ba8:	50                   	push   %eax
  800ba9:	ff 75 10             	pushl  0x10(%ebp)
  800bac:	ff 75 0c             	pushl  0xc(%ebp)
  800baf:	ff 75 08             	pushl  0x8(%ebp)
  800bb2:	e8 9a ff ff ff       	call   800b51 <vsnprintf>
	va_end(ap);

	return rc;
}
  800bb7:	c9                   	leave  
  800bb8:	c3                   	ret    

00800bb9 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800bb9:	55                   	push   %ebp
  800bba:	89 e5                	mov    %esp,%ebp
  800bbc:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800bbf:	b8 00 00 00 00       	mov    $0x0,%eax
  800bc4:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800bc8:	74 05                	je     800bcf <strlen+0x16>
		n++;
  800bca:	83 c0 01             	add    $0x1,%eax
  800bcd:	eb f5                	jmp    800bc4 <strlen+0xb>
	return n;
}
  800bcf:	5d                   	pop    %ebp
  800bd0:	c3                   	ret    

00800bd1 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800bd1:	55                   	push   %ebp
  800bd2:	89 e5                	mov    %esp,%ebp
  800bd4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bd7:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bda:	ba 00 00 00 00       	mov    $0x0,%edx
  800bdf:	39 c2                	cmp    %eax,%edx
  800be1:	74 0d                	je     800bf0 <strnlen+0x1f>
  800be3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800be7:	74 05                	je     800bee <strnlen+0x1d>
		n++;
  800be9:	83 c2 01             	add    $0x1,%edx
  800bec:	eb f1                	jmp    800bdf <strnlen+0xe>
  800bee:	89 d0                	mov    %edx,%eax
	return n;
}
  800bf0:	5d                   	pop    %ebp
  800bf1:	c3                   	ret    

00800bf2 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bf2:	55                   	push   %ebp
  800bf3:	89 e5                	mov    %esp,%ebp
  800bf5:	53                   	push   %ebx
  800bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800bfc:	ba 00 00 00 00       	mov    $0x0,%edx
  800c01:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800c05:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800c08:	83 c2 01             	add    $0x1,%edx
  800c0b:	84 c9                	test   %cl,%cl
  800c0d:	75 f2                	jne    800c01 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800c0f:	5b                   	pop    %ebx
  800c10:	5d                   	pop    %ebp
  800c11:	c3                   	ret    

00800c12 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800c12:	55                   	push   %ebp
  800c13:	89 e5                	mov    %esp,%ebp
  800c15:	53                   	push   %ebx
  800c16:	83 ec 10             	sub    $0x10,%esp
  800c19:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800c1c:	53                   	push   %ebx
  800c1d:	e8 97 ff ff ff       	call   800bb9 <strlen>
  800c22:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800c25:	ff 75 0c             	pushl  0xc(%ebp)
  800c28:	01 d8                	add    %ebx,%eax
  800c2a:	50                   	push   %eax
  800c2b:	e8 c2 ff ff ff       	call   800bf2 <strcpy>
	return dst;
}
  800c30:	89 d8                	mov    %ebx,%eax
  800c32:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c35:	c9                   	leave  
  800c36:	c3                   	ret    

00800c37 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800c37:	55                   	push   %ebp
  800c38:	89 e5                	mov    %esp,%ebp
  800c3a:	56                   	push   %esi
  800c3b:	53                   	push   %ebx
  800c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c42:	89 c6                	mov    %eax,%esi
  800c44:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c47:	89 c2                	mov    %eax,%edx
  800c49:	39 f2                	cmp    %esi,%edx
  800c4b:	74 11                	je     800c5e <strncpy+0x27>
		*dst++ = *src;
  800c4d:	83 c2 01             	add    $0x1,%edx
  800c50:	0f b6 19             	movzbl (%ecx),%ebx
  800c53:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800c56:	80 fb 01             	cmp    $0x1,%bl
  800c59:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800c5c:	eb eb                	jmp    800c49 <strncpy+0x12>
	}
	return ret;
}
  800c5e:	5b                   	pop    %ebx
  800c5f:	5e                   	pop    %esi
  800c60:	5d                   	pop    %ebp
  800c61:	c3                   	ret    

00800c62 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800c62:	55                   	push   %ebp
  800c63:	89 e5                	mov    %esp,%ebp
  800c65:	56                   	push   %esi
  800c66:	53                   	push   %ebx
  800c67:	8b 75 08             	mov    0x8(%ebp),%esi
  800c6a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c6d:	8b 55 10             	mov    0x10(%ebp),%edx
  800c70:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800c72:	85 d2                	test   %edx,%edx
  800c74:	74 21                	je     800c97 <strlcpy+0x35>
  800c76:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800c7a:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800c7c:	39 c2                	cmp    %eax,%edx
  800c7e:	74 14                	je     800c94 <strlcpy+0x32>
  800c80:	0f b6 19             	movzbl (%ecx),%ebx
  800c83:	84 db                	test   %bl,%bl
  800c85:	74 0b                	je     800c92 <strlcpy+0x30>
			*dst++ = *src++;
  800c87:	83 c1 01             	add    $0x1,%ecx
  800c8a:	83 c2 01             	add    $0x1,%edx
  800c8d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800c90:	eb ea                	jmp    800c7c <strlcpy+0x1a>
  800c92:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800c94:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c97:	29 f0                	sub    %esi,%eax
}
  800c99:	5b                   	pop    %ebx
  800c9a:	5e                   	pop    %esi
  800c9b:	5d                   	pop    %ebp
  800c9c:	c3                   	ret    

00800c9d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c9d:	55                   	push   %ebp
  800c9e:	89 e5                	mov    %esp,%ebp
  800ca0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ca3:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800ca6:	0f b6 01             	movzbl (%ecx),%eax
  800ca9:	84 c0                	test   %al,%al
  800cab:	74 0c                	je     800cb9 <strcmp+0x1c>
  800cad:	3a 02                	cmp    (%edx),%al
  800caf:	75 08                	jne    800cb9 <strcmp+0x1c>
		p++, q++;
  800cb1:	83 c1 01             	add    $0x1,%ecx
  800cb4:	83 c2 01             	add    $0x1,%edx
  800cb7:	eb ed                	jmp    800ca6 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cb9:	0f b6 c0             	movzbl %al,%eax
  800cbc:	0f b6 12             	movzbl (%edx),%edx
  800cbf:	29 d0                	sub    %edx,%eax
}
  800cc1:	5d                   	pop    %ebp
  800cc2:	c3                   	ret    

00800cc3 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800cc3:	55                   	push   %ebp
  800cc4:	89 e5                	mov    %esp,%ebp
  800cc6:	53                   	push   %ebx
  800cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cca:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ccd:	89 c3                	mov    %eax,%ebx
  800ccf:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800cd2:	eb 06                	jmp    800cda <strncmp+0x17>
		n--, p++, q++;
  800cd4:	83 c0 01             	add    $0x1,%eax
  800cd7:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800cda:	39 d8                	cmp    %ebx,%eax
  800cdc:	74 16                	je     800cf4 <strncmp+0x31>
  800cde:	0f b6 08             	movzbl (%eax),%ecx
  800ce1:	84 c9                	test   %cl,%cl
  800ce3:	74 04                	je     800ce9 <strncmp+0x26>
  800ce5:	3a 0a                	cmp    (%edx),%cl
  800ce7:	74 eb                	je     800cd4 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ce9:	0f b6 00             	movzbl (%eax),%eax
  800cec:	0f b6 12             	movzbl (%edx),%edx
  800cef:	29 d0                	sub    %edx,%eax
}
  800cf1:	5b                   	pop    %ebx
  800cf2:	5d                   	pop    %ebp
  800cf3:	c3                   	ret    
		return 0;
  800cf4:	b8 00 00 00 00       	mov    $0x0,%eax
  800cf9:	eb f6                	jmp    800cf1 <strncmp+0x2e>

00800cfb <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800cfb:	55                   	push   %ebp
  800cfc:	89 e5                	mov    %esp,%ebp
  800cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800d01:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d05:	0f b6 10             	movzbl (%eax),%edx
  800d08:	84 d2                	test   %dl,%dl
  800d0a:	74 09                	je     800d15 <strchr+0x1a>
		if (*s == c)
  800d0c:	38 ca                	cmp    %cl,%dl
  800d0e:	74 0a                	je     800d1a <strchr+0x1f>
	for (; *s; s++)
  800d10:	83 c0 01             	add    $0x1,%eax
  800d13:	eb f0                	jmp    800d05 <strchr+0xa>
			return (char *) s;
	return 0;
  800d15:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d1a:	5d                   	pop    %ebp
  800d1b:	c3                   	ret    

00800d1c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d1c:	55                   	push   %ebp
  800d1d:	89 e5                	mov    %esp,%ebp
  800d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d22:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d26:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800d29:	38 ca                	cmp    %cl,%dl
  800d2b:	74 09                	je     800d36 <strfind+0x1a>
  800d2d:	84 d2                	test   %dl,%dl
  800d2f:	74 05                	je     800d36 <strfind+0x1a>
	for (; *s; s++)
  800d31:	83 c0 01             	add    $0x1,%eax
  800d34:	eb f0                	jmp    800d26 <strfind+0xa>
			break;
	return (char *) s;
}
  800d36:	5d                   	pop    %ebp
  800d37:	c3                   	ret    

00800d38 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800d38:	55                   	push   %ebp
  800d39:	89 e5                	mov    %esp,%ebp
  800d3b:	57                   	push   %edi
  800d3c:	56                   	push   %esi
  800d3d:	53                   	push   %ebx
  800d3e:	8b 7d 08             	mov    0x8(%ebp),%edi
  800d41:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800d44:	85 c9                	test   %ecx,%ecx
  800d46:	74 31                	je     800d79 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800d48:	89 f8                	mov    %edi,%eax
  800d4a:	09 c8                	or     %ecx,%eax
  800d4c:	a8 03                	test   $0x3,%al
  800d4e:	75 23                	jne    800d73 <memset+0x3b>
		c &= 0xFF;
  800d50:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800d54:	89 d3                	mov    %edx,%ebx
  800d56:	c1 e3 08             	shl    $0x8,%ebx
  800d59:	89 d0                	mov    %edx,%eax
  800d5b:	c1 e0 18             	shl    $0x18,%eax
  800d5e:	89 d6                	mov    %edx,%esi
  800d60:	c1 e6 10             	shl    $0x10,%esi
  800d63:	09 f0                	or     %esi,%eax
  800d65:	09 c2                	or     %eax,%edx
  800d67:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800d69:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800d6c:	89 d0                	mov    %edx,%eax
  800d6e:	fc                   	cld    
  800d6f:	f3 ab                	rep stos %eax,%es:(%edi)
  800d71:	eb 06                	jmp    800d79 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d76:	fc                   	cld    
  800d77:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800d79:	89 f8                	mov    %edi,%eax
  800d7b:	5b                   	pop    %ebx
  800d7c:	5e                   	pop    %esi
  800d7d:	5f                   	pop    %edi
  800d7e:	5d                   	pop    %ebp
  800d7f:	c3                   	ret    

00800d80 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800d80:	55                   	push   %ebp
  800d81:	89 e5                	mov    %esp,%ebp
  800d83:	57                   	push   %edi
  800d84:	56                   	push   %esi
  800d85:	8b 45 08             	mov    0x8(%ebp),%eax
  800d88:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d8b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d8e:	39 c6                	cmp    %eax,%esi
  800d90:	73 32                	jae    800dc4 <memmove+0x44>
  800d92:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800d95:	39 c2                	cmp    %eax,%edx
  800d97:	76 2b                	jbe    800dc4 <memmove+0x44>
		s += n;
		d += n;
  800d99:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d9c:	89 fe                	mov    %edi,%esi
  800d9e:	09 ce                	or     %ecx,%esi
  800da0:	09 d6                	or     %edx,%esi
  800da2:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800da8:	75 0e                	jne    800db8 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800daa:	83 ef 04             	sub    $0x4,%edi
  800dad:	8d 72 fc             	lea    -0x4(%edx),%esi
  800db0:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800db3:	fd                   	std    
  800db4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800db6:	eb 09                	jmp    800dc1 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800db8:	83 ef 01             	sub    $0x1,%edi
  800dbb:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800dbe:	fd                   	std    
  800dbf:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800dc1:	fc                   	cld    
  800dc2:	eb 1a                	jmp    800dde <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800dc4:	89 c2                	mov    %eax,%edx
  800dc6:	09 ca                	or     %ecx,%edx
  800dc8:	09 f2                	or     %esi,%edx
  800dca:	f6 c2 03             	test   $0x3,%dl
  800dcd:	75 0a                	jne    800dd9 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800dcf:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800dd2:	89 c7                	mov    %eax,%edi
  800dd4:	fc                   	cld    
  800dd5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800dd7:	eb 05                	jmp    800dde <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800dd9:	89 c7                	mov    %eax,%edi
  800ddb:	fc                   	cld    
  800ddc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800dde:	5e                   	pop    %esi
  800ddf:	5f                   	pop    %edi
  800de0:	5d                   	pop    %ebp
  800de1:	c3                   	ret    

00800de2 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800de2:	55                   	push   %ebp
  800de3:	89 e5                	mov    %esp,%ebp
  800de5:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800de8:	ff 75 10             	pushl  0x10(%ebp)
  800deb:	ff 75 0c             	pushl  0xc(%ebp)
  800dee:	ff 75 08             	pushl  0x8(%ebp)
  800df1:	e8 8a ff ff ff       	call   800d80 <memmove>
}
  800df6:	c9                   	leave  
  800df7:	c3                   	ret    

00800df8 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800df8:	55                   	push   %ebp
  800df9:	89 e5                	mov    %esp,%ebp
  800dfb:	56                   	push   %esi
  800dfc:	53                   	push   %ebx
  800dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800e00:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e03:	89 c6                	mov    %eax,%esi
  800e05:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e08:	39 f0                	cmp    %esi,%eax
  800e0a:	74 1c                	je     800e28 <memcmp+0x30>
		if (*s1 != *s2)
  800e0c:	0f b6 08             	movzbl (%eax),%ecx
  800e0f:	0f b6 1a             	movzbl (%edx),%ebx
  800e12:	38 d9                	cmp    %bl,%cl
  800e14:	75 08                	jne    800e1e <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800e16:	83 c0 01             	add    $0x1,%eax
  800e19:	83 c2 01             	add    $0x1,%edx
  800e1c:	eb ea                	jmp    800e08 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800e1e:	0f b6 c1             	movzbl %cl,%eax
  800e21:	0f b6 db             	movzbl %bl,%ebx
  800e24:	29 d8                	sub    %ebx,%eax
  800e26:	eb 05                	jmp    800e2d <memcmp+0x35>
	}

	return 0;
  800e28:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e2d:	5b                   	pop    %ebx
  800e2e:	5e                   	pop    %esi
  800e2f:	5d                   	pop    %ebp
  800e30:	c3                   	ret    

00800e31 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800e31:	55                   	push   %ebp
  800e32:	89 e5                	mov    %esp,%ebp
  800e34:	8b 45 08             	mov    0x8(%ebp),%eax
  800e37:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800e3a:	89 c2                	mov    %eax,%edx
  800e3c:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800e3f:	39 d0                	cmp    %edx,%eax
  800e41:	73 09                	jae    800e4c <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e43:	38 08                	cmp    %cl,(%eax)
  800e45:	74 05                	je     800e4c <memfind+0x1b>
	for (; s < ends; s++)
  800e47:	83 c0 01             	add    $0x1,%eax
  800e4a:	eb f3                	jmp    800e3f <memfind+0xe>
			break;
	return (void *) s;
}
  800e4c:	5d                   	pop    %ebp
  800e4d:	c3                   	ret    

00800e4e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e4e:	55                   	push   %ebp
  800e4f:	89 e5                	mov    %esp,%ebp
  800e51:	57                   	push   %edi
  800e52:	56                   	push   %esi
  800e53:	53                   	push   %ebx
  800e54:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e57:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e5a:	eb 03                	jmp    800e5f <strtol+0x11>
		s++;
  800e5c:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800e5f:	0f b6 01             	movzbl (%ecx),%eax
  800e62:	3c 20                	cmp    $0x20,%al
  800e64:	74 f6                	je     800e5c <strtol+0xe>
  800e66:	3c 09                	cmp    $0x9,%al
  800e68:	74 f2                	je     800e5c <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800e6a:	3c 2b                	cmp    $0x2b,%al
  800e6c:	74 2a                	je     800e98 <strtol+0x4a>
	int neg = 0;
  800e6e:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800e73:	3c 2d                	cmp    $0x2d,%al
  800e75:	74 2b                	je     800ea2 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e77:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800e7d:	75 0f                	jne    800e8e <strtol+0x40>
  800e7f:	80 39 30             	cmpb   $0x30,(%ecx)
  800e82:	74 28                	je     800eac <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800e84:	85 db                	test   %ebx,%ebx
  800e86:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e8b:	0f 44 d8             	cmove  %eax,%ebx
  800e8e:	b8 00 00 00 00       	mov    $0x0,%eax
  800e93:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800e96:	eb 50                	jmp    800ee8 <strtol+0x9a>
		s++;
  800e98:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800e9b:	bf 00 00 00 00       	mov    $0x0,%edi
  800ea0:	eb d5                	jmp    800e77 <strtol+0x29>
		s++, neg = 1;
  800ea2:	83 c1 01             	add    $0x1,%ecx
  800ea5:	bf 01 00 00 00       	mov    $0x1,%edi
  800eaa:	eb cb                	jmp    800e77 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800eac:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800eb0:	74 0e                	je     800ec0 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800eb2:	85 db                	test   %ebx,%ebx
  800eb4:	75 d8                	jne    800e8e <strtol+0x40>
		s++, base = 8;
  800eb6:	83 c1 01             	add    $0x1,%ecx
  800eb9:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ebe:	eb ce                	jmp    800e8e <strtol+0x40>
		s += 2, base = 16;
  800ec0:	83 c1 02             	add    $0x2,%ecx
  800ec3:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ec8:	eb c4                	jmp    800e8e <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800eca:	8d 72 9f             	lea    -0x61(%edx),%esi
  800ecd:	89 f3                	mov    %esi,%ebx
  800ecf:	80 fb 19             	cmp    $0x19,%bl
  800ed2:	77 29                	ja     800efd <strtol+0xaf>
			dig = *s - 'a' + 10;
  800ed4:	0f be d2             	movsbl %dl,%edx
  800ed7:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800eda:	3b 55 10             	cmp    0x10(%ebp),%edx
  800edd:	7d 30                	jge    800f0f <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800edf:	83 c1 01             	add    $0x1,%ecx
  800ee2:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ee6:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800ee8:	0f b6 11             	movzbl (%ecx),%edx
  800eeb:	8d 72 d0             	lea    -0x30(%edx),%esi
  800eee:	89 f3                	mov    %esi,%ebx
  800ef0:	80 fb 09             	cmp    $0x9,%bl
  800ef3:	77 d5                	ja     800eca <strtol+0x7c>
			dig = *s - '0';
  800ef5:	0f be d2             	movsbl %dl,%edx
  800ef8:	83 ea 30             	sub    $0x30,%edx
  800efb:	eb dd                	jmp    800eda <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800efd:	8d 72 bf             	lea    -0x41(%edx),%esi
  800f00:	89 f3                	mov    %esi,%ebx
  800f02:	80 fb 19             	cmp    $0x19,%bl
  800f05:	77 08                	ja     800f0f <strtol+0xc1>
			dig = *s - 'A' + 10;
  800f07:	0f be d2             	movsbl %dl,%edx
  800f0a:	83 ea 37             	sub    $0x37,%edx
  800f0d:	eb cb                	jmp    800eda <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800f0f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f13:	74 05                	je     800f1a <strtol+0xcc>
		*endptr = (char *) s;
  800f15:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f18:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800f1a:	89 c2                	mov    %eax,%edx
  800f1c:	f7 da                	neg    %edx
  800f1e:	85 ff                	test   %edi,%edi
  800f20:	0f 45 c2             	cmovne %edx,%eax
}
  800f23:	5b                   	pop    %ebx
  800f24:	5e                   	pop    %esi
  800f25:	5f                   	pop    %edi
  800f26:	5d                   	pop    %ebp
  800f27:	c3                   	ret    

00800f28 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800f28:	55                   	push   %ebp
  800f29:	89 e5                	mov    %esp,%ebp
  800f2b:	57                   	push   %edi
  800f2c:	56                   	push   %esi
  800f2d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f2e:	b8 00 00 00 00       	mov    $0x0,%eax
  800f33:	8b 55 08             	mov    0x8(%ebp),%edx
  800f36:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f39:	89 c3                	mov    %eax,%ebx
  800f3b:	89 c7                	mov    %eax,%edi
  800f3d:	89 c6                	mov    %eax,%esi
  800f3f:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800f41:	5b                   	pop    %ebx
  800f42:	5e                   	pop    %esi
  800f43:	5f                   	pop    %edi
  800f44:	5d                   	pop    %ebp
  800f45:	c3                   	ret    

00800f46 <sys_cgetc>:

int
sys_cgetc(void)
{
  800f46:	55                   	push   %ebp
  800f47:	89 e5                	mov    %esp,%ebp
  800f49:	57                   	push   %edi
  800f4a:	56                   	push   %esi
  800f4b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f4c:	ba 00 00 00 00       	mov    $0x0,%edx
  800f51:	b8 01 00 00 00       	mov    $0x1,%eax
  800f56:	89 d1                	mov    %edx,%ecx
  800f58:	89 d3                	mov    %edx,%ebx
  800f5a:	89 d7                	mov    %edx,%edi
  800f5c:	89 d6                	mov    %edx,%esi
  800f5e:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800f60:	5b                   	pop    %ebx
  800f61:	5e                   	pop    %esi
  800f62:	5f                   	pop    %edi
  800f63:	5d                   	pop    %ebp
  800f64:	c3                   	ret    

00800f65 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800f65:	55                   	push   %ebp
  800f66:	89 e5                	mov    %esp,%ebp
  800f68:	57                   	push   %edi
  800f69:	56                   	push   %esi
  800f6a:	53                   	push   %ebx
  800f6b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f6e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f73:	8b 55 08             	mov    0x8(%ebp),%edx
  800f76:	b8 03 00 00 00       	mov    $0x3,%eax
  800f7b:	89 cb                	mov    %ecx,%ebx
  800f7d:	89 cf                	mov    %ecx,%edi
  800f7f:	89 ce                	mov    %ecx,%esi
  800f81:	cd 30                	int    $0x30
	if (check && ret > 0)
  800f83:	85 c0                	test   %eax,%eax
  800f85:	7f 08                	jg     800f8f <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800f87:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f8a:	5b                   	pop    %ebx
  800f8b:	5e                   	pop    %esi
  800f8c:	5f                   	pop    %edi
  800f8d:	5d                   	pop    %ebp
  800f8e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f8f:	83 ec 0c             	sub    $0xc,%esp
  800f92:	50                   	push   %eax
  800f93:	6a 03                	push   $0x3
  800f95:	68 40 2b 80 00       	push   $0x802b40
  800f9a:	6a 4c                	push   $0x4c
  800f9c:	68 5d 2b 80 00       	push   $0x802b5d
  800fa1:	e8 4b f4 ff ff       	call   8003f1 <_panic>

00800fa6 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800fa6:	55                   	push   %ebp
  800fa7:	89 e5                	mov    %esp,%ebp
  800fa9:	57                   	push   %edi
  800faa:	56                   	push   %esi
  800fab:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fac:	ba 00 00 00 00       	mov    $0x0,%edx
  800fb1:	b8 02 00 00 00       	mov    $0x2,%eax
  800fb6:	89 d1                	mov    %edx,%ecx
  800fb8:	89 d3                	mov    %edx,%ebx
  800fba:	89 d7                	mov    %edx,%edi
  800fbc:	89 d6                	mov    %edx,%esi
  800fbe:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800fc0:	5b                   	pop    %ebx
  800fc1:	5e                   	pop    %esi
  800fc2:	5f                   	pop    %edi
  800fc3:	5d                   	pop    %ebp
  800fc4:	c3                   	ret    

00800fc5 <sys_yield>:

void
sys_yield(void)
{
  800fc5:	55                   	push   %ebp
  800fc6:	89 e5                	mov    %esp,%ebp
  800fc8:	57                   	push   %edi
  800fc9:	56                   	push   %esi
  800fca:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fcb:	ba 00 00 00 00       	mov    $0x0,%edx
  800fd0:	b8 0b 00 00 00       	mov    $0xb,%eax
  800fd5:	89 d1                	mov    %edx,%ecx
  800fd7:	89 d3                	mov    %edx,%ebx
  800fd9:	89 d7                	mov    %edx,%edi
  800fdb:	89 d6                	mov    %edx,%esi
  800fdd:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800fdf:	5b                   	pop    %ebx
  800fe0:	5e                   	pop    %esi
  800fe1:	5f                   	pop    %edi
  800fe2:	5d                   	pop    %ebp
  800fe3:	c3                   	ret    

00800fe4 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800fe4:	55                   	push   %ebp
  800fe5:	89 e5                	mov    %esp,%ebp
  800fe7:	57                   	push   %edi
  800fe8:	56                   	push   %esi
  800fe9:	53                   	push   %ebx
  800fea:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fed:	be 00 00 00 00       	mov    $0x0,%esi
  800ff2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ff8:	b8 04 00 00 00       	mov    $0x4,%eax
  800ffd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801000:	89 f7                	mov    %esi,%edi
  801002:	cd 30                	int    $0x30
	if (check && ret > 0)
  801004:	85 c0                	test   %eax,%eax
  801006:	7f 08                	jg     801010 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801008:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80100b:	5b                   	pop    %ebx
  80100c:	5e                   	pop    %esi
  80100d:	5f                   	pop    %edi
  80100e:	5d                   	pop    %ebp
  80100f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801010:	83 ec 0c             	sub    $0xc,%esp
  801013:	50                   	push   %eax
  801014:	6a 04                	push   $0x4
  801016:	68 40 2b 80 00       	push   $0x802b40
  80101b:	6a 4c                	push   $0x4c
  80101d:	68 5d 2b 80 00       	push   $0x802b5d
  801022:	e8 ca f3 ff ff       	call   8003f1 <_panic>

00801027 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801027:	55                   	push   %ebp
  801028:	89 e5                	mov    %esp,%ebp
  80102a:	57                   	push   %edi
  80102b:	56                   	push   %esi
  80102c:	53                   	push   %ebx
  80102d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801030:	8b 55 08             	mov    0x8(%ebp),%edx
  801033:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801036:	b8 05 00 00 00       	mov    $0x5,%eax
  80103b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80103e:	8b 7d 14             	mov    0x14(%ebp),%edi
  801041:	8b 75 18             	mov    0x18(%ebp),%esi
  801044:	cd 30                	int    $0x30
	if (check && ret > 0)
  801046:	85 c0                	test   %eax,%eax
  801048:	7f 08                	jg     801052 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80104a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80104d:	5b                   	pop    %ebx
  80104e:	5e                   	pop    %esi
  80104f:	5f                   	pop    %edi
  801050:	5d                   	pop    %ebp
  801051:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801052:	83 ec 0c             	sub    $0xc,%esp
  801055:	50                   	push   %eax
  801056:	6a 05                	push   $0x5
  801058:	68 40 2b 80 00       	push   $0x802b40
  80105d:	6a 4c                	push   $0x4c
  80105f:	68 5d 2b 80 00       	push   $0x802b5d
  801064:	e8 88 f3 ff ff       	call   8003f1 <_panic>

00801069 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801069:	55                   	push   %ebp
  80106a:	89 e5                	mov    %esp,%ebp
  80106c:	57                   	push   %edi
  80106d:	56                   	push   %esi
  80106e:	53                   	push   %ebx
  80106f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801072:	bb 00 00 00 00       	mov    $0x0,%ebx
  801077:	8b 55 08             	mov    0x8(%ebp),%edx
  80107a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80107d:	b8 06 00 00 00       	mov    $0x6,%eax
  801082:	89 df                	mov    %ebx,%edi
  801084:	89 de                	mov    %ebx,%esi
  801086:	cd 30                	int    $0x30
	if (check && ret > 0)
  801088:	85 c0                	test   %eax,%eax
  80108a:	7f 08                	jg     801094 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80108c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80108f:	5b                   	pop    %ebx
  801090:	5e                   	pop    %esi
  801091:	5f                   	pop    %edi
  801092:	5d                   	pop    %ebp
  801093:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801094:	83 ec 0c             	sub    $0xc,%esp
  801097:	50                   	push   %eax
  801098:	6a 06                	push   $0x6
  80109a:	68 40 2b 80 00       	push   $0x802b40
  80109f:	6a 4c                	push   $0x4c
  8010a1:	68 5d 2b 80 00       	push   $0x802b5d
  8010a6:	e8 46 f3 ff ff       	call   8003f1 <_panic>

008010ab <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8010ab:	55                   	push   %ebp
  8010ac:	89 e5                	mov    %esp,%ebp
  8010ae:	57                   	push   %edi
  8010af:	56                   	push   %esi
  8010b0:	53                   	push   %ebx
  8010b1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010b4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8010bc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010bf:	b8 08 00 00 00       	mov    $0x8,%eax
  8010c4:	89 df                	mov    %ebx,%edi
  8010c6:	89 de                	mov    %ebx,%esi
  8010c8:	cd 30                	int    $0x30
	if (check && ret > 0)
  8010ca:	85 c0                	test   %eax,%eax
  8010cc:	7f 08                	jg     8010d6 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8010ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010d1:	5b                   	pop    %ebx
  8010d2:	5e                   	pop    %esi
  8010d3:	5f                   	pop    %edi
  8010d4:	5d                   	pop    %ebp
  8010d5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010d6:	83 ec 0c             	sub    $0xc,%esp
  8010d9:	50                   	push   %eax
  8010da:	6a 08                	push   $0x8
  8010dc:	68 40 2b 80 00       	push   $0x802b40
  8010e1:	6a 4c                	push   $0x4c
  8010e3:	68 5d 2b 80 00       	push   $0x802b5d
  8010e8:	e8 04 f3 ff ff       	call   8003f1 <_panic>

008010ed <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8010ed:	55                   	push   %ebp
  8010ee:	89 e5                	mov    %esp,%ebp
  8010f0:	57                   	push   %edi
  8010f1:	56                   	push   %esi
  8010f2:	53                   	push   %ebx
  8010f3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010f6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8010fe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801101:	b8 09 00 00 00       	mov    $0x9,%eax
  801106:	89 df                	mov    %ebx,%edi
  801108:	89 de                	mov    %ebx,%esi
  80110a:	cd 30                	int    $0x30
	if (check && ret > 0)
  80110c:	85 c0                	test   %eax,%eax
  80110e:	7f 08                	jg     801118 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801110:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801113:	5b                   	pop    %ebx
  801114:	5e                   	pop    %esi
  801115:	5f                   	pop    %edi
  801116:	5d                   	pop    %ebp
  801117:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801118:	83 ec 0c             	sub    $0xc,%esp
  80111b:	50                   	push   %eax
  80111c:	6a 09                	push   $0x9
  80111e:	68 40 2b 80 00       	push   $0x802b40
  801123:	6a 4c                	push   $0x4c
  801125:	68 5d 2b 80 00       	push   $0x802b5d
  80112a:	e8 c2 f2 ff ff       	call   8003f1 <_panic>

0080112f <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80112f:	55                   	push   %ebp
  801130:	89 e5                	mov    %esp,%ebp
  801132:	57                   	push   %edi
  801133:	56                   	push   %esi
  801134:	53                   	push   %ebx
  801135:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801138:	bb 00 00 00 00       	mov    $0x0,%ebx
  80113d:	8b 55 08             	mov    0x8(%ebp),%edx
  801140:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801143:	b8 0a 00 00 00       	mov    $0xa,%eax
  801148:	89 df                	mov    %ebx,%edi
  80114a:	89 de                	mov    %ebx,%esi
  80114c:	cd 30                	int    $0x30
	if (check && ret > 0)
  80114e:	85 c0                	test   %eax,%eax
  801150:	7f 08                	jg     80115a <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801152:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801155:	5b                   	pop    %ebx
  801156:	5e                   	pop    %esi
  801157:	5f                   	pop    %edi
  801158:	5d                   	pop    %ebp
  801159:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80115a:	83 ec 0c             	sub    $0xc,%esp
  80115d:	50                   	push   %eax
  80115e:	6a 0a                	push   $0xa
  801160:	68 40 2b 80 00       	push   $0x802b40
  801165:	6a 4c                	push   $0x4c
  801167:	68 5d 2b 80 00       	push   $0x802b5d
  80116c:	e8 80 f2 ff ff       	call   8003f1 <_panic>

00801171 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801171:	55                   	push   %ebp
  801172:	89 e5                	mov    %esp,%ebp
  801174:	57                   	push   %edi
  801175:	56                   	push   %esi
  801176:	53                   	push   %ebx
	asm volatile("int %1\n"
  801177:	8b 55 08             	mov    0x8(%ebp),%edx
  80117a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80117d:	b8 0c 00 00 00       	mov    $0xc,%eax
  801182:	be 00 00 00 00       	mov    $0x0,%esi
  801187:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80118a:	8b 7d 14             	mov    0x14(%ebp),%edi
  80118d:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80118f:	5b                   	pop    %ebx
  801190:	5e                   	pop    %esi
  801191:	5f                   	pop    %edi
  801192:	5d                   	pop    %ebp
  801193:	c3                   	ret    

00801194 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801194:	55                   	push   %ebp
  801195:	89 e5                	mov    %esp,%ebp
  801197:	57                   	push   %edi
  801198:	56                   	push   %esi
  801199:	53                   	push   %ebx
  80119a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80119d:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8011a5:	b8 0d 00 00 00       	mov    $0xd,%eax
  8011aa:	89 cb                	mov    %ecx,%ebx
  8011ac:	89 cf                	mov    %ecx,%edi
  8011ae:	89 ce                	mov    %ecx,%esi
  8011b0:	cd 30                	int    $0x30
	if (check && ret > 0)
  8011b2:	85 c0                	test   %eax,%eax
  8011b4:	7f 08                	jg     8011be <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8011b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011b9:	5b                   	pop    %ebx
  8011ba:	5e                   	pop    %esi
  8011bb:	5f                   	pop    %edi
  8011bc:	5d                   	pop    %ebp
  8011bd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011be:	83 ec 0c             	sub    $0xc,%esp
  8011c1:	50                   	push   %eax
  8011c2:	6a 0d                	push   $0xd
  8011c4:	68 40 2b 80 00       	push   $0x802b40
  8011c9:	6a 4c                	push   $0x4c
  8011cb:	68 5d 2b 80 00       	push   $0x802b5d
  8011d0:	e8 1c f2 ff ff       	call   8003f1 <_panic>

008011d5 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  8011d5:	55                   	push   %ebp
  8011d6:	89 e5                	mov    %esp,%ebp
  8011d8:	57                   	push   %edi
  8011d9:	56                   	push   %esi
  8011da:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011db:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8011e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011e6:	b8 0e 00 00 00       	mov    $0xe,%eax
  8011eb:	89 df                	mov    %ebx,%edi
  8011ed:	89 de                	mov    %ebx,%esi
  8011ef:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8011f1:	5b                   	pop    %ebx
  8011f2:	5e                   	pop    %esi
  8011f3:	5f                   	pop    %edi
  8011f4:	5d                   	pop    %ebp
  8011f5:	c3                   	ret    

008011f6 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8011f6:	55                   	push   %ebp
  8011f7:	89 e5                	mov    %esp,%ebp
  8011f9:	57                   	push   %edi
  8011fa:	56                   	push   %esi
  8011fb:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011fc:	b9 00 00 00 00       	mov    $0x0,%ecx
  801201:	8b 55 08             	mov    0x8(%ebp),%edx
  801204:	b8 0f 00 00 00       	mov    $0xf,%eax
  801209:	89 cb                	mov    %ecx,%ebx
  80120b:	89 cf                	mov    %ecx,%edi
  80120d:	89 ce                	mov    %ecx,%esi
  80120f:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801211:	5b                   	pop    %ebx
  801212:	5e                   	pop    %esi
  801213:	5f                   	pop    %edi
  801214:	5d                   	pop    %ebp
  801215:	c3                   	ret    

00801216 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801216:	55                   	push   %ebp
  801217:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801219:	8b 45 08             	mov    0x8(%ebp),%eax
  80121c:	05 00 00 00 30       	add    $0x30000000,%eax
  801221:	c1 e8 0c             	shr    $0xc,%eax
}
  801224:	5d                   	pop    %ebp
  801225:	c3                   	ret    

00801226 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801226:	55                   	push   %ebp
  801227:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801229:	8b 45 08             	mov    0x8(%ebp),%eax
  80122c:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801231:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801236:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80123b:	5d                   	pop    %ebp
  80123c:	c3                   	ret    

0080123d <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80123d:	55                   	push   %ebp
  80123e:	89 e5                	mov    %esp,%ebp
  801240:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801245:	89 c2                	mov    %eax,%edx
  801247:	c1 ea 16             	shr    $0x16,%edx
  80124a:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801251:	f6 c2 01             	test   $0x1,%dl
  801254:	74 2d                	je     801283 <fd_alloc+0x46>
  801256:	89 c2                	mov    %eax,%edx
  801258:	c1 ea 0c             	shr    $0xc,%edx
  80125b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801262:	f6 c2 01             	test   $0x1,%dl
  801265:	74 1c                	je     801283 <fd_alloc+0x46>
  801267:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80126c:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801271:	75 d2                	jne    801245 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801273:	8b 45 08             	mov    0x8(%ebp),%eax
  801276:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80127c:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801281:	eb 0a                	jmp    80128d <fd_alloc+0x50>
			*fd_store = fd;
  801283:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801286:	89 01                	mov    %eax,(%ecx)
			return 0;
  801288:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80128d:	5d                   	pop    %ebp
  80128e:	c3                   	ret    

0080128f <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80128f:	55                   	push   %ebp
  801290:	89 e5                	mov    %esp,%ebp
  801292:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801295:	83 f8 1f             	cmp    $0x1f,%eax
  801298:	77 30                	ja     8012ca <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80129a:	c1 e0 0c             	shl    $0xc,%eax
  80129d:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8012a2:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8012a8:	f6 c2 01             	test   $0x1,%dl
  8012ab:	74 24                	je     8012d1 <fd_lookup+0x42>
  8012ad:	89 c2                	mov    %eax,%edx
  8012af:	c1 ea 0c             	shr    $0xc,%edx
  8012b2:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012b9:	f6 c2 01             	test   $0x1,%dl
  8012bc:	74 1a                	je     8012d8 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8012be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012c1:	89 02                	mov    %eax,(%edx)
	return 0;
  8012c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012c8:	5d                   	pop    %ebp
  8012c9:	c3                   	ret    
		return -E_INVAL;
  8012ca:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012cf:	eb f7                	jmp    8012c8 <fd_lookup+0x39>
		return -E_INVAL;
  8012d1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012d6:	eb f0                	jmp    8012c8 <fd_lookup+0x39>
  8012d8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012dd:	eb e9                	jmp    8012c8 <fd_lookup+0x39>

008012df <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8012df:	55                   	push   %ebp
  8012e0:	89 e5                	mov    %esp,%ebp
  8012e2:	83 ec 08             	sub    $0x8,%esp
  8012e5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012e8:	ba e8 2b 80 00       	mov    $0x802be8,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8012ed:	b8 90 47 80 00       	mov    $0x804790,%eax
		if (devtab[i]->dev_id == dev_id) {
  8012f2:	39 08                	cmp    %ecx,(%eax)
  8012f4:	74 33                	je     801329 <dev_lookup+0x4a>
  8012f6:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8012f9:	8b 02                	mov    (%edx),%eax
  8012fb:	85 c0                	test   %eax,%eax
  8012fd:	75 f3                	jne    8012f2 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8012ff:	a1 90 67 80 00       	mov    0x806790,%eax
  801304:	8b 40 48             	mov    0x48(%eax),%eax
  801307:	83 ec 04             	sub    $0x4,%esp
  80130a:	51                   	push   %ecx
  80130b:	50                   	push   %eax
  80130c:	68 6c 2b 80 00       	push   $0x802b6c
  801311:	e8 b6 f1 ff ff       	call   8004cc <cprintf>
	*dev = 0;
  801316:	8b 45 0c             	mov    0xc(%ebp),%eax
  801319:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80131f:	83 c4 10             	add    $0x10,%esp
  801322:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801327:	c9                   	leave  
  801328:	c3                   	ret    
			*dev = devtab[i];
  801329:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80132c:	89 01                	mov    %eax,(%ecx)
			return 0;
  80132e:	b8 00 00 00 00       	mov    $0x0,%eax
  801333:	eb f2                	jmp    801327 <dev_lookup+0x48>

00801335 <fd_close>:
{
  801335:	55                   	push   %ebp
  801336:	89 e5                	mov    %esp,%ebp
  801338:	57                   	push   %edi
  801339:	56                   	push   %esi
  80133a:	53                   	push   %ebx
  80133b:	83 ec 24             	sub    $0x24,%esp
  80133e:	8b 75 08             	mov    0x8(%ebp),%esi
  801341:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801344:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801347:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801348:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80134e:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801351:	50                   	push   %eax
  801352:	e8 38 ff ff ff       	call   80128f <fd_lookup>
  801357:	89 c3                	mov    %eax,%ebx
  801359:	83 c4 10             	add    $0x10,%esp
  80135c:	85 c0                	test   %eax,%eax
  80135e:	78 05                	js     801365 <fd_close+0x30>
	    || fd != fd2)
  801360:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801363:	74 16                	je     80137b <fd_close+0x46>
		return (must_exist ? r : 0);
  801365:	89 f8                	mov    %edi,%eax
  801367:	84 c0                	test   %al,%al
  801369:	b8 00 00 00 00       	mov    $0x0,%eax
  80136e:	0f 44 d8             	cmove  %eax,%ebx
}
  801371:	89 d8                	mov    %ebx,%eax
  801373:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801376:	5b                   	pop    %ebx
  801377:	5e                   	pop    %esi
  801378:	5f                   	pop    %edi
  801379:	5d                   	pop    %ebp
  80137a:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80137b:	83 ec 08             	sub    $0x8,%esp
  80137e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801381:	50                   	push   %eax
  801382:	ff 36                	pushl  (%esi)
  801384:	e8 56 ff ff ff       	call   8012df <dev_lookup>
  801389:	89 c3                	mov    %eax,%ebx
  80138b:	83 c4 10             	add    $0x10,%esp
  80138e:	85 c0                	test   %eax,%eax
  801390:	78 1a                	js     8013ac <fd_close+0x77>
		if (dev->dev_close)
  801392:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801395:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801398:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80139d:	85 c0                	test   %eax,%eax
  80139f:	74 0b                	je     8013ac <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8013a1:	83 ec 0c             	sub    $0xc,%esp
  8013a4:	56                   	push   %esi
  8013a5:	ff d0                	call   *%eax
  8013a7:	89 c3                	mov    %eax,%ebx
  8013a9:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8013ac:	83 ec 08             	sub    $0x8,%esp
  8013af:	56                   	push   %esi
  8013b0:	6a 00                	push   $0x0
  8013b2:	e8 b2 fc ff ff       	call   801069 <sys_page_unmap>
	return r;
  8013b7:	83 c4 10             	add    $0x10,%esp
  8013ba:	eb b5                	jmp    801371 <fd_close+0x3c>

008013bc <close>:

int
close(int fdnum)
{
  8013bc:	55                   	push   %ebp
  8013bd:	89 e5                	mov    %esp,%ebp
  8013bf:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013c5:	50                   	push   %eax
  8013c6:	ff 75 08             	pushl  0x8(%ebp)
  8013c9:	e8 c1 fe ff ff       	call   80128f <fd_lookup>
  8013ce:	83 c4 10             	add    $0x10,%esp
  8013d1:	85 c0                	test   %eax,%eax
  8013d3:	79 02                	jns    8013d7 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8013d5:	c9                   	leave  
  8013d6:	c3                   	ret    
		return fd_close(fd, 1);
  8013d7:	83 ec 08             	sub    $0x8,%esp
  8013da:	6a 01                	push   $0x1
  8013dc:	ff 75 f4             	pushl  -0xc(%ebp)
  8013df:	e8 51 ff ff ff       	call   801335 <fd_close>
  8013e4:	83 c4 10             	add    $0x10,%esp
  8013e7:	eb ec                	jmp    8013d5 <close+0x19>

008013e9 <close_all>:

void
close_all(void)
{
  8013e9:	55                   	push   %ebp
  8013ea:	89 e5                	mov    %esp,%ebp
  8013ec:	53                   	push   %ebx
  8013ed:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8013f0:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8013f5:	83 ec 0c             	sub    $0xc,%esp
  8013f8:	53                   	push   %ebx
  8013f9:	e8 be ff ff ff       	call   8013bc <close>
	for (i = 0; i < MAXFD; i++)
  8013fe:	83 c3 01             	add    $0x1,%ebx
  801401:	83 c4 10             	add    $0x10,%esp
  801404:	83 fb 20             	cmp    $0x20,%ebx
  801407:	75 ec                	jne    8013f5 <close_all+0xc>
}
  801409:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80140c:	c9                   	leave  
  80140d:	c3                   	ret    

0080140e <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80140e:	55                   	push   %ebp
  80140f:	89 e5                	mov    %esp,%ebp
  801411:	57                   	push   %edi
  801412:	56                   	push   %esi
  801413:	53                   	push   %ebx
  801414:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801417:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80141a:	50                   	push   %eax
  80141b:	ff 75 08             	pushl  0x8(%ebp)
  80141e:	e8 6c fe ff ff       	call   80128f <fd_lookup>
  801423:	89 c3                	mov    %eax,%ebx
  801425:	83 c4 10             	add    $0x10,%esp
  801428:	85 c0                	test   %eax,%eax
  80142a:	0f 88 81 00 00 00    	js     8014b1 <dup+0xa3>
		return r;
	close(newfdnum);
  801430:	83 ec 0c             	sub    $0xc,%esp
  801433:	ff 75 0c             	pushl  0xc(%ebp)
  801436:	e8 81 ff ff ff       	call   8013bc <close>

	newfd = INDEX2FD(newfdnum);
  80143b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80143e:	c1 e6 0c             	shl    $0xc,%esi
  801441:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801447:	83 c4 04             	add    $0x4,%esp
  80144a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80144d:	e8 d4 fd ff ff       	call   801226 <fd2data>
  801452:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801454:	89 34 24             	mov    %esi,(%esp)
  801457:	e8 ca fd ff ff       	call   801226 <fd2data>
  80145c:	83 c4 10             	add    $0x10,%esp
  80145f:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801461:	89 d8                	mov    %ebx,%eax
  801463:	c1 e8 16             	shr    $0x16,%eax
  801466:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80146d:	a8 01                	test   $0x1,%al
  80146f:	74 11                	je     801482 <dup+0x74>
  801471:	89 d8                	mov    %ebx,%eax
  801473:	c1 e8 0c             	shr    $0xc,%eax
  801476:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80147d:	f6 c2 01             	test   $0x1,%dl
  801480:	75 39                	jne    8014bb <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801482:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801485:	89 d0                	mov    %edx,%eax
  801487:	c1 e8 0c             	shr    $0xc,%eax
  80148a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801491:	83 ec 0c             	sub    $0xc,%esp
  801494:	25 07 0e 00 00       	and    $0xe07,%eax
  801499:	50                   	push   %eax
  80149a:	56                   	push   %esi
  80149b:	6a 00                	push   $0x0
  80149d:	52                   	push   %edx
  80149e:	6a 00                	push   $0x0
  8014a0:	e8 82 fb ff ff       	call   801027 <sys_page_map>
  8014a5:	89 c3                	mov    %eax,%ebx
  8014a7:	83 c4 20             	add    $0x20,%esp
  8014aa:	85 c0                	test   %eax,%eax
  8014ac:	78 31                	js     8014df <dup+0xd1>
		goto err;

	return newfdnum;
  8014ae:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8014b1:	89 d8                	mov    %ebx,%eax
  8014b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014b6:	5b                   	pop    %ebx
  8014b7:	5e                   	pop    %esi
  8014b8:	5f                   	pop    %edi
  8014b9:	5d                   	pop    %ebp
  8014ba:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8014bb:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014c2:	83 ec 0c             	sub    $0xc,%esp
  8014c5:	25 07 0e 00 00       	and    $0xe07,%eax
  8014ca:	50                   	push   %eax
  8014cb:	57                   	push   %edi
  8014cc:	6a 00                	push   $0x0
  8014ce:	53                   	push   %ebx
  8014cf:	6a 00                	push   $0x0
  8014d1:	e8 51 fb ff ff       	call   801027 <sys_page_map>
  8014d6:	89 c3                	mov    %eax,%ebx
  8014d8:	83 c4 20             	add    $0x20,%esp
  8014db:	85 c0                	test   %eax,%eax
  8014dd:	79 a3                	jns    801482 <dup+0x74>
	sys_page_unmap(0, newfd);
  8014df:	83 ec 08             	sub    $0x8,%esp
  8014e2:	56                   	push   %esi
  8014e3:	6a 00                	push   $0x0
  8014e5:	e8 7f fb ff ff       	call   801069 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8014ea:	83 c4 08             	add    $0x8,%esp
  8014ed:	57                   	push   %edi
  8014ee:	6a 00                	push   $0x0
  8014f0:	e8 74 fb ff ff       	call   801069 <sys_page_unmap>
	return r;
  8014f5:	83 c4 10             	add    $0x10,%esp
  8014f8:	eb b7                	jmp    8014b1 <dup+0xa3>

008014fa <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8014fa:	55                   	push   %ebp
  8014fb:	89 e5                	mov    %esp,%ebp
  8014fd:	53                   	push   %ebx
  8014fe:	83 ec 1c             	sub    $0x1c,%esp
  801501:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801504:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801507:	50                   	push   %eax
  801508:	53                   	push   %ebx
  801509:	e8 81 fd ff ff       	call   80128f <fd_lookup>
  80150e:	83 c4 10             	add    $0x10,%esp
  801511:	85 c0                	test   %eax,%eax
  801513:	78 3f                	js     801554 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801515:	83 ec 08             	sub    $0x8,%esp
  801518:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80151b:	50                   	push   %eax
  80151c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80151f:	ff 30                	pushl  (%eax)
  801521:	e8 b9 fd ff ff       	call   8012df <dev_lookup>
  801526:	83 c4 10             	add    $0x10,%esp
  801529:	85 c0                	test   %eax,%eax
  80152b:	78 27                	js     801554 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80152d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801530:	8b 42 08             	mov    0x8(%edx),%eax
  801533:	83 e0 03             	and    $0x3,%eax
  801536:	83 f8 01             	cmp    $0x1,%eax
  801539:	74 1e                	je     801559 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80153b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80153e:	8b 40 08             	mov    0x8(%eax),%eax
  801541:	85 c0                	test   %eax,%eax
  801543:	74 35                	je     80157a <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801545:	83 ec 04             	sub    $0x4,%esp
  801548:	ff 75 10             	pushl  0x10(%ebp)
  80154b:	ff 75 0c             	pushl  0xc(%ebp)
  80154e:	52                   	push   %edx
  80154f:	ff d0                	call   *%eax
  801551:	83 c4 10             	add    $0x10,%esp
}
  801554:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801557:	c9                   	leave  
  801558:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801559:	a1 90 67 80 00       	mov    0x806790,%eax
  80155e:	8b 40 48             	mov    0x48(%eax),%eax
  801561:	83 ec 04             	sub    $0x4,%esp
  801564:	53                   	push   %ebx
  801565:	50                   	push   %eax
  801566:	68 ad 2b 80 00       	push   $0x802bad
  80156b:	e8 5c ef ff ff       	call   8004cc <cprintf>
		return -E_INVAL;
  801570:	83 c4 10             	add    $0x10,%esp
  801573:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801578:	eb da                	jmp    801554 <read+0x5a>
		return -E_NOT_SUPP;
  80157a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80157f:	eb d3                	jmp    801554 <read+0x5a>

00801581 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801581:	55                   	push   %ebp
  801582:	89 e5                	mov    %esp,%ebp
  801584:	57                   	push   %edi
  801585:	56                   	push   %esi
  801586:	53                   	push   %ebx
  801587:	83 ec 0c             	sub    $0xc,%esp
  80158a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80158d:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801590:	bb 00 00 00 00       	mov    $0x0,%ebx
  801595:	39 f3                	cmp    %esi,%ebx
  801597:	73 23                	jae    8015bc <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801599:	83 ec 04             	sub    $0x4,%esp
  80159c:	89 f0                	mov    %esi,%eax
  80159e:	29 d8                	sub    %ebx,%eax
  8015a0:	50                   	push   %eax
  8015a1:	89 d8                	mov    %ebx,%eax
  8015a3:	03 45 0c             	add    0xc(%ebp),%eax
  8015a6:	50                   	push   %eax
  8015a7:	57                   	push   %edi
  8015a8:	e8 4d ff ff ff       	call   8014fa <read>
		if (m < 0)
  8015ad:	83 c4 10             	add    $0x10,%esp
  8015b0:	85 c0                	test   %eax,%eax
  8015b2:	78 06                	js     8015ba <readn+0x39>
			return m;
		if (m == 0)
  8015b4:	74 06                	je     8015bc <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8015b6:	01 c3                	add    %eax,%ebx
  8015b8:	eb db                	jmp    801595 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8015ba:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8015bc:	89 d8                	mov    %ebx,%eax
  8015be:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015c1:	5b                   	pop    %ebx
  8015c2:	5e                   	pop    %esi
  8015c3:	5f                   	pop    %edi
  8015c4:	5d                   	pop    %ebp
  8015c5:	c3                   	ret    

008015c6 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8015c6:	55                   	push   %ebp
  8015c7:	89 e5                	mov    %esp,%ebp
  8015c9:	53                   	push   %ebx
  8015ca:	83 ec 1c             	sub    $0x1c,%esp
  8015cd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015d0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015d3:	50                   	push   %eax
  8015d4:	53                   	push   %ebx
  8015d5:	e8 b5 fc ff ff       	call   80128f <fd_lookup>
  8015da:	83 c4 10             	add    $0x10,%esp
  8015dd:	85 c0                	test   %eax,%eax
  8015df:	78 3a                	js     80161b <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015e1:	83 ec 08             	sub    $0x8,%esp
  8015e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015e7:	50                   	push   %eax
  8015e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015eb:	ff 30                	pushl  (%eax)
  8015ed:	e8 ed fc ff ff       	call   8012df <dev_lookup>
  8015f2:	83 c4 10             	add    $0x10,%esp
  8015f5:	85 c0                	test   %eax,%eax
  8015f7:	78 22                	js     80161b <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015fc:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801600:	74 1e                	je     801620 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801602:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801605:	8b 52 0c             	mov    0xc(%edx),%edx
  801608:	85 d2                	test   %edx,%edx
  80160a:	74 35                	je     801641 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80160c:	83 ec 04             	sub    $0x4,%esp
  80160f:	ff 75 10             	pushl  0x10(%ebp)
  801612:	ff 75 0c             	pushl  0xc(%ebp)
  801615:	50                   	push   %eax
  801616:	ff d2                	call   *%edx
  801618:	83 c4 10             	add    $0x10,%esp
}
  80161b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80161e:	c9                   	leave  
  80161f:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801620:	a1 90 67 80 00       	mov    0x806790,%eax
  801625:	8b 40 48             	mov    0x48(%eax),%eax
  801628:	83 ec 04             	sub    $0x4,%esp
  80162b:	53                   	push   %ebx
  80162c:	50                   	push   %eax
  80162d:	68 c9 2b 80 00       	push   $0x802bc9
  801632:	e8 95 ee ff ff       	call   8004cc <cprintf>
		return -E_INVAL;
  801637:	83 c4 10             	add    $0x10,%esp
  80163a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80163f:	eb da                	jmp    80161b <write+0x55>
		return -E_NOT_SUPP;
  801641:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801646:	eb d3                	jmp    80161b <write+0x55>

00801648 <seek>:

int
seek(int fdnum, off_t offset)
{
  801648:	55                   	push   %ebp
  801649:	89 e5                	mov    %esp,%ebp
  80164b:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80164e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801651:	50                   	push   %eax
  801652:	ff 75 08             	pushl  0x8(%ebp)
  801655:	e8 35 fc ff ff       	call   80128f <fd_lookup>
  80165a:	83 c4 10             	add    $0x10,%esp
  80165d:	85 c0                	test   %eax,%eax
  80165f:	78 0e                	js     80166f <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801661:	8b 55 0c             	mov    0xc(%ebp),%edx
  801664:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801667:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80166a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80166f:	c9                   	leave  
  801670:	c3                   	ret    

00801671 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801671:	55                   	push   %ebp
  801672:	89 e5                	mov    %esp,%ebp
  801674:	53                   	push   %ebx
  801675:	83 ec 1c             	sub    $0x1c,%esp
  801678:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80167b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80167e:	50                   	push   %eax
  80167f:	53                   	push   %ebx
  801680:	e8 0a fc ff ff       	call   80128f <fd_lookup>
  801685:	83 c4 10             	add    $0x10,%esp
  801688:	85 c0                	test   %eax,%eax
  80168a:	78 37                	js     8016c3 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80168c:	83 ec 08             	sub    $0x8,%esp
  80168f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801692:	50                   	push   %eax
  801693:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801696:	ff 30                	pushl  (%eax)
  801698:	e8 42 fc ff ff       	call   8012df <dev_lookup>
  80169d:	83 c4 10             	add    $0x10,%esp
  8016a0:	85 c0                	test   %eax,%eax
  8016a2:	78 1f                	js     8016c3 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016a7:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8016ab:	74 1b                	je     8016c8 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8016ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016b0:	8b 52 18             	mov    0x18(%edx),%edx
  8016b3:	85 d2                	test   %edx,%edx
  8016b5:	74 32                	je     8016e9 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8016b7:	83 ec 08             	sub    $0x8,%esp
  8016ba:	ff 75 0c             	pushl  0xc(%ebp)
  8016bd:	50                   	push   %eax
  8016be:	ff d2                	call   *%edx
  8016c0:	83 c4 10             	add    $0x10,%esp
}
  8016c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016c6:	c9                   	leave  
  8016c7:	c3                   	ret    
			thisenv->env_id, fdnum);
  8016c8:	a1 90 67 80 00       	mov    0x806790,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8016cd:	8b 40 48             	mov    0x48(%eax),%eax
  8016d0:	83 ec 04             	sub    $0x4,%esp
  8016d3:	53                   	push   %ebx
  8016d4:	50                   	push   %eax
  8016d5:	68 8c 2b 80 00       	push   $0x802b8c
  8016da:	e8 ed ed ff ff       	call   8004cc <cprintf>
		return -E_INVAL;
  8016df:	83 c4 10             	add    $0x10,%esp
  8016e2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016e7:	eb da                	jmp    8016c3 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8016e9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016ee:	eb d3                	jmp    8016c3 <ftruncate+0x52>

008016f0 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8016f0:	55                   	push   %ebp
  8016f1:	89 e5                	mov    %esp,%ebp
  8016f3:	53                   	push   %ebx
  8016f4:	83 ec 1c             	sub    $0x1c,%esp
  8016f7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016fa:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016fd:	50                   	push   %eax
  8016fe:	ff 75 08             	pushl  0x8(%ebp)
  801701:	e8 89 fb ff ff       	call   80128f <fd_lookup>
  801706:	83 c4 10             	add    $0x10,%esp
  801709:	85 c0                	test   %eax,%eax
  80170b:	78 4b                	js     801758 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80170d:	83 ec 08             	sub    $0x8,%esp
  801710:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801713:	50                   	push   %eax
  801714:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801717:	ff 30                	pushl  (%eax)
  801719:	e8 c1 fb ff ff       	call   8012df <dev_lookup>
  80171e:	83 c4 10             	add    $0x10,%esp
  801721:	85 c0                	test   %eax,%eax
  801723:	78 33                	js     801758 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801725:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801728:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80172c:	74 2f                	je     80175d <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80172e:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801731:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801738:	00 00 00 
	stat->st_isdir = 0;
  80173b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801742:	00 00 00 
	stat->st_dev = dev;
  801745:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80174b:	83 ec 08             	sub    $0x8,%esp
  80174e:	53                   	push   %ebx
  80174f:	ff 75 f0             	pushl  -0x10(%ebp)
  801752:	ff 50 14             	call   *0x14(%eax)
  801755:	83 c4 10             	add    $0x10,%esp
}
  801758:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80175b:	c9                   	leave  
  80175c:	c3                   	ret    
		return -E_NOT_SUPP;
  80175d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801762:	eb f4                	jmp    801758 <fstat+0x68>

00801764 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801764:	55                   	push   %ebp
  801765:	89 e5                	mov    %esp,%ebp
  801767:	56                   	push   %esi
  801768:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801769:	83 ec 08             	sub    $0x8,%esp
  80176c:	6a 00                	push   $0x0
  80176e:	ff 75 08             	pushl  0x8(%ebp)
  801771:	e8 bb 01 00 00       	call   801931 <open>
  801776:	89 c3                	mov    %eax,%ebx
  801778:	83 c4 10             	add    $0x10,%esp
  80177b:	85 c0                	test   %eax,%eax
  80177d:	78 1b                	js     80179a <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80177f:	83 ec 08             	sub    $0x8,%esp
  801782:	ff 75 0c             	pushl  0xc(%ebp)
  801785:	50                   	push   %eax
  801786:	e8 65 ff ff ff       	call   8016f0 <fstat>
  80178b:	89 c6                	mov    %eax,%esi
	close(fd);
  80178d:	89 1c 24             	mov    %ebx,(%esp)
  801790:	e8 27 fc ff ff       	call   8013bc <close>
	return r;
  801795:	83 c4 10             	add    $0x10,%esp
  801798:	89 f3                	mov    %esi,%ebx
}
  80179a:	89 d8                	mov    %ebx,%eax
  80179c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80179f:	5b                   	pop    %ebx
  8017a0:	5e                   	pop    %esi
  8017a1:	5d                   	pop    %ebp
  8017a2:	c3                   	ret    

008017a3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8017a3:	55                   	push   %ebp
  8017a4:	89 e5                	mov    %esp,%ebp
  8017a6:	56                   	push   %esi
  8017a7:	53                   	push   %ebx
  8017a8:	89 c6                	mov    %eax,%esi
  8017aa:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8017ac:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  8017b3:	74 27                	je     8017dc <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8017b5:	6a 07                	push   $0x7
  8017b7:	68 00 70 80 00       	push   $0x807000
  8017bc:	56                   	push   %esi
  8017bd:	ff 35 00 50 80 00    	pushl  0x805000
  8017c3:	e8 77 0b 00 00       	call   80233f <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8017c8:	83 c4 0c             	add    $0xc,%esp
  8017cb:	6a 00                	push   $0x0
  8017cd:	53                   	push   %ebx
  8017ce:	6a 00                	push   $0x0
  8017d0:	e8 01 0b 00 00       	call   8022d6 <ipc_recv>
}
  8017d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017d8:	5b                   	pop    %ebx
  8017d9:	5e                   	pop    %esi
  8017da:	5d                   	pop    %ebp
  8017db:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8017dc:	83 ec 0c             	sub    $0xc,%esp
  8017df:	6a 01                	push   $0x1
  8017e1:	e8 a6 0b 00 00       	call   80238c <ipc_find_env>
  8017e6:	a3 00 50 80 00       	mov    %eax,0x805000
  8017eb:	83 c4 10             	add    $0x10,%esp
  8017ee:	eb c5                	jmp    8017b5 <fsipc+0x12>

008017f0 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8017f0:	55                   	push   %ebp
  8017f1:	89 e5                	mov    %esp,%ebp
  8017f3:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8017f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f9:	8b 40 0c             	mov    0xc(%eax),%eax
  8017fc:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.set_size.req_size = newsize;
  801801:	8b 45 0c             	mov    0xc(%ebp),%eax
  801804:	a3 04 70 80 00       	mov    %eax,0x807004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801809:	ba 00 00 00 00       	mov    $0x0,%edx
  80180e:	b8 02 00 00 00       	mov    $0x2,%eax
  801813:	e8 8b ff ff ff       	call   8017a3 <fsipc>
}
  801818:	c9                   	leave  
  801819:	c3                   	ret    

0080181a <devfile_flush>:
{
  80181a:	55                   	push   %ebp
  80181b:	89 e5                	mov    %esp,%ebp
  80181d:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801820:	8b 45 08             	mov    0x8(%ebp),%eax
  801823:	8b 40 0c             	mov    0xc(%eax),%eax
  801826:	a3 00 70 80 00       	mov    %eax,0x807000
	return fsipc(FSREQ_FLUSH, NULL);
  80182b:	ba 00 00 00 00       	mov    $0x0,%edx
  801830:	b8 06 00 00 00       	mov    $0x6,%eax
  801835:	e8 69 ff ff ff       	call   8017a3 <fsipc>
}
  80183a:	c9                   	leave  
  80183b:	c3                   	ret    

0080183c <devfile_stat>:
{
  80183c:	55                   	push   %ebp
  80183d:	89 e5                	mov    %esp,%ebp
  80183f:	53                   	push   %ebx
  801840:	83 ec 04             	sub    $0x4,%esp
  801843:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801846:	8b 45 08             	mov    0x8(%ebp),%eax
  801849:	8b 40 0c             	mov    0xc(%eax),%eax
  80184c:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801851:	ba 00 00 00 00       	mov    $0x0,%edx
  801856:	b8 05 00 00 00       	mov    $0x5,%eax
  80185b:	e8 43 ff ff ff       	call   8017a3 <fsipc>
  801860:	85 c0                	test   %eax,%eax
  801862:	78 2c                	js     801890 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801864:	83 ec 08             	sub    $0x8,%esp
  801867:	68 00 70 80 00       	push   $0x807000
  80186c:	53                   	push   %ebx
  80186d:	e8 80 f3 ff ff       	call   800bf2 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801872:	a1 80 70 80 00       	mov    0x807080,%eax
  801877:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80187d:	a1 84 70 80 00       	mov    0x807084,%eax
  801882:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801888:	83 c4 10             	add    $0x10,%esp
  80188b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801890:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801893:	c9                   	leave  
  801894:	c3                   	ret    

00801895 <devfile_write>:
{
  801895:	55                   	push   %ebp
  801896:	89 e5                	mov    %esp,%ebp
  801898:	83 ec 0c             	sub    $0xc,%esp
	panic("devfile_write not implemented");
  80189b:	68 f8 2b 80 00       	push   $0x802bf8
  8018a0:	68 90 00 00 00       	push   $0x90
  8018a5:	68 16 2c 80 00       	push   $0x802c16
  8018aa:	e8 42 eb ff ff       	call   8003f1 <_panic>

008018af <devfile_read>:
{
  8018af:	55                   	push   %ebp
  8018b0:	89 e5                	mov    %esp,%ebp
  8018b2:	56                   	push   %esi
  8018b3:	53                   	push   %ebx
  8018b4:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8018b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8018bd:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.read.req_n = n;
  8018c2:	89 35 04 70 80 00    	mov    %esi,0x807004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8018c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8018cd:	b8 03 00 00 00       	mov    $0x3,%eax
  8018d2:	e8 cc fe ff ff       	call   8017a3 <fsipc>
  8018d7:	89 c3                	mov    %eax,%ebx
  8018d9:	85 c0                	test   %eax,%eax
  8018db:	78 1f                	js     8018fc <devfile_read+0x4d>
	assert(r <= n);
  8018dd:	39 f0                	cmp    %esi,%eax
  8018df:	77 24                	ja     801905 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8018e1:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018e6:	7f 33                	jg     80191b <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8018e8:	83 ec 04             	sub    $0x4,%esp
  8018eb:	50                   	push   %eax
  8018ec:	68 00 70 80 00       	push   $0x807000
  8018f1:	ff 75 0c             	pushl  0xc(%ebp)
  8018f4:	e8 87 f4 ff ff       	call   800d80 <memmove>
	return r;
  8018f9:	83 c4 10             	add    $0x10,%esp
}
  8018fc:	89 d8                	mov    %ebx,%eax
  8018fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801901:	5b                   	pop    %ebx
  801902:	5e                   	pop    %esi
  801903:	5d                   	pop    %ebp
  801904:	c3                   	ret    
	assert(r <= n);
  801905:	68 21 2c 80 00       	push   $0x802c21
  80190a:	68 28 2c 80 00       	push   $0x802c28
  80190f:	6a 7c                	push   $0x7c
  801911:	68 16 2c 80 00       	push   $0x802c16
  801916:	e8 d6 ea ff ff       	call   8003f1 <_panic>
	assert(r <= PGSIZE);
  80191b:	68 3d 2c 80 00       	push   $0x802c3d
  801920:	68 28 2c 80 00       	push   $0x802c28
  801925:	6a 7d                	push   $0x7d
  801927:	68 16 2c 80 00       	push   $0x802c16
  80192c:	e8 c0 ea ff ff       	call   8003f1 <_panic>

00801931 <open>:
{
  801931:	55                   	push   %ebp
  801932:	89 e5                	mov    %esp,%ebp
  801934:	56                   	push   %esi
  801935:	53                   	push   %ebx
  801936:	83 ec 1c             	sub    $0x1c,%esp
  801939:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80193c:	56                   	push   %esi
  80193d:	e8 77 f2 ff ff       	call   800bb9 <strlen>
  801942:	83 c4 10             	add    $0x10,%esp
  801945:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80194a:	7f 6c                	jg     8019b8 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80194c:	83 ec 0c             	sub    $0xc,%esp
  80194f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801952:	50                   	push   %eax
  801953:	e8 e5 f8 ff ff       	call   80123d <fd_alloc>
  801958:	89 c3                	mov    %eax,%ebx
  80195a:	83 c4 10             	add    $0x10,%esp
  80195d:	85 c0                	test   %eax,%eax
  80195f:	78 3c                	js     80199d <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801961:	83 ec 08             	sub    $0x8,%esp
  801964:	56                   	push   %esi
  801965:	68 00 70 80 00       	push   $0x807000
  80196a:	e8 83 f2 ff ff       	call   800bf2 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80196f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801972:	a3 00 74 80 00       	mov    %eax,0x807400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801977:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80197a:	b8 01 00 00 00       	mov    $0x1,%eax
  80197f:	e8 1f fe ff ff       	call   8017a3 <fsipc>
  801984:	89 c3                	mov    %eax,%ebx
  801986:	83 c4 10             	add    $0x10,%esp
  801989:	85 c0                	test   %eax,%eax
  80198b:	78 19                	js     8019a6 <open+0x75>
	return fd2num(fd);
  80198d:	83 ec 0c             	sub    $0xc,%esp
  801990:	ff 75 f4             	pushl  -0xc(%ebp)
  801993:	e8 7e f8 ff ff       	call   801216 <fd2num>
  801998:	89 c3                	mov    %eax,%ebx
  80199a:	83 c4 10             	add    $0x10,%esp
}
  80199d:	89 d8                	mov    %ebx,%eax
  80199f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019a2:	5b                   	pop    %ebx
  8019a3:	5e                   	pop    %esi
  8019a4:	5d                   	pop    %ebp
  8019a5:	c3                   	ret    
		fd_close(fd, 0);
  8019a6:	83 ec 08             	sub    $0x8,%esp
  8019a9:	6a 00                	push   $0x0
  8019ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8019ae:	e8 82 f9 ff ff       	call   801335 <fd_close>
		return r;
  8019b3:	83 c4 10             	add    $0x10,%esp
  8019b6:	eb e5                	jmp    80199d <open+0x6c>
		return -E_BAD_PATH;
  8019b8:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8019bd:	eb de                	jmp    80199d <open+0x6c>

008019bf <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8019bf:	55                   	push   %ebp
  8019c0:	89 e5                	mov    %esp,%ebp
  8019c2:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8019c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8019ca:	b8 08 00 00 00       	mov    $0x8,%eax
  8019cf:	e8 cf fd ff ff       	call   8017a3 <fsipc>
}
  8019d4:	c9                   	leave  
  8019d5:	c3                   	ret    

008019d6 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  8019d6:	55                   	push   %ebp
  8019d7:	89 e5                	mov    %esp,%ebp
  8019d9:	57                   	push   %edi
  8019da:	56                   	push   %esi
  8019db:	53                   	push   %ebx
  8019dc:	81 ec 94 02 00 00    	sub    $0x294,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  8019e2:	6a 00                	push   $0x0
  8019e4:	ff 75 08             	pushl  0x8(%ebp)
  8019e7:	e8 45 ff ff ff       	call   801931 <open>
  8019ec:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  8019f2:	83 c4 10             	add    $0x10,%esp
  8019f5:	85 c0                	test   %eax,%eax
  8019f7:	0f 88 72 04 00 00    	js     801e6f <spawn+0x499>
  8019fd:	89 c2                	mov    %eax,%edx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  8019ff:	83 ec 04             	sub    $0x4,%esp
  801a02:	68 00 02 00 00       	push   $0x200
  801a07:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801a0d:	50                   	push   %eax
  801a0e:	52                   	push   %edx
  801a0f:	e8 6d fb ff ff       	call   801581 <readn>
  801a14:	83 c4 10             	add    $0x10,%esp
  801a17:	3d 00 02 00 00       	cmp    $0x200,%eax
  801a1c:	75 60                	jne    801a7e <spawn+0xa8>
	    || elf->e_magic != ELF_MAGIC) {
  801a1e:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801a25:	45 4c 46 
  801a28:	75 54                	jne    801a7e <spawn+0xa8>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801a2a:	b8 07 00 00 00       	mov    $0x7,%eax
  801a2f:	cd 30                	int    $0x30
  801a31:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  801a37:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801a3d:	85 c0                	test   %eax,%eax
  801a3f:	0f 88 1e 04 00 00    	js     801e63 <spawn+0x48d>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801a45:	25 ff 03 00 00       	and    $0x3ff,%eax
  801a4a:	69 f0 84 00 00 00    	imul   $0x84,%eax,%esi
  801a50:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801a56:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801a5c:	b9 11 00 00 00       	mov    $0x11,%ecx
  801a61:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801a63:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801a69:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801a6f:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  801a74:	be 00 00 00 00       	mov    $0x0,%esi
  801a79:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801a7c:	eb 4b                	jmp    801ac9 <spawn+0xf3>
		close(fd);
  801a7e:	83 ec 0c             	sub    $0xc,%esp
  801a81:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801a87:	e8 30 f9 ff ff       	call   8013bc <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801a8c:	83 c4 0c             	add    $0xc,%esp
  801a8f:	68 7f 45 4c 46       	push   $0x464c457f
  801a94:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  801a9a:	68 49 2c 80 00       	push   $0x802c49
  801a9f:	e8 28 ea ff ff       	call   8004cc <cprintf>
		return -E_NOT_EXEC;
  801aa4:	83 c4 10             	add    $0x10,%esp
  801aa7:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  801aae:	ff ff ff 
  801ab1:	e9 b9 03 00 00       	jmp    801e6f <spawn+0x499>
		string_size += strlen(argv[argc]) + 1;
  801ab6:	83 ec 0c             	sub    $0xc,%esp
  801ab9:	50                   	push   %eax
  801aba:	e8 fa f0 ff ff       	call   800bb9 <strlen>
  801abf:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  801ac3:	83 c3 01             	add    $0x1,%ebx
  801ac6:	83 c4 10             	add    $0x10,%esp
  801ac9:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  801ad0:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801ad3:	85 c0                	test   %eax,%eax
  801ad5:	75 df                	jne    801ab6 <spawn+0xe0>
  801ad7:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  801add:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801ae3:	bf 00 10 40 00       	mov    $0x401000,%edi
  801ae8:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801aea:	89 fa                	mov    %edi,%edx
  801aec:	83 e2 fc             	and    $0xfffffffc,%edx
  801aef:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801af6:	29 c2                	sub    %eax,%edx
  801af8:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801afe:	8d 42 f8             	lea    -0x8(%edx),%eax
  801b01:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801b06:	0f 86 86 03 00 00    	jbe    801e92 <spawn+0x4bc>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801b0c:	83 ec 04             	sub    $0x4,%esp
  801b0f:	6a 07                	push   $0x7
  801b11:	68 00 00 40 00       	push   $0x400000
  801b16:	6a 00                	push   $0x0
  801b18:	e8 c7 f4 ff ff       	call   800fe4 <sys_page_alloc>
  801b1d:	83 c4 10             	add    $0x10,%esp
  801b20:	85 c0                	test   %eax,%eax
  801b22:	0f 88 6f 03 00 00    	js     801e97 <spawn+0x4c1>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801b28:	be 00 00 00 00       	mov    $0x0,%esi
  801b2d:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801b33:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801b36:	eb 30                	jmp    801b68 <spawn+0x192>
		argv_store[i] = UTEMP2USTACK(string_store);
  801b38:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801b3e:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  801b44:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  801b47:	83 ec 08             	sub    $0x8,%esp
  801b4a:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801b4d:	57                   	push   %edi
  801b4e:	e8 9f f0 ff ff       	call   800bf2 <strcpy>
		string_store += strlen(argv[i]) + 1;
  801b53:	83 c4 04             	add    $0x4,%esp
  801b56:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801b59:	e8 5b f0 ff ff       	call   800bb9 <strlen>
  801b5e:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  801b62:	83 c6 01             	add    $0x1,%esi
  801b65:	83 c4 10             	add    $0x10,%esp
  801b68:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  801b6e:	7f c8                	jg     801b38 <spawn+0x162>
	}
	argv_store[argc] = 0;
  801b70:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801b76:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  801b7c:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801b83:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801b89:	0f 85 86 00 00 00    	jne    801c15 <spawn+0x23f>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801b8f:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  801b95:	8d 81 00 d0 7f ee    	lea    -0x11803000(%ecx),%eax
  801b9b:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  801b9e:	89 c8                	mov    %ecx,%eax
  801ba0:	8b 8d 84 fd ff ff    	mov    -0x27c(%ebp),%ecx
  801ba6:	89 48 f8             	mov    %ecx,-0x8(%eax)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801ba9:	2d 08 30 80 11       	sub    $0x11803008,%eax
  801bae:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801bb4:	83 ec 0c             	sub    $0xc,%esp
  801bb7:	6a 07                	push   $0x7
  801bb9:	68 00 d0 bf ee       	push   $0xeebfd000
  801bbe:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801bc4:	68 00 00 40 00       	push   $0x400000
  801bc9:	6a 00                	push   $0x0
  801bcb:	e8 57 f4 ff ff       	call   801027 <sys_page_map>
  801bd0:	89 c3                	mov    %eax,%ebx
  801bd2:	83 c4 20             	add    $0x20,%esp
  801bd5:	85 c0                	test   %eax,%eax
  801bd7:	0f 88 c2 02 00 00    	js     801e9f <spawn+0x4c9>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801bdd:	83 ec 08             	sub    $0x8,%esp
  801be0:	68 00 00 40 00       	push   $0x400000
  801be5:	6a 00                	push   $0x0
  801be7:	e8 7d f4 ff ff       	call   801069 <sys_page_unmap>
  801bec:	89 c3                	mov    %eax,%ebx
  801bee:	83 c4 10             	add    $0x10,%esp
  801bf1:	85 c0                	test   %eax,%eax
  801bf3:	0f 88 a6 02 00 00    	js     801e9f <spawn+0x4c9>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801bf9:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801bff:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801c06:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  801c0d:	00 00 00 
  801c10:	e9 4f 01 00 00       	jmp    801d64 <spawn+0x38e>
	assert(string_store == (char*)UTEMP + PGSIZE);
  801c15:	68 c0 2c 80 00       	push   $0x802cc0
  801c1a:	68 28 2c 80 00       	push   $0x802c28
  801c1f:	68 f2 00 00 00       	push   $0xf2
  801c24:	68 63 2c 80 00       	push   $0x802c63
  801c29:	e8 c3 e7 ff ff       	call   8003f1 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801c2e:	83 ec 04             	sub    $0x4,%esp
  801c31:	6a 07                	push   $0x7
  801c33:	68 00 00 40 00       	push   $0x400000
  801c38:	6a 00                	push   $0x0
  801c3a:	e8 a5 f3 ff ff       	call   800fe4 <sys_page_alloc>
  801c3f:	83 c4 10             	add    $0x10,%esp
  801c42:	85 c0                	test   %eax,%eax
  801c44:	0f 88 33 02 00 00    	js     801e7d <spawn+0x4a7>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801c4a:	83 ec 08             	sub    $0x8,%esp
  801c4d:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801c53:	01 f0                	add    %esi,%eax
  801c55:	50                   	push   %eax
  801c56:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801c5c:	e8 e7 f9 ff ff       	call   801648 <seek>
  801c61:	83 c4 10             	add    $0x10,%esp
  801c64:	85 c0                	test   %eax,%eax
  801c66:	0f 88 18 02 00 00    	js     801e84 <spawn+0x4ae>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801c6c:	83 ec 04             	sub    $0x4,%esp
  801c6f:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801c75:	29 f0                	sub    %esi,%eax
  801c77:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c7c:	ba 00 10 00 00       	mov    $0x1000,%edx
  801c81:	0f 47 c2             	cmova  %edx,%eax
  801c84:	50                   	push   %eax
  801c85:	68 00 00 40 00       	push   $0x400000
  801c8a:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801c90:	e8 ec f8 ff ff       	call   801581 <readn>
  801c95:	83 c4 10             	add    $0x10,%esp
  801c98:	85 c0                	test   %eax,%eax
  801c9a:	0f 88 eb 01 00 00    	js     801e8b <spawn+0x4b5>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801ca0:	83 ec 0c             	sub    $0xc,%esp
  801ca3:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801ca9:	53                   	push   %ebx
  801caa:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801cb0:	68 00 00 40 00       	push   $0x400000
  801cb5:	6a 00                	push   $0x0
  801cb7:	e8 6b f3 ff ff       	call   801027 <sys_page_map>
  801cbc:	83 c4 20             	add    $0x20,%esp
  801cbf:	85 c0                	test   %eax,%eax
  801cc1:	78 7c                	js     801d3f <spawn+0x369>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  801cc3:	83 ec 08             	sub    $0x8,%esp
  801cc6:	68 00 00 40 00       	push   $0x400000
  801ccb:	6a 00                	push   $0x0
  801ccd:	e8 97 f3 ff ff       	call   801069 <sys_page_unmap>
  801cd2:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  801cd5:	81 c7 00 10 00 00    	add    $0x1000,%edi
  801cdb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801ce1:	89 fe                	mov    %edi,%esi
  801ce3:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  801ce9:	76 69                	jbe    801d54 <spawn+0x37e>
		if (i >= filesz) {
  801ceb:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  801cf1:	0f 87 37 ff ff ff    	ja     801c2e <spawn+0x258>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801cf7:	83 ec 04             	sub    $0x4,%esp
  801cfa:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801d00:	53                   	push   %ebx
  801d01:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801d07:	e8 d8 f2 ff ff       	call   800fe4 <sys_page_alloc>
  801d0c:	83 c4 10             	add    $0x10,%esp
  801d0f:	85 c0                	test   %eax,%eax
  801d11:	79 c2                	jns    801cd5 <spawn+0x2ff>
  801d13:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  801d15:	83 ec 0c             	sub    $0xc,%esp
  801d18:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801d1e:	e8 42 f2 ff ff       	call   800f65 <sys_env_destroy>
	close(fd);
  801d23:	83 c4 04             	add    $0x4,%esp
  801d26:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801d2c:	e8 8b f6 ff ff       	call   8013bc <close>
	return r;
  801d31:	83 c4 10             	add    $0x10,%esp
  801d34:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  801d3a:	e9 30 01 00 00       	jmp    801e6f <spawn+0x499>
				panic("spawn: sys_page_map data: %e", r);
  801d3f:	50                   	push   %eax
  801d40:	68 6f 2c 80 00       	push   $0x802c6f
  801d45:	68 25 01 00 00       	push   $0x125
  801d4a:	68 63 2c 80 00       	push   $0x802c63
  801d4f:	e8 9d e6 ff ff       	call   8003f1 <_panic>
  801d54:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801d5a:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  801d61:	83 c6 20             	add    $0x20,%esi
  801d64:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801d6b:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  801d71:	7e 6d                	jle    801de0 <spawn+0x40a>
		if (ph->p_type != ELF_PROG_LOAD)
  801d73:	83 3e 01             	cmpl   $0x1,(%esi)
  801d76:	75 e2                	jne    801d5a <spawn+0x384>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801d78:	8b 46 18             	mov    0x18(%esi),%eax
  801d7b:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  801d7e:	83 f8 01             	cmp    $0x1,%eax
  801d81:	19 c0                	sbb    %eax,%eax
  801d83:	83 e0 fe             	and    $0xfffffffe,%eax
  801d86:	83 c0 07             	add    $0x7,%eax
  801d89:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801d8f:	8b 4e 04             	mov    0x4(%esi),%ecx
  801d92:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  801d98:	8b 56 10             	mov    0x10(%esi),%edx
  801d9b:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  801da1:	8b 7e 14             	mov    0x14(%esi),%edi
  801da4:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  801daa:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  801dad:	89 d8                	mov    %ebx,%eax
  801daf:	25 ff 0f 00 00       	and    $0xfff,%eax
  801db4:	74 1a                	je     801dd0 <spawn+0x3fa>
		va -= i;
  801db6:	29 c3                	sub    %eax,%ebx
		memsz += i;
  801db8:	01 c7                	add    %eax,%edi
  801dba:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  801dc0:	01 c2                	add    %eax,%edx
  801dc2:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  801dc8:	29 c1                	sub    %eax,%ecx
  801dca:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  801dd0:	bf 00 00 00 00       	mov    $0x0,%edi
  801dd5:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  801ddb:	e9 01 ff ff ff       	jmp    801ce1 <spawn+0x30b>
	close(fd);
  801de0:	83 ec 0c             	sub    $0xc,%esp
  801de3:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801de9:	e8 ce f5 ff ff       	call   8013bc <close>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  801dee:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  801df5:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801df8:	83 c4 08             	add    $0x8,%esp
  801dfb:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801e01:	50                   	push   %eax
  801e02:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801e08:	e8 e0 f2 ff ff       	call   8010ed <sys_env_set_trapframe>
  801e0d:	83 c4 10             	add    $0x10,%esp
  801e10:	85 c0                	test   %eax,%eax
  801e12:	78 25                	js     801e39 <spawn+0x463>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801e14:	83 ec 08             	sub    $0x8,%esp
  801e17:	6a 02                	push   $0x2
  801e19:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801e1f:	e8 87 f2 ff ff       	call   8010ab <sys_env_set_status>
  801e24:	83 c4 10             	add    $0x10,%esp
  801e27:	85 c0                	test   %eax,%eax
  801e29:	78 23                	js     801e4e <spawn+0x478>
	return child;
  801e2b:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801e31:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801e37:	eb 36                	jmp    801e6f <spawn+0x499>
		panic("sys_env_set_trapframe: %e", r);
  801e39:	50                   	push   %eax
  801e3a:	68 8c 2c 80 00       	push   $0x802c8c
  801e3f:	68 86 00 00 00       	push   $0x86
  801e44:	68 63 2c 80 00       	push   $0x802c63
  801e49:	e8 a3 e5 ff ff       	call   8003f1 <_panic>
		panic("sys_env_set_status: %e", r);
  801e4e:	50                   	push   %eax
  801e4f:	68 a6 2c 80 00       	push   $0x802ca6
  801e54:	68 89 00 00 00       	push   $0x89
  801e59:	68 63 2c 80 00       	push   $0x802c63
  801e5e:	e8 8e e5 ff ff       	call   8003f1 <_panic>
		return r;
  801e63:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801e69:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  801e6f:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801e75:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e78:	5b                   	pop    %ebx
  801e79:	5e                   	pop    %esi
  801e7a:	5f                   	pop    %edi
  801e7b:	5d                   	pop    %ebp
  801e7c:	c3                   	ret    
  801e7d:	89 c7                	mov    %eax,%edi
  801e7f:	e9 91 fe ff ff       	jmp    801d15 <spawn+0x33f>
  801e84:	89 c7                	mov    %eax,%edi
  801e86:	e9 8a fe ff ff       	jmp    801d15 <spawn+0x33f>
  801e8b:	89 c7                	mov    %eax,%edi
  801e8d:	e9 83 fe ff ff       	jmp    801d15 <spawn+0x33f>
		return -E_NO_MEM;
  801e92:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801e97:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801e9d:	eb d0                	jmp    801e6f <spawn+0x499>
	sys_page_unmap(0, UTEMP);
  801e9f:	83 ec 08             	sub    $0x8,%esp
  801ea2:	68 00 00 40 00       	push   $0x400000
  801ea7:	6a 00                	push   $0x0
  801ea9:	e8 bb f1 ff ff       	call   801069 <sys_page_unmap>
  801eae:	83 c4 10             	add    $0x10,%esp
  801eb1:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  801eb7:	eb b6                	jmp    801e6f <spawn+0x499>

00801eb9 <spawnl>:
{
  801eb9:	55                   	push   %ebp
  801eba:	89 e5                	mov    %esp,%ebp
  801ebc:	57                   	push   %edi
  801ebd:	56                   	push   %esi
  801ebe:	53                   	push   %ebx
  801ebf:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  801ec2:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  801ec5:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  801eca:	8d 4a 04             	lea    0x4(%edx),%ecx
  801ecd:	83 3a 00             	cmpl   $0x0,(%edx)
  801ed0:	74 07                	je     801ed9 <spawnl+0x20>
		argc++;
  801ed2:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  801ed5:	89 ca                	mov    %ecx,%edx
  801ed7:	eb f1                	jmp    801eca <spawnl+0x11>
	const char *argv[argc+2];
  801ed9:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  801ee0:	83 e2 f0             	and    $0xfffffff0,%edx
  801ee3:	29 d4                	sub    %edx,%esp
  801ee5:	8d 54 24 03          	lea    0x3(%esp),%edx
  801ee9:	c1 ea 02             	shr    $0x2,%edx
  801eec:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  801ef3:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  801ef5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ef8:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  801eff:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  801f06:	00 
	va_start(vl, arg0);
  801f07:	8d 4d 10             	lea    0x10(%ebp),%ecx
  801f0a:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  801f0c:	b8 00 00 00 00       	mov    $0x0,%eax
  801f11:	eb 0b                	jmp    801f1e <spawnl+0x65>
		argv[i+1] = va_arg(vl, const char *);
  801f13:	83 c0 01             	add    $0x1,%eax
  801f16:	8b 39                	mov    (%ecx),%edi
  801f18:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  801f1b:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  801f1e:	39 d0                	cmp    %edx,%eax
  801f20:	75 f1                	jne    801f13 <spawnl+0x5a>
	return spawn(prog, argv);
  801f22:	83 ec 08             	sub    $0x8,%esp
  801f25:	56                   	push   %esi
  801f26:	ff 75 08             	pushl  0x8(%ebp)
  801f29:	e8 a8 fa ff ff       	call   8019d6 <spawn>
}
  801f2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f31:	5b                   	pop    %ebx
  801f32:	5e                   	pop    %esi
  801f33:	5f                   	pop    %edi
  801f34:	5d                   	pop    %ebp
  801f35:	c3                   	ret    

00801f36 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801f36:	55                   	push   %ebp
  801f37:	89 e5                	mov    %esp,%ebp
  801f39:	56                   	push   %esi
  801f3a:	53                   	push   %ebx
  801f3b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801f3e:	83 ec 0c             	sub    $0xc,%esp
  801f41:	ff 75 08             	pushl  0x8(%ebp)
  801f44:	e8 dd f2 ff ff       	call   801226 <fd2data>
  801f49:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801f4b:	83 c4 08             	add    $0x8,%esp
  801f4e:	68 e8 2c 80 00       	push   $0x802ce8
  801f53:	53                   	push   %ebx
  801f54:	e8 99 ec ff ff       	call   800bf2 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801f59:	8b 46 04             	mov    0x4(%esi),%eax
  801f5c:	2b 06                	sub    (%esi),%eax
  801f5e:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801f64:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801f6b:	00 00 00 
	stat->st_dev = &devpipe;
  801f6e:	c7 83 88 00 00 00 ac 	movl   $0x8047ac,0x88(%ebx)
  801f75:	47 80 00 
	return 0;
}
  801f78:	b8 00 00 00 00       	mov    $0x0,%eax
  801f7d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f80:	5b                   	pop    %ebx
  801f81:	5e                   	pop    %esi
  801f82:	5d                   	pop    %ebp
  801f83:	c3                   	ret    

00801f84 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801f84:	55                   	push   %ebp
  801f85:	89 e5                	mov    %esp,%ebp
  801f87:	53                   	push   %ebx
  801f88:	83 ec 0c             	sub    $0xc,%esp
  801f8b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801f8e:	53                   	push   %ebx
  801f8f:	6a 00                	push   $0x0
  801f91:	e8 d3 f0 ff ff       	call   801069 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801f96:	89 1c 24             	mov    %ebx,(%esp)
  801f99:	e8 88 f2 ff ff       	call   801226 <fd2data>
  801f9e:	83 c4 08             	add    $0x8,%esp
  801fa1:	50                   	push   %eax
  801fa2:	6a 00                	push   $0x0
  801fa4:	e8 c0 f0 ff ff       	call   801069 <sys_page_unmap>
}
  801fa9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fac:	c9                   	leave  
  801fad:	c3                   	ret    

00801fae <_pipeisclosed>:
{
  801fae:	55                   	push   %ebp
  801faf:	89 e5                	mov    %esp,%ebp
  801fb1:	57                   	push   %edi
  801fb2:	56                   	push   %esi
  801fb3:	53                   	push   %ebx
  801fb4:	83 ec 1c             	sub    $0x1c,%esp
  801fb7:	89 c7                	mov    %eax,%edi
  801fb9:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801fbb:	a1 90 67 80 00       	mov    0x806790,%eax
  801fc0:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801fc3:	83 ec 0c             	sub    $0xc,%esp
  801fc6:	57                   	push   %edi
  801fc7:	e8 ff 03 00 00       	call   8023cb <pageref>
  801fcc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801fcf:	89 34 24             	mov    %esi,(%esp)
  801fd2:	e8 f4 03 00 00       	call   8023cb <pageref>
		nn = thisenv->env_runs;
  801fd7:	8b 15 90 67 80 00    	mov    0x806790,%edx
  801fdd:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801fe0:	83 c4 10             	add    $0x10,%esp
  801fe3:	39 cb                	cmp    %ecx,%ebx
  801fe5:	74 1b                	je     802002 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801fe7:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801fea:	75 cf                	jne    801fbb <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801fec:	8b 42 58             	mov    0x58(%edx),%eax
  801fef:	6a 01                	push   $0x1
  801ff1:	50                   	push   %eax
  801ff2:	53                   	push   %ebx
  801ff3:	68 ef 2c 80 00       	push   $0x802cef
  801ff8:	e8 cf e4 ff ff       	call   8004cc <cprintf>
  801ffd:	83 c4 10             	add    $0x10,%esp
  802000:	eb b9                	jmp    801fbb <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802002:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802005:	0f 94 c0             	sete   %al
  802008:	0f b6 c0             	movzbl %al,%eax
}
  80200b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80200e:	5b                   	pop    %ebx
  80200f:	5e                   	pop    %esi
  802010:	5f                   	pop    %edi
  802011:	5d                   	pop    %ebp
  802012:	c3                   	ret    

00802013 <devpipe_write>:
{
  802013:	55                   	push   %ebp
  802014:	89 e5                	mov    %esp,%ebp
  802016:	57                   	push   %edi
  802017:	56                   	push   %esi
  802018:	53                   	push   %ebx
  802019:	83 ec 28             	sub    $0x28,%esp
  80201c:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80201f:	56                   	push   %esi
  802020:	e8 01 f2 ff ff       	call   801226 <fd2data>
  802025:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802027:	83 c4 10             	add    $0x10,%esp
  80202a:	bf 00 00 00 00       	mov    $0x0,%edi
  80202f:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802032:	74 4f                	je     802083 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802034:	8b 43 04             	mov    0x4(%ebx),%eax
  802037:	8b 0b                	mov    (%ebx),%ecx
  802039:	8d 51 20             	lea    0x20(%ecx),%edx
  80203c:	39 d0                	cmp    %edx,%eax
  80203e:	72 14                	jb     802054 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802040:	89 da                	mov    %ebx,%edx
  802042:	89 f0                	mov    %esi,%eax
  802044:	e8 65 ff ff ff       	call   801fae <_pipeisclosed>
  802049:	85 c0                	test   %eax,%eax
  80204b:	75 3b                	jne    802088 <devpipe_write+0x75>
			sys_yield();
  80204d:	e8 73 ef ff ff       	call   800fc5 <sys_yield>
  802052:	eb e0                	jmp    802034 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802054:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802057:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80205b:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80205e:	89 c2                	mov    %eax,%edx
  802060:	c1 fa 1f             	sar    $0x1f,%edx
  802063:	89 d1                	mov    %edx,%ecx
  802065:	c1 e9 1b             	shr    $0x1b,%ecx
  802068:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80206b:	83 e2 1f             	and    $0x1f,%edx
  80206e:	29 ca                	sub    %ecx,%edx
  802070:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802074:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802078:	83 c0 01             	add    $0x1,%eax
  80207b:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80207e:	83 c7 01             	add    $0x1,%edi
  802081:	eb ac                	jmp    80202f <devpipe_write+0x1c>
	return i;
  802083:	8b 45 10             	mov    0x10(%ebp),%eax
  802086:	eb 05                	jmp    80208d <devpipe_write+0x7a>
				return 0;
  802088:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80208d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802090:	5b                   	pop    %ebx
  802091:	5e                   	pop    %esi
  802092:	5f                   	pop    %edi
  802093:	5d                   	pop    %ebp
  802094:	c3                   	ret    

00802095 <devpipe_read>:
{
  802095:	55                   	push   %ebp
  802096:	89 e5                	mov    %esp,%ebp
  802098:	57                   	push   %edi
  802099:	56                   	push   %esi
  80209a:	53                   	push   %ebx
  80209b:	83 ec 18             	sub    $0x18,%esp
  80209e:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8020a1:	57                   	push   %edi
  8020a2:	e8 7f f1 ff ff       	call   801226 <fd2data>
  8020a7:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8020a9:	83 c4 10             	add    $0x10,%esp
  8020ac:	be 00 00 00 00       	mov    $0x0,%esi
  8020b1:	3b 75 10             	cmp    0x10(%ebp),%esi
  8020b4:	75 14                	jne    8020ca <devpipe_read+0x35>
	return i;
  8020b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8020b9:	eb 02                	jmp    8020bd <devpipe_read+0x28>
				return i;
  8020bb:	89 f0                	mov    %esi,%eax
}
  8020bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020c0:	5b                   	pop    %ebx
  8020c1:	5e                   	pop    %esi
  8020c2:	5f                   	pop    %edi
  8020c3:	5d                   	pop    %ebp
  8020c4:	c3                   	ret    
			sys_yield();
  8020c5:	e8 fb ee ff ff       	call   800fc5 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8020ca:	8b 03                	mov    (%ebx),%eax
  8020cc:	3b 43 04             	cmp    0x4(%ebx),%eax
  8020cf:	75 18                	jne    8020e9 <devpipe_read+0x54>
			if (i > 0)
  8020d1:	85 f6                	test   %esi,%esi
  8020d3:	75 e6                	jne    8020bb <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8020d5:	89 da                	mov    %ebx,%edx
  8020d7:	89 f8                	mov    %edi,%eax
  8020d9:	e8 d0 fe ff ff       	call   801fae <_pipeisclosed>
  8020de:	85 c0                	test   %eax,%eax
  8020e0:	74 e3                	je     8020c5 <devpipe_read+0x30>
				return 0;
  8020e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8020e7:	eb d4                	jmp    8020bd <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8020e9:	99                   	cltd   
  8020ea:	c1 ea 1b             	shr    $0x1b,%edx
  8020ed:	01 d0                	add    %edx,%eax
  8020ef:	83 e0 1f             	and    $0x1f,%eax
  8020f2:	29 d0                	sub    %edx,%eax
  8020f4:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8020f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8020fc:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8020ff:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802102:	83 c6 01             	add    $0x1,%esi
  802105:	eb aa                	jmp    8020b1 <devpipe_read+0x1c>

00802107 <pipe>:
{
  802107:	55                   	push   %ebp
  802108:	89 e5                	mov    %esp,%ebp
  80210a:	56                   	push   %esi
  80210b:	53                   	push   %ebx
  80210c:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80210f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802112:	50                   	push   %eax
  802113:	e8 25 f1 ff ff       	call   80123d <fd_alloc>
  802118:	89 c3                	mov    %eax,%ebx
  80211a:	83 c4 10             	add    $0x10,%esp
  80211d:	85 c0                	test   %eax,%eax
  80211f:	0f 88 23 01 00 00    	js     802248 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802125:	83 ec 04             	sub    $0x4,%esp
  802128:	68 07 04 00 00       	push   $0x407
  80212d:	ff 75 f4             	pushl  -0xc(%ebp)
  802130:	6a 00                	push   $0x0
  802132:	e8 ad ee ff ff       	call   800fe4 <sys_page_alloc>
  802137:	89 c3                	mov    %eax,%ebx
  802139:	83 c4 10             	add    $0x10,%esp
  80213c:	85 c0                	test   %eax,%eax
  80213e:	0f 88 04 01 00 00    	js     802248 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802144:	83 ec 0c             	sub    $0xc,%esp
  802147:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80214a:	50                   	push   %eax
  80214b:	e8 ed f0 ff ff       	call   80123d <fd_alloc>
  802150:	89 c3                	mov    %eax,%ebx
  802152:	83 c4 10             	add    $0x10,%esp
  802155:	85 c0                	test   %eax,%eax
  802157:	0f 88 db 00 00 00    	js     802238 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80215d:	83 ec 04             	sub    $0x4,%esp
  802160:	68 07 04 00 00       	push   $0x407
  802165:	ff 75 f0             	pushl  -0x10(%ebp)
  802168:	6a 00                	push   $0x0
  80216a:	e8 75 ee ff ff       	call   800fe4 <sys_page_alloc>
  80216f:	89 c3                	mov    %eax,%ebx
  802171:	83 c4 10             	add    $0x10,%esp
  802174:	85 c0                	test   %eax,%eax
  802176:	0f 88 bc 00 00 00    	js     802238 <pipe+0x131>
	va = fd2data(fd0);
  80217c:	83 ec 0c             	sub    $0xc,%esp
  80217f:	ff 75 f4             	pushl  -0xc(%ebp)
  802182:	e8 9f f0 ff ff       	call   801226 <fd2data>
  802187:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802189:	83 c4 0c             	add    $0xc,%esp
  80218c:	68 07 04 00 00       	push   $0x407
  802191:	50                   	push   %eax
  802192:	6a 00                	push   $0x0
  802194:	e8 4b ee ff ff       	call   800fe4 <sys_page_alloc>
  802199:	89 c3                	mov    %eax,%ebx
  80219b:	83 c4 10             	add    $0x10,%esp
  80219e:	85 c0                	test   %eax,%eax
  8021a0:	0f 88 82 00 00 00    	js     802228 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021a6:	83 ec 0c             	sub    $0xc,%esp
  8021a9:	ff 75 f0             	pushl  -0x10(%ebp)
  8021ac:	e8 75 f0 ff ff       	call   801226 <fd2data>
  8021b1:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8021b8:	50                   	push   %eax
  8021b9:	6a 00                	push   $0x0
  8021bb:	56                   	push   %esi
  8021bc:	6a 00                	push   $0x0
  8021be:	e8 64 ee ff ff       	call   801027 <sys_page_map>
  8021c3:	89 c3                	mov    %eax,%ebx
  8021c5:	83 c4 20             	add    $0x20,%esp
  8021c8:	85 c0                	test   %eax,%eax
  8021ca:	78 4e                	js     80221a <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8021cc:	a1 ac 47 80 00       	mov    0x8047ac,%eax
  8021d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021d4:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8021d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021d9:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8021e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021e3:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8021e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021e8:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8021ef:	83 ec 0c             	sub    $0xc,%esp
  8021f2:	ff 75 f4             	pushl  -0xc(%ebp)
  8021f5:	e8 1c f0 ff ff       	call   801216 <fd2num>
  8021fa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8021fd:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8021ff:	83 c4 04             	add    $0x4,%esp
  802202:	ff 75 f0             	pushl  -0x10(%ebp)
  802205:	e8 0c f0 ff ff       	call   801216 <fd2num>
  80220a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80220d:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802210:	83 c4 10             	add    $0x10,%esp
  802213:	bb 00 00 00 00       	mov    $0x0,%ebx
  802218:	eb 2e                	jmp    802248 <pipe+0x141>
	sys_page_unmap(0, va);
  80221a:	83 ec 08             	sub    $0x8,%esp
  80221d:	56                   	push   %esi
  80221e:	6a 00                	push   $0x0
  802220:	e8 44 ee ff ff       	call   801069 <sys_page_unmap>
  802225:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802228:	83 ec 08             	sub    $0x8,%esp
  80222b:	ff 75 f0             	pushl  -0x10(%ebp)
  80222e:	6a 00                	push   $0x0
  802230:	e8 34 ee ff ff       	call   801069 <sys_page_unmap>
  802235:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802238:	83 ec 08             	sub    $0x8,%esp
  80223b:	ff 75 f4             	pushl  -0xc(%ebp)
  80223e:	6a 00                	push   $0x0
  802240:	e8 24 ee ff ff       	call   801069 <sys_page_unmap>
  802245:	83 c4 10             	add    $0x10,%esp
}
  802248:	89 d8                	mov    %ebx,%eax
  80224a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80224d:	5b                   	pop    %ebx
  80224e:	5e                   	pop    %esi
  80224f:	5d                   	pop    %ebp
  802250:	c3                   	ret    

00802251 <pipeisclosed>:
{
  802251:	55                   	push   %ebp
  802252:	89 e5                	mov    %esp,%ebp
  802254:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802257:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80225a:	50                   	push   %eax
  80225b:	ff 75 08             	pushl  0x8(%ebp)
  80225e:	e8 2c f0 ff ff       	call   80128f <fd_lookup>
  802263:	83 c4 10             	add    $0x10,%esp
  802266:	85 c0                	test   %eax,%eax
  802268:	78 18                	js     802282 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80226a:	83 ec 0c             	sub    $0xc,%esp
  80226d:	ff 75 f4             	pushl  -0xc(%ebp)
  802270:	e8 b1 ef ff ff       	call   801226 <fd2data>
	return _pipeisclosed(fd, p);
  802275:	89 c2                	mov    %eax,%edx
  802277:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227a:	e8 2f fd ff ff       	call   801fae <_pipeisclosed>
  80227f:	83 c4 10             	add    $0x10,%esp
}
  802282:	c9                   	leave  
  802283:	c3                   	ret    

00802284 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802284:	55                   	push   %ebp
  802285:	89 e5                	mov    %esp,%ebp
  802287:	56                   	push   %esi
  802288:	53                   	push   %ebx
  802289:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  80228c:	85 f6                	test   %esi,%esi
  80228e:	74 16                	je     8022a6 <wait+0x22>
	e = &envs[ENVX(envid)];
  802290:	89 f3                	mov    %esi,%ebx
  802292:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802298:	69 db 84 00 00 00    	imul   $0x84,%ebx,%ebx
  80229e:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8022a4:	eb 1b                	jmp    8022c1 <wait+0x3d>
	assert(envid != 0);
  8022a6:	68 07 2d 80 00       	push   $0x802d07
  8022ab:	68 28 2c 80 00       	push   $0x802c28
  8022b0:	6a 09                	push   $0x9
  8022b2:	68 12 2d 80 00       	push   $0x802d12
  8022b7:	e8 35 e1 ff ff       	call   8003f1 <_panic>
		sys_yield();
  8022bc:	e8 04 ed ff ff       	call   800fc5 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8022c1:	8b 43 48             	mov    0x48(%ebx),%eax
  8022c4:	39 f0                	cmp    %esi,%eax
  8022c6:	75 07                	jne    8022cf <wait+0x4b>
  8022c8:	8b 43 54             	mov    0x54(%ebx),%eax
  8022cb:	85 c0                	test   %eax,%eax
  8022cd:	75 ed                	jne    8022bc <wait+0x38>
}
  8022cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022d2:	5b                   	pop    %ebx
  8022d3:	5e                   	pop    %esi
  8022d4:	5d                   	pop    %ebp
  8022d5:	c3                   	ret    

008022d6 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8022d6:	55                   	push   %ebp
  8022d7:	89 e5                	mov    %esp,%ebp
  8022d9:	56                   	push   %esi
  8022da:	53                   	push   %ebx
  8022db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8022de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022e1:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// return 0;
	if(!pg)
  8022e4:	85 c0                	test   %eax,%eax
		pg = (void*)UTOP;
  8022e6:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8022eb:	0f 44 c2             	cmove  %edx,%eax
	
	int ret;

	ret = sys_ipc_recv(pg);
  8022ee:	83 ec 0c             	sub    $0xc,%esp
  8022f1:	50                   	push   %eax
  8022f2:	e8 9d ee ff ff       	call   801194 <sys_ipc_recv>
	if(ret < 0){
  8022f7:	83 c4 10             	add    $0x10,%esp
  8022fa:	85 c0                	test   %eax,%eax
  8022fc:	78 2b                	js     802329 <ipc_recv+0x53>
		if(perm_store) *perm_store = 0;
		if(from_env_store) *from_env_store = 0;
		return ret;
	}
	
	if(perm_store)
  8022fe:	85 f6                	test   %esi,%esi
  802300:	74 0a                	je     80230c <ipc_recv+0x36>
		*perm_store = thisenv->env_ipc_perm;
  802302:	a1 90 67 80 00       	mov    0x806790,%eax
  802307:	8b 40 78             	mov    0x78(%eax),%eax
  80230a:	89 06                	mov    %eax,(%esi)
	if(from_env_store)
  80230c:	85 db                	test   %ebx,%ebx
  80230e:	74 0a                	je     80231a <ipc_recv+0x44>
		*from_env_store = thisenv->env_ipc_from;
  802310:	a1 90 67 80 00       	mov    0x806790,%eax
  802315:	8b 40 74             	mov    0x74(%eax),%eax
  802318:	89 03                	mov    %eax,(%ebx)

	return thisenv->env_ipc_value;
  80231a:	a1 90 67 80 00       	mov    0x806790,%eax
  80231f:	8b 40 70             	mov    0x70(%eax),%eax
}
  802322:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802325:	5b                   	pop    %ebx
  802326:	5e                   	pop    %esi
  802327:	5d                   	pop    %ebp
  802328:	c3                   	ret    
		if(perm_store) *perm_store = 0;
  802329:	85 f6                	test   %esi,%esi
  80232b:	74 06                	je     802333 <ipc_recv+0x5d>
  80232d:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(from_env_store) *from_env_store = 0;
  802333:	85 db                	test   %ebx,%ebx
  802335:	74 eb                	je     802322 <ipc_recv+0x4c>
  802337:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80233d:	eb e3                	jmp    802322 <ipc_recv+0x4c>

0080233f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80233f:	55                   	push   %ebp
  802340:	89 e5                	mov    %esp,%ebp
  802342:	57                   	push   %edi
  802343:	56                   	push   %esi
  802344:	53                   	push   %ebx
  802345:	83 ec 0c             	sub    $0xc,%esp
  802348:	8b 7d 08             	mov    0x8(%ebp),%edi
  80234b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80234e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
	if (!pg)
  802351:	85 db                	test   %ebx,%ebx
		pg = (void*)UTOP;
  802353:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802358:	0f 44 d8             	cmove  %eax,%ebx

	int ret = -E_IPC_NOT_RECV;
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))) {
  80235b:	ff 75 14             	pushl  0x14(%ebp)
  80235e:	53                   	push   %ebx
  80235f:	56                   	push   %esi
  802360:	57                   	push   %edi
  802361:	e8 0b ee ff ff       	call   801171 <sys_ipc_try_send>
  802366:	83 c4 10             	add    $0x10,%esp
  802369:	85 c0                	test   %eax,%eax
  80236b:	74 17                	je     802384 <ipc_send+0x45>
		if(ret != -E_IPC_NOT_RECV){
  80236d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802370:	74 e9                	je     80235b <ipc_send+0x1c>
			panic("ipc_send: ret : %d", ret);
  802372:	50                   	push   %eax
  802373:	68 1d 2d 80 00       	push   $0x802d1d
  802378:	6a 43                	push   $0x43
  80237a:	68 30 2d 80 00       	push   $0x802d30
  80237f:	e8 6d e0 ff ff       	call   8003f1 <_panic>
			sys_yield();
		}
	}
}
  802384:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802387:	5b                   	pop    %ebx
  802388:	5e                   	pop    %esi
  802389:	5f                   	pop    %edi
  80238a:	5d                   	pop    %ebp
  80238b:	c3                   	ret    

0080238c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80238c:	55                   	push   %ebp
  80238d:	89 e5                	mov    %esp,%ebp
  80238f:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802392:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802397:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  80239d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8023a3:	8b 52 50             	mov    0x50(%edx),%edx
  8023a6:	39 ca                	cmp    %ecx,%edx
  8023a8:	74 11                	je     8023bb <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  8023aa:	83 c0 01             	add    $0x1,%eax
  8023ad:	3d 00 04 00 00       	cmp    $0x400,%eax
  8023b2:	75 e3                	jne    802397 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8023b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8023b9:	eb 0e                	jmp    8023c9 <ipc_find_env+0x3d>
			return envs[i].env_id;
  8023bb:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8023c1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8023c6:	8b 40 48             	mov    0x48(%eax),%eax
}
  8023c9:	5d                   	pop    %ebp
  8023ca:	c3                   	ret    

008023cb <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8023cb:	55                   	push   %ebp
  8023cc:	89 e5                	mov    %esp,%ebp
  8023ce:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8023d1:	89 d0                	mov    %edx,%eax
  8023d3:	c1 e8 16             	shr    $0x16,%eax
  8023d6:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8023dd:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8023e2:	f6 c1 01             	test   $0x1,%cl
  8023e5:	74 1d                	je     802404 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8023e7:	c1 ea 0c             	shr    $0xc,%edx
  8023ea:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8023f1:	f6 c2 01             	test   $0x1,%dl
  8023f4:	74 0e                	je     802404 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8023f6:	c1 ea 0c             	shr    $0xc,%edx
  8023f9:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802400:	ef 
  802401:	0f b7 c0             	movzwl %ax,%eax
}
  802404:	5d                   	pop    %ebp
  802405:	c3                   	ret    
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
