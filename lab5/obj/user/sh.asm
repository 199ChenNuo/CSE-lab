
obj/user/sh.debug:     file format elf32-i386


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
  80002c:	e8 9d 09 00 00       	call   8009ce <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <_gettoken>:
#define WHITESPACE " \t\r\n"
#define SYMBOLS "<|>&;()"

int
_gettoken(char *s, char **p1, char **p2)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 0c             	sub    $0xc,%esp
  80003c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80003f:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int t;

	if (s == 0) {
  800042:	85 db                	test   %ebx,%ebx
  800044:	74 39                	je     80007f <_gettoken+0x4c>
		if (debug > 1)
			cprintf("GETTOKEN NULL\n");
		return 0;
	}

	if (debug > 1)
  800046:	83 3d 00 50 80 00 01 	cmpl   $0x1,0x805000
  80004d:	7f 50                	jg     80009f <_gettoken+0x6c>
		cprintf("GETTOKEN: %s\n", s);

	*p1 = 0;
  80004f:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
	*p2 = 0;
  800055:	8b 45 10             	mov    0x10(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	while (strchr(WHITESPACE, *s))
  80005e:	83 ec 08             	sub    $0x8,%esp
  800061:	0f be 03             	movsbl (%ebx),%eax
  800064:	50                   	push   %eax
  800065:	68 bd 34 80 00       	push   $0x8034bd
  80006a:	e8 b4 13 00 00       	call   801423 <strchr>
  80006f:	83 c4 10             	add    $0x10,%esp
  800072:	85 c0                	test   %eax,%eax
  800074:	74 3c                	je     8000b2 <_gettoken+0x7f>
		*s++ = 0;
  800076:	83 c3 01             	add    $0x1,%ebx
  800079:	c6 43 ff 00          	movb   $0x0,-0x1(%ebx)
  80007d:	eb df                	jmp    80005e <_gettoken+0x2b>
		return 0;
  80007f:	be 00 00 00 00       	mov    $0x0,%esi
		if (debug > 1)
  800084:	83 3d 00 50 80 00 01 	cmpl   $0x1,0x805000
  80008b:	7e 3a                	jle    8000c7 <_gettoken+0x94>
			cprintf("GETTOKEN NULL\n");
  80008d:	83 ec 0c             	sub    $0xc,%esp
  800090:	68 a0 34 80 00       	push   $0x8034a0
  800095:	e8 6a 0a 00 00       	call   800b04 <cprintf>
  80009a:	83 c4 10             	add    $0x10,%esp
  80009d:	eb 28                	jmp    8000c7 <_gettoken+0x94>
		cprintf("GETTOKEN: %s\n", s);
  80009f:	83 ec 08             	sub    $0x8,%esp
  8000a2:	53                   	push   %ebx
  8000a3:	68 af 34 80 00       	push   $0x8034af
  8000a8:	e8 57 0a 00 00       	call   800b04 <cprintf>
  8000ad:	83 c4 10             	add    $0x10,%esp
  8000b0:	eb 9d                	jmp    80004f <_gettoken+0x1c>
	if (*s == 0) {
  8000b2:	0f b6 03             	movzbl (%ebx),%eax
  8000b5:	84 c0                	test   %al,%al
  8000b7:	75 2a                	jne    8000e3 <_gettoken+0xb0>
		if (debug > 1)
			cprintf("EOL\n");
		return 0;
  8000b9:	be 00 00 00 00       	mov    $0x0,%esi
		if (debug > 1)
  8000be:	83 3d 00 50 80 00 01 	cmpl   $0x1,0x805000
  8000c5:	7f 0a                	jg     8000d1 <_gettoken+0x9e>
		**p2 = 0;
		cprintf("WORD: %s\n", *p1);
		**p2 = t;
	}
	return 'w';
}
  8000c7:	89 f0                	mov    %esi,%eax
  8000c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000cc:	5b                   	pop    %ebx
  8000cd:	5e                   	pop    %esi
  8000ce:	5f                   	pop    %edi
  8000cf:	5d                   	pop    %ebp
  8000d0:	c3                   	ret    
			cprintf("EOL\n");
  8000d1:	83 ec 0c             	sub    $0xc,%esp
  8000d4:	68 c2 34 80 00       	push   $0x8034c2
  8000d9:	e8 26 0a 00 00       	call   800b04 <cprintf>
  8000de:	83 c4 10             	add    $0x10,%esp
  8000e1:	eb e4                	jmp    8000c7 <_gettoken+0x94>
	if (strchr(SYMBOLS, *s)) {
  8000e3:	83 ec 08             	sub    $0x8,%esp
  8000e6:	0f be c0             	movsbl %al,%eax
  8000e9:	50                   	push   %eax
  8000ea:	68 d3 34 80 00       	push   $0x8034d3
  8000ef:	e8 2f 13 00 00       	call   801423 <strchr>
  8000f4:	83 c4 10             	add    $0x10,%esp
  8000f7:	85 c0                	test   %eax,%eax
  8000f9:	74 2c                	je     800127 <_gettoken+0xf4>
		t = *s;
  8000fb:	0f be 33             	movsbl (%ebx),%esi
		*p1 = s;
  8000fe:	89 1f                	mov    %ebx,(%edi)
		*s++ = 0;
  800100:	c6 03 00             	movb   $0x0,(%ebx)
  800103:	83 c3 01             	add    $0x1,%ebx
  800106:	8b 45 10             	mov    0x10(%ebp),%eax
  800109:	89 18                	mov    %ebx,(%eax)
		if (debug > 1)
  80010b:	83 3d 00 50 80 00 01 	cmpl   $0x1,0x805000
  800112:	7e b3                	jle    8000c7 <_gettoken+0x94>
			cprintf("TOK %c\n", t);
  800114:	83 ec 08             	sub    $0x8,%esp
  800117:	56                   	push   %esi
  800118:	68 c7 34 80 00       	push   $0x8034c7
  80011d:	e8 e2 09 00 00       	call   800b04 <cprintf>
  800122:	83 c4 10             	add    $0x10,%esp
  800125:	eb a0                	jmp    8000c7 <_gettoken+0x94>
	*p1 = s;
  800127:	89 1f                	mov    %ebx,(%edi)
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  800129:	eb 03                	jmp    80012e <_gettoken+0xfb>
		s++;
  80012b:	83 c3 01             	add    $0x1,%ebx
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  80012e:	0f b6 03             	movzbl (%ebx),%eax
  800131:	84 c0                	test   %al,%al
  800133:	74 18                	je     80014d <_gettoken+0x11a>
  800135:	83 ec 08             	sub    $0x8,%esp
  800138:	0f be c0             	movsbl %al,%eax
  80013b:	50                   	push   %eax
  80013c:	68 cf 34 80 00       	push   $0x8034cf
  800141:	e8 dd 12 00 00       	call   801423 <strchr>
  800146:	83 c4 10             	add    $0x10,%esp
  800149:	85 c0                	test   %eax,%eax
  80014b:	74 de                	je     80012b <_gettoken+0xf8>
	*p2 = s;
  80014d:	8b 45 10             	mov    0x10(%ebp),%eax
  800150:	89 18                	mov    %ebx,(%eax)
	return 'w';
  800152:	be 77 00 00 00       	mov    $0x77,%esi
	if (debug > 1) {
  800157:	83 3d 00 50 80 00 01 	cmpl   $0x1,0x805000
  80015e:	0f 8e 63 ff ff ff    	jle    8000c7 <_gettoken+0x94>
		t = **p2;
  800164:	0f b6 33             	movzbl (%ebx),%esi
		**p2 = 0;
  800167:	c6 03 00             	movb   $0x0,(%ebx)
		cprintf("WORD: %s\n", *p1);
  80016a:	83 ec 08             	sub    $0x8,%esp
  80016d:	ff 37                	pushl  (%edi)
  80016f:	68 db 34 80 00       	push   $0x8034db
  800174:	e8 8b 09 00 00       	call   800b04 <cprintf>
		**p2 = t;
  800179:	8b 45 10             	mov    0x10(%ebp),%eax
  80017c:	8b 00                	mov    (%eax),%eax
  80017e:	89 f2                	mov    %esi,%edx
  800180:	88 10                	mov    %dl,(%eax)
  800182:	83 c4 10             	add    $0x10,%esp
	return 'w';
  800185:	be 77 00 00 00       	mov    $0x77,%esi
  80018a:	e9 38 ff ff ff       	jmp    8000c7 <_gettoken+0x94>

0080018f <gettoken>:

int
gettoken(char *s, char **p1)
{
  80018f:	55                   	push   %ebp
  800190:	89 e5                	mov    %esp,%ebp
  800192:	83 ec 08             	sub    $0x8,%esp
  800195:	8b 45 08             	mov    0x8(%ebp),%eax
	static int c, nc;
	static char* np1, *np2;

	if (s) {
  800198:	85 c0                	test   %eax,%eax
  80019a:	74 22                	je     8001be <gettoken+0x2f>
		nc = _gettoken(s, &np1, &np2);
  80019c:	83 ec 04             	sub    $0x4,%esp
  80019f:	68 0c 50 80 00       	push   $0x80500c
  8001a4:	68 10 50 80 00       	push   $0x805010
  8001a9:	50                   	push   %eax
  8001aa:	e8 84 fe ff ff       	call   800033 <_gettoken>
  8001af:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  8001b4:	83 c4 10             	add    $0x10,%esp
  8001b7:	b8 00 00 00 00       	mov    $0x0,%eax
	}
	c = nc;
	*p1 = np1;
	nc = _gettoken(np2, &np1, &np2);
	return c;
}
  8001bc:	c9                   	leave  
  8001bd:	c3                   	ret    
	c = nc;
  8001be:	a1 08 50 80 00       	mov    0x805008,%eax
  8001c3:	a3 04 50 80 00       	mov    %eax,0x805004
	*p1 = np1;
  8001c8:	8b 15 10 50 80 00    	mov    0x805010,%edx
  8001ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d1:	89 10                	mov    %edx,(%eax)
	nc = _gettoken(np2, &np1, &np2);
  8001d3:	83 ec 04             	sub    $0x4,%esp
  8001d6:	68 0c 50 80 00       	push   $0x80500c
  8001db:	68 10 50 80 00       	push   $0x805010
  8001e0:	ff 35 0c 50 80 00    	pushl  0x80500c
  8001e6:	e8 48 fe ff ff       	call   800033 <_gettoken>
  8001eb:	a3 08 50 80 00       	mov    %eax,0x805008
	return c;
  8001f0:	a1 04 50 80 00       	mov    0x805004,%eax
  8001f5:	83 c4 10             	add    $0x10,%esp
  8001f8:	eb c2                	jmp    8001bc <gettoken+0x2d>

008001fa <runcmd>:
{
  8001fa:	55                   	push   %ebp
  8001fb:	89 e5                	mov    %esp,%ebp
  8001fd:	57                   	push   %edi
  8001fe:	56                   	push   %esi
  8001ff:	53                   	push   %ebx
  800200:	81 ec 64 04 00 00    	sub    $0x464,%esp
	gettoken(s, 0);
  800206:	6a 00                	push   $0x0
  800208:	ff 75 08             	pushl  0x8(%ebp)
  80020b:	e8 7f ff ff ff       	call   80018f <gettoken>
  800210:	83 c4 10             	add    $0x10,%esp
		switch ((c = gettoken(0, &t))) {
  800213:	8d 7d a4             	lea    -0x5c(%ebp),%edi
	argc = 0;
  800216:	be 00 00 00 00       	mov    $0x0,%esi
		switch ((c = gettoken(0, &t))) {
  80021b:	83 ec 08             	sub    $0x8,%esp
  80021e:	57                   	push   %edi
  80021f:	6a 00                	push   $0x0
  800221:	e8 69 ff ff ff       	call   80018f <gettoken>
  800226:	89 c3                	mov    %eax,%ebx
  800228:	83 c4 10             	add    $0x10,%esp
  80022b:	83 f8 3e             	cmp    $0x3e,%eax
  80022e:	0f 84 8b 01 00 00    	je     8003bf <runcmd+0x1c5>
  800234:	7e 72                	jle    8002a8 <runcmd+0xae>
  800236:	83 f8 77             	cmp    $0x77,%eax
  800239:	0f 84 3e 01 00 00    	je     80037d <runcmd+0x183>
  80023f:	83 f8 7c             	cmp    $0x7c,%eax
  800242:	0f 85 ab 02 00 00    	jne    8004f3 <runcmd+0x2f9>
			if ((r = pipe(p)) < 0) {
  800248:	83 ec 0c             	sub    $0xc,%esp
  80024b:	8d 85 9c fb ff ff    	lea    -0x464(%ebp),%eax
  800251:	50                   	push   %eax
  800252:	e8 5c 2c 00 00       	call   802eb3 <pipe>
  800257:	83 c4 10             	add    $0x10,%esp
  80025a:	85 c0                	test   %eax,%eax
  80025c:	0f 88 df 01 00 00    	js     800441 <runcmd+0x247>
			if (debug)
  800262:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  800269:	0f 85 ed 01 00 00    	jne    80045c <runcmd+0x262>
			if ((r = fork()) < 0) {
  80026f:	e8 c6 17 00 00       	call   801a3a <fork>
  800274:	89 c3                	mov    %eax,%ebx
  800276:	85 c0                	test   %eax,%eax
  800278:	0f 88 ff 01 00 00    	js     80047d <runcmd+0x283>
			if (r == 0) {
  80027e:	0f 85 0f 02 00 00    	jne    800493 <runcmd+0x299>
				if (p[0] != 0) {
  800284:	8b 85 9c fb ff ff    	mov    -0x464(%ebp),%eax
  80028a:	85 c0                	test   %eax,%eax
  80028c:	0f 85 22 02 00 00    	jne    8004b4 <runcmd+0x2ba>
				close(p[1]);
  800292:	83 ec 0c             	sub    $0xc,%esp
  800295:	ff b5 a0 fb ff ff    	pushl  -0x460(%ebp)
  80029b:	e8 b4 1d 00 00       	call   802054 <close>
				goto again;
  8002a0:	83 c4 10             	add    $0x10,%esp
  8002a3:	e9 6e ff ff ff       	jmp    800216 <runcmd+0x1c>
  8002a8:	85 c0                	test   %eax,%eax
  8002aa:	0f 85 9a 00 00 00    	jne    80034a <runcmd+0x150>
	if(argc == 0) {
  8002b0:	85 f6                	test   %esi,%esi
  8002b2:	0f 84 4d 02 00 00    	je     800505 <runcmd+0x30b>
	if (argv[0][0] != '/') {
  8002b8:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8002bb:	80 38 2f             	cmpb   $0x2f,(%eax)
  8002be:	0f 85 63 02 00 00    	jne    800527 <runcmd+0x32d>
	argv[argc] = 0;
  8002c4:	c7 44 b5 a8 00 00 00 	movl   $0x0,-0x58(%ebp,%esi,4)
  8002cb:	00 
	if (debug) {
  8002cc:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  8002d3:	0f 85 76 02 00 00    	jne    80054f <runcmd+0x355>
	if ((r = spawn(argv[0], (const char**) argv)) < 0)
  8002d9:	83 ec 08             	sub    $0x8,%esp
  8002dc:	8d 45 a8             	lea    -0x58(%ebp),%eax
  8002df:	50                   	push   %eax
  8002e0:	ff 75 a8             	pushl  -0x58(%ebp)
  8002e3:	e8 9a 24 00 00       	call   802782 <spawn>
  8002e8:	89 c6                	mov    %eax,%esi
  8002ea:	83 c4 10             	add    $0x10,%esp
  8002ed:	85 c0                	test   %eax,%eax
  8002ef:	0f 88 a8 02 00 00    	js     80059d <runcmd+0x3a3>
	close_all();
  8002f5:	e8 87 1d 00 00       	call   802081 <close_all>
		if (debug)
  8002fa:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  800301:	0f 85 e3 02 00 00    	jne    8005ea <runcmd+0x3f0>
		wait(r);
  800307:	83 ec 0c             	sub    $0xc,%esp
  80030a:	56                   	push   %esi
  80030b:	e8 20 2d 00 00       	call   803030 <wait>
		if (debug)
  800310:	83 c4 10             	add    $0x10,%esp
  800313:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  80031a:	0f 85 e9 02 00 00    	jne    800609 <runcmd+0x40f>
	if (pipe_child) {
  800320:	85 db                	test   %ebx,%ebx
  800322:	74 19                	je     80033d <runcmd+0x143>
		wait(pipe_child);
  800324:	83 ec 0c             	sub    $0xc,%esp
  800327:	53                   	push   %ebx
  800328:	e8 03 2d 00 00       	call   803030 <wait>
		if (debug)
  80032d:	83 c4 10             	add    $0x10,%esp
  800330:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  800337:	0f 85 e7 02 00 00    	jne    800624 <runcmd+0x42a>
	exit();
  80033d:	e8 d5 06 00 00       	call   800a17 <exit>
}
  800342:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800345:	5b                   	pop    %ebx
  800346:	5e                   	pop    %esi
  800347:	5f                   	pop    %edi
  800348:	5d                   	pop    %ebp
  800349:	c3                   	ret    
  80034a:	83 f8 3c             	cmp    $0x3c,%eax
  80034d:	0f 85 a0 01 00 00    	jne    8004f3 <runcmd+0x2f9>
			if (gettoken(0, &t) != 'w') {
  800353:	83 ec 08             	sub    $0x8,%esp
  800356:	8d 45 a4             	lea    -0x5c(%ebp),%eax
  800359:	50                   	push   %eax
  80035a:	6a 00                	push   $0x0
  80035c:	e8 2e fe ff ff       	call   80018f <gettoken>
  800361:	83 c4 10             	add    $0x10,%esp
  800364:	83 f8 77             	cmp    $0x77,%eax
  800367:	75 3f                	jne    8003a8 <runcmd+0x1ae>
			panic("< redirection not implemented");
  800369:	83 ec 04             	sub    $0x4,%esp
  80036c:	68 f9 34 80 00       	push   $0x8034f9
  800371:	6a 3a                	push   $0x3a
  800373:	68 17 35 80 00       	push   $0x803517
  800378:	e8 ac 06 00 00       	call   800a29 <_panic>
			if (argc == MAXARGS) {
  80037d:	83 fe 10             	cmp    $0x10,%esi
  800380:	74 0f                	je     800391 <runcmd+0x197>
			argv[argc++] = t;
  800382:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800385:	89 44 b5 a8          	mov    %eax,-0x58(%ebp,%esi,4)
  800389:	8d 76 01             	lea    0x1(%esi),%esi
			break;
  80038c:	e9 8a fe ff ff       	jmp    80021b <runcmd+0x21>
				cprintf("too many arguments\n");
  800391:	83 ec 0c             	sub    $0xc,%esp
  800394:	68 e5 34 80 00       	push   $0x8034e5
  800399:	e8 66 07 00 00       	call   800b04 <cprintf>
				exit();
  80039e:	e8 74 06 00 00       	call   800a17 <exit>
  8003a3:	83 c4 10             	add    $0x10,%esp
  8003a6:	eb da                	jmp    800382 <runcmd+0x188>
				cprintf("syntax error: < not followed by word\n");
  8003a8:	83 ec 0c             	sub    $0xc,%esp
  8003ab:	68 40 36 80 00       	push   $0x803640
  8003b0:	e8 4f 07 00 00       	call   800b04 <cprintf>
				exit();
  8003b5:	e8 5d 06 00 00       	call   800a17 <exit>
  8003ba:	83 c4 10             	add    $0x10,%esp
  8003bd:	eb aa                	jmp    800369 <runcmd+0x16f>
			if (gettoken(0, &t) != 'w') {
  8003bf:	83 ec 08             	sub    $0x8,%esp
  8003c2:	57                   	push   %edi
  8003c3:	6a 00                	push   $0x0
  8003c5:	e8 c5 fd ff ff       	call   80018f <gettoken>
  8003ca:	83 c4 10             	add    $0x10,%esp
  8003cd:	83 f8 77             	cmp    $0x77,%eax
  8003d0:	75 24                	jne    8003f6 <runcmd+0x1fc>
			if ((fd = open(t, O_WRONLY|O_CREAT|O_TRUNC)) < 0) {
  8003d2:	83 ec 08             	sub    $0x8,%esp
  8003d5:	68 01 03 00 00       	push   $0x301
  8003da:	ff 75 a4             	pushl  -0x5c(%ebp)
  8003dd:	e8 e7 21 00 00       	call   8025c9 <open>
  8003e2:	89 c3                	mov    %eax,%ebx
  8003e4:	83 c4 10             	add    $0x10,%esp
  8003e7:	85 c0                	test   %eax,%eax
  8003e9:	78 22                	js     80040d <runcmd+0x213>
			if (fd != 1) {
  8003eb:	83 f8 01             	cmp    $0x1,%eax
  8003ee:	0f 84 27 fe ff ff    	je     80021b <runcmd+0x21>
  8003f4:	eb 30                	jmp    800426 <runcmd+0x22c>
				cprintf("syntax error: > not followed by word\n");
  8003f6:	83 ec 0c             	sub    $0xc,%esp
  8003f9:	68 68 36 80 00       	push   $0x803668
  8003fe:	e8 01 07 00 00       	call   800b04 <cprintf>
				exit();
  800403:	e8 0f 06 00 00       	call   800a17 <exit>
  800408:	83 c4 10             	add    $0x10,%esp
  80040b:	eb c5                	jmp    8003d2 <runcmd+0x1d8>
				cprintf("open %s for write: %e", t, fd);
  80040d:	83 ec 04             	sub    $0x4,%esp
  800410:	50                   	push   %eax
  800411:	ff 75 a4             	pushl  -0x5c(%ebp)
  800414:	68 21 35 80 00       	push   $0x803521
  800419:	e8 e6 06 00 00       	call   800b04 <cprintf>
				exit();
  80041e:	e8 f4 05 00 00       	call   800a17 <exit>
  800423:	83 c4 10             	add    $0x10,%esp
				dup(fd, 1);
  800426:	83 ec 08             	sub    $0x8,%esp
  800429:	6a 01                	push   $0x1
  80042b:	53                   	push   %ebx
  80042c:	e8 75 1c 00 00       	call   8020a6 <dup>
				close(fd);
  800431:	89 1c 24             	mov    %ebx,(%esp)
  800434:	e8 1b 1c 00 00       	call   802054 <close>
  800439:	83 c4 10             	add    $0x10,%esp
  80043c:	e9 da fd ff ff       	jmp    80021b <runcmd+0x21>
				cprintf("pipe: %e", r);
  800441:	83 ec 08             	sub    $0x8,%esp
  800444:	50                   	push   %eax
  800445:	68 37 35 80 00       	push   $0x803537
  80044a:	e8 b5 06 00 00       	call   800b04 <cprintf>
				exit();
  80044f:	e8 c3 05 00 00       	call   800a17 <exit>
  800454:	83 c4 10             	add    $0x10,%esp
  800457:	e9 06 fe ff ff       	jmp    800262 <runcmd+0x68>
				cprintf("PIPE: %d %d\n", p[0], p[1]);
  80045c:	83 ec 04             	sub    $0x4,%esp
  80045f:	ff b5 a0 fb ff ff    	pushl  -0x460(%ebp)
  800465:	ff b5 9c fb ff ff    	pushl  -0x464(%ebp)
  80046b:	68 40 35 80 00       	push   $0x803540
  800470:	e8 8f 06 00 00       	call   800b04 <cprintf>
  800475:	83 c4 10             	add    $0x10,%esp
  800478:	e9 f2 fd ff ff       	jmp    80026f <runcmd+0x75>
				cprintf("fork: %e", r);
  80047d:	83 ec 08             	sub    $0x8,%esp
  800480:	50                   	push   %eax
  800481:	68 4d 35 80 00       	push   $0x80354d
  800486:	e8 79 06 00 00       	call   800b04 <cprintf>
				exit();
  80048b:	e8 87 05 00 00       	call   800a17 <exit>
  800490:	83 c4 10             	add    $0x10,%esp
				if (p[1] != 1) {
  800493:	8b 85 a0 fb ff ff    	mov    -0x460(%ebp),%eax
  800499:	83 f8 01             	cmp    $0x1,%eax
  80049c:	75 37                	jne    8004d5 <runcmd+0x2db>
				close(p[0]);
  80049e:	83 ec 0c             	sub    $0xc,%esp
  8004a1:	ff b5 9c fb ff ff    	pushl  -0x464(%ebp)
  8004a7:	e8 a8 1b 00 00       	call   802054 <close>
				goto runit;
  8004ac:	83 c4 10             	add    $0x10,%esp
  8004af:	e9 fc fd ff ff       	jmp    8002b0 <runcmd+0xb6>
					dup(p[0], 0);
  8004b4:	83 ec 08             	sub    $0x8,%esp
  8004b7:	6a 00                	push   $0x0
  8004b9:	50                   	push   %eax
  8004ba:	e8 e7 1b 00 00       	call   8020a6 <dup>
					close(p[0]);
  8004bf:	83 c4 04             	add    $0x4,%esp
  8004c2:	ff b5 9c fb ff ff    	pushl  -0x464(%ebp)
  8004c8:	e8 87 1b 00 00       	call   802054 <close>
  8004cd:	83 c4 10             	add    $0x10,%esp
  8004d0:	e9 bd fd ff ff       	jmp    800292 <runcmd+0x98>
					dup(p[1], 1);
  8004d5:	83 ec 08             	sub    $0x8,%esp
  8004d8:	6a 01                	push   $0x1
  8004da:	50                   	push   %eax
  8004db:	e8 c6 1b 00 00       	call   8020a6 <dup>
					close(p[1]);
  8004e0:	83 c4 04             	add    $0x4,%esp
  8004e3:	ff b5 a0 fb ff ff    	pushl  -0x460(%ebp)
  8004e9:	e8 66 1b 00 00       	call   802054 <close>
  8004ee:	83 c4 10             	add    $0x10,%esp
  8004f1:	eb ab                	jmp    80049e <runcmd+0x2a4>
			panic("bad return %d from gettoken", c);
  8004f3:	53                   	push   %ebx
  8004f4:	68 56 35 80 00       	push   $0x803556
  8004f9:	6a 70                	push   $0x70
  8004fb:	68 17 35 80 00       	push   $0x803517
  800500:	e8 24 05 00 00       	call   800a29 <_panic>
		if (debug)
  800505:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  80050c:	0f 84 30 fe ff ff    	je     800342 <runcmd+0x148>
			cprintf("EMPTY COMMAND\n");
  800512:	83 ec 0c             	sub    $0xc,%esp
  800515:	68 72 35 80 00       	push   $0x803572
  80051a:	e8 e5 05 00 00       	call   800b04 <cprintf>
  80051f:	83 c4 10             	add    $0x10,%esp
  800522:	e9 1b fe ff ff       	jmp    800342 <runcmd+0x148>
		argv0buf[0] = '/';
  800527:	c6 85 a4 fb ff ff 2f 	movb   $0x2f,-0x45c(%ebp)
		strcpy(argv0buf + 1, argv[0]);
  80052e:	83 ec 08             	sub    $0x8,%esp
  800531:	50                   	push   %eax
  800532:	8d bd a4 fb ff ff    	lea    -0x45c(%ebp),%edi
  800538:	8d 85 a5 fb ff ff    	lea    -0x45b(%ebp),%eax
  80053e:	50                   	push   %eax
  80053f:	e8 d6 0d 00 00       	call   80131a <strcpy>
		argv[0] = argv0buf;
  800544:	89 7d a8             	mov    %edi,-0x58(%ebp)
  800547:	83 c4 10             	add    $0x10,%esp
  80054a:	e9 75 fd ff ff       	jmp    8002c4 <runcmd+0xca>
		cprintf("[%08x] SPAWN:", thisenv->env_id);
  80054f:	a1 24 54 80 00       	mov    0x805424,%eax
  800554:	8b 40 48             	mov    0x48(%eax),%eax
  800557:	83 ec 08             	sub    $0x8,%esp
  80055a:	50                   	push   %eax
  80055b:	68 81 35 80 00       	push   $0x803581
  800560:	e8 9f 05 00 00       	call   800b04 <cprintf>
  800565:	8d 75 a8             	lea    -0x58(%ebp),%esi
		for (i = 0; argv[i]; i++)
  800568:	83 c4 10             	add    $0x10,%esp
  80056b:	eb 11                	jmp    80057e <runcmd+0x384>
			cprintf(" %s", argv[i]);
  80056d:	83 ec 08             	sub    $0x8,%esp
  800570:	50                   	push   %eax
  800571:	68 09 36 80 00       	push   $0x803609
  800576:	e8 89 05 00 00       	call   800b04 <cprintf>
  80057b:	83 c4 10             	add    $0x10,%esp
  80057e:	83 c6 04             	add    $0x4,%esi
		for (i = 0; argv[i]; i++)
  800581:	8b 46 fc             	mov    -0x4(%esi),%eax
  800584:	85 c0                	test   %eax,%eax
  800586:	75 e5                	jne    80056d <runcmd+0x373>
		cprintf("\n");
  800588:	83 ec 0c             	sub    $0xc,%esp
  80058b:	68 c0 34 80 00       	push   $0x8034c0
  800590:	e8 6f 05 00 00       	call   800b04 <cprintf>
  800595:	83 c4 10             	add    $0x10,%esp
  800598:	e9 3c fd ff ff       	jmp    8002d9 <runcmd+0xdf>
		cprintf("spawn %s: %e\n", argv[0], r);
  80059d:	83 ec 04             	sub    $0x4,%esp
  8005a0:	50                   	push   %eax
  8005a1:	ff 75 a8             	pushl  -0x58(%ebp)
  8005a4:	68 8f 35 80 00       	push   $0x80358f
  8005a9:	e8 56 05 00 00       	call   800b04 <cprintf>
	close_all();
  8005ae:	e8 ce 1a 00 00       	call   802081 <close_all>
  8005b3:	83 c4 10             	add    $0x10,%esp
	if (pipe_child) {
  8005b6:	85 db                	test   %ebx,%ebx
  8005b8:	0f 84 7f fd ff ff    	je     80033d <runcmd+0x143>
		if (debug)
  8005be:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  8005c5:	0f 84 59 fd ff ff    	je     800324 <runcmd+0x12a>
			cprintf("[%08x] WAIT pipe_child %08x\n", thisenv->env_id, pipe_child);
  8005cb:	a1 24 54 80 00       	mov    0x805424,%eax
  8005d0:	8b 40 48             	mov    0x48(%eax),%eax
  8005d3:	83 ec 04             	sub    $0x4,%esp
  8005d6:	53                   	push   %ebx
  8005d7:	50                   	push   %eax
  8005d8:	68 c8 35 80 00       	push   $0x8035c8
  8005dd:	e8 22 05 00 00       	call   800b04 <cprintf>
  8005e2:	83 c4 10             	add    $0x10,%esp
  8005e5:	e9 3a fd ff ff       	jmp    800324 <runcmd+0x12a>
			cprintf("[%08x] WAIT %s %08x\n", thisenv->env_id, argv[0], r);
  8005ea:	a1 24 54 80 00       	mov    0x805424,%eax
  8005ef:	8b 40 48             	mov    0x48(%eax),%eax
  8005f2:	56                   	push   %esi
  8005f3:	ff 75 a8             	pushl  -0x58(%ebp)
  8005f6:	50                   	push   %eax
  8005f7:	68 9d 35 80 00       	push   $0x80359d
  8005fc:	e8 03 05 00 00       	call   800b04 <cprintf>
  800601:	83 c4 10             	add    $0x10,%esp
  800604:	e9 fe fc ff ff       	jmp    800307 <runcmd+0x10d>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  800609:	a1 24 54 80 00       	mov    0x805424,%eax
  80060e:	8b 40 48             	mov    0x48(%eax),%eax
  800611:	83 ec 08             	sub    $0x8,%esp
  800614:	50                   	push   %eax
  800615:	68 b2 35 80 00       	push   $0x8035b2
  80061a:	e8 e5 04 00 00       	call   800b04 <cprintf>
  80061f:	83 c4 10             	add    $0x10,%esp
  800622:	eb 92                	jmp    8005b6 <runcmd+0x3bc>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  800624:	a1 24 54 80 00       	mov    0x805424,%eax
  800629:	8b 40 48             	mov    0x48(%eax),%eax
  80062c:	83 ec 08             	sub    $0x8,%esp
  80062f:	50                   	push   %eax
  800630:	68 b2 35 80 00       	push   $0x8035b2
  800635:	e8 ca 04 00 00       	call   800b04 <cprintf>
  80063a:	83 c4 10             	add    $0x10,%esp
  80063d:	e9 fb fc ff ff       	jmp    80033d <runcmd+0x143>

00800642 <usage>:


void
usage(void)
{
  800642:	55                   	push   %ebp
  800643:	89 e5                	mov    %esp,%ebp
  800645:	83 ec 14             	sub    $0x14,%esp
	cprintf("usage: sh [-dix] [command-file]\n");
  800648:	68 90 36 80 00       	push   $0x803690
  80064d:	e8 b2 04 00 00       	call   800b04 <cprintf>
	exit();
  800652:	e8 c0 03 00 00       	call   800a17 <exit>
}
  800657:	83 c4 10             	add    $0x10,%esp
  80065a:	c9                   	leave  
  80065b:	c3                   	ret    

0080065c <umain>:

void
umain(int argc, char **argv)
{
  80065c:	55                   	push   %ebp
  80065d:	89 e5                	mov    %esp,%ebp
  80065f:	57                   	push   %edi
  800660:	56                   	push   %esi
  800661:	53                   	push   %ebx
  800662:	83 ec 30             	sub    $0x30,%esp
	int r, interactive, echocmds;
	struct Argstate args;

	interactive = '?';
	echocmds = 0;
	argstart(&argc, argv, &args);
  800665:	8d 45 d8             	lea    -0x28(%ebp),%eax
  800668:	50                   	push   %eax
  800669:	ff 75 0c             	pushl  0xc(%ebp)
  80066c:	8d 45 08             	lea    0x8(%ebp),%eax
  80066f:	50                   	push   %eax
  800670:	e8 e5 16 00 00       	call   801d5a <argstart>
	while ((r = argnext(&args)) >= 0)
  800675:	83 c4 10             	add    $0x10,%esp
	echocmds = 0;
  800678:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
	interactive = '?';
  80067f:	bf 3f 00 00 00       	mov    $0x3f,%edi
	while ((r = argnext(&args)) >= 0)
  800684:	8d 5d d8             	lea    -0x28(%ebp),%ebx
		switch (r) {
		case 'd':
			debug++;
			break;
		case 'i':
			interactive = 1;
  800687:	be 01 00 00 00       	mov    $0x1,%esi
	while ((r = argnext(&args)) >= 0)
  80068c:	eb 10                	jmp    80069e <umain+0x42>
			debug++;
  80068e:	83 05 00 50 80 00 01 	addl   $0x1,0x805000
			break;
  800695:	eb 07                	jmp    80069e <umain+0x42>
			interactive = 1;
  800697:	89 f7                	mov    %esi,%edi
  800699:	eb 03                	jmp    80069e <umain+0x42>
			break;
		case 'x':
			echocmds = 1;
  80069b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
	while ((r = argnext(&args)) >= 0)
  80069e:	83 ec 0c             	sub    $0xc,%esp
  8006a1:	53                   	push   %ebx
  8006a2:	e8 e3 16 00 00       	call   801d8a <argnext>
  8006a7:	83 c4 10             	add    $0x10,%esp
  8006aa:	85 c0                	test   %eax,%eax
  8006ac:	78 16                	js     8006c4 <umain+0x68>
  8006ae:	83 f8 69             	cmp    $0x69,%eax
  8006b1:	74 e4                	je     800697 <umain+0x3b>
  8006b3:	83 f8 78             	cmp    $0x78,%eax
  8006b6:	74 e3                	je     80069b <umain+0x3f>
  8006b8:	83 f8 64             	cmp    $0x64,%eax
  8006bb:	74 d1                	je     80068e <umain+0x32>
			break;
		default:
			usage();
  8006bd:	e8 80 ff ff ff       	call   800642 <usage>
  8006c2:	eb da                	jmp    80069e <umain+0x42>
		}

	if (argc > 2)
  8006c4:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
  8006c8:	7f 1f                	jg     8006e9 <umain+0x8d>
		usage();
	if (argc == 2) {
  8006ca:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
  8006ce:	74 20                	je     8006f0 <umain+0x94>
		close(0);
		if ((r = open(argv[1], O_RDONLY)) < 0)
			panic("open %s: %e", argv[1], r);
		assert(r == 0);
	}
	if (interactive == '?')
  8006d0:	83 ff 3f             	cmp    $0x3f,%edi
  8006d3:	74 75                	je     80074a <umain+0xee>
  8006d5:	85 ff                	test   %edi,%edi
  8006d7:	bf 0d 36 80 00       	mov    $0x80360d,%edi
  8006dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8006e1:	0f 44 f8             	cmove  %eax,%edi
  8006e4:	e9 06 01 00 00       	jmp    8007ef <umain+0x193>
		usage();
  8006e9:	e8 54 ff ff ff       	call   800642 <usage>
  8006ee:	eb da                	jmp    8006ca <umain+0x6e>
		close(0);
  8006f0:	83 ec 0c             	sub    $0xc,%esp
  8006f3:	6a 00                	push   $0x0
  8006f5:	e8 5a 19 00 00       	call   802054 <close>
		if ((r = open(argv[1], O_RDONLY)) < 0)
  8006fa:	83 c4 08             	add    $0x8,%esp
  8006fd:	6a 00                	push   $0x0
  8006ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800702:	ff 70 04             	pushl  0x4(%eax)
  800705:	e8 bf 1e 00 00       	call   8025c9 <open>
  80070a:	83 c4 10             	add    $0x10,%esp
  80070d:	85 c0                	test   %eax,%eax
  80070f:	78 1b                	js     80072c <umain+0xd0>
		assert(r == 0);
  800711:	74 bd                	je     8006d0 <umain+0x74>
  800713:	68 f1 35 80 00       	push   $0x8035f1
  800718:	68 f8 35 80 00       	push   $0x8035f8
  80071d:	68 21 01 00 00       	push   $0x121
  800722:	68 17 35 80 00       	push   $0x803517
  800727:	e8 fd 02 00 00       	call   800a29 <_panic>
			panic("open %s: %e", argv[1], r);
  80072c:	83 ec 0c             	sub    $0xc,%esp
  80072f:	50                   	push   %eax
  800730:	8b 45 0c             	mov    0xc(%ebp),%eax
  800733:	ff 70 04             	pushl  0x4(%eax)
  800736:	68 e5 35 80 00       	push   $0x8035e5
  80073b:	68 20 01 00 00       	push   $0x120
  800740:	68 17 35 80 00       	push   $0x803517
  800745:	e8 df 02 00 00       	call   800a29 <_panic>
		interactive = iscons(0);
  80074a:	83 ec 0c             	sub    $0xc,%esp
  80074d:	6a 00                	push   $0x0
  80074f:	e8 fc 01 00 00       	call   800950 <iscons>
  800754:	89 c7                	mov    %eax,%edi
  800756:	83 c4 10             	add    $0x10,%esp
  800759:	e9 77 ff ff ff       	jmp    8006d5 <umain+0x79>
	while (1) {
		char *buf;

		buf = readline(interactive ? "$ " : NULL);
		if (buf == NULL) {
			if (debug)
  80075e:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  800765:	75 0a                	jne    800771 <umain+0x115>
				cprintf("EXITING\n");
			exit();	// end of file
  800767:	e8 ab 02 00 00       	call   800a17 <exit>
  80076c:	e9 94 00 00 00       	jmp    800805 <umain+0x1a9>
				cprintf("EXITING\n");
  800771:	83 ec 0c             	sub    $0xc,%esp
  800774:	68 10 36 80 00       	push   $0x803610
  800779:	e8 86 03 00 00       	call   800b04 <cprintf>
  80077e:	83 c4 10             	add    $0x10,%esp
  800781:	eb e4                	jmp    800767 <umain+0x10b>
		}
		if (debug)
			cprintf("LINE: %s\n", buf);
  800783:	83 ec 08             	sub    $0x8,%esp
  800786:	53                   	push   %ebx
  800787:	68 19 36 80 00       	push   $0x803619
  80078c:	e8 73 03 00 00       	call   800b04 <cprintf>
  800791:	83 c4 10             	add    $0x10,%esp
  800794:	eb 7c                	jmp    800812 <umain+0x1b6>
		if (buf[0] == '#')
			continue;
		if (echocmds)
			printf("# %s\n", buf);
  800796:	83 ec 08             	sub    $0x8,%esp
  800799:	53                   	push   %ebx
  80079a:	68 23 36 80 00       	push   $0x803623
  80079f:	e8 c8 1f 00 00       	call   80276c <printf>
  8007a4:	83 c4 10             	add    $0x10,%esp
  8007a7:	eb 78                	jmp    800821 <umain+0x1c5>
		if (debug)
			cprintf("BEFORE FORK\n");
  8007a9:	83 ec 0c             	sub    $0xc,%esp
  8007ac:	68 29 36 80 00       	push   $0x803629
  8007b1:	e8 4e 03 00 00       	call   800b04 <cprintf>
  8007b6:	83 c4 10             	add    $0x10,%esp
  8007b9:	eb 73                	jmp    80082e <umain+0x1d2>
		if ((r = fork()) < 0)
			panic("fork: %e", r);
  8007bb:	50                   	push   %eax
  8007bc:	68 4d 35 80 00       	push   $0x80354d
  8007c1:	68 38 01 00 00       	push   $0x138
  8007c6:	68 17 35 80 00       	push   $0x803517
  8007cb:	e8 59 02 00 00       	call   800a29 <_panic>
		if (debug)
			cprintf("FORK: %d\n", r);
  8007d0:	83 ec 08             	sub    $0x8,%esp
  8007d3:	50                   	push   %eax
  8007d4:	68 36 36 80 00       	push   $0x803636
  8007d9:	e8 26 03 00 00       	call   800b04 <cprintf>
  8007de:	83 c4 10             	add    $0x10,%esp
  8007e1:	eb 5f                	jmp    800842 <umain+0x1e6>
		if (r == 0) {
			runcmd(buf);
			exit();
		} else
			wait(r);
  8007e3:	83 ec 0c             	sub    $0xc,%esp
  8007e6:	56                   	push   %esi
  8007e7:	e8 44 28 00 00       	call   803030 <wait>
  8007ec:	83 c4 10             	add    $0x10,%esp
		buf = readline(interactive ? "$ " : NULL);
  8007ef:	83 ec 0c             	sub    $0xc,%esp
  8007f2:	57                   	push   %edi
  8007f3:	e8 f9 09 00 00       	call   8011f1 <readline>
  8007f8:	89 c3                	mov    %eax,%ebx
		if (buf == NULL) {
  8007fa:	83 c4 10             	add    $0x10,%esp
  8007fd:	85 c0                	test   %eax,%eax
  8007ff:	0f 84 59 ff ff ff    	je     80075e <umain+0x102>
		if (debug)
  800805:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  80080c:	0f 85 71 ff ff ff    	jne    800783 <umain+0x127>
		if (buf[0] == '#')
  800812:	80 3b 23             	cmpb   $0x23,(%ebx)
  800815:	74 d8                	je     8007ef <umain+0x193>
		if (echocmds)
  800817:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80081b:	0f 85 75 ff ff ff    	jne    800796 <umain+0x13a>
		if (debug)
  800821:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  800828:	0f 85 7b ff ff ff    	jne    8007a9 <umain+0x14d>
		if ((r = fork()) < 0)
  80082e:	e8 07 12 00 00       	call   801a3a <fork>
  800833:	89 c6                	mov    %eax,%esi
  800835:	85 c0                	test   %eax,%eax
  800837:	78 82                	js     8007bb <umain+0x15f>
		if (debug)
  800839:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  800840:	75 8e                	jne    8007d0 <umain+0x174>
		if (r == 0) {
  800842:	85 f6                	test   %esi,%esi
  800844:	75 9d                	jne    8007e3 <umain+0x187>
			runcmd(buf);
  800846:	83 ec 0c             	sub    $0xc,%esp
  800849:	53                   	push   %ebx
  80084a:	e8 ab f9 ff ff       	call   8001fa <runcmd>
			exit();
  80084f:	e8 c3 01 00 00       	call   800a17 <exit>
  800854:	83 c4 10             	add    $0x10,%esp
  800857:	eb 96                	jmp    8007ef <umain+0x193>

00800859 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  800859:	b8 00 00 00 00       	mov    $0x0,%eax
  80085e:	c3                   	ret    

0080085f <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80085f:	55                   	push   %ebp
  800860:	89 e5                	mov    %esp,%ebp
  800862:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  800865:	68 b1 36 80 00       	push   $0x8036b1
  80086a:	ff 75 0c             	pushl  0xc(%ebp)
  80086d:	e8 a8 0a 00 00       	call   80131a <strcpy>
	return 0;
}
  800872:	b8 00 00 00 00       	mov    $0x0,%eax
  800877:	c9                   	leave  
  800878:	c3                   	ret    

00800879 <devcons_write>:
{
  800879:	55                   	push   %ebp
  80087a:	89 e5                	mov    %esp,%ebp
  80087c:	57                   	push   %edi
  80087d:	56                   	push   %esi
  80087e:	53                   	push   %ebx
  80087f:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  800885:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80088a:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  800890:	3b 75 10             	cmp    0x10(%ebp),%esi
  800893:	73 31                	jae    8008c6 <devcons_write+0x4d>
		m = n - tot;
  800895:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800898:	29 f3                	sub    %esi,%ebx
  80089a:	83 fb 7f             	cmp    $0x7f,%ebx
  80089d:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8008a2:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8008a5:	83 ec 04             	sub    $0x4,%esp
  8008a8:	53                   	push   %ebx
  8008a9:	89 f0                	mov    %esi,%eax
  8008ab:	03 45 0c             	add    0xc(%ebp),%eax
  8008ae:	50                   	push   %eax
  8008af:	57                   	push   %edi
  8008b0:	e8 f3 0b 00 00       	call   8014a8 <memmove>
		sys_cputs(buf, m);
  8008b5:	83 c4 08             	add    $0x8,%esp
  8008b8:	53                   	push   %ebx
  8008b9:	57                   	push   %edi
  8008ba:	e8 91 0d 00 00       	call   801650 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8008bf:	01 de                	add    %ebx,%esi
  8008c1:	83 c4 10             	add    $0x10,%esp
  8008c4:	eb ca                	jmp    800890 <devcons_write+0x17>
}
  8008c6:	89 f0                	mov    %esi,%eax
  8008c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008cb:	5b                   	pop    %ebx
  8008cc:	5e                   	pop    %esi
  8008cd:	5f                   	pop    %edi
  8008ce:	5d                   	pop    %ebp
  8008cf:	c3                   	ret    

008008d0 <devcons_read>:
{
  8008d0:	55                   	push   %ebp
  8008d1:	89 e5                	mov    %esp,%ebp
  8008d3:	83 ec 08             	sub    $0x8,%esp
  8008d6:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8008db:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8008df:	74 21                	je     800902 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8008e1:	e8 88 0d 00 00       	call   80166e <sys_cgetc>
  8008e6:	85 c0                	test   %eax,%eax
  8008e8:	75 07                	jne    8008f1 <devcons_read+0x21>
		sys_yield();
  8008ea:	e8 fe 0d 00 00       	call   8016ed <sys_yield>
  8008ef:	eb f0                	jmp    8008e1 <devcons_read+0x11>
	if (c < 0)
  8008f1:	78 0f                	js     800902 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8008f3:	83 f8 04             	cmp    $0x4,%eax
  8008f6:	74 0c                	je     800904 <devcons_read+0x34>
	*(char*)vbuf = c;
  8008f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008fb:	88 02                	mov    %al,(%edx)
	return 1;
  8008fd:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800902:	c9                   	leave  
  800903:	c3                   	ret    
		return 0;
  800904:	b8 00 00 00 00       	mov    $0x0,%eax
  800909:	eb f7                	jmp    800902 <devcons_read+0x32>

0080090b <cputchar>:
{
  80090b:	55                   	push   %ebp
  80090c:	89 e5                	mov    %esp,%ebp
  80090e:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  800911:	8b 45 08             	mov    0x8(%ebp),%eax
  800914:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  800917:	6a 01                	push   $0x1
  800919:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80091c:	50                   	push   %eax
  80091d:	e8 2e 0d 00 00       	call   801650 <sys_cputs>
}
  800922:	83 c4 10             	add    $0x10,%esp
  800925:	c9                   	leave  
  800926:	c3                   	ret    

00800927 <getchar>:
{
  800927:	55                   	push   %ebp
  800928:	89 e5                	mov    %esp,%ebp
  80092a:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80092d:	6a 01                	push   $0x1
  80092f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800932:	50                   	push   %eax
  800933:	6a 00                	push   $0x0
  800935:	e8 58 18 00 00       	call   802192 <read>
	if (r < 0)
  80093a:	83 c4 10             	add    $0x10,%esp
  80093d:	85 c0                	test   %eax,%eax
  80093f:	78 06                	js     800947 <getchar+0x20>
	if (r < 1)
  800941:	74 06                	je     800949 <getchar+0x22>
	return c;
  800943:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  800947:	c9                   	leave  
  800948:	c3                   	ret    
		return -E_EOF;
  800949:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80094e:	eb f7                	jmp    800947 <getchar+0x20>

00800950 <iscons>:
{
  800950:	55                   	push   %ebp
  800951:	89 e5                	mov    %esp,%ebp
  800953:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800956:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800959:	50                   	push   %eax
  80095a:	ff 75 08             	pushl  0x8(%ebp)
  80095d:	e8 c5 15 00 00       	call   801f27 <fd_lookup>
  800962:	83 c4 10             	add    $0x10,%esp
  800965:	85 c0                	test   %eax,%eax
  800967:	78 11                	js     80097a <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  800969:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80096c:	8b 15 00 40 80 00    	mov    0x804000,%edx
  800972:	39 10                	cmp    %edx,(%eax)
  800974:	0f 94 c0             	sete   %al
  800977:	0f b6 c0             	movzbl %al,%eax
}
  80097a:	c9                   	leave  
  80097b:	c3                   	ret    

0080097c <opencons>:
{
  80097c:	55                   	push   %ebp
  80097d:	89 e5                	mov    %esp,%ebp
  80097f:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  800982:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800985:	50                   	push   %eax
  800986:	e8 4a 15 00 00       	call   801ed5 <fd_alloc>
  80098b:	83 c4 10             	add    $0x10,%esp
  80098e:	85 c0                	test   %eax,%eax
  800990:	78 3a                	js     8009cc <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800992:	83 ec 04             	sub    $0x4,%esp
  800995:	68 07 04 00 00       	push   $0x407
  80099a:	ff 75 f4             	pushl  -0xc(%ebp)
  80099d:	6a 00                	push   $0x0
  80099f:	e8 68 0d 00 00       	call   80170c <sys_page_alloc>
  8009a4:	83 c4 10             	add    $0x10,%esp
  8009a7:	85 c0                	test   %eax,%eax
  8009a9:	78 21                	js     8009cc <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8009ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009ae:	8b 15 00 40 80 00    	mov    0x804000,%edx
  8009b4:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8009b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009b9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8009c0:	83 ec 0c             	sub    $0xc,%esp
  8009c3:	50                   	push   %eax
  8009c4:	e8 e5 14 00 00       	call   801eae <fd2num>
  8009c9:	83 c4 10             	add    $0x10,%esp
}
  8009cc:	c9                   	leave  
  8009cd:	c3                   	ret    

008009ce <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8009ce:	55                   	push   %ebp
  8009cf:	89 e5                	mov    %esp,%ebp
  8009d1:	56                   	push   %esi
  8009d2:	53                   	push   %ebx
  8009d3:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8009d6:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	// thisenv = 0;
	thisenv = &(envs[ENVX(sys_getenvid())]);
  8009d9:	e8 f0 0c 00 00       	call   8016ce <sys_getenvid>
  8009de:	25 ff 03 00 00       	and    $0x3ff,%eax
  8009e3:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8009e9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8009ee:	a3 24 54 80 00       	mov    %eax,0x805424

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8009f3:	85 db                	test   %ebx,%ebx
  8009f5:	7e 07                	jle    8009fe <libmain+0x30>
		binaryname = argv[0];
  8009f7:	8b 06                	mov    (%esi),%eax
  8009f9:	a3 1c 40 80 00       	mov    %eax,0x80401c

	// call user main routine
	umain(argc, argv);
  8009fe:	83 ec 08             	sub    $0x8,%esp
  800a01:	56                   	push   %esi
  800a02:	53                   	push   %ebx
  800a03:	e8 54 fc ff ff       	call   80065c <umain>

	// exit gracefully
	exit();
  800a08:	e8 0a 00 00 00       	call   800a17 <exit>
}
  800a0d:	83 c4 10             	add    $0x10,%esp
  800a10:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a13:	5b                   	pop    %ebx
  800a14:	5e                   	pop    %esi
  800a15:	5d                   	pop    %ebp
  800a16:	c3                   	ret    

00800a17 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800a17:	55                   	push   %ebp
  800a18:	89 e5                	mov    %esp,%ebp
  800a1a:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  800a1d:	6a 00                	push   $0x0
  800a1f:	e8 69 0c 00 00       	call   80168d <sys_env_destroy>
}
  800a24:	83 c4 10             	add    $0x10,%esp
  800a27:	c9                   	leave  
  800a28:	c3                   	ret    

00800a29 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800a29:	55                   	push   %ebp
  800a2a:	89 e5                	mov    %esp,%ebp
  800a2c:	56                   	push   %esi
  800a2d:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800a2e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800a31:	8b 35 1c 40 80 00    	mov    0x80401c,%esi
  800a37:	e8 92 0c 00 00       	call   8016ce <sys_getenvid>
  800a3c:	83 ec 0c             	sub    $0xc,%esp
  800a3f:	ff 75 0c             	pushl  0xc(%ebp)
  800a42:	ff 75 08             	pushl  0x8(%ebp)
  800a45:	56                   	push   %esi
  800a46:	50                   	push   %eax
  800a47:	68 c8 36 80 00       	push   $0x8036c8
  800a4c:	e8 b3 00 00 00       	call   800b04 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800a51:	83 c4 18             	add    $0x18,%esp
  800a54:	53                   	push   %ebx
  800a55:	ff 75 10             	pushl  0x10(%ebp)
  800a58:	e8 56 00 00 00       	call   800ab3 <vcprintf>
	cprintf("\n");
  800a5d:	c7 04 24 c0 34 80 00 	movl   $0x8034c0,(%esp)
  800a64:	e8 9b 00 00 00       	call   800b04 <cprintf>
  800a69:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800a6c:	cc                   	int3   
  800a6d:	eb fd                	jmp    800a6c <_panic+0x43>

00800a6f <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800a6f:	55                   	push   %ebp
  800a70:	89 e5                	mov    %esp,%ebp
  800a72:	53                   	push   %ebx
  800a73:	83 ec 04             	sub    $0x4,%esp
  800a76:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800a79:	8b 13                	mov    (%ebx),%edx
  800a7b:	8d 42 01             	lea    0x1(%edx),%eax
  800a7e:	89 03                	mov    %eax,(%ebx)
  800a80:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a83:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800a87:	3d ff 00 00 00       	cmp    $0xff,%eax
  800a8c:	74 09                	je     800a97 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800a8e:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800a92:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a95:	c9                   	leave  
  800a96:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800a97:	83 ec 08             	sub    $0x8,%esp
  800a9a:	68 ff 00 00 00       	push   $0xff
  800a9f:	8d 43 08             	lea    0x8(%ebx),%eax
  800aa2:	50                   	push   %eax
  800aa3:	e8 a8 0b 00 00       	call   801650 <sys_cputs>
		b->idx = 0;
  800aa8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800aae:	83 c4 10             	add    $0x10,%esp
  800ab1:	eb db                	jmp    800a8e <putch+0x1f>

00800ab3 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800ab3:	55                   	push   %ebp
  800ab4:	89 e5                	mov    %esp,%ebp
  800ab6:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800abc:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800ac3:	00 00 00 
	b.cnt = 0;
  800ac6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800acd:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800ad0:	ff 75 0c             	pushl  0xc(%ebp)
  800ad3:	ff 75 08             	pushl  0x8(%ebp)
  800ad6:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800adc:	50                   	push   %eax
  800add:	68 6f 0a 80 00       	push   $0x800a6f
  800ae2:	e8 4a 01 00 00       	call   800c31 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800ae7:	83 c4 08             	add    $0x8,%esp
  800aea:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800af0:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800af6:	50                   	push   %eax
  800af7:	e8 54 0b 00 00       	call   801650 <sys_cputs>

	return b.cnt;
}
  800afc:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800b02:	c9                   	leave  
  800b03:	c3                   	ret    

00800b04 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800b04:	55                   	push   %ebp
  800b05:	89 e5                	mov    %esp,%ebp
  800b07:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800b0a:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800b0d:	50                   	push   %eax
  800b0e:	ff 75 08             	pushl  0x8(%ebp)
  800b11:	e8 9d ff ff ff       	call   800ab3 <vcprintf>
	va_end(ap);

	return cnt;
}
  800b16:	c9                   	leave  
  800b17:	c3                   	ret    

00800b18 <printnum>:


static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800b18:	55                   	push   %ebp
  800b19:	89 e5                	mov    %esp,%ebp
  800b1b:	57                   	push   %edi
  800b1c:	56                   	push   %esi
  800b1d:	53                   	push   %ebx
  800b1e:	83 ec 1c             	sub    $0x1c,%esp
  800b21:	89 c6                	mov    %eax,%esi
  800b23:	89 d7                	mov    %edx,%edi
  800b25:	8b 45 08             	mov    0x8(%ebp),%eax
  800b28:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b2b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800b2e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800b31:	8b 45 10             	mov    0x10(%ebp),%eax
  800b34:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	// to support '-'
	if(padc == '-'){
  800b37:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800b3b:	74 2c                	je     800b69 <printnum+0x51>
		while (--width > 0)
			putch(' ', putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800b3d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b40:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800b47:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800b4a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800b4d:	39 c2                	cmp    %eax,%edx
  800b4f:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800b52:	73 43                	jae    800b97 <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b54:	83 eb 01             	sub    $0x1,%ebx
  800b57:	85 db                	test   %ebx,%ebx
  800b59:	7e 6c                	jle    800bc7 <printnum+0xaf>
			putch(padc, putdat);
  800b5b:	83 ec 08             	sub    $0x8,%esp
  800b5e:	57                   	push   %edi
  800b5f:	ff 75 18             	pushl  0x18(%ebp)
  800b62:	ff d6                	call   *%esi
  800b64:	83 c4 10             	add    $0x10,%esp
  800b67:	eb eb                	jmp    800b54 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800b69:	83 ec 0c             	sub    $0xc,%esp
  800b6c:	6a 20                	push   $0x20
  800b6e:	6a 00                	push   $0x0
  800b70:	50                   	push   %eax
  800b71:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b74:	ff 75 e0             	pushl  -0x20(%ebp)
  800b77:	89 fa                	mov    %edi,%edx
  800b79:	89 f0                	mov    %esi,%eax
  800b7b:	e8 98 ff ff ff       	call   800b18 <printnum>
		while (--width > 0)
  800b80:	83 c4 20             	add    $0x20,%esp
  800b83:	83 eb 01             	sub    $0x1,%ebx
  800b86:	85 db                	test   %ebx,%ebx
  800b88:	7e 65                	jle    800bef <printnum+0xd7>
			putch(' ', putdat);
  800b8a:	83 ec 08             	sub    $0x8,%esp
  800b8d:	57                   	push   %edi
  800b8e:	6a 20                	push   $0x20
  800b90:	ff d6                	call   *%esi
  800b92:	83 c4 10             	add    $0x10,%esp
  800b95:	eb ec                	jmp    800b83 <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800b97:	83 ec 0c             	sub    $0xc,%esp
  800b9a:	ff 75 18             	pushl  0x18(%ebp)
  800b9d:	83 eb 01             	sub    $0x1,%ebx
  800ba0:	53                   	push   %ebx
  800ba1:	50                   	push   %eax
  800ba2:	83 ec 08             	sub    $0x8,%esp
  800ba5:	ff 75 dc             	pushl  -0x24(%ebp)
  800ba8:	ff 75 d8             	pushl  -0x28(%ebp)
  800bab:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bae:	ff 75 e0             	pushl  -0x20(%ebp)
  800bb1:	e8 9a 26 00 00       	call   803250 <__udivdi3>
  800bb6:	83 c4 18             	add    $0x18,%esp
  800bb9:	52                   	push   %edx
  800bba:	50                   	push   %eax
  800bbb:	89 fa                	mov    %edi,%edx
  800bbd:	89 f0                	mov    %esi,%eax
  800bbf:	e8 54 ff ff ff       	call   800b18 <printnum>
  800bc4:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800bc7:	83 ec 08             	sub    $0x8,%esp
  800bca:	57                   	push   %edi
  800bcb:	83 ec 04             	sub    $0x4,%esp
  800bce:	ff 75 dc             	pushl  -0x24(%ebp)
  800bd1:	ff 75 d8             	pushl  -0x28(%ebp)
  800bd4:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bd7:	ff 75 e0             	pushl  -0x20(%ebp)
  800bda:	e8 81 27 00 00       	call   803360 <__umoddi3>
  800bdf:	83 c4 14             	add    $0x14,%esp
  800be2:	0f be 80 eb 36 80 00 	movsbl 0x8036eb(%eax),%eax
  800be9:	50                   	push   %eax
  800bea:	ff d6                	call   *%esi
  800bec:	83 c4 10             	add    $0x10,%esp
}
  800bef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bf2:	5b                   	pop    %ebx
  800bf3:	5e                   	pop    %esi
  800bf4:	5f                   	pop    %edi
  800bf5:	5d                   	pop    %ebp
  800bf6:	c3                   	ret    

00800bf7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bf7:	55                   	push   %ebp
  800bf8:	89 e5                	mov    %esp,%ebp
  800bfa:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800bfd:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800c01:	8b 10                	mov    (%eax),%edx
  800c03:	3b 50 04             	cmp    0x4(%eax),%edx
  800c06:	73 0a                	jae    800c12 <sprintputch+0x1b>
		*b->buf++ = ch;
  800c08:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c0b:	89 08                	mov    %ecx,(%eax)
  800c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c10:	88 02                	mov    %al,(%edx)
}
  800c12:	5d                   	pop    %ebp
  800c13:	c3                   	ret    

00800c14 <printfmt>:
{
  800c14:	55                   	push   %ebp
  800c15:	89 e5                	mov    %esp,%ebp
  800c17:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800c1a:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800c1d:	50                   	push   %eax
  800c1e:	ff 75 10             	pushl  0x10(%ebp)
  800c21:	ff 75 0c             	pushl  0xc(%ebp)
  800c24:	ff 75 08             	pushl  0x8(%ebp)
  800c27:	e8 05 00 00 00       	call   800c31 <vprintfmt>
}
  800c2c:	83 c4 10             	add    $0x10,%esp
  800c2f:	c9                   	leave  
  800c30:	c3                   	ret    

00800c31 <vprintfmt>:
{
  800c31:	55                   	push   %ebp
  800c32:	89 e5                	mov    %esp,%ebp
  800c34:	57                   	push   %edi
  800c35:	56                   	push   %esi
  800c36:	53                   	push   %ebx
  800c37:	83 ec 3c             	sub    $0x3c,%esp
  800c3a:	8b 75 08             	mov    0x8(%ebp),%esi
  800c3d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800c40:	8b 7d 10             	mov    0x10(%ebp),%edi
  800c43:	e9 1e 04 00 00       	jmp    801066 <vprintfmt+0x435>
		posflag = 0;
  800c48:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
		padc = ' ';
  800c4f:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800c53:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800c5a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800c61:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c68:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  800c6f:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800c74:	8d 47 01             	lea    0x1(%edi),%eax
  800c77:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c7a:	0f b6 17             	movzbl (%edi),%edx
  800c7d:	8d 42 dd             	lea    -0x23(%edx),%eax
  800c80:	3c 55                	cmp    $0x55,%al
  800c82:	0f 87 d9 04 00 00    	ja     801161 <vprintfmt+0x530>
  800c88:	0f b6 c0             	movzbl %al,%eax
  800c8b:	ff 24 85 c0 38 80 00 	jmp    *0x8038c0(,%eax,4)
  800c92:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800c95:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800c99:	eb d9                	jmp    800c74 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800c9b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posflag = 1;
  800c9e:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  800ca5:	eb cd                	jmp    800c74 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800ca7:	0f b6 d2             	movzbl %dl,%edx
  800caa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800cad:	b8 00 00 00 00       	mov    $0x0,%eax
  800cb2:	89 75 08             	mov    %esi,0x8(%ebp)
  800cb5:	eb 0c                	jmp    800cc3 <vprintfmt+0x92>
		switch (ch = *(unsigned char *) fmt++) {
  800cb7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800cba:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  800cbe:	eb b4                	jmp    800c74 <vprintfmt+0x43>
			for (precision = 0; ; ++fmt) {
  800cc0:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800cc3:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800cc6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800cca:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800ccd:	8d 72 d0             	lea    -0x30(%edx),%esi
  800cd0:	83 fe 09             	cmp    $0x9,%esi
  800cd3:	76 eb                	jbe    800cc0 <vprintfmt+0x8f>
  800cd5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800cd8:	8b 75 08             	mov    0x8(%ebp),%esi
  800cdb:	eb 14                	jmp    800cf1 <vprintfmt+0xc0>
			precision = va_arg(ap, int);
  800cdd:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce0:	8b 00                	mov    (%eax),%eax
  800ce2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ce5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce8:	8d 40 04             	lea    0x4(%eax),%eax
  800ceb:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800cee:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800cf1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800cf5:	0f 89 79 ff ff ff    	jns    800c74 <vprintfmt+0x43>
				width = precision, precision = -1;
  800cfb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800cfe:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800d01:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800d08:	e9 67 ff ff ff       	jmp    800c74 <vprintfmt+0x43>
  800d0d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d10:	85 c0                	test   %eax,%eax
  800d12:	0f 48 c1             	cmovs  %ecx,%eax
  800d15:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800d18:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800d1b:	e9 54 ff ff ff       	jmp    800c74 <vprintfmt+0x43>
  800d20:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800d23:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800d2a:	e9 45 ff ff ff       	jmp    800c74 <vprintfmt+0x43>
			lflag++;
  800d2f:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800d33:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800d36:	e9 39 ff ff ff       	jmp    800c74 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800d3b:	8b 45 14             	mov    0x14(%ebp),%eax
  800d3e:	8d 78 04             	lea    0x4(%eax),%edi
  800d41:	83 ec 08             	sub    $0x8,%esp
  800d44:	53                   	push   %ebx
  800d45:	ff 30                	pushl  (%eax)
  800d47:	ff d6                	call   *%esi
			break;
  800d49:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800d4c:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800d4f:	e9 0f 03 00 00       	jmp    801063 <vprintfmt+0x432>
			err = va_arg(ap, int);
  800d54:	8b 45 14             	mov    0x14(%ebp),%eax
  800d57:	8d 78 04             	lea    0x4(%eax),%edi
  800d5a:	8b 00                	mov    (%eax),%eax
  800d5c:	99                   	cltd   
  800d5d:	31 d0                	xor    %edx,%eax
  800d5f:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800d61:	83 f8 0f             	cmp    $0xf,%eax
  800d64:	7f 23                	jg     800d89 <vprintfmt+0x158>
  800d66:	8b 14 85 20 3a 80 00 	mov    0x803a20(,%eax,4),%edx
  800d6d:	85 d2                	test   %edx,%edx
  800d6f:	74 18                	je     800d89 <vprintfmt+0x158>
				printfmt(putch, putdat, "%s", p);
  800d71:	52                   	push   %edx
  800d72:	68 0a 36 80 00       	push   $0x80360a
  800d77:	53                   	push   %ebx
  800d78:	56                   	push   %esi
  800d79:	e8 96 fe ff ff       	call   800c14 <printfmt>
  800d7e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800d81:	89 7d 14             	mov    %edi,0x14(%ebp)
  800d84:	e9 da 02 00 00       	jmp    801063 <vprintfmt+0x432>
				printfmt(putch, putdat, "error %d", err);
  800d89:	50                   	push   %eax
  800d8a:	68 03 37 80 00       	push   $0x803703
  800d8f:	53                   	push   %ebx
  800d90:	56                   	push   %esi
  800d91:	e8 7e fe ff ff       	call   800c14 <printfmt>
  800d96:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800d99:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800d9c:	e9 c2 02 00 00       	jmp    801063 <vprintfmt+0x432>
			if ((p = va_arg(ap, char *)) == NULL)
  800da1:	8b 45 14             	mov    0x14(%ebp),%eax
  800da4:	83 c0 04             	add    $0x4,%eax
  800da7:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800daa:	8b 45 14             	mov    0x14(%ebp),%eax
  800dad:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800daf:	85 c9                	test   %ecx,%ecx
  800db1:	b8 fc 36 80 00       	mov    $0x8036fc,%eax
  800db6:	0f 45 c1             	cmovne %ecx,%eax
  800db9:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800dbc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800dc0:	7e 06                	jle    800dc8 <vprintfmt+0x197>
  800dc2:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800dc6:	75 0d                	jne    800dd5 <vprintfmt+0x1a4>
				for (width -= strnlen(p, precision); width > 0; width--)
  800dc8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800dcb:	89 c7                	mov    %eax,%edi
  800dcd:	03 45 e0             	add    -0x20(%ebp),%eax
  800dd0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800dd3:	eb 53                	jmp    800e28 <vprintfmt+0x1f7>
  800dd5:	83 ec 08             	sub    $0x8,%esp
  800dd8:	ff 75 d8             	pushl  -0x28(%ebp)
  800ddb:	50                   	push   %eax
  800ddc:	e8 18 05 00 00       	call   8012f9 <strnlen>
  800de1:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800de4:	29 c1                	sub    %eax,%ecx
  800de6:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  800de9:	83 c4 10             	add    $0x10,%esp
  800dec:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800dee:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800df2:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800df5:	eb 0f                	jmp    800e06 <vprintfmt+0x1d5>
					putch(padc, putdat);
  800df7:	83 ec 08             	sub    $0x8,%esp
  800dfa:	53                   	push   %ebx
  800dfb:	ff 75 e0             	pushl  -0x20(%ebp)
  800dfe:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800e00:	83 ef 01             	sub    $0x1,%edi
  800e03:	83 c4 10             	add    $0x10,%esp
  800e06:	85 ff                	test   %edi,%edi
  800e08:	7f ed                	jg     800df7 <vprintfmt+0x1c6>
  800e0a:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  800e0d:	85 c9                	test   %ecx,%ecx
  800e0f:	b8 00 00 00 00       	mov    $0x0,%eax
  800e14:	0f 49 c1             	cmovns %ecx,%eax
  800e17:	29 c1                	sub    %eax,%ecx
  800e19:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800e1c:	eb aa                	jmp    800dc8 <vprintfmt+0x197>
					putch(ch, putdat);
  800e1e:	83 ec 08             	sub    $0x8,%esp
  800e21:	53                   	push   %ebx
  800e22:	52                   	push   %edx
  800e23:	ff d6                	call   *%esi
  800e25:	83 c4 10             	add    $0x10,%esp
  800e28:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800e2b:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e2d:	83 c7 01             	add    $0x1,%edi
  800e30:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800e34:	0f be d0             	movsbl %al,%edx
  800e37:	85 d2                	test   %edx,%edx
  800e39:	74 4b                	je     800e86 <vprintfmt+0x255>
  800e3b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800e3f:	78 06                	js     800e47 <vprintfmt+0x216>
  800e41:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800e45:	78 1e                	js     800e65 <vprintfmt+0x234>
				if (altflag && (ch < ' ' || ch > '~'))
  800e47:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800e4b:	74 d1                	je     800e1e <vprintfmt+0x1ed>
  800e4d:	0f be c0             	movsbl %al,%eax
  800e50:	83 e8 20             	sub    $0x20,%eax
  800e53:	83 f8 5e             	cmp    $0x5e,%eax
  800e56:	76 c6                	jbe    800e1e <vprintfmt+0x1ed>
					putch('?', putdat);
  800e58:	83 ec 08             	sub    $0x8,%esp
  800e5b:	53                   	push   %ebx
  800e5c:	6a 3f                	push   $0x3f
  800e5e:	ff d6                	call   *%esi
  800e60:	83 c4 10             	add    $0x10,%esp
  800e63:	eb c3                	jmp    800e28 <vprintfmt+0x1f7>
  800e65:	89 cf                	mov    %ecx,%edi
  800e67:	eb 0e                	jmp    800e77 <vprintfmt+0x246>
				putch(' ', putdat);
  800e69:	83 ec 08             	sub    $0x8,%esp
  800e6c:	53                   	push   %ebx
  800e6d:	6a 20                	push   $0x20
  800e6f:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800e71:	83 ef 01             	sub    $0x1,%edi
  800e74:	83 c4 10             	add    $0x10,%esp
  800e77:	85 ff                	test   %edi,%edi
  800e79:	7f ee                	jg     800e69 <vprintfmt+0x238>
			if ((p = va_arg(ap, char *)) == NULL)
  800e7b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800e7e:	89 45 14             	mov    %eax,0x14(%ebp)
  800e81:	e9 dd 01 00 00       	jmp    801063 <vprintfmt+0x432>
  800e86:	89 cf                	mov    %ecx,%edi
  800e88:	eb ed                	jmp    800e77 <vprintfmt+0x246>
	if (lflag >= 2)
  800e8a:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800e8e:	7f 21                	jg     800eb1 <vprintfmt+0x280>
	else if (lflag)
  800e90:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800e94:	74 6a                	je     800f00 <vprintfmt+0x2cf>
		return va_arg(*ap, long);
  800e96:	8b 45 14             	mov    0x14(%ebp),%eax
  800e99:	8b 00                	mov    (%eax),%eax
  800e9b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800e9e:	89 c1                	mov    %eax,%ecx
  800ea0:	c1 f9 1f             	sar    $0x1f,%ecx
  800ea3:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800ea6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ea9:	8d 40 04             	lea    0x4(%eax),%eax
  800eac:	89 45 14             	mov    %eax,0x14(%ebp)
  800eaf:	eb 17                	jmp    800ec8 <vprintfmt+0x297>
		return va_arg(*ap, long long);
  800eb1:	8b 45 14             	mov    0x14(%ebp),%eax
  800eb4:	8b 50 04             	mov    0x4(%eax),%edx
  800eb7:	8b 00                	mov    (%eax),%eax
  800eb9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ebc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ebf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ec2:	8d 40 08             	lea    0x8(%eax),%eax
  800ec5:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800ec8:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  800ecb:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800ed0:	85 d2                	test   %edx,%edx
  800ed2:	0f 89 5c 01 00 00    	jns    801034 <vprintfmt+0x403>
				putch('-', putdat);
  800ed8:	83 ec 08             	sub    $0x8,%esp
  800edb:	53                   	push   %ebx
  800edc:	6a 2d                	push   $0x2d
  800ede:	ff d6                	call   *%esi
				num = -(long long) num;
  800ee0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800ee3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800ee6:	f7 d8                	neg    %eax
  800ee8:	83 d2 00             	adc    $0x0,%edx
  800eeb:	f7 da                	neg    %edx
  800eed:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ef0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ef3:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800ef6:	bf 0a 00 00 00       	mov    $0xa,%edi
  800efb:	e9 45 01 00 00       	jmp    801045 <vprintfmt+0x414>
		return va_arg(*ap, int);
  800f00:	8b 45 14             	mov    0x14(%ebp),%eax
  800f03:	8b 00                	mov    (%eax),%eax
  800f05:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800f08:	89 c1                	mov    %eax,%ecx
  800f0a:	c1 f9 1f             	sar    $0x1f,%ecx
  800f0d:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800f10:	8b 45 14             	mov    0x14(%ebp),%eax
  800f13:	8d 40 04             	lea    0x4(%eax),%eax
  800f16:	89 45 14             	mov    %eax,0x14(%ebp)
  800f19:	eb ad                	jmp    800ec8 <vprintfmt+0x297>
	if (lflag >= 2)
  800f1b:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800f1f:	7f 29                	jg     800f4a <vprintfmt+0x319>
	else if (lflag)
  800f21:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800f25:	74 44                	je     800f6b <vprintfmt+0x33a>
		return va_arg(*ap, unsigned long);
  800f27:	8b 45 14             	mov    0x14(%ebp),%eax
  800f2a:	8b 00                	mov    (%eax),%eax
  800f2c:	ba 00 00 00 00       	mov    $0x0,%edx
  800f31:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800f34:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800f37:	8b 45 14             	mov    0x14(%ebp),%eax
  800f3a:	8d 40 04             	lea    0x4(%eax),%eax
  800f3d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800f40:	bf 0a 00 00 00       	mov    $0xa,%edi
  800f45:	e9 ea 00 00 00       	jmp    801034 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  800f4a:	8b 45 14             	mov    0x14(%ebp),%eax
  800f4d:	8b 50 04             	mov    0x4(%eax),%edx
  800f50:	8b 00                	mov    (%eax),%eax
  800f52:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800f55:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800f58:	8b 45 14             	mov    0x14(%ebp),%eax
  800f5b:	8d 40 08             	lea    0x8(%eax),%eax
  800f5e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800f61:	bf 0a 00 00 00       	mov    $0xa,%edi
  800f66:	e9 c9 00 00 00       	jmp    801034 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  800f6b:	8b 45 14             	mov    0x14(%ebp),%eax
  800f6e:	8b 00                	mov    (%eax),%eax
  800f70:	ba 00 00 00 00       	mov    $0x0,%edx
  800f75:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800f78:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800f7b:	8b 45 14             	mov    0x14(%ebp),%eax
  800f7e:	8d 40 04             	lea    0x4(%eax),%eax
  800f81:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800f84:	bf 0a 00 00 00       	mov    $0xa,%edi
  800f89:	e9 a6 00 00 00       	jmp    801034 <vprintfmt+0x403>
			putch('0', putdat);
  800f8e:	83 ec 08             	sub    $0x8,%esp
  800f91:	53                   	push   %ebx
  800f92:	6a 30                	push   $0x30
  800f94:	ff d6                	call   *%esi
	if (lflag >= 2)
  800f96:	83 c4 10             	add    $0x10,%esp
  800f99:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800f9d:	7f 26                	jg     800fc5 <vprintfmt+0x394>
	else if (lflag)
  800f9f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800fa3:	74 3e                	je     800fe3 <vprintfmt+0x3b2>
		return va_arg(*ap, unsigned long);
  800fa5:	8b 45 14             	mov    0x14(%ebp),%eax
  800fa8:	8b 00                	mov    (%eax),%eax
  800faa:	ba 00 00 00 00       	mov    $0x0,%edx
  800faf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800fb2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800fb5:	8b 45 14             	mov    0x14(%ebp),%eax
  800fb8:	8d 40 04             	lea    0x4(%eax),%eax
  800fbb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800fbe:	bf 08 00 00 00       	mov    $0x8,%edi
  800fc3:	eb 6f                	jmp    801034 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  800fc5:	8b 45 14             	mov    0x14(%ebp),%eax
  800fc8:	8b 50 04             	mov    0x4(%eax),%edx
  800fcb:	8b 00                	mov    (%eax),%eax
  800fcd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800fd0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800fd3:	8b 45 14             	mov    0x14(%ebp),%eax
  800fd6:	8d 40 08             	lea    0x8(%eax),%eax
  800fd9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800fdc:	bf 08 00 00 00       	mov    $0x8,%edi
  800fe1:	eb 51                	jmp    801034 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  800fe3:	8b 45 14             	mov    0x14(%ebp),%eax
  800fe6:	8b 00                	mov    (%eax),%eax
  800fe8:	ba 00 00 00 00       	mov    $0x0,%edx
  800fed:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ff0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ff3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ff6:	8d 40 04             	lea    0x4(%eax),%eax
  800ff9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800ffc:	bf 08 00 00 00       	mov    $0x8,%edi
  801001:	eb 31                	jmp    801034 <vprintfmt+0x403>
			putch('0', putdat);
  801003:	83 ec 08             	sub    $0x8,%esp
  801006:	53                   	push   %ebx
  801007:	6a 30                	push   $0x30
  801009:	ff d6                	call   *%esi
			putch('x', putdat);
  80100b:	83 c4 08             	add    $0x8,%esp
  80100e:	53                   	push   %ebx
  80100f:	6a 78                	push   $0x78
  801011:	ff d6                	call   *%esi
			num = (unsigned long long)
  801013:	8b 45 14             	mov    0x14(%ebp),%eax
  801016:	8b 00                	mov    (%eax),%eax
  801018:	ba 00 00 00 00       	mov    $0x0,%edx
  80101d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801020:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  801023:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801026:	8b 45 14             	mov    0x14(%ebp),%eax
  801029:	8d 40 04             	lea    0x4(%eax),%eax
  80102c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80102f:	bf 10 00 00 00       	mov    $0x10,%edi
			if(posflag)
  801034:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  801038:	74 0b                	je     801045 <vprintfmt+0x414>
				putch('+', putdat);
  80103a:	83 ec 08             	sub    $0x8,%esp
  80103d:	53                   	push   %ebx
  80103e:	6a 2b                	push   $0x2b
  801040:	ff d6                	call   *%esi
  801042:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  801045:	83 ec 0c             	sub    $0xc,%esp
  801048:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80104c:	50                   	push   %eax
  80104d:	ff 75 e0             	pushl  -0x20(%ebp)
  801050:	57                   	push   %edi
  801051:	ff 75 dc             	pushl  -0x24(%ebp)
  801054:	ff 75 d8             	pushl  -0x28(%ebp)
  801057:	89 da                	mov    %ebx,%edx
  801059:	89 f0                	mov    %esi,%eax
  80105b:	e8 b8 fa ff ff       	call   800b18 <printnum>
			break;
  801060:	83 c4 20             	add    $0x20,%esp
			char* cp = va_arg(ap, char *);
  801063:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801066:	83 c7 01             	add    $0x1,%edi
  801069:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80106d:	83 f8 25             	cmp    $0x25,%eax
  801070:	0f 84 d2 fb ff ff    	je     800c48 <vprintfmt+0x17>
			if (ch == '\0')
  801076:	85 c0                	test   %eax,%eax
  801078:	0f 84 03 01 00 00    	je     801181 <vprintfmt+0x550>
			putch(ch, putdat);
  80107e:	83 ec 08             	sub    $0x8,%esp
  801081:	53                   	push   %ebx
  801082:	50                   	push   %eax
  801083:	ff d6                	call   *%esi
  801085:	83 c4 10             	add    $0x10,%esp
  801088:	eb dc                	jmp    801066 <vprintfmt+0x435>
	if (lflag >= 2)
  80108a:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  80108e:	7f 29                	jg     8010b9 <vprintfmt+0x488>
	else if (lflag)
  801090:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  801094:	74 44                	je     8010da <vprintfmt+0x4a9>
		return va_arg(*ap, unsigned long);
  801096:	8b 45 14             	mov    0x14(%ebp),%eax
  801099:	8b 00                	mov    (%eax),%eax
  80109b:	ba 00 00 00 00       	mov    $0x0,%edx
  8010a0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8010a3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8010a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8010a9:	8d 40 04             	lea    0x4(%eax),%eax
  8010ac:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8010af:	bf 10 00 00 00       	mov    $0x10,%edi
  8010b4:	e9 7b ff ff ff       	jmp    801034 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  8010b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8010bc:	8b 50 04             	mov    0x4(%eax),%edx
  8010bf:	8b 00                	mov    (%eax),%eax
  8010c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8010c4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8010c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8010ca:	8d 40 08             	lea    0x8(%eax),%eax
  8010cd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8010d0:	bf 10 00 00 00       	mov    $0x10,%edi
  8010d5:	e9 5a ff ff ff       	jmp    801034 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  8010da:	8b 45 14             	mov    0x14(%ebp),%eax
  8010dd:	8b 00                	mov    (%eax),%eax
  8010df:	ba 00 00 00 00       	mov    $0x0,%edx
  8010e4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8010e7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8010ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8010ed:	8d 40 04             	lea    0x4(%eax),%eax
  8010f0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8010f3:	bf 10 00 00 00       	mov    $0x10,%edi
  8010f8:	e9 37 ff ff ff       	jmp    801034 <vprintfmt+0x403>
			char* cp = va_arg(ap, char *);
  8010fd:	8b 45 14             	mov    0x14(%ebp),%eax
  801100:	8d 78 04             	lea    0x4(%eax),%edi
  801103:	8b 00                	mov    (%eax),%eax
    			if (cp == NULL) {
  801105:	85 c0                	test   %eax,%eax
  801107:	74 2c                	je     801135 <vprintfmt+0x504>
    			*cp = *(int *)putdat;
  801109:	8b 13                	mov    (%ebx),%edx
  80110b:	88 10                	mov    %dl,(%eax)
			char* cp = va_arg(ap, char *);
  80110d:	89 7d 14             	mov    %edi,0x14(%ebp)
    			if ((*(int *) putdat) > 127)
  801110:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  801113:	0f 8e 4a ff ff ff    	jle    801063 <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", overflow_error);
  801119:	68 58 38 80 00       	push   $0x803858
  80111e:	68 0a 36 80 00       	push   $0x80360a
  801123:	53                   	push   %ebx
  801124:	56                   	push   %esi
  801125:	e8 ea fa ff ff       	call   800c14 <printfmt>
  80112a:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  80112d:	89 7d 14             	mov    %edi,0x14(%ebp)
  801130:	e9 2e ff ff ff       	jmp    801063 <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", null_error);
  801135:	68 20 38 80 00       	push   $0x803820
  80113a:	68 0a 36 80 00       	push   $0x80360a
  80113f:	53                   	push   %ebx
  801140:	56                   	push   %esi
  801141:	e8 ce fa ff ff       	call   800c14 <printfmt>
        		break;
  801146:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  801149:	89 7d 14             	mov    %edi,0x14(%ebp)
        		break;
  80114c:	e9 12 ff ff ff       	jmp    801063 <vprintfmt+0x432>
			putch(ch, putdat);
  801151:	83 ec 08             	sub    $0x8,%esp
  801154:	53                   	push   %ebx
  801155:	6a 25                	push   $0x25
  801157:	ff d6                	call   *%esi
			break;
  801159:	83 c4 10             	add    $0x10,%esp
  80115c:	e9 02 ff ff ff       	jmp    801063 <vprintfmt+0x432>
			putch('%', putdat);
  801161:	83 ec 08             	sub    $0x8,%esp
  801164:	53                   	push   %ebx
  801165:	6a 25                	push   $0x25
  801167:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801169:	83 c4 10             	add    $0x10,%esp
  80116c:	89 f8                	mov    %edi,%eax
  80116e:	eb 03                	jmp    801173 <vprintfmt+0x542>
  801170:	83 e8 01             	sub    $0x1,%eax
  801173:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801177:	75 f7                	jne    801170 <vprintfmt+0x53f>
  801179:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80117c:	e9 e2 fe ff ff       	jmp    801063 <vprintfmt+0x432>
}
  801181:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801184:	5b                   	pop    %ebx
  801185:	5e                   	pop    %esi
  801186:	5f                   	pop    %edi
  801187:	5d                   	pop    %ebp
  801188:	c3                   	ret    

00801189 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801189:	55                   	push   %ebp
  80118a:	89 e5                	mov    %esp,%ebp
  80118c:	83 ec 18             	sub    $0x18,%esp
  80118f:	8b 45 08             	mov    0x8(%ebp),%eax
  801192:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801195:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801198:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80119c:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80119f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8011a6:	85 c0                	test   %eax,%eax
  8011a8:	74 26                	je     8011d0 <vsnprintf+0x47>
  8011aa:	85 d2                	test   %edx,%edx
  8011ac:	7e 22                	jle    8011d0 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8011ae:	ff 75 14             	pushl  0x14(%ebp)
  8011b1:	ff 75 10             	pushl  0x10(%ebp)
  8011b4:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8011b7:	50                   	push   %eax
  8011b8:	68 f7 0b 80 00       	push   $0x800bf7
  8011bd:	e8 6f fa ff ff       	call   800c31 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8011c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011c5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8011c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011cb:	83 c4 10             	add    $0x10,%esp
}
  8011ce:	c9                   	leave  
  8011cf:	c3                   	ret    
		return -E_INVAL;
  8011d0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011d5:	eb f7                	jmp    8011ce <vsnprintf+0x45>

008011d7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011d7:	55                   	push   %ebp
  8011d8:	89 e5                	mov    %esp,%ebp
  8011da:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8011dd:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8011e0:	50                   	push   %eax
  8011e1:	ff 75 10             	pushl  0x10(%ebp)
  8011e4:	ff 75 0c             	pushl  0xc(%ebp)
  8011e7:	ff 75 08             	pushl  0x8(%ebp)
  8011ea:	e8 9a ff ff ff       	call   801189 <vsnprintf>
	va_end(ap);

	return rc;
}
  8011ef:	c9                   	leave  
  8011f0:	c3                   	ret    

008011f1 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  8011f1:	55                   	push   %ebp
  8011f2:	89 e5                	mov    %esp,%ebp
  8011f4:	57                   	push   %edi
  8011f5:	56                   	push   %esi
  8011f6:	53                   	push   %ebx
  8011f7:	83 ec 0c             	sub    $0xc,%esp
  8011fa:	8b 45 08             	mov    0x8(%ebp),%eax

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  8011fd:	85 c0                	test   %eax,%eax
  8011ff:	74 13                	je     801214 <readline+0x23>
		fprintf(1, "%s", prompt);
  801201:	83 ec 04             	sub    $0x4,%esp
  801204:	50                   	push   %eax
  801205:	68 0a 36 80 00       	push   $0x80360a
  80120a:	6a 01                	push   $0x1
  80120c:	e8 44 15 00 00       	call   802755 <fprintf>
  801211:	83 c4 10             	add    $0x10,%esp
#endif

	i = 0;
	echoing = iscons(0);
  801214:	83 ec 0c             	sub    $0xc,%esp
  801217:	6a 00                	push   $0x0
  801219:	e8 32 f7 ff ff       	call   800950 <iscons>
  80121e:	89 c7                	mov    %eax,%edi
  801220:	83 c4 10             	add    $0x10,%esp
	i = 0;
  801223:	be 00 00 00 00       	mov    $0x0,%esi
  801228:	eb 57                	jmp    801281 <readline+0x90>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
  80122a:	b8 00 00 00 00       	mov    $0x0,%eax
			if (c != -E_EOF)
  80122f:	83 fb f8             	cmp    $0xfffffff8,%ebx
  801232:	75 08                	jne    80123c <readline+0x4b>
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
  801234:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801237:	5b                   	pop    %ebx
  801238:	5e                   	pop    %esi
  801239:	5f                   	pop    %edi
  80123a:	5d                   	pop    %ebp
  80123b:	c3                   	ret    
				cprintf("read error: %e\n", c);
  80123c:	83 ec 08             	sub    $0x8,%esp
  80123f:	53                   	push   %ebx
  801240:	68 60 3a 80 00       	push   $0x803a60
  801245:	e8 ba f8 ff ff       	call   800b04 <cprintf>
  80124a:	83 c4 10             	add    $0x10,%esp
			return NULL;
  80124d:	b8 00 00 00 00       	mov    $0x0,%eax
  801252:	eb e0                	jmp    801234 <readline+0x43>
			if (echoing)
  801254:	85 ff                	test   %edi,%edi
  801256:	75 05                	jne    80125d <readline+0x6c>
			i--;
  801258:	83 ee 01             	sub    $0x1,%esi
  80125b:	eb 24                	jmp    801281 <readline+0x90>
				cputchar('\b');
  80125d:	83 ec 0c             	sub    $0xc,%esp
  801260:	6a 08                	push   $0x8
  801262:	e8 a4 f6 ff ff       	call   80090b <cputchar>
  801267:	83 c4 10             	add    $0x10,%esp
  80126a:	eb ec                	jmp    801258 <readline+0x67>
				cputchar(c);
  80126c:	83 ec 0c             	sub    $0xc,%esp
  80126f:	53                   	push   %ebx
  801270:	e8 96 f6 ff ff       	call   80090b <cputchar>
  801275:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801278:	88 9e 20 50 80 00    	mov    %bl,0x805020(%esi)
  80127e:	8d 76 01             	lea    0x1(%esi),%esi
		c = getchar();
  801281:	e8 a1 f6 ff ff       	call   800927 <getchar>
  801286:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
  801288:	85 c0                	test   %eax,%eax
  80128a:	78 9e                	js     80122a <readline+0x39>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  80128c:	83 f8 08             	cmp    $0x8,%eax
  80128f:	0f 94 c2             	sete   %dl
  801292:	83 f8 7f             	cmp    $0x7f,%eax
  801295:	0f 94 c0             	sete   %al
  801298:	08 c2                	or     %al,%dl
  80129a:	74 04                	je     8012a0 <readline+0xaf>
  80129c:	85 f6                	test   %esi,%esi
  80129e:	7f b4                	jg     801254 <readline+0x63>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8012a0:	83 fb 1f             	cmp    $0x1f,%ebx
  8012a3:	7e 0e                	jle    8012b3 <readline+0xc2>
  8012a5:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
  8012ab:	7f 06                	jg     8012b3 <readline+0xc2>
			if (echoing)
  8012ad:	85 ff                	test   %edi,%edi
  8012af:	74 c7                	je     801278 <readline+0x87>
  8012b1:	eb b9                	jmp    80126c <readline+0x7b>
		} else if (c == '\n' || c == '\r') {
  8012b3:	83 fb 0a             	cmp    $0xa,%ebx
  8012b6:	74 05                	je     8012bd <readline+0xcc>
  8012b8:	83 fb 0d             	cmp    $0xd,%ebx
  8012bb:	75 c4                	jne    801281 <readline+0x90>
			if (echoing)
  8012bd:	85 ff                	test   %edi,%edi
  8012bf:	75 11                	jne    8012d2 <readline+0xe1>
			buf[i] = 0;
  8012c1:	c6 86 20 50 80 00 00 	movb   $0x0,0x805020(%esi)
			return buf;
  8012c8:	b8 20 50 80 00       	mov    $0x805020,%eax
  8012cd:	e9 62 ff ff ff       	jmp    801234 <readline+0x43>
				cputchar('\n');
  8012d2:	83 ec 0c             	sub    $0xc,%esp
  8012d5:	6a 0a                	push   $0xa
  8012d7:	e8 2f f6 ff ff       	call   80090b <cputchar>
  8012dc:	83 c4 10             	add    $0x10,%esp
  8012df:	eb e0                	jmp    8012c1 <readline+0xd0>

008012e1 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8012e1:	55                   	push   %ebp
  8012e2:	89 e5                	mov    %esp,%ebp
  8012e4:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8012e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8012ec:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8012f0:	74 05                	je     8012f7 <strlen+0x16>
		n++;
  8012f2:	83 c0 01             	add    $0x1,%eax
  8012f5:	eb f5                	jmp    8012ec <strlen+0xb>
	return n;
}
  8012f7:	5d                   	pop    %ebp
  8012f8:	c3                   	ret    

008012f9 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8012f9:	55                   	push   %ebp
  8012fa:	89 e5                	mov    %esp,%ebp
  8012fc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012ff:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801302:	ba 00 00 00 00       	mov    $0x0,%edx
  801307:	39 c2                	cmp    %eax,%edx
  801309:	74 0d                	je     801318 <strnlen+0x1f>
  80130b:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  80130f:	74 05                	je     801316 <strnlen+0x1d>
		n++;
  801311:	83 c2 01             	add    $0x1,%edx
  801314:	eb f1                	jmp    801307 <strnlen+0xe>
  801316:	89 d0                	mov    %edx,%eax
	return n;
}
  801318:	5d                   	pop    %ebp
  801319:	c3                   	ret    

0080131a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80131a:	55                   	push   %ebp
  80131b:	89 e5                	mov    %esp,%ebp
  80131d:	53                   	push   %ebx
  80131e:	8b 45 08             	mov    0x8(%ebp),%eax
  801321:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801324:	ba 00 00 00 00       	mov    $0x0,%edx
  801329:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80132d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  801330:	83 c2 01             	add    $0x1,%edx
  801333:	84 c9                	test   %cl,%cl
  801335:	75 f2                	jne    801329 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  801337:	5b                   	pop    %ebx
  801338:	5d                   	pop    %ebp
  801339:	c3                   	ret    

0080133a <strcat>:

char *
strcat(char *dst, const char *src)
{
  80133a:	55                   	push   %ebp
  80133b:	89 e5                	mov    %esp,%ebp
  80133d:	53                   	push   %ebx
  80133e:	83 ec 10             	sub    $0x10,%esp
  801341:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801344:	53                   	push   %ebx
  801345:	e8 97 ff ff ff       	call   8012e1 <strlen>
  80134a:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80134d:	ff 75 0c             	pushl  0xc(%ebp)
  801350:	01 d8                	add    %ebx,%eax
  801352:	50                   	push   %eax
  801353:	e8 c2 ff ff ff       	call   80131a <strcpy>
	return dst;
}
  801358:	89 d8                	mov    %ebx,%eax
  80135a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80135d:	c9                   	leave  
  80135e:	c3                   	ret    

0080135f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80135f:	55                   	push   %ebp
  801360:	89 e5                	mov    %esp,%ebp
  801362:	56                   	push   %esi
  801363:	53                   	push   %ebx
  801364:	8b 45 08             	mov    0x8(%ebp),%eax
  801367:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80136a:	89 c6                	mov    %eax,%esi
  80136c:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80136f:	89 c2                	mov    %eax,%edx
  801371:	39 f2                	cmp    %esi,%edx
  801373:	74 11                	je     801386 <strncpy+0x27>
		*dst++ = *src;
  801375:	83 c2 01             	add    $0x1,%edx
  801378:	0f b6 19             	movzbl (%ecx),%ebx
  80137b:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80137e:	80 fb 01             	cmp    $0x1,%bl
  801381:	83 d9 ff             	sbb    $0xffffffff,%ecx
  801384:	eb eb                	jmp    801371 <strncpy+0x12>
	}
	return ret;
}
  801386:	5b                   	pop    %ebx
  801387:	5e                   	pop    %esi
  801388:	5d                   	pop    %ebp
  801389:	c3                   	ret    

0080138a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80138a:	55                   	push   %ebp
  80138b:	89 e5                	mov    %esp,%ebp
  80138d:	56                   	push   %esi
  80138e:	53                   	push   %ebx
  80138f:	8b 75 08             	mov    0x8(%ebp),%esi
  801392:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801395:	8b 55 10             	mov    0x10(%ebp),%edx
  801398:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80139a:	85 d2                	test   %edx,%edx
  80139c:	74 21                	je     8013bf <strlcpy+0x35>
  80139e:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8013a2:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8013a4:	39 c2                	cmp    %eax,%edx
  8013a6:	74 14                	je     8013bc <strlcpy+0x32>
  8013a8:	0f b6 19             	movzbl (%ecx),%ebx
  8013ab:	84 db                	test   %bl,%bl
  8013ad:	74 0b                	je     8013ba <strlcpy+0x30>
			*dst++ = *src++;
  8013af:	83 c1 01             	add    $0x1,%ecx
  8013b2:	83 c2 01             	add    $0x1,%edx
  8013b5:	88 5a ff             	mov    %bl,-0x1(%edx)
  8013b8:	eb ea                	jmp    8013a4 <strlcpy+0x1a>
  8013ba:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8013bc:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8013bf:	29 f0                	sub    %esi,%eax
}
  8013c1:	5b                   	pop    %ebx
  8013c2:	5e                   	pop    %esi
  8013c3:	5d                   	pop    %ebp
  8013c4:	c3                   	ret    

008013c5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8013c5:	55                   	push   %ebp
  8013c6:	89 e5                	mov    %esp,%ebp
  8013c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013cb:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8013ce:	0f b6 01             	movzbl (%ecx),%eax
  8013d1:	84 c0                	test   %al,%al
  8013d3:	74 0c                	je     8013e1 <strcmp+0x1c>
  8013d5:	3a 02                	cmp    (%edx),%al
  8013d7:	75 08                	jne    8013e1 <strcmp+0x1c>
		p++, q++;
  8013d9:	83 c1 01             	add    $0x1,%ecx
  8013dc:	83 c2 01             	add    $0x1,%edx
  8013df:	eb ed                	jmp    8013ce <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8013e1:	0f b6 c0             	movzbl %al,%eax
  8013e4:	0f b6 12             	movzbl (%edx),%edx
  8013e7:	29 d0                	sub    %edx,%eax
}
  8013e9:	5d                   	pop    %ebp
  8013ea:	c3                   	ret    

008013eb <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8013eb:	55                   	push   %ebp
  8013ec:	89 e5                	mov    %esp,%ebp
  8013ee:	53                   	push   %ebx
  8013ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013f5:	89 c3                	mov    %eax,%ebx
  8013f7:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8013fa:	eb 06                	jmp    801402 <strncmp+0x17>
		n--, p++, q++;
  8013fc:	83 c0 01             	add    $0x1,%eax
  8013ff:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  801402:	39 d8                	cmp    %ebx,%eax
  801404:	74 16                	je     80141c <strncmp+0x31>
  801406:	0f b6 08             	movzbl (%eax),%ecx
  801409:	84 c9                	test   %cl,%cl
  80140b:	74 04                	je     801411 <strncmp+0x26>
  80140d:	3a 0a                	cmp    (%edx),%cl
  80140f:	74 eb                	je     8013fc <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801411:	0f b6 00             	movzbl (%eax),%eax
  801414:	0f b6 12             	movzbl (%edx),%edx
  801417:	29 d0                	sub    %edx,%eax
}
  801419:	5b                   	pop    %ebx
  80141a:	5d                   	pop    %ebp
  80141b:	c3                   	ret    
		return 0;
  80141c:	b8 00 00 00 00       	mov    $0x0,%eax
  801421:	eb f6                	jmp    801419 <strncmp+0x2e>

00801423 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801423:	55                   	push   %ebp
  801424:	89 e5                	mov    %esp,%ebp
  801426:	8b 45 08             	mov    0x8(%ebp),%eax
  801429:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80142d:	0f b6 10             	movzbl (%eax),%edx
  801430:	84 d2                	test   %dl,%dl
  801432:	74 09                	je     80143d <strchr+0x1a>
		if (*s == c)
  801434:	38 ca                	cmp    %cl,%dl
  801436:	74 0a                	je     801442 <strchr+0x1f>
	for (; *s; s++)
  801438:	83 c0 01             	add    $0x1,%eax
  80143b:	eb f0                	jmp    80142d <strchr+0xa>
			return (char *) s;
	return 0;
  80143d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801442:	5d                   	pop    %ebp
  801443:	c3                   	ret    

00801444 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801444:	55                   	push   %ebp
  801445:	89 e5                	mov    %esp,%ebp
  801447:	8b 45 08             	mov    0x8(%ebp),%eax
  80144a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80144e:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801451:	38 ca                	cmp    %cl,%dl
  801453:	74 09                	je     80145e <strfind+0x1a>
  801455:	84 d2                	test   %dl,%dl
  801457:	74 05                	je     80145e <strfind+0x1a>
	for (; *s; s++)
  801459:	83 c0 01             	add    $0x1,%eax
  80145c:	eb f0                	jmp    80144e <strfind+0xa>
			break;
	return (char *) s;
}
  80145e:	5d                   	pop    %ebp
  80145f:	c3                   	ret    

00801460 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801460:	55                   	push   %ebp
  801461:	89 e5                	mov    %esp,%ebp
  801463:	57                   	push   %edi
  801464:	56                   	push   %esi
  801465:	53                   	push   %ebx
  801466:	8b 7d 08             	mov    0x8(%ebp),%edi
  801469:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80146c:	85 c9                	test   %ecx,%ecx
  80146e:	74 31                	je     8014a1 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801470:	89 f8                	mov    %edi,%eax
  801472:	09 c8                	or     %ecx,%eax
  801474:	a8 03                	test   $0x3,%al
  801476:	75 23                	jne    80149b <memset+0x3b>
		c &= 0xFF;
  801478:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80147c:	89 d3                	mov    %edx,%ebx
  80147e:	c1 e3 08             	shl    $0x8,%ebx
  801481:	89 d0                	mov    %edx,%eax
  801483:	c1 e0 18             	shl    $0x18,%eax
  801486:	89 d6                	mov    %edx,%esi
  801488:	c1 e6 10             	shl    $0x10,%esi
  80148b:	09 f0                	or     %esi,%eax
  80148d:	09 c2                	or     %eax,%edx
  80148f:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801491:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801494:	89 d0                	mov    %edx,%eax
  801496:	fc                   	cld    
  801497:	f3 ab                	rep stos %eax,%es:(%edi)
  801499:	eb 06                	jmp    8014a1 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80149b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80149e:	fc                   	cld    
  80149f:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8014a1:	89 f8                	mov    %edi,%eax
  8014a3:	5b                   	pop    %ebx
  8014a4:	5e                   	pop    %esi
  8014a5:	5f                   	pop    %edi
  8014a6:	5d                   	pop    %ebp
  8014a7:	c3                   	ret    

008014a8 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8014a8:	55                   	push   %ebp
  8014a9:	89 e5                	mov    %esp,%ebp
  8014ab:	57                   	push   %edi
  8014ac:	56                   	push   %esi
  8014ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b0:	8b 75 0c             	mov    0xc(%ebp),%esi
  8014b3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8014b6:	39 c6                	cmp    %eax,%esi
  8014b8:	73 32                	jae    8014ec <memmove+0x44>
  8014ba:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8014bd:	39 c2                	cmp    %eax,%edx
  8014bf:	76 2b                	jbe    8014ec <memmove+0x44>
		s += n;
		d += n;
  8014c1:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8014c4:	89 fe                	mov    %edi,%esi
  8014c6:	09 ce                	or     %ecx,%esi
  8014c8:	09 d6                	or     %edx,%esi
  8014ca:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8014d0:	75 0e                	jne    8014e0 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8014d2:	83 ef 04             	sub    $0x4,%edi
  8014d5:	8d 72 fc             	lea    -0x4(%edx),%esi
  8014d8:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8014db:	fd                   	std    
  8014dc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8014de:	eb 09                	jmp    8014e9 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8014e0:	83 ef 01             	sub    $0x1,%edi
  8014e3:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8014e6:	fd                   	std    
  8014e7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8014e9:	fc                   	cld    
  8014ea:	eb 1a                	jmp    801506 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8014ec:	89 c2                	mov    %eax,%edx
  8014ee:	09 ca                	or     %ecx,%edx
  8014f0:	09 f2                	or     %esi,%edx
  8014f2:	f6 c2 03             	test   $0x3,%dl
  8014f5:	75 0a                	jne    801501 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8014f7:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8014fa:	89 c7                	mov    %eax,%edi
  8014fc:	fc                   	cld    
  8014fd:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8014ff:	eb 05                	jmp    801506 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  801501:	89 c7                	mov    %eax,%edi
  801503:	fc                   	cld    
  801504:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801506:	5e                   	pop    %esi
  801507:	5f                   	pop    %edi
  801508:	5d                   	pop    %ebp
  801509:	c3                   	ret    

0080150a <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80150a:	55                   	push   %ebp
  80150b:	89 e5                	mov    %esp,%ebp
  80150d:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801510:	ff 75 10             	pushl  0x10(%ebp)
  801513:	ff 75 0c             	pushl  0xc(%ebp)
  801516:	ff 75 08             	pushl  0x8(%ebp)
  801519:	e8 8a ff ff ff       	call   8014a8 <memmove>
}
  80151e:	c9                   	leave  
  80151f:	c3                   	ret    

00801520 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801520:	55                   	push   %ebp
  801521:	89 e5                	mov    %esp,%ebp
  801523:	56                   	push   %esi
  801524:	53                   	push   %ebx
  801525:	8b 45 08             	mov    0x8(%ebp),%eax
  801528:	8b 55 0c             	mov    0xc(%ebp),%edx
  80152b:	89 c6                	mov    %eax,%esi
  80152d:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801530:	39 f0                	cmp    %esi,%eax
  801532:	74 1c                	je     801550 <memcmp+0x30>
		if (*s1 != *s2)
  801534:	0f b6 08             	movzbl (%eax),%ecx
  801537:	0f b6 1a             	movzbl (%edx),%ebx
  80153a:	38 d9                	cmp    %bl,%cl
  80153c:	75 08                	jne    801546 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  80153e:	83 c0 01             	add    $0x1,%eax
  801541:	83 c2 01             	add    $0x1,%edx
  801544:	eb ea                	jmp    801530 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  801546:	0f b6 c1             	movzbl %cl,%eax
  801549:	0f b6 db             	movzbl %bl,%ebx
  80154c:	29 d8                	sub    %ebx,%eax
  80154e:	eb 05                	jmp    801555 <memcmp+0x35>
	}

	return 0;
  801550:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801555:	5b                   	pop    %ebx
  801556:	5e                   	pop    %esi
  801557:	5d                   	pop    %ebp
  801558:	c3                   	ret    

00801559 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801559:	55                   	push   %ebp
  80155a:	89 e5                	mov    %esp,%ebp
  80155c:	8b 45 08             	mov    0x8(%ebp),%eax
  80155f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801562:	89 c2                	mov    %eax,%edx
  801564:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801567:	39 d0                	cmp    %edx,%eax
  801569:	73 09                	jae    801574 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  80156b:	38 08                	cmp    %cl,(%eax)
  80156d:	74 05                	je     801574 <memfind+0x1b>
	for (; s < ends; s++)
  80156f:	83 c0 01             	add    $0x1,%eax
  801572:	eb f3                	jmp    801567 <memfind+0xe>
			break;
	return (void *) s;
}
  801574:	5d                   	pop    %ebp
  801575:	c3                   	ret    

00801576 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801576:	55                   	push   %ebp
  801577:	89 e5                	mov    %esp,%ebp
  801579:	57                   	push   %edi
  80157a:	56                   	push   %esi
  80157b:	53                   	push   %ebx
  80157c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80157f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801582:	eb 03                	jmp    801587 <strtol+0x11>
		s++;
  801584:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801587:	0f b6 01             	movzbl (%ecx),%eax
  80158a:	3c 20                	cmp    $0x20,%al
  80158c:	74 f6                	je     801584 <strtol+0xe>
  80158e:	3c 09                	cmp    $0x9,%al
  801590:	74 f2                	je     801584 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  801592:	3c 2b                	cmp    $0x2b,%al
  801594:	74 2a                	je     8015c0 <strtol+0x4a>
	int neg = 0;
  801596:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  80159b:	3c 2d                	cmp    $0x2d,%al
  80159d:	74 2b                	je     8015ca <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80159f:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8015a5:	75 0f                	jne    8015b6 <strtol+0x40>
  8015a7:	80 39 30             	cmpb   $0x30,(%ecx)
  8015aa:	74 28                	je     8015d4 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8015ac:	85 db                	test   %ebx,%ebx
  8015ae:	b8 0a 00 00 00       	mov    $0xa,%eax
  8015b3:	0f 44 d8             	cmove  %eax,%ebx
  8015b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8015bb:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8015be:	eb 50                	jmp    801610 <strtol+0x9a>
		s++;
  8015c0:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  8015c3:	bf 00 00 00 00       	mov    $0x0,%edi
  8015c8:	eb d5                	jmp    80159f <strtol+0x29>
		s++, neg = 1;
  8015ca:	83 c1 01             	add    $0x1,%ecx
  8015cd:	bf 01 00 00 00       	mov    $0x1,%edi
  8015d2:	eb cb                	jmp    80159f <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8015d4:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8015d8:	74 0e                	je     8015e8 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  8015da:	85 db                	test   %ebx,%ebx
  8015dc:	75 d8                	jne    8015b6 <strtol+0x40>
		s++, base = 8;
  8015de:	83 c1 01             	add    $0x1,%ecx
  8015e1:	bb 08 00 00 00       	mov    $0x8,%ebx
  8015e6:	eb ce                	jmp    8015b6 <strtol+0x40>
		s += 2, base = 16;
  8015e8:	83 c1 02             	add    $0x2,%ecx
  8015eb:	bb 10 00 00 00       	mov    $0x10,%ebx
  8015f0:	eb c4                	jmp    8015b6 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  8015f2:	8d 72 9f             	lea    -0x61(%edx),%esi
  8015f5:	89 f3                	mov    %esi,%ebx
  8015f7:	80 fb 19             	cmp    $0x19,%bl
  8015fa:	77 29                	ja     801625 <strtol+0xaf>
			dig = *s - 'a' + 10;
  8015fc:	0f be d2             	movsbl %dl,%edx
  8015ff:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801602:	3b 55 10             	cmp    0x10(%ebp),%edx
  801605:	7d 30                	jge    801637 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  801607:	83 c1 01             	add    $0x1,%ecx
  80160a:	0f af 45 10          	imul   0x10(%ebp),%eax
  80160e:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801610:	0f b6 11             	movzbl (%ecx),%edx
  801613:	8d 72 d0             	lea    -0x30(%edx),%esi
  801616:	89 f3                	mov    %esi,%ebx
  801618:	80 fb 09             	cmp    $0x9,%bl
  80161b:	77 d5                	ja     8015f2 <strtol+0x7c>
			dig = *s - '0';
  80161d:	0f be d2             	movsbl %dl,%edx
  801620:	83 ea 30             	sub    $0x30,%edx
  801623:	eb dd                	jmp    801602 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  801625:	8d 72 bf             	lea    -0x41(%edx),%esi
  801628:	89 f3                	mov    %esi,%ebx
  80162a:	80 fb 19             	cmp    $0x19,%bl
  80162d:	77 08                	ja     801637 <strtol+0xc1>
			dig = *s - 'A' + 10;
  80162f:	0f be d2             	movsbl %dl,%edx
  801632:	83 ea 37             	sub    $0x37,%edx
  801635:	eb cb                	jmp    801602 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  801637:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80163b:	74 05                	je     801642 <strtol+0xcc>
		*endptr = (char *) s;
  80163d:	8b 75 0c             	mov    0xc(%ebp),%esi
  801640:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801642:	89 c2                	mov    %eax,%edx
  801644:	f7 da                	neg    %edx
  801646:	85 ff                	test   %edi,%edi
  801648:	0f 45 c2             	cmovne %edx,%eax
}
  80164b:	5b                   	pop    %ebx
  80164c:	5e                   	pop    %esi
  80164d:	5f                   	pop    %edi
  80164e:	5d                   	pop    %ebp
  80164f:	c3                   	ret    

00801650 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801650:	55                   	push   %ebp
  801651:	89 e5                	mov    %esp,%ebp
  801653:	57                   	push   %edi
  801654:	56                   	push   %esi
  801655:	53                   	push   %ebx
	asm volatile("int %1\n"
  801656:	b8 00 00 00 00       	mov    $0x0,%eax
  80165b:	8b 55 08             	mov    0x8(%ebp),%edx
  80165e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801661:	89 c3                	mov    %eax,%ebx
  801663:	89 c7                	mov    %eax,%edi
  801665:	89 c6                	mov    %eax,%esi
  801667:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  801669:	5b                   	pop    %ebx
  80166a:	5e                   	pop    %esi
  80166b:	5f                   	pop    %edi
  80166c:	5d                   	pop    %ebp
  80166d:	c3                   	ret    

0080166e <sys_cgetc>:

int
sys_cgetc(void)
{
  80166e:	55                   	push   %ebp
  80166f:	89 e5                	mov    %esp,%ebp
  801671:	57                   	push   %edi
  801672:	56                   	push   %esi
  801673:	53                   	push   %ebx
	asm volatile("int %1\n"
  801674:	ba 00 00 00 00       	mov    $0x0,%edx
  801679:	b8 01 00 00 00       	mov    $0x1,%eax
  80167e:	89 d1                	mov    %edx,%ecx
  801680:	89 d3                	mov    %edx,%ebx
  801682:	89 d7                	mov    %edx,%edi
  801684:	89 d6                	mov    %edx,%esi
  801686:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  801688:	5b                   	pop    %ebx
  801689:	5e                   	pop    %esi
  80168a:	5f                   	pop    %edi
  80168b:	5d                   	pop    %ebp
  80168c:	c3                   	ret    

0080168d <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80168d:	55                   	push   %ebp
  80168e:	89 e5                	mov    %esp,%ebp
  801690:	57                   	push   %edi
  801691:	56                   	push   %esi
  801692:	53                   	push   %ebx
  801693:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801696:	b9 00 00 00 00       	mov    $0x0,%ecx
  80169b:	8b 55 08             	mov    0x8(%ebp),%edx
  80169e:	b8 03 00 00 00       	mov    $0x3,%eax
  8016a3:	89 cb                	mov    %ecx,%ebx
  8016a5:	89 cf                	mov    %ecx,%edi
  8016a7:	89 ce                	mov    %ecx,%esi
  8016a9:	cd 30                	int    $0x30
	if (check && ret > 0)
  8016ab:	85 c0                	test   %eax,%eax
  8016ad:	7f 08                	jg     8016b7 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8016af:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016b2:	5b                   	pop    %ebx
  8016b3:	5e                   	pop    %esi
  8016b4:	5f                   	pop    %edi
  8016b5:	5d                   	pop    %ebp
  8016b6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8016b7:	83 ec 0c             	sub    $0xc,%esp
  8016ba:	50                   	push   %eax
  8016bb:	6a 03                	push   $0x3
  8016bd:	68 70 3a 80 00       	push   $0x803a70
  8016c2:	6a 4c                	push   $0x4c
  8016c4:	68 8d 3a 80 00       	push   $0x803a8d
  8016c9:	e8 5b f3 ff ff       	call   800a29 <_panic>

008016ce <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8016ce:	55                   	push   %ebp
  8016cf:	89 e5                	mov    %esp,%ebp
  8016d1:	57                   	push   %edi
  8016d2:	56                   	push   %esi
  8016d3:	53                   	push   %ebx
	asm volatile("int %1\n"
  8016d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8016d9:	b8 02 00 00 00       	mov    $0x2,%eax
  8016de:	89 d1                	mov    %edx,%ecx
  8016e0:	89 d3                	mov    %edx,%ebx
  8016e2:	89 d7                	mov    %edx,%edi
  8016e4:	89 d6                	mov    %edx,%esi
  8016e6:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8016e8:	5b                   	pop    %ebx
  8016e9:	5e                   	pop    %esi
  8016ea:	5f                   	pop    %edi
  8016eb:	5d                   	pop    %ebp
  8016ec:	c3                   	ret    

008016ed <sys_yield>:

void
sys_yield(void)
{
  8016ed:	55                   	push   %ebp
  8016ee:	89 e5                	mov    %esp,%ebp
  8016f0:	57                   	push   %edi
  8016f1:	56                   	push   %esi
  8016f2:	53                   	push   %ebx
	asm volatile("int %1\n"
  8016f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8016f8:	b8 0b 00 00 00       	mov    $0xb,%eax
  8016fd:	89 d1                	mov    %edx,%ecx
  8016ff:	89 d3                	mov    %edx,%ebx
  801701:	89 d7                	mov    %edx,%edi
  801703:	89 d6                	mov    %edx,%esi
  801705:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801707:	5b                   	pop    %ebx
  801708:	5e                   	pop    %esi
  801709:	5f                   	pop    %edi
  80170a:	5d                   	pop    %ebp
  80170b:	c3                   	ret    

0080170c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80170c:	55                   	push   %ebp
  80170d:	89 e5                	mov    %esp,%ebp
  80170f:	57                   	push   %edi
  801710:	56                   	push   %esi
  801711:	53                   	push   %ebx
  801712:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801715:	be 00 00 00 00       	mov    $0x0,%esi
  80171a:	8b 55 08             	mov    0x8(%ebp),%edx
  80171d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801720:	b8 04 00 00 00       	mov    $0x4,%eax
  801725:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801728:	89 f7                	mov    %esi,%edi
  80172a:	cd 30                	int    $0x30
	if (check && ret > 0)
  80172c:	85 c0                	test   %eax,%eax
  80172e:	7f 08                	jg     801738 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801730:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801733:	5b                   	pop    %ebx
  801734:	5e                   	pop    %esi
  801735:	5f                   	pop    %edi
  801736:	5d                   	pop    %ebp
  801737:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801738:	83 ec 0c             	sub    $0xc,%esp
  80173b:	50                   	push   %eax
  80173c:	6a 04                	push   $0x4
  80173e:	68 70 3a 80 00       	push   $0x803a70
  801743:	6a 4c                	push   $0x4c
  801745:	68 8d 3a 80 00       	push   $0x803a8d
  80174a:	e8 da f2 ff ff       	call   800a29 <_panic>

0080174f <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80174f:	55                   	push   %ebp
  801750:	89 e5                	mov    %esp,%ebp
  801752:	57                   	push   %edi
  801753:	56                   	push   %esi
  801754:	53                   	push   %ebx
  801755:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801758:	8b 55 08             	mov    0x8(%ebp),%edx
  80175b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80175e:	b8 05 00 00 00       	mov    $0x5,%eax
  801763:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801766:	8b 7d 14             	mov    0x14(%ebp),%edi
  801769:	8b 75 18             	mov    0x18(%ebp),%esi
  80176c:	cd 30                	int    $0x30
	if (check && ret > 0)
  80176e:	85 c0                	test   %eax,%eax
  801770:	7f 08                	jg     80177a <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801772:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801775:	5b                   	pop    %ebx
  801776:	5e                   	pop    %esi
  801777:	5f                   	pop    %edi
  801778:	5d                   	pop    %ebp
  801779:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80177a:	83 ec 0c             	sub    $0xc,%esp
  80177d:	50                   	push   %eax
  80177e:	6a 05                	push   $0x5
  801780:	68 70 3a 80 00       	push   $0x803a70
  801785:	6a 4c                	push   $0x4c
  801787:	68 8d 3a 80 00       	push   $0x803a8d
  80178c:	e8 98 f2 ff ff       	call   800a29 <_panic>

00801791 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801791:	55                   	push   %ebp
  801792:	89 e5                	mov    %esp,%ebp
  801794:	57                   	push   %edi
  801795:	56                   	push   %esi
  801796:	53                   	push   %ebx
  801797:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80179a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80179f:	8b 55 08             	mov    0x8(%ebp),%edx
  8017a2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017a5:	b8 06 00 00 00       	mov    $0x6,%eax
  8017aa:	89 df                	mov    %ebx,%edi
  8017ac:	89 de                	mov    %ebx,%esi
  8017ae:	cd 30                	int    $0x30
	if (check && ret > 0)
  8017b0:	85 c0                	test   %eax,%eax
  8017b2:	7f 08                	jg     8017bc <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8017b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017b7:	5b                   	pop    %ebx
  8017b8:	5e                   	pop    %esi
  8017b9:	5f                   	pop    %edi
  8017ba:	5d                   	pop    %ebp
  8017bb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8017bc:	83 ec 0c             	sub    $0xc,%esp
  8017bf:	50                   	push   %eax
  8017c0:	6a 06                	push   $0x6
  8017c2:	68 70 3a 80 00       	push   $0x803a70
  8017c7:	6a 4c                	push   $0x4c
  8017c9:	68 8d 3a 80 00       	push   $0x803a8d
  8017ce:	e8 56 f2 ff ff       	call   800a29 <_panic>

008017d3 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8017d3:	55                   	push   %ebp
  8017d4:	89 e5                	mov    %esp,%ebp
  8017d6:	57                   	push   %edi
  8017d7:	56                   	push   %esi
  8017d8:	53                   	push   %ebx
  8017d9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8017dc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8017e4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017e7:	b8 08 00 00 00       	mov    $0x8,%eax
  8017ec:	89 df                	mov    %ebx,%edi
  8017ee:	89 de                	mov    %ebx,%esi
  8017f0:	cd 30                	int    $0x30
	if (check && ret > 0)
  8017f2:	85 c0                	test   %eax,%eax
  8017f4:	7f 08                	jg     8017fe <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8017f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017f9:	5b                   	pop    %ebx
  8017fa:	5e                   	pop    %esi
  8017fb:	5f                   	pop    %edi
  8017fc:	5d                   	pop    %ebp
  8017fd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8017fe:	83 ec 0c             	sub    $0xc,%esp
  801801:	50                   	push   %eax
  801802:	6a 08                	push   $0x8
  801804:	68 70 3a 80 00       	push   $0x803a70
  801809:	6a 4c                	push   $0x4c
  80180b:	68 8d 3a 80 00       	push   $0x803a8d
  801810:	e8 14 f2 ff ff       	call   800a29 <_panic>

00801815 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801815:	55                   	push   %ebp
  801816:	89 e5                	mov    %esp,%ebp
  801818:	57                   	push   %edi
  801819:	56                   	push   %esi
  80181a:	53                   	push   %ebx
  80181b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80181e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801823:	8b 55 08             	mov    0x8(%ebp),%edx
  801826:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801829:	b8 09 00 00 00       	mov    $0x9,%eax
  80182e:	89 df                	mov    %ebx,%edi
  801830:	89 de                	mov    %ebx,%esi
  801832:	cd 30                	int    $0x30
	if (check && ret > 0)
  801834:	85 c0                	test   %eax,%eax
  801836:	7f 08                	jg     801840 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801838:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80183b:	5b                   	pop    %ebx
  80183c:	5e                   	pop    %esi
  80183d:	5f                   	pop    %edi
  80183e:	5d                   	pop    %ebp
  80183f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801840:	83 ec 0c             	sub    $0xc,%esp
  801843:	50                   	push   %eax
  801844:	6a 09                	push   $0x9
  801846:	68 70 3a 80 00       	push   $0x803a70
  80184b:	6a 4c                	push   $0x4c
  80184d:	68 8d 3a 80 00       	push   $0x803a8d
  801852:	e8 d2 f1 ff ff       	call   800a29 <_panic>

00801857 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801857:	55                   	push   %ebp
  801858:	89 e5                	mov    %esp,%ebp
  80185a:	57                   	push   %edi
  80185b:	56                   	push   %esi
  80185c:	53                   	push   %ebx
  80185d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801860:	bb 00 00 00 00       	mov    $0x0,%ebx
  801865:	8b 55 08             	mov    0x8(%ebp),%edx
  801868:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80186b:	b8 0a 00 00 00       	mov    $0xa,%eax
  801870:	89 df                	mov    %ebx,%edi
  801872:	89 de                	mov    %ebx,%esi
  801874:	cd 30                	int    $0x30
	if (check && ret > 0)
  801876:	85 c0                	test   %eax,%eax
  801878:	7f 08                	jg     801882 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80187a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80187d:	5b                   	pop    %ebx
  80187e:	5e                   	pop    %esi
  80187f:	5f                   	pop    %edi
  801880:	5d                   	pop    %ebp
  801881:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801882:	83 ec 0c             	sub    $0xc,%esp
  801885:	50                   	push   %eax
  801886:	6a 0a                	push   $0xa
  801888:	68 70 3a 80 00       	push   $0x803a70
  80188d:	6a 4c                	push   $0x4c
  80188f:	68 8d 3a 80 00       	push   $0x803a8d
  801894:	e8 90 f1 ff ff       	call   800a29 <_panic>

00801899 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801899:	55                   	push   %ebp
  80189a:	89 e5                	mov    %esp,%ebp
  80189c:	57                   	push   %edi
  80189d:	56                   	push   %esi
  80189e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80189f:	8b 55 08             	mov    0x8(%ebp),%edx
  8018a2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018a5:	b8 0c 00 00 00       	mov    $0xc,%eax
  8018aa:	be 00 00 00 00       	mov    $0x0,%esi
  8018af:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8018b2:	8b 7d 14             	mov    0x14(%ebp),%edi
  8018b5:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8018b7:	5b                   	pop    %ebx
  8018b8:	5e                   	pop    %esi
  8018b9:	5f                   	pop    %edi
  8018ba:	5d                   	pop    %ebp
  8018bb:	c3                   	ret    

008018bc <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8018bc:	55                   	push   %ebp
  8018bd:	89 e5                	mov    %esp,%ebp
  8018bf:	57                   	push   %edi
  8018c0:	56                   	push   %esi
  8018c1:	53                   	push   %ebx
  8018c2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8018c5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8018cd:	b8 0d 00 00 00       	mov    $0xd,%eax
  8018d2:	89 cb                	mov    %ecx,%ebx
  8018d4:	89 cf                	mov    %ecx,%edi
  8018d6:	89 ce                	mov    %ecx,%esi
  8018d8:	cd 30                	int    $0x30
	if (check && ret > 0)
  8018da:	85 c0                	test   %eax,%eax
  8018dc:	7f 08                	jg     8018e6 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8018de:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018e1:	5b                   	pop    %ebx
  8018e2:	5e                   	pop    %esi
  8018e3:	5f                   	pop    %edi
  8018e4:	5d                   	pop    %ebp
  8018e5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8018e6:	83 ec 0c             	sub    $0xc,%esp
  8018e9:	50                   	push   %eax
  8018ea:	6a 0d                	push   $0xd
  8018ec:	68 70 3a 80 00       	push   $0x803a70
  8018f1:	6a 4c                	push   $0x4c
  8018f3:	68 8d 3a 80 00       	push   $0x803a8d
  8018f8:	e8 2c f1 ff ff       	call   800a29 <_panic>

008018fd <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  8018fd:	55                   	push   %ebp
  8018fe:	89 e5                	mov    %esp,%ebp
  801900:	57                   	push   %edi
  801901:	56                   	push   %esi
  801902:	53                   	push   %ebx
	asm volatile("int %1\n"
  801903:	bb 00 00 00 00       	mov    $0x0,%ebx
  801908:	8b 55 08             	mov    0x8(%ebp),%edx
  80190b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80190e:	b8 0e 00 00 00       	mov    $0xe,%eax
  801913:	89 df                	mov    %ebx,%edi
  801915:	89 de                	mov    %ebx,%esi
  801917:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801919:	5b                   	pop    %ebx
  80191a:	5e                   	pop    %esi
  80191b:	5f                   	pop    %edi
  80191c:	5d                   	pop    %ebp
  80191d:	c3                   	ret    

0080191e <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  80191e:	55                   	push   %ebp
  80191f:	89 e5                	mov    %esp,%ebp
  801921:	57                   	push   %edi
  801922:	56                   	push   %esi
  801923:	53                   	push   %ebx
	asm volatile("int %1\n"
  801924:	b9 00 00 00 00       	mov    $0x0,%ecx
  801929:	8b 55 08             	mov    0x8(%ebp),%edx
  80192c:	b8 0f 00 00 00       	mov    $0xf,%eax
  801931:	89 cb                	mov    %ecx,%ebx
  801933:	89 cf                	mov    %ecx,%edi
  801935:	89 ce                	mov    %ecx,%esi
  801937:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801939:	5b                   	pop    %ebx
  80193a:	5e                   	pop    %esi
  80193b:	5f                   	pop    %edi
  80193c:	5d                   	pop    %ebp
  80193d:	c3                   	ret    

0080193e <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  80193e:	55                   	push   %ebp
  80193f:	89 e5                	mov    %esp,%ebp
  801941:	53                   	push   %ebx
  801942:	83 ec 04             	sub    $0x4,%esp
  801945:	8b 55 08             	mov    0x8(%ebp),%edx
	// cprintf("pgfault()\n");
	void *addr = (void *) utf->utf_fault_va;
  801948:	8b 02                	mov    (%edx),%eax
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(!(err & FEC_WR) || !(uvpd[PDX(addr)] & PTE_P) || !(uvpt[PGNUM(addr)] & PTE_P) || !(uvpt[PGNUM(addr)] & PTE_COW))
  80194a:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  80194e:	0f 84 9c 00 00 00    	je     8019f0 <pgfault+0xb2>
  801954:	89 c2                	mov    %eax,%edx
  801956:	c1 ea 16             	shr    $0x16,%edx
  801959:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801960:	f6 c2 01             	test   $0x1,%dl
  801963:	0f 84 87 00 00 00    	je     8019f0 <pgfault+0xb2>
  801969:	89 c2                	mov    %eax,%edx
  80196b:	c1 ea 0c             	shr    $0xc,%edx
  80196e:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801975:	f6 c1 01             	test   $0x1,%cl
  801978:	74 76                	je     8019f0 <pgfault+0xb2>
  80197a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801981:	f6 c6 08             	test   $0x8,%dh
  801984:	74 6a                	je     8019f0 <pgfault+0xb2>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  801986:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80198b:	89 c3                	mov    %eax,%ebx

	r = sys_page_alloc(0, PFTEMP, PTE_P|PTE_U|PTE_W);
  80198d:	83 ec 04             	sub    $0x4,%esp
  801990:	6a 07                	push   $0x7
  801992:	68 00 f0 7f 00       	push   $0x7ff000
  801997:	6a 00                	push   $0x0
  801999:	e8 6e fd ff ff       	call   80170c <sys_page_alloc>
	if(r < 0){
  80199e:	83 c4 10             	add    $0x10,%esp
  8019a1:	85 c0                	test   %eax,%eax
  8019a3:	78 5f                	js     801a04 <pgfault+0xc6>
		panic("pgfault: sys_page_alloc fail, r: %d", r);
	}

	memmove(PFTEMP, addr, PGSIZE);
  8019a5:	83 ec 04             	sub    $0x4,%esp
  8019a8:	68 00 10 00 00       	push   $0x1000
  8019ad:	53                   	push   %ebx
  8019ae:	68 00 f0 7f 00       	push   $0x7ff000
  8019b3:	e8 f0 fa ff ff       	call   8014a8 <memmove>

	r = sys_page_map(0, PFTEMP, 0, addr, PTE_P|PTE_U|PTE_W);
  8019b8:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  8019bf:	53                   	push   %ebx
  8019c0:	6a 00                	push   $0x0
  8019c2:	68 00 f0 7f 00       	push   $0x7ff000
  8019c7:	6a 00                	push   $0x0
  8019c9:	e8 81 fd ff ff       	call   80174f <sys_page_map>
	if(r < 0){
  8019ce:	83 c4 20             	add    $0x20,%esp
  8019d1:	85 c0                	test   %eax,%eax
  8019d3:	78 41                	js     801a16 <pgfault+0xd8>
		panic("pgfault: sys_page_map fail, r: %d", r);
	}

	r = sys_page_unmap(0, PFTEMP);
  8019d5:	83 ec 08             	sub    $0x8,%esp
  8019d8:	68 00 f0 7f 00       	push   $0x7ff000
  8019dd:	6a 00                	push   $0x0
  8019df:	e8 ad fd ff ff       	call   801791 <sys_page_unmap>
	if(r < 0){
  8019e4:	83 c4 10             	add    $0x10,%esp
  8019e7:	85 c0                	test   %eax,%eax
  8019e9:	78 3d                	js     801a28 <pgfault+0xea>
		panic("sys_page_unmap: %e", r);
	}
}
  8019eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019ee:	c9                   	leave  
  8019ef:	c3                   	ret    
		panic("pgfault: 1\n");
  8019f0:	83 ec 04             	sub    $0x4,%esp
  8019f3:	68 9b 3a 80 00       	push   $0x803a9b
  8019f8:	6a 20                	push   $0x20
  8019fa:	68 a7 3a 80 00       	push   $0x803aa7
  8019ff:	e8 25 f0 ff ff       	call   800a29 <_panic>
		panic("pgfault: sys_page_alloc fail, r: %d", r);
  801a04:	50                   	push   %eax
  801a05:	68 fc 3a 80 00       	push   $0x803afc
  801a0a:	6a 2e                	push   $0x2e
  801a0c:	68 a7 3a 80 00       	push   $0x803aa7
  801a11:	e8 13 f0 ff ff       	call   800a29 <_panic>
		panic("pgfault: sys_page_map fail, r: %d", r);
  801a16:	50                   	push   %eax
  801a17:	68 20 3b 80 00       	push   $0x803b20
  801a1c:	6a 35                	push   $0x35
  801a1e:	68 a7 3a 80 00       	push   $0x803aa7
  801a23:	e8 01 f0 ff ff       	call   800a29 <_panic>
		panic("sys_page_unmap: %e", r);
  801a28:	50                   	push   %eax
  801a29:	68 b2 3a 80 00       	push   $0x803ab2
  801a2e:	6a 3a                	push   $0x3a
  801a30:	68 a7 3a 80 00       	push   $0x803aa7
  801a35:	e8 ef ef ff ff       	call   800a29 <_panic>

00801a3a <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801a3a:	55                   	push   %ebp
  801a3b:	89 e5                	mov    %esp,%ebp
  801a3d:	57                   	push   %edi
  801a3e:	56                   	push   %esi
  801a3f:	53                   	push   %ebx
  801a40:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	// panic("fork not implemented");
	int r;
	set_pgfault_handler(pgfault);
  801a43:	68 3e 19 80 00       	push   $0x80193e
  801a48:	e8 35 16 00 00       	call   803082 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801a4d:	b8 07 00 00 00       	mov    $0x7,%eax
  801a52:	cd 30                	int    $0x30
  801a54:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int i;
	uintptr_t va;
	envid_t childid = sys_exofork();
	if (childid < 0){
  801a57:	83 c4 10             	add    $0x10,%esp
  801a5a:	85 c0                	test   %eax,%eax
  801a5c:	78 2c                	js     801a8a <fork+0x50>
  801a5e:	89 c7                	mov    %eax,%edi
	}

	extern volatile pde_t uvpd[];
	extern volatile pte_t uvpt[];

	for (va = UTEXT; va < USTACKTOP; va += PGSIZE){
  801a60:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if (childid == 0) {
  801a65:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801a69:	75 72                	jne    801add <fork+0xa3>
		thisenv = &envs[ENVX(sys_getenvid())];
  801a6b:	e8 5e fc ff ff       	call   8016ce <sys_getenvid>
  801a70:	25 ff 03 00 00       	and    $0x3ff,%eax
  801a75:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  801a7b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801a80:	a3 24 54 80 00       	mov    %eax,0x805424
		return 0;
  801a85:	e9 36 01 00 00       	jmp    801bc0 <fork+0x186>
		panic("fork: child id < 0: %d", childid);
  801a8a:	50                   	push   %eax
  801a8b:	68 c5 3a 80 00       	push   $0x803ac5
  801a90:	68 83 00 00 00       	push   $0x83
  801a95:	68 a7 3a 80 00       	push   $0x803aa7
  801a9a:	e8 8a ef ff ff       	call   800a29 <_panic>
			panic("sys_page_map: sys_page_map fail, r:%d\n", r);
  801a9f:	50                   	push   %eax
  801aa0:	68 44 3b 80 00       	push   $0x803b44
  801aa5:	6a 56                	push   $0x56
  801aa7:	68 a7 3a 80 00       	push   $0x803aa7
  801aac:	e8 78 ef ff ff       	call   800a29 <_panic>
		r = sys_page_map((envid_t)0, va, envid, va, PTE_U | PTE_P);
  801ab1:	83 ec 0c             	sub    $0xc,%esp
  801ab4:	6a 05                	push   $0x5
  801ab6:	56                   	push   %esi
  801ab7:	57                   	push   %edi
  801ab8:	56                   	push   %esi
  801ab9:	6a 00                	push   $0x0
  801abb:	e8 8f fc ff ff       	call   80174f <sys_page_map>
		if(r < 0){
  801ac0:	83 c4 20             	add    $0x20,%esp
  801ac3:	85 c0                	test   %eax,%eax
  801ac5:	0f 88 9f 00 00 00    	js     801b6a <fork+0x130>
	for (va = UTEXT; va < USTACKTOP; va += PGSIZE){
  801acb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801ad1:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801ad7:	0f 84 9f 00 00 00    	je     801b7c <fork+0x142>
		if ((uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_U)){
  801add:	89 d8                	mov    %ebx,%eax
  801adf:	c1 e8 16             	shr    $0x16,%eax
  801ae2:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801ae9:	a8 01                	test   $0x1,%al
  801aeb:	74 de                	je     801acb <fork+0x91>
  801aed:	89 d8                	mov    %ebx,%eax
  801aef:	c1 e8 0c             	shr    $0xc,%eax
  801af2:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801af9:	f6 c2 01             	test   $0x1,%dl
  801afc:	74 cd                	je     801acb <fork+0x91>
  801afe:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801b05:	f6 c2 04             	test   $0x4,%dl
  801b08:	74 c1                	je     801acb <fork+0x91>
	void * va = (void *)(pn * PGSIZE);
  801b0a:	89 c6                	mov    %eax,%esi
  801b0c:	c1 e6 0c             	shl    $0xc,%esi
	int perm = (uvpt[pn]);
  801b0f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (perm & (PTE_W | PTE_COW)) {
  801b16:	a9 02 08 00 00       	test   $0x802,%eax
  801b1b:	74 94                	je     801ab1 <fork+0x77>
		r = sys_page_map((envid_t)0, va, envid, va, PTE_U | PTE_P | PTE_COW);
  801b1d:	83 ec 0c             	sub    $0xc,%esp
  801b20:	68 05 08 00 00       	push   $0x805
  801b25:	56                   	push   %esi
  801b26:	57                   	push   %edi
  801b27:	56                   	push   %esi
  801b28:	6a 00                	push   $0x0
  801b2a:	e8 20 fc ff ff       	call   80174f <sys_page_map>
		if(r < 0){
  801b2f:	83 c4 20             	add    $0x20,%esp
  801b32:	85 c0                	test   %eax,%eax
  801b34:	0f 88 65 ff ff ff    	js     801a9f <fork+0x65>
		r = sys_page_map((envid_t)0, va, (envid_t)0, va, PTE_U | PTE_P | PTE_COW);
  801b3a:	83 ec 0c             	sub    $0xc,%esp
  801b3d:	68 05 08 00 00       	push   $0x805
  801b42:	56                   	push   %esi
  801b43:	6a 00                	push   $0x0
  801b45:	56                   	push   %esi
  801b46:	6a 00                	push   $0x0
  801b48:	e8 02 fc ff ff       	call   80174f <sys_page_map>
		if(r < 0){
  801b4d:	83 c4 20             	add    $0x20,%esp
  801b50:	85 c0                	test   %eax,%eax
  801b52:	0f 89 73 ff ff ff    	jns    801acb <fork+0x91>
			panic("sys_page_map: sys_page_map fail, r:%d\n", r);
  801b58:	50                   	push   %eax
  801b59:	68 44 3b 80 00       	push   $0x803b44
  801b5e:	6a 5b                	push   $0x5b
  801b60:	68 a7 3a 80 00       	push   $0x803aa7
  801b65:	e8 bf ee ff ff       	call   800a29 <_panic>
			panic("sys_page_map: sys_page_map fail, r:%d\n", r);
  801b6a:	50                   	push   %eax
  801b6b:	68 44 3b 80 00       	push   $0x803b44
  801b70:	6a 61                	push   $0x61
  801b72:	68 a7 3a 80 00       	push   $0x803aa7
  801b77:	e8 ad ee ff ff       	call   800a29 <_panic>
			duppage(childid, PGNUM(va));
		}
	}

	r = sys_page_alloc(childid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801b7c:	83 ec 04             	sub    $0x4,%esp
  801b7f:	6a 07                	push   $0x7
  801b81:	68 00 f0 bf ee       	push   $0xeebff000
  801b86:	ff 75 e4             	pushl  -0x1c(%ebp)
  801b89:	e8 7e fb ff ff       	call   80170c <sys_page_alloc>
	if (r < 0){
  801b8e:	83 c4 10             	add    $0x10,%esp
  801b91:	85 c0                	test   %eax,%eax
  801b93:	78 36                	js     801bcb <fork+0x191>
		panic("fork: allocate user exception stack for child env error, %d", r);
	}
	r = sys_env_set_pgfault_upcall(childid, _pgfault_upcall);
  801b95:	83 ec 08             	sub    $0x8,%esp
  801b98:	68 ed 30 80 00       	push   $0x8030ed
  801b9d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801ba0:	e8 b2 fc ff ff       	call   801857 <sys_env_set_pgfault_upcall>
	if (r < 0){
  801ba5:	83 c4 10             	add    $0x10,%esp
  801ba8:	85 c0                	test   %eax,%eax
  801baa:	78 34                	js     801be0 <fork+0x1a6>
		panic("fork: sys_env_set_pgfault_upcall error, %d", r);
	}
	r = sys_env_set_status(childid, ENV_RUNNABLE);
  801bac:	83 ec 08             	sub    $0x8,%esp
  801baf:	6a 02                	push   $0x2
  801bb1:	ff 75 e4             	pushl  -0x1c(%ebp)
  801bb4:	e8 1a fc ff ff       	call   8017d3 <sys_env_set_status>
	if(r < 0){
  801bb9:	83 c4 10             	add    $0x10,%esp
  801bbc:	85 c0                	test   %eax,%eax
  801bbe:	78 35                	js     801bf5 <fork+0x1bb>
		panic("forK: sys_env_set_status, r%d", r);
	}
	return childid;
}
  801bc0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bc3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bc6:	5b                   	pop    %ebx
  801bc7:	5e                   	pop    %esi
  801bc8:	5f                   	pop    %edi
  801bc9:	5d                   	pop    %ebp
  801bca:	c3                   	ret    
		panic("fork: allocate user exception stack for child env error, %d", r);
  801bcb:	50                   	push   %eax
  801bcc:	68 6c 3b 80 00       	push   $0x803b6c
  801bd1:	68 96 00 00 00       	push   $0x96
  801bd6:	68 a7 3a 80 00       	push   $0x803aa7
  801bdb:	e8 49 ee ff ff       	call   800a29 <_panic>
		panic("fork: sys_env_set_pgfault_upcall error, %d", r);
  801be0:	50                   	push   %eax
  801be1:	68 a8 3b 80 00       	push   $0x803ba8
  801be6:	68 9a 00 00 00       	push   $0x9a
  801beb:	68 a7 3a 80 00       	push   $0x803aa7
  801bf0:	e8 34 ee ff ff       	call   800a29 <_panic>
		panic("forK: sys_env_set_status, r%d", r);
  801bf5:	50                   	push   %eax
  801bf6:	68 dc 3a 80 00       	push   $0x803adc
  801bfb:	68 9e 00 00 00       	push   $0x9e
  801c00:	68 a7 3a 80 00       	push   $0x803aa7
  801c05:	e8 1f ee ff ff       	call   800a29 <_panic>

00801c0a <sfork>:

// Challenge!
int
sfork(void)
{
  801c0a:	55                   	push   %ebp
  801c0b:	89 e5                	mov    %esp,%ebp
  801c0d:	57                   	push   %edi
  801c0e:	56                   	push   %esi
  801c0f:	53                   	push   %ebx
  801c10:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// return -E_INVAL;
	set_pgfault_handler(pgfault);
  801c13:	68 3e 19 80 00       	push   $0x80193e
  801c18:	e8 65 14 00 00       	call   803082 <set_pgfault_handler>
  801c1d:	b8 07 00 00 00       	mov    $0x7,%eax
  801c22:	cd 30                	int    $0x30
  801c24:	89 c6                	mov    %eax,%esi
	int i;
	uintptr_t va;
	envid_t childid = sys_exofork();
	int r;
	if (childid < 0){
  801c26:	83 c4 10             	add    $0x10,%esp
  801c29:	85 c0                	test   %eax,%eax
  801c2b:	78 28                	js     801c55 <sfork+0x4b>
  801c2d:	89 c7                	mov    %eax,%edi
	}

	extern volatile pde_t uvpd[];
	extern volatile pte_t uvpt[];

	for (va = 0; va < USTACKTOP; va += PGSIZE){
  801c2f:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (childid == 0) {
  801c34:	75 42                	jne    801c78 <sfork+0x6e>
		thisenv = &envs[ENVX(sys_getenvid())];
  801c36:	e8 93 fa ff ff       	call   8016ce <sys_getenvid>
  801c3b:	25 ff 03 00 00       	and    $0x3ff,%eax
  801c40:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  801c46:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801c4b:	a3 24 54 80 00       	mov    %eax,0x805424
		return 0;
  801c50:	e9 bc 00 00 00       	jmp    801d11 <sfork+0x107>
		panic("fork: child id < 0: %d", childid);
  801c55:	50                   	push   %eax
  801c56:	68 c5 3a 80 00       	push   $0x803ac5
  801c5b:	68 af 00 00 00       	push   $0xaf
  801c60:	68 a7 3a 80 00       	push   $0x803aa7
  801c65:	e8 bf ed ff ff       	call   800a29 <_panic>
	for (va = 0; va < USTACKTOP; va += PGSIZE){
  801c6a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801c70:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801c76:	74 5b                	je     801cd3 <sfork+0xc9>
		if ((uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_U)){
  801c78:	89 d8                	mov    %ebx,%eax
  801c7a:	c1 e8 16             	shr    $0x16,%eax
  801c7d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801c84:	a8 01                	test   $0x1,%al
  801c86:	74 e2                	je     801c6a <sfork+0x60>
  801c88:	89 d8                	mov    %ebx,%eax
  801c8a:	c1 e8 0c             	shr    $0xc,%eax
  801c8d:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801c94:	f6 c2 01             	test   $0x1,%dl
  801c97:	74 d1                	je     801c6a <sfork+0x60>
  801c99:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801ca0:	f6 c2 04             	test   $0x4,%dl
  801ca3:	74 c5                	je     801c6a <sfork+0x60>
			void *addr = (void *)(PGNUM(va) * PGSIZE);
  801ca5:	c1 e0 0c             	shl    $0xc,%eax
			struct PageInfo *page;
			pte_t *pte;
			
			// page = page_lookup((envid_t)0->env_pgdir, addr, &pte);
			// page_insert(dstenv->env_pgdir, page, addr, PTE_U | PTE_P);
			r = sys_page_map((envid_t)0, addr, childid, addr, PTE_U | PTE_P);
  801ca8:	83 ec 0c             	sub    $0xc,%esp
  801cab:	6a 05                	push   $0x5
  801cad:	50                   	push   %eax
  801cae:	57                   	push   %edi
  801caf:	50                   	push   %eax
  801cb0:	6a 00                	push   $0x0
  801cb2:	e8 98 fa ff ff       	call   80174f <sys_page_map>
			if(r < 0){
  801cb7:	83 c4 20             	add    $0x20,%esp
  801cba:	85 c0                	test   %eax,%eax
  801cbc:	79 ac                	jns    801c6a <sfork+0x60>
				panic("sfork: sys_page_map fail, r:%d\n", r);
  801cbe:	50                   	push   %eax
  801cbf:	68 d4 3b 80 00       	push   $0x803bd4
  801cc4:	68 c4 00 00 00       	push   $0xc4
  801cc9:	68 a7 3a 80 00       	push   $0x803aa7
  801cce:	e8 56 ed ff ff       	call   800a29 <_panic>
			}
		}
	}

	r = sys_page_alloc(childid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801cd3:	83 ec 04             	sub    $0x4,%esp
  801cd6:	6a 07                	push   $0x7
  801cd8:	68 00 f0 bf ee       	push   $0xeebff000
  801cdd:	56                   	push   %esi
  801cde:	e8 29 fa ff ff       	call   80170c <sys_page_alloc>
	if (r < 0){
  801ce3:	83 c4 10             	add    $0x10,%esp
  801ce6:	85 c0                	test   %eax,%eax
  801ce8:	78 31                	js     801d1b <sfork+0x111>
		panic("sfork: allocate user exception stack for child env error, %d", r);
	}
	r = sys_env_set_pgfault_upcall(childid, _pgfault_upcall);
  801cea:	83 ec 08             	sub    $0x8,%esp
  801ced:	68 ed 30 80 00       	push   $0x8030ed
  801cf2:	56                   	push   %esi
  801cf3:	e8 5f fb ff ff       	call   801857 <sys_env_set_pgfault_upcall>
	if (r < 0){
  801cf8:	83 c4 10             	add    $0x10,%esp
  801cfb:	85 c0                	test   %eax,%eax
  801cfd:	78 31                	js     801d30 <sfork+0x126>
		panic("sfork: sys_env_set_pgfault_upcall error, %d", r);
	}
	r = sys_env_set_status(childid, ENV_RUNNABLE);
  801cff:	83 ec 08             	sub    $0x8,%esp
  801d02:	6a 02                	push   $0x2
  801d04:	56                   	push   %esi
  801d05:	e8 c9 fa ff ff       	call   8017d3 <sys_env_set_status>
	if(r < 0){
  801d0a:	83 c4 10             	add    $0x10,%esp
  801d0d:	85 c0                	test   %eax,%eax
  801d0f:	78 34                	js     801d45 <sfork+0x13b>
		panic("sforK: sys_env_set_status, r%d", r);
	}
	return childid;
}
  801d11:	89 f0                	mov    %esi,%eax
  801d13:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d16:	5b                   	pop    %ebx
  801d17:	5e                   	pop    %esi
  801d18:	5f                   	pop    %edi
  801d19:	5d                   	pop    %ebp
  801d1a:	c3                   	ret    
		panic("sfork: allocate user exception stack for child env error, %d", r);
  801d1b:	50                   	push   %eax
  801d1c:	68 f4 3b 80 00       	push   $0x803bf4
  801d21:	68 cb 00 00 00       	push   $0xcb
  801d26:	68 a7 3a 80 00       	push   $0x803aa7
  801d2b:	e8 f9 ec ff ff       	call   800a29 <_panic>
		panic("sfork: sys_env_set_pgfault_upcall error, %d", r);
  801d30:	50                   	push   %eax
  801d31:	68 34 3c 80 00       	push   $0x803c34
  801d36:	68 cf 00 00 00       	push   $0xcf
  801d3b:	68 a7 3a 80 00       	push   $0x803aa7
  801d40:	e8 e4 ec ff ff       	call   800a29 <_panic>
		panic("sforK: sys_env_set_status, r%d", r);
  801d45:	50                   	push   %eax
  801d46:	68 60 3c 80 00       	push   $0x803c60
  801d4b:	68 d3 00 00 00       	push   $0xd3
  801d50:	68 a7 3a 80 00       	push   $0x803aa7
  801d55:	e8 cf ec ff ff       	call   800a29 <_panic>

00801d5a <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  801d5a:	55                   	push   %ebp
  801d5b:	89 e5                	mov    %esp,%ebp
  801d5d:	8b 55 08             	mov    0x8(%ebp),%edx
  801d60:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d63:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  801d66:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  801d68:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  801d6b:	83 3a 01             	cmpl   $0x1,(%edx)
  801d6e:	7e 09                	jle    801d79 <argstart+0x1f>
  801d70:	ba c1 34 80 00       	mov    $0x8034c1,%edx
  801d75:	85 c9                	test   %ecx,%ecx
  801d77:	75 05                	jne    801d7e <argstart+0x24>
  801d79:	ba 00 00 00 00       	mov    $0x0,%edx
  801d7e:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  801d81:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  801d88:	5d                   	pop    %ebp
  801d89:	c3                   	ret    

00801d8a <argnext>:

int
argnext(struct Argstate *args)
{
  801d8a:	55                   	push   %ebp
  801d8b:	89 e5                	mov    %esp,%ebp
  801d8d:	53                   	push   %ebx
  801d8e:	83 ec 04             	sub    $0x4,%esp
  801d91:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  801d94:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  801d9b:	8b 43 08             	mov    0x8(%ebx),%eax
  801d9e:	85 c0                	test   %eax,%eax
  801da0:	74 72                	je     801e14 <argnext+0x8a>
		return -1;

	if (!*args->curarg) {
  801da2:	80 38 00             	cmpb   $0x0,(%eax)
  801da5:	75 48                	jne    801def <argnext+0x65>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  801da7:	8b 0b                	mov    (%ebx),%ecx
  801da9:	83 39 01             	cmpl   $0x1,(%ecx)
  801dac:	74 58                	je     801e06 <argnext+0x7c>
		    || args->argv[1][0] != '-'
  801dae:	8b 53 04             	mov    0x4(%ebx),%edx
  801db1:	8b 42 04             	mov    0x4(%edx),%eax
  801db4:	80 38 2d             	cmpb   $0x2d,(%eax)
  801db7:	75 4d                	jne    801e06 <argnext+0x7c>
		    || args->argv[1][1] == '\0')
  801db9:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801dbd:	74 47                	je     801e06 <argnext+0x7c>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  801dbf:	83 c0 01             	add    $0x1,%eax
  801dc2:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801dc5:	83 ec 04             	sub    $0x4,%esp
  801dc8:	8b 01                	mov    (%ecx),%eax
  801dca:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  801dd1:	50                   	push   %eax
  801dd2:	8d 42 08             	lea    0x8(%edx),%eax
  801dd5:	50                   	push   %eax
  801dd6:	83 c2 04             	add    $0x4,%edx
  801dd9:	52                   	push   %edx
  801dda:	e8 c9 f6 ff ff       	call   8014a8 <memmove>
		(*args->argc)--;
  801ddf:	8b 03                	mov    (%ebx),%eax
  801de1:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801de4:	8b 43 08             	mov    0x8(%ebx),%eax
  801de7:	83 c4 10             	add    $0x10,%esp
  801dea:	80 38 2d             	cmpb   $0x2d,(%eax)
  801ded:	74 11                	je     801e00 <argnext+0x76>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  801def:	8b 53 08             	mov    0x8(%ebx),%edx
  801df2:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  801df5:	83 c2 01             	add    $0x1,%edx
  801df8:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  801dfb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dfe:	c9                   	leave  
  801dff:	c3                   	ret    
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801e00:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801e04:	75 e9                	jne    801def <argnext+0x65>
	args->curarg = 0;
  801e06:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  801e0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801e12:	eb e7                	jmp    801dfb <argnext+0x71>
		return -1;
  801e14:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801e19:	eb e0                	jmp    801dfb <argnext+0x71>

00801e1b <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  801e1b:	55                   	push   %ebp
  801e1c:	89 e5                	mov    %esp,%ebp
  801e1e:	53                   	push   %ebx
  801e1f:	83 ec 04             	sub    $0x4,%esp
  801e22:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  801e25:	8b 43 08             	mov    0x8(%ebx),%eax
  801e28:	85 c0                	test   %eax,%eax
  801e2a:	74 5b                	je     801e87 <argnextvalue+0x6c>
		return 0;
	if (*args->curarg) {
  801e2c:	80 38 00             	cmpb   $0x0,(%eax)
  801e2f:	74 12                	je     801e43 <argnextvalue+0x28>
		args->argvalue = args->curarg;
  801e31:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  801e34:	c7 43 08 c1 34 80 00 	movl   $0x8034c1,0x8(%ebx)
		(*args->argc)--;
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
  801e3b:	8b 43 0c             	mov    0xc(%ebx),%eax
}
  801e3e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e41:	c9                   	leave  
  801e42:	c3                   	ret    
	} else if (*args->argc > 1) {
  801e43:	8b 13                	mov    (%ebx),%edx
  801e45:	83 3a 01             	cmpl   $0x1,(%edx)
  801e48:	7f 10                	jg     801e5a <argnextvalue+0x3f>
		args->argvalue = 0;
  801e4a:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  801e51:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  801e58:	eb e1                	jmp    801e3b <argnextvalue+0x20>
		args->argvalue = args->argv[1];
  801e5a:	8b 43 04             	mov    0x4(%ebx),%eax
  801e5d:	8b 48 04             	mov    0x4(%eax),%ecx
  801e60:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801e63:	83 ec 04             	sub    $0x4,%esp
  801e66:	8b 12                	mov    (%edx),%edx
  801e68:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  801e6f:	52                   	push   %edx
  801e70:	8d 50 08             	lea    0x8(%eax),%edx
  801e73:	52                   	push   %edx
  801e74:	83 c0 04             	add    $0x4,%eax
  801e77:	50                   	push   %eax
  801e78:	e8 2b f6 ff ff       	call   8014a8 <memmove>
		(*args->argc)--;
  801e7d:	8b 03                	mov    (%ebx),%eax
  801e7f:	83 28 01             	subl   $0x1,(%eax)
  801e82:	83 c4 10             	add    $0x10,%esp
  801e85:	eb b4                	jmp    801e3b <argnextvalue+0x20>
		return 0;
  801e87:	b8 00 00 00 00       	mov    $0x0,%eax
  801e8c:	eb b0                	jmp    801e3e <argnextvalue+0x23>

00801e8e <argvalue>:
{
  801e8e:	55                   	push   %ebp
  801e8f:	89 e5                	mov    %esp,%ebp
  801e91:	83 ec 08             	sub    $0x8,%esp
  801e94:	8b 55 08             	mov    0x8(%ebp),%edx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801e97:	8b 42 0c             	mov    0xc(%edx),%eax
  801e9a:	85 c0                	test   %eax,%eax
  801e9c:	74 02                	je     801ea0 <argvalue+0x12>
}
  801e9e:	c9                   	leave  
  801e9f:	c3                   	ret    
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801ea0:	83 ec 0c             	sub    $0xc,%esp
  801ea3:	52                   	push   %edx
  801ea4:	e8 72 ff ff ff       	call   801e1b <argnextvalue>
  801ea9:	83 c4 10             	add    $0x10,%esp
  801eac:	eb f0                	jmp    801e9e <argvalue+0x10>

00801eae <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801eae:	55                   	push   %ebp
  801eaf:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb4:	05 00 00 00 30       	add    $0x30000000,%eax
  801eb9:	c1 e8 0c             	shr    $0xc,%eax
}
  801ebc:	5d                   	pop    %ebp
  801ebd:	c3                   	ret    

00801ebe <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801ebe:	55                   	push   %ebp
  801ebf:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801ec1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec4:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801ec9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801ece:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801ed3:	5d                   	pop    %ebp
  801ed4:	c3                   	ret    

00801ed5 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801ed5:	55                   	push   %ebp
  801ed6:	89 e5                	mov    %esp,%ebp
  801ed8:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801edd:	89 c2                	mov    %eax,%edx
  801edf:	c1 ea 16             	shr    $0x16,%edx
  801ee2:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801ee9:	f6 c2 01             	test   $0x1,%dl
  801eec:	74 2d                	je     801f1b <fd_alloc+0x46>
  801eee:	89 c2                	mov    %eax,%edx
  801ef0:	c1 ea 0c             	shr    $0xc,%edx
  801ef3:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801efa:	f6 c2 01             	test   $0x1,%dl
  801efd:	74 1c                	je     801f1b <fd_alloc+0x46>
  801eff:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801f04:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801f09:	75 d2                	jne    801edd <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801f14:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801f19:	eb 0a                	jmp    801f25 <fd_alloc+0x50>
			*fd_store = fd;
  801f1b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f1e:	89 01                	mov    %eax,(%ecx)
			return 0;
  801f20:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f25:	5d                   	pop    %ebp
  801f26:	c3                   	ret    

00801f27 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801f27:	55                   	push   %ebp
  801f28:	89 e5                	mov    %esp,%ebp
  801f2a:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801f2d:	83 f8 1f             	cmp    $0x1f,%eax
  801f30:	77 30                	ja     801f62 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801f32:	c1 e0 0c             	shl    $0xc,%eax
  801f35:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801f3a:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801f40:	f6 c2 01             	test   $0x1,%dl
  801f43:	74 24                	je     801f69 <fd_lookup+0x42>
  801f45:	89 c2                	mov    %eax,%edx
  801f47:	c1 ea 0c             	shr    $0xc,%edx
  801f4a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801f51:	f6 c2 01             	test   $0x1,%dl
  801f54:	74 1a                	je     801f70 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801f56:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f59:	89 02                	mov    %eax,(%edx)
	return 0;
  801f5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f60:	5d                   	pop    %ebp
  801f61:	c3                   	ret    
		return -E_INVAL;
  801f62:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f67:	eb f7                	jmp    801f60 <fd_lookup+0x39>
		return -E_INVAL;
  801f69:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f6e:	eb f0                	jmp    801f60 <fd_lookup+0x39>
  801f70:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f75:	eb e9                	jmp    801f60 <fd_lookup+0x39>

00801f77 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801f77:	55                   	push   %ebp
  801f78:	89 e5                	mov    %esp,%ebp
  801f7a:	83 ec 08             	sub    $0x8,%esp
  801f7d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f80:	ba fc 3c 80 00       	mov    $0x803cfc,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801f85:	b8 20 40 80 00       	mov    $0x804020,%eax
		if (devtab[i]->dev_id == dev_id) {
  801f8a:	39 08                	cmp    %ecx,(%eax)
  801f8c:	74 33                	je     801fc1 <dev_lookup+0x4a>
  801f8e:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801f91:	8b 02                	mov    (%edx),%eax
  801f93:	85 c0                	test   %eax,%eax
  801f95:	75 f3                	jne    801f8a <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801f97:	a1 24 54 80 00       	mov    0x805424,%eax
  801f9c:	8b 40 48             	mov    0x48(%eax),%eax
  801f9f:	83 ec 04             	sub    $0x4,%esp
  801fa2:	51                   	push   %ecx
  801fa3:	50                   	push   %eax
  801fa4:	68 80 3c 80 00       	push   $0x803c80
  801fa9:	e8 56 eb ff ff       	call   800b04 <cprintf>
	*dev = 0;
  801fae:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fb1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801fb7:	83 c4 10             	add    $0x10,%esp
  801fba:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801fbf:	c9                   	leave  
  801fc0:	c3                   	ret    
			*dev = devtab[i];
  801fc1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801fc4:	89 01                	mov    %eax,(%ecx)
			return 0;
  801fc6:	b8 00 00 00 00       	mov    $0x0,%eax
  801fcb:	eb f2                	jmp    801fbf <dev_lookup+0x48>

00801fcd <fd_close>:
{
  801fcd:	55                   	push   %ebp
  801fce:	89 e5                	mov    %esp,%ebp
  801fd0:	57                   	push   %edi
  801fd1:	56                   	push   %esi
  801fd2:	53                   	push   %ebx
  801fd3:	83 ec 24             	sub    $0x24,%esp
  801fd6:	8b 75 08             	mov    0x8(%ebp),%esi
  801fd9:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801fdc:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801fdf:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801fe0:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801fe6:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801fe9:	50                   	push   %eax
  801fea:	e8 38 ff ff ff       	call   801f27 <fd_lookup>
  801fef:	89 c3                	mov    %eax,%ebx
  801ff1:	83 c4 10             	add    $0x10,%esp
  801ff4:	85 c0                	test   %eax,%eax
  801ff6:	78 05                	js     801ffd <fd_close+0x30>
	    || fd != fd2)
  801ff8:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801ffb:	74 16                	je     802013 <fd_close+0x46>
		return (must_exist ? r : 0);
  801ffd:	89 f8                	mov    %edi,%eax
  801fff:	84 c0                	test   %al,%al
  802001:	b8 00 00 00 00       	mov    $0x0,%eax
  802006:	0f 44 d8             	cmove  %eax,%ebx
}
  802009:	89 d8                	mov    %ebx,%eax
  80200b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80200e:	5b                   	pop    %ebx
  80200f:	5e                   	pop    %esi
  802010:	5f                   	pop    %edi
  802011:	5d                   	pop    %ebp
  802012:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802013:	83 ec 08             	sub    $0x8,%esp
  802016:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802019:	50                   	push   %eax
  80201a:	ff 36                	pushl  (%esi)
  80201c:	e8 56 ff ff ff       	call   801f77 <dev_lookup>
  802021:	89 c3                	mov    %eax,%ebx
  802023:	83 c4 10             	add    $0x10,%esp
  802026:	85 c0                	test   %eax,%eax
  802028:	78 1a                	js     802044 <fd_close+0x77>
		if (dev->dev_close)
  80202a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80202d:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  802030:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  802035:	85 c0                	test   %eax,%eax
  802037:	74 0b                	je     802044 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  802039:	83 ec 0c             	sub    $0xc,%esp
  80203c:	56                   	push   %esi
  80203d:	ff d0                	call   *%eax
  80203f:	89 c3                	mov    %eax,%ebx
  802041:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  802044:	83 ec 08             	sub    $0x8,%esp
  802047:	56                   	push   %esi
  802048:	6a 00                	push   $0x0
  80204a:	e8 42 f7 ff ff       	call   801791 <sys_page_unmap>
	return r;
  80204f:	83 c4 10             	add    $0x10,%esp
  802052:	eb b5                	jmp    802009 <fd_close+0x3c>

00802054 <close>:

int
close(int fdnum)
{
  802054:	55                   	push   %ebp
  802055:	89 e5                	mov    %esp,%ebp
  802057:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80205a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80205d:	50                   	push   %eax
  80205e:	ff 75 08             	pushl  0x8(%ebp)
  802061:	e8 c1 fe ff ff       	call   801f27 <fd_lookup>
  802066:	83 c4 10             	add    $0x10,%esp
  802069:	85 c0                	test   %eax,%eax
  80206b:	79 02                	jns    80206f <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80206d:	c9                   	leave  
  80206e:	c3                   	ret    
		return fd_close(fd, 1);
  80206f:	83 ec 08             	sub    $0x8,%esp
  802072:	6a 01                	push   $0x1
  802074:	ff 75 f4             	pushl  -0xc(%ebp)
  802077:	e8 51 ff ff ff       	call   801fcd <fd_close>
  80207c:	83 c4 10             	add    $0x10,%esp
  80207f:	eb ec                	jmp    80206d <close+0x19>

00802081 <close_all>:

void
close_all(void)
{
  802081:	55                   	push   %ebp
  802082:	89 e5                	mov    %esp,%ebp
  802084:	53                   	push   %ebx
  802085:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  802088:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80208d:	83 ec 0c             	sub    $0xc,%esp
  802090:	53                   	push   %ebx
  802091:	e8 be ff ff ff       	call   802054 <close>
	for (i = 0; i < MAXFD; i++)
  802096:	83 c3 01             	add    $0x1,%ebx
  802099:	83 c4 10             	add    $0x10,%esp
  80209c:	83 fb 20             	cmp    $0x20,%ebx
  80209f:	75 ec                	jne    80208d <close_all+0xc>
}
  8020a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020a4:	c9                   	leave  
  8020a5:	c3                   	ret    

008020a6 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8020a6:	55                   	push   %ebp
  8020a7:	89 e5                	mov    %esp,%ebp
  8020a9:	57                   	push   %edi
  8020aa:	56                   	push   %esi
  8020ab:	53                   	push   %ebx
  8020ac:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8020af:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8020b2:	50                   	push   %eax
  8020b3:	ff 75 08             	pushl  0x8(%ebp)
  8020b6:	e8 6c fe ff ff       	call   801f27 <fd_lookup>
  8020bb:	89 c3                	mov    %eax,%ebx
  8020bd:	83 c4 10             	add    $0x10,%esp
  8020c0:	85 c0                	test   %eax,%eax
  8020c2:	0f 88 81 00 00 00    	js     802149 <dup+0xa3>
		return r;
	close(newfdnum);
  8020c8:	83 ec 0c             	sub    $0xc,%esp
  8020cb:	ff 75 0c             	pushl  0xc(%ebp)
  8020ce:	e8 81 ff ff ff       	call   802054 <close>

	newfd = INDEX2FD(newfdnum);
  8020d3:	8b 75 0c             	mov    0xc(%ebp),%esi
  8020d6:	c1 e6 0c             	shl    $0xc,%esi
  8020d9:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8020df:	83 c4 04             	add    $0x4,%esp
  8020e2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8020e5:	e8 d4 fd ff ff       	call   801ebe <fd2data>
  8020ea:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8020ec:	89 34 24             	mov    %esi,(%esp)
  8020ef:	e8 ca fd ff ff       	call   801ebe <fd2data>
  8020f4:	83 c4 10             	add    $0x10,%esp
  8020f7:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8020f9:	89 d8                	mov    %ebx,%eax
  8020fb:	c1 e8 16             	shr    $0x16,%eax
  8020fe:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802105:	a8 01                	test   $0x1,%al
  802107:	74 11                	je     80211a <dup+0x74>
  802109:	89 d8                	mov    %ebx,%eax
  80210b:	c1 e8 0c             	shr    $0xc,%eax
  80210e:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  802115:	f6 c2 01             	test   $0x1,%dl
  802118:	75 39                	jne    802153 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80211a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80211d:	89 d0                	mov    %edx,%eax
  80211f:	c1 e8 0c             	shr    $0xc,%eax
  802122:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802129:	83 ec 0c             	sub    $0xc,%esp
  80212c:	25 07 0e 00 00       	and    $0xe07,%eax
  802131:	50                   	push   %eax
  802132:	56                   	push   %esi
  802133:	6a 00                	push   $0x0
  802135:	52                   	push   %edx
  802136:	6a 00                	push   $0x0
  802138:	e8 12 f6 ff ff       	call   80174f <sys_page_map>
  80213d:	89 c3                	mov    %eax,%ebx
  80213f:	83 c4 20             	add    $0x20,%esp
  802142:	85 c0                	test   %eax,%eax
  802144:	78 31                	js     802177 <dup+0xd1>
		goto err;

	return newfdnum;
  802146:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  802149:	89 d8                	mov    %ebx,%eax
  80214b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80214e:	5b                   	pop    %ebx
  80214f:	5e                   	pop    %esi
  802150:	5f                   	pop    %edi
  802151:	5d                   	pop    %ebp
  802152:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802153:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80215a:	83 ec 0c             	sub    $0xc,%esp
  80215d:	25 07 0e 00 00       	and    $0xe07,%eax
  802162:	50                   	push   %eax
  802163:	57                   	push   %edi
  802164:	6a 00                	push   $0x0
  802166:	53                   	push   %ebx
  802167:	6a 00                	push   $0x0
  802169:	e8 e1 f5 ff ff       	call   80174f <sys_page_map>
  80216e:	89 c3                	mov    %eax,%ebx
  802170:	83 c4 20             	add    $0x20,%esp
  802173:	85 c0                	test   %eax,%eax
  802175:	79 a3                	jns    80211a <dup+0x74>
	sys_page_unmap(0, newfd);
  802177:	83 ec 08             	sub    $0x8,%esp
  80217a:	56                   	push   %esi
  80217b:	6a 00                	push   $0x0
  80217d:	e8 0f f6 ff ff       	call   801791 <sys_page_unmap>
	sys_page_unmap(0, nva);
  802182:	83 c4 08             	add    $0x8,%esp
  802185:	57                   	push   %edi
  802186:	6a 00                	push   $0x0
  802188:	e8 04 f6 ff ff       	call   801791 <sys_page_unmap>
	return r;
  80218d:	83 c4 10             	add    $0x10,%esp
  802190:	eb b7                	jmp    802149 <dup+0xa3>

00802192 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802192:	55                   	push   %ebp
  802193:	89 e5                	mov    %esp,%ebp
  802195:	53                   	push   %ebx
  802196:	83 ec 1c             	sub    $0x1c,%esp
  802199:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80219c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80219f:	50                   	push   %eax
  8021a0:	53                   	push   %ebx
  8021a1:	e8 81 fd ff ff       	call   801f27 <fd_lookup>
  8021a6:	83 c4 10             	add    $0x10,%esp
  8021a9:	85 c0                	test   %eax,%eax
  8021ab:	78 3f                	js     8021ec <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8021ad:	83 ec 08             	sub    $0x8,%esp
  8021b0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021b3:	50                   	push   %eax
  8021b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021b7:	ff 30                	pushl  (%eax)
  8021b9:	e8 b9 fd ff ff       	call   801f77 <dev_lookup>
  8021be:	83 c4 10             	add    $0x10,%esp
  8021c1:	85 c0                	test   %eax,%eax
  8021c3:	78 27                	js     8021ec <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8021c5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021c8:	8b 42 08             	mov    0x8(%edx),%eax
  8021cb:	83 e0 03             	and    $0x3,%eax
  8021ce:	83 f8 01             	cmp    $0x1,%eax
  8021d1:	74 1e                	je     8021f1 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8021d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d6:	8b 40 08             	mov    0x8(%eax),%eax
  8021d9:	85 c0                	test   %eax,%eax
  8021db:	74 35                	je     802212 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8021dd:	83 ec 04             	sub    $0x4,%esp
  8021e0:	ff 75 10             	pushl  0x10(%ebp)
  8021e3:	ff 75 0c             	pushl  0xc(%ebp)
  8021e6:	52                   	push   %edx
  8021e7:	ff d0                	call   *%eax
  8021e9:	83 c4 10             	add    $0x10,%esp
}
  8021ec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021ef:	c9                   	leave  
  8021f0:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8021f1:	a1 24 54 80 00       	mov    0x805424,%eax
  8021f6:	8b 40 48             	mov    0x48(%eax),%eax
  8021f9:	83 ec 04             	sub    $0x4,%esp
  8021fc:	53                   	push   %ebx
  8021fd:	50                   	push   %eax
  8021fe:	68 c1 3c 80 00       	push   $0x803cc1
  802203:	e8 fc e8 ff ff       	call   800b04 <cprintf>
		return -E_INVAL;
  802208:	83 c4 10             	add    $0x10,%esp
  80220b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802210:	eb da                	jmp    8021ec <read+0x5a>
		return -E_NOT_SUPP;
  802212:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802217:	eb d3                	jmp    8021ec <read+0x5a>

00802219 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802219:	55                   	push   %ebp
  80221a:	89 e5                	mov    %esp,%ebp
  80221c:	57                   	push   %edi
  80221d:	56                   	push   %esi
  80221e:	53                   	push   %ebx
  80221f:	83 ec 0c             	sub    $0xc,%esp
  802222:	8b 7d 08             	mov    0x8(%ebp),%edi
  802225:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802228:	bb 00 00 00 00       	mov    $0x0,%ebx
  80222d:	39 f3                	cmp    %esi,%ebx
  80222f:	73 23                	jae    802254 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802231:	83 ec 04             	sub    $0x4,%esp
  802234:	89 f0                	mov    %esi,%eax
  802236:	29 d8                	sub    %ebx,%eax
  802238:	50                   	push   %eax
  802239:	89 d8                	mov    %ebx,%eax
  80223b:	03 45 0c             	add    0xc(%ebp),%eax
  80223e:	50                   	push   %eax
  80223f:	57                   	push   %edi
  802240:	e8 4d ff ff ff       	call   802192 <read>
		if (m < 0)
  802245:	83 c4 10             	add    $0x10,%esp
  802248:	85 c0                	test   %eax,%eax
  80224a:	78 06                	js     802252 <readn+0x39>
			return m;
		if (m == 0)
  80224c:	74 06                	je     802254 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  80224e:	01 c3                	add    %eax,%ebx
  802250:	eb db                	jmp    80222d <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802252:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  802254:	89 d8                	mov    %ebx,%eax
  802256:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802259:	5b                   	pop    %ebx
  80225a:	5e                   	pop    %esi
  80225b:	5f                   	pop    %edi
  80225c:	5d                   	pop    %ebp
  80225d:	c3                   	ret    

0080225e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80225e:	55                   	push   %ebp
  80225f:	89 e5                	mov    %esp,%ebp
  802261:	53                   	push   %ebx
  802262:	83 ec 1c             	sub    $0x1c,%esp
  802265:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802268:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80226b:	50                   	push   %eax
  80226c:	53                   	push   %ebx
  80226d:	e8 b5 fc ff ff       	call   801f27 <fd_lookup>
  802272:	83 c4 10             	add    $0x10,%esp
  802275:	85 c0                	test   %eax,%eax
  802277:	78 3a                	js     8022b3 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802279:	83 ec 08             	sub    $0x8,%esp
  80227c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80227f:	50                   	push   %eax
  802280:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802283:	ff 30                	pushl  (%eax)
  802285:	e8 ed fc ff ff       	call   801f77 <dev_lookup>
  80228a:	83 c4 10             	add    $0x10,%esp
  80228d:	85 c0                	test   %eax,%eax
  80228f:	78 22                	js     8022b3 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802291:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802294:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  802298:	74 1e                	je     8022b8 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80229a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80229d:	8b 52 0c             	mov    0xc(%edx),%edx
  8022a0:	85 d2                	test   %edx,%edx
  8022a2:	74 35                	je     8022d9 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8022a4:	83 ec 04             	sub    $0x4,%esp
  8022a7:	ff 75 10             	pushl  0x10(%ebp)
  8022aa:	ff 75 0c             	pushl  0xc(%ebp)
  8022ad:	50                   	push   %eax
  8022ae:	ff d2                	call   *%edx
  8022b0:	83 c4 10             	add    $0x10,%esp
}
  8022b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022b6:	c9                   	leave  
  8022b7:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8022b8:	a1 24 54 80 00       	mov    0x805424,%eax
  8022bd:	8b 40 48             	mov    0x48(%eax),%eax
  8022c0:	83 ec 04             	sub    $0x4,%esp
  8022c3:	53                   	push   %ebx
  8022c4:	50                   	push   %eax
  8022c5:	68 dd 3c 80 00       	push   $0x803cdd
  8022ca:	e8 35 e8 ff ff       	call   800b04 <cprintf>
		return -E_INVAL;
  8022cf:	83 c4 10             	add    $0x10,%esp
  8022d2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8022d7:	eb da                	jmp    8022b3 <write+0x55>
		return -E_NOT_SUPP;
  8022d9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8022de:	eb d3                	jmp    8022b3 <write+0x55>

008022e0 <seek>:

int
seek(int fdnum, off_t offset)
{
  8022e0:	55                   	push   %ebp
  8022e1:	89 e5                	mov    %esp,%ebp
  8022e3:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8022e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022e9:	50                   	push   %eax
  8022ea:	ff 75 08             	pushl  0x8(%ebp)
  8022ed:	e8 35 fc ff ff       	call   801f27 <fd_lookup>
  8022f2:	83 c4 10             	add    $0x10,%esp
  8022f5:	85 c0                	test   %eax,%eax
  8022f7:	78 0e                	js     802307 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8022f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ff:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  802302:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802307:	c9                   	leave  
  802308:	c3                   	ret    

00802309 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802309:	55                   	push   %ebp
  80230a:	89 e5                	mov    %esp,%ebp
  80230c:	53                   	push   %ebx
  80230d:	83 ec 1c             	sub    $0x1c,%esp
  802310:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802313:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802316:	50                   	push   %eax
  802317:	53                   	push   %ebx
  802318:	e8 0a fc ff ff       	call   801f27 <fd_lookup>
  80231d:	83 c4 10             	add    $0x10,%esp
  802320:	85 c0                	test   %eax,%eax
  802322:	78 37                	js     80235b <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802324:	83 ec 08             	sub    $0x8,%esp
  802327:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80232a:	50                   	push   %eax
  80232b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80232e:	ff 30                	pushl  (%eax)
  802330:	e8 42 fc ff ff       	call   801f77 <dev_lookup>
  802335:	83 c4 10             	add    $0x10,%esp
  802338:	85 c0                	test   %eax,%eax
  80233a:	78 1f                	js     80235b <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80233c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80233f:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  802343:	74 1b                	je     802360 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  802345:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802348:	8b 52 18             	mov    0x18(%edx),%edx
  80234b:	85 d2                	test   %edx,%edx
  80234d:	74 32                	je     802381 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80234f:	83 ec 08             	sub    $0x8,%esp
  802352:	ff 75 0c             	pushl  0xc(%ebp)
  802355:	50                   	push   %eax
  802356:	ff d2                	call   *%edx
  802358:	83 c4 10             	add    $0x10,%esp
}
  80235b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80235e:	c9                   	leave  
  80235f:	c3                   	ret    
			thisenv->env_id, fdnum);
  802360:	a1 24 54 80 00       	mov    0x805424,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802365:	8b 40 48             	mov    0x48(%eax),%eax
  802368:	83 ec 04             	sub    $0x4,%esp
  80236b:	53                   	push   %ebx
  80236c:	50                   	push   %eax
  80236d:	68 a0 3c 80 00       	push   $0x803ca0
  802372:	e8 8d e7 ff ff       	call   800b04 <cprintf>
		return -E_INVAL;
  802377:	83 c4 10             	add    $0x10,%esp
  80237a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80237f:	eb da                	jmp    80235b <ftruncate+0x52>
		return -E_NOT_SUPP;
  802381:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802386:	eb d3                	jmp    80235b <ftruncate+0x52>

00802388 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802388:	55                   	push   %ebp
  802389:	89 e5                	mov    %esp,%ebp
  80238b:	53                   	push   %ebx
  80238c:	83 ec 1c             	sub    $0x1c,%esp
  80238f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802392:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802395:	50                   	push   %eax
  802396:	ff 75 08             	pushl  0x8(%ebp)
  802399:	e8 89 fb ff ff       	call   801f27 <fd_lookup>
  80239e:	83 c4 10             	add    $0x10,%esp
  8023a1:	85 c0                	test   %eax,%eax
  8023a3:	78 4b                	js     8023f0 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8023a5:	83 ec 08             	sub    $0x8,%esp
  8023a8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023ab:	50                   	push   %eax
  8023ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023af:	ff 30                	pushl  (%eax)
  8023b1:	e8 c1 fb ff ff       	call   801f77 <dev_lookup>
  8023b6:	83 c4 10             	add    $0x10,%esp
  8023b9:	85 c0                	test   %eax,%eax
  8023bb:	78 33                	js     8023f0 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8023bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c0:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8023c4:	74 2f                	je     8023f5 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8023c6:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8023c9:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8023d0:	00 00 00 
	stat->st_isdir = 0;
  8023d3:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8023da:	00 00 00 
	stat->st_dev = dev;
  8023dd:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8023e3:	83 ec 08             	sub    $0x8,%esp
  8023e6:	53                   	push   %ebx
  8023e7:	ff 75 f0             	pushl  -0x10(%ebp)
  8023ea:	ff 50 14             	call   *0x14(%eax)
  8023ed:	83 c4 10             	add    $0x10,%esp
}
  8023f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023f3:	c9                   	leave  
  8023f4:	c3                   	ret    
		return -E_NOT_SUPP;
  8023f5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8023fa:	eb f4                	jmp    8023f0 <fstat+0x68>

008023fc <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8023fc:	55                   	push   %ebp
  8023fd:	89 e5                	mov    %esp,%ebp
  8023ff:	56                   	push   %esi
  802400:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802401:	83 ec 08             	sub    $0x8,%esp
  802404:	6a 00                	push   $0x0
  802406:	ff 75 08             	pushl  0x8(%ebp)
  802409:	e8 bb 01 00 00       	call   8025c9 <open>
  80240e:	89 c3                	mov    %eax,%ebx
  802410:	83 c4 10             	add    $0x10,%esp
  802413:	85 c0                	test   %eax,%eax
  802415:	78 1b                	js     802432 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  802417:	83 ec 08             	sub    $0x8,%esp
  80241a:	ff 75 0c             	pushl  0xc(%ebp)
  80241d:	50                   	push   %eax
  80241e:	e8 65 ff ff ff       	call   802388 <fstat>
  802423:	89 c6                	mov    %eax,%esi
	close(fd);
  802425:	89 1c 24             	mov    %ebx,(%esp)
  802428:	e8 27 fc ff ff       	call   802054 <close>
	return r;
  80242d:	83 c4 10             	add    $0x10,%esp
  802430:	89 f3                	mov    %esi,%ebx
}
  802432:	89 d8                	mov    %ebx,%eax
  802434:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802437:	5b                   	pop    %ebx
  802438:	5e                   	pop    %esi
  802439:	5d                   	pop    %ebp
  80243a:	c3                   	ret    

0080243b <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80243b:	55                   	push   %ebp
  80243c:	89 e5                	mov    %esp,%ebp
  80243e:	56                   	push   %esi
  80243f:	53                   	push   %ebx
  802440:	89 c6                	mov    %eax,%esi
  802442:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  802444:	83 3d 20 54 80 00 00 	cmpl   $0x0,0x805420
  80244b:	74 27                	je     802474 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80244d:	6a 07                	push   $0x7
  80244f:	68 00 60 80 00       	push   $0x806000
  802454:	56                   	push   %esi
  802455:	ff 35 20 54 80 00    	pushl  0x805420
  80245b:	e8 1c 0d 00 00       	call   80317c <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  802460:	83 c4 0c             	add    $0xc,%esp
  802463:	6a 00                	push   $0x0
  802465:	53                   	push   %ebx
  802466:	6a 00                	push   $0x0
  802468:	e8 a6 0c 00 00       	call   803113 <ipc_recv>
}
  80246d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802470:	5b                   	pop    %ebx
  802471:	5e                   	pop    %esi
  802472:	5d                   	pop    %ebp
  802473:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802474:	83 ec 0c             	sub    $0xc,%esp
  802477:	6a 01                	push   $0x1
  802479:	e8 4b 0d 00 00       	call   8031c9 <ipc_find_env>
  80247e:	a3 20 54 80 00       	mov    %eax,0x805420
  802483:	83 c4 10             	add    $0x10,%esp
  802486:	eb c5                	jmp    80244d <fsipc+0x12>

00802488 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802488:	55                   	push   %ebp
  802489:	89 e5                	mov    %esp,%ebp
  80248b:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80248e:	8b 45 08             	mov    0x8(%ebp),%eax
  802491:	8b 40 0c             	mov    0xc(%eax),%eax
  802494:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  802499:	8b 45 0c             	mov    0xc(%ebp),%eax
  80249c:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8024a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8024a6:	b8 02 00 00 00       	mov    $0x2,%eax
  8024ab:	e8 8b ff ff ff       	call   80243b <fsipc>
}
  8024b0:	c9                   	leave  
  8024b1:	c3                   	ret    

008024b2 <devfile_flush>:
{
  8024b2:	55                   	push   %ebp
  8024b3:	89 e5                	mov    %esp,%ebp
  8024b5:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8024b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8024be:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  8024c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8024c8:	b8 06 00 00 00       	mov    $0x6,%eax
  8024cd:	e8 69 ff ff ff       	call   80243b <fsipc>
}
  8024d2:	c9                   	leave  
  8024d3:	c3                   	ret    

008024d4 <devfile_stat>:
{
  8024d4:	55                   	push   %ebp
  8024d5:	89 e5                	mov    %esp,%ebp
  8024d7:	53                   	push   %ebx
  8024d8:	83 ec 04             	sub    $0x4,%esp
  8024db:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8024de:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8024e4:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8024e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8024ee:	b8 05 00 00 00       	mov    $0x5,%eax
  8024f3:	e8 43 ff ff ff       	call   80243b <fsipc>
  8024f8:	85 c0                	test   %eax,%eax
  8024fa:	78 2c                	js     802528 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8024fc:	83 ec 08             	sub    $0x8,%esp
  8024ff:	68 00 60 80 00       	push   $0x806000
  802504:	53                   	push   %ebx
  802505:	e8 10 ee ff ff       	call   80131a <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80250a:	a1 80 60 80 00       	mov    0x806080,%eax
  80250f:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802515:	a1 84 60 80 00       	mov    0x806084,%eax
  80251a:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  802520:	83 c4 10             	add    $0x10,%esp
  802523:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802528:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80252b:	c9                   	leave  
  80252c:	c3                   	ret    

0080252d <devfile_write>:
{
  80252d:	55                   	push   %ebp
  80252e:	89 e5                	mov    %esp,%ebp
  802530:	83 ec 0c             	sub    $0xc,%esp
	panic("devfile_write not implemented");
  802533:	68 0c 3d 80 00       	push   $0x803d0c
  802538:	68 90 00 00 00       	push   $0x90
  80253d:	68 2a 3d 80 00       	push   $0x803d2a
  802542:	e8 e2 e4 ff ff       	call   800a29 <_panic>

00802547 <devfile_read>:
{
  802547:	55                   	push   %ebp
  802548:	89 e5                	mov    %esp,%ebp
  80254a:	56                   	push   %esi
  80254b:	53                   	push   %ebx
  80254c:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80254f:	8b 45 08             	mov    0x8(%ebp),%eax
  802552:	8b 40 0c             	mov    0xc(%eax),%eax
  802555:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  80255a:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802560:	ba 00 00 00 00       	mov    $0x0,%edx
  802565:	b8 03 00 00 00       	mov    $0x3,%eax
  80256a:	e8 cc fe ff ff       	call   80243b <fsipc>
  80256f:	89 c3                	mov    %eax,%ebx
  802571:	85 c0                	test   %eax,%eax
  802573:	78 1f                	js     802594 <devfile_read+0x4d>
	assert(r <= n);
  802575:	39 f0                	cmp    %esi,%eax
  802577:	77 24                	ja     80259d <devfile_read+0x56>
	assert(r <= PGSIZE);
  802579:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80257e:	7f 33                	jg     8025b3 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802580:	83 ec 04             	sub    $0x4,%esp
  802583:	50                   	push   %eax
  802584:	68 00 60 80 00       	push   $0x806000
  802589:	ff 75 0c             	pushl  0xc(%ebp)
  80258c:	e8 17 ef ff ff       	call   8014a8 <memmove>
	return r;
  802591:	83 c4 10             	add    $0x10,%esp
}
  802594:	89 d8                	mov    %ebx,%eax
  802596:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802599:	5b                   	pop    %ebx
  80259a:	5e                   	pop    %esi
  80259b:	5d                   	pop    %ebp
  80259c:	c3                   	ret    
	assert(r <= n);
  80259d:	68 35 3d 80 00       	push   $0x803d35
  8025a2:	68 f8 35 80 00       	push   $0x8035f8
  8025a7:	6a 7c                	push   $0x7c
  8025a9:	68 2a 3d 80 00       	push   $0x803d2a
  8025ae:	e8 76 e4 ff ff       	call   800a29 <_panic>
	assert(r <= PGSIZE);
  8025b3:	68 3c 3d 80 00       	push   $0x803d3c
  8025b8:	68 f8 35 80 00       	push   $0x8035f8
  8025bd:	6a 7d                	push   $0x7d
  8025bf:	68 2a 3d 80 00       	push   $0x803d2a
  8025c4:	e8 60 e4 ff ff       	call   800a29 <_panic>

008025c9 <open>:
{
  8025c9:	55                   	push   %ebp
  8025ca:	89 e5                	mov    %esp,%ebp
  8025cc:	56                   	push   %esi
  8025cd:	53                   	push   %ebx
  8025ce:	83 ec 1c             	sub    $0x1c,%esp
  8025d1:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8025d4:	56                   	push   %esi
  8025d5:	e8 07 ed ff ff       	call   8012e1 <strlen>
  8025da:	83 c4 10             	add    $0x10,%esp
  8025dd:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8025e2:	7f 6c                	jg     802650 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8025e4:	83 ec 0c             	sub    $0xc,%esp
  8025e7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025ea:	50                   	push   %eax
  8025eb:	e8 e5 f8 ff ff       	call   801ed5 <fd_alloc>
  8025f0:	89 c3                	mov    %eax,%ebx
  8025f2:	83 c4 10             	add    $0x10,%esp
  8025f5:	85 c0                	test   %eax,%eax
  8025f7:	78 3c                	js     802635 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8025f9:	83 ec 08             	sub    $0x8,%esp
  8025fc:	56                   	push   %esi
  8025fd:	68 00 60 80 00       	push   $0x806000
  802602:	e8 13 ed ff ff       	call   80131a <strcpy>
	fsipcbuf.open.req_omode = mode;
  802607:	8b 45 0c             	mov    0xc(%ebp),%eax
  80260a:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80260f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802612:	b8 01 00 00 00       	mov    $0x1,%eax
  802617:	e8 1f fe ff ff       	call   80243b <fsipc>
  80261c:	89 c3                	mov    %eax,%ebx
  80261e:	83 c4 10             	add    $0x10,%esp
  802621:	85 c0                	test   %eax,%eax
  802623:	78 19                	js     80263e <open+0x75>
	return fd2num(fd);
  802625:	83 ec 0c             	sub    $0xc,%esp
  802628:	ff 75 f4             	pushl  -0xc(%ebp)
  80262b:	e8 7e f8 ff ff       	call   801eae <fd2num>
  802630:	89 c3                	mov    %eax,%ebx
  802632:	83 c4 10             	add    $0x10,%esp
}
  802635:	89 d8                	mov    %ebx,%eax
  802637:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80263a:	5b                   	pop    %ebx
  80263b:	5e                   	pop    %esi
  80263c:	5d                   	pop    %ebp
  80263d:	c3                   	ret    
		fd_close(fd, 0);
  80263e:	83 ec 08             	sub    $0x8,%esp
  802641:	6a 00                	push   $0x0
  802643:	ff 75 f4             	pushl  -0xc(%ebp)
  802646:	e8 82 f9 ff ff       	call   801fcd <fd_close>
		return r;
  80264b:	83 c4 10             	add    $0x10,%esp
  80264e:	eb e5                	jmp    802635 <open+0x6c>
		return -E_BAD_PATH;
  802650:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  802655:	eb de                	jmp    802635 <open+0x6c>

00802657 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  802657:	55                   	push   %ebp
  802658:	89 e5                	mov    %esp,%ebp
  80265a:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80265d:	ba 00 00 00 00       	mov    $0x0,%edx
  802662:	b8 08 00 00 00       	mov    $0x8,%eax
  802667:	e8 cf fd ff ff       	call   80243b <fsipc>
}
  80266c:	c9                   	leave  
  80266d:	c3                   	ret    

0080266e <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  80266e:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  802672:	7f 01                	jg     802675 <writebuf+0x7>
  802674:	c3                   	ret    
{
  802675:	55                   	push   %ebp
  802676:	89 e5                	mov    %esp,%ebp
  802678:	53                   	push   %ebx
  802679:	83 ec 08             	sub    $0x8,%esp
  80267c:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  80267e:	ff 70 04             	pushl  0x4(%eax)
  802681:	8d 40 10             	lea    0x10(%eax),%eax
  802684:	50                   	push   %eax
  802685:	ff 33                	pushl  (%ebx)
  802687:	e8 d2 fb ff ff       	call   80225e <write>
		if (result > 0)
  80268c:	83 c4 10             	add    $0x10,%esp
  80268f:	85 c0                	test   %eax,%eax
  802691:	7e 03                	jle    802696 <writebuf+0x28>
			b->result += result;
  802693:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  802696:	39 43 04             	cmp    %eax,0x4(%ebx)
  802699:	74 0d                	je     8026a8 <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  80269b:	85 c0                	test   %eax,%eax
  80269d:	ba 00 00 00 00       	mov    $0x0,%edx
  8026a2:	0f 4f c2             	cmovg  %edx,%eax
  8026a5:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  8026a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8026ab:	c9                   	leave  
  8026ac:	c3                   	ret    

008026ad <putch>:

static void
putch(int ch, void *thunk)
{
  8026ad:	55                   	push   %ebp
  8026ae:	89 e5                	mov    %esp,%ebp
  8026b0:	53                   	push   %ebx
  8026b1:	83 ec 04             	sub    $0x4,%esp
  8026b4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  8026b7:	8b 53 04             	mov    0x4(%ebx),%edx
  8026ba:	8d 42 01             	lea    0x1(%edx),%eax
  8026bd:	89 43 04             	mov    %eax,0x4(%ebx)
  8026c0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026c3:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  8026c7:	3d 00 01 00 00       	cmp    $0x100,%eax
  8026cc:	74 06                	je     8026d4 <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  8026ce:	83 c4 04             	add    $0x4,%esp
  8026d1:	5b                   	pop    %ebx
  8026d2:	5d                   	pop    %ebp
  8026d3:	c3                   	ret    
		writebuf(b);
  8026d4:	89 d8                	mov    %ebx,%eax
  8026d6:	e8 93 ff ff ff       	call   80266e <writebuf>
		b->idx = 0;
  8026db:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  8026e2:	eb ea                	jmp    8026ce <putch+0x21>

008026e4 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  8026e4:	55                   	push   %ebp
  8026e5:	89 e5                	mov    %esp,%ebp
  8026e7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  8026ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f0:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  8026f6:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  8026fd:	00 00 00 
	b.result = 0;
  802700:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  802707:	00 00 00 
	b.error = 1;
  80270a:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  802711:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  802714:	ff 75 10             	pushl  0x10(%ebp)
  802717:	ff 75 0c             	pushl  0xc(%ebp)
  80271a:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  802720:	50                   	push   %eax
  802721:	68 ad 26 80 00       	push   $0x8026ad
  802726:	e8 06 e5 ff ff       	call   800c31 <vprintfmt>
	if (b.idx > 0)
  80272b:	83 c4 10             	add    $0x10,%esp
  80272e:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  802735:	7f 11                	jg     802748 <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  802737:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80273d:	85 c0                	test   %eax,%eax
  80273f:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  802746:	c9                   	leave  
  802747:	c3                   	ret    
		writebuf(&b);
  802748:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80274e:	e8 1b ff ff ff       	call   80266e <writebuf>
  802753:	eb e2                	jmp    802737 <vfprintf+0x53>

00802755 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  802755:	55                   	push   %ebp
  802756:	89 e5                	mov    %esp,%ebp
  802758:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80275b:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  80275e:	50                   	push   %eax
  80275f:	ff 75 0c             	pushl  0xc(%ebp)
  802762:	ff 75 08             	pushl  0x8(%ebp)
  802765:	e8 7a ff ff ff       	call   8026e4 <vfprintf>
	va_end(ap);

	return cnt;
}
  80276a:	c9                   	leave  
  80276b:	c3                   	ret    

0080276c <printf>:

int
printf(const char *fmt, ...)
{
  80276c:	55                   	push   %ebp
  80276d:	89 e5                	mov    %esp,%ebp
  80276f:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802772:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  802775:	50                   	push   %eax
  802776:	ff 75 08             	pushl  0x8(%ebp)
  802779:	6a 01                	push   $0x1
  80277b:	e8 64 ff ff ff       	call   8026e4 <vfprintf>
	va_end(ap);

	return cnt;
}
  802780:	c9                   	leave  
  802781:	c3                   	ret    

00802782 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  802782:	55                   	push   %ebp
  802783:	89 e5                	mov    %esp,%ebp
  802785:	57                   	push   %edi
  802786:	56                   	push   %esi
  802787:	53                   	push   %ebx
  802788:	81 ec 94 02 00 00    	sub    $0x294,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  80278e:	6a 00                	push   $0x0
  802790:	ff 75 08             	pushl  0x8(%ebp)
  802793:	e8 31 fe ff ff       	call   8025c9 <open>
  802798:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  80279e:	83 c4 10             	add    $0x10,%esp
  8027a1:	85 c0                	test   %eax,%eax
  8027a3:	0f 88 72 04 00 00    	js     802c1b <spawn+0x499>
  8027a9:	89 c2                	mov    %eax,%edx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  8027ab:	83 ec 04             	sub    $0x4,%esp
  8027ae:	68 00 02 00 00       	push   $0x200
  8027b3:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  8027b9:	50                   	push   %eax
  8027ba:	52                   	push   %edx
  8027bb:	e8 59 fa ff ff       	call   802219 <readn>
  8027c0:	83 c4 10             	add    $0x10,%esp
  8027c3:	3d 00 02 00 00       	cmp    $0x200,%eax
  8027c8:	75 60                	jne    80282a <spawn+0xa8>
	    || elf->e_magic != ELF_MAGIC) {
  8027ca:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  8027d1:	45 4c 46 
  8027d4:	75 54                	jne    80282a <spawn+0xa8>
  8027d6:	b8 07 00 00 00       	mov    $0x7,%eax
  8027db:	cd 30                	int    $0x30
  8027dd:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  8027e3:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  8027e9:	85 c0                	test   %eax,%eax
  8027eb:	0f 88 1e 04 00 00    	js     802c0f <spawn+0x48d>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  8027f1:	25 ff 03 00 00       	and    $0x3ff,%eax
  8027f6:	69 f0 84 00 00 00    	imul   $0x84,%eax,%esi
  8027fc:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  802802:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  802808:	b9 11 00 00 00       	mov    $0x11,%ecx
  80280d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  80280f:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  802815:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  80281b:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  802820:	be 00 00 00 00       	mov    $0x0,%esi
  802825:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802828:	eb 4b                	jmp    802875 <spawn+0xf3>
		close(fd);
  80282a:	83 ec 0c             	sub    $0xc,%esp
  80282d:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802833:	e8 1c f8 ff ff       	call   802054 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  802838:	83 c4 0c             	add    $0xc,%esp
  80283b:	68 7f 45 4c 46       	push   $0x464c457f
  802840:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  802846:	68 48 3d 80 00       	push   $0x803d48
  80284b:	e8 b4 e2 ff ff       	call   800b04 <cprintf>
		return -E_NOT_EXEC;
  802850:	83 c4 10             	add    $0x10,%esp
  802853:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  80285a:	ff ff ff 
  80285d:	e9 b9 03 00 00       	jmp    802c1b <spawn+0x499>
		string_size += strlen(argv[argc]) + 1;
  802862:	83 ec 0c             	sub    $0xc,%esp
  802865:	50                   	push   %eax
  802866:	e8 76 ea ff ff       	call   8012e1 <strlen>
  80286b:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  80286f:	83 c3 01             	add    $0x1,%ebx
  802872:	83 c4 10             	add    $0x10,%esp
  802875:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  80287c:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  80287f:	85 c0                	test   %eax,%eax
  802881:	75 df                	jne    802862 <spawn+0xe0>
  802883:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  802889:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  80288f:	bf 00 10 40 00       	mov    $0x401000,%edi
  802894:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  802896:	89 fa                	mov    %edi,%edx
  802898:	83 e2 fc             	and    $0xfffffffc,%edx
  80289b:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  8028a2:	29 c2                	sub    %eax,%edx
  8028a4:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  8028aa:	8d 42 f8             	lea    -0x8(%edx),%eax
  8028ad:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  8028b2:	0f 86 86 03 00 00    	jbe    802c3e <spawn+0x4bc>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8028b8:	83 ec 04             	sub    $0x4,%esp
  8028bb:	6a 07                	push   $0x7
  8028bd:	68 00 00 40 00       	push   $0x400000
  8028c2:	6a 00                	push   $0x0
  8028c4:	e8 43 ee ff ff       	call   80170c <sys_page_alloc>
  8028c9:	83 c4 10             	add    $0x10,%esp
  8028cc:	85 c0                	test   %eax,%eax
  8028ce:	0f 88 6f 03 00 00    	js     802c43 <spawn+0x4c1>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8028d4:	be 00 00 00 00       	mov    $0x0,%esi
  8028d9:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  8028df:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8028e2:	eb 30                	jmp    802914 <spawn+0x192>
		argv_store[i] = UTEMP2USTACK(string_store);
  8028e4:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  8028ea:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  8028f0:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  8028f3:	83 ec 08             	sub    $0x8,%esp
  8028f6:	ff 34 b3             	pushl  (%ebx,%esi,4)
  8028f9:	57                   	push   %edi
  8028fa:	e8 1b ea ff ff       	call   80131a <strcpy>
		string_store += strlen(argv[i]) + 1;
  8028ff:	83 c4 04             	add    $0x4,%esp
  802902:	ff 34 b3             	pushl  (%ebx,%esi,4)
  802905:	e8 d7 e9 ff ff       	call   8012e1 <strlen>
  80290a:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  80290e:	83 c6 01             	add    $0x1,%esi
  802911:	83 c4 10             	add    $0x10,%esp
  802914:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  80291a:	7f c8                	jg     8028e4 <spawn+0x162>
	}
	argv_store[argc] = 0;
  80291c:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802922:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  802928:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  80292f:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  802935:	0f 85 86 00 00 00    	jne    8029c1 <spawn+0x23f>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  80293b:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  802941:	8d 81 00 d0 7f ee    	lea    -0x11803000(%ecx),%eax
  802947:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  80294a:	89 c8                	mov    %ecx,%eax
  80294c:	8b 8d 84 fd ff ff    	mov    -0x27c(%ebp),%ecx
  802952:	89 48 f8             	mov    %ecx,-0x8(%eax)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  802955:	2d 08 30 80 11       	sub    $0x11803008,%eax
  80295a:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  802960:	83 ec 0c             	sub    $0xc,%esp
  802963:	6a 07                	push   $0x7
  802965:	68 00 d0 bf ee       	push   $0xeebfd000
  80296a:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802970:	68 00 00 40 00       	push   $0x400000
  802975:	6a 00                	push   $0x0
  802977:	e8 d3 ed ff ff       	call   80174f <sys_page_map>
  80297c:	89 c3                	mov    %eax,%ebx
  80297e:	83 c4 20             	add    $0x20,%esp
  802981:	85 c0                	test   %eax,%eax
  802983:	0f 88 c2 02 00 00    	js     802c4b <spawn+0x4c9>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  802989:	83 ec 08             	sub    $0x8,%esp
  80298c:	68 00 00 40 00       	push   $0x400000
  802991:	6a 00                	push   $0x0
  802993:	e8 f9 ed ff ff       	call   801791 <sys_page_unmap>
  802998:	89 c3                	mov    %eax,%ebx
  80299a:	83 c4 10             	add    $0x10,%esp
  80299d:	85 c0                	test   %eax,%eax
  80299f:	0f 88 a6 02 00 00    	js     802c4b <spawn+0x4c9>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  8029a5:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  8029ab:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8029b2:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  8029b9:	00 00 00 
  8029bc:	e9 4f 01 00 00       	jmp    802b10 <spawn+0x38e>
	assert(string_store == (char*)UTEMP + PGSIZE);
  8029c1:	68 bc 3d 80 00       	push   $0x803dbc
  8029c6:	68 f8 35 80 00       	push   $0x8035f8
  8029cb:	68 f2 00 00 00       	push   $0xf2
  8029d0:	68 62 3d 80 00       	push   $0x803d62
  8029d5:	e8 4f e0 ff ff       	call   800a29 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8029da:	83 ec 04             	sub    $0x4,%esp
  8029dd:	6a 07                	push   $0x7
  8029df:	68 00 00 40 00       	push   $0x400000
  8029e4:	6a 00                	push   $0x0
  8029e6:	e8 21 ed ff ff       	call   80170c <sys_page_alloc>
  8029eb:	83 c4 10             	add    $0x10,%esp
  8029ee:	85 c0                	test   %eax,%eax
  8029f0:	0f 88 33 02 00 00    	js     802c29 <spawn+0x4a7>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  8029f6:	83 ec 08             	sub    $0x8,%esp
  8029f9:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  8029ff:	01 f0                	add    %esi,%eax
  802a01:	50                   	push   %eax
  802a02:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802a08:	e8 d3 f8 ff ff       	call   8022e0 <seek>
  802a0d:	83 c4 10             	add    $0x10,%esp
  802a10:	85 c0                	test   %eax,%eax
  802a12:	0f 88 18 02 00 00    	js     802c30 <spawn+0x4ae>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  802a18:	83 ec 04             	sub    $0x4,%esp
  802a1b:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802a21:	29 f0                	sub    %esi,%eax
  802a23:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802a28:	ba 00 10 00 00       	mov    $0x1000,%edx
  802a2d:	0f 47 c2             	cmova  %edx,%eax
  802a30:	50                   	push   %eax
  802a31:	68 00 00 40 00       	push   $0x400000
  802a36:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802a3c:	e8 d8 f7 ff ff       	call   802219 <readn>
  802a41:	83 c4 10             	add    $0x10,%esp
  802a44:	85 c0                	test   %eax,%eax
  802a46:	0f 88 eb 01 00 00    	js     802c37 <spawn+0x4b5>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  802a4c:	83 ec 0c             	sub    $0xc,%esp
  802a4f:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  802a55:	53                   	push   %ebx
  802a56:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  802a5c:	68 00 00 40 00       	push   $0x400000
  802a61:	6a 00                	push   $0x0
  802a63:	e8 e7 ec ff ff       	call   80174f <sys_page_map>
  802a68:	83 c4 20             	add    $0x20,%esp
  802a6b:	85 c0                	test   %eax,%eax
  802a6d:	78 7c                	js     802aeb <spawn+0x369>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  802a6f:	83 ec 08             	sub    $0x8,%esp
  802a72:	68 00 00 40 00       	push   $0x400000
  802a77:	6a 00                	push   $0x0
  802a79:	e8 13 ed ff ff       	call   801791 <sys_page_unmap>
  802a7e:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  802a81:	81 c7 00 10 00 00    	add    $0x1000,%edi
  802a87:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802a8d:	89 fe                	mov    %edi,%esi
  802a8f:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  802a95:	76 69                	jbe    802b00 <spawn+0x37e>
		if (i >= filesz) {
  802a97:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  802a9d:	0f 87 37 ff ff ff    	ja     8029da <spawn+0x258>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  802aa3:	83 ec 04             	sub    $0x4,%esp
  802aa6:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  802aac:	53                   	push   %ebx
  802aad:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  802ab3:	e8 54 ec ff ff       	call   80170c <sys_page_alloc>
  802ab8:	83 c4 10             	add    $0x10,%esp
  802abb:	85 c0                	test   %eax,%eax
  802abd:	79 c2                	jns    802a81 <spawn+0x2ff>
  802abf:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  802ac1:	83 ec 0c             	sub    $0xc,%esp
  802ac4:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802aca:	e8 be eb ff ff       	call   80168d <sys_env_destroy>
	close(fd);
  802acf:	83 c4 04             	add    $0x4,%esp
  802ad2:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802ad8:	e8 77 f5 ff ff       	call   802054 <close>
	return r;
  802add:	83 c4 10             	add    $0x10,%esp
  802ae0:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  802ae6:	e9 30 01 00 00       	jmp    802c1b <spawn+0x499>
				panic("spawn: sys_page_map data: %e", r);
  802aeb:	50                   	push   %eax
  802aec:	68 6e 3d 80 00       	push   $0x803d6e
  802af1:	68 25 01 00 00       	push   $0x125
  802af6:	68 62 3d 80 00       	push   $0x803d62
  802afb:	e8 29 df ff ff       	call   800a29 <_panic>
  802b00:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802b06:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  802b0d:	83 c6 20             	add    $0x20,%esi
  802b10:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  802b17:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  802b1d:	7e 6d                	jle    802b8c <spawn+0x40a>
		if (ph->p_type != ELF_PROG_LOAD)
  802b1f:	83 3e 01             	cmpl   $0x1,(%esi)
  802b22:	75 e2                	jne    802b06 <spawn+0x384>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802b24:	8b 46 18             	mov    0x18(%esi),%eax
  802b27:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  802b2a:	83 f8 01             	cmp    $0x1,%eax
  802b2d:	19 c0                	sbb    %eax,%eax
  802b2f:	83 e0 fe             	and    $0xfffffffe,%eax
  802b32:	83 c0 07             	add    $0x7,%eax
  802b35:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802b3b:	8b 4e 04             	mov    0x4(%esi),%ecx
  802b3e:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  802b44:	8b 56 10             	mov    0x10(%esi),%edx
  802b47:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  802b4d:	8b 7e 14             	mov    0x14(%esi),%edi
  802b50:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  802b56:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  802b59:	89 d8                	mov    %ebx,%eax
  802b5b:	25 ff 0f 00 00       	and    $0xfff,%eax
  802b60:	74 1a                	je     802b7c <spawn+0x3fa>
		va -= i;
  802b62:	29 c3                	sub    %eax,%ebx
		memsz += i;
  802b64:	01 c7                	add    %eax,%edi
  802b66:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  802b6c:	01 c2                	add    %eax,%edx
  802b6e:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  802b74:	29 c1                	sub    %eax,%ecx
  802b76:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  802b7c:	bf 00 00 00 00       	mov    $0x0,%edi
  802b81:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  802b87:	e9 01 ff ff ff       	jmp    802a8d <spawn+0x30b>
	close(fd);
  802b8c:	83 ec 0c             	sub    $0xc,%esp
  802b8f:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802b95:	e8 ba f4 ff ff       	call   802054 <close>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  802b9a:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  802ba1:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  802ba4:	83 c4 08             	add    $0x8,%esp
  802ba7:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  802bad:	50                   	push   %eax
  802bae:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802bb4:	e8 5c ec ff ff       	call   801815 <sys_env_set_trapframe>
  802bb9:	83 c4 10             	add    $0x10,%esp
  802bbc:	85 c0                	test   %eax,%eax
  802bbe:	78 25                	js     802be5 <spawn+0x463>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802bc0:	83 ec 08             	sub    $0x8,%esp
  802bc3:	6a 02                	push   $0x2
  802bc5:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802bcb:	e8 03 ec ff ff       	call   8017d3 <sys_env_set_status>
  802bd0:	83 c4 10             	add    $0x10,%esp
  802bd3:	85 c0                	test   %eax,%eax
  802bd5:	78 23                	js     802bfa <spawn+0x478>
	return child;
  802bd7:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802bdd:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  802be3:	eb 36                	jmp    802c1b <spawn+0x499>
		panic("sys_env_set_trapframe: %e", r);
  802be5:	50                   	push   %eax
  802be6:	68 8b 3d 80 00       	push   $0x803d8b
  802beb:	68 86 00 00 00       	push   $0x86
  802bf0:	68 62 3d 80 00       	push   $0x803d62
  802bf5:	e8 2f de ff ff       	call   800a29 <_panic>
		panic("sys_env_set_status: %e", r);
  802bfa:	50                   	push   %eax
  802bfb:	68 a5 3d 80 00       	push   $0x803da5
  802c00:	68 89 00 00 00       	push   $0x89
  802c05:	68 62 3d 80 00       	push   $0x803d62
  802c0a:	e8 1a de ff ff       	call   800a29 <_panic>
		return r;
  802c0f:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802c15:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  802c1b:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  802c21:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802c24:	5b                   	pop    %ebx
  802c25:	5e                   	pop    %esi
  802c26:	5f                   	pop    %edi
  802c27:	5d                   	pop    %ebp
  802c28:	c3                   	ret    
  802c29:	89 c7                	mov    %eax,%edi
  802c2b:	e9 91 fe ff ff       	jmp    802ac1 <spawn+0x33f>
  802c30:	89 c7                	mov    %eax,%edi
  802c32:	e9 8a fe ff ff       	jmp    802ac1 <spawn+0x33f>
  802c37:	89 c7                	mov    %eax,%edi
  802c39:	e9 83 fe ff ff       	jmp    802ac1 <spawn+0x33f>
		return -E_NO_MEM;
  802c3e:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802c43:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  802c49:	eb d0                	jmp    802c1b <spawn+0x499>
	sys_page_unmap(0, UTEMP);
  802c4b:	83 ec 08             	sub    $0x8,%esp
  802c4e:	68 00 00 40 00       	push   $0x400000
  802c53:	6a 00                	push   $0x0
  802c55:	e8 37 eb ff ff       	call   801791 <sys_page_unmap>
  802c5a:	83 c4 10             	add    $0x10,%esp
  802c5d:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  802c63:	eb b6                	jmp    802c1b <spawn+0x499>

00802c65 <spawnl>:
{
  802c65:	55                   	push   %ebp
  802c66:	89 e5                	mov    %esp,%ebp
  802c68:	57                   	push   %edi
  802c69:	56                   	push   %esi
  802c6a:	53                   	push   %ebx
  802c6b:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  802c6e:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  802c71:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  802c76:	8d 4a 04             	lea    0x4(%edx),%ecx
  802c79:	83 3a 00             	cmpl   $0x0,(%edx)
  802c7c:	74 07                	je     802c85 <spawnl+0x20>
		argc++;
  802c7e:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  802c81:	89 ca                	mov    %ecx,%edx
  802c83:	eb f1                	jmp    802c76 <spawnl+0x11>
	const char *argv[argc+2];
  802c85:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  802c8c:	83 e2 f0             	and    $0xfffffff0,%edx
  802c8f:	29 d4                	sub    %edx,%esp
  802c91:	8d 54 24 03          	lea    0x3(%esp),%edx
  802c95:	c1 ea 02             	shr    $0x2,%edx
  802c98:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  802c9f:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  802ca1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802ca4:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  802cab:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  802cb2:	00 
	va_start(vl, arg0);
  802cb3:	8d 4d 10             	lea    0x10(%ebp),%ecx
  802cb6:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  802cb8:	b8 00 00 00 00       	mov    $0x0,%eax
  802cbd:	eb 0b                	jmp    802cca <spawnl+0x65>
		argv[i+1] = va_arg(vl, const char *);
  802cbf:	83 c0 01             	add    $0x1,%eax
  802cc2:	8b 39                	mov    (%ecx),%edi
  802cc4:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  802cc7:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  802cca:	39 d0                	cmp    %edx,%eax
  802ccc:	75 f1                	jne    802cbf <spawnl+0x5a>
	return spawn(prog, argv);
  802cce:	83 ec 08             	sub    $0x8,%esp
  802cd1:	56                   	push   %esi
  802cd2:	ff 75 08             	pushl  0x8(%ebp)
  802cd5:	e8 a8 fa ff ff       	call   802782 <spawn>
}
  802cda:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802cdd:	5b                   	pop    %ebx
  802cde:	5e                   	pop    %esi
  802cdf:	5f                   	pop    %edi
  802ce0:	5d                   	pop    %ebp
  802ce1:	c3                   	ret    

00802ce2 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802ce2:	55                   	push   %ebp
  802ce3:	89 e5                	mov    %esp,%ebp
  802ce5:	56                   	push   %esi
  802ce6:	53                   	push   %ebx
  802ce7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802cea:	83 ec 0c             	sub    $0xc,%esp
  802ced:	ff 75 08             	pushl  0x8(%ebp)
  802cf0:	e8 c9 f1 ff ff       	call   801ebe <fd2data>
  802cf5:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802cf7:	83 c4 08             	add    $0x8,%esp
  802cfa:	68 e2 3d 80 00       	push   $0x803de2
  802cff:	53                   	push   %ebx
  802d00:	e8 15 e6 ff ff       	call   80131a <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802d05:	8b 46 04             	mov    0x4(%esi),%eax
  802d08:	2b 06                	sub    (%esi),%eax
  802d0a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802d10:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802d17:	00 00 00 
	stat->st_dev = &devpipe;
  802d1a:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  802d21:	40 80 00 
	return 0;
}
  802d24:	b8 00 00 00 00       	mov    $0x0,%eax
  802d29:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802d2c:	5b                   	pop    %ebx
  802d2d:	5e                   	pop    %esi
  802d2e:	5d                   	pop    %ebp
  802d2f:	c3                   	ret    

00802d30 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802d30:	55                   	push   %ebp
  802d31:	89 e5                	mov    %esp,%ebp
  802d33:	53                   	push   %ebx
  802d34:	83 ec 0c             	sub    $0xc,%esp
  802d37:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802d3a:	53                   	push   %ebx
  802d3b:	6a 00                	push   $0x0
  802d3d:	e8 4f ea ff ff       	call   801791 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802d42:	89 1c 24             	mov    %ebx,(%esp)
  802d45:	e8 74 f1 ff ff       	call   801ebe <fd2data>
  802d4a:	83 c4 08             	add    $0x8,%esp
  802d4d:	50                   	push   %eax
  802d4e:	6a 00                	push   $0x0
  802d50:	e8 3c ea ff ff       	call   801791 <sys_page_unmap>
}
  802d55:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802d58:	c9                   	leave  
  802d59:	c3                   	ret    

00802d5a <_pipeisclosed>:
{
  802d5a:	55                   	push   %ebp
  802d5b:	89 e5                	mov    %esp,%ebp
  802d5d:	57                   	push   %edi
  802d5e:	56                   	push   %esi
  802d5f:	53                   	push   %ebx
  802d60:	83 ec 1c             	sub    $0x1c,%esp
  802d63:	89 c7                	mov    %eax,%edi
  802d65:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802d67:	a1 24 54 80 00       	mov    0x805424,%eax
  802d6c:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802d6f:	83 ec 0c             	sub    $0xc,%esp
  802d72:	57                   	push   %edi
  802d73:	e8 90 04 00 00       	call   803208 <pageref>
  802d78:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802d7b:	89 34 24             	mov    %esi,(%esp)
  802d7e:	e8 85 04 00 00       	call   803208 <pageref>
		nn = thisenv->env_runs;
  802d83:	8b 15 24 54 80 00    	mov    0x805424,%edx
  802d89:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802d8c:	83 c4 10             	add    $0x10,%esp
  802d8f:	39 cb                	cmp    %ecx,%ebx
  802d91:	74 1b                	je     802dae <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802d93:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802d96:	75 cf                	jne    802d67 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802d98:	8b 42 58             	mov    0x58(%edx),%eax
  802d9b:	6a 01                	push   $0x1
  802d9d:	50                   	push   %eax
  802d9e:	53                   	push   %ebx
  802d9f:	68 e9 3d 80 00       	push   $0x803de9
  802da4:	e8 5b dd ff ff       	call   800b04 <cprintf>
  802da9:	83 c4 10             	add    $0x10,%esp
  802dac:	eb b9                	jmp    802d67 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802dae:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802db1:	0f 94 c0             	sete   %al
  802db4:	0f b6 c0             	movzbl %al,%eax
}
  802db7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802dba:	5b                   	pop    %ebx
  802dbb:	5e                   	pop    %esi
  802dbc:	5f                   	pop    %edi
  802dbd:	5d                   	pop    %ebp
  802dbe:	c3                   	ret    

00802dbf <devpipe_write>:
{
  802dbf:	55                   	push   %ebp
  802dc0:	89 e5                	mov    %esp,%ebp
  802dc2:	57                   	push   %edi
  802dc3:	56                   	push   %esi
  802dc4:	53                   	push   %ebx
  802dc5:	83 ec 28             	sub    $0x28,%esp
  802dc8:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802dcb:	56                   	push   %esi
  802dcc:	e8 ed f0 ff ff       	call   801ebe <fd2data>
  802dd1:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802dd3:	83 c4 10             	add    $0x10,%esp
  802dd6:	bf 00 00 00 00       	mov    $0x0,%edi
  802ddb:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802dde:	74 4f                	je     802e2f <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802de0:	8b 43 04             	mov    0x4(%ebx),%eax
  802de3:	8b 0b                	mov    (%ebx),%ecx
  802de5:	8d 51 20             	lea    0x20(%ecx),%edx
  802de8:	39 d0                	cmp    %edx,%eax
  802dea:	72 14                	jb     802e00 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802dec:	89 da                	mov    %ebx,%edx
  802dee:	89 f0                	mov    %esi,%eax
  802df0:	e8 65 ff ff ff       	call   802d5a <_pipeisclosed>
  802df5:	85 c0                	test   %eax,%eax
  802df7:	75 3b                	jne    802e34 <devpipe_write+0x75>
			sys_yield();
  802df9:	e8 ef e8 ff ff       	call   8016ed <sys_yield>
  802dfe:	eb e0                	jmp    802de0 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802e00:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802e03:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802e07:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802e0a:	89 c2                	mov    %eax,%edx
  802e0c:	c1 fa 1f             	sar    $0x1f,%edx
  802e0f:	89 d1                	mov    %edx,%ecx
  802e11:	c1 e9 1b             	shr    $0x1b,%ecx
  802e14:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802e17:	83 e2 1f             	and    $0x1f,%edx
  802e1a:	29 ca                	sub    %ecx,%edx
  802e1c:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802e20:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802e24:	83 c0 01             	add    $0x1,%eax
  802e27:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802e2a:	83 c7 01             	add    $0x1,%edi
  802e2d:	eb ac                	jmp    802ddb <devpipe_write+0x1c>
	return i;
  802e2f:	8b 45 10             	mov    0x10(%ebp),%eax
  802e32:	eb 05                	jmp    802e39 <devpipe_write+0x7a>
				return 0;
  802e34:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e39:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802e3c:	5b                   	pop    %ebx
  802e3d:	5e                   	pop    %esi
  802e3e:	5f                   	pop    %edi
  802e3f:	5d                   	pop    %ebp
  802e40:	c3                   	ret    

00802e41 <devpipe_read>:
{
  802e41:	55                   	push   %ebp
  802e42:	89 e5                	mov    %esp,%ebp
  802e44:	57                   	push   %edi
  802e45:	56                   	push   %esi
  802e46:	53                   	push   %ebx
  802e47:	83 ec 18             	sub    $0x18,%esp
  802e4a:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802e4d:	57                   	push   %edi
  802e4e:	e8 6b f0 ff ff       	call   801ebe <fd2data>
  802e53:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802e55:	83 c4 10             	add    $0x10,%esp
  802e58:	be 00 00 00 00       	mov    $0x0,%esi
  802e5d:	3b 75 10             	cmp    0x10(%ebp),%esi
  802e60:	75 14                	jne    802e76 <devpipe_read+0x35>
	return i;
  802e62:	8b 45 10             	mov    0x10(%ebp),%eax
  802e65:	eb 02                	jmp    802e69 <devpipe_read+0x28>
				return i;
  802e67:	89 f0                	mov    %esi,%eax
}
  802e69:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802e6c:	5b                   	pop    %ebx
  802e6d:	5e                   	pop    %esi
  802e6e:	5f                   	pop    %edi
  802e6f:	5d                   	pop    %ebp
  802e70:	c3                   	ret    
			sys_yield();
  802e71:	e8 77 e8 ff ff       	call   8016ed <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802e76:	8b 03                	mov    (%ebx),%eax
  802e78:	3b 43 04             	cmp    0x4(%ebx),%eax
  802e7b:	75 18                	jne    802e95 <devpipe_read+0x54>
			if (i > 0)
  802e7d:	85 f6                	test   %esi,%esi
  802e7f:	75 e6                	jne    802e67 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802e81:	89 da                	mov    %ebx,%edx
  802e83:	89 f8                	mov    %edi,%eax
  802e85:	e8 d0 fe ff ff       	call   802d5a <_pipeisclosed>
  802e8a:	85 c0                	test   %eax,%eax
  802e8c:	74 e3                	je     802e71 <devpipe_read+0x30>
				return 0;
  802e8e:	b8 00 00 00 00       	mov    $0x0,%eax
  802e93:	eb d4                	jmp    802e69 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802e95:	99                   	cltd   
  802e96:	c1 ea 1b             	shr    $0x1b,%edx
  802e99:	01 d0                	add    %edx,%eax
  802e9b:	83 e0 1f             	and    $0x1f,%eax
  802e9e:	29 d0                	sub    %edx,%eax
  802ea0:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802ea5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802ea8:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802eab:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802eae:	83 c6 01             	add    $0x1,%esi
  802eb1:	eb aa                	jmp    802e5d <devpipe_read+0x1c>

00802eb3 <pipe>:
{
  802eb3:	55                   	push   %ebp
  802eb4:	89 e5                	mov    %esp,%ebp
  802eb6:	56                   	push   %esi
  802eb7:	53                   	push   %ebx
  802eb8:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802ebb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802ebe:	50                   	push   %eax
  802ebf:	e8 11 f0 ff ff       	call   801ed5 <fd_alloc>
  802ec4:	89 c3                	mov    %eax,%ebx
  802ec6:	83 c4 10             	add    $0x10,%esp
  802ec9:	85 c0                	test   %eax,%eax
  802ecb:	0f 88 23 01 00 00    	js     802ff4 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802ed1:	83 ec 04             	sub    $0x4,%esp
  802ed4:	68 07 04 00 00       	push   $0x407
  802ed9:	ff 75 f4             	pushl  -0xc(%ebp)
  802edc:	6a 00                	push   $0x0
  802ede:	e8 29 e8 ff ff       	call   80170c <sys_page_alloc>
  802ee3:	89 c3                	mov    %eax,%ebx
  802ee5:	83 c4 10             	add    $0x10,%esp
  802ee8:	85 c0                	test   %eax,%eax
  802eea:	0f 88 04 01 00 00    	js     802ff4 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802ef0:	83 ec 0c             	sub    $0xc,%esp
  802ef3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802ef6:	50                   	push   %eax
  802ef7:	e8 d9 ef ff ff       	call   801ed5 <fd_alloc>
  802efc:	89 c3                	mov    %eax,%ebx
  802efe:	83 c4 10             	add    $0x10,%esp
  802f01:	85 c0                	test   %eax,%eax
  802f03:	0f 88 db 00 00 00    	js     802fe4 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802f09:	83 ec 04             	sub    $0x4,%esp
  802f0c:	68 07 04 00 00       	push   $0x407
  802f11:	ff 75 f0             	pushl  -0x10(%ebp)
  802f14:	6a 00                	push   $0x0
  802f16:	e8 f1 e7 ff ff       	call   80170c <sys_page_alloc>
  802f1b:	89 c3                	mov    %eax,%ebx
  802f1d:	83 c4 10             	add    $0x10,%esp
  802f20:	85 c0                	test   %eax,%eax
  802f22:	0f 88 bc 00 00 00    	js     802fe4 <pipe+0x131>
	va = fd2data(fd0);
  802f28:	83 ec 0c             	sub    $0xc,%esp
  802f2b:	ff 75 f4             	pushl  -0xc(%ebp)
  802f2e:	e8 8b ef ff ff       	call   801ebe <fd2data>
  802f33:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802f35:	83 c4 0c             	add    $0xc,%esp
  802f38:	68 07 04 00 00       	push   $0x407
  802f3d:	50                   	push   %eax
  802f3e:	6a 00                	push   $0x0
  802f40:	e8 c7 e7 ff ff       	call   80170c <sys_page_alloc>
  802f45:	89 c3                	mov    %eax,%ebx
  802f47:	83 c4 10             	add    $0x10,%esp
  802f4a:	85 c0                	test   %eax,%eax
  802f4c:	0f 88 82 00 00 00    	js     802fd4 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802f52:	83 ec 0c             	sub    $0xc,%esp
  802f55:	ff 75 f0             	pushl  -0x10(%ebp)
  802f58:	e8 61 ef ff ff       	call   801ebe <fd2data>
  802f5d:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802f64:	50                   	push   %eax
  802f65:	6a 00                	push   $0x0
  802f67:	56                   	push   %esi
  802f68:	6a 00                	push   $0x0
  802f6a:	e8 e0 e7 ff ff       	call   80174f <sys_page_map>
  802f6f:	89 c3                	mov    %eax,%ebx
  802f71:	83 c4 20             	add    $0x20,%esp
  802f74:	85 c0                	test   %eax,%eax
  802f76:	78 4e                	js     802fc6 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802f78:	a1 3c 40 80 00       	mov    0x80403c,%eax
  802f7d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f80:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802f82:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f85:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802f8c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f8f:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802f91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f94:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802f9b:	83 ec 0c             	sub    $0xc,%esp
  802f9e:	ff 75 f4             	pushl  -0xc(%ebp)
  802fa1:	e8 08 ef ff ff       	call   801eae <fd2num>
  802fa6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802fa9:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802fab:	83 c4 04             	add    $0x4,%esp
  802fae:	ff 75 f0             	pushl  -0x10(%ebp)
  802fb1:	e8 f8 ee ff ff       	call   801eae <fd2num>
  802fb6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802fb9:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802fbc:	83 c4 10             	add    $0x10,%esp
  802fbf:	bb 00 00 00 00       	mov    $0x0,%ebx
  802fc4:	eb 2e                	jmp    802ff4 <pipe+0x141>
	sys_page_unmap(0, va);
  802fc6:	83 ec 08             	sub    $0x8,%esp
  802fc9:	56                   	push   %esi
  802fca:	6a 00                	push   $0x0
  802fcc:	e8 c0 e7 ff ff       	call   801791 <sys_page_unmap>
  802fd1:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802fd4:	83 ec 08             	sub    $0x8,%esp
  802fd7:	ff 75 f0             	pushl  -0x10(%ebp)
  802fda:	6a 00                	push   $0x0
  802fdc:	e8 b0 e7 ff ff       	call   801791 <sys_page_unmap>
  802fe1:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802fe4:	83 ec 08             	sub    $0x8,%esp
  802fe7:	ff 75 f4             	pushl  -0xc(%ebp)
  802fea:	6a 00                	push   $0x0
  802fec:	e8 a0 e7 ff ff       	call   801791 <sys_page_unmap>
  802ff1:	83 c4 10             	add    $0x10,%esp
}
  802ff4:	89 d8                	mov    %ebx,%eax
  802ff6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802ff9:	5b                   	pop    %ebx
  802ffa:	5e                   	pop    %esi
  802ffb:	5d                   	pop    %ebp
  802ffc:	c3                   	ret    

00802ffd <pipeisclosed>:
{
  802ffd:	55                   	push   %ebp
  802ffe:	89 e5                	mov    %esp,%ebp
  803000:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803003:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803006:	50                   	push   %eax
  803007:	ff 75 08             	pushl  0x8(%ebp)
  80300a:	e8 18 ef ff ff       	call   801f27 <fd_lookup>
  80300f:	83 c4 10             	add    $0x10,%esp
  803012:	85 c0                	test   %eax,%eax
  803014:	78 18                	js     80302e <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  803016:	83 ec 0c             	sub    $0xc,%esp
  803019:	ff 75 f4             	pushl  -0xc(%ebp)
  80301c:	e8 9d ee ff ff       	call   801ebe <fd2data>
	return _pipeisclosed(fd, p);
  803021:	89 c2                	mov    %eax,%edx
  803023:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803026:	e8 2f fd ff ff       	call   802d5a <_pipeisclosed>
  80302b:	83 c4 10             	add    $0x10,%esp
}
  80302e:	c9                   	leave  
  80302f:	c3                   	ret    

00803030 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  803030:	55                   	push   %ebp
  803031:	89 e5                	mov    %esp,%ebp
  803033:	56                   	push   %esi
  803034:	53                   	push   %ebx
  803035:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  803038:	85 f6                	test   %esi,%esi
  80303a:	74 16                	je     803052 <wait+0x22>
	e = &envs[ENVX(envid)];
  80303c:	89 f3                	mov    %esi,%ebx
  80303e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  803044:	69 db 84 00 00 00    	imul   $0x84,%ebx,%ebx
  80304a:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  803050:	eb 1b                	jmp    80306d <wait+0x3d>
	assert(envid != 0);
  803052:	68 01 3e 80 00       	push   $0x803e01
  803057:	68 f8 35 80 00       	push   $0x8035f8
  80305c:	6a 09                	push   $0x9
  80305e:	68 0c 3e 80 00       	push   $0x803e0c
  803063:	e8 c1 d9 ff ff       	call   800a29 <_panic>
		sys_yield();
  803068:	e8 80 e6 ff ff       	call   8016ed <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80306d:	8b 43 48             	mov    0x48(%ebx),%eax
  803070:	39 f0                	cmp    %esi,%eax
  803072:	75 07                	jne    80307b <wait+0x4b>
  803074:	8b 43 54             	mov    0x54(%ebx),%eax
  803077:	85 c0                	test   %eax,%eax
  803079:	75 ed                	jne    803068 <wait+0x38>
}
  80307b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80307e:	5b                   	pop    %ebx
  80307f:	5e                   	pop    %esi
  803080:	5d                   	pop    %ebp
  803081:	c3                   	ret    

00803082 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803082:	55                   	push   %ebp
  803083:	89 e5                	mov    %esp,%ebp
  803085:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  803088:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  80308f:	74 0a                	je     80309b <set_pgfault_handler+0x19>
			panic("set_pgfault_handler: sys_env_set_pgfault_upcall fail, ret:%d", ret);
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  803091:	8b 45 08             	mov    0x8(%ebp),%eax
  803094:	a3 00 70 80 00       	mov    %eax,0x807000
}
  803099:	c9                   	leave  
  80309a:	c3                   	ret    
		ret = sys_page_alloc((envid_t)0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W);
  80309b:	83 ec 04             	sub    $0x4,%esp
  80309e:	6a 07                	push   $0x7
  8030a0:	68 00 f0 bf ee       	push   $0xeebff000
  8030a5:	6a 00                	push   $0x0
  8030a7:	e8 60 e6 ff ff       	call   80170c <sys_page_alloc>
		if(ret < 0){
  8030ac:	83 c4 10             	add    $0x10,%esp
  8030af:	85 c0                	test   %eax,%eax
  8030b1:	78 28                	js     8030db <set_pgfault_handler+0x59>
    	ret = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  8030b3:	83 ec 08             	sub    $0x8,%esp
  8030b6:	68 ed 30 80 00       	push   $0x8030ed
  8030bb:	6a 00                	push   $0x0
  8030bd:	e8 95 e7 ff ff       	call   801857 <sys_env_set_pgfault_upcall>
		if(ret < 0){
  8030c2:	83 c4 10             	add    $0x10,%esp
  8030c5:	85 c0                	test   %eax,%eax
  8030c7:	79 c8                	jns    803091 <set_pgfault_handler+0xf>
			panic("set_pgfault_handler: sys_env_set_pgfault_upcall fail, ret:%d", ret);
  8030c9:	50                   	push   %eax
  8030ca:	68 4c 3e 80 00       	push   $0x803e4c
  8030cf:	6a 28                	push   $0x28
  8030d1:	68 8c 3e 80 00       	push   $0x803e8c
  8030d6:	e8 4e d9 ff ff       	call   800a29 <_panic>
			panic("set_pgfault_handler: sys_page_alloc fail, ret:%d", ret);
  8030db:	50                   	push   %eax
  8030dc:	68 18 3e 80 00       	push   $0x803e18
  8030e1:	6a 24                	push   $0x24
  8030e3:	68 8c 3e 80 00       	push   $0x803e8c
  8030e8:	e8 3c d9 ff ff       	call   800a29 <_panic>

008030ed <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8030ed:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8030ee:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  8030f3:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8030f5:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %edi
  8030f8:	8b 7c 24 28          	mov    0x28(%esp),%edi
	movl 0x30(%esp), %esi
  8030fc:	8b 74 24 30          	mov    0x30(%esp),%esi
	subl $4, %esi
  803100:	83 ee 04             	sub    $0x4,%esi
	movl %edi, (%esi)
  803103:	89 3e                	mov    %edi,(%esi)
	movl %esi, 0x30(%esp)
  803105:	89 74 24 30          	mov    %esi,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  803109:	83 c4 08             	add    $0x8,%esp
	popal
  80310c:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  80310d:	83 c4 04             	add    $0x4,%esp
	popfl
  803110:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  803111:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  803112:	c3                   	ret    

00803113 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803113:	55                   	push   %ebp
  803114:	89 e5                	mov    %esp,%ebp
  803116:	56                   	push   %esi
  803117:	53                   	push   %ebx
  803118:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80311b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80311e:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// return 0;
	if(!pg)
  803121:	85 c0                	test   %eax,%eax
		pg = (void*)UTOP;
  803123:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  803128:	0f 44 c2             	cmove  %edx,%eax
	
	int ret;

	ret = sys_ipc_recv(pg);
  80312b:	83 ec 0c             	sub    $0xc,%esp
  80312e:	50                   	push   %eax
  80312f:	e8 88 e7 ff ff       	call   8018bc <sys_ipc_recv>
	if(ret < 0){
  803134:	83 c4 10             	add    $0x10,%esp
  803137:	85 c0                	test   %eax,%eax
  803139:	78 2b                	js     803166 <ipc_recv+0x53>
		if(perm_store) *perm_store = 0;
		if(from_env_store) *from_env_store = 0;
		return ret;
	}
	
	if(perm_store)
  80313b:	85 f6                	test   %esi,%esi
  80313d:	74 0a                	je     803149 <ipc_recv+0x36>
		*perm_store = thisenv->env_ipc_perm;
  80313f:	a1 24 54 80 00       	mov    0x805424,%eax
  803144:	8b 40 78             	mov    0x78(%eax),%eax
  803147:	89 06                	mov    %eax,(%esi)
	if(from_env_store)
  803149:	85 db                	test   %ebx,%ebx
  80314b:	74 0a                	je     803157 <ipc_recv+0x44>
		*from_env_store = thisenv->env_ipc_from;
  80314d:	a1 24 54 80 00       	mov    0x805424,%eax
  803152:	8b 40 74             	mov    0x74(%eax),%eax
  803155:	89 03                	mov    %eax,(%ebx)

	return thisenv->env_ipc_value;
  803157:	a1 24 54 80 00       	mov    0x805424,%eax
  80315c:	8b 40 70             	mov    0x70(%eax),%eax
}
  80315f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803162:	5b                   	pop    %ebx
  803163:	5e                   	pop    %esi
  803164:	5d                   	pop    %ebp
  803165:	c3                   	ret    
		if(perm_store) *perm_store = 0;
  803166:	85 f6                	test   %esi,%esi
  803168:	74 06                	je     803170 <ipc_recv+0x5d>
  80316a:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(from_env_store) *from_env_store = 0;
  803170:	85 db                	test   %ebx,%ebx
  803172:	74 eb                	je     80315f <ipc_recv+0x4c>
  803174:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80317a:	eb e3                	jmp    80315f <ipc_recv+0x4c>

0080317c <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80317c:	55                   	push   %ebp
  80317d:	89 e5                	mov    %esp,%ebp
  80317f:	57                   	push   %edi
  803180:	56                   	push   %esi
  803181:	53                   	push   %ebx
  803182:	83 ec 0c             	sub    $0xc,%esp
  803185:	8b 7d 08             	mov    0x8(%ebp),%edi
  803188:	8b 75 0c             	mov    0xc(%ebp),%esi
  80318b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
	if (!pg)
  80318e:	85 db                	test   %ebx,%ebx
		pg = (void*)UTOP;
  803190:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  803195:	0f 44 d8             	cmove  %eax,%ebx

	int ret = -E_IPC_NOT_RECV;
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))) {
  803198:	ff 75 14             	pushl  0x14(%ebp)
  80319b:	53                   	push   %ebx
  80319c:	56                   	push   %esi
  80319d:	57                   	push   %edi
  80319e:	e8 f6 e6 ff ff       	call   801899 <sys_ipc_try_send>
  8031a3:	83 c4 10             	add    $0x10,%esp
  8031a6:	85 c0                	test   %eax,%eax
  8031a8:	74 17                	je     8031c1 <ipc_send+0x45>
		if(ret != -E_IPC_NOT_RECV){
  8031aa:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8031ad:	74 e9                	je     803198 <ipc_send+0x1c>
			panic("ipc_send: ret : %d", ret);
  8031af:	50                   	push   %eax
  8031b0:	68 9a 3e 80 00       	push   $0x803e9a
  8031b5:	6a 43                	push   $0x43
  8031b7:	68 ad 3e 80 00       	push   $0x803ead
  8031bc:	e8 68 d8 ff ff       	call   800a29 <_panic>
			sys_yield();
		}
	}
}
  8031c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8031c4:	5b                   	pop    %ebx
  8031c5:	5e                   	pop    %esi
  8031c6:	5f                   	pop    %edi
  8031c7:	5d                   	pop    %ebp
  8031c8:	c3                   	ret    

008031c9 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8031c9:	55                   	push   %ebp
  8031ca:	89 e5                	mov    %esp,%ebp
  8031cc:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8031cf:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8031d4:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  8031da:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8031e0:	8b 52 50             	mov    0x50(%edx),%edx
  8031e3:	39 ca                	cmp    %ecx,%edx
  8031e5:	74 11                	je     8031f8 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  8031e7:	83 c0 01             	add    $0x1,%eax
  8031ea:	3d 00 04 00 00       	cmp    $0x400,%eax
  8031ef:	75 e3                	jne    8031d4 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8031f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8031f6:	eb 0e                	jmp    803206 <ipc_find_env+0x3d>
			return envs[i].env_id;
  8031f8:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8031fe:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  803203:	8b 40 48             	mov    0x48(%eax),%eax
}
  803206:	5d                   	pop    %ebp
  803207:	c3                   	ret    

00803208 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803208:	55                   	push   %ebp
  803209:	89 e5                	mov    %esp,%ebp
  80320b:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80320e:	89 d0                	mov    %edx,%eax
  803210:	c1 e8 16             	shr    $0x16,%eax
  803213:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80321a:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80321f:	f6 c1 01             	test   $0x1,%cl
  803222:	74 1d                	je     803241 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  803224:	c1 ea 0c             	shr    $0xc,%edx
  803227:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80322e:	f6 c2 01             	test   $0x1,%dl
  803231:	74 0e                	je     803241 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  803233:	c1 ea 0c             	shr    $0xc,%edx
  803236:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80323d:	ef 
  80323e:	0f b7 c0             	movzwl %ax,%eax
}
  803241:	5d                   	pop    %ebp
  803242:	c3                   	ret    
  803243:	66 90                	xchg   %ax,%ax
  803245:	66 90                	xchg   %ax,%ax
  803247:	66 90                	xchg   %ax,%ax
  803249:	66 90                	xchg   %ax,%ax
  80324b:	66 90                	xchg   %ax,%ax
  80324d:	66 90                	xchg   %ax,%ax
  80324f:	90                   	nop

00803250 <__udivdi3>:
  803250:	55                   	push   %ebp
  803251:	57                   	push   %edi
  803252:	56                   	push   %esi
  803253:	53                   	push   %ebx
  803254:	83 ec 1c             	sub    $0x1c,%esp
  803257:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80325b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80325f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803263:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  803267:	85 d2                	test   %edx,%edx
  803269:	75 4d                	jne    8032b8 <__udivdi3+0x68>
  80326b:	39 f3                	cmp    %esi,%ebx
  80326d:	76 19                	jbe    803288 <__udivdi3+0x38>
  80326f:	31 ff                	xor    %edi,%edi
  803271:	89 e8                	mov    %ebp,%eax
  803273:	89 f2                	mov    %esi,%edx
  803275:	f7 f3                	div    %ebx
  803277:	89 fa                	mov    %edi,%edx
  803279:	83 c4 1c             	add    $0x1c,%esp
  80327c:	5b                   	pop    %ebx
  80327d:	5e                   	pop    %esi
  80327e:	5f                   	pop    %edi
  80327f:	5d                   	pop    %ebp
  803280:	c3                   	ret    
  803281:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803288:	89 d9                	mov    %ebx,%ecx
  80328a:	85 db                	test   %ebx,%ebx
  80328c:	75 0b                	jne    803299 <__udivdi3+0x49>
  80328e:	b8 01 00 00 00       	mov    $0x1,%eax
  803293:	31 d2                	xor    %edx,%edx
  803295:	f7 f3                	div    %ebx
  803297:	89 c1                	mov    %eax,%ecx
  803299:	31 d2                	xor    %edx,%edx
  80329b:	89 f0                	mov    %esi,%eax
  80329d:	f7 f1                	div    %ecx
  80329f:	89 c6                	mov    %eax,%esi
  8032a1:	89 e8                	mov    %ebp,%eax
  8032a3:	89 f7                	mov    %esi,%edi
  8032a5:	f7 f1                	div    %ecx
  8032a7:	89 fa                	mov    %edi,%edx
  8032a9:	83 c4 1c             	add    $0x1c,%esp
  8032ac:	5b                   	pop    %ebx
  8032ad:	5e                   	pop    %esi
  8032ae:	5f                   	pop    %edi
  8032af:	5d                   	pop    %ebp
  8032b0:	c3                   	ret    
  8032b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8032b8:	39 f2                	cmp    %esi,%edx
  8032ba:	77 1c                	ja     8032d8 <__udivdi3+0x88>
  8032bc:	0f bd fa             	bsr    %edx,%edi
  8032bf:	83 f7 1f             	xor    $0x1f,%edi
  8032c2:	75 2c                	jne    8032f0 <__udivdi3+0xa0>
  8032c4:	39 f2                	cmp    %esi,%edx
  8032c6:	72 06                	jb     8032ce <__udivdi3+0x7e>
  8032c8:	31 c0                	xor    %eax,%eax
  8032ca:	39 eb                	cmp    %ebp,%ebx
  8032cc:	77 a9                	ja     803277 <__udivdi3+0x27>
  8032ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8032d3:	eb a2                	jmp    803277 <__udivdi3+0x27>
  8032d5:	8d 76 00             	lea    0x0(%esi),%esi
  8032d8:	31 ff                	xor    %edi,%edi
  8032da:	31 c0                	xor    %eax,%eax
  8032dc:	89 fa                	mov    %edi,%edx
  8032de:	83 c4 1c             	add    $0x1c,%esp
  8032e1:	5b                   	pop    %ebx
  8032e2:	5e                   	pop    %esi
  8032e3:	5f                   	pop    %edi
  8032e4:	5d                   	pop    %ebp
  8032e5:	c3                   	ret    
  8032e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8032ed:	8d 76 00             	lea    0x0(%esi),%esi
  8032f0:	89 f9                	mov    %edi,%ecx
  8032f2:	b8 20 00 00 00       	mov    $0x20,%eax
  8032f7:	29 f8                	sub    %edi,%eax
  8032f9:	d3 e2                	shl    %cl,%edx
  8032fb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8032ff:	89 c1                	mov    %eax,%ecx
  803301:	89 da                	mov    %ebx,%edx
  803303:	d3 ea                	shr    %cl,%edx
  803305:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803309:	09 d1                	or     %edx,%ecx
  80330b:	89 f2                	mov    %esi,%edx
  80330d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803311:	89 f9                	mov    %edi,%ecx
  803313:	d3 e3                	shl    %cl,%ebx
  803315:	89 c1                	mov    %eax,%ecx
  803317:	d3 ea                	shr    %cl,%edx
  803319:	89 f9                	mov    %edi,%ecx
  80331b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80331f:	89 eb                	mov    %ebp,%ebx
  803321:	d3 e6                	shl    %cl,%esi
  803323:	89 c1                	mov    %eax,%ecx
  803325:	d3 eb                	shr    %cl,%ebx
  803327:	09 de                	or     %ebx,%esi
  803329:	89 f0                	mov    %esi,%eax
  80332b:	f7 74 24 08          	divl   0x8(%esp)
  80332f:	89 d6                	mov    %edx,%esi
  803331:	89 c3                	mov    %eax,%ebx
  803333:	f7 64 24 0c          	mull   0xc(%esp)
  803337:	39 d6                	cmp    %edx,%esi
  803339:	72 15                	jb     803350 <__udivdi3+0x100>
  80333b:	89 f9                	mov    %edi,%ecx
  80333d:	d3 e5                	shl    %cl,%ebp
  80333f:	39 c5                	cmp    %eax,%ebp
  803341:	73 04                	jae    803347 <__udivdi3+0xf7>
  803343:	39 d6                	cmp    %edx,%esi
  803345:	74 09                	je     803350 <__udivdi3+0x100>
  803347:	89 d8                	mov    %ebx,%eax
  803349:	31 ff                	xor    %edi,%edi
  80334b:	e9 27 ff ff ff       	jmp    803277 <__udivdi3+0x27>
  803350:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803353:	31 ff                	xor    %edi,%edi
  803355:	e9 1d ff ff ff       	jmp    803277 <__udivdi3+0x27>
  80335a:	66 90                	xchg   %ax,%ax
  80335c:	66 90                	xchg   %ax,%ax
  80335e:	66 90                	xchg   %ax,%ax

00803360 <__umoddi3>:
  803360:	55                   	push   %ebp
  803361:	57                   	push   %edi
  803362:	56                   	push   %esi
  803363:	53                   	push   %ebx
  803364:	83 ec 1c             	sub    $0x1c,%esp
  803367:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80336b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80336f:	8b 74 24 30          	mov    0x30(%esp),%esi
  803373:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803377:	89 da                	mov    %ebx,%edx
  803379:	85 c0                	test   %eax,%eax
  80337b:	75 43                	jne    8033c0 <__umoddi3+0x60>
  80337d:	39 df                	cmp    %ebx,%edi
  80337f:	76 17                	jbe    803398 <__umoddi3+0x38>
  803381:	89 f0                	mov    %esi,%eax
  803383:	f7 f7                	div    %edi
  803385:	89 d0                	mov    %edx,%eax
  803387:	31 d2                	xor    %edx,%edx
  803389:	83 c4 1c             	add    $0x1c,%esp
  80338c:	5b                   	pop    %ebx
  80338d:	5e                   	pop    %esi
  80338e:	5f                   	pop    %edi
  80338f:	5d                   	pop    %ebp
  803390:	c3                   	ret    
  803391:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803398:	89 fd                	mov    %edi,%ebp
  80339a:	85 ff                	test   %edi,%edi
  80339c:	75 0b                	jne    8033a9 <__umoddi3+0x49>
  80339e:	b8 01 00 00 00       	mov    $0x1,%eax
  8033a3:	31 d2                	xor    %edx,%edx
  8033a5:	f7 f7                	div    %edi
  8033a7:	89 c5                	mov    %eax,%ebp
  8033a9:	89 d8                	mov    %ebx,%eax
  8033ab:	31 d2                	xor    %edx,%edx
  8033ad:	f7 f5                	div    %ebp
  8033af:	89 f0                	mov    %esi,%eax
  8033b1:	f7 f5                	div    %ebp
  8033b3:	89 d0                	mov    %edx,%eax
  8033b5:	eb d0                	jmp    803387 <__umoddi3+0x27>
  8033b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8033be:	66 90                	xchg   %ax,%ax
  8033c0:	89 f1                	mov    %esi,%ecx
  8033c2:	39 d8                	cmp    %ebx,%eax
  8033c4:	76 0a                	jbe    8033d0 <__umoddi3+0x70>
  8033c6:	89 f0                	mov    %esi,%eax
  8033c8:	83 c4 1c             	add    $0x1c,%esp
  8033cb:	5b                   	pop    %ebx
  8033cc:	5e                   	pop    %esi
  8033cd:	5f                   	pop    %edi
  8033ce:	5d                   	pop    %ebp
  8033cf:	c3                   	ret    
  8033d0:	0f bd e8             	bsr    %eax,%ebp
  8033d3:	83 f5 1f             	xor    $0x1f,%ebp
  8033d6:	75 20                	jne    8033f8 <__umoddi3+0x98>
  8033d8:	39 d8                	cmp    %ebx,%eax
  8033da:	0f 82 b0 00 00 00    	jb     803490 <__umoddi3+0x130>
  8033e0:	39 f7                	cmp    %esi,%edi
  8033e2:	0f 86 a8 00 00 00    	jbe    803490 <__umoddi3+0x130>
  8033e8:	89 c8                	mov    %ecx,%eax
  8033ea:	83 c4 1c             	add    $0x1c,%esp
  8033ed:	5b                   	pop    %ebx
  8033ee:	5e                   	pop    %esi
  8033ef:	5f                   	pop    %edi
  8033f0:	5d                   	pop    %ebp
  8033f1:	c3                   	ret    
  8033f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8033f8:	89 e9                	mov    %ebp,%ecx
  8033fa:	ba 20 00 00 00       	mov    $0x20,%edx
  8033ff:	29 ea                	sub    %ebp,%edx
  803401:	d3 e0                	shl    %cl,%eax
  803403:	89 44 24 08          	mov    %eax,0x8(%esp)
  803407:	89 d1                	mov    %edx,%ecx
  803409:	89 f8                	mov    %edi,%eax
  80340b:	d3 e8                	shr    %cl,%eax
  80340d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803411:	89 54 24 04          	mov    %edx,0x4(%esp)
  803415:	8b 54 24 04          	mov    0x4(%esp),%edx
  803419:	09 c1                	or     %eax,%ecx
  80341b:	89 d8                	mov    %ebx,%eax
  80341d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803421:	89 e9                	mov    %ebp,%ecx
  803423:	d3 e7                	shl    %cl,%edi
  803425:	89 d1                	mov    %edx,%ecx
  803427:	d3 e8                	shr    %cl,%eax
  803429:	89 e9                	mov    %ebp,%ecx
  80342b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80342f:	d3 e3                	shl    %cl,%ebx
  803431:	89 c7                	mov    %eax,%edi
  803433:	89 d1                	mov    %edx,%ecx
  803435:	89 f0                	mov    %esi,%eax
  803437:	d3 e8                	shr    %cl,%eax
  803439:	89 e9                	mov    %ebp,%ecx
  80343b:	89 fa                	mov    %edi,%edx
  80343d:	d3 e6                	shl    %cl,%esi
  80343f:	09 d8                	or     %ebx,%eax
  803441:	f7 74 24 08          	divl   0x8(%esp)
  803445:	89 d1                	mov    %edx,%ecx
  803447:	89 f3                	mov    %esi,%ebx
  803449:	f7 64 24 0c          	mull   0xc(%esp)
  80344d:	89 c6                	mov    %eax,%esi
  80344f:	89 d7                	mov    %edx,%edi
  803451:	39 d1                	cmp    %edx,%ecx
  803453:	72 06                	jb     80345b <__umoddi3+0xfb>
  803455:	75 10                	jne    803467 <__umoddi3+0x107>
  803457:	39 c3                	cmp    %eax,%ebx
  803459:	73 0c                	jae    803467 <__umoddi3+0x107>
  80345b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80345f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  803463:	89 d7                	mov    %edx,%edi
  803465:	89 c6                	mov    %eax,%esi
  803467:	89 ca                	mov    %ecx,%edx
  803469:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80346e:	29 f3                	sub    %esi,%ebx
  803470:	19 fa                	sbb    %edi,%edx
  803472:	89 d0                	mov    %edx,%eax
  803474:	d3 e0                	shl    %cl,%eax
  803476:	89 e9                	mov    %ebp,%ecx
  803478:	d3 eb                	shr    %cl,%ebx
  80347a:	d3 ea                	shr    %cl,%edx
  80347c:	09 d8                	or     %ebx,%eax
  80347e:	83 c4 1c             	add    $0x1c,%esp
  803481:	5b                   	pop    %ebx
  803482:	5e                   	pop    %esi
  803483:	5f                   	pop    %edi
  803484:	5d                   	pop    %ebp
  803485:	c3                   	ret    
  803486:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80348d:	8d 76 00             	lea    0x0(%esi),%esi
  803490:	89 da                	mov    %ebx,%edx
  803492:	29 fe                	sub    %edi,%esi
  803494:	19 c2                	sbb    %eax,%edx
  803496:	89 f1                	mov    %esi,%ecx
  803498:	89 c8                	mov    %ecx,%eax
  80349a:	e9 4b ff ff ff       	jmp    8033ea <__umoddi3+0x8a>
