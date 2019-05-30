
obj/user/faultnostack.debug:     file format elf32-i386


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
  80002c:	e8 23 00 00 00       	call   800054 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

void _pgfault_upcall();

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	sys_env_set_pgfault_upcall(0, (void*) _pgfault_upcall);
  800039:	68 9d 03 80 00       	push   $0x80039d
  80003e:	6a 00                	push   $0x0
  800040:	e8 71 02 00 00       	call   8002b6 <sys_env_set_pgfault_upcall>
	*(int*)0 = 0;
  800045:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80004c:	00 00 00 
}
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	c9                   	leave  
  800053:	c3                   	ret    

00800054 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800054:	55                   	push   %ebp
  800055:	89 e5                	mov    %esp,%ebp
  800057:	56                   	push   %esi
  800058:	53                   	push   %ebx
  800059:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80005c:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	// thisenv = 0;
	thisenv = &(envs[ENVX(sys_getenvid())]);
  80005f:	e8 c9 00 00 00       	call   80012d <sys_getenvid>
  800064:	25 ff 03 00 00       	and    $0x3ff,%eax
  800069:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80006f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800074:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800079:	85 db                	test   %ebx,%ebx
  80007b:	7e 07                	jle    800084 <libmain+0x30>
		binaryname = argv[0];
  80007d:	8b 06                	mov    (%esi),%eax
  80007f:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800084:	83 ec 08             	sub    $0x8,%esp
  800087:	56                   	push   %esi
  800088:	53                   	push   %ebx
  800089:	e8 a5 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80008e:	e8 0a 00 00 00       	call   80009d <exit>
}
  800093:	83 c4 10             	add    $0x10,%esp
  800096:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800099:	5b                   	pop    %ebx
  80009a:	5e                   	pop    %esi
  80009b:	5d                   	pop    %ebp
  80009c:	c3                   	ret    

0080009d <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80009d:	55                   	push   %ebp
  80009e:	89 e5                	mov    %esp,%ebp
  8000a0:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  8000a3:	6a 00                	push   $0x0
  8000a5:	e8 42 00 00 00       	call   8000ec <sys_env_destroy>
}
  8000aa:	83 c4 10             	add    $0x10,%esp
  8000ad:	c9                   	leave  
  8000ae:	c3                   	ret    

008000af <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000af:	55                   	push   %ebp
  8000b0:	89 e5                	mov    %esp,%ebp
  8000b2:	57                   	push   %edi
  8000b3:	56                   	push   %esi
  8000b4:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8000bd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000c0:	89 c3                	mov    %eax,%ebx
  8000c2:	89 c7                	mov    %eax,%edi
  8000c4:	89 c6                	mov    %eax,%esi
  8000c6:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000c8:	5b                   	pop    %ebx
  8000c9:	5e                   	pop    %esi
  8000ca:	5f                   	pop    %edi
  8000cb:	5d                   	pop    %ebp
  8000cc:	c3                   	ret    

008000cd <sys_cgetc>:

int
sys_cgetc(void)
{
  8000cd:	55                   	push   %ebp
  8000ce:	89 e5                	mov    %esp,%ebp
  8000d0:	57                   	push   %edi
  8000d1:	56                   	push   %esi
  8000d2:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8000d8:	b8 01 00 00 00       	mov    $0x1,%eax
  8000dd:	89 d1                	mov    %edx,%ecx
  8000df:	89 d3                	mov    %edx,%ebx
  8000e1:	89 d7                	mov    %edx,%edi
  8000e3:	89 d6                	mov    %edx,%esi
  8000e5:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000e7:	5b                   	pop    %ebx
  8000e8:	5e                   	pop    %esi
  8000e9:	5f                   	pop    %edi
  8000ea:	5d                   	pop    %ebp
  8000eb:	c3                   	ret    

008000ec <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000ec:	55                   	push   %ebp
  8000ed:	89 e5                	mov    %esp,%ebp
  8000ef:	57                   	push   %edi
  8000f0:	56                   	push   %esi
  8000f1:	53                   	push   %ebx
  8000f2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000f5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8000fd:	b8 03 00 00 00       	mov    $0x3,%eax
  800102:	89 cb                	mov    %ecx,%ebx
  800104:	89 cf                	mov    %ecx,%edi
  800106:	89 ce                	mov    %ecx,%esi
  800108:	cd 30                	int    $0x30
	if (check && ret > 0)
  80010a:	85 c0                	test   %eax,%eax
  80010c:	7f 08                	jg     800116 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80010e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800111:	5b                   	pop    %ebx
  800112:	5e                   	pop    %esi
  800113:	5f                   	pop    %edi
  800114:	5d                   	pop    %ebp
  800115:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800116:	83 ec 0c             	sub    $0xc,%esp
  800119:	50                   	push   %eax
  80011a:	6a 03                	push   $0x3
  80011c:	68 ca 11 80 00       	push   $0x8011ca
  800121:	6a 4c                	push   $0x4c
  800123:	68 e7 11 80 00       	push   $0x8011e7
  800128:	e8 96 02 00 00       	call   8003c3 <_panic>

0080012d <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80012d:	55                   	push   %ebp
  80012e:	89 e5                	mov    %esp,%ebp
  800130:	57                   	push   %edi
  800131:	56                   	push   %esi
  800132:	53                   	push   %ebx
	asm volatile("int %1\n"
  800133:	ba 00 00 00 00       	mov    $0x0,%edx
  800138:	b8 02 00 00 00       	mov    $0x2,%eax
  80013d:	89 d1                	mov    %edx,%ecx
  80013f:	89 d3                	mov    %edx,%ebx
  800141:	89 d7                	mov    %edx,%edi
  800143:	89 d6                	mov    %edx,%esi
  800145:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800147:	5b                   	pop    %ebx
  800148:	5e                   	pop    %esi
  800149:	5f                   	pop    %edi
  80014a:	5d                   	pop    %ebp
  80014b:	c3                   	ret    

0080014c <sys_yield>:

void
sys_yield(void)
{
  80014c:	55                   	push   %ebp
  80014d:	89 e5                	mov    %esp,%ebp
  80014f:	57                   	push   %edi
  800150:	56                   	push   %esi
  800151:	53                   	push   %ebx
	asm volatile("int %1\n"
  800152:	ba 00 00 00 00       	mov    $0x0,%edx
  800157:	b8 0b 00 00 00       	mov    $0xb,%eax
  80015c:	89 d1                	mov    %edx,%ecx
  80015e:	89 d3                	mov    %edx,%ebx
  800160:	89 d7                	mov    %edx,%edi
  800162:	89 d6                	mov    %edx,%esi
  800164:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800166:	5b                   	pop    %ebx
  800167:	5e                   	pop    %esi
  800168:	5f                   	pop    %edi
  800169:	5d                   	pop    %ebp
  80016a:	c3                   	ret    

0080016b <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80016b:	55                   	push   %ebp
  80016c:	89 e5                	mov    %esp,%ebp
  80016e:	57                   	push   %edi
  80016f:	56                   	push   %esi
  800170:	53                   	push   %ebx
  800171:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800174:	be 00 00 00 00       	mov    $0x0,%esi
  800179:	8b 55 08             	mov    0x8(%ebp),%edx
  80017c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80017f:	b8 04 00 00 00       	mov    $0x4,%eax
  800184:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800187:	89 f7                	mov    %esi,%edi
  800189:	cd 30                	int    $0x30
	if (check && ret > 0)
  80018b:	85 c0                	test   %eax,%eax
  80018d:	7f 08                	jg     800197 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80018f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800192:	5b                   	pop    %ebx
  800193:	5e                   	pop    %esi
  800194:	5f                   	pop    %edi
  800195:	5d                   	pop    %ebp
  800196:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800197:	83 ec 0c             	sub    $0xc,%esp
  80019a:	50                   	push   %eax
  80019b:	6a 04                	push   $0x4
  80019d:	68 ca 11 80 00       	push   $0x8011ca
  8001a2:	6a 4c                	push   $0x4c
  8001a4:	68 e7 11 80 00       	push   $0x8011e7
  8001a9:	e8 15 02 00 00       	call   8003c3 <_panic>

008001ae <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001ae:	55                   	push   %ebp
  8001af:	89 e5                	mov    %esp,%ebp
  8001b1:	57                   	push   %edi
  8001b2:	56                   	push   %esi
  8001b3:	53                   	push   %ebx
  8001b4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8001ba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001bd:	b8 05 00 00 00       	mov    $0x5,%eax
  8001c2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001c5:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001c8:	8b 75 18             	mov    0x18(%ebp),%esi
  8001cb:	cd 30                	int    $0x30
	if (check && ret > 0)
  8001cd:	85 c0                	test   %eax,%eax
  8001cf:	7f 08                	jg     8001d9 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001d4:	5b                   	pop    %ebx
  8001d5:	5e                   	pop    %esi
  8001d6:	5f                   	pop    %edi
  8001d7:	5d                   	pop    %ebp
  8001d8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001d9:	83 ec 0c             	sub    $0xc,%esp
  8001dc:	50                   	push   %eax
  8001dd:	6a 05                	push   $0x5
  8001df:	68 ca 11 80 00       	push   $0x8011ca
  8001e4:	6a 4c                	push   $0x4c
  8001e6:	68 e7 11 80 00       	push   $0x8011e7
  8001eb:	e8 d3 01 00 00       	call   8003c3 <_panic>

008001f0 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001f0:	55                   	push   %ebp
  8001f1:	89 e5                	mov    %esp,%ebp
  8001f3:	57                   	push   %edi
  8001f4:	56                   	push   %esi
  8001f5:	53                   	push   %ebx
  8001f6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001f9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001fe:	8b 55 08             	mov    0x8(%ebp),%edx
  800201:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800204:	b8 06 00 00 00       	mov    $0x6,%eax
  800209:	89 df                	mov    %ebx,%edi
  80020b:	89 de                	mov    %ebx,%esi
  80020d:	cd 30                	int    $0x30
	if (check && ret > 0)
  80020f:	85 c0                	test   %eax,%eax
  800211:	7f 08                	jg     80021b <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800213:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800216:	5b                   	pop    %ebx
  800217:	5e                   	pop    %esi
  800218:	5f                   	pop    %edi
  800219:	5d                   	pop    %ebp
  80021a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80021b:	83 ec 0c             	sub    $0xc,%esp
  80021e:	50                   	push   %eax
  80021f:	6a 06                	push   $0x6
  800221:	68 ca 11 80 00       	push   $0x8011ca
  800226:	6a 4c                	push   $0x4c
  800228:	68 e7 11 80 00       	push   $0x8011e7
  80022d:	e8 91 01 00 00       	call   8003c3 <_panic>

00800232 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800232:	55                   	push   %ebp
  800233:	89 e5                	mov    %esp,%ebp
  800235:	57                   	push   %edi
  800236:	56                   	push   %esi
  800237:	53                   	push   %ebx
  800238:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80023b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800240:	8b 55 08             	mov    0x8(%ebp),%edx
  800243:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800246:	b8 08 00 00 00       	mov    $0x8,%eax
  80024b:	89 df                	mov    %ebx,%edi
  80024d:	89 de                	mov    %ebx,%esi
  80024f:	cd 30                	int    $0x30
	if (check && ret > 0)
  800251:	85 c0                	test   %eax,%eax
  800253:	7f 08                	jg     80025d <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800255:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800258:	5b                   	pop    %ebx
  800259:	5e                   	pop    %esi
  80025a:	5f                   	pop    %edi
  80025b:	5d                   	pop    %ebp
  80025c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80025d:	83 ec 0c             	sub    $0xc,%esp
  800260:	50                   	push   %eax
  800261:	6a 08                	push   $0x8
  800263:	68 ca 11 80 00       	push   $0x8011ca
  800268:	6a 4c                	push   $0x4c
  80026a:	68 e7 11 80 00       	push   $0x8011e7
  80026f:	e8 4f 01 00 00       	call   8003c3 <_panic>

00800274 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800274:	55                   	push   %ebp
  800275:	89 e5                	mov    %esp,%ebp
  800277:	57                   	push   %edi
  800278:	56                   	push   %esi
  800279:	53                   	push   %ebx
  80027a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80027d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800282:	8b 55 08             	mov    0x8(%ebp),%edx
  800285:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800288:	b8 09 00 00 00       	mov    $0x9,%eax
  80028d:	89 df                	mov    %ebx,%edi
  80028f:	89 de                	mov    %ebx,%esi
  800291:	cd 30                	int    $0x30
	if (check && ret > 0)
  800293:	85 c0                	test   %eax,%eax
  800295:	7f 08                	jg     80029f <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800297:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80029a:	5b                   	pop    %ebx
  80029b:	5e                   	pop    %esi
  80029c:	5f                   	pop    %edi
  80029d:	5d                   	pop    %ebp
  80029e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80029f:	83 ec 0c             	sub    $0xc,%esp
  8002a2:	50                   	push   %eax
  8002a3:	6a 09                	push   $0x9
  8002a5:	68 ca 11 80 00       	push   $0x8011ca
  8002aa:	6a 4c                	push   $0x4c
  8002ac:	68 e7 11 80 00       	push   $0x8011e7
  8002b1:	e8 0d 01 00 00       	call   8003c3 <_panic>

008002b6 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002b6:	55                   	push   %ebp
  8002b7:	89 e5                	mov    %esp,%ebp
  8002b9:	57                   	push   %edi
  8002ba:	56                   	push   %esi
  8002bb:	53                   	push   %ebx
  8002bc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002bf:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8002c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002ca:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002cf:	89 df                	mov    %ebx,%edi
  8002d1:	89 de                	mov    %ebx,%esi
  8002d3:	cd 30                	int    $0x30
	if (check && ret > 0)
  8002d5:	85 c0                	test   %eax,%eax
  8002d7:	7f 08                	jg     8002e1 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002dc:	5b                   	pop    %ebx
  8002dd:	5e                   	pop    %esi
  8002de:	5f                   	pop    %edi
  8002df:	5d                   	pop    %ebp
  8002e0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002e1:	83 ec 0c             	sub    $0xc,%esp
  8002e4:	50                   	push   %eax
  8002e5:	6a 0a                	push   $0xa
  8002e7:	68 ca 11 80 00       	push   $0x8011ca
  8002ec:	6a 4c                	push   $0x4c
  8002ee:	68 e7 11 80 00       	push   $0x8011e7
  8002f3:	e8 cb 00 00 00       	call   8003c3 <_panic>

008002f8 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002f8:	55                   	push   %ebp
  8002f9:	89 e5                	mov    %esp,%ebp
  8002fb:	57                   	push   %edi
  8002fc:	56                   	push   %esi
  8002fd:	53                   	push   %ebx
	asm volatile("int %1\n"
  8002fe:	8b 55 08             	mov    0x8(%ebp),%edx
  800301:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800304:	b8 0c 00 00 00       	mov    $0xc,%eax
  800309:	be 00 00 00 00       	mov    $0x0,%esi
  80030e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800311:	8b 7d 14             	mov    0x14(%ebp),%edi
  800314:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800316:	5b                   	pop    %ebx
  800317:	5e                   	pop    %esi
  800318:	5f                   	pop    %edi
  800319:	5d                   	pop    %ebp
  80031a:	c3                   	ret    

0080031b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80031b:	55                   	push   %ebp
  80031c:	89 e5                	mov    %esp,%ebp
  80031e:	57                   	push   %edi
  80031f:	56                   	push   %esi
  800320:	53                   	push   %ebx
  800321:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800324:	b9 00 00 00 00       	mov    $0x0,%ecx
  800329:	8b 55 08             	mov    0x8(%ebp),%edx
  80032c:	b8 0d 00 00 00       	mov    $0xd,%eax
  800331:	89 cb                	mov    %ecx,%ebx
  800333:	89 cf                	mov    %ecx,%edi
  800335:	89 ce                	mov    %ecx,%esi
  800337:	cd 30                	int    $0x30
	if (check && ret > 0)
  800339:	85 c0                	test   %eax,%eax
  80033b:	7f 08                	jg     800345 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80033d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800340:	5b                   	pop    %ebx
  800341:	5e                   	pop    %esi
  800342:	5f                   	pop    %edi
  800343:	5d                   	pop    %ebp
  800344:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800345:	83 ec 0c             	sub    $0xc,%esp
  800348:	50                   	push   %eax
  800349:	6a 0d                	push   $0xd
  80034b:	68 ca 11 80 00       	push   $0x8011ca
  800350:	6a 4c                	push   $0x4c
  800352:	68 e7 11 80 00       	push   $0x8011e7
  800357:	e8 67 00 00 00       	call   8003c3 <_panic>

0080035c <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  80035c:	55                   	push   %ebp
  80035d:	89 e5                	mov    %esp,%ebp
  80035f:	57                   	push   %edi
  800360:	56                   	push   %esi
  800361:	53                   	push   %ebx
	asm volatile("int %1\n"
  800362:	bb 00 00 00 00       	mov    $0x0,%ebx
  800367:	8b 55 08             	mov    0x8(%ebp),%edx
  80036a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80036d:	b8 0e 00 00 00       	mov    $0xe,%eax
  800372:	89 df                	mov    %ebx,%edi
  800374:	89 de                	mov    %ebx,%esi
  800376:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800378:	5b                   	pop    %ebx
  800379:	5e                   	pop    %esi
  80037a:	5f                   	pop    %edi
  80037b:	5d                   	pop    %ebp
  80037c:	c3                   	ret    

0080037d <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  80037d:	55                   	push   %ebp
  80037e:	89 e5                	mov    %esp,%ebp
  800380:	57                   	push   %edi
  800381:	56                   	push   %esi
  800382:	53                   	push   %ebx
	asm volatile("int %1\n"
  800383:	b9 00 00 00 00       	mov    $0x0,%ecx
  800388:	8b 55 08             	mov    0x8(%ebp),%edx
  80038b:	b8 0f 00 00 00       	mov    $0xf,%eax
  800390:	89 cb                	mov    %ecx,%ebx
  800392:	89 cf                	mov    %ecx,%edi
  800394:	89 ce                	mov    %ecx,%esi
  800396:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800398:	5b                   	pop    %ebx
  800399:	5e                   	pop    %esi
  80039a:	5f                   	pop    %edi
  80039b:	5d                   	pop    %ebp
  80039c:	c3                   	ret    

0080039d <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80039d:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80039e:	a1 08 20 80 00       	mov    0x802008,%eax
	call *%eax
  8003a3:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8003a5:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %edi
  8003a8:	8b 7c 24 28          	mov    0x28(%esp),%edi
	movl 0x30(%esp), %esi
  8003ac:	8b 74 24 30          	mov    0x30(%esp),%esi
	subl $4, %esi
  8003b0:	83 ee 04             	sub    $0x4,%esi
	movl %edi, (%esi)
  8003b3:	89 3e                	mov    %edi,(%esi)
	movl %esi, 0x30(%esp)
  8003b5:	89 74 24 30          	mov    %esi,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  8003b9:	83 c4 08             	add    $0x8,%esp
	popal
  8003bc:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8003bd:	83 c4 04             	add    $0x4,%esp
	popfl
  8003c0:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8003c1:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  8003c2:	c3                   	ret    

008003c3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8003c3:	55                   	push   %ebp
  8003c4:	89 e5                	mov    %esp,%ebp
  8003c6:	56                   	push   %esi
  8003c7:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8003c8:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8003cb:	8b 35 00 20 80 00    	mov    0x802000,%esi
  8003d1:	e8 57 fd ff ff       	call   80012d <sys_getenvid>
  8003d6:	83 ec 0c             	sub    $0xc,%esp
  8003d9:	ff 75 0c             	pushl  0xc(%ebp)
  8003dc:	ff 75 08             	pushl  0x8(%ebp)
  8003df:	56                   	push   %esi
  8003e0:	50                   	push   %eax
  8003e1:	68 f8 11 80 00       	push   $0x8011f8
  8003e6:	e8 b3 00 00 00       	call   80049e <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8003eb:	83 c4 18             	add    $0x18,%esp
  8003ee:	53                   	push   %ebx
  8003ef:	ff 75 10             	pushl  0x10(%ebp)
  8003f2:	e8 56 00 00 00       	call   80044d <vcprintf>
	cprintf("\n");
  8003f7:	c7 04 24 1b 12 80 00 	movl   $0x80121b,(%esp)
  8003fe:	e8 9b 00 00 00       	call   80049e <cprintf>
  800403:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800406:	cc                   	int3   
  800407:	eb fd                	jmp    800406 <_panic+0x43>

00800409 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800409:	55                   	push   %ebp
  80040a:	89 e5                	mov    %esp,%ebp
  80040c:	53                   	push   %ebx
  80040d:	83 ec 04             	sub    $0x4,%esp
  800410:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800413:	8b 13                	mov    (%ebx),%edx
  800415:	8d 42 01             	lea    0x1(%edx),%eax
  800418:	89 03                	mov    %eax,(%ebx)
  80041a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80041d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800421:	3d ff 00 00 00       	cmp    $0xff,%eax
  800426:	74 09                	je     800431 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800428:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80042c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80042f:	c9                   	leave  
  800430:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800431:	83 ec 08             	sub    $0x8,%esp
  800434:	68 ff 00 00 00       	push   $0xff
  800439:	8d 43 08             	lea    0x8(%ebx),%eax
  80043c:	50                   	push   %eax
  80043d:	e8 6d fc ff ff       	call   8000af <sys_cputs>
		b->idx = 0;
  800442:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800448:	83 c4 10             	add    $0x10,%esp
  80044b:	eb db                	jmp    800428 <putch+0x1f>

0080044d <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80044d:	55                   	push   %ebp
  80044e:	89 e5                	mov    %esp,%ebp
  800450:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800456:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80045d:	00 00 00 
	b.cnt = 0;
  800460:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800467:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80046a:	ff 75 0c             	pushl  0xc(%ebp)
  80046d:	ff 75 08             	pushl  0x8(%ebp)
  800470:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800476:	50                   	push   %eax
  800477:	68 09 04 80 00       	push   $0x800409
  80047c:	e8 4a 01 00 00       	call   8005cb <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800481:	83 c4 08             	add    $0x8,%esp
  800484:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80048a:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800490:	50                   	push   %eax
  800491:	e8 19 fc ff ff       	call   8000af <sys_cputs>

	return b.cnt;
}
  800496:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80049c:	c9                   	leave  
  80049d:	c3                   	ret    

0080049e <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80049e:	55                   	push   %ebp
  80049f:	89 e5                	mov    %esp,%ebp
  8004a1:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8004a4:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8004a7:	50                   	push   %eax
  8004a8:	ff 75 08             	pushl  0x8(%ebp)
  8004ab:	e8 9d ff ff ff       	call   80044d <vcprintf>
	va_end(ap);

	return cnt;
}
  8004b0:	c9                   	leave  
  8004b1:	c3                   	ret    

008004b2 <printnum>:


static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004b2:	55                   	push   %ebp
  8004b3:	89 e5                	mov    %esp,%ebp
  8004b5:	57                   	push   %edi
  8004b6:	56                   	push   %esi
  8004b7:	53                   	push   %ebx
  8004b8:	83 ec 1c             	sub    $0x1c,%esp
  8004bb:	89 c6                	mov    %eax,%esi
  8004bd:	89 d7                	mov    %edx,%edi
  8004bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004c8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8004cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8004ce:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	// to support '-'
	if(padc == '-'){
  8004d1:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8004d5:	74 2c                	je     800503 <printnum+0x51>
		while (--width > 0)
			putch(' ', putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004d7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004da:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8004e1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004e4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8004e7:	39 c2                	cmp    %eax,%edx
  8004e9:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8004ec:	73 43                	jae    800531 <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004ee:	83 eb 01             	sub    $0x1,%ebx
  8004f1:	85 db                	test   %ebx,%ebx
  8004f3:	7e 6c                	jle    800561 <printnum+0xaf>
			putch(padc, putdat);
  8004f5:	83 ec 08             	sub    $0x8,%esp
  8004f8:	57                   	push   %edi
  8004f9:	ff 75 18             	pushl  0x18(%ebp)
  8004fc:	ff d6                	call   *%esi
  8004fe:	83 c4 10             	add    $0x10,%esp
  800501:	eb eb                	jmp    8004ee <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800503:	83 ec 0c             	sub    $0xc,%esp
  800506:	6a 20                	push   $0x20
  800508:	6a 00                	push   $0x0
  80050a:	50                   	push   %eax
  80050b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80050e:	ff 75 e0             	pushl  -0x20(%ebp)
  800511:	89 fa                	mov    %edi,%edx
  800513:	89 f0                	mov    %esi,%eax
  800515:	e8 98 ff ff ff       	call   8004b2 <printnum>
		while (--width > 0)
  80051a:	83 c4 20             	add    $0x20,%esp
  80051d:	83 eb 01             	sub    $0x1,%ebx
  800520:	85 db                	test   %ebx,%ebx
  800522:	7e 65                	jle    800589 <printnum+0xd7>
			putch(' ', putdat);
  800524:	83 ec 08             	sub    $0x8,%esp
  800527:	57                   	push   %edi
  800528:	6a 20                	push   $0x20
  80052a:	ff d6                	call   *%esi
  80052c:	83 c4 10             	add    $0x10,%esp
  80052f:	eb ec                	jmp    80051d <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800531:	83 ec 0c             	sub    $0xc,%esp
  800534:	ff 75 18             	pushl  0x18(%ebp)
  800537:	83 eb 01             	sub    $0x1,%ebx
  80053a:	53                   	push   %ebx
  80053b:	50                   	push   %eax
  80053c:	83 ec 08             	sub    $0x8,%esp
  80053f:	ff 75 dc             	pushl  -0x24(%ebp)
  800542:	ff 75 d8             	pushl  -0x28(%ebp)
  800545:	ff 75 e4             	pushl  -0x1c(%ebp)
  800548:	ff 75 e0             	pushl  -0x20(%ebp)
  80054b:	e8 20 0a 00 00       	call   800f70 <__udivdi3>
  800550:	83 c4 18             	add    $0x18,%esp
  800553:	52                   	push   %edx
  800554:	50                   	push   %eax
  800555:	89 fa                	mov    %edi,%edx
  800557:	89 f0                	mov    %esi,%eax
  800559:	e8 54 ff ff ff       	call   8004b2 <printnum>
  80055e:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800561:	83 ec 08             	sub    $0x8,%esp
  800564:	57                   	push   %edi
  800565:	83 ec 04             	sub    $0x4,%esp
  800568:	ff 75 dc             	pushl  -0x24(%ebp)
  80056b:	ff 75 d8             	pushl  -0x28(%ebp)
  80056e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800571:	ff 75 e0             	pushl  -0x20(%ebp)
  800574:	e8 07 0b 00 00       	call   801080 <__umoddi3>
  800579:	83 c4 14             	add    $0x14,%esp
  80057c:	0f be 80 1d 12 80 00 	movsbl 0x80121d(%eax),%eax
  800583:	50                   	push   %eax
  800584:	ff d6                	call   *%esi
  800586:	83 c4 10             	add    $0x10,%esp
}
  800589:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80058c:	5b                   	pop    %ebx
  80058d:	5e                   	pop    %esi
  80058e:	5f                   	pop    %edi
  80058f:	5d                   	pop    %ebp
  800590:	c3                   	ret    

00800591 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800591:	55                   	push   %ebp
  800592:	89 e5                	mov    %esp,%ebp
  800594:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800597:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80059b:	8b 10                	mov    (%eax),%edx
  80059d:	3b 50 04             	cmp    0x4(%eax),%edx
  8005a0:	73 0a                	jae    8005ac <sprintputch+0x1b>
		*b->buf++ = ch;
  8005a2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8005a5:	89 08                	mov    %ecx,(%eax)
  8005a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005aa:	88 02                	mov    %al,(%edx)
}
  8005ac:	5d                   	pop    %ebp
  8005ad:	c3                   	ret    

008005ae <printfmt>:
{
  8005ae:	55                   	push   %ebp
  8005af:	89 e5                	mov    %esp,%ebp
  8005b1:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8005b4:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8005b7:	50                   	push   %eax
  8005b8:	ff 75 10             	pushl  0x10(%ebp)
  8005bb:	ff 75 0c             	pushl  0xc(%ebp)
  8005be:	ff 75 08             	pushl  0x8(%ebp)
  8005c1:	e8 05 00 00 00       	call   8005cb <vprintfmt>
}
  8005c6:	83 c4 10             	add    $0x10,%esp
  8005c9:	c9                   	leave  
  8005ca:	c3                   	ret    

008005cb <vprintfmt>:
{
  8005cb:	55                   	push   %ebp
  8005cc:	89 e5                	mov    %esp,%ebp
  8005ce:	57                   	push   %edi
  8005cf:	56                   	push   %esi
  8005d0:	53                   	push   %ebx
  8005d1:	83 ec 3c             	sub    $0x3c,%esp
  8005d4:	8b 75 08             	mov    0x8(%ebp),%esi
  8005d7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8005da:	8b 7d 10             	mov    0x10(%ebp),%edi
  8005dd:	e9 1e 04 00 00       	jmp    800a00 <vprintfmt+0x435>
		posflag = 0;
  8005e2:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
		padc = ' ';
  8005e9:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8005ed:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8005f4:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8005fb:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800602:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  800609:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80060e:	8d 47 01             	lea    0x1(%edi),%eax
  800611:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800614:	0f b6 17             	movzbl (%edi),%edx
  800617:	8d 42 dd             	lea    -0x23(%edx),%eax
  80061a:	3c 55                	cmp    $0x55,%al
  80061c:	0f 87 d9 04 00 00    	ja     800afb <vprintfmt+0x530>
  800622:	0f b6 c0             	movzbl %al,%eax
  800625:	ff 24 85 00 14 80 00 	jmp    *0x801400(,%eax,4)
  80062c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80062f:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800633:	eb d9                	jmp    80060e <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800635:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posflag = 1;
  800638:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  80063f:	eb cd                	jmp    80060e <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800641:	0f b6 d2             	movzbl %dl,%edx
  800644:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800647:	b8 00 00 00 00       	mov    $0x0,%eax
  80064c:	89 75 08             	mov    %esi,0x8(%ebp)
  80064f:	eb 0c                	jmp    80065d <vprintfmt+0x92>
		switch (ch = *(unsigned char *) fmt++) {
  800651:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800654:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  800658:	eb b4                	jmp    80060e <vprintfmt+0x43>
			for (precision = 0; ; ++fmt) {
  80065a:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80065d:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800660:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800664:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800667:	8d 72 d0             	lea    -0x30(%edx),%esi
  80066a:	83 fe 09             	cmp    $0x9,%esi
  80066d:	76 eb                	jbe    80065a <vprintfmt+0x8f>
  80066f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800672:	8b 75 08             	mov    0x8(%ebp),%esi
  800675:	eb 14                	jmp    80068b <vprintfmt+0xc0>
			precision = va_arg(ap, int);
  800677:	8b 45 14             	mov    0x14(%ebp),%eax
  80067a:	8b 00                	mov    (%eax),%eax
  80067c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80067f:	8b 45 14             	mov    0x14(%ebp),%eax
  800682:	8d 40 04             	lea    0x4(%eax),%eax
  800685:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800688:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80068b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80068f:	0f 89 79 ff ff ff    	jns    80060e <vprintfmt+0x43>
				width = precision, precision = -1;
  800695:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800698:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80069b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8006a2:	e9 67 ff ff ff       	jmp    80060e <vprintfmt+0x43>
  8006a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006aa:	85 c0                	test   %eax,%eax
  8006ac:	0f 48 c1             	cmovs  %ecx,%eax
  8006af:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006b2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8006b5:	e9 54 ff ff ff       	jmp    80060e <vprintfmt+0x43>
  8006ba:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8006bd:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8006c4:	e9 45 ff ff ff       	jmp    80060e <vprintfmt+0x43>
			lflag++;
  8006c9:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006cd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8006d0:	e9 39 ff ff ff       	jmp    80060e <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8006d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d8:	8d 78 04             	lea    0x4(%eax),%edi
  8006db:	83 ec 08             	sub    $0x8,%esp
  8006de:	53                   	push   %ebx
  8006df:	ff 30                	pushl  (%eax)
  8006e1:	ff d6                	call   *%esi
			break;
  8006e3:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8006e6:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8006e9:	e9 0f 03 00 00       	jmp    8009fd <vprintfmt+0x432>
			err = va_arg(ap, int);
  8006ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f1:	8d 78 04             	lea    0x4(%eax),%edi
  8006f4:	8b 00                	mov    (%eax),%eax
  8006f6:	99                   	cltd   
  8006f7:	31 d0                	xor    %edx,%eax
  8006f9:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8006fb:	83 f8 0f             	cmp    $0xf,%eax
  8006fe:	7f 23                	jg     800723 <vprintfmt+0x158>
  800700:	8b 14 85 60 15 80 00 	mov    0x801560(,%eax,4),%edx
  800707:	85 d2                	test   %edx,%edx
  800709:	74 18                	je     800723 <vprintfmt+0x158>
				printfmt(putch, putdat, "%s", p);
  80070b:	52                   	push   %edx
  80070c:	68 3e 12 80 00       	push   $0x80123e
  800711:	53                   	push   %ebx
  800712:	56                   	push   %esi
  800713:	e8 96 fe ff ff       	call   8005ae <printfmt>
  800718:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80071b:	89 7d 14             	mov    %edi,0x14(%ebp)
  80071e:	e9 da 02 00 00       	jmp    8009fd <vprintfmt+0x432>
				printfmt(putch, putdat, "error %d", err);
  800723:	50                   	push   %eax
  800724:	68 35 12 80 00       	push   $0x801235
  800729:	53                   	push   %ebx
  80072a:	56                   	push   %esi
  80072b:	e8 7e fe ff ff       	call   8005ae <printfmt>
  800730:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800733:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800736:	e9 c2 02 00 00       	jmp    8009fd <vprintfmt+0x432>
			if ((p = va_arg(ap, char *)) == NULL)
  80073b:	8b 45 14             	mov    0x14(%ebp),%eax
  80073e:	83 c0 04             	add    $0x4,%eax
  800741:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800744:	8b 45 14             	mov    0x14(%ebp),%eax
  800747:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800749:	85 c9                	test   %ecx,%ecx
  80074b:	b8 2e 12 80 00       	mov    $0x80122e,%eax
  800750:	0f 45 c1             	cmovne %ecx,%eax
  800753:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800756:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80075a:	7e 06                	jle    800762 <vprintfmt+0x197>
  80075c:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800760:	75 0d                	jne    80076f <vprintfmt+0x1a4>
				for (width -= strnlen(p, precision); width > 0; width--)
  800762:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800765:	89 c7                	mov    %eax,%edi
  800767:	03 45 e0             	add    -0x20(%ebp),%eax
  80076a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80076d:	eb 53                	jmp    8007c2 <vprintfmt+0x1f7>
  80076f:	83 ec 08             	sub    $0x8,%esp
  800772:	ff 75 d8             	pushl  -0x28(%ebp)
  800775:	50                   	push   %eax
  800776:	e8 28 04 00 00       	call   800ba3 <strnlen>
  80077b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80077e:	29 c1                	sub    %eax,%ecx
  800780:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  800783:	83 c4 10             	add    $0x10,%esp
  800786:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800788:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80078c:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80078f:	eb 0f                	jmp    8007a0 <vprintfmt+0x1d5>
					putch(padc, putdat);
  800791:	83 ec 08             	sub    $0x8,%esp
  800794:	53                   	push   %ebx
  800795:	ff 75 e0             	pushl  -0x20(%ebp)
  800798:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80079a:	83 ef 01             	sub    $0x1,%edi
  80079d:	83 c4 10             	add    $0x10,%esp
  8007a0:	85 ff                	test   %edi,%edi
  8007a2:	7f ed                	jg     800791 <vprintfmt+0x1c6>
  8007a4:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  8007a7:	85 c9                	test   %ecx,%ecx
  8007a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8007ae:	0f 49 c1             	cmovns %ecx,%eax
  8007b1:	29 c1                	sub    %eax,%ecx
  8007b3:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8007b6:	eb aa                	jmp    800762 <vprintfmt+0x197>
					putch(ch, putdat);
  8007b8:	83 ec 08             	sub    $0x8,%esp
  8007bb:	53                   	push   %ebx
  8007bc:	52                   	push   %edx
  8007bd:	ff d6                	call   *%esi
  8007bf:	83 c4 10             	add    $0x10,%esp
  8007c2:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8007c5:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007c7:	83 c7 01             	add    $0x1,%edi
  8007ca:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007ce:	0f be d0             	movsbl %al,%edx
  8007d1:	85 d2                	test   %edx,%edx
  8007d3:	74 4b                	je     800820 <vprintfmt+0x255>
  8007d5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8007d9:	78 06                	js     8007e1 <vprintfmt+0x216>
  8007db:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8007df:	78 1e                	js     8007ff <vprintfmt+0x234>
				if (altflag && (ch < ' ' || ch > '~'))
  8007e1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8007e5:	74 d1                	je     8007b8 <vprintfmt+0x1ed>
  8007e7:	0f be c0             	movsbl %al,%eax
  8007ea:	83 e8 20             	sub    $0x20,%eax
  8007ed:	83 f8 5e             	cmp    $0x5e,%eax
  8007f0:	76 c6                	jbe    8007b8 <vprintfmt+0x1ed>
					putch('?', putdat);
  8007f2:	83 ec 08             	sub    $0x8,%esp
  8007f5:	53                   	push   %ebx
  8007f6:	6a 3f                	push   $0x3f
  8007f8:	ff d6                	call   *%esi
  8007fa:	83 c4 10             	add    $0x10,%esp
  8007fd:	eb c3                	jmp    8007c2 <vprintfmt+0x1f7>
  8007ff:	89 cf                	mov    %ecx,%edi
  800801:	eb 0e                	jmp    800811 <vprintfmt+0x246>
				putch(' ', putdat);
  800803:	83 ec 08             	sub    $0x8,%esp
  800806:	53                   	push   %ebx
  800807:	6a 20                	push   $0x20
  800809:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80080b:	83 ef 01             	sub    $0x1,%edi
  80080e:	83 c4 10             	add    $0x10,%esp
  800811:	85 ff                	test   %edi,%edi
  800813:	7f ee                	jg     800803 <vprintfmt+0x238>
			if ((p = va_arg(ap, char *)) == NULL)
  800815:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800818:	89 45 14             	mov    %eax,0x14(%ebp)
  80081b:	e9 dd 01 00 00       	jmp    8009fd <vprintfmt+0x432>
  800820:	89 cf                	mov    %ecx,%edi
  800822:	eb ed                	jmp    800811 <vprintfmt+0x246>
	if (lflag >= 2)
  800824:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800828:	7f 21                	jg     80084b <vprintfmt+0x280>
	else if (lflag)
  80082a:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80082e:	74 6a                	je     80089a <vprintfmt+0x2cf>
		return va_arg(*ap, long);
  800830:	8b 45 14             	mov    0x14(%ebp),%eax
  800833:	8b 00                	mov    (%eax),%eax
  800835:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800838:	89 c1                	mov    %eax,%ecx
  80083a:	c1 f9 1f             	sar    $0x1f,%ecx
  80083d:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800840:	8b 45 14             	mov    0x14(%ebp),%eax
  800843:	8d 40 04             	lea    0x4(%eax),%eax
  800846:	89 45 14             	mov    %eax,0x14(%ebp)
  800849:	eb 17                	jmp    800862 <vprintfmt+0x297>
		return va_arg(*ap, long long);
  80084b:	8b 45 14             	mov    0x14(%ebp),%eax
  80084e:	8b 50 04             	mov    0x4(%eax),%edx
  800851:	8b 00                	mov    (%eax),%eax
  800853:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800856:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800859:	8b 45 14             	mov    0x14(%ebp),%eax
  80085c:	8d 40 08             	lea    0x8(%eax),%eax
  80085f:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800862:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  800865:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  80086a:	85 d2                	test   %edx,%edx
  80086c:	0f 89 5c 01 00 00    	jns    8009ce <vprintfmt+0x403>
				putch('-', putdat);
  800872:	83 ec 08             	sub    $0x8,%esp
  800875:	53                   	push   %ebx
  800876:	6a 2d                	push   $0x2d
  800878:	ff d6                	call   *%esi
				num = -(long long) num;
  80087a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80087d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800880:	f7 d8                	neg    %eax
  800882:	83 d2 00             	adc    $0x0,%edx
  800885:	f7 da                	neg    %edx
  800887:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80088a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80088d:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800890:	bf 0a 00 00 00       	mov    $0xa,%edi
  800895:	e9 45 01 00 00       	jmp    8009df <vprintfmt+0x414>
		return va_arg(*ap, int);
  80089a:	8b 45 14             	mov    0x14(%ebp),%eax
  80089d:	8b 00                	mov    (%eax),%eax
  80089f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008a2:	89 c1                	mov    %eax,%ecx
  8008a4:	c1 f9 1f             	sar    $0x1f,%ecx
  8008a7:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8008aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ad:	8d 40 04             	lea    0x4(%eax),%eax
  8008b0:	89 45 14             	mov    %eax,0x14(%ebp)
  8008b3:	eb ad                	jmp    800862 <vprintfmt+0x297>
	if (lflag >= 2)
  8008b5:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8008b9:	7f 29                	jg     8008e4 <vprintfmt+0x319>
	else if (lflag)
  8008bb:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8008bf:	74 44                	je     800905 <vprintfmt+0x33a>
		return va_arg(*ap, unsigned long);
  8008c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c4:	8b 00                	mov    (%eax),%eax
  8008c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8008cb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008ce:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d4:	8d 40 04             	lea    0x4(%eax),%eax
  8008d7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008da:	bf 0a 00 00 00       	mov    $0xa,%edi
  8008df:	e9 ea 00 00 00       	jmp    8009ce <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  8008e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e7:	8b 50 04             	mov    0x4(%eax),%edx
  8008ea:	8b 00                	mov    (%eax),%eax
  8008ec:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008ef:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f5:	8d 40 08             	lea    0x8(%eax),%eax
  8008f8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008fb:	bf 0a 00 00 00       	mov    $0xa,%edi
  800900:	e9 c9 00 00 00       	jmp    8009ce <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  800905:	8b 45 14             	mov    0x14(%ebp),%eax
  800908:	8b 00                	mov    (%eax),%eax
  80090a:	ba 00 00 00 00       	mov    $0x0,%edx
  80090f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800912:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800915:	8b 45 14             	mov    0x14(%ebp),%eax
  800918:	8d 40 04             	lea    0x4(%eax),%eax
  80091b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80091e:	bf 0a 00 00 00       	mov    $0xa,%edi
  800923:	e9 a6 00 00 00       	jmp    8009ce <vprintfmt+0x403>
			putch('0', putdat);
  800928:	83 ec 08             	sub    $0x8,%esp
  80092b:	53                   	push   %ebx
  80092c:	6a 30                	push   $0x30
  80092e:	ff d6                	call   *%esi
	if (lflag >= 2)
  800930:	83 c4 10             	add    $0x10,%esp
  800933:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800937:	7f 26                	jg     80095f <vprintfmt+0x394>
	else if (lflag)
  800939:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80093d:	74 3e                	je     80097d <vprintfmt+0x3b2>
		return va_arg(*ap, unsigned long);
  80093f:	8b 45 14             	mov    0x14(%ebp),%eax
  800942:	8b 00                	mov    (%eax),%eax
  800944:	ba 00 00 00 00       	mov    $0x0,%edx
  800949:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80094c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80094f:	8b 45 14             	mov    0x14(%ebp),%eax
  800952:	8d 40 04             	lea    0x4(%eax),%eax
  800955:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800958:	bf 08 00 00 00       	mov    $0x8,%edi
  80095d:	eb 6f                	jmp    8009ce <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  80095f:	8b 45 14             	mov    0x14(%ebp),%eax
  800962:	8b 50 04             	mov    0x4(%eax),%edx
  800965:	8b 00                	mov    (%eax),%eax
  800967:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80096a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80096d:	8b 45 14             	mov    0x14(%ebp),%eax
  800970:	8d 40 08             	lea    0x8(%eax),%eax
  800973:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800976:	bf 08 00 00 00       	mov    $0x8,%edi
  80097b:	eb 51                	jmp    8009ce <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  80097d:	8b 45 14             	mov    0x14(%ebp),%eax
  800980:	8b 00                	mov    (%eax),%eax
  800982:	ba 00 00 00 00       	mov    $0x0,%edx
  800987:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80098a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80098d:	8b 45 14             	mov    0x14(%ebp),%eax
  800990:	8d 40 04             	lea    0x4(%eax),%eax
  800993:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800996:	bf 08 00 00 00       	mov    $0x8,%edi
  80099b:	eb 31                	jmp    8009ce <vprintfmt+0x403>
			putch('0', putdat);
  80099d:	83 ec 08             	sub    $0x8,%esp
  8009a0:	53                   	push   %ebx
  8009a1:	6a 30                	push   $0x30
  8009a3:	ff d6                	call   *%esi
			putch('x', putdat);
  8009a5:	83 c4 08             	add    $0x8,%esp
  8009a8:	53                   	push   %ebx
  8009a9:	6a 78                	push   $0x78
  8009ab:	ff d6                	call   *%esi
			num = (unsigned long long)
  8009ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b0:	8b 00                	mov    (%eax),%eax
  8009b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8009b7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009ba:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8009bd:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8009c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c3:	8d 40 04             	lea    0x4(%eax),%eax
  8009c6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009c9:	bf 10 00 00 00       	mov    $0x10,%edi
			if(posflag)
  8009ce:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8009d2:	74 0b                	je     8009df <vprintfmt+0x414>
				putch('+', putdat);
  8009d4:	83 ec 08             	sub    $0x8,%esp
  8009d7:	53                   	push   %ebx
  8009d8:	6a 2b                	push   $0x2b
  8009da:	ff d6                	call   *%esi
  8009dc:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  8009df:	83 ec 0c             	sub    $0xc,%esp
  8009e2:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8009e6:	50                   	push   %eax
  8009e7:	ff 75 e0             	pushl  -0x20(%ebp)
  8009ea:	57                   	push   %edi
  8009eb:	ff 75 dc             	pushl  -0x24(%ebp)
  8009ee:	ff 75 d8             	pushl  -0x28(%ebp)
  8009f1:	89 da                	mov    %ebx,%edx
  8009f3:	89 f0                	mov    %esi,%eax
  8009f5:	e8 b8 fa ff ff       	call   8004b2 <printnum>
			break;
  8009fa:	83 c4 20             	add    $0x20,%esp
			char* cp = va_arg(ap, char *);
  8009fd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a00:	83 c7 01             	add    $0x1,%edi
  800a03:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800a07:	83 f8 25             	cmp    $0x25,%eax
  800a0a:	0f 84 d2 fb ff ff    	je     8005e2 <vprintfmt+0x17>
			if (ch == '\0')
  800a10:	85 c0                	test   %eax,%eax
  800a12:	0f 84 03 01 00 00    	je     800b1b <vprintfmt+0x550>
			putch(ch, putdat);
  800a18:	83 ec 08             	sub    $0x8,%esp
  800a1b:	53                   	push   %ebx
  800a1c:	50                   	push   %eax
  800a1d:	ff d6                	call   *%esi
  800a1f:	83 c4 10             	add    $0x10,%esp
  800a22:	eb dc                	jmp    800a00 <vprintfmt+0x435>
	if (lflag >= 2)
  800a24:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800a28:	7f 29                	jg     800a53 <vprintfmt+0x488>
	else if (lflag)
  800a2a:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800a2e:	74 44                	je     800a74 <vprintfmt+0x4a9>
		return va_arg(*ap, unsigned long);
  800a30:	8b 45 14             	mov    0x14(%ebp),%eax
  800a33:	8b 00                	mov    (%eax),%eax
  800a35:	ba 00 00 00 00       	mov    $0x0,%edx
  800a3a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a3d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a40:	8b 45 14             	mov    0x14(%ebp),%eax
  800a43:	8d 40 04             	lea    0x4(%eax),%eax
  800a46:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a49:	bf 10 00 00 00       	mov    $0x10,%edi
  800a4e:	e9 7b ff ff ff       	jmp    8009ce <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  800a53:	8b 45 14             	mov    0x14(%ebp),%eax
  800a56:	8b 50 04             	mov    0x4(%eax),%edx
  800a59:	8b 00                	mov    (%eax),%eax
  800a5b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a5e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a61:	8b 45 14             	mov    0x14(%ebp),%eax
  800a64:	8d 40 08             	lea    0x8(%eax),%eax
  800a67:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a6a:	bf 10 00 00 00       	mov    $0x10,%edi
  800a6f:	e9 5a ff ff ff       	jmp    8009ce <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  800a74:	8b 45 14             	mov    0x14(%ebp),%eax
  800a77:	8b 00                	mov    (%eax),%eax
  800a79:	ba 00 00 00 00       	mov    $0x0,%edx
  800a7e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a81:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a84:	8b 45 14             	mov    0x14(%ebp),%eax
  800a87:	8d 40 04             	lea    0x4(%eax),%eax
  800a8a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a8d:	bf 10 00 00 00       	mov    $0x10,%edi
  800a92:	e9 37 ff ff ff       	jmp    8009ce <vprintfmt+0x403>
			char* cp = va_arg(ap, char *);
  800a97:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9a:	8d 78 04             	lea    0x4(%eax),%edi
  800a9d:	8b 00                	mov    (%eax),%eax
    			if (cp == NULL) {
  800a9f:	85 c0                	test   %eax,%eax
  800aa1:	74 2c                	je     800acf <vprintfmt+0x504>
    			*cp = *(int *)putdat;
  800aa3:	8b 13                	mov    (%ebx),%edx
  800aa5:	88 10                	mov    %dl,(%eax)
			char* cp = va_arg(ap, char *);
  800aa7:	89 7d 14             	mov    %edi,0x14(%ebp)
    			if ((*(int *) putdat) > 127)
  800aaa:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  800aad:	0f 8e 4a ff ff ff    	jle    8009fd <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", overflow_error);
  800ab3:	68 8c 13 80 00       	push   $0x80138c
  800ab8:	68 3e 12 80 00       	push   $0x80123e
  800abd:	53                   	push   %ebx
  800abe:	56                   	push   %esi
  800abf:	e8 ea fa ff ff       	call   8005ae <printfmt>
  800ac4:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  800ac7:	89 7d 14             	mov    %edi,0x14(%ebp)
  800aca:	e9 2e ff ff ff       	jmp    8009fd <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", null_error);
  800acf:	68 54 13 80 00       	push   $0x801354
  800ad4:	68 3e 12 80 00       	push   $0x80123e
  800ad9:	53                   	push   %ebx
  800ada:	56                   	push   %esi
  800adb:	e8 ce fa ff ff       	call   8005ae <printfmt>
        		break;
  800ae0:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  800ae3:	89 7d 14             	mov    %edi,0x14(%ebp)
        		break;
  800ae6:	e9 12 ff ff ff       	jmp    8009fd <vprintfmt+0x432>
			putch(ch, putdat);
  800aeb:	83 ec 08             	sub    $0x8,%esp
  800aee:	53                   	push   %ebx
  800aef:	6a 25                	push   $0x25
  800af1:	ff d6                	call   *%esi
			break;
  800af3:	83 c4 10             	add    $0x10,%esp
  800af6:	e9 02 ff ff ff       	jmp    8009fd <vprintfmt+0x432>
			putch('%', putdat);
  800afb:	83 ec 08             	sub    $0x8,%esp
  800afe:	53                   	push   %ebx
  800aff:	6a 25                	push   $0x25
  800b01:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b03:	83 c4 10             	add    $0x10,%esp
  800b06:	89 f8                	mov    %edi,%eax
  800b08:	eb 03                	jmp    800b0d <vprintfmt+0x542>
  800b0a:	83 e8 01             	sub    $0x1,%eax
  800b0d:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800b11:	75 f7                	jne    800b0a <vprintfmt+0x53f>
  800b13:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b16:	e9 e2 fe ff ff       	jmp    8009fd <vprintfmt+0x432>
}
  800b1b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b1e:	5b                   	pop    %ebx
  800b1f:	5e                   	pop    %esi
  800b20:	5f                   	pop    %edi
  800b21:	5d                   	pop    %ebp
  800b22:	c3                   	ret    

00800b23 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b23:	55                   	push   %ebp
  800b24:	89 e5                	mov    %esp,%ebp
  800b26:	83 ec 18             	sub    $0x18,%esp
  800b29:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2c:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b2f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b32:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800b36:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800b39:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b40:	85 c0                	test   %eax,%eax
  800b42:	74 26                	je     800b6a <vsnprintf+0x47>
  800b44:	85 d2                	test   %edx,%edx
  800b46:	7e 22                	jle    800b6a <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b48:	ff 75 14             	pushl  0x14(%ebp)
  800b4b:	ff 75 10             	pushl  0x10(%ebp)
  800b4e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b51:	50                   	push   %eax
  800b52:	68 91 05 80 00       	push   $0x800591
  800b57:	e8 6f fa ff ff       	call   8005cb <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800b5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b5f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b65:	83 c4 10             	add    $0x10,%esp
}
  800b68:	c9                   	leave  
  800b69:	c3                   	ret    
		return -E_INVAL;
  800b6a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b6f:	eb f7                	jmp    800b68 <vsnprintf+0x45>

00800b71 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b71:	55                   	push   %ebp
  800b72:	89 e5                	mov    %esp,%ebp
  800b74:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b77:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800b7a:	50                   	push   %eax
  800b7b:	ff 75 10             	pushl  0x10(%ebp)
  800b7e:	ff 75 0c             	pushl  0xc(%ebp)
  800b81:	ff 75 08             	pushl  0x8(%ebp)
  800b84:	e8 9a ff ff ff       	call   800b23 <vsnprintf>
	va_end(ap);

	return rc;
}
  800b89:	c9                   	leave  
  800b8a:	c3                   	ret    

00800b8b <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800b8b:	55                   	push   %ebp
  800b8c:	89 e5                	mov    %esp,%ebp
  800b8e:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800b91:	b8 00 00 00 00       	mov    $0x0,%eax
  800b96:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800b9a:	74 05                	je     800ba1 <strlen+0x16>
		n++;
  800b9c:	83 c0 01             	add    $0x1,%eax
  800b9f:	eb f5                	jmp    800b96 <strlen+0xb>
	return n;
}
  800ba1:	5d                   	pop    %ebp
  800ba2:	c3                   	ret    

00800ba3 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800ba3:	55                   	push   %ebp
  800ba4:	89 e5                	mov    %esp,%ebp
  800ba6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ba9:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bac:	ba 00 00 00 00       	mov    $0x0,%edx
  800bb1:	39 c2                	cmp    %eax,%edx
  800bb3:	74 0d                	je     800bc2 <strnlen+0x1f>
  800bb5:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800bb9:	74 05                	je     800bc0 <strnlen+0x1d>
		n++;
  800bbb:	83 c2 01             	add    $0x1,%edx
  800bbe:	eb f1                	jmp    800bb1 <strnlen+0xe>
  800bc0:	89 d0                	mov    %edx,%eax
	return n;
}
  800bc2:	5d                   	pop    %ebp
  800bc3:	c3                   	ret    

00800bc4 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bc4:	55                   	push   %ebp
  800bc5:	89 e5                	mov    %esp,%ebp
  800bc7:	53                   	push   %ebx
  800bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800bce:	ba 00 00 00 00       	mov    $0x0,%edx
  800bd3:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800bd7:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800bda:	83 c2 01             	add    $0x1,%edx
  800bdd:	84 c9                	test   %cl,%cl
  800bdf:	75 f2                	jne    800bd3 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800be1:	5b                   	pop    %ebx
  800be2:	5d                   	pop    %ebp
  800be3:	c3                   	ret    

00800be4 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800be4:	55                   	push   %ebp
  800be5:	89 e5                	mov    %esp,%ebp
  800be7:	53                   	push   %ebx
  800be8:	83 ec 10             	sub    $0x10,%esp
  800beb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800bee:	53                   	push   %ebx
  800bef:	e8 97 ff ff ff       	call   800b8b <strlen>
  800bf4:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800bf7:	ff 75 0c             	pushl  0xc(%ebp)
  800bfa:	01 d8                	add    %ebx,%eax
  800bfc:	50                   	push   %eax
  800bfd:	e8 c2 ff ff ff       	call   800bc4 <strcpy>
	return dst;
}
  800c02:	89 d8                	mov    %ebx,%eax
  800c04:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c07:	c9                   	leave  
  800c08:	c3                   	ret    

00800c09 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800c09:	55                   	push   %ebp
  800c0a:	89 e5                	mov    %esp,%ebp
  800c0c:	56                   	push   %esi
  800c0d:	53                   	push   %ebx
  800c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c11:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c14:	89 c6                	mov    %eax,%esi
  800c16:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c19:	89 c2                	mov    %eax,%edx
  800c1b:	39 f2                	cmp    %esi,%edx
  800c1d:	74 11                	je     800c30 <strncpy+0x27>
		*dst++ = *src;
  800c1f:	83 c2 01             	add    $0x1,%edx
  800c22:	0f b6 19             	movzbl (%ecx),%ebx
  800c25:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800c28:	80 fb 01             	cmp    $0x1,%bl
  800c2b:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800c2e:	eb eb                	jmp    800c1b <strncpy+0x12>
	}
	return ret;
}
  800c30:	5b                   	pop    %ebx
  800c31:	5e                   	pop    %esi
  800c32:	5d                   	pop    %ebp
  800c33:	c3                   	ret    

00800c34 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800c34:	55                   	push   %ebp
  800c35:	89 e5                	mov    %esp,%ebp
  800c37:	56                   	push   %esi
  800c38:	53                   	push   %ebx
  800c39:	8b 75 08             	mov    0x8(%ebp),%esi
  800c3c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c3f:	8b 55 10             	mov    0x10(%ebp),%edx
  800c42:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800c44:	85 d2                	test   %edx,%edx
  800c46:	74 21                	je     800c69 <strlcpy+0x35>
  800c48:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800c4c:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800c4e:	39 c2                	cmp    %eax,%edx
  800c50:	74 14                	je     800c66 <strlcpy+0x32>
  800c52:	0f b6 19             	movzbl (%ecx),%ebx
  800c55:	84 db                	test   %bl,%bl
  800c57:	74 0b                	je     800c64 <strlcpy+0x30>
			*dst++ = *src++;
  800c59:	83 c1 01             	add    $0x1,%ecx
  800c5c:	83 c2 01             	add    $0x1,%edx
  800c5f:	88 5a ff             	mov    %bl,-0x1(%edx)
  800c62:	eb ea                	jmp    800c4e <strlcpy+0x1a>
  800c64:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800c66:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c69:	29 f0                	sub    %esi,%eax
}
  800c6b:	5b                   	pop    %ebx
  800c6c:	5e                   	pop    %esi
  800c6d:	5d                   	pop    %ebp
  800c6e:	c3                   	ret    

00800c6f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c6f:	55                   	push   %ebp
  800c70:	89 e5                	mov    %esp,%ebp
  800c72:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c75:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800c78:	0f b6 01             	movzbl (%ecx),%eax
  800c7b:	84 c0                	test   %al,%al
  800c7d:	74 0c                	je     800c8b <strcmp+0x1c>
  800c7f:	3a 02                	cmp    (%edx),%al
  800c81:	75 08                	jne    800c8b <strcmp+0x1c>
		p++, q++;
  800c83:	83 c1 01             	add    $0x1,%ecx
  800c86:	83 c2 01             	add    $0x1,%edx
  800c89:	eb ed                	jmp    800c78 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c8b:	0f b6 c0             	movzbl %al,%eax
  800c8e:	0f b6 12             	movzbl (%edx),%edx
  800c91:	29 d0                	sub    %edx,%eax
}
  800c93:	5d                   	pop    %ebp
  800c94:	c3                   	ret    

00800c95 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800c95:	55                   	push   %ebp
  800c96:	89 e5                	mov    %esp,%ebp
  800c98:	53                   	push   %ebx
  800c99:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c9f:	89 c3                	mov    %eax,%ebx
  800ca1:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800ca4:	eb 06                	jmp    800cac <strncmp+0x17>
		n--, p++, q++;
  800ca6:	83 c0 01             	add    $0x1,%eax
  800ca9:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800cac:	39 d8                	cmp    %ebx,%eax
  800cae:	74 16                	je     800cc6 <strncmp+0x31>
  800cb0:	0f b6 08             	movzbl (%eax),%ecx
  800cb3:	84 c9                	test   %cl,%cl
  800cb5:	74 04                	je     800cbb <strncmp+0x26>
  800cb7:	3a 0a                	cmp    (%edx),%cl
  800cb9:	74 eb                	je     800ca6 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800cbb:	0f b6 00             	movzbl (%eax),%eax
  800cbe:	0f b6 12             	movzbl (%edx),%edx
  800cc1:	29 d0                	sub    %edx,%eax
}
  800cc3:	5b                   	pop    %ebx
  800cc4:	5d                   	pop    %ebp
  800cc5:	c3                   	ret    
		return 0;
  800cc6:	b8 00 00 00 00       	mov    $0x0,%eax
  800ccb:	eb f6                	jmp    800cc3 <strncmp+0x2e>

00800ccd <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ccd:	55                   	push   %ebp
  800cce:	89 e5                	mov    %esp,%ebp
  800cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd3:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800cd7:	0f b6 10             	movzbl (%eax),%edx
  800cda:	84 d2                	test   %dl,%dl
  800cdc:	74 09                	je     800ce7 <strchr+0x1a>
		if (*s == c)
  800cde:	38 ca                	cmp    %cl,%dl
  800ce0:	74 0a                	je     800cec <strchr+0x1f>
	for (; *s; s++)
  800ce2:	83 c0 01             	add    $0x1,%eax
  800ce5:	eb f0                	jmp    800cd7 <strchr+0xa>
			return (char *) s;
	return 0;
  800ce7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cec:	5d                   	pop    %ebp
  800ced:	c3                   	ret    

00800cee <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cee:	55                   	push   %ebp
  800cef:	89 e5                	mov    %esp,%ebp
  800cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800cf8:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800cfb:	38 ca                	cmp    %cl,%dl
  800cfd:	74 09                	je     800d08 <strfind+0x1a>
  800cff:	84 d2                	test   %dl,%dl
  800d01:	74 05                	je     800d08 <strfind+0x1a>
	for (; *s; s++)
  800d03:	83 c0 01             	add    $0x1,%eax
  800d06:	eb f0                	jmp    800cf8 <strfind+0xa>
			break;
	return (char *) s;
}
  800d08:	5d                   	pop    %ebp
  800d09:	c3                   	ret    

00800d0a <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800d0a:	55                   	push   %ebp
  800d0b:	89 e5                	mov    %esp,%ebp
  800d0d:	57                   	push   %edi
  800d0e:	56                   	push   %esi
  800d0f:	53                   	push   %ebx
  800d10:	8b 7d 08             	mov    0x8(%ebp),%edi
  800d13:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800d16:	85 c9                	test   %ecx,%ecx
  800d18:	74 31                	je     800d4b <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800d1a:	89 f8                	mov    %edi,%eax
  800d1c:	09 c8                	or     %ecx,%eax
  800d1e:	a8 03                	test   $0x3,%al
  800d20:	75 23                	jne    800d45 <memset+0x3b>
		c &= 0xFF;
  800d22:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800d26:	89 d3                	mov    %edx,%ebx
  800d28:	c1 e3 08             	shl    $0x8,%ebx
  800d2b:	89 d0                	mov    %edx,%eax
  800d2d:	c1 e0 18             	shl    $0x18,%eax
  800d30:	89 d6                	mov    %edx,%esi
  800d32:	c1 e6 10             	shl    $0x10,%esi
  800d35:	09 f0                	or     %esi,%eax
  800d37:	09 c2                	or     %eax,%edx
  800d39:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800d3b:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800d3e:	89 d0                	mov    %edx,%eax
  800d40:	fc                   	cld    
  800d41:	f3 ab                	rep stos %eax,%es:(%edi)
  800d43:	eb 06                	jmp    800d4b <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d48:	fc                   	cld    
  800d49:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800d4b:	89 f8                	mov    %edi,%eax
  800d4d:	5b                   	pop    %ebx
  800d4e:	5e                   	pop    %esi
  800d4f:	5f                   	pop    %edi
  800d50:	5d                   	pop    %ebp
  800d51:	c3                   	ret    

00800d52 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800d52:	55                   	push   %ebp
  800d53:	89 e5                	mov    %esp,%ebp
  800d55:	57                   	push   %edi
  800d56:	56                   	push   %esi
  800d57:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5a:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d5d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d60:	39 c6                	cmp    %eax,%esi
  800d62:	73 32                	jae    800d96 <memmove+0x44>
  800d64:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800d67:	39 c2                	cmp    %eax,%edx
  800d69:	76 2b                	jbe    800d96 <memmove+0x44>
		s += n;
		d += n;
  800d6b:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d6e:	89 fe                	mov    %edi,%esi
  800d70:	09 ce                	or     %ecx,%esi
  800d72:	09 d6                	or     %edx,%esi
  800d74:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800d7a:	75 0e                	jne    800d8a <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800d7c:	83 ef 04             	sub    $0x4,%edi
  800d7f:	8d 72 fc             	lea    -0x4(%edx),%esi
  800d82:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800d85:	fd                   	std    
  800d86:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d88:	eb 09                	jmp    800d93 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800d8a:	83 ef 01             	sub    $0x1,%edi
  800d8d:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800d90:	fd                   	std    
  800d91:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800d93:	fc                   	cld    
  800d94:	eb 1a                	jmp    800db0 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d96:	89 c2                	mov    %eax,%edx
  800d98:	09 ca                	or     %ecx,%edx
  800d9a:	09 f2                	or     %esi,%edx
  800d9c:	f6 c2 03             	test   $0x3,%dl
  800d9f:	75 0a                	jne    800dab <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800da1:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800da4:	89 c7                	mov    %eax,%edi
  800da6:	fc                   	cld    
  800da7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800da9:	eb 05                	jmp    800db0 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800dab:	89 c7                	mov    %eax,%edi
  800dad:	fc                   	cld    
  800dae:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800db0:	5e                   	pop    %esi
  800db1:	5f                   	pop    %edi
  800db2:	5d                   	pop    %ebp
  800db3:	c3                   	ret    

00800db4 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800db4:	55                   	push   %ebp
  800db5:	89 e5                	mov    %esp,%ebp
  800db7:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800dba:	ff 75 10             	pushl  0x10(%ebp)
  800dbd:	ff 75 0c             	pushl  0xc(%ebp)
  800dc0:	ff 75 08             	pushl  0x8(%ebp)
  800dc3:	e8 8a ff ff ff       	call   800d52 <memmove>
}
  800dc8:	c9                   	leave  
  800dc9:	c3                   	ret    

00800dca <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800dca:	55                   	push   %ebp
  800dcb:	89 e5                	mov    %esp,%ebp
  800dcd:	56                   	push   %esi
  800dce:	53                   	push   %ebx
  800dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dd5:	89 c6                	mov    %eax,%esi
  800dd7:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800dda:	39 f0                	cmp    %esi,%eax
  800ddc:	74 1c                	je     800dfa <memcmp+0x30>
		if (*s1 != *s2)
  800dde:	0f b6 08             	movzbl (%eax),%ecx
  800de1:	0f b6 1a             	movzbl (%edx),%ebx
  800de4:	38 d9                	cmp    %bl,%cl
  800de6:	75 08                	jne    800df0 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800de8:	83 c0 01             	add    $0x1,%eax
  800deb:	83 c2 01             	add    $0x1,%edx
  800dee:	eb ea                	jmp    800dda <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800df0:	0f b6 c1             	movzbl %cl,%eax
  800df3:	0f b6 db             	movzbl %bl,%ebx
  800df6:	29 d8                	sub    %ebx,%eax
  800df8:	eb 05                	jmp    800dff <memcmp+0x35>
	}

	return 0;
  800dfa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dff:	5b                   	pop    %ebx
  800e00:	5e                   	pop    %esi
  800e01:	5d                   	pop    %ebp
  800e02:	c3                   	ret    

00800e03 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800e03:	55                   	push   %ebp
  800e04:	89 e5                	mov    %esp,%ebp
  800e06:	8b 45 08             	mov    0x8(%ebp),%eax
  800e09:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800e0c:	89 c2                	mov    %eax,%edx
  800e0e:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800e11:	39 d0                	cmp    %edx,%eax
  800e13:	73 09                	jae    800e1e <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e15:	38 08                	cmp    %cl,(%eax)
  800e17:	74 05                	je     800e1e <memfind+0x1b>
	for (; s < ends; s++)
  800e19:	83 c0 01             	add    $0x1,%eax
  800e1c:	eb f3                	jmp    800e11 <memfind+0xe>
			break;
	return (void *) s;
}
  800e1e:	5d                   	pop    %ebp
  800e1f:	c3                   	ret    

00800e20 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e20:	55                   	push   %ebp
  800e21:	89 e5                	mov    %esp,%ebp
  800e23:	57                   	push   %edi
  800e24:	56                   	push   %esi
  800e25:	53                   	push   %ebx
  800e26:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e29:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e2c:	eb 03                	jmp    800e31 <strtol+0x11>
		s++;
  800e2e:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800e31:	0f b6 01             	movzbl (%ecx),%eax
  800e34:	3c 20                	cmp    $0x20,%al
  800e36:	74 f6                	je     800e2e <strtol+0xe>
  800e38:	3c 09                	cmp    $0x9,%al
  800e3a:	74 f2                	je     800e2e <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800e3c:	3c 2b                	cmp    $0x2b,%al
  800e3e:	74 2a                	je     800e6a <strtol+0x4a>
	int neg = 0;
  800e40:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800e45:	3c 2d                	cmp    $0x2d,%al
  800e47:	74 2b                	je     800e74 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e49:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800e4f:	75 0f                	jne    800e60 <strtol+0x40>
  800e51:	80 39 30             	cmpb   $0x30,(%ecx)
  800e54:	74 28                	je     800e7e <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800e56:	85 db                	test   %ebx,%ebx
  800e58:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e5d:	0f 44 d8             	cmove  %eax,%ebx
  800e60:	b8 00 00 00 00       	mov    $0x0,%eax
  800e65:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800e68:	eb 50                	jmp    800eba <strtol+0x9a>
		s++;
  800e6a:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800e6d:	bf 00 00 00 00       	mov    $0x0,%edi
  800e72:	eb d5                	jmp    800e49 <strtol+0x29>
		s++, neg = 1;
  800e74:	83 c1 01             	add    $0x1,%ecx
  800e77:	bf 01 00 00 00       	mov    $0x1,%edi
  800e7c:	eb cb                	jmp    800e49 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e7e:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800e82:	74 0e                	je     800e92 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800e84:	85 db                	test   %ebx,%ebx
  800e86:	75 d8                	jne    800e60 <strtol+0x40>
		s++, base = 8;
  800e88:	83 c1 01             	add    $0x1,%ecx
  800e8b:	bb 08 00 00 00       	mov    $0x8,%ebx
  800e90:	eb ce                	jmp    800e60 <strtol+0x40>
		s += 2, base = 16;
  800e92:	83 c1 02             	add    $0x2,%ecx
  800e95:	bb 10 00 00 00       	mov    $0x10,%ebx
  800e9a:	eb c4                	jmp    800e60 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800e9c:	8d 72 9f             	lea    -0x61(%edx),%esi
  800e9f:	89 f3                	mov    %esi,%ebx
  800ea1:	80 fb 19             	cmp    $0x19,%bl
  800ea4:	77 29                	ja     800ecf <strtol+0xaf>
			dig = *s - 'a' + 10;
  800ea6:	0f be d2             	movsbl %dl,%edx
  800ea9:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800eac:	3b 55 10             	cmp    0x10(%ebp),%edx
  800eaf:	7d 30                	jge    800ee1 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800eb1:	83 c1 01             	add    $0x1,%ecx
  800eb4:	0f af 45 10          	imul   0x10(%ebp),%eax
  800eb8:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800eba:	0f b6 11             	movzbl (%ecx),%edx
  800ebd:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ec0:	89 f3                	mov    %esi,%ebx
  800ec2:	80 fb 09             	cmp    $0x9,%bl
  800ec5:	77 d5                	ja     800e9c <strtol+0x7c>
			dig = *s - '0';
  800ec7:	0f be d2             	movsbl %dl,%edx
  800eca:	83 ea 30             	sub    $0x30,%edx
  800ecd:	eb dd                	jmp    800eac <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800ecf:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ed2:	89 f3                	mov    %esi,%ebx
  800ed4:	80 fb 19             	cmp    $0x19,%bl
  800ed7:	77 08                	ja     800ee1 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800ed9:	0f be d2             	movsbl %dl,%edx
  800edc:	83 ea 37             	sub    $0x37,%edx
  800edf:	eb cb                	jmp    800eac <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800ee1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ee5:	74 05                	je     800eec <strtol+0xcc>
		*endptr = (char *) s;
  800ee7:	8b 75 0c             	mov    0xc(%ebp),%esi
  800eea:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800eec:	89 c2                	mov    %eax,%edx
  800eee:	f7 da                	neg    %edx
  800ef0:	85 ff                	test   %edi,%edi
  800ef2:	0f 45 c2             	cmovne %edx,%eax
}
  800ef5:	5b                   	pop    %ebx
  800ef6:	5e                   	pop    %esi
  800ef7:	5f                   	pop    %edi
  800ef8:	5d                   	pop    %ebp
  800ef9:	c3                   	ret    

00800efa <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800efa:	55                   	push   %ebp
  800efb:	89 e5                	mov    %esp,%ebp
  800efd:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  800f00:	83 3d 08 20 80 00 00 	cmpl   $0x0,0x802008
  800f07:	74 0a                	je     800f13 <set_pgfault_handler+0x19>
			panic("set_pgfault_handler: sys_env_set_pgfault_upcall fail, ret:%d", ret);
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  800f09:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0c:	a3 08 20 80 00       	mov    %eax,0x802008
}
  800f11:	c9                   	leave  
  800f12:	c3                   	ret    
		ret = sys_page_alloc((envid_t)0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W);
  800f13:	83 ec 04             	sub    $0x4,%esp
  800f16:	6a 07                	push   $0x7
  800f18:	68 00 f0 bf ee       	push   $0xeebff000
  800f1d:	6a 00                	push   $0x0
  800f1f:	e8 47 f2 ff ff       	call   80016b <sys_page_alloc>
		if(ret < 0){
  800f24:	83 c4 10             	add    $0x10,%esp
  800f27:	85 c0                	test   %eax,%eax
  800f29:	78 28                	js     800f53 <set_pgfault_handler+0x59>
    	ret = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  800f2b:	83 ec 08             	sub    $0x8,%esp
  800f2e:	68 9d 03 80 00       	push   $0x80039d
  800f33:	6a 00                	push   $0x0
  800f35:	e8 7c f3 ff ff       	call   8002b6 <sys_env_set_pgfault_upcall>
		if(ret < 0){
  800f3a:	83 c4 10             	add    $0x10,%esp
  800f3d:	85 c0                	test   %eax,%eax
  800f3f:	79 c8                	jns    800f09 <set_pgfault_handler+0xf>
			panic("set_pgfault_handler: sys_env_set_pgfault_upcall fail, ret:%d", ret);
  800f41:	50                   	push   %eax
  800f42:	68 d4 15 80 00       	push   $0x8015d4
  800f47:	6a 28                	push   $0x28
  800f49:	68 14 16 80 00       	push   $0x801614
  800f4e:	e8 70 f4 ff ff       	call   8003c3 <_panic>
			panic("set_pgfault_handler: sys_page_alloc fail, ret:%d", ret);
  800f53:	50                   	push   %eax
  800f54:	68 a0 15 80 00       	push   $0x8015a0
  800f59:	6a 24                	push   $0x24
  800f5b:	68 14 16 80 00       	push   $0x801614
  800f60:	e8 5e f4 ff ff       	call   8003c3 <_panic>
  800f65:	66 90                	xchg   %ax,%ax
  800f67:	66 90                	xchg   %ax,%ax
  800f69:	66 90                	xchg   %ax,%ax
  800f6b:	66 90                	xchg   %ax,%ax
  800f6d:	66 90                	xchg   %ax,%ax
  800f6f:	90                   	nop

00800f70 <__udivdi3>:
  800f70:	55                   	push   %ebp
  800f71:	57                   	push   %edi
  800f72:	56                   	push   %esi
  800f73:	53                   	push   %ebx
  800f74:	83 ec 1c             	sub    $0x1c,%esp
  800f77:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800f7b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800f7f:	8b 74 24 34          	mov    0x34(%esp),%esi
  800f83:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800f87:	85 d2                	test   %edx,%edx
  800f89:	75 4d                	jne    800fd8 <__udivdi3+0x68>
  800f8b:	39 f3                	cmp    %esi,%ebx
  800f8d:	76 19                	jbe    800fa8 <__udivdi3+0x38>
  800f8f:	31 ff                	xor    %edi,%edi
  800f91:	89 e8                	mov    %ebp,%eax
  800f93:	89 f2                	mov    %esi,%edx
  800f95:	f7 f3                	div    %ebx
  800f97:	89 fa                	mov    %edi,%edx
  800f99:	83 c4 1c             	add    $0x1c,%esp
  800f9c:	5b                   	pop    %ebx
  800f9d:	5e                   	pop    %esi
  800f9e:	5f                   	pop    %edi
  800f9f:	5d                   	pop    %ebp
  800fa0:	c3                   	ret    
  800fa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800fa8:	89 d9                	mov    %ebx,%ecx
  800faa:	85 db                	test   %ebx,%ebx
  800fac:	75 0b                	jne    800fb9 <__udivdi3+0x49>
  800fae:	b8 01 00 00 00       	mov    $0x1,%eax
  800fb3:	31 d2                	xor    %edx,%edx
  800fb5:	f7 f3                	div    %ebx
  800fb7:	89 c1                	mov    %eax,%ecx
  800fb9:	31 d2                	xor    %edx,%edx
  800fbb:	89 f0                	mov    %esi,%eax
  800fbd:	f7 f1                	div    %ecx
  800fbf:	89 c6                	mov    %eax,%esi
  800fc1:	89 e8                	mov    %ebp,%eax
  800fc3:	89 f7                	mov    %esi,%edi
  800fc5:	f7 f1                	div    %ecx
  800fc7:	89 fa                	mov    %edi,%edx
  800fc9:	83 c4 1c             	add    $0x1c,%esp
  800fcc:	5b                   	pop    %ebx
  800fcd:	5e                   	pop    %esi
  800fce:	5f                   	pop    %edi
  800fcf:	5d                   	pop    %ebp
  800fd0:	c3                   	ret    
  800fd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800fd8:	39 f2                	cmp    %esi,%edx
  800fda:	77 1c                	ja     800ff8 <__udivdi3+0x88>
  800fdc:	0f bd fa             	bsr    %edx,%edi
  800fdf:	83 f7 1f             	xor    $0x1f,%edi
  800fe2:	75 2c                	jne    801010 <__udivdi3+0xa0>
  800fe4:	39 f2                	cmp    %esi,%edx
  800fe6:	72 06                	jb     800fee <__udivdi3+0x7e>
  800fe8:	31 c0                	xor    %eax,%eax
  800fea:	39 eb                	cmp    %ebp,%ebx
  800fec:	77 a9                	ja     800f97 <__udivdi3+0x27>
  800fee:	b8 01 00 00 00       	mov    $0x1,%eax
  800ff3:	eb a2                	jmp    800f97 <__udivdi3+0x27>
  800ff5:	8d 76 00             	lea    0x0(%esi),%esi
  800ff8:	31 ff                	xor    %edi,%edi
  800ffa:	31 c0                	xor    %eax,%eax
  800ffc:	89 fa                	mov    %edi,%edx
  800ffe:	83 c4 1c             	add    $0x1c,%esp
  801001:	5b                   	pop    %ebx
  801002:	5e                   	pop    %esi
  801003:	5f                   	pop    %edi
  801004:	5d                   	pop    %ebp
  801005:	c3                   	ret    
  801006:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80100d:	8d 76 00             	lea    0x0(%esi),%esi
  801010:	89 f9                	mov    %edi,%ecx
  801012:	b8 20 00 00 00       	mov    $0x20,%eax
  801017:	29 f8                	sub    %edi,%eax
  801019:	d3 e2                	shl    %cl,%edx
  80101b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80101f:	89 c1                	mov    %eax,%ecx
  801021:	89 da                	mov    %ebx,%edx
  801023:	d3 ea                	shr    %cl,%edx
  801025:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801029:	09 d1                	or     %edx,%ecx
  80102b:	89 f2                	mov    %esi,%edx
  80102d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801031:	89 f9                	mov    %edi,%ecx
  801033:	d3 e3                	shl    %cl,%ebx
  801035:	89 c1                	mov    %eax,%ecx
  801037:	d3 ea                	shr    %cl,%edx
  801039:	89 f9                	mov    %edi,%ecx
  80103b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80103f:	89 eb                	mov    %ebp,%ebx
  801041:	d3 e6                	shl    %cl,%esi
  801043:	89 c1                	mov    %eax,%ecx
  801045:	d3 eb                	shr    %cl,%ebx
  801047:	09 de                	or     %ebx,%esi
  801049:	89 f0                	mov    %esi,%eax
  80104b:	f7 74 24 08          	divl   0x8(%esp)
  80104f:	89 d6                	mov    %edx,%esi
  801051:	89 c3                	mov    %eax,%ebx
  801053:	f7 64 24 0c          	mull   0xc(%esp)
  801057:	39 d6                	cmp    %edx,%esi
  801059:	72 15                	jb     801070 <__udivdi3+0x100>
  80105b:	89 f9                	mov    %edi,%ecx
  80105d:	d3 e5                	shl    %cl,%ebp
  80105f:	39 c5                	cmp    %eax,%ebp
  801061:	73 04                	jae    801067 <__udivdi3+0xf7>
  801063:	39 d6                	cmp    %edx,%esi
  801065:	74 09                	je     801070 <__udivdi3+0x100>
  801067:	89 d8                	mov    %ebx,%eax
  801069:	31 ff                	xor    %edi,%edi
  80106b:	e9 27 ff ff ff       	jmp    800f97 <__udivdi3+0x27>
  801070:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801073:	31 ff                	xor    %edi,%edi
  801075:	e9 1d ff ff ff       	jmp    800f97 <__udivdi3+0x27>
  80107a:	66 90                	xchg   %ax,%ax
  80107c:	66 90                	xchg   %ax,%ax
  80107e:	66 90                	xchg   %ax,%ax

00801080 <__umoddi3>:
  801080:	55                   	push   %ebp
  801081:	57                   	push   %edi
  801082:	56                   	push   %esi
  801083:	53                   	push   %ebx
  801084:	83 ec 1c             	sub    $0x1c,%esp
  801087:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80108b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80108f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801093:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801097:	89 da                	mov    %ebx,%edx
  801099:	85 c0                	test   %eax,%eax
  80109b:	75 43                	jne    8010e0 <__umoddi3+0x60>
  80109d:	39 df                	cmp    %ebx,%edi
  80109f:	76 17                	jbe    8010b8 <__umoddi3+0x38>
  8010a1:	89 f0                	mov    %esi,%eax
  8010a3:	f7 f7                	div    %edi
  8010a5:	89 d0                	mov    %edx,%eax
  8010a7:	31 d2                	xor    %edx,%edx
  8010a9:	83 c4 1c             	add    $0x1c,%esp
  8010ac:	5b                   	pop    %ebx
  8010ad:	5e                   	pop    %esi
  8010ae:	5f                   	pop    %edi
  8010af:	5d                   	pop    %ebp
  8010b0:	c3                   	ret    
  8010b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8010b8:	89 fd                	mov    %edi,%ebp
  8010ba:	85 ff                	test   %edi,%edi
  8010bc:	75 0b                	jne    8010c9 <__umoddi3+0x49>
  8010be:	b8 01 00 00 00       	mov    $0x1,%eax
  8010c3:	31 d2                	xor    %edx,%edx
  8010c5:	f7 f7                	div    %edi
  8010c7:	89 c5                	mov    %eax,%ebp
  8010c9:	89 d8                	mov    %ebx,%eax
  8010cb:	31 d2                	xor    %edx,%edx
  8010cd:	f7 f5                	div    %ebp
  8010cf:	89 f0                	mov    %esi,%eax
  8010d1:	f7 f5                	div    %ebp
  8010d3:	89 d0                	mov    %edx,%eax
  8010d5:	eb d0                	jmp    8010a7 <__umoddi3+0x27>
  8010d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8010de:	66 90                	xchg   %ax,%ax
  8010e0:	89 f1                	mov    %esi,%ecx
  8010e2:	39 d8                	cmp    %ebx,%eax
  8010e4:	76 0a                	jbe    8010f0 <__umoddi3+0x70>
  8010e6:	89 f0                	mov    %esi,%eax
  8010e8:	83 c4 1c             	add    $0x1c,%esp
  8010eb:	5b                   	pop    %ebx
  8010ec:	5e                   	pop    %esi
  8010ed:	5f                   	pop    %edi
  8010ee:	5d                   	pop    %ebp
  8010ef:	c3                   	ret    
  8010f0:	0f bd e8             	bsr    %eax,%ebp
  8010f3:	83 f5 1f             	xor    $0x1f,%ebp
  8010f6:	75 20                	jne    801118 <__umoddi3+0x98>
  8010f8:	39 d8                	cmp    %ebx,%eax
  8010fa:	0f 82 b0 00 00 00    	jb     8011b0 <__umoddi3+0x130>
  801100:	39 f7                	cmp    %esi,%edi
  801102:	0f 86 a8 00 00 00    	jbe    8011b0 <__umoddi3+0x130>
  801108:	89 c8                	mov    %ecx,%eax
  80110a:	83 c4 1c             	add    $0x1c,%esp
  80110d:	5b                   	pop    %ebx
  80110e:	5e                   	pop    %esi
  80110f:	5f                   	pop    %edi
  801110:	5d                   	pop    %ebp
  801111:	c3                   	ret    
  801112:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801118:	89 e9                	mov    %ebp,%ecx
  80111a:	ba 20 00 00 00       	mov    $0x20,%edx
  80111f:	29 ea                	sub    %ebp,%edx
  801121:	d3 e0                	shl    %cl,%eax
  801123:	89 44 24 08          	mov    %eax,0x8(%esp)
  801127:	89 d1                	mov    %edx,%ecx
  801129:	89 f8                	mov    %edi,%eax
  80112b:	d3 e8                	shr    %cl,%eax
  80112d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801131:	89 54 24 04          	mov    %edx,0x4(%esp)
  801135:	8b 54 24 04          	mov    0x4(%esp),%edx
  801139:	09 c1                	or     %eax,%ecx
  80113b:	89 d8                	mov    %ebx,%eax
  80113d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801141:	89 e9                	mov    %ebp,%ecx
  801143:	d3 e7                	shl    %cl,%edi
  801145:	89 d1                	mov    %edx,%ecx
  801147:	d3 e8                	shr    %cl,%eax
  801149:	89 e9                	mov    %ebp,%ecx
  80114b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80114f:	d3 e3                	shl    %cl,%ebx
  801151:	89 c7                	mov    %eax,%edi
  801153:	89 d1                	mov    %edx,%ecx
  801155:	89 f0                	mov    %esi,%eax
  801157:	d3 e8                	shr    %cl,%eax
  801159:	89 e9                	mov    %ebp,%ecx
  80115b:	89 fa                	mov    %edi,%edx
  80115d:	d3 e6                	shl    %cl,%esi
  80115f:	09 d8                	or     %ebx,%eax
  801161:	f7 74 24 08          	divl   0x8(%esp)
  801165:	89 d1                	mov    %edx,%ecx
  801167:	89 f3                	mov    %esi,%ebx
  801169:	f7 64 24 0c          	mull   0xc(%esp)
  80116d:	89 c6                	mov    %eax,%esi
  80116f:	89 d7                	mov    %edx,%edi
  801171:	39 d1                	cmp    %edx,%ecx
  801173:	72 06                	jb     80117b <__umoddi3+0xfb>
  801175:	75 10                	jne    801187 <__umoddi3+0x107>
  801177:	39 c3                	cmp    %eax,%ebx
  801179:	73 0c                	jae    801187 <__umoddi3+0x107>
  80117b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80117f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801183:	89 d7                	mov    %edx,%edi
  801185:	89 c6                	mov    %eax,%esi
  801187:	89 ca                	mov    %ecx,%edx
  801189:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80118e:	29 f3                	sub    %esi,%ebx
  801190:	19 fa                	sbb    %edi,%edx
  801192:	89 d0                	mov    %edx,%eax
  801194:	d3 e0                	shl    %cl,%eax
  801196:	89 e9                	mov    %ebp,%ecx
  801198:	d3 eb                	shr    %cl,%ebx
  80119a:	d3 ea                	shr    %cl,%edx
  80119c:	09 d8                	or     %ebx,%eax
  80119e:	83 c4 1c             	add    $0x1c,%esp
  8011a1:	5b                   	pop    %ebx
  8011a2:	5e                   	pop    %esi
  8011a3:	5f                   	pop    %edi
  8011a4:	5d                   	pop    %ebp
  8011a5:	c3                   	ret    
  8011a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8011ad:	8d 76 00             	lea    0x0(%esi),%esi
  8011b0:	89 da                	mov    %ebx,%edx
  8011b2:	29 fe                	sub    %edi,%esi
  8011b4:	19 c2                	sbb    %eax,%edx
  8011b6:	89 f1                	mov    %esi,%ecx
  8011b8:	89 c8                	mov    %ecx,%eax
  8011ba:	e9 4b ff ff ff       	jmp    80110a <__umoddi3+0x8a>
