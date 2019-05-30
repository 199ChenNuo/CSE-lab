
obj/user/testkbd.debug:     file format elf32-i386


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
  80002c:	e8 29 02 00 00       	call   80025a <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 04             	sub    $0x4,%esp
  80003a:	bb 0a 00 00 00       	mov    $0xa,%ebx
	int i, r;

	// Spin for a bit to let the console quiet
	for (i = 0; i < 10; ++i)
		sys_yield();
  80003f:	e8 35 0f 00 00       	call   800f79 <sys_yield>
	for (i = 0; i < 10; ++i)
  800044:	83 eb 01             	sub    $0x1,%ebx
  800047:	75 f6                	jne    80003f <umain+0xc>

	close(0);
  800049:	83 ec 0c             	sub    $0xc,%esp
  80004c:	6a 00                	push   $0x0
  80004e:	e8 1d 13 00 00       	call   801370 <close>
	if ((r = opencons()) < 0)
  800053:	e8 b0 01 00 00       	call   800208 <opencons>
  800058:	83 c4 10             	add    $0x10,%esp
  80005b:	85 c0                	test   %eax,%eax
  80005d:	78 14                	js     800073 <umain+0x40>
		panic("opencons: %e", r);
	if (r != 0)
  80005f:	74 24                	je     800085 <umain+0x52>
		panic("first opencons used fd %d", r);
  800061:	50                   	push   %eax
  800062:	68 9c 21 80 00       	push   $0x80219c
  800067:	6a 11                	push   $0x11
  800069:	68 8d 21 80 00       	push   $0x80218d
  80006e:	e8 42 02 00 00       	call   8002b5 <_panic>
		panic("opencons: %e", r);
  800073:	50                   	push   %eax
  800074:	68 80 21 80 00       	push   $0x802180
  800079:	6a 0f                	push   $0xf
  80007b:	68 8d 21 80 00       	push   $0x80218d
  800080:	e8 30 02 00 00       	call   8002b5 <_panic>
	if ((r = dup(0, 1)) < 0)
  800085:	83 ec 08             	sub    $0x8,%esp
  800088:	6a 01                	push   $0x1
  80008a:	6a 00                	push   $0x0
  80008c:	e8 31 13 00 00       	call   8013c2 <dup>
  800091:	83 c4 10             	add    $0x10,%esp
  800094:	85 c0                	test   %eax,%eax
  800096:	79 24                	jns    8000bc <umain+0x89>
		panic("dup: %e", r);
  800098:	50                   	push   %eax
  800099:	68 b6 21 80 00       	push   $0x8021b6
  80009e:	6a 13                	push   $0x13
  8000a0:	68 8d 21 80 00       	push   $0x80218d
  8000a5:	e8 0b 02 00 00       	call   8002b5 <_panic>

		buf = readline("Type a line: ");
		if (buf != NULL)
			fprintf(1, "%s\n", buf);
		else
			fprintf(1, "(end of file received)\n");
  8000aa:	83 ec 08             	sub    $0x8,%esp
  8000ad:	68 d0 21 80 00       	push   $0x8021d0
  8000b2:	6a 01                	push   $0x1
  8000b4:	e8 b8 19 00 00       	call   801a71 <fprintf>
  8000b9:	83 c4 10             	add    $0x10,%esp
		buf = readline("Type a line: ");
  8000bc:	83 ec 0c             	sub    $0xc,%esp
  8000bf:	68 be 21 80 00       	push   $0x8021be
  8000c4:	e8 b4 09 00 00       	call   800a7d <readline>
		if (buf != NULL)
  8000c9:	83 c4 10             	add    $0x10,%esp
  8000cc:	85 c0                	test   %eax,%eax
  8000ce:	74 da                	je     8000aa <umain+0x77>
			fprintf(1, "%s\n", buf);
  8000d0:	83 ec 04             	sub    $0x4,%esp
  8000d3:	50                   	push   %eax
  8000d4:	68 cc 21 80 00       	push   $0x8021cc
  8000d9:	6a 01                	push   $0x1
  8000db:	e8 91 19 00 00       	call   801a71 <fprintf>
  8000e0:	83 c4 10             	add    $0x10,%esp
  8000e3:	eb d7                	jmp    8000bc <umain+0x89>

008000e5 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8000e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ea:	c3                   	ret    

008000eb <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8000eb:	55                   	push   %ebp
  8000ec:	89 e5                	mov    %esp,%ebp
  8000ee:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8000f1:	68 e8 21 80 00       	push   $0x8021e8
  8000f6:	ff 75 0c             	pushl  0xc(%ebp)
  8000f9:	e8 a8 0a 00 00       	call   800ba6 <strcpy>
	return 0;
}
  8000fe:	b8 00 00 00 00       	mov    $0x0,%eax
  800103:	c9                   	leave  
  800104:	c3                   	ret    

00800105 <devcons_write>:
{
  800105:	55                   	push   %ebp
  800106:	89 e5                	mov    %esp,%ebp
  800108:	57                   	push   %edi
  800109:	56                   	push   %esi
  80010a:	53                   	push   %ebx
  80010b:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  800111:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  800116:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80011c:	3b 75 10             	cmp    0x10(%ebp),%esi
  80011f:	73 31                	jae    800152 <devcons_write+0x4d>
		m = n - tot;
  800121:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800124:	29 f3                	sub    %esi,%ebx
  800126:	83 fb 7f             	cmp    $0x7f,%ebx
  800129:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80012e:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  800131:	83 ec 04             	sub    $0x4,%esp
  800134:	53                   	push   %ebx
  800135:	89 f0                	mov    %esi,%eax
  800137:	03 45 0c             	add    0xc(%ebp),%eax
  80013a:	50                   	push   %eax
  80013b:	57                   	push   %edi
  80013c:	e8 f3 0b 00 00       	call   800d34 <memmove>
		sys_cputs(buf, m);
  800141:	83 c4 08             	add    $0x8,%esp
  800144:	53                   	push   %ebx
  800145:	57                   	push   %edi
  800146:	e8 91 0d 00 00       	call   800edc <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80014b:	01 de                	add    %ebx,%esi
  80014d:	83 c4 10             	add    $0x10,%esp
  800150:	eb ca                	jmp    80011c <devcons_write+0x17>
}
  800152:	89 f0                	mov    %esi,%eax
  800154:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800157:	5b                   	pop    %ebx
  800158:	5e                   	pop    %esi
  800159:	5f                   	pop    %edi
  80015a:	5d                   	pop    %ebp
  80015b:	c3                   	ret    

0080015c <devcons_read>:
{
  80015c:	55                   	push   %ebp
  80015d:	89 e5                	mov    %esp,%ebp
  80015f:	83 ec 08             	sub    $0x8,%esp
  800162:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  800167:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80016b:	74 21                	je     80018e <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80016d:	e8 88 0d 00 00       	call   800efa <sys_cgetc>
  800172:	85 c0                	test   %eax,%eax
  800174:	75 07                	jne    80017d <devcons_read+0x21>
		sys_yield();
  800176:	e8 fe 0d 00 00       	call   800f79 <sys_yield>
  80017b:	eb f0                	jmp    80016d <devcons_read+0x11>
	if (c < 0)
  80017d:	78 0f                	js     80018e <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80017f:	83 f8 04             	cmp    $0x4,%eax
  800182:	74 0c                	je     800190 <devcons_read+0x34>
	*(char*)vbuf = c;
  800184:	8b 55 0c             	mov    0xc(%ebp),%edx
  800187:	88 02                	mov    %al,(%edx)
	return 1;
  800189:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80018e:	c9                   	leave  
  80018f:	c3                   	ret    
		return 0;
  800190:	b8 00 00 00 00       	mov    $0x0,%eax
  800195:	eb f7                	jmp    80018e <devcons_read+0x32>

00800197 <cputchar>:
{
  800197:	55                   	push   %ebp
  800198:	89 e5                	mov    %esp,%ebp
  80019a:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80019d:	8b 45 08             	mov    0x8(%ebp),%eax
  8001a0:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8001a3:	6a 01                	push   $0x1
  8001a5:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8001a8:	50                   	push   %eax
  8001a9:	e8 2e 0d 00 00       	call   800edc <sys_cputs>
}
  8001ae:	83 c4 10             	add    $0x10,%esp
  8001b1:	c9                   	leave  
  8001b2:	c3                   	ret    

008001b3 <getchar>:
{
  8001b3:	55                   	push   %ebp
  8001b4:	89 e5                	mov    %esp,%ebp
  8001b6:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8001b9:	6a 01                	push   $0x1
  8001bb:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8001be:	50                   	push   %eax
  8001bf:	6a 00                	push   $0x0
  8001c1:	e8 e8 12 00 00       	call   8014ae <read>
	if (r < 0)
  8001c6:	83 c4 10             	add    $0x10,%esp
  8001c9:	85 c0                	test   %eax,%eax
  8001cb:	78 06                	js     8001d3 <getchar+0x20>
	if (r < 1)
  8001cd:	74 06                	je     8001d5 <getchar+0x22>
	return c;
  8001cf:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8001d3:	c9                   	leave  
  8001d4:	c3                   	ret    
		return -E_EOF;
  8001d5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8001da:	eb f7                	jmp    8001d3 <getchar+0x20>

008001dc <iscons>:
{
  8001dc:	55                   	push   %ebp
  8001dd:	89 e5                	mov    %esp,%ebp
  8001df:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8001e2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8001e5:	50                   	push   %eax
  8001e6:	ff 75 08             	pushl  0x8(%ebp)
  8001e9:	e8 55 10 00 00       	call   801243 <fd_lookup>
  8001ee:	83 c4 10             	add    $0x10,%esp
  8001f1:	85 c0                	test   %eax,%eax
  8001f3:	78 11                	js     800206 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8001f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001f8:	8b 15 00 30 80 00    	mov    0x803000,%edx
  8001fe:	39 10                	cmp    %edx,(%eax)
  800200:	0f 94 c0             	sete   %al
  800203:	0f b6 c0             	movzbl %al,%eax
}
  800206:	c9                   	leave  
  800207:	c3                   	ret    

00800208 <opencons>:
{
  800208:	55                   	push   %ebp
  800209:	89 e5                	mov    %esp,%ebp
  80020b:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80020e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800211:	50                   	push   %eax
  800212:	e8 da 0f 00 00       	call   8011f1 <fd_alloc>
  800217:	83 c4 10             	add    $0x10,%esp
  80021a:	85 c0                	test   %eax,%eax
  80021c:	78 3a                	js     800258 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80021e:	83 ec 04             	sub    $0x4,%esp
  800221:	68 07 04 00 00       	push   $0x407
  800226:	ff 75 f4             	pushl  -0xc(%ebp)
  800229:	6a 00                	push   $0x0
  80022b:	e8 68 0d 00 00       	call   800f98 <sys_page_alloc>
  800230:	83 c4 10             	add    $0x10,%esp
  800233:	85 c0                	test   %eax,%eax
  800235:	78 21                	js     800258 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  800237:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80023a:	8b 15 00 30 80 00    	mov    0x803000,%edx
  800240:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  800242:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800245:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80024c:	83 ec 0c             	sub    $0xc,%esp
  80024f:	50                   	push   %eax
  800250:	e8 75 0f 00 00       	call   8011ca <fd2num>
  800255:	83 c4 10             	add    $0x10,%esp
}
  800258:	c9                   	leave  
  800259:	c3                   	ret    

0080025a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80025a:	55                   	push   %ebp
  80025b:	89 e5                	mov    %esp,%ebp
  80025d:	56                   	push   %esi
  80025e:	53                   	push   %ebx
  80025f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800262:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	// thisenv = 0;
	thisenv = &(envs[ENVX(sys_getenvid())]);
  800265:	e8 f0 0c 00 00       	call   800f5a <sys_getenvid>
  80026a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80026f:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  800275:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80027a:	a3 04 44 80 00       	mov    %eax,0x804404

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80027f:	85 db                	test   %ebx,%ebx
  800281:	7e 07                	jle    80028a <libmain+0x30>
		binaryname = argv[0];
  800283:	8b 06                	mov    (%esi),%eax
  800285:	a3 1c 30 80 00       	mov    %eax,0x80301c

	// call user main routine
	umain(argc, argv);
  80028a:	83 ec 08             	sub    $0x8,%esp
  80028d:	56                   	push   %esi
  80028e:	53                   	push   %ebx
  80028f:	e8 9f fd ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800294:	e8 0a 00 00 00       	call   8002a3 <exit>
}
  800299:	83 c4 10             	add    $0x10,%esp
  80029c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80029f:	5b                   	pop    %ebx
  8002a0:	5e                   	pop    %esi
  8002a1:	5d                   	pop    %ebp
  8002a2:	c3                   	ret    

008002a3 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8002a3:	55                   	push   %ebp
  8002a4:	89 e5                	mov    %esp,%ebp
  8002a6:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  8002a9:	6a 00                	push   $0x0
  8002ab:	e8 69 0c 00 00       	call   800f19 <sys_env_destroy>
}
  8002b0:	83 c4 10             	add    $0x10,%esp
  8002b3:	c9                   	leave  
  8002b4:	c3                   	ret    

008002b5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8002b5:	55                   	push   %ebp
  8002b6:	89 e5                	mov    %esp,%ebp
  8002b8:	56                   	push   %esi
  8002b9:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8002ba:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002bd:	8b 35 1c 30 80 00    	mov    0x80301c,%esi
  8002c3:	e8 92 0c 00 00       	call   800f5a <sys_getenvid>
  8002c8:	83 ec 0c             	sub    $0xc,%esp
  8002cb:	ff 75 0c             	pushl  0xc(%ebp)
  8002ce:	ff 75 08             	pushl  0x8(%ebp)
  8002d1:	56                   	push   %esi
  8002d2:	50                   	push   %eax
  8002d3:	68 00 22 80 00       	push   $0x802200
  8002d8:	e8 b3 00 00 00       	call   800390 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002dd:	83 c4 18             	add    $0x18,%esp
  8002e0:	53                   	push   %ebx
  8002e1:	ff 75 10             	pushl  0x10(%ebp)
  8002e4:	e8 56 00 00 00       	call   80033f <vcprintf>
	cprintf("\n");
  8002e9:	c7 04 24 e6 21 80 00 	movl   $0x8021e6,(%esp)
  8002f0:	e8 9b 00 00 00       	call   800390 <cprintf>
  8002f5:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002f8:	cc                   	int3   
  8002f9:	eb fd                	jmp    8002f8 <_panic+0x43>

008002fb <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002fb:	55                   	push   %ebp
  8002fc:	89 e5                	mov    %esp,%ebp
  8002fe:	53                   	push   %ebx
  8002ff:	83 ec 04             	sub    $0x4,%esp
  800302:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800305:	8b 13                	mov    (%ebx),%edx
  800307:	8d 42 01             	lea    0x1(%edx),%eax
  80030a:	89 03                	mov    %eax,(%ebx)
  80030c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80030f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800313:	3d ff 00 00 00       	cmp    $0xff,%eax
  800318:	74 09                	je     800323 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80031a:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80031e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800321:	c9                   	leave  
  800322:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800323:	83 ec 08             	sub    $0x8,%esp
  800326:	68 ff 00 00 00       	push   $0xff
  80032b:	8d 43 08             	lea    0x8(%ebx),%eax
  80032e:	50                   	push   %eax
  80032f:	e8 a8 0b 00 00       	call   800edc <sys_cputs>
		b->idx = 0;
  800334:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80033a:	83 c4 10             	add    $0x10,%esp
  80033d:	eb db                	jmp    80031a <putch+0x1f>

0080033f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80033f:	55                   	push   %ebp
  800340:	89 e5                	mov    %esp,%ebp
  800342:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800348:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80034f:	00 00 00 
	b.cnt = 0;
  800352:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800359:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80035c:	ff 75 0c             	pushl  0xc(%ebp)
  80035f:	ff 75 08             	pushl  0x8(%ebp)
  800362:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800368:	50                   	push   %eax
  800369:	68 fb 02 80 00       	push   $0x8002fb
  80036e:	e8 4a 01 00 00       	call   8004bd <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800373:	83 c4 08             	add    $0x8,%esp
  800376:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80037c:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800382:	50                   	push   %eax
  800383:	e8 54 0b 00 00       	call   800edc <sys_cputs>

	return b.cnt;
}
  800388:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80038e:	c9                   	leave  
  80038f:	c3                   	ret    

00800390 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800390:	55                   	push   %ebp
  800391:	89 e5                	mov    %esp,%ebp
  800393:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800396:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800399:	50                   	push   %eax
  80039a:	ff 75 08             	pushl  0x8(%ebp)
  80039d:	e8 9d ff ff ff       	call   80033f <vcprintf>
	va_end(ap);

	return cnt;
}
  8003a2:	c9                   	leave  
  8003a3:	c3                   	ret    

008003a4 <printnum>:


static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003a4:	55                   	push   %ebp
  8003a5:	89 e5                	mov    %esp,%ebp
  8003a7:	57                   	push   %edi
  8003a8:	56                   	push   %esi
  8003a9:	53                   	push   %ebx
  8003aa:	83 ec 1c             	sub    $0x1c,%esp
  8003ad:	89 c6                	mov    %eax,%esi
  8003af:	89 d7                	mov    %edx,%edi
  8003b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003b7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003ba:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8003bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8003c0:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	// to support '-'
	if(padc == '-'){
  8003c3:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8003c7:	74 2c                	je     8003f5 <printnum+0x51>
		while (--width > 0)
			putch(' ', putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003c9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003cc:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8003d3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003d6:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003d9:	39 c2                	cmp    %eax,%edx
  8003db:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8003de:	73 43                	jae    800423 <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003e0:	83 eb 01             	sub    $0x1,%ebx
  8003e3:	85 db                	test   %ebx,%ebx
  8003e5:	7e 6c                	jle    800453 <printnum+0xaf>
			putch(padc, putdat);
  8003e7:	83 ec 08             	sub    $0x8,%esp
  8003ea:	57                   	push   %edi
  8003eb:	ff 75 18             	pushl  0x18(%ebp)
  8003ee:	ff d6                	call   *%esi
  8003f0:	83 c4 10             	add    $0x10,%esp
  8003f3:	eb eb                	jmp    8003e0 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8003f5:	83 ec 0c             	sub    $0xc,%esp
  8003f8:	6a 20                	push   $0x20
  8003fa:	6a 00                	push   $0x0
  8003fc:	50                   	push   %eax
  8003fd:	ff 75 e4             	pushl  -0x1c(%ebp)
  800400:	ff 75 e0             	pushl  -0x20(%ebp)
  800403:	89 fa                	mov    %edi,%edx
  800405:	89 f0                	mov    %esi,%eax
  800407:	e8 98 ff ff ff       	call   8003a4 <printnum>
		while (--width > 0)
  80040c:	83 c4 20             	add    $0x20,%esp
  80040f:	83 eb 01             	sub    $0x1,%ebx
  800412:	85 db                	test   %ebx,%ebx
  800414:	7e 65                	jle    80047b <printnum+0xd7>
			putch(' ', putdat);
  800416:	83 ec 08             	sub    $0x8,%esp
  800419:	57                   	push   %edi
  80041a:	6a 20                	push   $0x20
  80041c:	ff d6                	call   *%esi
  80041e:	83 c4 10             	add    $0x10,%esp
  800421:	eb ec                	jmp    80040f <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800423:	83 ec 0c             	sub    $0xc,%esp
  800426:	ff 75 18             	pushl  0x18(%ebp)
  800429:	83 eb 01             	sub    $0x1,%ebx
  80042c:	53                   	push   %ebx
  80042d:	50                   	push   %eax
  80042e:	83 ec 08             	sub    $0x8,%esp
  800431:	ff 75 dc             	pushl  -0x24(%ebp)
  800434:	ff 75 d8             	pushl  -0x28(%ebp)
  800437:	ff 75 e4             	pushl  -0x1c(%ebp)
  80043a:	ff 75 e0             	pushl  -0x20(%ebp)
  80043d:	e8 de 1a 00 00       	call   801f20 <__udivdi3>
  800442:	83 c4 18             	add    $0x18,%esp
  800445:	52                   	push   %edx
  800446:	50                   	push   %eax
  800447:	89 fa                	mov    %edi,%edx
  800449:	89 f0                	mov    %esi,%eax
  80044b:	e8 54 ff ff ff       	call   8003a4 <printnum>
  800450:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800453:	83 ec 08             	sub    $0x8,%esp
  800456:	57                   	push   %edi
  800457:	83 ec 04             	sub    $0x4,%esp
  80045a:	ff 75 dc             	pushl  -0x24(%ebp)
  80045d:	ff 75 d8             	pushl  -0x28(%ebp)
  800460:	ff 75 e4             	pushl  -0x1c(%ebp)
  800463:	ff 75 e0             	pushl  -0x20(%ebp)
  800466:	e8 c5 1b 00 00       	call   802030 <__umoddi3>
  80046b:	83 c4 14             	add    $0x14,%esp
  80046e:	0f be 80 23 22 80 00 	movsbl 0x802223(%eax),%eax
  800475:	50                   	push   %eax
  800476:	ff d6                	call   *%esi
  800478:	83 c4 10             	add    $0x10,%esp
}
  80047b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80047e:	5b                   	pop    %ebx
  80047f:	5e                   	pop    %esi
  800480:	5f                   	pop    %edi
  800481:	5d                   	pop    %ebp
  800482:	c3                   	ret    

00800483 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800483:	55                   	push   %ebp
  800484:	89 e5                	mov    %esp,%ebp
  800486:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800489:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80048d:	8b 10                	mov    (%eax),%edx
  80048f:	3b 50 04             	cmp    0x4(%eax),%edx
  800492:	73 0a                	jae    80049e <sprintputch+0x1b>
		*b->buf++ = ch;
  800494:	8d 4a 01             	lea    0x1(%edx),%ecx
  800497:	89 08                	mov    %ecx,(%eax)
  800499:	8b 45 08             	mov    0x8(%ebp),%eax
  80049c:	88 02                	mov    %al,(%edx)
}
  80049e:	5d                   	pop    %ebp
  80049f:	c3                   	ret    

008004a0 <printfmt>:
{
  8004a0:	55                   	push   %ebp
  8004a1:	89 e5                	mov    %esp,%ebp
  8004a3:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8004a6:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8004a9:	50                   	push   %eax
  8004aa:	ff 75 10             	pushl  0x10(%ebp)
  8004ad:	ff 75 0c             	pushl  0xc(%ebp)
  8004b0:	ff 75 08             	pushl  0x8(%ebp)
  8004b3:	e8 05 00 00 00       	call   8004bd <vprintfmt>
}
  8004b8:	83 c4 10             	add    $0x10,%esp
  8004bb:	c9                   	leave  
  8004bc:	c3                   	ret    

008004bd <vprintfmt>:
{
  8004bd:	55                   	push   %ebp
  8004be:	89 e5                	mov    %esp,%ebp
  8004c0:	57                   	push   %edi
  8004c1:	56                   	push   %esi
  8004c2:	53                   	push   %ebx
  8004c3:	83 ec 3c             	sub    $0x3c,%esp
  8004c6:	8b 75 08             	mov    0x8(%ebp),%esi
  8004c9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004cc:	8b 7d 10             	mov    0x10(%ebp),%edi
  8004cf:	e9 1e 04 00 00       	jmp    8008f2 <vprintfmt+0x435>
		posflag = 0;
  8004d4:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
		padc = ' ';
  8004db:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8004df:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8004e6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8004ed:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004f4:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  8004fb:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800500:	8d 47 01             	lea    0x1(%edi),%eax
  800503:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800506:	0f b6 17             	movzbl (%edi),%edx
  800509:	8d 42 dd             	lea    -0x23(%edx),%eax
  80050c:	3c 55                	cmp    $0x55,%al
  80050e:	0f 87 d9 04 00 00    	ja     8009ed <vprintfmt+0x530>
  800514:	0f b6 c0             	movzbl %al,%eax
  800517:	ff 24 85 00 24 80 00 	jmp    *0x802400(,%eax,4)
  80051e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800521:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800525:	eb d9                	jmp    800500 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800527:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posflag = 1;
  80052a:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  800531:	eb cd                	jmp    800500 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800533:	0f b6 d2             	movzbl %dl,%edx
  800536:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800539:	b8 00 00 00 00       	mov    $0x0,%eax
  80053e:	89 75 08             	mov    %esi,0x8(%ebp)
  800541:	eb 0c                	jmp    80054f <vprintfmt+0x92>
		switch (ch = *(unsigned char *) fmt++) {
  800543:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800546:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  80054a:	eb b4                	jmp    800500 <vprintfmt+0x43>
			for (precision = 0; ; ++fmt) {
  80054c:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80054f:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800552:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800556:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800559:	8d 72 d0             	lea    -0x30(%edx),%esi
  80055c:	83 fe 09             	cmp    $0x9,%esi
  80055f:	76 eb                	jbe    80054c <vprintfmt+0x8f>
  800561:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800564:	8b 75 08             	mov    0x8(%ebp),%esi
  800567:	eb 14                	jmp    80057d <vprintfmt+0xc0>
			precision = va_arg(ap, int);
  800569:	8b 45 14             	mov    0x14(%ebp),%eax
  80056c:	8b 00                	mov    (%eax),%eax
  80056e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800571:	8b 45 14             	mov    0x14(%ebp),%eax
  800574:	8d 40 04             	lea    0x4(%eax),%eax
  800577:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80057a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80057d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800581:	0f 89 79 ff ff ff    	jns    800500 <vprintfmt+0x43>
				width = precision, precision = -1;
  800587:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80058a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80058d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800594:	e9 67 ff ff ff       	jmp    800500 <vprintfmt+0x43>
  800599:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80059c:	85 c0                	test   %eax,%eax
  80059e:	0f 48 c1             	cmovs  %ecx,%eax
  8005a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005a4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8005a7:	e9 54 ff ff ff       	jmp    800500 <vprintfmt+0x43>
  8005ac:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8005af:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8005b6:	e9 45 ff ff ff       	jmp    800500 <vprintfmt+0x43>
			lflag++;
  8005bb:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005bf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8005c2:	e9 39 ff ff ff       	jmp    800500 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8005c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ca:	8d 78 04             	lea    0x4(%eax),%edi
  8005cd:	83 ec 08             	sub    $0x8,%esp
  8005d0:	53                   	push   %ebx
  8005d1:	ff 30                	pushl  (%eax)
  8005d3:	ff d6                	call   *%esi
			break;
  8005d5:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8005d8:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8005db:	e9 0f 03 00 00       	jmp    8008ef <vprintfmt+0x432>
			err = va_arg(ap, int);
  8005e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e3:	8d 78 04             	lea    0x4(%eax),%edi
  8005e6:	8b 00                	mov    (%eax),%eax
  8005e8:	99                   	cltd   
  8005e9:	31 d0                	xor    %edx,%eax
  8005eb:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005ed:	83 f8 0f             	cmp    $0xf,%eax
  8005f0:	7f 23                	jg     800615 <vprintfmt+0x158>
  8005f2:	8b 14 85 60 25 80 00 	mov    0x802560(,%eax,4),%edx
  8005f9:	85 d2                	test   %edx,%edx
  8005fb:	74 18                	je     800615 <vprintfmt+0x158>
				printfmt(putch, putdat, "%s", p);
  8005fd:	52                   	push   %edx
  8005fe:	68 ae 26 80 00       	push   $0x8026ae
  800603:	53                   	push   %ebx
  800604:	56                   	push   %esi
  800605:	e8 96 fe ff ff       	call   8004a0 <printfmt>
  80060a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80060d:	89 7d 14             	mov    %edi,0x14(%ebp)
  800610:	e9 da 02 00 00       	jmp    8008ef <vprintfmt+0x432>
				printfmt(putch, putdat, "error %d", err);
  800615:	50                   	push   %eax
  800616:	68 3b 22 80 00       	push   $0x80223b
  80061b:	53                   	push   %ebx
  80061c:	56                   	push   %esi
  80061d:	e8 7e fe ff ff       	call   8004a0 <printfmt>
  800622:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800625:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800628:	e9 c2 02 00 00       	jmp    8008ef <vprintfmt+0x432>
			if ((p = va_arg(ap, char *)) == NULL)
  80062d:	8b 45 14             	mov    0x14(%ebp),%eax
  800630:	83 c0 04             	add    $0x4,%eax
  800633:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800636:	8b 45 14             	mov    0x14(%ebp),%eax
  800639:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80063b:	85 c9                	test   %ecx,%ecx
  80063d:	b8 34 22 80 00       	mov    $0x802234,%eax
  800642:	0f 45 c1             	cmovne %ecx,%eax
  800645:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800648:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80064c:	7e 06                	jle    800654 <vprintfmt+0x197>
  80064e:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800652:	75 0d                	jne    800661 <vprintfmt+0x1a4>
				for (width -= strnlen(p, precision); width > 0; width--)
  800654:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800657:	89 c7                	mov    %eax,%edi
  800659:	03 45 e0             	add    -0x20(%ebp),%eax
  80065c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80065f:	eb 53                	jmp    8006b4 <vprintfmt+0x1f7>
  800661:	83 ec 08             	sub    $0x8,%esp
  800664:	ff 75 d8             	pushl  -0x28(%ebp)
  800667:	50                   	push   %eax
  800668:	e8 18 05 00 00       	call   800b85 <strnlen>
  80066d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800670:	29 c1                	sub    %eax,%ecx
  800672:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  800675:	83 c4 10             	add    $0x10,%esp
  800678:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  80067a:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80067e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800681:	eb 0f                	jmp    800692 <vprintfmt+0x1d5>
					putch(padc, putdat);
  800683:	83 ec 08             	sub    $0x8,%esp
  800686:	53                   	push   %ebx
  800687:	ff 75 e0             	pushl  -0x20(%ebp)
  80068a:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80068c:	83 ef 01             	sub    $0x1,%edi
  80068f:	83 c4 10             	add    $0x10,%esp
  800692:	85 ff                	test   %edi,%edi
  800694:	7f ed                	jg     800683 <vprintfmt+0x1c6>
  800696:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  800699:	85 c9                	test   %ecx,%ecx
  80069b:	b8 00 00 00 00       	mov    $0x0,%eax
  8006a0:	0f 49 c1             	cmovns %ecx,%eax
  8006a3:	29 c1                	sub    %eax,%ecx
  8006a5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8006a8:	eb aa                	jmp    800654 <vprintfmt+0x197>
					putch(ch, putdat);
  8006aa:	83 ec 08             	sub    $0x8,%esp
  8006ad:	53                   	push   %ebx
  8006ae:	52                   	push   %edx
  8006af:	ff d6                	call   *%esi
  8006b1:	83 c4 10             	add    $0x10,%esp
  8006b4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8006b7:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006b9:	83 c7 01             	add    $0x1,%edi
  8006bc:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006c0:	0f be d0             	movsbl %al,%edx
  8006c3:	85 d2                	test   %edx,%edx
  8006c5:	74 4b                	je     800712 <vprintfmt+0x255>
  8006c7:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8006cb:	78 06                	js     8006d3 <vprintfmt+0x216>
  8006cd:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8006d1:	78 1e                	js     8006f1 <vprintfmt+0x234>
				if (altflag && (ch < ' ' || ch > '~'))
  8006d3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8006d7:	74 d1                	je     8006aa <vprintfmt+0x1ed>
  8006d9:	0f be c0             	movsbl %al,%eax
  8006dc:	83 e8 20             	sub    $0x20,%eax
  8006df:	83 f8 5e             	cmp    $0x5e,%eax
  8006e2:	76 c6                	jbe    8006aa <vprintfmt+0x1ed>
					putch('?', putdat);
  8006e4:	83 ec 08             	sub    $0x8,%esp
  8006e7:	53                   	push   %ebx
  8006e8:	6a 3f                	push   $0x3f
  8006ea:	ff d6                	call   *%esi
  8006ec:	83 c4 10             	add    $0x10,%esp
  8006ef:	eb c3                	jmp    8006b4 <vprintfmt+0x1f7>
  8006f1:	89 cf                	mov    %ecx,%edi
  8006f3:	eb 0e                	jmp    800703 <vprintfmt+0x246>
				putch(' ', putdat);
  8006f5:	83 ec 08             	sub    $0x8,%esp
  8006f8:	53                   	push   %ebx
  8006f9:	6a 20                	push   $0x20
  8006fb:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8006fd:	83 ef 01             	sub    $0x1,%edi
  800700:	83 c4 10             	add    $0x10,%esp
  800703:	85 ff                	test   %edi,%edi
  800705:	7f ee                	jg     8006f5 <vprintfmt+0x238>
			if ((p = va_arg(ap, char *)) == NULL)
  800707:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80070a:	89 45 14             	mov    %eax,0x14(%ebp)
  80070d:	e9 dd 01 00 00       	jmp    8008ef <vprintfmt+0x432>
  800712:	89 cf                	mov    %ecx,%edi
  800714:	eb ed                	jmp    800703 <vprintfmt+0x246>
	if (lflag >= 2)
  800716:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  80071a:	7f 21                	jg     80073d <vprintfmt+0x280>
	else if (lflag)
  80071c:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800720:	74 6a                	je     80078c <vprintfmt+0x2cf>
		return va_arg(*ap, long);
  800722:	8b 45 14             	mov    0x14(%ebp),%eax
  800725:	8b 00                	mov    (%eax),%eax
  800727:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80072a:	89 c1                	mov    %eax,%ecx
  80072c:	c1 f9 1f             	sar    $0x1f,%ecx
  80072f:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800732:	8b 45 14             	mov    0x14(%ebp),%eax
  800735:	8d 40 04             	lea    0x4(%eax),%eax
  800738:	89 45 14             	mov    %eax,0x14(%ebp)
  80073b:	eb 17                	jmp    800754 <vprintfmt+0x297>
		return va_arg(*ap, long long);
  80073d:	8b 45 14             	mov    0x14(%ebp),%eax
  800740:	8b 50 04             	mov    0x4(%eax),%edx
  800743:	8b 00                	mov    (%eax),%eax
  800745:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800748:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80074b:	8b 45 14             	mov    0x14(%ebp),%eax
  80074e:	8d 40 08             	lea    0x8(%eax),%eax
  800751:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800754:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  800757:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  80075c:	85 d2                	test   %edx,%edx
  80075e:	0f 89 5c 01 00 00    	jns    8008c0 <vprintfmt+0x403>
				putch('-', putdat);
  800764:	83 ec 08             	sub    $0x8,%esp
  800767:	53                   	push   %ebx
  800768:	6a 2d                	push   $0x2d
  80076a:	ff d6                	call   *%esi
				num = -(long long) num;
  80076c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80076f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800772:	f7 d8                	neg    %eax
  800774:	83 d2 00             	adc    $0x0,%edx
  800777:	f7 da                	neg    %edx
  800779:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80077c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80077f:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800782:	bf 0a 00 00 00       	mov    $0xa,%edi
  800787:	e9 45 01 00 00       	jmp    8008d1 <vprintfmt+0x414>
		return va_arg(*ap, int);
  80078c:	8b 45 14             	mov    0x14(%ebp),%eax
  80078f:	8b 00                	mov    (%eax),%eax
  800791:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800794:	89 c1                	mov    %eax,%ecx
  800796:	c1 f9 1f             	sar    $0x1f,%ecx
  800799:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80079c:	8b 45 14             	mov    0x14(%ebp),%eax
  80079f:	8d 40 04             	lea    0x4(%eax),%eax
  8007a2:	89 45 14             	mov    %eax,0x14(%ebp)
  8007a5:	eb ad                	jmp    800754 <vprintfmt+0x297>
	if (lflag >= 2)
  8007a7:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8007ab:	7f 29                	jg     8007d6 <vprintfmt+0x319>
	else if (lflag)
  8007ad:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8007b1:	74 44                	je     8007f7 <vprintfmt+0x33a>
		return va_arg(*ap, unsigned long);
  8007b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b6:	8b 00                	mov    (%eax),%eax
  8007b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8007bd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007c0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c6:	8d 40 04             	lea    0x4(%eax),%eax
  8007c9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007cc:	bf 0a 00 00 00       	mov    $0xa,%edi
  8007d1:	e9 ea 00 00 00       	jmp    8008c0 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  8007d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d9:	8b 50 04             	mov    0x4(%eax),%edx
  8007dc:	8b 00                	mov    (%eax),%eax
  8007de:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007e1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e7:	8d 40 08             	lea    0x8(%eax),%eax
  8007ea:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007ed:	bf 0a 00 00 00       	mov    $0xa,%edi
  8007f2:	e9 c9 00 00 00       	jmp    8008c0 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  8007f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fa:	8b 00                	mov    (%eax),%eax
  8007fc:	ba 00 00 00 00       	mov    $0x0,%edx
  800801:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800804:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800807:	8b 45 14             	mov    0x14(%ebp),%eax
  80080a:	8d 40 04             	lea    0x4(%eax),%eax
  80080d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800810:	bf 0a 00 00 00       	mov    $0xa,%edi
  800815:	e9 a6 00 00 00       	jmp    8008c0 <vprintfmt+0x403>
			putch('0', putdat);
  80081a:	83 ec 08             	sub    $0x8,%esp
  80081d:	53                   	push   %ebx
  80081e:	6a 30                	push   $0x30
  800820:	ff d6                	call   *%esi
	if (lflag >= 2)
  800822:	83 c4 10             	add    $0x10,%esp
  800825:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800829:	7f 26                	jg     800851 <vprintfmt+0x394>
	else if (lflag)
  80082b:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80082f:	74 3e                	je     80086f <vprintfmt+0x3b2>
		return va_arg(*ap, unsigned long);
  800831:	8b 45 14             	mov    0x14(%ebp),%eax
  800834:	8b 00                	mov    (%eax),%eax
  800836:	ba 00 00 00 00       	mov    $0x0,%edx
  80083b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80083e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800841:	8b 45 14             	mov    0x14(%ebp),%eax
  800844:	8d 40 04             	lea    0x4(%eax),%eax
  800847:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80084a:	bf 08 00 00 00       	mov    $0x8,%edi
  80084f:	eb 6f                	jmp    8008c0 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  800851:	8b 45 14             	mov    0x14(%ebp),%eax
  800854:	8b 50 04             	mov    0x4(%eax),%edx
  800857:	8b 00                	mov    (%eax),%eax
  800859:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80085c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80085f:	8b 45 14             	mov    0x14(%ebp),%eax
  800862:	8d 40 08             	lea    0x8(%eax),%eax
  800865:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800868:	bf 08 00 00 00       	mov    $0x8,%edi
  80086d:	eb 51                	jmp    8008c0 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  80086f:	8b 45 14             	mov    0x14(%ebp),%eax
  800872:	8b 00                	mov    (%eax),%eax
  800874:	ba 00 00 00 00       	mov    $0x0,%edx
  800879:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80087c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80087f:	8b 45 14             	mov    0x14(%ebp),%eax
  800882:	8d 40 04             	lea    0x4(%eax),%eax
  800885:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800888:	bf 08 00 00 00       	mov    $0x8,%edi
  80088d:	eb 31                	jmp    8008c0 <vprintfmt+0x403>
			putch('0', putdat);
  80088f:	83 ec 08             	sub    $0x8,%esp
  800892:	53                   	push   %ebx
  800893:	6a 30                	push   $0x30
  800895:	ff d6                	call   *%esi
			putch('x', putdat);
  800897:	83 c4 08             	add    $0x8,%esp
  80089a:	53                   	push   %ebx
  80089b:	6a 78                	push   $0x78
  80089d:	ff d6                	call   *%esi
			num = (unsigned long long)
  80089f:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a2:	8b 00                	mov    (%eax),%eax
  8008a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8008a9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008ac:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8008af:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8008b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b5:	8d 40 04             	lea    0x4(%eax),%eax
  8008b8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008bb:	bf 10 00 00 00       	mov    $0x10,%edi
			if(posflag)
  8008c0:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8008c4:	74 0b                	je     8008d1 <vprintfmt+0x414>
				putch('+', putdat);
  8008c6:	83 ec 08             	sub    $0x8,%esp
  8008c9:	53                   	push   %ebx
  8008ca:	6a 2b                	push   $0x2b
  8008cc:	ff d6                	call   *%esi
  8008ce:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  8008d1:	83 ec 0c             	sub    $0xc,%esp
  8008d4:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8008d8:	50                   	push   %eax
  8008d9:	ff 75 e0             	pushl  -0x20(%ebp)
  8008dc:	57                   	push   %edi
  8008dd:	ff 75 dc             	pushl  -0x24(%ebp)
  8008e0:	ff 75 d8             	pushl  -0x28(%ebp)
  8008e3:	89 da                	mov    %ebx,%edx
  8008e5:	89 f0                	mov    %esi,%eax
  8008e7:	e8 b8 fa ff ff       	call   8003a4 <printnum>
			break;
  8008ec:	83 c4 20             	add    $0x20,%esp
			char* cp = va_arg(ap, char *);
  8008ef:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008f2:	83 c7 01             	add    $0x1,%edi
  8008f5:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008f9:	83 f8 25             	cmp    $0x25,%eax
  8008fc:	0f 84 d2 fb ff ff    	je     8004d4 <vprintfmt+0x17>
			if (ch == '\0')
  800902:	85 c0                	test   %eax,%eax
  800904:	0f 84 03 01 00 00    	je     800a0d <vprintfmt+0x550>
			putch(ch, putdat);
  80090a:	83 ec 08             	sub    $0x8,%esp
  80090d:	53                   	push   %ebx
  80090e:	50                   	push   %eax
  80090f:	ff d6                	call   *%esi
  800911:	83 c4 10             	add    $0x10,%esp
  800914:	eb dc                	jmp    8008f2 <vprintfmt+0x435>
	if (lflag >= 2)
  800916:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  80091a:	7f 29                	jg     800945 <vprintfmt+0x488>
	else if (lflag)
  80091c:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800920:	74 44                	je     800966 <vprintfmt+0x4a9>
		return va_arg(*ap, unsigned long);
  800922:	8b 45 14             	mov    0x14(%ebp),%eax
  800925:	8b 00                	mov    (%eax),%eax
  800927:	ba 00 00 00 00       	mov    $0x0,%edx
  80092c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80092f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800932:	8b 45 14             	mov    0x14(%ebp),%eax
  800935:	8d 40 04             	lea    0x4(%eax),%eax
  800938:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80093b:	bf 10 00 00 00       	mov    $0x10,%edi
  800940:	e9 7b ff ff ff       	jmp    8008c0 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  800945:	8b 45 14             	mov    0x14(%ebp),%eax
  800948:	8b 50 04             	mov    0x4(%eax),%edx
  80094b:	8b 00                	mov    (%eax),%eax
  80094d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800950:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800953:	8b 45 14             	mov    0x14(%ebp),%eax
  800956:	8d 40 08             	lea    0x8(%eax),%eax
  800959:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80095c:	bf 10 00 00 00       	mov    $0x10,%edi
  800961:	e9 5a ff ff ff       	jmp    8008c0 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  800966:	8b 45 14             	mov    0x14(%ebp),%eax
  800969:	8b 00                	mov    (%eax),%eax
  80096b:	ba 00 00 00 00       	mov    $0x0,%edx
  800970:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800973:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800976:	8b 45 14             	mov    0x14(%ebp),%eax
  800979:	8d 40 04             	lea    0x4(%eax),%eax
  80097c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80097f:	bf 10 00 00 00       	mov    $0x10,%edi
  800984:	e9 37 ff ff ff       	jmp    8008c0 <vprintfmt+0x403>
			char* cp = va_arg(ap, char *);
  800989:	8b 45 14             	mov    0x14(%ebp),%eax
  80098c:	8d 78 04             	lea    0x4(%eax),%edi
  80098f:	8b 00                	mov    (%eax),%eax
    			if (cp == NULL) {
  800991:	85 c0                	test   %eax,%eax
  800993:	74 2c                	je     8009c1 <vprintfmt+0x504>
    			*cp = *(int *)putdat;
  800995:	8b 13                	mov    (%ebx),%edx
  800997:	88 10                	mov    %dl,(%eax)
			char* cp = va_arg(ap, char *);
  800999:	89 7d 14             	mov    %edi,0x14(%ebp)
    			if ((*(int *) putdat) > 127)
  80099c:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  80099f:	0f 8e 4a ff ff ff    	jle    8008ef <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", overflow_error);
  8009a5:	68 90 23 80 00       	push   $0x802390
  8009aa:	68 ae 26 80 00       	push   $0x8026ae
  8009af:	53                   	push   %ebx
  8009b0:	56                   	push   %esi
  8009b1:	e8 ea fa ff ff       	call   8004a0 <printfmt>
  8009b6:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  8009b9:	89 7d 14             	mov    %edi,0x14(%ebp)
  8009bc:	e9 2e ff ff ff       	jmp    8008ef <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", null_error);
  8009c1:	68 58 23 80 00       	push   $0x802358
  8009c6:	68 ae 26 80 00       	push   $0x8026ae
  8009cb:	53                   	push   %ebx
  8009cc:	56                   	push   %esi
  8009cd:	e8 ce fa ff ff       	call   8004a0 <printfmt>
        		break;
  8009d2:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  8009d5:	89 7d 14             	mov    %edi,0x14(%ebp)
        		break;
  8009d8:	e9 12 ff ff ff       	jmp    8008ef <vprintfmt+0x432>
			putch(ch, putdat);
  8009dd:	83 ec 08             	sub    $0x8,%esp
  8009e0:	53                   	push   %ebx
  8009e1:	6a 25                	push   $0x25
  8009e3:	ff d6                	call   *%esi
			break;
  8009e5:	83 c4 10             	add    $0x10,%esp
  8009e8:	e9 02 ff ff ff       	jmp    8008ef <vprintfmt+0x432>
			putch('%', putdat);
  8009ed:	83 ec 08             	sub    $0x8,%esp
  8009f0:	53                   	push   %ebx
  8009f1:	6a 25                	push   $0x25
  8009f3:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009f5:	83 c4 10             	add    $0x10,%esp
  8009f8:	89 f8                	mov    %edi,%eax
  8009fa:	eb 03                	jmp    8009ff <vprintfmt+0x542>
  8009fc:	83 e8 01             	sub    $0x1,%eax
  8009ff:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800a03:	75 f7                	jne    8009fc <vprintfmt+0x53f>
  800a05:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a08:	e9 e2 fe ff ff       	jmp    8008ef <vprintfmt+0x432>
}
  800a0d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a10:	5b                   	pop    %ebx
  800a11:	5e                   	pop    %esi
  800a12:	5f                   	pop    %edi
  800a13:	5d                   	pop    %ebp
  800a14:	c3                   	ret    

00800a15 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a15:	55                   	push   %ebp
  800a16:	89 e5                	mov    %esp,%ebp
  800a18:	83 ec 18             	sub    $0x18,%esp
  800a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1e:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a21:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a24:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800a28:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800a2b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a32:	85 c0                	test   %eax,%eax
  800a34:	74 26                	je     800a5c <vsnprintf+0x47>
  800a36:	85 d2                	test   %edx,%edx
  800a38:	7e 22                	jle    800a5c <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a3a:	ff 75 14             	pushl  0x14(%ebp)
  800a3d:	ff 75 10             	pushl  0x10(%ebp)
  800a40:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a43:	50                   	push   %eax
  800a44:	68 83 04 80 00       	push   $0x800483
  800a49:	e8 6f fa ff ff       	call   8004bd <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a51:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a57:	83 c4 10             	add    $0x10,%esp
}
  800a5a:	c9                   	leave  
  800a5b:	c3                   	ret    
		return -E_INVAL;
  800a5c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a61:	eb f7                	jmp    800a5a <vsnprintf+0x45>

00800a63 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a63:	55                   	push   %ebp
  800a64:	89 e5                	mov    %esp,%ebp
  800a66:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a69:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a6c:	50                   	push   %eax
  800a6d:	ff 75 10             	pushl  0x10(%ebp)
  800a70:	ff 75 0c             	pushl  0xc(%ebp)
  800a73:	ff 75 08             	pushl  0x8(%ebp)
  800a76:	e8 9a ff ff ff       	call   800a15 <vsnprintf>
	va_end(ap);

	return rc;
}
  800a7b:	c9                   	leave  
  800a7c:	c3                   	ret    

00800a7d <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  800a7d:	55                   	push   %ebp
  800a7e:	89 e5                	mov    %esp,%ebp
  800a80:	57                   	push   %edi
  800a81:	56                   	push   %esi
  800a82:	53                   	push   %ebx
  800a83:	83 ec 0c             	sub    $0xc,%esp
  800a86:	8b 45 08             	mov    0x8(%ebp),%eax

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  800a89:	85 c0                	test   %eax,%eax
  800a8b:	74 13                	je     800aa0 <readline+0x23>
		fprintf(1, "%s", prompt);
  800a8d:	83 ec 04             	sub    $0x4,%esp
  800a90:	50                   	push   %eax
  800a91:	68 ae 26 80 00       	push   $0x8026ae
  800a96:	6a 01                	push   $0x1
  800a98:	e8 d4 0f 00 00       	call   801a71 <fprintf>
  800a9d:	83 c4 10             	add    $0x10,%esp
#endif

	i = 0;
	echoing = iscons(0);
  800aa0:	83 ec 0c             	sub    $0xc,%esp
  800aa3:	6a 00                	push   $0x0
  800aa5:	e8 32 f7 ff ff       	call   8001dc <iscons>
  800aaa:	89 c7                	mov    %eax,%edi
  800aac:	83 c4 10             	add    $0x10,%esp
	i = 0;
  800aaf:	be 00 00 00 00       	mov    $0x0,%esi
  800ab4:	eb 57                	jmp    800b0d <readline+0x90>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
  800ab6:	b8 00 00 00 00       	mov    $0x0,%eax
			if (c != -E_EOF)
  800abb:	83 fb f8             	cmp    $0xfffffff8,%ebx
  800abe:	75 08                	jne    800ac8 <readline+0x4b>
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
  800ac0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ac3:	5b                   	pop    %ebx
  800ac4:	5e                   	pop    %esi
  800ac5:	5f                   	pop    %edi
  800ac6:	5d                   	pop    %ebp
  800ac7:	c3                   	ret    
				cprintf("read error: %e\n", c);
  800ac8:	83 ec 08             	sub    $0x8,%esp
  800acb:	53                   	push   %ebx
  800acc:	68 a0 25 80 00       	push   $0x8025a0
  800ad1:	e8 ba f8 ff ff       	call   800390 <cprintf>
  800ad6:	83 c4 10             	add    $0x10,%esp
			return NULL;
  800ad9:	b8 00 00 00 00       	mov    $0x0,%eax
  800ade:	eb e0                	jmp    800ac0 <readline+0x43>
			if (echoing)
  800ae0:	85 ff                	test   %edi,%edi
  800ae2:	75 05                	jne    800ae9 <readline+0x6c>
			i--;
  800ae4:	83 ee 01             	sub    $0x1,%esi
  800ae7:	eb 24                	jmp    800b0d <readline+0x90>
				cputchar('\b');
  800ae9:	83 ec 0c             	sub    $0xc,%esp
  800aec:	6a 08                	push   $0x8
  800aee:	e8 a4 f6 ff ff       	call   800197 <cputchar>
  800af3:	83 c4 10             	add    $0x10,%esp
  800af6:	eb ec                	jmp    800ae4 <readline+0x67>
				cputchar(c);
  800af8:	83 ec 0c             	sub    $0xc,%esp
  800afb:	53                   	push   %ebx
  800afc:	e8 96 f6 ff ff       	call   800197 <cputchar>
  800b01:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800b04:	88 9e 00 40 80 00    	mov    %bl,0x804000(%esi)
  800b0a:	8d 76 01             	lea    0x1(%esi),%esi
		c = getchar();
  800b0d:	e8 a1 f6 ff ff       	call   8001b3 <getchar>
  800b12:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
  800b14:	85 c0                	test   %eax,%eax
  800b16:	78 9e                	js     800ab6 <readline+0x39>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  800b18:	83 f8 08             	cmp    $0x8,%eax
  800b1b:	0f 94 c2             	sete   %dl
  800b1e:	83 f8 7f             	cmp    $0x7f,%eax
  800b21:	0f 94 c0             	sete   %al
  800b24:	08 c2                	or     %al,%dl
  800b26:	74 04                	je     800b2c <readline+0xaf>
  800b28:	85 f6                	test   %esi,%esi
  800b2a:	7f b4                	jg     800ae0 <readline+0x63>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800b2c:	83 fb 1f             	cmp    $0x1f,%ebx
  800b2f:	7e 0e                	jle    800b3f <readline+0xc2>
  800b31:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
  800b37:	7f 06                	jg     800b3f <readline+0xc2>
			if (echoing)
  800b39:	85 ff                	test   %edi,%edi
  800b3b:	74 c7                	je     800b04 <readline+0x87>
  800b3d:	eb b9                	jmp    800af8 <readline+0x7b>
		} else if (c == '\n' || c == '\r') {
  800b3f:	83 fb 0a             	cmp    $0xa,%ebx
  800b42:	74 05                	je     800b49 <readline+0xcc>
  800b44:	83 fb 0d             	cmp    $0xd,%ebx
  800b47:	75 c4                	jne    800b0d <readline+0x90>
			if (echoing)
  800b49:	85 ff                	test   %edi,%edi
  800b4b:	75 11                	jne    800b5e <readline+0xe1>
			buf[i] = 0;
  800b4d:	c6 86 00 40 80 00 00 	movb   $0x0,0x804000(%esi)
			return buf;
  800b54:	b8 00 40 80 00       	mov    $0x804000,%eax
  800b59:	e9 62 ff ff ff       	jmp    800ac0 <readline+0x43>
				cputchar('\n');
  800b5e:	83 ec 0c             	sub    $0xc,%esp
  800b61:	6a 0a                	push   $0xa
  800b63:	e8 2f f6 ff ff       	call   800197 <cputchar>
  800b68:	83 c4 10             	add    $0x10,%esp
  800b6b:	eb e0                	jmp    800b4d <readline+0xd0>

00800b6d <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800b6d:	55                   	push   %ebp
  800b6e:	89 e5                	mov    %esp,%ebp
  800b70:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800b73:	b8 00 00 00 00       	mov    $0x0,%eax
  800b78:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800b7c:	74 05                	je     800b83 <strlen+0x16>
		n++;
  800b7e:	83 c0 01             	add    $0x1,%eax
  800b81:	eb f5                	jmp    800b78 <strlen+0xb>
	return n;
}
  800b83:	5d                   	pop    %ebp
  800b84:	c3                   	ret    

00800b85 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800b85:	55                   	push   %ebp
  800b86:	89 e5                	mov    %esp,%ebp
  800b88:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b8b:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b8e:	ba 00 00 00 00       	mov    $0x0,%edx
  800b93:	39 c2                	cmp    %eax,%edx
  800b95:	74 0d                	je     800ba4 <strnlen+0x1f>
  800b97:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800b9b:	74 05                	je     800ba2 <strnlen+0x1d>
		n++;
  800b9d:	83 c2 01             	add    $0x1,%edx
  800ba0:	eb f1                	jmp    800b93 <strnlen+0xe>
  800ba2:	89 d0                	mov    %edx,%eax
	return n;
}
  800ba4:	5d                   	pop    %ebp
  800ba5:	c3                   	ret    

00800ba6 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ba6:	55                   	push   %ebp
  800ba7:	89 e5                	mov    %esp,%ebp
  800ba9:	53                   	push   %ebx
  800baa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bad:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800bb0:	ba 00 00 00 00       	mov    $0x0,%edx
  800bb5:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800bb9:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800bbc:	83 c2 01             	add    $0x1,%edx
  800bbf:	84 c9                	test   %cl,%cl
  800bc1:	75 f2                	jne    800bb5 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800bc3:	5b                   	pop    %ebx
  800bc4:	5d                   	pop    %ebp
  800bc5:	c3                   	ret    

00800bc6 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800bc6:	55                   	push   %ebp
  800bc7:	89 e5                	mov    %esp,%ebp
  800bc9:	53                   	push   %ebx
  800bca:	83 ec 10             	sub    $0x10,%esp
  800bcd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800bd0:	53                   	push   %ebx
  800bd1:	e8 97 ff ff ff       	call   800b6d <strlen>
  800bd6:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800bd9:	ff 75 0c             	pushl  0xc(%ebp)
  800bdc:	01 d8                	add    %ebx,%eax
  800bde:	50                   	push   %eax
  800bdf:	e8 c2 ff ff ff       	call   800ba6 <strcpy>
	return dst;
}
  800be4:	89 d8                	mov    %ebx,%eax
  800be6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800be9:	c9                   	leave  
  800bea:	c3                   	ret    

00800beb <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800beb:	55                   	push   %ebp
  800bec:	89 e5                	mov    %esp,%ebp
  800bee:	56                   	push   %esi
  800bef:	53                   	push   %ebx
  800bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bf6:	89 c6                	mov    %eax,%esi
  800bf8:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800bfb:	89 c2                	mov    %eax,%edx
  800bfd:	39 f2                	cmp    %esi,%edx
  800bff:	74 11                	je     800c12 <strncpy+0x27>
		*dst++ = *src;
  800c01:	83 c2 01             	add    $0x1,%edx
  800c04:	0f b6 19             	movzbl (%ecx),%ebx
  800c07:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800c0a:	80 fb 01             	cmp    $0x1,%bl
  800c0d:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800c10:	eb eb                	jmp    800bfd <strncpy+0x12>
	}
	return ret;
}
  800c12:	5b                   	pop    %ebx
  800c13:	5e                   	pop    %esi
  800c14:	5d                   	pop    %ebp
  800c15:	c3                   	ret    

00800c16 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800c16:	55                   	push   %ebp
  800c17:	89 e5                	mov    %esp,%ebp
  800c19:	56                   	push   %esi
  800c1a:	53                   	push   %ebx
  800c1b:	8b 75 08             	mov    0x8(%ebp),%esi
  800c1e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c21:	8b 55 10             	mov    0x10(%ebp),%edx
  800c24:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800c26:	85 d2                	test   %edx,%edx
  800c28:	74 21                	je     800c4b <strlcpy+0x35>
  800c2a:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800c2e:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800c30:	39 c2                	cmp    %eax,%edx
  800c32:	74 14                	je     800c48 <strlcpy+0x32>
  800c34:	0f b6 19             	movzbl (%ecx),%ebx
  800c37:	84 db                	test   %bl,%bl
  800c39:	74 0b                	je     800c46 <strlcpy+0x30>
			*dst++ = *src++;
  800c3b:	83 c1 01             	add    $0x1,%ecx
  800c3e:	83 c2 01             	add    $0x1,%edx
  800c41:	88 5a ff             	mov    %bl,-0x1(%edx)
  800c44:	eb ea                	jmp    800c30 <strlcpy+0x1a>
  800c46:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800c48:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c4b:	29 f0                	sub    %esi,%eax
}
  800c4d:	5b                   	pop    %ebx
  800c4e:	5e                   	pop    %esi
  800c4f:	5d                   	pop    %ebp
  800c50:	c3                   	ret    

00800c51 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c51:	55                   	push   %ebp
  800c52:	89 e5                	mov    %esp,%ebp
  800c54:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c57:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800c5a:	0f b6 01             	movzbl (%ecx),%eax
  800c5d:	84 c0                	test   %al,%al
  800c5f:	74 0c                	je     800c6d <strcmp+0x1c>
  800c61:	3a 02                	cmp    (%edx),%al
  800c63:	75 08                	jne    800c6d <strcmp+0x1c>
		p++, q++;
  800c65:	83 c1 01             	add    $0x1,%ecx
  800c68:	83 c2 01             	add    $0x1,%edx
  800c6b:	eb ed                	jmp    800c5a <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c6d:	0f b6 c0             	movzbl %al,%eax
  800c70:	0f b6 12             	movzbl (%edx),%edx
  800c73:	29 d0                	sub    %edx,%eax
}
  800c75:	5d                   	pop    %ebp
  800c76:	c3                   	ret    

00800c77 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800c77:	55                   	push   %ebp
  800c78:	89 e5                	mov    %esp,%ebp
  800c7a:	53                   	push   %ebx
  800c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c81:	89 c3                	mov    %eax,%ebx
  800c83:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800c86:	eb 06                	jmp    800c8e <strncmp+0x17>
		n--, p++, q++;
  800c88:	83 c0 01             	add    $0x1,%eax
  800c8b:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800c8e:	39 d8                	cmp    %ebx,%eax
  800c90:	74 16                	je     800ca8 <strncmp+0x31>
  800c92:	0f b6 08             	movzbl (%eax),%ecx
  800c95:	84 c9                	test   %cl,%cl
  800c97:	74 04                	je     800c9d <strncmp+0x26>
  800c99:	3a 0a                	cmp    (%edx),%cl
  800c9b:	74 eb                	je     800c88 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c9d:	0f b6 00             	movzbl (%eax),%eax
  800ca0:	0f b6 12             	movzbl (%edx),%edx
  800ca3:	29 d0                	sub    %edx,%eax
}
  800ca5:	5b                   	pop    %ebx
  800ca6:	5d                   	pop    %ebp
  800ca7:	c3                   	ret    
		return 0;
  800ca8:	b8 00 00 00 00       	mov    $0x0,%eax
  800cad:	eb f6                	jmp    800ca5 <strncmp+0x2e>

00800caf <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800caf:	55                   	push   %ebp
  800cb0:	89 e5                	mov    %esp,%ebp
  800cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb5:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800cb9:	0f b6 10             	movzbl (%eax),%edx
  800cbc:	84 d2                	test   %dl,%dl
  800cbe:	74 09                	je     800cc9 <strchr+0x1a>
		if (*s == c)
  800cc0:	38 ca                	cmp    %cl,%dl
  800cc2:	74 0a                	je     800cce <strchr+0x1f>
	for (; *s; s++)
  800cc4:	83 c0 01             	add    $0x1,%eax
  800cc7:	eb f0                	jmp    800cb9 <strchr+0xa>
			return (char *) s;
	return 0;
  800cc9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cce:	5d                   	pop    %ebp
  800ccf:	c3                   	ret    

00800cd0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cd0:	55                   	push   %ebp
  800cd1:	89 e5                	mov    %esp,%ebp
  800cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800cda:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800cdd:	38 ca                	cmp    %cl,%dl
  800cdf:	74 09                	je     800cea <strfind+0x1a>
  800ce1:	84 d2                	test   %dl,%dl
  800ce3:	74 05                	je     800cea <strfind+0x1a>
	for (; *s; s++)
  800ce5:	83 c0 01             	add    $0x1,%eax
  800ce8:	eb f0                	jmp    800cda <strfind+0xa>
			break;
	return (char *) s;
}
  800cea:	5d                   	pop    %ebp
  800ceb:	c3                   	ret    

00800cec <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800cec:	55                   	push   %ebp
  800ced:	89 e5                	mov    %esp,%ebp
  800cef:	57                   	push   %edi
  800cf0:	56                   	push   %esi
  800cf1:	53                   	push   %ebx
  800cf2:	8b 7d 08             	mov    0x8(%ebp),%edi
  800cf5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800cf8:	85 c9                	test   %ecx,%ecx
  800cfa:	74 31                	je     800d2d <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800cfc:	89 f8                	mov    %edi,%eax
  800cfe:	09 c8                	or     %ecx,%eax
  800d00:	a8 03                	test   $0x3,%al
  800d02:	75 23                	jne    800d27 <memset+0x3b>
		c &= 0xFF;
  800d04:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800d08:	89 d3                	mov    %edx,%ebx
  800d0a:	c1 e3 08             	shl    $0x8,%ebx
  800d0d:	89 d0                	mov    %edx,%eax
  800d0f:	c1 e0 18             	shl    $0x18,%eax
  800d12:	89 d6                	mov    %edx,%esi
  800d14:	c1 e6 10             	shl    $0x10,%esi
  800d17:	09 f0                	or     %esi,%eax
  800d19:	09 c2                	or     %eax,%edx
  800d1b:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800d1d:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800d20:	89 d0                	mov    %edx,%eax
  800d22:	fc                   	cld    
  800d23:	f3 ab                	rep stos %eax,%es:(%edi)
  800d25:	eb 06                	jmp    800d2d <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2a:	fc                   	cld    
  800d2b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800d2d:	89 f8                	mov    %edi,%eax
  800d2f:	5b                   	pop    %ebx
  800d30:	5e                   	pop    %esi
  800d31:	5f                   	pop    %edi
  800d32:	5d                   	pop    %ebp
  800d33:	c3                   	ret    

00800d34 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800d34:	55                   	push   %ebp
  800d35:	89 e5                	mov    %esp,%ebp
  800d37:	57                   	push   %edi
  800d38:	56                   	push   %esi
  800d39:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d3f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d42:	39 c6                	cmp    %eax,%esi
  800d44:	73 32                	jae    800d78 <memmove+0x44>
  800d46:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800d49:	39 c2                	cmp    %eax,%edx
  800d4b:	76 2b                	jbe    800d78 <memmove+0x44>
		s += n;
		d += n;
  800d4d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d50:	89 fe                	mov    %edi,%esi
  800d52:	09 ce                	or     %ecx,%esi
  800d54:	09 d6                	or     %edx,%esi
  800d56:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800d5c:	75 0e                	jne    800d6c <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800d5e:	83 ef 04             	sub    $0x4,%edi
  800d61:	8d 72 fc             	lea    -0x4(%edx),%esi
  800d64:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800d67:	fd                   	std    
  800d68:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d6a:	eb 09                	jmp    800d75 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800d6c:	83 ef 01             	sub    $0x1,%edi
  800d6f:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800d72:	fd                   	std    
  800d73:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800d75:	fc                   	cld    
  800d76:	eb 1a                	jmp    800d92 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d78:	89 c2                	mov    %eax,%edx
  800d7a:	09 ca                	or     %ecx,%edx
  800d7c:	09 f2                	or     %esi,%edx
  800d7e:	f6 c2 03             	test   $0x3,%dl
  800d81:	75 0a                	jne    800d8d <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800d83:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800d86:	89 c7                	mov    %eax,%edi
  800d88:	fc                   	cld    
  800d89:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d8b:	eb 05                	jmp    800d92 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800d8d:	89 c7                	mov    %eax,%edi
  800d8f:	fc                   	cld    
  800d90:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800d92:	5e                   	pop    %esi
  800d93:	5f                   	pop    %edi
  800d94:	5d                   	pop    %ebp
  800d95:	c3                   	ret    

00800d96 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800d96:	55                   	push   %ebp
  800d97:	89 e5                	mov    %esp,%ebp
  800d99:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800d9c:	ff 75 10             	pushl  0x10(%ebp)
  800d9f:	ff 75 0c             	pushl  0xc(%ebp)
  800da2:	ff 75 08             	pushl  0x8(%ebp)
  800da5:	e8 8a ff ff ff       	call   800d34 <memmove>
}
  800daa:	c9                   	leave  
  800dab:	c3                   	ret    

00800dac <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800dac:	55                   	push   %ebp
  800dad:	89 e5                	mov    %esp,%ebp
  800daf:	56                   	push   %esi
  800db0:	53                   	push   %ebx
  800db1:	8b 45 08             	mov    0x8(%ebp),%eax
  800db4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800db7:	89 c6                	mov    %eax,%esi
  800db9:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800dbc:	39 f0                	cmp    %esi,%eax
  800dbe:	74 1c                	je     800ddc <memcmp+0x30>
		if (*s1 != *s2)
  800dc0:	0f b6 08             	movzbl (%eax),%ecx
  800dc3:	0f b6 1a             	movzbl (%edx),%ebx
  800dc6:	38 d9                	cmp    %bl,%cl
  800dc8:	75 08                	jne    800dd2 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800dca:	83 c0 01             	add    $0x1,%eax
  800dcd:	83 c2 01             	add    $0x1,%edx
  800dd0:	eb ea                	jmp    800dbc <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800dd2:	0f b6 c1             	movzbl %cl,%eax
  800dd5:	0f b6 db             	movzbl %bl,%ebx
  800dd8:	29 d8                	sub    %ebx,%eax
  800dda:	eb 05                	jmp    800de1 <memcmp+0x35>
	}

	return 0;
  800ddc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800de1:	5b                   	pop    %ebx
  800de2:	5e                   	pop    %esi
  800de3:	5d                   	pop    %ebp
  800de4:	c3                   	ret    

00800de5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800de5:	55                   	push   %ebp
  800de6:	89 e5                	mov    %esp,%ebp
  800de8:	8b 45 08             	mov    0x8(%ebp),%eax
  800deb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800dee:	89 c2                	mov    %eax,%edx
  800df0:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800df3:	39 d0                	cmp    %edx,%eax
  800df5:	73 09                	jae    800e00 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800df7:	38 08                	cmp    %cl,(%eax)
  800df9:	74 05                	je     800e00 <memfind+0x1b>
	for (; s < ends; s++)
  800dfb:	83 c0 01             	add    $0x1,%eax
  800dfe:	eb f3                	jmp    800df3 <memfind+0xe>
			break;
	return (void *) s;
}
  800e00:	5d                   	pop    %ebp
  800e01:	c3                   	ret    

00800e02 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e02:	55                   	push   %ebp
  800e03:	89 e5                	mov    %esp,%ebp
  800e05:	57                   	push   %edi
  800e06:	56                   	push   %esi
  800e07:	53                   	push   %ebx
  800e08:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e0b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e0e:	eb 03                	jmp    800e13 <strtol+0x11>
		s++;
  800e10:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800e13:	0f b6 01             	movzbl (%ecx),%eax
  800e16:	3c 20                	cmp    $0x20,%al
  800e18:	74 f6                	je     800e10 <strtol+0xe>
  800e1a:	3c 09                	cmp    $0x9,%al
  800e1c:	74 f2                	je     800e10 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800e1e:	3c 2b                	cmp    $0x2b,%al
  800e20:	74 2a                	je     800e4c <strtol+0x4a>
	int neg = 0;
  800e22:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800e27:	3c 2d                	cmp    $0x2d,%al
  800e29:	74 2b                	je     800e56 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e2b:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800e31:	75 0f                	jne    800e42 <strtol+0x40>
  800e33:	80 39 30             	cmpb   $0x30,(%ecx)
  800e36:	74 28                	je     800e60 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800e38:	85 db                	test   %ebx,%ebx
  800e3a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e3f:	0f 44 d8             	cmove  %eax,%ebx
  800e42:	b8 00 00 00 00       	mov    $0x0,%eax
  800e47:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800e4a:	eb 50                	jmp    800e9c <strtol+0x9a>
		s++;
  800e4c:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800e4f:	bf 00 00 00 00       	mov    $0x0,%edi
  800e54:	eb d5                	jmp    800e2b <strtol+0x29>
		s++, neg = 1;
  800e56:	83 c1 01             	add    $0x1,%ecx
  800e59:	bf 01 00 00 00       	mov    $0x1,%edi
  800e5e:	eb cb                	jmp    800e2b <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e60:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800e64:	74 0e                	je     800e74 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800e66:	85 db                	test   %ebx,%ebx
  800e68:	75 d8                	jne    800e42 <strtol+0x40>
		s++, base = 8;
  800e6a:	83 c1 01             	add    $0x1,%ecx
  800e6d:	bb 08 00 00 00       	mov    $0x8,%ebx
  800e72:	eb ce                	jmp    800e42 <strtol+0x40>
		s += 2, base = 16;
  800e74:	83 c1 02             	add    $0x2,%ecx
  800e77:	bb 10 00 00 00       	mov    $0x10,%ebx
  800e7c:	eb c4                	jmp    800e42 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800e7e:	8d 72 9f             	lea    -0x61(%edx),%esi
  800e81:	89 f3                	mov    %esi,%ebx
  800e83:	80 fb 19             	cmp    $0x19,%bl
  800e86:	77 29                	ja     800eb1 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800e88:	0f be d2             	movsbl %dl,%edx
  800e8b:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800e8e:	3b 55 10             	cmp    0x10(%ebp),%edx
  800e91:	7d 30                	jge    800ec3 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800e93:	83 c1 01             	add    $0x1,%ecx
  800e96:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e9a:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800e9c:	0f b6 11             	movzbl (%ecx),%edx
  800e9f:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ea2:	89 f3                	mov    %esi,%ebx
  800ea4:	80 fb 09             	cmp    $0x9,%bl
  800ea7:	77 d5                	ja     800e7e <strtol+0x7c>
			dig = *s - '0';
  800ea9:	0f be d2             	movsbl %dl,%edx
  800eac:	83 ea 30             	sub    $0x30,%edx
  800eaf:	eb dd                	jmp    800e8e <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800eb1:	8d 72 bf             	lea    -0x41(%edx),%esi
  800eb4:	89 f3                	mov    %esi,%ebx
  800eb6:	80 fb 19             	cmp    $0x19,%bl
  800eb9:	77 08                	ja     800ec3 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800ebb:	0f be d2             	movsbl %dl,%edx
  800ebe:	83 ea 37             	sub    $0x37,%edx
  800ec1:	eb cb                	jmp    800e8e <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800ec3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ec7:	74 05                	je     800ece <strtol+0xcc>
		*endptr = (char *) s;
  800ec9:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ecc:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ece:	89 c2                	mov    %eax,%edx
  800ed0:	f7 da                	neg    %edx
  800ed2:	85 ff                	test   %edi,%edi
  800ed4:	0f 45 c2             	cmovne %edx,%eax
}
  800ed7:	5b                   	pop    %ebx
  800ed8:	5e                   	pop    %esi
  800ed9:	5f                   	pop    %edi
  800eda:	5d                   	pop    %ebp
  800edb:	c3                   	ret    

00800edc <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800edc:	55                   	push   %ebp
  800edd:	89 e5                	mov    %esp,%ebp
  800edf:	57                   	push   %edi
  800ee0:	56                   	push   %esi
  800ee1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ee2:	b8 00 00 00 00       	mov    $0x0,%eax
  800ee7:	8b 55 08             	mov    0x8(%ebp),%edx
  800eea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eed:	89 c3                	mov    %eax,%ebx
  800eef:	89 c7                	mov    %eax,%edi
  800ef1:	89 c6                	mov    %eax,%esi
  800ef3:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ef5:	5b                   	pop    %ebx
  800ef6:	5e                   	pop    %esi
  800ef7:	5f                   	pop    %edi
  800ef8:	5d                   	pop    %ebp
  800ef9:	c3                   	ret    

00800efa <sys_cgetc>:

int
sys_cgetc(void)
{
  800efa:	55                   	push   %ebp
  800efb:	89 e5                	mov    %esp,%ebp
  800efd:	57                   	push   %edi
  800efe:	56                   	push   %esi
  800eff:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f00:	ba 00 00 00 00       	mov    $0x0,%edx
  800f05:	b8 01 00 00 00       	mov    $0x1,%eax
  800f0a:	89 d1                	mov    %edx,%ecx
  800f0c:	89 d3                	mov    %edx,%ebx
  800f0e:	89 d7                	mov    %edx,%edi
  800f10:	89 d6                	mov    %edx,%esi
  800f12:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800f14:	5b                   	pop    %ebx
  800f15:	5e                   	pop    %esi
  800f16:	5f                   	pop    %edi
  800f17:	5d                   	pop    %ebp
  800f18:	c3                   	ret    

00800f19 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800f19:	55                   	push   %ebp
  800f1a:	89 e5                	mov    %esp,%ebp
  800f1c:	57                   	push   %edi
  800f1d:	56                   	push   %esi
  800f1e:	53                   	push   %ebx
  800f1f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f22:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f27:	8b 55 08             	mov    0x8(%ebp),%edx
  800f2a:	b8 03 00 00 00       	mov    $0x3,%eax
  800f2f:	89 cb                	mov    %ecx,%ebx
  800f31:	89 cf                	mov    %ecx,%edi
  800f33:	89 ce                	mov    %ecx,%esi
  800f35:	cd 30                	int    $0x30
	if (check && ret > 0)
  800f37:	85 c0                	test   %eax,%eax
  800f39:	7f 08                	jg     800f43 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800f3b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f3e:	5b                   	pop    %ebx
  800f3f:	5e                   	pop    %esi
  800f40:	5f                   	pop    %edi
  800f41:	5d                   	pop    %ebp
  800f42:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f43:	83 ec 0c             	sub    $0xc,%esp
  800f46:	50                   	push   %eax
  800f47:	6a 03                	push   $0x3
  800f49:	68 b0 25 80 00       	push   $0x8025b0
  800f4e:	6a 4c                	push   $0x4c
  800f50:	68 cd 25 80 00       	push   $0x8025cd
  800f55:	e8 5b f3 ff ff       	call   8002b5 <_panic>

00800f5a <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800f5a:	55                   	push   %ebp
  800f5b:	89 e5                	mov    %esp,%ebp
  800f5d:	57                   	push   %edi
  800f5e:	56                   	push   %esi
  800f5f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f60:	ba 00 00 00 00       	mov    $0x0,%edx
  800f65:	b8 02 00 00 00       	mov    $0x2,%eax
  800f6a:	89 d1                	mov    %edx,%ecx
  800f6c:	89 d3                	mov    %edx,%ebx
  800f6e:	89 d7                	mov    %edx,%edi
  800f70:	89 d6                	mov    %edx,%esi
  800f72:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800f74:	5b                   	pop    %ebx
  800f75:	5e                   	pop    %esi
  800f76:	5f                   	pop    %edi
  800f77:	5d                   	pop    %ebp
  800f78:	c3                   	ret    

00800f79 <sys_yield>:

void
sys_yield(void)
{
  800f79:	55                   	push   %ebp
  800f7a:	89 e5                	mov    %esp,%ebp
  800f7c:	57                   	push   %edi
  800f7d:	56                   	push   %esi
  800f7e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f7f:	ba 00 00 00 00       	mov    $0x0,%edx
  800f84:	b8 0b 00 00 00       	mov    $0xb,%eax
  800f89:	89 d1                	mov    %edx,%ecx
  800f8b:	89 d3                	mov    %edx,%ebx
  800f8d:	89 d7                	mov    %edx,%edi
  800f8f:	89 d6                	mov    %edx,%esi
  800f91:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800f93:	5b                   	pop    %ebx
  800f94:	5e                   	pop    %esi
  800f95:	5f                   	pop    %edi
  800f96:	5d                   	pop    %ebp
  800f97:	c3                   	ret    

00800f98 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800f98:	55                   	push   %ebp
  800f99:	89 e5                	mov    %esp,%ebp
  800f9b:	57                   	push   %edi
  800f9c:	56                   	push   %esi
  800f9d:	53                   	push   %ebx
  800f9e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fa1:	be 00 00 00 00       	mov    $0x0,%esi
  800fa6:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fac:	b8 04 00 00 00       	mov    $0x4,%eax
  800fb1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fb4:	89 f7                	mov    %esi,%edi
  800fb6:	cd 30                	int    $0x30
	if (check && ret > 0)
  800fb8:	85 c0                	test   %eax,%eax
  800fba:	7f 08                	jg     800fc4 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800fbc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fbf:	5b                   	pop    %ebx
  800fc0:	5e                   	pop    %esi
  800fc1:	5f                   	pop    %edi
  800fc2:	5d                   	pop    %ebp
  800fc3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fc4:	83 ec 0c             	sub    $0xc,%esp
  800fc7:	50                   	push   %eax
  800fc8:	6a 04                	push   $0x4
  800fca:	68 b0 25 80 00       	push   $0x8025b0
  800fcf:	6a 4c                	push   $0x4c
  800fd1:	68 cd 25 80 00       	push   $0x8025cd
  800fd6:	e8 da f2 ff ff       	call   8002b5 <_panic>

00800fdb <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800fdb:	55                   	push   %ebp
  800fdc:	89 e5                	mov    %esp,%ebp
  800fde:	57                   	push   %edi
  800fdf:	56                   	push   %esi
  800fe0:	53                   	push   %ebx
  800fe1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fe4:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fea:	b8 05 00 00 00       	mov    $0x5,%eax
  800fef:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ff2:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ff5:	8b 75 18             	mov    0x18(%ebp),%esi
  800ff8:	cd 30                	int    $0x30
	if (check && ret > 0)
  800ffa:	85 c0                	test   %eax,%eax
  800ffc:	7f 08                	jg     801006 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ffe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801001:	5b                   	pop    %ebx
  801002:	5e                   	pop    %esi
  801003:	5f                   	pop    %edi
  801004:	5d                   	pop    %ebp
  801005:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801006:	83 ec 0c             	sub    $0xc,%esp
  801009:	50                   	push   %eax
  80100a:	6a 05                	push   $0x5
  80100c:	68 b0 25 80 00       	push   $0x8025b0
  801011:	6a 4c                	push   $0x4c
  801013:	68 cd 25 80 00       	push   $0x8025cd
  801018:	e8 98 f2 ff ff       	call   8002b5 <_panic>

0080101d <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80101d:	55                   	push   %ebp
  80101e:	89 e5                	mov    %esp,%ebp
  801020:	57                   	push   %edi
  801021:	56                   	push   %esi
  801022:	53                   	push   %ebx
  801023:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801026:	bb 00 00 00 00       	mov    $0x0,%ebx
  80102b:	8b 55 08             	mov    0x8(%ebp),%edx
  80102e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801031:	b8 06 00 00 00       	mov    $0x6,%eax
  801036:	89 df                	mov    %ebx,%edi
  801038:	89 de                	mov    %ebx,%esi
  80103a:	cd 30                	int    $0x30
	if (check && ret > 0)
  80103c:	85 c0                	test   %eax,%eax
  80103e:	7f 08                	jg     801048 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801040:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801043:	5b                   	pop    %ebx
  801044:	5e                   	pop    %esi
  801045:	5f                   	pop    %edi
  801046:	5d                   	pop    %ebp
  801047:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801048:	83 ec 0c             	sub    $0xc,%esp
  80104b:	50                   	push   %eax
  80104c:	6a 06                	push   $0x6
  80104e:	68 b0 25 80 00       	push   $0x8025b0
  801053:	6a 4c                	push   $0x4c
  801055:	68 cd 25 80 00       	push   $0x8025cd
  80105a:	e8 56 f2 ff ff       	call   8002b5 <_panic>

0080105f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80105f:	55                   	push   %ebp
  801060:	89 e5                	mov    %esp,%ebp
  801062:	57                   	push   %edi
  801063:	56                   	push   %esi
  801064:	53                   	push   %ebx
  801065:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801068:	bb 00 00 00 00       	mov    $0x0,%ebx
  80106d:	8b 55 08             	mov    0x8(%ebp),%edx
  801070:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801073:	b8 08 00 00 00       	mov    $0x8,%eax
  801078:	89 df                	mov    %ebx,%edi
  80107a:	89 de                	mov    %ebx,%esi
  80107c:	cd 30                	int    $0x30
	if (check && ret > 0)
  80107e:	85 c0                	test   %eax,%eax
  801080:	7f 08                	jg     80108a <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801082:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801085:	5b                   	pop    %ebx
  801086:	5e                   	pop    %esi
  801087:	5f                   	pop    %edi
  801088:	5d                   	pop    %ebp
  801089:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80108a:	83 ec 0c             	sub    $0xc,%esp
  80108d:	50                   	push   %eax
  80108e:	6a 08                	push   $0x8
  801090:	68 b0 25 80 00       	push   $0x8025b0
  801095:	6a 4c                	push   $0x4c
  801097:	68 cd 25 80 00       	push   $0x8025cd
  80109c:	e8 14 f2 ff ff       	call   8002b5 <_panic>

008010a1 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8010a1:	55                   	push   %ebp
  8010a2:	89 e5                	mov    %esp,%ebp
  8010a4:	57                   	push   %edi
  8010a5:	56                   	push   %esi
  8010a6:	53                   	push   %ebx
  8010a7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010aa:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010af:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010b5:	b8 09 00 00 00       	mov    $0x9,%eax
  8010ba:	89 df                	mov    %ebx,%edi
  8010bc:	89 de                	mov    %ebx,%esi
  8010be:	cd 30                	int    $0x30
	if (check && ret > 0)
  8010c0:	85 c0                	test   %eax,%eax
  8010c2:	7f 08                	jg     8010cc <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8010c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010c7:	5b                   	pop    %ebx
  8010c8:	5e                   	pop    %esi
  8010c9:	5f                   	pop    %edi
  8010ca:	5d                   	pop    %ebp
  8010cb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010cc:	83 ec 0c             	sub    $0xc,%esp
  8010cf:	50                   	push   %eax
  8010d0:	6a 09                	push   $0x9
  8010d2:	68 b0 25 80 00       	push   $0x8025b0
  8010d7:	6a 4c                	push   $0x4c
  8010d9:	68 cd 25 80 00       	push   $0x8025cd
  8010de:	e8 d2 f1 ff ff       	call   8002b5 <_panic>

008010e3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8010e3:	55                   	push   %ebp
  8010e4:	89 e5                	mov    %esp,%ebp
  8010e6:	57                   	push   %edi
  8010e7:	56                   	push   %esi
  8010e8:	53                   	push   %ebx
  8010e9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010ec:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010f7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8010fc:	89 df                	mov    %ebx,%edi
  8010fe:	89 de                	mov    %ebx,%esi
  801100:	cd 30                	int    $0x30
	if (check && ret > 0)
  801102:	85 c0                	test   %eax,%eax
  801104:	7f 08                	jg     80110e <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801106:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801109:	5b                   	pop    %ebx
  80110a:	5e                   	pop    %esi
  80110b:	5f                   	pop    %edi
  80110c:	5d                   	pop    %ebp
  80110d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80110e:	83 ec 0c             	sub    $0xc,%esp
  801111:	50                   	push   %eax
  801112:	6a 0a                	push   $0xa
  801114:	68 b0 25 80 00       	push   $0x8025b0
  801119:	6a 4c                	push   $0x4c
  80111b:	68 cd 25 80 00       	push   $0x8025cd
  801120:	e8 90 f1 ff ff       	call   8002b5 <_panic>

00801125 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801125:	55                   	push   %ebp
  801126:	89 e5                	mov    %esp,%ebp
  801128:	57                   	push   %edi
  801129:	56                   	push   %esi
  80112a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80112b:	8b 55 08             	mov    0x8(%ebp),%edx
  80112e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801131:	b8 0c 00 00 00       	mov    $0xc,%eax
  801136:	be 00 00 00 00       	mov    $0x0,%esi
  80113b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80113e:	8b 7d 14             	mov    0x14(%ebp),%edi
  801141:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801143:	5b                   	pop    %ebx
  801144:	5e                   	pop    %esi
  801145:	5f                   	pop    %edi
  801146:	5d                   	pop    %ebp
  801147:	c3                   	ret    

00801148 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801148:	55                   	push   %ebp
  801149:	89 e5                	mov    %esp,%ebp
  80114b:	57                   	push   %edi
  80114c:	56                   	push   %esi
  80114d:	53                   	push   %ebx
  80114e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801151:	b9 00 00 00 00       	mov    $0x0,%ecx
  801156:	8b 55 08             	mov    0x8(%ebp),%edx
  801159:	b8 0d 00 00 00       	mov    $0xd,%eax
  80115e:	89 cb                	mov    %ecx,%ebx
  801160:	89 cf                	mov    %ecx,%edi
  801162:	89 ce                	mov    %ecx,%esi
  801164:	cd 30                	int    $0x30
	if (check && ret > 0)
  801166:	85 c0                	test   %eax,%eax
  801168:	7f 08                	jg     801172 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80116a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80116d:	5b                   	pop    %ebx
  80116e:	5e                   	pop    %esi
  80116f:	5f                   	pop    %edi
  801170:	5d                   	pop    %ebp
  801171:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801172:	83 ec 0c             	sub    $0xc,%esp
  801175:	50                   	push   %eax
  801176:	6a 0d                	push   $0xd
  801178:	68 b0 25 80 00       	push   $0x8025b0
  80117d:	6a 4c                	push   $0x4c
  80117f:	68 cd 25 80 00       	push   $0x8025cd
  801184:	e8 2c f1 ff ff       	call   8002b5 <_panic>

00801189 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  801189:	55                   	push   %ebp
  80118a:	89 e5                	mov    %esp,%ebp
  80118c:	57                   	push   %edi
  80118d:	56                   	push   %esi
  80118e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80118f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801194:	8b 55 08             	mov    0x8(%ebp),%edx
  801197:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80119a:	b8 0e 00 00 00       	mov    $0xe,%eax
  80119f:	89 df                	mov    %ebx,%edi
  8011a1:	89 de                	mov    %ebx,%esi
  8011a3:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8011a5:	5b                   	pop    %ebx
  8011a6:	5e                   	pop    %esi
  8011a7:	5f                   	pop    %edi
  8011a8:	5d                   	pop    %ebp
  8011a9:	c3                   	ret    

008011aa <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8011aa:	55                   	push   %ebp
  8011ab:	89 e5                	mov    %esp,%ebp
  8011ad:	57                   	push   %edi
  8011ae:	56                   	push   %esi
  8011af:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011b0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8011b8:	b8 0f 00 00 00       	mov    $0xf,%eax
  8011bd:	89 cb                	mov    %ecx,%ebx
  8011bf:	89 cf                	mov    %ecx,%edi
  8011c1:	89 ce                	mov    %ecx,%esi
  8011c3:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8011c5:	5b                   	pop    %ebx
  8011c6:	5e                   	pop    %esi
  8011c7:	5f                   	pop    %edi
  8011c8:	5d                   	pop    %ebp
  8011c9:	c3                   	ret    

008011ca <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8011ca:	55                   	push   %ebp
  8011cb:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d0:	05 00 00 00 30       	add    $0x30000000,%eax
  8011d5:	c1 e8 0c             	shr    $0xc,%eax
}
  8011d8:	5d                   	pop    %ebp
  8011d9:	c3                   	ret    

008011da <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8011da:	55                   	push   %ebp
  8011db:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e0:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8011e5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011ea:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8011ef:	5d                   	pop    %ebp
  8011f0:	c3                   	ret    

008011f1 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8011f1:	55                   	push   %ebp
  8011f2:	89 e5                	mov    %esp,%ebp
  8011f4:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8011f9:	89 c2                	mov    %eax,%edx
  8011fb:	c1 ea 16             	shr    $0x16,%edx
  8011fe:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801205:	f6 c2 01             	test   $0x1,%dl
  801208:	74 2d                	je     801237 <fd_alloc+0x46>
  80120a:	89 c2                	mov    %eax,%edx
  80120c:	c1 ea 0c             	shr    $0xc,%edx
  80120f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801216:	f6 c2 01             	test   $0x1,%dl
  801219:	74 1c                	je     801237 <fd_alloc+0x46>
  80121b:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801220:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801225:	75 d2                	jne    8011f9 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801227:	8b 45 08             	mov    0x8(%ebp),%eax
  80122a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801230:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801235:	eb 0a                	jmp    801241 <fd_alloc+0x50>
			*fd_store = fd;
  801237:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80123a:	89 01                	mov    %eax,(%ecx)
			return 0;
  80123c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801241:	5d                   	pop    %ebp
  801242:	c3                   	ret    

00801243 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801243:	55                   	push   %ebp
  801244:	89 e5                	mov    %esp,%ebp
  801246:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801249:	83 f8 1f             	cmp    $0x1f,%eax
  80124c:	77 30                	ja     80127e <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80124e:	c1 e0 0c             	shl    $0xc,%eax
  801251:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801256:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80125c:	f6 c2 01             	test   $0x1,%dl
  80125f:	74 24                	je     801285 <fd_lookup+0x42>
  801261:	89 c2                	mov    %eax,%edx
  801263:	c1 ea 0c             	shr    $0xc,%edx
  801266:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80126d:	f6 c2 01             	test   $0x1,%dl
  801270:	74 1a                	je     80128c <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801272:	8b 55 0c             	mov    0xc(%ebp),%edx
  801275:	89 02                	mov    %eax,(%edx)
	return 0;
  801277:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80127c:	5d                   	pop    %ebp
  80127d:	c3                   	ret    
		return -E_INVAL;
  80127e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801283:	eb f7                	jmp    80127c <fd_lookup+0x39>
		return -E_INVAL;
  801285:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80128a:	eb f0                	jmp    80127c <fd_lookup+0x39>
  80128c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801291:	eb e9                	jmp    80127c <fd_lookup+0x39>

00801293 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801293:	55                   	push   %ebp
  801294:	89 e5                	mov    %esp,%ebp
  801296:	83 ec 08             	sub    $0x8,%esp
  801299:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80129c:	ba 5c 26 80 00       	mov    $0x80265c,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8012a1:	b8 20 30 80 00       	mov    $0x803020,%eax
		if (devtab[i]->dev_id == dev_id) {
  8012a6:	39 08                	cmp    %ecx,(%eax)
  8012a8:	74 33                	je     8012dd <dev_lookup+0x4a>
  8012aa:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8012ad:	8b 02                	mov    (%edx),%eax
  8012af:	85 c0                	test   %eax,%eax
  8012b1:	75 f3                	jne    8012a6 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8012b3:	a1 04 44 80 00       	mov    0x804404,%eax
  8012b8:	8b 40 48             	mov    0x48(%eax),%eax
  8012bb:	83 ec 04             	sub    $0x4,%esp
  8012be:	51                   	push   %ecx
  8012bf:	50                   	push   %eax
  8012c0:	68 dc 25 80 00       	push   $0x8025dc
  8012c5:	e8 c6 f0 ff ff       	call   800390 <cprintf>
	*dev = 0;
  8012ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8012d3:	83 c4 10             	add    $0x10,%esp
  8012d6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8012db:	c9                   	leave  
  8012dc:	c3                   	ret    
			*dev = devtab[i];
  8012dd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012e0:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8012e7:	eb f2                	jmp    8012db <dev_lookup+0x48>

008012e9 <fd_close>:
{
  8012e9:	55                   	push   %ebp
  8012ea:	89 e5                	mov    %esp,%ebp
  8012ec:	57                   	push   %edi
  8012ed:	56                   	push   %esi
  8012ee:	53                   	push   %ebx
  8012ef:	83 ec 24             	sub    $0x24,%esp
  8012f2:	8b 75 08             	mov    0x8(%ebp),%esi
  8012f5:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012f8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012fb:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012fc:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801302:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801305:	50                   	push   %eax
  801306:	e8 38 ff ff ff       	call   801243 <fd_lookup>
  80130b:	89 c3                	mov    %eax,%ebx
  80130d:	83 c4 10             	add    $0x10,%esp
  801310:	85 c0                	test   %eax,%eax
  801312:	78 05                	js     801319 <fd_close+0x30>
	    || fd != fd2)
  801314:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801317:	74 16                	je     80132f <fd_close+0x46>
		return (must_exist ? r : 0);
  801319:	89 f8                	mov    %edi,%eax
  80131b:	84 c0                	test   %al,%al
  80131d:	b8 00 00 00 00       	mov    $0x0,%eax
  801322:	0f 44 d8             	cmove  %eax,%ebx
}
  801325:	89 d8                	mov    %ebx,%eax
  801327:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80132a:	5b                   	pop    %ebx
  80132b:	5e                   	pop    %esi
  80132c:	5f                   	pop    %edi
  80132d:	5d                   	pop    %ebp
  80132e:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80132f:	83 ec 08             	sub    $0x8,%esp
  801332:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801335:	50                   	push   %eax
  801336:	ff 36                	pushl  (%esi)
  801338:	e8 56 ff ff ff       	call   801293 <dev_lookup>
  80133d:	89 c3                	mov    %eax,%ebx
  80133f:	83 c4 10             	add    $0x10,%esp
  801342:	85 c0                	test   %eax,%eax
  801344:	78 1a                	js     801360 <fd_close+0x77>
		if (dev->dev_close)
  801346:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801349:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80134c:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801351:	85 c0                	test   %eax,%eax
  801353:	74 0b                	je     801360 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801355:	83 ec 0c             	sub    $0xc,%esp
  801358:	56                   	push   %esi
  801359:	ff d0                	call   *%eax
  80135b:	89 c3                	mov    %eax,%ebx
  80135d:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801360:	83 ec 08             	sub    $0x8,%esp
  801363:	56                   	push   %esi
  801364:	6a 00                	push   $0x0
  801366:	e8 b2 fc ff ff       	call   80101d <sys_page_unmap>
	return r;
  80136b:	83 c4 10             	add    $0x10,%esp
  80136e:	eb b5                	jmp    801325 <fd_close+0x3c>

00801370 <close>:

int
close(int fdnum)
{
  801370:	55                   	push   %ebp
  801371:	89 e5                	mov    %esp,%ebp
  801373:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801376:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801379:	50                   	push   %eax
  80137a:	ff 75 08             	pushl  0x8(%ebp)
  80137d:	e8 c1 fe ff ff       	call   801243 <fd_lookup>
  801382:	83 c4 10             	add    $0x10,%esp
  801385:	85 c0                	test   %eax,%eax
  801387:	79 02                	jns    80138b <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801389:	c9                   	leave  
  80138a:	c3                   	ret    
		return fd_close(fd, 1);
  80138b:	83 ec 08             	sub    $0x8,%esp
  80138e:	6a 01                	push   $0x1
  801390:	ff 75 f4             	pushl  -0xc(%ebp)
  801393:	e8 51 ff ff ff       	call   8012e9 <fd_close>
  801398:	83 c4 10             	add    $0x10,%esp
  80139b:	eb ec                	jmp    801389 <close+0x19>

0080139d <close_all>:

void
close_all(void)
{
  80139d:	55                   	push   %ebp
  80139e:	89 e5                	mov    %esp,%ebp
  8013a0:	53                   	push   %ebx
  8013a1:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8013a4:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8013a9:	83 ec 0c             	sub    $0xc,%esp
  8013ac:	53                   	push   %ebx
  8013ad:	e8 be ff ff ff       	call   801370 <close>
	for (i = 0; i < MAXFD; i++)
  8013b2:	83 c3 01             	add    $0x1,%ebx
  8013b5:	83 c4 10             	add    $0x10,%esp
  8013b8:	83 fb 20             	cmp    $0x20,%ebx
  8013bb:	75 ec                	jne    8013a9 <close_all+0xc>
}
  8013bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013c0:	c9                   	leave  
  8013c1:	c3                   	ret    

008013c2 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8013c2:	55                   	push   %ebp
  8013c3:	89 e5                	mov    %esp,%ebp
  8013c5:	57                   	push   %edi
  8013c6:	56                   	push   %esi
  8013c7:	53                   	push   %ebx
  8013c8:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8013cb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8013ce:	50                   	push   %eax
  8013cf:	ff 75 08             	pushl  0x8(%ebp)
  8013d2:	e8 6c fe ff ff       	call   801243 <fd_lookup>
  8013d7:	89 c3                	mov    %eax,%ebx
  8013d9:	83 c4 10             	add    $0x10,%esp
  8013dc:	85 c0                	test   %eax,%eax
  8013de:	0f 88 81 00 00 00    	js     801465 <dup+0xa3>
		return r;
	close(newfdnum);
  8013e4:	83 ec 0c             	sub    $0xc,%esp
  8013e7:	ff 75 0c             	pushl  0xc(%ebp)
  8013ea:	e8 81 ff ff ff       	call   801370 <close>

	newfd = INDEX2FD(newfdnum);
  8013ef:	8b 75 0c             	mov    0xc(%ebp),%esi
  8013f2:	c1 e6 0c             	shl    $0xc,%esi
  8013f5:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8013fb:	83 c4 04             	add    $0x4,%esp
  8013fe:	ff 75 e4             	pushl  -0x1c(%ebp)
  801401:	e8 d4 fd ff ff       	call   8011da <fd2data>
  801406:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801408:	89 34 24             	mov    %esi,(%esp)
  80140b:	e8 ca fd ff ff       	call   8011da <fd2data>
  801410:	83 c4 10             	add    $0x10,%esp
  801413:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801415:	89 d8                	mov    %ebx,%eax
  801417:	c1 e8 16             	shr    $0x16,%eax
  80141a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801421:	a8 01                	test   $0x1,%al
  801423:	74 11                	je     801436 <dup+0x74>
  801425:	89 d8                	mov    %ebx,%eax
  801427:	c1 e8 0c             	shr    $0xc,%eax
  80142a:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801431:	f6 c2 01             	test   $0x1,%dl
  801434:	75 39                	jne    80146f <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801436:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801439:	89 d0                	mov    %edx,%eax
  80143b:	c1 e8 0c             	shr    $0xc,%eax
  80143e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801445:	83 ec 0c             	sub    $0xc,%esp
  801448:	25 07 0e 00 00       	and    $0xe07,%eax
  80144d:	50                   	push   %eax
  80144e:	56                   	push   %esi
  80144f:	6a 00                	push   $0x0
  801451:	52                   	push   %edx
  801452:	6a 00                	push   $0x0
  801454:	e8 82 fb ff ff       	call   800fdb <sys_page_map>
  801459:	89 c3                	mov    %eax,%ebx
  80145b:	83 c4 20             	add    $0x20,%esp
  80145e:	85 c0                	test   %eax,%eax
  801460:	78 31                	js     801493 <dup+0xd1>
		goto err;

	return newfdnum;
  801462:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801465:	89 d8                	mov    %ebx,%eax
  801467:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80146a:	5b                   	pop    %ebx
  80146b:	5e                   	pop    %esi
  80146c:	5f                   	pop    %edi
  80146d:	5d                   	pop    %ebp
  80146e:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80146f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801476:	83 ec 0c             	sub    $0xc,%esp
  801479:	25 07 0e 00 00       	and    $0xe07,%eax
  80147e:	50                   	push   %eax
  80147f:	57                   	push   %edi
  801480:	6a 00                	push   $0x0
  801482:	53                   	push   %ebx
  801483:	6a 00                	push   $0x0
  801485:	e8 51 fb ff ff       	call   800fdb <sys_page_map>
  80148a:	89 c3                	mov    %eax,%ebx
  80148c:	83 c4 20             	add    $0x20,%esp
  80148f:	85 c0                	test   %eax,%eax
  801491:	79 a3                	jns    801436 <dup+0x74>
	sys_page_unmap(0, newfd);
  801493:	83 ec 08             	sub    $0x8,%esp
  801496:	56                   	push   %esi
  801497:	6a 00                	push   $0x0
  801499:	e8 7f fb ff ff       	call   80101d <sys_page_unmap>
	sys_page_unmap(0, nva);
  80149e:	83 c4 08             	add    $0x8,%esp
  8014a1:	57                   	push   %edi
  8014a2:	6a 00                	push   $0x0
  8014a4:	e8 74 fb ff ff       	call   80101d <sys_page_unmap>
	return r;
  8014a9:	83 c4 10             	add    $0x10,%esp
  8014ac:	eb b7                	jmp    801465 <dup+0xa3>

008014ae <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8014ae:	55                   	push   %ebp
  8014af:	89 e5                	mov    %esp,%ebp
  8014b1:	53                   	push   %ebx
  8014b2:	83 ec 1c             	sub    $0x1c,%esp
  8014b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014b8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014bb:	50                   	push   %eax
  8014bc:	53                   	push   %ebx
  8014bd:	e8 81 fd ff ff       	call   801243 <fd_lookup>
  8014c2:	83 c4 10             	add    $0x10,%esp
  8014c5:	85 c0                	test   %eax,%eax
  8014c7:	78 3f                	js     801508 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014c9:	83 ec 08             	sub    $0x8,%esp
  8014cc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014cf:	50                   	push   %eax
  8014d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014d3:	ff 30                	pushl  (%eax)
  8014d5:	e8 b9 fd ff ff       	call   801293 <dev_lookup>
  8014da:	83 c4 10             	add    $0x10,%esp
  8014dd:	85 c0                	test   %eax,%eax
  8014df:	78 27                	js     801508 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8014e1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014e4:	8b 42 08             	mov    0x8(%edx),%eax
  8014e7:	83 e0 03             	and    $0x3,%eax
  8014ea:	83 f8 01             	cmp    $0x1,%eax
  8014ed:	74 1e                	je     80150d <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8014ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014f2:	8b 40 08             	mov    0x8(%eax),%eax
  8014f5:	85 c0                	test   %eax,%eax
  8014f7:	74 35                	je     80152e <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8014f9:	83 ec 04             	sub    $0x4,%esp
  8014fc:	ff 75 10             	pushl  0x10(%ebp)
  8014ff:	ff 75 0c             	pushl  0xc(%ebp)
  801502:	52                   	push   %edx
  801503:	ff d0                	call   *%eax
  801505:	83 c4 10             	add    $0x10,%esp
}
  801508:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80150b:	c9                   	leave  
  80150c:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80150d:	a1 04 44 80 00       	mov    0x804404,%eax
  801512:	8b 40 48             	mov    0x48(%eax),%eax
  801515:	83 ec 04             	sub    $0x4,%esp
  801518:	53                   	push   %ebx
  801519:	50                   	push   %eax
  80151a:	68 20 26 80 00       	push   $0x802620
  80151f:	e8 6c ee ff ff       	call   800390 <cprintf>
		return -E_INVAL;
  801524:	83 c4 10             	add    $0x10,%esp
  801527:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80152c:	eb da                	jmp    801508 <read+0x5a>
		return -E_NOT_SUPP;
  80152e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801533:	eb d3                	jmp    801508 <read+0x5a>

00801535 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801535:	55                   	push   %ebp
  801536:	89 e5                	mov    %esp,%ebp
  801538:	57                   	push   %edi
  801539:	56                   	push   %esi
  80153a:	53                   	push   %ebx
  80153b:	83 ec 0c             	sub    $0xc,%esp
  80153e:	8b 7d 08             	mov    0x8(%ebp),%edi
  801541:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801544:	bb 00 00 00 00       	mov    $0x0,%ebx
  801549:	39 f3                	cmp    %esi,%ebx
  80154b:	73 23                	jae    801570 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80154d:	83 ec 04             	sub    $0x4,%esp
  801550:	89 f0                	mov    %esi,%eax
  801552:	29 d8                	sub    %ebx,%eax
  801554:	50                   	push   %eax
  801555:	89 d8                	mov    %ebx,%eax
  801557:	03 45 0c             	add    0xc(%ebp),%eax
  80155a:	50                   	push   %eax
  80155b:	57                   	push   %edi
  80155c:	e8 4d ff ff ff       	call   8014ae <read>
		if (m < 0)
  801561:	83 c4 10             	add    $0x10,%esp
  801564:	85 c0                	test   %eax,%eax
  801566:	78 06                	js     80156e <readn+0x39>
			return m;
		if (m == 0)
  801568:	74 06                	je     801570 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  80156a:	01 c3                	add    %eax,%ebx
  80156c:	eb db                	jmp    801549 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80156e:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801570:	89 d8                	mov    %ebx,%eax
  801572:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801575:	5b                   	pop    %ebx
  801576:	5e                   	pop    %esi
  801577:	5f                   	pop    %edi
  801578:	5d                   	pop    %ebp
  801579:	c3                   	ret    

0080157a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80157a:	55                   	push   %ebp
  80157b:	89 e5                	mov    %esp,%ebp
  80157d:	53                   	push   %ebx
  80157e:	83 ec 1c             	sub    $0x1c,%esp
  801581:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801584:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801587:	50                   	push   %eax
  801588:	53                   	push   %ebx
  801589:	e8 b5 fc ff ff       	call   801243 <fd_lookup>
  80158e:	83 c4 10             	add    $0x10,%esp
  801591:	85 c0                	test   %eax,%eax
  801593:	78 3a                	js     8015cf <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801595:	83 ec 08             	sub    $0x8,%esp
  801598:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80159b:	50                   	push   %eax
  80159c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80159f:	ff 30                	pushl  (%eax)
  8015a1:	e8 ed fc ff ff       	call   801293 <dev_lookup>
  8015a6:	83 c4 10             	add    $0x10,%esp
  8015a9:	85 c0                	test   %eax,%eax
  8015ab:	78 22                	js     8015cf <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015b0:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015b4:	74 1e                	je     8015d4 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8015b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015b9:	8b 52 0c             	mov    0xc(%edx),%edx
  8015bc:	85 d2                	test   %edx,%edx
  8015be:	74 35                	je     8015f5 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8015c0:	83 ec 04             	sub    $0x4,%esp
  8015c3:	ff 75 10             	pushl  0x10(%ebp)
  8015c6:	ff 75 0c             	pushl  0xc(%ebp)
  8015c9:	50                   	push   %eax
  8015ca:	ff d2                	call   *%edx
  8015cc:	83 c4 10             	add    $0x10,%esp
}
  8015cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015d2:	c9                   	leave  
  8015d3:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8015d4:	a1 04 44 80 00       	mov    0x804404,%eax
  8015d9:	8b 40 48             	mov    0x48(%eax),%eax
  8015dc:	83 ec 04             	sub    $0x4,%esp
  8015df:	53                   	push   %ebx
  8015e0:	50                   	push   %eax
  8015e1:	68 3c 26 80 00       	push   $0x80263c
  8015e6:	e8 a5 ed ff ff       	call   800390 <cprintf>
		return -E_INVAL;
  8015eb:	83 c4 10             	add    $0x10,%esp
  8015ee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015f3:	eb da                	jmp    8015cf <write+0x55>
		return -E_NOT_SUPP;
  8015f5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015fa:	eb d3                	jmp    8015cf <write+0x55>

008015fc <seek>:

int
seek(int fdnum, off_t offset)
{
  8015fc:	55                   	push   %ebp
  8015fd:	89 e5                	mov    %esp,%ebp
  8015ff:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801602:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801605:	50                   	push   %eax
  801606:	ff 75 08             	pushl  0x8(%ebp)
  801609:	e8 35 fc ff ff       	call   801243 <fd_lookup>
  80160e:	83 c4 10             	add    $0x10,%esp
  801611:	85 c0                	test   %eax,%eax
  801613:	78 0e                	js     801623 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801615:	8b 55 0c             	mov    0xc(%ebp),%edx
  801618:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80161b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80161e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801623:	c9                   	leave  
  801624:	c3                   	ret    

00801625 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801625:	55                   	push   %ebp
  801626:	89 e5                	mov    %esp,%ebp
  801628:	53                   	push   %ebx
  801629:	83 ec 1c             	sub    $0x1c,%esp
  80162c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80162f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801632:	50                   	push   %eax
  801633:	53                   	push   %ebx
  801634:	e8 0a fc ff ff       	call   801243 <fd_lookup>
  801639:	83 c4 10             	add    $0x10,%esp
  80163c:	85 c0                	test   %eax,%eax
  80163e:	78 37                	js     801677 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801640:	83 ec 08             	sub    $0x8,%esp
  801643:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801646:	50                   	push   %eax
  801647:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80164a:	ff 30                	pushl  (%eax)
  80164c:	e8 42 fc ff ff       	call   801293 <dev_lookup>
  801651:	83 c4 10             	add    $0x10,%esp
  801654:	85 c0                	test   %eax,%eax
  801656:	78 1f                	js     801677 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801658:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80165b:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80165f:	74 1b                	je     80167c <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801661:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801664:	8b 52 18             	mov    0x18(%edx),%edx
  801667:	85 d2                	test   %edx,%edx
  801669:	74 32                	je     80169d <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80166b:	83 ec 08             	sub    $0x8,%esp
  80166e:	ff 75 0c             	pushl  0xc(%ebp)
  801671:	50                   	push   %eax
  801672:	ff d2                	call   *%edx
  801674:	83 c4 10             	add    $0x10,%esp
}
  801677:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80167a:	c9                   	leave  
  80167b:	c3                   	ret    
			thisenv->env_id, fdnum);
  80167c:	a1 04 44 80 00       	mov    0x804404,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801681:	8b 40 48             	mov    0x48(%eax),%eax
  801684:	83 ec 04             	sub    $0x4,%esp
  801687:	53                   	push   %ebx
  801688:	50                   	push   %eax
  801689:	68 fc 25 80 00       	push   $0x8025fc
  80168e:	e8 fd ec ff ff       	call   800390 <cprintf>
		return -E_INVAL;
  801693:	83 c4 10             	add    $0x10,%esp
  801696:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80169b:	eb da                	jmp    801677 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80169d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016a2:	eb d3                	jmp    801677 <ftruncate+0x52>

008016a4 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8016a4:	55                   	push   %ebp
  8016a5:	89 e5                	mov    %esp,%ebp
  8016a7:	53                   	push   %ebx
  8016a8:	83 ec 1c             	sub    $0x1c,%esp
  8016ab:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016ae:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016b1:	50                   	push   %eax
  8016b2:	ff 75 08             	pushl  0x8(%ebp)
  8016b5:	e8 89 fb ff ff       	call   801243 <fd_lookup>
  8016ba:	83 c4 10             	add    $0x10,%esp
  8016bd:	85 c0                	test   %eax,%eax
  8016bf:	78 4b                	js     80170c <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016c1:	83 ec 08             	sub    $0x8,%esp
  8016c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016c7:	50                   	push   %eax
  8016c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016cb:	ff 30                	pushl  (%eax)
  8016cd:	e8 c1 fb ff ff       	call   801293 <dev_lookup>
  8016d2:	83 c4 10             	add    $0x10,%esp
  8016d5:	85 c0                	test   %eax,%eax
  8016d7:	78 33                	js     80170c <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8016d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016dc:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8016e0:	74 2f                	je     801711 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8016e2:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8016e5:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8016ec:	00 00 00 
	stat->st_isdir = 0;
  8016ef:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8016f6:	00 00 00 
	stat->st_dev = dev;
  8016f9:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8016ff:	83 ec 08             	sub    $0x8,%esp
  801702:	53                   	push   %ebx
  801703:	ff 75 f0             	pushl  -0x10(%ebp)
  801706:	ff 50 14             	call   *0x14(%eax)
  801709:	83 c4 10             	add    $0x10,%esp
}
  80170c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80170f:	c9                   	leave  
  801710:	c3                   	ret    
		return -E_NOT_SUPP;
  801711:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801716:	eb f4                	jmp    80170c <fstat+0x68>

00801718 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801718:	55                   	push   %ebp
  801719:	89 e5                	mov    %esp,%ebp
  80171b:	56                   	push   %esi
  80171c:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80171d:	83 ec 08             	sub    $0x8,%esp
  801720:	6a 00                	push   $0x0
  801722:	ff 75 08             	pushl  0x8(%ebp)
  801725:	e8 bb 01 00 00       	call   8018e5 <open>
  80172a:	89 c3                	mov    %eax,%ebx
  80172c:	83 c4 10             	add    $0x10,%esp
  80172f:	85 c0                	test   %eax,%eax
  801731:	78 1b                	js     80174e <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801733:	83 ec 08             	sub    $0x8,%esp
  801736:	ff 75 0c             	pushl  0xc(%ebp)
  801739:	50                   	push   %eax
  80173a:	e8 65 ff ff ff       	call   8016a4 <fstat>
  80173f:	89 c6                	mov    %eax,%esi
	close(fd);
  801741:	89 1c 24             	mov    %ebx,(%esp)
  801744:	e8 27 fc ff ff       	call   801370 <close>
	return r;
  801749:	83 c4 10             	add    $0x10,%esp
  80174c:	89 f3                	mov    %esi,%ebx
}
  80174e:	89 d8                	mov    %ebx,%eax
  801750:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801753:	5b                   	pop    %ebx
  801754:	5e                   	pop    %esi
  801755:	5d                   	pop    %ebp
  801756:	c3                   	ret    

00801757 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801757:	55                   	push   %ebp
  801758:	89 e5                	mov    %esp,%ebp
  80175a:	56                   	push   %esi
  80175b:	53                   	push   %ebx
  80175c:	89 c6                	mov    %eax,%esi
  80175e:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801760:	83 3d 00 44 80 00 00 	cmpl   $0x0,0x804400
  801767:	74 27                	je     801790 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801769:	6a 07                	push   $0x7
  80176b:	68 00 50 80 00       	push   $0x805000
  801770:	56                   	push   %esi
  801771:	ff 35 00 44 80 00    	pushl  0x804400
  801777:	e8 d9 06 00 00       	call   801e55 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80177c:	83 c4 0c             	add    $0xc,%esp
  80177f:	6a 00                	push   $0x0
  801781:	53                   	push   %ebx
  801782:	6a 00                	push   $0x0
  801784:	e8 63 06 00 00       	call   801dec <ipc_recv>
}
  801789:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80178c:	5b                   	pop    %ebx
  80178d:	5e                   	pop    %esi
  80178e:	5d                   	pop    %ebp
  80178f:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801790:	83 ec 0c             	sub    $0xc,%esp
  801793:	6a 01                	push   $0x1
  801795:	e8 08 07 00 00       	call   801ea2 <ipc_find_env>
  80179a:	a3 00 44 80 00       	mov    %eax,0x804400
  80179f:	83 c4 10             	add    $0x10,%esp
  8017a2:	eb c5                	jmp    801769 <fsipc+0x12>

008017a4 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8017a4:	55                   	push   %ebp
  8017a5:	89 e5                	mov    %esp,%ebp
  8017a7:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8017aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ad:	8b 40 0c             	mov    0xc(%eax),%eax
  8017b0:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8017b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017b8:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8017bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8017c2:	b8 02 00 00 00       	mov    $0x2,%eax
  8017c7:	e8 8b ff ff ff       	call   801757 <fsipc>
}
  8017cc:	c9                   	leave  
  8017cd:	c3                   	ret    

008017ce <devfile_flush>:
{
  8017ce:	55                   	push   %ebp
  8017cf:	89 e5                	mov    %esp,%ebp
  8017d1:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8017d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8017da:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8017df:	ba 00 00 00 00       	mov    $0x0,%edx
  8017e4:	b8 06 00 00 00       	mov    $0x6,%eax
  8017e9:	e8 69 ff ff ff       	call   801757 <fsipc>
}
  8017ee:	c9                   	leave  
  8017ef:	c3                   	ret    

008017f0 <devfile_stat>:
{
  8017f0:	55                   	push   %ebp
  8017f1:	89 e5                	mov    %esp,%ebp
  8017f3:	53                   	push   %ebx
  8017f4:	83 ec 04             	sub    $0x4,%esp
  8017f7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8017fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fd:	8b 40 0c             	mov    0xc(%eax),%eax
  801800:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801805:	ba 00 00 00 00       	mov    $0x0,%edx
  80180a:	b8 05 00 00 00       	mov    $0x5,%eax
  80180f:	e8 43 ff ff ff       	call   801757 <fsipc>
  801814:	85 c0                	test   %eax,%eax
  801816:	78 2c                	js     801844 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801818:	83 ec 08             	sub    $0x8,%esp
  80181b:	68 00 50 80 00       	push   $0x805000
  801820:	53                   	push   %ebx
  801821:	e8 80 f3 ff ff       	call   800ba6 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801826:	a1 80 50 80 00       	mov    0x805080,%eax
  80182b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801831:	a1 84 50 80 00       	mov    0x805084,%eax
  801836:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80183c:	83 c4 10             	add    $0x10,%esp
  80183f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801844:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801847:	c9                   	leave  
  801848:	c3                   	ret    

00801849 <devfile_write>:
{
  801849:	55                   	push   %ebp
  80184a:	89 e5                	mov    %esp,%ebp
  80184c:	83 ec 0c             	sub    $0xc,%esp
	panic("devfile_write not implemented");
  80184f:	68 6c 26 80 00       	push   $0x80266c
  801854:	68 90 00 00 00       	push   $0x90
  801859:	68 8a 26 80 00       	push   $0x80268a
  80185e:	e8 52 ea ff ff       	call   8002b5 <_panic>

00801863 <devfile_read>:
{
  801863:	55                   	push   %ebp
  801864:	89 e5                	mov    %esp,%ebp
  801866:	56                   	push   %esi
  801867:	53                   	push   %ebx
  801868:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80186b:	8b 45 08             	mov    0x8(%ebp),%eax
  80186e:	8b 40 0c             	mov    0xc(%eax),%eax
  801871:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801876:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80187c:	ba 00 00 00 00       	mov    $0x0,%edx
  801881:	b8 03 00 00 00       	mov    $0x3,%eax
  801886:	e8 cc fe ff ff       	call   801757 <fsipc>
  80188b:	89 c3                	mov    %eax,%ebx
  80188d:	85 c0                	test   %eax,%eax
  80188f:	78 1f                	js     8018b0 <devfile_read+0x4d>
	assert(r <= n);
  801891:	39 f0                	cmp    %esi,%eax
  801893:	77 24                	ja     8018b9 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801895:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80189a:	7f 33                	jg     8018cf <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80189c:	83 ec 04             	sub    $0x4,%esp
  80189f:	50                   	push   %eax
  8018a0:	68 00 50 80 00       	push   $0x805000
  8018a5:	ff 75 0c             	pushl  0xc(%ebp)
  8018a8:	e8 87 f4 ff ff       	call   800d34 <memmove>
	return r;
  8018ad:	83 c4 10             	add    $0x10,%esp
}
  8018b0:	89 d8                	mov    %ebx,%eax
  8018b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018b5:	5b                   	pop    %ebx
  8018b6:	5e                   	pop    %esi
  8018b7:	5d                   	pop    %ebp
  8018b8:	c3                   	ret    
	assert(r <= n);
  8018b9:	68 95 26 80 00       	push   $0x802695
  8018be:	68 9c 26 80 00       	push   $0x80269c
  8018c3:	6a 7c                	push   $0x7c
  8018c5:	68 8a 26 80 00       	push   $0x80268a
  8018ca:	e8 e6 e9 ff ff       	call   8002b5 <_panic>
	assert(r <= PGSIZE);
  8018cf:	68 b1 26 80 00       	push   $0x8026b1
  8018d4:	68 9c 26 80 00       	push   $0x80269c
  8018d9:	6a 7d                	push   $0x7d
  8018db:	68 8a 26 80 00       	push   $0x80268a
  8018e0:	e8 d0 e9 ff ff       	call   8002b5 <_panic>

008018e5 <open>:
{
  8018e5:	55                   	push   %ebp
  8018e6:	89 e5                	mov    %esp,%ebp
  8018e8:	56                   	push   %esi
  8018e9:	53                   	push   %ebx
  8018ea:	83 ec 1c             	sub    $0x1c,%esp
  8018ed:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8018f0:	56                   	push   %esi
  8018f1:	e8 77 f2 ff ff       	call   800b6d <strlen>
  8018f6:	83 c4 10             	add    $0x10,%esp
  8018f9:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8018fe:	7f 6c                	jg     80196c <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801900:	83 ec 0c             	sub    $0xc,%esp
  801903:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801906:	50                   	push   %eax
  801907:	e8 e5 f8 ff ff       	call   8011f1 <fd_alloc>
  80190c:	89 c3                	mov    %eax,%ebx
  80190e:	83 c4 10             	add    $0x10,%esp
  801911:	85 c0                	test   %eax,%eax
  801913:	78 3c                	js     801951 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801915:	83 ec 08             	sub    $0x8,%esp
  801918:	56                   	push   %esi
  801919:	68 00 50 80 00       	push   $0x805000
  80191e:	e8 83 f2 ff ff       	call   800ba6 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801923:	8b 45 0c             	mov    0xc(%ebp),%eax
  801926:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80192b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80192e:	b8 01 00 00 00       	mov    $0x1,%eax
  801933:	e8 1f fe ff ff       	call   801757 <fsipc>
  801938:	89 c3                	mov    %eax,%ebx
  80193a:	83 c4 10             	add    $0x10,%esp
  80193d:	85 c0                	test   %eax,%eax
  80193f:	78 19                	js     80195a <open+0x75>
	return fd2num(fd);
  801941:	83 ec 0c             	sub    $0xc,%esp
  801944:	ff 75 f4             	pushl  -0xc(%ebp)
  801947:	e8 7e f8 ff ff       	call   8011ca <fd2num>
  80194c:	89 c3                	mov    %eax,%ebx
  80194e:	83 c4 10             	add    $0x10,%esp
}
  801951:	89 d8                	mov    %ebx,%eax
  801953:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801956:	5b                   	pop    %ebx
  801957:	5e                   	pop    %esi
  801958:	5d                   	pop    %ebp
  801959:	c3                   	ret    
		fd_close(fd, 0);
  80195a:	83 ec 08             	sub    $0x8,%esp
  80195d:	6a 00                	push   $0x0
  80195f:	ff 75 f4             	pushl  -0xc(%ebp)
  801962:	e8 82 f9 ff ff       	call   8012e9 <fd_close>
		return r;
  801967:	83 c4 10             	add    $0x10,%esp
  80196a:	eb e5                	jmp    801951 <open+0x6c>
		return -E_BAD_PATH;
  80196c:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801971:	eb de                	jmp    801951 <open+0x6c>

00801973 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801973:	55                   	push   %ebp
  801974:	89 e5                	mov    %esp,%ebp
  801976:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801979:	ba 00 00 00 00       	mov    $0x0,%edx
  80197e:	b8 08 00 00 00       	mov    $0x8,%eax
  801983:	e8 cf fd ff ff       	call   801757 <fsipc>
}
  801988:	c9                   	leave  
  801989:	c3                   	ret    

0080198a <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  80198a:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  80198e:	7f 01                	jg     801991 <writebuf+0x7>
  801990:	c3                   	ret    
{
  801991:	55                   	push   %ebp
  801992:	89 e5                	mov    %esp,%ebp
  801994:	53                   	push   %ebx
  801995:	83 ec 08             	sub    $0x8,%esp
  801998:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  80199a:	ff 70 04             	pushl  0x4(%eax)
  80199d:	8d 40 10             	lea    0x10(%eax),%eax
  8019a0:	50                   	push   %eax
  8019a1:	ff 33                	pushl  (%ebx)
  8019a3:	e8 d2 fb ff ff       	call   80157a <write>
		if (result > 0)
  8019a8:	83 c4 10             	add    $0x10,%esp
  8019ab:	85 c0                	test   %eax,%eax
  8019ad:	7e 03                	jle    8019b2 <writebuf+0x28>
			b->result += result;
  8019af:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  8019b2:	39 43 04             	cmp    %eax,0x4(%ebx)
  8019b5:	74 0d                	je     8019c4 <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  8019b7:	85 c0                	test   %eax,%eax
  8019b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8019be:	0f 4f c2             	cmovg  %edx,%eax
  8019c1:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  8019c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019c7:	c9                   	leave  
  8019c8:	c3                   	ret    

008019c9 <putch>:

static void
putch(int ch, void *thunk)
{
  8019c9:	55                   	push   %ebp
  8019ca:	89 e5                	mov    %esp,%ebp
  8019cc:	53                   	push   %ebx
  8019cd:	83 ec 04             	sub    $0x4,%esp
  8019d0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  8019d3:	8b 53 04             	mov    0x4(%ebx),%edx
  8019d6:	8d 42 01             	lea    0x1(%edx),%eax
  8019d9:	89 43 04             	mov    %eax,0x4(%ebx)
  8019dc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019df:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  8019e3:	3d 00 01 00 00       	cmp    $0x100,%eax
  8019e8:	74 06                	je     8019f0 <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  8019ea:	83 c4 04             	add    $0x4,%esp
  8019ed:	5b                   	pop    %ebx
  8019ee:	5d                   	pop    %ebp
  8019ef:	c3                   	ret    
		writebuf(b);
  8019f0:	89 d8                	mov    %ebx,%eax
  8019f2:	e8 93 ff ff ff       	call   80198a <writebuf>
		b->idx = 0;
  8019f7:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  8019fe:	eb ea                	jmp    8019ea <putch+0x21>

00801a00 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801a00:	55                   	push   %ebp
  801a01:	89 e5                	mov    %esp,%ebp
  801a03:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  801a09:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0c:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801a12:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801a19:	00 00 00 
	b.result = 0;
  801a1c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801a23:	00 00 00 
	b.error = 1;
  801a26:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801a2d:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801a30:	ff 75 10             	pushl  0x10(%ebp)
  801a33:	ff 75 0c             	pushl  0xc(%ebp)
  801a36:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801a3c:	50                   	push   %eax
  801a3d:	68 c9 19 80 00       	push   $0x8019c9
  801a42:	e8 76 ea ff ff       	call   8004bd <vprintfmt>
	if (b.idx > 0)
  801a47:	83 c4 10             	add    $0x10,%esp
  801a4a:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801a51:	7f 11                	jg     801a64 <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  801a53:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801a59:	85 c0                	test   %eax,%eax
  801a5b:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801a62:	c9                   	leave  
  801a63:	c3                   	ret    
		writebuf(&b);
  801a64:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801a6a:	e8 1b ff ff ff       	call   80198a <writebuf>
  801a6f:	eb e2                	jmp    801a53 <vfprintf+0x53>

00801a71 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801a71:	55                   	push   %ebp
  801a72:	89 e5                	mov    %esp,%ebp
  801a74:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801a77:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801a7a:	50                   	push   %eax
  801a7b:	ff 75 0c             	pushl  0xc(%ebp)
  801a7e:	ff 75 08             	pushl  0x8(%ebp)
  801a81:	e8 7a ff ff ff       	call   801a00 <vfprintf>
	va_end(ap);

	return cnt;
}
  801a86:	c9                   	leave  
  801a87:	c3                   	ret    

00801a88 <printf>:

int
printf(const char *fmt, ...)
{
  801a88:	55                   	push   %ebp
  801a89:	89 e5                	mov    %esp,%ebp
  801a8b:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801a8e:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801a91:	50                   	push   %eax
  801a92:	ff 75 08             	pushl  0x8(%ebp)
  801a95:	6a 01                	push   $0x1
  801a97:	e8 64 ff ff ff       	call   801a00 <vfprintf>
	va_end(ap);

	return cnt;
}
  801a9c:	c9                   	leave  
  801a9d:	c3                   	ret    

00801a9e <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801a9e:	55                   	push   %ebp
  801a9f:	89 e5                	mov    %esp,%ebp
  801aa1:	56                   	push   %esi
  801aa2:	53                   	push   %ebx
  801aa3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801aa6:	83 ec 0c             	sub    $0xc,%esp
  801aa9:	ff 75 08             	pushl  0x8(%ebp)
  801aac:	e8 29 f7 ff ff       	call   8011da <fd2data>
  801ab1:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801ab3:	83 c4 08             	add    $0x8,%esp
  801ab6:	68 bd 26 80 00       	push   $0x8026bd
  801abb:	53                   	push   %ebx
  801abc:	e8 e5 f0 ff ff       	call   800ba6 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801ac1:	8b 46 04             	mov    0x4(%esi),%eax
  801ac4:	2b 06                	sub    (%esi),%eax
  801ac6:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801acc:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ad3:	00 00 00 
	stat->st_dev = &devpipe;
  801ad6:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801add:	30 80 00 
	return 0;
}
  801ae0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ae5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ae8:	5b                   	pop    %ebx
  801ae9:	5e                   	pop    %esi
  801aea:	5d                   	pop    %ebp
  801aeb:	c3                   	ret    

00801aec <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801aec:	55                   	push   %ebp
  801aed:	89 e5                	mov    %esp,%ebp
  801aef:	53                   	push   %ebx
  801af0:	83 ec 0c             	sub    $0xc,%esp
  801af3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801af6:	53                   	push   %ebx
  801af7:	6a 00                	push   $0x0
  801af9:	e8 1f f5 ff ff       	call   80101d <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801afe:	89 1c 24             	mov    %ebx,(%esp)
  801b01:	e8 d4 f6 ff ff       	call   8011da <fd2data>
  801b06:	83 c4 08             	add    $0x8,%esp
  801b09:	50                   	push   %eax
  801b0a:	6a 00                	push   $0x0
  801b0c:	e8 0c f5 ff ff       	call   80101d <sys_page_unmap>
}
  801b11:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b14:	c9                   	leave  
  801b15:	c3                   	ret    

00801b16 <_pipeisclosed>:
{
  801b16:	55                   	push   %ebp
  801b17:	89 e5                	mov    %esp,%ebp
  801b19:	57                   	push   %edi
  801b1a:	56                   	push   %esi
  801b1b:	53                   	push   %ebx
  801b1c:	83 ec 1c             	sub    $0x1c,%esp
  801b1f:	89 c7                	mov    %eax,%edi
  801b21:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801b23:	a1 04 44 80 00       	mov    0x804404,%eax
  801b28:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801b2b:	83 ec 0c             	sub    $0xc,%esp
  801b2e:	57                   	push   %edi
  801b2f:	e8 ad 03 00 00       	call   801ee1 <pageref>
  801b34:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b37:	89 34 24             	mov    %esi,(%esp)
  801b3a:	e8 a2 03 00 00       	call   801ee1 <pageref>
		nn = thisenv->env_runs;
  801b3f:	8b 15 04 44 80 00    	mov    0x804404,%edx
  801b45:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801b48:	83 c4 10             	add    $0x10,%esp
  801b4b:	39 cb                	cmp    %ecx,%ebx
  801b4d:	74 1b                	je     801b6a <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801b4f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b52:	75 cf                	jne    801b23 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801b54:	8b 42 58             	mov    0x58(%edx),%eax
  801b57:	6a 01                	push   $0x1
  801b59:	50                   	push   %eax
  801b5a:	53                   	push   %ebx
  801b5b:	68 c4 26 80 00       	push   $0x8026c4
  801b60:	e8 2b e8 ff ff       	call   800390 <cprintf>
  801b65:	83 c4 10             	add    $0x10,%esp
  801b68:	eb b9                	jmp    801b23 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801b6a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b6d:	0f 94 c0             	sete   %al
  801b70:	0f b6 c0             	movzbl %al,%eax
}
  801b73:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b76:	5b                   	pop    %ebx
  801b77:	5e                   	pop    %esi
  801b78:	5f                   	pop    %edi
  801b79:	5d                   	pop    %ebp
  801b7a:	c3                   	ret    

00801b7b <devpipe_write>:
{
  801b7b:	55                   	push   %ebp
  801b7c:	89 e5                	mov    %esp,%ebp
  801b7e:	57                   	push   %edi
  801b7f:	56                   	push   %esi
  801b80:	53                   	push   %ebx
  801b81:	83 ec 28             	sub    $0x28,%esp
  801b84:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801b87:	56                   	push   %esi
  801b88:	e8 4d f6 ff ff       	call   8011da <fd2data>
  801b8d:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801b8f:	83 c4 10             	add    $0x10,%esp
  801b92:	bf 00 00 00 00       	mov    $0x0,%edi
  801b97:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801b9a:	74 4f                	je     801beb <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801b9c:	8b 43 04             	mov    0x4(%ebx),%eax
  801b9f:	8b 0b                	mov    (%ebx),%ecx
  801ba1:	8d 51 20             	lea    0x20(%ecx),%edx
  801ba4:	39 d0                	cmp    %edx,%eax
  801ba6:	72 14                	jb     801bbc <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801ba8:	89 da                	mov    %ebx,%edx
  801baa:	89 f0                	mov    %esi,%eax
  801bac:	e8 65 ff ff ff       	call   801b16 <_pipeisclosed>
  801bb1:	85 c0                	test   %eax,%eax
  801bb3:	75 3b                	jne    801bf0 <devpipe_write+0x75>
			sys_yield();
  801bb5:	e8 bf f3 ff ff       	call   800f79 <sys_yield>
  801bba:	eb e0                	jmp    801b9c <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801bbc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bbf:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801bc3:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801bc6:	89 c2                	mov    %eax,%edx
  801bc8:	c1 fa 1f             	sar    $0x1f,%edx
  801bcb:	89 d1                	mov    %edx,%ecx
  801bcd:	c1 e9 1b             	shr    $0x1b,%ecx
  801bd0:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801bd3:	83 e2 1f             	and    $0x1f,%edx
  801bd6:	29 ca                	sub    %ecx,%edx
  801bd8:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801bdc:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801be0:	83 c0 01             	add    $0x1,%eax
  801be3:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801be6:	83 c7 01             	add    $0x1,%edi
  801be9:	eb ac                	jmp    801b97 <devpipe_write+0x1c>
	return i;
  801beb:	8b 45 10             	mov    0x10(%ebp),%eax
  801bee:	eb 05                	jmp    801bf5 <devpipe_write+0x7a>
				return 0;
  801bf0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bf5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bf8:	5b                   	pop    %ebx
  801bf9:	5e                   	pop    %esi
  801bfa:	5f                   	pop    %edi
  801bfb:	5d                   	pop    %ebp
  801bfc:	c3                   	ret    

00801bfd <devpipe_read>:
{
  801bfd:	55                   	push   %ebp
  801bfe:	89 e5                	mov    %esp,%ebp
  801c00:	57                   	push   %edi
  801c01:	56                   	push   %esi
  801c02:	53                   	push   %ebx
  801c03:	83 ec 18             	sub    $0x18,%esp
  801c06:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801c09:	57                   	push   %edi
  801c0a:	e8 cb f5 ff ff       	call   8011da <fd2data>
  801c0f:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c11:	83 c4 10             	add    $0x10,%esp
  801c14:	be 00 00 00 00       	mov    $0x0,%esi
  801c19:	3b 75 10             	cmp    0x10(%ebp),%esi
  801c1c:	75 14                	jne    801c32 <devpipe_read+0x35>
	return i;
  801c1e:	8b 45 10             	mov    0x10(%ebp),%eax
  801c21:	eb 02                	jmp    801c25 <devpipe_read+0x28>
				return i;
  801c23:	89 f0                	mov    %esi,%eax
}
  801c25:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c28:	5b                   	pop    %ebx
  801c29:	5e                   	pop    %esi
  801c2a:	5f                   	pop    %edi
  801c2b:	5d                   	pop    %ebp
  801c2c:	c3                   	ret    
			sys_yield();
  801c2d:	e8 47 f3 ff ff       	call   800f79 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801c32:	8b 03                	mov    (%ebx),%eax
  801c34:	3b 43 04             	cmp    0x4(%ebx),%eax
  801c37:	75 18                	jne    801c51 <devpipe_read+0x54>
			if (i > 0)
  801c39:	85 f6                	test   %esi,%esi
  801c3b:	75 e6                	jne    801c23 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801c3d:	89 da                	mov    %ebx,%edx
  801c3f:	89 f8                	mov    %edi,%eax
  801c41:	e8 d0 fe ff ff       	call   801b16 <_pipeisclosed>
  801c46:	85 c0                	test   %eax,%eax
  801c48:	74 e3                	je     801c2d <devpipe_read+0x30>
				return 0;
  801c4a:	b8 00 00 00 00       	mov    $0x0,%eax
  801c4f:	eb d4                	jmp    801c25 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801c51:	99                   	cltd   
  801c52:	c1 ea 1b             	shr    $0x1b,%edx
  801c55:	01 d0                	add    %edx,%eax
  801c57:	83 e0 1f             	and    $0x1f,%eax
  801c5a:	29 d0                	sub    %edx,%eax
  801c5c:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801c61:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c64:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801c67:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801c6a:	83 c6 01             	add    $0x1,%esi
  801c6d:	eb aa                	jmp    801c19 <devpipe_read+0x1c>

00801c6f <pipe>:
{
  801c6f:	55                   	push   %ebp
  801c70:	89 e5                	mov    %esp,%ebp
  801c72:	56                   	push   %esi
  801c73:	53                   	push   %ebx
  801c74:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801c77:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c7a:	50                   	push   %eax
  801c7b:	e8 71 f5 ff ff       	call   8011f1 <fd_alloc>
  801c80:	89 c3                	mov    %eax,%ebx
  801c82:	83 c4 10             	add    $0x10,%esp
  801c85:	85 c0                	test   %eax,%eax
  801c87:	0f 88 23 01 00 00    	js     801db0 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c8d:	83 ec 04             	sub    $0x4,%esp
  801c90:	68 07 04 00 00       	push   $0x407
  801c95:	ff 75 f4             	pushl  -0xc(%ebp)
  801c98:	6a 00                	push   $0x0
  801c9a:	e8 f9 f2 ff ff       	call   800f98 <sys_page_alloc>
  801c9f:	89 c3                	mov    %eax,%ebx
  801ca1:	83 c4 10             	add    $0x10,%esp
  801ca4:	85 c0                	test   %eax,%eax
  801ca6:	0f 88 04 01 00 00    	js     801db0 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801cac:	83 ec 0c             	sub    $0xc,%esp
  801caf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801cb2:	50                   	push   %eax
  801cb3:	e8 39 f5 ff ff       	call   8011f1 <fd_alloc>
  801cb8:	89 c3                	mov    %eax,%ebx
  801cba:	83 c4 10             	add    $0x10,%esp
  801cbd:	85 c0                	test   %eax,%eax
  801cbf:	0f 88 db 00 00 00    	js     801da0 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cc5:	83 ec 04             	sub    $0x4,%esp
  801cc8:	68 07 04 00 00       	push   $0x407
  801ccd:	ff 75 f0             	pushl  -0x10(%ebp)
  801cd0:	6a 00                	push   $0x0
  801cd2:	e8 c1 f2 ff ff       	call   800f98 <sys_page_alloc>
  801cd7:	89 c3                	mov    %eax,%ebx
  801cd9:	83 c4 10             	add    $0x10,%esp
  801cdc:	85 c0                	test   %eax,%eax
  801cde:	0f 88 bc 00 00 00    	js     801da0 <pipe+0x131>
	va = fd2data(fd0);
  801ce4:	83 ec 0c             	sub    $0xc,%esp
  801ce7:	ff 75 f4             	pushl  -0xc(%ebp)
  801cea:	e8 eb f4 ff ff       	call   8011da <fd2data>
  801cef:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cf1:	83 c4 0c             	add    $0xc,%esp
  801cf4:	68 07 04 00 00       	push   $0x407
  801cf9:	50                   	push   %eax
  801cfa:	6a 00                	push   $0x0
  801cfc:	e8 97 f2 ff ff       	call   800f98 <sys_page_alloc>
  801d01:	89 c3                	mov    %eax,%ebx
  801d03:	83 c4 10             	add    $0x10,%esp
  801d06:	85 c0                	test   %eax,%eax
  801d08:	0f 88 82 00 00 00    	js     801d90 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d0e:	83 ec 0c             	sub    $0xc,%esp
  801d11:	ff 75 f0             	pushl  -0x10(%ebp)
  801d14:	e8 c1 f4 ff ff       	call   8011da <fd2data>
  801d19:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801d20:	50                   	push   %eax
  801d21:	6a 00                	push   $0x0
  801d23:	56                   	push   %esi
  801d24:	6a 00                	push   $0x0
  801d26:	e8 b0 f2 ff ff       	call   800fdb <sys_page_map>
  801d2b:	89 c3                	mov    %eax,%ebx
  801d2d:	83 c4 20             	add    $0x20,%esp
  801d30:	85 c0                	test   %eax,%eax
  801d32:	78 4e                	js     801d82 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801d34:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801d39:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d3c:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801d3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d41:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801d48:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d4b:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801d4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d50:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801d57:	83 ec 0c             	sub    $0xc,%esp
  801d5a:	ff 75 f4             	pushl  -0xc(%ebp)
  801d5d:	e8 68 f4 ff ff       	call   8011ca <fd2num>
  801d62:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d65:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801d67:	83 c4 04             	add    $0x4,%esp
  801d6a:	ff 75 f0             	pushl  -0x10(%ebp)
  801d6d:	e8 58 f4 ff ff       	call   8011ca <fd2num>
  801d72:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d75:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801d78:	83 c4 10             	add    $0x10,%esp
  801d7b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d80:	eb 2e                	jmp    801db0 <pipe+0x141>
	sys_page_unmap(0, va);
  801d82:	83 ec 08             	sub    $0x8,%esp
  801d85:	56                   	push   %esi
  801d86:	6a 00                	push   $0x0
  801d88:	e8 90 f2 ff ff       	call   80101d <sys_page_unmap>
  801d8d:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801d90:	83 ec 08             	sub    $0x8,%esp
  801d93:	ff 75 f0             	pushl  -0x10(%ebp)
  801d96:	6a 00                	push   $0x0
  801d98:	e8 80 f2 ff ff       	call   80101d <sys_page_unmap>
  801d9d:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801da0:	83 ec 08             	sub    $0x8,%esp
  801da3:	ff 75 f4             	pushl  -0xc(%ebp)
  801da6:	6a 00                	push   $0x0
  801da8:	e8 70 f2 ff ff       	call   80101d <sys_page_unmap>
  801dad:	83 c4 10             	add    $0x10,%esp
}
  801db0:	89 d8                	mov    %ebx,%eax
  801db2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801db5:	5b                   	pop    %ebx
  801db6:	5e                   	pop    %esi
  801db7:	5d                   	pop    %ebp
  801db8:	c3                   	ret    

00801db9 <pipeisclosed>:
{
  801db9:	55                   	push   %ebp
  801dba:	89 e5                	mov    %esp,%ebp
  801dbc:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801dbf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dc2:	50                   	push   %eax
  801dc3:	ff 75 08             	pushl  0x8(%ebp)
  801dc6:	e8 78 f4 ff ff       	call   801243 <fd_lookup>
  801dcb:	83 c4 10             	add    $0x10,%esp
  801dce:	85 c0                	test   %eax,%eax
  801dd0:	78 18                	js     801dea <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801dd2:	83 ec 0c             	sub    $0xc,%esp
  801dd5:	ff 75 f4             	pushl  -0xc(%ebp)
  801dd8:	e8 fd f3 ff ff       	call   8011da <fd2data>
	return _pipeisclosed(fd, p);
  801ddd:	89 c2                	mov    %eax,%edx
  801ddf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de2:	e8 2f fd ff ff       	call   801b16 <_pipeisclosed>
  801de7:	83 c4 10             	add    $0x10,%esp
}
  801dea:	c9                   	leave  
  801deb:	c3                   	ret    

00801dec <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801dec:	55                   	push   %ebp
  801ded:	89 e5                	mov    %esp,%ebp
  801def:	56                   	push   %esi
  801df0:	53                   	push   %ebx
  801df1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801df4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801df7:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// return 0;
	if(!pg)
  801dfa:	85 c0                	test   %eax,%eax
		pg = (void*)UTOP;
  801dfc:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801e01:	0f 44 c2             	cmove  %edx,%eax
	
	int ret;

	ret = sys_ipc_recv(pg);
  801e04:	83 ec 0c             	sub    $0xc,%esp
  801e07:	50                   	push   %eax
  801e08:	e8 3b f3 ff ff       	call   801148 <sys_ipc_recv>
	if(ret < 0){
  801e0d:	83 c4 10             	add    $0x10,%esp
  801e10:	85 c0                	test   %eax,%eax
  801e12:	78 2b                	js     801e3f <ipc_recv+0x53>
		if(perm_store) *perm_store = 0;
		if(from_env_store) *from_env_store = 0;
		return ret;
	}
	
	if(perm_store)
  801e14:	85 f6                	test   %esi,%esi
  801e16:	74 0a                	je     801e22 <ipc_recv+0x36>
		*perm_store = thisenv->env_ipc_perm;
  801e18:	a1 04 44 80 00       	mov    0x804404,%eax
  801e1d:	8b 40 78             	mov    0x78(%eax),%eax
  801e20:	89 06                	mov    %eax,(%esi)
	if(from_env_store)
  801e22:	85 db                	test   %ebx,%ebx
  801e24:	74 0a                	je     801e30 <ipc_recv+0x44>
		*from_env_store = thisenv->env_ipc_from;
  801e26:	a1 04 44 80 00       	mov    0x804404,%eax
  801e2b:	8b 40 74             	mov    0x74(%eax),%eax
  801e2e:	89 03                	mov    %eax,(%ebx)

	return thisenv->env_ipc_value;
  801e30:	a1 04 44 80 00       	mov    0x804404,%eax
  801e35:	8b 40 70             	mov    0x70(%eax),%eax
}
  801e38:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e3b:	5b                   	pop    %ebx
  801e3c:	5e                   	pop    %esi
  801e3d:	5d                   	pop    %ebp
  801e3e:	c3                   	ret    
		if(perm_store) *perm_store = 0;
  801e3f:	85 f6                	test   %esi,%esi
  801e41:	74 06                	je     801e49 <ipc_recv+0x5d>
  801e43:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(from_env_store) *from_env_store = 0;
  801e49:	85 db                	test   %ebx,%ebx
  801e4b:	74 eb                	je     801e38 <ipc_recv+0x4c>
  801e4d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801e53:	eb e3                	jmp    801e38 <ipc_recv+0x4c>

00801e55 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801e55:	55                   	push   %ebp
  801e56:	89 e5                	mov    %esp,%ebp
  801e58:	57                   	push   %edi
  801e59:	56                   	push   %esi
  801e5a:	53                   	push   %ebx
  801e5b:	83 ec 0c             	sub    $0xc,%esp
  801e5e:	8b 7d 08             	mov    0x8(%ebp),%edi
  801e61:	8b 75 0c             	mov    0xc(%ebp),%esi
  801e64:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
	if (!pg)
  801e67:	85 db                	test   %ebx,%ebx
		pg = (void*)UTOP;
  801e69:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801e6e:	0f 44 d8             	cmove  %eax,%ebx

	int ret = -E_IPC_NOT_RECV;
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))) {
  801e71:	ff 75 14             	pushl  0x14(%ebp)
  801e74:	53                   	push   %ebx
  801e75:	56                   	push   %esi
  801e76:	57                   	push   %edi
  801e77:	e8 a9 f2 ff ff       	call   801125 <sys_ipc_try_send>
  801e7c:	83 c4 10             	add    $0x10,%esp
  801e7f:	85 c0                	test   %eax,%eax
  801e81:	74 17                	je     801e9a <ipc_send+0x45>
		if(ret != -E_IPC_NOT_RECV){
  801e83:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801e86:	74 e9                	je     801e71 <ipc_send+0x1c>
			panic("ipc_send: ret : %d", ret);
  801e88:	50                   	push   %eax
  801e89:	68 dc 26 80 00       	push   $0x8026dc
  801e8e:	6a 43                	push   $0x43
  801e90:	68 ef 26 80 00       	push   $0x8026ef
  801e95:	e8 1b e4 ff ff       	call   8002b5 <_panic>
			sys_yield();
		}
	}
}
  801e9a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e9d:	5b                   	pop    %ebx
  801e9e:	5e                   	pop    %esi
  801e9f:	5f                   	pop    %edi
  801ea0:	5d                   	pop    %ebp
  801ea1:	c3                   	ret    

00801ea2 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801ea2:	55                   	push   %ebp
  801ea3:	89 e5                	mov    %esp,%ebp
  801ea5:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801ea8:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801ead:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  801eb3:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801eb9:	8b 52 50             	mov    0x50(%edx),%edx
  801ebc:	39 ca                	cmp    %ecx,%edx
  801ebe:	74 11                	je     801ed1 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  801ec0:	83 c0 01             	add    $0x1,%eax
  801ec3:	3d 00 04 00 00       	cmp    $0x400,%eax
  801ec8:	75 e3                	jne    801ead <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801eca:	b8 00 00 00 00       	mov    $0x0,%eax
  801ecf:	eb 0e                	jmp    801edf <ipc_find_env+0x3d>
			return envs[i].env_id;
  801ed1:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  801ed7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801edc:	8b 40 48             	mov    0x48(%eax),%eax
}
  801edf:	5d                   	pop    %ebp
  801ee0:	c3                   	ret    

00801ee1 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801ee1:	55                   	push   %ebp
  801ee2:	89 e5                	mov    %esp,%ebp
  801ee4:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801ee7:	89 d0                	mov    %edx,%eax
  801ee9:	c1 e8 16             	shr    $0x16,%eax
  801eec:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801ef3:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801ef8:	f6 c1 01             	test   $0x1,%cl
  801efb:	74 1d                	je     801f1a <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801efd:	c1 ea 0c             	shr    $0xc,%edx
  801f00:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801f07:	f6 c2 01             	test   $0x1,%dl
  801f0a:	74 0e                	je     801f1a <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801f0c:	c1 ea 0c             	shr    $0xc,%edx
  801f0f:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801f16:	ef 
  801f17:	0f b7 c0             	movzwl %ax,%eax
}
  801f1a:	5d                   	pop    %ebp
  801f1b:	c3                   	ret    
  801f1c:	66 90                	xchg   %ax,%ax
  801f1e:	66 90                	xchg   %ax,%ax

00801f20 <__udivdi3>:
  801f20:	55                   	push   %ebp
  801f21:	57                   	push   %edi
  801f22:	56                   	push   %esi
  801f23:	53                   	push   %ebx
  801f24:	83 ec 1c             	sub    $0x1c,%esp
  801f27:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801f2b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801f2f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801f33:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801f37:	85 d2                	test   %edx,%edx
  801f39:	75 4d                	jne    801f88 <__udivdi3+0x68>
  801f3b:	39 f3                	cmp    %esi,%ebx
  801f3d:	76 19                	jbe    801f58 <__udivdi3+0x38>
  801f3f:	31 ff                	xor    %edi,%edi
  801f41:	89 e8                	mov    %ebp,%eax
  801f43:	89 f2                	mov    %esi,%edx
  801f45:	f7 f3                	div    %ebx
  801f47:	89 fa                	mov    %edi,%edx
  801f49:	83 c4 1c             	add    $0x1c,%esp
  801f4c:	5b                   	pop    %ebx
  801f4d:	5e                   	pop    %esi
  801f4e:	5f                   	pop    %edi
  801f4f:	5d                   	pop    %ebp
  801f50:	c3                   	ret    
  801f51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801f58:	89 d9                	mov    %ebx,%ecx
  801f5a:	85 db                	test   %ebx,%ebx
  801f5c:	75 0b                	jne    801f69 <__udivdi3+0x49>
  801f5e:	b8 01 00 00 00       	mov    $0x1,%eax
  801f63:	31 d2                	xor    %edx,%edx
  801f65:	f7 f3                	div    %ebx
  801f67:	89 c1                	mov    %eax,%ecx
  801f69:	31 d2                	xor    %edx,%edx
  801f6b:	89 f0                	mov    %esi,%eax
  801f6d:	f7 f1                	div    %ecx
  801f6f:	89 c6                	mov    %eax,%esi
  801f71:	89 e8                	mov    %ebp,%eax
  801f73:	89 f7                	mov    %esi,%edi
  801f75:	f7 f1                	div    %ecx
  801f77:	89 fa                	mov    %edi,%edx
  801f79:	83 c4 1c             	add    $0x1c,%esp
  801f7c:	5b                   	pop    %ebx
  801f7d:	5e                   	pop    %esi
  801f7e:	5f                   	pop    %edi
  801f7f:	5d                   	pop    %ebp
  801f80:	c3                   	ret    
  801f81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801f88:	39 f2                	cmp    %esi,%edx
  801f8a:	77 1c                	ja     801fa8 <__udivdi3+0x88>
  801f8c:	0f bd fa             	bsr    %edx,%edi
  801f8f:	83 f7 1f             	xor    $0x1f,%edi
  801f92:	75 2c                	jne    801fc0 <__udivdi3+0xa0>
  801f94:	39 f2                	cmp    %esi,%edx
  801f96:	72 06                	jb     801f9e <__udivdi3+0x7e>
  801f98:	31 c0                	xor    %eax,%eax
  801f9a:	39 eb                	cmp    %ebp,%ebx
  801f9c:	77 a9                	ja     801f47 <__udivdi3+0x27>
  801f9e:	b8 01 00 00 00       	mov    $0x1,%eax
  801fa3:	eb a2                	jmp    801f47 <__udivdi3+0x27>
  801fa5:	8d 76 00             	lea    0x0(%esi),%esi
  801fa8:	31 ff                	xor    %edi,%edi
  801faa:	31 c0                	xor    %eax,%eax
  801fac:	89 fa                	mov    %edi,%edx
  801fae:	83 c4 1c             	add    $0x1c,%esp
  801fb1:	5b                   	pop    %ebx
  801fb2:	5e                   	pop    %esi
  801fb3:	5f                   	pop    %edi
  801fb4:	5d                   	pop    %ebp
  801fb5:	c3                   	ret    
  801fb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801fbd:	8d 76 00             	lea    0x0(%esi),%esi
  801fc0:	89 f9                	mov    %edi,%ecx
  801fc2:	b8 20 00 00 00       	mov    $0x20,%eax
  801fc7:	29 f8                	sub    %edi,%eax
  801fc9:	d3 e2                	shl    %cl,%edx
  801fcb:	89 54 24 08          	mov    %edx,0x8(%esp)
  801fcf:	89 c1                	mov    %eax,%ecx
  801fd1:	89 da                	mov    %ebx,%edx
  801fd3:	d3 ea                	shr    %cl,%edx
  801fd5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801fd9:	09 d1                	or     %edx,%ecx
  801fdb:	89 f2                	mov    %esi,%edx
  801fdd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801fe1:	89 f9                	mov    %edi,%ecx
  801fe3:	d3 e3                	shl    %cl,%ebx
  801fe5:	89 c1                	mov    %eax,%ecx
  801fe7:	d3 ea                	shr    %cl,%edx
  801fe9:	89 f9                	mov    %edi,%ecx
  801feb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801fef:	89 eb                	mov    %ebp,%ebx
  801ff1:	d3 e6                	shl    %cl,%esi
  801ff3:	89 c1                	mov    %eax,%ecx
  801ff5:	d3 eb                	shr    %cl,%ebx
  801ff7:	09 de                	or     %ebx,%esi
  801ff9:	89 f0                	mov    %esi,%eax
  801ffb:	f7 74 24 08          	divl   0x8(%esp)
  801fff:	89 d6                	mov    %edx,%esi
  802001:	89 c3                	mov    %eax,%ebx
  802003:	f7 64 24 0c          	mull   0xc(%esp)
  802007:	39 d6                	cmp    %edx,%esi
  802009:	72 15                	jb     802020 <__udivdi3+0x100>
  80200b:	89 f9                	mov    %edi,%ecx
  80200d:	d3 e5                	shl    %cl,%ebp
  80200f:	39 c5                	cmp    %eax,%ebp
  802011:	73 04                	jae    802017 <__udivdi3+0xf7>
  802013:	39 d6                	cmp    %edx,%esi
  802015:	74 09                	je     802020 <__udivdi3+0x100>
  802017:	89 d8                	mov    %ebx,%eax
  802019:	31 ff                	xor    %edi,%edi
  80201b:	e9 27 ff ff ff       	jmp    801f47 <__udivdi3+0x27>
  802020:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802023:	31 ff                	xor    %edi,%edi
  802025:	e9 1d ff ff ff       	jmp    801f47 <__udivdi3+0x27>
  80202a:	66 90                	xchg   %ax,%ax
  80202c:	66 90                	xchg   %ax,%ax
  80202e:	66 90                	xchg   %ax,%ax

00802030 <__umoddi3>:
  802030:	55                   	push   %ebp
  802031:	57                   	push   %edi
  802032:	56                   	push   %esi
  802033:	53                   	push   %ebx
  802034:	83 ec 1c             	sub    $0x1c,%esp
  802037:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80203b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80203f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802043:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802047:	89 da                	mov    %ebx,%edx
  802049:	85 c0                	test   %eax,%eax
  80204b:	75 43                	jne    802090 <__umoddi3+0x60>
  80204d:	39 df                	cmp    %ebx,%edi
  80204f:	76 17                	jbe    802068 <__umoddi3+0x38>
  802051:	89 f0                	mov    %esi,%eax
  802053:	f7 f7                	div    %edi
  802055:	89 d0                	mov    %edx,%eax
  802057:	31 d2                	xor    %edx,%edx
  802059:	83 c4 1c             	add    $0x1c,%esp
  80205c:	5b                   	pop    %ebx
  80205d:	5e                   	pop    %esi
  80205e:	5f                   	pop    %edi
  80205f:	5d                   	pop    %ebp
  802060:	c3                   	ret    
  802061:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802068:	89 fd                	mov    %edi,%ebp
  80206a:	85 ff                	test   %edi,%edi
  80206c:	75 0b                	jne    802079 <__umoddi3+0x49>
  80206e:	b8 01 00 00 00       	mov    $0x1,%eax
  802073:	31 d2                	xor    %edx,%edx
  802075:	f7 f7                	div    %edi
  802077:	89 c5                	mov    %eax,%ebp
  802079:	89 d8                	mov    %ebx,%eax
  80207b:	31 d2                	xor    %edx,%edx
  80207d:	f7 f5                	div    %ebp
  80207f:	89 f0                	mov    %esi,%eax
  802081:	f7 f5                	div    %ebp
  802083:	89 d0                	mov    %edx,%eax
  802085:	eb d0                	jmp    802057 <__umoddi3+0x27>
  802087:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80208e:	66 90                	xchg   %ax,%ax
  802090:	89 f1                	mov    %esi,%ecx
  802092:	39 d8                	cmp    %ebx,%eax
  802094:	76 0a                	jbe    8020a0 <__umoddi3+0x70>
  802096:	89 f0                	mov    %esi,%eax
  802098:	83 c4 1c             	add    $0x1c,%esp
  80209b:	5b                   	pop    %ebx
  80209c:	5e                   	pop    %esi
  80209d:	5f                   	pop    %edi
  80209e:	5d                   	pop    %ebp
  80209f:	c3                   	ret    
  8020a0:	0f bd e8             	bsr    %eax,%ebp
  8020a3:	83 f5 1f             	xor    $0x1f,%ebp
  8020a6:	75 20                	jne    8020c8 <__umoddi3+0x98>
  8020a8:	39 d8                	cmp    %ebx,%eax
  8020aa:	0f 82 b0 00 00 00    	jb     802160 <__umoddi3+0x130>
  8020b0:	39 f7                	cmp    %esi,%edi
  8020b2:	0f 86 a8 00 00 00    	jbe    802160 <__umoddi3+0x130>
  8020b8:	89 c8                	mov    %ecx,%eax
  8020ba:	83 c4 1c             	add    $0x1c,%esp
  8020bd:	5b                   	pop    %ebx
  8020be:	5e                   	pop    %esi
  8020bf:	5f                   	pop    %edi
  8020c0:	5d                   	pop    %ebp
  8020c1:	c3                   	ret    
  8020c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8020c8:	89 e9                	mov    %ebp,%ecx
  8020ca:	ba 20 00 00 00       	mov    $0x20,%edx
  8020cf:	29 ea                	sub    %ebp,%edx
  8020d1:	d3 e0                	shl    %cl,%eax
  8020d3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020d7:	89 d1                	mov    %edx,%ecx
  8020d9:	89 f8                	mov    %edi,%eax
  8020db:	d3 e8                	shr    %cl,%eax
  8020dd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8020e1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8020e5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8020e9:	09 c1                	or     %eax,%ecx
  8020eb:	89 d8                	mov    %ebx,%eax
  8020ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8020f1:	89 e9                	mov    %ebp,%ecx
  8020f3:	d3 e7                	shl    %cl,%edi
  8020f5:	89 d1                	mov    %edx,%ecx
  8020f7:	d3 e8                	shr    %cl,%eax
  8020f9:	89 e9                	mov    %ebp,%ecx
  8020fb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8020ff:	d3 e3                	shl    %cl,%ebx
  802101:	89 c7                	mov    %eax,%edi
  802103:	89 d1                	mov    %edx,%ecx
  802105:	89 f0                	mov    %esi,%eax
  802107:	d3 e8                	shr    %cl,%eax
  802109:	89 e9                	mov    %ebp,%ecx
  80210b:	89 fa                	mov    %edi,%edx
  80210d:	d3 e6                	shl    %cl,%esi
  80210f:	09 d8                	or     %ebx,%eax
  802111:	f7 74 24 08          	divl   0x8(%esp)
  802115:	89 d1                	mov    %edx,%ecx
  802117:	89 f3                	mov    %esi,%ebx
  802119:	f7 64 24 0c          	mull   0xc(%esp)
  80211d:	89 c6                	mov    %eax,%esi
  80211f:	89 d7                	mov    %edx,%edi
  802121:	39 d1                	cmp    %edx,%ecx
  802123:	72 06                	jb     80212b <__umoddi3+0xfb>
  802125:	75 10                	jne    802137 <__umoddi3+0x107>
  802127:	39 c3                	cmp    %eax,%ebx
  802129:	73 0c                	jae    802137 <__umoddi3+0x107>
  80212b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80212f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802133:	89 d7                	mov    %edx,%edi
  802135:	89 c6                	mov    %eax,%esi
  802137:	89 ca                	mov    %ecx,%edx
  802139:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80213e:	29 f3                	sub    %esi,%ebx
  802140:	19 fa                	sbb    %edi,%edx
  802142:	89 d0                	mov    %edx,%eax
  802144:	d3 e0                	shl    %cl,%eax
  802146:	89 e9                	mov    %ebp,%ecx
  802148:	d3 eb                	shr    %cl,%ebx
  80214a:	d3 ea                	shr    %cl,%edx
  80214c:	09 d8                	or     %ebx,%eax
  80214e:	83 c4 1c             	add    $0x1c,%esp
  802151:	5b                   	pop    %ebx
  802152:	5e                   	pop    %esi
  802153:	5f                   	pop    %edi
  802154:	5d                   	pop    %ebp
  802155:	c3                   	ret    
  802156:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80215d:	8d 76 00             	lea    0x0(%esi),%esi
  802160:	89 da                	mov    %ebx,%edx
  802162:	29 fe                	sub    %edi,%esi
  802164:	19 c2                	sbb    %eax,%edx
  802166:	89 f1                	mov    %esi,%ecx
  802168:	89 c8                	mov    %ecx,%eax
  80216a:	e9 4b ff ff ff       	jmp    8020ba <__umoddi3+0x8a>
