
obj/user/testfile.debug:     file format elf32-i386


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
  80002c:	e8 54 06 00 00       	call   800685 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <xopen>:

#define FVA ((struct Fd*)0xCCCCC000)

static int
xopen(const char *path, int mode)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 0c             	sub    $0xc,%esp
  80003a:	89 d3                	mov    %edx,%ebx
	extern union Fsipc fsipcbuf;
	envid_t fsenv;
	
	strcpy(fsipcbuf.open.req_path, path);
  80003c:	50                   	push   %eax
  80003d:	68 00 50 80 00       	push   $0x805000
  800042:	e8 9a 0e 00 00       	call   800ee1 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800047:	89 1d 00 54 80 00    	mov    %ebx,0x805400

	fsenv = ipc_find_env(ENV_TYPE_FS);
  80004d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800054:	e8 62 15 00 00       	call   8015bb <ipc_find_env>
	ipc_send(fsenv, FSREQ_OPEN, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800059:	6a 07                	push   $0x7
  80005b:	68 00 50 80 00       	push   $0x805000
  800060:	6a 01                	push   $0x1
  800062:	50                   	push   %eax
  800063:	e8 06 15 00 00       	call   80156e <ipc_send>
	return ipc_recv(NULL, FVA, NULL);
  800068:	83 c4 1c             	add    $0x1c,%esp
  80006b:	6a 00                	push   $0x0
  80006d:	68 00 c0 cc cc       	push   $0xccccc000
  800072:	6a 00                	push   $0x0
  800074:	e8 8c 14 00 00       	call   801505 <ipc_recv>
}
  800079:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80007c:	c9                   	leave  
  80007d:	c3                   	ret    

0080007e <umain>:

void
umain(int argc, char **argv)
{
  80007e:	55                   	push   %ebp
  80007f:	89 e5                	mov    %esp,%ebp
  800081:	57                   	push   %edi
  800082:	56                   	push   %esi
  800083:	53                   	push   %ebx
  800084:	81 ec ac 02 00 00    	sub    $0x2ac,%esp
	struct Fd fdcopy;
	struct Stat st;
	char buf[512];

	// We open files manually first, to avoid the FD layer
	if ((r = xopen("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  80008a:	ba 00 00 00 00       	mov    $0x0,%edx
  80008f:	b8 20 25 80 00       	mov    $0x802520,%eax
  800094:	e8 9a ff ff ff       	call   800033 <xopen>
  800099:	83 f8 f5             	cmp    $0xfffffff5,%eax
  80009c:	74 08                	je     8000a6 <umain+0x28>
  80009e:	85 c0                	test   %eax,%eax
  8000a0:	0f 88 e9 03 00 00    	js     80048f <umain+0x411>
		panic("serve_open /not-found: %e", r);
	else if (r >= 0)
  8000a6:	85 c0                	test   %eax,%eax
  8000a8:	0f 89 f3 03 00 00    	jns    8004a1 <umain+0x423>
		panic("serve_open /not-found succeeded!");

	if ((r = xopen("/newmotd", O_RDONLY)) < 0)
  8000ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8000b3:	b8 55 25 80 00       	mov    $0x802555,%eax
  8000b8:	e8 76 ff ff ff       	call   800033 <xopen>
  8000bd:	85 c0                	test   %eax,%eax
  8000bf:	0f 88 f0 03 00 00    	js     8004b5 <umain+0x437>
		panic("serve_open /newmotd: %e", r);
	if (FVA->fd_dev_id != 'f' || FVA->fd_offset != 0 || FVA->fd_omode != O_RDONLY)
  8000c5:	83 3d 00 c0 cc cc 66 	cmpl   $0x66,0xccccc000
  8000cc:	0f 85 f5 03 00 00    	jne    8004c7 <umain+0x449>
  8000d2:	83 3d 04 c0 cc cc 00 	cmpl   $0x0,0xccccc004
  8000d9:	0f 85 e8 03 00 00    	jne    8004c7 <umain+0x449>
  8000df:	83 3d 08 c0 cc cc 00 	cmpl   $0x0,0xccccc008
  8000e6:	0f 85 db 03 00 00    	jne    8004c7 <umain+0x449>
		panic("serve_open did not fill struct Fd correctly\n");
	cprintf("serve_open is good\n");
  8000ec:	83 ec 0c             	sub    $0xc,%esp
  8000ef:	68 76 25 80 00       	push   $0x802576
  8000f4:	e8 c2 06 00 00       	call   8007bb <cprintf>

	if ((r = devfile.dev_stat(FVA, &st)) < 0)
  8000f9:	83 c4 08             	add    $0x8,%esp
  8000fc:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  800102:	50                   	push   %eax
  800103:	68 00 c0 cc cc       	push   $0xccccc000
  800108:	ff 15 1c 30 80 00    	call   *0x80301c
  80010e:	83 c4 10             	add    $0x10,%esp
  800111:	85 c0                	test   %eax,%eax
  800113:	0f 88 c2 03 00 00    	js     8004db <umain+0x45d>
		panic("file_stat: %e", r);
	if (strlen(msg) != st.st_size)
  800119:	83 ec 0c             	sub    $0xc,%esp
  80011c:	ff 35 00 30 80 00    	pushl  0x803000
  800122:	e8 81 0d 00 00       	call   800ea8 <strlen>
  800127:	83 c4 10             	add    $0x10,%esp
  80012a:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  80012d:	0f 85 ba 03 00 00    	jne    8004ed <umain+0x46f>
		panic("file_stat returned size %d wanted %d\n", st.st_size, strlen(msg));
	cprintf("file_stat is good\n");
  800133:	83 ec 0c             	sub    $0xc,%esp
  800136:	68 98 25 80 00       	push   $0x802598
  80013b:	e8 7b 06 00 00       	call   8007bb <cprintf>

	memset(buf, 0, sizeof buf);
  800140:	83 c4 0c             	add    $0xc,%esp
  800143:	68 00 02 00 00       	push   $0x200
  800148:	6a 00                	push   $0x0
  80014a:	8d 9d 4c fd ff ff    	lea    -0x2b4(%ebp),%ebx
  800150:	53                   	push   %ebx
  800151:	e8 d1 0e 00 00       	call   801027 <memset>
	if ((r = devfile.dev_read(FVA, buf, sizeof buf)) < 0)
  800156:	83 c4 0c             	add    $0xc,%esp
  800159:	68 00 02 00 00       	push   $0x200
  80015e:	53                   	push   %ebx
  80015f:	68 00 c0 cc cc       	push   $0xccccc000
  800164:	ff 15 10 30 80 00    	call   *0x803010
  80016a:	83 c4 10             	add    $0x10,%esp
  80016d:	85 c0                	test   %eax,%eax
  80016f:	0f 88 9d 03 00 00    	js     800512 <umain+0x494>
		panic("file_read: %e", r);
	if (strcmp(buf, msg) != 0)
  800175:	83 ec 08             	sub    $0x8,%esp
  800178:	ff 35 00 30 80 00    	pushl  0x803000
  80017e:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  800184:	50                   	push   %eax
  800185:	e8 02 0e 00 00       	call   800f8c <strcmp>
  80018a:	83 c4 10             	add    $0x10,%esp
  80018d:	85 c0                	test   %eax,%eax
  80018f:	0f 85 8f 03 00 00    	jne    800524 <umain+0x4a6>
		panic("file_read returned wrong data");
	cprintf("file_read is good\n");
  800195:	83 ec 0c             	sub    $0xc,%esp
  800198:	68 d7 25 80 00       	push   $0x8025d7
  80019d:	e8 19 06 00 00       	call   8007bb <cprintf>

	if ((r = devfile.dev_close(FVA)) < 0)
  8001a2:	c7 04 24 00 c0 cc cc 	movl   $0xccccc000,(%esp)
  8001a9:	ff 15 18 30 80 00    	call   *0x803018
  8001af:	83 c4 10             	add    $0x10,%esp
  8001b2:	85 c0                	test   %eax,%eax
  8001b4:	0f 88 7e 03 00 00    	js     800538 <umain+0x4ba>
		panic("file_close: %e", r);
	cprintf("file_close is good\n");
  8001ba:	83 ec 0c             	sub    $0xc,%esp
  8001bd:	68 f9 25 80 00       	push   $0x8025f9
  8001c2:	e8 f4 05 00 00       	call   8007bb <cprintf>

	// We're about to unmap the FD, but still need a way to get
	// the stale filenum to serve_read, so we make a local copy.
	// The file server won't think it's stale until we unmap the
	// FD page.
	fdcopy = *FVA;
  8001c7:	a1 00 c0 cc cc       	mov    0xccccc000,%eax
  8001cc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001cf:	a1 04 c0 cc cc       	mov    0xccccc004,%eax
  8001d4:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8001d7:	a1 08 c0 cc cc       	mov    0xccccc008,%eax
  8001dc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001df:	a1 0c c0 cc cc       	mov    0xccccc00c,%eax
  8001e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	sys_page_unmap(0, FVA);
  8001e7:	83 c4 08             	add    $0x8,%esp
  8001ea:	68 00 c0 cc cc       	push   $0xccccc000
  8001ef:	6a 00                	push   $0x0
  8001f1:	e8 62 11 00 00       	call   801358 <sys_page_unmap>

	if ((r = devfile.dev_read(&fdcopy, buf, sizeof buf)) != -E_INVAL)
  8001f6:	83 c4 0c             	add    $0xc,%esp
  8001f9:	68 00 02 00 00       	push   $0x200
  8001fe:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  800204:	50                   	push   %eax
  800205:	8d 45 d8             	lea    -0x28(%ebp),%eax
  800208:	50                   	push   %eax
  800209:	ff 15 10 30 80 00    	call   *0x803010
  80020f:	83 c4 10             	add    $0x10,%esp
  800212:	83 f8 fd             	cmp    $0xfffffffd,%eax
  800215:	0f 85 2f 03 00 00    	jne    80054a <umain+0x4cc>
		panic("serve_read does not handle stale fileids correctly: %e", r);
	cprintf("stale fileid is good\n");
  80021b:	83 ec 0c             	sub    $0xc,%esp
  80021e:	68 0d 26 80 00       	push   $0x80260d
  800223:	e8 93 05 00 00       	call   8007bb <cprintf>

	// Try writing
	if ((r = xopen("/new-file", O_RDWR|O_CREAT)) < 0)
  800228:	ba 02 01 00 00       	mov    $0x102,%edx
  80022d:	b8 23 26 80 00       	mov    $0x802623,%eax
  800232:	e8 fc fd ff ff       	call   800033 <xopen>
  800237:	83 c4 10             	add    $0x10,%esp
  80023a:	85 c0                	test   %eax,%eax
  80023c:	0f 88 1a 03 00 00    	js     80055c <umain+0x4de>
		panic("serve_open /new-file: %e", r);

	if ((r = devfile.dev_write(FVA, msg, strlen(msg))) != strlen(msg))
  800242:	8b 1d 14 30 80 00    	mov    0x803014,%ebx
  800248:	83 ec 0c             	sub    $0xc,%esp
  80024b:	ff 35 00 30 80 00    	pushl  0x803000
  800251:	e8 52 0c 00 00       	call   800ea8 <strlen>
  800256:	83 c4 0c             	add    $0xc,%esp
  800259:	50                   	push   %eax
  80025a:	ff 35 00 30 80 00    	pushl  0x803000
  800260:	68 00 c0 cc cc       	push   $0xccccc000
  800265:	ff d3                	call   *%ebx
  800267:	89 c3                	mov    %eax,%ebx
  800269:	83 c4 04             	add    $0x4,%esp
  80026c:	ff 35 00 30 80 00    	pushl  0x803000
  800272:	e8 31 0c 00 00       	call   800ea8 <strlen>
  800277:	83 c4 10             	add    $0x10,%esp
  80027a:	39 d8                	cmp    %ebx,%eax
  80027c:	0f 85 ec 02 00 00    	jne    80056e <umain+0x4f0>
		panic("file_write: %e", r);
	cprintf("file_write is good\n");
  800282:	83 ec 0c             	sub    $0xc,%esp
  800285:	68 55 26 80 00       	push   $0x802655
  80028a:	e8 2c 05 00 00       	call   8007bb <cprintf>

	FVA->fd_offset = 0;
  80028f:	c7 05 04 c0 cc cc 00 	movl   $0x0,0xccccc004
  800296:	00 00 00 
	memset(buf, 0, sizeof buf);
  800299:	83 c4 0c             	add    $0xc,%esp
  80029c:	68 00 02 00 00       	push   $0x200
  8002a1:	6a 00                	push   $0x0
  8002a3:	8d 9d 4c fd ff ff    	lea    -0x2b4(%ebp),%ebx
  8002a9:	53                   	push   %ebx
  8002aa:	e8 78 0d 00 00       	call   801027 <memset>
	if ((r = devfile.dev_read(FVA, buf, sizeof buf)) < 0)
  8002af:	83 c4 0c             	add    $0xc,%esp
  8002b2:	68 00 02 00 00       	push   $0x200
  8002b7:	53                   	push   %ebx
  8002b8:	68 00 c0 cc cc       	push   $0xccccc000
  8002bd:	ff 15 10 30 80 00    	call   *0x803010
  8002c3:	89 c3                	mov    %eax,%ebx
  8002c5:	83 c4 10             	add    $0x10,%esp
  8002c8:	85 c0                	test   %eax,%eax
  8002ca:	0f 88 b0 02 00 00    	js     800580 <umain+0x502>
		panic("file_read after file_write: %e", r);
	if (r != strlen(msg))
  8002d0:	83 ec 0c             	sub    $0xc,%esp
  8002d3:	ff 35 00 30 80 00    	pushl  0x803000
  8002d9:	e8 ca 0b 00 00       	call   800ea8 <strlen>
  8002de:	83 c4 10             	add    $0x10,%esp
  8002e1:	39 d8                	cmp    %ebx,%eax
  8002e3:	0f 85 a9 02 00 00    	jne    800592 <umain+0x514>
		panic("file_read after file_write returned wrong length: %d", r);
	if (strcmp(buf, msg) != 0)
  8002e9:	83 ec 08             	sub    $0x8,%esp
  8002ec:	ff 35 00 30 80 00    	pushl  0x803000
  8002f2:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  8002f8:	50                   	push   %eax
  8002f9:	e8 8e 0c 00 00       	call   800f8c <strcmp>
  8002fe:	83 c4 10             	add    $0x10,%esp
  800301:	85 c0                	test   %eax,%eax
  800303:	0f 85 9b 02 00 00    	jne    8005a4 <umain+0x526>
		panic("file_read after file_write returned wrong data");
	cprintf("file_read after file_write is good\n");
  800309:	83 ec 0c             	sub    $0xc,%esp
  80030c:	68 1c 28 80 00       	push   $0x80281c
  800311:	e8 a5 04 00 00       	call   8007bb <cprintf>

	// Now we'll try out open
	if ((r = open("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  800316:	83 c4 08             	add    $0x8,%esp
  800319:	6a 00                	push   $0x0
  80031b:	68 20 25 80 00       	push   $0x802520
  800320:	e8 f0 19 00 00       	call   801d15 <open>
  800325:	83 c4 10             	add    $0x10,%esp
  800328:	83 f8 f5             	cmp    $0xfffffff5,%eax
  80032b:	74 08                	je     800335 <umain+0x2b7>
  80032d:	85 c0                	test   %eax,%eax
  80032f:	0f 88 83 02 00 00    	js     8005b8 <umain+0x53a>
		panic("open /not-found: %e", r);
	else if (r >= 0)
  800335:	85 c0                	test   %eax,%eax
  800337:	0f 89 8d 02 00 00    	jns    8005ca <umain+0x54c>
		panic("open /not-found succeeded!");

	if ((r = open("/newmotd", O_RDONLY)) < 0)
  80033d:	83 ec 08             	sub    $0x8,%esp
  800340:	6a 00                	push   $0x0
  800342:	68 55 25 80 00       	push   $0x802555
  800347:	e8 c9 19 00 00       	call   801d15 <open>
  80034c:	83 c4 10             	add    $0x10,%esp
  80034f:	85 c0                	test   %eax,%eax
  800351:	0f 88 87 02 00 00    	js     8005de <umain+0x560>
		panic("open /newmotd: %e", r);
	fd = (struct Fd*) (0xD0000000 + r*PGSIZE);
  800357:	c1 e0 0c             	shl    $0xc,%eax
	if (fd->fd_dev_id != 'f' || fd->fd_offset != 0 || fd->fd_omode != O_RDONLY)
  80035a:	83 b8 00 00 00 d0 66 	cmpl   $0x66,-0x30000000(%eax)
  800361:	0f 85 89 02 00 00    	jne    8005f0 <umain+0x572>
  800367:	83 b8 04 00 00 d0 00 	cmpl   $0x0,-0x2ffffffc(%eax)
  80036e:	0f 85 7c 02 00 00    	jne    8005f0 <umain+0x572>
  800374:	8b 98 08 00 00 d0    	mov    -0x2ffffff8(%eax),%ebx
  80037a:	85 db                	test   %ebx,%ebx
  80037c:	0f 85 6e 02 00 00    	jne    8005f0 <umain+0x572>
		panic("open did not fill struct Fd correctly\n");
	cprintf("open is good\n");
  800382:	83 ec 0c             	sub    $0xc,%esp
  800385:	68 7c 25 80 00       	push   $0x80257c
  80038a:	e8 2c 04 00 00       	call   8007bb <cprintf>

	// Try files with indirect blocks
	if ((f = open("/big", O_WRONLY|O_CREAT)) < 0)
  80038f:	83 c4 08             	add    $0x8,%esp
  800392:	68 01 01 00 00       	push   $0x101
  800397:	68 84 26 80 00       	push   $0x802684
  80039c:	e8 74 19 00 00       	call   801d15 <open>
  8003a1:	89 c7                	mov    %eax,%edi
  8003a3:	83 c4 10             	add    $0x10,%esp
  8003a6:	85 c0                	test   %eax,%eax
  8003a8:	0f 88 56 02 00 00    	js     800604 <umain+0x586>
		panic("creat /big: %e", f);
	memset(buf, 0, sizeof(buf));
  8003ae:	83 ec 04             	sub    $0x4,%esp
  8003b1:	68 00 02 00 00       	push   $0x200
  8003b6:	6a 00                	push   $0x0
  8003b8:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  8003be:	50                   	push   %eax
  8003bf:	e8 63 0c 00 00       	call   801027 <memset>
  8003c4:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  8003c7:	89 de                	mov    %ebx,%esi
		*(int*)buf = i;
  8003c9:	89 b5 4c fd ff ff    	mov    %esi,-0x2b4(%ebp)
		if ((r = write(f, buf, sizeof(buf))) < 0)
  8003cf:	83 ec 04             	sub    $0x4,%esp
  8003d2:	68 00 02 00 00       	push   $0x200
  8003d7:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  8003dd:	50                   	push   %eax
  8003de:	57                   	push   %edi
  8003df:	e8 c6 15 00 00       	call   8019aa <write>
  8003e4:	83 c4 10             	add    $0x10,%esp
  8003e7:	85 c0                	test   %eax,%eax
  8003e9:	0f 88 27 02 00 00    	js     800616 <umain+0x598>
  8003ef:	81 c6 00 02 00 00    	add    $0x200,%esi
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  8003f5:	81 fe 00 e0 01 00    	cmp    $0x1e000,%esi
  8003fb:	75 cc                	jne    8003c9 <umain+0x34b>
			panic("write /big@%d: %e", i, r);
	}
	close(f);
  8003fd:	83 ec 0c             	sub    $0xc,%esp
  800400:	57                   	push   %edi
  800401:	e8 9a 13 00 00       	call   8017a0 <close>

	if ((f = open("/big", O_RDONLY)) < 0)
  800406:	83 c4 08             	add    $0x8,%esp
  800409:	6a 00                	push   $0x0
  80040b:	68 84 26 80 00       	push   $0x802684
  800410:	e8 00 19 00 00       	call   801d15 <open>
  800415:	89 c6                	mov    %eax,%esi
  800417:	83 c4 10             	add    $0x10,%esp
  80041a:	85 c0                	test   %eax,%eax
  80041c:	0f 88 0a 02 00 00    	js     80062c <umain+0x5ae>
		panic("open /big: %e", f);
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
		*(int*)buf = i;
		if ((r = readn(f, buf, sizeof(buf))) < 0)
  800422:	8d bd 4c fd ff ff    	lea    -0x2b4(%ebp),%edi
		*(int*)buf = i;
  800428:	89 9d 4c fd ff ff    	mov    %ebx,-0x2b4(%ebp)
		if ((r = readn(f, buf, sizeof(buf))) < 0)
  80042e:	83 ec 04             	sub    $0x4,%esp
  800431:	68 00 02 00 00       	push   $0x200
  800436:	57                   	push   %edi
  800437:	56                   	push   %esi
  800438:	e8 28 15 00 00       	call   801965 <readn>
  80043d:	83 c4 10             	add    $0x10,%esp
  800440:	85 c0                	test   %eax,%eax
  800442:	0f 88 f6 01 00 00    	js     80063e <umain+0x5c0>
			panic("read /big@%d: %e", i, r);
		if (r != sizeof(buf))
  800448:	3d 00 02 00 00       	cmp    $0x200,%eax
  80044d:	0f 85 01 02 00 00    	jne    800654 <umain+0x5d6>
			panic("read /big from %d returned %d < %d bytes",
			      i, r, sizeof(buf));
		if (*(int*)buf != i)
  800453:	8b 85 4c fd ff ff    	mov    -0x2b4(%ebp),%eax
  800459:	39 d8                	cmp    %ebx,%eax
  80045b:	0f 85 0e 02 00 00    	jne    80066f <umain+0x5f1>
  800461:	81 c3 00 02 00 00    	add    $0x200,%ebx
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  800467:	81 fb 00 e0 01 00    	cmp    $0x1e000,%ebx
  80046d:	75 b9                	jne    800428 <umain+0x3aa>
			panic("read /big from %d returned bad data %d",
			      i, *(int*)buf);
	}
	close(f);
  80046f:	83 ec 0c             	sub    $0xc,%esp
  800472:	56                   	push   %esi
  800473:	e8 28 13 00 00       	call   8017a0 <close>
	cprintf("large file is good\n");
  800478:	c7 04 24 c9 26 80 00 	movl   $0x8026c9,(%esp)
  80047f:	e8 37 03 00 00       	call   8007bb <cprintf>
}
  800484:	83 c4 10             	add    $0x10,%esp
  800487:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80048a:	5b                   	pop    %ebx
  80048b:	5e                   	pop    %esi
  80048c:	5f                   	pop    %edi
  80048d:	5d                   	pop    %ebp
  80048e:	c3                   	ret    
		panic("serve_open /not-found: %e", r);
  80048f:	50                   	push   %eax
  800490:	68 2b 25 80 00       	push   $0x80252b
  800495:	6a 20                	push   $0x20
  800497:	68 45 25 80 00       	push   $0x802545
  80049c:	e8 3f 02 00 00       	call   8006e0 <_panic>
		panic("serve_open /not-found succeeded!");
  8004a1:	83 ec 04             	sub    $0x4,%esp
  8004a4:	68 e0 26 80 00       	push   $0x8026e0
  8004a9:	6a 22                	push   $0x22
  8004ab:	68 45 25 80 00       	push   $0x802545
  8004b0:	e8 2b 02 00 00       	call   8006e0 <_panic>
		panic("serve_open /newmotd: %e", r);
  8004b5:	50                   	push   %eax
  8004b6:	68 5e 25 80 00       	push   $0x80255e
  8004bb:	6a 25                	push   $0x25
  8004bd:	68 45 25 80 00       	push   $0x802545
  8004c2:	e8 19 02 00 00       	call   8006e0 <_panic>
		panic("serve_open did not fill struct Fd correctly\n");
  8004c7:	83 ec 04             	sub    $0x4,%esp
  8004ca:	68 04 27 80 00       	push   $0x802704
  8004cf:	6a 27                	push   $0x27
  8004d1:	68 45 25 80 00       	push   $0x802545
  8004d6:	e8 05 02 00 00       	call   8006e0 <_panic>
		panic("file_stat: %e", r);
  8004db:	50                   	push   %eax
  8004dc:	68 8a 25 80 00       	push   $0x80258a
  8004e1:	6a 2b                	push   $0x2b
  8004e3:	68 45 25 80 00       	push   $0x802545
  8004e8:	e8 f3 01 00 00       	call   8006e0 <_panic>
		panic("file_stat returned size %d wanted %d\n", st.st_size, strlen(msg));
  8004ed:	83 ec 0c             	sub    $0xc,%esp
  8004f0:	ff 35 00 30 80 00    	pushl  0x803000
  8004f6:	e8 ad 09 00 00       	call   800ea8 <strlen>
  8004fb:	89 04 24             	mov    %eax,(%esp)
  8004fe:	ff 75 cc             	pushl  -0x34(%ebp)
  800501:	68 34 27 80 00       	push   $0x802734
  800506:	6a 2d                	push   $0x2d
  800508:	68 45 25 80 00       	push   $0x802545
  80050d:	e8 ce 01 00 00       	call   8006e0 <_panic>
		panic("file_read: %e", r);
  800512:	50                   	push   %eax
  800513:	68 ab 25 80 00       	push   $0x8025ab
  800518:	6a 32                	push   $0x32
  80051a:	68 45 25 80 00       	push   $0x802545
  80051f:	e8 bc 01 00 00       	call   8006e0 <_panic>
		panic("file_read returned wrong data");
  800524:	83 ec 04             	sub    $0x4,%esp
  800527:	68 b9 25 80 00       	push   $0x8025b9
  80052c:	6a 34                	push   $0x34
  80052e:	68 45 25 80 00       	push   $0x802545
  800533:	e8 a8 01 00 00       	call   8006e0 <_panic>
		panic("file_close: %e", r);
  800538:	50                   	push   %eax
  800539:	68 ea 25 80 00       	push   $0x8025ea
  80053e:	6a 38                	push   $0x38
  800540:	68 45 25 80 00       	push   $0x802545
  800545:	e8 96 01 00 00       	call   8006e0 <_panic>
		panic("serve_read does not handle stale fileids correctly: %e", r);
  80054a:	50                   	push   %eax
  80054b:	68 5c 27 80 00       	push   $0x80275c
  800550:	6a 43                	push   $0x43
  800552:	68 45 25 80 00       	push   $0x802545
  800557:	e8 84 01 00 00       	call   8006e0 <_panic>
		panic("serve_open /new-file: %e", r);
  80055c:	50                   	push   %eax
  80055d:	68 2d 26 80 00       	push   $0x80262d
  800562:	6a 48                	push   $0x48
  800564:	68 45 25 80 00       	push   $0x802545
  800569:	e8 72 01 00 00       	call   8006e0 <_panic>
		panic("file_write: %e", r);
  80056e:	53                   	push   %ebx
  80056f:	68 46 26 80 00       	push   $0x802646
  800574:	6a 4b                	push   $0x4b
  800576:	68 45 25 80 00       	push   $0x802545
  80057b:	e8 60 01 00 00       	call   8006e0 <_panic>
		panic("file_read after file_write: %e", r);
  800580:	50                   	push   %eax
  800581:	68 94 27 80 00       	push   $0x802794
  800586:	6a 51                	push   $0x51
  800588:	68 45 25 80 00       	push   $0x802545
  80058d:	e8 4e 01 00 00       	call   8006e0 <_panic>
		panic("file_read after file_write returned wrong length: %d", r);
  800592:	53                   	push   %ebx
  800593:	68 b4 27 80 00       	push   $0x8027b4
  800598:	6a 53                	push   $0x53
  80059a:	68 45 25 80 00       	push   $0x802545
  80059f:	e8 3c 01 00 00       	call   8006e0 <_panic>
		panic("file_read after file_write returned wrong data");
  8005a4:	83 ec 04             	sub    $0x4,%esp
  8005a7:	68 ec 27 80 00       	push   $0x8027ec
  8005ac:	6a 55                	push   $0x55
  8005ae:	68 45 25 80 00       	push   $0x802545
  8005b3:	e8 28 01 00 00       	call   8006e0 <_panic>
		panic("open /not-found: %e", r);
  8005b8:	50                   	push   %eax
  8005b9:	68 31 25 80 00       	push   $0x802531
  8005be:	6a 5a                	push   $0x5a
  8005c0:	68 45 25 80 00       	push   $0x802545
  8005c5:	e8 16 01 00 00       	call   8006e0 <_panic>
		panic("open /not-found succeeded!");
  8005ca:	83 ec 04             	sub    $0x4,%esp
  8005cd:	68 69 26 80 00       	push   $0x802669
  8005d2:	6a 5c                	push   $0x5c
  8005d4:	68 45 25 80 00       	push   $0x802545
  8005d9:	e8 02 01 00 00       	call   8006e0 <_panic>
		panic("open /newmotd: %e", r);
  8005de:	50                   	push   %eax
  8005df:	68 64 25 80 00       	push   $0x802564
  8005e4:	6a 5f                	push   $0x5f
  8005e6:	68 45 25 80 00       	push   $0x802545
  8005eb:	e8 f0 00 00 00       	call   8006e0 <_panic>
		panic("open did not fill struct Fd correctly\n");
  8005f0:	83 ec 04             	sub    $0x4,%esp
  8005f3:	68 40 28 80 00       	push   $0x802840
  8005f8:	6a 62                	push   $0x62
  8005fa:	68 45 25 80 00       	push   $0x802545
  8005ff:	e8 dc 00 00 00       	call   8006e0 <_panic>
		panic("creat /big: %e", f);
  800604:	50                   	push   %eax
  800605:	68 89 26 80 00       	push   $0x802689
  80060a:	6a 67                	push   $0x67
  80060c:	68 45 25 80 00       	push   $0x802545
  800611:	e8 ca 00 00 00       	call   8006e0 <_panic>
			panic("write /big@%d: %e", i, r);
  800616:	83 ec 0c             	sub    $0xc,%esp
  800619:	50                   	push   %eax
  80061a:	56                   	push   %esi
  80061b:	68 98 26 80 00       	push   $0x802698
  800620:	6a 6c                	push   $0x6c
  800622:	68 45 25 80 00       	push   $0x802545
  800627:	e8 b4 00 00 00       	call   8006e0 <_panic>
		panic("open /big: %e", f);
  80062c:	50                   	push   %eax
  80062d:	68 aa 26 80 00       	push   $0x8026aa
  800632:	6a 71                	push   $0x71
  800634:	68 45 25 80 00       	push   $0x802545
  800639:	e8 a2 00 00 00       	call   8006e0 <_panic>
			panic("read /big@%d: %e", i, r);
  80063e:	83 ec 0c             	sub    $0xc,%esp
  800641:	50                   	push   %eax
  800642:	53                   	push   %ebx
  800643:	68 b8 26 80 00       	push   $0x8026b8
  800648:	6a 75                	push   $0x75
  80064a:	68 45 25 80 00       	push   $0x802545
  80064f:	e8 8c 00 00 00       	call   8006e0 <_panic>
			panic("read /big from %d returned %d < %d bytes",
  800654:	83 ec 08             	sub    $0x8,%esp
  800657:	68 00 02 00 00       	push   $0x200
  80065c:	50                   	push   %eax
  80065d:	53                   	push   %ebx
  80065e:	68 68 28 80 00       	push   $0x802868
  800663:	6a 78                	push   $0x78
  800665:	68 45 25 80 00       	push   $0x802545
  80066a:	e8 71 00 00 00       	call   8006e0 <_panic>
			panic("read /big from %d returned bad data %d",
  80066f:	83 ec 0c             	sub    $0xc,%esp
  800672:	50                   	push   %eax
  800673:	53                   	push   %ebx
  800674:	68 94 28 80 00       	push   $0x802894
  800679:	6a 7b                	push   $0x7b
  80067b:	68 45 25 80 00       	push   $0x802545
  800680:	e8 5b 00 00 00       	call   8006e0 <_panic>

00800685 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800685:	55                   	push   %ebp
  800686:	89 e5                	mov    %esp,%ebp
  800688:	56                   	push   %esi
  800689:	53                   	push   %ebx
  80068a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80068d:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	// thisenv = 0;
	thisenv = &(envs[ENVX(sys_getenvid())]);
  800690:	e8 00 0c 00 00       	call   801295 <sys_getenvid>
  800695:	25 ff 03 00 00       	and    $0x3ff,%eax
  80069a:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8006a0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8006a5:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006aa:	85 db                	test   %ebx,%ebx
  8006ac:	7e 07                	jle    8006b5 <libmain+0x30>
		binaryname = argv[0];
  8006ae:	8b 06                	mov    (%esi),%eax
  8006b0:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	umain(argc, argv);
  8006b5:	83 ec 08             	sub    $0x8,%esp
  8006b8:	56                   	push   %esi
  8006b9:	53                   	push   %ebx
  8006ba:	e8 bf f9 ff ff       	call   80007e <umain>

	// exit gracefully
	exit();
  8006bf:	e8 0a 00 00 00       	call   8006ce <exit>
}
  8006c4:	83 c4 10             	add    $0x10,%esp
  8006c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8006ca:	5b                   	pop    %ebx
  8006cb:	5e                   	pop    %esi
  8006cc:	5d                   	pop    %ebp
  8006cd:	c3                   	ret    

008006ce <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8006ce:	55                   	push   %ebp
  8006cf:	89 e5                	mov    %esp,%ebp
  8006d1:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  8006d4:	6a 00                	push   $0x0
  8006d6:	e8 79 0b 00 00       	call   801254 <sys_env_destroy>
}
  8006db:	83 c4 10             	add    $0x10,%esp
  8006de:	c9                   	leave  
  8006df:	c3                   	ret    

008006e0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8006e0:	55                   	push   %ebp
  8006e1:	89 e5                	mov    %esp,%ebp
  8006e3:	56                   	push   %esi
  8006e4:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8006e5:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8006e8:	8b 35 04 30 80 00    	mov    0x803004,%esi
  8006ee:	e8 a2 0b 00 00       	call   801295 <sys_getenvid>
  8006f3:	83 ec 0c             	sub    $0xc,%esp
  8006f6:	ff 75 0c             	pushl  0xc(%ebp)
  8006f9:	ff 75 08             	pushl  0x8(%ebp)
  8006fc:	56                   	push   %esi
  8006fd:	50                   	push   %eax
  8006fe:	68 ec 28 80 00       	push   $0x8028ec
  800703:	e8 b3 00 00 00       	call   8007bb <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800708:	83 c4 18             	add    $0x18,%esp
  80070b:	53                   	push   %ebx
  80070c:	ff 75 10             	pushl  0x10(%ebp)
  80070f:	e8 56 00 00 00       	call   80076a <vcprintf>
	cprintf("\n");
  800714:	c7 04 24 c1 2d 80 00 	movl   $0x802dc1,(%esp)
  80071b:	e8 9b 00 00 00       	call   8007bb <cprintf>
  800720:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800723:	cc                   	int3   
  800724:	eb fd                	jmp    800723 <_panic+0x43>

00800726 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800726:	55                   	push   %ebp
  800727:	89 e5                	mov    %esp,%ebp
  800729:	53                   	push   %ebx
  80072a:	83 ec 04             	sub    $0x4,%esp
  80072d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800730:	8b 13                	mov    (%ebx),%edx
  800732:	8d 42 01             	lea    0x1(%edx),%eax
  800735:	89 03                	mov    %eax,(%ebx)
  800737:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80073a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80073e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800743:	74 09                	je     80074e <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800745:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800749:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80074c:	c9                   	leave  
  80074d:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80074e:	83 ec 08             	sub    $0x8,%esp
  800751:	68 ff 00 00 00       	push   $0xff
  800756:	8d 43 08             	lea    0x8(%ebx),%eax
  800759:	50                   	push   %eax
  80075a:	e8 b8 0a 00 00       	call   801217 <sys_cputs>
		b->idx = 0;
  80075f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800765:	83 c4 10             	add    $0x10,%esp
  800768:	eb db                	jmp    800745 <putch+0x1f>

0080076a <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80076a:	55                   	push   %ebp
  80076b:	89 e5                	mov    %esp,%ebp
  80076d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800773:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80077a:	00 00 00 
	b.cnt = 0;
  80077d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800784:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800787:	ff 75 0c             	pushl  0xc(%ebp)
  80078a:	ff 75 08             	pushl  0x8(%ebp)
  80078d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800793:	50                   	push   %eax
  800794:	68 26 07 80 00       	push   $0x800726
  800799:	e8 4a 01 00 00       	call   8008e8 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80079e:	83 c4 08             	add    $0x8,%esp
  8007a1:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8007a7:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8007ad:	50                   	push   %eax
  8007ae:	e8 64 0a 00 00       	call   801217 <sys_cputs>

	return b.cnt;
}
  8007b3:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8007b9:	c9                   	leave  
  8007ba:	c3                   	ret    

008007bb <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8007bb:	55                   	push   %ebp
  8007bc:	89 e5                	mov    %esp,%ebp
  8007be:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8007c1:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8007c4:	50                   	push   %eax
  8007c5:	ff 75 08             	pushl  0x8(%ebp)
  8007c8:	e8 9d ff ff ff       	call   80076a <vcprintf>
	va_end(ap);

	return cnt;
}
  8007cd:	c9                   	leave  
  8007ce:	c3                   	ret    

008007cf <printnum>:


static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007cf:	55                   	push   %ebp
  8007d0:	89 e5                	mov    %esp,%ebp
  8007d2:	57                   	push   %edi
  8007d3:	56                   	push   %esi
  8007d4:	53                   	push   %ebx
  8007d5:	83 ec 1c             	sub    $0x1c,%esp
  8007d8:	89 c6                	mov    %eax,%esi
  8007da:	89 d7                	mov    %edx,%edi
  8007dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007e2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8007e5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8007e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8007eb:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	// to support '-'
	if(padc == '-'){
  8007ee:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8007f2:	74 2c                	je     800820 <printnum+0x51>
		while (--width > 0)
			putch(' ', putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007f4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007f7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8007fe:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800801:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800804:	39 c2                	cmp    %eax,%edx
  800806:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800809:	73 43                	jae    80084e <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80080b:	83 eb 01             	sub    $0x1,%ebx
  80080e:	85 db                	test   %ebx,%ebx
  800810:	7e 6c                	jle    80087e <printnum+0xaf>
			putch(padc, putdat);
  800812:	83 ec 08             	sub    $0x8,%esp
  800815:	57                   	push   %edi
  800816:	ff 75 18             	pushl  0x18(%ebp)
  800819:	ff d6                	call   *%esi
  80081b:	83 c4 10             	add    $0x10,%esp
  80081e:	eb eb                	jmp    80080b <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800820:	83 ec 0c             	sub    $0xc,%esp
  800823:	6a 20                	push   $0x20
  800825:	6a 00                	push   $0x0
  800827:	50                   	push   %eax
  800828:	ff 75 e4             	pushl  -0x1c(%ebp)
  80082b:	ff 75 e0             	pushl  -0x20(%ebp)
  80082e:	89 fa                	mov    %edi,%edx
  800830:	89 f0                	mov    %esi,%eax
  800832:	e8 98 ff ff ff       	call   8007cf <printnum>
		while (--width > 0)
  800837:	83 c4 20             	add    $0x20,%esp
  80083a:	83 eb 01             	sub    $0x1,%ebx
  80083d:	85 db                	test   %ebx,%ebx
  80083f:	7e 65                	jle    8008a6 <printnum+0xd7>
			putch(' ', putdat);
  800841:	83 ec 08             	sub    $0x8,%esp
  800844:	57                   	push   %edi
  800845:	6a 20                	push   $0x20
  800847:	ff d6                	call   *%esi
  800849:	83 c4 10             	add    $0x10,%esp
  80084c:	eb ec                	jmp    80083a <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80084e:	83 ec 0c             	sub    $0xc,%esp
  800851:	ff 75 18             	pushl  0x18(%ebp)
  800854:	83 eb 01             	sub    $0x1,%ebx
  800857:	53                   	push   %ebx
  800858:	50                   	push   %eax
  800859:	83 ec 08             	sub    $0x8,%esp
  80085c:	ff 75 dc             	pushl  -0x24(%ebp)
  80085f:	ff 75 d8             	pushl  -0x28(%ebp)
  800862:	ff 75 e4             	pushl  -0x1c(%ebp)
  800865:	ff 75 e0             	pushl  -0x20(%ebp)
  800868:	e8 53 1a 00 00       	call   8022c0 <__udivdi3>
  80086d:	83 c4 18             	add    $0x18,%esp
  800870:	52                   	push   %edx
  800871:	50                   	push   %eax
  800872:	89 fa                	mov    %edi,%edx
  800874:	89 f0                	mov    %esi,%eax
  800876:	e8 54 ff ff ff       	call   8007cf <printnum>
  80087b:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80087e:	83 ec 08             	sub    $0x8,%esp
  800881:	57                   	push   %edi
  800882:	83 ec 04             	sub    $0x4,%esp
  800885:	ff 75 dc             	pushl  -0x24(%ebp)
  800888:	ff 75 d8             	pushl  -0x28(%ebp)
  80088b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80088e:	ff 75 e0             	pushl  -0x20(%ebp)
  800891:	e8 3a 1b 00 00       	call   8023d0 <__umoddi3>
  800896:	83 c4 14             	add    $0x14,%esp
  800899:	0f be 80 0f 29 80 00 	movsbl 0x80290f(%eax),%eax
  8008a0:	50                   	push   %eax
  8008a1:	ff d6                	call   *%esi
  8008a3:	83 c4 10             	add    $0x10,%esp
}
  8008a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008a9:	5b                   	pop    %ebx
  8008aa:	5e                   	pop    %esi
  8008ab:	5f                   	pop    %edi
  8008ac:	5d                   	pop    %ebp
  8008ad:	c3                   	ret    

008008ae <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8008ae:	55                   	push   %ebp
  8008af:	89 e5                	mov    %esp,%ebp
  8008b1:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8008b4:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8008b8:	8b 10                	mov    (%eax),%edx
  8008ba:	3b 50 04             	cmp    0x4(%eax),%edx
  8008bd:	73 0a                	jae    8008c9 <sprintputch+0x1b>
		*b->buf++ = ch;
  8008bf:	8d 4a 01             	lea    0x1(%edx),%ecx
  8008c2:	89 08                	mov    %ecx,(%eax)
  8008c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c7:	88 02                	mov    %al,(%edx)
}
  8008c9:	5d                   	pop    %ebp
  8008ca:	c3                   	ret    

008008cb <printfmt>:
{
  8008cb:	55                   	push   %ebp
  8008cc:	89 e5                	mov    %esp,%ebp
  8008ce:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8008d1:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8008d4:	50                   	push   %eax
  8008d5:	ff 75 10             	pushl  0x10(%ebp)
  8008d8:	ff 75 0c             	pushl  0xc(%ebp)
  8008db:	ff 75 08             	pushl  0x8(%ebp)
  8008de:	e8 05 00 00 00       	call   8008e8 <vprintfmt>
}
  8008e3:	83 c4 10             	add    $0x10,%esp
  8008e6:	c9                   	leave  
  8008e7:	c3                   	ret    

008008e8 <vprintfmt>:
{
  8008e8:	55                   	push   %ebp
  8008e9:	89 e5                	mov    %esp,%ebp
  8008eb:	57                   	push   %edi
  8008ec:	56                   	push   %esi
  8008ed:	53                   	push   %ebx
  8008ee:	83 ec 3c             	sub    $0x3c,%esp
  8008f1:	8b 75 08             	mov    0x8(%ebp),%esi
  8008f4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8008f7:	8b 7d 10             	mov    0x10(%ebp),%edi
  8008fa:	e9 1e 04 00 00       	jmp    800d1d <vprintfmt+0x435>
		posflag = 0;
  8008ff:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
		padc = ' ';
  800906:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80090a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800911:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800918:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80091f:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  800926:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80092b:	8d 47 01             	lea    0x1(%edi),%eax
  80092e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800931:	0f b6 17             	movzbl (%edi),%edx
  800934:	8d 42 dd             	lea    -0x23(%edx),%eax
  800937:	3c 55                	cmp    $0x55,%al
  800939:	0f 87 d9 04 00 00    	ja     800e18 <vprintfmt+0x530>
  80093f:	0f b6 c0             	movzbl %al,%eax
  800942:	ff 24 85 e0 2a 80 00 	jmp    *0x802ae0(,%eax,4)
  800949:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80094c:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800950:	eb d9                	jmp    80092b <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800952:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posflag = 1;
  800955:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  80095c:	eb cd                	jmp    80092b <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80095e:	0f b6 d2             	movzbl %dl,%edx
  800961:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800964:	b8 00 00 00 00       	mov    $0x0,%eax
  800969:	89 75 08             	mov    %esi,0x8(%ebp)
  80096c:	eb 0c                	jmp    80097a <vprintfmt+0x92>
		switch (ch = *(unsigned char *) fmt++) {
  80096e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800971:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  800975:	eb b4                	jmp    80092b <vprintfmt+0x43>
			for (precision = 0; ; ++fmt) {
  800977:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80097a:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80097d:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800981:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800984:	8d 72 d0             	lea    -0x30(%edx),%esi
  800987:	83 fe 09             	cmp    $0x9,%esi
  80098a:	76 eb                	jbe    800977 <vprintfmt+0x8f>
  80098c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80098f:	8b 75 08             	mov    0x8(%ebp),%esi
  800992:	eb 14                	jmp    8009a8 <vprintfmt+0xc0>
			precision = va_arg(ap, int);
  800994:	8b 45 14             	mov    0x14(%ebp),%eax
  800997:	8b 00                	mov    (%eax),%eax
  800999:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80099c:	8b 45 14             	mov    0x14(%ebp),%eax
  80099f:	8d 40 04             	lea    0x4(%eax),%eax
  8009a2:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8009a5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8009a8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009ac:	0f 89 79 ff ff ff    	jns    80092b <vprintfmt+0x43>
				width = precision, precision = -1;
  8009b2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009b5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8009b8:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8009bf:	e9 67 ff ff ff       	jmp    80092b <vprintfmt+0x43>
  8009c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009c7:	85 c0                	test   %eax,%eax
  8009c9:	0f 48 c1             	cmovs  %ecx,%eax
  8009cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8009cf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8009d2:	e9 54 ff ff ff       	jmp    80092b <vprintfmt+0x43>
  8009d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8009da:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8009e1:	e9 45 ff ff ff       	jmp    80092b <vprintfmt+0x43>
			lflag++;
  8009e6:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8009ea:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8009ed:	e9 39 ff ff ff       	jmp    80092b <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8009f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f5:	8d 78 04             	lea    0x4(%eax),%edi
  8009f8:	83 ec 08             	sub    $0x8,%esp
  8009fb:	53                   	push   %ebx
  8009fc:	ff 30                	pushl  (%eax)
  8009fe:	ff d6                	call   *%esi
			break;
  800a00:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800a03:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800a06:	e9 0f 03 00 00       	jmp    800d1a <vprintfmt+0x432>
			err = va_arg(ap, int);
  800a0b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0e:	8d 78 04             	lea    0x4(%eax),%edi
  800a11:	8b 00                	mov    (%eax),%eax
  800a13:	99                   	cltd   
  800a14:	31 d0                	xor    %edx,%eax
  800a16:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a18:	83 f8 0f             	cmp    $0xf,%eax
  800a1b:	7f 23                	jg     800a40 <vprintfmt+0x158>
  800a1d:	8b 14 85 40 2c 80 00 	mov    0x802c40(,%eax,4),%edx
  800a24:	85 d2                	test   %edx,%edx
  800a26:	74 18                	je     800a40 <vprintfmt+0x158>
				printfmt(putch, putdat, "%s", p);
  800a28:	52                   	push   %edx
  800a29:	68 9a 2d 80 00       	push   $0x802d9a
  800a2e:	53                   	push   %ebx
  800a2f:	56                   	push   %esi
  800a30:	e8 96 fe ff ff       	call   8008cb <printfmt>
  800a35:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800a38:	89 7d 14             	mov    %edi,0x14(%ebp)
  800a3b:	e9 da 02 00 00       	jmp    800d1a <vprintfmt+0x432>
				printfmt(putch, putdat, "error %d", err);
  800a40:	50                   	push   %eax
  800a41:	68 27 29 80 00       	push   $0x802927
  800a46:	53                   	push   %ebx
  800a47:	56                   	push   %esi
  800a48:	e8 7e fe ff ff       	call   8008cb <printfmt>
  800a4d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800a50:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800a53:	e9 c2 02 00 00       	jmp    800d1a <vprintfmt+0x432>
			if ((p = va_arg(ap, char *)) == NULL)
  800a58:	8b 45 14             	mov    0x14(%ebp),%eax
  800a5b:	83 c0 04             	add    $0x4,%eax
  800a5e:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800a61:	8b 45 14             	mov    0x14(%ebp),%eax
  800a64:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800a66:	85 c9                	test   %ecx,%ecx
  800a68:	b8 20 29 80 00       	mov    $0x802920,%eax
  800a6d:	0f 45 c1             	cmovne %ecx,%eax
  800a70:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800a73:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a77:	7e 06                	jle    800a7f <vprintfmt+0x197>
  800a79:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800a7d:	75 0d                	jne    800a8c <vprintfmt+0x1a4>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a7f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800a82:	89 c7                	mov    %eax,%edi
  800a84:	03 45 e0             	add    -0x20(%ebp),%eax
  800a87:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800a8a:	eb 53                	jmp    800adf <vprintfmt+0x1f7>
  800a8c:	83 ec 08             	sub    $0x8,%esp
  800a8f:	ff 75 d8             	pushl  -0x28(%ebp)
  800a92:	50                   	push   %eax
  800a93:	e8 28 04 00 00       	call   800ec0 <strnlen>
  800a98:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800a9b:	29 c1                	sub    %eax,%ecx
  800a9d:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  800aa0:	83 c4 10             	add    $0x10,%esp
  800aa3:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800aa5:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800aa9:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800aac:	eb 0f                	jmp    800abd <vprintfmt+0x1d5>
					putch(padc, putdat);
  800aae:	83 ec 08             	sub    $0x8,%esp
  800ab1:	53                   	push   %ebx
  800ab2:	ff 75 e0             	pushl  -0x20(%ebp)
  800ab5:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800ab7:	83 ef 01             	sub    $0x1,%edi
  800aba:	83 c4 10             	add    $0x10,%esp
  800abd:	85 ff                	test   %edi,%edi
  800abf:	7f ed                	jg     800aae <vprintfmt+0x1c6>
  800ac1:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  800ac4:	85 c9                	test   %ecx,%ecx
  800ac6:	b8 00 00 00 00       	mov    $0x0,%eax
  800acb:	0f 49 c1             	cmovns %ecx,%eax
  800ace:	29 c1                	sub    %eax,%ecx
  800ad0:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800ad3:	eb aa                	jmp    800a7f <vprintfmt+0x197>
					putch(ch, putdat);
  800ad5:	83 ec 08             	sub    $0x8,%esp
  800ad8:	53                   	push   %ebx
  800ad9:	52                   	push   %edx
  800ada:	ff d6                	call   *%esi
  800adc:	83 c4 10             	add    $0x10,%esp
  800adf:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800ae2:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ae4:	83 c7 01             	add    $0x1,%edi
  800ae7:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800aeb:	0f be d0             	movsbl %al,%edx
  800aee:	85 d2                	test   %edx,%edx
  800af0:	74 4b                	je     800b3d <vprintfmt+0x255>
  800af2:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800af6:	78 06                	js     800afe <vprintfmt+0x216>
  800af8:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800afc:	78 1e                	js     800b1c <vprintfmt+0x234>
				if (altflag && (ch < ' ' || ch > '~'))
  800afe:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800b02:	74 d1                	je     800ad5 <vprintfmt+0x1ed>
  800b04:	0f be c0             	movsbl %al,%eax
  800b07:	83 e8 20             	sub    $0x20,%eax
  800b0a:	83 f8 5e             	cmp    $0x5e,%eax
  800b0d:	76 c6                	jbe    800ad5 <vprintfmt+0x1ed>
					putch('?', putdat);
  800b0f:	83 ec 08             	sub    $0x8,%esp
  800b12:	53                   	push   %ebx
  800b13:	6a 3f                	push   $0x3f
  800b15:	ff d6                	call   *%esi
  800b17:	83 c4 10             	add    $0x10,%esp
  800b1a:	eb c3                	jmp    800adf <vprintfmt+0x1f7>
  800b1c:	89 cf                	mov    %ecx,%edi
  800b1e:	eb 0e                	jmp    800b2e <vprintfmt+0x246>
				putch(' ', putdat);
  800b20:	83 ec 08             	sub    $0x8,%esp
  800b23:	53                   	push   %ebx
  800b24:	6a 20                	push   $0x20
  800b26:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800b28:	83 ef 01             	sub    $0x1,%edi
  800b2b:	83 c4 10             	add    $0x10,%esp
  800b2e:	85 ff                	test   %edi,%edi
  800b30:	7f ee                	jg     800b20 <vprintfmt+0x238>
			if ((p = va_arg(ap, char *)) == NULL)
  800b32:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800b35:	89 45 14             	mov    %eax,0x14(%ebp)
  800b38:	e9 dd 01 00 00       	jmp    800d1a <vprintfmt+0x432>
  800b3d:	89 cf                	mov    %ecx,%edi
  800b3f:	eb ed                	jmp    800b2e <vprintfmt+0x246>
	if (lflag >= 2)
  800b41:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800b45:	7f 21                	jg     800b68 <vprintfmt+0x280>
	else if (lflag)
  800b47:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800b4b:	74 6a                	je     800bb7 <vprintfmt+0x2cf>
		return va_arg(*ap, long);
  800b4d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b50:	8b 00                	mov    (%eax),%eax
  800b52:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b55:	89 c1                	mov    %eax,%ecx
  800b57:	c1 f9 1f             	sar    $0x1f,%ecx
  800b5a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800b5d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b60:	8d 40 04             	lea    0x4(%eax),%eax
  800b63:	89 45 14             	mov    %eax,0x14(%ebp)
  800b66:	eb 17                	jmp    800b7f <vprintfmt+0x297>
		return va_arg(*ap, long long);
  800b68:	8b 45 14             	mov    0x14(%ebp),%eax
  800b6b:	8b 50 04             	mov    0x4(%eax),%edx
  800b6e:	8b 00                	mov    (%eax),%eax
  800b70:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b73:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b76:	8b 45 14             	mov    0x14(%ebp),%eax
  800b79:	8d 40 08             	lea    0x8(%eax),%eax
  800b7c:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800b7f:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  800b82:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800b87:	85 d2                	test   %edx,%edx
  800b89:	0f 89 5c 01 00 00    	jns    800ceb <vprintfmt+0x403>
				putch('-', putdat);
  800b8f:	83 ec 08             	sub    $0x8,%esp
  800b92:	53                   	push   %ebx
  800b93:	6a 2d                	push   $0x2d
  800b95:	ff d6                	call   *%esi
				num = -(long long) num;
  800b97:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b9a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800b9d:	f7 d8                	neg    %eax
  800b9f:	83 d2 00             	adc    $0x0,%edx
  800ba2:	f7 da                	neg    %edx
  800ba4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ba7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800baa:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800bad:	bf 0a 00 00 00       	mov    $0xa,%edi
  800bb2:	e9 45 01 00 00       	jmp    800cfc <vprintfmt+0x414>
		return va_arg(*ap, int);
  800bb7:	8b 45 14             	mov    0x14(%ebp),%eax
  800bba:	8b 00                	mov    (%eax),%eax
  800bbc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800bbf:	89 c1                	mov    %eax,%ecx
  800bc1:	c1 f9 1f             	sar    $0x1f,%ecx
  800bc4:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800bc7:	8b 45 14             	mov    0x14(%ebp),%eax
  800bca:	8d 40 04             	lea    0x4(%eax),%eax
  800bcd:	89 45 14             	mov    %eax,0x14(%ebp)
  800bd0:	eb ad                	jmp    800b7f <vprintfmt+0x297>
	if (lflag >= 2)
  800bd2:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800bd6:	7f 29                	jg     800c01 <vprintfmt+0x319>
	else if (lflag)
  800bd8:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800bdc:	74 44                	je     800c22 <vprintfmt+0x33a>
		return va_arg(*ap, unsigned long);
  800bde:	8b 45 14             	mov    0x14(%ebp),%eax
  800be1:	8b 00                	mov    (%eax),%eax
  800be3:	ba 00 00 00 00       	mov    $0x0,%edx
  800be8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800beb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800bee:	8b 45 14             	mov    0x14(%ebp),%eax
  800bf1:	8d 40 04             	lea    0x4(%eax),%eax
  800bf4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800bf7:	bf 0a 00 00 00       	mov    $0xa,%edi
  800bfc:	e9 ea 00 00 00       	jmp    800ceb <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  800c01:	8b 45 14             	mov    0x14(%ebp),%eax
  800c04:	8b 50 04             	mov    0x4(%eax),%edx
  800c07:	8b 00                	mov    (%eax),%eax
  800c09:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c0c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c0f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c12:	8d 40 08             	lea    0x8(%eax),%eax
  800c15:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800c18:	bf 0a 00 00 00       	mov    $0xa,%edi
  800c1d:	e9 c9 00 00 00       	jmp    800ceb <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  800c22:	8b 45 14             	mov    0x14(%ebp),%eax
  800c25:	8b 00                	mov    (%eax),%eax
  800c27:	ba 00 00 00 00       	mov    $0x0,%edx
  800c2c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c2f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c32:	8b 45 14             	mov    0x14(%ebp),%eax
  800c35:	8d 40 04             	lea    0x4(%eax),%eax
  800c38:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800c3b:	bf 0a 00 00 00       	mov    $0xa,%edi
  800c40:	e9 a6 00 00 00       	jmp    800ceb <vprintfmt+0x403>
			putch('0', putdat);
  800c45:	83 ec 08             	sub    $0x8,%esp
  800c48:	53                   	push   %ebx
  800c49:	6a 30                	push   $0x30
  800c4b:	ff d6                	call   *%esi
	if (lflag >= 2)
  800c4d:	83 c4 10             	add    $0x10,%esp
  800c50:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800c54:	7f 26                	jg     800c7c <vprintfmt+0x394>
	else if (lflag)
  800c56:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800c5a:	74 3e                	je     800c9a <vprintfmt+0x3b2>
		return va_arg(*ap, unsigned long);
  800c5c:	8b 45 14             	mov    0x14(%ebp),%eax
  800c5f:	8b 00                	mov    (%eax),%eax
  800c61:	ba 00 00 00 00       	mov    $0x0,%edx
  800c66:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c69:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c6c:	8b 45 14             	mov    0x14(%ebp),%eax
  800c6f:	8d 40 04             	lea    0x4(%eax),%eax
  800c72:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800c75:	bf 08 00 00 00       	mov    $0x8,%edi
  800c7a:	eb 6f                	jmp    800ceb <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  800c7c:	8b 45 14             	mov    0x14(%ebp),%eax
  800c7f:	8b 50 04             	mov    0x4(%eax),%edx
  800c82:	8b 00                	mov    (%eax),%eax
  800c84:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c87:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c8a:	8b 45 14             	mov    0x14(%ebp),%eax
  800c8d:	8d 40 08             	lea    0x8(%eax),%eax
  800c90:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800c93:	bf 08 00 00 00       	mov    $0x8,%edi
  800c98:	eb 51                	jmp    800ceb <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  800c9a:	8b 45 14             	mov    0x14(%ebp),%eax
  800c9d:	8b 00                	mov    (%eax),%eax
  800c9f:	ba 00 00 00 00       	mov    $0x0,%edx
  800ca4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ca7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800caa:	8b 45 14             	mov    0x14(%ebp),%eax
  800cad:	8d 40 04             	lea    0x4(%eax),%eax
  800cb0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800cb3:	bf 08 00 00 00       	mov    $0x8,%edi
  800cb8:	eb 31                	jmp    800ceb <vprintfmt+0x403>
			putch('0', putdat);
  800cba:	83 ec 08             	sub    $0x8,%esp
  800cbd:	53                   	push   %ebx
  800cbe:	6a 30                	push   $0x30
  800cc0:	ff d6                	call   *%esi
			putch('x', putdat);
  800cc2:	83 c4 08             	add    $0x8,%esp
  800cc5:	53                   	push   %ebx
  800cc6:	6a 78                	push   $0x78
  800cc8:	ff d6                	call   *%esi
			num = (unsigned long long)
  800cca:	8b 45 14             	mov    0x14(%ebp),%eax
  800ccd:	8b 00                	mov    (%eax),%eax
  800ccf:	ba 00 00 00 00       	mov    $0x0,%edx
  800cd4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800cd7:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800cda:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800cdd:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce0:	8d 40 04             	lea    0x4(%eax),%eax
  800ce3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800ce6:	bf 10 00 00 00       	mov    $0x10,%edi
			if(posflag)
  800ceb:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800cef:	74 0b                	je     800cfc <vprintfmt+0x414>
				putch('+', putdat);
  800cf1:	83 ec 08             	sub    $0x8,%esp
  800cf4:	53                   	push   %ebx
  800cf5:	6a 2b                	push   $0x2b
  800cf7:	ff d6                	call   *%esi
  800cf9:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  800cfc:	83 ec 0c             	sub    $0xc,%esp
  800cff:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800d03:	50                   	push   %eax
  800d04:	ff 75 e0             	pushl  -0x20(%ebp)
  800d07:	57                   	push   %edi
  800d08:	ff 75 dc             	pushl  -0x24(%ebp)
  800d0b:	ff 75 d8             	pushl  -0x28(%ebp)
  800d0e:	89 da                	mov    %ebx,%edx
  800d10:	89 f0                	mov    %esi,%eax
  800d12:	e8 b8 fa ff ff       	call   8007cf <printnum>
			break;
  800d17:	83 c4 20             	add    $0x20,%esp
			char* cp = va_arg(ap, char *);
  800d1a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d1d:	83 c7 01             	add    $0x1,%edi
  800d20:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800d24:	83 f8 25             	cmp    $0x25,%eax
  800d27:	0f 84 d2 fb ff ff    	je     8008ff <vprintfmt+0x17>
			if (ch == '\0')
  800d2d:	85 c0                	test   %eax,%eax
  800d2f:	0f 84 03 01 00 00    	je     800e38 <vprintfmt+0x550>
			putch(ch, putdat);
  800d35:	83 ec 08             	sub    $0x8,%esp
  800d38:	53                   	push   %ebx
  800d39:	50                   	push   %eax
  800d3a:	ff d6                	call   *%esi
  800d3c:	83 c4 10             	add    $0x10,%esp
  800d3f:	eb dc                	jmp    800d1d <vprintfmt+0x435>
	if (lflag >= 2)
  800d41:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800d45:	7f 29                	jg     800d70 <vprintfmt+0x488>
	else if (lflag)
  800d47:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800d4b:	74 44                	je     800d91 <vprintfmt+0x4a9>
		return va_arg(*ap, unsigned long);
  800d4d:	8b 45 14             	mov    0x14(%ebp),%eax
  800d50:	8b 00                	mov    (%eax),%eax
  800d52:	ba 00 00 00 00       	mov    $0x0,%edx
  800d57:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d5a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800d5d:	8b 45 14             	mov    0x14(%ebp),%eax
  800d60:	8d 40 04             	lea    0x4(%eax),%eax
  800d63:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800d66:	bf 10 00 00 00       	mov    $0x10,%edi
  800d6b:	e9 7b ff ff ff       	jmp    800ceb <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  800d70:	8b 45 14             	mov    0x14(%ebp),%eax
  800d73:	8b 50 04             	mov    0x4(%eax),%edx
  800d76:	8b 00                	mov    (%eax),%eax
  800d78:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d7b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800d7e:	8b 45 14             	mov    0x14(%ebp),%eax
  800d81:	8d 40 08             	lea    0x8(%eax),%eax
  800d84:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800d87:	bf 10 00 00 00       	mov    $0x10,%edi
  800d8c:	e9 5a ff ff ff       	jmp    800ceb <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  800d91:	8b 45 14             	mov    0x14(%ebp),%eax
  800d94:	8b 00                	mov    (%eax),%eax
  800d96:	ba 00 00 00 00       	mov    $0x0,%edx
  800d9b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d9e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800da1:	8b 45 14             	mov    0x14(%ebp),%eax
  800da4:	8d 40 04             	lea    0x4(%eax),%eax
  800da7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800daa:	bf 10 00 00 00       	mov    $0x10,%edi
  800daf:	e9 37 ff ff ff       	jmp    800ceb <vprintfmt+0x403>
			char* cp = va_arg(ap, char *);
  800db4:	8b 45 14             	mov    0x14(%ebp),%eax
  800db7:	8d 78 04             	lea    0x4(%eax),%edi
  800dba:	8b 00                	mov    (%eax),%eax
    			if (cp == NULL) {
  800dbc:	85 c0                	test   %eax,%eax
  800dbe:	74 2c                	je     800dec <vprintfmt+0x504>
    			*cp = *(int *)putdat;
  800dc0:	8b 13                	mov    (%ebx),%edx
  800dc2:	88 10                	mov    %dl,(%eax)
			char* cp = va_arg(ap, char *);
  800dc4:	89 7d 14             	mov    %edi,0x14(%ebp)
    			if ((*(int *) putdat) > 127)
  800dc7:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  800dca:	0f 8e 4a ff ff ff    	jle    800d1a <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", overflow_error);
  800dd0:	68 7c 2a 80 00       	push   $0x802a7c
  800dd5:	68 9a 2d 80 00       	push   $0x802d9a
  800dda:	53                   	push   %ebx
  800ddb:	56                   	push   %esi
  800ddc:	e8 ea fa ff ff       	call   8008cb <printfmt>
  800de1:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  800de4:	89 7d 14             	mov    %edi,0x14(%ebp)
  800de7:	e9 2e ff ff ff       	jmp    800d1a <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", null_error);
  800dec:	68 44 2a 80 00       	push   $0x802a44
  800df1:	68 9a 2d 80 00       	push   $0x802d9a
  800df6:	53                   	push   %ebx
  800df7:	56                   	push   %esi
  800df8:	e8 ce fa ff ff       	call   8008cb <printfmt>
        		break;
  800dfd:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  800e00:	89 7d 14             	mov    %edi,0x14(%ebp)
        		break;
  800e03:	e9 12 ff ff ff       	jmp    800d1a <vprintfmt+0x432>
			putch(ch, putdat);
  800e08:	83 ec 08             	sub    $0x8,%esp
  800e0b:	53                   	push   %ebx
  800e0c:	6a 25                	push   $0x25
  800e0e:	ff d6                	call   *%esi
			break;
  800e10:	83 c4 10             	add    $0x10,%esp
  800e13:	e9 02 ff ff ff       	jmp    800d1a <vprintfmt+0x432>
			putch('%', putdat);
  800e18:	83 ec 08             	sub    $0x8,%esp
  800e1b:	53                   	push   %ebx
  800e1c:	6a 25                	push   $0x25
  800e1e:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800e20:	83 c4 10             	add    $0x10,%esp
  800e23:	89 f8                	mov    %edi,%eax
  800e25:	eb 03                	jmp    800e2a <vprintfmt+0x542>
  800e27:	83 e8 01             	sub    $0x1,%eax
  800e2a:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800e2e:	75 f7                	jne    800e27 <vprintfmt+0x53f>
  800e30:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e33:	e9 e2 fe ff ff       	jmp    800d1a <vprintfmt+0x432>
}
  800e38:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e3b:	5b                   	pop    %ebx
  800e3c:	5e                   	pop    %esi
  800e3d:	5f                   	pop    %edi
  800e3e:	5d                   	pop    %ebp
  800e3f:	c3                   	ret    

00800e40 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e40:	55                   	push   %ebp
  800e41:	89 e5                	mov    %esp,%ebp
  800e43:	83 ec 18             	sub    $0x18,%esp
  800e46:	8b 45 08             	mov    0x8(%ebp),%eax
  800e49:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e4c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e4f:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800e53:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800e56:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e5d:	85 c0                	test   %eax,%eax
  800e5f:	74 26                	je     800e87 <vsnprintf+0x47>
  800e61:	85 d2                	test   %edx,%edx
  800e63:	7e 22                	jle    800e87 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e65:	ff 75 14             	pushl  0x14(%ebp)
  800e68:	ff 75 10             	pushl  0x10(%ebp)
  800e6b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e6e:	50                   	push   %eax
  800e6f:	68 ae 08 80 00       	push   $0x8008ae
  800e74:	e8 6f fa ff ff       	call   8008e8 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800e79:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e7c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e82:	83 c4 10             	add    $0x10,%esp
}
  800e85:	c9                   	leave  
  800e86:	c3                   	ret    
		return -E_INVAL;
  800e87:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e8c:	eb f7                	jmp    800e85 <vsnprintf+0x45>

00800e8e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e8e:	55                   	push   %ebp
  800e8f:	89 e5                	mov    %esp,%ebp
  800e91:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e94:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800e97:	50                   	push   %eax
  800e98:	ff 75 10             	pushl  0x10(%ebp)
  800e9b:	ff 75 0c             	pushl  0xc(%ebp)
  800e9e:	ff 75 08             	pushl  0x8(%ebp)
  800ea1:	e8 9a ff ff ff       	call   800e40 <vsnprintf>
	va_end(ap);

	return rc;
}
  800ea6:	c9                   	leave  
  800ea7:	c3                   	ret    

00800ea8 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800ea8:	55                   	push   %ebp
  800ea9:	89 e5                	mov    %esp,%ebp
  800eab:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800eae:	b8 00 00 00 00       	mov    $0x0,%eax
  800eb3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800eb7:	74 05                	je     800ebe <strlen+0x16>
		n++;
  800eb9:	83 c0 01             	add    $0x1,%eax
  800ebc:	eb f5                	jmp    800eb3 <strlen+0xb>
	return n;
}
  800ebe:	5d                   	pop    %ebp
  800ebf:	c3                   	ret    

00800ec0 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800ec0:	55                   	push   %ebp
  800ec1:	89 e5                	mov    %esp,%ebp
  800ec3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ec6:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ec9:	ba 00 00 00 00       	mov    $0x0,%edx
  800ece:	39 c2                	cmp    %eax,%edx
  800ed0:	74 0d                	je     800edf <strnlen+0x1f>
  800ed2:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800ed6:	74 05                	je     800edd <strnlen+0x1d>
		n++;
  800ed8:	83 c2 01             	add    $0x1,%edx
  800edb:	eb f1                	jmp    800ece <strnlen+0xe>
  800edd:	89 d0                	mov    %edx,%eax
	return n;
}
  800edf:	5d                   	pop    %ebp
  800ee0:	c3                   	ret    

00800ee1 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ee1:	55                   	push   %ebp
  800ee2:	89 e5                	mov    %esp,%ebp
  800ee4:	53                   	push   %ebx
  800ee5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800eeb:	ba 00 00 00 00       	mov    $0x0,%edx
  800ef0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800ef4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800ef7:	83 c2 01             	add    $0x1,%edx
  800efa:	84 c9                	test   %cl,%cl
  800efc:	75 f2                	jne    800ef0 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800efe:	5b                   	pop    %ebx
  800eff:	5d                   	pop    %ebp
  800f00:	c3                   	ret    

00800f01 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800f01:	55                   	push   %ebp
  800f02:	89 e5                	mov    %esp,%ebp
  800f04:	53                   	push   %ebx
  800f05:	83 ec 10             	sub    $0x10,%esp
  800f08:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800f0b:	53                   	push   %ebx
  800f0c:	e8 97 ff ff ff       	call   800ea8 <strlen>
  800f11:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800f14:	ff 75 0c             	pushl  0xc(%ebp)
  800f17:	01 d8                	add    %ebx,%eax
  800f19:	50                   	push   %eax
  800f1a:	e8 c2 ff ff ff       	call   800ee1 <strcpy>
	return dst;
}
  800f1f:	89 d8                	mov    %ebx,%eax
  800f21:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f24:	c9                   	leave  
  800f25:	c3                   	ret    

00800f26 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800f26:	55                   	push   %ebp
  800f27:	89 e5                	mov    %esp,%ebp
  800f29:	56                   	push   %esi
  800f2a:	53                   	push   %ebx
  800f2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f31:	89 c6                	mov    %eax,%esi
  800f33:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f36:	89 c2                	mov    %eax,%edx
  800f38:	39 f2                	cmp    %esi,%edx
  800f3a:	74 11                	je     800f4d <strncpy+0x27>
		*dst++ = *src;
  800f3c:	83 c2 01             	add    $0x1,%edx
  800f3f:	0f b6 19             	movzbl (%ecx),%ebx
  800f42:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800f45:	80 fb 01             	cmp    $0x1,%bl
  800f48:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800f4b:	eb eb                	jmp    800f38 <strncpy+0x12>
	}
	return ret;
}
  800f4d:	5b                   	pop    %ebx
  800f4e:	5e                   	pop    %esi
  800f4f:	5d                   	pop    %ebp
  800f50:	c3                   	ret    

00800f51 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800f51:	55                   	push   %ebp
  800f52:	89 e5                	mov    %esp,%ebp
  800f54:	56                   	push   %esi
  800f55:	53                   	push   %ebx
  800f56:	8b 75 08             	mov    0x8(%ebp),%esi
  800f59:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f5c:	8b 55 10             	mov    0x10(%ebp),%edx
  800f5f:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800f61:	85 d2                	test   %edx,%edx
  800f63:	74 21                	je     800f86 <strlcpy+0x35>
  800f65:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800f69:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800f6b:	39 c2                	cmp    %eax,%edx
  800f6d:	74 14                	je     800f83 <strlcpy+0x32>
  800f6f:	0f b6 19             	movzbl (%ecx),%ebx
  800f72:	84 db                	test   %bl,%bl
  800f74:	74 0b                	je     800f81 <strlcpy+0x30>
			*dst++ = *src++;
  800f76:	83 c1 01             	add    $0x1,%ecx
  800f79:	83 c2 01             	add    $0x1,%edx
  800f7c:	88 5a ff             	mov    %bl,-0x1(%edx)
  800f7f:	eb ea                	jmp    800f6b <strlcpy+0x1a>
  800f81:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800f83:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f86:	29 f0                	sub    %esi,%eax
}
  800f88:	5b                   	pop    %ebx
  800f89:	5e                   	pop    %esi
  800f8a:	5d                   	pop    %ebp
  800f8b:	c3                   	ret    

00800f8c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f8c:	55                   	push   %ebp
  800f8d:	89 e5                	mov    %esp,%ebp
  800f8f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f92:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800f95:	0f b6 01             	movzbl (%ecx),%eax
  800f98:	84 c0                	test   %al,%al
  800f9a:	74 0c                	je     800fa8 <strcmp+0x1c>
  800f9c:	3a 02                	cmp    (%edx),%al
  800f9e:	75 08                	jne    800fa8 <strcmp+0x1c>
		p++, q++;
  800fa0:	83 c1 01             	add    $0x1,%ecx
  800fa3:	83 c2 01             	add    $0x1,%edx
  800fa6:	eb ed                	jmp    800f95 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800fa8:	0f b6 c0             	movzbl %al,%eax
  800fab:	0f b6 12             	movzbl (%edx),%edx
  800fae:	29 d0                	sub    %edx,%eax
}
  800fb0:	5d                   	pop    %ebp
  800fb1:	c3                   	ret    

00800fb2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800fb2:	55                   	push   %ebp
  800fb3:	89 e5                	mov    %esp,%ebp
  800fb5:	53                   	push   %ebx
  800fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fbc:	89 c3                	mov    %eax,%ebx
  800fbe:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800fc1:	eb 06                	jmp    800fc9 <strncmp+0x17>
		n--, p++, q++;
  800fc3:	83 c0 01             	add    $0x1,%eax
  800fc6:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800fc9:	39 d8                	cmp    %ebx,%eax
  800fcb:	74 16                	je     800fe3 <strncmp+0x31>
  800fcd:	0f b6 08             	movzbl (%eax),%ecx
  800fd0:	84 c9                	test   %cl,%cl
  800fd2:	74 04                	je     800fd8 <strncmp+0x26>
  800fd4:	3a 0a                	cmp    (%edx),%cl
  800fd6:	74 eb                	je     800fc3 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fd8:	0f b6 00             	movzbl (%eax),%eax
  800fdb:	0f b6 12             	movzbl (%edx),%edx
  800fde:	29 d0                	sub    %edx,%eax
}
  800fe0:	5b                   	pop    %ebx
  800fe1:	5d                   	pop    %ebp
  800fe2:	c3                   	ret    
		return 0;
  800fe3:	b8 00 00 00 00       	mov    $0x0,%eax
  800fe8:	eb f6                	jmp    800fe0 <strncmp+0x2e>

00800fea <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800fea:	55                   	push   %ebp
  800feb:	89 e5                	mov    %esp,%ebp
  800fed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ff4:	0f b6 10             	movzbl (%eax),%edx
  800ff7:	84 d2                	test   %dl,%dl
  800ff9:	74 09                	je     801004 <strchr+0x1a>
		if (*s == c)
  800ffb:	38 ca                	cmp    %cl,%dl
  800ffd:	74 0a                	je     801009 <strchr+0x1f>
	for (; *s; s++)
  800fff:	83 c0 01             	add    $0x1,%eax
  801002:	eb f0                	jmp    800ff4 <strchr+0xa>
			return (char *) s;
	return 0;
  801004:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801009:	5d                   	pop    %ebp
  80100a:	c3                   	ret    

0080100b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80100b:	55                   	push   %ebp
  80100c:	89 e5                	mov    %esp,%ebp
  80100e:	8b 45 08             	mov    0x8(%ebp),%eax
  801011:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801015:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801018:	38 ca                	cmp    %cl,%dl
  80101a:	74 09                	je     801025 <strfind+0x1a>
  80101c:	84 d2                	test   %dl,%dl
  80101e:	74 05                	je     801025 <strfind+0x1a>
	for (; *s; s++)
  801020:	83 c0 01             	add    $0x1,%eax
  801023:	eb f0                	jmp    801015 <strfind+0xa>
			break;
	return (char *) s;
}
  801025:	5d                   	pop    %ebp
  801026:	c3                   	ret    

00801027 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801027:	55                   	push   %ebp
  801028:	89 e5                	mov    %esp,%ebp
  80102a:	57                   	push   %edi
  80102b:	56                   	push   %esi
  80102c:	53                   	push   %ebx
  80102d:	8b 7d 08             	mov    0x8(%ebp),%edi
  801030:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801033:	85 c9                	test   %ecx,%ecx
  801035:	74 31                	je     801068 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801037:	89 f8                	mov    %edi,%eax
  801039:	09 c8                	or     %ecx,%eax
  80103b:	a8 03                	test   $0x3,%al
  80103d:	75 23                	jne    801062 <memset+0x3b>
		c &= 0xFF;
  80103f:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801043:	89 d3                	mov    %edx,%ebx
  801045:	c1 e3 08             	shl    $0x8,%ebx
  801048:	89 d0                	mov    %edx,%eax
  80104a:	c1 e0 18             	shl    $0x18,%eax
  80104d:	89 d6                	mov    %edx,%esi
  80104f:	c1 e6 10             	shl    $0x10,%esi
  801052:	09 f0                	or     %esi,%eax
  801054:	09 c2                	or     %eax,%edx
  801056:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801058:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  80105b:	89 d0                	mov    %edx,%eax
  80105d:	fc                   	cld    
  80105e:	f3 ab                	rep stos %eax,%es:(%edi)
  801060:	eb 06                	jmp    801068 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801062:	8b 45 0c             	mov    0xc(%ebp),%eax
  801065:	fc                   	cld    
  801066:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801068:	89 f8                	mov    %edi,%eax
  80106a:	5b                   	pop    %ebx
  80106b:	5e                   	pop    %esi
  80106c:	5f                   	pop    %edi
  80106d:	5d                   	pop    %ebp
  80106e:	c3                   	ret    

0080106f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80106f:	55                   	push   %ebp
  801070:	89 e5                	mov    %esp,%ebp
  801072:	57                   	push   %edi
  801073:	56                   	push   %esi
  801074:	8b 45 08             	mov    0x8(%ebp),%eax
  801077:	8b 75 0c             	mov    0xc(%ebp),%esi
  80107a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80107d:	39 c6                	cmp    %eax,%esi
  80107f:	73 32                	jae    8010b3 <memmove+0x44>
  801081:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801084:	39 c2                	cmp    %eax,%edx
  801086:	76 2b                	jbe    8010b3 <memmove+0x44>
		s += n;
		d += n;
  801088:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80108b:	89 fe                	mov    %edi,%esi
  80108d:	09 ce                	or     %ecx,%esi
  80108f:	09 d6                	or     %edx,%esi
  801091:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801097:	75 0e                	jne    8010a7 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801099:	83 ef 04             	sub    $0x4,%edi
  80109c:	8d 72 fc             	lea    -0x4(%edx),%esi
  80109f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8010a2:	fd                   	std    
  8010a3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8010a5:	eb 09                	jmp    8010b0 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8010a7:	83 ef 01             	sub    $0x1,%edi
  8010aa:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8010ad:	fd                   	std    
  8010ae:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8010b0:	fc                   	cld    
  8010b1:	eb 1a                	jmp    8010cd <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8010b3:	89 c2                	mov    %eax,%edx
  8010b5:	09 ca                	or     %ecx,%edx
  8010b7:	09 f2                	or     %esi,%edx
  8010b9:	f6 c2 03             	test   $0x3,%dl
  8010bc:	75 0a                	jne    8010c8 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8010be:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8010c1:	89 c7                	mov    %eax,%edi
  8010c3:	fc                   	cld    
  8010c4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8010c6:	eb 05                	jmp    8010cd <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  8010c8:	89 c7                	mov    %eax,%edi
  8010ca:	fc                   	cld    
  8010cb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8010cd:	5e                   	pop    %esi
  8010ce:	5f                   	pop    %edi
  8010cf:	5d                   	pop    %ebp
  8010d0:	c3                   	ret    

008010d1 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8010d1:	55                   	push   %ebp
  8010d2:	89 e5                	mov    %esp,%ebp
  8010d4:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8010d7:	ff 75 10             	pushl  0x10(%ebp)
  8010da:	ff 75 0c             	pushl  0xc(%ebp)
  8010dd:	ff 75 08             	pushl  0x8(%ebp)
  8010e0:	e8 8a ff ff ff       	call   80106f <memmove>
}
  8010e5:	c9                   	leave  
  8010e6:	c3                   	ret    

008010e7 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8010e7:	55                   	push   %ebp
  8010e8:	89 e5                	mov    %esp,%ebp
  8010ea:	56                   	push   %esi
  8010eb:	53                   	push   %ebx
  8010ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010f2:	89 c6                	mov    %eax,%esi
  8010f4:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8010f7:	39 f0                	cmp    %esi,%eax
  8010f9:	74 1c                	je     801117 <memcmp+0x30>
		if (*s1 != *s2)
  8010fb:	0f b6 08             	movzbl (%eax),%ecx
  8010fe:	0f b6 1a             	movzbl (%edx),%ebx
  801101:	38 d9                	cmp    %bl,%cl
  801103:	75 08                	jne    80110d <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801105:	83 c0 01             	add    $0x1,%eax
  801108:	83 c2 01             	add    $0x1,%edx
  80110b:	eb ea                	jmp    8010f7 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  80110d:	0f b6 c1             	movzbl %cl,%eax
  801110:	0f b6 db             	movzbl %bl,%ebx
  801113:	29 d8                	sub    %ebx,%eax
  801115:	eb 05                	jmp    80111c <memcmp+0x35>
	}

	return 0;
  801117:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80111c:	5b                   	pop    %ebx
  80111d:	5e                   	pop    %esi
  80111e:	5d                   	pop    %ebp
  80111f:	c3                   	ret    

00801120 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801120:	55                   	push   %ebp
  801121:	89 e5                	mov    %esp,%ebp
  801123:	8b 45 08             	mov    0x8(%ebp),%eax
  801126:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801129:	89 c2                	mov    %eax,%edx
  80112b:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  80112e:	39 d0                	cmp    %edx,%eax
  801130:	73 09                	jae    80113b <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  801132:	38 08                	cmp    %cl,(%eax)
  801134:	74 05                	je     80113b <memfind+0x1b>
	for (; s < ends; s++)
  801136:	83 c0 01             	add    $0x1,%eax
  801139:	eb f3                	jmp    80112e <memfind+0xe>
			break;
	return (void *) s;
}
  80113b:	5d                   	pop    %ebp
  80113c:	c3                   	ret    

0080113d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80113d:	55                   	push   %ebp
  80113e:	89 e5                	mov    %esp,%ebp
  801140:	57                   	push   %edi
  801141:	56                   	push   %esi
  801142:	53                   	push   %ebx
  801143:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801146:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801149:	eb 03                	jmp    80114e <strtol+0x11>
		s++;
  80114b:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  80114e:	0f b6 01             	movzbl (%ecx),%eax
  801151:	3c 20                	cmp    $0x20,%al
  801153:	74 f6                	je     80114b <strtol+0xe>
  801155:	3c 09                	cmp    $0x9,%al
  801157:	74 f2                	je     80114b <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  801159:	3c 2b                	cmp    $0x2b,%al
  80115b:	74 2a                	je     801187 <strtol+0x4a>
	int neg = 0;
  80115d:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801162:	3c 2d                	cmp    $0x2d,%al
  801164:	74 2b                	je     801191 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801166:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  80116c:	75 0f                	jne    80117d <strtol+0x40>
  80116e:	80 39 30             	cmpb   $0x30,(%ecx)
  801171:	74 28                	je     80119b <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801173:	85 db                	test   %ebx,%ebx
  801175:	b8 0a 00 00 00       	mov    $0xa,%eax
  80117a:	0f 44 d8             	cmove  %eax,%ebx
  80117d:	b8 00 00 00 00       	mov    $0x0,%eax
  801182:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801185:	eb 50                	jmp    8011d7 <strtol+0x9a>
		s++;
  801187:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  80118a:	bf 00 00 00 00       	mov    $0x0,%edi
  80118f:	eb d5                	jmp    801166 <strtol+0x29>
		s++, neg = 1;
  801191:	83 c1 01             	add    $0x1,%ecx
  801194:	bf 01 00 00 00       	mov    $0x1,%edi
  801199:	eb cb                	jmp    801166 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80119b:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  80119f:	74 0e                	je     8011af <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  8011a1:	85 db                	test   %ebx,%ebx
  8011a3:	75 d8                	jne    80117d <strtol+0x40>
		s++, base = 8;
  8011a5:	83 c1 01             	add    $0x1,%ecx
  8011a8:	bb 08 00 00 00       	mov    $0x8,%ebx
  8011ad:	eb ce                	jmp    80117d <strtol+0x40>
		s += 2, base = 16;
  8011af:	83 c1 02             	add    $0x2,%ecx
  8011b2:	bb 10 00 00 00       	mov    $0x10,%ebx
  8011b7:	eb c4                	jmp    80117d <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  8011b9:	8d 72 9f             	lea    -0x61(%edx),%esi
  8011bc:	89 f3                	mov    %esi,%ebx
  8011be:	80 fb 19             	cmp    $0x19,%bl
  8011c1:	77 29                	ja     8011ec <strtol+0xaf>
			dig = *s - 'a' + 10;
  8011c3:	0f be d2             	movsbl %dl,%edx
  8011c6:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  8011c9:	3b 55 10             	cmp    0x10(%ebp),%edx
  8011cc:	7d 30                	jge    8011fe <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  8011ce:	83 c1 01             	add    $0x1,%ecx
  8011d1:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011d5:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  8011d7:	0f b6 11             	movzbl (%ecx),%edx
  8011da:	8d 72 d0             	lea    -0x30(%edx),%esi
  8011dd:	89 f3                	mov    %esi,%ebx
  8011df:	80 fb 09             	cmp    $0x9,%bl
  8011e2:	77 d5                	ja     8011b9 <strtol+0x7c>
			dig = *s - '0';
  8011e4:	0f be d2             	movsbl %dl,%edx
  8011e7:	83 ea 30             	sub    $0x30,%edx
  8011ea:	eb dd                	jmp    8011c9 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  8011ec:	8d 72 bf             	lea    -0x41(%edx),%esi
  8011ef:	89 f3                	mov    %esi,%ebx
  8011f1:	80 fb 19             	cmp    $0x19,%bl
  8011f4:	77 08                	ja     8011fe <strtol+0xc1>
			dig = *s - 'A' + 10;
  8011f6:	0f be d2             	movsbl %dl,%edx
  8011f9:	83 ea 37             	sub    $0x37,%edx
  8011fc:	eb cb                	jmp    8011c9 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  8011fe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801202:	74 05                	je     801209 <strtol+0xcc>
		*endptr = (char *) s;
  801204:	8b 75 0c             	mov    0xc(%ebp),%esi
  801207:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801209:	89 c2                	mov    %eax,%edx
  80120b:	f7 da                	neg    %edx
  80120d:	85 ff                	test   %edi,%edi
  80120f:	0f 45 c2             	cmovne %edx,%eax
}
  801212:	5b                   	pop    %ebx
  801213:	5e                   	pop    %esi
  801214:	5f                   	pop    %edi
  801215:	5d                   	pop    %ebp
  801216:	c3                   	ret    

00801217 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801217:	55                   	push   %ebp
  801218:	89 e5                	mov    %esp,%ebp
  80121a:	57                   	push   %edi
  80121b:	56                   	push   %esi
  80121c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80121d:	b8 00 00 00 00       	mov    $0x0,%eax
  801222:	8b 55 08             	mov    0x8(%ebp),%edx
  801225:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801228:	89 c3                	mov    %eax,%ebx
  80122a:	89 c7                	mov    %eax,%edi
  80122c:	89 c6                	mov    %eax,%esi
  80122e:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  801230:	5b                   	pop    %ebx
  801231:	5e                   	pop    %esi
  801232:	5f                   	pop    %edi
  801233:	5d                   	pop    %ebp
  801234:	c3                   	ret    

00801235 <sys_cgetc>:

int
sys_cgetc(void)
{
  801235:	55                   	push   %ebp
  801236:	89 e5                	mov    %esp,%ebp
  801238:	57                   	push   %edi
  801239:	56                   	push   %esi
  80123a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80123b:	ba 00 00 00 00       	mov    $0x0,%edx
  801240:	b8 01 00 00 00       	mov    $0x1,%eax
  801245:	89 d1                	mov    %edx,%ecx
  801247:	89 d3                	mov    %edx,%ebx
  801249:	89 d7                	mov    %edx,%edi
  80124b:	89 d6                	mov    %edx,%esi
  80124d:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80124f:	5b                   	pop    %ebx
  801250:	5e                   	pop    %esi
  801251:	5f                   	pop    %edi
  801252:	5d                   	pop    %ebp
  801253:	c3                   	ret    

00801254 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801254:	55                   	push   %ebp
  801255:	89 e5                	mov    %esp,%ebp
  801257:	57                   	push   %edi
  801258:	56                   	push   %esi
  801259:	53                   	push   %ebx
  80125a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80125d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801262:	8b 55 08             	mov    0x8(%ebp),%edx
  801265:	b8 03 00 00 00       	mov    $0x3,%eax
  80126a:	89 cb                	mov    %ecx,%ebx
  80126c:	89 cf                	mov    %ecx,%edi
  80126e:	89 ce                	mov    %ecx,%esi
  801270:	cd 30                	int    $0x30
	if (check && ret > 0)
  801272:	85 c0                	test   %eax,%eax
  801274:	7f 08                	jg     80127e <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801276:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801279:	5b                   	pop    %ebx
  80127a:	5e                   	pop    %esi
  80127b:	5f                   	pop    %edi
  80127c:	5d                   	pop    %ebp
  80127d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80127e:	83 ec 0c             	sub    $0xc,%esp
  801281:	50                   	push   %eax
  801282:	6a 03                	push   $0x3
  801284:	68 80 2c 80 00       	push   $0x802c80
  801289:	6a 4c                	push   $0x4c
  80128b:	68 9d 2c 80 00       	push   $0x802c9d
  801290:	e8 4b f4 ff ff       	call   8006e0 <_panic>

00801295 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801295:	55                   	push   %ebp
  801296:	89 e5                	mov    %esp,%ebp
  801298:	57                   	push   %edi
  801299:	56                   	push   %esi
  80129a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80129b:	ba 00 00 00 00       	mov    $0x0,%edx
  8012a0:	b8 02 00 00 00       	mov    $0x2,%eax
  8012a5:	89 d1                	mov    %edx,%ecx
  8012a7:	89 d3                	mov    %edx,%ebx
  8012a9:	89 d7                	mov    %edx,%edi
  8012ab:	89 d6                	mov    %edx,%esi
  8012ad:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8012af:	5b                   	pop    %ebx
  8012b0:	5e                   	pop    %esi
  8012b1:	5f                   	pop    %edi
  8012b2:	5d                   	pop    %ebp
  8012b3:	c3                   	ret    

008012b4 <sys_yield>:

void
sys_yield(void)
{
  8012b4:	55                   	push   %ebp
  8012b5:	89 e5                	mov    %esp,%ebp
  8012b7:	57                   	push   %edi
  8012b8:	56                   	push   %esi
  8012b9:	53                   	push   %ebx
	asm volatile("int %1\n"
  8012ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8012bf:	b8 0b 00 00 00       	mov    $0xb,%eax
  8012c4:	89 d1                	mov    %edx,%ecx
  8012c6:	89 d3                	mov    %edx,%ebx
  8012c8:	89 d7                	mov    %edx,%edi
  8012ca:	89 d6                	mov    %edx,%esi
  8012cc:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8012ce:	5b                   	pop    %ebx
  8012cf:	5e                   	pop    %esi
  8012d0:	5f                   	pop    %edi
  8012d1:	5d                   	pop    %ebp
  8012d2:	c3                   	ret    

008012d3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8012d3:	55                   	push   %ebp
  8012d4:	89 e5                	mov    %esp,%ebp
  8012d6:	57                   	push   %edi
  8012d7:	56                   	push   %esi
  8012d8:	53                   	push   %ebx
  8012d9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012dc:	be 00 00 00 00       	mov    $0x0,%esi
  8012e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8012e4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012e7:	b8 04 00 00 00       	mov    $0x4,%eax
  8012ec:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8012ef:	89 f7                	mov    %esi,%edi
  8012f1:	cd 30                	int    $0x30
	if (check && ret > 0)
  8012f3:	85 c0                	test   %eax,%eax
  8012f5:	7f 08                	jg     8012ff <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8012f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012fa:	5b                   	pop    %ebx
  8012fb:	5e                   	pop    %esi
  8012fc:	5f                   	pop    %edi
  8012fd:	5d                   	pop    %ebp
  8012fe:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012ff:	83 ec 0c             	sub    $0xc,%esp
  801302:	50                   	push   %eax
  801303:	6a 04                	push   $0x4
  801305:	68 80 2c 80 00       	push   $0x802c80
  80130a:	6a 4c                	push   $0x4c
  80130c:	68 9d 2c 80 00       	push   $0x802c9d
  801311:	e8 ca f3 ff ff       	call   8006e0 <_panic>

00801316 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801316:	55                   	push   %ebp
  801317:	89 e5                	mov    %esp,%ebp
  801319:	57                   	push   %edi
  80131a:	56                   	push   %esi
  80131b:	53                   	push   %ebx
  80131c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80131f:	8b 55 08             	mov    0x8(%ebp),%edx
  801322:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801325:	b8 05 00 00 00       	mov    $0x5,%eax
  80132a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80132d:	8b 7d 14             	mov    0x14(%ebp),%edi
  801330:	8b 75 18             	mov    0x18(%ebp),%esi
  801333:	cd 30                	int    $0x30
	if (check && ret > 0)
  801335:	85 c0                	test   %eax,%eax
  801337:	7f 08                	jg     801341 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801339:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80133c:	5b                   	pop    %ebx
  80133d:	5e                   	pop    %esi
  80133e:	5f                   	pop    %edi
  80133f:	5d                   	pop    %ebp
  801340:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801341:	83 ec 0c             	sub    $0xc,%esp
  801344:	50                   	push   %eax
  801345:	6a 05                	push   $0x5
  801347:	68 80 2c 80 00       	push   $0x802c80
  80134c:	6a 4c                	push   $0x4c
  80134e:	68 9d 2c 80 00       	push   $0x802c9d
  801353:	e8 88 f3 ff ff       	call   8006e0 <_panic>

00801358 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801358:	55                   	push   %ebp
  801359:	89 e5                	mov    %esp,%ebp
  80135b:	57                   	push   %edi
  80135c:	56                   	push   %esi
  80135d:	53                   	push   %ebx
  80135e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801361:	bb 00 00 00 00       	mov    $0x0,%ebx
  801366:	8b 55 08             	mov    0x8(%ebp),%edx
  801369:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80136c:	b8 06 00 00 00       	mov    $0x6,%eax
  801371:	89 df                	mov    %ebx,%edi
  801373:	89 de                	mov    %ebx,%esi
  801375:	cd 30                	int    $0x30
	if (check && ret > 0)
  801377:	85 c0                	test   %eax,%eax
  801379:	7f 08                	jg     801383 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80137b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80137e:	5b                   	pop    %ebx
  80137f:	5e                   	pop    %esi
  801380:	5f                   	pop    %edi
  801381:	5d                   	pop    %ebp
  801382:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801383:	83 ec 0c             	sub    $0xc,%esp
  801386:	50                   	push   %eax
  801387:	6a 06                	push   $0x6
  801389:	68 80 2c 80 00       	push   $0x802c80
  80138e:	6a 4c                	push   $0x4c
  801390:	68 9d 2c 80 00       	push   $0x802c9d
  801395:	e8 46 f3 ff ff       	call   8006e0 <_panic>

0080139a <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80139a:	55                   	push   %ebp
  80139b:	89 e5                	mov    %esp,%ebp
  80139d:	57                   	push   %edi
  80139e:	56                   	push   %esi
  80139f:	53                   	push   %ebx
  8013a0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8013a3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8013ab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013ae:	b8 08 00 00 00       	mov    $0x8,%eax
  8013b3:	89 df                	mov    %ebx,%edi
  8013b5:	89 de                	mov    %ebx,%esi
  8013b7:	cd 30                	int    $0x30
	if (check && ret > 0)
  8013b9:	85 c0                	test   %eax,%eax
  8013bb:	7f 08                	jg     8013c5 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8013bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013c0:	5b                   	pop    %ebx
  8013c1:	5e                   	pop    %esi
  8013c2:	5f                   	pop    %edi
  8013c3:	5d                   	pop    %ebp
  8013c4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8013c5:	83 ec 0c             	sub    $0xc,%esp
  8013c8:	50                   	push   %eax
  8013c9:	6a 08                	push   $0x8
  8013cb:	68 80 2c 80 00       	push   $0x802c80
  8013d0:	6a 4c                	push   $0x4c
  8013d2:	68 9d 2c 80 00       	push   $0x802c9d
  8013d7:	e8 04 f3 ff ff       	call   8006e0 <_panic>

008013dc <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8013dc:	55                   	push   %ebp
  8013dd:	89 e5                	mov    %esp,%ebp
  8013df:	57                   	push   %edi
  8013e0:	56                   	push   %esi
  8013e1:	53                   	push   %ebx
  8013e2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8013e5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8013ed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013f0:	b8 09 00 00 00       	mov    $0x9,%eax
  8013f5:	89 df                	mov    %ebx,%edi
  8013f7:	89 de                	mov    %ebx,%esi
  8013f9:	cd 30                	int    $0x30
	if (check && ret > 0)
  8013fb:	85 c0                	test   %eax,%eax
  8013fd:	7f 08                	jg     801407 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8013ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801402:	5b                   	pop    %ebx
  801403:	5e                   	pop    %esi
  801404:	5f                   	pop    %edi
  801405:	5d                   	pop    %ebp
  801406:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801407:	83 ec 0c             	sub    $0xc,%esp
  80140a:	50                   	push   %eax
  80140b:	6a 09                	push   $0x9
  80140d:	68 80 2c 80 00       	push   $0x802c80
  801412:	6a 4c                	push   $0x4c
  801414:	68 9d 2c 80 00       	push   $0x802c9d
  801419:	e8 c2 f2 ff ff       	call   8006e0 <_panic>

0080141e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80141e:	55                   	push   %ebp
  80141f:	89 e5                	mov    %esp,%ebp
  801421:	57                   	push   %edi
  801422:	56                   	push   %esi
  801423:	53                   	push   %ebx
  801424:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801427:	bb 00 00 00 00       	mov    $0x0,%ebx
  80142c:	8b 55 08             	mov    0x8(%ebp),%edx
  80142f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801432:	b8 0a 00 00 00       	mov    $0xa,%eax
  801437:	89 df                	mov    %ebx,%edi
  801439:	89 de                	mov    %ebx,%esi
  80143b:	cd 30                	int    $0x30
	if (check && ret > 0)
  80143d:	85 c0                	test   %eax,%eax
  80143f:	7f 08                	jg     801449 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801441:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801444:	5b                   	pop    %ebx
  801445:	5e                   	pop    %esi
  801446:	5f                   	pop    %edi
  801447:	5d                   	pop    %ebp
  801448:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801449:	83 ec 0c             	sub    $0xc,%esp
  80144c:	50                   	push   %eax
  80144d:	6a 0a                	push   $0xa
  80144f:	68 80 2c 80 00       	push   $0x802c80
  801454:	6a 4c                	push   $0x4c
  801456:	68 9d 2c 80 00       	push   $0x802c9d
  80145b:	e8 80 f2 ff ff       	call   8006e0 <_panic>

00801460 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801460:	55                   	push   %ebp
  801461:	89 e5                	mov    %esp,%ebp
  801463:	57                   	push   %edi
  801464:	56                   	push   %esi
  801465:	53                   	push   %ebx
	asm volatile("int %1\n"
  801466:	8b 55 08             	mov    0x8(%ebp),%edx
  801469:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80146c:	b8 0c 00 00 00       	mov    $0xc,%eax
  801471:	be 00 00 00 00       	mov    $0x0,%esi
  801476:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801479:	8b 7d 14             	mov    0x14(%ebp),%edi
  80147c:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80147e:	5b                   	pop    %ebx
  80147f:	5e                   	pop    %esi
  801480:	5f                   	pop    %edi
  801481:	5d                   	pop    %ebp
  801482:	c3                   	ret    

00801483 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801483:	55                   	push   %ebp
  801484:	89 e5                	mov    %esp,%ebp
  801486:	57                   	push   %edi
  801487:	56                   	push   %esi
  801488:	53                   	push   %ebx
  801489:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80148c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801491:	8b 55 08             	mov    0x8(%ebp),%edx
  801494:	b8 0d 00 00 00       	mov    $0xd,%eax
  801499:	89 cb                	mov    %ecx,%ebx
  80149b:	89 cf                	mov    %ecx,%edi
  80149d:	89 ce                	mov    %ecx,%esi
  80149f:	cd 30                	int    $0x30
	if (check && ret > 0)
  8014a1:	85 c0                	test   %eax,%eax
  8014a3:	7f 08                	jg     8014ad <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8014a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014a8:	5b                   	pop    %ebx
  8014a9:	5e                   	pop    %esi
  8014aa:	5f                   	pop    %edi
  8014ab:	5d                   	pop    %ebp
  8014ac:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8014ad:	83 ec 0c             	sub    $0xc,%esp
  8014b0:	50                   	push   %eax
  8014b1:	6a 0d                	push   $0xd
  8014b3:	68 80 2c 80 00       	push   $0x802c80
  8014b8:	6a 4c                	push   $0x4c
  8014ba:	68 9d 2c 80 00       	push   $0x802c9d
  8014bf:	e8 1c f2 ff ff       	call   8006e0 <_panic>

008014c4 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  8014c4:	55                   	push   %ebp
  8014c5:	89 e5                	mov    %esp,%ebp
  8014c7:	57                   	push   %edi
  8014c8:	56                   	push   %esi
  8014c9:	53                   	push   %ebx
	asm volatile("int %1\n"
  8014ca:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8014d2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014d5:	b8 0e 00 00 00       	mov    $0xe,%eax
  8014da:	89 df                	mov    %ebx,%edi
  8014dc:	89 de                	mov    %ebx,%esi
  8014de:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8014e0:	5b                   	pop    %ebx
  8014e1:	5e                   	pop    %esi
  8014e2:	5f                   	pop    %edi
  8014e3:	5d                   	pop    %ebp
  8014e4:	c3                   	ret    

008014e5 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8014e5:	55                   	push   %ebp
  8014e6:	89 e5                	mov    %esp,%ebp
  8014e8:	57                   	push   %edi
  8014e9:	56                   	push   %esi
  8014ea:	53                   	push   %ebx
	asm volatile("int %1\n"
  8014eb:	b9 00 00 00 00       	mov    $0x0,%ecx
  8014f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8014f3:	b8 0f 00 00 00       	mov    $0xf,%eax
  8014f8:	89 cb                	mov    %ecx,%ebx
  8014fa:	89 cf                	mov    %ecx,%edi
  8014fc:	89 ce                	mov    %ecx,%esi
  8014fe:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801500:	5b                   	pop    %ebx
  801501:	5e                   	pop    %esi
  801502:	5f                   	pop    %edi
  801503:	5d                   	pop    %ebp
  801504:	c3                   	ret    

00801505 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801505:	55                   	push   %ebp
  801506:	89 e5                	mov    %esp,%ebp
  801508:	56                   	push   %esi
  801509:	53                   	push   %ebx
  80150a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80150d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801510:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// return 0;
	if(!pg)
  801513:	85 c0                	test   %eax,%eax
		pg = (void*)UTOP;
  801515:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80151a:	0f 44 c2             	cmove  %edx,%eax
	
	int ret;

	ret = sys_ipc_recv(pg);
  80151d:	83 ec 0c             	sub    $0xc,%esp
  801520:	50                   	push   %eax
  801521:	e8 5d ff ff ff       	call   801483 <sys_ipc_recv>
	if(ret < 0){
  801526:	83 c4 10             	add    $0x10,%esp
  801529:	85 c0                	test   %eax,%eax
  80152b:	78 2b                	js     801558 <ipc_recv+0x53>
		if(perm_store) *perm_store = 0;
		if(from_env_store) *from_env_store = 0;
		return ret;
	}
	
	if(perm_store)
  80152d:	85 f6                	test   %esi,%esi
  80152f:	74 0a                	je     80153b <ipc_recv+0x36>
		*perm_store = thisenv->env_ipc_perm;
  801531:	a1 04 40 80 00       	mov    0x804004,%eax
  801536:	8b 40 78             	mov    0x78(%eax),%eax
  801539:	89 06                	mov    %eax,(%esi)
	if(from_env_store)
  80153b:	85 db                	test   %ebx,%ebx
  80153d:	74 0a                	je     801549 <ipc_recv+0x44>
		*from_env_store = thisenv->env_ipc_from;
  80153f:	a1 04 40 80 00       	mov    0x804004,%eax
  801544:	8b 40 74             	mov    0x74(%eax),%eax
  801547:	89 03                	mov    %eax,(%ebx)

	return thisenv->env_ipc_value;
  801549:	a1 04 40 80 00       	mov    0x804004,%eax
  80154e:	8b 40 70             	mov    0x70(%eax),%eax
}
  801551:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801554:	5b                   	pop    %ebx
  801555:	5e                   	pop    %esi
  801556:	5d                   	pop    %ebp
  801557:	c3                   	ret    
		if(perm_store) *perm_store = 0;
  801558:	85 f6                	test   %esi,%esi
  80155a:	74 06                	je     801562 <ipc_recv+0x5d>
  80155c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(from_env_store) *from_env_store = 0;
  801562:	85 db                	test   %ebx,%ebx
  801564:	74 eb                	je     801551 <ipc_recv+0x4c>
  801566:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80156c:	eb e3                	jmp    801551 <ipc_recv+0x4c>

0080156e <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80156e:	55                   	push   %ebp
  80156f:	89 e5                	mov    %esp,%ebp
  801571:	57                   	push   %edi
  801572:	56                   	push   %esi
  801573:	53                   	push   %ebx
  801574:	83 ec 0c             	sub    $0xc,%esp
  801577:	8b 7d 08             	mov    0x8(%ebp),%edi
  80157a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80157d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
	if (!pg)
  801580:	85 db                	test   %ebx,%ebx
		pg = (void*)UTOP;
  801582:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801587:	0f 44 d8             	cmove  %eax,%ebx

	int ret = -E_IPC_NOT_RECV;
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))) {
  80158a:	ff 75 14             	pushl  0x14(%ebp)
  80158d:	53                   	push   %ebx
  80158e:	56                   	push   %esi
  80158f:	57                   	push   %edi
  801590:	e8 cb fe ff ff       	call   801460 <sys_ipc_try_send>
  801595:	83 c4 10             	add    $0x10,%esp
  801598:	85 c0                	test   %eax,%eax
  80159a:	74 17                	je     8015b3 <ipc_send+0x45>
		if(ret != -E_IPC_NOT_RECV){
  80159c:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80159f:	74 e9                	je     80158a <ipc_send+0x1c>
			panic("ipc_send: ret : %d", ret);
  8015a1:	50                   	push   %eax
  8015a2:	68 ab 2c 80 00       	push   $0x802cab
  8015a7:	6a 43                	push   $0x43
  8015a9:	68 be 2c 80 00       	push   $0x802cbe
  8015ae:	e8 2d f1 ff ff       	call   8006e0 <_panic>
			sys_yield();
		}
	}
}
  8015b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015b6:	5b                   	pop    %ebx
  8015b7:	5e                   	pop    %esi
  8015b8:	5f                   	pop    %edi
  8015b9:	5d                   	pop    %ebp
  8015ba:	c3                   	ret    

008015bb <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8015bb:	55                   	push   %ebp
  8015bc:	89 e5                	mov    %esp,%ebp
  8015be:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8015c1:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8015c6:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  8015cc:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8015d2:	8b 52 50             	mov    0x50(%edx),%edx
  8015d5:	39 ca                	cmp    %ecx,%edx
  8015d7:	74 11                	je     8015ea <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  8015d9:	83 c0 01             	add    $0x1,%eax
  8015dc:	3d 00 04 00 00       	cmp    $0x400,%eax
  8015e1:	75 e3                	jne    8015c6 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8015e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8015e8:	eb 0e                	jmp    8015f8 <ipc_find_env+0x3d>
			return envs[i].env_id;
  8015ea:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8015f0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8015f5:	8b 40 48             	mov    0x48(%eax),%eax
}
  8015f8:	5d                   	pop    %ebp
  8015f9:	c3                   	ret    

008015fa <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8015fa:	55                   	push   %ebp
  8015fb:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8015fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801600:	05 00 00 00 30       	add    $0x30000000,%eax
  801605:	c1 e8 0c             	shr    $0xc,%eax
}
  801608:	5d                   	pop    %ebp
  801609:	c3                   	ret    

0080160a <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80160a:	55                   	push   %ebp
  80160b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80160d:	8b 45 08             	mov    0x8(%ebp),%eax
  801610:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801615:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80161a:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80161f:	5d                   	pop    %ebp
  801620:	c3                   	ret    

00801621 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801621:	55                   	push   %ebp
  801622:	89 e5                	mov    %esp,%ebp
  801624:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801629:	89 c2                	mov    %eax,%edx
  80162b:	c1 ea 16             	shr    $0x16,%edx
  80162e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801635:	f6 c2 01             	test   $0x1,%dl
  801638:	74 2d                	je     801667 <fd_alloc+0x46>
  80163a:	89 c2                	mov    %eax,%edx
  80163c:	c1 ea 0c             	shr    $0xc,%edx
  80163f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801646:	f6 c2 01             	test   $0x1,%dl
  801649:	74 1c                	je     801667 <fd_alloc+0x46>
  80164b:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801650:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801655:	75 d2                	jne    801629 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801657:	8b 45 08             	mov    0x8(%ebp),%eax
  80165a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801660:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801665:	eb 0a                	jmp    801671 <fd_alloc+0x50>
			*fd_store = fd;
  801667:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80166a:	89 01                	mov    %eax,(%ecx)
			return 0;
  80166c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801671:	5d                   	pop    %ebp
  801672:	c3                   	ret    

00801673 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801673:	55                   	push   %ebp
  801674:	89 e5                	mov    %esp,%ebp
  801676:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801679:	83 f8 1f             	cmp    $0x1f,%eax
  80167c:	77 30                	ja     8016ae <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80167e:	c1 e0 0c             	shl    $0xc,%eax
  801681:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801686:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80168c:	f6 c2 01             	test   $0x1,%dl
  80168f:	74 24                	je     8016b5 <fd_lookup+0x42>
  801691:	89 c2                	mov    %eax,%edx
  801693:	c1 ea 0c             	shr    $0xc,%edx
  801696:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80169d:	f6 c2 01             	test   $0x1,%dl
  8016a0:	74 1a                	je     8016bc <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8016a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a5:	89 02                	mov    %eax,(%edx)
	return 0;
  8016a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016ac:	5d                   	pop    %ebp
  8016ad:	c3                   	ret    
		return -E_INVAL;
  8016ae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016b3:	eb f7                	jmp    8016ac <fd_lookup+0x39>
		return -E_INVAL;
  8016b5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016ba:	eb f0                	jmp    8016ac <fd_lookup+0x39>
  8016bc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016c1:	eb e9                	jmp    8016ac <fd_lookup+0x39>

008016c3 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8016c3:	55                   	push   %ebp
  8016c4:	89 e5                	mov    %esp,%ebp
  8016c6:	83 ec 08             	sub    $0x8,%esp
  8016c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016cc:	ba 48 2d 80 00       	mov    $0x802d48,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8016d1:	b8 08 30 80 00       	mov    $0x803008,%eax
		if (devtab[i]->dev_id == dev_id) {
  8016d6:	39 08                	cmp    %ecx,(%eax)
  8016d8:	74 33                	je     80170d <dev_lookup+0x4a>
  8016da:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8016dd:	8b 02                	mov    (%edx),%eax
  8016df:	85 c0                	test   %eax,%eax
  8016e1:	75 f3                	jne    8016d6 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8016e3:	a1 04 40 80 00       	mov    0x804004,%eax
  8016e8:	8b 40 48             	mov    0x48(%eax),%eax
  8016eb:	83 ec 04             	sub    $0x4,%esp
  8016ee:	51                   	push   %ecx
  8016ef:	50                   	push   %eax
  8016f0:	68 c8 2c 80 00       	push   $0x802cc8
  8016f5:	e8 c1 f0 ff ff       	call   8007bb <cprintf>
	*dev = 0;
  8016fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016fd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801703:	83 c4 10             	add    $0x10,%esp
  801706:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80170b:	c9                   	leave  
  80170c:	c3                   	ret    
			*dev = devtab[i];
  80170d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801710:	89 01                	mov    %eax,(%ecx)
			return 0;
  801712:	b8 00 00 00 00       	mov    $0x0,%eax
  801717:	eb f2                	jmp    80170b <dev_lookup+0x48>

00801719 <fd_close>:
{
  801719:	55                   	push   %ebp
  80171a:	89 e5                	mov    %esp,%ebp
  80171c:	57                   	push   %edi
  80171d:	56                   	push   %esi
  80171e:	53                   	push   %ebx
  80171f:	83 ec 24             	sub    $0x24,%esp
  801722:	8b 75 08             	mov    0x8(%ebp),%esi
  801725:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801728:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80172b:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80172c:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801732:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801735:	50                   	push   %eax
  801736:	e8 38 ff ff ff       	call   801673 <fd_lookup>
  80173b:	89 c3                	mov    %eax,%ebx
  80173d:	83 c4 10             	add    $0x10,%esp
  801740:	85 c0                	test   %eax,%eax
  801742:	78 05                	js     801749 <fd_close+0x30>
	    || fd != fd2)
  801744:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801747:	74 16                	je     80175f <fd_close+0x46>
		return (must_exist ? r : 0);
  801749:	89 f8                	mov    %edi,%eax
  80174b:	84 c0                	test   %al,%al
  80174d:	b8 00 00 00 00       	mov    $0x0,%eax
  801752:	0f 44 d8             	cmove  %eax,%ebx
}
  801755:	89 d8                	mov    %ebx,%eax
  801757:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80175a:	5b                   	pop    %ebx
  80175b:	5e                   	pop    %esi
  80175c:	5f                   	pop    %edi
  80175d:	5d                   	pop    %ebp
  80175e:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80175f:	83 ec 08             	sub    $0x8,%esp
  801762:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801765:	50                   	push   %eax
  801766:	ff 36                	pushl  (%esi)
  801768:	e8 56 ff ff ff       	call   8016c3 <dev_lookup>
  80176d:	89 c3                	mov    %eax,%ebx
  80176f:	83 c4 10             	add    $0x10,%esp
  801772:	85 c0                	test   %eax,%eax
  801774:	78 1a                	js     801790 <fd_close+0x77>
		if (dev->dev_close)
  801776:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801779:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80177c:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801781:	85 c0                	test   %eax,%eax
  801783:	74 0b                	je     801790 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801785:	83 ec 0c             	sub    $0xc,%esp
  801788:	56                   	push   %esi
  801789:	ff d0                	call   *%eax
  80178b:	89 c3                	mov    %eax,%ebx
  80178d:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801790:	83 ec 08             	sub    $0x8,%esp
  801793:	56                   	push   %esi
  801794:	6a 00                	push   $0x0
  801796:	e8 bd fb ff ff       	call   801358 <sys_page_unmap>
	return r;
  80179b:	83 c4 10             	add    $0x10,%esp
  80179e:	eb b5                	jmp    801755 <fd_close+0x3c>

008017a0 <close>:

int
close(int fdnum)
{
  8017a0:	55                   	push   %ebp
  8017a1:	89 e5                	mov    %esp,%ebp
  8017a3:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017a9:	50                   	push   %eax
  8017aa:	ff 75 08             	pushl  0x8(%ebp)
  8017ad:	e8 c1 fe ff ff       	call   801673 <fd_lookup>
  8017b2:	83 c4 10             	add    $0x10,%esp
  8017b5:	85 c0                	test   %eax,%eax
  8017b7:	79 02                	jns    8017bb <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8017b9:	c9                   	leave  
  8017ba:	c3                   	ret    
		return fd_close(fd, 1);
  8017bb:	83 ec 08             	sub    $0x8,%esp
  8017be:	6a 01                	push   $0x1
  8017c0:	ff 75 f4             	pushl  -0xc(%ebp)
  8017c3:	e8 51 ff ff ff       	call   801719 <fd_close>
  8017c8:	83 c4 10             	add    $0x10,%esp
  8017cb:	eb ec                	jmp    8017b9 <close+0x19>

008017cd <close_all>:

void
close_all(void)
{
  8017cd:	55                   	push   %ebp
  8017ce:	89 e5                	mov    %esp,%ebp
  8017d0:	53                   	push   %ebx
  8017d1:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8017d4:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8017d9:	83 ec 0c             	sub    $0xc,%esp
  8017dc:	53                   	push   %ebx
  8017dd:	e8 be ff ff ff       	call   8017a0 <close>
	for (i = 0; i < MAXFD; i++)
  8017e2:	83 c3 01             	add    $0x1,%ebx
  8017e5:	83 c4 10             	add    $0x10,%esp
  8017e8:	83 fb 20             	cmp    $0x20,%ebx
  8017eb:	75 ec                	jne    8017d9 <close_all+0xc>
}
  8017ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017f0:	c9                   	leave  
  8017f1:	c3                   	ret    

008017f2 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8017f2:	55                   	push   %ebp
  8017f3:	89 e5                	mov    %esp,%ebp
  8017f5:	57                   	push   %edi
  8017f6:	56                   	push   %esi
  8017f7:	53                   	push   %ebx
  8017f8:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8017fb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8017fe:	50                   	push   %eax
  8017ff:	ff 75 08             	pushl  0x8(%ebp)
  801802:	e8 6c fe ff ff       	call   801673 <fd_lookup>
  801807:	89 c3                	mov    %eax,%ebx
  801809:	83 c4 10             	add    $0x10,%esp
  80180c:	85 c0                	test   %eax,%eax
  80180e:	0f 88 81 00 00 00    	js     801895 <dup+0xa3>
		return r;
	close(newfdnum);
  801814:	83 ec 0c             	sub    $0xc,%esp
  801817:	ff 75 0c             	pushl  0xc(%ebp)
  80181a:	e8 81 ff ff ff       	call   8017a0 <close>

	newfd = INDEX2FD(newfdnum);
  80181f:	8b 75 0c             	mov    0xc(%ebp),%esi
  801822:	c1 e6 0c             	shl    $0xc,%esi
  801825:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80182b:	83 c4 04             	add    $0x4,%esp
  80182e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801831:	e8 d4 fd ff ff       	call   80160a <fd2data>
  801836:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801838:	89 34 24             	mov    %esi,(%esp)
  80183b:	e8 ca fd ff ff       	call   80160a <fd2data>
  801840:	83 c4 10             	add    $0x10,%esp
  801843:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801845:	89 d8                	mov    %ebx,%eax
  801847:	c1 e8 16             	shr    $0x16,%eax
  80184a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801851:	a8 01                	test   $0x1,%al
  801853:	74 11                	je     801866 <dup+0x74>
  801855:	89 d8                	mov    %ebx,%eax
  801857:	c1 e8 0c             	shr    $0xc,%eax
  80185a:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801861:	f6 c2 01             	test   $0x1,%dl
  801864:	75 39                	jne    80189f <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801866:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801869:	89 d0                	mov    %edx,%eax
  80186b:	c1 e8 0c             	shr    $0xc,%eax
  80186e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801875:	83 ec 0c             	sub    $0xc,%esp
  801878:	25 07 0e 00 00       	and    $0xe07,%eax
  80187d:	50                   	push   %eax
  80187e:	56                   	push   %esi
  80187f:	6a 00                	push   $0x0
  801881:	52                   	push   %edx
  801882:	6a 00                	push   $0x0
  801884:	e8 8d fa ff ff       	call   801316 <sys_page_map>
  801889:	89 c3                	mov    %eax,%ebx
  80188b:	83 c4 20             	add    $0x20,%esp
  80188e:	85 c0                	test   %eax,%eax
  801890:	78 31                	js     8018c3 <dup+0xd1>
		goto err;

	return newfdnum;
  801892:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801895:	89 d8                	mov    %ebx,%eax
  801897:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80189a:	5b                   	pop    %ebx
  80189b:	5e                   	pop    %esi
  80189c:	5f                   	pop    %edi
  80189d:	5d                   	pop    %ebp
  80189e:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80189f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8018a6:	83 ec 0c             	sub    $0xc,%esp
  8018a9:	25 07 0e 00 00       	and    $0xe07,%eax
  8018ae:	50                   	push   %eax
  8018af:	57                   	push   %edi
  8018b0:	6a 00                	push   $0x0
  8018b2:	53                   	push   %ebx
  8018b3:	6a 00                	push   $0x0
  8018b5:	e8 5c fa ff ff       	call   801316 <sys_page_map>
  8018ba:	89 c3                	mov    %eax,%ebx
  8018bc:	83 c4 20             	add    $0x20,%esp
  8018bf:	85 c0                	test   %eax,%eax
  8018c1:	79 a3                	jns    801866 <dup+0x74>
	sys_page_unmap(0, newfd);
  8018c3:	83 ec 08             	sub    $0x8,%esp
  8018c6:	56                   	push   %esi
  8018c7:	6a 00                	push   $0x0
  8018c9:	e8 8a fa ff ff       	call   801358 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8018ce:	83 c4 08             	add    $0x8,%esp
  8018d1:	57                   	push   %edi
  8018d2:	6a 00                	push   $0x0
  8018d4:	e8 7f fa ff ff       	call   801358 <sys_page_unmap>
	return r;
  8018d9:	83 c4 10             	add    $0x10,%esp
  8018dc:	eb b7                	jmp    801895 <dup+0xa3>

008018de <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8018de:	55                   	push   %ebp
  8018df:	89 e5                	mov    %esp,%ebp
  8018e1:	53                   	push   %ebx
  8018e2:	83 ec 1c             	sub    $0x1c,%esp
  8018e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018e8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018eb:	50                   	push   %eax
  8018ec:	53                   	push   %ebx
  8018ed:	e8 81 fd ff ff       	call   801673 <fd_lookup>
  8018f2:	83 c4 10             	add    $0x10,%esp
  8018f5:	85 c0                	test   %eax,%eax
  8018f7:	78 3f                	js     801938 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018f9:	83 ec 08             	sub    $0x8,%esp
  8018fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018ff:	50                   	push   %eax
  801900:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801903:	ff 30                	pushl  (%eax)
  801905:	e8 b9 fd ff ff       	call   8016c3 <dev_lookup>
  80190a:	83 c4 10             	add    $0x10,%esp
  80190d:	85 c0                	test   %eax,%eax
  80190f:	78 27                	js     801938 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801911:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801914:	8b 42 08             	mov    0x8(%edx),%eax
  801917:	83 e0 03             	and    $0x3,%eax
  80191a:	83 f8 01             	cmp    $0x1,%eax
  80191d:	74 1e                	je     80193d <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80191f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801922:	8b 40 08             	mov    0x8(%eax),%eax
  801925:	85 c0                	test   %eax,%eax
  801927:	74 35                	je     80195e <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801929:	83 ec 04             	sub    $0x4,%esp
  80192c:	ff 75 10             	pushl  0x10(%ebp)
  80192f:	ff 75 0c             	pushl  0xc(%ebp)
  801932:	52                   	push   %edx
  801933:	ff d0                	call   *%eax
  801935:	83 c4 10             	add    $0x10,%esp
}
  801938:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80193b:	c9                   	leave  
  80193c:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80193d:	a1 04 40 80 00       	mov    0x804004,%eax
  801942:	8b 40 48             	mov    0x48(%eax),%eax
  801945:	83 ec 04             	sub    $0x4,%esp
  801948:	53                   	push   %ebx
  801949:	50                   	push   %eax
  80194a:	68 0c 2d 80 00       	push   $0x802d0c
  80194f:	e8 67 ee ff ff       	call   8007bb <cprintf>
		return -E_INVAL;
  801954:	83 c4 10             	add    $0x10,%esp
  801957:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80195c:	eb da                	jmp    801938 <read+0x5a>
		return -E_NOT_SUPP;
  80195e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801963:	eb d3                	jmp    801938 <read+0x5a>

00801965 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801965:	55                   	push   %ebp
  801966:	89 e5                	mov    %esp,%ebp
  801968:	57                   	push   %edi
  801969:	56                   	push   %esi
  80196a:	53                   	push   %ebx
  80196b:	83 ec 0c             	sub    $0xc,%esp
  80196e:	8b 7d 08             	mov    0x8(%ebp),%edi
  801971:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801974:	bb 00 00 00 00       	mov    $0x0,%ebx
  801979:	39 f3                	cmp    %esi,%ebx
  80197b:	73 23                	jae    8019a0 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80197d:	83 ec 04             	sub    $0x4,%esp
  801980:	89 f0                	mov    %esi,%eax
  801982:	29 d8                	sub    %ebx,%eax
  801984:	50                   	push   %eax
  801985:	89 d8                	mov    %ebx,%eax
  801987:	03 45 0c             	add    0xc(%ebp),%eax
  80198a:	50                   	push   %eax
  80198b:	57                   	push   %edi
  80198c:	e8 4d ff ff ff       	call   8018de <read>
		if (m < 0)
  801991:	83 c4 10             	add    $0x10,%esp
  801994:	85 c0                	test   %eax,%eax
  801996:	78 06                	js     80199e <readn+0x39>
			return m;
		if (m == 0)
  801998:	74 06                	je     8019a0 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  80199a:	01 c3                	add    %eax,%ebx
  80199c:	eb db                	jmp    801979 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80199e:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8019a0:	89 d8                	mov    %ebx,%eax
  8019a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019a5:	5b                   	pop    %ebx
  8019a6:	5e                   	pop    %esi
  8019a7:	5f                   	pop    %edi
  8019a8:	5d                   	pop    %ebp
  8019a9:	c3                   	ret    

008019aa <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8019aa:	55                   	push   %ebp
  8019ab:	89 e5                	mov    %esp,%ebp
  8019ad:	53                   	push   %ebx
  8019ae:	83 ec 1c             	sub    $0x1c,%esp
  8019b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019b4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019b7:	50                   	push   %eax
  8019b8:	53                   	push   %ebx
  8019b9:	e8 b5 fc ff ff       	call   801673 <fd_lookup>
  8019be:	83 c4 10             	add    $0x10,%esp
  8019c1:	85 c0                	test   %eax,%eax
  8019c3:	78 3a                	js     8019ff <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019c5:	83 ec 08             	sub    $0x8,%esp
  8019c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019cb:	50                   	push   %eax
  8019cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019cf:	ff 30                	pushl  (%eax)
  8019d1:	e8 ed fc ff ff       	call   8016c3 <dev_lookup>
  8019d6:	83 c4 10             	add    $0x10,%esp
  8019d9:	85 c0                	test   %eax,%eax
  8019db:	78 22                	js     8019ff <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8019dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019e0:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8019e4:	74 1e                	je     801a04 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8019e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019e9:	8b 52 0c             	mov    0xc(%edx),%edx
  8019ec:	85 d2                	test   %edx,%edx
  8019ee:	74 35                	je     801a25 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8019f0:	83 ec 04             	sub    $0x4,%esp
  8019f3:	ff 75 10             	pushl  0x10(%ebp)
  8019f6:	ff 75 0c             	pushl  0xc(%ebp)
  8019f9:	50                   	push   %eax
  8019fa:	ff d2                	call   *%edx
  8019fc:	83 c4 10             	add    $0x10,%esp
}
  8019ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a02:	c9                   	leave  
  801a03:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801a04:	a1 04 40 80 00       	mov    0x804004,%eax
  801a09:	8b 40 48             	mov    0x48(%eax),%eax
  801a0c:	83 ec 04             	sub    $0x4,%esp
  801a0f:	53                   	push   %ebx
  801a10:	50                   	push   %eax
  801a11:	68 28 2d 80 00       	push   $0x802d28
  801a16:	e8 a0 ed ff ff       	call   8007bb <cprintf>
		return -E_INVAL;
  801a1b:	83 c4 10             	add    $0x10,%esp
  801a1e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a23:	eb da                	jmp    8019ff <write+0x55>
		return -E_NOT_SUPP;
  801a25:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a2a:	eb d3                	jmp    8019ff <write+0x55>

00801a2c <seek>:

int
seek(int fdnum, off_t offset)
{
  801a2c:	55                   	push   %ebp
  801a2d:	89 e5                	mov    %esp,%ebp
  801a2f:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a32:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a35:	50                   	push   %eax
  801a36:	ff 75 08             	pushl  0x8(%ebp)
  801a39:	e8 35 fc ff ff       	call   801673 <fd_lookup>
  801a3e:	83 c4 10             	add    $0x10,%esp
  801a41:	85 c0                	test   %eax,%eax
  801a43:	78 0e                	js     801a53 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801a45:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a4b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801a4e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a53:	c9                   	leave  
  801a54:	c3                   	ret    

00801a55 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801a55:	55                   	push   %ebp
  801a56:	89 e5                	mov    %esp,%ebp
  801a58:	53                   	push   %ebx
  801a59:	83 ec 1c             	sub    $0x1c,%esp
  801a5c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a5f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a62:	50                   	push   %eax
  801a63:	53                   	push   %ebx
  801a64:	e8 0a fc ff ff       	call   801673 <fd_lookup>
  801a69:	83 c4 10             	add    $0x10,%esp
  801a6c:	85 c0                	test   %eax,%eax
  801a6e:	78 37                	js     801aa7 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a70:	83 ec 08             	sub    $0x8,%esp
  801a73:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a76:	50                   	push   %eax
  801a77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a7a:	ff 30                	pushl  (%eax)
  801a7c:	e8 42 fc ff ff       	call   8016c3 <dev_lookup>
  801a81:	83 c4 10             	add    $0x10,%esp
  801a84:	85 c0                	test   %eax,%eax
  801a86:	78 1f                	js     801aa7 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a8b:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a8f:	74 1b                	je     801aac <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801a91:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a94:	8b 52 18             	mov    0x18(%edx),%edx
  801a97:	85 d2                	test   %edx,%edx
  801a99:	74 32                	je     801acd <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801a9b:	83 ec 08             	sub    $0x8,%esp
  801a9e:	ff 75 0c             	pushl  0xc(%ebp)
  801aa1:	50                   	push   %eax
  801aa2:	ff d2                	call   *%edx
  801aa4:	83 c4 10             	add    $0x10,%esp
}
  801aa7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801aaa:	c9                   	leave  
  801aab:	c3                   	ret    
			thisenv->env_id, fdnum);
  801aac:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801ab1:	8b 40 48             	mov    0x48(%eax),%eax
  801ab4:	83 ec 04             	sub    $0x4,%esp
  801ab7:	53                   	push   %ebx
  801ab8:	50                   	push   %eax
  801ab9:	68 e8 2c 80 00       	push   $0x802ce8
  801abe:	e8 f8 ec ff ff       	call   8007bb <cprintf>
		return -E_INVAL;
  801ac3:	83 c4 10             	add    $0x10,%esp
  801ac6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801acb:	eb da                	jmp    801aa7 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801acd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ad2:	eb d3                	jmp    801aa7 <ftruncate+0x52>

00801ad4 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801ad4:	55                   	push   %ebp
  801ad5:	89 e5                	mov    %esp,%ebp
  801ad7:	53                   	push   %ebx
  801ad8:	83 ec 1c             	sub    $0x1c,%esp
  801adb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801ade:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ae1:	50                   	push   %eax
  801ae2:	ff 75 08             	pushl  0x8(%ebp)
  801ae5:	e8 89 fb ff ff       	call   801673 <fd_lookup>
  801aea:	83 c4 10             	add    $0x10,%esp
  801aed:	85 c0                	test   %eax,%eax
  801aef:	78 4b                	js     801b3c <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801af1:	83 ec 08             	sub    $0x8,%esp
  801af4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801af7:	50                   	push   %eax
  801af8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801afb:	ff 30                	pushl  (%eax)
  801afd:	e8 c1 fb ff ff       	call   8016c3 <dev_lookup>
  801b02:	83 c4 10             	add    $0x10,%esp
  801b05:	85 c0                	test   %eax,%eax
  801b07:	78 33                	js     801b3c <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801b09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b0c:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801b10:	74 2f                	je     801b41 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801b12:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801b15:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801b1c:	00 00 00 
	stat->st_isdir = 0;
  801b1f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b26:	00 00 00 
	stat->st_dev = dev;
  801b29:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801b2f:	83 ec 08             	sub    $0x8,%esp
  801b32:	53                   	push   %ebx
  801b33:	ff 75 f0             	pushl  -0x10(%ebp)
  801b36:	ff 50 14             	call   *0x14(%eax)
  801b39:	83 c4 10             	add    $0x10,%esp
}
  801b3c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b3f:	c9                   	leave  
  801b40:	c3                   	ret    
		return -E_NOT_SUPP;
  801b41:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b46:	eb f4                	jmp    801b3c <fstat+0x68>

00801b48 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801b48:	55                   	push   %ebp
  801b49:	89 e5                	mov    %esp,%ebp
  801b4b:	56                   	push   %esi
  801b4c:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801b4d:	83 ec 08             	sub    $0x8,%esp
  801b50:	6a 00                	push   $0x0
  801b52:	ff 75 08             	pushl  0x8(%ebp)
  801b55:	e8 bb 01 00 00       	call   801d15 <open>
  801b5a:	89 c3                	mov    %eax,%ebx
  801b5c:	83 c4 10             	add    $0x10,%esp
  801b5f:	85 c0                	test   %eax,%eax
  801b61:	78 1b                	js     801b7e <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801b63:	83 ec 08             	sub    $0x8,%esp
  801b66:	ff 75 0c             	pushl  0xc(%ebp)
  801b69:	50                   	push   %eax
  801b6a:	e8 65 ff ff ff       	call   801ad4 <fstat>
  801b6f:	89 c6                	mov    %eax,%esi
	close(fd);
  801b71:	89 1c 24             	mov    %ebx,(%esp)
  801b74:	e8 27 fc ff ff       	call   8017a0 <close>
	return r;
  801b79:	83 c4 10             	add    $0x10,%esp
  801b7c:	89 f3                	mov    %esi,%ebx
}
  801b7e:	89 d8                	mov    %ebx,%eax
  801b80:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b83:	5b                   	pop    %ebx
  801b84:	5e                   	pop    %esi
  801b85:	5d                   	pop    %ebp
  801b86:	c3                   	ret    

00801b87 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801b87:	55                   	push   %ebp
  801b88:	89 e5                	mov    %esp,%ebp
  801b8a:	56                   	push   %esi
  801b8b:	53                   	push   %ebx
  801b8c:	89 c6                	mov    %eax,%esi
  801b8e:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801b90:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801b97:	74 27                	je     801bc0 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801b99:	6a 07                	push   $0x7
  801b9b:	68 00 50 80 00       	push   $0x805000
  801ba0:	56                   	push   %esi
  801ba1:	ff 35 00 40 80 00    	pushl  0x804000
  801ba7:	e8 c2 f9 ff ff       	call   80156e <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801bac:	83 c4 0c             	add    $0xc,%esp
  801baf:	6a 00                	push   $0x0
  801bb1:	53                   	push   %ebx
  801bb2:	6a 00                	push   $0x0
  801bb4:	e8 4c f9 ff ff       	call   801505 <ipc_recv>
}
  801bb9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bbc:	5b                   	pop    %ebx
  801bbd:	5e                   	pop    %esi
  801bbe:	5d                   	pop    %ebp
  801bbf:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801bc0:	83 ec 0c             	sub    $0xc,%esp
  801bc3:	6a 01                	push   $0x1
  801bc5:	e8 f1 f9 ff ff       	call   8015bb <ipc_find_env>
  801bca:	a3 00 40 80 00       	mov    %eax,0x804000
  801bcf:	83 c4 10             	add    $0x10,%esp
  801bd2:	eb c5                	jmp    801b99 <fsipc+0x12>

00801bd4 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801bd4:	55                   	push   %ebp
  801bd5:	89 e5                	mov    %esp,%ebp
  801bd7:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801bda:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdd:	8b 40 0c             	mov    0xc(%eax),%eax
  801be0:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801be5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801be8:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801bed:	ba 00 00 00 00       	mov    $0x0,%edx
  801bf2:	b8 02 00 00 00       	mov    $0x2,%eax
  801bf7:	e8 8b ff ff ff       	call   801b87 <fsipc>
}
  801bfc:	c9                   	leave  
  801bfd:	c3                   	ret    

00801bfe <devfile_flush>:
{
  801bfe:	55                   	push   %ebp
  801bff:	89 e5                	mov    %esp,%ebp
  801c01:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801c04:	8b 45 08             	mov    0x8(%ebp),%eax
  801c07:	8b 40 0c             	mov    0xc(%eax),%eax
  801c0a:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801c0f:	ba 00 00 00 00       	mov    $0x0,%edx
  801c14:	b8 06 00 00 00       	mov    $0x6,%eax
  801c19:	e8 69 ff ff ff       	call   801b87 <fsipc>
}
  801c1e:	c9                   	leave  
  801c1f:	c3                   	ret    

00801c20 <devfile_stat>:
{
  801c20:	55                   	push   %ebp
  801c21:	89 e5                	mov    %esp,%ebp
  801c23:	53                   	push   %ebx
  801c24:	83 ec 04             	sub    $0x4,%esp
  801c27:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2d:	8b 40 0c             	mov    0xc(%eax),%eax
  801c30:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801c35:	ba 00 00 00 00       	mov    $0x0,%edx
  801c3a:	b8 05 00 00 00       	mov    $0x5,%eax
  801c3f:	e8 43 ff ff ff       	call   801b87 <fsipc>
  801c44:	85 c0                	test   %eax,%eax
  801c46:	78 2c                	js     801c74 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801c48:	83 ec 08             	sub    $0x8,%esp
  801c4b:	68 00 50 80 00       	push   $0x805000
  801c50:	53                   	push   %ebx
  801c51:	e8 8b f2 ff ff       	call   800ee1 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801c56:	a1 80 50 80 00       	mov    0x805080,%eax
  801c5b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801c61:	a1 84 50 80 00       	mov    0x805084,%eax
  801c66:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801c6c:	83 c4 10             	add    $0x10,%esp
  801c6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c74:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c77:	c9                   	leave  
  801c78:	c3                   	ret    

00801c79 <devfile_write>:
{
  801c79:	55                   	push   %ebp
  801c7a:	89 e5                	mov    %esp,%ebp
  801c7c:	83 ec 0c             	sub    $0xc,%esp
	panic("devfile_write not implemented");
  801c7f:	68 58 2d 80 00       	push   $0x802d58
  801c84:	68 90 00 00 00       	push   $0x90
  801c89:	68 76 2d 80 00       	push   $0x802d76
  801c8e:	e8 4d ea ff ff       	call   8006e0 <_panic>

00801c93 <devfile_read>:
{
  801c93:	55                   	push   %ebp
  801c94:	89 e5                	mov    %esp,%ebp
  801c96:	56                   	push   %esi
  801c97:	53                   	push   %ebx
  801c98:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9e:	8b 40 0c             	mov    0xc(%eax),%eax
  801ca1:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801ca6:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801cac:	ba 00 00 00 00       	mov    $0x0,%edx
  801cb1:	b8 03 00 00 00       	mov    $0x3,%eax
  801cb6:	e8 cc fe ff ff       	call   801b87 <fsipc>
  801cbb:	89 c3                	mov    %eax,%ebx
  801cbd:	85 c0                	test   %eax,%eax
  801cbf:	78 1f                	js     801ce0 <devfile_read+0x4d>
	assert(r <= n);
  801cc1:	39 f0                	cmp    %esi,%eax
  801cc3:	77 24                	ja     801ce9 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801cc5:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801cca:	7f 33                	jg     801cff <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801ccc:	83 ec 04             	sub    $0x4,%esp
  801ccf:	50                   	push   %eax
  801cd0:	68 00 50 80 00       	push   $0x805000
  801cd5:	ff 75 0c             	pushl  0xc(%ebp)
  801cd8:	e8 92 f3 ff ff       	call   80106f <memmove>
	return r;
  801cdd:	83 c4 10             	add    $0x10,%esp
}
  801ce0:	89 d8                	mov    %ebx,%eax
  801ce2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ce5:	5b                   	pop    %ebx
  801ce6:	5e                   	pop    %esi
  801ce7:	5d                   	pop    %ebp
  801ce8:	c3                   	ret    
	assert(r <= n);
  801ce9:	68 81 2d 80 00       	push   $0x802d81
  801cee:	68 88 2d 80 00       	push   $0x802d88
  801cf3:	6a 7c                	push   $0x7c
  801cf5:	68 76 2d 80 00       	push   $0x802d76
  801cfa:	e8 e1 e9 ff ff       	call   8006e0 <_panic>
	assert(r <= PGSIZE);
  801cff:	68 9d 2d 80 00       	push   $0x802d9d
  801d04:	68 88 2d 80 00       	push   $0x802d88
  801d09:	6a 7d                	push   $0x7d
  801d0b:	68 76 2d 80 00       	push   $0x802d76
  801d10:	e8 cb e9 ff ff       	call   8006e0 <_panic>

00801d15 <open>:
{
  801d15:	55                   	push   %ebp
  801d16:	89 e5                	mov    %esp,%ebp
  801d18:	56                   	push   %esi
  801d19:	53                   	push   %ebx
  801d1a:	83 ec 1c             	sub    $0x1c,%esp
  801d1d:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801d20:	56                   	push   %esi
  801d21:	e8 82 f1 ff ff       	call   800ea8 <strlen>
  801d26:	83 c4 10             	add    $0x10,%esp
  801d29:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801d2e:	7f 6c                	jg     801d9c <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801d30:	83 ec 0c             	sub    $0xc,%esp
  801d33:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d36:	50                   	push   %eax
  801d37:	e8 e5 f8 ff ff       	call   801621 <fd_alloc>
  801d3c:	89 c3                	mov    %eax,%ebx
  801d3e:	83 c4 10             	add    $0x10,%esp
  801d41:	85 c0                	test   %eax,%eax
  801d43:	78 3c                	js     801d81 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801d45:	83 ec 08             	sub    $0x8,%esp
  801d48:	56                   	push   %esi
  801d49:	68 00 50 80 00       	push   $0x805000
  801d4e:	e8 8e f1 ff ff       	call   800ee1 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801d53:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d56:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801d5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d5e:	b8 01 00 00 00       	mov    $0x1,%eax
  801d63:	e8 1f fe ff ff       	call   801b87 <fsipc>
  801d68:	89 c3                	mov    %eax,%ebx
  801d6a:	83 c4 10             	add    $0x10,%esp
  801d6d:	85 c0                	test   %eax,%eax
  801d6f:	78 19                	js     801d8a <open+0x75>
	return fd2num(fd);
  801d71:	83 ec 0c             	sub    $0xc,%esp
  801d74:	ff 75 f4             	pushl  -0xc(%ebp)
  801d77:	e8 7e f8 ff ff       	call   8015fa <fd2num>
  801d7c:	89 c3                	mov    %eax,%ebx
  801d7e:	83 c4 10             	add    $0x10,%esp
}
  801d81:	89 d8                	mov    %ebx,%eax
  801d83:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d86:	5b                   	pop    %ebx
  801d87:	5e                   	pop    %esi
  801d88:	5d                   	pop    %ebp
  801d89:	c3                   	ret    
		fd_close(fd, 0);
  801d8a:	83 ec 08             	sub    $0x8,%esp
  801d8d:	6a 00                	push   $0x0
  801d8f:	ff 75 f4             	pushl  -0xc(%ebp)
  801d92:	e8 82 f9 ff ff       	call   801719 <fd_close>
		return r;
  801d97:	83 c4 10             	add    $0x10,%esp
  801d9a:	eb e5                	jmp    801d81 <open+0x6c>
		return -E_BAD_PATH;
  801d9c:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801da1:	eb de                	jmp    801d81 <open+0x6c>

00801da3 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801da3:	55                   	push   %ebp
  801da4:	89 e5                	mov    %esp,%ebp
  801da6:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801da9:	ba 00 00 00 00       	mov    $0x0,%edx
  801dae:	b8 08 00 00 00       	mov    $0x8,%eax
  801db3:	e8 cf fd ff ff       	call   801b87 <fsipc>
}
  801db8:	c9                   	leave  
  801db9:	c3                   	ret    

00801dba <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801dba:	55                   	push   %ebp
  801dbb:	89 e5                	mov    %esp,%ebp
  801dbd:	56                   	push   %esi
  801dbe:	53                   	push   %ebx
  801dbf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801dc2:	83 ec 0c             	sub    $0xc,%esp
  801dc5:	ff 75 08             	pushl  0x8(%ebp)
  801dc8:	e8 3d f8 ff ff       	call   80160a <fd2data>
  801dcd:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801dcf:	83 c4 08             	add    $0x8,%esp
  801dd2:	68 a9 2d 80 00       	push   $0x802da9
  801dd7:	53                   	push   %ebx
  801dd8:	e8 04 f1 ff ff       	call   800ee1 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801ddd:	8b 46 04             	mov    0x4(%esi),%eax
  801de0:	2b 06                	sub    (%esi),%eax
  801de2:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801de8:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801def:	00 00 00 
	stat->st_dev = &devpipe;
  801df2:	c7 83 88 00 00 00 24 	movl   $0x803024,0x88(%ebx)
  801df9:	30 80 00 
	return 0;
}
  801dfc:	b8 00 00 00 00       	mov    $0x0,%eax
  801e01:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e04:	5b                   	pop    %ebx
  801e05:	5e                   	pop    %esi
  801e06:	5d                   	pop    %ebp
  801e07:	c3                   	ret    

00801e08 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801e08:	55                   	push   %ebp
  801e09:	89 e5                	mov    %esp,%ebp
  801e0b:	53                   	push   %ebx
  801e0c:	83 ec 0c             	sub    $0xc,%esp
  801e0f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801e12:	53                   	push   %ebx
  801e13:	6a 00                	push   $0x0
  801e15:	e8 3e f5 ff ff       	call   801358 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801e1a:	89 1c 24             	mov    %ebx,(%esp)
  801e1d:	e8 e8 f7 ff ff       	call   80160a <fd2data>
  801e22:	83 c4 08             	add    $0x8,%esp
  801e25:	50                   	push   %eax
  801e26:	6a 00                	push   $0x0
  801e28:	e8 2b f5 ff ff       	call   801358 <sys_page_unmap>
}
  801e2d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e30:	c9                   	leave  
  801e31:	c3                   	ret    

00801e32 <_pipeisclosed>:
{
  801e32:	55                   	push   %ebp
  801e33:	89 e5                	mov    %esp,%ebp
  801e35:	57                   	push   %edi
  801e36:	56                   	push   %esi
  801e37:	53                   	push   %ebx
  801e38:	83 ec 1c             	sub    $0x1c,%esp
  801e3b:	89 c7                	mov    %eax,%edi
  801e3d:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801e3f:	a1 04 40 80 00       	mov    0x804004,%eax
  801e44:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801e47:	83 ec 0c             	sub    $0xc,%esp
  801e4a:	57                   	push   %edi
  801e4b:	e8 2d 04 00 00       	call   80227d <pageref>
  801e50:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801e53:	89 34 24             	mov    %esi,(%esp)
  801e56:	e8 22 04 00 00       	call   80227d <pageref>
		nn = thisenv->env_runs;
  801e5b:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801e61:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801e64:	83 c4 10             	add    $0x10,%esp
  801e67:	39 cb                	cmp    %ecx,%ebx
  801e69:	74 1b                	je     801e86 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801e6b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e6e:	75 cf                	jne    801e3f <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801e70:	8b 42 58             	mov    0x58(%edx),%eax
  801e73:	6a 01                	push   $0x1
  801e75:	50                   	push   %eax
  801e76:	53                   	push   %ebx
  801e77:	68 b0 2d 80 00       	push   $0x802db0
  801e7c:	e8 3a e9 ff ff       	call   8007bb <cprintf>
  801e81:	83 c4 10             	add    $0x10,%esp
  801e84:	eb b9                	jmp    801e3f <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801e86:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e89:	0f 94 c0             	sete   %al
  801e8c:	0f b6 c0             	movzbl %al,%eax
}
  801e8f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e92:	5b                   	pop    %ebx
  801e93:	5e                   	pop    %esi
  801e94:	5f                   	pop    %edi
  801e95:	5d                   	pop    %ebp
  801e96:	c3                   	ret    

00801e97 <devpipe_write>:
{
  801e97:	55                   	push   %ebp
  801e98:	89 e5                	mov    %esp,%ebp
  801e9a:	57                   	push   %edi
  801e9b:	56                   	push   %esi
  801e9c:	53                   	push   %ebx
  801e9d:	83 ec 28             	sub    $0x28,%esp
  801ea0:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801ea3:	56                   	push   %esi
  801ea4:	e8 61 f7 ff ff       	call   80160a <fd2data>
  801ea9:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801eab:	83 c4 10             	add    $0x10,%esp
  801eae:	bf 00 00 00 00       	mov    $0x0,%edi
  801eb3:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801eb6:	74 4f                	je     801f07 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801eb8:	8b 43 04             	mov    0x4(%ebx),%eax
  801ebb:	8b 0b                	mov    (%ebx),%ecx
  801ebd:	8d 51 20             	lea    0x20(%ecx),%edx
  801ec0:	39 d0                	cmp    %edx,%eax
  801ec2:	72 14                	jb     801ed8 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801ec4:	89 da                	mov    %ebx,%edx
  801ec6:	89 f0                	mov    %esi,%eax
  801ec8:	e8 65 ff ff ff       	call   801e32 <_pipeisclosed>
  801ecd:	85 c0                	test   %eax,%eax
  801ecf:	75 3b                	jne    801f0c <devpipe_write+0x75>
			sys_yield();
  801ed1:	e8 de f3 ff ff       	call   8012b4 <sys_yield>
  801ed6:	eb e0                	jmp    801eb8 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801ed8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801edb:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801edf:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801ee2:	89 c2                	mov    %eax,%edx
  801ee4:	c1 fa 1f             	sar    $0x1f,%edx
  801ee7:	89 d1                	mov    %edx,%ecx
  801ee9:	c1 e9 1b             	shr    $0x1b,%ecx
  801eec:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801eef:	83 e2 1f             	and    $0x1f,%edx
  801ef2:	29 ca                	sub    %ecx,%edx
  801ef4:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801ef8:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801efc:	83 c0 01             	add    $0x1,%eax
  801eff:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801f02:	83 c7 01             	add    $0x1,%edi
  801f05:	eb ac                	jmp    801eb3 <devpipe_write+0x1c>
	return i;
  801f07:	8b 45 10             	mov    0x10(%ebp),%eax
  801f0a:	eb 05                	jmp    801f11 <devpipe_write+0x7a>
				return 0;
  801f0c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f11:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f14:	5b                   	pop    %ebx
  801f15:	5e                   	pop    %esi
  801f16:	5f                   	pop    %edi
  801f17:	5d                   	pop    %ebp
  801f18:	c3                   	ret    

00801f19 <devpipe_read>:
{
  801f19:	55                   	push   %ebp
  801f1a:	89 e5                	mov    %esp,%ebp
  801f1c:	57                   	push   %edi
  801f1d:	56                   	push   %esi
  801f1e:	53                   	push   %ebx
  801f1f:	83 ec 18             	sub    $0x18,%esp
  801f22:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801f25:	57                   	push   %edi
  801f26:	e8 df f6 ff ff       	call   80160a <fd2data>
  801f2b:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801f2d:	83 c4 10             	add    $0x10,%esp
  801f30:	be 00 00 00 00       	mov    $0x0,%esi
  801f35:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f38:	75 14                	jne    801f4e <devpipe_read+0x35>
	return i;
  801f3a:	8b 45 10             	mov    0x10(%ebp),%eax
  801f3d:	eb 02                	jmp    801f41 <devpipe_read+0x28>
				return i;
  801f3f:	89 f0                	mov    %esi,%eax
}
  801f41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f44:	5b                   	pop    %ebx
  801f45:	5e                   	pop    %esi
  801f46:	5f                   	pop    %edi
  801f47:	5d                   	pop    %ebp
  801f48:	c3                   	ret    
			sys_yield();
  801f49:	e8 66 f3 ff ff       	call   8012b4 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801f4e:	8b 03                	mov    (%ebx),%eax
  801f50:	3b 43 04             	cmp    0x4(%ebx),%eax
  801f53:	75 18                	jne    801f6d <devpipe_read+0x54>
			if (i > 0)
  801f55:	85 f6                	test   %esi,%esi
  801f57:	75 e6                	jne    801f3f <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801f59:	89 da                	mov    %ebx,%edx
  801f5b:	89 f8                	mov    %edi,%eax
  801f5d:	e8 d0 fe ff ff       	call   801e32 <_pipeisclosed>
  801f62:	85 c0                	test   %eax,%eax
  801f64:	74 e3                	je     801f49 <devpipe_read+0x30>
				return 0;
  801f66:	b8 00 00 00 00       	mov    $0x0,%eax
  801f6b:	eb d4                	jmp    801f41 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801f6d:	99                   	cltd   
  801f6e:	c1 ea 1b             	shr    $0x1b,%edx
  801f71:	01 d0                	add    %edx,%eax
  801f73:	83 e0 1f             	and    $0x1f,%eax
  801f76:	29 d0                	sub    %edx,%eax
  801f78:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801f7d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f80:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801f83:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801f86:	83 c6 01             	add    $0x1,%esi
  801f89:	eb aa                	jmp    801f35 <devpipe_read+0x1c>

00801f8b <pipe>:
{
  801f8b:	55                   	push   %ebp
  801f8c:	89 e5                	mov    %esp,%ebp
  801f8e:	56                   	push   %esi
  801f8f:	53                   	push   %ebx
  801f90:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801f93:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f96:	50                   	push   %eax
  801f97:	e8 85 f6 ff ff       	call   801621 <fd_alloc>
  801f9c:	89 c3                	mov    %eax,%ebx
  801f9e:	83 c4 10             	add    $0x10,%esp
  801fa1:	85 c0                	test   %eax,%eax
  801fa3:	0f 88 23 01 00 00    	js     8020cc <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fa9:	83 ec 04             	sub    $0x4,%esp
  801fac:	68 07 04 00 00       	push   $0x407
  801fb1:	ff 75 f4             	pushl  -0xc(%ebp)
  801fb4:	6a 00                	push   $0x0
  801fb6:	e8 18 f3 ff ff       	call   8012d3 <sys_page_alloc>
  801fbb:	89 c3                	mov    %eax,%ebx
  801fbd:	83 c4 10             	add    $0x10,%esp
  801fc0:	85 c0                	test   %eax,%eax
  801fc2:	0f 88 04 01 00 00    	js     8020cc <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801fc8:	83 ec 0c             	sub    $0xc,%esp
  801fcb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801fce:	50                   	push   %eax
  801fcf:	e8 4d f6 ff ff       	call   801621 <fd_alloc>
  801fd4:	89 c3                	mov    %eax,%ebx
  801fd6:	83 c4 10             	add    $0x10,%esp
  801fd9:	85 c0                	test   %eax,%eax
  801fdb:	0f 88 db 00 00 00    	js     8020bc <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fe1:	83 ec 04             	sub    $0x4,%esp
  801fe4:	68 07 04 00 00       	push   $0x407
  801fe9:	ff 75 f0             	pushl  -0x10(%ebp)
  801fec:	6a 00                	push   $0x0
  801fee:	e8 e0 f2 ff ff       	call   8012d3 <sys_page_alloc>
  801ff3:	89 c3                	mov    %eax,%ebx
  801ff5:	83 c4 10             	add    $0x10,%esp
  801ff8:	85 c0                	test   %eax,%eax
  801ffa:	0f 88 bc 00 00 00    	js     8020bc <pipe+0x131>
	va = fd2data(fd0);
  802000:	83 ec 0c             	sub    $0xc,%esp
  802003:	ff 75 f4             	pushl  -0xc(%ebp)
  802006:	e8 ff f5 ff ff       	call   80160a <fd2data>
  80200b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80200d:	83 c4 0c             	add    $0xc,%esp
  802010:	68 07 04 00 00       	push   $0x407
  802015:	50                   	push   %eax
  802016:	6a 00                	push   $0x0
  802018:	e8 b6 f2 ff ff       	call   8012d3 <sys_page_alloc>
  80201d:	89 c3                	mov    %eax,%ebx
  80201f:	83 c4 10             	add    $0x10,%esp
  802022:	85 c0                	test   %eax,%eax
  802024:	0f 88 82 00 00 00    	js     8020ac <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80202a:	83 ec 0c             	sub    $0xc,%esp
  80202d:	ff 75 f0             	pushl  -0x10(%ebp)
  802030:	e8 d5 f5 ff ff       	call   80160a <fd2data>
  802035:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80203c:	50                   	push   %eax
  80203d:	6a 00                	push   $0x0
  80203f:	56                   	push   %esi
  802040:	6a 00                	push   $0x0
  802042:	e8 cf f2 ff ff       	call   801316 <sys_page_map>
  802047:	89 c3                	mov    %eax,%ebx
  802049:	83 c4 20             	add    $0x20,%esp
  80204c:	85 c0                	test   %eax,%eax
  80204e:	78 4e                	js     80209e <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802050:	a1 24 30 80 00       	mov    0x803024,%eax
  802055:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802058:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80205a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80205d:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802064:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802067:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802069:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80206c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802073:	83 ec 0c             	sub    $0xc,%esp
  802076:	ff 75 f4             	pushl  -0xc(%ebp)
  802079:	e8 7c f5 ff ff       	call   8015fa <fd2num>
  80207e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802081:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802083:	83 c4 04             	add    $0x4,%esp
  802086:	ff 75 f0             	pushl  -0x10(%ebp)
  802089:	e8 6c f5 ff ff       	call   8015fa <fd2num>
  80208e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802091:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802094:	83 c4 10             	add    $0x10,%esp
  802097:	bb 00 00 00 00       	mov    $0x0,%ebx
  80209c:	eb 2e                	jmp    8020cc <pipe+0x141>
	sys_page_unmap(0, va);
  80209e:	83 ec 08             	sub    $0x8,%esp
  8020a1:	56                   	push   %esi
  8020a2:	6a 00                	push   $0x0
  8020a4:	e8 af f2 ff ff       	call   801358 <sys_page_unmap>
  8020a9:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8020ac:	83 ec 08             	sub    $0x8,%esp
  8020af:	ff 75 f0             	pushl  -0x10(%ebp)
  8020b2:	6a 00                	push   $0x0
  8020b4:	e8 9f f2 ff ff       	call   801358 <sys_page_unmap>
  8020b9:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8020bc:	83 ec 08             	sub    $0x8,%esp
  8020bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8020c2:	6a 00                	push   $0x0
  8020c4:	e8 8f f2 ff ff       	call   801358 <sys_page_unmap>
  8020c9:	83 c4 10             	add    $0x10,%esp
}
  8020cc:	89 d8                	mov    %ebx,%eax
  8020ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020d1:	5b                   	pop    %ebx
  8020d2:	5e                   	pop    %esi
  8020d3:	5d                   	pop    %ebp
  8020d4:	c3                   	ret    

008020d5 <pipeisclosed>:
{
  8020d5:	55                   	push   %ebp
  8020d6:	89 e5                	mov    %esp,%ebp
  8020d8:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020db:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020de:	50                   	push   %eax
  8020df:	ff 75 08             	pushl  0x8(%ebp)
  8020e2:	e8 8c f5 ff ff       	call   801673 <fd_lookup>
  8020e7:	83 c4 10             	add    $0x10,%esp
  8020ea:	85 c0                	test   %eax,%eax
  8020ec:	78 18                	js     802106 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8020ee:	83 ec 0c             	sub    $0xc,%esp
  8020f1:	ff 75 f4             	pushl  -0xc(%ebp)
  8020f4:	e8 11 f5 ff ff       	call   80160a <fd2data>
	return _pipeisclosed(fd, p);
  8020f9:	89 c2                	mov    %eax,%edx
  8020fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fe:	e8 2f fd ff ff       	call   801e32 <_pipeisclosed>
  802103:	83 c4 10             	add    $0x10,%esp
}
  802106:	c9                   	leave  
  802107:	c3                   	ret    

00802108 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802108:	b8 00 00 00 00       	mov    $0x0,%eax
  80210d:	c3                   	ret    

0080210e <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80210e:	55                   	push   %ebp
  80210f:	89 e5                	mov    %esp,%ebp
  802111:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802114:	68 c8 2d 80 00       	push   $0x802dc8
  802119:	ff 75 0c             	pushl  0xc(%ebp)
  80211c:	e8 c0 ed ff ff       	call   800ee1 <strcpy>
	return 0;
}
  802121:	b8 00 00 00 00       	mov    $0x0,%eax
  802126:	c9                   	leave  
  802127:	c3                   	ret    

00802128 <devcons_write>:
{
  802128:	55                   	push   %ebp
  802129:	89 e5                	mov    %esp,%ebp
  80212b:	57                   	push   %edi
  80212c:	56                   	push   %esi
  80212d:	53                   	push   %ebx
  80212e:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802134:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802139:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80213f:	3b 75 10             	cmp    0x10(%ebp),%esi
  802142:	73 31                	jae    802175 <devcons_write+0x4d>
		m = n - tot;
  802144:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802147:	29 f3                	sub    %esi,%ebx
  802149:	83 fb 7f             	cmp    $0x7f,%ebx
  80214c:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802151:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802154:	83 ec 04             	sub    $0x4,%esp
  802157:	53                   	push   %ebx
  802158:	89 f0                	mov    %esi,%eax
  80215a:	03 45 0c             	add    0xc(%ebp),%eax
  80215d:	50                   	push   %eax
  80215e:	57                   	push   %edi
  80215f:	e8 0b ef ff ff       	call   80106f <memmove>
		sys_cputs(buf, m);
  802164:	83 c4 08             	add    $0x8,%esp
  802167:	53                   	push   %ebx
  802168:	57                   	push   %edi
  802169:	e8 a9 f0 ff ff       	call   801217 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80216e:	01 de                	add    %ebx,%esi
  802170:	83 c4 10             	add    $0x10,%esp
  802173:	eb ca                	jmp    80213f <devcons_write+0x17>
}
  802175:	89 f0                	mov    %esi,%eax
  802177:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80217a:	5b                   	pop    %ebx
  80217b:	5e                   	pop    %esi
  80217c:	5f                   	pop    %edi
  80217d:	5d                   	pop    %ebp
  80217e:	c3                   	ret    

0080217f <devcons_read>:
{
  80217f:	55                   	push   %ebp
  802180:	89 e5                	mov    %esp,%ebp
  802182:	83 ec 08             	sub    $0x8,%esp
  802185:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80218a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80218e:	74 21                	je     8021b1 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802190:	e8 a0 f0 ff ff       	call   801235 <sys_cgetc>
  802195:	85 c0                	test   %eax,%eax
  802197:	75 07                	jne    8021a0 <devcons_read+0x21>
		sys_yield();
  802199:	e8 16 f1 ff ff       	call   8012b4 <sys_yield>
  80219e:	eb f0                	jmp    802190 <devcons_read+0x11>
	if (c < 0)
  8021a0:	78 0f                	js     8021b1 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8021a2:	83 f8 04             	cmp    $0x4,%eax
  8021a5:	74 0c                	je     8021b3 <devcons_read+0x34>
	*(char*)vbuf = c;
  8021a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021aa:	88 02                	mov    %al,(%edx)
	return 1;
  8021ac:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8021b1:	c9                   	leave  
  8021b2:	c3                   	ret    
		return 0;
  8021b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8021b8:	eb f7                	jmp    8021b1 <devcons_read+0x32>

008021ba <cputchar>:
{
  8021ba:	55                   	push   %ebp
  8021bb:	89 e5                	mov    %esp,%ebp
  8021bd:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8021c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c3:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8021c6:	6a 01                	push   $0x1
  8021c8:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021cb:	50                   	push   %eax
  8021cc:	e8 46 f0 ff ff       	call   801217 <sys_cputs>
}
  8021d1:	83 c4 10             	add    $0x10,%esp
  8021d4:	c9                   	leave  
  8021d5:	c3                   	ret    

008021d6 <getchar>:
{
  8021d6:	55                   	push   %ebp
  8021d7:	89 e5                	mov    %esp,%ebp
  8021d9:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8021dc:	6a 01                	push   $0x1
  8021de:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021e1:	50                   	push   %eax
  8021e2:	6a 00                	push   $0x0
  8021e4:	e8 f5 f6 ff ff       	call   8018de <read>
	if (r < 0)
  8021e9:	83 c4 10             	add    $0x10,%esp
  8021ec:	85 c0                	test   %eax,%eax
  8021ee:	78 06                	js     8021f6 <getchar+0x20>
	if (r < 1)
  8021f0:	74 06                	je     8021f8 <getchar+0x22>
	return c;
  8021f2:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8021f6:	c9                   	leave  
  8021f7:	c3                   	ret    
		return -E_EOF;
  8021f8:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8021fd:	eb f7                	jmp    8021f6 <getchar+0x20>

008021ff <iscons>:
{
  8021ff:	55                   	push   %ebp
  802200:	89 e5                	mov    %esp,%ebp
  802202:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802205:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802208:	50                   	push   %eax
  802209:	ff 75 08             	pushl  0x8(%ebp)
  80220c:	e8 62 f4 ff ff       	call   801673 <fd_lookup>
  802211:	83 c4 10             	add    $0x10,%esp
  802214:	85 c0                	test   %eax,%eax
  802216:	78 11                	js     802229 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802218:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221b:	8b 15 40 30 80 00    	mov    0x803040,%edx
  802221:	39 10                	cmp    %edx,(%eax)
  802223:	0f 94 c0             	sete   %al
  802226:	0f b6 c0             	movzbl %al,%eax
}
  802229:	c9                   	leave  
  80222a:	c3                   	ret    

0080222b <opencons>:
{
  80222b:	55                   	push   %ebp
  80222c:	89 e5                	mov    %esp,%ebp
  80222e:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802231:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802234:	50                   	push   %eax
  802235:	e8 e7 f3 ff ff       	call   801621 <fd_alloc>
  80223a:	83 c4 10             	add    $0x10,%esp
  80223d:	85 c0                	test   %eax,%eax
  80223f:	78 3a                	js     80227b <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802241:	83 ec 04             	sub    $0x4,%esp
  802244:	68 07 04 00 00       	push   $0x407
  802249:	ff 75 f4             	pushl  -0xc(%ebp)
  80224c:	6a 00                	push   $0x0
  80224e:	e8 80 f0 ff ff       	call   8012d3 <sys_page_alloc>
  802253:	83 c4 10             	add    $0x10,%esp
  802256:	85 c0                	test   %eax,%eax
  802258:	78 21                	js     80227b <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80225a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225d:	8b 15 40 30 80 00    	mov    0x803040,%edx
  802263:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802265:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802268:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80226f:	83 ec 0c             	sub    $0xc,%esp
  802272:	50                   	push   %eax
  802273:	e8 82 f3 ff ff       	call   8015fa <fd2num>
  802278:	83 c4 10             	add    $0x10,%esp
}
  80227b:	c9                   	leave  
  80227c:	c3                   	ret    

0080227d <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80227d:	55                   	push   %ebp
  80227e:	89 e5                	mov    %esp,%ebp
  802280:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802283:	89 d0                	mov    %edx,%eax
  802285:	c1 e8 16             	shr    $0x16,%eax
  802288:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80228f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802294:	f6 c1 01             	test   $0x1,%cl
  802297:	74 1d                	je     8022b6 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802299:	c1 ea 0c             	shr    $0xc,%edx
  80229c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8022a3:	f6 c2 01             	test   $0x1,%dl
  8022a6:	74 0e                	je     8022b6 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8022a8:	c1 ea 0c             	shr    $0xc,%edx
  8022ab:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8022b2:	ef 
  8022b3:	0f b7 c0             	movzwl %ax,%eax
}
  8022b6:	5d                   	pop    %ebp
  8022b7:	c3                   	ret    
  8022b8:	66 90                	xchg   %ax,%ax
  8022ba:	66 90                	xchg   %ax,%ax
  8022bc:	66 90                	xchg   %ax,%ax
  8022be:	66 90                	xchg   %ax,%ax

008022c0 <__udivdi3>:
  8022c0:	55                   	push   %ebp
  8022c1:	57                   	push   %edi
  8022c2:	56                   	push   %esi
  8022c3:	53                   	push   %ebx
  8022c4:	83 ec 1c             	sub    $0x1c,%esp
  8022c7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8022cb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8022cf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8022d3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8022d7:	85 d2                	test   %edx,%edx
  8022d9:	75 4d                	jne    802328 <__udivdi3+0x68>
  8022db:	39 f3                	cmp    %esi,%ebx
  8022dd:	76 19                	jbe    8022f8 <__udivdi3+0x38>
  8022df:	31 ff                	xor    %edi,%edi
  8022e1:	89 e8                	mov    %ebp,%eax
  8022e3:	89 f2                	mov    %esi,%edx
  8022e5:	f7 f3                	div    %ebx
  8022e7:	89 fa                	mov    %edi,%edx
  8022e9:	83 c4 1c             	add    $0x1c,%esp
  8022ec:	5b                   	pop    %ebx
  8022ed:	5e                   	pop    %esi
  8022ee:	5f                   	pop    %edi
  8022ef:	5d                   	pop    %ebp
  8022f0:	c3                   	ret    
  8022f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022f8:	89 d9                	mov    %ebx,%ecx
  8022fa:	85 db                	test   %ebx,%ebx
  8022fc:	75 0b                	jne    802309 <__udivdi3+0x49>
  8022fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802303:	31 d2                	xor    %edx,%edx
  802305:	f7 f3                	div    %ebx
  802307:	89 c1                	mov    %eax,%ecx
  802309:	31 d2                	xor    %edx,%edx
  80230b:	89 f0                	mov    %esi,%eax
  80230d:	f7 f1                	div    %ecx
  80230f:	89 c6                	mov    %eax,%esi
  802311:	89 e8                	mov    %ebp,%eax
  802313:	89 f7                	mov    %esi,%edi
  802315:	f7 f1                	div    %ecx
  802317:	89 fa                	mov    %edi,%edx
  802319:	83 c4 1c             	add    $0x1c,%esp
  80231c:	5b                   	pop    %ebx
  80231d:	5e                   	pop    %esi
  80231e:	5f                   	pop    %edi
  80231f:	5d                   	pop    %ebp
  802320:	c3                   	ret    
  802321:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802328:	39 f2                	cmp    %esi,%edx
  80232a:	77 1c                	ja     802348 <__udivdi3+0x88>
  80232c:	0f bd fa             	bsr    %edx,%edi
  80232f:	83 f7 1f             	xor    $0x1f,%edi
  802332:	75 2c                	jne    802360 <__udivdi3+0xa0>
  802334:	39 f2                	cmp    %esi,%edx
  802336:	72 06                	jb     80233e <__udivdi3+0x7e>
  802338:	31 c0                	xor    %eax,%eax
  80233a:	39 eb                	cmp    %ebp,%ebx
  80233c:	77 a9                	ja     8022e7 <__udivdi3+0x27>
  80233e:	b8 01 00 00 00       	mov    $0x1,%eax
  802343:	eb a2                	jmp    8022e7 <__udivdi3+0x27>
  802345:	8d 76 00             	lea    0x0(%esi),%esi
  802348:	31 ff                	xor    %edi,%edi
  80234a:	31 c0                	xor    %eax,%eax
  80234c:	89 fa                	mov    %edi,%edx
  80234e:	83 c4 1c             	add    $0x1c,%esp
  802351:	5b                   	pop    %ebx
  802352:	5e                   	pop    %esi
  802353:	5f                   	pop    %edi
  802354:	5d                   	pop    %ebp
  802355:	c3                   	ret    
  802356:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80235d:	8d 76 00             	lea    0x0(%esi),%esi
  802360:	89 f9                	mov    %edi,%ecx
  802362:	b8 20 00 00 00       	mov    $0x20,%eax
  802367:	29 f8                	sub    %edi,%eax
  802369:	d3 e2                	shl    %cl,%edx
  80236b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80236f:	89 c1                	mov    %eax,%ecx
  802371:	89 da                	mov    %ebx,%edx
  802373:	d3 ea                	shr    %cl,%edx
  802375:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802379:	09 d1                	or     %edx,%ecx
  80237b:	89 f2                	mov    %esi,%edx
  80237d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802381:	89 f9                	mov    %edi,%ecx
  802383:	d3 e3                	shl    %cl,%ebx
  802385:	89 c1                	mov    %eax,%ecx
  802387:	d3 ea                	shr    %cl,%edx
  802389:	89 f9                	mov    %edi,%ecx
  80238b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80238f:	89 eb                	mov    %ebp,%ebx
  802391:	d3 e6                	shl    %cl,%esi
  802393:	89 c1                	mov    %eax,%ecx
  802395:	d3 eb                	shr    %cl,%ebx
  802397:	09 de                	or     %ebx,%esi
  802399:	89 f0                	mov    %esi,%eax
  80239b:	f7 74 24 08          	divl   0x8(%esp)
  80239f:	89 d6                	mov    %edx,%esi
  8023a1:	89 c3                	mov    %eax,%ebx
  8023a3:	f7 64 24 0c          	mull   0xc(%esp)
  8023a7:	39 d6                	cmp    %edx,%esi
  8023a9:	72 15                	jb     8023c0 <__udivdi3+0x100>
  8023ab:	89 f9                	mov    %edi,%ecx
  8023ad:	d3 e5                	shl    %cl,%ebp
  8023af:	39 c5                	cmp    %eax,%ebp
  8023b1:	73 04                	jae    8023b7 <__udivdi3+0xf7>
  8023b3:	39 d6                	cmp    %edx,%esi
  8023b5:	74 09                	je     8023c0 <__udivdi3+0x100>
  8023b7:	89 d8                	mov    %ebx,%eax
  8023b9:	31 ff                	xor    %edi,%edi
  8023bb:	e9 27 ff ff ff       	jmp    8022e7 <__udivdi3+0x27>
  8023c0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8023c3:	31 ff                	xor    %edi,%edi
  8023c5:	e9 1d ff ff ff       	jmp    8022e7 <__udivdi3+0x27>
  8023ca:	66 90                	xchg   %ax,%ax
  8023cc:	66 90                	xchg   %ax,%ax
  8023ce:	66 90                	xchg   %ax,%ax

008023d0 <__umoddi3>:
  8023d0:	55                   	push   %ebp
  8023d1:	57                   	push   %edi
  8023d2:	56                   	push   %esi
  8023d3:	53                   	push   %ebx
  8023d4:	83 ec 1c             	sub    $0x1c,%esp
  8023d7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8023db:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8023df:	8b 74 24 30          	mov    0x30(%esp),%esi
  8023e3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8023e7:	89 da                	mov    %ebx,%edx
  8023e9:	85 c0                	test   %eax,%eax
  8023eb:	75 43                	jne    802430 <__umoddi3+0x60>
  8023ed:	39 df                	cmp    %ebx,%edi
  8023ef:	76 17                	jbe    802408 <__umoddi3+0x38>
  8023f1:	89 f0                	mov    %esi,%eax
  8023f3:	f7 f7                	div    %edi
  8023f5:	89 d0                	mov    %edx,%eax
  8023f7:	31 d2                	xor    %edx,%edx
  8023f9:	83 c4 1c             	add    $0x1c,%esp
  8023fc:	5b                   	pop    %ebx
  8023fd:	5e                   	pop    %esi
  8023fe:	5f                   	pop    %edi
  8023ff:	5d                   	pop    %ebp
  802400:	c3                   	ret    
  802401:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802408:	89 fd                	mov    %edi,%ebp
  80240a:	85 ff                	test   %edi,%edi
  80240c:	75 0b                	jne    802419 <__umoddi3+0x49>
  80240e:	b8 01 00 00 00       	mov    $0x1,%eax
  802413:	31 d2                	xor    %edx,%edx
  802415:	f7 f7                	div    %edi
  802417:	89 c5                	mov    %eax,%ebp
  802419:	89 d8                	mov    %ebx,%eax
  80241b:	31 d2                	xor    %edx,%edx
  80241d:	f7 f5                	div    %ebp
  80241f:	89 f0                	mov    %esi,%eax
  802421:	f7 f5                	div    %ebp
  802423:	89 d0                	mov    %edx,%eax
  802425:	eb d0                	jmp    8023f7 <__umoddi3+0x27>
  802427:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80242e:	66 90                	xchg   %ax,%ax
  802430:	89 f1                	mov    %esi,%ecx
  802432:	39 d8                	cmp    %ebx,%eax
  802434:	76 0a                	jbe    802440 <__umoddi3+0x70>
  802436:	89 f0                	mov    %esi,%eax
  802438:	83 c4 1c             	add    $0x1c,%esp
  80243b:	5b                   	pop    %ebx
  80243c:	5e                   	pop    %esi
  80243d:	5f                   	pop    %edi
  80243e:	5d                   	pop    %ebp
  80243f:	c3                   	ret    
  802440:	0f bd e8             	bsr    %eax,%ebp
  802443:	83 f5 1f             	xor    $0x1f,%ebp
  802446:	75 20                	jne    802468 <__umoddi3+0x98>
  802448:	39 d8                	cmp    %ebx,%eax
  80244a:	0f 82 b0 00 00 00    	jb     802500 <__umoddi3+0x130>
  802450:	39 f7                	cmp    %esi,%edi
  802452:	0f 86 a8 00 00 00    	jbe    802500 <__umoddi3+0x130>
  802458:	89 c8                	mov    %ecx,%eax
  80245a:	83 c4 1c             	add    $0x1c,%esp
  80245d:	5b                   	pop    %ebx
  80245e:	5e                   	pop    %esi
  80245f:	5f                   	pop    %edi
  802460:	5d                   	pop    %ebp
  802461:	c3                   	ret    
  802462:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802468:	89 e9                	mov    %ebp,%ecx
  80246a:	ba 20 00 00 00       	mov    $0x20,%edx
  80246f:	29 ea                	sub    %ebp,%edx
  802471:	d3 e0                	shl    %cl,%eax
  802473:	89 44 24 08          	mov    %eax,0x8(%esp)
  802477:	89 d1                	mov    %edx,%ecx
  802479:	89 f8                	mov    %edi,%eax
  80247b:	d3 e8                	shr    %cl,%eax
  80247d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802481:	89 54 24 04          	mov    %edx,0x4(%esp)
  802485:	8b 54 24 04          	mov    0x4(%esp),%edx
  802489:	09 c1                	or     %eax,%ecx
  80248b:	89 d8                	mov    %ebx,%eax
  80248d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802491:	89 e9                	mov    %ebp,%ecx
  802493:	d3 e7                	shl    %cl,%edi
  802495:	89 d1                	mov    %edx,%ecx
  802497:	d3 e8                	shr    %cl,%eax
  802499:	89 e9                	mov    %ebp,%ecx
  80249b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80249f:	d3 e3                	shl    %cl,%ebx
  8024a1:	89 c7                	mov    %eax,%edi
  8024a3:	89 d1                	mov    %edx,%ecx
  8024a5:	89 f0                	mov    %esi,%eax
  8024a7:	d3 e8                	shr    %cl,%eax
  8024a9:	89 e9                	mov    %ebp,%ecx
  8024ab:	89 fa                	mov    %edi,%edx
  8024ad:	d3 e6                	shl    %cl,%esi
  8024af:	09 d8                	or     %ebx,%eax
  8024b1:	f7 74 24 08          	divl   0x8(%esp)
  8024b5:	89 d1                	mov    %edx,%ecx
  8024b7:	89 f3                	mov    %esi,%ebx
  8024b9:	f7 64 24 0c          	mull   0xc(%esp)
  8024bd:	89 c6                	mov    %eax,%esi
  8024bf:	89 d7                	mov    %edx,%edi
  8024c1:	39 d1                	cmp    %edx,%ecx
  8024c3:	72 06                	jb     8024cb <__umoddi3+0xfb>
  8024c5:	75 10                	jne    8024d7 <__umoddi3+0x107>
  8024c7:	39 c3                	cmp    %eax,%ebx
  8024c9:	73 0c                	jae    8024d7 <__umoddi3+0x107>
  8024cb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8024cf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8024d3:	89 d7                	mov    %edx,%edi
  8024d5:	89 c6                	mov    %eax,%esi
  8024d7:	89 ca                	mov    %ecx,%edx
  8024d9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8024de:	29 f3                	sub    %esi,%ebx
  8024e0:	19 fa                	sbb    %edi,%edx
  8024e2:	89 d0                	mov    %edx,%eax
  8024e4:	d3 e0                	shl    %cl,%eax
  8024e6:	89 e9                	mov    %ebp,%ecx
  8024e8:	d3 eb                	shr    %cl,%ebx
  8024ea:	d3 ea                	shr    %cl,%edx
  8024ec:	09 d8                	or     %ebx,%eax
  8024ee:	83 c4 1c             	add    $0x1c,%esp
  8024f1:	5b                   	pop    %ebx
  8024f2:	5e                   	pop    %esi
  8024f3:	5f                   	pop    %edi
  8024f4:	5d                   	pop    %ebp
  8024f5:	c3                   	ret    
  8024f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024fd:	8d 76 00             	lea    0x0(%esi),%esi
  802500:	89 da                	mov    %ebx,%edx
  802502:	29 fe                	sub    %edi,%esi
  802504:	19 c2                	sbb    %eax,%edx
  802506:	89 f1                	mov    %esi,%ecx
  802508:	89 c8                	mov    %ecx,%eax
  80250a:	e9 4b ff ff ff       	jmp    80245a <__umoddi3+0x8a>
