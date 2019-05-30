
obj/user/idle.debug:     file format elf32-i386


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
  80002c:	e8 19 00 00 00       	call   80004a <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/x86.h>
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 08             	sub    $0x8,%esp
	binaryname = "idle";
  800039:	c7 05 00 20 80 00 20 	movl   $0x801120,0x802000
  800040:	11 80 00 
	// Instead of busy-waiting like this,
	// a better way would be to use the processor's HLT instruction
	// to cause the processor to stop executing until the next interrupt -
	// doing so allows the processor to conserve power more effectively.
	while (1) {
		sys_yield();
  800043:	e8 fa 00 00 00       	call   800142 <sys_yield>
  800048:	eb f9                	jmp    800043 <umain+0x10>

0080004a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80004a:	55                   	push   %ebp
  80004b:	89 e5                	mov    %esp,%ebp
  80004d:	56                   	push   %esi
  80004e:	53                   	push   %ebx
  80004f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800052:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	// thisenv = 0;
	thisenv = &(envs[ENVX(sys_getenvid())]);
  800055:	e8 c9 00 00 00       	call   800123 <sys_getenvid>
  80005a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80005f:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  800065:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80006a:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80006f:	85 db                	test   %ebx,%ebx
  800071:	7e 07                	jle    80007a <libmain+0x30>
		binaryname = argv[0];
  800073:	8b 06                	mov    (%esi),%eax
  800075:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  80007a:	83 ec 08             	sub    $0x8,%esp
  80007d:	56                   	push   %esi
  80007e:	53                   	push   %ebx
  80007f:	e8 af ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800084:	e8 0a 00 00 00       	call   800093 <exit>
}
  800089:	83 c4 10             	add    $0x10,%esp
  80008c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80008f:	5b                   	pop    %ebx
  800090:	5e                   	pop    %esi
  800091:	5d                   	pop    %ebp
  800092:	c3                   	ret    

00800093 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800093:	55                   	push   %ebp
  800094:	89 e5                	mov    %esp,%ebp
  800096:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  800099:	6a 00                	push   $0x0
  80009b:	e8 42 00 00 00       	call   8000e2 <sys_env_destroy>
}
  8000a0:	83 c4 10             	add    $0x10,%esp
  8000a3:	c9                   	leave  
  8000a4:	c3                   	ret    

008000a5 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000a5:	55                   	push   %ebp
  8000a6:	89 e5                	mov    %esp,%ebp
  8000a8:	57                   	push   %edi
  8000a9:	56                   	push   %esi
  8000aa:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8000b3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000b6:	89 c3                	mov    %eax,%ebx
  8000b8:	89 c7                	mov    %eax,%edi
  8000ba:	89 c6                	mov    %eax,%esi
  8000bc:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000be:	5b                   	pop    %ebx
  8000bf:	5e                   	pop    %esi
  8000c0:	5f                   	pop    %edi
  8000c1:	5d                   	pop    %ebp
  8000c2:	c3                   	ret    

008000c3 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000c3:	55                   	push   %ebp
  8000c4:	89 e5                	mov    %esp,%ebp
  8000c6:	57                   	push   %edi
  8000c7:	56                   	push   %esi
  8000c8:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8000ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8000d3:	89 d1                	mov    %edx,%ecx
  8000d5:	89 d3                	mov    %edx,%ebx
  8000d7:	89 d7                	mov    %edx,%edi
  8000d9:	89 d6                	mov    %edx,%esi
  8000db:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000dd:	5b                   	pop    %ebx
  8000de:	5e                   	pop    %esi
  8000df:	5f                   	pop    %edi
  8000e0:	5d                   	pop    %ebp
  8000e1:	c3                   	ret    

008000e2 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000e2:	55                   	push   %ebp
  8000e3:	89 e5                	mov    %esp,%ebp
  8000e5:	57                   	push   %edi
  8000e6:	56                   	push   %esi
  8000e7:	53                   	push   %ebx
  8000e8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000eb:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8000f3:	b8 03 00 00 00       	mov    $0x3,%eax
  8000f8:	89 cb                	mov    %ecx,%ebx
  8000fa:	89 cf                	mov    %ecx,%edi
  8000fc:	89 ce                	mov    %ecx,%esi
  8000fe:	cd 30                	int    $0x30
	if (check && ret > 0)
  800100:	85 c0                	test   %eax,%eax
  800102:	7f 08                	jg     80010c <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800104:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800107:	5b                   	pop    %ebx
  800108:	5e                   	pop    %esi
  800109:	5f                   	pop    %edi
  80010a:	5d                   	pop    %ebp
  80010b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80010c:	83 ec 0c             	sub    $0xc,%esp
  80010f:	50                   	push   %eax
  800110:	6a 03                	push   $0x3
  800112:	68 2f 11 80 00       	push   $0x80112f
  800117:	6a 4c                	push   $0x4c
  800119:	68 4c 11 80 00       	push   $0x80114c
  80011e:	e8 70 02 00 00       	call   800393 <_panic>

00800123 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800123:	55                   	push   %ebp
  800124:	89 e5                	mov    %esp,%ebp
  800126:	57                   	push   %edi
  800127:	56                   	push   %esi
  800128:	53                   	push   %ebx
	asm volatile("int %1\n"
  800129:	ba 00 00 00 00       	mov    $0x0,%edx
  80012e:	b8 02 00 00 00       	mov    $0x2,%eax
  800133:	89 d1                	mov    %edx,%ecx
  800135:	89 d3                	mov    %edx,%ebx
  800137:	89 d7                	mov    %edx,%edi
  800139:	89 d6                	mov    %edx,%esi
  80013b:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80013d:	5b                   	pop    %ebx
  80013e:	5e                   	pop    %esi
  80013f:	5f                   	pop    %edi
  800140:	5d                   	pop    %ebp
  800141:	c3                   	ret    

00800142 <sys_yield>:

void
sys_yield(void)
{
  800142:	55                   	push   %ebp
  800143:	89 e5                	mov    %esp,%ebp
  800145:	57                   	push   %edi
  800146:	56                   	push   %esi
  800147:	53                   	push   %ebx
	asm volatile("int %1\n"
  800148:	ba 00 00 00 00       	mov    $0x0,%edx
  80014d:	b8 0b 00 00 00       	mov    $0xb,%eax
  800152:	89 d1                	mov    %edx,%ecx
  800154:	89 d3                	mov    %edx,%ebx
  800156:	89 d7                	mov    %edx,%edi
  800158:	89 d6                	mov    %edx,%esi
  80015a:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80015c:	5b                   	pop    %ebx
  80015d:	5e                   	pop    %esi
  80015e:	5f                   	pop    %edi
  80015f:	5d                   	pop    %ebp
  800160:	c3                   	ret    

00800161 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800161:	55                   	push   %ebp
  800162:	89 e5                	mov    %esp,%ebp
  800164:	57                   	push   %edi
  800165:	56                   	push   %esi
  800166:	53                   	push   %ebx
  800167:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80016a:	be 00 00 00 00       	mov    $0x0,%esi
  80016f:	8b 55 08             	mov    0x8(%ebp),%edx
  800172:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800175:	b8 04 00 00 00       	mov    $0x4,%eax
  80017a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80017d:	89 f7                	mov    %esi,%edi
  80017f:	cd 30                	int    $0x30
	if (check && ret > 0)
  800181:	85 c0                	test   %eax,%eax
  800183:	7f 08                	jg     80018d <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800185:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800188:	5b                   	pop    %ebx
  800189:	5e                   	pop    %esi
  80018a:	5f                   	pop    %edi
  80018b:	5d                   	pop    %ebp
  80018c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80018d:	83 ec 0c             	sub    $0xc,%esp
  800190:	50                   	push   %eax
  800191:	6a 04                	push   $0x4
  800193:	68 2f 11 80 00       	push   $0x80112f
  800198:	6a 4c                	push   $0x4c
  80019a:	68 4c 11 80 00       	push   $0x80114c
  80019f:	e8 ef 01 00 00       	call   800393 <_panic>

008001a4 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001a4:	55                   	push   %ebp
  8001a5:	89 e5                	mov    %esp,%ebp
  8001a7:	57                   	push   %edi
  8001a8:	56                   	push   %esi
  8001a9:	53                   	push   %ebx
  8001aa:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8001b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001b3:	b8 05 00 00 00       	mov    $0x5,%eax
  8001b8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001bb:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001be:	8b 75 18             	mov    0x18(%ebp),%esi
  8001c1:	cd 30                	int    $0x30
	if (check && ret > 0)
  8001c3:	85 c0                	test   %eax,%eax
  8001c5:	7f 08                	jg     8001cf <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001ca:	5b                   	pop    %ebx
  8001cb:	5e                   	pop    %esi
  8001cc:	5f                   	pop    %edi
  8001cd:	5d                   	pop    %ebp
  8001ce:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001cf:	83 ec 0c             	sub    $0xc,%esp
  8001d2:	50                   	push   %eax
  8001d3:	6a 05                	push   $0x5
  8001d5:	68 2f 11 80 00       	push   $0x80112f
  8001da:	6a 4c                	push   $0x4c
  8001dc:	68 4c 11 80 00       	push   $0x80114c
  8001e1:	e8 ad 01 00 00       	call   800393 <_panic>

008001e6 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001e6:	55                   	push   %ebp
  8001e7:	89 e5                	mov    %esp,%ebp
  8001e9:	57                   	push   %edi
  8001ea:	56                   	push   %esi
  8001eb:	53                   	push   %ebx
  8001ec:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001ef:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8001f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001fa:	b8 06 00 00 00       	mov    $0x6,%eax
  8001ff:	89 df                	mov    %ebx,%edi
  800201:	89 de                	mov    %ebx,%esi
  800203:	cd 30                	int    $0x30
	if (check && ret > 0)
  800205:	85 c0                	test   %eax,%eax
  800207:	7f 08                	jg     800211 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800209:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80020c:	5b                   	pop    %ebx
  80020d:	5e                   	pop    %esi
  80020e:	5f                   	pop    %edi
  80020f:	5d                   	pop    %ebp
  800210:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800211:	83 ec 0c             	sub    $0xc,%esp
  800214:	50                   	push   %eax
  800215:	6a 06                	push   $0x6
  800217:	68 2f 11 80 00       	push   $0x80112f
  80021c:	6a 4c                	push   $0x4c
  80021e:	68 4c 11 80 00       	push   $0x80114c
  800223:	e8 6b 01 00 00       	call   800393 <_panic>

00800228 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800228:	55                   	push   %ebp
  800229:	89 e5                	mov    %esp,%ebp
  80022b:	57                   	push   %edi
  80022c:	56                   	push   %esi
  80022d:	53                   	push   %ebx
  80022e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800231:	bb 00 00 00 00       	mov    $0x0,%ebx
  800236:	8b 55 08             	mov    0x8(%ebp),%edx
  800239:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80023c:	b8 08 00 00 00       	mov    $0x8,%eax
  800241:	89 df                	mov    %ebx,%edi
  800243:	89 de                	mov    %ebx,%esi
  800245:	cd 30                	int    $0x30
	if (check && ret > 0)
  800247:	85 c0                	test   %eax,%eax
  800249:	7f 08                	jg     800253 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80024b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80024e:	5b                   	pop    %ebx
  80024f:	5e                   	pop    %esi
  800250:	5f                   	pop    %edi
  800251:	5d                   	pop    %ebp
  800252:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800253:	83 ec 0c             	sub    $0xc,%esp
  800256:	50                   	push   %eax
  800257:	6a 08                	push   $0x8
  800259:	68 2f 11 80 00       	push   $0x80112f
  80025e:	6a 4c                	push   $0x4c
  800260:	68 4c 11 80 00       	push   $0x80114c
  800265:	e8 29 01 00 00       	call   800393 <_panic>

0080026a <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80026a:	55                   	push   %ebp
  80026b:	89 e5                	mov    %esp,%ebp
  80026d:	57                   	push   %edi
  80026e:	56                   	push   %esi
  80026f:	53                   	push   %ebx
  800270:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800273:	bb 00 00 00 00       	mov    $0x0,%ebx
  800278:	8b 55 08             	mov    0x8(%ebp),%edx
  80027b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80027e:	b8 09 00 00 00       	mov    $0x9,%eax
  800283:	89 df                	mov    %ebx,%edi
  800285:	89 de                	mov    %ebx,%esi
  800287:	cd 30                	int    $0x30
	if (check && ret > 0)
  800289:	85 c0                	test   %eax,%eax
  80028b:	7f 08                	jg     800295 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80028d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800290:	5b                   	pop    %ebx
  800291:	5e                   	pop    %esi
  800292:	5f                   	pop    %edi
  800293:	5d                   	pop    %ebp
  800294:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800295:	83 ec 0c             	sub    $0xc,%esp
  800298:	50                   	push   %eax
  800299:	6a 09                	push   $0x9
  80029b:	68 2f 11 80 00       	push   $0x80112f
  8002a0:	6a 4c                	push   $0x4c
  8002a2:	68 4c 11 80 00       	push   $0x80114c
  8002a7:	e8 e7 00 00 00       	call   800393 <_panic>

008002ac <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002ac:	55                   	push   %ebp
  8002ad:	89 e5                	mov    %esp,%ebp
  8002af:	57                   	push   %edi
  8002b0:	56                   	push   %esi
  8002b1:	53                   	push   %ebx
  8002b2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002b5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8002bd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002c0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002c5:	89 df                	mov    %ebx,%edi
  8002c7:	89 de                	mov    %ebx,%esi
  8002c9:	cd 30                	int    $0x30
	if (check && ret > 0)
  8002cb:	85 c0                	test   %eax,%eax
  8002cd:	7f 08                	jg     8002d7 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002d2:	5b                   	pop    %ebx
  8002d3:	5e                   	pop    %esi
  8002d4:	5f                   	pop    %edi
  8002d5:	5d                   	pop    %ebp
  8002d6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002d7:	83 ec 0c             	sub    $0xc,%esp
  8002da:	50                   	push   %eax
  8002db:	6a 0a                	push   $0xa
  8002dd:	68 2f 11 80 00       	push   $0x80112f
  8002e2:	6a 4c                	push   $0x4c
  8002e4:	68 4c 11 80 00       	push   $0x80114c
  8002e9:	e8 a5 00 00 00       	call   800393 <_panic>

008002ee <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002ee:	55                   	push   %ebp
  8002ef:	89 e5                	mov    %esp,%ebp
  8002f1:	57                   	push   %edi
  8002f2:	56                   	push   %esi
  8002f3:	53                   	push   %ebx
	asm volatile("int %1\n"
  8002f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8002f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002fa:	b8 0c 00 00 00       	mov    $0xc,%eax
  8002ff:	be 00 00 00 00       	mov    $0x0,%esi
  800304:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800307:	8b 7d 14             	mov    0x14(%ebp),%edi
  80030a:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80030c:	5b                   	pop    %ebx
  80030d:	5e                   	pop    %esi
  80030e:	5f                   	pop    %edi
  80030f:	5d                   	pop    %ebp
  800310:	c3                   	ret    

00800311 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800311:	55                   	push   %ebp
  800312:	89 e5                	mov    %esp,%ebp
  800314:	57                   	push   %edi
  800315:	56                   	push   %esi
  800316:	53                   	push   %ebx
  800317:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80031a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80031f:	8b 55 08             	mov    0x8(%ebp),%edx
  800322:	b8 0d 00 00 00       	mov    $0xd,%eax
  800327:	89 cb                	mov    %ecx,%ebx
  800329:	89 cf                	mov    %ecx,%edi
  80032b:	89 ce                	mov    %ecx,%esi
  80032d:	cd 30                	int    $0x30
	if (check && ret > 0)
  80032f:	85 c0                	test   %eax,%eax
  800331:	7f 08                	jg     80033b <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800333:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800336:	5b                   	pop    %ebx
  800337:	5e                   	pop    %esi
  800338:	5f                   	pop    %edi
  800339:	5d                   	pop    %ebp
  80033a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80033b:	83 ec 0c             	sub    $0xc,%esp
  80033e:	50                   	push   %eax
  80033f:	6a 0d                	push   $0xd
  800341:	68 2f 11 80 00       	push   $0x80112f
  800346:	6a 4c                	push   $0x4c
  800348:	68 4c 11 80 00       	push   $0x80114c
  80034d:	e8 41 00 00 00       	call   800393 <_panic>

00800352 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800352:	55                   	push   %ebp
  800353:	89 e5                	mov    %esp,%ebp
  800355:	57                   	push   %edi
  800356:	56                   	push   %esi
  800357:	53                   	push   %ebx
	asm volatile("int %1\n"
  800358:	bb 00 00 00 00       	mov    $0x0,%ebx
  80035d:	8b 55 08             	mov    0x8(%ebp),%edx
  800360:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800363:	b8 0e 00 00 00       	mov    $0xe,%eax
  800368:	89 df                	mov    %ebx,%edi
  80036a:	89 de                	mov    %ebx,%esi
  80036c:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  80036e:	5b                   	pop    %ebx
  80036f:	5e                   	pop    %esi
  800370:	5f                   	pop    %edi
  800371:	5d                   	pop    %ebp
  800372:	c3                   	ret    

00800373 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800373:	55                   	push   %ebp
  800374:	89 e5                	mov    %esp,%ebp
  800376:	57                   	push   %edi
  800377:	56                   	push   %esi
  800378:	53                   	push   %ebx
	asm volatile("int %1\n"
  800379:	b9 00 00 00 00       	mov    $0x0,%ecx
  80037e:	8b 55 08             	mov    0x8(%ebp),%edx
  800381:	b8 0f 00 00 00       	mov    $0xf,%eax
  800386:	89 cb                	mov    %ecx,%ebx
  800388:	89 cf                	mov    %ecx,%edi
  80038a:	89 ce                	mov    %ecx,%esi
  80038c:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  80038e:	5b                   	pop    %ebx
  80038f:	5e                   	pop    %esi
  800390:	5f                   	pop    %edi
  800391:	5d                   	pop    %ebp
  800392:	c3                   	ret    

00800393 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800393:	55                   	push   %ebp
  800394:	89 e5                	mov    %esp,%ebp
  800396:	56                   	push   %esi
  800397:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800398:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80039b:	8b 35 00 20 80 00    	mov    0x802000,%esi
  8003a1:	e8 7d fd ff ff       	call   800123 <sys_getenvid>
  8003a6:	83 ec 0c             	sub    $0xc,%esp
  8003a9:	ff 75 0c             	pushl  0xc(%ebp)
  8003ac:	ff 75 08             	pushl  0x8(%ebp)
  8003af:	56                   	push   %esi
  8003b0:	50                   	push   %eax
  8003b1:	68 5c 11 80 00       	push   $0x80115c
  8003b6:	e8 b3 00 00 00       	call   80046e <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8003bb:	83 c4 18             	add    $0x18,%esp
  8003be:	53                   	push   %ebx
  8003bf:	ff 75 10             	pushl  0x10(%ebp)
  8003c2:	e8 56 00 00 00       	call   80041d <vcprintf>
	cprintf("\n");
  8003c7:	c7 04 24 7f 11 80 00 	movl   $0x80117f,(%esp)
  8003ce:	e8 9b 00 00 00       	call   80046e <cprintf>
  8003d3:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8003d6:	cc                   	int3   
  8003d7:	eb fd                	jmp    8003d6 <_panic+0x43>

008003d9 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8003d9:	55                   	push   %ebp
  8003da:	89 e5                	mov    %esp,%ebp
  8003dc:	53                   	push   %ebx
  8003dd:	83 ec 04             	sub    $0x4,%esp
  8003e0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8003e3:	8b 13                	mov    (%ebx),%edx
  8003e5:	8d 42 01             	lea    0x1(%edx),%eax
  8003e8:	89 03                	mov    %eax,(%ebx)
  8003ea:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003ed:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8003f1:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003f6:	74 09                	je     800401 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8003f8:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8003fc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003ff:	c9                   	leave  
  800400:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800401:	83 ec 08             	sub    $0x8,%esp
  800404:	68 ff 00 00 00       	push   $0xff
  800409:	8d 43 08             	lea    0x8(%ebx),%eax
  80040c:	50                   	push   %eax
  80040d:	e8 93 fc ff ff       	call   8000a5 <sys_cputs>
		b->idx = 0;
  800412:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800418:	83 c4 10             	add    $0x10,%esp
  80041b:	eb db                	jmp    8003f8 <putch+0x1f>

0080041d <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80041d:	55                   	push   %ebp
  80041e:	89 e5                	mov    %esp,%ebp
  800420:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800426:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80042d:	00 00 00 
	b.cnt = 0;
  800430:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800437:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80043a:	ff 75 0c             	pushl  0xc(%ebp)
  80043d:	ff 75 08             	pushl  0x8(%ebp)
  800440:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800446:	50                   	push   %eax
  800447:	68 d9 03 80 00       	push   $0x8003d9
  80044c:	e8 4a 01 00 00       	call   80059b <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800451:	83 c4 08             	add    $0x8,%esp
  800454:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80045a:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800460:	50                   	push   %eax
  800461:	e8 3f fc ff ff       	call   8000a5 <sys_cputs>

	return b.cnt;
}
  800466:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80046c:	c9                   	leave  
  80046d:	c3                   	ret    

0080046e <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80046e:	55                   	push   %ebp
  80046f:	89 e5                	mov    %esp,%ebp
  800471:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800474:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800477:	50                   	push   %eax
  800478:	ff 75 08             	pushl  0x8(%ebp)
  80047b:	e8 9d ff ff ff       	call   80041d <vcprintf>
	va_end(ap);

	return cnt;
}
  800480:	c9                   	leave  
  800481:	c3                   	ret    

00800482 <printnum>:


static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800482:	55                   	push   %ebp
  800483:	89 e5                	mov    %esp,%ebp
  800485:	57                   	push   %edi
  800486:	56                   	push   %esi
  800487:	53                   	push   %ebx
  800488:	83 ec 1c             	sub    $0x1c,%esp
  80048b:	89 c6                	mov    %eax,%esi
  80048d:	89 d7                	mov    %edx,%edi
  80048f:	8b 45 08             	mov    0x8(%ebp),%eax
  800492:	8b 55 0c             	mov    0xc(%ebp),%edx
  800495:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800498:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80049b:	8b 45 10             	mov    0x10(%ebp),%eax
  80049e:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	// to support '-'
	if(padc == '-'){
  8004a1:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8004a5:	74 2c                	je     8004d3 <printnum+0x51>
		while (--width > 0)
			putch(' ', putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004aa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8004b1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004b4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8004b7:	39 c2                	cmp    %eax,%edx
  8004b9:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8004bc:	73 43                	jae    800501 <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004be:	83 eb 01             	sub    $0x1,%ebx
  8004c1:	85 db                	test   %ebx,%ebx
  8004c3:	7e 6c                	jle    800531 <printnum+0xaf>
			putch(padc, putdat);
  8004c5:	83 ec 08             	sub    $0x8,%esp
  8004c8:	57                   	push   %edi
  8004c9:	ff 75 18             	pushl  0x18(%ebp)
  8004cc:	ff d6                	call   *%esi
  8004ce:	83 c4 10             	add    $0x10,%esp
  8004d1:	eb eb                	jmp    8004be <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8004d3:	83 ec 0c             	sub    $0xc,%esp
  8004d6:	6a 20                	push   $0x20
  8004d8:	6a 00                	push   $0x0
  8004da:	50                   	push   %eax
  8004db:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004de:	ff 75 e0             	pushl  -0x20(%ebp)
  8004e1:	89 fa                	mov    %edi,%edx
  8004e3:	89 f0                	mov    %esi,%eax
  8004e5:	e8 98 ff ff ff       	call   800482 <printnum>
		while (--width > 0)
  8004ea:	83 c4 20             	add    $0x20,%esp
  8004ed:	83 eb 01             	sub    $0x1,%ebx
  8004f0:	85 db                	test   %ebx,%ebx
  8004f2:	7e 65                	jle    800559 <printnum+0xd7>
			putch(' ', putdat);
  8004f4:	83 ec 08             	sub    $0x8,%esp
  8004f7:	57                   	push   %edi
  8004f8:	6a 20                	push   $0x20
  8004fa:	ff d6                	call   *%esi
  8004fc:	83 c4 10             	add    $0x10,%esp
  8004ff:	eb ec                	jmp    8004ed <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800501:	83 ec 0c             	sub    $0xc,%esp
  800504:	ff 75 18             	pushl  0x18(%ebp)
  800507:	83 eb 01             	sub    $0x1,%ebx
  80050a:	53                   	push   %ebx
  80050b:	50                   	push   %eax
  80050c:	83 ec 08             	sub    $0x8,%esp
  80050f:	ff 75 dc             	pushl  -0x24(%ebp)
  800512:	ff 75 d8             	pushl  -0x28(%ebp)
  800515:	ff 75 e4             	pushl  -0x1c(%ebp)
  800518:	ff 75 e0             	pushl  -0x20(%ebp)
  80051b:	e8 b0 09 00 00       	call   800ed0 <__udivdi3>
  800520:	83 c4 18             	add    $0x18,%esp
  800523:	52                   	push   %edx
  800524:	50                   	push   %eax
  800525:	89 fa                	mov    %edi,%edx
  800527:	89 f0                	mov    %esi,%eax
  800529:	e8 54 ff ff ff       	call   800482 <printnum>
  80052e:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800531:	83 ec 08             	sub    $0x8,%esp
  800534:	57                   	push   %edi
  800535:	83 ec 04             	sub    $0x4,%esp
  800538:	ff 75 dc             	pushl  -0x24(%ebp)
  80053b:	ff 75 d8             	pushl  -0x28(%ebp)
  80053e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800541:	ff 75 e0             	pushl  -0x20(%ebp)
  800544:	e8 97 0a 00 00       	call   800fe0 <__umoddi3>
  800549:	83 c4 14             	add    $0x14,%esp
  80054c:	0f be 80 81 11 80 00 	movsbl 0x801181(%eax),%eax
  800553:	50                   	push   %eax
  800554:	ff d6                	call   *%esi
  800556:	83 c4 10             	add    $0x10,%esp
}
  800559:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80055c:	5b                   	pop    %ebx
  80055d:	5e                   	pop    %esi
  80055e:	5f                   	pop    %edi
  80055f:	5d                   	pop    %ebp
  800560:	c3                   	ret    

00800561 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800561:	55                   	push   %ebp
  800562:	89 e5                	mov    %esp,%ebp
  800564:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800567:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80056b:	8b 10                	mov    (%eax),%edx
  80056d:	3b 50 04             	cmp    0x4(%eax),%edx
  800570:	73 0a                	jae    80057c <sprintputch+0x1b>
		*b->buf++ = ch;
  800572:	8d 4a 01             	lea    0x1(%edx),%ecx
  800575:	89 08                	mov    %ecx,(%eax)
  800577:	8b 45 08             	mov    0x8(%ebp),%eax
  80057a:	88 02                	mov    %al,(%edx)
}
  80057c:	5d                   	pop    %ebp
  80057d:	c3                   	ret    

0080057e <printfmt>:
{
  80057e:	55                   	push   %ebp
  80057f:	89 e5                	mov    %esp,%ebp
  800581:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800584:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800587:	50                   	push   %eax
  800588:	ff 75 10             	pushl  0x10(%ebp)
  80058b:	ff 75 0c             	pushl  0xc(%ebp)
  80058e:	ff 75 08             	pushl  0x8(%ebp)
  800591:	e8 05 00 00 00       	call   80059b <vprintfmt>
}
  800596:	83 c4 10             	add    $0x10,%esp
  800599:	c9                   	leave  
  80059a:	c3                   	ret    

0080059b <vprintfmt>:
{
  80059b:	55                   	push   %ebp
  80059c:	89 e5                	mov    %esp,%ebp
  80059e:	57                   	push   %edi
  80059f:	56                   	push   %esi
  8005a0:	53                   	push   %ebx
  8005a1:	83 ec 3c             	sub    $0x3c,%esp
  8005a4:	8b 75 08             	mov    0x8(%ebp),%esi
  8005a7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8005aa:	8b 7d 10             	mov    0x10(%ebp),%edi
  8005ad:	e9 1e 04 00 00       	jmp    8009d0 <vprintfmt+0x435>
		posflag = 0;
  8005b2:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
		padc = ' ';
  8005b9:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8005bd:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8005c4:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8005cb:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8005d2:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  8005d9:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8005de:	8d 47 01             	lea    0x1(%edi),%eax
  8005e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005e4:	0f b6 17             	movzbl (%edi),%edx
  8005e7:	8d 42 dd             	lea    -0x23(%edx),%eax
  8005ea:	3c 55                	cmp    $0x55,%al
  8005ec:	0f 87 d9 04 00 00    	ja     800acb <vprintfmt+0x530>
  8005f2:	0f b6 c0             	movzbl %al,%eax
  8005f5:	ff 24 85 60 13 80 00 	jmp    *0x801360(,%eax,4)
  8005fc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8005ff:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800603:	eb d9                	jmp    8005de <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800605:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posflag = 1;
  800608:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  80060f:	eb cd                	jmp    8005de <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800611:	0f b6 d2             	movzbl %dl,%edx
  800614:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800617:	b8 00 00 00 00       	mov    $0x0,%eax
  80061c:	89 75 08             	mov    %esi,0x8(%ebp)
  80061f:	eb 0c                	jmp    80062d <vprintfmt+0x92>
		switch (ch = *(unsigned char *) fmt++) {
  800621:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800624:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  800628:	eb b4                	jmp    8005de <vprintfmt+0x43>
			for (precision = 0; ; ++fmt) {
  80062a:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80062d:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800630:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800634:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800637:	8d 72 d0             	lea    -0x30(%edx),%esi
  80063a:	83 fe 09             	cmp    $0x9,%esi
  80063d:	76 eb                	jbe    80062a <vprintfmt+0x8f>
  80063f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800642:	8b 75 08             	mov    0x8(%ebp),%esi
  800645:	eb 14                	jmp    80065b <vprintfmt+0xc0>
			precision = va_arg(ap, int);
  800647:	8b 45 14             	mov    0x14(%ebp),%eax
  80064a:	8b 00                	mov    (%eax),%eax
  80064c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80064f:	8b 45 14             	mov    0x14(%ebp),%eax
  800652:	8d 40 04             	lea    0x4(%eax),%eax
  800655:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800658:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80065b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80065f:	0f 89 79 ff ff ff    	jns    8005de <vprintfmt+0x43>
				width = precision, precision = -1;
  800665:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800668:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80066b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800672:	e9 67 ff ff ff       	jmp    8005de <vprintfmt+0x43>
  800677:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80067a:	85 c0                	test   %eax,%eax
  80067c:	0f 48 c1             	cmovs  %ecx,%eax
  80067f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800682:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800685:	e9 54 ff ff ff       	jmp    8005de <vprintfmt+0x43>
  80068a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80068d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800694:	e9 45 ff ff ff       	jmp    8005de <vprintfmt+0x43>
			lflag++;
  800699:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80069d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8006a0:	e9 39 ff ff ff       	jmp    8005de <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8006a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a8:	8d 78 04             	lea    0x4(%eax),%edi
  8006ab:	83 ec 08             	sub    $0x8,%esp
  8006ae:	53                   	push   %ebx
  8006af:	ff 30                	pushl  (%eax)
  8006b1:	ff d6                	call   *%esi
			break;
  8006b3:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8006b6:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8006b9:	e9 0f 03 00 00       	jmp    8009cd <vprintfmt+0x432>
			err = va_arg(ap, int);
  8006be:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c1:	8d 78 04             	lea    0x4(%eax),%edi
  8006c4:	8b 00                	mov    (%eax),%eax
  8006c6:	99                   	cltd   
  8006c7:	31 d0                	xor    %edx,%eax
  8006c9:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8006cb:	83 f8 0f             	cmp    $0xf,%eax
  8006ce:	7f 23                	jg     8006f3 <vprintfmt+0x158>
  8006d0:	8b 14 85 c0 14 80 00 	mov    0x8014c0(,%eax,4),%edx
  8006d7:	85 d2                	test   %edx,%edx
  8006d9:	74 18                	je     8006f3 <vprintfmt+0x158>
				printfmt(putch, putdat, "%s", p);
  8006db:	52                   	push   %edx
  8006dc:	68 a2 11 80 00       	push   $0x8011a2
  8006e1:	53                   	push   %ebx
  8006e2:	56                   	push   %esi
  8006e3:	e8 96 fe ff ff       	call   80057e <printfmt>
  8006e8:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8006eb:	89 7d 14             	mov    %edi,0x14(%ebp)
  8006ee:	e9 da 02 00 00       	jmp    8009cd <vprintfmt+0x432>
				printfmt(putch, putdat, "error %d", err);
  8006f3:	50                   	push   %eax
  8006f4:	68 99 11 80 00       	push   $0x801199
  8006f9:	53                   	push   %ebx
  8006fa:	56                   	push   %esi
  8006fb:	e8 7e fe ff ff       	call   80057e <printfmt>
  800700:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800703:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800706:	e9 c2 02 00 00       	jmp    8009cd <vprintfmt+0x432>
			if ((p = va_arg(ap, char *)) == NULL)
  80070b:	8b 45 14             	mov    0x14(%ebp),%eax
  80070e:	83 c0 04             	add    $0x4,%eax
  800711:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800714:	8b 45 14             	mov    0x14(%ebp),%eax
  800717:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800719:	85 c9                	test   %ecx,%ecx
  80071b:	b8 92 11 80 00       	mov    $0x801192,%eax
  800720:	0f 45 c1             	cmovne %ecx,%eax
  800723:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800726:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80072a:	7e 06                	jle    800732 <vprintfmt+0x197>
  80072c:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800730:	75 0d                	jne    80073f <vprintfmt+0x1a4>
				for (width -= strnlen(p, precision); width > 0; width--)
  800732:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800735:	89 c7                	mov    %eax,%edi
  800737:	03 45 e0             	add    -0x20(%ebp),%eax
  80073a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80073d:	eb 53                	jmp    800792 <vprintfmt+0x1f7>
  80073f:	83 ec 08             	sub    $0x8,%esp
  800742:	ff 75 d8             	pushl  -0x28(%ebp)
  800745:	50                   	push   %eax
  800746:	e8 28 04 00 00       	call   800b73 <strnlen>
  80074b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80074e:	29 c1                	sub    %eax,%ecx
  800750:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  800753:	83 c4 10             	add    $0x10,%esp
  800756:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800758:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80075c:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80075f:	eb 0f                	jmp    800770 <vprintfmt+0x1d5>
					putch(padc, putdat);
  800761:	83 ec 08             	sub    $0x8,%esp
  800764:	53                   	push   %ebx
  800765:	ff 75 e0             	pushl  -0x20(%ebp)
  800768:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80076a:	83 ef 01             	sub    $0x1,%edi
  80076d:	83 c4 10             	add    $0x10,%esp
  800770:	85 ff                	test   %edi,%edi
  800772:	7f ed                	jg     800761 <vprintfmt+0x1c6>
  800774:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  800777:	85 c9                	test   %ecx,%ecx
  800779:	b8 00 00 00 00       	mov    $0x0,%eax
  80077e:	0f 49 c1             	cmovns %ecx,%eax
  800781:	29 c1                	sub    %eax,%ecx
  800783:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800786:	eb aa                	jmp    800732 <vprintfmt+0x197>
					putch(ch, putdat);
  800788:	83 ec 08             	sub    $0x8,%esp
  80078b:	53                   	push   %ebx
  80078c:	52                   	push   %edx
  80078d:	ff d6                	call   *%esi
  80078f:	83 c4 10             	add    $0x10,%esp
  800792:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800795:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800797:	83 c7 01             	add    $0x1,%edi
  80079a:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80079e:	0f be d0             	movsbl %al,%edx
  8007a1:	85 d2                	test   %edx,%edx
  8007a3:	74 4b                	je     8007f0 <vprintfmt+0x255>
  8007a5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8007a9:	78 06                	js     8007b1 <vprintfmt+0x216>
  8007ab:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8007af:	78 1e                	js     8007cf <vprintfmt+0x234>
				if (altflag && (ch < ' ' || ch > '~'))
  8007b1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8007b5:	74 d1                	je     800788 <vprintfmt+0x1ed>
  8007b7:	0f be c0             	movsbl %al,%eax
  8007ba:	83 e8 20             	sub    $0x20,%eax
  8007bd:	83 f8 5e             	cmp    $0x5e,%eax
  8007c0:	76 c6                	jbe    800788 <vprintfmt+0x1ed>
					putch('?', putdat);
  8007c2:	83 ec 08             	sub    $0x8,%esp
  8007c5:	53                   	push   %ebx
  8007c6:	6a 3f                	push   $0x3f
  8007c8:	ff d6                	call   *%esi
  8007ca:	83 c4 10             	add    $0x10,%esp
  8007cd:	eb c3                	jmp    800792 <vprintfmt+0x1f7>
  8007cf:	89 cf                	mov    %ecx,%edi
  8007d1:	eb 0e                	jmp    8007e1 <vprintfmt+0x246>
				putch(' ', putdat);
  8007d3:	83 ec 08             	sub    $0x8,%esp
  8007d6:	53                   	push   %ebx
  8007d7:	6a 20                	push   $0x20
  8007d9:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8007db:	83 ef 01             	sub    $0x1,%edi
  8007de:	83 c4 10             	add    $0x10,%esp
  8007e1:	85 ff                	test   %edi,%edi
  8007e3:	7f ee                	jg     8007d3 <vprintfmt+0x238>
			if ((p = va_arg(ap, char *)) == NULL)
  8007e5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8007e8:	89 45 14             	mov    %eax,0x14(%ebp)
  8007eb:	e9 dd 01 00 00       	jmp    8009cd <vprintfmt+0x432>
  8007f0:	89 cf                	mov    %ecx,%edi
  8007f2:	eb ed                	jmp    8007e1 <vprintfmt+0x246>
	if (lflag >= 2)
  8007f4:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8007f8:	7f 21                	jg     80081b <vprintfmt+0x280>
	else if (lflag)
  8007fa:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8007fe:	74 6a                	je     80086a <vprintfmt+0x2cf>
		return va_arg(*ap, long);
  800800:	8b 45 14             	mov    0x14(%ebp),%eax
  800803:	8b 00                	mov    (%eax),%eax
  800805:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800808:	89 c1                	mov    %eax,%ecx
  80080a:	c1 f9 1f             	sar    $0x1f,%ecx
  80080d:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800810:	8b 45 14             	mov    0x14(%ebp),%eax
  800813:	8d 40 04             	lea    0x4(%eax),%eax
  800816:	89 45 14             	mov    %eax,0x14(%ebp)
  800819:	eb 17                	jmp    800832 <vprintfmt+0x297>
		return va_arg(*ap, long long);
  80081b:	8b 45 14             	mov    0x14(%ebp),%eax
  80081e:	8b 50 04             	mov    0x4(%eax),%edx
  800821:	8b 00                	mov    (%eax),%eax
  800823:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800826:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800829:	8b 45 14             	mov    0x14(%ebp),%eax
  80082c:	8d 40 08             	lea    0x8(%eax),%eax
  80082f:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800832:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  800835:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  80083a:	85 d2                	test   %edx,%edx
  80083c:	0f 89 5c 01 00 00    	jns    80099e <vprintfmt+0x403>
				putch('-', putdat);
  800842:	83 ec 08             	sub    $0x8,%esp
  800845:	53                   	push   %ebx
  800846:	6a 2d                	push   $0x2d
  800848:	ff d6                	call   *%esi
				num = -(long long) num;
  80084a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80084d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800850:	f7 d8                	neg    %eax
  800852:	83 d2 00             	adc    $0x0,%edx
  800855:	f7 da                	neg    %edx
  800857:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80085a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80085d:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800860:	bf 0a 00 00 00       	mov    $0xa,%edi
  800865:	e9 45 01 00 00       	jmp    8009af <vprintfmt+0x414>
		return va_arg(*ap, int);
  80086a:	8b 45 14             	mov    0x14(%ebp),%eax
  80086d:	8b 00                	mov    (%eax),%eax
  80086f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800872:	89 c1                	mov    %eax,%ecx
  800874:	c1 f9 1f             	sar    $0x1f,%ecx
  800877:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80087a:	8b 45 14             	mov    0x14(%ebp),%eax
  80087d:	8d 40 04             	lea    0x4(%eax),%eax
  800880:	89 45 14             	mov    %eax,0x14(%ebp)
  800883:	eb ad                	jmp    800832 <vprintfmt+0x297>
	if (lflag >= 2)
  800885:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800889:	7f 29                	jg     8008b4 <vprintfmt+0x319>
	else if (lflag)
  80088b:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80088f:	74 44                	je     8008d5 <vprintfmt+0x33a>
		return va_arg(*ap, unsigned long);
  800891:	8b 45 14             	mov    0x14(%ebp),%eax
  800894:	8b 00                	mov    (%eax),%eax
  800896:	ba 00 00 00 00       	mov    $0x0,%edx
  80089b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80089e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a4:	8d 40 04             	lea    0x4(%eax),%eax
  8008a7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008aa:	bf 0a 00 00 00       	mov    $0xa,%edi
  8008af:	e9 ea 00 00 00       	jmp    80099e <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  8008b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b7:	8b 50 04             	mov    0x4(%eax),%edx
  8008ba:	8b 00                	mov    (%eax),%eax
  8008bc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008bf:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c5:	8d 40 08             	lea    0x8(%eax),%eax
  8008c8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008cb:	bf 0a 00 00 00       	mov    $0xa,%edi
  8008d0:	e9 c9 00 00 00       	jmp    80099e <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  8008d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d8:	8b 00                	mov    (%eax),%eax
  8008da:	ba 00 00 00 00       	mov    $0x0,%edx
  8008df:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008e2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e8:	8d 40 04             	lea    0x4(%eax),%eax
  8008eb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008ee:	bf 0a 00 00 00       	mov    $0xa,%edi
  8008f3:	e9 a6 00 00 00       	jmp    80099e <vprintfmt+0x403>
			putch('0', putdat);
  8008f8:	83 ec 08             	sub    $0x8,%esp
  8008fb:	53                   	push   %ebx
  8008fc:	6a 30                	push   $0x30
  8008fe:	ff d6                	call   *%esi
	if (lflag >= 2)
  800900:	83 c4 10             	add    $0x10,%esp
  800903:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800907:	7f 26                	jg     80092f <vprintfmt+0x394>
	else if (lflag)
  800909:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80090d:	74 3e                	je     80094d <vprintfmt+0x3b2>
		return va_arg(*ap, unsigned long);
  80090f:	8b 45 14             	mov    0x14(%ebp),%eax
  800912:	8b 00                	mov    (%eax),%eax
  800914:	ba 00 00 00 00       	mov    $0x0,%edx
  800919:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80091c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80091f:	8b 45 14             	mov    0x14(%ebp),%eax
  800922:	8d 40 04             	lea    0x4(%eax),%eax
  800925:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800928:	bf 08 00 00 00       	mov    $0x8,%edi
  80092d:	eb 6f                	jmp    80099e <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  80092f:	8b 45 14             	mov    0x14(%ebp),%eax
  800932:	8b 50 04             	mov    0x4(%eax),%edx
  800935:	8b 00                	mov    (%eax),%eax
  800937:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80093a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80093d:	8b 45 14             	mov    0x14(%ebp),%eax
  800940:	8d 40 08             	lea    0x8(%eax),%eax
  800943:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800946:	bf 08 00 00 00       	mov    $0x8,%edi
  80094b:	eb 51                	jmp    80099e <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  80094d:	8b 45 14             	mov    0x14(%ebp),%eax
  800950:	8b 00                	mov    (%eax),%eax
  800952:	ba 00 00 00 00       	mov    $0x0,%edx
  800957:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80095a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80095d:	8b 45 14             	mov    0x14(%ebp),%eax
  800960:	8d 40 04             	lea    0x4(%eax),%eax
  800963:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800966:	bf 08 00 00 00       	mov    $0x8,%edi
  80096b:	eb 31                	jmp    80099e <vprintfmt+0x403>
			putch('0', putdat);
  80096d:	83 ec 08             	sub    $0x8,%esp
  800970:	53                   	push   %ebx
  800971:	6a 30                	push   $0x30
  800973:	ff d6                	call   *%esi
			putch('x', putdat);
  800975:	83 c4 08             	add    $0x8,%esp
  800978:	53                   	push   %ebx
  800979:	6a 78                	push   $0x78
  80097b:	ff d6                	call   *%esi
			num = (unsigned long long)
  80097d:	8b 45 14             	mov    0x14(%ebp),%eax
  800980:	8b 00                	mov    (%eax),%eax
  800982:	ba 00 00 00 00       	mov    $0x0,%edx
  800987:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80098a:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80098d:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800990:	8b 45 14             	mov    0x14(%ebp),%eax
  800993:	8d 40 04             	lea    0x4(%eax),%eax
  800996:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800999:	bf 10 00 00 00       	mov    $0x10,%edi
			if(posflag)
  80099e:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8009a2:	74 0b                	je     8009af <vprintfmt+0x414>
				putch('+', putdat);
  8009a4:	83 ec 08             	sub    $0x8,%esp
  8009a7:	53                   	push   %ebx
  8009a8:	6a 2b                	push   $0x2b
  8009aa:	ff d6                	call   *%esi
  8009ac:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  8009af:	83 ec 0c             	sub    $0xc,%esp
  8009b2:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8009b6:	50                   	push   %eax
  8009b7:	ff 75 e0             	pushl  -0x20(%ebp)
  8009ba:	57                   	push   %edi
  8009bb:	ff 75 dc             	pushl  -0x24(%ebp)
  8009be:	ff 75 d8             	pushl  -0x28(%ebp)
  8009c1:	89 da                	mov    %ebx,%edx
  8009c3:	89 f0                	mov    %esi,%eax
  8009c5:	e8 b8 fa ff ff       	call   800482 <printnum>
			break;
  8009ca:	83 c4 20             	add    $0x20,%esp
			char* cp = va_arg(ap, char *);
  8009cd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009d0:	83 c7 01             	add    $0x1,%edi
  8009d3:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8009d7:	83 f8 25             	cmp    $0x25,%eax
  8009da:	0f 84 d2 fb ff ff    	je     8005b2 <vprintfmt+0x17>
			if (ch == '\0')
  8009e0:	85 c0                	test   %eax,%eax
  8009e2:	0f 84 03 01 00 00    	je     800aeb <vprintfmt+0x550>
			putch(ch, putdat);
  8009e8:	83 ec 08             	sub    $0x8,%esp
  8009eb:	53                   	push   %ebx
  8009ec:	50                   	push   %eax
  8009ed:	ff d6                	call   *%esi
  8009ef:	83 c4 10             	add    $0x10,%esp
  8009f2:	eb dc                	jmp    8009d0 <vprintfmt+0x435>
	if (lflag >= 2)
  8009f4:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8009f8:	7f 29                	jg     800a23 <vprintfmt+0x488>
	else if (lflag)
  8009fa:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8009fe:	74 44                	je     800a44 <vprintfmt+0x4a9>
		return va_arg(*ap, unsigned long);
  800a00:	8b 45 14             	mov    0x14(%ebp),%eax
  800a03:	8b 00                	mov    (%eax),%eax
  800a05:	ba 00 00 00 00       	mov    $0x0,%edx
  800a0a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a0d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a10:	8b 45 14             	mov    0x14(%ebp),%eax
  800a13:	8d 40 04             	lea    0x4(%eax),%eax
  800a16:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a19:	bf 10 00 00 00       	mov    $0x10,%edi
  800a1e:	e9 7b ff ff ff       	jmp    80099e <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  800a23:	8b 45 14             	mov    0x14(%ebp),%eax
  800a26:	8b 50 04             	mov    0x4(%eax),%edx
  800a29:	8b 00                	mov    (%eax),%eax
  800a2b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a2e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a31:	8b 45 14             	mov    0x14(%ebp),%eax
  800a34:	8d 40 08             	lea    0x8(%eax),%eax
  800a37:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a3a:	bf 10 00 00 00       	mov    $0x10,%edi
  800a3f:	e9 5a ff ff ff       	jmp    80099e <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  800a44:	8b 45 14             	mov    0x14(%ebp),%eax
  800a47:	8b 00                	mov    (%eax),%eax
  800a49:	ba 00 00 00 00       	mov    $0x0,%edx
  800a4e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a51:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a54:	8b 45 14             	mov    0x14(%ebp),%eax
  800a57:	8d 40 04             	lea    0x4(%eax),%eax
  800a5a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a5d:	bf 10 00 00 00       	mov    $0x10,%edi
  800a62:	e9 37 ff ff ff       	jmp    80099e <vprintfmt+0x403>
			char* cp = va_arg(ap, char *);
  800a67:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6a:	8d 78 04             	lea    0x4(%eax),%edi
  800a6d:	8b 00                	mov    (%eax),%eax
    			if (cp == NULL) {
  800a6f:	85 c0                	test   %eax,%eax
  800a71:	74 2c                	je     800a9f <vprintfmt+0x504>
    			*cp = *(int *)putdat;
  800a73:	8b 13                	mov    (%ebx),%edx
  800a75:	88 10                	mov    %dl,(%eax)
			char* cp = va_arg(ap, char *);
  800a77:	89 7d 14             	mov    %edi,0x14(%ebp)
    			if ((*(int *) putdat) > 127)
  800a7a:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  800a7d:	0f 8e 4a ff ff ff    	jle    8009cd <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", overflow_error);
  800a83:	68 f0 12 80 00       	push   $0x8012f0
  800a88:	68 a2 11 80 00       	push   $0x8011a2
  800a8d:	53                   	push   %ebx
  800a8e:	56                   	push   %esi
  800a8f:	e8 ea fa ff ff       	call   80057e <printfmt>
  800a94:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  800a97:	89 7d 14             	mov    %edi,0x14(%ebp)
  800a9a:	e9 2e ff ff ff       	jmp    8009cd <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", null_error);
  800a9f:	68 b8 12 80 00       	push   $0x8012b8
  800aa4:	68 a2 11 80 00       	push   $0x8011a2
  800aa9:	53                   	push   %ebx
  800aaa:	56                   	push   %esi
  800aab:	e8 ce fa ff ff       	call   80057e <printfmt>
        		break;
  800ab0:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  800ab3:	89 7d 14             	mov    %edi,0x14(%ebp)
        		break;
  800ab6:	e9 12 ff ff ff       	jmp    8009cd <vprintfmt+0x432>
			putch(ch, putdat);
  800abb:	83 ec 08             	sub    $0x8,%esp
  800abe:	53                   	push   %ebx
  800abf:	6a 25                	push   $0x25
  800ac1:	ff d6                	call   *%esi
			break;
  800ac3:	83 c4 10             	add    $0x10,%esp
  800ac6:	e9 02 ff ff ff       	jmp    8009cd <vprintfmt+0x432>
			putch('%', putdat);
  800acb:	83 ec 08             	sub    $0x8,%esp
  800ace:	53                   	push   %ebx
  800acf:	6a 25                	push   $0x25
  800ad1:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ad3:	83 c4 10             	add    $0x10,%esp
  800ad6:	89 f8                	mov    %edi,%eax
  800ad8:	eb 03                	jmp    800add <vprintfmt+0x542>
  800ada:	83 e8 01             	sub    $0x1,%eax
  800add:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800ae1:	75 f7                	jne    800ada <vprintfmt+0x53f>
  800ae3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ae6:	e9 e2 fe ff ff       	jmp    8009cd <vprintfmt+0x432>
}
  800aeb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800aee:	5b                   	pop    %ebx
  800aef:	5e                   	pop    %esi
  800af0:	5f                   	pop    %edi
  800af1:	5d                   	pop    %ebp
  800af2:	c3                   	ret    

00800af3 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800af3:	55                   	push   %ebp
  800af4:	89 e5                	mov    %esp,%ebp
  800af6:	83 ec 18             	sub    $0x18,%esp
  800af9:	8b 45 08             	mov    0x8(%ebp),%eax
  800afc:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800aff:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b02:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800b06:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800b09:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b10:	85 c0                	test   %eax,%eax
  800b12:	74 26                	je     800b3a <vsnprintf+0x47>
  800b14:	85 d2                	test   %edx,%edx
  800b16:	7e 22                	jle    800b3a <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b18:	ff 75 14             	pushl  0x14(%ebp)
  800b1b:	ff 75 10             	pushl  0x10(%ebp)
  800b1e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b21:	50                   	push   %eax
  800b22:	68 61 05 80 00       	push   $0x800561
  800b27:	e8 6f fa ff ff       	call   80059b <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800b2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b2f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b35:	83 c4 10             	add    $0x10,%esp
}
  800b38:	c9                   	leave  
  800b39:	c3                   	ret    
		return -E_INVAL;
  800b3a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b3f:	eb f7                	jmp    800b38 <vsnprintf+0x45>

00800b41 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b41:	55                   	push   %ebp
  800b42:	89 e5                	mov    %esp,%ebp
  800b44:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b47:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800b4a:	50                   	push   %eax
  800b4b:	ff 75 10             	pushl  0x10(%ebp)
  800b4e:	ff 75 0c             	pushl  0xc(%ebp)
  800b51:	ff 75 08             	pushl  0x8(%ebp)
  800b54:	e8 9a ff ff ff       	call   800af3 <vsnprintf>
	va_end(ap);

	return rc;
}
  800b59:	c9                   	leave  
  800b5a:	c3                   	ret    

00800b5b <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800b5b:	55                   	push   %ebp
  800b5c:	89 e5                	mov    %esp,%ebp
  800b5e:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800b61:	b8 00 00 00 00       	mov    $0x0,%eax
  800b66:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800b6a:	74 05                	je     800b71 <strlen+0x16>
		n++;
  800b6c:	83 c0 01             	add    $0x1,%eax
  800b6f:	eb f5                	jmp    800b66 <strlen+0xb>
	return n;
}
  800b71:	5d                   	pop    %ebp
  800b72:	c3                   	ret    

00800b73 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800b73:	55                   	push   %ebp
  800b74:	89 e5                	mov    %esp,%ebp
  800b76:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b79:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b7c:	ba 00 00 00 00       	mov    $0x0,%edx
  800b81:	39 c2                	cmp    %eax,%edx
  800b83:	74 0d                	je     800b92 <strnlen+0x1f>
  800b85:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800b89:	74 05                	je     800b90 <strnlen+0x1d>
		n++;
  800b8b:	83 c2 01             	add    $0x1,%edx
  800b8e:	eb f1                	jmp    800b81 <strnlen+0xe>
  800b90:	89 d0                	mov    %edx,%eax
	return n;
}
  800b92:	5d                   	pop    %ebp
  800b93:	c3                   	ret    

00800b94 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b94:	55                   	push   %ebp
  800b95:	89 e5                	mov    %esp,%ebp
  800b97:	53                   	push   %ebx
  800b98:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800b9e:	ba 00 00 00 00       	mov    $0x0,%edx
  800ba3:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800ba7:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800baa:	83 c2 01             	add    $0x1,%edx
  800bad:	84 c9                	test   %cl,%cl
  800baf:	75 f2                	jne    800ba3 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800bb1:	5b                   	pop    %ebx
  800bb2:	5d                   	pop    %ebp
  800bb3:	c3                   	ret    

00800bb4 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800bb4:	55                   	push   %ebp
  800bb5:	89 e5                	mov    %esp,%ebp
  800bb7:	53                   	push   %ebx
  800bb8:	83 ec 10             	sub    $0x10,%esp
  800bbb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800bbe:	53                   	push   %ebx
  800bbf:	e8 97 ff ff ff       	call   800b5b <strlen>
  800bc4:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800bc7:	ff 75 0c             	pushl  0xc(%ebp)
  800bca:	01 d8                	add    %ebx,%eax
  800bcc:	50                   	push   %eax
  800bcd:	e8 c2 ff ff ff       	call   800b94 <strcpy>
	return dst;
}
  800bd2:	89 d8                	mov    %ebx,%eax
  800bd4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800bd7:	c9                   	leave  
  800bd8:	c3                   	ret    

00800bd9 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800bd9:	55                   	push   %ebp
  800bda:	89 e5                	mov    %esp,%ebp
  800bdc:	56                   	push   %esi
  800bdd:	53                   	push   %ebx
  800bde:	8b 45 08             	mov    0x8(%ebp),%eax
  800be1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800be4:	89 c6                	mov    %eax,%esi
  800be6:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800be9:	89 c2                	mov    %eax,%edx
  800beb:	39 f2                	cmp    %esi,%edx
  800bed:	74 11                	je     800c00 <strncpy+0x27>
		*dst++ = *src;
  800bef:	83 c2 01             	add    $0x1,%edx
  800bf2:	0f b6 19             	movzbl (%ecx),%ebx
  800bf5:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800bf8:	80 fb 01             	cmp    $0x1,%bl
  800bfb:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800bfe:	eb eb                	jmp    800beb <strncpy+0x12>
	}
	return ret;
}
  800c00:	5b                   	pop    %ebx
  800c01:	5e                   	pop    %esi
  800c02:	5d                   	pop    %ebp
  800c03:	c3                   	ret    

00800c04 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800c04:	55                   	push   %ebp
  800c05:	89 e5                	mov    %esp,%ebp
  800c07:	56                   	push   %esi
  800c08:	53                   	push   %ebx
  800c09:	8b 75 08             	mov    0x8(%ebp),%esi
  800c0c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c0f:	8b 55 10             	mov    0x10(%ebp),%edx
  800c12:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800c14:	85 d2                	test   %edx,%edx
  800c16:	74 21                	je     800c39 <strlcpy+0x35>
  800c18:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800c1c:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800c1e:	39 c2                	cmp    %eax,%edx
  800c20:	74 14                	je     800c36 <strlcpy+0x32>
  800c22:	0f b6 19             	movzbl (%ecx),%ebx
  800c25:	84 db                	test   %bl,%bl
  800c27:	74 0b                	je     800c34 <strlcpy+0x30>
			*dst++ = *src++;
  800c29:	83 c1 01             	add    $0x1,%ecx
  800c2c:	83 c2 01             	add    $0x1,%edx
  800c2f:	88 5a ff             	mov    %bl,-0x1(%edx)
  800c32:	eb ea                	jmp    800c1e <strlcpy+0x1a>
  800c34:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800c36:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c39:	29 f0                	sub    %esi,%eax
}
  800c3b:	5b                   	pop    %ebx
  800c3c:	5e                   	pop    %esi
  800c3d:	5d                   	pop    %ebp
  800c3e:	c3                   	ret    

00800c3f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c3f:	55                   	push   %ebp
  800c40:	89 e5                	mov    %esp,%ebp
  800c42:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c45:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800c48:	0f b6 01             	movzbl (%ecx),%eax
  800c4b:	84 c0                	test   %al,%al
  800c4d:	74 0c                	je     800c5b <strcmp+0x1c>
  800c4f:	3a 02                	cmp    (%edx),%al
  800c51:	75 08                	jne    800c5b <strcmp+0x1c>
		p++, q++;
  800c53:	83 c1 01             	add    $0x1,%ecx
  800c56:	83 c2 01             	add    $0x1,%edx
  800c59:	eb ed                	jmp    800c48 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c5b:	0f b6 c0             	movzbl %al,%eax
  800c5e:	0f b6 12             	movzbl (%edx),%edx
  800c61:	29 d0                	sub    %edx,%eax
}
  800c63:	5d                   	pop    %ebp
  800c64:	c3                   	ret    

00800c65 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800c65:	55                   	push   %ebp
  800c66:	89 e5                	mov    %esp,%ebp
  800c68:	53                   	push   %ebx
  800c69:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c6f:	89 c3                	mov    %eax,%ebx
  800c71:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800c74:	eb 06                	jmp    800c7c <strncmp+0x17>
		n--, p++, q++;
  800c76:	83 c0 01             	add    $0x1,%eax
  800c79:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800c7c:	39 d8                	cmp    %ebx,%eax
  800c7e:	74 16                	je     800c96 <strncmp+0x31>
  800c80:	0f b6 08             	movzbl (%eax),%ecx
  800c83:	84 c9                	test   %cl,%cl
  800c85:	74 04                	je     800c8b <strncmp+0x26>
  800c87:	3a 0a                	cmp    (%edx),%cl
  800c89:	74 eb                	je     800c76 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c8b:	0f b6 00             	movzbl (%eax),%eax
  800c8e:	0f b6 12             	movzbl (%edx),%edx
  800c91:	29 d0                	sub    %edx,%eax
}
  800c93:	5b                   	pop    %ebx
  800c94:	5d                   	pop    %ebp
  800c95:	c3                   	ret    
		return 0;
  800c96:	b8 00 00 00 00       	mov    $0x0,%eax
  800c9b:	eb f6                	jmp    800c93 <strncmp+0x2e>

00800c9d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c9d:	55                   	push   %ebp
  800c9e:	89 e5                	mov    %esp,%ebp
  800ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca3:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ca7:	0f b6 10             	movzbl (%eax),%edx
  800caa:	84 d2                	test   %dl,%dl
  800cac:	74 09                	je     800cb7 <strchr+0x1a>
		if (*s == c)
  800cae:	38 ca                	cmp    %cl,%dl
  800cb0:	74 0a                	je     800cbc <strchr+0x1f>
	for (; *s; s++)
  800cb2:	83 c0 01             	add    $0x1,%eax
  800cb5:	eb f0                	jmp    800ca7 <strchr+0xa>
			return (char *) s;
	return 0;
  800cb7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cbc:	5d                   	pop    %ebp
  800cbd:	c3                   	ret    

00800cbe <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cbe:	55                   	push   %ebp
  800cbf:	89 e5                	mov    %esp,%ebp
  800cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800cc8:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800ccb:	38 ca                	cmp    %cl,%dl
  800ccd:	74 09                	je     800cd8 <strfind+0x1a>
  800ccf:	84 d2                	test   %dl,%dl
  800cd1:	74 05                	je     800cd8 <strfind+0x1a>
	for (; *s; s++)
  800cd3:	83 c0 01             	add    $0x1,%eax
  800cd6:	eb f0                	jmp    800cc8 <strfind+0xa>
			break;
	return (char *) s;
}
  800cd8:	5d                   	pop    %ebp
  800cd9:	c3                   	ret    

00800cda <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800cda:	55                   	push   %ebp
  800cdb:	89 e5                	mov    %esp,%ebp
  800cdd:	57                   	push   %edi
  800cde:	56                   	push   %esi
  800cdf:	53                   	push   %ebx
  800ce0:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ce3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ce6:	85 c9                	test   %ecx,%ecx
  800ce8:	74 31                	je     800d1b <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800cea:	89 f8                	mov    %edi,%eax
  800cec:	09 c8                	or     %ecx,%eax
  800cee:	a8 03                	test   $0x3,%al
  800cf0:	75 23                	jne    800d15 <memset+0x3b>
		c &= 0xFF;
  800cf2:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800cf6:	89 d3                	mov    %edx,%ebx
  800cf8:	c1 e3 08             	shl    $0x8,%ebx
  800cfb:	89 d0                	mov    %edx,%eax
  800cfd:	c1 e0 18             	shl    $0x18,%eax
  800d00:	89 d6                	mov    %edx,%esi
  800d02:	c1 e6 10             	shl    $0x10,%esi
  800d05:	09 f0                	or     %esi,%eax
  800d07:	09 c2                	or     %eax,%edx
  800d09:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800d0b:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800d0e:	89 d0                	mov    %edx,%eax
  800d10:	fc                   	cld    
  800d11:	f3 ab                	rep stos %eax,%es:(%edi)
  800d13:	eb 06                	jmp    800d1b <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d18:	fc                   	cld    
  800d19:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800d1b:	89 f8                	mov    %edi,%eax
  800d1d:	5b                   	pop    %ebx
  800d1e:	5e                   	pop    %esi
  800d1f:	5f                   	pop    %edi
  800d20:	5d                   	pop    %ebp
  800d21:	c3                   	ret    

00800d22 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800d22:	55                   	push   %ebp
  800d23:	89 e5                	mov    %esp,%ebp
  800d25:	57                   	push   %edi
  800d26:	56                   	push   %esi
  800d27:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2a:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d2d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d30:	39 c6                	cmp    %eax,%esi
  800d32:	73 32                	jae    800d66 <memmove+0x44>
  800d34:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800d37:	39 c2                	cmp    %eax,%edx
  800d39:	76 2b                	jbe    800d66 <memmove+0x44>
		s += n;
		d += n;
  800d3b:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d3e:	89 fe                	mov    %edi,%esi
  800d40:	09 ce                	or     %ecx,%esi
  800d42:	09 d6                	or     %edx,%esi
  800d44:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800d4a:	75 0e                	jne    800d5a <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800d4c:	83 ef 04             	sub    $0x4,%edi
  800d4f:	8d 72 fc             	lea    -0x4(%edx),%esi
  800d52:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800d55:	fd                   	std    
  800d56:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d58:	eb 09                	jmp    800d63 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800d5a:	83 ef 01             	sub    $0x1,%edi
  800d5d:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800d60:	fd                   	std    
  800d61:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800d63:	fc                   	cld    
  800d64:	eb 1a                	jmp    800d80 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d66:	89 c2                	mov    %eax,%edx
  800d68:	09 ca                	or     %ecx,%edx
  800d6a:	09 f2                	or     %esi,%edx
  800d6c:	f6 c2 03             	test   $0x3,%dl
  800d6f:	75 0a                	jne    800d7b <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800d71:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800d74:	89 c7                	mov    %eax,%edi
  800d76:	fc                   	cld    
  800d77:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d79:	eb 05                	jmp    800d80 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800d7b:	89 c7                	mov    %eax,%edi
  800d7d:	fc                   	cld    
  800d7e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800d80:	5e                   	pop    %esi
  800d81:	5f                   	pop    %edi
  800d82:	5d                   	pop    %ebp
  800d83:	c3                   	ret    

00800d84 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800d84:	55                   	push   %ebp
  800d85:	89 e5                	mov    %esp,%ebp
  800d87:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800d8a:	ff 75 10             	pushl  0x10(%ebp)
  800d8d:	ff 75 0c             	pushl  0xc(%ebp)
  800d90:	ff 75 08             	pushl  0x8(%ebp)
  800d93:	e8 8a ff ff ff       	call   800d22 <memmove>
}
  800d98:	c9                   	leave  
  800d99:	c3                   	ret    

00800d9a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800d9a:	55                   	push   %ebp
  800d9b:	89 e5                	mov    %esp,%ebp
  800d9d:	56                   	push   %esi
  800d9e:	53                   	push   %ebx
  800d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800da2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800da5:	89 c6                	mov    %eax,%esi
  800da7:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800daa:	39 f0                	cmp    %esi,%eax
  800dac:	74 1c                	je     800dca <memcmp+0x30>
		if (*s1 != *s2)
  800dae:	0f b6 08             	movzbl (%eax),%ecx
  800db1:	0f b6 1a             	movzbl (%edx),%ebx
  800db4:	38 d9                	cmp    %bl,%cl
  800db6:	75 08                	jne    800dc0 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800db8:	83 c0 01             	add    $0x1,%eax
  800dbb:	83 c2 01             	add    $0x1,%edx
  800dbe:	eb ea                	jmp    800daa <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800dc0:	0f b6 c1             	movzbl %cl,%eax
  800dc3:	0f b6 db             	movzbl %bl,%ebx
  800dc6:	29 d8                	sub    %ebx,%eax
  800dc8:	eb 05                	jmp    800dcf <memcmp+0x35>
	}

	return 0;
  800dca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dcf:	5b                   	pop    %ebx
  800dd0:	5e                   	pop    %esi
  800dd1:	5d                   	pop    %ebp
  800dd2:	c3                   	ret    

00800dd3 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800dd3:	55                   	push   %ebp
  800dd4:	89 e5                	mov    %esp,%ebp
  800dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ddc:	89 c2                	mov    %eax,%edx
  800dde:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800de1:	39 d0                	cmp    %edx,%eax
  800de3:	73 09                	jae    800dee <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800de5:	38 08                	cmp    %cl,(%eax)
  800de7:	74 05                	je     800dee <memfind+0x1b>
	for (; s < ends; s++)
  800de9:	83 c0 01             	add    $0x1,%eax
  800dec:	eb f3                	jmp    800de1 <memfind+0xe>
			break;
	return (void *) s;
}
  800dee:	5d                   	pop    %ebp
  800def:	c3                   	ret    

00800df0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800df0:	55                   	push   %ebp
  800df1:	89 e5                	mov    %esp,%ebp
  800df3:	57                   	push   %edi
  800df4:	56                   	push   %esi
  800df5:	53                   	push   %ebx
  800df6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800df9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800dfc:	eb 03                	jmp    800e01 <strtol+0x11>
		s++;
  800dfe:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800e01:	0f b6 01             	movzbl (%ecx),%eax
  800e04:	3c 20                	cmp    $0x20,%al
  800e06:	74 f6                	je     800dfe <strtol+0xe>
  800e08:	3c 09                	cmp    $0x9,%al
  800e0a:	74 f2                	je     800dfe <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800e0c:	3c 2b                	cmp    $0x2b,%al
  800e0e:	74 2a                	je     800e3a <strtol+0x4a>
	int neg = 0;
  800e10:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800e15:	3c 2d                	cmp    $0x2d,%al
  800e17:	74 2b                	je     800e44 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e19:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800e1f:	75 0f                	jne    800e30 <strtol+0x40>
  800e21:	80 39 30             	cmpb   $0x30,(%ecx)
  800e24:	74 28                	je     800e4e <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800e26:	85 db                	test   %ebx,%ebx
  800e28:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e2d:	0f 44 d8             	cmove  %eax,%ebx
  800e30:	b8 00 00 00 00       	mov    $0x0,%eax
  800e35:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800e38:	eb 50                	jmp    800e8a <strtol+0x9a>
		s++;
  800e3a:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800e3d:	bf 00 00 00 00       	mov    $0x0,%edi
  800e42:	eb d5                	jmp    800e19 <strtol+0x29>
		s++, neg = 1;
  800e44:	83 c1 01             	add    $0x1,%ecx
  800e47:	bf 01 00 00 00       	mov    $0x1,%edi
  800e4c:	eb cb                	jmp    800e19 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e4e:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800e52:	74 0e                	je     800e62 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800e54:	85 db                	test   %ebx,%ebx
  800e56:	75 d8                	jne    800e30 <strtol+0x40>
		s++, base = 8;
  800e58:	83 c1 01             	add    $0x1,%ecx
  800e5b:	bb 08 00 00 00       	mov    $0x8,%ebx
  800e60:	eb ce                	jmp    800e30 <strtol+0x40>
		s += 2, base = 16;
  800e62:	83 c1 02             	add    $0x2,%ecx
  800e65:	bb 10 00 00 00       	mov    $0x10,%ebx
  800e6a:	eb c4                	jmp    800e30 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800e6c:	8d 72 9f             	lea    -0x61(%edx),%esi
  800e6f:	89 f3                	mov    %esi,%ebx
  800e71:	80 fb 19             	cmp    $0x19,%bl
  800e74:	77 29                	ja     800e9f <strtol+0xaf>
			dig = *s - 'a' + 10;
  800e76:	0f be d2             	movsbl %dl,%edx
  800e79:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800e7c:	3b 55 10             	cmp    0x10(%ebp),%edx
  800e7f:	7d 30                	jge    800eb1 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800e81:	83 c1 01             	add    $0x1,%ecx
  800e84:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e88:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800e8a:	0f b6 11             	movzbl (%ecx),%edx
  800e8d:	8d 72 d0             	lea    -0x30(%edx),%esi
  800e90:	89 f3                	mov    %esi,%ebx
  800e92:	80 fb 09             	cmp    $0x9,%bl
  800e95:	77 d5                	ja     800e6c <strtol+0x7c>
			dig = *s - '0';
  800e97:	0f be d2             	movsbl %dl,%edx
  800e9a:	83 ea 30             	sub    $0x30,%edx
  800e9d:	eb dd                	jmp    800e7c <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800e9f:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ea2:	89 f3                	mov    %esi,%ebx
  800ea4:	80 fb 19             	cmp    $0x19,%bl
  800ea7:	77 08                	ja     800eb1 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800ea9:	0f be d2             	movsbl %dl,%edx
  800eac:	83 ea 37             	sub    $0x37,%edx
  800eaf:	eb cb                	jmp    800e7c <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800eb1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800eb5:	74 05                	je     800ebc <strtol+0xcc>
		*endptr = (char *) s;
  800eb7:	8b 75 0c             	mov    0xc(%ebp),%esi
  800eba:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ebc:	89 c2                	mov    %eax,%edx
  800ebe:	f7 da                	neg    %edx
  800ec0:	85 ff                	test   %edi,%edi
  800ec2:	0f 45 c2             	cmovne %edx,%eax
}
  800ec5:	5b                   	pop    %ebx
  800ec6:	5e                   	pop    %esi
  800ec7:	5f                   	pop    %edi
  800ec8:	5d                   	pop    %ebp
  800ec9:	c3                   	ret    
  800eca:	66 90                	xchg   %ax,%ax
  800ecc:	66 90                	xchg   %ax,%ax
  800ece:	66 90                	xchg   %ax,%ax

00800ed0 <__udivdi3>:
  800ed0:	55                   	push   %ebp
  800ed1:	57                   	push   %edi
  800ed2:	56                   	push   %esi
  800ed3:	53                   	push   %ebx
  800ed4:	83 ec 1c             	sub    $0x1c,%esp
  800ed7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800edb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800edf:	8b 74 24 34          	mov    0x34(%esp),%esi
  800ee3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800ee7:	85 d2                	test   %edx,%edx
  800ee9:	75 4d                	jne    800f38 <__udivdi3+0x68>
  800eeb:	39 f3                	cmp    %esi,%ebx
  800eed:	76 19                	jbe    800f08 <__udivdi3+0x38>
  800eef:	31 ff                	xor    %edi,%edi
  800ef1:	89 e8                	mov    %ebp,%eax
  800ef3:	89 f2                	mov    %esi,%edx
  800ef5:	f7 f3                	div    %ebx
  800ef7:	89 fa                	mov    %edi,%edx
  800ef9:	83 c4 1c             	add    $0x1c,%esp
  800efc:	5b                   	pop    %ebx
  800efd:	5e                   	pop    %esi
  800efe:	5f                   	pop    %edi
  800eff:	5d                   	pop    %ebp
  800f00:	c3                   	ret    
  800f01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f08:	89 d9                	mov    %ebx,%ecx
  800f0a:	85 db                	test   %ebx,%ebx
  800f0c:	75 0b                	jne    800f19 <__udivdi3+0x49>
  800f0e:	b8 01 00 00 00       	mov    $0x1,%eax
  800f13:	31 d2                	xor    %edx,%edx
  800f15:	f7 f3                	div    %ebx
  800f17:	89 c1                	mov    %eax,%ecx
  800f19:	31 d2                	xor    %edx,%edx
  800f1b:	89 f0                	mov    %esi,%eax
  800f1d:	f7 f1                	div    %ecx
  800f1f:	89 c6                	mov    %eax,%esi
  800f21:	89 e8                	mov    %ebp,%eax
  800f23:	89 f7                	mov    %esi,%edi
  800f25:	f7 f1                	div    %ecx
  800f27:	89 fa                	mov    %edi,%edx
  800f29:	83 c4 1c             	add    $0x1c,%esp
  800f2c:	5b                   	pop    %ebx
  800f2d:	5e                   	pop    %esi
  800f2e:	5f                   	pop    %edi
  800f2f:	5d                   	pop    %ebp
  800f30:	c3                   	ret    
  800f31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f38:	39 f2                	cmp    %esi,%edx
  800f3a:	77 1c                	ja     800f58 <__udivdi3+0x88>
  800f3c:	0f bd fa             	bsr    %edx,%edi
  800f3f:	83 f7 1f             	xor    $0x1f,%edi
  800f42:	75 2c                	jne    800f70 <__udivdi3+0xa0>
  800f44:	39 f2                	cmp    %esi,%edx
  800f46:	72 06                	jb     800f4e <__udivdi3+0x7e>
  800f48:	31 c0                	xor    %eax,%eax
  800f4a:	39 eb                	cmp    %ebp,%ebx
  800f4c:	77 a9                	ja     800ef7 <__udivdi3+0x27>
  800f4e:	b8 01 00 00 00       	mov    $0x1,%eax
  800f53:	eb a2                	jmp    800ef7 <__udivdi3+0x27>
  800f55:	8d 76 00             	lea    0x0(%esi),%esi
  800f58:	31 ff                	xor    %edi,%edi
  800f5a:	31 c0                	xor    %eax,%eax
  800f5c:	89 fa                	mov    %edi,%edx
  800f5e:	83 c4 1c             	add    $0x1c,%esp
  800f61:	5b                   	pop    %ebx
  800f62:	5e                   	pop    %esi
  800f63:	5f                   	pop    %edi
  800f64:	5d                   	pop    %ebp
  800f65:	c3                   	ret    
  800f66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f6d:	8d 76 00             	lea    0x0(%esi),%esi
  800f70:	89 f9                	mov    %edi,%ecx
  800f72:	b8 20 00 00 00       	mov    $0x20,%eax
  800f77:	29 f8                	sub    %edi,%eax
  800f79:	d3 e2                	shl    %cl,%edx
  800f7b:	89 54 24 08          	mov    %edx,0x8(%esp)
  800f7f:	89 c1                	mov    %eax,%ecx
  800f81:	89 da                	mov    %ebx,%edx
  800f83:	d3 ea                	shr    %cl,%edx
  800f85:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800f89:	09 d1                	or     %edx,%ecx
  800f8b:	89 f2                	mov    %esi,%edx
  800f8d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800f91:	89 f9                	mov    %edi,%ecx
  800f93:	d3 e3                	shl    %cl,%ebx
  800f95:	89 c1                	mov    %eax,%ecx
  800f97:	d3 ea                	shr    %cl,%edx
  800f99:	89 f9                	mov    %edi,%ecx
  800f9b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800f9f:	89 eb                	mov    %ebp,%ebx
  800fa1:	d3 e6                	shl    %cl,%esi
  800fa3:	89 c1                	mov    %eax,%ecx
  800fa5:	d3 eb                	shr    %cl,%ebx
  800fa7:	09 de                	or     %ebx,%esi
  800fa9:	89 f0                	mov    %esi,%eax
  800fab:	f7 74 24 08          	divl   0x8(%esp)
  800faf:	89 d6                	mov    %edx,%esi
  800fb1:	89 c3                	mov    %eax,%ebx
  800fb3:	f7 64 24 0c          	mull   0xc(%esp)
  800fb7:	39 d6                	cmp    %edx,%esi
  800fb9:	72 15                	jb     800fd0 <__udivdi3+0x100>
  800fbb:	89 f9                	mov    %edi,%ecx
  800fbd:	d3 e5                	shl    %cl,%ebp
  800fbf:	39 c5                	cmp    %eax,%ebp
  800fc1:	73 04                	jae    800fc7 <__udivdi3+0xf7>
  800fc3:	39 d6                	cmp    %edx,%esi
  800fc5:	74 09                	je     800fd0 <__udivdi3+0x100>
  800fc7:	89 d8                	mov    %ebx,%eax
  800fc9:	31 ff                	xor    %edi,%edi
  800fcb:	e9 27 ff ff ff       	jmp    800ef7 <__udivdi3+0x27>
  800fd0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800fd3:	31 ff                	xor    %edi,%edi
  800fd5:	e9 1d ff ff ff       	jmp    800ef7 <__udivdi3+0x27>
  800fda:	66 90                	xchg   %ax,%ax
  800fdc:	66 90                	xchg   %ax,%ax
  800fde:	66 90                	xchg   %ax,%ax

00800fe0 <__umoddi3>:
  800fe0:	55                   	push   %ebp
  800fe1:	57                   	push   %edi
  800fe2:	56                   	push   %esi
  800fe3:	53                   	push   %ebx
  800fe4:	83 ec 1c             	sub    $0x1c,%esp
  800fe7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800feb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  800fef:	8b 74 24 30          	mov    0x30(%esp),%esi
  800ff3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  800ff7:	89 da                	mov    %ebx,%edx
  800ff9:	85 c0                	test   %eax,%eax
  800ffb:	75 43                	jne    801040 <__umoddi3+0x60>
  800ffd:	39 df                	cmp    %ebx,%edi
  800fff:	76 17                	jbe    801018 <__umoddi3+0x38>
  801001:	89 f0                	mov    %esi,%eax
  801003:	f7 f7                	div    %edi
  801005:	89 d0                	mov    %edx,%eax
  801007:	31 d2                	xor    %edx,%edx
  801009:	83 c4 1c             	add    $0x1c,%esp
  80100c:	5b                   	pop    %ebx
  80100d:	5e                   	pop    %esi
  80100e:	5f                   	pop    %edi
  80100f:	5d                   	pop    %ebp
  801010:	c3                   	ret    
  801011:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801018:	89 fd                	mov    %edi,%ebp
  80101a:	85 ff                	test   %edi,%edi
  80101c:	75 0b                	jne    801029 <__umoddi3+0x49>
  80101e:	b8 01 00 00 00       	mov    $0x1,%eax
  801023:	31 d2                	xor    %edx,%edx
  801025:	f7 f7                	div    %edi
  801027:	89 c5                	mov    %eax,%ebp
  801029:	89 d8                	mov    %ebx,%eax
  80102b:	31 d2                	xor    %edx,%edx
  80102d:	f7 f5                	div    %ebp
  80102f:	89 f0                	mov    %esi,%eax
  801031:	f7 f5                	div    %ebp
  801033:	89 d0                	mov    %edx,%eax
  801035:	eb d0                	jmp    801007 <__umoddi3+0x27>
  801037:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80103e:	66 90                	xchg   %ax,%ax
  801040:	89 f1                	mov    %esi,%ecx
  801042:	39 d8                	cmp    %ebx,%eax
  801044:	76 0a                	jbe    801050 <__umoddi3+0x70>
  801046:	89 f0                	mov    %esi,%eax
  801048:	83 c4 1c             	add    $0x1c,%esp
  80104b:	5b                   	pop    %ebx
  80104c:	5e                   	pop    %esi
  80104d:	5f                   	pop    %edi
  80104e:	5d                   	pop    %ebp
  80104f:	c3                   	ret    
  801050:	0f bd e8             	bsr    %eax,%ebp
  801053:	83 f5 1f             	xor    $0x1f,%ebp
  801056:	75 20                	jne    801078 <__umoddi3+0x98>
  801058:	39 d8                	cmp    %ebx,%eax
  80105a:	0f 82 b0 00 00 00    	jb     801110 <__umoddi3+0x130>
  801060:	39 f7                	cmp    %esi,%edi
  801062:	0f 86 a8 00 00 00    	jbe    801110 <__umoddi3+0x130>
  801068:	89 c8                	mov    %ecx,%eax
  80106a:	83 c4 1c             	add    $0x1c,%esp
  80106d:	5b                   	pop    %ebx
  80106e:	5e                   	pop    %esi
  80106f:	5f                   	pop    %edi
  801070:	5d                   	pop    %ebp
  801071:	c3                   	ret    
  801072:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801078:	89 e9                	mov    %ebp,%ecx
  80107a:	ba 20 00 00 00       	mov    $0x20,%edx
  80107f:	29 ea                	sub    %ebp,%edx
  801081:	d3 e0                	shl    %cl,%eax
  801083:	89 44 24 08          	mov    %eax,0x8(%esp)
  801087:	89 d1                	mov    %edx,%ecx
  801089:	89 f8                	mov    %edi,%eax
  80108b:	d3 e8                	shr    %cl,%eax
  80108d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801091:	89 54 24 04          	mov    %edx,0x4(%esp)
  801095:	8b 54 24 04          	mov    0x4(%esp),%edx
  801099:	09 c1                	or     %eax,%ecx
  80109b:	89 d8                	mov    %ebx,%eax
  80109d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8010a1:	89 e9                	mov    %ebp,%ecx
  8010a3:	d3 e7                	shl    %cl,%edi
  8010a5:	89 d1                	mov    %edx,%ecx
  8010a7:	d3 e8                	shr    %cl,%eax
  8010a9:	89 e9                	mov    %ebp,%ecx
  8010ab:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8010af:	d3 e3                	shl    %cl,%ebx
  8010b1:	89 c7                	mov    %eax,%edi
  8010b3:	89 d1                	mov    %edx,%ecx
  8010b5:	89 f0                	mov    %esi,%eax
  8010b7:	d3 e8                	shr    %cl,%eax
  8010b9:	89 e9                	mov    %ebp,%ecx
  8010bb:	89 fa                	mov    %edi,%edx
  8010bd:	d3 e6                	shl    %cl,%esi
  8010bf:	09 d8                	or     %ebx,%eax
  8010c1:	f7 74 24 08          	divl   0x8(%esp)
  8010c5:	89 d1                	mov    %edx,%ecx
  8010c7:	89 f3                	mov    %esi,%ebx
  8010c9:	f7 64 24 0c          	mull   0xc(%esp)
  8010cd:	89 c6                	mov    %eax,%esi
  8010cf:	89 d7                	mov    %edx,%edi
  8010d1:	39 d1                	cmp    %edx,%ecx
  8010d3:	72 06                	jb     8010db <__umoddi3+0xfb>
  8010d5:	75 10                	jne    8010e7 <__umoddi3+0x107>
  8010d7:	39 c3                	cmp    %eax,%ebx
  8010d9:	73 0c                	jae    8010e7 <__umoddi3+0x107>
  8010db:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8010df:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8010e3:	89 d7                	mov    %edx,%edi
  8010e5:	89 c6                	mov    %eax,%esi
  8010e7:	89 ca                	mov    %ecx,%edx
  8010e9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8010ee:	29 f3                	sub    %esi,%ebx
  8010f0:	19 fa                	sbb    %edi,%edx
  8010f2:	89 d0                	mov    %edx,%eax
  8010f4:	d3 e0                	shl    %cl,%eax
  8010f6:	89 e9                	mov    %ebp,%ecx
  8010f8:	d3 eb                	shr    %cl,%ebx
  8010fa:	d3 ea                	shr    %cl,%edx
  8010fc:	09 d8                	or     %ebx,%eax
  8010fe:	83 c4 1c             	add    $0x1c,%esp
  801101:	5b                   	pop    %ebx
  801102:	5e                   	pop    %esi
  801103:	5f                   	pop    %edi
  801104:	5d                   	pop    %ebp
  801105:	c3                   	ret    
  801106:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80110d:	8d 76 00             	lea    0x0(%esi),%esi
  801110:	89 da                	mov    %ebx,%edx
  801112:	29 fe                	sub    %edi,%esi
  801114:	19 c2                	sbb    %eax,%edx
  801116:	89 f1                	mov    %esi,%ecx
  801118:	89 c8                	mov    %ecx,%eax
  80111a:	e9 4b ff ff ff       	jmp    80106a <__umoddi3+0x8a>
