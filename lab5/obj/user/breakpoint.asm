
obj/user/breakpoint.debug:     file format elf32-i386


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
  80002c:	e8 04 00 00 00       	call   800035 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
	asm volatile("int $3");
  800033:	cc                   	int3   
}
  800034:	c3                   	ret    

00800035 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800035:	55                   	push   %ebp
  800036:	89 e5                	mov    %esp,%ebp
  800038:	56                   	push   %esi
  800039:	53                   	push   %ebx
  80003a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80003d:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	// thisenv = 0;
	thisenv = &(envs[ENVX(sys_getenvid())]);
  800040:	e8 c9 00 00 00       	call   80010e <sys_getenvid>
  800045:	25 ff 03 00 00       	and    $0x3ff,%eax
  80004a:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  800050:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800055:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80005a:	85 db                	test   %ebx,%ebx
  80005c:	7e 07                	jle    800065 <libmain+0x30>
		binaryname = argv[0];
  80005e:	8b 06                	mov    (%esi),%eax
  800060:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800065:	83 ec 08             	sub    $0x8,%esp
  800068:	56                   	push   %esi
  800069:	53                   	push   %ebx
  80006a:	e8 c4 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80006f:	e8 0a 00 00 00       	call   80007e <exit>
}
  800074:	83 c4 10             	add    $0x10,%esp
  800077:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80007a:	5b                   	pop    %ebx
  80007b:	5e                   	pop    %esi
  80007c:	5d                   	pop    %ebp
  80007d:	c3                   	ret    

0080007e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80007e:	55                   	push   %ebp
  80007f:	89 e5                	mov    %esp,%ebp
  800081:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  800084:	6a 00                	push   $0x0
  800086:	e8 42 00 00 00       	call   8000cd <sys_env_destroy>
}
  80008b:	83 c4 10             	add    $0x10,%esp
  80008e:	c9                   	leave  
  80008f:	c3                   	ret    

00800090 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800090:	55                   	push   %ebp
  800091:	89 e5                	mov    %esp,%ebp
  800093:	57                   	push   %edi
  800094:	56                   	push   %esi
  800095:	53                   	push   %ebx
	asm volatile("int %1\n"
  800096:	b8 00 00 00 00       	mov    $0x0,%eax
  80009b:	8b 55 08             	mov    0x8(%ebp),%edx
  80009e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000a1:	89 c3                	mov    %eax,%ebx
  8000a3:	89 c7                	mov    %eax,%edi
  8000a5:	89 c6                	mov    %eax,%esi
  8000a7:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000a9:	5b                   	pop    %ebx
  8000aa:	5e                   	pop    %esi
  8000ab:	5f                   	pop    %edi
  8000ac:	5d                   	pop    %ebp
  8000ad:	c3                   	ret    

008000ae <sys_cgetc>:

int
sys_cgetc(void)
{
  8000ae:	55                   	push   %ebp
  8000af:	89 e5                	mov    %esp,%ebp
  8000b1:	57                   	push   %edi
  8000b2:	56                   	push   %esi
  8000b3:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8000b9:	b8 01 00 00 00       	mov    $0x1,%eax
  8000be:	89 d1                	mov    %edx,%ecx
  8000c0:	89 d3                	mov    %edx,%ebx
  8000c2:	89 d7                	mov    %edx,%edi
  8000c4:	89 d6                	mov    %edx,%esi
  8000c6:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000c8:	5b                   	pop    %ebx
  8000c9:	5e                   	pop    %esi
  8000ca:	5f                   	pop    %edi
  8000cb:	5d                   	pop    %ebp
  8000cc:	c3                   	ret    

008000cd <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000cd:	55                   	push   %ebp
  8000ce:	89 e5                	mov    %esp,%ebp
  8000d0:	57                   	push   %edi
  8000d1:	56                   	push   %esi
  8000d2:	53                   	push   %ebx
  8000d3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000d6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000db:	8b 55 08             	mov    0x8(%ebp),%edx
  8000de:	b8 03 00 00 00       	mov    $0x3,%eax
  8000e3:	89 cb                	mov    %ecx,%ebx
  8000e5:	89 cf                	mov    %ecx,%edi
  8000e7:	89 ce                	mov    %ecx,%esi
  8000e9:	cd 30                	int    $0x30
	if (check && ret > 0)
  8000eb:	85 c0                	test   %eax,%eax
  8000ed:	7f 08                	jg     8000f7 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8000ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000f2:	5b                   	pop    %ebx
  8000f3:	5e                   	pop    %esi
  8000f4:	5f                   	pop    %edi
  8000f5:	5d                   	pop    %ebp
  8000f6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8000f7:	83 ec 0c             	sub    $0xc,%esp
  8000fa:	50                   	push   %eax
  8000fb:	6a 03                	push   $0x3
  8000fd:	68 2a 11 80 00       	push   $0x80112a
  800102:	6a 4c                	push   $0x4c
  800104:	68 47 11 80 00       	push   $0x801147
  800109:	e8 70 02 00 00       	call   80037e <_panic>

0080010e <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80010e:	55                   	push   %ebp
  80010f:	89 e5                	mov    %esp,%ebp
  800111:	57                   	push   %edi
  800112:	56                   	push   %esi
  800113:	53                   	push   %ebx
	asm volatile("int %1\n"
  800114:	ba 00 00 00 00       	mov    $0x0,%edx
  800119:	b8 02 00 00 00       	mov    $0x2,%eax
  80011e:	89 d1                	mov    %edx,%ecx
  800120:	89 d3                	mov    %edx,%ebx
  800122:	89 d7                	mov    %edx,%edi
  800124:	89 d6                	mov    %edx,%esi
  800126:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800128:	5b                   	pop    %ebx
  800129:	5e                   	pop    %esi
  80012a:	5f                   	pop    %edi
  80012b:	5d                   	pop    %ebp
  80012c:	c3                   	ret    

0080012d <sys_yield>:

void
sys_yield(void)
{
  80012d:	55                   	push   %ebp
  80012e:	89 e5                	mov    %esp,%ebp
  800130:	57                   	push   %edi
  800131:	56                   	push   %esi
  800132:	53                   	push   %ebx
	asm volatile("int %1\n"
  800133:	ba 00 00 00 00       	mov    $0x0,%edx
  800138:	b8 0b 00 00 00       	mov    $0xb,%eax
  80013d:	89 d1                	mov    %edx,%ecx
  80013f:	89 d3                	mov    %edx,%ebx
  800141:	89 d7                	mov    %edx,%edi
  800143:	89 d6                	mov    %edx,%esi
  800145:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800147:	5b                   	pop    %ebx
  800148:	5e                   	pop    %esi
  800149:	5f                   	pop    %edi
  80014a:	5d                   	pop    %ebp
  80014b:	c3                   	ret    

0080014c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80014c:	55                   	push   %ebp
  80014d:	89 e5                	mov    %esp,%ebp
  80014f:	57                   	push   %edi
  800150:	56                   	push   %esi
  800151:	53                   	push   %ebx
  800152:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800155:	be 00 00 00 00       	mov    $0x0,%esi
  80015a:	8b 55 08             	mov    0x8(%ebp),%edx
  80015d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800160:	b8 04 00 00 00       	mov    $0x4,%eax
  800165:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800168:	89 f7                	mov    %esi,%edi
  80016a:	cd 30                	int    $0x30
	if (check && ret > 0)
  80016c:	85 c0                	test   %eax,%eax
  80016e:	7f 08                	jg     800178 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800170:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800173:	5b                   	pop    %ebx
  800174:	5e                   	pop    %esi
  800175:	5f                   	pop    %edi
  800176:	5d                   	pop    %ebp
  800177:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800178:	83 ec 0c             	sub    $0xc,%esp
  80017b:	50                   	push   %eax
  80017c:	6a 04                	push   $0x4
  80017e:	68 2a 11 80 00       	push   $0x80112a
  800183:	6a 4c                	push   $0x4c
  800185:	68 47 11 80 00       	push   $0x801147
  80018a:	e8 ef 01 00 00       	call   80037e <_panic>

0080018f <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80018f:	55                   	push   %ebp
  800190:	89 e5                	mov    %esp,%ebp
  800192:	57                   	push   %edi
  800193:	56                   	push   %esi
  800194:	53                   	push   %ebx
  800195:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800198:	8b 55 08             	mov    0x8(%ebp),%edx
  80019b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80019e:	b8 05 00 00 00       	mov    $0x5,%eax
  8001a3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001a6:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001a9:	8b 75 18             	mov    0x18(%ebp),%esi
  8001ac:	cd 30                	int    $0x30
	if (check && ret > 0)
  8001ae:	85 c0                	test   %eax,%eax
  8001b0:	7f 08                	jg     8001ba <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001b5:	5b                   	pop    %ebx
  8001b6:	5e                   	pop    %esi
  8001b7:	5f                   	pop    %edi
  8001b8:	5d                   	pop    %ebp
  8001b9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001ba:	83 ec 0c             	sub    $0xc,%esp
  8001bd:	50                   	push   %eax
  8001be:	6a 05                	push   $0x5
  8001c0:	68 2a 11 80 00       	push   $0x80112a
  8001c5:	6a 4c                	push   $0x4c
  8001c7:	68 47 11 80 00       	push   $0x801147
  8001cc:	e8 ad 01 00 00       	call   80037e <_panic>

008001d1 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001d1:	55                   	push   %ebp
  8001d2:	89 e5                	mov    %esp,%ebp
  8001d4:	57                   	push   %edi
  8001d5:	56                   	push   %esi
  8001d6:	53                   	push   %ebx
  8001d7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001da:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001df:	8b 55 08             	mov    0x8(%ebp),%edx
  8001e2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001e5:	b8 06 00 00 00       	mov    $0x6,%eax
  8001ea:	89 df                	mov    %ebx,%edi
  8001ec:	89 de                	mov    %ebx,%esi
  8001ee:	cd 30                	int    $0x30
	if (check && ret > 0)
  8001f0:	85 c0                	test   %eax,%eax
  8001f2:	7f 08                	jg     8001fc <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8001f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001f7:	5b                   	pop    %ebx
  8001f8:	5e                   	pop    %esi
  8001f9:	5f                   	pop    %edi
  8001fa:	5d                   	pop    %ebp
  8001fb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001fc:	83 ec 0c             	sub    $0xc,%esp
  8001ff:	50                   	push   %eax
  800200:	6a 06                	push   $0x6
  800202:	68 2a 11 80 00       	push   $0x80112a
  800207:	6a 4c                	push   $0x4c
  800209:	68 47 11 80 00       	push   $0x801147
  80020e:	e8 6b 01 00 00       	call   80037e <_panic>

00800213 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800213:	55                   	push   %ebp
  800214:	89 e5                	mov    %esp,%ebp
  800216:	57                   	push   %edi
  800217:	56                   	push   %esi
  800218:	53                   	push   %ebx
  800219:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80021c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800221:	8b 55 08             	mov    0x8(%ebp),%edx
  800224:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800227:	b8 08 00 00 00       	mov    $0x8,%eax
  80022c:	89 df                	mov    %ebx,%edi
  80022e:	89 de                	mov    %ebx,%esi
  800230:	cd 30                	int    $0x30
	if (check && ret > 0)
  800232:	85 c0                	test   %eax,%eax
  800234:	7f 08                	jg     80023e <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800236:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800239:	5b                   	pop    %ebx
  80023a:	5e                   	pop    %esi
  80023b:	5f                   	pop    %edi
  80023c:	5d                   	pop    %ebp
  80023d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80023e:	83 ec 0c             	sub    $0xc,%esp
  800241:	50                   	push   %eax
  800242:	6a 08                	push   $0x8
  800244:	68 2a 11 80 00       	push   $0x80112a
  800249:	6a 4c                	push   $0x4c
  80024b:	68 47 11 80 00       	push   $0x801147
  800250:	e8 29 01 00 00       	call   80037e <_panic>

00800255 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800255:	55                   	push   %ebp
  800256:	89 e5                	mov    %esp,%ebp
  800258:	57                   	push   %edi
  800259:	56                   	push   %esi
  80025a:	53                   	push   %ebx
  80025b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80025e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800263:	8b 55 08             	mov    0x8(%ebp),%edx
  800266:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800269:	b8 09 00 00 00       	mov    $0x9,%eax
  80026e:	89 df                	mov    %ebx,%edi
  800270:	89 de                	mov    %ebx,%esi
  800272:	cd 30                	int    $0x30
	if (check && ret > 0)
  800274:	85 c0                	test   %eax,%eax
  800276:	7f 08                	jg     800280 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800278:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80027b:	5b                   	pop    %ebx
  80027c:	5e                   	pop    %esi
  80027d:	5f                   	pop    %edi
  80027e:	5d                   	pop    %ebp
  80027f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800280:	83 ec 0c             	sub    $0xc,%esp
  800283:	50                   	push   %eax
  800284:	6a 09                	push   $0x9
  800286:	68 2a 11 80 00       	push   $0x80112a
  80028b:	6a 4c                	push   $0x4c
  80028d:	68 47 11 80 00       	push   $0x801147
  800292:	e8 e7 00 00 00       	call   80037e <_panic>

00800297 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800297:	55                   	push   %ebp
  800298:	89 e5                	mov    %esp,%ebp
  80029a:	57                   	push   %edi
  80029b:	56                   	push   %esi
  80029c:	53                   	push   %ebx
  80029d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002a0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8002a8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002ab:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002b0:	89 df                	mov    %ebx,%edi
  8002b2:	89 de                	mov    %ebx,%esi
  8002b4:	cd 30                	int    $0x30
	if (check && ret > 0)
  8002b6:	85 c0                	test   %eax,%eax
  8002b8:	7f 08                	jg     8002c2 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002bd:	5b                   	pop    %ebx
  8002be:	5e                   	pop    %esi
  8002bf:	5f                   	pop    %edi
  8002c0:	5d                   	pop    %ebp
  8002c1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002c2:	83 ec 0c             	sub    $0xc,%esp
  8002c5:	50                   	push   %eax
  8002c6:	6a 0a                	push   $0xa
  8002c8:	68 2a 11 80 00       	push   $0x80112a
  8002cd:	6a 4c                	push   $0x4c
  8002cf:	68 47 11 80 00       	push   $0x801147
  8002d4:	e8 a5 00 00 00       	call   80037e <_panic>

008002d9 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002d9:	55                   	push   %ebp
  8002da:	89 e5                	mov    %esp,%ebp
  8002dc:	57                   	push   %edi
  8002dd:	56                   	push   %esi
  8002de:	53                   	push   %ebx
	asm volatile("int %1\n"
  8002df:	8b 55 08             	mov    0x8(%ebp),%edx
  8002e2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002e5:	b8 0c 00 00 00       	mov    $0xc,%eax
  8002ea:	be 00 00 00 00       	mov    $0x0,%esi
  8002ef:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8002f2:	8b 7d 14             	mov    0x14(%ebp),%edi
  8002f5:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8002f7:	5b                   	pop    %ebx
  8002f8:	5e                   	pop    %esi
  8002f9:	5f                   	pop    %edi
  8002fa:	5d                   	pop    %ebp
  8002fb:	c3                   	ret    

008002fc <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8002fc:	55                   	push   %ebp
  8002fd:	89 e5                	mov    %esp,%ebp
  8002ff:	57                   	push   %edi
  800300:	56                   	push   %esi
  800301:	53                   	push   %ebx
  800302:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800305:	b9 00 00 00 00       	mov    $0x0,%ecx
  80030a:	8b 55 08             	mov    0x8(%ebp),%edx
  80030d:	b8 0d 00 00 00       	mov    $0xd,%eax
  800312:	89 cb                	mov    %ecx,%ebx
  800314:	89 cf                	mov    %ecx,%edi
  800316:	89 ce                	mov    %ecx,%esi
  800318:	cd 30                	int    $0x30
	if (check && ret > 0)
  80031a:	85 c0                	test   %eax,%eax
  80031c:	7f 08                	jg     800326 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80031e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800321:	5b                   	pop    %ebx
  800322:	5e                   	pop    %esi
  800323:	5f                   	pop    %edi
  800324:	5d                   	pop    %ebp
  800325:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800326:	83 ec 0c             	sub    $0xc,%esp
  800329:	50                   	push   %eax
  80032a:	6a 0d                	push   $0xd
  80032c:	68 2a 11 80 00       	push   $0x80112a
  800331:	6a 4c                	push   $0x4c
  800333:	68 47 11 80 00       	push   $0x801147
  800338:	e8 41 00 00 00       	call   80037e <_panic>

0080033d <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  80033d:	55                   	push   %ebp
  80033e:	89 e5                	mov    %esp,%ebp
  800340:	57                   	push   %edi
  800341:	56                   	push   %esi
  800342:	53                   	push   %ebx
	asm volatile("int %1\n"
  800343:	bb 00 00 00 00       	mov    $0x0,%ebx
  800348:	8b 55 08             	mov    0x8(%ebp),%edx
  80034b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80034e:	b8 0e 00 00 00       	mov    $0xe,%eax
  800353:	89 df                	mov    %ebx,%edi
  800355:	89 de                	mov    %ebx,%esi
  800357:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800359:	5b                   	pop    %ebx
  80035a:	5e                   	pop    %esi
  80035b:	5f                   	pop    %edi
  80035c:	5d                   	pop    %ebp
  80035d:	c3                   	ret    

0080035e <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  80035e:	55                   	push   %ebp
  80035f:	89 e5                	mov    %esp,%ebp
  800361:	57                   	push   %edi
  800362:	56                   	push   %esi
  800363:	53                   	push   %ebx
	asm volatile("int %1\n"
  800364:	b9 00 00 00 00       	mov    $0x0,%ecx
  800369:	8b 55 08             	mov    0x8(%ebp),%edx
  80036c:	b8 0f 00 00 00       	mov    $0xf,%eax
  800371:	89 cb                	mov    %ecx,%ebx
  800373:	89 cf                	mov    %ecx,%edi
  800375:	89 ce                	mov    %ecx,%esi
  800377:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800379:	5b                   	pop    %ebx
  80037a:	5e                   	pop    %esi
  80037b:	5f                   	pop    %edi
  80037c:	5d                   	pop    %ebp
  80037d:	c3                   	ret    

0080037e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80037e:	55                   	push   %ebp
  80037f:	89 e5                	mov    %esp,%ebp
  800381:	56                   	push   %esi
  800382:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800383:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800386:	8b 35 00 20 80 00    	mov    0x802000,%esi
  80038c:	e8 7d fd ff ff       	call   80010e <sys_getenvid>
  800391:	83 ec 0c             	sub    $0xc,%esp
  800394:	ff 75 0c             	pushl  0xc(%ebp)
  800397:	ff 75 08             	pushl  0x8(%ebp)
  80039a:	56                   	push   %esi
  80039b:	50                   	push   %eax
  80039c:	68 58 11 80 00       	push   $0x801158
  8003a1:	e8 b3 00 00 00       	call   800459 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8003a6:	83 c4 18             	add    $0x18,%esp
  8003a9:	53                   	push   %ebx
  8003aa:	ff 75 10             	pushl  0x10(%ebp)
  8003ad:	e8 56 00 00 00       	call   800408 <vcprintf>
	cprintf("\n");
  8003b2:	c7 04 24 7b 11 80 00 	movl   $0x80117b,(%esp)
  8003b9:	e8 9b 00 00 00       	call   800459 <cprintf>
  8003be:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8003c1:	cc                   	int3   
  8003c2:	eb fd                	jmp    8003c1 <_panic+0x43>

008003c4 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8003c4:	55                   	push   %ebp
  8003c5:	89 e5                	mov    %esp,%ebp
  8003c7:	53                   	push   %ebx
  8003c8:	83 ec 04             	sub    $0x4,%esp
  8003cb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8003ce:	8b 13                	mov    (%ebx),%edx
  8003d0:	8d 42 01             	lea    0x1(%edx),%eax
  8003d3:	89 03                	mov    %eax,(%ebx)
  8003d5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003d8:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8003dc:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003e1:	74 09                	je     8003ec <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8003e3:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8003e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003ea:	c9                   	leave  
  8003eb:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8003ec:	83 ec 08             	sub    $0x8,%esp
  8003ef:	68 ff 00 00 00       	push   $0xff
  8003f4:	8d 43 08             	lea    0x8(%ebx),%eax
  8003f7:	50                   	push   %eax
  8003f8:	e8 93 fc ff ff       	call   800090 <sys_cputs>
		b->idx = 0;
  8003fd:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800403:	83 c4 10             	add    $0x10,%esp
  800406:	eb db                	jmp    8003e3 <putch+0x1f>

00800408 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800408:	55                   	push   %ebp
  800409:	89 e5                	mov    %esp,%ebp
  80040b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800411:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800418:	00 00 00 
	b.cnt = 0;
  80041b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800422:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800425:	ff 75 0c             	pushl  0xc(%ebp)
  800428:	ff 75 08             	pushl  0x8(%ebp)
  80042b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800431:	50                   	push   %eax
  800432:	68 c4 03 80 00       	push   $0x8003c4
  800437:	e8 4a 01 00 00       	call   800586 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80043c:	83 c4 08             	add    $0x8,%esp
  80043f:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800445:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80044b:	50                   	push   %eax
  80044c:	e8 3f fc ff ff       	call   800090 <sys_cputs>

	return b.cnt;
}
  800451:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800457:	c9                   	leave  
  800458:	c3                   	ret    

00800459 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800459:	55                   	push   %ebp
  80045a:	89 e5                	mov    %esp,%ebp
  80045c:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80045f:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800462:	50                   	push   %eax
  800463:	ff 75 08             	pushl  0x8(%ebp)
  800466:	e8 9d ff ff ff       	call   800408 <vcprintf>
	va_end(ap);

	return cnt;
}
  80046b:	c9                   	leave  
  80046c:	c3                   	ret    

0080046d <printnum>:


static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80046d:	55                   	push   %ebp
  80046e:	89 e5                	mov    %esp,%ebp
  800470:	57                   	push   %edi
  800471:	56                   	push   %esi
  800472:	53                   	push   %ebx
  800473:	83 ec 1c             	sub    $0x1c,%esp
  800476:	89 c6                	mov    %eax,%esi
  800478:	89 d7                	mov    %edx,%edi
  80047a:	8b 45 08             	mov    0x8(%ebp),%eax
  80047d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800480:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800483:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800486:	8b 45 10             	mov    0x10(%ebp),%eax
  800489:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	// to support '-'
	if(padc == '-'){
  80048c:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800490:	74 2c                	je     8004be <printnum+0x51>
		while (--width > 0)
			putch(' ', putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800492:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800495:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80049c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80049f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8004a2:	39 c2                	cmp    %eax,%edx
  8004a4:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8004a7:	73 43                	jae    8004ec <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004a9:	83 eb 01             	sub    $0x1,%ebx
  8004ac:	85 db                	test   %ebx,%ebx
  8004ae:	7e 6c                	jle    80051c <printnum+0xaf>
			putch(padc, putdat);
  8004b0:	83 ec 08             	sub    $0x8,%esp
  8004b3:	57                   	push   %edi
  8004b4:	ff 75 18             	pushl  0x18(%ebp)
  8004b7:	ff d6                	call   *%esi
  8004b9:	83 c4 10             	add    $0x10,%esp
  8004bc:	eb eb                	jmp    8004a9 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8004be:	83 ec 0c             	sub    $0xc,%esp
  8004c1:	6a 20                	push   $0x20
  8004c3:	6a 00                	push   $0x0
  8004c5:	50                   	push   %eax
  8004c6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004c9:	ff 75 e0             	pushl  -0x20(%ebp)
  8004cc:	89 fa                	mov    %edi,%edx
  8004ce:	89 f0                	mov    %esi,%eax
  8004d0:	e8 98 ff ff ff       	call   80046d <printnum>
		while (--width > 0)
  8004d5:	83 c4 20             	add    $0x20,%esp
  8004d8:	83 eb 01             	sub    $0x1,%ebx
  8004db:	85 db                	test   %ebx,%ebx
  8004dd:	7e 65                	jle    800544 <printnum+0xd7>
			putch(' ', putdat);
  8004df:	83 ec 08             	sub    $0x8,%esp
  8004e2:	57                   	push   %edi
  8004e3:	6a 20                	push   $0x20
  8004e5:	ff d6                	call   *%esi
  8004e7:	83 c4 10             	add    $0x10,%esp
  8004ea:	eb ec                	jmp    8004d8 <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004ec:	83 ec 0c             	sub    $0xc,%esp
  8004ef:	ff 75 18             	pushl  0x18(%ebp)
  8004f2:	83 eb 01             	sub    $0x1,%ebx
  8004f5:	53                   	push   %ebx
  8004f6:	50                   	push   %eax
  8004f7:	83 ec 08             	sub    $0x8,%esp
  8004fa:	ff 75 dc             	pushl  -0x24(%ebp)
  8004fd:	ff 75 d8             	pushl  -0x28(%ebp)
  800500:	ff 75 e4             	pushl  -0x1c(%ebp)
  800503:	ff 75 e0             	pushl  -0x20(%ebp)
  800506:	e8 b5 09 00 00       	call   800ec0 <__udivdi3>
  80050b:	83 c4 18             	add    $0x18,%esp
  80050e:	52                   	push   %edx
  80050f:	50                   	push   %eax
  800510:	89 fa                	mov    %edi,%edx
  800512:	89 f0                	mov    %esi,%eax
  800514:	e8 54 ff ff ff       	call   80046d <printnum>
  800519:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80051c:	83 ec 08             	sub    $0x8,%esp
  80051f:	57                   	push   %edi
  800520:	83 ec 04             	sub    $0x4,%esp
  800523:	ff 75 dc             	pushl  -0x24(%ebp)
  800526:	ff 75 d8             	pushl  -0x28(%ebp)
  800529:	ff 75 e4             	pushl  -0x1c(%ebp)
  80052c:	ff 75 e0             	pushl  -0x20(%ebp)
  80052f:	e8 9c 0a 00 00       	call   800fd0 <__umoddi3>
  800534:	83 c4 14             	add    $0x14,%esp
  800537:	0f be 80 7d 11 80 00 	movsbl 0x80117d(%eax),%eax
  80053e:	50                   	push   %eax
  80053f:	ff d6                	call   *%esi
  800541:	83 c4 10             	add    $0x10,%esp
}
  800544:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800547:	5b                   	pop    %ebx
  800548:	5e                   	pop    %esi
  800549:	5f                   	pop    %edi
  80054a:	5d                   	pop    %ebp
  80054b:	c3                   	ret    

0080054c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80054c:	55                   	push   %ebp
  80054d:	89 e5                	mov    %esp,%ebp
  80054f:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800552:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800556:	8b 10                	mov    (%eax),%edx
  800558:	3b 50 04             	cmp    0x4(%eax),%edx
  80055b:	73 0a                	jae    800567 <sprintputch+0x1b>
		*b->buf++ = ch;
  80055d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800560:	89 08                	mov    %ecx,(%eax)
  800562:	8b 45 08             	mov    0x8(%ebp),%eax
  800565:	88 02                	mov    %al,(%edx)
}
  800567:	5d                   	pop    %ebp
  800568:	c3                   	ret    

00800569 <printfmt>:
{
  800569:	55                   	push   %ebp
  80056a:	89 e5                	mov    %esp,%ebp
  80056c:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80056f:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800572:	50                   	push   %eax
  800573:	ff 75 10             	pushl  0x10(%ebp)
  800576:	ff 75 0c             	pushl  0xc(%ebp)
  800579:	ff 75 08             	pushl  0x8(%ebp)
  80057c:	e8 05 00 00 00       	call   800586 <vprintfmt>
}
  800581:	83 c4 10             	add    $0x10,%esp
  800584:	c9                   	leave  
  800585:	c3                   	ret    

00800586 <vprintfmt>:
{
  800586:	55                   	push   %ebp
  800587:	89 e5                	mov    %esp,%ebp
  800589:	57                   	push   %edi
  80058a:	56                   	push   %esi
  80058b:	53                   	push   %ebx
  80058c:	83 ec 3c             	sub    $0x3c,%esp
  80058f:	8b 75 08             	mov    0x8(%ebp),%esi
  800592:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800595:	8b 7d 10             	mov    0x10(%ebp),%edi
  800598:	e9 1e 04 00 00       	jmp    8009bb <vprintfmt+0x435>
		posflag = 0;
  80059d:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
		padc = ' ';
  8005a4:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8005a8:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8005af:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8005b6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8005bd:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  8005c4:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8005c9:	8d 47 01             	lea    0x1(%edi),%eax
  8005cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005cf:	0f b6 17             	movzbl (%edi),%edx
  8005d2:	8d 42 dd             	lea    -0x23(%edx),%eax
  8005d5:	3c 55                	cmp    $0x55,%al
  8005d7:	0f 87 d9 04 00 00    	ja     800ab6 <vprintfmt+0x530>
  8005dd:	0f b6 c0             	movzbl %al,%eax
  8005e0:	ff 24 85 60 13 80 00 	jmp    *0x801360(,%eax,4)
  8005e7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8005ea:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8005ee:	eb d9                	jmp    8005c9 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8005f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posflag = 1;
  8005f3:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  8005fa:	eb cd                	jmp    8005c9 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8005fc:	0f b6 d2             	movzbl %dl,%edx
  8005ff:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800602:	b8 00 00 00 00       	mov    $0x0,%eax
  800607:	89 75 08             	mov    %esi,0x8(%ebp)
  80060a:	eb 0c                	jmp    800618 <vprintfmt+0x92>
		switch (ch = *(unsigned char *) fmt++) {
  80060c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80060f:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  800613:	eb b4                	jmp    8005c9 <vprintfmt+0x43>
			for (precision = 0; ; ++fmt) {
  800615:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800618:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80061b:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80061f:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800622:	8d 72 d0             	lea    -0x30(%edx),%esi
  800625:	83 fe 09             	cmp    $0x9,%esi
  800628:	76 eb                	jbe    800615 <vprintfmt+0x8f>
  80062a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80062d:	8b 75 08             	mov    0x8(%ebp),%esi
  800630:	eb 14                	jmp    800646 <vprintfmt+0xc0>
			precision = va_arg(ap, int);
  800632:	8b 45 14             	mov    0x14(%ebp),%eax
  800635:	8b 00                	mov    (%eax),%eax
  800637:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80063a:	8b 45 14             	mov    0x14(%ebp),%eax
  80063d:	8d 40 04             	lea    0x4(%eax),%eax
  800640:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800643:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800646:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80064a:	0f 89 79 ff ff ff    	jns    8005c9 <vprintfmt+0x43>
				width = precision, precision = -1;
  800650:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800653:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800656:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80065d:	e9 67 ff ff ff       	jmp    8005c9 <vprintfmt+0x43>
  800662:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800665:	85 c0                	test   %eax,%eax
  800667:	0f 48 c1             	cmovs  %ecx,%eax
  80066a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80066d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800670:	e9 54 ff ff ff       	jmp    8005c9 <vprintfmt+0x43>
  800675:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800678:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80067f:	e9 45 ff ff ff       	jmp    8005c9 <vprintfmt+0x43>
			lflag++;
  800684:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800688:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80068b:	e9 39 ff ff ff       	jmp    8005c9 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800690:	8b 45 14             	mov    0x14(%ebp),%eax
  800693:	8d 78 04             	lea    0x4(%eax),%edi
  800696:	83 ec 08             	sub    $0x8,%esp
  800699:	53                   	push   %ebx
  80069a:	ff 30                	pushl  (%eax)
  80069c:	ff d6                	call   *%esi
			break;
  80069e:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8006a1:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8006a4:	e9 0f 03 00 00       	jmp    8009b8 <vprintfmt+0x432>
			err = va_arg(ap, int);
  8006a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ac:	8d 78 04             	lea    0x4(%eax),%edi
  8006af:	8b 00                	mov    (%eax),%eax
  8006b1:	99                   	cltd   
  8006b2:	31 d0                	xor    %edx,%eax
  8006b4:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8006b6:	83 f8 0f             	cmp    $0xf,%eax
  8006b9:	7f 23                	jg     8006de <vprintfmt+0x158>
  8006bb:	8b 14 85 c0 14 80 00 	mov    0x8014c0(,%eax,4),%edx
  8006c2:	85 d2                	test   %edx,%edx
  8006c4:	74 18                	je     8006de <vprintfmt+0x158>
				printfmt(putch, putdat, "%s", p);
  8006c6:	52                   	push   %edx
  8006c7:	68 9e 11 80 00       	push   $0x80119e
  8006cc:	53                   	push   %ebx
  8006cd:	56                   	push   %esi
  8006ce:	e8 96 fe ff ff       	call   800569 <printfmt>
  8006d3:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8006d6:	89 7d 14             	mov    %edi,0x14(%ebp)
  8006d9:	e9 da 02 00 00       	jmp    8009b8 <vprintfmt+0x432>
				printfmt(putch, putdat, "error %d", err);
  8006de:	50                   	push   %eax
  8006df:	68 95 11 80 00       	push   $0x801195
  8006e4:	53                   	push   %ebx
  8006e5:	56                   	push   %esi
  8006e6:	e8 7e fe ff ff       	call   800569 <printfmt>
  8006eb:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8006ee:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8006f1:	e9 c2 02 00 00       	jmp    8009b8 <vprintfmt+0x432>
			if ((p = va_arg(ap, char *)) == NULL)
  8006f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f9:	83 c0 04             	add    $0x4,%eax
  8006fc:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8006ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800702:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800704:	85 c9                	test   %ecx,%ecx
  800706:	b8 8e 11 80 00       	mov    $0x80118e,%eax
  80070b:	0f 45 c1             	cmovne %ecx,%eax
  80070e:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800711:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800715:	7e 06                	jle    80071d <vprintfmt+0x197>
  800717:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80071b:	75 0d                	jne    80072a <vprintfmt+0x1a4>
				for (width -= strnlen(p, precision); width > 0; width--)
  80071d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800720:	89 c7                	mov    %eax,%edi
  800722:	03 45 e0             	add    -0x20(%ebp),%eax
  800725:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800728:	eb 53                	jmp    80077d <vprintfmt+0x1f7>
  80072a:	83 ec 08             	sub    $0x8,%esp
  80072d:	ff 75 d8             	pushl  -0x28(%ebp)
  800730:	50                   	push   %eax
  800731:	e8 28 04 00 00       	call   800b5e <strnlen>
  800736:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800739:	29 c1                	sub    %eax,%ecx
  80073b:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  80073e:	83 c4 10             	add    $0x10,%esp
  800741:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800743:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800747:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80074a:	eb 0f                	jmp    80075b <vprintfmt+0x1d5>
					putch(padc, putdat);
  80074c:	83 ec 08             	sub    $0x8,%esp
  80074f:	53                   	push   %ebx
  800750:	ff 75 e0             	pushl  -0x20(%ebp)
  800753:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800755:	83 ef 01             	sub    $0x1,%edi
  800758:	83 c4 10             	add    $0x10,%esp
  80075b:	85 ff                	test   %edi,%edi
  80075d:	7f ed                	jg     80074c <vprintfmt+0x1c6>
  80075f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  800762:	85 c9                	test   %ecx,%ecx
  800764:	b8 00 00 00 00       	mov    $0x0,%eax
  800769:	0f 49 c1             	cmovns %ecx,%eax
  80076c:	29 c1                	sub    %eax,%ecx
  80076e:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800771:	eb aa                	jmp    80071d <vprintfmt+0x197>
					putch(ch, putdat);
  800773:	83 ec 08             	sub    $0x8,%esp
  800776:	53                   	push   %ebx
  800777:	52                   	push   %edx
  800778:	ff d6                	call   *%esi
  80077a:	83 c4 10             	add    $0x10,%esp
  80077d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800780:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800782:	83 c7 01             	add    $0x1,%edi
  800785:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800789:	0f be d0             	movsbl %al,%edx
  80078c:	85 d2                	test   %edx,%edx
  80078e:	74 4b                	je     8007db <vprintfmt+0x255>
  800790:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800794:	78 06                	js     80079c <vprintfmt+0x216>
  800796:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80079a:	78 1e                	js     8007ba <vprintfmt+0x234>
				if (altflag && (ch < ' ' || ch > '~'))
  80079c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8007a0:	74 d1                	je     800773 <vprintfmt+0x1ed>
  8007a2:	0f be c0             	movsbl %al,%eax
  8007a5:	83 e8 20             	sub    $0x20,%eax
  8007a8:	83 f8 5e             	cmp    $0x5e,%eax
  8007ab:	76 c6                	jbe    800773 <vprintfmt+0x1ed>
					putch('?', putdat);
  8007ad:	83 ec 08             	sub    $0x8,%esp
  8007b0:	53                   	push   %ebx
  8007b1:	6a 3f                	push   $0x3f
  8007b3:	ff d6                	call   *%esi
  8007b5:	83 c4 10             	add    $0x10,%esp
  8007b8:	eb c3                	jmp    80077d <vprintfmt+0x1f7>
  8007ba:	89 cf                	mov    %ecx,%edi
  8007bc:	eb 0e                	jmp    8007cc <vprintfmt+0x246>
				putch(' ', putdat);
  8007be:	83 ec 08             	sub    $0x8,%esp
  8007c1:	53                   	push   %ebx
  8007c2:	6a 20                	push   $0x20
  8007c4:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8007c6:	83 ef 01             	sub    $0x1,%edi
  8007c9:	83 c4 10             	add    $0x10,%esp
  8007cc:	85 ff                	test   %edi,%edi
  8007ce:	7f ee                	jg     8007be <vprintfmt+0x238>
			if ((p = va_arg(ap, char *)) == NULL)
  8007d0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8007d3:	89 45 14             	mov    %eax,0x14(%ebp)
  8007d6:	e9 dd 01 00 00       	jmp    8009b8 <vprintfmt+0x432>
  8007db:	89 cf                	mov    %ecx,%edi
  8007dd:	eb ed                	jmp    8007cc <vprintfmt+0x246>
	if (lflag >= 2)
  8007df:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8007e3:	7f 21                	jg     800806 <vprintfmt+0x280>
	else if (lflag)
  8007e5:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8007e9:	74 6a                	je     800855 <vprintfmt+0x2cf>
		return va_arg(*ap, long);
  8007eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ee:	8b 00                	mov    (%eax),%eax
  8007f0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007f3:	89 c1                	mov    %eax,%ecx
  8007f5:	c1 f9 1f             	sar    $0x1f,%ecx
  8007f8:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8007fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fe:	8d 40 04             	lea    0x4(%eax),%eax
  800801:	89 45 14             	mov    %eax,0x14(%ebp)
  800804:	eb 17                	jmp    80081d <vprintfmt+0x297>
		return va_arg(*ap, long long);
  800806:	8b 45 14             	mov    0x14(%ebp),%eax
  800809:	8b 50 04             	mov    0x4(%eax),%edx
  80080c:	8b 00                	mov    (%eax),%eax
  80080e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800811:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800814:	8b 45 14             	mov    0x14(%ebp),%eax
  800817:	8d 40 08             	lea    0x8(%eax),%eax
  80081a:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80081d:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  800820:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800825:	85 d2                	test   %edx,%edx
  800827:	0f 89 5c 01 00 00    	jns    800989 <vprintfmt+0x403>
				putch('-', putdat);
  80082d:	83 ec 08             	sub    $0x8,%esp
  800830:	53                   	push   %ebx
  800831:	6a 2d                	push   $0x2d
  800833:	ff d6                	call   *%esi
				num = -(long long) num;
  800835:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800838:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80083b:	f7 d8                	neg    %eax
  80083d:	83 d2 00             	adc    $0x0,%edx
  800840:	f7 da                	neg    %edx
  800842:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800845:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800848:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80084b:	bf 0a 00 00 00       	mov    $0xa,%edi
  800850:	e9 45 01 00 00       	jmp    80099a <vprintfmt+0x414>
		return va_arg(*ap, int);
  800855:	8b 45 14             	mov    0x14(%ebp),%eax
  800858:	8b 00                	mov    (%eax),%eax
  80085a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80085d:	89 c1                	mov    %eax,%ecx
  80085f:	c1 f9 1f             	sar    $0x1f,%ecx
  800862:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800865:	8b 45 14             	mov    0x14(%ebp),%eax
  800868:	8d 40 04             	lea    0x4(%eax),%eax
  80086b:	89 45 14             	mov    %eax,0x14(%ebp)
  80086e:	eb ad                	jmp    80081d <vprintfmt+0x297>
	if (lflag >= 2)
  800870:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800874:	7f 29                	jg     80089f <vprintfmt+0x319>
	else if (lflag)
  800876:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80087a:	74 44                	je     8008c0 <vprintfmt+0x33a>
		return va_arg(*ap, unsigned long);
  80087c:	8b 45 14             	mov    0x14(%ebp),%eax
  80087f:	8b 00                	mov    (%eax),%eax
  800881:	ba 00 00 00 00       	mov    $0x0,%edx
  800886:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800889:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80088c:	8b 45 14             	mov    0x14(%ebp),%eax
  80088f:	8d 40 04             	lea    0x4(%eax),%eax
  800892:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800895:	bf 0a 00 00 00       	mov    $0xa,%edi
  80089a:	e9 ea 00 00 00       	jmp    800989 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  80089f:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a2:	8b 50 04             	mov    0x4(%eax),%edx
  8008a5:	8b 00                	mov    (%eax),%eax
  8008a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008aa:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b0:	8d 40 08             	lea    0x8(%eax),%eax
  8008b3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008b6:	bf 0a 00 00 00       	mov    $0xa,%edi
  8008bb:	e9 c9 00 00 00       	jmp    800989 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  8008c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c3:	8b 00                	mov    (%eax),%eax
  8008c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8008ca:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008cd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d3:	8d 40 04             	lea    0x4(%eax),%eax
  8008d6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008d9:	bf 0a 00 00 00       	mov    $0xa,%edi
  8008de:	e9 a6 00 00 00       	jmp    800989 <vprintfmt+0x403>
			putch('0', putdat);
  8008e3:	83 ec 08             	sub    $0x8,%esp
  8008e6:	53                   	push   %ebx
  8008e7:	6a 30                	push   $0x30
  8008e9:	ff d6                	call   *%esi
	if (lflag >= 2)
  8008eb:	83 c4 10             	add    $0x10,%esp
  8008ee:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8008f2:	7f 26                	jg     80091a <vprintfmt+0x394>
	else if (lflag)
  8008f4:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8008f8:	74 3e                	je     800938 <vprintfmt+0x3b2>
		return va_arg(*ap, unsigned long);
  8008fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8008fd:	8b 00                	mov    (%eax),%eax
  8008ff:	ba 00 00 00 00       	mov    $0x0,%edx
  800904:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800907:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80090a:	8b 45 14             	mov    0x14(%ebp),%eax
  80090d:	8d 40 04             	lea    0x4(%eax),%eax
  800910:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800913:	bf 08 00 00 00       	mov    $0x8,%edi
  800918:	eb 6f                	jmp    800989 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  80091a:	8b 45 14             	mov    0x14(%ebp),%eax
  80091d:	8b 50 04             	mov    0x4(%eax),%edx
  800920:	8b 00                	mov    (%eax),%eax
  800922:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800925:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800928:	8b 45 14             	mov    0x14(%ebp),%eax
  80092b:	8d 40 08             	lea    0x8(%eax),%eax
  80092e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800931:	bf 08 00 00 00       	mov    $0x8,%edi
  800936:	eb 51                	jmp    800989 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  800938:	8b 45 14             	mov    0x14(%ebp),%eax
  80093b:	8b 00                	mov    (%eax),%eax
  80093d:	ba 00 00 00 00       	mov    $0x0,%edx
  800942:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800945:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800948:	8b 45 14             	mov    0x14(%ebp),%eax
  80094b:	8d 40 04             	lea    0x4(%eax),%eax
  80094e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800951:	bf 08 00 00 00       	mov    $0x8,%edi
  800956:	eb 31                	jmp    800989 <vprintfmt+0x403>
			putch('0', putdat);
  800958:	83 ec 08             	sub    $0x8,%esp
  80095b:	53                   	push   %ebx
  80095c:	6a 30                	push   $0x30
  80095e:	ff d6                	call   *%esi
			putch('x', putdat);
  800960:	83 c4 08             	add    $0x8,%esp
  800963:	53                   	push   %ebx
  800964:	6a 78                	push   $0x78
  800966:	ff d6                	call   *%esi
			num = (unsigned long long)
  800968:	8b 45 14             	mov    0x14(%ebp),%eax
  80096b:	8b 00                	mov    (%eax),%eax
  80096d:	ba 00 00 00 00       	mov    $0x0,%edx
  800972:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800975:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800978:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80097b:	8b 45 14             	mov    0x14(%ebp),%eax
  80097e:	8d 40 04             	lea    0x4(%eax),%eax
  800981:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800984:	bf 10 00 00 00       	mov    $0x10,%edi
			if(posflag)
  800989:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80098d:	74 0b                	je     80099a <vprintfmt+0x414>
				putch('+', putdat);
  80098f:	83 ec 08             	sub    $0x8,%esp
  800992:	53                   	push   %ebx
  800993:	6a 2b                	push   $0x2b
  800995:	ff d6                	call   *%esi
  800997:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  80099a:	83 ec 0c             	sub    $0xc,%esp
  80099d:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8009a1:	50                   	push   %eax
  8009a2:	ff 75 e0             	pushl  -0x20(%ebp)
  8009a5:	57                   	push   %edi
  8009a6:	ff 75 dc             	pushl  -0x24(%ebp)
  8009a9:	ff 75 d8             	pushl  -0x28(%ebp)
  8009ac:	89 da                	mov    %ebx,%edx
  8009ae:	89 f0                	mov    %esi,%eax
  8009b0:	e8 b8 fa ff ff       	call   80046d <printnum>
			break;
  8009b5:	83 c4 20             	add    $0x20,%esp
			char* cp = va_arg(ap, char *);
  8009b8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009bb:	83 c7 01             	add    $0x1,%edi
  8009be:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8009c2:	83 f8 25             	cmp    $0x25,%eax
  8009c5:	0f 84 d2 fb ff ff    	je     80059d <vprintfmt+0x17>
			if (ch == '\0')
  8009cb:	85 c0                	test   %eax,%eax
  8009cd:	0f 84 03 01 00 00    	je     800ad6 <vprintfmt+0x550>
			putch(ch, putdat);
  8009d3:	83 ec 08             	sub    $0x8,%esp
  8009d6:	53                   	push   %ebx
  8009d7:	50                   	push   %eax
  8009d8:	ff d6                	call   *%esi
  8009da:	83 c4 10             	add    $0x10,%esp
  8009dd:	eb dc                	jmp    8009bb <vprintfmt+0x435>
	if (lflag >= 2)
  8009df:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8009e3:	7f 29                	jg     800a0e <vprintfmt+0x488>
	else if (lflag)
  8009e5:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8009e9:	74 44                	je     800a2f <vprintfmt+0x4a9>
		return va_arg(*ap, unsigned long);
  8009eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ee:	8b 00                	mov    (%eax),%eax
  8009f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8009f5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009f8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8009fe:	8d 40 04             	lea    0x4(%eax),%eax
  800a01:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a04:	bf 10 00 00 00       	mov    $0x10,%edi
  800a09:	e9 7b ff ff ff       	jmp    800989 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  800a0e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a11:	8b 50 04             	mov    0x4(%eax),%edx
  800a14:	8b 00                	mov    (%eax),%eax
  800a16:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a19:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a1c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1f:	8d 40 08             	lea    0x8(%eax),%eax
  800a22:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a25:	bf 10 00 00 00       	mov    $0x10,%edi
  800a2a:	e9 5a ff ff ff       	jmp    800989 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  800a2f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a32:	8b 00                	mov    (%eax),%eax
  800a34:	ba 00 00 00 00       	mov    $0x0,%edx
  800a39:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a3c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a3f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a42:	8d 40 04             	lea    0x4(%eax),%eax
  800a45:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a48:	bf 10 00 00 00       	mov    $0x10,%edi
  800a4d:	e9 37 ff ff ff       	jmp    800989 <vprintfmt+0x403>
			char* cp = va_arg(ap, char *);
  800a52:	8b 45 14             	mov    0x14(%ebp),%eax
  800a55:	8d 78 04             	lea    0x4(%eax),%edi
  800a58:	8b 00                	mov    (%eax),%eax
    			if (cp == NULL) {
  800a5a:	85 c0                	test   %eax,%eax
  800a5c:	74 2c                	je     800a8a <vprintfmt+0x504>
    			*cp = *(int *)putdat;
  800a5e:	8b 13                	mov    (%ebx),%edx
  800a60:	88 10                	mov    %dl,(%eax)
			char* cp = va_arg(ap, char *);
  800a62:	89 7d 14             	mov    %edi,0x14(%ebp)
    			if ((*(int *) putdat) > 127)
  800a65:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  800a68:	0f 8e 4a ff ff ff    	jle    8009b8 <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", overflow_error);
  800a6e:	68 ec 12 80 00       	push   $0x8012ec
  800a73:	68 9e 11 80 00       	push   $0x80119e
  800a78:	53                   	push   %ebx
  800a79:	56                   	push   %esi
  800a7a:	e8 ea fa ff ff       	call   800569 <printfmt>
  800a7f:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  800a82:	89 7d 14             	mov    %edi,0x14(%ebp)
  800a85:	e9 2e ff ff ff       	jmp    8009b8 <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", null_error);
  800a8a:	68 b4 12 80 00       	push   $0x8012b4
  800a8f:	68 9e 11 80 00       	push   $0x80119e
  800a94:	53                   	push   %ebx
  800a95:	56                   	push   %esi
  800a96:	e8 ce fa ff ff       	call   800569 <printfmt>
        		break;
  800a9b:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  800a9e:	89 7d 14             	mov    %edi,0x14(%ebp)
        		break;
  800aa1:	e9 12 ff ff ff       	jmp    8009b8 <vprintfmt+0x432>
			putch(ch, putdat);
  800aa6:	83 ec 08             	sub    $0x8,%esp
  800aa9:	53                   	push   %ebx
  800aaa:	6a 25                	push   $0x25
  800aac:	ff d6                	call   *%esi
			break;
  800aae:	83 c4 10             	add    $0x10,%esp
  800ab1:	e9 02 ff ff ff       	jmp    8009b8 <vprintfmt+0x432>
			putch('%', putdat);
  800ab6:	83 ec 08             	sub    $0x8,%esp
  800ab9:	53                   	push   %ebx
  800aba:	6a 25                	push   $0x25
  800abc:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800abe:	83 c4 10             	add    $0x10,%esp
  800ac1:	89 f8                	mov    %edi,%eax
  800ac3:	eb 03                	jmp    800ac8 <vprintfmt+0x542>
  800ac5:	83 e8 01             	sub    $0x1,%eax
  800ac8:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800acc:	75 f7                	jne    800ac5 <vprintfmt+0x53f>
  800ace:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ad1:	e9 e2 fe ff ff       	jmp    8009b8 <vprintfmt+0x432>
}
  800ad6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ad9:	5b                   	pop    %ebx
  800ada:	5e                   	pop    %esi
  800adb:	5f                   	pop    %edi
  800adc:	5d                   	pop    %ebp
  800add:	c3                   	ret    

00800ade <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ade:	55                   	push   %ebp
  800adf:	89 e5                	mov    %esp,%ebp
  800ae1:	83 ec 18             	sub    $0x18,%esp
  800ae4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae7:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800aea:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800aed:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800af1:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800af4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800afb:	85 c0                	test   %eax,%eax
  800afd:	74 26                	je     800b25 <vsnprintf+0x47>
  800aff:	85 d2                	test   %edx,%edx
  800b01:	7e 22                	jle    800b25 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b03:	ff 75 14             	pushl  0x14(%ebp)
  800b06:	ff 75 10             	pushl  0x10(%ebp)
  800b09:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b0c:	50                   	push   %eax
  800b0d:	68 4c 05 80 00       	push   $0x80054c
  800b12:	e8 6f fa ff ff       	call   800586 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800b17:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b1a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b20:	83 c4 10             	add    $0x10,%esp
}
  800b23:	c9                   	leave  
  800b24:	c3                   	ret    
		return -E_INVAL;
  800b25:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b2a:	eb f7                	jmp    800b23 <vsnprintf+0x45>

00800b2c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b2c:	55                   	push   %ebp
  800b2d:	89 e5                	mov    %esp,%ebp
  800b2f:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b32:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800b35:	50                   	push   %eax
  800b36:	ff 75 10             	pushl  0x10(%ebp)
  800b39:	ff 75 0c             	pushl  0xc(%ebp)
  800b3c:	ff 75 08             	pushl  0x8(%ebp)
  800b3f:	e8 9a ff ff ff       	call   800ade <vsnprintf>
	va_end(ap);

	return rc;
}
  800b44:	c9                   	leave  
  800b45:	c3                   	ret    

00800b46 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800b46:	55                   	push   %ebp
  800b47:	89 e5                	mov    %esp,%ebp
  800b49:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800b4c:	b8 00 00 00 00       	mov    $0x0,%eax
  800b51:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800b55:	74 05                	je     800b5c <strlen+0x16>
		n++;
  800b57:	83 c0 01             	add    $0x1,%eax
  800b5a:	eb f5                	jmp    800b51 <strlen+0xb>
	return n;
}
  800b5c:	5d                   	pop    %ebp
  800b5d:	c3                   	ret    

00800b5e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800b5e:	55                   	push   %ebp
  800b5f:	89 e5                	mov    %esp,%ebp
  800b61:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b64:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b67:	ba 00 00 00 00       	mov    $0x0,%edx
  800b6c:	39 c2                	cmp    %eax,%edx
  800b6e:	74 0d                	je     800b7d <strnlen+0x1f>
  800b70:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800b74:	74 05                	je     800b7b <strnlen+0x1d>
		n++;
  800b76:	83 c2 01             	add    $0x1,%edx
  800b79:	eb f1                	jmp    800b6c <strnlen+0xe>
  800b7b:	89 d0                	mov    %edx,%eax
	return n;
}
  800b7d:	5d                   	pop    %ebp
  800b7e:	c3                   	ret    

00800b7f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b7f:	55                   	push   %ebp
  800b80:	89 e5                	mov    %esp,%ebp
  800b82:	53                   	push   %ebx
  800b83:	8b 45 08             	mov    0x8(%ebp),%eax
  800b86:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800b89:	ba 00 00 00 00       	mov    $0x0,%edx
  800b8e:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800b92:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800b95:	83 c2 01             	add    $0x1,%edx
  800b98:	84 c9                	test   %cl,%cl
  800b9a:	75 f2                	jne    800b8e <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800b9c:	5b                   	pop    %ebx
  800b9d:	5d                   	pop    %ebp
  800b9e:	c3                   	ret    

00800b9f <strcat>:

char *
strcat(char *dst, const char *src)
{
  800b9f:	55                   	push   %ebp
  800ba0:	89 e5                	mov    %esp,%ebp
  800ba2:	53                   	push   %ebx
  800ba3:	83 ec 10             	sub    $0x10,%esp
  800ba6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800ba9:	53                   	push   %ebx
  800baa:	e8 97 ff ff ff       	call   800b46 <strlen>
  800baf:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800bb2:	ff 75 0c             	pushl  0xc(%ebp)
  800bb5:	01 d8                	add    %ebx,%eax
  800bb7:	50                   	push   %eax
  800bb8:	e8 c2 ff ff ff       	call   800b7f <strcpy>
	return dst;
}
  800bbd:	89 d8                	mov    %ebx,%eax
  800bbf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800bc2:	c9                   	leave  
  800bc3:	c3                   	ret    

00800bc4 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800bc4:	55                   	push   %ebp
  800bc5:	89 e5                	mov    %esp,%ebp
  800bc7:	56                   	push   %esi
  800bc8:	53                   	push   %ebx
  800bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bcf:	89 c6                	mov    %eax,%esi
  800bd1:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800bd4:	89 c2                	mov    %eax,%edx
  800bd6:	39 f2                	cmp    %esi,%edx
  800bd8:	74 11                	je     800beb <strncpy+0x27>
		*dst++ = *src;
  800bda:	83 c2 01             	add    $0x1,%edx
  800bdd:	0f b6 19             	movzbl (%ecx),%ebx
  800be0:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800be3:	80 fb 01             	cmp    $0x1,%bl
  800be6:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800be9:	eb eb                	jmp    800bd6 <strncpy+0x12>
	}
	return ret;
}
  800beb:	5b                   	pop    %ebx
  800bec:	5e                   	pop    %esi
  800bed:	5d                   	pop    %ebp
  800bee:	c3                   	ret    

00800bef <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800bef:	55                   	push   %ebp
  800bf0:	89 e5                	mov    %esp,%ebp
  800bf2:	56                   	push   %esi
  800bf3:	53                   	push   %ebx
  800bf4:	8b 75 08             	mov    0x8(%ebp),%esi
  800bf7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bfa:	8b 55 10             	mov    0x10(%ebp),%edx
  800bfd:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800bff:	85 d2                	test   %edx,%edx
  800c01:	74 21                	je     800c24 <strlcpy+0x35>
  800c03:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800c07:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800c09:	39 c2                	cmp    %eax,%edx
  800c0b:	74 14                	je     800c21 <strlcpy+0x32>
  800c0d:	0f b6 19             	movzbl (%ecx),%ebx
  800c10:	84 db                	test   %bl,%bl
  800c12:	74 0b                	je     800c1f <strlcpy+0x30>
			*dst++ = *src++;
  800c14:	83 c1 01             	add    $0x1,%ecx
  800c17:	83 c2 01             	add    $0x1,%edx
  800c1a:	88 5a ff             	mov    %bl,-0x1(%edx)
  800c1d:	eb ea                	jmp    800c09 <strlcpy+0x1a>
  800c1f:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800c21:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c24:	29 f0                	sub    %esi,%eax
}
  800c26:	5b                   	pop    %ebx
  800c27:	5e                   	pop    %esi
  800c28:	5d                   	pop    %ebp
  800c29:	c3                   	ret    

00800c2a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c2a:	55                   	push   %ebp
  800c2b:	89 e5                	mov    %esp,%ebp
  800c2d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c30:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800c33:	0f b6 01             	movzbl (%ecx),%eax
  800c36:	84 c0                	test   %al,%al
  800c38:	74 0c                	je     800c46 <strcmp+0x1c>
  800c3a:	3a 02                	cmp    (%edx),%al
  800c3c:	75 08                	jne    800c46 <strcmp+0x1c>
		p++, q++;
  800c3e:	83 c1 01             	add    $0x1,%ecx
  800c41:	83 c2 01             	add    $0x1,%edx
  800c44:	eb ed                	jmp    800c33 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c46:	0f b6 c0             	movzbl %al,%eax
  800c49:	0f b6 12             	movzbl (%edx),%edx
  800c4c:	29 d0                	sub    %edx,%eax
}
  800c4e:	5d                   	pop    %ebp
  800c4f:	c3                   	ret    

00800c50 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800c50:	55                   	push   %ebp
  800c51:	89 e5                	mov    %esp,%ebp
  800c53:	53                   	push   %ebx
  800c54:	8b 45 08             	mov    0x8(%ebp),%eax
  800c57:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c5a:	89 c3                	mov    %eax,%ebx
  800c5c:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800c5f:	eb 06                	jmp    800c67 <strncmp+0x17>
		n--, p++, q++;
  800c61:	83 c0 01             	add    $0x1,%eax
  800c64:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800c67:	39 d8                	cmp    %ebx,%eax
  800c69:	74 16                	je     800c81 <strncmp+0x31>
  800c6b:	0f b6 08             	movzbl (%eax),%ecx
  800c6e:	84 c9                	test   %cl,%cl
  800c70:	74 04                	je     800c76 <strncmp+0x26>
  800c72:	3a 0a                	cmp    (%edx),%cl
  800c74:	74 eb                	je     800c61 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c76:	0f b6 00             	movzbl (%eax),%eax
  800c79:	0f b6 12             	movzbl (%edx),%edx
  800c7c:	29 d0                	sub    %edx,%eax
}
  800c7e:	5b                   	pop    %ebx
  800c7f:	5d                   	pop    %ebp
  800c80:	c3                   	ret    
		return 0;
  800c81:	b8 00 00 00 00       	mov    $0x0,%eax
  800c86:	eb f6                	jmp    800c7e <strncmp+0x2e>

00800c88 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c88:	55                   	push   %ebp
  800c89:	89 e5                	mov    %esp,%ebp
  800c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c92:	0f b6 10             	movzbl (%eax),%edx
  800c95:	84 d2                	test   %dl,%dl
  800c97:	74 09                	je     800ca2 <strchr+0x1a>
		if (*s == c)
  800c99:	38 ca                	cmp    %cl,%dl
  800c9b:	74 0a                	je     800ca7 <strchr+0x1f>
	for (; *s; s++)
  800c9d:	83 c0 01             	add    $0x1,%eax
  800ca0:	eb f0                	jmp    800c92 <strchr+0xa>
			return (char *) s;
	return 0;
  800ca2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ca7:	5d                   	pop    %ebp
  800ca8:	c3                   	ret    

00800ca9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ca9:	55                   	push   %ebp
  800caa:	89 e5                	mov    %esp,%ebp
  800cac:	8b 45 08             	mov    0x8(%ebp),%eax
  800caf:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800cb3:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800cb6:	38 ca                	cmp    %cl,%dl
  800cb8:	74 09                	je     800cc3 <strfind+0x1a>
  800cba:	84 d2                	test   %dl,%dl
  800cbc:	74 05                	je     800cc3 <strfind+0x1a>
	for (; *s; s++)
  800cbe:	83 c0 01             	add    $0x1,%eax
  800cc1:	eb f0                	jmp    800cb3 <strfind+0xa>
			break;
	return (char *) s;
}
  800cc3:	5d                   	pop    %ebp
  800cc4:	c3                   	ret    

00800cc5 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800cc5:	55                   	push   %ebp
  800cc6:	89 e5                	mov    %esp,%ebp
  800cc8:	57                   	push   %edi
  800cc9:	56                   	push   %esi
  800cca:	53                   	push   %ebx
  800ccb:	8b 7d 08             	mov    0x8(%ebp),%edi
  800cce:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800cd1:	85 c9                	test   %ecx,%ecx
  800cd3:	74 31                	je     800d06 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800cd5:	89 f8                	mov    %edi,%eax
  800cd7:	09 c8                	or     %ecx,%eax
  800cd9:	a8 03                	test   $0x3,%al
  800cdb:	75 23                	jne    800d00 <memset+0x3b>
		c &= 0xFF;
  800cdd:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ce1:	89 d3                	mov    %edx,%ebx
  800ce3:	c1 e3 08             	shl    $0x8,%ebx
  800ce6:	89 d0                	mov    %edx,%eax
  800ce8:	c1 e0 18             	shl    $0x18,%eax
  800ceb:	89 d6                	mov    %edx,%esi
  800ced:	c1 e6 10             	shl    $0x10,%esi
  800cf0:	09 f0                	or     %esi,%eax
  800cf2:	09 c2                	or     %eax,%edx
  800cf4:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800cf6:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800cf9:	89 d0                	mov    %edx,%eax
  800cfb:	fc                   	cld    
  800cfc:	f3 ab                	rep stos %eax,%es:(%edi)
  800cfe:	eb 06                	jmp    800d06 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d03:	fc                   	cld    
  800d04:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800d06:	89 f8                	mov    %edi,%eax
  800d08:	5b                   	pop    %ebx
  800d09:	5e                   	pop    %esi
  800d0a:	5f                   	pop    %edi
  800d0b:	5d                   	pop    %ebp
  800d0c:	c3                   	ret    

00800d0d <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800d0d:	55                   	push   %ebp
  800d0e:	89 e5                	mov    %esp,%ebp
  800d10:	57                   	push   %edi
  800d11:	56                   	push   %esi
  800d12:	8b 45 08             	mov    0x8(%ebp),%eax
  800d15:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d18:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d1b:	39 c6                	cmp    %eax,%esi
  800d1d:	73 32                	jae    800d51 <memmove+0x44>
  800d1f:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800d22:	39 c2                	cmp    %eax,%edx
  800d24:	76 2b                	jbe    800d51 <memmove+0x44>
		s += n;
		d += n;
  800d26:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d29:	89 fe                	mov    %edi,%esi
  800d2b:	09 ce                	or     %ecx,%esi
  800d2d:	09 d6                	or     %edx,%esi
  800d2f:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800d35:	75 0e                	jne    800d45 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800d37:	83 ef 04             	sub    $0x4,%edi
  800d3a:	8d 72 fc             	lea    -0x4(%edx),%esi
  800d3d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800d40:	fd                   	std    
  800d41:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d43:	eb 09                	jmp    800d4e <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800d45:	83 ef 01             	sub    $0x1,%edi
  800d48:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800d4b:	fd                   	std    
  800d4c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800d4e:	fc                   	cld    
  800d4f:	eb 1a                	jmp    800d6b <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d51:	89 c2                	mov    %eax,%edx
  800d53:	09 ca                	or     %ecx,%edx
  800d55:	09 f2                	or     %esi,%edx
  800d57:	f6 c2 03             	test   $0x3,%dl
  800d5a:	75 0a                	jne    800d66 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800d5c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800d5f:	89 c7                	mov    %eax,%edi
  800d61:	fc                   	cld    
  800d62:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d64:	eb 05                	jmp    800d6b <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800d66:	89 c7                	mov    %eax,%edi
  800d68:	fc                   	cld    
  800d69:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800d6b:	5e                   	pop    %esi
  800d6c:	5f                   	pop    %edi
  800d6d:	5d                   	pop    %ebp
  800d6e:	c3                   	ret    

00800d6f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800d6f:	55                   	push   %ebp
  800d70:	89 e5                	mov    %esp,%ebp
  800d72:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800d75:	ff 75 10             	pushl  0x10(%ebp)
  800d78:	ff 75 0c             	pushl  0xc(%ebp)
  800d7b:	ff 75 08             	pushl  0x8(%ebp)
  800d7e:	e8 8a ff ff ff       	call   800d0d <memmove>
}
  800d83:	c9                   	leave  
  800d84:	c3                   	ret    

00800d85 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800d85:	55                   	push   %ebp
  800d86:	89 e5                	mov    %esp,%ebp
  800d88:	56                   	push   %esi
  800d89:	53                   	push   %ebx
  800d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d90:	89 c6                	mov    %eax,%esi
  800d92:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d95:	39 f0                	cmp    %esi,%eax
  800d97:	74 1c                	je     800db5 <memcmp+0x30>
		if (*s1 != *s2)
  800d99:	0f b6 08             	movzbl (%eax),%ecx
  800d9c:	0f b6 1a             	movzbl (%edx),%ebx
  800d9f:	38 d9                	cmp    %bl,%cl
  800da1:	75 08                	jne    800dab <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800da3:	83 c0 01             	add    $0x1,%eax
  800da6:	83 c2 01             	add    $0x1,%edx
  800da9:	eb ea                	jmp    800d95 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800dab:	0f b6 c1             	movzbl %cl,%eax
  800dae:	0f b6 db             	movzbl %bl,%ebx
  800db1:	29 d8                	sub    %ebx,%eax
  800db3:	eb 05                	jmp    800dba <memcmp+0x35>
	}

	return 0;
  800db5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dba:	5b                   	pop    %ebx
  800dbb:	5e                   	pop    %esi
  800dbc:	5d                   	pop    %ebp
  800dbd:	c3                   	ret    

00800dbe <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800dbe:	55                   	push   %ebp
  800dbf:	89 e5                	mov    %esp,%ebp
  800dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800dc7:	89 c2                	mov    %eax,%edx
  800dc9:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800dcc:	39 d0                	cmp    %edx,%eax
  800dce:	73 09                	jae    800dd9 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800dd0:	38 08                	cmp    %cl,(%eax)
  800dd2:	74 05                	je     800dd9 <memfind+0x1b>
	for (; s < ends; s++)
  800dd4:	83 c0 01             	add    $0x1,%eax
  800dd7:	eb f3                	jmp    800dcc <memfind+0xe>
			break;
	return (void *) s;
}
  800dd9:	5d                   	pop    %ebp
  800dda:	c3                   	ret    

00800ddb <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ddb:	55                   	push   %ebp
  800ddc:	89 e5                	mov    %esp,%ebp
  800dde:	57                   	push   %edi
  800ddf:	56                   	push   %esi
  800de0:	53                   	push   %ebx
  800de1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800de4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800de7:	eb 03                	jmp    800dec <strtol+0x11>
		s++;
  800de9:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800dec:	0f b6 01             	movzbl (%ecx),%eax
  800def:	3c 20                	cmp    $0x20,%al
  800df1:	74 f6                	je     800de9 <strtol+0xe>
  800df3:	3c 09                	cmp    $0x9,%al
  800df5:	74 f2                	je     800de9 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800df7:	3c 2b                	cmp    $0x2b,%al
  800df9:	74 2a                	je     800e25 <strtol+0x4a>
	int neg = 0;
  800dfb:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800e00:	3c 2d                	cmp    $0x2d,%al
  800e02:	74 2b                	je     800e2f <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e04:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800e0a:	75 0f                	jne    800e1b <strtol+0x40>
  800e0c:	80 39 30             	cmpb   $0x30,(%ecx)
  800e0f:	74 28                	je     800e39 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800e11:	85 db                	test   %ebx,%ebx
  800e13:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e18:	0f 44 d8             	cmove  %eax,%ebx
  800e1b:	b8 00 00 00 00       	mov    $0x0,%eax
  800e20:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800e23:	eb 50                	jmp    800e75 <strtol+0x9a>
		s++;
  800e25:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800e28:	bf 00 00 00 00       	mov    $0x0,%edi
  800e2d:	eb d5                	jmp    800e04 <strtol+0x29>
		s++, neg = 1;
  800e2f:	83 c1 01             	add    $0x1,%ecx
  800e32:	bf 01 00 00 00       	mov    $0x1,%edi
  800e37:	eb cb                	jmp    800e04 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e39:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800e3d:	74 0e                	je     800e4d <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800e3f:	85 db                	test   %ebx,%ebx
  800e41:	75 d8                	jne    800e1b <strtol+0x40>
		s++, base = 8;
  800e43:	83 c1 01             	add    $0x1,%ecx
  800e46:	bb 08 00 00 00       	mov    $0x8,%ebx
  800e4b:	eb ce                	jmp    800e1b <strtol+0x40>
		s += 2, base = 16;
  800e4d:	83 c1 02             	add    $0x2,%ecx
  800e50:	bb 10 00 00 00       	mov    $0x10,%ebx
  800e55:	eb c4                	jmp    800e1b <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800e57:	8d 72 9f             	lea    -0x61(%edx),%esi
  800e5a:	89 f3                	mov    %esi,%ebx
  800e5c:	80 fb 19             	cmp    $0x19,%bl
  800e5f:	77 29                	ja     800e8a <strtol+0xaf>
			dig = *s - 'a' + 10;
  800e61:	0f be d2             	movsbl %dl,%edx
  800e64:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800e67:	3b 55 10             	cmp    0x10(%ebp),%edx
  800e6a:	7d 30                	jge    800e9c <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800e6c:	83 c1 01             	add    $0x1,%ecx
  800e6f:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e73:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800e75:	0f b6 11             	movzbl (%ecx),%edx
  800e78:	8d 72 d0             	lea    -0x30(%edx),%esi
  800e7b:	89 f3                	mov    %esi,%ebx
  800e7d:	80 fb 09             	cmp    $0x9,%bl
  800e80:	77 d5                	ja     800e57 <strtol+0x7c>
			dig = *s - '0';
  800e82:	0f be d2             	movsbl %dl,%edx
  800e85:	83 ea 30             	sub    $0x30,%edx
  800e88:	eb dd                	jmp    800e67 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800e8a:	8d 72 bf             	lea    -0x41(%edx),%esi
  800e8d:	89 f3                	mov    %esi,%ebx
  800e8f:	80 fb 19             	cmp    $0x19,%bl
  800e92:	77 08                	ja     800e9c <strtol+0xc1>
			dig = *s - 'A' + 10;
  800e94:	0f be d2             	movsbl %dl,%edx
  800e97:	83 ea 37             	sub    $0x37,%edx
  800e9a:	eb cb                	jmp    800e67 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800e9c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ea0:	74 05                	je     800ea7 <strtol+0xcc>
		*endptr = (char *) s;
  800ea2:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ea5:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ea7:	89 c2                	mov    %eax,%edx
  800ea9:	f7 da                	neg    %edx
  800eab:	85 ff                	test   %edi,%edi
  800ead:	0f 45 c2             	cmovne %edx,%eax
}
  800eb0:	5b                   	pop    %ebx
  800eb1:	5e                   	pop    %esi
  800eb2:	5f                   	pop    %edi
  800eb3:	5d                   	pop    %ebp
  800eb4:	c3                   	ret    
  800eb5:	66 90                	xchg   %ax,%ax
  800eb7:	66 90                	xchg   %ax,%ax
  800eb9:	66 90                	xchg   %ax,%ax
  800ebb:	66 90                	xchg   %ax,%ax
  800ebd:	66 90                	xchg   %ax,%ax
  800ebf:	90                   	nop

00800ec0 <__udivdi3>:
  800ec0:	55                   	push   %ebp
  800ec1:	57                   	push   %edi
  800ec2:	56                   	push   %esi
  800ec3:	53                   	push   %ebx
  800ec4:	83 ec 1c             	sub    $0x1c,%esp
  800ec7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800ecb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800ecf:	8b 74 24 34          	mov    0x34(%esp),%esi
  800ed3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800ed7:	85 d2                	test   %edx,%edx
  800ed9:	75 4d                	jne    800f28 <__udivdi3+0x68>
  800edb:	39 f3                	cmp    %esi,%ebx
  800edd:	76 19                	jbe    800ef8 <__udivdi3+0x38>
  800edf:	31 ff                	xor    %edi,%edi
  800ee1:	89 e8                	mov    %ebp,%eax
  800ee3:	89 f2                	mov    %esi,%edx
  800ee5:	f7 f3                	div    %ebx
  800ee7:	89 fa                	mov    %edi,%edx
  800ee9:	83 c4 1c             	add    $0x1c,%esp
  800eec:	5b                   	pop    %ebx
  800eed:	5e                   	pop    %esi
  800eee:	5f                   	pop    %edi
  800eef:	5d                   	pop    %ebp
  800ef0:	c3                   	ret    
  800ef1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800ef8:	89 d9                	mov    %ebx,%ecx
  800efa:	85 db                	test   %ebx,%ebx
  800efc:	75 0b                	jne    800f09 <__udivdi3+0x49>
  800efe:	b8 01 00 00 00       	mov    $0x1,%eax
  800f03:	31 d2                	xor    %edx,%edx
  800f05:	f7 f3                	div    %ebx
  800f07:	89 c1                	mov    %eax,%ecx
  800f09:	31 d2                	xor    %edx,%edx
  800f0b:	89 f0                	mov    %esi,%eax
  800f0d:	f7 f1                	div    %ecx
  800f0f:	89 c6                	mov    %eax,%esi
  800f11:	89 e8                	mov    %ebp,%eax
  800f13:	89 f7                	mov    %esi,%edi
  800f15:	f7 f1                	div    %ecx
  800f17:	89 fa                	mov    %edi,%edx
  800f19:	83 c4 1c             	add    $0x1c,%esp
  800f1c:	5b                   	pop    %ebx
  800f1d:	5e                   	pop    %esi
  800f1e:	5f                   	pop    %edi
  800f1f:	5d                   	pop    %ebp
  800f20:	c3                   	ret    
  800f21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f28:	39 f2                	cmp    %esi,%edx
  800f2a:	77 1c                	ja     800f48 <__udivdi3+0x88>
  800f2c:	0f bd fa             	bsr    %edx,%edi
  800f2f:	83 f7 1f             	xor    $0x1f,%edi
  800f32:	75 2c                	jne    800f60 <__udivdi3+0xa0>
  800f34:	39 f2                	cmp    %esi,%edx
  800f36:	72 06                	jb     800f3e <__udivdi3+0x7e>
  800f38:	31 c0                	xor    %eax,%eax
  800f3a:	39 eb                	cmp    %ebp,%ebx
  800f3c:	77 a9                	ja     800ee7 <__udivdi3+0x27>
  800f3e:	b8 01 00 00 00       	mov    $0x1,%eax
  800f43:	eb a2                	jmp    800ee7 <__udivdi3+0x27>
  800f45:	8d 76 00             	lea    0x0(%esi),%esi
  800f48:	31 ff                	xor    %edi,%edi
  800f4a:	31 c0                	xor    %eax,%eax
  800f4c:	89 fa                	mov    %edi,%edx
  800f4e:	83 c4 1c             	add    $0x1c,%esp
  800f51:	5b                   	pop    %ebx
  800f52:	5e                   	pop    %esi
  800f53:	5f                   	pop    %edi
  800f54:	5d                   	pop    %ebp
  800f55:	c3                   	ret    
  800f56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f5d:	8d 76 00             	lea    0x0(%esi),%esi
  800f60:	89 f9                	mov    %edi,%ecx
  800f62:	b8 20 00 00 00       	mov    $0x20,%eax
  800f67:	29 f8                	sub    %edi,%eax
  800f69:	d3 e2                	shl    %cl,%edx
  800f6b:	89 54 24 08          	mov    %edx,0x8(%esp)
  800f6f:	89 c1                	mov    %eax,%ecx
  800f71:	89 da                	mov    %ebx,%edx
  800f73:	d3 ea                	shr    %cl,%edx
  800f75:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800f79:	09 d1                	or     %edx,%ecx
  800f7b:	89 f2                	mov    %esi,%edx
  800f7d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800f81:	89 f9                	mov    %edi,%ecx
  800f83:	d3 e3                	shl    %cl,%ebx
  800f85:	89 c1                	mov    %eax,%ecx
  800f87:	d3 ea                	shr    %cl,%edx
  800f89:	89 f9                	mov    %edi,%ecx
  800f8b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800f8f:	89 eb                	mov    %ebp,%ebx
  800f91:	d3 e6                	shl    %cl,%esi
  800f93:	89 c1                	mov    %eax,%ecx
  800f95:	d3 eb                	shr    %cl,%ebx
  800f97:	09 de                	or     %ebx,%esi
  800f99:	89 f0                	mov    %esi,%eax
  800f9b:	f7 74 24 08          	divl   0x8(%esp)
  800f9f:	89 d6                	mov    %edx,%esi
  800fa1:	89 c3                	mov    %eax,%ebx
  800fa3:	f7 64 24 0c          	mull   0xc(%esp)
  800fa7:	39 d6                	cmp    %edx,%esi
  800fa9:	72 15                	jb     800fc0 <__udivdi3+0x100>
  800fab:	89 f9                	mov    %edi,%ecx
  800fad:	d3 e5                	shl    %cl,%ebp
  800faf:	39 c5                	cmp    %eax,%ebp
  800fb1:	73 04                	jae    800fb7 <__udivdi3+0xf7>
  800fb3:	39 d6                	cmp    %edx,%esi
  800fb5:	74 09                	je     800fc0 <__udivdi3+0x100>
  800fb7:	89 d8                	mov    %ebx,%eax
  800fb9:	31 ff                	xor    %edi,%edi
  800fbb:	e9 27 ff ff ff       	jmp    800ee7 <__udivdi3+0x27>
  800fc0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800fc3:	31 ff                	xor    %edi,%edi
  800fc5:	e9 1d ff ff ff       	jmp    800ee7 <__udivdi3+0x27>
  800fca:	66 90                	xchg   %ax,%ax
  800fcc:	66 90                	xchg   %ax,%ax
  800fce:	66 90                	xchg   %ax,%ax

00800fd0 <__umoddi3>:
  800fd0:	55                   	push   %ebp
  800fd1:	57                   	push   %edi
  800fd2:	56                   	push   %esi
  800fd3:	53                   	push   %ebx
  800fd4:	83 ec 1c             	sub    $0x1c,%esp
  800fd7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800fdb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  800fdf:	8b 74 24 30          	mov    0x30(%esp),%esi
  800fe3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  800fe7:	89 da                	mov    %ebx,%edx
  800fe9:	85 c0                	test   %eax,%eax
  800feb:	75 43                	jne    801030 <__umoddi3+0x60>
  800fed:	39 df                	cmp    %ebx,%edi
  800fef:	76 17                	jbe    801008 <__umoddi3+0x38>
  800ff1:	89 f0                	mov    %esi,%eax
  800ff3:	f7 f7                	div    %edi
  800ff5:	89 d0                	mov    %edx,%eax
  800ff7:	31 d2                	xor    %edx,%edx
  800ff9:	83 c4 1c             	add    $0x1c,%esp
  800ffc:	5b                   	pop    %ebx
  800ffd:	5e                   	pop    %esi
  800ffe:	5f                   	pop    %edi
  800fff:	5d                   	pop    %ebp
  801000:	c3                   	ret    
  801001:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801008:	89 fd                	mov    %edi,%ebp
  80100a:	85 ff                	test   %edi,%edi
  80100c:	75 0b                	jne    801019 <__umoddi3+0x49>
  80100e:	b8 01 00 00 00       	mov    $0x1,%eax
  801013:	31 d2                	xor    %edx,%edx
  801015:	f7 f7                	div    %edi
  801017:	89 c5                	mov    %eax,%ebp
  801019:	89 d8                	mov    %ebx,%eax
  80101b:	31 d2                	xor    %edx,%edx
  80101d:	f7 f5                	div    %ebp
  80101f:	89 f0                	mov    %esi,%eax
  801021:	f7 f5                	div    %ebp
  801023:	89 d0                	mov    %edx,%eax
  801025:	eb d0                	jmp    800ff7 <__umoddi3+0x27>
  801027:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80102e:	66 90                	xchg   %ax,%ax
  801030:	89 f1                	mov    %esi,%ecx
  801032:	39 d8                	cmp    %ebx,%eax
  801034:	76 0a                	jbe    801040 <__umoddi3+0x70>
  801036:	89 f0                	mov    %esi,%eax
  801038:	83 c4 1c             	add    $0x1c,%esp
  80103b:	5b                   	pop    %ebx
  80103c:	5e                   	pop    %esi
  80103d:	5f                   	pop    %edi
  80103e:	5d                   	pop    %ebp
  80103f:	c3                   	ret    
  801040:	0f bd e8             	bsr    %eax,%ebp
  801043:	83 f5 1f             	xor    $0x1f,%ebp
  801046:	75 20                	jne    801068 <__umoddi3+0x98>
  801048:	39 d8                	cmp    %ebx,%eax
  80104a:	0f 82 b0 00 00 00    	jb     801100 <__umoddi3+0x130>
  801050:	39 f7                	cmp    %esi,%edi
  801052:	0f 86 a8 00 00 00    	jbe    801100 <__umoddi3+0x130>
  801058:	89 c8                	mov    %ecx,%eax
  80105a:	83 c4 1c             	add    $0x1c,%esp
  80105d:	5b                   	pop    %ebx
  80105e:	5e                   	pop    %esi
  80105f:	5f                   	pop    %edi
  801060:	5d                   	pop    %ebp
  801061:	c3                   	ret    
  801062:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801068:	89 e9                	mov    %ebp,%ecx
  80106a:	ba 20 00 00 00       	mov    $0x20,%edx
  80106f:	29 ea                	sub    %ebp,%edx
  801071:	d3 e0                	shl    %cl,%eax
  801073:	89 44 24 08          	mov    %eax,0x8(%esp)
  801077:	89 d1                	mov    %edx,%ecx
  801079:	89 f8                	mov    %edi,%eax
  80107b:	d3 e8                	shr    %cl,%eax
  80107d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801081:	89 54 24 04          	mov    %edx,0x4(%esp)
  801085:	8b 54 24 04          	mov    0x4(%esp),%edx
  801089:	09 c1                	or     %eax,%ecx
  80108b:	89 d8                	mov    %ebx,%eax
  80108d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801091:	89 e9                	mov    %ebp,%ecx
  801093:	d3 e7                	shl    %cl,%edi
  801095:	89 d1                	mov    %edx,%ecx
  801097:	d3 e8                	shr    %cl,%eax
  801099:	89 e9                	mov    %ebp,%ecx
  80109b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80109f:	d3 e3                	shl    %cl,%ebx
  8010a1:	89 c7                	mov    %eax,%edi
  8010a3:	89 d1                	mov    %edx,%ecx
  8010a5:	89 f0                	mov    %esi,%eax
  8010a7:	d3 e8                	shr    %cl,%eax
  8010a9:	89 e9                	mov    %ebp,%ecx
  8010ab:	89 fa                	mov    %edi,%edx
  8010ad:	d3 e6                	shl    %cl,%esi
  8010af:	09 d8                	or     %ebx,%eax
  8010b1:	f7 74 24 08          	divl   0x8(%esp)
  8010b5:	89 d1                	mov    %edx,%ecx
  8010b7:	89 f3                	mov    %esi,%ebx
  8010b9:	f7 64 24 0c          	mull   0xc(%esp)
  8010bd:	89 c6                	mov    %eax,%esi
  8010bf:	89 d7                	mov    %edx,%edi
  8010c1:	39 d1                	cmp    %edx,%ecx
  8010c3:	72 06                	jb     8010cb <__umoddi3+0xfb>
  8010c5:	75 10                	jne    8010d7 <__umoddi3+0x107>
  8010c7:	39 c3                	cmp    %eax,%ebx
  8010c9:	73 0c                	jae    8010d7 <__umoddi3+0x107>
  8010cb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8010cf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8010d3:	89 d7                	mov    %edx,%edi
  8010d5:	89 c6                	mov    %eax,%esi
  8010d7:	89 ca                	mov    %ecx,%edx
  8010d9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8010de:	29 f3                	sub    %esi,%ebx
  8010e0:	19 fa                	sbb    %edi,%edx
  8010e2:	89 d0                	mov    %edx,%eax
  8010e4:	d3 e0                	shl    %cl,%eax
  8010e6:	89 e9                	mov    %ebp,%ecx
  8010e8:	d3 eb                	shr    %cl,%ebx
  8010ea:	d3 ea                	shr    %cl,%edx
  8010ec:	09 d8                	or     %ebx,%eax
  8010ee:	83 c4 1c             	add    $0x1c,%esp
  8010f1:	5b                   	pop    %ebx
  8010f2:	5e                   	pop    %esi
  8010f3:	5f                   	pop    %edi
  8010f4:	5d                   	pop    %ebp
  8010f5:	c3                   	ret    
  8010f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8010fd:	8d 76 00             	lea    0x0(%esi),%esi
  801100:	89 da                	mov    %ebx,%edx
  801102:	29 fe                	sub    %edi,%esi
  801104:	19 c2                	sbb    %eax,%edx
  801106:	89 f1                	mov    %esi,%ecx
  801108:	89 c8                	mov    %ecx,%eax
  80110a:	e9 4b ff ff ff       	jmp    80105a <__umoddi3+0x8a>
