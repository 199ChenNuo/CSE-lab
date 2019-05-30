
obj/user/ls.debug:     file format elf32-i386


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
  80002c:	e8 95 02 00 00       	call   8002c6 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <ls1>:
		panic("error reading directory %s: %e", path, n);
}

void
ls1(const char *prefix, bool isdir, off_t size, const char *name)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80003b:	8b 75 0c             	mov    0xc(%ebp),%esi
	const char *sep;

	if(flag['l'])
  80003e:	83 3d d0 41 80 00 00 	cmpl   $0x0,0x8041d0
  800045:	74 20                	je     800067 <ls1+0x34>
		printf("%11d %c ", size, isdir ? 'd' : '-');
  800047:	89 f0                	mov    %esi,%eax
  800049:	3c 01                	cmp    $0x1,%al
  80004b:	19 c0                	sbb    %eax,%eax
  80004d:	83 e0 c9             	and    $0xffffffc9,%eax
  800050:	83 c0 64             	add    $0x64,%eax
  800053:	83 ec 04             	sub    $0x4,%esp
  800056:	50                   	push   %eax
  800057:	ff 75 10             	pushl  0x10(%ebp)
  80005a:	68 c2 23 80 00       	push   $0x8023c2
  80005f:	e8 f4 1a 00 00       	call   801b58 <printf>
  800064:	83 c4 10             	add    $0x10,%esp
	if(prefix) {
  800067:	85 db                	test   %ebx,%ebx
  800069:	74 1c                	je     800087 <ls1+0x54>
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
			sep = "/";
		else
			sep = "";
  80006b:	b8 28 24 80 00       	mov    $0x802428,%eax
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
  800070:	80 3b 00             	cmpb   $0x0,(%ebx)
  800073:	75 4b                	jne    8000c0 <ls1+0x8d>
		printf("%s%s", prefix, sep);
  800075:	83 ec 04             	sub    $0x4,%esp
  800078:	50                   	push   %eax
  800079:	53                   	push   %ebx
  80007a:	68 cb 23 80 00       	push   $0x8023cb
  80007f:	e8 d4 1a 00 00       	call   801b58 <printf>
  800084:	83 c4 10             	add    $0x10,%esp
	}
	printf("%s", name);
  800087:	83 ec 08             	sub    $0x8,%esp
  80008a:	ff 75 14             	pushl  0x14(%ebp)
  80008d:	68 fe 28 80 00       	push   $0x8028fe
  800092:	e8 c1 1a 00 00       	call   801b58 <printf>
	if(flag['F'] && isdir)
  800097:	83 c4 10             	add    $0x10,%esp
  80009a:	83 3d 38 41 80 00 00 	cmpl   $0x0,0x804138
  8000a1:	74 06                	je     8000a9 <ls1+0x76>
  8000a3:	89 f0                	mov    %esi,%eax
  8000a5:	84 c0                	test   %al,%al
  8000a7:	75 37                	jne    8000e0 <ls1+0xad>
		printf("/");
	printf("\n");
  8000a9:	83 ec 0c             	sub    $0xc,%esp
  8000ac:	68 27 24 80 00       	push   $0x802427
  8000b1:	e8 a2 1a 00 00       	call   801b58 <printf>
}
  8000b6:	83 c4 10             	add    $0x10,%esp
  8000b9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000bc:	5b                   	pop    %ebx
  8000bd:	5e                   	pop    %esi
  8000be:	5d                   	pop    %ebp
  8000bf:	c3                   	ret    
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
  8000c0:	83 ec 0c             	sub    $0xc,%esp
  8000c3:	53                   	push   %ebx
  8000c4:	e8 20 0a 00 00       	call   800ae9 <strlen>
  8000c9:	83 c4 10             	add    $0x10,%esp
			sep = "";
  8000cc:	80 7c 03 ff 2f       	cmpb   $0x2f,-0x1(%ebx,%eax,1)
  8000d1:	b8 c0 23 80 00       	mov    $0x8023c0,%eax
  8000d6:	ba 28 24 80 00       	mov    $0x802428,%edx
  8000db:	0f 44 c2             	cmove  %edx,%eax
  8000de:	eb 95                	jmp    800075 <ls1+0x42>
		printf("/");
  8000e0:	83 ec 0c             	sub    $0xc,%esp
  8000e3:	68 c0 23 80 00       	push   $0x8023c0
  8000e8:	e8 6b 1a 00 00       	call   801b58 <printf>
  8000ed:	83 c4 10             	add    $0x10,%esp
  8000f0:	eb b7                	jmp    8000a9 <ls1+0x76>

008000f2 <lsdir>:
{
  8000f2:	55                   	push   %ebp
  8000f3:	89 e5                	mov    %esp,%ebp
  8000f5:	57                   	push   %edi
  8000f6:	56                   	push   %esi
  8000f7:	53                   	push   %ebx
  8000f8:	81 ec 14 01 00 00    	sub    $0x114,%esp
  8000fe:	8b 7d 08             	mov    0x8(%ebp),%edi
	if ((fd = open(path, O_RDONLY)) < 0)
  800101:	6a 00                	push   $0x0
  800103:	57                   	push   %edi
  800104:	e8 ac 18 00 00       	call   8019b5 <open>
  800109:	89 c3                	mov    %eax,%ebx
  80010b:	83 c4 10             	add    $0x10,%esp
  80010e:	85 c0                	test   %eax,%eax
  800110:	78 4a                	js     80015c <lsdir+0x6a>
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
  800112:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  800118:	83 ec 04             	sub    $0x4,%esp
  80011b:	68 00 01 00 00       	push   $0x100
  800120:	56                   	push   %esi
  800121:	53                   	push   %ebx
  800122:	e8 de 14 00 00       	call   801605 <readn>
  800127:	83 c4 10             	add    $0x10,%esp
  80012a:	3d 00 01 00 00       	cmp    $0x100,%eax
  80012f:	75 41                	jne    800172 <lsdir+0x80>
		if (f.f_name[0])
  800131:	80 bd e8 fe ff ff 00 	cmpb   $0x0,-0x118(%ebp)
  800138:	74 de                	je     800118 <lsdir+0x26>
			ls1(prefix, f.f_type==FTYPE_DIR, f.f_size, f.f_name);
  80013a:	56                   	push   %esi
  80013b:	ff b5 68 ff ff ff    	pushl  -0x98(%ebp)
  800141:	83 bd 6c ff ff ff 01 	cmpl   $0x1,-0x94(%ebp)
  800148:	0f 94 c0             	sete   %al
  80014b:	0f b6 c0             	movzbl %al,%eax
  80014e:	50                   	push   %eax
  80014f:	ff 75 0c             	pushl  0xc(%ebp)
  800152:	e8 dc fe ff ff       	call   800033 <ls1>
  800157:	83 c4 10             	add    $0x10,%esp
  80015a:	eb bc                	jmp    800118 <lsdir+0x26>
		panic("open %s: %e", path, fd);
  80015c:	83 ec 0c             	sub    $0xc,%esp
  80015f:	50                   	push   %eax
  800160:	57                   	push   %edi
  800161:	68 d0 23 80 00       	push   $0x8023d0
  800166:	6a 1d                	push   $0x1d
  800168:	68 dc 23 80 00       	push   $0x8023dc
  80016d:	e8 af 01 00 00       	call   800321 <_panic>
	if (n > 0)
  800172:	85 c0                	test   %eax,%eax
  800174:	7f 0a                	jg     800180 <lsdir+0x8e>
	if (n < 0)
  800176:	78 1a                	js     800192 <lsdir+0xa0>
}
  800178:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80017b:	5b                   	pop    %ebx
  80017c:	5e                   	pop    %esi
  80017d:	5f                   	pop    %edi
  80017e:	5d                   	pop    %ebp
  80017f:	c3                   	ret    
		panic("short read in directory %s", path);
  800180:	57                   	push   %edi
  800181:	68 e6 23 80 00       	push   $0x8023e6
  800186:	6a 22                	push   $0x22
  800188:	68 dc 23 80 00       	push   $0x8023dc
  80018d:	e8 8f 01 00 00       	call   800321 <_panic>
		panic("error reading directory %s: %e", path, n);
  800192:	83 ec 0c             	sub    $0xc,%esp
  800195:	50                   	push   %eax
  800196:	57                   	push   %edi
  800197:	68 2c 24 80 00       	push   $0x80242c
  80019c:	6a 24                	push   $0x24
  80019e:	68 dc 23 80 00       	push   $0x8023dc
  8001a3:	e8 79 01 00 00       	call   800321 <_panic>

008001a8 <ls>:
{
  8001a8:	55                   	push   %ebp
  8001a9:	89 e5                	mov    %esp,%ebp
  8001ab:	53                   	push   %ebx
  8001ac:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  8001b2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if ((r = stat(path, &st)) < 0)
  8001b5:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
  8001bb:	50                   	push   %eax
  8001bc:	53                   	push   %ebx
  8001bd:	e8 26 16 00 00       	call   8017e8 <stat>
  8001c2:	83 c4 10             	add    $0x10,%esp
  8001c5:	85 c0                	test   %eax,%eax
  8001c7:	78 2c                	js     8001f5 <ls+0x4d>
	if (st.st_isdir && !flag['d'])
  8001c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001cc:	85 c0                	test   %eax,%eax
  8001ce:	74 09                	je     8001d9 <ls+0x31>
  8001d0:	83 3d b0 41 80 00 00 	cmpl   $0x0,0x8041b0
  8001d7:	74 32                	je     80020b <ls+0x63>
		ls1(0, st.st_isdir, st.st_size, path);
  8001d9:	53                   	push   %ebx
  8001da:	ff 75 ec             	pushl  -0x14(%ebp)
  8001dd:	85 c0                	test   %eax,%eax
  8001df:	0f 95 c0             	setne  %al
  8001e2:	0f b6 c0             	movzbl %al,%eax
  8001e5:	50                   	push   %eax
  8001e6:	6a 00                	push   $0x0
  8001e8:	e8 46 fe ff ff       	call   800033 <ls1>
  8001ed:	83 c4 10             	add    $0x10,%esp
}
  8001f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001f3:	c9                   	leave  
  8001f4:	c3                   	ret    
		panic("stat %s: %e", path, r);
  8001f5:	83 ec 0c             	sub    $0xc,%esp
  8001f8:	50                   	push   %eax
  8001f9:	53                   	push   %ebx
  8001fa:	68 01 24 80 00       	push   $0x802401
  8001ff:	6a 0f                	push   $0xf
  800201:	68 dc 23 80 00       	push   $0x8023dc
  800206:	e8 16 01 00 00       	call   800321 <_panic>
		lsdir(path, prefix);
  80020b:	83 ec 08             	sub    $0x8,%esp
  80020e:	ff 75 0c             	pushl  0xc(%ebp)
  800211:	53                   	push   %ebx
  800212:	e8 db fe ff ff       	call   8000f2 <lsdir>
  800217:	83 c4 10             	add    $0x10,%esp
  80021a:	eb d4                	jmp    8001f0 <ls+0x48>

0080021c <usage>:

void
usage(void)
{
  80021c:	55                   	push   %ebp
  80021d:	89 e5                	mov    %esp,%ebp
  80021f:	83 ec 14             	sub    $0x14,%esp
	printf("usage: ls [-dFl] [file...]\n");
  800222:	68 0d 24 80 00       	push   $0x80240d
  800227:	e8 2c 19 00 00       	call   801b58 <printf>
	exit();
  80022c:	e8 de 00 00 00       	call   80030f <exit>
}
  800231:	83 c4 10             	add    $0x10,%esp
  800234:	c9                   	leave  
  800235:	c3                   	ret    

00800236 <umain>:

void
umain(int argc, char **argv)
{
  800236:	55                   	push   %ebp
  800237:	89 e5                	mov    %esp,%ebp
  800239:	56                   	push   %esi
  80023a:	53                   	push   %ebx
  80023b:	83 ec 14             	sub    $0x14,%esp
  80023e:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i;
	struct Argstate args;

	argstart(&argc, argv, &args);
  800241:	8d 45 e8             	lea    -0x18(%ebp),%eax
  800244:	50                   	push   %eax
  800245:	56                   	push   %esi
  800246:	8d 45 08             	lea    0x8(%ebp),%eax
  800249:	50                   	push   %eax
  80024a:	e8 f7 0e 00 00       	call   801146 <argstart>
	while ((i = argnext(&args)) >= 0)
  80024f:	83 c4 10             	add    $0x10,%esp
  800252:	8d 5d e8             	lea    -0x18(%ebp),%ebx
  800255:	eb 08                	jmp    80025f <umain+0x29>
		switch (i) {
		case 'd':
		case 'F':
		case 'l':
			flag[i]++;
  800257:	83 04 85 20 40 80 00 	addl   $0x1,0x804020(,%eax,4)
  80025e:	01 
	while ((i = argnext(&args)) >= 0)
  80025f:	83 ec 0c             	sub    $0xc,%esp
  800262:	53                   	push   %ebx
  800263:	e8 0e 0f 00 00       	call   801176 <argnext>
  800268:	83 c4 10             	add    $0x10,%esp
  80026b:	85 c0                	test   %eax,%eax
  80026d:	78 16                	js     800285 <umain+0x4f>
  80026f:	83 f8 64             	cmp    $0x64,%eax
  800272:	74 e3                	je     800257 <umain+0x21>
  800274:	83 f8 6c             	cmp    $0x6c,%eax
  800277:	74 de                	je     800257 <umain+0x21>
  800279:	83 f8 46             	cmp    $0x46,%eax
  80027c:	74 d9                	je     800257 <umain+0x21>
			break;
		default:
			usage();
  80027e:	e8 99 ff ff ff       	call   80021c <usage>
  800283:	eb da                	jmp    80025f <umain+0x29>
		}

	if (argc == 1)
		ls("/", "");
	else {
		for (i = 1; i < argc; i++)
  800285:	bb 01 00 00 00       	mov    $0x1,%ebx
	if (argc == 1)
  80028a:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  80028e:	75 2a                	jne    8002ba <umain+0x84>
		ls("/", "");
  800290:	83 ec 08             	sub    $0x8,%esp
  800293:	68 28 24 80 00       	push   $0x802428
  800298:	68 c0 23 80 00       	push   $0x8023c0
  80029d:	e8 06 ff ff ff       	call   8001a8 <ls>
  8002a2:	83 c4 10             	add    $0x10,%esp
  8002a5:	eb 18                	jmp    8002bf <umain+0x89>
			ls(argv[i], argv[i]);
  8002a7:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  8002aa:	83 ec 08             	sub    $0x8,%esp
  8002ad:	50                   	push   %eax
  8002ae:	50                   	push   %eax
  8002af:	e8 f4 fe ff ff       	call   8001a8 <ls>
		for (i = 1; i < argc; i++)
  8002b4:	83 c3 01             	add    $0x1,%ebx
  8002b7:	83 c4 10             	add    $0x10,%esp
  8002ba:	39 5d 08             	cmp    %ebx,0x8(%ebp)
  8002bd:	7f e8                	jg     8002a7 <umain+0x71>
	}
}
  8002bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8002c2:	5b                   	pop    %ebx
  8002c3:	5e                   	pop    %esi
  8002c4:	5d                   	pop    %ebp
  8002c5:	c3                   	ret    

008002c6 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002c6:	55                   	push   %ebp
  8002c7:	89 e5                	mov    %esp,%ebp
  8002c9:	56                   	push   %esi
  8002ca:	53                   	push   %ebx
  8002cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8002ce:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	// thisenv = 0;
	thisenv = &(envs[ENVX(sys_getenvid())]);
  8002d1:	e8 00 0c 00 00       	call   800ed6 <sys_getenvid>
  8002d6:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002db:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8002e1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002e6:	a3 20 44 80 00       	mov    %eax,0x804420

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002eb:	85 db                	test   %ebx,%ebx
  8002ed:	7e 07                	jle    8002f6 <libmain+0x30>
		binaryname = argv[0];
  8002ef:	8b 06                	mov    (%esi),%eax
  8002f1:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8002f6:	83 ec 08             	sub    $0x8,%esp
  8002f9:	56                   	push   %esi
  8002fa:	53                   	push   %ebx
  8002fb:	e8 36 ff ff ff       	call   800236 <umain>

	// exit gracefully
	exit();
  800300:	e8 0a 00 00 00       	call   80030f <exit>
}
  800305:	83 c4 10             	add    $0x10,%esp
  800308:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80030b:	5b                   	pop    %ebx
  80030c:	5e                   	pop    %esi
  80030d:	5d                   	pop    %ebp
  80030e:	c3                   	ret    

0080030f <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80030f:	55                   	push   %ebp
  800310:	89 e5                	mov    %esp,%ebp
  800312:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  800315:	6a 00                	push   $0x0
  800317:	e8 79 0b 00 00       	call   800e95 <sys_env_destroy>
}
  80031c:	83 c4 10             	add    $0x10,%esp
  80031f:	c9                   	leave  
  800320:	c3                   	ret    

00800321 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800321:	55                   	push   %ebp
  800322:	89 e5                	mov    %esp,%ebp
  800324:	56                   	push   %esi
  800325:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800326:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800329:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80032f:	e8 a2 0b 00 00       	call   800ed6 <sys_getenvid>
  800334:	83 ec 0c             	sub    $0xc,%esp
  800337:	ff 75 0c             	pushl  0xc(%ebp)
  80033a:	ff 75 08             	pushl  0x8(%ebp)
  80033d:	56                   	push   %esi
  80033e:	50                   	push   %eax
  80033f:	68 58 24 80 00       	push   $0x802458
  800344:	e8 b3 00 00 00       	call   8003fc <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800349:	83 c4 18             	add    $0x18,%esp
  80034c:	53                   	push   %ebx
  80034d:	ff 75 10             	pushl  0x10(%ebp)
  800350:	e8 56 00 00 00       	call   8003ab <vcprintf>
	cprintf("\n");
  800355:	c7 04 24 27 24 80 00 	movl   $0x802427,(%esp)
  80035c:	e8 9b 00 00 00       	call   8003fc <cprintf>
  800361:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800364:	cc                   	int3   
  800365:	eb fd                	jmp    800364 <_panic+0x43>

00800367 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800367:	55                   	push   %ebp
  800368:	89 e5                	mov    %esp,%ebp
  80036a:	53                   	push   %ebx
  80036b:	83 ec 04             	sub    $0x4,%esp
  80036e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800371:	8b 13                	mov    (%ebx),%edx
  800373:	8d 42 01             	lea    0x1(%edx),%eax
  800376:	89 03                	mov    %eax,(%ebx)
  800378:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80037b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80037f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800384:	74 09                	je     80038f <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800386:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80038a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80038d:	c9                   	leave  
  80038e:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80038f:	83 ec 08             	sub    $0x8,%esp
  800392:	68 ff 00 00 00       	push   $0xff
  800397:	8d 43 08             	lea    0x8(%ebx),%eax
  80039a:	50                   	push   %eax
  80039b:	e8 b8 0a 00 00       	call   800e58 <sys_cputs>
		b->idx = 0;
  8003a0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8003a6:	83 c4 10             	add    $0x10,%esp
  8003a9:	eb db                	jmp    800386 <putch+0x1f>

008003ab <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003ab:	55                   	push   %ebp
  8003ac:	89 e5                	mov    %esp,%ebp
  8003ae:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003b4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003bb:	00 00 00 
	b.cnt = 0;
  8003be:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003c5:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003c8:	ff 75 0c             	pushl  0xc(%ebp)
  8003cb:	ff 75 08             	pushl  0x8(%ebp)
  8003ce:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003d4:	50                   	push   %eax
  8003d5:	68 67 03 80 00       	push   $0x800367
  8003da:	e8 4a 01 00 00       	call   800529 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8003df:	83 c4 08             	add    $0x8,%esp
  8003e2:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8003e8:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8003ee:	50                   	push   %eax
  8003ef:	e8 64 0a 00 00       	call   800e58 <sys_cputs>

	return b.cnt;
}
  8003f4:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8003fa:	c9                   	leave  
  8003fb:	c3                   	ret    

008003fc <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8003fc:	55                   	push   %ebp
  8003fd:	89 e5                	mov    %esp,%ebp
  8003ff:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800402:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800405:	50                   	push   %eax
  800406:	ff 75 08             	pushl  0x8(%ebp)
  800409:	e8 9d ff ff ff       	call   8003ab <vcprintf>
	va_end(ap);

	return cnt;
}
  80040e:	c9                   	leave  
  80040f:	c3                   	ret    

00800410 <printnum>:


static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800410:	55                   	push   %ebp
  800411:	89 e5                	mov    %esp,%ebp
  800413:	57                   	push   %edi
  800414:	56                   	push   %esi
  800415:	53                   	push   %ebx
  800416:	83 ec 1c             	sub    $0x1c,%esp
  800419:	89 c6                	mov    %eax,%esi
  80041b:	89 d7                	mov    %edx,%edi
  80041d:	8b 45 08             	mov    0x8(%ebp),%eax
  800420:	8b 55 0c             	mov    0xc(%ebp),%edx
  800423:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800426:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800429:	8b 45 10             	mov    0x10(%ebp),%eax
  80042c:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	// to support '-'
	if(padc == '-'){
  80042f:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800433:	74 2c                	je     800461 <printnum+0x51>
		while (--width > 0)
			putch(' ', putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800435:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800438:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80043f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800442:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800445:	39 c2                	cmp    %eax,%edx
  800447:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80044a:	73 43                	jae    80048f <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80044c:	83 eb 01             	sub    $0x1,%ebx
  80044f:	85 db                	test   %ebx,%ebx
  800451:	7e 6c                	jle    8004bf <printnum+0xaf>
			putch(padc, putdat);
  800453:	83 ec 08             	sub    $0x8,%esp
  800456:	57                   	push   %edi
  800457:	ff 75 18             	pushl  0x18(%ebp)
  80045a:	ff d6                	call   *%esi
  80045c:	83 c4 10             	add    $0x10,%esp
  80045f:	eb eb                	jmp    80044c <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800461:	83 ec 0c             	sub    $0xc,%esp
  800464:	6a 20                	push   $0x20
  800466:	6a 00                	push   $0x0
  800468:	50                   	push   %eax
  800469:	ff 75 e4             	pushl  -0x1c(%ebp)
  80046c:	ff 75 e0             	pushl  -0x20(%ebp)
  80046f:	89 fa                	mov    %edi,%edx
  800471:	89 f0                	mov    %esi,%eax
  800473:	e8 98 ff ff ff       	call   800410 <printnum>
		while (--width > 0)
  800478:	83 c4 20             	add    $0x20,%esp
  80047b:	83 eb 01             	sub    $0x1,%ebx
  80047e:	85 db                	test   %ebx,%ebx
  800480:	7e 65                	jle    8004e7 <printnum+0xd7>
			putch(' ', putdat);
  800482:	83 ec 08             	sub    $0x8,%esp
  800485:	57                   	push   %edi
  800486:	6a 20                	push   $0x20
  800488:	ff d6                	call   *%esi
  80048a:	83 c4 10             	add    $0x10,%esp
  80048d:	eb ec                	jmp    80047b <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80048f:	83 ec 0c             	sub    $0xc,%esp
  800492:	ff 75 18             	pushl  0x18(%ebp)
  800495:	83 eb 01             	sub    $0x1,%ebx
  800498:	53                   	push   %ebx
  800499:	50                   	push   %eax
  80049a:	83 ec 08             	sub    $0x8,%esp
  80049d:	ff 75 dc             	pushl  -0x24(%ebp)
  8004a0:	ff 75 d8             	pushl  -0x28(%ebp)
  8004a3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004a6:	ff 75 e0             	pushl  -0x20(%ebp)
  8004a9:	e8 c2 1c 00 00       	call   802170 <__udivdi3>
  8004ae:	83 c4 18             	add    $0x18,%esp
  8004b1:	52                   	push   %edx
  8004b2:	50                   	push   %eax
  8004b3:	89 fa                	mov    %edi,%edx
  8004b5:	89 f0                	mov    %esi,%eax
  8004b7:	e8 54 ff ff ff       	call   800410 <printnum>
  8004bc:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004bf:	83 ec 08             	sub    $0x8,%esp
  8004c2:	57                   	push   %edi
  8004c3:	83 ec 04             	sub    $0x4,%esp
  8004c6:	ff 75 dc             	pushl  -0x24(%ebp)
  8004c9:	ff 75 d8             	pushl  -0x28(%ebp)
  8004cc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004cf:	ff 75 e0             	pushl  -0x20(%ebp)
  8004d2:	e8 a9 1d 00 00       	call   802280 <__umoddi3>
  8004d7:	83 c4 14             	add    $0x14,%esp
  8004da:	0f be 80 7b 24 80 00 	movsbl 0x80247b(%eax),%eax
  8004e1:	50                   	push   %eax
  8004e2:	ff d6                	call   *%esi
  8004e4:	83 c4 10             	add    $0x10,%esp
}
  8004e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004ea:	5b                   	pop    %ebx
  8004eb:	5e                   	pop    %esi
  8004ec:	5f                   	pop    %edi
  8004ed:	5d                   	pop    %ebp
  8004ee:	c3                   	ret    

008004ef <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004ef:	55                   	push   %ebp
  8004f0:	89 e5                	mov    %esp,%ebp
  8004f2:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004f5:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004f9:	8b 10                	mov    (%eax),%edx
  8004fb:	3b 50 04             	cmp    0x4(%eax),%edx
  8004fe:	73 0a                	jae    80050a <sprintputch+0x1b>
		*b->buf++ = ch;
  800500:	8d 4a 01             	lea    0x1(%edx),%ecx
  800503:	89 08                	mov    %ecx,(%eax)
  800505:	8b 45 08             	mov    0x8(%ebp),%eax
  800508:	88 02                	mov    %al,(%edx)
}
  80050a:	5d                   	pop    %ebp
  80050b:	c3                   	ret    

0080050c <printfmt>:
{
  80050c:	55                   	push   %ebp
  80050d:	89 e5                	mov    %esp,%ebp
  80050f:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800512:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800515:	50                   	push   %eax
  800516:	ff 75 10             	pushl  0x10(%ebp)
  800519:	ff 75 0c             	pushl  0xc(%ebp)
  80051c:	ff 75 08             	pushl  0x8(%ebp)
  80051f:	e8 05 00 00 00       	call   800529 <vprintfmt>
}
  800524:	83 c4 10             	add    $0x10,%esp
  800527:	c9                   	leave  
  800528:	c3                   	ret    

00800529 <vprintfmt>:
{
  800529:	55                   	push   %ebp
  80052a:	89 e5                	mov    %esp,%ebp
  80052c:	57                   	push   %edi
  80052d:	56                   	push   %esi
  80052e:	53                   	push   %ebx
  80052f:	83 ec 3c             	sub    $0x3c,%esp
  800532:	8b 75 08             	mov    0x8(%ebp),%esi
  800535:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800538:	8b 7d 10             	mov    0x10(%ebp),%edi
  80053b:	e9 1e 04 00 00       	jmp    80095e <vprintfmt+0x435>
		posflag = 0;
  800540:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
		padc = ' ';
  800547:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80054b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800552:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800559:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800560:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  800567:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80056c:	8d 47 01             	lea    0x1(%edi),%eax
  80056f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800572:	0f b6 17             	movzbl (%edi),%edx
  800575:	8d 42 dd             	lea    -0x23(%edx),%eax
  800578:	3c 55                	cmp    $0x55,%al
  80057a:	0f 87 d9 04 00 00    	ja     800a59 <vprintfmt+0x530>
  800580:	0f b6 c0             	movzbl %al,%eax
  800583:	ff 24 85 60 26 80 00 	jmp    *0x802660(,%eax,4)
  80058a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80058d:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800591:	eb d9                	jmp    80056c <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800593:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posflag = 1;
  800596:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  80059d:	eb cd                	jmp    80056c <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80059f:	0f b6 d2             	movzbl %dl,%edx
  8005a2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8005a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8005aa:	89 75 08             	mov    %esi,0x8(%ebp)
  8005ad:	eb 0c                	jmp    8005bb <vprintfmt+0x92>
		switch (ch = *(unsigned char *) fmt++) {
  8005af:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8005b2:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  8005b6:	eb b4                	jmp    80056c <vprintfmt+0x43>
			for (precision = 0; ; ++fmt) {
  8005b8:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8005bb:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8005be:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8005c2:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8005c5:	8d 72 d0             	lea    -0x30(%edx),%esi
  8005c8:	83 fe 09             	cmp    $0x9,%esi
  8005cb:	76 eb                	jbe    8005b8 <vprintfmt+0x8f>
  8005cd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005d0:	8b 75 08             	mov    0x8(%ebp),%esi
  8005d3:	eb 14                	jmp    8005e9 <vprintfmt+0xc0>
			precision = va_arg(ap, int);
  8005d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d8:	8b 00                	mov    (%eax),%eax
  8005da:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e0:	8d 40 04             	lea    0x4(%eax),%eax
  8005e3:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005e6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8005e9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005ed:	0f 89 79 ff ff ff    	jns    80056c <vprintfmt+0x43>
				width = precision, precision = -1;
  8005f3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005f9:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800600:	e9 67 ff ff ff       	jmp    80056c <vprintfmt+0x43>
  800605:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800608:	85 c0                	test   %eax,%eax
  80060a:	0f 48 c1             	cmovs  %ecx,%eax
  80060d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800610:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800613:	e9 54 ff ff ff       	jmp    80056c <vprintfmt+0x43>
  800618:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80061b:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800622:	e9 45 ff ff ff       	jmp    80056c <vprintfmt+0x43>
			lflag++;
  800627:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80062b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80062e:	e9 39 ff ff ff       	jmp    80056c <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800633:	8b 45 14             	mov    0x14(%ebp),%eax
  800636:	8d 78 04             	lea    0x4(%eax),%edi
  800639:	83 ec 08             	sub    $0x8,%esp
  80063c:	53                   	push   %ebx
  80063d:	ff 30                	pushl  (%eax)
  80063f:	ff d6                	call   *%esi
			break;
  800641:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800644:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800647:	e9 0f 03 00 00       	jmp    80095b <vprintfmt+0x432>
			err = va_arg(ap, int);
  80064c:	8b 45 14             	mov    0x14(%ebp),%eax
  80064f:	8d 78 04             	lea    0x4(%eax),%edi
  800652:	8b 00                	mov    (%eax),%eax
  800654:	99                   	cltd   
  800655:	31 d0                	xor    %edx,%eax
  800657:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800659:	83 f8 0f             	cmp    $0xf,%eax
  80065c:	7f 23                	jg     800681 <vprintfmt+0x158>
  80065e:	8b 14 85 c0 27 80 00 	mov    0x8027c0(,%eax,4),%edx
  800665:	85 d2                	test   %edx,%edx
  800667:	74 18                	je     800681 <vprintfmt+0x158>
				printfmt(putch, putdat, "%s", p);
  800669:	52                   	push   %edx
  80066a:	68 fe 28 80 00       	push   $0x8028fe
  80066f:	53                   	push   %ebx
  800670:	56                   	push   %esi
  800671:	e8 96 fe ff ff       	call   80050c <printfmt>
  800676:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800679:	89 7d 14             	mov    %edi,0x14(%ebp)
  80067c:	e9 da 02 00 00       	jmp    80095b <vprintfmt+0x432>
				printfmt(putch, putdat, "error %d", err);
  800681:	50                   	push   %eax
  800682:	68 93 24 80 00       	push   $0x802493
  800687:	53                   	push   %ebx
  800688:	56                   	push   %esi
  800689:	e8 7e fe ff ff       	call   80050c <printfmt>
  80068e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800691:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800694:	e9 c2 02 00 00       	jmp    80095b <vprintfmt+0x432>
			if ((p = va_arg(ap, char *)) == NULL)
  800699:	8b 45 14             	mov    0x14(%ebp),%eax
  80069c:	83 c0 04             	add    $0x4,%eax
  80069f:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8006a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a5:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8006a7:	85 c9                	test   %ecx,%ecx
  8006a9:	b8 8c 24 80 00       	mov    $0x80248c,%eax
  8006ae:	0f 45 c1             	cmovne %ecx,%eax
  8006b1:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8006b4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006b8:	7e 06                	jle    8006c0 <vprintfmt+0x197>
  8006ba:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8006be:	75 0d                	jne    8006cd <vprintfmt+0x1a4>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006c0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8006c3:	89 c7                	mov    %eax,%edi
  8006c5:	03 45 e0             	add    -0x20(%ebp),%eax
  8006c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006cb:	eb 53                	jmp    800720 <vprintfmt+0x1f7>
  8006cd:	83 ec 08             	sub    $0x8,%esp
  8006d0:	ff 75 d8             	pushl  -0x28(%ebp)
  8006d3:	50                   	push   %eax
  8006d4:	e8 28 04 00 00       	call   800b01 <strnlen>
  8006d9:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8006dc:	29 c1                	sub    %eax,%ecx
  8006de:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  8006e1:	83 c4 10             	add    $0x10,%esp
  8006e4:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8006e6:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8006ea:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8006ed:	eb 0f                	jmp    8006fe <vprintfmt+0x1d5>
					putch(padc, putdat);
  8006ef:	83 ec 08             	sub    $0x8,%esp
  8006f2:	53                   	push   %ebx
  8006f3:	ff 75 e0             	pushl  -0x20(%ebp)
  8006f6:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006f8:	83 ef 01             	sub    $0x1,%edi
  8006fb:	83 c4 10             	add    $0x10,%esp
  8006fe:	85 ff                	test   %edi,%edi
  800700:	7f ed                	jg     8006ef <vprintfmt+0x1c6>
  800702:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  800705:	85 c9                	test   %ecx,%ecx
  800707:	b8 00 00 00 00       	mov    $0x0,%eax
  80070c:	0f 49 c1             	cmovns %ecx,%eax
  80070f:	29 c1                	sub    %eax,%ecx
  800711:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800714:	eb aa                	jmp    8006c0 <vprintfmt+0x197>
					putch(ch, putdat);
  800716:	83 ec 08             	sub    $0x8,%esp
  800719:	53                   	push   %ebx
  80071a:	52                   	push   %edx
  80071b:	ff d6                	call   *%esi
  80071d:	83 c4 10             	add    $0x10,%esp
  800720:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800723:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800725:	83 c7 01             	add    $0x1,%edi
  800728:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80072c:	0f be d0             	movsbl %al,%edx
  80072f:	85 d2                	test   %edx,%edx
  800731:	74 4b                	je     80077e <vprintfmt+0x255>
  800733:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800737:	78 06                	js     80073f <vprintfmt+0x216>
  800739:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80073d:	78 1e                	js     80075d <vprintfmt+0x234>
				if (altflag && (ch < ' ' || ch > '~'))
  80073f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800743:	74 d1                	je     800716 <vprintfmt+0x1ed>
  800745:	0f be c0             	movsbl %al,%eax
  800748:	83 e8 20             	sub    $0x20,%eax
  80074b:	83 f8 5e             	cmp    $0x5e,%eax
  80074e:	76 c6                	jbe    800716 <vprintfmt+0x1ed>
					putch('?', putdat);
  800750:	83 ec 08             	sub    $0x8,%esp
  800753:	53                   	push   %ebx
  800754:	6a 3f                	push   $0x3f
  800756:	ff d6                	call   *%esi
  800758:	83 c4 10             	add    $0x10,%esp
  80075b:	eb c3                	jmp    800720 <vprintfmt+0x1f7>
  80075d:	89 cf                	mov    %ecx,%edi
  80075f:	eb 0e                	jmp    80076f <vprintfmt+0x246>
				putch(' ', putdat);
  800761:	83 ec 08             	sub    $0x8,%esp
  800764:	53                   	push   %ebx
  800765:	6a 20                	push   $0x20
  800767:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800769:	83 ef 01             	sub    $0x1,%edi
  80076c:	83 c4 10             	add    $0x10,%esp
  80076f:	85 ff                	test   %edi,%edi
  800771:	7f ee                	jg     800761 <vprintfmt+0x238>
			if ((p = va_arg(ap, char *)) == NULL)
  800773:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800776:	89 45 14             	mov    %eax,0x14(%ebp)
  800779:	e9 dd 01 00 00       	jmp    80095b <vprintfmt+0x432>
  80077e:	89 cf                	mov    %ecx,%edi
  800780:	eb ed                	jmp    80076f <vprintfmt+0x246>
	if (lflag >= 2)
  800782:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800786:	7f 21                	jg     8007a9 <vprintfmt+0x280>
	else if (lflag)
  800788:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80078c:	74 6a                	je     8007f8 <vprintfmt+0x2cf>
		return va_arg(*ap, long);
  80078e:	8b 45 14             	mov    0x14(%ebp),%eax
  800791:	8b 00                	mov    (%eax),%eax
  800793:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800796:	89 c1                	mov    %eax,%ecx
  800798:	c1 f9 1f             	sar    $0x1f,%ecx
  80079b:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80079e:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a1:	8d 40 04             	lea    0x4(%eax),%eax
  8007a4:	89 45 14             	mov    %eax,0x14(%ebp)
  8007a7:	eb 17                	jmp    8007c0 <vprintfmt+0x297>
		return va_arg(*ap, long long);
  8007a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ac:	8b 50 04             	mov    0x4(%eax),%edx
  8007af:	8b 00                	mov    (%eax),%eax
  8007b1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007b4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ba:	8d 40 08             	lea    0x8(%eax),%eax
  8007bd:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8007c0:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  8007c3:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  8007c8:	85 d2                	test   %edx,%edx
  8007ca:	0f 89 5c 01 00 00    	jns    80092c <vprintfmt+0x403>
				putch('-', putdat);
  8007d0:	83 ec 08             	sub    $0x8,%esp
  8007d3:	53                   	push   %ebx
  8007d4:	6a 2d                	push   $0x2d
  8007d6:	ff d6                	call   *%esi
				num = -(long long) num;
  8007d8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007db:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8007de:	f7 d8                	neg    %eax
  8007e0:	83 d2 00             	adc    $0x0,%edx
  8007e3:	f7 da                	neg    %edx
  8007e5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007e8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007eb:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8007ee:	bf 0a 00 00 00       	mov    $0xa,%edi
  8007f3:	e9 45 01 00 00       	jmp    80093d <vprintfmt+0x414>
		return va_arg(*ap, int);
  8007f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fb:	8b 00                	mov    (%eax),%eax
  8007fd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800800:	89 c1                	mov    %eax,%ecx
  800802:	c1 f9 1f             	sar    $0x1f,%ecx
  800805:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800808:	8b 45 14             	mov    0x14(%ebp),%eax
  80080b:	8d 40 04             	lea    0x4(%eax),%eax
  80080e:	89 45 14             	mov    %eax,0x14(%ebp)
  800811:	eb ad                	jmp    8007c0 <vprintfmt+0x297>
	if (lflag >= 2)
  800813:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800817:	7f 29                	jg     800842 <vprintfmt+0x319>
	else if (lflag)
  800819:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80081d:	74 44                	je     800863 <vprintfmt+0x33a>
		return va_arg(*ap, unsigned long);
  80081f:	8b 45 14             	mov    0x14(%ebp),%eax
  800822:	8b 00                	mov    (%eax),%eax
  800824:	ba 00 00 00 00       	mov    $0x0,%edx
  800829:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80082c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80082f:	8b 45 14             	mov    0x14(%ebp),%eax
  800832:	8d 40 04             	lea    0x4(%eax),%eax
  800835:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800838:	bf 0a 00 00 00       	mov    $0xa,%edi
  80083d:	e9 ea 00 00 00       	jmp    80092c <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  800842:	8b 45 14             	mov    0x14(%ebp),%eax
  800845:	8b 50 04             	mov    0x4(%eax),%edx
  800848:	8b 00                	mov    (%eax),%eax
  80084a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80084d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800850:	8b 45 14             	mov    0x14(%ebp),%eax
  800853:	8d 40 08             	lea    0x8(%eax),%eax
  800856:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800859:	bf 0a 00 00 00       	mov    $0xa,%edi
  80085e:	e9 c9 00 00 00       	jmp    80092c <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  800863:	8b 45 14             	mov    0x14(%ebp),%eax
  800866:	8b 00                	mov    (%eax),%eax
  800868:	ba 00 00 00 00       	mov    $0x0,%edx
  80086d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800870:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800873:	8b 45 14             	mov    0x14(%ebp),%eax
  800876:	8d 40 04             	lea    0x4(%eax),%eax
  800879:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80087c:	bf 0a 00 00 00       	mov    $0xa,%edi
  800881:	e9 a6 00 00 00       	jmp    80092c <vprintfmt+0x403>
			putch('0', putdat);
  800886:	83 ec 08             	sub    $0x8,%esp
  800889:	53                   	push   %ebx
  80088a:	6a 30                	push   $0x30
  80088c:	ff d6                	call   *%esi
	if (lflag >= 2)
  80088e:	83 c4 10             	add    $0x10,%esp
  800891:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800895:	7f 26                	jg     8008bd <vprintfmt+0x394>
	else if (lflag)
  800897:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80089b:	74 3e                	je     8008db <vprintfmt+0x3b2>
		return va_arg(*ap, unsigned long);
  80089d:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a0:	8b 00                	mov    (%eax),%eax
  8008a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8008a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008aa:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b0:	8d 40 04             	lea    0x4(%eax),%eax
  8008b3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8008b6:	bf 08 00 00 00       	mov    $0x8,%edi
  8008bb:	eb 6f                	jmp    80092c <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  8008bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c0:	8b 50 04             	mov    0x4(%eax),%edx
  8008c3:	8b 00                	mov    (%eax),%eax
  8008c5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008c8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ce:	8d 40 08             	lea    0x8(%eax),%eax
  8008d1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8008d4:	bf 08 00 00 00       	mov    $0x8,%edi
  8008d9:	eb 51                	jmp    80092c <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  8008db:	8b 45 14             	mov    0x14(%ebp),%eax
  8008de:	8b 00                	mov    (%eax),%eax
  8008e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8008e5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008e8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ee:	8d 40 04             	lea    0x4(%eax),%eax
  8008f1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8008f4:	bf 08 00 00 00       	mov    $0x8,%edi
  8008f9:	eb 31                	jmp    80092c <vprintfmt+0x403>
			putch('0', putdat);
  8008fb:	83 ec 08             	sub    $0x8,%esp
  8008fe:	53                   	push   %ebx
  8008ff:	6a 30                	push   $0x30
  800901:	ff d6                	call   *%esi
			putch('x', putdat);
  800903:	83 c4 08             	add    $0x8,%esp
  800906:	53                   	push   %ebx
  800907:	6a 78                	push   $0x78
  800909:	ff d6                	call   *%esi
			num = (unsigned long long)
  80090b:	8b 45 14             	mov    0x14(%ebp),%eax
  80090e:	8b 00                	mov    (%eax),%eax
  800910:	ba 00 00 00 00       	mov    $0x0,%edx
  800915:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800918:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80091b:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80091e:	8b 45 14             	mov    0x14(%ebp),%eax
  800921:	8d 40 04             	lea    0x4(%eax),%eax
  800924:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800927:	bf 10 00 00 00       	mov    $0x10,%edi
			if(posflag)
  80092c:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800930:	74 0b                	je     80093d <vprintfmt+0x414>
				putch('+', putdat);
  800932:	83 ec 08             	sub    $0x8,%esp
  800935:	53                   	push   %ebx
  800936:	6a 2b                	push   $0x2b
  800938:	ff d6                	call   *%esi
  80093a:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  80093d:	83 ec 0c             	sub    $0xc,%esp
  800940:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800944:	50                   	push   %eax
  800945:	ff 75 e0             	pushl  -0x20(%ebp)
  800948:	57                   	push   %edi
  800949:	ff 75 dc             	pushl  -0x24(%ebp)
  80094c:	ff 75 d8             	pushl  -0x28(%ebp)
  80094f:	89 da                	mov    %ebx,%edx
  800951:	89 f0                	mov    %esi,%eax
  800953:	e8 b8 fa ff ff       	call   800410 <printnum>
			break;
  800958:	83 c4 20             	add    $0x20,%esp
			char* cp = va_arg(ap, char *);
  80095b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80095e:	83 c7 01             	add    $0x1,%edi
  800961:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800965:	83 f8 25             	cmp    $0x25,%eax
  800968:	0f 84 d2 fb ff ff    	je     800540 <vprintfmt+0x17>
			if (ch == '\0')
  80096e:	85 c0                	test   %eax,%eax
  800970:	0f 84 03 01 00 00    	je     800a79 <vprintfmt+0x550>
			putch(ch, putdat);
  800976:	83 ec 08             	sub    $0x8,%esp
  800979:	53                   	push   %ebx
  80097a:	50                   	push   %eax
  80097b:	ff d6                	call   *%esi
  80097d:	83 c4 10             	add    $0x10,%esp
  800980:	eb dc                	jmp    80095e <vprintfmt+0x435>
	if (lflag >= 2)
  800982:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800986:	7f 29                	jg     8009b1 <vprintfmt+0x488>
	else if (lflag)
  800988:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80098c:	74 44                	je     8009d2 <vprintfmt+0x4a9>
		return va_arg(*ap, unsigned long);
  80098e:	8b 45 14             	mov    0x14(%ebp),%eax
  800991:	8b 00                	mov    (%eax),%eax
  800993:	ba 00 00 00 00       	mov    $0x0,%edx
  800998:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80099b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80099e:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a1:	8d 40 04             	lea    0x4(%eax),%eax
  8009a4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009a7:	bf 10 00 00 00       	mov    $0x10,%edi
  8009ac:	e9 7b ff ff ff       	jmp    80092c <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  8009b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b4:	8b 50 04             	mov    0x4(%eax),%edx
  8009b7:	8b 00                	mov    (%eax),%eax
  8009b9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009bc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c2:	8d 40 08             	lea    0x8(%eax),%eax
  8009c5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009c8:	bf 10 00 00 00       	mov    $0x10,%edi
  8009cd:	e9 5a ff ff ff       	jmp    80092c <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  8009d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d5:	8b 00                	mov    (%eax),%eax
  8009d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8009dc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009df:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e5:	8d 40 04             	lea    0x4(%eax),%eax
  8009e8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009eb:	bf 10 00 00 00       	mov    $0x10,%edi
  8009f0:	e9 37 ff ff ff       	jmp    80092c <vprintfmt+0x403>
			char* cp = va_arg(ap, char *);
  8009f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f8:	8d 78 04             	lea    0x4(%eax),%edi
  8009fb:	8b 00                	mov    (%eax),%eax
    			if (cp == NULL) {
  8009fd:	85 c0                	test   %eax,%eax
  8009ff:	74 2c                	je     800a2d <vprintfmt+0x504>
    			*cp = *(int *)putdat;
  800a01:	8b 13                	mov    (%ebx),%edx
  800a03:	88 10                	mov    %dl,(%eax)
			char* cp = va_arg(ap, char *);
  800a05:	89 7d 14             	mov    %edi,0x14(%ebp)
    			if ((*(int *) putdat) > 127)
  800a08:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  800a0b:	0f 8e 4a ff ff ff    	jle    80095b <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", overflow_error);
  800a11:	68 e8 25 80 00       	push   $0x8025e8
  800a16:	68 fe 28 80 00       	push   $0x8028fe
  800a1b:	53                   	push   %ebx
  800a1c:	56                   	push   %esi
  800a1d:	e8 ea fa ff ff       	call   80050c <printfmt>
  800a22:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  800a25:	89 7d 14             	mov    %edi,0x14(%ebp)
  800a28:	e9 2e ff ff ff       	jmp    80095b <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", null_error);
  800a2d:	68 b0 25 80 00       	push   $0x8025b0
  800a32:	68 fe 28 80 00       	push   $0x8028fe
  800a37:	53                   	push   %ebx
  800a38:	56                   	push   %esi
  800a39:	e8 ce fa ff ff       	call   80050c <printfmt>
        		break;
  800a3e:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  800a41:	89 7d 14             	mov    %edi,0x14(%ebp)
        		break;
  800a44:	e9 12 ff ff ff       	jmp    80095b <vprintfmt+0x432>
			putch(ch, putdat);
  800a49:	83 ec 08             	sub    $0x8,%esp
  800a4c:	53                   	push   %ebx
  800a4d:	6a 25                	push   $0x25
  800a4f:	ff d6                	call   *%esi
			break;
  800a51:	83 c4 10             	add    $0x10,%esp
  800a54:	e9 02 ff ff ff       	jmp    80095b <vprintfmt+0x432>
			putch('%', putdat);
  800a59:	83 ec 08             	sub    $0x8,%esp
  800a5c:	53                   	push   %ebx
  800a5d:	6a 25                	push   $0x25
  800a5f:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a61:	83 c4 10             	add    $0x10,%esp
  800a64:	89 f8                	mov    %edi,%eax
  800a66:	eb 03                	jmp    800a6b <vprintfmt+0x542>
  800a68:	83 e8 01             	sub    $0x1,%eax
  800a6b:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800a6f:	75 f7                	jne    800a68 <vprintfmt+0x53f>
  800a71:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a74:	e9 e2 fe ff ff       	jmp    80095b <vprintfmt+0x432>
}
  800a79:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a7c:	5b                   	pop    %ebx
  800a7d:	5e                   	pop    %esi
  800a7e:	5f                   	pop    %edi
  800a7f:	5d                   	pop    %ebp
  800a80:	c3                   	ret    

00800a81 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a81:	55                   	push   %ebp
  800a82:	89 e5                	mov    %esp,%ebp
  800a84:	83 ec 18             	sub    $0x18,%esp
  800a87:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8a:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a8d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a90:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800a94:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800a97:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a9e:	85 c0                	test   %eax,%eax
  800aa0:	74 26                	je     800ac8 <vsnprintf+0x47>
  800aa2:	85 d2                	test   %edx,%edx
  800aa4:	7e 22                	jle    800ac8 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800aa6:	ff 75 14             	pushl  0x14(%ebp)
  800aa9:	ff 75 10             	pushl  0x10(%ebp)
  800aac:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800aaf:	50                   	push   %eax
  800ab0:	68 ef 04 80 00       	push   $0x8004ef
  800ab5:	e8 6f fa ff ff       	call   800529 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800aba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800abd:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ac0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ac3:	83 c4 10             	add    $0x10,%esp
}
  800ac6:	c9                   	leave  
  800ac7:	c3                   	ret    
		return -E_INVAL;
  800ac8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800acd:	eb f7                	jmp    800ac6 <vsnprintf+0x45>

00800acf <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800acf:	55                   	push   %ebp
  800ad0:	89 e5                	mov    %esp,%ebp
  800ad2:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ad5:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800ad8:	50                   	push   %eax
  800ad9:	ff 75 10             	pushl  0x10(%ebp)
  800adc:	ff 75 0c             	pushl  0xc(%ebp)
  800adf:	ff 75 08             	pushl  0x8(%ebp)
  800ae2:	e8 9a ff ff ff       	call   800a81 <vsnprintf>
	va_end(ap);

	return rc;
}
  800ae7:	c9                   	leave  
  800ae8:	c3                   	ret    

00800ae9 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800ae9:	55                   	push   %ebp
  800aea:	89 e5                	mov    %esp,%ebp
  800aec:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800aef:	b8 00 00 00 00       	mov    $0x0,%eax
  800af4:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800af8:	74 05                	je     800aff <strlen+0x16>
		n++;
  800afa:	83 c0 01             	add    $0x1,%eax
  800afd:	eb f5                	jmp    800af4 <strlen+0xb>
	return n;
}
  800aff:	5d                   	pop    %ebp
  800b00:	c3                   	ret    

00800b01 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800b01:	55                   	push   %ebp
  800b02:	89 e5                	mov    %esp,%ebp
  800b04:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b07:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b0a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b0f:	39 c2                	cmp    %eax,%edx
  800b11:	74 0d                	je     800b20 <strnlen+0x1f>
  800b13:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800b17:	74 05                	je     800b1e <strnlen+0x1d>
		n++;
  800b19:	83 c2 01             	add    $0x1,%edx
  800b1c:	eb f1                	jmp    800b0f <strnlen+0xe>
  800b1e:	89 d0                	mov    %edx,%eax
	return n;
}
  800b20:	5d                   	pop    %ebp
  800b21:	c3                   	ret    

00800b22 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b22:	55                   	push   %ebp
  800b23:	89 e5                	mov    %esp,%ebp
  800b25:	53                   	push   %ebx
  800b26:	8b 45 08             	mov    0x8(%ebp),%eax
  800b29:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800b2c:	ba 00 00 00 00       	mov    $0x0,%edx
  800b31:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800b35:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800b38:	83 c2 01             	add    $0x1,%edx
  800b3b:	84 c9                	test   %cl,%cl
  800b3d:	75 f2                	jne    800b31 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800b3f:	5b                   	pop    %ebx
  800b40:	5d                   	pop    %ebp
  800b41:	c3                   	ret    

00800b42 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800b42:	55                   	push   %ebp
  800b43:	89 e5                	mov    %esp,%ebp
  800b45:	53                   	push   %ebx
  800b46:	83 ec 10             	sub    $0x10,%esp
  800b49:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800b4c:	53                   	push   %ebx
  800b4d:	e8 97 ff ff ff       	call   800ae9 <strlen>
  800b52:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800b55:	ff 75 0c             	pushl  0xc(%ebp)
  800b58:	01 d8                	add    %ebx,%eax
  800b5a:	50                   	push   %eax
  800b5b:	e8 c2 ff ff ff       	call   800b22 <strcpy>
	return dst;
}
  800b60:	89 d8                	mov    %ebx,%eax
  800b62:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b65:	c9                   	leave  
  800b66:	c3                   	ret    

00800b67 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b67:	55                   	push   %ebp
  800b68:	89 e5                	mov    %esp,%ebp
  800b6a:	56                   	push   %esi
  800b6b:	53                   	push   %ebx
  800b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b72:	89 c6                	mov    %eax,%esi
  800b74:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b77:	89 c2                	mov    %eax,%edx
  800b79:	39 f2                	cmp    %esi,%edx
  800b7b:	74 11                	je     800b8e <strncpy+0x27>
		*dst++ = *src;
  800b7d:	83 c2 01             	add    $0x1,%edx
  800b80:	0f b6 19             	movzbl (%ecx),%ebx
  800b83:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b86:	80 fb 01             	cmp    $0x1,%bl
  800b89:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800b8c:	eb eb                	jmp    800b79 <strncpy+0x12>
	}
	return ret;
}
  800b8e:	5b                   	pop    %ebx
  800b8f:	5e                   	pop    %esi
  800b90:	5d                   	pop    %ebp
  800b91:	c3                   	ret    

00800b92 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b92:	55                   	push   %ebp
  800b93:	89 e5                	mov    %esp,%ebp
  800b95:	56                   	push   %esi
  800b96:	53                   	push   %ebx
  800b97:	8b 75 08             	mov    0x8(%ebp),%esi
  800b9a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b9d:	8b 55 10             	mov    0x10(%ebp),%edx
  800ba0:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ba2:	85 d2                	test   %edx,%edx
  800ba4:	74 21                	je     800bc7 <strlcpy+0x35>
  800ba6:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800baa:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800bac:	39 c2                	cmp    %eax,%edx
  800bae:	74 14                	je     800bc4 <strlcpy+0x32>
  800bb0:	0f b6 19             	movzbl (%ecx),%ebx
  800bb3:	84 db                	test   %bl,%bl
  800bb5:	74 0b                	je     800bc2 <strlcpy+0x30>
			*dst++ = *src++;
  800bb7:	83 c1 01             	add    $0x1,%ecx
  800bba:	83 c2 01             	add    $0x1,%edx
  800bbd:	88 5a ff             	mov    %bl,-0x1(%edx)
  800bc0:	eb ea                	jmp    800bac <strlcpy+0x1a>
  800bc2:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800bc4:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800bc7:	29 f0                	sub    %esi,%eax
}
  800bc9:	5b                   	pop    %ebx
  800bca:	5e                   	pop    %esi
  800bcb:	5d                   	pop    %ebp
  800bcc:	c3                   	ret    

00800bcd <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800bcd:	55                   	push   %ebp
  800bce:	89 e5                	mov    %esp,%ebp
  800bd0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bd3:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800bd6:	0f b6 01             	movzbl (%ecx),%eax
  800bd9:	84 c0                	test   %al,%al
  800bdb:	74 0c                	je     800be9 <strcmp+0x1c>
  800bdd:	3a 02                	cmp    (%edx),%al
  800bdf:	75 08                	jne    800be9 <strcmp+0x1c>
		p++, q++;
  800be1:	83 c1 01             	add    $0x1,%ecx
  800be4:	83 c2 01             	add    $0x1,%edx
  800be7:	eb ed                	jmp    800bd6 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800be9:	0f b6 c0             	movzbl %al,%eax
  800bec:	0f b6 12             	movzbl (%edx),%edx
  800bef:	29 d0                	sub    %edx,%eax
}
  800bf1:	5d                   	pop    %ebp
  800bf2:	c3                   	ret    

00800bf3 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800bf3:	55                   	push   %ebp
  800bf4:	89 e5                	mov    %esp,%ebp
  800bf6:	53                   	push   %ebx
  800bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfa:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bfd:	89 c3                	mov    %eax,%ebx
  800bff:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800c02:	eb 06                	jmp    800c0a <strncmp+0x17>
		n--, p++, q++;
  800c04:	83 c0 01             	add    $0x1,%eax
  800c07:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800c0a:	39 d8                	cmp    %ebx,%eax
  800c0c:	74 16                	je     800c24 <strncmp+0x31>
  800c0e:	0f b6 08             	movzbl (%eax),%ecx
  800c11:	84 c9                	test   %cl,%cl
  800c13:	74 04                	je     800c19 <strncmp+0x26>
  800c15:	3a 0a                	cmp    (%edx),%cl
  800c17:	74 eb                	je     800c04 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c19:	0f b6 00             	movzbl (%eax),%eax
  800c1c:	0f b6 12             	movzbl (%edx),%edx
  800c1f:	29 d0                	sub    %edx,%eax
}
  800c21:	5b                   	pop    %ebx
  800c22:	5d                   	pop    %ebp
  800c23:	c3                   	ret    
		return 0;
  800c24:	b8 00 00 00 00       	mov    $0x0,%eax
  800c29:	eb f6                	jmp    800c21 <strncmp+0x2e>

00800c2b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c2b:	55                   	push   %ebp
  800c2c:	89 e5                	mov    %esp,%ebp
  800c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c31:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c35:	0f b6 10             	movzbl (%eax),%edx
  800c38:	84 d2                	test   %dl,%dl
  800c3a:	74 09                	je     800c45 <strchr+0x1a>
		if (*s == c)
  800c3c:	38 ca                	cmp    %cl,%dl
  800c3e:	74 0a                	je     800c4a <strchr+0x1f>
	for (; *s; s++)
  800c40:	83 c0 01             	add    $0x1,%eax
  800c43:	eb f0                	jmp    800c35 <strchr+0xa>
			return (char *) s;
	return 0;
  800c45:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c4a:	5d                   	pop    %ebp
  800c4b:	c3                   	ret    

00800c4c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c4c:	55                   	push   %ebp
  800c4d:	89 e5                	mov    %esp,%ebp
  800c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c52:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c56:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800c59:	38 ca                	cmp    %cl,%dl
  800c5b:	74 09                	je     800c66 <strfind+0x1a>
  800c5d:	84 d2                	test   %dl,%dl
  800c5f:	74 05                	je     800c66 <strfind+0x1a>
	for (; *s; s++)
  800c61:	83 c0 01             	add    $0x1,%eax
  800c64:	eb f0                	jmp    800c56 <strfind+0xa>
			break;
	return (char *) s;
}
  800c66:	5d                   	pop    %ebp
  800c67:	c3                   	ret    

00800c68 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c68:	55                   	push   %ebp
  800c69:	89 e5                	mov    %esp,%ebp
  800c6b:	57                   	push   %edi
  800c6c:	56                   	push   %esi
  800c6d:	53                   	push   %ebx
  800c6e:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c71:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c74:	85 c9                	test   %ecx,%ecx
  800c76:	74 31                	je     800ca9 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c78:	89 f8                	mov    %edi,%eax
  800c7a:	09 c8                	or     %ecx,%eax
  800c7c:	a8 03                	test   $0x3,%al
  800c7e:	75 23                	jne    800ca3 <memset+0x3b>
		c &= 0xFF;
  800c80:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c84:	89 d3                	mov    %edx,%ebx
  800c86:	c1 e3 08             	shl    $0x8,%ebx
  800c89:	89 d0                	mov    %edx,%eax
  800c8b:	c1 e0 18             	shl    $0x18,%eax
  800c8e:	89 d6                	mov    %edx,%esi
  800c90:	c1 e6 10             	shl    $0x10,%esi
  800c93:	09 f0                	or     %esi,%eax
  800c95:	09 c2                	or     %eax,%edx
  800c97:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800c99:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800c9c:	89 d0                	mov    %edx,%eax
  800c9e:	fc                   	cld    
  800c9f:	f3 ab                	rep stos %eax,%es:(%edi)
  800ca1:	eb 06                	jmp    800ca9 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ca3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca6:	fc                   	cld    
  800ca7:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800ca9:	89 f8                	mov    %edi,%eax
  800cab:	5b                   	pop    %ebx
  800cac:	5e                   	pop    %esi
  800cad:	5f                   	pop    %edi
  800cae:	5d                   	pop    %ebp
  800caf:	c3                   	ret    

00800cb0 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800cb0:	55                   	push   %ebp
  800cb1:	89 e5                	mov    %esp,%ebp
  800cb3:	57                   	push   %edi
  800cb4:	56                   	push   %esi
  800cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb8:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cbb:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800cbe:	39 c6                	cmp    %eax,%esi
  800cc0:	73 32                	jae    800cf4 <memmove+0x44>
  800cc2:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800cc5:	39 c2                	cmp    %eax,%edx
  800cc7:	76 2b                	jbe    800cf4 <memmove+0x44>
		s += n;
		d += n;
  800cc9:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ccc:	89 fe                	mov    %edi,%esi
  800cce:	09 ce                	or     %ecx,%esi
  800cd0:	09 d6                	or     %edx,%esi
  800cd2:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800cd8:	75 0e                	jne    800ce8 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800cda:	83 ef 04             	sub    $0x4,%edi
  800cdd:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ce0:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800ce3:	fd                   	std    
  800ce4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ce6:	eb 09                	jmp    800cf1 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ce8:	83 ef 01             	sub    $0x1,%edi
  800ceb:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800cee:	fd                   	std    
  800cef:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800cf1:	fc                   	cld    
  800cf2:	eb 1a                	jmp    800d0e <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800cf4:	89 c2                	mov    %eax,%edx
  800cf6:	09 ca                	or     %ecx,%edx
  800cf8:	09 f2                	or     %esi,%edx
  800cfa:	f6 c2 03             	test   $0x3,%dl
  800cfd:	75 0a                	jne    800d09 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800cff:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800d02:	89 c7                	mov    %eax,%edi
  800d04:	fc                   	cld    
  800d05:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d07:	eb 05                	jmp    800d0e <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800d09:	89 c7                	mov    %eax,%edi
  800d0b:	fc                   	cld    
  800d0c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800d0e:	5e                   	pop    %esi
  800d0f:	5f                   	pop    %edi
  800d10:	5d                   	pop    %ebp
  800d11:	c3                   	ret    

00800d12 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800d12:	55                   	push   %ebp
  800d13:	89 e5                	mov    %esp,%ebp
  800d15:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800d18:	ff 75 10             	pushl  0x10(%ebp)
  800d1b:	ff 75 0c             	pushl  0xc(%ebp)
  800d1e:	ff 75 08             	pushl  0x8(%ebp)
  800d21:	e8 8a ff ff ff       	call   800cb0 <memmove>
}
  800d26:	c9                   	leave  
  800d27:	c3                   	ret    

00800d28 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800d28:	55                   	push   %ebp
  800d29:	89 e5                	mov    %esp,%ebp
  800d2b:	56                   	push   %esi
  800d2c:	53                   	push   %ebx
  800d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d30:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d33:	89 c6                	mov    %eax,%esi
  800d35:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d38:	39 f0                	cmp    %esi,%eax
  800d3a:	74 1c                	je     800d58 <memcmp+0x30>
		if (*s1 != *s2)
  800d3c:	0f b6 08             	movzbl (%eax),%ecx
  800d3f:	0f b6 1a             	movzbl (%edx),%ebx
  800d42:	38 d9                	cmp    %bl,%cl
  800d44:	75 08                	jne    800d4e <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800d46:	83 c0 01             	add    $0x1,%eax
  800d49:	83 c2 01             	add    $0x1,%edx
  800d4c:	eb ea                	jmp    800d38 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800d4e:	0f b6 c1             	movzbl %cl,%eax
  800d51:	0f b6 db             	movzbl %bl,%ebx
  800d54:	29 d8                	sub    %ebx,%eax
  800d56:	eb 05                	jmp    800d5d <memcmp+0x35>
	}

	return 0;
  800d58:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d5d:	5b                   	pop    %ebx
  800d5e:	5e                   	pop    %esi
  800d5f:	5d                   	pop    %ebp
  800d60:	c3                   	ret    

00800d61 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d61:	55                   	push   %ebp
  800d62:	89 e5                	mov    %esp,%ebp
  800d64:	8b 45 08             	mov    0x8(%ebp),%eax
  800d67:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800d6a:	89 c2                	mov    %eax,%edx
  800d6c:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d6f:	39 d0                	cmp    %edx,%eax
  800d71:	73 09                	jae    800d7c <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d73:	38 08                	cmp    %cl,(%eax)
  800d75:	74 05                	je     800d7c <memfind+0x1b>
	for (; s < ends; s++)
  800d77:	83 c0 01             	add    $0x1,%eax
  800d7a:	eb f3                	jmp    800d6f <memfind+0xe>
			break;
	return (void *) s;
}
  800d7c:	5d                   	pop    %ebp
  800d7d:	c3                   	ret    

00800d7e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d7e:	55                   	push   %ebp
  800d7f:	89 e5                	mov    %esp,%ebp
  800d81:	57                   	push   %edi
  800d82:	56                   	push   %esi
  800d83:	53                   	push   %ebx
  800d84:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d87:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d8a:	eb 03                	jmp    800d8f <strtol+0x11>
		s++;
  800d8c:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800d8f:	0f b6 01             	movzbl (%ecx),%eax
  800d92:	3c 20                	cmp    $0x20,%al
  800d94:	74 f6                	je     800d8c <strtol+0xe>
  800d96:	3c 09                	cmp    $0x9,%al
  800d98:	74 f2                	je     800d8c <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800d9a:	3c 2b                	cmp    $0x2b,%al
  800d9c:	74 2a                	je     800dc8 <strtol+0x4a>
	int neg = 0;
  800d9e:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800da3:	3c 2d                	cmp    $0x2d,%al
  800da5:	74 2b                	je     800dd2 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800da7:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800dad:	75 0f                	jne    800dbe <strtol+0x40>
  800daf:	80 39 30             	cmpb   $0x30,(%ecx)
  800db2:	74 28                	je     800ddc <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800db4:	85 db                	test   %ebx,%ebx
  800db6:	b8 0a 00 00 00       	mov    $0xa,%eax
  800dbb:	0f 44 d8             	cmove  %eax,%ebx
  800dbe:	b8 00 00 00 00       	mov    $0x0,%eax
  800dc3:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800dc6:	eb 50                	jmp    800e18 <strtol+0x9a>
		s++;
  800dc8:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800dcb:	bf 00 00 00 00       	mov    $0x0,%edi
  800dd0:	eb d5                	jmp    800da7 <strtol+0x29>
		s++, neg = 1;
  800dd2:	83 c1 01             	add    $0x1,%ecx
  800dd5:	bf 01 00 00 00       	mov    $0x1,%edi
  800dda:	eb cb                	jmp    800da7 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ddc:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800de0:	74 0e                	je     800df0 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800de2:	85 db                	test   %ebx,%ebx
  800de4:	75 d8                	jne    800dbe <strtol+0x40>
		s++, base = 8;
  800de6:	83 c1 01             	add    $0x1,%ecx
  800de9:	bb 08 00 00 00       	mov    $0x8,%ebx
  800dee:	eb ce                	jmp    800dbe <strtol+0x40>
		s += 2, base = 16;
  800df0:	83 c1 02             	add    $0x2,%ecx
  800df3:	bb 10 00 00 00       	mov    $0x10,%ebx
  800df8:	eb c4                	jmp    800dbe <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800dfa:	8d 72 9f             	lea    -0x61(%edx),%esi
  800dfd:	89 f3                	mov    %esi,%ebx
  800dff:	80 fb 19             	cmp    $0x19,%bl
  800e02:	77 29                	ja     800e2d <strtol+0xaf>
			dig = *s - 'a' + 10;
  800e04:	0f be d2             	movsbl %dl,%edx
  800e07:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800e0a:	3b 55 10             	cmp    0x10(%ebp),%edx
  800e0d:	7d 30                	jge    800e3f <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800e0f:	83 c1 01             	add    $0x1,%ecx
  800e12:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e16:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800e18:	0f b6 11             	movzbl (%ecx),%edx
  800e1b:	8d 72 d0             	lea    -0x30(%edx),%esi
  800e1e:	89 f3                	mov    %esi,%ebx
  800e20:	80 fb 09             	cmp    $0x9,%bl
  800e23:	77 d5                	ja     800dfa <strtol+0x7c>
			dig = *s - '0';
  800e25:	0f be d2             	movsbl %dl,%edx
  800e28:	83 ea 30             	sub    $0x30,%edx
  800e2b:	eb dd                	jmp    800e0a <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800e2d:	8d 72 bf             	lea    -0x41(%edx),%esi
  800e30:	89 f3                	mov    %esi,%ebx
  800e32:	80 fb 19             	cmp    $0x19,%bl
  800e35:	77 08                	ja     800e3f <strtol+0xc1>
			dig = *s - 'A' + 10;
  800e37:	0f be d2             	movsbl %dl,%edx
  800e3a:	83 ea 37             	sub    $0x37,%edx
  800e3d:	eb cb                	jmp    800e0a <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800e3f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e43:	74 05                	je     800e4a <strtol+0xcc>
		*endptr = (char *) s;
  800e45:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e48:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800e4a:	89 c2                	mov    %eax,%edx
  800e4c:	f7 da                	neg    %edx
  800e4e:	85 ff                	test   %edi,%edi
  800e50:	0f 45 c2             	cmovne %edx,%eax
}
  800e53:	5b                   	pop    %ebx
  800e54:	5e                   	pop    %esi
  800e55:	5f                   	pop    %edi
  800e56:	5d                   	pop    %ebp
  800e57:	c3                   	ret    

00800e58 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800e58:	55                   	push   %ebp
  800e59:	89 e5                	mov    %esp,%ebp
  800e5b:	57                   	push   %edi
  800e5c:	56                   	push   %esi
  800e5d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e5e:	b8 00 00 00 00       	mov    $0x0,%eax
  800e63:	8b 55 08             	mov    0x8(%ebp),%edx
  800e66:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e69:	89 c3                	mov    %eax,%ebx
  800e6b:	89 c7                	mov    %eax,%edi
  800e6d:	89 c6                	mov    %eax,%esi
  800e6f:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800e71:	5b                   	pop    %ebx
  800e72:	5e                   	pop    %esi
  800e73:	5f                   	pop    %edi
  800e74:	5d                   	pop    %ebp
  800e75:	c3                   	ret    

00800e76 <sys_cgetc>:

int
sys_cgetc(void)
{
  800e76:	55                   	push   %ebp
  800e77:	89 e5                	mov    %esp,%ebp
  800e79:	57                   	push   %edi
  800e7a:	56                   	push   %esi
  800e7b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e7c:	ba 00 00 00 00       	mov    $0x0,%edx
  800e81:	b8 01 00 00 00       	mov    $0x1,%eax
  800e86:	89 d1                	mov    %edx,%ecx
  800e88:	89 d3                	mov    %edx,%ebx
  800e8a:	89 d7                	mov    %edx,%edi
  800e8c:	89 d6                	mov    %edx,%esi
  800e8e:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800e90:	5b                   	pop    %ebx
  800e91:	5e                   	pop    %esi
  800e92:	5f                   	pop    %edi
  800e93:	5d                   	pop    %ebp
  800e94:	c3                   	ret    

00800e95 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800e95:	55                   	push   %ebp
  800e96:	89 e5                	mov    %esp,%ebp
  800e98:	57                   	push   %edi
  800e99:	56                   	push   %esi
  800e9a:	53                   	push   %ebx
  800e9b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e9e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ea3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea6:	b8 03 00 00 00       	mov    $0x3,%eax
  800eab:	89 cb                	mov    %ecx,%ebx
  800ead:	89 cf                	mov    %ecx,%edi
  800eaf:	89 ce                	mov    %ecx,%esi
  800eb1:	cd 30                	int    $0x30
	if (check && ret > 0)
  800eb3:	85 c0                	test   %eax,%eax
  800eb5:	7f 08                	jg     800ebf <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800eb7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eba:	5b                   	pop    %ebx
  800ebb:	5e                   	pop    %esi
  800ebc:	5f                   	pop    %edi
  800ebd:	5d                   	pop    %ebp
  800ebe:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ebf:	83 ec 0c             	sub    $0xc,%esp
  800ec2:	50                   	push   %eax
  800ec3:	6a 03                	push   $0x3
  800ec5:	68 00 28 80 00       	push   $0x802800
  800eca:	6a 4c                	push   $0x4c
  800ecc:	68 1d 28 80 00       	push   $0x80281d
  800ed1:	e8 4b f4 ff ff       	call   800321 <_panic>

00800ed6 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800ed6:	55                   	push   %ebp
  800ed7:	89 e5                	mov    %esp,%ebp
  800ed9:	57                   	push   %edi
  800eda:	56                   	push   %esi
  800edb:	53                   	push   %ebx
	asm volatile("int %1\n"
  800edc:	ba 00 00 00 00       	mov    $0x0,%edx
  800ee1:	b8 02 00 00 00       	mov    $0x2,%eax
  800ee6:	89 d1                	mov    %edx,%ecx
  800ee8:	89 d3                	mov    %edx,%ebx
  800eea:	89 d7                	mov    %edx,%edi
  800eec:	89 d6                	mov    %edx,%esi
  800eee:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800ef0:	5b                   	pop    %ebx
  800ef1:	5e                   	pop    %esi
  800ef2:	5f                   	pop    %edi
  800ef3:	5d                   	pop    %ebp
  800ef4:	c3                   	ret    

00800ef5 <sys_yield>:

void
sys_yield(void)
{
  800ef5:	55                   	push   %ebp
  800ef6:	89 e5                	mov    %esp,%ebp
  800ef8:	57                   	push   %edi
  800ef9:	56                   	push   %esi
  800efa:	53                   	push   %ebx
	asm volatile("int %1\n"
  800efb:	ba 00 00 00 00       	mov    $0x0,%edx
  800f00:	b8 0b 00 00 00       	mov    $0xb,%eax
  800f05:	89 d1                	mov    %edx,%ecx
  800f07:	89 d3                	mov    %edx,%ebx
  800f09:	89 d7                	mov    %edx,%edi
  800f0b:	89 d6                	mov    %edx,%esi
  800f0d:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800f0f:	5b                   	pop    %ebx
  800f10:	5e                   	pop    %esi
  800f11:	5f                   	pop    %edi
  800f12:	5d                   	pop    %ebp
  800f13:	c3                   	ret    

00800f14 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800f14:	55                   	push   %ebp
  800f15:	89 e5                	mov    %esp,%ebp
  800f17:	57                   	push   %edi
  800f18:	56                   	push   %esi
  800f19:	53                   	push   %ebx
  800f1a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f1d:	be 00 00 00 00       	mov    $0x0,%esi
  800f22:	8b 55 08             	mov    0x8(%ebp),%edx
  800f25:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f28:	b8 04 00 00 00       	mov    $0x4,%eax
  800f2d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f30:	89 f7                	mov    %esi,%edi
  800f32:	cd 30                	int    $0x30
	if (check && ret > 0)
  800f34:	85 c0                	test   %eax,%eax
  800f36:	7f 08                	jg     800f40 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800f38:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f3b:	5b                   	pop    %ebx
  800f3c:	5e                   	pop    %esi
  800f3d:	5f                   	pop    %edi
  800f3e:	5d                   	pop    %ebp
  800f3f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f40:	83 ec 0c             	sub    $0xc,%esp
  800f43:	50                   	push   %eax
  800f44:	6a 04                	push   $0x4
  800f46:	68 00 28 80 00       	push   $0x802800
  800f4b:	6a 4c                	push   $0x4c
  800f4d:	68 1d 28 80 00       	push   $0x80281d
  800f52:	e8 ca f3 ff ff       	call   800321 <_panic>

00800f57 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800f57:	55                   	push   %ebp
  800f58:	89 e5                	mov    %esp,%ebp
  800f5a:	57                   	push   %edi
  800f5b:	56                   	push   %esi
  800f5c:	53                   	push   %ebx
  800f5d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f60:	8b 55 08             	mov    0x8(%ebp),%edx
  800f63:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f66:	b8 05 00 00 00       	mov    $0x5,%eax
  800f6b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f6e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f71:	8b 75 18             	mov    0x18(%ebp),%esi
  800f74:	cd 30                	int    $0x30
	if (check && ret > 0)
  800f76:	85 c0                	test   %eax,%eax
  800f78:	7f 08                	jg     800f82 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800f7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f7d:	5b                   	pop    %ebx
  800f7e:	5e                   	pop    %esi
  800f7f:	5f                   	pop    %edi
  800f80:	5d                   	pop    %ebp
  800f81:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f82:	83 ec 0c             	sub    $0xc,%esp
  800f85:	50                   	push   %eax
  800f86:	6a 05                	push   $0x5
  800f88:	68 00 28 80 00       	push   $0x802800
  800f8d:	6a 4c                	push   $0x4c
  800f8f:	68 1d 28 80 00       	push   $0x80281d
  800f94:	e8 88 f3 ff ff       	call   800321 <_panic>

00800f99 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800f99:	55                   	push   %ebp
  800f9a:	89 e5                	mov    %esp,%ebp
  800f9c:	57                   	push   %edi
  800f9d:	56                   	push   %esi
  800f9e:	53                   	push   %ebx
  800f9f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fa2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fa7:	8b 55 08             	mov    0x8(%ebp),%edx
  800faa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fad:	b8 06 00 00 00       	mov    $0x6,%eax
  800fb2:	89 df                	mov    %ebx,%edi
  800fb4:	89 de                	mov    %ebx,%esi
  800fb6:	cd 30                	int    $0x30
	if (check && ret > 0)
  800fb8:	85 c0                	test   %eax,%eax
  800fba:	7f 08                	jg     800fc4 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
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
  800fc8:	6a 06                	push   $0x6
  800fca:	68 00 28 80 00       	push   $0x802800
  800fcf:	6a 4c                	push   $0x4c
  800fd1:	68 1d 28 80 00       	push   $0x80281d
  800fd6:	e8 46 f3 ff ff       	call   800321 <_panic>

00800fdb <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800fdb:	55                   	push   %ebp
  800fdc:	89 e5                	mov    %esp,%ebp
  800fde:	57                   	push   %edi
  800fdf:	56                   	push   %esi
  800fe0:	53                   	push   %ebx
  800fe1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fe4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fe9:	8b 55 08             	mov    0x8(%ebp),%edx
  800fec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fef:	b8 08 00 00 00       	mov    $0x8,%eax
  800ff4:	89 df                	mov    %ebx,%edi
  800ff6:	89 de                	mov    %ebx,%esi
  800ff8:	cd 30                	int    $0x30
	if (check && ret > 0)
  800ffa:	85 c0                	test   %eax,%eax
  800ffc:	7f 08                	jg     801006 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
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
  80100a:	6a 08                	push   $0x8
  80100c:	68 00 28 80 00       	push   $0x802800
  801011:	6a 4c                	push   $0x4c
  801013:	68 1d 28 80 00       	push   $0x80281d
  801018:	e8 04 f3 ff ff       	call   800321 <_panic>

0080101d <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
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
  801031:	b8 09 00 00 00       	mov    $0x9,%eax
  801036:	89 df                	mov    %ebx,%edi
  801038:	89 de                	mov    %ebx,%esi
  80103a:	cd 30                	int    $0x30
	if (check && ret > 0)
  80103c:	85 c0                	test   %eax,%eax
  80103e:	7f 08                	jg     801048 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
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
  80104c:	6a 09                	push   $0x9
  80104e:	68 00 28 80 00       	push   $0x802800
  801053:	6a 4c                	push   $0x4c
  801055:	68 1d 28 80 00       	push   $0x80281d
  80105a:	e8 c2 f2 ff ff       	call   800321 <_panic>

0080105f <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
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
  801073:	b8 0a 00 00 00       	mov    $0xa,%eax
  801078:	89 df                	mov    %ebx,%edi
  80107a:	89 de                	mov    %ebx,%esi
  80107c:	cd 30                	int    $0x30
	if (check && ret > 0)
  80107e:	85 c0                	test   %eax,%eax
  801080:	7f 08                	jg     80108a <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
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
  80108e:	6a 0a                	push   $0xa
  801090:	68 00 28 80 00       	push   $0x802800
  801095:	6a 4c                	push   $0x4c
  801097:	68 1d 28 80 00       	push   $0x80281d
  80109c:	e8 80 f2 ff ff       	call   800321 <_panic>

008010a1 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8010a1:	55                   	push   %ebp
  8010a2:	89 e5                	mov    %esp,%ebp
  8010a4:	57                   	push   %edi
  8010a5:	56                   	push   %esi
  8010a6:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8010aa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010ad:	b8 0c 00 00 00       	mov    $0xc,%eax
  8010b2:	be 00 00 00 00       	mov    $0x0,%esi
  8010b7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010ba:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010bd:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8010bf:	5b                   	pop    %ebx
  8010c0:	5e                   	pop    %esi
  8010c1:	5f                   	pop    %edi
  8010c2:	5d                   	pop    %ebp
  8010c3:	c3                   	ret    

008010c4 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8010c4:	55                   	push   %ebp
  8010c5:	89 e5                	mov    %esp,%ebp
  8010c7:	57                   	push   %edi
  8010c8:	56                   	push   %esi
  8010c9:	53                   	push   %ebx
  8010ca:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010cd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8010d5:	b8 0d 00 00 00       	mov    $0xd,%eax
  8010da:	89 cb                	mov    %ecx,%ebx
  8010dc:	89 cf                	mov    %ecx,%edi
  8010de:	89 ce                	mov    %ecx,%esi
  8010e0:	cd 30                	int    $0x30
	if (check && ret > 0)
  8010e2:	85 c0                	test   %eax,%eax
  8010e4:	7f 08                	jg     8010ee <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8010e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010e9:	5b                   	pop    %ebx
  8010ea:	5e                   	pop    %esi
  8010eb:	5f                   	pop    %edi
  8010ec:	5d                   	pop    %ebp
  8010ed:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010ee:	83 ec 0c             	sub    $0xc,%esp
  8010f1:	50                   	push   %eax
  8010f2:	6a 0d                	push   $0xd
  8010f4:	68 00 28 80 00       	push   $0x802800
  8010f9:	6a 4c                	push   $0x4c
  8010fb:	68 1d 28 80 00       	push   $0x80281d
  801100:	e8 1c f2 ff ff       	call   800321 <_panic>

00801105 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  801105:	55                   	push   %ebp
  801106:	89 e5                	mov    %esp,%ebp
  801108:	57                   	push   %edi
  801109:	56                   	push   %esi
  80110a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80110b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801110:	8b 55 08             	mov    0x8(%ebp),%edx
  801113:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801116:	b8 0e 00 00 00       	mov    $0xe,%eax
  80111b:	89 df                	mov    %ebx,%edi
  80111d:	89 de                	mov    %ebx,%esi
  80111f:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801121:	5b                   	pop    %ebx
  801122:	5e                   	pop    %esi
  801123:	5f                   	pop    %edi
  801124:	5d                   	pop    %ebp
  801125:	c3                   	ret    

00801126 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  801126:	55                   	push   %ebp
  801127:	89 e5                	mov    %esp,%ebp
  801129:	57                   	push   %edi
  80112a:	56                   	push   %esi
  80112b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80112c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801131:	8b 55 08             	mov    0x8(%ebp),%edx
  801134:	b8 0f 00 00 00       	mov    $0xf,%eax
  801139:	89 cb                	mov    %ecx,%ebx
  80113b:	89 cf                	mov    %ecx,%edi
  80113d:	89 ce                	mov    %ecx,%esi
  80113f:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801141:	5b                   	pop    %ebx
  801142:	5e                   	pop    %esi
  801143:	5f                   	pop    %edi
  801144:	5d                   	pop    %ebp
  801145:	c3                   	ret    

00801146 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  801146:	55                   	push   %ebp
  801147:	89 e5                	mov    %esp,%ebp
  801149:	8b 55 08             	mov    0x8(%ebp),%edx
  80114c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80114f:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  801152:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  801154:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  801157:	83 3a 01             	cmpl   $0x1,(%edx)
  80115a:	7e 09                	jle    801165 <argstart+0x1f>
  80115c:	ba 28 24 80 00       	mov    $0x802428,%edx
  801161:	85 c9                	test   %ecx,%ecx
  801163:	75 05                	jne    80116a <argstart+0x24>
  801165:	ba 00 00 00 00       	mov    $0x0,%edx
  80116a:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  80116d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  801174:	5d                   	pop    %ebp
  801175:	c3                   	ret    

00801176 <argnext>:

int
argnext(struct Argstate *args)
{
  801176:	55                   	push   %ebp
  801177:	89 e5                	mov    %esp,%ebp
  801179:	53                   	push   %ebx
  80117a:	83 ec 04             	sub    $0x4,%esp
  80117d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  801180:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  801187:	8b 43 08             	mov    0x8(%ebx),%eax
  80118a:	85 c0                	test   %eax,%eax
  80118c:	74 72                	je     801200 <argnext+0x8a>
		return -1;

	if (!*args->curarg) {
  80118e:	80 38 00             	cmpb   $0x0,(%eax)
  801191:	75 48                	jne    8011db <argnext+0x65>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  801193:	8b 0b                	mov    (%ebx),%ecx
  801195:	83 39 01             	cmpl   $0x1,(%ecx)
  801198:	74 58                	je     8011f2 <argnext+0x7c>
		    || args->argv[1][0] != '-'
  80119a:	8b 53 04             	mov    0x4(%ebx),%edx
  80119d:	8b 42 04             	mov    0x4(%edx),%eax
  8011a0:	80 38 2d             	cmpb   $0x2d,(%eax)
  8011a3:	75 4d                	jne    8011f2 <argnext+0x7c>
		    || args->argv[1][1] == '\0')
  8011a5:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  8011a9:	74 47                	je     8011f2 <argnext+0x7c>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  8011ab:	83 c0 01             	add    $0x1,%eax
  8011ae:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  8011b1:	83 ec 04             	sub    $0x4,%esp
  8011b4:	8b 01                	mov    (%ecx),%eax
  8011b6:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  8011bd:	50                   	push   %eax
  8011be:	8d 42 08             	lea    0x8(%edx),%eax
  8011c1:	50                   	push   %eax
  8011c2:	83 c2 04             	add    $0x4,%edx
  8011c5:	52                   	push   %edx
  8011c6:	e8 e5 fa ff ff       	call   800cb0 <memmove>
		(*args->argc)--;
  8011cb:	8b 03                	mov    (%ebx),%eax
  8011cd:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  8011d0:	8b 43 08             	mov    0x8(%ebx),%eax
  8011d3:	83 c4 10             	add    $0x10,%esp
  8011d6:	80 38 2d             	cmpb   $0x2d,(%eax)
  8011d9:	74 11                	je     8011ec <argnext+0x76>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  8011db:	8b 53 08             	mov    0x8(%ebx),%edx
  8011de:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  8011e1:	83 c2 01             	add    $0x1,%edx
  8011e4:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  8011e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011ea:	c9                   	leave  
  8011eb:	c3                   	ret    
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  8011ec:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  8011f0:	75 e9                	jne    8011db <argnext+0x65>
	args->curarg = 0;
  8011f2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  8011f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8011fe:	eb e7                	jmp    8011e7 <argnext+0x71>
		return -1;
  801200:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801205:	eb e0                	jmp    8011e7 <argnext+0x71>

00801207 <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  801207:	55                   	push   %ebp
  801208:	89 e5                	mov    %esp,%ebp
  80120a:	53                   	push   %ebx
  80120b:	83 ec 04             	sub    $0x4,%esp
  80120e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  801211:	8b 43 08             	mov    0x8(%ebx),%eax
  801214:	85 c0                	test   %eax,%eax
  801216:	74 5b                	je     801273 <argnextvalue+0x6c>
		return 0;
	if (*args->curarg) {
  801218:	80 38 00             	cmpb   $0x0,(%eax)
  80121b:	74 12                	je     80122f <argnextvalue+0x28>
		args->argvalue = args->curarg;
  80121d:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  801220:	c7 43 08 28 24 80 00 	movl   $0x802428,0x8(%ebx)
		(*args->argc)--;
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
  801227:	8b 43 0c             	mov    0xc(%ebx),%eax
}
  80122a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80122d:	c9                   	leave  
  80122e:	c3                   	ret    
	} else if (*args->argc > 1) {
  80122f:	8b 13                	mov    (%ebx),%edx
  801231:	83 3a 01             	cmpl   $0x1,(%edx)
  801234:	7f 10                	jg     801246 <argnextvalue+0x3f>
		args->argvalue = 0;
  801236:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  80123d:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  801244:	eb e1                	jmp    801227 <argnextvalue+0x20>
		args->argvalue = args->argv[1];
  801246:	8b 43 04             	mov    0x4(%ebx),%eax
  801249:	8b 48 04             	mov    0x4(%eax),%ecx
  80124c:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  80124f:	83 ec 04             	sub    $0x4,%esp
  801252:	8b 12                	mov    (%edx),%edx
  801254:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  80125b:	52                   	push   %edx
  80125c:	8d 50 08             	lea    0x8(%eax),%edx
  80125f:	52                   	push   %edx
  801260:	83 c0 04             	add    $0x4,%eax
  801263:	50                   	push   %eax
  801264:	e8 47 fa ff ff       	call   800cb0 <memmove>
		(*args->argc)--;
  801269:	8b 03                	mov    (%ebx),%eax
  80126b:	83 28 01             	subl   $0x1,(%eax)
  80126e:	83 c4 10             	add    $0x10,%esp
  801271:	eb b4                	jmp    801227 <argnextvalue+0x20>
		return 0;
  801273:	b8 00 00 00 00       	mov    $0x0,%eax
  801278:	eb b0                	jmp    80122a <argnextvalue+0x23>

0080127a <argvalue>:
{
  80127a:	55                   	push   %ebp
  80127b:	89 e5                	mov    %esp,%ebp
  80127d:	83 ec 08             	sub    $0x8,%esp
  801280:	8b 55 08             	mov    0x8(%ebp),%edx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801283:	8b 42 0c             	mov    0xc(%edx),%eax
  801286:	85 c0                	test   %eax,%eax
  801288:	74 02                	je     80128c <argvalue+0x12>
}
  80128a:	c9                   	leave  
  80128b:	c3                   	ret    
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  80128c:	83 ec 0c             	sub    $0xc,%esp
  80128f:	52                   	push   %edx
  801290:	e8 72 ff ff ff       	call   801207 <argnextvalue>
  801295:	83 c4 10             	add    $0x10,%esp
  801298:	eb f0                	jmp    80128a <argvalue+0x10>

0080129a <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80129a:	55                   	push   %ebp
  80129b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80129d:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a0:	05 00 00 00 30       	add    $0x30000000,%eax
  8012a5:	c1 e8 0c             	shr    $0xc,%eax
}
  8012a8:	5d                   	pop    %ebp
  8012a9:	c3                   	ret    

008012aa <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8012aa:	55                   	push   %ebp
  8012ab:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b0:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8012b5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012ba:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8012bf:	5d                   	pop    %ebp
  8012c0:	c3                   	ret    

008012c1 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8012c1:	55                   	push   %ebp
  8012c2:	89 e5                	mov    %esp,%ebp
  8012c4:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8012c9:	89 c2                	mov    %eax,%edx
  8012cb:	c1 ea 16             	shr    $0x16,%edx
  8012ce:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8012d5:	f6 c2 01             	test   $0x1,%dl
  8012d8:	74 2d                	je     801307 <fd_alloc+0x46>
  8012da:	89 c2                	mov    %eax,%edx
  8012dc:	c1 ea 0c             	shr    $0xc,%edx
  8012df:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012e6:	f6 c2 01             	test   $0x1,%dl
  8012e9:	74 1c                	je     801307 <fd_alloc+0x46>
  8012eb:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8012f0:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8012f5:	75 d2                	jne    8012c9 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8012f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801300:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801305:	eb 0a                	jmp    801311 <fd_alloc+0x50>
			*fd_store = fd;
  801307:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80130a:	89 01                	mov    %eax,(%ecx)
			return 0;
  80130c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801311:	5d                   	pop    %ebp
  801312:	c3                   	ret    

00801313 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801313:	55                   	push   %ebp
  801314:	89 e5                	mov    %esp,%ebp
  801316:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801319:	83 f8 1f             	cmp    $0x1f,%eax
  80131c:	77 30                	ja     80134e <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80131e:	c1 e0 0c             	shl    $0xc,%eax
  801321:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801326:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80132c:	f6 c2 01             	test   $0x1,%dl
  80132f:	74 24                	je     801355 <fd_lookup+0x42>
  801331:	89 c2                	mov    %eax,%edx
  801333:	c1 ea 0c             	shr    $0xc,%edx
  801336:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80133d:	f6 c2 01             	test   $0x1,%dl
  801340:	74 1a                	je     80135c <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801342:	8b 55 0c             	mov    0xc(%ebp),%edx
  801345:	89 02                	mov    %eax,(%edx)
	return 0;
  801347:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80134c:	5d                   	pop    %ebp
  80134d:	c3                   	ret    
		return -E_INVAL;
  80134e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801353:	eb f7                	jmp    80134c <fd_lookup+0x39>
		return -E_INVAL;
  801355:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80135a:	eb f0                	jmp    80134c <fd_lookup+0x39>
  80135c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801361:	eb e9                	jmp    80134c <fd_lookup+0x39>

00801363 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801363:	55                   	push   %ebp
  801364:	89 e5                	mov    %esp,%ebp
  801366:	83 ec 08             	sub    $0x8,%esp
  801369:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80136c:	ba ac 28 80 00       	mov    $0x8028ac,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801371:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801376:	39 08                	cmp    %ecx,(%eax)
  801378:	74 33                	je     8013ad <dev_lookup+0x4a>
  80137a:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  80137d:	8b 02                	mov    (%edx),%eax
  80137f:	85 c0                	test   %eax,%eax
  801381:	75 f3                	jne    801376 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801383:	a1 20 44 80 00       	mov    0x804420,%eax
  801388:	8b 40 48             	mov    0x48(%eax),%eax
  80138b:	83 ec 04             	sub    $0x4,%esp
  80138e:	51                   	push   %ecx
  80138f:	50                   	push   %eax
  801390:	68 2c 28 80 00       	push   $0x80282c
  801395:	e8 62 f0 ff ff       	call   8003fc <cprintf>
	*dev = 0;
  80139a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8013a3:	83 c4 10             	add    $0x10,%esp
  8013a6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8013ab:	c9                   	leave  
  8013ac:	c3                   	ret    
			*dev = devtab[i];
  8013ad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013b0:	89 01                	mov    %eax,(%ecx)
			return 0;
  8013b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8013b7:	eb f2                	jmp    8013ab <dev_lookup+0x48>

008013b9 <fd_close>:
{
  8013b9:	55                   	push   %ebp
  8013ba:	89 e5                	mov    %esp,%ebp
  8013bc:	57                   	push   %edi
  8013bd:	56                   	push   %esi
  8013be:	53                   	push   %ebx
  8013bf:	83 ec 24             	sub    $0x24,%esp
  8013c2:	8b 75 08             	mov    0x8(%ebp),%esi
  8013c5:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8013c8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8013cb:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013cc:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8013d2:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8013d5:	50                   	push   %eax
  8013d6:	e8 38 ff ff ff       	call   801313 <fd_lookup>
  8013db:	89 c3                	mov    %eax,%ebx
  8013dd:	83 c4 10             	add    $0x10,%esp
  8013e0:	85 c0                	test   %eax,%eax
  8013e2:	78 05                	js     8013e9 <fd_close+0x30>
	    || fd != fd2)
  8013e4:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8013e7:	74 16                	je     8013ff <fd_close+0x46>
		return (must_exist ? r : 0);
  8013e9:	89 f8                	mov    %edi,%eax
  8013eb:	84 c0                	test   %al,%al
  8013ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8013f2:	0f 44 d8             	cmove  %eax,%ebx
}
  8013f5:	89 d8                	mov    %ebx,%eax
  8013f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013fa:	5b                   	pop    %ebx
  8013fb:	5e                   	pop    %esi
  8013fc:	5f                   	pop    %edi
  8013fd:	5d                   	pop    %ebp
  8013fe:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8013ff:	83 ec 08             	sub    $0x8,%esp
  801402:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801405:	50                   	push   %eax
  801406:	ff 36                	pushl  (%esi)
  801408:	e8 56 ff ff ff       	call   801363 <dev_lookup>
  80140d:	89 c3                	mov    %eax,%ebx
  80140f:	83 c4 10             	add    $0x10,%esp
  801412:	85 c0                	test   %eax,%eax
  801414:	78 1a                	js     801430 <fd_close+0x77>
		if (dev->dev_close)
  801416:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801419:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80141c:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801421:	85 c0                	test   %eax,%eax
  801423:	74 0b                	je     801430 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801425:	83 ec 0c             	sub    $0xc,%esp
  801428:	56                   	push   %esi
  801429:	ff d0                	call   *%eax
  80142b:	89 c3                	mov    %eax,%ebx
  80142d:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801430:	83 ec 08             	sub    $0x8,%esp
  801433:	56                   	push   %esi
  801434:	6a 00                	push   $0x0
  801436:	e8 5e fb ff ff       	call   800f99 <sys_page_unmap>
	return r;
  80143b:	83 c4 10             	add    $0x10,%esp
  80143e:	eb b5                	jmp    8013f5 <fd_close+0x3c>

00801440 <close>:

int
close(int fdnum)
{
  801440:	55                   	push   %ebp
  801441:	89 e5                	mov    %esp,%ebp
  801443:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801446:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801449:	50                   	push   %eax
  80144a:	ff 75 08             	pushl  0x8(%ebp)
  80144d:	e8 c1 fe ff ff       	call   801313 <fd_lookup>
  801452:	83 c4 10             	add    $0x10,%esp
  801455:	85 c0                	test   %eax,%eax
  801457:	79 02                	jns    80145b <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801459:	c9                   	leave  
  80145a:	c3                   	ret    
		return fd_close(fd, 1);
  80145b:	83 ec 08             	sub    $0x8,%esp
  80145e:	6a 01                	push   $0x1
  801460:	ff 75 f4             	pushl  -0xc(%ebp)
  801463:	e8 51 ff ff ff       	call   8013b9 <fd_close>
  801468:	83 c4 10             	add    $0x10,%esp
  80146b:	eb ec                	jmp    801459 <close+0x19>

0080146d <close_all>:

void
close_all(void)
{
  80146d:	55                   	push   %ebp
  80146e:	89 e5                	mov    %esp,%ebp
  801470:	53                   	push   %ebx
  801471:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801474:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801479:	83 ec 0c             	sub    $0xc,%esp
  80147c:	53                   	push   %ebx
  80147d:	e8 be ff ff ff       	call   801440 <close>
	for (i = 0; i < MAXFD; i++)
  801482:	83 c3 01             	add    $0x1,%ebx
  801485:	83 c4 10             	add    $0x10,%esp
  801488:	83 fb 20             	cmp    $0x20,%ebx
  80148b:	75 ec                	jne    801479 <close_all+0xc>
}
  80148d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801490:	c9                   	leave  
  801491:	c3                   	ret    

00801492 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801492:	55                   	push   %ebp
  801493:	89 e5                	mov    %esp,%ebp
  801495:	57                   	push   %edi
  801496:	56                   	push   %esi
  801497:	53                   	push   %ebx
  801498:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80149b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80149e:	50                   	push   %eax
  80149f:	ff 75 08             	pushl  0x8(%ebp)
  8014a2:	e8 6c fe ff ff       	call   801313 <fd_lookup>
  8014a7:	89 c3                	mov    %eax,%ebx
  8014a9:	83 c4 10             	add    $0x10,%esp
  8014ac:	85 c0                	test   %eax,%eax
  8014ae:	0f 88 81 00 00 00    	js     801535 <dup+0xa3>
		return r;
	close(newfdnum);
  8014b4:	83 ec 0c             	sub    $0xc,%esp
  8014b7:	ff 75 0c             	pushl  0xc(%ebp)
  8014ba:	e8 81 ff ff ff       	call   801440 <close>

	newfd = INDEX2FD(newfdnum);
  8014bf:	8b 75 0c             	mov    0xc(%ebp),%esi
  8014c2:	c1 e6 0c             	shl    $0xc,%esi
  8014c5:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8014cb:	83 c4 04             	add    $0x4,%esp
  8014ce:	ff 75 e4             	pushl  -0x1c(%ebp)
  8014d1:	e8 d4 fd ff ff       	call   8012aa <fd2data>
  8014d6:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8014d8:	89 34 24             	mov    %esi,(%esp)
  8014db:	e8 ca fd ff ff       	call   8012aa <fd2data>
  8014e0:	83 c4 10             	add    $0x10,%esp
  8014e3:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8014e5:	89 d8                	mov    %ebx,%eax
  8014e7:	c1 e8 16             	shr    $0x16,%eax
  8014ea:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8014f1:	a8 01                	test   $0x1,%al
  8014f3:	74 11                	je     801506 <dup+0x74>
  8014f5:	89 d8                	mov    %ebx,%eax
  8014f7:	c1 e8 0c             	shr    $0xc,%eax
  8014fa:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801501:	f6 c2 01             	test   $0x1,%dl
  801504:	75 39                	jne    80153f <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801506:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801509:	89 d0                	mov    %edx,%eax
  80150b:	c1 e8 0c             	shr    $0xc,%eax
  80150e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801515:	83 ec 0c             	sub    $0xc,%esp
  801518:	25 07 0e 00 00       	and    $0xe07,%eax
  80151d:	50                   	push   %eax
  80151e:	56                   	push   %esi
  80151f:	6a 00                	push   $0x0
  801521:	52                   	push   %edx
  801522:	6a 00                	push   $0x0
  801524:	e8 2e fa ff ff       	call   800f57 <sys_page_map>
  801529:	89 c3                	mov    %eax,%ebx
  80152b:	83 c4 20             	add    $0x20,%esp
  80152e:	85 c0                	test   %eax,%eax
  801530:	78 31                	js     801563 <dup+0xd1>
		goto err;

	return newfdnum;
  801532:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801535:	89 d8                	mov    %ebx,%eax
  801537:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80153a:	5b                   	pop    %ebx
  80153b:	5e                   	pop    %esi
  80153c:	5f                   	pop    %edi
  80153d:	5d                   	pop    %ebp
  80153e:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80153f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801546:	83 ec 0c             	sub    $0xc,%esp
  801549:	25 07 0e 00 00       	and    $0xe07,%eax
  80154e:	50                   	push   %eax
  80154f:	57                   	push   %edi
  801550:	6a 00                	push   $0x0
  801552:	53                   	push   %ebx
  801553:	6a 00                	push   $0x0
  801555:	e8 fd f9 ff ff       	call   800f57 <sys_page_map>
  80155a:	89 c3                	mov    %eax,%ebx
  80155c:	83 c4 20             	add    $0x20,%esp
  80155f:	85 c0                	test   %eax,%eax
  801561:	79 a3                	jns    801506 <dup+0x74>
	sys_page_unmap(0, newfd);
  801563:	83 ec 08             	sub    $0x8,%esp
  801566:	56                   	push   %esi
  801567:	6a 00                	push   $0x0
  801569:	e8 2b fa ff ff       	call   800f99 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80156e:	83 c4 08             	add    $0x8,%esp
  801571:	57                   	push   %edi
  801572:	6a 00                	push   $0x0
  801574:	e8 20 fa ff ff       	call   800f99 <sys_page_unmap>
	return r;
  801579:	83 c4 10             	add    $0x10,%esp
  80157c:	eb b7                	jmp    801535 <dup+0xa3>

0080157e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80157e:	55                   	push   %ebp
  80157f:	89 e5                	mov    %esp,%ebp
  801581:	53                   	push   %ebx
  801582:	83 ec 1c             	sub    $0x1c,%esp
  801585:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801588:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80158b:	50                   	push   %eax
  80158c:	53                   	push   %ebx
  80158d:	e8 81 fd ff ff       	call   801313 <fd_lookup>
  801592:	83 c4 10             	add    $0x10,%esp
  801595:	85 c0                	test   %eax,%eax
  801597:	78 3f                	js     8015d8 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801599:	83 ec 08             	sub    $0x8,%esp
  80159c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80159f:	50                   	push   %eax
  8015a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015a3:	ff 30                	pushl  (%eax)
  8015a5:	e8 b9 fd ff ff       	call   801363 <dev_lookup>
  8015aa:	83 c4 10             	add    $0x10,%esp
  8015ad:	85 c0                	test   %eax,%eax
  8015af:	78 27                	js     8015d8 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8015b1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015b4:	8b 42 08             	mov    0x8(%edx),%eax
  8015b7:	83 e0 03             	and    $0x3,%eax
  8015ba:	83 f8 01             	cmp    $0x1,%eax
  8015bd:	74 1e                	je     8015dd <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8015bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015c2:	8b 40 08             	mov    0x8(%eax),%eax
  8015c5:	85 c0                	test   %eax,%eax
  8015c7:	74 35                	je     8015fe <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8015c9:	83 ec 04             	sub    $0x4,%esp
  8015cc:	ff 75 10             	pushl  0x10(%ebp)
  8015cf:	ff 75 0c             	pushl  0xc(%ebp)
  8015d2:	52                   	push   %edx
  8015d3:	ff d0                	call   *%eax
  8015d5:	83 c4 10             	add    $0x10,%esp
}
  8015d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015db:	c9                   	leave  
  8015dc:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8015dd:	a1 20 44 80 00       	mov    0x804420,%eax
  8015e2:	8b 40 48             	mov    0x48(%eax),%eax
  8015e5:	83 ec 04             	sub    $0x4,%esp
  8015e8:	53                   	push   %ebx
  8015e9:	50                   	push   %eax
  8015ea:	68 70 28 80 00       	push   $0x802870
  8015ef:	e8 08 ee ff ff       	call   8003fc <cprintf>
		return -E_INVAL;
  8015f4:	83 c4 10             	add    $0x10,%esp
  8015f7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015fc:	eb da                	jmp    8015d8 <read+0x5a>
		return -E_NOT_SUPP;
  8015fe:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801603:	eb d3                	jmp    8015d8 <read+0x5a>

00801605 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801605:	55                   	push   %ebp
  801606:	89 e5                	mov    %esp,%ebp
  801608:	57                   	push   %edi
  801609:	56                   	push   %esi
  80160a:	53                   	push   %ebx
  80160b:	83 ec 0c             	sub    $0xc,%esp
  80160e:	8b 7d 08             	mov    0x8(%ebp),%edi
  801611:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801614:	bb 00 00 00 00       	mov    $0x0,%ebx
  801619:	39 f3                	cmp    %esi,%ebx
  80161b:	73 23                	jae    801640 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80161d:	83 ec 04             	sub    $0x4,%esp
  801620:	89 f0                	mov    %esi,%eax
  801622:	29 d8                	sub    %ebx,%eax
  801624:	50                   	push   %eax
  801625:	89 d8                	mov    %ebx,%eax
  801627:	03 45 0c             	add    0xc(%ebp),%eax
  80162a:	50                   	push   %eax
  80162b:	57                   	push   %edi
  80162c:	e8 4d ff ff ff       	call   80157e <read>
		if (m < 0)
  801631:	83 c4 10             	add    $0x10,%esp
  801634:	85 c0                	test   %eax,%eax
  801636:	78 06                	js     80163e <readn+0x39>
			return m;
		if (m == 0)
  801638:	74 06                	je     801640 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  80163a:	01 c3                	add    %eax,%ebx
  80163c:	eb db                	jmp    801619 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80163e:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801640:	89 d8                	mov    %ebx,%eax
  801642:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801645:	5b                   	pop    %ebx
  801646:	5e                   	pop    %esi
  801647:	5f                   	pop    %edi
  801648:	5d                   	pop    %ebp
  801649:	c3                   	ret    

0080164a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80164a:	55                   	push   %ebp
  80164b:	89 e5                	mov    %esp,%ebp
  80164d:	53                   	push   %ebx
  80164e:	83 ec 1c             	sub    $0x1c,%esp
  801651:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801654:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801657:	50                   	push   %eax
  801658:	53                   	push   %ebx
  801659:	e8 b5 fc ff ff       	call   801313 <fd_lookup>
  80165e:	83 c4 10             	add    $0x10,%esp
  801661:	85 c0                	test   %eax,%eax
  801663:	78 3a                	js     80169f <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801665:	83 ec 08             	sub    $0x8,%esp
  801668:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80166b:	50                   	push   %eax
  80166c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80166f:	ff 30                	pushl  (%eax)
  801671:	e8 ed fc ff ff       	call   801363 <dev_lookup>
  801676:	83 c4 10             	add    $0x10,%esp
  801679:	85 c0                	test   %eax,%eax
  80167b:	78 22                	js     80169f <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80167d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801680:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801684:	74 1e                	je     8016a4 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801686:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801689:	8b 52 0c             	mov    0xc(%edx),%edx
  80168c:	85 d2                	test   %edx,%edx
  80168e:	74 35                	je     8016c5 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801690:	83 ec 04             	sub    $0x4,%esp
  801693:	ff 75 10             	pushl  0x10(%ebp)
  801696:	ff 75 0c             	pushl  0xc(%ebp)
  801699:	50                   	push   %eax
  80169a:	ff d2                	call   *%edx
  80169c:	83 c4 10             	add    $0x10,%esp
}
  80169f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016a2:	c9                   	leave  
  8016a3:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8016a4:	a1 20 44 80 00       	mov    0x804420,%eax
  8016a9:	8b 40 48             	mov    0x48(%eax),%eax
  8016ac:	83 ec 04             	sub    $0x4,%esp
  8016af:	53                   	push   %ebx
  8016b0:	50                   	push   %eax
  8016b1:	68 8c 28 80 00       	push   $0x80288c
  8016b6:	e8 41 ed ff ff       	call   8003fc <cprintf>
		return -E_INVAL;
  8016bb:	83 c4 10             	add    $0x10,%esp
  8016be:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016c3:	eb da                	jmp    80169f <write+0x55>
		return -E_NOT_SUPP;
  8016c5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016ca:	eb d3                	jmp    80169f <write+0x55>

008016cc <seek>:

int
seek(int fdnum, off_t offset)
{
  8016cc:	55                   	push   %ebp
  8016cd:	89 e5                	mov    %esp,%ebp
  8016cf:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016d2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016d5:	50                   	push   %eax
  8016d6:	ff 75 08             	pushl  0x8(%ebp)
  8016d9:	e8 35 fc ff ff       	call   801313 <fd_lookup>
  8016de:	83 c4 10             	add    $0x10,%esp
  8016e1:	85 c0                	test   %eax,%eax
  8016e3:	78 0e                	js     8016f3 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8016e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016eb:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8016ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016f3:	c9                   	leave  
  8016f4:	c3                   	ret    

008016f5 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8016f5:	55                   	push   %ebp
  8016f6:	89 e5                	mov    %esp,%ebp
  8016f8:	53                   	push   %ebx
  8016f9:	83 ec 1c             	sub    $0x1c,%esp
  8016fc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016ff:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801702:	50                   	push   %eax
  801703:	53                   	push   %ebx
  801704:	e8 0a fc ff ff       	call   801313 <fd_lookup>
  801709:	83 c4 10             	add    $0x10,%esp
  80170c:	85 c0                	test   %eax,%eax
  80170e:	78 37                	js     801747 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801710:	83 ec 08             	sub    $0x8,%esp
  801713:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801716:	50                   	push   %eax
  801717:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80171a:	ff 30                	pushl  (%eax)
  80171c:	e8 42 fc ff ff       	call   801363 <dev_lookup>
  801721:	83 c4 10             	add    $0x10,%esp
  801724:	85 c0                	test   %eax,%eax
  801726:	78 1f                	js     801747 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801728:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80172b:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80172f:	74 1b                	je     80174c <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801731:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801734:	8b 52 18             	mov    0x18(%edx),%edx
  801737:	85 d2                	test   %edx,%edx
  801739:	74 32                	je     80176d <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80173b:	83 ec 08             	sub    $0x8,%esp
  80173e:	ff 75 0c             	pushl  0xc(%ebp)
  801741:	50                   	push   %eax
  801742:	ff d2                	call   *%edx
  801744:	83 c4 10             	add    $0x10,%esp
}
  801747:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80174a:	c9                   	leave  
  80174b:	c3                   	ret    
			thisenv->env_id, fdnum);
  80174c:	a1 20 44 80 00       	mov    0x804420,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801751:	8b 40 48             	mov    0x48(%eax),%eax
  801754:	83 ec 04             	sub    $0x4,%esp
  801757:	53                   	push   %ebx
  801758:	50                   	push   %eax
  801759:	68 4c 28 80 00       	push   $0x80284c
  80175e:	e8 99 ec ff ff       	call   8003fc <cprintf>
		return -E_INVAL;
  801763:	83 c4 10             	add    $0x10,%esp
  801766:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80176b:	eb da                	jmp    801747 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80176d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801772:	eb d3                	jmp    801747 <ftruncate+0x52>

00801774 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801774:	55                   	push   %ebp
  801775:	89 e5                	mov    %esp,%ebp
  801777:	53                   	push   %ebx
  801778:	83 ec 1c             	sub    $0x1c,%esp
  80177b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80177e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801781:	50                   	push   %eax
  801782:	ff 75 08             	pushl  0x8(%ebp)
  801785:	e8 89 fb ff ff       	call   801313 <fd_lookup>
  80178a:	83 c4 10             	add    $0x10,%esp
  80178d:	85 c0                	test   %eax,%eax
  80178f:	78 4b                	js     8017dc <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801791:	83 ec 08             	sub    $0x8,%esp
  801794:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801797:	50                   	push   %eax
  801798:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80179b:	ff 30                	pushl  (%eax)
  80179d:	e8 c1 fb ff ff       	call   801363 <dev_lookup>
  8017a2:	83 c4 10             	add    $0x10,%esp
  8017a5:	85 c0                	test   %eax,%eax
  8017a7:	78 33                	js     8017dc <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8017a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017ac:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8017b0:	74 2f                	je     8017e1 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8017b2:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8017b5:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8017bc:	00 00 00 
	stat->st_isdir = 0;
  8017bf:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8017c6:	00 00 00 
	stat->st_dev = dev;
  8017c9:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8017cf:	83 ec 08             	sub    $0x8,%esp
  8017d2:	53                   	push   %ebx
  8017d3:	ff 75 f0             	pushl  -0x10(%ebp)
  8017d6:	ff 50 14             	call   *0x14(%eax)
  8017d9:	83 c4 10             	add    $0x10,%esp
}
  8017dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017df:	c9                   	leave  
  8017e0:	c3                   	ret    
		return -E_NOT_SUPP;
  8017e1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017e6:	eb f4                	jmp    8017dc <fstat+0x68>

008017e8 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8017e8:	55                   	push   %ebp
  8017e9:	89 e5                	mov    %esp,%ebp
  8017eb:	56                   	push   %esi
  8017ec:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8017ed:	83 ec 08             	sub    $0x8,%esp
  8017f0:	6a 00                	push   $0x0
  8017f2:	ff 75 08             	pushl  0x8(%ebp)
  8017f5:	e8 bb 01 00 00       	call   8019b5 <open>
  8017fa:	89 c3                	mov    %eax,%ebx
  8017fc:	83 c4 10             	add    $0x10,%esp
  8017ff:	85 c0                	test   %eax,%eax
  801801:	78 1b                	js     80181e <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801803:	83 ec 08             	sub    $0x8,%esp
  801806:	ff 75 0c             	pushl  0xc(%ebp)
  801809:	50                   	push   %eax
  80180a:	e8 65 ff ff ff       	call   801774 <fstat>
  80180f:	89 c6                	mov    %eax,%esi
	close(fd);
  801811:	89 1c 24             	mov    %ebx,(%esp)
  801814:	e8 27 fc ff ff       	call   801440 <close>
	return r;
  801819:	83 c4 10             	add    $0x10,%esp
  80181c:	89 f3                	mov    %esi,%ebx
}
  80181e:	89 d8                	mov    %ebx,%eax
  801820:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801823:	5b                   	pop    %ebx
  801824:	5e                   	pop    %esi
  801825:	5d                   	pop    %ebp
  801826:	c3                   	ret    

00801827 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801827:	55                   	push   %ebp
  801828:	89 e5                	mov    %esp,%ebp
  80182a:	56                   	push   %esi
  80182b:	53                   	push   %ebx
  80182c:	89 c6                	mov    %eax,%esi
  80182e:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801830:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801837:	74 27                	je     801860 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801839:	6a 07                	push   $0x7
  80183b:	68 00 50 80 00       	push   $0x805000
  801840:	56                   	push   %esi
  801841:	ff 35 00 40 80 00    	pushl  0x804000
  801847:	e8 4e 08 00 00       	call   80209a <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80184c:	83 c4 0c             	add    $0xc,%esp
  80184f:	6a 00                	push   $0x0
  801851:	53                   	push   %ebx
  801852:	6a 00                	push   $0x0
  801854:	e8 d8 07 00 00       	call   802031 <ipc_recv>
}
  801859:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80185c:	5b                   	pop    %ebx
  80185d:	5e                   	pop    %esi
  80185e:	5d                   	pop    %ebp
  80185f:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801860:	83 ec 0c             	sub    $0xc,%esp
  801863:	6a 01                	push   $0x1
  801865:	e8 7d 08 00 00       	call   8020e7 <ipc_find_env>
  80186a:	a3 00 40 80 00       	mov    %eax,0x804000
  80186f:	83 c4 10             	add    $0x10,%esp
  801872:	eb c5                	jmp    801839 <fsipc+0x12>

00801874 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801874:	55                   	push   %ebp
  801875:	89 e5                	mov    %esp,%ebp
  801877:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80187a:	8b 45 08             	mov    0x8(%ebp),%eax
  80187d:	8b 40 0c             	mov    0xc(%eax),%eax
  801880:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801885:	8b 45 0c             	mov    0xc(%ebp),%eax
  801888:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80188d:	ba 00 00 00 00       	mov    $0x0,%edx
  801892:	b8 02 00 00 00       	mov    $0x2,%eax
  801897:	e8 8b ff ff ff       	call   801827 <fsipc>
}
  80189c:	c9                   	leave  
  80189d:	c3                   	ret    

0080189e <devfile_flush>:
{
  80189e:	55                   	push   %ebp
  80189f:	89 e5                	mov    %esp,%ebp
  8018a1:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8018a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8018aa:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8018af:	ba 00 00 00 00       	mov    $0x0,%edx
  8018b4:	b8 06 00 00 00       	mov    $0x6,%eax
  8018b9:	e8 69 ff ff ff       	call   801827 <fsipc>
}
  8018be:	c9                   	leave  
  8018bf:	c3                   	ret    

008018c0 <devfile_stat>:
{
  8018c0:	55                   	push   %ebp
  8018c1:	89 e5                	mov    %esp,%ebp
  8018c3:	53                   	push   %ebx
  8018c4:	83 ec 04             	sub    $0x4,%esp
  8018c7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8018ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8018d0:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8018d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8018da:	b8 05 00 00 00       	mov    $0x5,%eax
  8018df:	e8 43 ff ff ff       	call   801827 <fsipc>
  8018e4:	85 c0                	test   %eax,%eax
  8018e6:	78 2c                	js     801914 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8018e8:	83 ec 08             	sub    $0x8,%esp
  8018eb:	68 00 50 80 00       	push   $0x805000
  8018f0:	53                   	push   %ebx
  8018f1:	e8 2c f2 ff ff       	call   800b22 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8018f6:	a1 80 50 80 00       	mov    0x805080,%eax
  8018fb:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801901:	a1 84 50 80 00       	mov    0x805084,%eax
  801906:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80190c:	83 c4 10             	add    $0x10,%esp
  80190f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801914:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801917:	c9                   	leave  
  801918:	c3                   	ret    

00801919 <devfile_write>:
{
  801919:	55                   	push   %ebp
  80191a:	89 e5                	mov    %esp,%ebp
  80191c:	83 ec 0c             	sub    $0xc,%esp
	panic("devfile_write not implemented");
  80191f:	68 bc 28 80 00       	push   $0x8028bc
  801924:	68 90 00 00 00       	push   $0x90
  801929:	68 da 28 80 00       	push   $0x8028da
  80192e:	e8 ee e9 ff ff       	call   800321 <_panic>

00801933 <devfile_read>:
{
  801933:	55                   	push   %ebp
  801934:	89 e5                	mov    %esp,%ebp
  801936:	56                   	push   %esi
  801937:	53                   	push   %ebx
  801938:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80193b:	8b 45 08             	mov    0x8(%ebp),%eax
  80193e:	8b 40 0c             	mov    0xc(%eax),%eax
  801941:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801946:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80194c:	ba 00 00 00 00       	mov    $0x0,%edx
  801951:	b8 03 00 00 00       	mov    $0x3,%eax
  801956:	e8 cc fe ff ff       	call   801827 <fsipc>
  80195b:	89 c3                	mov    %eax,%ebx
  80195d:	85 c0                	test   %eax,%eax
  80195f:	78 1f                	js     801980 <devfile_read+0x4d>
	assert(r <= n);
  801961:	39 f0                	cmp    %esi,%eax
  801963:	77 24                	ja     801989 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801965:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80196a:	7f 33                	jg     80199f <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80196c:	83 ec 04             	sub    $0x4,%esp
  80196f:	50                   	push   %eax
  801970:	68 00 50 80 00       	push   $0x805000
  801975:	ff 75 0c             	pushl  0xc(%ebp)
  801978:	e8 33 f3 ff ff       	call   800cb0 <memmove>
	return r;
  80197d:	83 c4 10             	add    $0x10,%esp
}
  801980:	89 d8                	mov    %ebx,%eax
  801982:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801985:	5b                   	pop    %ebx
  801986:	5e                   	pop    %esi
  801987:	5d                   	pop    %ebp
  801988:	c3                   	ret    
	assert(r <= n);
  801989:	68 e5 28 80 00       	push   $0x8028e5
  80198e:	68 ec 28 80 00       	push   $0x8028ec
  801993:	6a 7c                	push   $0x7c
  801995:	68 da 28 80 00       	push   $0x8028da
  80199a:	e8 82 e9 ff ff       	call   800321 <_panic>
	assert(r <= PGSIZE);
  80199f:	68 01 29 80 00       	push   $0x802901
  8019a4:	68 ec 28 80 00       	push   $0x8028ec
  8019a9:	6a 7d                	push   $0x7d
  8019ab:	68 da 28 80 00       	push   $0x8028da
  8019b0:	e8 6c e9 ff ff       	call   800321 <_panic>

008019b5 <open>:
{
  8019b5:	55                   	push   %ebp
  8019b6:	89 e5                	mov    %esp,%ebp
  8019b8:	56                   	push   %esi
  8019b9:	53                   	push   %ebx
  8019ba:	83 ec 1c             	sub    $0x1c,%esp
  8019bd:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8019c0:	56                   	push   %esi
  8019c1:	e8 23 f1 ff ff       	call   800ae9 <strlen>
  8019c6:	83 c4 10             	add    $0x10,%esp
  8019c9:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8019ce:	7f 6c                	jg     801a3c <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8019d0:	83 ec 0c             	sub    $0xc,%esp
  8019d3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019d6:	50                   	push   %eax
  8019d7:	e8 e5 f8 ff ff       	call   8012c1 <fd_alloc>
  8019dc:	89 c3                	mov    %eax,%ebx
  8019de:	83 c4 10             	add    $0x10,%esp
  8019e1:	85 c0                	test   %eax,%eax
  8019e3:	78 3c                	js     801a21 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8019e5:	83 ec 08             	sub    $0x8,%esp
  8019e8:	56                   	push   %esi
  8019e9:	68 00 50 80 00       	push   $0x805000
  8019ee:	e8 2f f1 ff ff       	call   800b22 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8019f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019f6:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8019fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019fe:	b8 01 00 00 00       	mov    $0x1,%eax
  801a03:	e8 1f fe ff ff       	call   801827 <fsipc>
  801a08:	89 c3                	mov    %eax,%ebx
  801a0a:	83 c4 10             	add    $0x10,%esp
  801a0d:	85 c0                	test   %eax,%eax
  801a0f:	78 19                	js     801a2a <open+0x75>
	return fd2num(fd);
  801a11:	83 ec 0c             	sub    $0xc,%esp
  801a14:	ff 75 f4             	pushl  -0xc(%ebp)
  801a17:	e8 7e f8 ff ff       	call   80129a <fd2num>
  801a1c:	89 c3                	mov    %eax,%ebx
  801a1e:	83 c4 10             	add    $0x10,%esp
}
  801a21:	89 d8                	mov    %ebx,%eax
  801a23:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a26:	5b                   	pop    %ebx
  801a27:	5e                   	pop    %esi
  801a28:	5d                   	pop    %ebp
  801a29:	c3                   	ret    
		fd_close(fd, 0);
  801a2a:	83 ec 08             	sub    $0x8,%esp
  801a2d:	6a 00                	push   $0x0
  801a2f:	ff 75 f4             	pushl  -0xc(%ebp)
  801a32:	e8 82 f9 ff ff       	call   8013b9 <fd_close>
		return r;
  801a37:	83 c4 10             	add    $0x10,%esp
  801a3a:	eb e5                	jmp    801a21 <open+0x6c>
		return -E_BAD_PATH;
  801a3c:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801a41:	eb de                	jmp    801a21 <open+0x6c>

00801a43 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801a43:	55                   	push   %ebp
  801a44:	89 e5                	mov    %esp,%ebp
  801a46:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801a49:	ba 00 00 00 00       	mov    $0x0,%edx
  801a4e:	b8 08 00 00 00       	mov    $0x8,%eax
  801a53:	e8 cf fd ff ff       	call   801827 <fsipc>
}
  801a58:	c9                   	leave  
  801a59:	c3                   	ret    

00801a5a <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  801a5a:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801a5e:	7f 01                	jg     801a61 <writebuf+0x7>
  801a60:	c3                   	ret    
{
  801a61:	55                   	push   %ebp
  801a62:	89 e5                	mov    %esp,%ebp
  801a64:	53                   	push   %ebx
  801a65:	83 ec 08             	sub    $0x8,%esp
  801a68:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  801a6a:	ff 70 04             	pushl  0x4(%eax)
  801a6d:	8d 40 10             	lea    0x10(%eax),%eax
  801a70:	50                   	push   %eax
  801a71:	ff 33                	pushl  (%ebx)
  801a73:	e8 d2 fb ff ff       	call   80164a <write>
		if (result > 0)
  801a78:	83 c4 10             	add    $0x10,%esp
  801a7b:	85 c0                	test   %eax,%eax
  801a7d:	7e 03                	jle    801a82 <writebuf+0x28>
			b->result += result;
  801a7f:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801a82:	39 43 04             	cmp    %eax,0x4(%ebx)
  801a85:	74 0d                	je     801a94 <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  801a87:	85 c0                	test   %eax,%eax
  801a89:	ba 00 00 00 00       	mov    $0x0,%edx
  801a8e:	0f 4f c2             	cmovg  %edx,%eax
  801a91:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801a94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a97:	c9                   	leave  
  801a98:	c3                   	ret    

00801a99 <putch>:

static void
putch(int ch, void *thunk)
{
  801a99:	55                   	push   %ebp
  801a9a:	89 e5                	mov    %esp,%ebp
  801a9c:	53                   	push   %ebx
  801a9d:	83 ec 04             	sub    $0x4,%esp
  801aa0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801aa3:	8b 53 04             	mov    0x4(%ebx),%edx
  801aa6:	8d 42 01             	lea    0x1(%edx),%eax
  801aa9:	89 43 04             	mov    %eax,0x4(%ebx)
  801aac:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801aaf:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  801ab3:	3d 00 01 00 00       	cmp    $0x100,%eax
  801ab8:	74 06                	je     801ac0 <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  801aba:	83 c4 04             	add    $0x4,%esp
  801abd:	5b                   	pop    %ebx
  801abe:	5d                   	pop    %ebp
  801abf:	c3                   	ret    
		writebuf(b);
  801ac0:	89 d8                	mov    %ebx,%eax
  801ac2:	e8 93 ff ff ff       	call   801a5a <writebuf>
		b->idx = 0;
  801ac7:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  801ace:	eb ea                	jmp    801aba <putch+0x21>

00801ad0 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801ad0:	55                   	push   %ebp
  801ad1:	89 e5                	mov    %esp,%ebp
  801ad3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  801ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  801adc:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801ae2:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801ae9:	00 00 00 
	b.result = 0;
  801aec:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801af3:	00 00 00 
	b.error = 1;
  801af6:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801afd:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801b00:	ff 75 10             	pushl  0x10(%ebp)
  801b03:	ff 75 0c             	pushl  0xc(%ebp)
  801b06:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801b0c:	50                   	push   %eax
  801b0d:	68 99 1a 80 00       	push   $0x801a99
  801b12:	e8 12 ea ff ff       	call   800529 <vprintfmt>
	if (b.idx > 0)
  801b17:	83 c4 10             	add    $0x10,%esp
  801b1a:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801b21:	7f 11                	jg     801b34 <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  801b23:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801b29:	85 c0                	test   %eax,%eax
  801b2b:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801b32:	c9                   	leave  
  801b33:	c3                   	ret    
		writebuf(&b);
  801b34:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801b3a:	e8 1b ff ff ff       	call   801a5a <writebuf>
  801b3f:	eb e2                	jmp    801b23 <vfprintf+0x53>

00801b41 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801b41:	55                   	push   %ebp
  801b42:	89 e5                	mov    %esp,%ebp
  801b44:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801b47:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801b4a:	50                   	push   %eax
  801b4b:	ff 75 0c             	pushl  0xc(%ebp)
  801b4e:	ff 75 08             	pushl  0x8(%ebp)
  801b51:	e8 7a ff ff ff       	call   801ad0 <vfprintf>
	va_end(ap);

	return cnt;
}
  801b56:	c9                   	leave  
  801b57:	c3                   	ret    

00801b58 <printf>:

int
printf(const char *fmt, ...)
{
  801b58:	55                   	push   %ebp
  801b59:	89 e5                	mov    %esp,%ebp
  801b5b:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801b5e:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801b61:	50                   	push   %eax
  801b62:	ff 75 08             	pushl  0x8(%ebp)
  801b65:	6a 01                	push   $0x1
  801b67:	e8 64 ff ff ff       	call   801ad0 <vfprintf>
	va_end(ap);

	return cnt;
}
  801b6c:	c9                   	leave  
  801b6d:	c3                   	ret    

00801b6e <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801b6e:	55                   	push   %ebp
  801b6f:	89 e5                	mov    %esp,%ebp
  801b71:	56                   	push   %esi
  801b72:	53                   	push   %ebx
  801b73:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801b76:	83 ec 0c             	sub    $0xc,%esp
  801b79:	ff 75 08             	pushl  0x8(%ebp)
  801b7c:	e8 29 f7 ff ff       	call   8012aa <fd2data>
  801b81:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801b83:	83 c4 08             	add    $0x8,%esp
  801b86:	68 0d 29 80 00       	push   $0x80290d
  801b8b:	53                   	push   %ebx
  801b8c:	e8 91 ef ff ff       	call   800b22 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801b91:	8b 46 04             	mov    0x4(%esi),%eax
  801b94:	2b 06                	sub    (%esi),%eax
  801b96:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801b9c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ba3:	00 00 00 
	stat->st_dev = &devpipe;
  801ba6:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801bad:	30 80 00 
	return 0;
}
  801bb0:	b8 00 00 00 00       	mov    $0x0,%eax
  801bb5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bb8:	5b                   	pop    %ebx
  801bb9:	5e                   	pop    %esi
  801bba:	5d                   	pop    %ebp
  801bbb:	c3                   	ret    

00801bbc <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801bbc:	55                   	push   %ebp
  801bbd:	89 e5                	mov    %esp,%ebp
  801bbf:	53                   	push   %ebx
  801bc0:	83 ec 0c             	sub    $0xc,%esp
  801bc3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801bc6:	53                   	push   %ebx
  801bc7:	6a 00                	push   $0x0
  801bc9:	e8 cb f3 ff ff       	call   800f99 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801bce:	89 1c 24             	mov    %ebx,(%esp)
  801bd1:	e8 d4 f6 ff ff       	call   8012aa <fd2data>
  801bd6:	83 c4 08             	add    $0x8,%esp
  801bd9:	50                   	push   %eax
  801bda:	6a 00                	push   $0x0
  801bdc:	e8 b8 f3 ff ff       	call   800f99 <sys_page_unmap>
}
  801be1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801be4:	c9                   	leave  
  801be5:	c3                   	ret    

00801be6 <_pipeisclosed>:
{
  801be6:	55                   	push   %ebp
  801be7:	89 e5                	mov    %esp,%ebp
  801be9:	57                   	push   %edi
  801bea:	56                   	push   %esi
  801beb:	53                   	push   %ebx
  801bec:	83 ec 1c             	sub    $0x1c,%esp
  801bef:	89 c7                	mov    %eax,%edi
  801bf1:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801bf3:	a1 20 44 80 00       	mov    0x804420,%eax
  801bf8:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801bfb:	83 ec 0c             	sub    $0xc,%esp
  801bfe:	57                   	push   %edi
  801bff:	e8 22 05 00 00       	call   802126 <pageref>
  801c04:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801c07:	89 34 24             	mov    %esi,(%esp)
  801c0a:	e8 17 05 00 00       	call   802126 <pageref>
		nn = thisenv->env_runs;
  801c0f:	8b 15 20 44 80 00    	mov    0x804420,%edx
  801c15:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801c18:	83 c4 10             	add    $0x10,%esp
  801c1b:	39 cb                	cmp    %ecx,%ebx
  801c1d:	74 1b                	je     801c3a <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801c1f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c22:	75 cf                	jne    801bf3 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801c24:	8b 42 58             	mov    0x58(%edx),%eax
  801c27:	6a 01                	push   $0x1
  801c29:	50                   	push   %eax
  801c2a:	53                   	push   %ebx
  801c2b:	68 14 29 80 00       	push   $0x802914
  801c30:	e8 c7 e7 ff ff       	call   8003fc <cprintf>
  801c35:	83 c4 10             	add    $0x10,%esp
  801c38:	eb b9                	jmp    801bf3 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801c3a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c3d:	0f 94 c0             	sete   %al
  801c40:	0f b6 c0             	movzbl %al,%eax
}
  801c43:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c46:	5b                   	pop    %ebx
  801c47:	5e                   	pop    %esi
  801c48:	5f                   	pop    %edi
  801c49:	5d                   	pop    %ebp
  801c4a:	c3                   	ret    

00801c4b <devpipe_write>:
{
  801c4b:	55                   	push   %ebp
  801c4c:	89 e5                	mov    %esp,%ebp
  801c4e:	57                   	push   %edi
  801c4f:	56                   	push   %esi
  801c50:	53                   	push   %ebx
  801c51:	83 ec 28             	sub    $0x28,%esp
  801c54:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801c57:	56                   	push   %esi
  801c58:	e8 4d f6 ff ff       	call   8012aa <fd2data>
  801c5d:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c5f:	83 c4 10             	add    $0x10,%esp
  801c62:	bf 00 00 00 00       	mov    $0x0,%edi
  801c67:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801c6a:	74 4f                	je     801cbb <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801c6c:	8b 43 04             	mov    0x4(%ebx),%eax
  801c6f:	8b 0b                	mov    (%ebx),%ecx
  801c71:	8d 51 20             	lea    0x20(%ecx),%edx
  801c74:	39 d0                	cmp    %edx,%eax
  801c76:	72 14                	jb     801c8c <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801c78:	89 da                	mov    %ebx,%edx
  801c7a:	89 f0                	mov    %esi,%eax
  801c7c:	e8 65 ff ff ff       	call   801be6 <_pipeisclosed>
  801c81:	85 c0                	test   %eax,%eax
  801c83:	75 3b                	jne    801cc0 <devpipe_write+0x75>
			sys_yield();
  801c85:	e8 6b f2 ff ff       	call   800ef5 <sys_yield>
  801c8a:	eb e0                	jmp    801c6c <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801c8c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c8f:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801c93:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801c96:	89 c2                	mov    %eax,%edx
  801c98:	c1 fa 1f             	sar    $0x1f,%edx
  801c9b:	89 d1                	mov    %edx,%ecx
  801c9d:	c1 e9 1b             	shr    $0x1b,%ecx
  801ca0:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801ca3:	83 e2 1f             	and    $0x1f,%edx
  801ca6:	29 ca                	sub    %ecx,%edx
  801ca8:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801cac:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801cb0:	83 c0 01             	add    $0x1,%eax
  801cb3:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801cb6:	83 c7 01             	add    $0x1,%edi
  801cb9:	eb ac                	jmp    801c67 <devpipe_write+0x1c>
	return i;
  801cbb:	8b 45 10             	mov    0x10(%ebp),%eax
  801cbe:	eb 05                	jmp    801cc5 <devpipe_write+0x7a>
				return 0;
  801cc0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cc5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cc8:	5b                   	pop    %ebx
  801cc9:	5e                   	pop    %esi
  801cca:	5f                   	pop    %edi
  801ccb:	5d                   	pop    %ebp
  801ccc:	c3                   	ret    

00801ccd <devpipe_read>:
{
  801ccd:	55                   	push   %ebp
  801cce:	89 e5                	mov    %esp,%ebp
  801cd0:	57                   	push   %edi
  801cd1:	56                   	push   %esi
  801cd2:	53                   	push   %ebx
  801cd3:	83 ec 18             	sub    $0x18,%esp
  801cd6:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801cd9:	57                   	push   %edi
  801cda:	e8 cb f5 ff ff       	call   8012aa <fd2data>
  801cdf:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801ce1:	83 c4 10             	add    $0x10,%esp
  801ce4:	be 00 00 00 00       	mov    $0x0,%esi
  801ce9:	3b 75 10             	cmp    0x10(%ebp),%esi
  801cec:	75 14                	jne    801d02 <devpipe_read+0x35>
	return i;
  801cee:	8b 45 10             	mov    0x10(%ebp),%eax
  801cf1:	eb 02                	jmp    801cf5 <devpipe_read+0x28>
				return i;
  801cf3:	89 f0                	mov    %esi,%eax
}
  801cf5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cf8:	5b                   	pop    %ebx
  801cf9:	5e                   	pop    %esi
  801cfa:	5f                   	pop    %edi
  801cfb:	5d                   	pop    %ebp
  801cfc:	c3                   	ret    
			sys_yield();
  801cfd:	e8 f3 f1 ff ff       	call   800ef5 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801d02:	8b 03                	mov    (%ebx),%eax
  801d04:	3b 43 04             	cmp    0x4(%ebx),%eax
  801d07:	75 18                	jne    801d21 <devpipe_read+0x54>
			if (i > 0)
  801d09:	85 f6                	test   %esi,%esi
  801d0b:	75 e6                	jne    801cf3 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801d0d:	89 da                	mov    %ebx,%edx
  801d0f:	89 f8                	mov    %edi,%eax
  801d11:	e8 d0 fe ff ff       	call   801be6 <_pipeisclosed>
  801d16:	85 c0                	test   %eax,%eax
  801d18:	74 e3                	je     801cfd <devpipe_read+0x30>
				return 0;
  801d1a:	b8 00 00 00 00       	mov    $0x0,%eax
  801d1f:	eb d4                	jmp    801cf5 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801d21:	99                   	cltd   
  801d22:	c1 ea 1b             	shr    $0x1b,%edx
  801d25:	01 d0                	add    %edx,%eax
  801d27:	83 e0 1f             	and    $0x1f,%eax
  801d2a:	29 d0                	sub    %edx,%eax
  801d2c:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801d31:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d34:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801d37:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801d3a:	83 c6 01             	add    $0x1,%esi
  801d3d:	eb aa                	jmp    801ce9 <devpipe_read+0x1c>

00801d3f <pipe>:
{
  801d3f:	55                   	push   %ebp
  801d40:	89 e5                	mov    %esp,%ebp
  801d42:	56                   	push   %esi
  801d43:	53                   	push   %ebx
  801d44:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801d47:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d4a:	50                   	push   %eax
  801d4b:	e8 71 f5 ff ff       	call   8012c1 <fd_alloc>
  801d50:	89 c3                	mov    %eax,%ebx
  801d52:	83 c4 10             	add    $0x10,%esp
  801d55:	85 c0                	test   %eax,%eax
  801d57:	0f 88 23 01 00 00    	js     801e80 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d5d:	83 ec 04             	sub    $0x4,%esp
  801d60:	68 07 04 00 00       	push   $0x407
  801d65:	ff 75 f4             	pushl  -0xc(%ebp)
  801d68:	6a 00                	push   $0x0
  801d6a:	e8 a5 f1 ff ff       	call   800f14 <sys_page_alloc>
  801d6f:	89 c3                	mov    %eax,%ebx
  801d71:	83 c4 10             	add    $0x10,%esp
  801d74:	85 c0                	test   %eax,%eax
  801d76:	0f 88 04 01 00 00    	js     801e80 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801d7c:	83 ec 0c             	sub    $0xc,%esp
  801d7f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d82:	50                   	push   %eax
  801d83:	e8 39 f5 ff ff       	call   8012c1 <fd_alloc>
  801d88:	89 c3                	mov    %eax,%ebx
  801d8a:	83 c4 10             	add    $0x10,%esp
  801d8d:	85 c0                	test   %eax,%eax
  801d8f:	0f 88 db 00 00 00    	js     801e70 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d95:	83 ec 04             	sub    $0x4,%esp
  801d98:	68 07 04 00 00       	push   $0x407
  801d9d:	ff 75 f0             	pushl  -0x10(%ebp)
  801da0:	6a 00                	push   $0x0
  801da2:	e8 6d f1 ff ff       	call   800f14 <sys_page_alloc>
  801da7:	89 c3                	mov    %eax,%ebx
  801da9:	83 c4 10             	add    $0x10,%esp
  801dac:	85 c0                	test   %eax,%eax
  801dae:	0f 88 bc 00 00 00    	js     801e70 <pipe+0x131>
	va = fd2data(fd0);
  801db4:	83 ec 0c             	sub    $0xc,%esp
  801db7:	ff 75 f4             	pushl  -0xc(%ebp)
  801dba:	e8 eb f4 ff ff       	call   8012aa <fd2data>
  801dbf:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801dc1:	83 c4 0c             	add    $0xc,%esp
  801dc4:	68 07 04 00 00       	push   $0x407
  801dc9:	50                   	push   %eax
  801dca:	6a 00                	push   $0x0
  801dcc:	e8 43 f1 ff ff       	call   800f14 <sys_page_alloc>
  801dd1:	89 c3                	mov    %eax,%ebx
  801dd3:	83 c4 10             	add    $0x10,%esp
  801dd6:	85 c0                	test   %eax,%eax
  801dd8:	0f 88 82 00 00 00    	js     801e60 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801dde:	83 ec 0c             	sub    $0xc,%esp
  801de1:	ff 75 f0             	pushl  -0x10(%ebp)
  801de4:	e8 c1 f4 ff ff       	call   8012aa <fd2data>
  801de9:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801df0:	50                   	push   %eax
  801df1:	6a 00                	push   $0x0
  801df3:	56                   	push   %esi
  801df4:	6a 00                	push   $0x0
  801df6:	e8 5c f1 ff ff       	call   800f57 <sys_page_map>
  801dfb:	89 c3                	mov    %eax,%ebx
  801dfd:	83 c4 20             	add    $0x20,%esp
  801e00:	85 c0                	test   %eax,%eax
  801e02:	78 4e                	js     801e52 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801e04:	a1 20 30 80 00       	mov    0x803020,%eax
  801e09:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e0c:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801e0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e11:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801e18:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e1b:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801e1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e20:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801e27:	83 ec 0c             	sub    $0xc,%esp
  801e2a:	ff 75 f4             	pushl  -0xc(%ebp)
  801e2d:	e8 68 f4 ff ff       	call   80129a <fd2num>
  801e32:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e35:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801e37:	83 c4 04             	add    $0x4,%esp
  801e3a:	ff 75 f0             	pushl  -0x10(%ebp)
  801e3d:	e8 58 f4 ff ff       	call   80129a <fd2num>
  801e42:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e45:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801e48:	83 c4 10             	add    $0x10,%esp
  801e4b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e50:	eb 2e                	jmp    801e80 <pipe+0x141>
	sys_page_unmap(0, va);
  801e52:	83 ec 08             	sub    $0x8,%esp
  801e55:	56                   	push   %esi
  801e56:	6a 00                	push   $0x0
  801e58:	e8 3c f1 ff ff       	call   800f99 <sys_page_unmap>
  801e5d:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801e60:	83 ec 08             	sub    $0x8,%esp
  801e63:	ff 75 f0             	pushl  -0x10(%ebp)
  801e66:	6a 00                	push   $0x0
  801e68:	e8 2c f1 ff ff       	call   800f99 <sys_page_unmap>
  801e6d:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801e70:	83 ec 08             	sub    $0x8,%esp
  801e73:	ff 75 f4             	pushl  -0xc(%ebp)
  801e76:	6a 00                	push   $0x0
  801e78:	e8 1c f1 ff ff       	call   800f99 <sys_page_unmap>
  801e7d:	83 c4 10             	add    $0x10,%esp
}
  801e80:	89 d8                	mov    %ebx,%eax
  801e82:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e85:	5b                   	pop    %ebx
  801e86:	5e                   	pop    %esi
  801e87:	5d                   	pop    %ebp
  801e88:	c3                   	ret    

00801e89 <pipeisclosed>:
{
  801e89:	55                   	push   %ebp
  801e8a:	89 e5                	mov    %esp,%ebp
  801e8c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e8f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e92:	50                   	push   %eax
  801e93:	ff 75 08             	pushl  0x8(%ebp)
  801e96:	e8 78 f4 ff ff       	call   801313 <fd_lookup>
  801e9b:	83 c4 10             	add    $0x10,%esp
  801e9e:	85 c0                	test   %eax,%eax
  801ea0:	78 18                	js     801eba <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801ea2:	83 ec 0c             	sub    $0xc,%esp
  801ea5:	ff 75 f4             	pushl  -0xc(%ebp)
  801ea8:	e8 fd f3 ff ff       	call   8012aa <fd2data>
	return _pipeisclosed(fd, p);
  801ead:	89 c2                	mov    %eax,%edx
  801eaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb2:	e8 2f fd ff ff       	call   801be6 <_pipeisclosed>
  801eb7:	83 c4 10             	add    $0x10,%esp
}
  801eba:	c9                   	leave  
  801ebb:	c3                   	ret    

00801ebc <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801ebc:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec1:	c3                   	ret    

00801ec2 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801ec2:	55                   	push   %ebp
  801ec3:	89 e5                	mov    %esp,%ebp
  801ec5:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801ec8:	68 2c 29 80 00       	push   $0x80292c
  801ecd:	ff 75 0c             	pushl  0xc(%ebp)
  801ed0:	e8 4d ec ff ff       	call   800b22 <strcpy>
	return 0;
}
  801ed5:	b8 00 00 00 00       	mov    $0x0,%eax
  801eda:	c9                   	leave  
  801edb:	c3                   	ret    

00801edc <devcons_write>:
{
  801edc:	55                   	push   %ebp
  801edd:	89 e5                	mov    %esp,%ebp
  801edf:	57                   	push   %edi
  801ee0:	56                   	push   %esi
  801ee1:	53                   	push   %ebx
  801ee2:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801ee8:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801eed:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801ef3:	3b 75 10             	cmp    0x10(%ebp),%esi
  801ef6:	73 31                	jae    801f29 <devcons_write+0x4d>
		m = n - tot;
  801ef8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801efb:	29 f3                	sub    %esi,%ebx
  801efd:	83 fb 7f             	cmp    $0x7f,%ebx
  801f00:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801f05:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801f08:	83 ec 04             	sub    $0x4,%esp
  801f0b:	53                   	push   %ebx
  801f0c:	89 f0                	mov    %esi,%eax
  801f0e:	03 45 0c             	add    0xc(%ebp),%eax
  801f11:	50                   	push   %eax
  801f12:	57                   	push   %edi
  801f13:	e8 98 ed ff ff       	call   800cb0 <memmove>
		sys_cputs(buf, m);
  801f18:	83 c4 08             	add    $0x8,%esp
  801f1b:	53                   	push   %ebx
  801f1c:	57                   	push   %edi
  801f1d:	e8 36 ef ff ff       	call   800e58 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801f22:	01 de                	add    %ebx,%esi
  801f24:	83 c4 10             	add    $0x10,%esp
  801f27:	eb ca                	jmp    801ef3 <devcons_write+0x17>
}
  801f29:	89 f0                	mov    %esi,%eax
  801f2b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f2e:	5b                   	pop    %ebx
  801f2f:	5e                   	pop    %esi
  801f30:	5f                   	pop    %edi
  801f31:	5d                   	pop    %ebp
  801f32:	c3                   	ret    

00801f33 <devcons_read>:
{
  801f33:	55                   	push   %ebp
  801f34:	89 e5                	mov    %esp,%ebp
  801f36:	83 ec 08             	sub    $0x8,%esp
  801f39:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801f3e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f42:	74 21                	je     801f65 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  801f44:	e8 2d ef ff ff       	call   800e76 <sys_cgetc>
  801f49:	85 c0                	test   %eax,%eax
  801f4b:	75 07                	jne    801f54 <devcons_read+0x21>
		sys_yield();
  801f4d:	e8 a3 ef ff ff       	call   800ef5 <sys_yield>
  801f52:	eb f0                	jmp    801f44 <devcons_read+0x11>
	if (c < 0)
  801f54:	78 0f                	js     801f65 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  801f56:	83 f8 04             	cmp    $0x4,%eax
  801f59:	74 0c                	je     801f67 <devcons_read+0x34>
	*(char*)vbuf = c;
  801f5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f5e:	88 02                	mov    %al,(%edx)
	return 1;
  801f60:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801f65:	c9                   	leave  
  801f66:	c3                   	ret    
		return 0;
  801f67:	b8 00 00 00 00       	mov    $0x0,%eax
  801f6c:	eb f7                	jmp    801f65 <devcons_read+0x32>

00801f6e <cputchar>:
{
  801f6e:	55                   	push   %ebp
  801f6f:	89 e5                	mov    %esp,%ebp
  801f71:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801f74:	8b 45 08             	mov    0x8(%ebp),%eax
  801f77:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801f7a:	6a 01                	push   $0x1
  801f7c:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f7f:	50                   	push   %eax
  801f80:	e8 d3 ee ff ff       	call   800e58 <sys_cputs>
}
  801f85:	83 c4 10             	add    $0x10,%esp
  801f88:	c9                   	leave  
  801f89:	c3                   	ret    

00801f8a <getchar>:
{
  801f8a:	55                   	push   %ebp
  801f8b:	89 e5                	mov    %esp,%ebp
  801f8d:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801f90:	6a 01                	push   $0x1
  801f92:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f95:	50                   	push   %eax
  801f96:	6a 00                	push   $0x0
  801f98:	e8 e1 f5 ff ff       	call   80157e <read>
	if (r < 0)
  801f9d:	83 c4 10             	add    $0x10,%esp
  801fa0:	85 c0                	test   %eax,%eax
  801fa2:	78 06                	js     801faa <getchar+0x20>
	if (r < 1)
  801fa4:	74 06                	je     801fac <getchar+0x22>
	return c;
  801fa6:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801faa:	c9                   	leave  
  801fab:	c3                   	ret    
		return -E_EOF;
  801fac:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801fb1:	eb f7                	jmp    801faa <getchar+0x20>

00801fb3 <iscons>:
{
  801fb3:	55                   	push   %ebp
  801fb4:	89 e5                	mov    %esp,%ebp
  801fb6:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fb9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fbc:	50                   	push   %eax
  801fbd:	ff 75 08             	pushl  0x8(%ebp)
  801fc0:	e8 4e f3 ff ff       	call   801313 <fd_lookup>
  801fc5:	83 c4 10             	add    $0x10,%esp
  801fc8:	85 c0                	test   %eax,%eax
  801fca:	78 11                	js     801fdd <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801fcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fcf:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801fd5:	39 10                	cmp    %edx,(%eax)
  801fd7:	0f 94 c0             	sete   %al
  801fda:	0f b6 c0             	movzbl %al,%eax
}
  801fdd:	c9                   	leave  
  801fde:	c3                   	ret    

00801fdf <opencons>:
{
  801fdf:	55                   	push   %ebp
  801fe0:	89 e5                	mov    %esp,%ebp
  801fe2:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801fe5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fe8:	50                   	push   %eax
  801fe9:	e8 d3 f2 ff ff       	call   8012c1 <fd_alloc>
  801fee:	83 c4 10             	add    $0x10,%esp
  801ff1:	85 c0                	test   %eax,%eax
  801ff3:	78 3a                	js     80202f <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801ff5:	83 ec 04             	sub    $0x4,%esp
  801ff8:	68 07 04 00 00       	push   $0x407
  801ffd:	ff 75 f4             	pushl  -0xc(%ebp)
  802000:	6a 00                	push   $0x0
  802002:	e8 0d ef ff ff       	call   800f14 <sys_page_alloc>
  802007:	83 c4 10             	add    $0x10,%esp
  80200a:	85 c0                	test   %eax,%eax
  80200c:	78 21                	js     80202f <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80200e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802011:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802017:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802019:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802023:	83 ec 0c             	sub    $0xc,%esp
  802026:	50                   	push   %eax
  802027:	e8 6e f2 ff ff       	call   80129a <fd2num>
  80202c:	83 c4 10             	add    $0x10,%esp
}
  80202f:	c9                   	leave  
  802030:	c3                   	ret    

00802031 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802031:	55                   	push   %ebp
  802032:	89 e5                	mov    %esp,%ebp
  802034:	56                   	push   %esi
  802035:	53                   	push   %ebx
  802036:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802039:	8b 45 0c             	mov    0xc(%ebp),%eax
  80203c:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// return 0;
	if(!pg)
  80203f:	85 c0                	test   %eax,%eax
		pg = (void*)UTOP;
  802041:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802046:	0f 44 c2             	cmove  %edx,%eax
	
	int ret;

	ret = sys_ipc_recv(pg);
  802049:	83 ec 0c             	sub    $0xc,%esp
  80204c:	50                   	push   %eax
  80204d:	e8 72 f0 ff ff       	call   8010c4 <sys_ipc_recv>
	if(ret < 0){
  802052:	83 c4 10             	add    $0x10,%esp
  802055:	85 c0                	test   %eax,%eax
  802057:	78 2b                	js     802084 <ipc_recv+0x53>
		if(perm_store) *perm_store = 0;
		if(from_env_store) *from_env_store = 0;
		return ret;
	}
	
	if(perm_store)
  802059:	85 f6                	test   %esi,%esi
  80205b:	74 0a                	je     802067 <ipc_recv+0x36>
		*perm_store = thisenv->env_ipc_perm;
  80205d:	a1 20 44 80 00       	mov    0x804420,%eax
  802062:	8b 40 78             	mov    0x78(%eax),%eax
  802065:	89 06                	mov    %eax,(%esi)
	if(from_env_store)
  802067:	85 db                	test   %ebx,%ebx
  802069:	74 0a                	je     802075 <ipc_recv+0x44>
		*from_env_store = thisenv->env_ipc_from;
  80206b:	a1 20 44 80 00       	mov    0x804420,%eax
  802070:	8b 40 74             	mov    0x74(%eax),%eax
  802073:	89 03                	mov    %eax,(%ebx)

	return thisenv->env_ipc_value;
  802075:	a1 20 44 80 00       	mov    0x804420,%eax
  80207a:	8b 40 70             	mov    0x70(%eax),%eax
}
  80207d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802080:	5b                   	pop    %ebx
  802081:	5e                   	pop    %esi
  802082:	5d                   	pop    %ebp
  802083:	c3                   	ret    
		if(perm_store) *perm_store = 0;
  802084:	85 f6                	test   %esi,%esi
  802086:	74 06                	je     80208e <ipc_recv+0x5d>
  802088:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(from_env_store) *from_env_store = 0;
  80208e:	85 db                	test   %ebx,%ebx
  802090:	74 eb                	je     80207d <ipc_recv+0x4c>
  802092:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802098:	eb e3                	jmp    80207d <ipc_recv+0x4c>

0080209a <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80209a:	55                   	push   %ebp
  80209b:	89 e5                	mov    %esp,%ebp
  80209d:	57                   	push   %edi
  80209e:	56                   	push   %esi
  80209f:	53                   	push   %ebx
  8020a0:	83 ec 0c             	sub    $0xc,%esp
  8020a3:	8b 7d 08             	mov    0x8(%ebp),%edi
  8020a6:	8b 75 0c             	mov    0xc(%ebp),%esi
  8020a9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
	if (!pg)
  8020ac:	85 db                	test   %ebx,%ebx
		pg = (void*)UTOP;
  8020ae:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8020b3:	0f 44 d8             	cmove  %eax,%ebx

	int ret = -E_IPC_NOT_RECV;
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))) {
  8020b6:	ff 75 14             	pushl  0x14(%ebp)
  8020b9:	53                   	push   %ebx
  8020ba:	56                   	push   %esi
  8020bb:	57                   	push   %edi
  8020bc:	e8 e0 ef ff ff       	call   8010a1 <sys_ipc_try_send>
  8020c1:	83 c4 10             	add    $0x10,%esp
  8020c4:	85 c0                	test   %eax,%eax
  8020c6:	74 17                	je     8020df <ipc_send+0x45>
		if(ret != -E_IPC_NOT_RECV){
  8020c8:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8020cb:	74 e9                	je     8020b6 <ipc_send+0x1c>
			panic("ipc_send: ret : %d", ret);
  8020cd:	50                   	push   %eax
  8020ce:	68 38 29 80 00       	push   $0x802938
  8020d3:	6a 43                	push   $0x43
  8020d5:	68 4b 29 80 00       	push   $0x80294b
  8020da:	e8 42 e2 ff ff       	call   800321 <_panic>
			sys_yield();
		}
	}
}
  8020df:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020e2:	5b                   	pop    %ebx
  8020e3:	5e                   	pop    %esi
  8020e4:	5f                   	pop    %edi
  8020e5:	5d                   	pop    %ebp
  8020e6:	c3                   	ret    

008020e7 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8020e7:	55                   	push   %ebp
  8020e8:	89 e5                	mov    %esp,%ebp
  8020ea:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8020ed:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8020f2:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  8020f8:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8020fe:	8b 52 50             	mov    0x50(%edx),%edx
  802101:	39 ca                	cmp    %ecx,%edx
  802103:	74 11                	je     802116 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  802105:	83 c0 01             	add    $0x1,%eax
  802108:	3d 00 04 00 00       	cmp    $0x400,%eax
  80210d:	75 e3                	jne    8020f2 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80210f:	b8 00 00 00 00       	mov    $0x0,%eax
  802114:	eb 0e                	jmp    802124 <ipc_find_env+0x3d>
			return envs[i].env_id;
  802116:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80211c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802121:	8b 40 48             	mov    0x48(%eax),%eax
}
  802124:	5d                   	pop    %ebp
  802125:	c3                   	ret    

00802126 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802126:	55                   	push   %ebp
  802127:	89 e5                	mov    %esp,%ebp
  802129:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80212c:	89 d0                	mov    %edx,%eax
  80212e:	c1 e8 16             	shr    $0x16,%eax
  802131:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802138:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80213d:	f6 c1 01             	test   $0x1,%cl
  802140:	74 1d                	je     80215f <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802142:	c1 ea 0c             	shr    $0xc,%edx
  802145:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80214c:	f6 c2 01             	test   $0x1,%dl
  80214f:	74 0e                	je     80215f <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802151:	c1 ea 0c             	shr    $0xc,%edx
  802154:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80215b:	ef 
  80215c:	0f b7 c0             	movzwl %ax,%eax
}
  80215f:	5d                   	pop    %ebp
  802160:	c3                   	ret    
  802161:	66 90                	xchg   %ax,%ax
  802163:	66 90                	xchg   %ax,%ax
  802165:	66 90                	xchg   %ax,%ax
  802167:	66 90                	xchg   %ax,%ax
  802169:	66 90                	xchg   %ax,%ax
  80216b:	66 90                	xchg   %ax,%ax
  80216d:	66 90                	xchg   %ax,%ax
  80216f:	90                   	nop

00802170 <__udivdi3>:
  802170:	55                   	push   %ebp
  802171:	57                   	push   %edi
  802172:	56                   	push   %esi
  802173:	53                   	push   %ebx
  802174:	83 ec 1c             	sub    $0x1c,%esp
  802177:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80217b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80217f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802183:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802187:	85 d2                	test   %edx,%edx
  802189:	75 4d                	jne    8021d8 <__udivdi3+0x68>
  80218b:	39 f3                	cmp    %esi,%ebx
  80218d:	76 19                	jbe    8021a8 <__udivdi3+0x38>
  80218f:	31 ff                	xor    %edi,%edi
  802191:	89 e8                	mov    %ebp,%eax
  802193:	89 f2                	mov    %esi,%edx
  802195:	f7 f3                	div    %ebx
  802197:	89 fa                	mov    %edi,%edx
  802199:	83 c4 1c             	add    $0x1c,%esp
  80219c:	5b                   	pop    %ebx
  80219d:	5e                   	pop    %esi
  80219e:	5f                   	pop    %edi
  80219f:	5d                   	pop    %ebp
  8021a0:	c3                   	ret    
  8021a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8021a8:	89 d9                	mov    %ebx,%ecx
  8021aa:	85 db                	test   %ebx,%ebx
  8021ac:	75 0b                	jne    8021b9 <__udivdi3+0x49>
  8021ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8021b3:	31 d2                	xor    %edx,%edx
  8021b5:	f7 f3                	div    %ebx
  8021b7:	89 c1                	mov    %eax,%ecx
  8021b9:	31 d2                	xor    %edx,%edx
  8021bb:	89 f0                	mov    %esi,%eax
  8021bd:	f7 f1                	div    %ecx
  8021bf:	89 c6                	mov    %eax,%esi
  8021c1:	89 e8                	mov    %ebp,%eax
  8021c3:	89 f7                	mov    %esi,%edi
  8021c5:	f7 f1                	div    %ecx
  8021c7:	89 fa                	mov    %edi,%edx
  8021c9:	83 c4 1c             	add    $0x1c,%esp
  8021cc:	5b                   	pop    %ebx
  8021cd:	5e                   	pop    %esi
  8021ce:	5f                   	pop    %edi
  8021cf:	5d                   	pop    %ebp
  8021d0:	c3                   	ret    
  8021d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8021d8:	39 f2                	cmp    %esi,%edx
  8021da:	77 1c                	ja     8021f8 <__udivdi3+0x88>
  8021dc:	0f bd fa             	bsr    %edx,%edi
  8021df:	83 f7 1f             	xor    $0x1f,%edi
  8021e2:	75 2c                	jne    802210 <__udivdi3+0xa0>
  8021e4:	39 f2                	cmp    %esi,%edx
  8021e6:	72 06                	jb     8021ee <__udivdi3+0x7e>
  8021e8:	31 c0                	xor    %eax,%eax
  8021ea:	39 eb                	cmp    %ebp,%ebx
  8021ec:	77 a9                	ja     802197 <__udivdi3+0x27>
  8021ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8021f3:	eb a2                	jmp    802197 <__udivdi3+0x27>
  8021f5:	8d 76 00             	lea    0x0(%esi),%esi
  8021f8:	31 ff                	xor    %edi,%edi
  8021fa:	31 c0                	xor    %eax,%eax
  8021fc:	89 fa                	mov    %edi,%edx
  8021fe:	83 c4 1c             	add    $0x1c,%esp
  802201:	5b                   	pop    %ebx
  802202:	5e                   	pop    %esi
  802203:	5f                   	pop    %edi
  802204:	5d                   	pop    %ebp
  802205:	c3                   	ret    
  802206:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80220d:	8d 76 00             	lea    0x0(%esi),%esi
  802210:	89 f9                	mov    %edi,%ecx
  802212:	b8 20 00 00 00       	mov    $0x20,%eax
  802217:	29 f8                	sub    %edi,%eax
  802219:	d3 e2                	shl    %cl,%edx
  80221b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80221f:	89 c1                	mov    %eax,%ecx
  802221:	89 da                	mov    %ebx,%edx
  802223:	d3 ea                	shr    %cl,%edx
  802225:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802229:	09 d1                	or     %edx,%ecx
  80222b:	89 f2                	mov    %esi,%edx
  80222d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802231:	89 f9                	mov    %edi,%ecx
  802233:	d3 e3                	shl    %cl,%ebx
  802235:	89 c1                	mov    %eax,%ecx
  802237:	d3 ea                	shr    %cl,%edx
  802239:	89 f9                	mov    %edi,%ecx
  80223b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80223f:	89 eb                	mov    %ebp,%ebx
  802241:	d3 e6                	shl    %cl,%esi
  802243:	89 c1                	mov    %eax,%ecx
  802245:	d3 eb                	shr    %cl,%ebx
  802247:	09 de                	or     %ebx,%esi
  802249:	89 f0                	mov    %esi,%eax
  80224b:	f7 74 24 08          	divl   0x8(%esp)
  80224f:	89 d6                	mov    %edx,%esi
  802251:	89 c3                	mov    %eax,%ebx
  802253:	f7 64 24 0c          	mull   0xc(%esp)
  802257:	39 d6                	cmp    %edx,%esi
  802259:	72 15                	jb     802270 <__udivdi3+0x100>
  80225b:	89 f9                	mov    %edi,%ecx
  80225d:	d3 e5                	shl    %cl,%ebp
  80225f:	39 c5                	cmp    %eax,%ebp
  802261:	73 04                	jae    802267 <__udivdi3+0xf7>
  802263:	39 d6                	cmp    %edx,%esi
  802265:	74 09                	je     802270 <__udivdi3+0x100>
  802267:	89 d8                	mov    %ebx,%eax
  802269:	31 ff                	xor    %edi,%edi
  80226b:	e9 27 ff ff ff       	jmp    802197 <__udivdi3+0x27>
  802270:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802273:	31 ff                	xor    %edi,%edi
  802275:	e9 1d ff ff ff       	jmp    802197 <__udivdi3+0x27>
  80227a:	66 90                	xchg   %ax,%ax
  80227c:	66 90                	xchg   %ax,%ax
  80227e:	66 90                	xchg   %ax,%ax

00802280 <__umoddi3>:
  802280:	55                   	push   %ebp
  802281:	57                   	push   %edi
  802282:	56                   	push   %esi
  802283:	53                   	push   %ebx
  802284:	83 ec 1c             	sub    $0x1c,%esp
  802287:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80228b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80228f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802293:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802297:	89 da                	mov    %ebx,%edx
  802299:	85 c0                	test   %eax,%eax
  80229b:	75 43                	jne    8022e0 <__umoddi3+0x60>
  80229d:	39 df                	cmp    %ebx,%edi
  80229f:	76 17                	jbe    8022b8 <__umoddi3+0x38>
  8022a1:	89 f0                	mov    %esi,%eax
  8022a3:	f7 f7                	div    %edi
  8022a5:	89 d0                	mov    %edx,%eax
  8022a7:	31 d2                	xor    %edx,%edx
  8022a9:	83 c4 1c             	add    $0x1c,%esp
  8022ac:	5b                   	pop    %ebx
  8022ad:	5e                   	pop    %esi
  8022ae:	5f                   	pop    %edi
  8022af:	5d                   	pop    %ebp
  8022b0:	c3                   	ret    
  8022b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022b8:	89 fd                	mov    %edi,%ebp
  8022ba:	85 ff                	test   %edi,%edi
  8022bc:	75 0b                	jne    8022c9 <__umoddi3+0x49>
  8022be:	b8 01 00 00 00       	mov    $0x1,%eax
  8022c3:	31 d2                	xor    %edx,%edx
  8022c5:	f7 f7                	div    %edi
  8022c7:	89 c5                	mov    %eax,%ebp
  8022c9:	89 d8                	mov    %ebx,%eax
  8022cb:	31 d2                	xor    %edx,%edx
  8022cd:	f7 f5                	div    %ebp
  8022cf:	89 f0                	mov    %esi,%eax
  8022d1:	f7 f5                	div    %ebp
  8022d3:	89 d0                	mov    %edx,%eax
  8022d5:	eb d0                	jmp    8022a7 <__umoddi3+0x27>
  8022d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022de:	66 90                	xchg   %ax,%ax
  8022e0:	89 f1                	mov    %esi,%ecx
  8022e2:	39 d8                	cmp    %ebx,%eax
  8022e4:	76 0a                	jbe    8022f0 <__umoddi3+0x70>
  8022e6:	89 f0                	mov    %esi,%eax
  8022e8:	83 c4 1c             	add    $0x1c,%esp
  8022eb:	5b                   	pop    %ebx
  8022ec:	5e                   	pop    %esi
  8022ed:	5f                   	pop    %edi
  8022ee:	5d                   	pop    %ebp
  8022ef:	c3                   	ret    
  8022f0:	0f bd e8             	bsr    %eax,%ebp
  8022f3:	83 f5 1f             	xor    $0x1f,%ebp
  8022f6:	75 20                	jne    802318 <__umoddi3+0x98>
  8022f8:	39 d8                	cmp    %ebx,%eax
  8022fa:	0f 82 b0 00 00 00    	jb     8023b0 <__umoddi3+0x130>
  802300:	39 f7                	cmp    %esi,%edi
  802302:	0f 86 a8 00 00 00    	jbe    8023b0 <__umoddi3+0x130>
  802308:	89 c8                	mov    %ecx,%eax
  80230a:	83 c4 1c             	add    $0x1c,%esp
  80230d:	5b                   	pop    %ebx
  80230e:	5e                   	pop    %esi
  80230f:	5f                   	pop    %edi
  802310:	5d                   	pop    %ebp
  802311:	c3                   	ret    
  802312:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802318:	89 e9                	mov    %ebp,%ecx
  80231a:	ba 20 00 00 00       	mov    $0x20,%edx
  80231f:	29 ea                	sub    %ebp,%edx
  802321:	d3 e0                	shl    %cl,%eax
  802323:	89 44 24 08          	mov    %eax,0x8(%esp)
  802327:	89 d1                	mov    %edx,%ecx
  802329:	89 f8                	mov    %edi,%eax
  80232b:	d3 e8                	shr    %cl,%eax
  80232d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802331:	89 54 24 04          	mov    %edx,0x4(%esp)
  802335:	8b 54 24 04          	mov    0x4(%esp),%edx
  802339:	09 c1                	or     %eax,%ecx
  80233b:	89 d8                	mov    %ebx,%eax
  80233d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802341:	89 e9                	mov    %ebp,%ecx
  802343:	d3 e7                	shl    %cl,%edi
  802345:	89 d1                	mov    %edx,%ecx
  802347:	d3 e8                	shr    %cl,%eax
  802349:	89 e9                	mov    %ebp,%ecx
  80234b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80234f:	d3 e3                	shl    %cl,%ebx
  802351:	89 c7                	mov    %eax,%edi
  802353:	89 d1                	mov    %edx,%ecx
  802355:	89 f0                	mov    %esi,%eax
  802357:	d3 e8                	shr    %cl,%eax
  802359:	89 e9                	mov    %ebp,%ecx
  80235b:	89 fa                	mov    %edi,%edx
  80235d:	d3 e6                	shl    %cl,%esi
  80235f:	09 d8                	or     %ebx,%eax
  802361:	f7 74 24 08          	divl   0x8(%esp)
  802365:	89 d1                	mov    %edx,%ecx
  802367:	89 f3                	mov    %esi,%ebx
  802369:	f7 64 24 0c          	mull   0xc(%esp)
  80236d:	89 c6                	mov    %eax,%esi
  80236f:	89 d7                	mov    %edx,%edi
  802371:	39 d1                	cmp    %edx,%ecx
  802373:	72 06                	jb     80237b <__umoddi3+0xfb>
  802375:	75 10                	jne    802387 <__umoddi3+0x107>
  802377:	39 c3                	cmp    %eax,%ebx
  802379:	73 0c                	jae    802387 <__umoddi3+0x107>
  80237b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80237f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802383:	89 d7                	mov    %edx,%edi
  802385:	89 c6                	mov    %eax,%esi
  802387:	89 ca                	mov    %ecx,%edx
  802389:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80238e:	29 f3                	sub    %esi,%ebx
  802390:	19 fa                	sbb    %edi,%edx
  802392:	89 d0                	mov    %edx,%eax
  802394:	d3 e0                	shl    %cl,%eax
  802396:	89 e9                	mov    %ebp,%ecx
  802398:	d3 eb                	shr    %cl,%ebx
  80239a:	d3 ea                	shr    %cl,%edx
  80239c:	09 d8                	or     %ebx,%eax
  80239e:	83 c4 1c             	add    $0x1c,%esp
  8023a1:	5b                   	pop    %ebx
  8023a2:	5e                   	pop    %esi
  8023a3:	5f                   	pop    %edi
  8023a4:	5d                   	pop    %ebp
  8023a5:	c3                   	ret    
  8023a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023ad:	8d 76 00             	lea    0x0(%esi),%esi
  8023b0:	89 da                	mov    %ebx,%edx
  8023b2:	29 fe                	sub    %edi,%esi
  8023b4:	19 c2                	sbb    %eax,%edx
  8023b6:	89 f1                	mov    %esi,%ecx
  8023b8:	89 c8                	mov    %ecx,%eax
  8023ba:	e9 4b ff ff ff       	jmp    80230a <__umoddi3+0x8a>
