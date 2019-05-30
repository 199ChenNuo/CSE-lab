
obj/user/evilhello2.debug:     file format elf32-i386


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
  80002c:	e8 1c 01 00 00       	call   80014d <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <evil>:
struct Segdesc *gdt;
struct Segdesc *entry;

// Call this function with ring0 privilege
void evil()
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
	// Kernel memory access
	*(char*)0xf010000a = 0;
  800037:	c6 05 0a 00 10 f0 00 	movb   $0x0,0xf010000a
}

static inline void
outb(int port, uint8_t data)
{
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  80003e:	bb 49 00 00 00       	mov    $0x49,%ebx
  800043:	ba f8 03 00 00       	mov    $0x3f8,%edx
  800048:	89 d8                	mov    %ebx,%eax
  80004a:	ee                   	out    %al,(%dx)
  80004b:	b9 4e 00 00 00       	mov    $0x4e,%ecx
  800050:	89 c8                	mov    %ecx,%eax
  800052:	ee                   	out    %al,(%dx)
  800053:	b8 20 00 00 00       	mov    $0x20,%eax
  800058:	ee                   	out    %al,(%dx)
  800059:	b8 52 00 00 00       	mov    $0x52,%eax
  80005e:	ee                   	out    %al,(%dx)
  80005f:	89 d8                	mov    %ebx,%eax
  800061:	ee                   	out    %al,(%dx)
  800062:	89 c8                	mov    %ecx,%eax
  800064:	ee                   	out    %al,(%dx)
  800065:	b8 47 00 00 00       	mov    $0x47,%eax
  80006a:	ee                   	out    %al,(%dx)
  80006b:	b8 30 00 00 00       	mov    $0x30,%eax
  800070:	ee                   	out    %al,(%dx)
  800071:	b8 21 00 00 00       	mov    $0x21,%eax
  800076:	ee                   	out    %al,(%dx)
  800077:	ee                   	out    %al,(%dx)
  800078:	ee                   	out    %al,(%dx)
  800079:	b8 0a 00 00 00       	mov    $0xa,%eax
  80007e:	ee                   	out    %al,(%dx)
	outb(0x3f8, '0');
	outb(0x3f8, '!');
	outb(0x3f8, '!');
	outb(0x3f8, '!');
	outb(0x3f8, '\n');
}
  80007f:	5b                   	pop    %ebx
  800080:	5d                   	pop    %ebp
  800081:	c3                   	ret    

00800082 <call_fun_ptr>:

void call_fun_ptr()
{
  800082:	55                   	push   %ebp
  800083:	89 e5                	mov    %esp,%ebp
  800085:	83 ec 08             	sub    $0x8,%esp
    evil();  
  800088:	e8 a6 ff ff ff       	call   800033 <evil>
    *entry = old;  
  80008d:	8b 0d 20 20 80 00    	mov    0x802020,%ecx
  800093:	a1 44 30 80 00       	mov    0x803044,%eax
  800098:	8b 15 48 30 80 00    	mov    0x803048,%edx
  80009e:	89 01                	mov    %eax,(%ecx)
  8000a0:	89 51 04             	mov    %edx,0x4(%ecx)
    asm volatile("leave");
  8000a3:	c9                   	leave  
    asm volatile("lret");   
  8000a4:	cb                   	lret   
}
  8000a5:	c9                   	leave  
  8000a6:	c3                   	ret    

008000a7 <ring0_call>:
{
	__asm __volatile("sgdt %0" :  "=m" (*gdtd));
}

// Invoke a given function pointer with ring0 privilege, then return to ring3
void ring0_call(void (*fun_ptr)(void)) {
  8000a7:	55                   	push   %ebp
  8000a8:	89 e5                	mov    %esp,%ebp
  8000aa:	83 ec 20             	sub    $0x20,%esp
	__asm __volatile("sgdt %0" :  "=m" (*gdtd));
  8000ad:	0f 01 45 f2          	sgdtl  -0xe(%ebp)

    // Lab3 : Your Code Here
    struct Pseudodesc r_gdt; 
    sgdt(&r_gdt);

    int t = sys_map_kernel_page((void* )r_gdt.pd_base, (void* )vaddr);
  8000b1:	68 40 20 80 00       	push   $0x802040
  8000b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8000b9:	e8 88 0e 00 00       	call   800f46 <sys_map_kernel_page>
    if (t < 0) {
  8000be:	83 c4 10             	add    $0x10,%esp
  8000c1:	85 c0                	test   %eax,%eax
  8000c3:	78 5b                	js     800120 <ring0_call+0x79>
        cprintf("ring0_call: sys_map_kernel_page failed, %e\n", t);
    }

    uint32_t base = (uint32_t)(PGNUM(vaddr) << PTXSHIFT);
    uint32_t index = GD_UD >> 3;
    uint32_t offset = PGOFF(r_gdt.pd_base);
  8000c5:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8000c8:	81 e1 ff 0f 00 00    	and    $0xfff,%ecx
    uint32_t base = (uint32_t)(PGNUM(vaddr) << PTXSHIFT);
  8000ce:	b8 40 20 80 00       	mov    $0x802040,%eax
  8000d3:	25 00 f0 ff ff       	and    $0xfffff000,%eax

    gdt = (struct Segdesc*)(base+offset); 
  8000d8:	09 c1                	or     %eax,%ecx
  8000da:	89 0d 40 30 80 00    	mov    %ecx,0x803040
    entry = gdt + index; 
  8000e0:	8d 41 20             	lea    0x20(%ecx),%eax
  8000e3:	a3 20 20 80 00       	mov    %eax,0x802020
    old= *entry; 
  8000e8:	8b 41 20             	mov    0x20(%ecx),%eax
  8000eb:	8b 51 24             	mov    0x24(%ecx),%edx
  8000ee:	a3 44 30 80 00       	mov    %eax,0x803044
  8000f3:	89 15 48 30 80 00    	mov    %edx,0x803048

    SETCALLGATE(*((struct Gatedesc*)entry), GD_KT, call_fun_ptr, 3);
  8000f9:	b8 82 00 80 00       	mov    $0x800082,%eax
  8000fe:	66 89 41 20          	mov    %ax,0x20(%ecx)
  800102:	66 c7 41 22 08 00    	movw   $0x8,0x22(%ecx)
  800108:	c6 41 24 00          	movb   $0x0,0x24(%ecx)
  80010c:	c6 41 25 ec          	movb   $0xec,0x25(%ecx)
  800110:	c1 e8 10             	shr    $0x10,%eax
  800113:	66 89 41 26          	mov    %ax,0x26(%ecx)
    asm volatile("lcall $0x20, $0");
  800117:	9a 00 00 00 00 20 00 	lcall  $0x20,$0x0
}
  80011e:	c9                   	leave  
  80011f:	c3                   	ret    
        cprintf("ring0_call: sys_map_kernel_page failed, %e\n", t);
  800120:	83 ec 08             	sub    $0x8,%esp
  800123:	50                   	push   %eax
  800124:	68 20 12 80 00       	push   $0x801220
  800129:	e8 0f 01 00 00       	call   80023d <cprintf>
  80012e:	83 c4 10             	add    $0x10,%esp
  800131:	eb 92                	jmp    8000c5 <ring0_call+0x1e>

00800133 <umain>:

void
umain(int argc, char **argv)
{
  800133:	55                   	push   %ebp
  800134:	89 e5                	mov    %esp,%ebp
  800136:	83 ec 14             	sub    $0x14,%esp
        // call the evil function in ring0
	ring0_call(&evil);
  800139:	68 33 00 80 00       	push   $0x800033
  80013e:	e8 64 ff ff ff       	call   8000a7 <ring0_call>

	// call the evil function in ring3
	evil();
  800143:	e8 eb fe ff ff       	call   800033 <evil>
}
  800148:	83 c4 10             	add    $0x10,%esp
  80014b:	c9                   	leave  
  80014c:	c3                   	ret    

0080014d <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80014d:	55                   	push   %ebp
  80014e:	89 e5                	mov    %esp,%ebp
  800150:	56                   	push   %esi
  800151:	53                   	push   %ebx
  800152:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800155:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	// thisenv = 0;
	thisenv = &(envs[ENVX(sys_getenvid())]);
  800158:	e8 ba 0b 00 00       	call   800d17 <sys_getenvid>
  80015d:	25 ff 03 00 00       	and    $0x3ff,%eax
  800162:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  800168:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80016d:	a3 4c 30 80 00       	mov    %eax,0x80304c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800172:	85 db                	test   %ebx,%ebx
  800174:	7e 07                	jle    80017d <libmain+0x30>
		binaryname = argv[0];
  800176:	8b 06                	mov    (%esi),%eax
  800178:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  80017d:	83 ec 08             	sub    $0x8,%esp
  800180:	56                   	push   %esi
  800181:	53                   	push   %ebx
  800182:	e8 ac ff ff ff       	call   800133 <umain>

	// exit gracefully
	exit();
  800187:	e8 0a 00 00 00       	call   800196 <exit>
}
  80018c:	83 c4 10             	add    $0x10,%esp
  80018f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800192:	5b                   	pop    %ebx
  800193:	5e                   	pop    %esi
  800194:	5d                   	pop    %ebp
  800195:	c3                   	ret    

00800196 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800196:	55                   	push   %ebp
  800197:	89 e5                	mov    %esp,%ebp
  800199:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  80019c:	6a 00                	push   $0x0
  80019e:	e8 33 0b 00 00       	call   800cd6 <sys_env_destroy>
}
  8001a3:	83 c4 10             	add    $0x10,%esp
  8001a6:	c9                   	leave  
  8001a7:	c3                   	ret    

008001a8 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001a8:	55                   	push   %ebp
  8001a9:	89 e5                	mov    %esp,%ebp
  8001ab:	53                   	push   %ebx
  8001ac:	83 ec 04             	sub    $0x4,%esp
  8001af:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001b2:	8b 13                	mov    (%ebx),%edx
  8001b4:	8d 42 01             	lea    0x1(%edx),%eax
  8001b7:	89 03                	mov    %eax,(%ebx)
  8001b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001bc:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001c0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001c5:	74 09                	je     8001d0 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001c7:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001ce:	c9                   	leave  
  8001cf:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001d0:	83 ec 08             	sub    $0x8,%esp
  8001d3:	68 ff 00 00 00       	push   $0xff
  8001d8:	8d 43 08             	lea    0x8(%ebx),%eax
  8001db:	50                   	push   %eax
  8001dc:	e8 b8 0a 00 00       	call   800c99 <sys_cputs>
		b->idx = 0;
  8001e1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001e7:	83 c4 10             	add    $0x10,%esp
  8001ea:	eb db                	jmp    8001c7 <putch+0x1f>

008001ec <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001ec:	55                   	push   %ebp
  8001ed:	89 e5                	mov    %esp,%ebp
  8001ef:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001f5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001fc:	00 00 00 
	b.cnt = 0;
  8001ff:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800206:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800209:	ff 75 0c             	pushl  0xc(%ebp)
  80020c:	ff 75 08             	pushl  0x8(%ebp)
  80020f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800215:	50                   	push   %eax
  800216:	68 a8 01 80 00       	push   $0x8001a8
  80021b:	e8 4a 01 00 00       	call   80036a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800220:	83 c4 08             	add    $0x8,%esp
  800223:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800229:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80022f:	50                   	push   %eax
  800230:	e8 64 0a 00 00       	call   800c99 <sys_cputs>

	return b.cnt;
}
  800235:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80023b:	c9                   	leave  
  80023c:	c3                   	ret    

0080023d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80023d:	55                   	push   %ebp
  80023e:	89 e5                	mov    %esp,%ebp
  800240:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800243:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800246:	50                   	push   %eax
  800247:	ff 75 08             	pushl  0x8(%ebp)
  80024a:	e8 9d ff ff ff       	call   8001ec <vcprintf>
	va_end(ap);

	return cnt;
}
  80024f:	c9                   	leave  
  800250:	c3                   	ret    

00800251 <printnum>:


static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800251:	55                   	push   %ebp
  800252:	89 e5                	mov    %esp,%ebp
  800254:	57                   	push   %edi
  800255:	56                   	push   %esi
  800256:	53                   	push   %ebx
  800257:	83 ec 1c             	sub    $0x1c,%esp
  80025a:	89 c6                	mov    %eax,%esi
  80025c:	89 d7                	mov    %edx,%edi
  80025e:	8b 45 08             	mov    0x8(%ebp),%eax
  800261:	8b 55 0c             	mov    0xc(%ebp),%edx
  800264:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800267:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80026a:	8b 45 10             	mov    0x10(%ebp),%eax
  80026d:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	// to support '-'
	if(padc == '-'){
  800270:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800274:	74 2c                	je     8002a2 <printnum+0x51>
		while (--width > 0)
			putch(' ', putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800276:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800279:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800280:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800283:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800286:	39 c2                	cmp    %eax,%edx
  800288:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80028b:	73 43                	jae    8002d0 <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80028d:	83 eb 01             	sub    $0x1,%ebx
  800290:	85 db                	test   %ebx,%ebx
  800292:	7e 6c                	jle    800300 <printnum+0xaf>
			putch(padc, putdat);
  800294:	83 ec 08             	sub    $0x8,%esp
  800297:	57                   	push   %edi
  800298:	ff 75 18             	pushl  0x18(%ebp)
  80029b:	ff d6                	call   *%esi
  80029d:	83 c4 10             	add    $0x10,%esp
  8002a0:	eb eb                	jmp    80028d <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8002a2:	83 ec 0c             	sub    $0xc,%esp
  8002a5:	6a 20                	push   $0x20
  8002a7:	6a 00                	push   $0x0
  8002a9:	50                   	push   %eax
  8002aa:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002ad:	ff 75 e0             	pushl  -0x20(%ebp)
  8002b0:	89 fa                	mov    %edi,%edx
  8002b2:	89 f0                	mov    %esi,%eax
  8002b4:	e8 98 ff ff ff       	call   800251 <printnum>
		while (--width > 0)
  8002b9:	83 c4 20             	add    $0x20,%esp
  8002bc:	83 eb 01             	sub    $0x1,%ebx
  8002bf:	85 db                	test   %ebx,%ebx
  8002c1:	7e 65                	jle    800328 <printnum+0xd7>
			putch(' ', putdat);
  8002c3:	83 ec 08             	sub    $0x8,%esp
  8002c6:	57                   	push   %edi
  8002c7:	6a 20                	push   $0x20
  8002c9:	ff d6                	call   *%esi
  8002cb:	83 c4 10             	add    $0x10,%esp
  8002ce:	eb ec                	jmp    8002bc <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002d0:	83 ec 0c             	sub    $0xc,%esp
  8002d3:	ff 75 18             	pushl  0x18(%ebp)
  8002d6:	83 eb 01             	sub    $0x1,%ebx
  8002d9:	53                   	push   %ebx
  8002da:	50                   	push   %eax
  8002db:	83 ec 08             	sub    $0x8,%esp
  8002de:	ff 75 dc             	pushl  -0x24(%ebp)
  8002e1:	ff 75 d8             	pushl  -0x28(%ebp)
  8002e4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002e7:	ff 75 e0             	pushl  -0x20(%ebp)
  8002ea:	e8 e1 0c 00 00       	call   800fd0 <__udivdi3>
  8002ef:	83 c4 18             	add    $0x18,%esp
  8002f2:	52                   	push   %edx
  8002f3:	50                   	push   %eax
  8002f4:	89 fa                	mov    %edi,%edx
  8002f6:	89 f0                	mov    %esi,%eax
  8002f8:	e8 54 ff ff ff       	call   800251 <printnum>
  8002fd:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800300:	83 ec 08             	sub    $0x8,%esp
  800303:	57                   	push   %edi
  800304:	83 ec 04             	sub    $0x4,%esp
  800307:	ff 75 dc             	pushl  -0x24(%ebp)
  80030a:	ff 75 d8             	pushl  -0x28(%ebp)
  80030d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800310:	ff 75 e0             	pushl  -0x20(%ebp)
  800313:	e8 c8 0d 00 00       	call   8010e0 <__umoddi3>
  800318:	83 c4 14             	add    $0x14,%esp
  80031b:	0f be 80 56 12 80 00 	movsbl 0x801256(%eax),%eax
  800322:	50                   	push   %eax
  800323:	ff d6                	call   *%esi
  800325:	83 c4 10             	add    $0x10,%esp
}
  800328:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80032b:	5b                   	pop    %ebx
  80032c:	5e                   	pop    %esi
  80032d:	5f                   	pop    %edi
  80032e:	5d                   	pop    %ebp
  80032f:	c3                   	ret    

00800330 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800330:	55                   	push   %ebp
  800331:	89 e5                	mov    %esp,%ebp
  800333:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800336:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80033a:	8b 10                	mov    (%eax),%edx
  80033c:	3b 50 04             	cmp    0x4(%eax),%edx
  80033f:	73 0a                	jae    80034b <sprintputch+0x1b>
		*b->buf++ = ch;
  800341:	8d 4a 01             	lea    0x1(%edx),%ecx
  800344:	89 08                	mov    %ecx,(%eax)
  800346:	8b 45 08             	mov    0x8(%ebp),%eax
  800349:	88 02                	mov    %al,(%edx)
}
  80034b:	5d                   	pop    %ebp
  80034c:	c3                   	ret    

0080034d <printfmt>:
{
  80034d:	55                   	push   %ebp
  80034e:	89 e5                	mov    %esp,%ebp
  800350:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800353:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800356:	50                   	push   %eax
  800357:	ff 75 10             	pushl  0x10(%ebp)
  80035a:	ff 75 0c             	pushl  0xc(%ebp)
  80035d:	ff 75 08             	pushl  0x8(%ebp)
  800360:	e8 05 00 00 00       	call   80036a <vprintfmt>
}
  800365:	83 c4 10             	add    $0x10,%esp
  800368:	c9                   	leave  
  800369:	c3                   	ret    

0080036a <vprintfmt>:
{
  80036a:	55                   	push   %ebp
  80036b:	89 e5                	mov    %esp,%ebp
  80036d:	57                   	push   %edi
  80036e:	56                   	push   %esi
  80036f:	53                   	push   %ebx
  800370:	83 ec 3c             	sub    $0x3c,%esp
  800373:	8b 75 08             	mov    0x8(%ebp),%esi
  800376:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800379:	8b 7d 10             	mov    0x10(%ebp),%edi
  80037c:	e9 1e 04 00 00       	jmp    80079f <vprintfmt+0x435>
		posflag = 0;
  800381:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
		padc = ' ';
  800388:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80038c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800393:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80039a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003a1:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  8003a8:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003ad:	8d 47 01             	lea    0x1(%edi),%eax
  8003b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003b3:	0f b6 17             	movzbl (%edi),%edx
  8003b6:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003b9:	3c 55                	cmp    $0x55,%al
  8003bb:	0f 87 d9 04 00 00    	ja     80089a <vprintfmt+0x530>
  8003c1:	0f b6 c0             	movzbl %al,%eax
  8003c4:	ff 24 85 40 14 80 00 	jmp    *0x801440(,%eax,4)
  8003cb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003ce:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8003d2:	eb d9                	jmp    8003ad <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003d4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posflag = 1;
  8003d7:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  8003de:	eb cd                	jmp    8003ad <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003e0:	0f b6 d2             	movzbl %dl,%edx
  8003e3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8003eb:	89 75 08             	mov    %esi,0x8(%ebp)
  8003ee:	eb 0c                	jmp    8003fc <vprintfmt+0x92>
		switch (ch = *(unsigned char *) fmt++) {
  8003f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003f3:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  8003f7:	eb b4                	jmp    8003ad <vprintfmt+0x43>
			for (precision = 0; ; ++fmt) {
  8003f9:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003fc:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003ff:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800403:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800406:	8d 72 d0             	lea    -0x30(%edx),%esi
  800409:	83 fe 09             	cmp    $0x9,%esi
  80040c:	76 eb                	jbe    8003f9 <vprintfmt+0x8f>
  80040e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800411:	8b 75 08             	mov    0x8(%ebp),%esi
  800414:	eb 14                	jmp    80042a <vprintfmt+0xc0>
			precision = va_arg(ap, int);
  800416:	8b 45 14             	mov    0x14(%ebp),%eax
  800419:	8b 00                	mov    (%eax),%eax
  80041b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80041e:	8b 45 14             	mov    0x14(%ebp),%eax
  800421:	8d 40 04             	lea    0x4(%eax),%eax
  800424:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800427:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80042a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80042e:	0f 89 79 ff ff ff    	jns    8003ad <vprintfmt+0x43>
				width = precision, precision = -1;
  800434:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800437:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80043a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800441:	e9 67 ff ff ff       	jmp    8003ad <vprintfmt+0x43>
  800446:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800449:	85 c0                	test   %eax,%eax
  80044b:	0f 48 c1             	cmovs  %ecx,%eax
  80044e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800451:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800454:	e9 54 ff ff ff       	jmp    8003ad <vprintfmt+0x43>
  800459:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80045c:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800463:	e9 45 ff ff ff       	jmp    8003ad <vprintfmt+0x43>
			lflag++;
  800468:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80046c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80046f:	e9 39 ff ff ff       	jmp    8003ad <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800474:	8b 45 14             	mov    0x14(%ebp),%eax
  800477:	8d 78 04             	lea    0x4(%eax),%edi
  80047a:	83 ec 08             	sub    $0x8,%esp
  80047d:	53                   	push   %ebx
  80047e:	ff 30                	pushl  (%eax)
  800480:	ff d6                	call   *%esi
			break;
  800482:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800485:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800488:	e9 0f 03 00 00       	jmp    80079c <vprintfmt+0x432>
			err = va_arg(ap, int);
  80048d:	8b 45 14             	mov    0x14(%ebp),%eax
  800490:	8d 78 04             	lea    0x4(%eax),%edi
  800493:	8b 00                	mov    (%eax),%eax
  800495:	99                   	cltd   
  800496:	31 d0                	xor    %edx,%eax
  800498:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80049a:	83 f8 0f             	cmp    $0xf,%eax
  80049d:	7f 23                	jg     8004c2 <vprintfmt+0x158>
  80049f:	8b 14 85 a0 15 80 00 	mov    0x8015a0(,%eax,4),%edx
  8004a6:	85 d2                	test   %edx,%edx
  8004a8:	74 18                	je     8004c2 <vprintfmt+0x158>
				printfmt(putch, putdat, "%s", p);
  8004aa:	52                   	push   %edx
  8004ab:	68 77 12 80 00       	push   $0x801277
  8004b0:	53                   	push   %ebx
  8004b1:	56                   	push   %esi
  8004b2:	e8 96 fe ff ff       	call   80034d <printfmt>
  8004b7:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004ba:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004bd:	e9 da 02 00 00       	jmp    80079c <vprintfmt+0x432>
				printfmt(putch, putdat, "error %d", err);
  8004c2:	50                   	push   %eax
  8004c3:	68 6e 12 80 00       	push   $0x80126e
  8004c8:	53                   	push   %ebx
  8004c9:	56                   	push   %esi
  8004ca:	e8 7e fe ff ff       	call   80034d <printfmt>
  8004cf:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004d2:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004d5:	e9 c2 02 00 00       	jmp    80079c <vprintfmt+0x432>
			if ((p = va_arg(ap, char *)) == NULL)
  8004da:	8b 45 14             	mov    0x14(%ebp),%eax
  8004dd:	83 c0 04             	add    $0x4,%eax
  8004e0:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8004e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e6:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8004e8:	85 c9                	test   %ecx,%ecx
  8004ea:	b8 67 12 80 00       	mov    $0x801267,%eax
  8004ef:	0f 45 c1             	cmovne %ecx,%eax
  8004f2:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8004f5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004f9:	7e 06                	jle    800501 <vprintfmt+0x197>
  8004fb:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8004ff:	75 0d                	jne    80050e <vprintfmt+0x1a4>
				for (width -= strnlen(p, precision); width > 0; width--)
  800501:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800504:	89 c7                	mov    %eax,%edi
  800506:	03 45 e0             	add    -0x20(%ebp),%eax
  800509:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80050c:	eb 53                	jmp    800561 <vprintfmt+0x1f7>
  80050e:	83 ec 08             	sub    $0x8,%esp
  800511:	ff 75 d8             	pushl  -0x28(%ebp)
  800514:	50                   	push   %eax
  800515:	e8 28 04 00 00       	call   800942 <strnlen>
  80051a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80051d:	29 c1                	sub    %eax,%ecx
  80051f:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  800522:	83 c4 10             	add    $0x10,%esp
  800525:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800527:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80052b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80052e:	eb 0f                	jmp    80053f <vprintfmt+0x1d5>
					putch(padc, putdat);
  800530:	83 ec 08             	sub    $0x8,%esp
  800533:	53                   	push   %ebx
  800534:	ff 75 e0             	pushl  -0x20(%ebp)
  800537:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800539:	83 ef 01             	sub    $0x1,%edi
  80053c:	83 c4 10             	add    $0x10,%esp
  80053f:	85 ff                	test   %edi,%edi
  800541:	7f ed                	jg     800530 <vprintfmt+0x1c6>
  800543:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  800546:	85 c9                	test   %ecx,%ecx
  800548:	b8 00 00 00 00       	mov    $0x0,%eax
  80054d:	0f 49 c1             	cmovns %ecx,%eax
  800550:	29 c1                	sub    %eax,%ecx
  800552:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800555:	eb aa                	jmp    800501 <vprintfmt+0x197>
					putch(ch, putdat);
  800557:	83 ec 08             	sub    $0x8,%esp
  80055a:	53                   	push   %ebx
  80055b:	52                   	push   %edx
  80055c:	ff d6                	call   *%esi
  80055e:	83 c4 10             	add    $0x10,%esp
  800561:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800564:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800566:	83 c7 01             	add    $0x1,%edi
  800569:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80056d:	0f be d0             	movsbl %al,%edx
  800570:	85 d2                	test   %edx,%edx
  800572:	74 4b                	je     8005bf <vprintfmt+0x255>
  800574:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800578:	78 06                	js     800580 <vprintfmt+0x216>
  80057a:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80057e:	78 1e                	js     80059e <vprintfmt+0x234>
				if (altflag && (ch < ' ' || ch > '~'))
  800580:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800584:	74 d1                	je     800557 <vprintfmt+0x1ed>
  800586:	0f be c0             	movsbl %al,%eax
  800589:	83 e8 20             	sub    $0x20,%eax
  80058c:	83 f8 5e             	cmp    $0x5e,%eax
  80058f:	76 c6                	jbe    800557 <vprintfmt+0x1ed>
					putch('?', putdat);
  800591:	83 ec 08             	sub    $0x8,%esp
  800594:	53                   	push   %ebx
  800595:	6a 3f                	push   $0x3f
  800597:	ff d6                	call   *%esi
  800599:	83 c4 10             	add    $0x10,%esp
  80059c:	eb c3                	jmp    800561 <vprintfmt+0x1f7>
  80059e:	89 cf                	mov    %ecx,%edi
  8005a0:	eb 0e                	jmp    8005b0 <vprintfmt+0x246>
				putch(' ', putdat);
  8005a2:	83 ec 08             	sub    $0x8,%esp
  8005a5:	53                   	push   %ebx
  8005a6:	6a 20                	push   $0x20
  8005a8:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005aa:	83 ef 01             	sub    $0x1,%edi
  8005ad:	83 c4 10             	add    $0x10,%esp
  8005b0:	85 ff                	test   %edi,%edi
  8005b2:	7f ee                	jg     8005a2 <vprintfmt+0x238>
			if ((p = va_arg(ap, char *)) == NULL)
  8005b4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8005b7:	89 45 14             	mov    %eax,0x14(%ebp)
  8005ba:	e9 dd 01 00 00       	jmp    80079c <vprintfmt+0x432>
  8005bf:	89 cf                	mov    %ecx,%edi
  8005c1:	eb ed                	jmp    8005b0 <vprintfmt+0x246>
	if (lflag >= 2)
  8005c3:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8005c7:	7f 21                	jg     8005ea <vprintfmt+0x280>
	else if (lflag)
  8005c9:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8005cd:	74 6a                	je     800639 <vprintfmt+0x2cf>
		return va_arg(*ap, long);
  8005cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d2:	8b 00                	mov    (%eax),%eax
  8005d4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005d7:	89 c1                	mov    %eax,%ecx
  8005d9:	c1 f9 1f             	sar    $0x1f,%ecx
  8005dc:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005df:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e2:	8d 40 04             	lea    0x4(%eax),%eax
  8005e5:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e8:	eb 17                	jmp    800601 <vprintfmt+0x297>
		return va_arg(*ap, long long);
  8005ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ed:	8b 50 04             	mov    0x4(%eax),%edx
  8005f0:	8b 00                	mov    (%eax),%eax
  8005f2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005f5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fb:	8d 40 08             	lea    0x8(%eax),%eax
  8005fe:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800601:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  800604:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800609:	85 d2                	test   %edx,%edx
  80060b:	0f 89 5c 01 00 00    	jns    80076d <vprintfmt+0x403>
				putch('-', putdat);
  800611:	83 ec 08             	sub    $0x8,%esp
  800614:	53                   	push   %ebx
  800615:	6a 2d                	push   $0x2d
  800617:	ff d6                	call   *%esi
				num = -(long long) num;
  800619:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80061c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80061f:	f7 d8                	neg    %eax
  800621:	83 d2 00             	adc    $0x0,%edx
  800624:	f7 da                	neg    %edx
  800626:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800629:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80062c:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80062f:	bf 0a 00 00 00       	mov    $0xa,%edi
  800634:	e9 45 01 00 00       	jmp    80077e <vprintfmt+0x414>
		return va_arg(*ap, int);
  800639:	8b 45 14             	mov    0x14(%ebp),%eax
  80063c:	8b 00                	mov    (%eax),%eax
  80063e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800641:	89 c1                	mov    %eax,%ecx
  800643:	c1 f9 1f             	sar    $0x1f,%ecx
  800646:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800649:	8b 45 14             	mov    0x14(%ebp),%eax
  80064c:	8d 40 04             	lea    0x4(%eax),%eax
  80064f:	89 45 14             	mov    %eax,0x14(%ebp)
  800652:	eb ad                	jmp    800601 <vprintfmt+0x297>
	if (lflag >= 2)
  800654:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800658:	7f 29                	jg     800683 <vprintfmt+0x319>
	else if (lflag)
  80065a:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80065e:	74 44                	je     8006a4 <vprintfmt+0x33a>
		return va_arg(*ap, unsigned long);
  800660:	8b 45 14             	mov    0x14(%ebp),%eax
  800663:	8b 00                	mov    (%eax),%eax
  800665:	ba 00 00 00 00       	mov    $0x0,%edx
  80066a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80066d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800670:	8b 45 14             	mov    0x14(%ebp),%eax
  800673:	8d 40 04             	lea    0x4(%eax),%eax
  800676:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800679:	bf 0a 00 00 00       	mov    $0xa,%edi
  80067e:	e9 ea 00 00 00       	jmp    80076d <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  800683:	8b 45 14             	mov    0x14(%ebp),%eax
  800686:	8b 50 04             	mov    0x4(%eax),%edx
  800689:	8b 00                	mov    (%eax),%eax
  80068b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80068e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800691:	8b 45 14             	mov    0x14(%ebp),%eax
  800694:	8d 40 08             	lea    0x8(%eax),%eax
  800697:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80069a:	bf 0a 00 00 00       	mov    $0xa,%edi
  80069f:	e9 c9 00 00 00       	jmp    80076d <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  8006a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a7:	8b 00                	mov    (%eax),%eax
  8006a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ae:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006b1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b7:	8d 40 04             	lea    0x4(%eax),%eax
  8006ba:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006bd:	bf 0a 00 00 00       	mov    $0xa,%edi
  8006c2:	e9 a6 00 00 00       	jmp    80076d <vprintfmt+0x403>
			putch('0', putdat);
  8006c7:	83 ec 08             	sub    $0x8,%esp
  8006ca:	53                   	push   %ebx
  8006cb:	6a 30                	push   $0x30
  8006cd:	ff d6                	call   *%esi
	if (lflag >= 2)
  8006cf:	83 c4 10             	add    $0x10,%esp
  8006d2:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8006d6:	7f 26                	jg     8006fe <vprintfmt+0x394>
	else if (lflag)
  8006d8:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8006dc:	74 3e                	je     80071c <vprintfmt+0x3b2>
		return va_arg(*ap, unsigned long);
  8006de:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e1:	8b 00                	mov    (%eax),%eax
  8006e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8006e8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006eb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f1:	8d 40 04             	lea    0x4(%eax),%eax
  8006f4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006f7:	bf 08 00 00 00       	mov    $0x8,%edi
  8006fc:	eb 6f                	jmp    80076d <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  8006fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800701:	8b 50 04             	mov    0x4(%eax),%edx
  800704:	8b 00                	mov    (%eax),%eax
  800706:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800709:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80070c:	8b 45 14             	mov    0x14(%ebp),%eax
  80070f:	8d 40 08             	lea    0x8(%eax),%eax
  800712:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800715:	bf 08 00 00 00       	mov    $0x8,%edi
  80071a:	eb 51                	jmp    80076d <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  80071c:	8b 45 14             	mov    0x14(%ebp),%eax
  80071f:	8b 00                	mov    (%eax),%eax
  800721:	ba 00 00 00 00       	mov    $0x0,%edx
  800726:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800729:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80072c:	8b 45 14             	mov    0x14(%ebp),%eax
  80072f:	8d 40 04             	lea    0x4(%eax),%eax
  800732:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800735:	bf 08 00 00 00       	mov    $0x8,%edi
  80073a:	eb 31                	jmp    80076d <vprintfmt+0x403>
			putch('0', putdat);
  80073c:	83 ec 08             	sub    $0x8,%esp
  80073f:	53                   	push   %ebx
  800740:	6a 30                	push   $0x30
  800742:	ff d6                	call   *%esi
			putch('x', putdat);
  800744:	83 c4 08             	add    $0x8,%esp
  800747:	53                   	push   %ebx
  800748:	6a 78                	push   $0x78
  80074a:	ff d6                	call   *%esi
			num = (unsigned long long)
  80074c:	8b 45 14             	mov    0x14(%ebp),%eax
  80074f:	8b 00                	mov    (%eax),%eax
  800751:	ba 00 00 00 00       	mov    $0x0,%edx
  800756:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800759:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80075c:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80075f:	8b 45 14             	mov    0x14(%ebp),%eax
  800762:	8d 40 04             	lea    0x4(%eax),%eax
  800765:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800768:	bf 10 00 00 00       	mov    $0x10,%edi
			if(posflag)
  80076d:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800771:	74 0b                	je     80077e <vprintfmt+0x414>
				putch('+', putdat);
  800773:	83 ec 08             	sub    $0x8,%esp
  800776:	53                   	push   %ebx
  800777:	6a 2b                	push   $0x2b
  800779:	ff d6                	call   *%esi
  80077b:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  80077e:	83 ec 0c             	sub    $0xc,%esp
  800781:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800785:	50                   	push   %eax
  800786:	ff 75 e0             	pushl  -0x20(%ebp)
  800789:	57                   	push   %edi
  80078a:	ff 75 dc             	pushl  -0x24(%ebp)
  80078d:	ff 75 d8             	pushl  -0x28(%ebp)
  800790:	89 da                	mov    %ebx,%edx
  800792:	89 f0                	mov    %esi,%eax
  800794:	e8 b8 fa ff ff       	call   800251 <printnum>
			break;
  800799:	83 c4 20             	add    $0x20,%esp
			char* cp = va_arg(ap, char *);
  80079c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80079f:	83 c7 01             	add    $0x1,%edi
  8007a2:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007a6:	83 f8 25             	cmp    $0x25,%eax
  8007a9:	0f 84 d2 fb ff ff    	je     800381 <vprintfmt+0x17>
			if (ch == '\0')
  8007af:	85 c0                	test   %eax,%eax
  8007b1:	0f 84 03 01 00 00    	je     8008ba <vprintfmt+0x550>
			putch(ch, putdat);
  8007b7:	83 ec 08             	sub    $0x8,%esp
  8007ba:	53                   	push   %ebx
  8007bb:	50                   	push   %eax
  8007bc:	ff d6                	call   *%esi
  8007be:	83 c4 10             	add    $0x10,%esp
  8007c1:	eb dc                	jmp    80079f <vprintfmt+0x435>
	if (lflag >= 2)
  8007c3:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8007c7:	7f 29                	jg     8007f2 <vprintfmt+0x488>
	else if (lflag)
  8007c9:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8007cd:	74 44                	je     800813 <vprintfmt+0x4a9>
		return va_arg(*ap, unsigned long);
  8007cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d2:	8b 00                	mov    (%eax),%eax
  8007d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8007d9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007dc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007df:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e2:	8d 40 04             	lea    0x4(%eax),%eax
  8007e5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007e8:	bf 10 00 00 00       	mov    $0x10,%edi
  8007ed:	e9 7b ff ff ff       	jmp    80076d <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  8007f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f5:	8b 50 04             	mov    0x4(%eax),%edx
  8007f8:	8b 00                	mov    (%eax),%eax
  8007fa:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007fd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800800:	8b 45 14             	mov    0x14(%ebp),%eax
  800803:	8d 40 08             	lea    0x8(%eax),%eax
  800806:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800809:	bf 10 00 00 00       	mov    $0x10,%edi
  80080e:	e9 5a ff ff ff       	jmp    80076d <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  800813:	8b 45 14             	mov    0x14(%ebp),%eax
  800816:	8b 00                	mov    (%eax),%eax
  800818:	ba 00 00 00 00       	mov    $0x0,%edx
  80081d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800820:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800823:	8b 45 14             	mov    0x14(%ebp),%eax
  800826:	8d 40 04             	lea    0x4(%eax),%eax
  800829:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80082c:	bf 10 00 00 00       	mov    $0x10,%edi
  800831:	e9 37 ff ff ff       	jmp    80076d <vprintfmt+0x403>
			char* cp = va_arg(ap, char *);
  800836:	8b 45 14             	mov    0x14(%ebp),%eax
  800839:	8d 78 04             	lea    0x4(%eax),%edi
  80083c:	8b 00                	mov    (%eax),%eax
    			if (cp == NULL) {
  80083e:	85 c0                	test   %eax,%eax
  800840:	74 2c                	je     80086e <vprintfmt+0x504>
    			*cp = *(int *)putdat;
  800842:	8b 13                	mov    (%ebx),%edx
  800844:	88 10                	mov    %dl,(%eax)
			char* cp = va_arg(ap, char *);
  800846:	89 7d 14             	mov    %edi,0x14(%ebp)
    			if ((*(int *) putdat) > 127)
  800849:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  80084c:	0f 8e 4a ff ff ff    	jle    80079c <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", overflow_error);
  800852:	68 c4 13 80 00       	push   $0x8013c4
  800857:	68 77 12 80 00       	push   $0x801277
  80085c:	53                   	push   %ebx
  80085d:	56                   	push   %esi
  80085e:	e8 ea fa ff ff       	call   80034d <printfmt>
  800863:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  800866:	89 7d 14             	mov    %edi,0x14(%ebp)
  800869:	e9 2e ff ff ff       	jmp    80079c <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", null_error);
  80086e:	68 8c 13 80 00       	push   $0x80138c
  800873:	68 77 12 80 00       	push   $0x801277
  800878:	53                   	push   %ebx
  800879:	56                   	push   %esi
  80087a:	e8 ce fa ff ff       	call   80034d <printfmt>
        		break;
  80087f:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  800882:	89 7d 14             	mov    %edi,0x14(%ebp)
        		break;
  800885:	e9 12 ff ff ff       	jmp    80079c <vprintfmt+0x432>
			putch(ch, putdat);
  80088a:	83 ec 08             	sub    $0x8,%esp
  80088d:	53                   	push   %ebx
  80088e:	6a 25                	push   $0x25
  800890:	ff d6                	call   *%esi
			break;
  800892:	83 c4 10             	add    $0x10,%esp
  800895:	e9 02 ff ff ff       	jmp    80079c <vprintfmt+0x432>
			putch('%', putdat);
  80089a:	83 ec 08             	sub    $0x8,%esp
  80089d:	53                   	push   %ebx
  80089e:	6a 25                	push   $0x25
  8008a0:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008a2:	83 c4 10             	add    $0x10,%esp
  8008a5:	89 f8                	mov    %edi,%eax
  8008a7:	eb 03                	jmp    8008ac <vprintfmt+0x542>
  8008a9:	83 e8 01             	sub    $0x1,%eax
  8008ac:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8008b0:	75 f7                	jne    8008a9 <vprintfmt+0x53f>
  8008b2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008b5:	e9 e2 fe ff ff       	jmp    80079c <vprintfmt+0x432>
}
  8008ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008bd:	5b                   	pop    %ebx
  8008be:	5e                   	pop    %esi
  8008bf:	5f                   	pop    %edi
  8008c0:	5d                   	pop    %ebp
  8008c1:	c3                   	ret    

008008c2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008c2:	55                   	push   %ebp
  8008c3:	89 e5                	mov    %esp,%ebp
  8008c5:	83 ec 18             	sub    $0x18,%esp
  8008c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cb:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008ce:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008d1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008d5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008d8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008df:	85 c0                	test   %eax,%eax
  8008e1:	74 26                	je     800909 <vsnprintf+0x47>
  8008e3:	85 d2                	test   %edx,%edx
  8008e5:	7e 22                	jle    800909 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008e7:	ff 75 14             	pushl  0x14(%ebp)
  8008ea:	ff 75 10             	pushl  0x10(%ebp)
  8008ed:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008f0:	50                   	push   %eax
  8008f1:	68 30 03 80 00       	push   $0x800330
  8008f6:	e8 6f fa ff ff       	call   80036a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008fe:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800901:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800904:	83 c4 10             	add    $0x10,%esp
}
  800907:	c9                   	leave  
  800908:	c3                   	ret    
		return -E_INVAL;
  800909:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80090e:	eb f7                	jmp    800907 <vsnprintf+0x45>

00800910 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800910:	55                   	push   %ebp
  800911:	89 e5                	mov    %esp,%ebp
  800913:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800916:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800919:	50                   	push   %eax
  80091a:	ff 75 10             	pushl  0x10(%ebp)
  80091d:	ff 75 0c             	pushl  0xc(%ebp)
  800920:	ff 75 08             	pushl  0x8(%ebp)
  800923:	e8 9a ff ff ff       	call   8008c2 <vsnprintf>
	va_end(ap);

	return rc;
}
  800928:	c9                   	leave  
  800929:	c3                   	ret    

0080092a <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80092a:	55                   	push   %ebp
  80092b:	89 e5                	mov    %esp,%ebp
  80092d:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800930:	b8 00 00 00 00       	mov    $0x0,%eax
  800935:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800939:	74 05                	je     800940 <strlen+0x16>
		n++;
  80093b:	83 c0 01             	add    $0x1,%eax
  80093e:	eb f5                	jmp    800935 <strlen+0xb>
	return n;
}
  800940:	5d                   	pop    %ebp
  800941:	c3                   	ret    

00800942 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800942:	55                   	push   %ebp
  800943:	89 e5                	mov    %esp,%ebp
  800945:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800948:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80094b:	ba 00 00 00 00       	mov    $0x0,%edx
  800950:	39 c2                	cmp    %eax,%edx
  800952:	74 0d                	je     800961 <strnlen+0x1f>
  800954:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800958:	74 05                	je     80095f <strnlen+0x1d>
		n++;
  80095a:	83 c2 01             	add    $0x1,%edx
  80095d:	eb f1                	jmp    800950 <strnlen+0xe>
  80095f:	89 d0                	mov    %edx,%eax
	return n;
}
  800961:	5d                   	pop    %ebp
  800962:	c3                   	ret    

00800963 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800963:	55                   	push   %ebp
  800964:	89 e5                	mov    %esp,%ebp
  800966:	53                   	push   %ebx
  800967:	8b 45 08             	mov    0x8(%ebp),%eax
  80096a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80096d:	ba 00 00 00 00       	mov    $0x0,%edx
  800972:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800976:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800979:	83 c2 01             	add    $0x1,%edx
  80097c:	84 c9                	test   %cl,%cl
  80097e:	75 f2                	jne    800972 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800980:	5b                   	pop    %ebx
  800981:	5d                   	pop    %ebp
  800982:	c3                   	ret    

00800983 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800983:	55                   	push   %ebp
  800984:	89 e5                	mov    %esp,%ebp
  800986:	53                   	push   %ebx
  800987:	83 ec 10             	sub    $0x10,%esp
  80098a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80098d:	53                   	push   %ebx
  80098e:	e8 97 ff ff ff       	call   80092a <strlen>
  800993:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800996:	ff 75 0c             	pushl  0xc(%ebp)
  800999:	01 d8                	add    %ebx,%eax
  80099b:	50                   	push   %eax
  80099c:	e8 c2 ff ff ff       	call   800963 <strcpy>
	return dst;
}
  8009a1:	89 d8                	mov    %ebx,%eax
  8009a3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009a6:	c9                   	leave  
  8009a7:	c3                   	ret    

008009a8 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009a8:	55                   	push   %ebp
  8009a9:	89 e5                	mov    %esp,%ebp
  8009ab:	56                   	push   %esi
  8009ac:	53                   	push   %ebx
  8009ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009b3:	89 c6                	mov    %eax,%esi
  8009b5:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009b8:	89 c2                	mov    %eax,%edx
  8009ba:	39 f2                	cmp    %esi,%edx
  8009bc:	74 11                	je     8009cf <strncpy+0x27>
		*dst++ = *src;
  8009be:	83 c2 01             	add    $0x1,%edx
  8009c1:	0f b6 19             	movzbl (%ecx),%ebx
  8009c4:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009c7:	80 fb 01             	cmp    $0x1,%bl
  8009ca:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8009cd:	eb eb                	jmp    8009ba <strncpy+0x12>
	}
	return ret;
}
  8009cf:	5b                   	pop    %ebx
  8009d0:	5e                   	pop    %esi
  8009d1:	5d                   	pop    %ebp
  8009d2:	c3                   	ret    

008009d3 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009d3:	55                   	push   %ebp
  8009d4:	89 e5                	mov    %esp,%ebp
  8009d6:	56                   	push   %esi
  8009d7:	53                   	push   %ebx
  8009d8:	8b 75 08             	mov    0x8(%ebp),%esi
  8009db:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009de:	8b 55 10             	mov    0x10(%ebp),%edx
  8009e1:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009e3:	85 d2                	test   %edx,%edx
  8009e5:	74 21                	je     800a08 <strlcpy+0x35>
  8009e7:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009eb:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8009ed:	39 c2                	cmp    %eax,%edx
  8009ef:	74 14                	je     800a05 <strlcpy+0x32>
  8009f1:	0f b6 19             	movzbl (%ecx),%ebx
  8009f4:	84 db                	test   %bl,%bl
  8009f6:	74 0b                	je     800a03 <strlcpy+0x30>
			*dst++ = *src++;
  8009f8:	83 c1 01             	add    $0x1,%ecx
  8009fb:	83 c2 01             	add    $0x1,%edx
  8009fe:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a01:	eb ea                	jmp    8009ed <strlcpy+0x1a>
  800a03:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a05:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a08:	29 f0                	sub    %esi,%eax
}
  800a0a:	5b                   	pop    %ebx
  800a0b:	5e                   	pop    %esi
  800a0c:	5d                   	pop    %ebp
  800a0d:	c3                   	ret    

00800a0e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a0e:	55                   	push   %ebp
  800a0f:	89 e5                	mov    %esp,%ebp
  800a11:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a14:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a17:	0f b6 01             	movzbl (%ecx),%eax
  800a1a:	84 c0                	test   %al,%al
  800a1c:	74 0c                	je     800a2a <strcmp+0x1c>
  800a1e:	3a 02                	cmp    (%edx),%al
  800a20:	75 08                	jne    800a2a <strcmp+0x1c>
		p++, q++;
  800a22:	83 c1 01             	add    $0x1,%ecx
  800a25:	83 c2 01             	add    $0x1,%edx
  800a28:	eb ed                	jmp    800a17 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a2a:	0f b6 c0             	movzbl %al,%eax
  800a2d:	0f b6 12             	movzbl (%edx),%edx
  800a30:	29 d0                	sub    %edx,%eax
}
  800a32:	5d                   	pop    %ebp
  800a33:	c3                   	ret    

00800a34 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a34:	55                   	push   %ebp
  800a35:	89 e5                	mov    %esp,%ebp
  800a37:	53                   	push   %ebx
  800a38:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a3e:	89 c3                	mov    %eax,%ebx
  800a40:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a43:	eb 06                	jmp    800a4b <strncmp+0x17>
		n--, p++, q++;
  800a45:	83 c0 01             	add    $0x1,%eax
  800a48:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a4b:	39 d8                	cmp    %ebx,%eax
  800a4d:	74 16                	je     800a65 <strncmp+0x31>
  800a4f:	0f b6 08             	movzbl (%eax),%ecx
  800a52:	84 c9                	test   %cl,%cl
  800a54:	74 04                	je     800a5a <strncmp+0x26>
  800a56:	3a 0a                	cmp    (%edx),%cl
  800a58:	74 eb                	je     800a45 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a5a:	0f b6 00             	movzbl (%eax),%eax
  800a5d:	0f b6 12             	movzbl (%edx),%edx
  800a60:	29 d0                	sub    %edx,%eax
}
  800a62:	5b                   	pop    %ebx
  800a63:	5d                   	pop    %ebp
  800a64:	c3                   	ret    
		return 0;
  800a65:	b8 00 00 00 00       	mov    $0x0,%eax
  800a6a:	eb f6                	jmp    800a62 <strncmp+0x2e>

00800a6c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a6c:	55                   	push   %ebp
  800a6d:	89 e5                	mov    %esp,%ebp
  800a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a72:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a76:	0f b6 10             	movzbl (%eax),%edx
  800a79:	84 d2                	test   %dl,%dl
  800a7b:	74 09                	je     800a86 <strchr+0x1a>
		if (*s == c)
  800a7d:	38 ca                	cmp    %cl,%dl
  800a7f:	74 0a                	je     800a8b <strchr+0x1f>
	for (; *s; s++)
  800a81:	83 c0 01             	add    $0x1,%eax
  800a84:	eb f0                	jmp    800a76 <strchr+0xa>
			return (char *) s;
	return 0;
  800a86:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a8b:	5d                   	pop    %ebp
  800a8c:	c3                   	ret    

00800a8d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a8d:	55                   	push   %ebp
  800a8e:	89 e5                	mov    %esp,%ebp
  800a90:	8b 45 08             	mov    0x8(%ebp),%eax
  800a93:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a97:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a9a:	38 ca                	cmp    %cl,%dl
  800a9c:	74 09                	je     800aa7 <strfind+0x1a>
  800a9e:	84 d2                	test   %dl,%dl
  800aa0:	74 05                	je     800aa7 <strfind+0x1a>
	for (; *s; s++)
  800aa2:	83 c0 01             	add    $0x1,%eax
  800aa5:	eb f0                	jmp    800a97 <strfind+0xa>
			break;
	return (char *) s;
}
  800aa7:	5d                   	pop    %ebp
  800aa8:	c3                   	ret    

00800aa9 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800aa9:	55                   	push   %ebp
  800aaa:	89 e5                	mov    %esp,%ebp
  800aac:	57                   	push   %edi
  800aad:	56                   	push   %esi
  800aae:	53                   	push   %ebx
  800aaf:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ab2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ab5:	85 c9                	test   %ecx,%ecx
  800ab7:	74 31                	je     800aea <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ab9:	89 f8                	mov    %edi,%eax
  800abb:	09 c8                	or     %ecx,%eax
  800abd:	a8 03                	test   $0x3,%al
  800abf:	75 23                	jne    800ae4 <memset+0x3b>
		c &= 0xFF;
  800ac1:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ac5:	89 d3                	mov    %edx,%ebx
  800ac7:	c1 e3 08             	shl    $0x8,%ebx
  800aca:	89 d0                	mov    %edx,%eax
  800acc:	c1 e0 18             	shl    $0x18,%eax
  800acf:	89 d6                	mov    %edx,%esi
  800ad1:	c1 e6 10             	shl    $0x10,%esi
  800ad4:	09 f0                	or     %esi,%eax
  800ad6:	09 c2                	or     %eax,%edx
  800ad8:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800ada:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800add:	89 d0                	mov    %edx,%eax
  800adf:	fc                   	cld    
  800ae0:	f3 ab                	rep stos %eax,%es:(%edi)
  800ae2:	eb 06                	jmp    800aea <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ae4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae7:	fc                   	cld    
  800ae8:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800aea:	89 f8                	mov    %edi,%eax
  800aec:	5b                   	pop    %ebx
  800aed:	5e                   	pop    %esi
  800aee:	5f                   	pop    %edi
  800aef:	5d                   	pop    %ebp
  800af0:	c3                   	ret    

00800af1 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800af1:	55                   	push   %ebp
  800af2:	89 e5                	mov    %esp,%ebp
  800af4:	57                   	push   %edi
  800af5:	56                   	push   %esi
  800af6:	8b 45 08             	mov    0x8(%ebp),%eax
  800af9:	8b 75 0c             	mov    0xc(%ebp),%esi
  800afc:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800aff:	39 c6                	cmp    %eax,%esi
  800b01:	73 32                	jae    800b35 <memmove+0x44>
  800b03:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b06:	39 c2                	cmp    %eax,%edx
  800b08:	76 2b                	jbe    800b35 <memmove+0x44>
		s += n;
		d += n;
  800b0a:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b0d:	89 fe                	mov    %edi,%esi
  800b0f:	09 ce                	or     %ecx,%esi
  800b11:	09 d6                	or     %edx,%esi
  800b13:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b19:	75 0e                	jne    800b29 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b1b:	83 ef 04             	sub    $0x4,%edi
  800b1e:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b21:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b24:	fd                   	std    
  800b25:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b27:	eb 09                	jmp    800b32 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b29:	83 ef 01             	sub    $0x1,%edi
  800b2c:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b2f:	fd                   	std    
  800b30:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b32:	fc                   	cld    
  800b33:	eb 1a                	jmp    800b4f <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b35:	89 c2                	mov    %eax,%edx
  800b37:	09 ca                	or     %ecx,%edx
  800b39:	09 f2                	or     %esi,%edx
  800b3b:	f6 c2 03             	test   $0x3,%dl
  800b3e:	75 0a                	jne    800b4a <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b40:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b43:	89 c7                	mov    %eax,%edi
  800b45:	fc                   	cld    
  800b46:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b48:	eb 05                	jmp    800b4f <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b4a:	89 c7                	mov    %eax,%edi
  800b4c:	fc                   	cld    
  800b4d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b4f:	5e                   	pop    %esi
  800b50:	5f                   	pop    %edi
  800b51:	5d                   	pop    %ebp
  800b52:	c3                   	ret    

00800b53 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b53:	55                   	push   %ebp
  800b54:	89 e5                	mov    %esp,%ebp
  800b56:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b59:	ff 75 10             	pushl  0x10(%ebp)
  800b5c:	ff 75 0c             	pushl  0xc(%ebp)
  800b5f:	ff 75 08             	pushl  0x8(%ebp)
  800b62:	e8 8a ff ff ff       	call   800af1 <memmove>
}
  800b67:	c9                   	leave  
  800b68:	c3                   	ret    

00800b69 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b69:	55                   	push   %ebp
  800b6a:	89 e5                	mov    %esp,%ebp
  800b6c:	56                   	push   %esi
  800b6d:	53                   	push   %ebx
  800b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b71:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b74:	89 c6                	mov    %eax,%esi
  800b76:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b79:	39 f0                	cmp    %esi,%eax
  800b7b:	74 1c                	je     800b99 <memcmp+0x30>
		if (*s1 != *s2)
  800b7d:	0f b6 08             	movzbl (%eax),%ecx
  800b80:	0f b6 1a             	movzbl (%edx),%ebx
  800b83:	38 d9                	cmp    %bl,%cl
  800b85:	75 08                	jne    800b8f <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b87:	83 c0 01             	add    $0x1,%eax
  800b8a:	83 c2 01             	add    $0x1,%edx
  800b8d:	eb ea                	jmp    800b79 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b8f:	0f b6 c1             	movzbl %cl,%eax
  800b92:	0f b6 db             	movzbl %bl,%ebx
  800b95:	29 d8                	sub    %ebx,%eax
  800b97:	eb 05                	jmp    800b9e <memcmp+0x35>
	}

	return 0;
  800b99:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b9e:	5b                   	pop    %ebx
  800b9f:	5e                   	pop    %esi
  800ba0:	5d                   	pop    %ebp
  800ba1:	c3                   	ret    

00800ba2 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ba2:	55                   	push   %ebp
  800ba3:	89 e5                	mov    %esp,%ebp
  800ba5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800bab:	89 c2                	mov    %eax,%edx
  800bad:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bb0:	39 d0                	cmp    %edx,%eax
  800bb2:	73 09                	jae    800bbd <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bb4:	38 08                	cmp    %cl,(%eax)
  800bb6:	74 05                	je     800bbd <memfind+0x1b>
	for (; s < ends; s++)
  800bb8:	83 c0 01             	add    $0x1,%eax
  800bbb:	eb f3                	jmp    800bb0 <memfind+0xe>
			break;
	return (void *) s;
}
  800bbd:	5d                   	pop    %ebp
  800bbe:	c3                   	ret    

00800bbf <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bbf:	55                   	push   %ebp
  800bc0:	89 e5                	mov    %esp,%ebp
  800bc2:	57                   	push   %edi
  800bc3:	56                   	push   %esi
  800bc4:	53                   	push   %ebx
  800bc5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bc8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bcb:	eb 03                	jmp    800bd0 <strtol+0x11>
		s++;
  800bcd:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800bd0:	0f b6 01             	movzbl (%ecx),%eax
  800bd3:	3c 20                	cmp    $0x20,%al
  800bd5:	74 f6                	je     800bcd <strtol+0xe>
  800bd7:	3c 09                	cmp    $0x9,%al
  800bd9:	74 f2                	je     800bcd <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800bdb:	3c 2b                	cmp    $0x2b,%al
  800bdd:	74 2a                	je     800c09 <strtol+0x4a>
	int neg = 0;
  800bdf:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800be4:	3c 2d                	cmp    $0x2d,%al
  800be6:	74 2b                	je     800c13 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800be8:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bee:	75 0f                	jne    800bff <strtol+0x40>
  800bf0:	80 39 30             	cmpb   $0x30,(%ecx)
  800bf3:	74 28                	je     800c1d <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bf5:	85 db                	test   %ebx,%ebx
  800bf7:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bfc:	0f 44 d8             	cmove  %eax,%ebx
  800bff:	b8 00 00 00 00       	mov    $0x0,%eax
  800c04:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c07:	eb 50                	jmp    800c59 <strtol+0x9a>
		s++;
  800c09:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c0c:	bf 00 00 00 00       	mov    $0x0,%edi
  800c11:	eb d5                	jmp    800be8 <strtol+0x29>
		s++, neg = 1;
  800c13:	83 c1 01             	add    $0x1,%ecx
  800c16:	bf 01 00 00 00       	mov    $0x1,%edi
  800c1b:	eb cb                	jmp    800be8 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c1d:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c21:	74 0e                	je     800c31 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c23:	85 db                	test   %ebx,%ebx
  800c25:	75 d8                	jne    800bff <strtol+0x40>
		s++, base = 8;
  800c27:	83 c1 01             	add    $0x1,%ecx
  800c2a:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c2f:	eb ce                	jmp    800bff <strtol+0x40>
		s += 2, base = 16;
  800c31:	83 c1 02             	add    $0x2,%ecx
  800c34:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c39:	eb c4                	jmp    800bff <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c3b:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c3e:	89 f3                	mov    %esi,%ebx
  800c40:	80 fb 19             	cmp    $0x19,%bl
  800c43:	77 29                	ja     800c6e <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c45:	0f be d2             	movsbl %dl,%edx
  800c48:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c4b:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c4e:	7d 30                	jge    800c80 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c50:	83 c1 01             	add    $0x1,%ecx
  800c53:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c57:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c59:	0f b6 11             	movzbl (%ecx),%edx
  800c5c:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c5f:	89 f3                	mov    %esi,%ebx
  800c61:	80 fb 09             	cmp    $0x9,%bl
  800c64:	77 d5                	ja     800c3b <strtol+0x7c>
			dig = *s - '0';
  800c66:	0f be d2             	movsbl %dl,%edx
  800c69:	83 ea 30             	sub    $0x30,%edx
  800c6c:	eb dd                	jmp    800c4b <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c6e:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c71:	89 f3                	mov    %esi,%ebx
  800c73:	80 fb 19             	cmp    $0x19,%bl
  800c76:	77 08                	ja     800c80 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c78:	0f be d2             	movsbl %dl,%edx
  800c7b:	83 ea 37             	sub    $0x37,%edx
  800c7e:	eb cb                	jmp    800c4b <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c80:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c84:	74 05                	je     800c8b <strtol+0xcc>
		*endptr = (char *) s;
  800c86:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c89:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c8b:	89 c2                	mov    %eax,%edx
  800c8d:	f7 da                	neg    %edx
  800c8f:	85 ff                	test   %edi,%edi
  800c91:	0f 45 c2             	cmovne %edx,%eax
}
  800c94:	5b                   	pop    %ebx
  800c95:	5e                   	pop    %esi
  800c96:	5f                   	pop    %edi
  800c97:	5d                   	pop    %ebp
  800c98:	c3                   	ret    

00800c99 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c99:	55                   	push   %ebp
  800c9a:	89 e5                	mov    %esp,%ebp
  800c9c:	57                   	push   %edi
  800c9d:	56                   	push   %esi
  800c9e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c9f:	b8 00 00 00 00       	mov    $0x0,%eax
  800ca4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800caa:	89 c3                	mov    %eax,%ebx
  800cac:	89 c7                	mov    %eax,%edi
  800cae:	89 c6                	mov    %eax,%esi
  800cb0:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cb2:	5b                   	pop    %ebx
  800cb3:	5e                   	pop    %esi
  800cb4:	5f                   	pop    %edi
  800cb5:	5d                   	pop    %ebp
  800cb6:	c3                   	ret    

00800cb7 <sys_cgetc>:

int
sys_cgetc(void)
{
  800cb7:	55                   	push   %ebp
  800cb8:	89 e5                	mov    %esp,%ebp
  800cba:	57                   	push   %edi
  800cbb:	56                   	push   %esi
  800cbc:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cbd:	ba 00 00 00 00       	mov    $0x0,%edx
  800cc2:	b8 01 00 00 00       	mov    $0x1,%eax
  800cc7:	89 d1                	mov    %edx,%ecx
  800cc9:	89 d3                	mov    %edx,%ebx
  800ccb:	89 d7                	mov    %edx,%edi
  800ccd:	89 d6                	mov    %edx,%esi
  800ccf:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cd1:	5b                   	pop    %ebx
  800cd2:	5e                   	pop    %esi
  800cd3:	5f                   	pop    %edi
  800cd4:	5d                   	pop    %ebp
  800cd5:	c3                   	ret    

00800cd6 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cd6:	55                   	push   %ebp
  800cd7:	89 e5                	mov    %esp,%ebp
  800cd9:	57                   	push   %edi
  800cda:	56                   	push   %esi
  800cdb:	53                   	push   %ebx
  800cdc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cdf:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ce4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce7:	b8 03 00 00 00       	mov    $0x3,%eax
  800cec:	89 cb                	mov    %ecx,%ebx
  800cee:	89 cf                	mov    %ecx,%edi
  800cf0:	89 ce                	mov    %ecx,%esi
  800cf2:	cd 30                	int    $0x30
	if (check && ret > 0)
  800cf4:	85 c0                	test   %eax,%eax
  800cf6:	7f 08                	jg     800d00 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cf8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cfb:	5b                   	pop    %ebx
  800cfc:	5e                   	pop    %esi
  800cfd:	5f                   	pop    %edi
  800cfe:	5d                   	pop    %ebp
  800cff:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d00:	83 ec 0c             	sub    $0xc,%esp
  800d03:	50                   	push   %eax
  800d04:	6a 03                	push   $0x3
  800d06:	68 e0 15 80 00       	push   $0x8015e0
  800d0b:	6a 4c                	push   $0x4c
  800d0d:	68 fd 15 80 00       	push   $0x8015fd
  800d12:	e8 70 02 00 00       	call   800f87 <_panic>

00800d17 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d17:	55                   	push   %ebp
  800d18:	89 e5                	mov    %esp,%ebp
  800d1a:	57                   	push   %edi
  800d1b:	56                   	push   %esi
  800d1c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d1d:	ba 00 00 00 00       	mov    $0x0,%edx
  800d22:	b8 02 00 00 00       	mov    $0x2,%eax
  800d27:	89 d1                	mov    %edx,%ecx
  800d29:	89 d3                	mov    %edx,%ebx
  800d2b:	89 d7                	mov    %edx,%edi
  800d2d:	89 d6                	mov    %edx,%esi
  800d2f:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d31:	5b                   	pop    %ebx
  800d32:	5e                   	pop    %esi
  800d33:	5f                   	pop    %edi
  800d34:	5d                   	pop    %ebp
  800d35:	c3                   	ret    

00800d36 <sys_yield>:

void
sys_yield(void)
{
  800d36:	55                   	push   %ebp
  800d37:	89 e5                	mov    %esp,%ebp
  800d39:	57                   	push   %edi
  800d3a:	56                   	push   %esi
  800d3b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d3c:	ba 00 00 00 00       	mov    $0x0,%edx
  800d41:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d46:	89 d1                	mov    %edx,%ecx
  800d48:	89 d3                	mov    %edx,%ebx
  800d4a:	89 d7                	mov    %edx,%edi
  800d4c:	89 d6                	mov    %edx,%esi
  800d4e:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d50:	5b                   	pop    %ebx
  800d51:	5e                   	pop    %esi
  800d52:	5f                   	pop    %edi
  800d53:	5d                   	pop    %ebp
  800d54:	c3                   	ret    

00800d55 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d55:	55                   	push   %ebp
  800d56:	89 e5                	mov    %esp,%ebp
  800d58:	57                   	push   %edi
  800d59:	56                   	push   %esi
  800d5a:	53                   	push   %ebx
  800d5b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d5e:	be 00 00 00 00       	mov    $0x0,%esi
  800d63:	8b 55 08             	mov    0x8(%ebp),%edx
  800d66:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d69:	b8 04 00 00 00       	mov    $0x4,%eax
  800d6e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d71:	89 f7                	mov    %esi,%edi
  800d73:	cd 30                	int    $0x30
	if (check && ret > 0)
  800d75:	85 c0                	test   %eax,%eax
  800d77:	7f 08                	jg     800d81 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d79:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d7c:	5b                   	pop    %ebx
  800d7d:	5e                   	pop    %esi
  800d7e:	5f                   	pop    %edi
  800d7f:	5d                   	pop    %ebp
  800d80:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d81:	83 ec 0c             	sub    $0xc,%esp
  800d84:	50                   	push   %eax
  800d85:	6a 04                	push   $0x4
  800d87:	68 e0 15 80 00       	push   $0x8015e0
  800d8c:	6a 4c                	push   $0x4c
  800d8e:	68 fd 15 80 00       	push   $0x8015fd
  800d93:	e8 ef 01 00 00       	call   800f87 <_panic>

00800d98 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d98:	55                   	push   %ebp
  800d99:	89 e5                	mov    %esp,%ebp
  800d9b:	57                   	push   %edi
  800d9c:	56                   	push   %esi
  800d9d:	53                   	push   %ebx
  800d9e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800da1:	8b 55 08             	mov    0x8(%ebp),%edx
  800da4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da7:	b8 05 00 00 00       	mov    $0x5,%eax
  800dac:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800daf:	8b 7d 14             	mov    0x14(%ebp),%edi
  800db2:	8b 75 18             	mov    0x18(%ebp),%esi
  800db5:	cd 30                	int    $0x30
	if (check && ret > 0)
  800db7:	85 c0                	test   %eax,%eax
  800db9:	7f 08                	jg     800dc3 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800dbb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dbe:	5b                   	pop    %ebx
  800dbf:	5e                   	pop    %esi
  800dc0:	5f                   	pop    %edi
  800dc1:	5d                   	pop    %ebp
  800dc2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dc3:	83 ec 0c             	sub    $0xc,%esp
  800dc6:	50                   	push   %eax
  800dc7:	6a 05                	push   $0x5
  800dc9:	68 e0 15 80 00       	push   $0x8015e0
  800dce:	6a 4c                	push   $0x4c
  800dd0:	68 fd 15 80 00       	push   $0x8015fd
  800dd5:	e8 ad 01 00 00       	call   800f87 <_panic>

00800dda <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800dda:	55                   	push   %ebp
  800ddb:	89 e5                	mov    %esp,%ebp
  800ddd:	57                   	push   %edi
  800dde:	56                   	push   %esi
  800ddf:	53                   	push   %ebx
  800de0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800de3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800de8:	8b 55 08             	mov    0x8(%ebp),%edx
  800deb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dee:	b8 06 00 00 00       	mov    $0x6,%eax
  800df3:	89 df                	mov    %ebx,%edi
  800df5:	89 de                	mov    %ebx,%esi
  800df7:	cd 30                	int    $0x30
	if (check && ret > 0)
  800df9:	85 c0                	test   %eax,%eax
  800dfb:	7f 08                	jg     800e05 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800dfd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e00:	5b                   	pop    %ebx
  800e01:	5e                   	pop    %esi
  800e02:	5f                   	pop    %edi
  800e03:	5d                   	pop    %ebp
  800e04:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e05:	83 ec 0c             	sub    $0xc,%esp
  800e08:	50                   	push   %eax
  800e09:	6a 06                	push   $0x6
  800e0b:	68 e0 15 80 00       	push   $0x8015e0
  800e10:	6a 4c                	push   $0x4c
  800e12:	68 fd 15 80 00       	push   $0x8015fd
  800e17:	e8 6b 01 00 00       	call   800f87 <_panic>

00800e1c <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e1c:	55                   	push   %ebp
  800e1d:	89 e5                	mov    %esp,%ebp
  800e1f:	57                   	push   %edi
  800e20:	56                   	push   %esi
  800e21:	53                   	push   %ebx
  800e22:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e25:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e2a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e30:	b8 08 00 00 00       	mov    $0x8,%eax
  800e35:	89 df                	mov    %ebx,%edi
  800e37:	89 de                	mov    %ebx,%esi
  800e39:	cd 30                	int    $0x30
	if (check && ret > 0)
  800e3b:	85 c0                	test   %eax,%eax
  800e3d:	7f 08                	jg     800e47 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e3f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e42:	5b                   	pop    %ebx
  800e43:	5e                   	pop    %esi
  800e44:	5f                   	pop    %edi
  800e45:	5d                   	pop    %ebp
  800e46:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e47:	83 ec 0c             	sub    $0xc,%esp
  800e4a:	50                   	push   %eax
  800e4b:	6a 08                	push   $0x8
  800e4d:	68 e0 15 80 00       	push   $0x8015e0
  800e52:	6a 4c                	push   $0x4c
  800e54:	68 fd 15 80 00       	push   $0x8015fd
  800e59:	e8 29 01 00 00       	call   800f87 <_panic>

00800e5e <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e5e:	55                   	push   %ebp
  800e5f:	89 e5                	mov    %esp,%ebp
  800e61:	57                   	push   %edi
  800e62:	56                   	push   %esi
  800e63:	53                   	push   %ebx
  800e64:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e67:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e6c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e6f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e72:	b8 09 00 00 00       	mov    $0x9,%eax
  800e77:	89 df                	mov    %ebx,%edi
  800e79:	89 de                	mov    %ebx,%esi
  800e7b:	cd 30                	int    $0x30
	if (check && ret > 0)
  800e7d:	85 c0                	test   %eax,%eax
  800e7f:	7f 08                	jg     800e89 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e81:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e84:	5b                   	pop    %ebx
  800e85:	5e                   	pop    %esi
  800e86:	5f                   	pop    %edi
  800e87:	5d                   	pop    %ebp
  800e88:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e89:	83 ec 0c             	sub    $0xc,%esp
  800e8c:	50                   	push   %eax
  800e8d:	6a 09                	push   $0x9
  800e8f:	68 e0 15 80 00       	push   $0x8015e0
  800e94:	6a 4c                	push   $0x4c
  800e96:	68 fd 15 80 00       	push   $0x8015fd
  800e9b:	e8 e7 00 00 00       	call   800f87 <_panic>

00800ea0 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ea0:	55                   	push   %ebp
  800ea1:	89 e5                	mov    %esp,%ebp
  800ea3:	57                   	push   %edi
  800ea4:	56                   	push   %esi
  800ea5:	53                   	push   %ebx
  800ea6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ea9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eae:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb4:	b8 0a 00 00 00       	mov    $0xa,%eax
  800eb9:	89 df                	mov    %ebx,%edi
  800ebb:	89 de                	mov    %ebx,%esi
  800ebd:	cd 30                	int    $0x30
	if (check && ret > 0)
  800ebf:	85 c0                	test   %eax,%eax
  800ec1:	7f 08                	jg     800ecb <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
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
  800ecf:	6a 0a                	push   $0xa
  800ed1:	68 e0 15 80 00       	push   $0x8015e0
  800ed6:	6a 4c                	push   $0x4c
  800ed8:	68 fd 15 80 00       	push   $0x8015fd
  800edd:	e8 a5 00 00 00       	call   800f87 <_panic>

00800ee2 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ee2:	55                   	push   %ebp
  800ee3:	89 e5                	mov    %esp,%ebp
  800ee5:	57                   	push   %edi
  800ee6:	56                   	push   %esi
  800ee7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ee8:	8b 55 08             	mov    0x8(%ebp),%edx
  800eeb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eee:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ef3:	be 00 00 00 00       	mov    $0x0,%esi
  800ef8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800efb:	8b 7d 14             	mov    0x14(%ebp),%edi
  800efe:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f00:	5b                   	pop    %ebx
  800f01:	5e                   	pop    %esi
  800f02:	5f                   	pop    %edi
  800f03:	5d                   	pop    %ebp
  800f04:	c3                   	ret    

00800f05 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f05:	55                   	push   %ebp
  800f06:	89 e5                	mov    %esp,%ebp
  800f08:	57                   	push   %edi
  800f09:	56                   	push   %esi
  800f0a:	53                   	push   %ebx
  800f0b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f0e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f13:	8b 55 08             	mov    0x8(%ebp),%edx
  800f16:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f1b:	89 cb                	mov    %ecx,%ebx
  800f1d:	89 cf                	mov    %ecx,%edi
  800f1f:	89 ce                	mov    %ecx,%esi
  800f21:	cd 30                	int    $0x30
	if (check && ret > 0)
  800f23:	85 c0                	test   %eax,%eax
  800f25:	7f 08                	jg     800f2f <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
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
  800f33:	6a 0d                	push   $0xd
  800f35:	68 e0 15 80 00       	push   $0x8015e0
  800f3a:	6a 4c                	push   $0x4c
  800f3c:	68 fd 15 80 00       	push   $0x8015fd
  800f41:	e8 41 00 00 00       	call   800f87 <_panic>

00800f46 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f46:	55                   	push   %ebp
  800f47:	89 e5                	mov    %esp,%ebp
  800f49:	57                   	push   %edi
  800f4a:	56                   	push   %esi
  800f4b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f4c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f51:	8b 55 08             	mov    0x8(%ebp),%edx
  800f54:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f57:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f5c:	89 df                	mov    %ebx,%edi
  800f5e:	89 de                	mov    %ebx,%esi
  800f60:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f62:	5b                   	pop    %ebx
  800f63:	5e                   	pop    %esi
  800f64:	5f                   	pop    %edi
  800f65:	5d                   	pop    %ebp
  800f66:	c3                   	ret    

00800f67 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f67:	55                   	push   %ebp
  800f68:	89 e5                	mov    %esp,%ebp
  800f6a:	57                   	push   %edi
  800f6b:	56                   	push   %esi
  800f6c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f6d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f72:	8b 55 08             	mov    0x8(%ebp),%edx
  800f75:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f7a:	89 cb                	mov    %ecx,%ebx
  800f7c:	89 cf                	mov    %ecx,%edi
  800f7e:	89 ce                	mov    %ecx,%esi
  800f80:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f82:	5b                   	pop    %ebx
  800f83:	5e                   	pop    %esi
  800f84:	5f                   	pop    %edi
  800f85:	5d                   	pop    %ebp
  800f86:	c3                   	ret    

00800f87 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800f87:	55                   	push   %ebp
  800f88:	89 e5                	mov    %esp,%ebp
  800f8a:	56                   	push   %esi
  800f8b:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800f8c:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800f8f:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800f95:	e8 7d fd ff ff       	call   800d17 <sys_getenvid>
  800f9a:	83 ec 0c             	sub    $0xc,%esp
  800f9d:	ff 75 0c             	pushl  0xc(%ebp)
  800fa0:	ff 75 08             	pushl  0x8(%ebp)
  800fa3:	56                   	push   %esi
  800fa4:	50                   	push   %eax
  800fa5:	68 0c 16 80 00       	push   $0x80160c
  800faa:	e8 8e f2 ff ff       	call   80023d <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800faf:	83 c4 18             	add    $0x18,%esp
  800fb2:	53                   	push   %ebx
  800fb3:	ff 75 10             	pushl  0x10(%ebp)
  800fb6:	e8 31 f2 ff ff       	call   8001ec <vcprintf>
	cprintf("\n");
  800fbb:	c7 04 24 30 16 80 00 	movl   $0x801630,(%esp)
  800fc2:	e8 76 f2 ff ff       	call   80023d <cprintf>
  800fc7:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800fca:	cc                   	int3   
  800fcb:	eb fd                	jmp    800fca <_panic+0x43>
  800fcd:	66 90                	xchg   %ax,%ax
  800fcf:	90                   	nop

00800fd0 <__udivdi3>:
  800fd0:	55                   	push   %ebp
  800fd1:	57                   	push   %edi
  800fd2:	56                   	push   %esi
  800fd3:	53                   	push   %ebx
  800fd4:	83 ec 1c             	sub    $0x1c,%esp
  800fd7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800fdb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800fdf:	8b 74 24 34          	mov    0x34(%esp),%esi
  800fe3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800fe7:	85 d2                	test   %edx,%edx
  800fe9:	75 4d                	jne    801038 <__udivdi3+0x68>
  800feb:	39 f3                	cmp    %esi,%ebx
  800fed:	76 19                	jbe    801008 <__udivdi3+0x38>
  800fef:	31 ff                	xor    %edi,%edi
  800ff1:	89 e8                	mov    %ebp,%eax
  800ff3:	89 f2                	mov    %esi,%edx
  800ff5:	f7 f3                	div    %ebx
  800ff7:	89 fa                	mov    %edi,%edx
  800ff9:	83 c4 1c             	add    $0x1c,%esp
  800ffc:	5b                   	pop    %ebx
  800ffd:	5e                   	pop    %esi
  800ffe:	5f                   	pop    %edi
  800fff:	5d                   	pop    %ebp
  801000:	c3                   	ret    
  801001:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801008:	89 d9                	mov    %ebx,%ecx
  80100a:	85 db                	test   %ebx,%ebx
  80100c:	75 0b                	jne    801019 <__udivdi3+0x49>
  80100e:	b8 01 00 00 00       	mov    $0x1,%eax
  801013:	31 d2                	xor    %edx,%edx
  801015:	f7 f3                	div    %ebx
  801017:	89 c1                	mov    %eax,%ecx
  801019:	31 d2                	xor    %edx,%edx
  80101b:	89 f0                	mov    %esi,%eax
  80101d:	f7 f1                	div    %ecx
  80101f:	89 c6                	mov    %eax,%esi
  801021:	89 e8                	mov    %ebp,%eax
  801023:	89 f7                	mov    %esi,%edi
  801025:	f7 f1                	div    %ecx
  801027:	89 fa                	mov    %edi,%edx
  801029:	83 c4 1c             	add    $0x1c,%esp
  80102c:	5b                   	pop    %ebx
  80102d:	5e                   	pop    %esi
  80102e:	5f                   	pop    %edi
  80102f:	5d                   	pop    %ebp
  801030:	c3                   	ret    
  801031:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801038:	39 f2                	cmp    %esi,%edx
  80103a:	77 1c                	ja     801058 <__udivdi3+0x88>
  80103c:	0f bd fa             	bsr    %edx,%edi
  80103f:	83 f7 1f             	xor    $0x1f,%edi
  801042:	75 2c                	jne    801070 <__udivdi3+0xa0>
  801044:	39 f2                	cmp    %esi,%edx
  801046:	72 06                	jb     80104e <__udivdi3+0x7e>
  801048:	31 c0                	xor    %eax,%eax
  80104a:	39 eb                	cmp    %ebp,%ebx
  80104c:	77 a9                	ja     800ff7 <__udivdi3+0x27>
  80104e:	b8 01 00 00 00       	mov    $0x1,%eax
  801053:	eb a2                	jmp    800ff7 <__udivdi3+0x27>
  801055:	8d 76 00             	lea    0x0(%esi),%esi
  801058:	31 ff                	xor    %edi,%edi
  80105a:	31 c0                	xor    %eax,%eax
  80105c:	89 fa                	mov    %edi,%edx
  80105e:	83 c4 1c             	add    $0x1c,%esp
  801061:	5b                   	pop    %ebx
  801062:	5e                   	pop    %esi
  801063:	5f                   	pop    %edi
  801064:	5d                   	pop    %ebp
  801065:	c3                   	ret    
  801066:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80106d:	8d 76 00             	lea    0x0(%esi),%esi
  801070:	89 f9                	mov    %edi,%ecx
  801072:	b8 20 00 00 00       	mov    $0x20,%eax
  801077:	29 f8                	sub    %edi,%eax
  801079:	d3 e2                	shl    %cl,%edx
  80107b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80107f:	89 c1                	mov    %eax,%ecx
  801081:	89 da                	mov    %ebx,%edx
  801083:	d3 ea                	shr    %cl,%edx
  801085:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801089:	09 d1                	or     %edx,%ecx
  80108b:	89 f2                	mov    %esi,%edx
  80108d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801091:	89 f9                	mov    %edi,%ecx
  801093:	d3 e3                	shl    %cl,%ebx
  801095:	89 c1                	mov    %eax,%ecx
  801097:	d3 ea                	shr    %cl,%edx
  801099:	89 f9                	mov    %edi,%ecx
  80109b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80109f:	89 eb                	mov    %ebp,%ebx
  8010a1:	d3 e6                	shl    %cl,%esi
  8010a3:	89 c1                	mov    %eax,%ecx
  8010a5:	d3 eb                	shr    %cl,%ebx
  8010a7:	09 de                	or     %ebx,%esi
  8010a9:	89 f0                	mov    %esi,%eax
  8010ab:	f7 74 24 08          	divl   0x8(%esp)
  8010af:	89 d6                	mov    %edx,%esi
  8010b1:	89 c3                	mov    %eax,%ebx
  8010b3:	f7 64 24 0c          	mull   0xc(%esp)
  8010b7:	39 d6                	cmp    %edx,%esi
  8010b9:	72 15                	jb     8010d0 <__udivdi3+0x100>
  8010bb:	89 f9                	mov    %edi,%ecx
  8010bd:	d3 e5                	shl    %cl,%ebp
  8010bf:	39 c5                	cmp    %eax,%ebp
  8010c1:	73 04                	jae    8010c7 <__udivdi3+0xf7>
  8010c3:	39 d6                	cmp    %edx,%esi
  8010c5:	74 09                	je     8010d0 <__udivdi3+0x100>
  8010c7:	89 d8                	mov    %ebx,%eax
  8010c9:	31 ff                	xor    %edi,%edi
  8010cb:	e9 27 ff ff ff       	jmp    800ff7 <__udivdi3+0x27>
  8010d0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8010d3:	31 ff                	xor    %edi,%edi
  8010d5:	e9 1d ff ff ff       	jmp    800ff7 <__udivdi3+0x27>
  8010da:	66 90                	xchg   %ax,%ax
  8010dc:	66 90                	xchg   %ax,%ax
  8010de:	66 90                	xchg   %ax,%ax

008010e0 <__umoddi3>:
  8010e0:	55                   	push   %ebp
  8010e1:	57                   	push   %edi
  8010e2:	56                   	push   %esi
  8010e3:	53                   	push   %ebx
  8010e4:	83 ec 1c             	sub    $0x1c,%esp
  8010e7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8010eb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8010ef:	8b 74 24 30          	mov    0x30(%esp),%esi
  8010f3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8010f7:	89 da                	mov    %ebx,%edx
  8010f9:	85 c0                	test   %eax,%eax
  8010fb:	75 43                	jne    801140 <__umoddi3+0x60>
  8010fd:	39 df                	cmp    %ebx,%edi
  8010ff:	76 17                	jbe    801118 <__umoddi3+0x38>
  801101:	89 f0                	mov    %esi,%eax
  801103:	f7 f7                	div    %edi
  801105:	89 d0                	mov    %edx,%eax
  801107:	31 d2                	xor    %edx,%edx
  801109:	83 c4 1c             	add    $0x1c,%esp
  80110c:	5b                   	pop    %ebx
  80110d:	5e                   	pop    %esi
  80110e:	5f                   	pop    %edi
  80110f:	5d                   	pop    %ebp
  801110:	c3                   	ret    
  801111:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801118:	89 fd                	mov    %edi,%ebp
  80111a:	85 ff                	test   %edi,%edi
  80111c:	75 0b                	jne    801129 <__umoddi3+0x49>
  80111e:	b8 01 00 00 00       	mov    $0x1,%eax
  801123:	31 d2                	xor    %edx,%edx
  801125:	f7 f7                	div    %edi
  801127:	89 c5                	mov    %eax,%ebp
  801129:	89 d8                	mov    %ebx,%eax
  80112b:	31 d2                	xor    %edx,%edx
  80112d:	f7 f5                	div    %ebp
  80112f:	89 f0                	mov    %esi,%eax
  801131:	f7 f5                	div    %ebp
  801133:	89 d0                	mov    %edx,%eax
  801135:	eb d0                	jmp    801107 <__umoddi3+0x27>
  801137:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80113e:	66 90                	xchg   %ax,%ax
  801140:	89 f1                	mov    %esi,%ecx
  801142:	39 d8                	cmp    %ebx,%eax
  801144:	76 0a                	jbe    801150 <__umoddi3+0x70>
  801146:	89 f0                	mov    %esi,%eax
  801148:	83 c4 1c             	add    $0x1c,%esp
  80114b:	5b                   	pop    %ebx
  80114c:	5e                   	pop    %esi
  80114d:	5f                   	pop    %edi
  80114e:	5d                   	pop    %ebp
  80114f:	c3                   	ret    
  801150:	0f bd e8             	bsr    %eax,%ebp
  801153:	83 f5 1f             	xor    $0x1f,%ebp
  801156:	75 20                	jne    801178 <__umoddi3+0x98>
  801158:	39 d8                	cmp    %ebx,%eax
  80115a:	0f 82 b0 00 00 00    	jb     801210 <__umoddi3+0x130>
  801160:	39 f7                	cmp    %esi,%edi
  801162:	0f 86 a8 00 00 00    	jbe    801210 <__umoddi3+0x130>
  801168:	89 c8                	mov    %ecx,%eax
  80116a:	83 c4 1c             	add    $0x1c,%esp
  80116d:	5b                   	pop    %ebx
  80116e:	5e                   	pop    %esi
  80116f:	5f                   	pop    %edi
  801170:	5d                   	pop    %ebp
  801171:	c3                   	ret    
  801172:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801178:	89 e9                	mov    %ebp,%ecx
  80117a:	ba 20 00 00 00       	mov    $0x20,%edx
  80117f:	29 ea                	sub    %ebp,%edx
  801181:	d3 e0                	shl    %cl,%eax
  801183:	89 44 24 08          	mov    %eax,0x8(%esp)
  801187:	89 d1                	mov    %edx,%ecx
  801189:	89 f8                	mov    %edi,%eax
  80118b:	d3 e8                	shr    %cl,%eax
  80118d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801191:	89 54 24 04          	mov    %edx,0x4(%esp)
  801195:	8b 54 24 04          	mov    0x4(%esp),%edx
  801199:	09 c1                	or     %eax,%ecx
  80119b:	89 d8                	mov    %ebx,%eax
  80119d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8011a1:	89 e9                	mov    %ebp,%ecx
  8011a3:	d3 e7                	shl    %cl,%edi
  8011a5:	89 d1                	mov    %edx,%ecx
  8011a7:	d3 e8                	shr    %cl,%eax
  8011a9:	89 e9                	mov    %ebp,%ecx
  8011ab:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8011af:	d3 e3                	shl    %cl,%ebx
  8011b1:	89 c7                	mov    %eax,%edi
  8011b3:	89 d1                	mov    %edx,%ecx
  8011b5:	89 f0                	mov    %esi,%eax
  8011b7:	d3 e8                	shr    %cl,%eax
  8011b9:	89 e9                	mov    %ebp,%ecx
  8011bb:	89 fa                	mov    %edi,%edx
  8011bd:	d3 e6                	shl    %cl,%esi
  8011bf:	09 d8                	or     %ebx,%eax
  8011c1:	f7 74 24 08          	divl   0x8(%esp)
  8011c5:	89 d1                	mov    %edx,%ecx
  8011c7:	89 f3                	mov    %esi,%ebx
  8011c9:	f7 64 24 0c          	mull   0xc(%esp)
  8011cd:	89 c6                	mov    %eax,%esi
  8011cf:	89 d7                	mov    %edx,%edi
  8011d1:	39 d1                	cmp    %edx,%ecx
  8011d3:	72 06                	jb     8011db <__umoddi3+0xfb>
  8011d5:	75 10                	jne    8011e7 <__umoddi3+0x107>
  8011d7:	39 c3                	cmp    %eax,%ebx
  8011d9:	73 0c                	jae    8011e7 <__umoddi3+0x107>
  8011db:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8011df:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8011e3:	89 d7                	mov    %edx,%edi
  8011e5:	89 c6                	mov    %eax,%esi
  8011e7:	89 ca                	mov    %ecx,%edx
  8011e9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8011ee:	29 f3                	sub    %esi,%ebx
  8011f0:	19 fa                	sbb    %edi,%edx
  8011f2:	89 d0                	mov    %edx,%eax
  8011f4:	d3 e0                	shl    %cl,%eax
  8011f6:	89 e9                	mov    %ebp,%ecx
  8011f8:	d3 eb                	shr    %cl,%ebx
  8011fa:	d3 ea                	shr    %cl,%edx
  8011fc:	09 d8                	or     %ebx,%eax
  8011fe:	83 c4 1c             	add    $0x1c,%esp
  801201:	5b                   	pop    %ebx
  801202:	5e                   	pop    %esi
  801203:	5f                   	pop    %edi
  801204:	5d                   	pop    %ebp
  801205:	c3                   	ret    
  801206:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80120d:	8d 76 00             	lea    0x0(%esi),%esi
  801210:	89 da                	mov    %ebx,%edx
  801212:	29 fe                	sub    %edi,%esi
  801214:	19 c2                	sbb    %eax,%edx
  801216:	89 f1                	mov    %esi,%ecx
  801218:	89 c8                	mov    %ecx,%eax
  80121a:	e9 4b ff ff ff       	jmp    80116a <__umoddi3+0x8a>
