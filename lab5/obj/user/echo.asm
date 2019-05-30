
obj/user/echo.debug:     file format elf32-i386


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
  80002c:	e8 b3 00 00 00       	call   8000e4 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 1c             	sub    $0x1c,%esp
  80003c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80003f:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i, nflag;

	nflag = 0;
  800042:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  800049:	83 ff 01             	cmp    $0x1,%edi
  80004c:	7f 07                	jg     800055 <umain+0x22>
		nflag = 1;
		argc--;
		argv++;
	}
	for (i = 1; i < argc; i++) {
  80004e:	bb 01 00 00 00       	mov    $0x1,%ebx
  800053:	eb 60                	jmp    8000b5 <umain+0x82>
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  800055:	83 ec 08             	sub    $0x8,%esp
  800058:	68 80 1f 80 00       	push   $0x801f80
  80005d:	ff 76 04             	pushl  0x4(%esi)
  800060:	e8 be 01 00 00       	call   800223 <strcmp>
  800065:	83 c4 10             	add    $0x10,%esp
	nflag = 0;
  800068:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  80006f:	85 c0                	test   %eax,%eax
  800071:	75 db                	jne    80004e <umain+0x1b>
		argc--;
  800073:	83 ef 01             	sub    $0x1,%edi
		argv++;
  800076:	83 c6 04             	add    $0x4,%esi
		nflag = 1;
  800079:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  800080:	eb cc                	jmp    80004e <umain+0x1b>
		if (i > 1)
			write(1, " ", 1);
  800082:	83 ec 04             	sub    $0x4,%esp
  800085:	6a 01                	push   $0x1
  800087:	68 83 1f 80 00       	push   $0x801f83
  80008c:	6a 01                	push   $0x1
  80008e:	e8 b9 0a 00 00       	call   800b4c <write>
  800093:	83 c4 10             	add    $0x10,%esp
		write(1, argv[i], strlen(argv[i]));
  800096:	83 ec 0c             	sub    $0xc,%esp
  800099:	ff 34 9e             	pushl  (%esi,%ebx,4)
  80009c:	e8 9e 00 00 00       	call   80013f <strlen>
  8000a1:	83 c4 0c             	add    $0xc,%esp
  8000a4:	50                   	push   %eax
  8000a5:	ff 34 9e             	pushl  (%esi,%ebx,4)
  8000a8:	6a 01                	push   $0x1
  8000aa:	e8 9d 0a 00 00       	call   800b4c <write>
	for (i = 1; i < argc; i++) {
  8000af:	83 c3 01             	add    $0x1,%ebx
  8000b2:	83 c4 10             	add    $0x10,%esp
  8000b5:	39 df                	cmp    %ebx,%edi
  8000b7:	7e 07                	jle    8000c0 <umain+0x8d>
		if (i > 1)
  8000b9:	83 fb 01             	cmp    $0x1,%ebx
  8000bc:	7f c4                	jg     800082 <umain+0x4f>
  8000be:	eb d6                	jmp    800096 <umain+0x63>
	}
	if (!nflag)
  8000c0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8000c4:	74 08                	je     8000ce <umain+0x9b>
		write(1, "\n", 1);
}
  8000c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000c9:	5b                   	pop    %ebx
  8000ca:	5e                   	pop    %esi
  8000cb:	5f                   	pop    %edi
  8000cc:	5d                   	pop    %ebp
  8000cd:	c3                   	ret    
		write(1, "\n", 1);
  8000ce:	83 ec 04             	sub    $0x4,%esp
  8000d1:	6a 01                	push   $0x1
  8000d3:	68 b1 20 80 00       	push   $0x8020b1
  8000d8:	6a 01                	push   $0x1
  8000da:	e8 6d 0a 00 00       	call   800b4c <write>
  8000df:	83 c4 10             	add    $0x10,%esp
}
  8000e2:	eb e2                	jmp    8000c6 <umain+0x93>

008000e4 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000e4:	55                   	push   %ebp
  8000e5:	89 e5                	mov    %esp,%ebp
  8000e7:	56                   	push   %esi
  8000e8:	53                   	push   %ebx
  8000e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000ec:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	// thisenv = 0;
	thisenv = &(envs[ENVX(sys_getenvid())]);
  8000ef:	e8 38 04 00 00       	call   80052c <sys_getenvid>
  8000f4:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000f9:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8000ff:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800104:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800109:	85 db                	test   %ebx,%ebx
  80010b:	7e 07                	jle    800114 <libmain+0x30>
		binaryname = argv[0];
  80010d:	8b 06                	mov    (%esi),%eax
  80010f:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800114:	83 ec 08             	sub    $0x8,%esp
  800117:	56                   	push   %esi
  800118:	53                   	push   %ebx
  800119:	e8 15 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80011e:	e8 0a 00 00 00       	call   80012d <exit>
}
  800123:	83 c4 10             	add    $0x10,%esp
  800126:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800129:	5b                   	pop    %ebx
  80012a:	5e                   	pop    %esi
  80012b:	5d                   	pop    %ebp
  80012c:	c3                   	ret    

0080012d <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80012d:	55                   	push   %ebp
  80012e:	89 e5                	mov    %esp,%ebp
  800130:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  800133:	6a 00                	push   $0x0
  800135:	e8 b1 03 00 00       	call   8004eb <sys_env_destroy>
}
  80013a:	83 c4 10             	add    $0x10,%esp
  80013d:	c9                   	leave  
  80013e:	c3                   	ret    

0080013f <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80013f:	55                   	push   %ebp
  800140:	89 e5                	mov    %esp,%ebp
  800142:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800145:	b8 00 00 00 00       	mov    $0x0,%eax
  80014a:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80014e:	74 05                	je     800155 <strlen+0x16>
		n++;
  800150:	83 c0 01             	add    $0x1,%eax
  800153:	eb f5                	jmp    80014a <strlen+0xb>
	return n;
}
  800155:	5d                   	pop    %ebp
  800156:	c3                   	ret    

00800157 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800157:	55                   	push   %ebp
  800158:	89 e5                	mov    %esp,%ebp
  80015a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80015d:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800160:	ba 00 00 00 00       	mov    $0x0,%edx
  800165:	39 c2                	cmp    %eax,%edx
  800167:	74 0d                	je     800176 <strnlen+0x1f>
  800169:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  80016d:	74 05                	je     800174 <strnlen+0x1d>
		n++;
  80016f:	83 c2 01             	add    $0x1,%edx
  800172:	eb f1                	jmp    800165 <strnlen+0xe>
  800174:	89 d0                	mov    %edx,%eax
	return n;
}
  800176:	5d                   	pop    %ebp
  800177:	c3                   	ret    

00800178 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800178:	55                   	push   %ebp
  800179:	89 e5                	mov    %esp,%ebp
  80017b:	53                   	push   %ebx
  80017c:	8b 45 08             	mov    0x8(%ebp),%eax
  80017f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800182:	ba 00 00 00 00       	mov    $0x0,%edx
  800187:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80018b:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  80018e:	83 c2 01             	add    $0x1,%edx
  800191:	84 c9                	test   %cl,%cl
  800193:	75 f2                	jne    800187 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800195:	5b                   	pop    %ebx
  800196:	5d                   	pop    %ebp
  800197:	c3                   	ret    

00800198 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800198:	55                   	push   %ebp
  800199:	89 e5                	mov    %esp,%ebp
  80019b:	53                   	push   %ebx
  80019c:	83 ec 10             	sub    $0x10,%esp
  80019f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8001a2:	53                   	push   %ebx
  8001a3:	e8 97 ff ff ff       	call   80013f <strlen>
  8001a8:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8001ab:	ff 75 0c             	pushl  0xc(%ebp)
  8001ae:	01 d8                	add    %ebx,%eax
  8001b0:	50                   	push   %eax
  8001b1:	e8 c2 ff ff ff       	call   800178 <strcpy>
	return dst;
}
  8001b6:	89 d8                	mov    %ebx,%eax
  8001b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001bb:	c9                   	leave  
  8001bc:	c3                   	ret    

008001bd <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8001bd:	55                   	push   %ebp
  8001be:	89 e5                	mov    %esp,%ebp
  8001c0:	56                   	push   %esi
  8001c1:	53                   	push   %ebx
  8001c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8001c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001c8:	89 c6                	mov    %eax,%esi
  8001ca:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8001cd:	89 c2                	mov    %eax,%edx
  8001cf:	39 f2                	cmp    %esi,%edx
  8001d1:	74 11                	je     8001e4 <strncpy+0x27>
		*dst++ = *src;
  8001d3:	83 c2 01             	add    $0x1,%edx
  8001d6:	0f b6 19             	movzbl (%ecx),%ebx
  8001d9:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8001dc:	80 fb 01             	cmp    $0x1,%bl
  8001df:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8001e2:	eb eb                	jmp    8001cf <strncpy+0x12>
	}
	return ret;
}
  8001e4:	5b                   	pop    %ebx
  8001e5:	5e                   	pop    %esi
  8001e6:	5d                   	pop    %ebp
  8001e7:	c3                   	ret    

008001e8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8001e8:	55                   	push   %ebp
  8001e9:	89 e5                	mov    %esp,%ebp
  8001eb:	56                   	push   %esi
  8001ec:	53                   	push   %ebx
  8001ed:	8b 75 08             	mov    0x8(%ebp),%esi
  8001f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001f3:	8b 55 10             	mov    0x10(%ebp),%edx
  8001f6:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8001f8:	85 d2                	test   %edx,%edx
  8001fa:	74 21                	je     80021d <strlcpy+0x35>
  8001fc:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800200:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800202:	39 c2                	cmp    %eax,%edx
  800204:	74 14                	je     80021a <strlcpy+0x32>
  800206:	0f b6 19             	movzbl (%ecx),%ebx
  800209:	84 db                	test   %bl,%bl
  80020b:	74 0b                	je     800218 <strlcpy+0x30>
			*dst++ = *src++;
  80020d:	83 c1 01             	add    $0x1,%ecx
  800210:	83 c2 01             	add    $0x1,%edx
  800213:	88 5a ff             	mov    %bl,-0x1(%edx)
  800216:	eb ea                	jmp    800202 <strlcpy+0x1a>
  800218:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80021a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80021d:	29 f0                	sub    %esi,%eax
}
  80021f:	5b                   	pop    %ebx
  800220:	5e                   	pop    %esi
  800221:	5d                   	pop    %ebp
  800222:	c3                   	ret    

00800223 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800223:	55                   	push   %ebp
  800224:	89 e5                	mov    %esp,%ebp
  800226:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800229:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80022c:	0f b6 01             	movzbl (%ecx),%eax
  80022f:	84 c0                	test   %al,%al
  800231:	74 0c                	je     80023f <strcmp+0x1c>
  800233:	3a 02                	cmp    (%edx),%al
  800235:	75 08                	jne    80023f <strcmp+0x1c>
		p++, q++;
  800237:	83 c1 01             	add    $0x1,%ecx
  80023a:	83 c2 01             	add    $0x1,%edx
  80023d:	eb ed                	jmp    80022c <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80023f:	0f b6 c0             	movzbl %al,%eax
  800242:	0f b6 12             	movzbl (%edx),%edx
  800245:	29 d0                	sub    %edx,%eax
}
  800247:	5d                   	pop    %ebp
  800248:	c3                   	ret    

00800249 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800249:	55                   	push   %ebp
  80024a:	89 e5                	mov    %esp,%ebp
  80024c:	53                   	push   %ebx
  80024d:	8b 45 08             	mov    0x8(%ebp),%eax
  800250:	8b 55 0c             	mov    0xc(%ebp),%edx
  800253:	89 c3                	mov    %eax,%ebx
  800255:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800258:	eb 06                	jmp    800260 <strncmp+0x17>
		n--, p++, q++;
  80025a:	83 c0 01             	add    $0x1,%eax
  80025d:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800260:	39 d8                	cmp    %ebx,%eax
  800262:	74 16                	je     80027a <strncmp+0x31>
  800264:	0f b6 08             	movzbl (%eax),%ecx
  800267:	84 c9                	test   %cl,%cl
  800269:	74 04                	je     80026f <strncmp+0x26>
  80026b:	3a 0a                	cmp    (%edx),%cl
  80026d:	74 eb                	je     80025a <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80026f:	0f b6 00             	movzbl (%eax),%eax
  800272:	0f b6 12             	movzbl (%edx),%edx
  800275:	29 d0                	sub    %edx,%eax
}
  800277:	5b                   	pop    %ebx
  800278:	5d                   	pop    %ebp
  800279:	c3                   	ret    
		return 0;
  80027a:	b8 00 00 00 00       	mov    $0x0,%eax
  80027f:	eb f6                	jmp    800277 <strncmp+0x2e>

00800281 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800281:	55                   	push   %ebp
  800282:	89 e5                	mov    %esp,%ebp
  800284:	8b 45 08             	mov    0x8(%ebp),%eax
  800287:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80028b:	0f b6 10             	movzbl (%eax),%edx
  80028e:	84 d2                	test   %dl,%dl
  800290:	74 09                	je     80029b <strchr+0x1a>
		if (*s == c)
  800292:	38 ca                	cmp    %cl,%dl
  800294:	74 0a                	je     8002a0 <strchr+0x1f>
	for (; *s; s++)
  800296:	83 c0 01             	add    $0x1,%eax
  800299:	eb f0                	jmp    80028b <strchr+0xa>
			return (char *) s;
	return 0;
  80029b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8002a0:	5d                   	pop    %ebp
  8002a1:	c3                   	ret    

008002a2 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8002a2:	55                   	push   %ebp
  8002a3:	89 e5                	mov    %esp,%ebp
  8002a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8002a8:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8002ac:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8002af:	38 ca                	cmp    %cl,%dl
  8002b1:	74 09                	je     8002bc <strfind+0x1a>
  8002b3:	84 d2                	test   %dl,%dl
  8002b5:	74 05                	je     8002bc <strfind+0x1a>
	for (; *s; s++)
  8002b7:	83 c0 01             	add    $0x1,%eax
  8002ba:	eb f0                	jmp    8002ac <strfind+0xa>
			break;
	return (char *) s;
}
  8002bc:	5d                   	pop    %ebp
  8002bd:	c3                   	ret    

008002be <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8002be:	55                   	push   %ebp
  8002bf:	89 e5                	mov    %esp,%ebp
  8002c1:	57                   	push   %edi
  8002c2:	56                   	push   %esi
  8002c3:	53                   	push   %ebx
  8002c4:	8b 7d 08             	mov    0x8(%ebp),%edi
  8002c7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8002ca:	85 c9                	test   %ecx,%ecx
  8002cc:	74 31                	je     8002ff <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8002ce:	89 f8                	mov    %edi,%eax
  8002d0:	09 c8                	or     %ecx,%eax
  8002d2:	a8 03                	test   $0x3,%al
  8002d4:	75 23                	jne    8002f9 <memset+0x3b>
		c &= 0xFF;
  8002d6:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8002da:	89 d3                	mov    %edx,%ebx
  8002dc:	c1 e3 08             	shl    $0x8,%ebx
  8002df:	89 d0                	mov    %edx,%eax
  8002e1:	c1 e0 18             	shl    $0x18,%eax
  8002e4:	89 d6                	mov    %edx,%esi
  8002e6:	c1 e6 10             	shl    $0x10,%esi
  8002e9:	09 f0                	or     %esi,%eax
  8002eb:	09 c2                	or     %eax,%edx
  8002ed:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8002ef:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8002f2:	89 d0                	mov    %edx,%eax
  8002f4:	fc                   	cld    
  8002f5:	f3 ab                	rep stos %eax,%es:(%edi)
  8002f7:	eb 06                	jmp    8002ff <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8002f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002fc:	fc                   	cld    
  8002fd:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8002ff:	89 f8                	mov    %edi,%eax
  800301:	5b                   	pop    %ebx
  800302:	5e                   	pop    %esi
  800303:	5f                   	pop    %edi
  800304:	5d                   	pop    %ebp
  800305:	c3                   	ret    

00800306 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800306:	55                   	push   %ebp
  800307:	89 e5                	mov    %esp,%ebp
  800309:	57                   	push   %edi
  80030a:	56                   	push   %esi
  80030b:	8b 45 08             	mov    0x8(%ebp),%eax
  80030e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800311:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800314:	39 c6                	cmp    %eax,%esi
  800316:	73 32                	jae    80034a <memmove+0x44>
  800318:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80031b:	39 c2                	cmp    %eax,%edx
  80031d:	76 2b                	jbe    80034a <memmove+0x44>
		s += n;
		d += n;
  80031f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800322:	89 fe                	mov    %edi,%esi
  800324:	09 ce                	or     %ecx,%esi
  800326:	09 d6                	or     %edx,%esi
  800328:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80032e:	75 0e                	jne    80033e <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800330:	83 ef 04             	sub    $0x4,%edi
  800333:	8d 72 fc             	lea    -0x4(%edx),%esi
  800336:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800339:	fd                   	std    
  80033a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80033c:	eb 09                	jmp    800347 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80033e:	83 ef 01             	sub    $0x1,%edi
  800341:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800344:	fd                   	std    
  800345:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800347:	fc                   	cld    
  800348:	eb 1a                	jmp    800364 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80034a:	89 c2                	mov    %eax,%edx
  80034c:	09 ca                	or     %ecx,%edx
  80034e:	09 f2                	or     %esi,%edx
  800350:	f6 c2 03             	test   $0x3,%dl
  800353:	75 0a                	jne    80035f <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800355:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800358:	89 c7                	mov    %eax,%edi
  80035a:	fc                   	cld    
  80035b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80035d:	eb 05                	jmp    800364 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  80035f:	89 c7                	mov    %eax,%edi
  800361:	fc                   	cld    
  800362:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800364:	5e                   	pop    %esi
  800365:	5f                   	pop    %edi
  800366:	5d                   	pop    %ebp
  800367:	c3                   	ret    

00800368 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800368:	55                   	push   %ebp
  800369:	89 e5                	mov    %esp,%ebp
  80036b:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  80036e:	ff 75 10             	pushl  0x10(%ebp)
  800371:	ff 75 0c             	pushl  0xc(%ebp)
  800374:	ff 75 08             	pushl  0x8(%ebp)
  800377:	e8 8a ff ff ff       	call   800306 <memmove>
}
  80037c:	c9                   	leave  
  80037d:	c3                   	ret    

0080037e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80037e:	55                   	push   %ebp
  80037f:	89 e5                	mov    %esp,%ebp
  800381:	56                   	push   %esi
  800382:	53                   	push   %ebx
  800383:	8b 45 08             	mov    0x8(%ebp),%eax
  800386:	8b 55 0c             	mov    0xc(%ebp),%edx
  800389:	89 c6                	mov    %eax,%esi
  80038b:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80038e:	39 f0                	cmp    %esi,%eax
  800390:	74 1c                	je     8003ae <memcmp+0x30>
		if (*s1 != *s2)
  800392:	0f b6 08             	movzbl (%eax),%ecx
  800395:	0f b6 1a             	movzbl (%edx),%ebx
  800398:	38 d9                	cmp    %bl,%cl
  80039a:	75 08                	jne    8003a4 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  80039c:	83 c0 01             	add    $0x1,%eax
  80039f:	83 c2 01             	add    $0x1,%edx
  8003a2:	eb ea                	jmp    80038e <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  8003a4:	0f b6 c1             	movzbl %cl,%eax
  8003a7:	0f b6 db             	movzbl %bl,%ebx
  8003aa:	29 d8                	sub    %ebx,%eax
  8003ac:	eb 05                	jmp    8003b3 <memcmp+0x35>
	}

	return 0;
  8003ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8003b3:	5b                   	pop    %ebx
  8003b4:	5e                   	pop    %esi
  8003b5:	5d                   	pop    %ebp
  8003b6:	c3                   	ret    

008003b7 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8003b7:	55                   	push   %ebp
  8003b8:	89 e5                	mov    %esp,%ebp
  8003ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8003c0:	89 c2                	mov    %eax,%edx
  8003c2:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8003c5:	39 d0                	cmp    %edx,%eax
  8003c7:	73 09                	jae    8003d2 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  8003c9:	38 08                	cmp    %cl,(%eax)
  8003cb:	74 05                	je     8003d2 <memfind+0x1b>
	for (; s < ends; s++)
  8003cd:	83 c0 01             	add    $0x1,%eax
  8003d0:	eb f3                	jmp    8003c5 <memfind+0xe>
			break;
	return (void *) s;
}
  8003d2:	5d                   	pop    %ebp
  8003d3:	c3                   	ret    

008003d4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8003d4:	55                   	push   %ebp
  8003d5:	89 e5                	mov    %esp,%ebp
  8003d7:	57                   	push   %edi
  8003d8:	56                   	push   %esi
  8003d9:	53                   	push   %ebx
  8003da:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003dd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8003e0:	eb 03                	jmp    8003e5 <strtol+0x11>
		s++;
  8003e2:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  8003e5:	0f b6 01             	movzbl (%ecx),%eax
  8003e8:	3c 20                	cmp    $0x20,%al
  8003ea:	74 f6                	je     8003e2 <strtol+0xe>
  8003ec:	3c 09                	cmp    $0x9,%al
  8003ee:	74 f2                	je     8003e2 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  8003f0:	3c 2b                	cmp    $0x2b,%al
  8003f2:	74 2a                	je     80041e <strtol+0x4a>
	int neg = 0;
  8003f4:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  8003f9:	3c 2d                	cmp    $0x2d,%al
  8003fb:	74 2b                	je     800428 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8003fd:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800403:	75 0f                	jne    800414 <strtol+0x40>
  800405:	80 39 30             	cmpb   $0x30,(%ecx)
  800408:	74 28                	je     800432 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  80040a:	85 db                	test   %ebx,%ebx
  80040c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800411:	0f 44 d8             	cmove  %eax,%ebx
  800414:	b8 00 00 00 00       	mov    $0x0,%eax
  800419:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80041c:	eb 50                	jmp    80046e <strtol+0x9a>
		s++;
  80041e:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800421:	bf 00 00 00 00       	mov    $0x0,%edi
  800426:	eb d5                	jmp    8003fd <strtol+0x29>
		s++, neg = 1;
  800428:	83 c1 01             	add    $0x1,%ecx
  80042b:	bf 01 00 00 00       	mov    $0x1,%edi
  800430:	eb cb                	jmp    8003fd <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800432:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800436:	74 0e                	je     800446 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800438:	85 db                	test   %ebx,%ebx
  80043a:	75 d8                	jne    800414 <strtol+0x40>
		s++, base = 8;
  80043c:	83 c1 01             	add    $0x1,%ecx
  80043f:	bb 08 00 00 00       	mov    $0x8,%ebx
  800444:	eb ce                	jmp    800414 <strtol+0x40>
		s += 2, base = 16;
  800446:	83 c1 02             	add    $0x2,%ecx
  800449:	bb 10 00 00 00       	mov    $0x10,%ebx
  80044e:	eb c4                	jmp    800414 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800450:	8d 72 9f             	lea    -0x61(%edx),%esi
  800453:	89 f3                	mov    %esi,%ebx
  800455:	80 fb 19             	cmp    $0x19,%bl
  800458:	77 29                	ja     800483 <strtol+0xaf>
			dig = *s - 'a' + 10;
  80045a:	0f be d2             	movsbl %dl,%edx
  80045d:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800460:	3b 55 10             	cmp    0x10(%ebp),%edx
  800463:	7d 30                	jge    800495 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800465:	83 c1 01             	add    $0x1,%ecx
  800468:	0f af 45 10          	imul   0x10(%ebp),%eax
  80046c:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  80046e:	0f b6 11             	movzbl (%ecx),%edx
  800471:	8d 72 d0             	lea    -0x30(%edx),%esi
  800474:	89 f3                	mov    %esi,%ebx
  800476:	80 fb 09             	cmp    $0x9,%bl
  800479:	77 d5                	ja     800450 <strtol+0x7c>
			dig = *s - '0';
  80047b:	0f be d2             	movsbl %dl,%edx
  80047e:	83 ea 30             	sub    $0x30,%edx
  800481:	eb dd                	jmp    800460 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800483:	8d 72 bf             	lea    -0x41(%edx),%esi
  800486:	89 f3                	mov    %esi,%ebx
  800488:	80 fb 19             	cmp    $0x19,%bl
  80048b:	77 08                	ja     800495 <strtol+0xc1>
			dig = *s - 'A' + 10;
  80048d:	0f be d2             	movsbl %dl,%edx
  800490:	83 ea 37             	sub    $0x37,%edx
  800493:	eb cb                	jmp    800460 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800495:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800499:	74 05                	je     8004a0 <strtol+0xcc>
		*endptr = (char *) s;
  80049b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80049e:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  8004a0:	89 c2                	mov    %eax,%edx
  8004a2:	f7 da                	neg    %edx
  8004a4:	85 ff                	test   %edi,%edi
  8004a6:	0f 45 c2             	cmovne %edx,%eax
}
  8004a9:	5b                   	pop    %ebx
  8004aa:	5e                   	pop    %esi
  8004ab:	5f                   	pop    %edi
  8004ac:	5d                   	pop    %ebp
  8004ad:	c3                   	ret    

008004ae <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8004ae:	55                   	push   %ebp
  8004af:	89 e5                	mov    %esp,%ebp
  8004b1:	57                   	push   %edi
  8004b2:	56                   	push   %esi
  8004b3:	53                   	push   %ebx
	asm volatile("int %1\n"
  8004b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8004b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8004bc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004bf:	89 c3                	mov    %eax,%ebx
  8004c1:	89 c7                	mov    %eax,%edi
  8004c3:	89 c6                	mov    %eax,%esi
  8004c5:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8004c7:	5b                   	pop    %ebx
  8004c8:	5e                   	pop    %esi
  8004c9:	5f                   	pop    %edi
  8004ca:	5d                   	pop    %ebp
  8004cb:	c3                   	ret    

008004cc <sys_cgetc>:

int
sys_cgetc(void)
{
  8004cc:	55                   	push   %ebp
  8004cd:	89 e5                	mov    %esp,%ebp
  8004cf:	57                   	push   %edi
  8004d0:	56                   	push   %esi
  8004d1:	53                   	push   %ebx
	asm volatile("int %1\n"
  8004d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8004d7:	b8 01 00 00 00       	mov    $0x1,%eax
  8004dc:	89 d1                	mov    %edx,%ecx
  8004de:	89 d3                	mov    %edx,%ebx
  8004e0:	89 d7                	mov    %edx,%edi
  8004e2:	89 d6                	mov    %edx,%esi
  8004e4:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8004e6:	5b                   	pop    %ebx
  8004e7:	5e                   	pop    %esi
  8004e8:	5f                   	pop    %edi
  8004e9:	5d                   	pop    %ebp
  8004ea:	c3                   	ret    

008004eb <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8004eb:	55                   	push   %ebp
  8004ec:	89 e5                	mov    %esp,%ebp
  8004ee:	57                   	push   %edi
  8004ef:	56                   	push   %esi
  8004f0:	53                   	push   %ebx
  8004f1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8004f4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8004fc:	b8 03 00 00 00       	mov    $0x3,%eax
  800501:	89 cb                	mov    %ecx,%ebx
  800503:	89 cf                	mov    %ecx,%edi
  800505:	89 ce                	mov    %ecx,%esi
  800507:	cd 30                	int    $0x30
	if (check && ret > 0)
  800509:	85 c0                	test   %eax,%eax
  80050b:	7f 08                	jg     800515 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80050d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800510:	5b                   	pop    %ebx
  800511:	5e                   	pop    %esi
  800512:	5f                   	pop    %edi
  800513:	5d                   	pop    %ebp
  800514:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800515:	83 ec 0c             	sub    $0xc,%esp
  800518:	50                   	push   %eax
  800519:	6a 03                	push   $0x3
  80051b:	68 8f 1f 80 00       	push   $0x801f8f
  800520:	6a 4c                	push   $0x4c
  800522:	68 ac 1f 80 00       	push   $0x801fac
  800527:	e8 f3 0e 00 00       	call   80141f <_panic>

0080052c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80052c:	55                   	push   %ebp
  80052d:	89 e5                	mov    %esp,%ebp
  80052f:	57                   	push   %edi
  800530:	56                   	push   %esi
  800531:	53                   	push   %ebx
	asm volatile("int %1\n"
  800532:	ba 00 00 00 00       	mov    $0x0,%edx
  800537:	b8 02 00 00 00       	mov    $0x2,%eax
  80053c:	89 d1                	mov    %edx,%ecx
  80053e:	89 d3                	mov    %edx,%ebx
  800540:	89 d7                	mov    %edx,%edi
  800542:	89 d6                	mov    %edx,%esi
  800544:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800546:	5b                   	pop    %ebx
  800547:	5e                   	pop    %esi
  800548:	5f                   	pop    %edi
  800549:	5d                   	pop    %ebp
  80054a:	c3                   	ret    

0080054b <sys_yield>:

void
sys_yield(void)
{
  80054b:	55                   	push   %ebp
  80054c:	89 e5                	mov    %esp,%ebp
  80054e:	57                   	push   %edi
  80054f:	56                   	push   %esi
  800550:	53                   	push   %ebx
	asm volatile("int %1\n"
  800551:	ba 00 00 00 00       	mov    $0x0,%edx
  800556:	b8 0b 00 00 00       	mov    $0xb,%eax
  80055b:	89 d1                	mov    %edx,%ecx
  80055d:	89 d3                	mov    %edx,%ebx
  80055f:	89 d7                	mov    %edx,%edi
  800561:	89 d6                	mov    %edx,%esi
  800563:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800565:	5b                   	pop    %ebx
  800566:	5e                   	pop    %esi
  800567:	5f                   	pop    %edi
  800568:	5d                   	pop    %ebp
  800569:	c3                   	ret    

0080056a <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80056a:	55                   	push   %ebp
  80056b:	89 e5                	mov    %esp,%ebp
  80056d:	57                   	push   %edi
  80056e:	56                   	push   %esi
  80056f:	53                   	push   %ebx
  800570:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800573:	be 00 00 00 00       	mov    $0x0,%esi
  800578:	8b 55 08             	mov    0x8(%ebp),%edx
  80057b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80057e:	b8 04 00 00 00       	mov    $0x4,%eax
  800583:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800586:	89 f7                	mov    %esi,%edi
  800588:	cd 30                	int    $0x30
	if (check && ret > 0)
  80058a:	85 c0                	test   %eax,%eax
  80058c:	7f 08                	jg     800596 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80058e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800591:	5b                   	pop    %ebx
  800592:	5e                   	pop    %esi
  800593:	5f                   	pop    %edi
  800594:	5d                   	pop    %ebp
  800595:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800596:	83 ec 0c             	sub    $0xc,%esp
  800599:	50                   	push   %eax
  80059a:	6a 04                	push   $0x4
  80059c:	68 8f 1f 80 00       	push   $0x801f8f
  8005a1:	6a 4c                	push   $0x4c
  8005a3:	68 ac 1f 80 00       	push   $0x801fac
  8005a8:	e8 72 0e 00 00       	call   80141f <_panic>

008005ad <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8005ad:	55                   	push   %ebp
  8005ae:	89 e5                	mov    %esp,%ebp
  8005b0:	57                   	push   %edi
  8005b1:	56                   	push   %esi
  8005b2:	53                   	push   %ebx
  8005b3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8005b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8005b9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005bc:	b8 05 00 00 00       	mov    $0x5,%eax
  8005c1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8005c4:	8b 7d 14             	mov    0x14(%ebp),%edi
  8005c7:	8b 75 18             	mov    0x18(%ebp),%esi
  8005ca:	cd 30                	int    $0x30
	if (check && ret > 0)
  8005cc:	85 c0                	test   %eax,%eax
  8005ce:	7f 08                	jg     8005d8 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8005d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005d3:	5b                   	pop    %ebx
  8005d4:	5e                   	pop    %esi
  8005d5:	5f                   	pop    %edi
  8005d6:	5d                   	pop    %ebp
  8005d7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8005d8:	83 ec 0c             	sub    $0xc,%esp
  8005db:	50                   	push   %eax
  8005dc:	6a 05                	push   $0x5
  8005de:	68 8f 1f 80 00       	push   $0x801f8f
  8005e3:	6a 4c                	push   $0x4c
  8005e5:	68 ac 1f 80 00       	push   $0x801fac
  8005ea:	e8 30 0e 00 00       	call   80141f <_panic>

008005ef <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8005ef:	55                   	push   %ebp
  8005f0:	89 e5                	mov    %esp,%ebp
  8005f2:	57                   	push   %edi
  8005f3:	56                   	push   %esi
  8005f4:	53                   	push   %ebx
  8005f5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8005f8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8005fd:	8b 55 08             	mov    0x8(%ebp),%edx
  800600:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800603:	b8 06 00 00 00       	mov    $0x6,%eax
  800608:	89 df                	mov    %ebx,%edi
  80060a:	89 de                	mov    %ebx,%esi
  80060c:	cd 30                	int    $0x30
	if (check && ret > 0)
  80060e:	85 c0                	test   %eax,%eax
  800610:	7f 08                	jg     80061a <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800612:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800615:	5b                   	pop    %ebx
  800616:	5e                   	pop    %esi
  800617:	5f                   	pop    %edi
  800618:	5d                   	pop    %ebp
  800619:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80061a:	83 ec 0c             	sub    $0xc,%esp
  80061d:	50                   	push   %eax
  80061e:	6a 06                	push   $0x6
  800620:	68 8f 1f 80 00       	push   $0x801f8f
  800625:	6a 4c                	push   $0x4c
  800627:	68 ac 1f 80 00       	push   $0x801fac
  80062c:	e8 ee 0d 00 00       	call   80141f <_panic>

00800631 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800631:	55                   	push   %ebp
  800632:	89 e5                	mov    %esp,%ebp
  800634:	57                   	push   %edi
  800635:	56                   	push   %esi
  800636:	53                   	push   %ebx
  800637:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80063a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80063f:	8b 55 08             	mov    0x8(%ebp),%edx
  800642:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800645:	b8 08 00 00 00       	mov    $0x8,%eax
  80064a:	89 df                	mov    %ebx,%edi
  80064c:	89 de                	mov    %ebx,%esi
  80064e:	cd 30                	int    $0x30
	if (check && ret > 0)
  800650:	85 c0                	test   %eax,%eax
  800652:	7f 08                	jg     80065c <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800654:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800657:	5b                   	pop    %ebx
  800658:	5e                   	pop    %esi
  800659:	5f                   	pop    %edi
  80065a:	5d                   	pop    %ebp
  80065b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80065c:	83 ec 0c             	sub    $0xc,%esp
  80065f:	50                   	push   %eax
  800660:	6a 08                	push   $0x8
  800662:	68 8f 1f 80 00       	push   $0x801f8f
  800667:	6a 4c                	push   $0x4c
  800669:	68 ac 1f 80 00       	push   $0x801fac
  80066e:	e8 ac 0d 00 00       	call   80141f <_panic>

00800673 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800673:	55                   	push   %ebp
  800674:	89 e5                	mov    %esp,%ebp
  800676:	57                   	push   %edi
  800677:	56                   	push   %esi
  800678:	53                   	push   %ebx
  800679:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80067c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800681:	8b 55 08             	mov    0x8(%ebp),%edx
  800684:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800687:	b8 09 00 00 00       	mov    $0x9,%eax
  80068c:	89 df                	mov    %ebx,%edi
  80068e:	89 de                	mov    %ebx,%esi
  800690:	cd 30                	int    $0x30
	if (check && ret > 0)
  800692:	85 c0                	test   %eax,%eax
  800694:	7f 08                	jg     80069e <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800696:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800699:	5b                   	pop    %ebx
  80069a:	5e                   	pop    %esi
  80069b:	5f                   	pop    %edi
  80069c:	5d                   	pop    %ebp
  80069d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80069e:	83 ec 0c             	sub    $0xc,%esp
  8006a1:	50                   	push   %eax
  8006a2:	6a 09                	push   $0x9
  8006a4:	68 8f 1f 80 00       	push   $0x801f8f
  8006a9:	6a 4c                	push   $0x4c
  8006ab:	68 ac 1f 80 00       	push   $0x801fac
  8006b0:	e8 6a 0d 00 00       	call   80141f <_panic>

008006b5 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8006b5:	55                   	push   %ebp
  8006b6:	89 e5                	mov    %esp,%ebp
  8006b8:	57                   	push   %edi
  8006b9:	56                   	push   %esi
  8006ba:	53                   	push   %ebx
  8006bb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8006be:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8006c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006c9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006ce:	89 df                	mov    %ebx,%edi
  8006d0:	89 de                	mov    %ebx,%esi
  8006d2:	cd 30                	int    $0x30
	if (check && ret > 0)
  8006d4:	85 c0                	test   %eax,%eax
  8006d6:	7f 08                	jg     8006e0 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8006d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006db:	5b                   	pop    %ebx
  8006dc:	5e                   	pop    %esi
  8006dd:	5f                   	pop    %edi
  8006de:	5d                   	pop    %ebp
  8006df:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8006e0:	83 ec 0c             	sub    $0xc,%esp
  8006e3:	50                   	push   %eax
  8006e4:	6a 0a                	push   $0xa
  8006e6:	68 8f 1f 80 00       	push   $0x801f8f
  8006eb:	6a 4c                	push   $0x4c
  8006ed:	68 ac 1f 80 00       	push   $0x801fac
  8006f2:	e8 28 0d 00 00       	call   80141f <_panic>

008006f7 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8006f7:	55                   	push   %ebp
  8006f8:	89 e5                	mov    %esp,%ebp
  8006fa:	57                   	push   %edi
  8006fb:	56                   	push   %esi
  8006fc:	53                   	push   %ebx
	asm volatile("int %1\n"
  8006fd:	8b 55 08             	mov    0x8(%ebp),%edx
  800700:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800703:	b8 0c 00 00 00       	mov    $0xc,%eax
  800708:	be 00 00 00 00       	mov    $0x0,%esi
  80070d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800710:	8b 7d 14             	mov    0x14(%ebp),%edi
  800713:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800715:	5b                   	pop    %ebx
  800716:	5e                   	pop    %esi
  800717:	5f                   	pop    %edi
  800718:	5d                   	pop    %ebp
  800719:	c3                   	ret    

0080071a <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80071a:	55                   	push   %ebp
  80071b:	89 e5                	mov    %esp,%ebp
  80071d:	57                   	push   %edi
  80071e:	56                   	push   %esi
  80071f:	53                   	push   %ebx
  800720:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800723:	b9 00 00 00 00       	mov    $0x0,%ecx
  800728:	8b 55 08             	mov    0x8(%ebp),%edx
  80072b:	b8 0d 00 00 00       	mov    $0xd,%eax
  800730:	89 cb                	mov    %ecx,%ebx
  800732:	89 cf                	mov    %ecx,%edi
  800734:	89 ce                	mov    %ecx,%esi
  800736:	cd 30                	int    $0x30
	if (check && ret > 0)
  800738:	85 c0                	test   %eax,%eax
  80073a:	7f 08                	jg     800744 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80073c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80073f:	5b                   	pop    %ebx
  800740:	5e                   	pop    %esi
  800741:	5f                   	pop    %edi
  800742:	5d                   	pop    %ebp
  800743:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800744:	83 ec 0c             	sub    $0xc,%esp
  800747:	50                   	push   %eax
  800748:	6a 0d                	push   $0xd
  80074a:	68 8f 1f 80 00       	push   $0x801f8f
  80074f:	6a 4c                	push   $0x4c
  800751:	68 ac 1f 80 00       	push   $0x801fac
  800756:	e8 c4 0c 00 00       	call   80141f <_panic>

0080075b <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  80075b:	55                   	push   %ebp
  80075c:	89 e5                	mov    %esp,%ebp
  80075e:	57                   	push   %edi
  80075f:	56                   	push   %esi
  800760:	53                   	push   %ebx
	asm volatile("int %1\n"
  800761:	bb 00 00 00 00       	mov    $0x0,%ebx
  800766:	8b 55 08             	mov    0x8(%ebp),%edx
  800769:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80076c:	b8 0e 00 00 00       	mov    $0xe,%eax
  800771:	89 df                	mov    %ebx,%edi
  800773:	89 de                	mov    %ebx,%esi
  800775:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800777:	5b                   	pop    %ebx
  800778:	5e                   	pop    %esi
  800779:	5f                   	pop    %edi
  80077a:	5d                   	pop    %ebp
  80077b:	c3                   	ret    

0080077c <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  80077c:	55                   	push   %ebp
  80077d:	89 e5                	mov    %esp,%ebp
  80077f:	57                   	push   %edi
  800780:	56                   	push   %esi
  800781:	53                   	push   %ebx
	asm volatile("int %1\n"
  800782:	b9 00 00 00 00       	mov    $0x0,%ecx
  800787:	8b 55 08             	mov    0x8(%ebp),%edx
  80078a:	b8 0f 00 00 00       	mov    $0xf,%eax
  80078f:	89 cb                	mov    %ecx,%ebx
  800791:	89 cf                	mov    %ecx,%edi
  800793:	89 ce                	mov    %ecx,%esi
  800795:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800797:	5b                   	pop    %ebx
  800798:	5e                   	pop    %esi
  800799:	5f                   	pop    %edi
  80079a:	5d                   	pop    %ebp
  80079b:	c3                   	ret    

0080079c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80079c:	55                   	push   %ebp
  80079d:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80079f:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a2:	05 00 00 00 30       	add    $0x30000000,%eax
  8007a7:	c1 e8 0c             	shr    $0xc,%eax
}
  8007aa:	5d                   	pop    %ebp
  8007ab:	c3                   	ret    

008007ac <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8007ac:	55                   	push   %ebp
  8007ad:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8007af:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b2:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8007b7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8007bc:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8007c1:	5d                   	pop    %ebp
  8007c2:	c3                   	ret    

008007c3 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8007c3:	55                   	push   %ebp
  8007c4:	89 e5                	mov    %esp,%ebp
  8007c6:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8007cb:	89 c2                	mov    %eax,%edx
  8007cd:	c1 ea 16             	shr    $0x16,%edx
  8007d0:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8007d7:	f6 c2 01             	test   $0x1,%dl
  8007da:	74 2d                	je     800809 <fd_alloc+0x46>
  8007dc:	89 c2                	mov    %eax,%edx
  8007de:	c1 ea 0c             	shr    $0xc,%edx
  8007e1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8007e8:	f6 c2 01             	test   $0x1,%dl
  8007eb:	74 1c                	je     800809 <fd_alloc+0x46>
  8007ed:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8007f2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8007f7:	75 d2                	jne    8007cb <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8007f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800802:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800807:	eb 0a                	jmp    800813 <fd_alloc+0x50>
			*fd_store = fd;
  800809:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80080c:	89 01                	mov    %eax,(%ecx)
			return 0;
  80080e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800813:	5d                   	pop    %ebp
  800814:	c3                   	ret    

00800815 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800815:	55                   	push   %ebp
  800816:	89 e5                	mov    %esp,%ebp
  800818:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80081b:	83 f8 1f             	cmp    $0x1f,%eax
  80081e:	77 30                	ja     800850 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800820:	c1 e0 0c             	shl    $0xc,%eax
  800823:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800828:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80082e:	f6 c2 01             	test   $0x1,%dl
  800831:	74 24                	je     800857 <fd_lookup+0x42>
  800833:	89 c2                	mov    %eax,%edx
  800835:	c1 ea 0c             	shr    $0xc,%edx
  800838:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80083f:	f6 c2 01             	test   $0x1,%dl
  800842:	74 1a                	je     80085e <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800844:	8b 55 0c             	mov    0xc(%ebp),%edx
  800847:	89 02                	mov    %eax,(%edx)
	return 0;
  800849:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80084e:	5d                   	pop    %ebp
  80084f:	c3                   	ret    
		return -E_INVAL;
  800850:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800855:	eb f7                	jmp    80084e <fd_lookup+0x39>
		return -E_INVAL;
  800857:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80085c:	eb f0                	jmp    80084e <fd_lookup+0x39>
  80085e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800863:	eb e9                	jmp    80084e <fd_lookup+0x39>

00800865 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800865:	55                   	push   %ebp
  800866:	89 e5                	mov    %esp,%ebp
  800868:	83 ec 08             	sub    $0x8,%esp
  80086b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80086e:	ba 38 20 80 00       	mov    $0x802038,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800873:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800878:	39 08                	cmp    %ecx,(%eax)
  80087a:	74 33                	je     8008af <dev_lookup+0x4a>
  80087c:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  80087f:	8b 02                	mov    (%edx),%eax
  800881:	85 c0                	test   %eax,%eax
  800883:	75 f3                	jne    800878 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800885:	a1 04 40 80 00       	mov    0x804004,%eax
  80088a:	8b 40 48             	mov    0x48(%eax),%eax
  80088d:	83 ec 04             	sub    $0x4,%esp
  800890:	51                   	push   %ecx
  800891:	50                   	push   %eax
  800892:	68 bc 1f 80 00       	push   $0x801fbc
  800897:	e8 5e 0c 00 00       	call   8014fa <cprintf>
	*dev = 0;
  80089c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80089f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8008a5:	83 c4 10             	add    $0x10,%esp
  8008a8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8008ad:	c9                   	leave  
  8008ae:	c3                   	ret    
			*dev = devtab[i];
  8008af:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008b2:	89 01                	mov    %eax,(%ecx)
			return 0;
  8008b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8008b9:	eb f2                	jmp    8008ad <dev_lookup+0x48>

008008bb <fd_close>:
{
  8008bb:	55                   	push   %ebp
  8008bc:	89 e5                	mov    %esp,%ebp
  8008be:	57                   	push   %edi
  8008bf:	56                   	push   %esi
  8008c0:	53                   	push   %ebx
  8008c1:	83 ec 24             	sub    $0x24,%esp
  8008c4:	8b 75 08             	mov    0x8(%ebp),%esi
  8008c7:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8008ca:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8008cd:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8008ce:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8008d4:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8008d7:	50                   	push   %eax
  8008d8:	e8 38 ff ff ff       	call   800815 <fd_lookup>
  8008dd:	89 c3                	mov    %eax,%ebx
  8008df:	83 c4 10             	add    $0x10,%esp
  8008e2:	85 c0                	test   %eax,%eax
  8008e4:	78 05                	js     8008eb <fd_close+0x30>
	    || fd != fd2)
  8008e6:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8008e9:	74 16                	je     800901 <fd_close+0x46>
		return (must_exist ? r : 0);
  8008eb:	89 f8                	mov    %edi,%eax
  8008ed:	84 c0                	test   %al,%al
  8008ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8008f4:	0f 44 d8             	cmove  %eax,%ebx
}
  8008f7:	89 d8                	mov    %ebx,%eax
  8008f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008fc:	5b                   	pop    %ebx
  8008fd:	5e                   	pop    %esi
  8008fe:	5f                   	pop    %edi
  8008ff:	5d                   	pop    %ebp
  800900:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800901:	83 ec 08             	sub    $0x8,%esp
  800904:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800907:	50                   	push   %eax
  800908:	ff 36                	pushl  (%esi)
  80090a:	e8 56 ff ff ff       	call   800865 <dev_lookup>
  80090f:	89 c3                	mov    %eax,%ebx
  800911:	83 c4 10             	add    $0x10,%esp
  800914:	85 c0                	test   %eax,%eax
  800916:	78 1a                	js     800932 <fd_close+0x77>
		if (dev->dev_close)
  800918:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80091b:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80091e:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  800923:	85 c0                	test   %eax,%eax
  800925:	74 0b                	je     800932 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  800927:	83 ec 0c             	sub    $0xc,%esp
  80092a:	56                   	push   %esi
  80092b:	ff d0                	call   *%eax
  80092d:	89 c3                	mov    %eax,%ebx
  80092f:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800932:	83 ec 08             	sub    $0x8,%esp
  800935:	56                   	push   %esi
  800936:	6a 00                	push   $0x0
  800938:	e8 b2 fc ff ff       	call   8005ef <sys_page_unmap>
	return r;
  80093d:	83 c4 10             	add    $0x10,%esp
  800940:	eb b5                	jmp    8008f7 <fd_close+0x3c>

00800942 <close>:

int
close(int fdnum)
{
  800942:	55                   	push   %ebp
  800943:	89 e5                	mov    %esp,%ebp
  800945:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800948:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80094b:	50                   	push   %eax
  80094c:	ff 75 08             	pushl  0x8(%ebp)
  80094f:	e8 c1 fe ff ff       	call   800815 <fd_lookup>
  800954:	83 c4 10             	add    $0x10,%esp
  800957:	85 c0                	test   %eax,%eax
  800959:	79 02                	jns    80095d <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80095b:	c9                   	leave  
  80095c:	c3                   	ret    
		return fd_close(fd, 1);
  80095d:	83 ec 08             	sub    $0x8,%esp
  800960:	6a 01                	push   $0x1
  800962:	ff 75 f4             	pushl  -0xc(%ebp)
  800965:	e8 51 ff ff ff       	call   8008bb <fd_close>
  80096a:	83 c4 10             	add    $0x10,%esp
  80096d:	eb ec                	jmp    80095b <close+0x19>

0080096f <close_all>:

void
close_all(void)
{
  80096f:	55                   	push   %ebp
  800970:	89 e5                	mov    %esp,%ebp
  800972:	53                   	push   %ebx
  800973:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800976:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80097b:	83 ec 0c             	sub    $0xc,%esp
  80097e:	53                   	push   %ebx
  80097f:	e8 be ff ff ff       	call   800942 <close>
	for (i = 0; i < MAXFD; i++)
  800984:	83 c3 01             	add    $0x1,%ebx
  800987:	83 c4 10             	add    $0x10,%esp
  80098a:	83 fb 20             	cmp    $0x20,%ebx
  80098d:	75 ec                	jne    80097b <close_all+0xc>
}
  80098f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800992:	c9                   	leave  
  800993:	c3                   	ret    

00800994 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800994:	55                   	push   %ebp
  800995:	89 e5                	mov    %esp,%ebp
  800997:	57                   	push   %edi
  800998:	56                   	push   %esi
  800999:	53                   	push   %ebx
  80099a:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80099d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8009a0:	50                   	push   %eax
  8009a1:	ff 75 08             	pushl  0x8(%ebp)
  8009a4:	e8 6c fe ff ff       	call   800815 <fd_lookup>
  8009a9:	89 c3                	mov    %eax,%ebx
  8009ab:	83 c4 10             	add    $0x10,%esp
  8009ae:	85 c0                	test   %eax,%eax
  8009b0:	0f 88 81 00 00 00    	js     800a37 <dup+0xa3>
		return r;
	close(newfdnum);
  8009b6:	83 ec 0c             	sub    $0xc,%esp
  8009b9:	ff 75 0c             	pushl  0xc(%ebp)
  8009bc:	e8 81 ff ff ff       	call   800942 <close>

	newfd = INDEX2FD(newfdnum);
  8009c1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009c4:	c1 e6 0c             	shl    $0xc,%esi
  8009c7:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8009cd:	83 c4 04             	add    $0x4,%esp
  8009d0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8009d3:	e8 d4 fd ff ff       	call   8007ac <fd2data>
  8009d8:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8009da:	89 34 24             	mov    %esi,(%esp)
  8009dd:	e8 ca fd ff ff       	call   8007ac <fd2data>
  8009e2:	83 c4 10             	add    $0x10,%esp
  8009e5:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8009e7:	89 d8                	mov    %ebx,%eax
  8009e9:	c1 e8 16             	shr    $0x16,%eax
  8009ec:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8009f3:	a8 01                	test   $0x1,%al
  8009f5:	74 11                	je     800a08 <dup+0x74>
  8009f7:	89 d8                	mov    %ebx,%eax
  8009f9:	c1 e8 0c             	shr    $0xc,%eax
  8009fc:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800a03:	f6 c2 01             	test   $0x1,%dl
  800a06:	75 39                	jne    800a41 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800a08:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800a0b:	89 d0                	mov    %edx,%eax
  800a0d:	c1 e8 0c             	shr    $0xc,%eax
  800a10:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800a17:	83 ec 0c             	sub    $0xc,%esp
  800a1a:	25 07 0e 00 00       	and    $0xe07,%eax
  800a1f:	50                   	push   %eax
  800a20:	56                   	push   %esi
  800a21:	6a 00                	push   $0x0
  800a23:	52                   	push   %edx
  800a24:	6a 00                	push   $0x0
  800a26:	e8 82 fb ff ff       	call   8005ad <sys_page_map>
  800a2b:	89 c3                	mov    %eax,%ebx
  800a2d:	83 c4 20             	add    $0x20,%esp
  800a30:	85 c0                	test   %eax,%eax
  800a32:	78 31                	js     800a65 <dup+0xd1>
		goto err;

	return newfdnum;
  800a34:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  800a37:	89 d8                	mov    %ebx,%eax
  800a39:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a3c:	5b                   	pop    %ebx
  800a3d:	5e                   	pop    %esi
  800a3e:	5f                   	pop    %edi
  800a3f:	5d                   	pop    %ebp
  800a40:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800a41:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800a48:	83 ec 0c             	sub    $0xc,%esp
  800a4b:	25 07 0e 00 00       	and    $0xe07,%eax
  800a50:	50                   	push   %eax
  800a51:	57                   	push   %edi
  800a52:	6a 00                	push   $0x0
  800a54:	53                   	push   %ebx
  800a55:	6a 00                	push   $0x0
  800a57:	e8 51 fb ff ff       	call   8005ad <sys_page_map>
  800a5c:	89 c3                	mov    %eax,%ebx
  800a5e:	83 c4 20             	add    $0x20,%esp
  800a61:	85 c0                	test   %eax,%eax
  800a63:	79 a3                	jns    800a08 <dup+0x74>
	sys_page_unmap(0, newfd);
  800a65:	83 ec 08             	sub    $0x8,%esp
  800a68:	56                   	push   %esi
  800a69:	6a 00                	push   $0x0
  800a6b:	e8 7f fb ff ff       	call   8005ef <sys_page_unmap>
	sys_page_unmap(0, nva);
  800a70:	83 c4 08             	add    $0x8,%esp
  800a73:	57                   	push   %edi
  800a74:	6a 00                	push   $0x0
  800a76:	e8 74 fb ff ff       	call   8005ef <sys_page_unmap>
	return r;
  800a7b:	83 c4 10             	add    $0x10,%esp
  800a7e:	eb b7                	jmp    800a37 <dup+0xa3>

00800a80 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800a80:	55                   	push   %ebp
  800a81:	89 e5                	mov    %esp,%ebp
  800a83:	53                   	push   %ebx
  800a84:	83 ec 1c             	sub    $0x1c,%esp
  800a87:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800a8a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800a8d:	50                   	push   %eax
  800a8e:	53                   	push   %ebx
  800a8f:	e8 81 fd ff ff       	call   800815 <fd_lookup>
  800a94:	83 c4 10             	add    $0x10,%esp
  800a97:	85 c0                	test   %eax,%eax
  800a99:	78 3f                	js     800ada <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800a9b:	83 ec 08             	sub    $0x8,%esp
  800a9e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800aa1:	50                   	push   %eax
  800aa2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800aa5:	ff 30                	pushl  (%eax)
  800aa7:	e8 b9 fd ff ff       	call   800865 <dev_lookup>
  800aac:	83 c4 10             	add    $0x10,%esp
  800aaf:	85 c0                	test   %eax,%eax
  800ab1:	78 27                	js     800ada <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800ab3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800ab6:	8b 42 08             	mov    0x8(%edx),%eax
  800ab9:	83 e0 03             	and    $0x3,%eax
  800abc:	83 f8 01             	cmp    $0x1,%eax
  800abf:	74 1e                	je     800adf <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  800ac1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ac4:	8b 40 08             	mov    0x8(%eax),%eax
  800ac7:	85 c0                	test   %eax,%eax
  800ac9:	74 35                	je     800b00 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800acb:	83 ec 04             	sub    $0x4,%esp
  800ace:	ff 75 10             	pushl  0x10(%ebp)
  800ad1:	ff 75 0c             	pushl  0xc(%ebp)
  800ad4:	52                   	push   %edx
  800ad5:	ff d0                	call   *%eax
  800ad7:	83 c4 10             	add    $0x10,%esp
}
  800ada:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800add:	c9                   	leave  
  800ade:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800adf:	a1 04 40 80 00       	mov    0x804004,%eax
  800ae4:	8b 40 48             	mov    0x48(%eax),%eax
  800ae7:	83 ec 04             	sub    $0x4,%esp
  800aea:	53                   	push   %ebx
  800aeb:	50                   	push   %eax
  800aec:	68 fd 1f 80 00       	push   $0x801ffd
  800af1:	e8 04 0a 00 00       	call   8014fa <cprintf>
		return -E_INVAL;
  800af6:	83 c4 10             	add    $0x10,%esp
  800af9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800afe:	eb da                	jmp    800ada <read+0x5a>
		return -E_NOT_SUPP;
  800b00:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800b05:	eb d3                	jmp    800ada <read+0x5a>

00800b07 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800b07:	55                   	push   %ebp
  800b08:	89 e5                	mov    %esp,%ebp
  800b0a:	57                   	push   %edi
  800b0b:	56                   	push   %esi
  800b0c:	53                   	push   %ebx
  800b0d:	83 ec 0c             	sub    $0xc,%esp
  800b10:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b13:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800b16:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b1b:	39 f3                	cmp    %esi,%ebx
  800b1d:	73 23                	jae    800b42 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800b1f:	83 ec 04             	sub    $0x4,%esp
  800b22:	89 f0                	mov    %esi,%eax
  800b24:	29 d8                	sub    %ebx,%eax
  800b26:	50                   	push   %eax
  800b27:	89 d8                	mov    %ebx,%eax
  800b29:	03 45 0c             	add    0xc(%ebp),%eax
  800b2c:	50                   	push   %eax
  800b2d:	57                   	push   %edi
  800b2e:	e8 4d ff ff ff       	call   800a80 <read>
		if (m < 0)
  800b33:	83 c4 10             	add    $0x10,%esp
  800b36:	85 c0                	test   %eax,%eax
  800b38:	78 06                	js     800b40 <readn+0x39>
			return m;
		if (m == 0)
  800b3a:	74 06                	je     800b42 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  800b3c:	01 c3                	add    %eax,%ebx
  800b3e:	eb db                	jmp    800b1b <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800b40:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  800b42:	89 d8                	mov    %ebx,%eax
  800b44:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b47:	5b                   	pop    %ebx
  800b48:	5e                   	pop    %esi
  800b49:	5f                   	pop    %edi
  800b4a:	5d                   	pop    %ebp
  800b4b:	c3                   	ret    

00800b4c <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800b4c:	55                   	push   %ebp
  800b4d:	89 e5                	mov    %esp,%ebp
  800b4f:	53                   	push   %ebx
  800b50:	83 ec 1c             	sub    $0x1c,%esp
  800b53:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800b56:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800b59:	50                   	push   %eax
  800b5a:	53                   	push   %ebx
  800b5b:	e8 b5 fc ff ff       	call   800815 <fd_lookup>
  800b60:	83 c4 10             	add    $0x10,%esp
  800b63:	85 c0                	test   %eax,%eax
  800b65:	78 3a                	js     800ba1 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800b67:	83 ec 08             	sub    $0x8,%esp
  800b6a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800b6d:	50                   	push   %eax
  800b6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b71:	ff 30                	pushl  (%eax)
  800b73:	e8 ed fc ff ff       	call   800865 <dev_lookup>
  800b78:	83 c4 10             	add    $0x10,%esp
  800b7b:	85 c0                	test   %eax,%eax
  800b7d:	78 22                	js     800ba1 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800b7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b82:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800b86:	74 1e                	je     800ba6 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800b88:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b8b:	8b 52 0c             	mov    0xc(%edx),%edx
  800b8e:	85 d2                	test   %edx,%edx
  800b90:	74 35                	je     800bc7 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800b92:	83 ec 04             	sub    $0x4,%esp
  800b95:	ff 75 10             	pushl  0x10(%ebp)
  800b98:	ff 75 0c             	pushl  0xc(%ebp)
  800b9b:	50                   	push   %eax
  800b9c:	ff d2                	call   *%edx
  800b9e:	83 c4 10             	add    $0x10,%esp
}
  800ba1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ba4:	c9                   	leave  
  800ba5:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800ba6:	a1 04 40 80 00       	mov    0x804004,%eax
  800bab:	8b 40 48             	mov    0x48(%eax),%eax
  800bae:	83 ec 04             	sub    $0x4,%esp
  800bb1:	53                   	push   %ebx
  800bb2:	50                   	push   %eax
  800bb3:	68 19 20 80 00       	push   $0x802019
  800bb8:	e8 3d 09 00 00       	call   8014fa <cprintf>
		return -E_INVAL;
  800bbd:	83 c4 10             	add    $0x10,%esp
  800bc0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800bc5:	eb da                	jmp    800ba1 <write+0x55>
		return -E_NOT_SUPP;
  800bc7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800bcc:	eb d3                	jmp    800ba1 <write+0x55>

00800bce <seek>:

int
seek(int fdnum, off_t offset)
{
  800bce:	55                   	push   %ebp
  800bcf:	89 e5                	mov    %esp,%ebp
  800bd1:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800bd4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800bd7:	50                   	push   %eax
  800bd8:	ff 75 08             	pushl  0x8(%ebp)
  800bdb:	e8 35 fc ff ff       	call   800815 <fd_lookup>
  800be0:	83 c4 10             	add    $0x10,%esp
  800be3:	85 c0                	test   %eax,%eax
  800be5:	78 0e                	js     800bf5 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  800be7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800bed:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800bf0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bf5:	c9                   	leave  
  800bf6:	c3                   	ret    

00800bf7 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800bf7:	55                   	push   %ebp
  800bf8:	89 e5                	mov    %esp,%ebp
  800bfa:	53                   	push   %ebx
  800bfb:	83 ec 1c             	sub    $0x1c,%esp
  800bfe:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800c01:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800c04:	50                   	push   %eax
  800c05:	53                   	push   %ebx
  800c06:	e8 0a fc ff ff       	call   800815 <fd_lookup>
  800c0b:	83 c4 10             	add    $0x10,%esp
  800c0e:	85 c0                	test   %eax,%eax
  800c10:	78 37                	js     800c49 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800c12:	83 ec 08             	sub    $0x8,%esp
  800c15:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800c18:	50                   	push   %eax
  800c19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c1c:	ff 30                	pushl  (%eax)
  800c1e:	e8 42 fc ff ff       	call   800865 <dev_lookup>
  800c23:	83 c4 10             	add    $0x10,%esp
  800c26:	85 c0                	test   %eax,%eax
  800c28:	78 1f                	js     800c49 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800c2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c2d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800c31:	74 1b                	je     800c4e <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  800c33:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c36:	8b 52 18             	mov    0x18(%edx),%edx
  800c39:	85 d2                	test   %edx,%edx
  800c3b:	74 32                	je     800c6f <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800c3d:	83 ec 08             	sub    $0x8,%esp
  800c40:	ff 75 0c             	pushl  0xc(%ebp)
  800c43:	50                   	push   %eax
  800c44:	ff d2                	call   *%edx
  800c46:	83 c4 10             	add    $0x10,%esp
}
  800c49:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c4c:	c9                   	leave  
  800c4d:	c3                   	ret    
			thisenv->env_id, fdnum);
  800c4e:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800c53:	8b 40 48             	mov    0x48(%eax),%eax
  800c56:	83 ec 04             	sub    $0x4,%esp
  800c59:	53                   	push   %ebx
  800c5a:	50                   	push   %eax
  800c5b:	68 dc 1f 80 00       	push   $0x801fdc
  800c60:	e8 95 08 00 00       	call   8014fa <cprintf>
		return -E_INVAL;
  800c65:	83 c4 10             	add    $0x10,%esp
  800c68:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c6d:	eb da                	jmp    800c49 <ftruncate+0x52>
		return -E_NOT_SUPP;
  800c6f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800c74:	eb d3                	jmp    800c49 <ftruncate+0x52>

00800c76 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800c76:	55                   	push   %ebp
  800c77:	89 e5                	mov    %esp,%ebp
  800c79:	53                   	push   %ebx
  800c7a:	83 ec 1c             	sub    $0x1c,%esp
  800c7d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800c80:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800c83:	50                   	push   %eax
  800c84:	ff 75 08             	pushl  0x8(%ebp)
  800c87:	e8 89 fb ff ff       	call   800815 <fd_lookup>
  800c8c:	83 c4 10             	add    $0x10,%esp
  800c8f:	85 c0                	test   %eax,%eax
  800c91:	78 4b                	js     800cde <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800c93:	83 ec 08             	sub    $0x8,%esp
  800c96:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800c99:	50                   	push   %eax
  800c9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c9d:	ff 30                	pushl  (%eax)
  800c9f:	e8 c1 fb ff ff       	call   800865 <dev_lookup>
  800ca4:	83 c4 10             	add    $0x10,%esp
  800ca7:	85 c0                	test   %eax,%eax
  800ca9:	78 33                	js     800cde <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  800cab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800cae:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800cb2:	74 2f                	je     800ce3 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800cb4:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800cb7:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800cbe:	00 00 00 
	stat->st_isdir = 0;
  800cc1:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800cc8:	00 00 00 
	stat->st_dev = dev;
  800ccb:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800cd1:	83 ec 08             	sub    $0x8,%esp
  800cd4:	53                   	push   %ebx
  800cd5:	ff 75 f0             	pushl  -0x10(%ebp)
  800cd8:	ff 50 14             	call   *0x14(%eax)
  800cdb:	83 c4 10             	add    $0x10,%esp
}
  800cde:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ce1:	c9                   	leave  
  800ce2:	c3                   	ret    
		return -E_NOT_SUPP;
  800ce3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800ce8:	eb f4                	jmp    800cde <fstat+0x68>

00800cea <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800cea:	55                   	push   %ebp
  800ceb:	89 e5                	mov    %esp,%ebp
  800ced:	56                   	push   %esi
  800cee:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800cef:	83 ec 08             	sub    $0x8,%esp
  800cf2:	6a 00                	push   $0x0
  800cf4:	ff 75 08             	pushl  0x8(%ebp)
  800cf7:	e8 bb 01 00 00       	call   800eb7 <open>
  800cfc:	89 c3                	mov    %eax,%ebx
  800cfe:	83 c4 10             	add    $0x10,%esp
  800d01:	85 c0                	test   %eax,%eax
  800d03:	78 1b                	js     800d20 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  800d05:	83 ec 08             	sub    $0x8,%esp
  800d08:	ff 75 0c             	pushl  0xc(%ebp)
  800d0b:	50                   	push   %eax
  800d0c:	e8 65 ff ff ff       	call   800c76 <fstat>
  800d11:	89 c6                	mov    %eax,%esi
	close(fd);
  800d13:	89 1c 24             	mov    %ebx,(%esp)
  800d16:	e8 27 fc ff ff       	call   800942 <close>
	return r;
  800d1b:	83 c4 10             	add    $0x10,%esp
  800d1e:	89 f3                	mov    %esi,%ebx
}
  800d20:	89 d8                	mov    %ebx,%eax
  800d22:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d25:	5b                   	pop    %ebx
  800d26:	5e                   	pop    %esi
  800d27:	5d                   	pop    %ebp
  800d28:	c3                   	ret    

00800d29 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800d29:	55                   	push   %ebp
  800d2a:	89 e5                	mov    %esp,%ebp
  800d2c:	56                   	push   %esi
  800d2d:	53                   	push   %ebx
  800d2e:	89 c6                	mov    %eax,%esi
  800d30:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800d32:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800d39:	74 27                	je     800d62 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800d3b:	6a 07                	push   $0x7
  800d3d:	68 00 50 80 00       	push   $0x805000
  800d42:	56                   	push   %esi
  800d43:	ff 35 00 40 80 00    	pushl  0x804000
  800d49:	e8 02 0f 00 00       	call   801c50 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800d4e:	83 c4 0c             	add    $0xc,%esp
  800d51:	6a 00                	push   $0x0
  800d53:	53                   	push   %ebx
  800d54:	6a 00                	push   $0x0
  800d56:	e8 8c 0e 00 00       	call   801be7 <ipc_recv>
}
  800d5b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d5e:	5b                   	pop    %ebx
  800d5f:	5e                   	pop    %esi
  800d60:	5d                   	pop    %ebp
  800d61:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800d62:	83 ec 0c             	sub    $0xc,%esp
  800d65:	6a 01                	push   $0x1
  800d67:	e8 31 0f 00 00       	call   801c9d <ipc_find_env>
  800d6c:	a3 00 40 80 00       	mov    %eax,0x804000
  800d71:	83 c4 10             	add    $0x10,%esp
  800d74:	eb c5                	jmp    800d3b <fsipc+0x12>

00800d76 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800d76:	55                   	push   %ebp
  800d77:	89 e5                	mov    %esp,%ebp
  800d79:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7f:	8b 40 0c             	mov    0xc(%eax),%eax
  800d82:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800d87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8a:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800d8f:	ba 00 00 00 00       	mov    $0x0,%edx
  800d94:	b8 02 00 00 00       	mov    $0x2,%eax
  800d99:	e8 8b ff ff ff       	call   800d29 <fsipc>
}
  800d9e:	c9                   	leave  
  800d9f:	c3                   	ret    

00800da0 <devfile_flush>:
{
  800da0:	55                   	push   %ebp
  800da1:	89 e5                	mov    %esp,%ebp
  800da3:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800da6:	8b 45 08             	mov    0x8(%ebp),%eax
  800da9:	8b 40 0c             	mov    0xc(%eax),%eax
  800dac:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800db1:	ba 00 00 00 00       	mov    $0x0,%edx
  800db6:	b8 06 00 00 00       	mov    $0x6,%eax
  800dbb:	e8 69 ff ff ff       	call   800d29 <fsipc>
}
  800dc0:	c9                   	leave  
  800dc1:	c3                   	ret    

00800dc2 <devfile_stat>:
{
  800dc2:	55                   	push   %ebp
  800dc3:	89 e5                	mov    %esp,%ebp
  800dc5:	53                   	push   %ebx
  800dc6:	83 ec 04             	sub    $0x4,%esp
  800dc9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcf:	8b 40 0c             	mov    0xc(%eax),%eax
  800dd2:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800dd7:	ba 00 00 00 00       	mov    $0x0,%edx
  800ddc:	b8 05 00 00 00       	mov    $0x5,%eax
  800de1:	e8 43 ff ff ff       	call   800d29 <fsipc>
  800de6:	85 c0                	test   %eax,%eax
  800de8:	78 2c                	js     800e16 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800dea:	83 ec 08             	sub    $0x8,%esp
  800ded:	68 00 50 80 00       	push   $0x805000
  800df2:	53                   	push   %ebx
  800df3:	e8 80 f3 ff ff       	call   800178 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800df8:	a1 80 50 80 00       	mov    0x805080,%eax
  800dfd:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800e03:	a1 84 50 80 00       	mov    0x805084,%eax
  800e08:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800e0e:	83 c4 10             	add    $0x10,%esp
  800e11:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e16:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e19:	c9                   	leave  
  800e1a:	c3                   	ret    

00800e1b <devfile_write>:
{
  800e1b:	55                   	push   %ebp
  800e1c:	89 e5                	mov    %esp,%ebp
  800e1e:	83 ec 0c             	sub    $0xc,%esp
	panic("devfile_write not implemented");
  800e21:	68 48 20 80 00       	push   $0x802048
  800e26:	68 90 00 00 00       	push   $0x90
  800e2b:	68 66 20 80 00       	push   $0x802066
  800e30:	e8 ea 05 00 00       	call   80141f <_panic>

00800e35 <devfile_read>:
{
  800e35:	55                   	push   %ebp
  800e36:	89 e5                	mov    %esp,%ebp
  800e38:	56                   	push   %esi
  800e39:	53                   	push   %ebx
  800e3a:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e40:	8b 40 0c             	mov    0xc(%eax),%eax
  800e43:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800e48:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800e4e:	ba 00 00 00 00       	mov    $0x0,%edx
  800e53:	b8 03 00 00 00       	mov    $0x3,%eax
  800e58:	e8 cc fe ff ff       	call   800d29 <fsipc>
  800e5d:	89 c3                	mov    %eax,%ebx
  800e5f:	85 c0                	test   %eax,%eax
  800e61:	78 1f                	js     800e82 <devfile_read+0x4d>
	assert(r <= n);
  800e63:	39 f0                	cmp    %esi,%eax
  800e65:	77 24                	ja     800e8b <devfile_read+0x56>
	assert(r <= PGSIZE);
  800e67:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800e6c:	7f 33                	jg     800ea1 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800e6e:	83 ec 04             	sub    $0x4,%esp
  800e71:	50                   	push   %eax
  800e72:	68 00 50 80 00       	push   $0x805000
  800e77:	ff 75 0c             	pushl  0xc(%ebp)
  800e7a:	e8 87 f4 ff ff       	call   800306 <memmove>
	return r;
  800e7f:	83 c4 10             	add    $0x10,%esp
}
  800e82:	89 d8                	mov    %ebx,%eax
  800e84:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e87:	5b                   	pop    %ebx
  800e88:	5e                   	pop    %esi
  800e89:	5d                   	pop    %ebp
  800e8a:	c3                   	ret    
	assert(r <= n);
  800e8b:	68 71 20 80 00       	push   $0x802071
  800e90:	68 78 20 80 00       	push   $0x802078
  800e95:	6a 7c                	push   $0x7c
  800e97:	68 66 20 80 00       	push   $0x802066
  800e9c:	e8 7e 05 00 00       	call   80141f <_panic>
	assert(r <= PGSIZE);
  800ea1:	68 8d 20 80 00       	push   $0x80208d
  800ea6:	68 78 20 80 00       	push   $0x802078
  800eab:	6a 7d                	push   $0x7d
  800ead:	68 66 20 80 00       	push   $0x802066
  800eb2:	e8 68 05 00 00       	call   80141f <_panic>

00800eb7 <open>:
{
  800eb7:	55                   	push   %ebp
  800eb8:	89 e5                	mov    %esp,%ebp
  800eba:	56                   	push   %esi
  800ebb:	53                   	push   %ebx
  800ebc:	83 ec 1c             	sub    $0x1c,%esp
  800ebf:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800ec2:	56                   	push   %esi
  800ec3:	e8 77 f2 ff ff       	call   80013f <strlen>
  800ec8:	83 c4 10             	add    $0x10,%esp
  800ecb:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800ed0:	7f 6c                	jg     800f3e <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  800ed2:	83 ec 0c             	sub    $0xc,%esp
  800ed5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ed8:	50                   	push   %eax
  800ed9:	e8 e5 f8 ff ff       	call   8007c3 <fd_alloc>
  800ede:	89 c3                	mov    %eax,%ebx
  800ee0:	83 c4 10             	add    $0x10,%esp
  800ee3:	85 c0                	test   %eax,%eax
  800ee5:	78 3c                	js     800f23 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  800ee7:	83 ec 08             	sub    $0x8,%esp
  800eea:	56                   	push   %esi
  800eeb:	68 00 50 80 00       	push   $0x805000
  800ef0:	e8 83 f2 ff ff       	call   800178 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800ef5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef8:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800efd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f00:	b8 01 00 00 00       	mov    $0x1,%eax
  800f05:	e8 1f fe ff ff       	call   800d29 <fsipc>
  800f0a:	89 c3                	mov    %eax,%ebx
  800f0c:	83 c4 10             	add    $0x10,%esp
  800f0f:	85 c0                	test   %eax,%eax
  800f11:	78 19                	js     800f2c <open+0x75>
	return fd2num(fd);
  800f13:	83 ec 0c             	sub    $0xc,%esp
  800f16:	ff 75 f4             	pushl  -0xc(%ebp)
  800f19:	e8 7e f8 ff ff       	call   80079c <fd2num>
  800f1e:	89 c3                	mov    %eax,%ebx
  800f20:	83 c4 10             	add    $0x10,%esp
}
  800f23:	89 d8                	mov    %ebx,%eax
  800f25:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f28:	5b                   	pop    %ebx
  800f29:	5e                   	pop    %esi
  800f2a:	5d                   	pop    %ebp
  800f2b:	c3                   	ret    
		fd_close(fd, 0);
  800f2c:	83 ec 08             	sub    $0x8,%esp
  800f2f:	6a 00                	push   $0x0
  800f31:	ff 75 f4             	pushl  -0xc(%ebp)
  800f34:	e8 82 f9 ff ff       	call   8008bb <fd_close>
		return r;
  800f39:	83 c4 10             	add    $0x10,%esp
  800f3c:	eb e5                	jmp    800f23 <open+0x6c>
		return -E_BAD_PATH;
  800f3e:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800f43:	eb de                	jmp    800f23 <open+0x6c>

00800f45 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800f45:	55                   	push   %ebp
  800f46:	89 e5                	mov    %esp,%ebp
  800f48:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800f4b:	ba 00 00 00 00       	mov    $0x0,%edx
  800f50:	b8 08 00 00 00       	mov    $0x8,%eax
  800f55:	e8 cf fd ff ff       	call   800d29 <fsipc>
}
  800f5a:	c9                   	leave  
  800f5b:	c3                   	ret    

00800f5c <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800f5c:	55                   	push   %ebp
  800f5d:	89 e5                	mov    %esp,%ebp
  800f5f:	56                   	push   %esi
  800f60:	53                   	push   %ebx
  800f61:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800f64:	83 ec 0c             	sub    $0xc,%esp
  800f67:	ff 75 08             	pushl  0x8(%ebp)
  800f6a:	e8 3d f8 ff ff       	call   8007ac <fd2data>
  800f6f:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800f71:	83 c4 08             	add    $0x8,%esp
  800f74:	68 99 20 80 00       	push   $0x802099
  800f79:	53                   	push   %ebx
  800f7a:	e8 f9 f1 ff ff       	call   800178 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800f7f:	8b 46 04             	mov    0x4(%esi),%eax
  800f82:	2b 06                	sub    (%esi),%eax
  800f84:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800f8a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800f91:	00 00 00 
	stat->st_dev = &devpipe;
  800f94:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  800f9b:	30 80 00 
	return 0;
}
  800f9e:	b8 00 00 00 00       	mov    $0x0,%eax
  800fa3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800fa6:	5b                   	pop    %ebx
  800fa7:	5e                   	pop    %esi
  800fa8:	5d                   	pop    %ebp
  800fa9:	c3                   	ret    

00800faa <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800faa:	55                   	push   %ebp
  800fab:	89 e5                	mov    %esp,%ebp
  800fad:	53                   	push   %ebx
  800fae:	83 ec 0c             	sub    $0xc,%esp
  800fb1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800fb4:	53                   	push   %ebx
  800fb5:	6a 00                	push   $0x0
  800fb7:	e8 33 f6 ff ff       	call   8005ef <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800fbc:	89 1c 24             	mov    %ebx,(%esp)
  800fbf:	e8 e8 f7 ff ff       	call   8007ac <fd2data>
  800fc4:	83 c4 08             	add    $0x8,%esp
  800fc7:	50                   	push   %eax
  800fc8:	6a 00                	push   $0x0
  800fca:	e8 20 f6 ff ff       	call   8005ef <sys_page_unmap>
}
  800fcf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800fd2:	c9                   	leave  
  800fd3:	c3                   	ret    

00800fd4 <_pipeisclosed>:
{
  800fd4:	55                   	push   %ebp
  800fd5:	89 e5                	mov    %esp,%ebp
  800fd7:	57                   	push   %edi
  800fd8:	56                   	push   %esi
  800fd9:	53                   	push   %ebx
  800fda:	83 ec 1c             	sub    $0x1c,%esp
  800fdd:	89 c7                	mov    %eax,%edi
  800fdf:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  800fe1:	a1 04 40 80 00       	mov    0x804004,%eax
  800fe6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  800fe9:	83 ec 0c             	sub    $0xc,%esp
  800fec:	57                   	push   %edi
  800fed:	e8 ea 0c 00 00       	call   801cdc <pageref>
  800ff2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ff5:	89 34 24             	mov    %esi,(%esp)
  800ff8:	e8 df 0c 00 00       	call   801cdc <pageref>
		nn = thisenv->env_runs;
  800ffd:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801003:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801006:	83 c4 10             	add    $0x10,%esp
  801009:	39 cb                	cmp    %ecx,%ebx
  80100b:	74 1b                	je     801028 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80100d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801010:	75 cf                	jne    800fe1 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801012:	8b 42 58             	mov    0x58(%edx),%eax
  801015:	6a 01                	push   $0x1
  801017:	50                   	push   %eax
  801018:	53                   	push   %ebx
  801019:	68 a0 20 80 00       	push   $0x8020a0
  80101e:	e8 d7 04 00 00       	call   8014fa <cprintf>
  801023:	83 c4 10             	add    $0x10,%esp
  801026:	eb b9                	jmp    800fe1 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801028:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80102b:	0f 94 c0             	sete   %al
  80102e:	0f b6 c0             	movzbl %al,%eax
}
  801031:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801034:	5b                   	pop    %ebx
  801035:	5e                   	pop    %esi
  801036:	5f                   	pop    %edi
  801037:	5d                   	pop    %ebp
  801038:	c3                   	ret    

00801039 <devpipe_write>:
{
  801039:	55                   	push   %ebp
  80103a:	89 e5                	mov    %esp,%ebp
  80103c:	57                   	push   %edi
  80103d:	56                   	push   %esi
  80103e:	53                   	push   %ebx
  80103f:	83 ec 28             	sub    $0x28,%esp
  801042:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801045:	56                   	push   %esi
  801046:	e8 61 f7 ff ff       	call   8007ac <fd2data>
  80104b:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80104d:	83 c4 10             	add    $0x10,%esp
  801050:	bf 00 00 00 00       	mov    $0x0,%edi
  801055:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801058:	74 4f                	je     8010a9 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80105a:	8b 43 04             	mov    0x4(%ebx),%eax
  80105d:	8b 0b                	mov    (%ebx),%ecx
  80105f:	8d 51 20             	lea    0x20(%ecx),%edx
  801062:	39 d0                	cmp    %edx,%eax
  801064:	72 14                	jb     80107a <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801066:	89 da                	mov    %ebx,%edx
  801068:	89 f0                	mov    %esi,%eax
  80106a:	e8 65 ff ff ff       	call   800fd4 <_pipeisclosed>
  80106f:	85 c0                	test   %eax,%eax
  801071:	75 3b                	jne    8010ae <devpipe_write+0x75>
			sys_yield();
  801073:	e8 d3 f4 ff ff       	call   80054b <sys_yield>
  801078:	eb e0                	jmp    80105a <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80107a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80107d:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801081:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801084:	89 c2                	mov    %eax,%edx
  801086:	c1 fa 1f             	sar    $0x1f,%edx
  801089:	89 d1                	mov    %edx,%ecx
  80108b:	c1 e9 1b             	shr    $0x1b,%ecx
  80108e:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801091:	83 e2 1f             	and    $0x1f,%edx
  801094:	29 ca                	sub    %ecx,%edx
  801096:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80109a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80109e:	83 c0 01             	add    $0x1,%eax
  8010a1:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8010a4:	83 c7 01             	add    $0x1,%edi
  8010a7:	eb ac                	jmp    801055 <devpipe_write+0x1c>
	return i;
  8010a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ac:	eb 05                	jmp    8010b3 <devpipe_write+0x7a>
				return 0;
  8010ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010b6:	5b                   	pop    %ebx
  8010b7:	5e                   	pop    %esi
  8010b8:	5f                   	pop    %edi
  8010b9:	5d                   	pop    %ebp
  8010ba:	c3                   	ret    

008010bb <devpipe_read>:
{
  8010bb:	55                   	push   %ebp
  8010bc:	89 e5                	mov    %esp,%ebp
  8010be:	57                   	push   %edi
  8010bf:	56                   	push   %esi
  8010c0:	53                   	push   %ebx
  8010c1:	83 ec 18             	sub    $0x18,%esp
  8010c4:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8010c7:	57                   	push   %edi
  8010c8:	e8 df f6 ff ff       	call   8007ac <fd2data>
  8010cd:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8010cf:	83 c4 10             	add    $0x10,%esp
  8010d2:	be 00 00 00 00       	mov    $0x0,%esi
  8010d7:	3b 75 10             	cmp    0x10(%ebp),%esi
  8010da:	75 14                	jne    8010f0 <devpipe_read+0x35>
	return i;
  8010dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8010df:	eb 02                	jmp    8010e3 <devpipe_read+0x28>
				return i;
  8010e1:	89 f0                	mov    %esi,%eax
}
  8010e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010e6:	5b                   	pop    %ebx
  8010e7:	5e                   	pop    %esi
  8010e8:	5f                   	pop    %edi
  8010e9:	5d                   	pop    %ebp
  8010ea:	c3                   	ret    
			sys_yield();
  8010eb:	e8 5b f4 ff ff       	call   80054b <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8010f0:	8b 03                	mov    (%ebx),%eax
  8010f2:	3b 43 04             	cmp    0x4(%ebx),%eax
  8010f5:	75 18                	jne    80110f <devpipe_read+0x54>
			if (i > 0)
  8010f7:	85 f6                	test   %esi,%esi
  8010f9:	75 e6                	jne    8010e1 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8010fb:	89 da                	mov    %ebx,%edx
  8010fd:	89 f8                	mov    %edi,%eax
  8010ff:	e8 d0 fe ff ff       	call   800fd4 <_pipeisclosed>
  801104:	85 c0                	test   %eax,%eax
  801106:	74 e3                	je     8010eb <devpipe_read+0x30>
				return 0;
  801108:	b8 00 00 00 00       	mov    $0x0,%eax
  80110d:	eb d4                	jmp    8010e3 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80110f:	99                   	cltd   
  801110:	c1 ea 1b             	shr    $0x1b,%edx
  801113:	01 d0                	add    %edx,%eax
  801115:	83 e0 1f             	and    $0x1f,%eax
  801118:	29 d0                	sub    %edx,%eax
  80111a:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80111f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801122:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801125:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801128:	83 c6 01             	add    $0x1,%esi
  80112b:	eb aa                	jmp    8010d7 <devpipe_read+0x1c>

0080112d <pipe>:
{
  80112d:	55                   	push   %ebp
  80112e:	89 e5                	mov    %esp,%ebp
  801130:	56                   	push   %esi
  801131:	53                   	push   %ebx
  801132:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801135:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801138:	50                   	push   %eax
  801139:	e8 85 f6 ff ff       	call   8007c3 <fd_alloc>
  80113e:	89 c3                	mov    %eax,%ebx
  801140:	83 c4 10             	add    $0x10,%esp
  801143:	85 c0                	test   %eax,%eax
  801145:	0f 88 23 01 00 00    	js     80126e <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80114b:	83 ec 04             	sub    $0x4,%esp
  80114e:	68 07 04 00 00       	push   $0x407
  801153:	ff 75 f4             	pushl  -0xc(%ebp)
  801156:	6a 00                	push   $0x0
  801158:	e8 0d f4 ff ff       	call   80056a <sys_page_alloc>
  80115d:	89 c3                	mov    %eax,%ebx
  80115f:	83 c4 10             	add    $0x10,%esp
  801162:	85 c0                	test   %eax,%eax
  801164:	0f 88 04 01 00 00    	js     80126e <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  80116a:	83 ec 0c             	sub    $0xc,%esp
  80116d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801170:	50                   	push   %eax
  801171:	e8 4d f6 ff ff       	call   8007c3 <fd_alloc>
  801176:	89 c3                	mov    %eax,%ebx
  801178:	83 c4 10             	add    $0x10,%esp
  80117b:	85 c0                	test   %eax,%eax
  80117d:	0f 88 db 00 00 00    	js     80125e <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801183:	83 ec 04             	sub    $0x4,%esp
  801186:	68 07 04 00 00       	push   $0x407
  80118b:	ff 75 f0             	pushl  -0x10(%ebp)
  80118e:	6a 00                	push   $0x0
  801190:	e8 d5 f3 ff ff       	call   80056a <sys_page_alloc>
  801195:	89 c3                	mov    %eax,%ebx
  801197:	83 c4 10             	add    $0x10,%esp
  80119a:	85 c0                	test   %eax,%eax
  80119c:	0f 88 bc 00 00 00    	js     80125e <pipe+0x131>
	va = fd2data(fd0);
  8011a2:	83 ec 0c             	sub    $0xc,%esp
  8011a5:	ff 75 f4             	pushl  -0xc(%ebp)
  8011a8:	e8 ff f5 ff ff       	call   8007ac <fd2data>
  8011ad:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8011af:	83 c4 0c             	add    $0xc,%esp
  8011b2:	68 07 04 00 00       	push   $0x407
  8011b7:	50                   	push   %eax
  8011b8:	6a 00                	push   $0x0
  8011ba:	e8 ab f3 ff ff       	call   80056a <sys_page_alloc>
  8011bf:	89 c3                	mov    %eax,%ebx
  8011c1:	83 c4 10             	add    $0x10,%esp
  8011c4:	85 c0                	test   %eax,%eax
  8011c6:	0f 88 82 00 00 00    	js     80124e <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8011cc:	83 ec 0c             	sub    $0xc,%esp
  8011cf:	ff 75 f0             	pushl  -0x10(%ebp)
  8011d2:	e8 d5 f5 ff ff       	call   8007ac <fd2data>
  8011d7:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8011de:	50                   	push   %eax
  8011df:	6a 00                	push   $0x0
  8011e1:	56                   	push   %esi
  8011e2:	6a 00                	push   $0x0
  8011e4:	e8 c4 f3 ff ff       	call   8005ad <sys_page_map>
  8011e9:	89 c3                	mov    %eax,%ebx
  8011eb:	83 c4 20             	add    $0x20,%esp
  8011ee:	85 c0                	test   %eax,%eax
  8011f0:	78 4e                	js     801240 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8011f2:	a1 20 30 80 00       	mov    0x803020,%eax
  8011f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011fa:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8011fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011ff:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801206:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801209:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80120b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80120e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801215:	83 ec 0c             	sub    $0xc,%esp
  801218:	ff 75 f4             	pushl  -0xc(%ebp)
  80121b:	e8 7c f5 ff ff       	call   80079c <fd2num>
  801220:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801223:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801225:	83 c4 04             	add    $0x4,%esp
  801228:	ff 75 f0             	pushl  -0x10(%ebp)
  80122b:	e8 6c f5 ff ff       	call   80079c <fd2num>
  801230:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801233:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801236:	83 c4 10             	add    $0x10,%esp
  801239:	bb 00 00 00 00       	mov    $0x0,%ebx
  80123e:	eb 2e                	jmp    80126e <pipe+0x141>
	sys_page_unmap(0, va);
  801240:	83 ec 08             	sub    $0x8,%esp
  801243:	56                   	push   %esi
  801244:	6a 00                	push   $0x0
  801246:	e8 a4 f3 ff ff       	call   8005ef <sys_page_unmap>
  80124b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80124e:	83 ec 08             	sub    $0x8,%esp
  801251:	ff 75 f0             	pushl  -0x10(%ebp)
  801254:	6a 00                	push   $0x0
  801256:	e8 94 f3 ff ff       	call   8005ef <sys_page_unmap>
  80125b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80125e:	83 ec 08             	sub    $0x8,%esp
  801261:	ff 75 f4             	pushl  -0xc(%ebp)
  801264:	6a 00                	push   $0x0
  801266:	e8 84 f3 ff ff       	call   8005ef <sys_page_unmap>
  80126b:	83 c4 10             	add    $0x10,%esp
}
  80126e:	89 d8                	mov    %ebx,%eax
  801270:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801273:	5b                   	pop    %ebx
  801274:	5e                   	pop    %esi
  801275:	5d                   	pop    %ebp
  801276:	c3                   	ret    

00801277 <pipeisclosed>:
{
  801277:	55                   	push   %ebp
  801278:	89 e5                	mov    %esp,%ebp
  80127a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80127d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801280:	50                   	push   %eax
  801281:	ff 75 08             	pushl  0x8(%ebp)
  801284:	e8 8c f5 ff ff       	call   800815 <fd_lookup>
  801289:	83 c4 10             	add    $0x10,%esp
  80128c:	85 c0                	test   %eax,%eax
  80128e:	78 18                	js     8012a8 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801290:	83 ec 0c             	sub    $0xc,%esp
  801293:	ff 75 f4             	pushl  -0xc(%ebp)
  801296:	e8 11 f5 ff ff       	call   8007ac <fd2data>
	return _pipeisclosed(fd, p);
  80129b:	89 c2                	mov    %eax,%edx
  80129d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012a0:	e8 2f fd ff ff       	call   800fd4 <_pipeisclosed>
  8012a5:	83 c4 10             	add    $0x10,%esp
}
  8012a8:	c9                   	leave  
  8012a9:	c3                   	ret    

008012aa <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8012aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8012af:	c3                   	ret    

008012b0 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8012b0:	55                   	push   %ebp
  8012b1:	89 e5                	mov    %esp,%ebp
  8012b3:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8012b6:	68 b8 20 80 00       	push   $0x8020b8
  8012bb:	ff 75 0c             	pushl  0xc(%ebp)
  8012be:	e8 b5 ee ff ff       	call   800178 <strcpy>
	return 0;
}
  8012c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8012c8:	c9                   	leave  
  8012c9:	c3                   	ret    

008012ca <devcons_write>:
{
  8012ca:	55                   	push   %ebp
  8012cb:	89 e5                	mov    %esp,%ebp
  8012cd:	57                   	push   %edi
  8012ce:	56                   	push   %esi
  8012cf:	53                   	push   %ebx
  8012d0:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8012d6:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8012db:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8012e1:	3b 75 10             	cmp    0x10(%ebp),%esi
  8012e4:	73 31                	jae    801317 <devcons_write+0x4d>
		m = n - tot;
  8012e6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8012e9:	29 f3                	sub    %esi,%ebx
  8012eb:	83 fb 7f             	cmp    $0x7f,%ebx
  8012ee:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8012f3:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8012f6:	83 ec 04             	sub    $0x4,%esp
  8012f9:	53                   	push   %ebx
  8012fa:	89 f0                	mov    %esi,%eax
  8012fc:	03 45 0c             	add    0xc(%ebp),%eax
  8012ff:	50                   	push   %eax
  801300:	57                   	push   %edi
  801301:	e8 00 f0 ff ff       	call   800306 <memmove>
		sys_cputs(buf, m);
  801306:	83 c4 08             	add    $0x8,%esp
  801309:	53                   	push   %ebx
  80130a:	57                   	push   %edi
  80130b:	e8 9e f1 ff ff       	call   8004ae <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801310:	01 de                	add    %ebx,%esi
  801312:	83 c4 10             	add    $0x10,%esp
  801315:	eb ca                	jmp    8012e1 <devcons_write+0x17>
}
  801317:	89 f0                	mov    %esi,%eax
  801319:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80131c:	5b                   	pop    %ebx
  80131d:	5e                   	pop    %esi
  80131e:	5f                   	pop    %edi
  80131f:	5d                   	pop    %ebp
  801320:	c3                   	ret    

00801321 <devcons_read>:
{
  801321:	55                   	push   %ebp
  801322:	89 e5                	mov    %esp,%ebp
  801324:	83 ec 08             	sub    $0x8,%esp
  801327:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80132c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801330:	74 21                	je     801353 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  801332:	e8 95 f1 ff ff       	call   8004cc <sys_cgetc>
  801337:	85 c0                	test   %eax,%eax
  801339:	75 07                	jne    801342 <devcons_read+0x21>
		sys_yield();
  80133b:	e8 0b f2 ff ff       	call   80054b <sys_yield>
  801340:	eb f0                	jmp    801332 <devcons_read+0x11>
	if (c < 0)
  801342:	78 0f                	js     801353 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  801344:	83 f8 04             	cmp    $0x4,%eax
  801347:	74 0c                	je     801355 <devcons_read+0x34>
	*(char*)vbuf = c;
  801349:	8b 55 0c             	mov    0xc(%ebp),%edx
  80134c:	88 02                	mov    %al,(%edx)
	return 1;
  80134e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801353:	c9                   	leave  
  801354:	c3                   	ret    
		return 0;
  801355:	b8 00 00 00 00       	mov    $0x0,%eax
  80135a:	eb f7                	jmp    801353 <devcons_read+0x32>

0080135c <cputchar>:
{
  80135c:	55                   	push   %ebp
  80135d:	89 e5                	mov    %esp,%ebp
  80135f:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801362:	8b 45 08             	mov    0x8(%ebp),%eax
  801365:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801368:	6a 01                	push   $0x1
  80136a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80136d:	50                   	push   %eax
  80136e:	e8 3b f1 ff ff       	call   8004ae <sys_cputs>
}
  801373:	83 c4 10             	add    $0x10,%esp
  801376:	c9                   	leave  
  801377:	c3                   	ret    

00801378 <getchar>:
{
  801378:	55                   	push   %ebp
  801379:	89 e5                	mov    %esp,%ebp
  80137b:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80137e:	6a 01                	push   $0x1
  801380:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801383:	50                   	push   %eax
  801384:	6a 00                	push   $0x0
  801386:	e8 f5 f6 ff ff       	call   800a80 <read>
	if (r < 0)
  80138b:	83 c4 10             	add    $0x10,%esp
  80138e:	85 c0                	test   %eax,%eax
  801390:	78 06                	js     801398 <getchar+0x20>
	if (r < 1)
  801392:	74 06                	je     80139a <getchar+0x22>
	return c;
  801394:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801398:	c9                   	leave  
  801399:	c3                   	ret    
		return -E_EOF;
  80139a:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80139f:	eb f7                	jmp    801398 <getchar+0x20>

008013a1 <iscons>:
{
  8013a1:	55                   	push   %ebp
  8013a2:	89 e5                	mov    %esp,%ebp
  8013a4:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013a7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013aa:	50                   	push   %eax
  8013ab:	ff 75 08             	pushl  0x8(%ebp)
  8013ae:	e8 62 f4 ff ff       	call   800815 <fd_lookup>
  8013b3:	83 c4 10             	add    $0x10,%esp
  8013b6:	85 c0                	test   %eax,%eax
  8013b8:	78 11                	js     8013cb <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8013ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013bd:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8013c3:	39 10                	cmp    %edx,(%eax)
  8013c5:	0f 94 c0             	sete   %al
  8013c8:	0f b6 c0             	movzbl %al,%eax
}
  8013cb:	c9                   	leave  
  8013cc:	c3                   	ret    

008013cd <opencons>:
{
  8013cd:	55                   	push   %ebp
  8013ce:	89 e5                	mov    %esp,%ebp
  8013d0:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8013d3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013d6:	50                   	push   %eax
  8013d7:	e8 e7 f3 ff ff       	call   8007c3 <fd_alloc>
  8013dc:	83 c4 10             	add    $0x10,%esp
  8013df:	85 c0                	test   %eax,%eax
  8013e1:	78 3a                	js     80141d <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8013e3:	83 ec 04             	sub    $0x4,%esp
  8013e6:	68 07 04 00 00       	push   $0x407
  8013eb:	ff 75 f4             	pushl  -0xc(%ebp)
  8013ee:	6a 00                	push   $0x0
  8013f0:	e8 75 f1 ff ff       	call   80056a <sys_page_alloc>
  8013f5:	83 c4 10             	add    $0x10,%esp
  8013f8:	85 c0                	test   %eax,%eax
  8013fa:	78 21                	js     80141d <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8013fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013ff:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801405:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801407:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80140a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801411:	83 ec 0c             	sub    $0xc,%esp
  801414:	50                   	push   %eax
  801415:	e8 82 f3 ff ff       	call   80079c <fd2num>
  80141a:	83 c4 10             	add    $0x10,%esp
}
  80141d:	c9                   	leave  
  80141e:	c3                   	ret    

0080141f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80141f:	55                   	push   %ebp
  801420:	89 e5                	mov    %esp,%ebp
  801422:	56                   	push   %esi
  801423:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801424:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801427:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80142d:	e8 fa f0 ff ff       	call   80052c <sys_getenvid>
  801432:	83 ec 0c             	sub    $0xc,%esp
  801435:	ff 75 0c             	pushl  0xc(%ebp)
  801438:	ff 75 08             	pushl  0x8(%ebp)
  80143b:	56                   	push   %esi
  80143c:	50                   	push   %eax
  80143d:	68 c4 20 80 00       	push   $0x8020c4
  801442:	e8 b3 00 00 00       	call   8014fa <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801447:	83 c4 18             	add    $0x18,%esp
  80144a:	53                   	push   %ebx
  80144b:	ff 75 10             	pushl  0x10(%ebp)
  80144e:	e8 56 00 00 00       	call   8014a9 <vcprintf>
	cprintf("\n");
  801453:	c7 04 24 b1 20 80 00 	movl   $0x8020b1,(%esp)
  80145a:	e8 9b 00 00 00       	call   8014fa <cprintf>
  80145f:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801462:	cc                   	int3   
  801463:	eb fd                	jmp    801462 <_panic+0x43>

00801465 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801465:	55                   	push   %ebp
  801466:	89 e5                	mov    %esp,%ebp
  801468:	53                   	push   %ebx
  801469:	83 ec 04             	sub    $0x4,%esp
  80146c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80146f:	8b 13                	mov    (%ebx),%edx
  801471:	8d 42 01             	lea    0x1(%edx),%eax
  801474:	89 03                	mov    %eax,(%ebx)
  801476:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801479:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80147d:	3d ff 00 00 00       	cmp    $0xff,%eax
  801482:	74 09                	je     80148d <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  801484:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801488:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80148b:	c9                   	leave  
  80148c:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80148d:	83 ec 08             	sub    $0x8,%esp
  801490:	68 ff 00 00 00       	push   $0xff
  801495:	8d 43 08             	lea    0x8(%ebx),%eax
  801498:	50                   	push   %eax
  801499:	e8 10 f0 ff ff       	call   8004ae <sys_cputs>
		b->idx = 0;
  80149e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8014a4:	83 c4 10             	add    $0x10,%esp
  8014a7:	eb db                	jmp    801484 <putch+0x1f>

008014a9 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8014a9:	55                   	push   %ebp
  8014aa:	89 e5                	mov    %esp,%ebp
  8014ac:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8014b2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8014b9:	00 00 00 
	b.cnt = 0;
  8014bc:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8014c3:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8014c6:	ff 75 0c             	pushl  0xc(%ebp)
  8014c9:	ff 75 08             	pushl  0x8(%ebp)
  8014cc:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8014d2:	50                   	push   %eax
  8014d3:	68 65 14 80 00       	push   $0x801465
  8014d8:	e8 4a 01 00 00       	call   801627 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8014dd:	83 c4 08             	add    $0x8,%esp
  8014e0:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8014e6:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8014ec:	50                   	push   %eax
  8014ed:	e8 bc ef ff ff       	call   8004ae <sys_cputs>

	return b.cnt;
}
  8014f2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8014f8:	c9                   	leave  
  8014f9:	c3                   	ret    

008014fa <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8014fa:	55                   	push   %ebp
  8014fb:	89 e5                	mov    %esp,%ebp
  8014fd:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801500:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801503:	50                   	push   %eax
  801504:	ff 75 08             	pushl  0x8(%ebp)
  801507:	e8 9d ff ff ff       	call   8014a9 <vcprintf>
	va_end(ap);

	return cnt;
}
  80150c:	c9                   	leave  
  80150d:	c3                   	ret    

0080150e <printnum>:


static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80150e:	55                   	push   %ebp
  80150f:	89 e5                	mov    %esp,%ebp
  801511:	57                   	push   %edi
  801512:	56                   	push   %esi
  801513:	53                   	push   %ebx
  801514:	83 ec 1c             	sub    $0x1c,%esp
  801517:	89 c6                	mov    %eax,%esi
  801519:	89 d7                	mov    %edx,%edi
  80151b:	8b 45 08             	mov    0x8(%ebp),%eax
  80151e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801521:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801524:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  801527:	8b 45 10             	mov    0x10(%ebp),%eax
  80152a:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	// to support '-'
	if(padc == '-'){
  80152d:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  801531:	74 2c                	je     80155f <printnum+0x51>
		while (--width > 0)
			putch(' ', putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801533:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801536:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80153d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801540:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  801543:	39 c2                	cmp    %eax,%edx
  801545:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  801548:	73 43                	jae    80158d <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80154a:	83 eb 01             	sub    $0x1,%ebx
  80154d:	85 db                	test   %ebx,%ebx
  80154f:	7e 6c                	jle    8015bd <printnum+0xaf>
			putch(padc, putdat);
  801551:	83 ec 08             	sub    $0x8,%esp
  801554:	57                   	push   %edi
  801555:	ff 75 18             	pushl  0x18(%ebp)
  801558:	ff d6                	call   *%esi
  80155a:	83 c4 10             	add    $0x10,%esp
  80155d:	eb eb                	jmp    80154a <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80155f:	83 ec 0c             	sub    $0xc,%esp
  801562:	6a 20                	push   $0x20
  801564:	6a 00                	push   $0x0
  801566:	50                   	push   %eax
  801567:	ff 75 e4             	pushl  -0x1c(%ebp)
  80156a:	ff 75 e0             	pushl  -0x20(%ebp)
  80156d:	89 fa                	mov    %edi,%edx
  80156f:	89 f0                	mov    %esi,%eax
  801571:	e8 98 ff ff ff       	call   80150e <printnum>
		while (--width > 0)
  801576:	83 c4 20             	add    $0x20,%esp
  801579:	83 eb 01             	sub    $0x1,%ebx
  80157c:	85 db                	test   %ebx,%ebx
  80157e:	7e 65                	jle    8015e5 <printnum+0xd7>
			putch(' ', putdat);
  801580:	83 ec 08             	sub    $0x8,%esp
  801583:	57                   	push   %edi
  801584:	6a 20                	push   $0x20
  801586:	ff d6                	call   *%esi
  801588:	83 c4 10             	add    $0x10,%esp
  80158b:	eb ec                	jmp    801579 <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80158d:	83 ec 0c             	sub    $0xc,%esp
  801590:	ff 75 18             	pushl  0x18(%ebp)
  801593:	83 eb 01             	sub    $0x1,%ebx
  801596:	53                   	push   %ebx
  801597:	50                   	push   %eax
  801598:	83 ec 08             	sub    $0x8,%esp
  80159b:	ff 75 dc             	pushl  -0x24(%ebp)
  80159e:	ff 75 d8             	pushl  -0x28(%ebp)
  8015a1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8015a4:	ff 75 e0             	pushl  -0x20(%ebp)
  8015a7:	e8 74 07 00 00       	call   801d20 <__udivdi3>
  8015ac:	83 c4 18             	add    $0x18,%esp
  8015af:	52                   	push   %edx
  8015b0:	50                   	push   %eax
  8015b1:	89 fa                	mov    %edi,%edx
  8015b3:	89 f0                	mov    %esi,%eax
  8015b5:	e8 54 ff ff ff       	call   80150e <printnum>
  8015ba:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8015bd:	83 ec 08             	sub    $0x8,%esp
  8015c0:	57                   	push   %edi
  8015c1:	83 ec 04             	sub    $0x4,%esp
  8015c4:	ff 75 dc             	pushl  -0x24(%ebp)
  8015c7:	ff 75 d8             	pushl  -0x28(%ebp)
  8015ca:	ff 75 e4             	pushl  -0x1c(%ebp)
  8015cd:	ff 75 e0             	pushl  -0x20(%ebp)
  8015d0:	e8 5b 08 00 00       	call   801e30 <__umoddi3>
  8015d5:	83 c4 14             	add    $0x14,%esp
  8015d8:	0f be 80 e7 20 80 00 	movsbl 0x8020e7(%eax),%eax
  8015df:	50                   	push   %eax
  8015e0:	ff d6                	call   *%esi
  8015e2:	83 c4 10             	add    $0x10,%esp
}
  8015e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015e8:	5b                   	pop    %ebx
  8015e9:	5e                   	pop    %esi
  8015ea:	5f                   	pop    %edi
  8015eb:	5d                   	pop    %ebp
  8015ec:	c3                   	ret    

008015ed <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8015ed:	55                   	push   %ebp
  8015ee:	89 e5                	mov    %esp,%ebp
  8015f0:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8015f3:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8015f7:	8b 10                	mov    (%eax),%edx
  8015f9:	3b 50 04             	cmp    0x4(%eax),%edx
  8015fc:	73 0a                	jae    801608 <sprintputch+0x1b>
		*b->buf++ = ch;
  8015fe:	8d 4a 01             	lea    0x1(%edx),%ecx
  801601:	89 08                	mov    %ecx,(%eax)
  801603:	8b 45 08             	mov    0x8(%ebp),%eax
  801606:	88 02                	mov    %al,(%edx)
}
  801608:	5d                   	pop    %ebp
  801609:	c3                   	ret    

0080160a <printfmt>:
{
  80160a:	55                   	push   %ebp
  80160b:	89 e5                	mov    %esp,%ebp
  80160d:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  801610:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801613:	50                   	push   %eax
  801614:	ff 75 10             	pushl  0x10(%ebp)
  801617:	ff 75 0c             	pushl  0xc(%ebp)
  80161a:	ff 75 08             	pushl  0x8(%ebp)
  80161d:	e8 05 00 00 00       	call   801627 <vprintfmt>
}
  801622:	83 c4 10             	add    $0x10,%esp
  801625:	c9                   	leave  
  801626:	c3                   	ret    

00801627 <vprintfmt>:
{
  801627:	55                   	push   %ebp
  801628:	89 e5                	mov    %esp,%ebp
  80162a:	57                   	push   %edi
  80162b:	56                   	push   %esi
  80162c:	53                   	push   %ebx
  80162d:	83 ec 3c             	sub    $0x3c,%esp
  801630:	8b 75 08             	mov    0x8(%ebp),%esi
  801633:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801636:	8b 7d 10             	mov    0x10(%ebp),%edi
  801639:	e9 1e 04 00 00       	jmp    801a5c <vprintfmt+0x435>
		posflag = 0;
  80163e:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
		padc = ' ';
  801645:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  801649:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  801650:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  801657:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80165e:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  801665:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80166a:	8d 47 01             	lea    0x1(%edi),%eax
  80166d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801670:	0f b6 17             	movzbl (%edi),%edx
  801673:	8d 42 dd             	lea    -0x23(%edx),%eax
  801676:	3c 55                	cmp    $0x55,%al
  801678:	0f 87 d9 04 00 00    	ja     801b57 <vprintfmt+0x530>
  80167e:	0f b6 c0             	movzbl %al,%eax
  801681:	ff 24 85 c0 22 80 00 	jmp    *0x8022c0(,%eax,4)
  801688:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80168b:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80168f:	eb d9                	jmp    80166a <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  801691:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posflag = 1;
  801694:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  80169b:	eb cd                	jmp    80166a <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80169d:	0f b6 d2             	movzbl %dl,%edx
  8016a0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8016a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8016a8:	89 75 08             	mov    %esi,0x8(%ebp)
  8016ab:	eb 0c                	jmp    8016b9 <vprintfmt+0x92>
		switch (ch = *(unsigned char *) fmt++) {
  8016ad:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8016b0:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  8016b4:	eb b4                	jmp    80166a <vprintfmt+0x43>
			for (precision = 0; ; ++fmt) {
  8016b6:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8016b9:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8016bc:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8016c0:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8016c3:	8d 72 d0             	lea    -0x30(%edx),%esi
  8016c6:	83 fe 09             	cmp    $0x9,%esi
  8016c9:	76 eb                	jbe    8016b6 <vprintfmt+0x8f>
  8016cb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8016ce:	8b 75 08             	mov    0x8(%ebp),%esi
  8016d1:	eb 14                	jmp    8016e7 <vprintfmt+0xc0>
			precision = va_arg(ap, int);
  8016d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8016d6:	8b 00                	mov    (%eax),%eax
  8016d8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8016db:	8b 45 14             	mov    0x14(%ebp),%eax
  8016de:	8d 40 04             	lea    0x4(%eax),%eax
  8016e1:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8016e4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8016e7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8016eb:	0f 89 79 ff ff ff    	jns    80166a <vprintfmt+0x43>
				width = precision, precision = -1;
  8016f1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8016f4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8016f7:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8016fe:	e9 67 ff ff ff       	jmp    80166a <vprintfmt+0x43>
  801703:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801706:	85 c0                	test   %eax,%eax
  801708:	0f 48 c1             	cmovs  %ecx,%eax
  80170b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80170e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801711:	e9 54 ff ff ff       	jmp    80166a <vprintfmt+0x43>
  801716:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  801719:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  801720:	e9 45 ff ff ff       	jmp    80166a <vprintfmt+0x43>
			lflag++;
  801725:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801729:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80172c:	e9 39 ff ff ff       	jmp    80166a <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  801731:	8b 45 14             	mov    0x14(%ebp),%eax
  801734:	8d 78 04             	lea    0x4(%eax),%edi
  801737:	83 ec 08             	sub    $0x8,%esp
  80173a:	53                   	push   %ebx
  80173b:	ff 30                	pushl  (%eax)
  80173d:	ff d6                	call   *%esi
			break;
  80173f:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  801742:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  801745:	e9 0f 03 00 00       	jmp    801a59 <vprintfmt+0x432>
			err = va_arg(ap, int);
  80174a:	8b 45 14             	mov    0x14(%ebp),%eax
  80174d:	8d 78 04             	lea    0x4(%eax),%edi
  801750:	8b 00                	mov    (%eax),%eax
  801752:	99                   	cltd   
  801753:	31 d0                	xor    %edx,%eax
  801755:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801757:	83 f8 0f             	cmp    $0xf,%eax
  80175a:	7f 23                	jg     80177f <vprintfmt+0x158>
  80175c:	8b 14 85 20 24 80 00 	mov    0x802420(,%eax,4),%edx
  801763:	85 d2                	test   %edx,%edx
  801765:	74 18                	je     80177f <vprintfmt+0x158>
				printfmt(putch, putdat, "%s", p);
  801767:	52                   	push   %edx
  801768:	68 8a 20 80 00       	push   $0x80208a
  80176d:	53                   	push   %ebx
  80176e:	56                   	push   %esi
  80176f:	e8 96 fe ff ff       	call   80160a <printfmt>
  801774:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801777:	89 7d 14             	mov    %edi,0x14(%ebp)
  80177a:	e9 da 02 00 00       	jmp    801a59 <vprintfmt+0x432>
				printfmt(putch, putdat, "error %d", err);
  80177f:	50                   	push   %eax
  801780:	68 ff 20 80 00       	push   $0x8020ff
  801785:	53                   	push   %ebx
  801786:	56                   	push   %esi
  801787:	e8 7e fe ff ff       	call   80160a <printfmt>
  80178c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80178f:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  801792:	e9 c2 02 00 00       	jmp    801a59 <vprintfmt+0x432>
			if ((p = va_arg(ap, char *)) == NULL)
  801797:	8b 45 14             	mov    0x14(%ebp),%eax
  80179a:	83 c0 04             	add    $0x4,%eax
  80179d:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8017a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8017a3:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8017a5:	85 c9                	test   %ecx,%ecx
  8017a7:	b8 f8 20 80 00       	mov    $0x8020f8,%eax
  8017ac:	0f 45 c1             	cmovne %ecx,%eax
  8017af:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8017b2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8017b6:	7e 06                	jle    8017be <vprintfmt+0x197>
  8017b8:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8017bc:	75 0d                	jne    8017cb <vprintfmt+0x1a4>
				for (width -= strnlen(p, precision); width > 0; width--)
  8017be:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8017c1:	89 c7                	mov    %eax,%edi
  8017c3:	03 45 e0             	add    -0x20(%ebp),%eax
  8017c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8017c9:	eb 53                	jmp    80181e <vprintfmt+0x1f7>
  8017cb:	83 ec 08             	sub    $0x8,%esp
  8017ce:	ff 75 d8             	pushl  -0x28(%ebp)
  8017d1:	50                   	push   %eax
  8017d2:	e8 80 e9 ff ff       	call   800157 <strnlen>
  8017d7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8017da:	29 c1                	sub    %eax,%ecx
  8017dc:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  8017df:	83 c4 10             	add    $0x10,%esp
  8017e2:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8017e4:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8017e8:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8017eb:	eb 0f                	jmp    8017fc <vprintfmt+0x1d5>
					putch(padc, putdat);
  8017ed:	83 ec 08             	sub    $0x8,%esp
  8017f0:	53                   	push   %ebx
  8017f1:	ff 75 e0             	pushl  -0x20(%ebp)
  8017f4:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8017f6:	83 ef 01             	sub    $0x1,%edi
  8017f9:	83 c4 10             	add    $0x10,%esp
  8017fc:	85 ff                	test   %edi,%edi
  8017fe:	7f ed                	jg     8017ed <vprintfmt+0x1c6>
  801800:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  801803:	85 c9                	test   %ecx,%ecx
  801805:	b8 00 00 00 00       	mov    $0x0,%eax
  80180a:	0f 49 c1             	cmovns %ecx,%eax
  80180d:	29 c1                	sub    %eax,%ecx
  80180f:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  801812:	eb aa                	jmp    8017be <vprintfmt+0x197>
					putch(ch, putdat);
  801814:	83 ec 08             	sub    $0x8,%esp
  801817:	53                   	push   %ebx
  801818:	52                   	push   %edx
  801819:	ff d6                	call   *%esi
  80181b:	83 c4 10             	add    $0x10,%esp
  80181e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801821:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801823:	83 c7 01             	add    $0x1,%edi
  801826:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80182a:	0f be d0             	movsbl %al,%edx
  80182d:	85 d2                	test   %edx,%edx
  80182f:	74 4b                	je     80187c <vprintfmt+0x255>
  801831:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801835:	78 06                	js     80183d <vprintfmt+0x216>
  801837:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80183b:	78 1e                	js     80185b <vprintfmt+0x234>
				if (altflag && (ch < ' ' || ch > '~'))
  80183d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801841:	74 d1                	je     801814 <vprintfmt+0x1ed>
  801843:	0f be c0             	movsbl %al,%eax
  801846:	83 e8 20             	sub    $0x20,%eax
  801849:	83 f8 5e             	cmp    $0x5e,%eax
  80184c:	76 c6                	jbe    801814 <vprintfmt+0x1ed>
					putch('?', putdat);
  80184e:	83 ec 08             	sub    $0x8,%esp
  801851:	53                   	push   %ebx
  801852:	6a 3f                	push   $0x3f
  801854:	ff d6                	call   *%esi
  801856:	83 c4 10             	add    $0x10,%esp
  801859:	eb c3                	jmp    80181e <vprintfmt+0x1f7>
  80185b:	89 cf                	mov    %ecx,%edi
  80185d:	eb 0e                	jmp    80186d <vprintfmt+0x246>
				putch(' ', putdat);
  80185f:	83 ec 08             	sub    $0x8,%esp
  801862:	53                   	push   %ebx
  801863:	6a 20                	push   $0x20
  801865:	ff d6                	call   *%esi
			for (; width > 0; width--)
  801867:	83 ef 01             	sub    $0x1,%edi
  80186a:	83 c4 10             	add    $0x10,%esp
  80186d:	85 ff                	test   %edi,%edi
  80186f:	7f ee                	jg     80185f <vprintfmt+0x238>
			if ((p = va_arg(ap, char *)) == NULL)
  801871:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801874:	89 45 14             	mov    %eax,0x14(%ebp)
  801877:	e9 dd 01 00 00       	jmp    801a59 <vprintfmt+0x432>
  80187c:	89 cf                	mov    %ecx,%edi
  80187e:	eb ed                	jmp    80186d <vprintfmt+0x246>
	if (lflag >= 2)
  801880:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  801884:	7f 21                	jg     8018a7 <vprintfmt+0x280>
	else if (lflag)
  801886:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80188a:	74 6a                	je     8018f6 <vprintfmt+0x2cf>
		return va_arg(*ap, long);
  80188c:	8b 45 14             	mov    0x14(%ebp),%eax
  80188f:	8b 00                	mov    (%eax),%eax
  801891:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801894:	89 c1                	mov    %eax,%ecx
  801896:	c1 f9 1f             	sar    $0x1f,%ecx
  801899:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80189c:	8b 45 14             	mov    0x14(%ebp),%eax
  80189f:	8d 40 04             	lea    0x4(%eax),%eax
  8018a2:	89 45 14             	mov    %eax,0x14(%ebp)
  8018a5:	eb 17                	jmp    8018be <vprintfmt+0x297>
		return va_arg(*ap, long long);
  8018a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8018aa:	8b 50 04             	mov    0x4(%eax),%edx
  8018ad:	8b 00                	mov    (%eax),%eax
  8018af:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8018b2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8018b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8018b8:	8d 40 08             	lea    0x8(%eax),%eax
  8018bb:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8018be:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  8018c1:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  8018c6:	85 d2                	test   %edx,%edx
  8018c8:	0f 89 5c 01 00 00    	jns    801a2a <vprintfmt+0x403>
				putch('-', putdat);
  8018ce:	83 ec 08             	sub    $0x8,%esp
  8018d1:	53                   	push   %ebx
  8018d2:	6a 2d                	push   $0x2d
  8018d4:	ff d6                	call   *%esi
				num = -(long long) num;
  8018d6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8018d9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8018dc:	f7 d8                	neg    %eax
  8018de:	83 d2 00             	adc    $0x0,%edx
  8018e1:	f7 da                	neg    %edx
  8018e3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8018e6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8018e9:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8018ec:	bf 0a 00 00 00       	mov    $0xa,%edi
  8018f1:	e9 45 01 00 00       	jmp    801a3b <vprintfmt+0x414>
		return va_arg(*ap, int);
  8018f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8018f9:	8b 00                	mov    (%eax),%eax
  8018fb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8018fe:	89 c1                	mov    %eax,%ecx
  801900:	c1 f9 1f             	sar    $0x1f,%ecx
  801903:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801906:	8b 45 14             	mov    0x14(%ebp),%eax
  801909:	8d 40 04             	lea    0x4(%eax),%eax
  80190c:	89 45 14             	mov    %eax,0x14(%ebp)
  80190f:	eb ad                	jmp    8018be <vprintfmt+0x297>
	if (lflag >= 2)
  801911:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  801915:	7f 29                	jg     801940 <vprintfmt+0x319>
	else if (lflag)
  801917:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80191b:	74 44                	je     801961 <vprintfmt+0x33a>
		return va_arg(*ap, unsigned long);
  80191d:	8b 45 14             	mov    0x14(%ebp),%eax
  801920:	8b 00                	mov    (%eax),%eax
  801922:	ba 00 00 00 00       	mov    $0x0,%edx
  801927:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80192a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80192d:	8b 45 14             	mov    0x14(%ebp),%eax
  801930:	8d 40 04             	lea    0x4(%eax),%eax
  801933:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801936:	bf 0a 00 00 00       	mov    $0xa,%edi
  80193b:	e9 ea 00 00 00       	jmp    801a2a <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  801940:	8b 45 14             	mov    0x14(%ebp),%eax
  801943:	8b 50 04             	mov    0x4(%eax),%edx
  801946:	8b 00                	mov    (%eax),%eax
  801948:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80194b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80194e:	8b 45 14             	mov    0x14(%ebp),%eax
  801951:	8d 40 08             	lea    0x8(%eax),%eax
  801954:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801957:	bf 0a 00 00 00       	mov    $0xa,%edi
  80195c:	e9 c9 00 00 00       	jmp    801a2a <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  801961:	8b 45 14             	mov    0x14(%ebp),%eax
  801964:	8b 00                	mov    (%eax),%eax
  801966:	ba 00 00 00 00       	mov    $0x0,%edx
  80196b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80196e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801971:	8b 45 14             	mov    0x14(%ebp),%eax
  801974:	8d 40 04             	lea    0x4(%eax),%eax
  801977:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80197a:	bf 0a 00 00 00       	mov    $0xa,%edi
  80197f:	e9 a6 00 00 00       	jmp    801a2a <vprintfmt+0x403>
			putch('0', putdat);
  801984:	83 ec 08             	sub    $0x8,%esp
  801987:	53                   	push   %ebx
  801988:	6a 30                	push   $0x30
  80198a:	ff d6                	call   *%esi
	if (lflag >= 2)
  80198c:	83 c4 10             	add    $0x10,%esp
  80198f:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  801993:	7f 26                	jg     8019bb <vprintfmt+0x394>
	else if (lflag)
  801995:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  801999:	74 3e                	je     8019d9 <vprintfmt+0x3b2>
		return va_arg(*ap, unsigned long);
  80199b:	8b 45 14             	mov    0x14(%ebp),%eax
  80199e:	8b 00                	mov    (%eax),%eax
  8019a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8019a5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8019a8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8019ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ae:	8d 40 04             	lea    0x4(%eax),%eax
  8019b1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8019b4:	bf 08 00 00 00       	mov    $0x8,%edi
  8019b9:	eb 6f                	jmp    801a2a <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  8019bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8019be:	8b 50 04             	mov    0x4(%eax),%edx
  8019c1:	8b 00                	mov    (%eax),%eax
  8019c3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8019c6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8019c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8019cc:	8d 40 08             	lea    0x8(%eax),%eax
  8019cf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8019d2:	bf 08 00 00 00       	mov    $0x8,%edi
  8019d7:	eb 51                	jmp    801a2a <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  8019d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8019dc:	8b 00                	mov    (%eax),%eax
  8019de:	ba 00 00 00 00       	mov    $0x0,%edx
  8019e3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8019e6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8019e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ec:	8d 40 04             	lea    0x4(%eax),%eax
  8019ef:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8019f2:	bf 08 00 00 00       	mov    $0x8,%edi
  8019f7:	eb 31                	jmp    801a2a <vprintfmt+0x403>
			putch('0', putdat);
  8019f9:	83 ec 08             	sub    $0x8,%esp
  8019fc:	53                   	push   %ebx
  8019fd:	6a 30                	push   $0x30
  8019ff:	ff d6                	call   *%esi
			putch('x', putdat);
  801a01:	83 c4 08             	add    $0x8,%esp
  801a04:	53                   	push   %ebx
  801a05:	6a 78                	push   $0x78
  801a07:	ff d6                	call   *%esi
			num = (unsigned long long)
  801a09:	8b 45 14             	mov    0x14(%ebp),%eax
  801a0c:	8b 00                	mov    (%eax),%eax
  801a0e:	ba 00 00 00 00       	mov    $0x0,%edx
  801a13:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a16:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  801a19:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801a1c:	8b 45 14             	mov    0x14(%ebp),%eax
  801a1f:	8d 40 04             	lea    0x4(%eax),%eax
  801a22:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801a25:	bf 10 00 00 00       	mov    $0x10,%edi
			if(posflag)
  801a2a:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  801a2e:	74 0b                	je     801a3b <vprintfmt+0x414>
				putch('+', putdat);
  801a30:	83 ec 08             	sub    $0x8,%esp
  801a33:	53                   	push   %ebx
  801a34:	6a 2b                	push   $0x2b
  801a36:	ff d6                	call   *%esi
  801a38:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  801a3b:	83 ec 0c             	sub    $0xc,%esp
  801a3e:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  801a42:	50                   	push   %eax
  801a43:	ff 75 e0             	pushl  -0x20(%ebp)
  801a46:	57                   	push   %edi
  801a47:	ff 75 dc             	pushl  -0x24(%ebp)
  801a4a:	ff 75 d8             	pushl  -0x28(%ebp)
  801a4d:	89 da                	mov    %ebx,%edx
  801a4f:	89 f0                	mov    %esi,%eax
  801a51:	e8 b8 fa ff ff       	call   80150e <printnum>
			break;
  801a56:	83 c4 20             	add    $0x20,%esp
			char* cp = va_arg(ap, char *);
  801a59:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801a5c:	83 c7 01             	add    $0x1,%edi
  801a5f:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801a63:	83 f8 25             	cmp    $0x25,%eax
  801a66:	0f 84 d2 fb ff ff    	je     80163e <vprintfmt+0x17>
			if (ch == '\0')
  801a6c:	85 c0                	test   %eax,%eax
  801a6e:	0f 84 03 01 00 00    	je     801b77 <vprintfmt+0x550>
			putch(ch, putdat);
  801a74:	83 ec 08             	sub    $0x8,%esp
  801a77:	53                   	push   %ebx
  801a78:	50                   	push   %eax
  801a79:	ff d6                	call   *%esi
  801a7b:	83 c4 10             	add    $0x10,%esp
  801a7e:	eb dc                	jmp    801a5c <vprintfmt+0x435>
	if (lflag >= 2)
  801a80:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  801a84:	7f 29                	jg     801aaf <vprintfmt+0x488>
	else if (lflag)
  801a86:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  801a8a:	74 44                	je     801ad0 <vprintfmt+0x4a9>
		return va_arg(*ap, unsigned long);
  801a8c:	8b 45 14             	mov    0x14(%ebp),%eax
  801a8f:	8b 00                	mov    (%eax),%eax
  801a91:	ba 00 00 00 00       	mov    $0x0,%edx
  801a96:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a99:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a9c:	8b 45 14             	mov    0x14(%ebp),%eax
  801a9f:	8d 40 04             	lea    0x4(%eax),%eax
  801aa2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801aa5:	bf 10 00 00 00       	mov    $0x10,%edi
  801aaa:	e9 7b ff ff ff       	jmp    801a2a <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  801aaf:	8b 45 14             	mov    0x14(%ebp),%eax
  801ab2:	8b 50 04             	mov    0x4(%eax),%edx
  801ab5:	8b 00                	mov    (%eax),%eax
  801ab7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801aba:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801abd:	8b 45 14             	mov    0x14(%ebp),%eax
  801ac0:	8d 40 08             	lea    0x8(%eax),%eax
  801ac3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801ac6:	bf 10 00 00 00       	mov    $0x10,%edi
  801acb:	e9 5a ff ff ff       	jmp    801a2a <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  801ad0:	8b 45 14             	mov    0x14(%ebp),%eax
  801ad3:	8b 00                	mov    (%eax),%eax
  801ad5:	ba 00 00 00 00       	mov    $0x0,%edx
  801ada:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801add:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801ae0:	8b 45 14             	mov    0x14(%ebp),%eax
  801ae3:	8d 40 04             	lea    0x4(%eax),%eax
  801ae6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801ae9:	bf 10 00 00 00       	mov    $0x10,%edi
  801aee:	e9 37 ff ff ff       	jmp    801a2a <vprintfmt+0x403>
			char* cp = va_arg(ap, char *);
  801af3:	8b 45 14             	mov    0x14(%ebp),%eax
  801af6:	8d 78 04             	lea    0x4(%eax),%edi
  801af9:	8b 00                	mov    (%eax),%eax
    			if (cp == NULL) {
  801afb:	85 c0                	test   %eax,%eax
  801afd:	74 2c                	je     801b2b <vprintfmt+0x504>
    			*cp = *(int *)putdat;
  801aff:	8b 13                	mov    (%ebx),%edx
  801b01:	88 10                	mov    %dl,(%eax)
			char* cp = va_arg(ap, char *);
  801b03:	89 7d 14             	mov    %edi,0x14(%ebp)
    			if ((*(int *) putdat) > 127)
  801b06:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  801b09:	0f 8e 4a ff ff ff    	jle    801a59 <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", overflow_error);
  801b0f:	68 54 22 80 00       	push   $0x802254
  801b14:	68 8a 20 80 00       	push   $0x80208a
  801b19:	53                   	push   %ebx
  801b1a:	56                   	push   %esi
  801b1b:	e8 ea fa ff ff       	call   80160a <printfmt>
  801b20:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  801b23:	89 7d 14             	mov    %edi,0x14(%ebp)
  801b26:	e9 2e ff ff ff       	jmp    801a59 <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", null_error);
  801b2b:	68 1c 22 80 00       	push   $0x80221c
  801b30:	68 8a 20 80 00       	push   $0x80208a
  801b35:	53                   	push   %ebx
  801b36:	56                   	push   %esi
  801b37:	e8 ce fa ff ff       	call   80160a <printfmt>
        		break;
  801b3c:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  801b3f:	89 7d 14             	mov    %edi,0x14(%ebp)
        		break;
  801b42:	e9 12 ff ff ff       	jmp    801a59 <vprintfmt+0x432>
			putch(ch, putdat);
  801b47:	83 ec 08             	sub    $0x8,%esp
  801b4a:	53                   	push   %ebx
  801b4b:	6a 25                	push   $0x25
  801b4d:	ff d6                	call   *%esi
			break;
  801b4f:	83 c4 10             	add    $0x10,%esp
  801b52:	e9 02 ff ff ff       	jmp    801a59 <vprintfmt+0x432>
			putch('%', putdat);
  801b57:	83 ec 08             	sub    $0x8,%esp
  801b5a:	53                   	push   %ebx
  801b5b:	6a 25                	push   $0x25
  801b5d:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801b5f:	83 c4 10             	add    $0x10,%esp
  801b62:	89 f8                	mov    %edi,%eax
  801b64:	eb 03                	jmp    801b69 <vprintfmt+0x542>
  801b66:	83 e8 01             	sub    $0x1,%eax
  801b69:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801b6d:	75 f7                	jne    801b66 <vprintfmt+0x53f>
  801b6f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b72:	e9 e2 fe ff ff       	jmp    801a59 <vprintfmt+0x432>
}
  801b77:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b7a:	5b                   	pop    %ebx
  801b7b:	5e                   	pop    %esi
  801b7c:	5f                   	pop    %edi
  801b7d:	5d                   	pop    %ebp
  801b7e:	c3                   	ret    

00801b7f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801b7f:	55                   	push   %ebp
  801b80:	89 e5                	mov    %esp,%ebp
  801b82:	83 ec 18             	sub    $0x18,%esp
  801b85:	8b 45 08             	mov    0x8(%ebp),%eax
  801b88:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801b8b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801b8e:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801b92:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801b95:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801b9c:	85 c0                	test   %eax,%eax
  801b9e:	74 26                	je     801bc6 <vsnprintf+0x47>
  801ba0:	85 d2                	test   %edx,%edx
  801ba2:	7e 22                	jle    801bc6 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801ba4:	ff 75 14             	pushl  0x14(%ebp)
  801ba7:	ff 75 10             	pushl  0x10(%ebp)
  801baa:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801bad:	50                   	push   %eax
  801bae:	68 ed 15 80 00       	push   $0x8015ed
  801bb3:	e8 6f fa ff ff       	call   801627 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801bb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bbb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801bbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bc1:	83 c4 10             	add    $0x10,%esp
}
  801bc4:	c9                   	leave  
  801bc5:	c3                   	ret    
		return -E_INVAL;
  801bc6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801bcb:	eb f7                	jmp    801bc4 <vsnprintf+0x45>

00801bcd <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801bcd:	55                   	push   %ebp
  801bce:	89 e5                	mov    %esp,%ebp
  801bd0:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801bd3:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801bd6:	50                   	push   %eax
  801bd7:	ff 75 10             	pushl  0x10(%ebp)
  801bda:	ff 75 0c             	pushl  0xc(%ebp)
  801bdd:	ff 75 08             	pushl  0x8(%ebp)
  801be0:	e8 9a ff ff ff       	call   801b7f <vsnprintf>
	va_end(ap);

	return rc;
}
  801be5:	c9                   	leave  
  801be6:	c3                   	ret    

00801be7 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801be7:	55                   	push   %ebp
  801be8:	89 e5                	mov    %esp,%ebp
  801bea:	56                   	push   %esi
  801beb:	53                   	push   %ebx
  801bec:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801bef:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bf2:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// return 0;
	if(!pg)
  801bf5:	85 c0                	test   %eax,%eax
		pg = (void*)UTOP;
  801bf7:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801bfc:	0f 44 c2             	cmove  %edx,%eax
	
	int ret;

	ret = sys_ipc_recv(pg);
  801bff:	83 ec 0c             	sub    $0xc,%esp
  801c02:	50                   	push   %eax
  801c03:	e8 12 eb ff ff       	call   80071a <sys_ipc_recv>
	if(ret < 0){
  801c08:	83 c4 10             	add    $0x10,%esp
  801c0b:	85 c0                	test   %eax,%eax
  801c0d:	78 2b                	js     801c3a <ipc_recv+0x53>
		if(perm_store) *perm_store = 0;
		if(from_env_store) *from_env_store = 0;
		return ret;
	}
	
	if(perm_store)
  801c0f:	85 f6                	test   %esi,%esi
  801c11:	74 0a                	je     801c1d <ipc_recv+0x36>
		*perm_store = thisenv->env_ipc_perm;
  801c13:	a1 04 40 80 00       	mov    0x804004,%eax
  801c18:	8b 40 78             	mov    0x78(%eax),%eax
  801c1b:	89 06                	mov    %eax,(%esi)
	if(from_env_store)
  801c1d:	85 db                	test   %ebx,%ebx
  801c1f:	74 0a                	je     801c2b <ipc_recv+0x44>
		*from_env_store = thisenv->env_ipc_from;
  801c21:	a1 04 40 80 00       	mov    0x804004,%eax
  801c26:	8b 40 74             	mov    0x74(%eax),%eax
  801c29:	89 03                	mov    %eax,(%ebx)

	return thisenv->env_ipc_value;
  801c2b:	a1 04 40 80 00       	mov    0x804004,%eax
  801c30:	8b 40 70             	mov    0x70(%eax),%eax
}
  801c33:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c36:	5b                   	pop    %ebx
  801c37:	5e                   	pop    %esi
  801c38:	5d                   	pop    %ebp
  801c39:	c3                   	ret    
		if(perm_store) *perm_store = 0;
  801c3a:	85 f6                	test   %esi,%esi
  801c3c:	74 06                	je     801c44 <ipc_recv+0x5d>
  801c3e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(from_env_store) *from_env_store = 0;
  801c44:	85 db                	test   %ebx,%ebx
  801c46:	74 eb                	je     801c33 <ipc_recv+0x4c>
  801c48:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801c4e:	eb e3                	jmp    801c33 <ipc_recv+0x4c>

00801c50 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801c50:	55                   	push   %ebp
  801c51:	89 e5                	mov    %esp,%ebp
  801c53:	57                   	push   %edi
  801c54:	56                   	push   %esi
  801c55:	53                   	push   %ebx
  801c56:	83 ec 0c             	sub    $0xc,%esp
  801c59:	8b 7d 08             	mov    0x8(%ebp),%edi
  801c5c:	8b 75 0c             	mov    0xc(%ebp),%esi
  801c5f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
	if (!pg)
  801c62:	85 db                	test   %ebx,%ebx
		pg = (void*)UTOP;
  801c64:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801c69:	0f 44 d8             	cmove  %eax,%ebx

	int ret = -E_IPC_NOT_RECV;
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))) {
  801c6c:	ff 75 14             	pushl  0x14(%ebp)
  801c6f:	53                   	push   %ebx
  801c70:	56                   	push   %esi
  801c71:	57                   	push   %edi
  801c72:	e8 80 ea ff ff       	call   8006f7 <sys_ipc_try_send>
  801c77:	83 c4 10             	add    $0x10,%esp
  801c7a:	85 c0                	test   %eax,%eax
  801c7c:	74 17                	je     801c95 <ipc_send+0x45>
		if(ret != -E_IPC_NOT_RECV){
  801c7e:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801c81:	74 e9                	je     801c6c <ipc_send+0x1c>
			panic("ipc_send: ret : %d", ret);
  801c83:	50                   	push   %eax
  801c84:	68 60 24 80 00       	push   $0x802460
  801c89:	6a 43                	push   $0x43
  801c8b:	68 73 24 80 00       	push   $0x802473
  801c90:	e8 8a f7 ff ff       	call   80141f <_panic>
			sys_yield();
		}
	}
}
  801c95:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c98:	5b                   	pop    %ebx
  801c99:	5e                   	pop    %esi
  801c9a:	5f                   	pop    %edi
  801c9b:	5d                   	pop    %ebp
  801c9c:	c3                   	ret    

00801c9d <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801c9d:	55                   	push   %ebp
  801c9e:	89 e5                	mov    %esp,%ebp
  801ca0:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801ca3:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801ca8:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  801cae:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801cb4:	8b 52 50             	mov    0x50(%edx),%edx
  801cb7:	39 ca                	cmp    %ecx,%edx
  801cb9:	74 11                	je     801ccc <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  801cbb:	83 c0 01             	add    $0x1,%eax
  801cbe:	3d 00 04 00 00       	cmp    $0x400,%eax
  801cc3:	75 e3                	jne    801ca8 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801cc5:	b8 00 00 00 00       	mov    $0x0,%eax
  801cca:	eb 0e                	jmp    801cda <ipc_find_env+0x3d>
			return envs[i].env_id;
  801ccc:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  801cd2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801cd7:	8b 40 48             	mov    0x48(%eax),%eax
}
  801cda:	5d                   	pop    %ebp
  801cdb:	c3                   	ret    

00801cdc <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801cdc:	55                   	push   %ebp
  801cdd:	89 e5                	mov    %esp,%ebp
  801cdf:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801ce2:	89 d0                	mov    %edx,%eax
  801ce4:	c1 e8 16             	shr    $0x16,%eax
  801ce7:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801cee:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801cf3:	f6 c1 01             	test   $0x1,%cl
  801cf6:	74 1d                	je     801d15 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801cf8:	c1 ea 0c             	shr    $0xc,%edx
  801cfb:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801d02:	f6 c2 01             	test   $0x1,%dl
  801d05:	74 0e                	je     801d15 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801d07:	c1 ea 0c             	shr    $0xc,%edx
  801d0a:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801d11:	ef 
  801d12:	0f b7 c0             	movzwl %ax,%eax
}
  801d15:	5d                   	pop    %ebp
  801d16:	c3                   	ret    
  801d17:	66 90                	xchg   %ax,%ax
  801d19:	66 90                	xchg   %ax,%ax
  801d1b:	66 90                	xchg   %ax,%ax
  801d1d:	66 90                	xchg   %ax,%ax
  801d1f:	90                   	nop

00801d20 <__udivdi3>:
  801d20:	55                   	push   %ebp
  801d21:	57                   	push   %edi
  801d22:	56                   	push   %esi
  801d23:	53                   	push   %ebx
  801d24:	83 ec 1c             	sub    $0x1c,%esp
  801d27:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801d2b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801d2f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801d33:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801d37:	85 d2                	test   %edx,%edx
  801d39:	75 4d                	jne    801d88 <__udivdi3+0x68>
  801d3b:	39 f3                	cmp    %esi,%ebx
  801d3d:	76 19                	jbe    801d58 <__udivdi3+0x38>
  801d3f:	31 ff                	xor    %edi,%edi
  801d41:	89 e8                	mov    %ebp,%eax
  801d43:	89 f2                	mov    %esi,%edx
  801d45:	f7 f3                	div    %ebx
  801d47:	89 fa                	mov    %edi,%edx
  801d49:	83 c4 1c             	add    $0x1c,%esp
  801d4c:	5b                   	pop    %ebx
  801d4d:	5e                   	pop    %esi
  801d4e:	5f                   	pop    %edi
  801d4f:	5d                   	pop    %ebp
  801d50:	c3                   	ret    
  801d51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801d58:	89 d9                	mov    %ebx,%ecx
  801d5a:	85 db                	test   %ebx,%ebx
  801d5c:	75 0b                	jne    801d69 <__udivdi3+0x49>
  801d5e:	b8 01 00 00 00       	mov    $0x1,%eax
  801d63:	31 d2                	xor    %edx,%edx
  801d65:	f7 f3                	div    %ebx
  801d67:	89 c1                	mov    %eax,%ecx
  801d69:	31 d2                	xor    %edx,%edx
  801d6b:	89 f0                	mov    %esi,%eax
  801d6d:	f7 f1                	div    %ecx
  801d6f:	89 c6                	mov    %eax,%esi
  801d71:	89 e8                	mov    %ebp,%eax
  801d73:	89 f7                	mov    %esi,%edi
  801d75:	f7 f1                	div    %ecx
  801d77:	89 fa                	mov    %edi,%edx
  801d79:	83 c4 1c             	add    $0x1c,%esp
  801d7c:	5b                   	pop    %ebx
  801d7d:	5e                   	pop    %esi
  801d7e:	5f                   	pop    %edi
  801d7f:	5d                   	pop    %ebp
  801d80:	c3                   	ret    
  801d81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801d88:	39 f2                	cmp    %esi,%edx
  801d8a:	77 1c                	ja     801da8 <__udivdi3+0x88>
  801d8c:	0f bd fa             	bsr    %edx,%edi
  801d8f:	83 f7 1f             	xor    $0x1f,%edi
  801d92:	75 2c                	jne    801dc0 <__udivdi3+0xa0>
  801d94:	39 f2                	cmp    %esi,%edx
  801d96:	72 06                	jb     801d9e <__udivdi3+0x7e>
  801d98:	31 c0                	xor    %eax,%eax
  801d9a:	39 eb                	cmp    %ebp,%ebx
  801d9c:	77 a9                	ja     801d47 <__udivdi3+0x27>
  801d9e:	b8 01 00 00 00       	mov    $0x1,%eax
  801da3:	eb a2                	jmp    801d47 <__udivdi3+0x27>
  801da5:	8d 76 00             	lea    0x0(%esi),%esi
  801da8:	31 ff                	xor    %edi,%edi
  801daa:	31 c0                	xor    %eax,%eax
  801dac:	89 fa                	mov    %edi,%edx
  801dae:	83 c4 1c             	add    $0x1c,%esp
  801db1:	5b                   	pop    %ebx
  801db2:	5e                   	pop    %esi
  801db3:	5f                   	pop    %edi
  801db4:	5d                   	pop    %ebp
  801db5:	c3                   	ret    
  801db6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801dbd:	8d 76 00             	lea    0x0(%esi),%esi
  801dc0:	89 f9                	mov    %edi,%ecx
  801dc2:	b8 20 00 00 00       	mov    $0x20,%eax
  801dc7:	29 f8                	sub    %edi,%eax
  801dc9:	d3 e2                	shl    %cl,%edx
  801dcb:	89 54 24 08          	mov    %edx,0x8(%esp)
  801dcf:	89 c1                	mov    %eax,%ecx
  801dd1:	89 da                	mov    %ebx,%edx
  801dd3:	d3 ea                	shr    %cl,%edx
  801dd5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801dd9:	09 d1                	or     %edx,%ecx
  801ddb:	89 f2                	mov    %esi,%edx
  801ddd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801de1:	89 f9                	mov    %edi,%ecx
  801de3:	d3 e3                	shl    %cl,%ebx
  801de5:	89 c1                	mov    %eax,%ecx
  801de7:	d3 ea                	shr    %cl,%edx
  801de9:	89 f9                	mov    %edi,%ecx
  801deb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801def:	89 eb                	mov    %ebp,%ebx
  801df1:	d3 e6                	shl    %cl,%esi
  801df3:	89 c1                	mov    %eax,%ecx
  801df5:	d3 eb                	shr    %cl,%ebx
  801df7:	09 de                	or     %ebx,%esi
  801df9:	89 f0                	mov    %esi,%eax
  801dfb:	f7 74 24 08          	divl   0x8(%esp)
  801dff:	89 d6                	mov    %edx,%esi
  801e01:	89 c3                	mov    %eax,%ebx
  801e03:	f7 64 24 0c          	mull   0xc(%esp)
  801e07:	39 d6                	cmp    %edx,%esi
  801e09:	72 15                	jb     801e20 <__udivdi3+0x100>
  801e0b:	89 f9                	mov    %edi,%ecx
  801e0d:	d3 e5                	shl    %cl,%ebp
  801e0f:	39 c5                	cmp    %eax,%ebp
  801e11:	73 04                	jae    801e17 <__udivdi3+0xf7>
  801e13:	39 d6                	cmp    %edx,%esi
  801e15:	74 09                	je     801e20 <__udivdi3+0x100>
  801e17:	89 d8                	mov    %ebx,%eax
  801e19:	31 ff                	xor    %edi,%edi
  801e1b:	e9 27 ff ff ff       	jmp    801d47 <__udivdi3+0x27>
  801e20:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801e23:	31 ff                	xor    %edi,%edi
  801e25:	e9 1d ff ff ff       	jmp    801d47 <__udivdi3+0x27>
  801e2a:	66 90                	xchg   %ax,%ax
  801e2c:	66 90                	xchg   %ax,%ax
  801e2e:	66 90                	xchg   %ax,%ax

00801e30 <__umoddi3>:
  801e30:	55                   	push   %ebp
  801e31:	57                   	push   %edi
  801e32:	56                   	push   %esi
  801e33:	53                   	push   %ebx
  801e34:	83 ec 1c             	sub    $0x1c,%esp
  801e37:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801e3b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801e3f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801e43:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801e47:	89 da                	mov    %ebx,%edx
  801e49:	85 c0                	test   %eax,%eax
  801e4b:	75 43                	jne    801e90 <__umoddi3+0x60>
  801e4d:	39 df                	cmp    %ebx,%edi
  801e4f:	76 17                	jbe    801e68 <__umoddi3+0x38>
  801e51:	89 f0                	mov    %esi,%eax
  801e53:	f7 f7                	div    %edi
  801e55:	89 d0                	mov    %edx,%eax
  801e57:	31 d2                	xor    %edx,%edx
  801e59:	83 c4 1c             	add    $0x1c,%esp
  801e5c:	5b                   	pop    %ebx
  801e5d:	5e                   	pop    %esi
  801e5e:	5f                   	pop    %edi
  801e5f:	5d                   	pop    %ebp
  801e60:	c3                   	ret    
  801e61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801e68:	89 fd                	mov    %edi,%ebp
  801e6a:	85 ff                	test   %edi,%edi
  801e6c:	75 0b                	jne    801e79 <__umoddi3+0x49>
  801e6e:	b8 01 00 00 00       	mov    $0x1,%eax
  801e73:	31 d2                	xor    %edx,%edx
  801e75:	f7 f7                	div    %edi
  801e77:	89 c5                	mov    %eax,%ebp
  801e79:	89 d8                	mov    %ebx,%eax
  801e7b:	31 d2                	xor    %edx,%edx
  801e7d:	f7 f5                	div    %ebp
  801e7f:	89 f0                	mov    %esi,%eax
  801e81:	f7 f5                	div    %ebp
  801e83:	89 d0                	mov    %edx,%eax
  801e85:	eb d0                	jmp    801e57 <__umoddi3+0x27>
  801e87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801e8e:	66 90                	xchg   %ax,%ax
  801e90:	89 f1                	mov    %esi,%ecx
  801e92:	39 d8                	cmp    %ebx,%eax
  801e94:	76 0a                	jbe    801ea0 <__umoddi3+0x70>
  801e96:	89 f0                	mov    %esi,%eax
  801e98:	83 c4 1c             	add    $0x1c,%esp
  801e9b:	5b                   	pop    %ebx
  801e9c:	5e                   	pop    %esi
  801e9d:	5f                   	pop    %edi
  801e9e:	5d                   	pop    %ebp
  801e9f:	c3                   	ret    
  801ea0:	0f bd e8             	bsr    %eax,%ebp
  801ea3:	83 f5 1f             	xor    $0x1f,%ebp
  801ea6:	75 20                	jne    801ec8 <__umoddi3+0x98>
  801ea8:	39 d8                	cmp    %ebx,%eax
  801eaa:	0f 82 b0 00 00 00    	jb     801f60 <__umoddi3+0x130>
  801eb0:	39 f7                	cmp    %esi,%edi
  801eb2:	0f 86 a8 00 00 00    	jbe    801f60 <__umoddi3+0x130>
  801eb8:	89 c8                	mov    %ecx,%eax
  801eba:	83 c4 1c             	add    $0x1c,%esp
  801ebd:	5b                   	pop    %ebx
  801ebe:	5e                   	pop    %esi
  801ebf:	5f                   	pop    %edi
  801ec0:	5d                   	pop    %ebp
  801ec1:	c3                   	ret    
  801ec2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801ec8:	89 e9                	mov    %ebp,%ecx
  801eca:	ba 20 00 00 00       	mov    $0x20,%edx
  801ecf:	29 ea                	sub    %ebp,%edx
  801ed1:	d3 e0                	shl    %cl,%eax
  801ed3:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ed7:	89 d1                	mov    %edx,%ecx
  801ed9:	89 f8                	mov    %edi,%eax
  801edb:	d3 e8                	shr    %cl,%eax
  801edd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801ee1:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ee5:	8b 54 24 04          	mov    0x4(%esp),%edx
  801ee9:	09 c1                	or     %eax,%ecx
  801eeb:	89 d8                	mov    %ebx,%eax
  801eed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801ef1:	89 e9                	mov    %ebp,%ecx
  801ef3:	d3 e7                	shl    %cl,%edi
  801ef5:	89 d1                	mov    %edx,%ecx
  801ef7:	d3 e8                	shr    %cl,%eax
  801ef9:	89 e9                	mov    %ebp,%ecx
  801efb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801eff:	d3 e3                	shl    %cl,%ebx
  801f01:	89 c7                	mov    %eax,%edi
  801f03:	89 d1                	mov    %edx,%ecx
  801f05:	89 f0                	mov    %esi,%eax
  801f07:	d3 e8                	shr    %cl,%eax
  801f09:	89 e9                	mov    %ebp,%ecx
  801f0b:	89 fa                	mov    %edi,%edx
  801f0d:	d3 e6                	shl    %cl,%esi
  801f0f:	09 d8                	or     %ebx,%eax
  801f11:	f7 74 24 08          	divl   0x8(%esp)
  801f15:	89 d1                	mov    %edx,%ecx
  801f17:	89 f3                	mov    %esi,%ebx
  801f19:	f7 64 24 0c          	mull   0xc(%esp)
  801f1d:	89 c6                	mov    %eax,%esi
  801f1f:	89 d7                	mov    %edx,%edi
  801f21:	39 d1                	cmp    %edx,%ecx
  801f23:	72 06                	jb     801f2b <__umoddi3+0xfb>
  801f25:	75 10                	jne    801f37 <__umoddi3+0x107>
  801f27:	39 c3                	cmp    %eax,%ebx
  801f29:	73 0c                	jae    801f37 <__umoddi3+0x107>
  801f2b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  801f2f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801f33:	89 d7                	mov    %edx,%edi
  801f35:	89 c6                	mov    %eax,%esi
  801f37:	89 ca                	mov    %ecx,%edx
  801f39:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801f3e:	29 f3                	sub    %esi,%ebx
  801f40:	19 fa                	sbb    %edi,%edx
  801f42:	89 d0                	mov    %edx,%eax
  801f44:	d3 e0                	shl    %cl,%eax
  801f46:	89 e9                	mov    %ebp,%ecx
  801f48:	d3 eb                	shr    %cl,%ebx
  801f4a:	d3 ea                	shr    %cl,%edx
  801f4c:	09 d8                	or     %ebx,%eax
  801f4e:	83 c4 1c             	add    $0x1c,%esp
  801f51:	5b                   	pop    %ebx
  801f52:	5e                   	pop    %esi
  801f53:	5f                   	pop    %edi
  801f54:	5d                   	pop    %ebp
  801f55:	c3                   	ret    
  801f56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801f5d:	8d 76 00             	lea    0x0(%esi),%esi
  801f60:	89 da                	mov    %ebx,%edx
  801f62:	29 fe                	sub    %edi,%esi
  801f64:	19 c2                	sbb    %eax,%edx
  801f66:	89 f1                	mov    %esi,%ecx
  801f68:	89 c8                	mov    %ecx,%eax
  801f6a:	e9 4b ff ff ff       	jmp    801eba <__umoddi3+0x8a>
