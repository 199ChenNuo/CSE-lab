
obj/user/softint.debug:     file format elf32-i386


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
  80002c:	e8 05 00 00 00       	call   800036 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
	asm volatile("int $14");	// page fault
  800033:	cd 0e                	int    $0xe
}
  800035:	c3                   	ret    

00800036 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800036:	55                   	push   %ebp
  800037:	89 e5                	mov    %esp,%ebp
  800039:	56                   	push   %esi
  80003a:	53                   	push   %ebx
  80003b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80003e:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	// thisenv = 0;
	thisenv = &(envs[ENVX(sys_getenvid())]);
  800041:	e8 c9 00 00 00       	call   80010f <sys_getenvid>
  800046:	25 ff 03 00 00       	and    $0x3ff,%eax
  80004b:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  800051:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800056:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80005b:	85 db                	test   %ebx,%ebx
  80005d:	7e 07                	jle    800066 <libmain+0x30>
		binaryname = argv[0];
  80005f:	8b 06                	mov    (%esi),%eax
  800061:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800066:	83 ec 08             	sub    $0x8,%esp
  800069:	56                   	push   %esi
  80006a:	53                   	push   %ebx
  80006b:	e8 c3 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800070:	e8 0a 00 00 00       	call   80007f <exit>
}
  800075:	83 c4 10             	add    $0x10,%esp
  800078:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80007b:	5b                   	pop    %ebx
  80007c:	5e                   	pop    %esi
  80007d:	5d                   	pop    %ebp
  80007e:	c3                   	ret    

0080007f <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80007f:	55                   	push   %ebp
  800080:	89 e5                	mov    %esp,%ebp
  800082:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  800085:	6a 00                	push   $0x0
  800087:	e8 42 00 00 00       	call   8000ce <sys_env_destroy>
}
  80008c:	83 c4 10             	add    $0x10,%esp
  80008f:	c9                   	leave  
  800090:	c3                   	ret    

00800091 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800091:	55                   	push   %ebp
  800092:	89 e5                	mov    %esp,%ebp
  800094:	57                   	push   %edi
  800095:	56                   	push   %esi
  800096:	53                   	push   %ebx
	asm volatile("int %1\n"
  800097:	b8 00 00 00 00       	mov    $0x0,%eax
  80009c:	8b 55 08             	mov    0x8(%ebp),%edx
  80009f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000a2:	89 c3                	mov    %eax,%ebx
  8000a4:	89 c7                	mov    %eax,%edi
  8000a6:	89 c6                	mov    %eax,%esi
  8000a8:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000aa:	5b                   	pop    %ebx
  8000ab:	5e                   	pop    %esi
  8000ac:	5f                   	pop    %edi
  8000ad:	5d                   	pop    %ebp
  8000ae:	c3                   	ret    

008000af <sys_cgetc>:

int
sys_cgetc(void)
{
  8000af:	55                   	push   %ebp
  8000b0:	89 e5                	mov    %esp,%ebp
  8000b2:	57                   	push   %edi
  8000b3:	56                   	push   %esi
  8000b4:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8000ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8000bf:	89 d1                	mov    %edx,%ecx
  8000c1:	89 d3                	mov    %edx,%ebx
  8000c3:	89 d7                	mov    %edx,%edi
  8000c5:	89 d6                	mov    %edx,%esi
  8000c7:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000c9:	5b                   	pop    %ebx
  8000ca:	5e                   	pop    %esi
  8000cb:	5f                   	pop    %edi
  8000cc:	5d                   	pop    %ebp
  8000cd:	c3                   	ret    

008000ce <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000ce:	55                   	push   %ebp
  8000cf:	89 e5                	mov    %esp,%ebp
  8000d1:	57                   	push   %edi
  8000d2:	56                   	push   %esi
  8000d3:	53                   	push   %ebx
  8000d4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000d7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8000df:	b8 03 00 00 00       	mov    $0x3,%eax
  8000e4:	89 cb                	mov    %ecx,%ebx
  8000e6:	89 cf                	mov    %ecx,%edi
  8000e8:	89 ce                	mov    %ecx,%esi
  8000ea:	cd 30                	int    $0x30
	if (check && ret > 0)
  8000ec:	85 c0                	test   %eax,%eax
  8000ee:	7f 08                	jg     8000f8 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8000f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000f3:	5b                   	pop    %ebx
  8000f4:	5e                   	pop    %esi
  8000f5:	5f                   	pop    %edi
  8000f6:	5d                   	pop    %ebp
  8000f7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8000f8:	83 ec 0c             	sub    $0xc,%esp
  8000fb:	50                   	push   %eax
  8000fc:	6a 03                	push   $0x3
  8000fe:	68 2a 11 80 00       	push   $0x80112a
  800103:	6a 4c                	push   $0x4c
  800105:	68 47 11 80 00       	push   $0x801147
  80010a:	e8 70 02 00 00       	call   80037f <_panic>

0080010f <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80010f:	55                   	push   %ebp
  800110:	89 e5                	mov    %esp,%ebp
  800112:	57                   	push   %edi
  800113:	56                   	push   %esi
  800114:	53                   	push   %ebx
	asm volatile("int %1\n"
  800115:	ba 00 00 00 00       	mov    $0x0,%edx
  80011a:	b8 02 00 00 00       	mov    $0x2,%eax
  80011f:	89 d1                	mov    %edx,%ecx
  800121:	89 d3                	mov    %edx,%ebx
  800123:	89 d7                	mov    %edx,%edi
  800125:	89 d6                	mov    %edx,%esi
  800127:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800129:	5b                   	pop    %ebx
  80012a:	5e                   	pop    %esi
  80012b:	5f                   	pop    %edi
  80012c:	5d                   	pop    %ebp
  80012d:	c3                   	ret    

0080012e <sys_yield>:

void
sys_yield(void)
{
  80012e:	55                   	push   %ebp
  80012f:	89 e5                	mov    %esp,%ebp
  800131:	57                   	push   %edi
  800132:	56                   	push   %esi
  800133:	53                   	push   %ebx
	asm volatile("int %1\n"
  800134:	ba 00 00 00 00       	mov    $0x0,%edx
  800139:	b8 0b 00 00 00       	mov    $0xb,%eax
  80013e:	89 d1                	mov    %edx,%ecx
  800140:	89 d3                	mov    %edx,%ebx
  800142:	89 d7                	mov    %edx,%edi
  800144:	89 d6                	mov    %edx,%esi
  800146:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800148:	5b                   	pop    %ebx
  800149:	5e                   	pop    %esi
  80014a:	5f                   	pop    %edi
  80014b:	5d                   	pop    %ebp
  80014c:	c3                   	ret    

0080014d <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80014d:	55                   	push   %ebp
  80014e:	89 e5                	mov    %esp,%ebp
  800150:	57                   	push   %edi
  800151:	56                   	push   %esi
  800152:	53                   	push   %ebx
  800153:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800156:	be 00 00 00 00       	mov    $0x0,%esi
  80015b:	8b 55 08             	mov    0x8(%ebp),%edx
  80015e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800161:	b8 04 00 00 00       	mov    $0x4,%eax
  800166:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800169:	89 f7                	mov    %esi,%edi
  80016b:	cd 30                	int    $0x30
	if (check && ret > 0)
  80016d:	85 c0                	test   %eax,%eax
  80016f:	7f 08                	jg     800179 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800171:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800174:	5b                   	pop    %ebx
  800175:	5e                   	pop    %esi
  800176:	5f                   	pop    %edi
  800177:	5d                   	pop    %ebp
  800178:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800179:	83 ec 0c             	sub    $0xc,%esp
  80017c:	50                   	push   %eax
  80017d:	6a 04                	push   $0x4
  80017f:	68 2a 11 80 00       	push   $0x80112a
  800184:	6a 4c                	push   $0x4c
  800186:	68 47 11 80 00       	push   $0x801147
  80018b:	e8 ef 01 00 00       	call   80037f <_panic>

00800190 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800190:	55                   	push   %ebp
  800191:	89 e5                	mov    %esp,%ebp
  800193:	57                   	push   %edi
  800194:	56                   	push   %esi
  800195:	53                   	push   %ebx
  800196:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800199:	8b 55 08             	mov    0x8(%ebp),%edx
  80019c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80019f:	b8 05 00 00 00       	mov    $0x5,%eax
  8001a4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001a7:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001aa:	8b 75 18             	mov    0x18(%ebp),%esi
  8001ad:	cd 30                	int    $0x30
	if (check && ret > 0)
  8001af:	85 c0                	test   %eax,%eax
  8001b1:	7f 08                	jg     8001bb <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001b6:	5b                   	pop    %ebx
  8001b7:	5e                   	pop    %esi
  8001b8:	5f                   	pop    %edi
  8001b9:	5d                   	pop    %ebp
  8001ba:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001bb:	83 ec 0c             	sub    $0xc,%esp
  8001be:	50                   	push   %eax
  8001bf:	6a 05                	push   $0x5
  8001c1:	68 2a 11 80 00       	push   $0x80112a
  8001c6:	6a 4c                	push   $0x4c
  8001c8:	68 47 11 80 00       	push   $0x801147
  8001cd:	e8 ad 01 00 00       	call   80037f <_panic>

008001d2 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001d2:	55                   	push   %ebp
  8001d3:	89 e5                	mov    %esp,%ebp
  8001d5:	57                   	push   %edi
  8001d6:	56                   	push   %esi
  8001d7:	53                   	push   %ebx
  8001d8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001db:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8001e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001e6:	b8 06 00 00 00       	mov    $0x6,%eax
  8001eb:	89 df                	mov    %ebx,%edi
  8001ed:	89 de                	mov    %ebx,%esi
  8001ef:	cd 30                	int    $0x30
	if (check && ret > 0)
  8001f1:	85 c0                	test   %eax,%eax
  8001f3:	7f 08                	jg     8001fd <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8001f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001f8:	5b                   	pop    %ebx
  8001f9:	5e                   	pop    %esi
  8001fa:	5f                   	pop    %edi
  8001fb:	5d                   	pop    %ebp
  8001fc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001fd:	83 ec 0c             	sub    $0xc,%esp
  800200:	50                   	push   %eax
  800201:	6a 06                	push   $0x6
  800203:	68 2a 11 80 00       	push   $0x80112a
  800208:	6a 4c                	push   $0x4c
  80020a:	68 47 11 80 00       	push   $0x801147
  80020f:	e8 6b 01 00 00       	call   80037f <_panic>

00800214 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800214:	55                   	push   %ebp
  800215:	89 e5                	mov    %esp,%ebp
  800217:	57                   	push   %edi
  800218:	56                   	push   %esi
  800219:	53                   	push   %ebx
  80021a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80021d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800222:	8b 55 08             	mov    0x8(%ebp),%edx
  800225:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800228:	b8 08 00 00 00       	mov    $0x8,%eax
  80022d:	89 df                	mov    %ebx,%edi
  80022f:	89 de                	mov    %ebx,%esi
  800231:	cd 30                	int    $0x30
	if (check && ret > 0)
  800233:	85 c0                	test   %eax,%eax
  800235:	7f 08                	jg     80023f <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800237:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80023a:	5b                   	pop    %ebx
  80023b:	5e                   	pop    %esi
  80023c:	5f                   	pop    %edi
  80023d:	5d                   	pop    %ebp
  80023e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80023f:	83 ec 0c             	sub    $0xc,%esp
  800242:	50                   	push   %eax
  800243:	6a 08                	push   $0x8
  800245:	68 2a 11 80 00       	push   $0x80112a
  80024a:	6a 4c                	push   $0x4c
  80024c:	68 47 11 80 00       	push   $0x801147
  800251:	e8 29 01 00 00       	call   80037f <_panic>

00800256 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800256:	55                   	push   %ebp
  800257:	89 e5                	mov    %esp,%ebp
  800259:	57                   	push   %edi
  80025a:	56                   	push   %esi
  80025b:	53                   	push   %ebx
  80025c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80025f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800264:	8b 55 08             	mov    0x8(%ebp),%edx
  800267:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80026a:	b8 09 00 00 00       	mov    $0x9,%eax
  80026f:	89 df                	mov    %ebx,%edi
  800271:	89 de                	mov    %ebx,%esi
  800273:	cd 30                	int    $0x30
	if (check && ret > 0)
  800275:	85 c0                	test   %eax,%eax
  800277:	7f 08                	jg     800281 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800279:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80027c:	5b                   	pop    %ebx
  80027d:	5e                   	pop    %esi
  80027e:	5f                   	pop    %edi
  80027f:	5d                   	pop    %ebp
  800280:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800281:	83 ec 0c             	sub    $0xc,%esp
  800284:	50                   	push   %eax
  800285:	6a 09                	push   $0x9
  800287:	68 2a 11 80 00       	push   $0x80112a
  80028c:	6a 4c                	push   $0x4c
  80028e:	68 47 11 80 00       	push   $0x801147
  800293:	e8 e7 00 00 00       	call   80037f <_panic>

00800298 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800298:	55                   	push   %ebp
  800299:	89 e5                	mov    %esp,%ebp
  80029b:	57                   	push   %edi
  80029c:	56                   	push   %esi
  80029d:	53                   	push   %ebx
  80029e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002a1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8002a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002ac:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002b1:	89 df                	mov    %ebx,%edi
  8002b3:	89 de                	mov    %ebx,%esi
  8002b5:	cd 30                	int    $0x30
	if (check && ret > 0)
  8002b7:	85 c0                	test   %eax,%eax
  8002b9:	7f 08                	jg     8002c3 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002be:	5b                   	pop    %ebx
  8002bf:	5e                   	pop    %esi
  8002c0:	5f                   	pop    %edi
  8002c1:	5d                   	pop    %ebp
  8002c2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002c3:	83 ec 0c             	sub    $0xc,%esp
  8002c6:	50                   	push   %eax
  8002c7:	6a 0a                	push   $0xa
  8002c9:	68 2a 11 80 00       	push   $0x80112a
  8002ce:	6a 4c                	push   $0x4c
  8002d0:	68 47 11 80 00       	push   $0x801147
  8002d5:	e8 a5 00 00 00       	call   80037f <_panic>

008002da <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002da:	55                   	push   %ebp
  8002db:	89 e5                	mov    %esp,%ebp
  8002dd:	57                   	push   %edi
  8002de:	56                   	push   %esi
  8002df:	53                   	push   %ebx
	asm volatile("int %1\n"
  8002e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8002e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002e6:	b8 0c 00 00 00       	mov    $0xc,%eax
  8002eb:	be 00 00 00 00       	mov    $0x0,%esi
  8002f0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8002f3:	8b 7d 14             	mov    0x14(%ebp),%edi
  8002f6:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8002f8:	5b                   	pop    %ebx
  8002f9:	5e                   	pop    %esi
  8002fa:	5f                   	pop    %edi
  8002fb:	5d                   	pop    %ebp
  8002fc:	c3                   	ret    

008002fd <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8002fd:	55                   	push   %ebp
  8002fe:	89 e5                	mov    %esp,%ebp
  800300:	57                   	push   %edi
  800301:	56                   	push   %esi
  800302:	53                   	push   %ebx
  800303:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800306:	b9 00 00 00 00       	mov    $0x0,%ecx
  80030b:	8b 55 08             	mov    0x8(%ebp),%edx
  80030e:	b8 0d 00 00 00       	mov    $0xd,%eax
  800313:	89 cb                	mov    %ecx,%ebx
  800315:	89 cf                	mov    %ecx,%edi
  800317:	89 ce                	mov    %ecx,%esi
  800319:	cd 30                	int    $0x30
	if (check && ret > 0)
  80031b:	85 c0                	test   %eax,%eax
  80031d:	7f 08                	jg     800327 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80031f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800322:	5b                   	pop    %ebx
  800323:	5e                   	pop    %esi
  800324:	5f                   	pop    %edi
  800325:	5d                   	pop    %ebp
  800326:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800327:	83 ec 0c             	sub    $0xc,%esp
  80032a:	50                   	push   %eax
  80032b:	6a 0d                	push   $0xd
  80032d:	68 2a 11 80 00       	push   $0x80112a
  800332:	6a 4c                	push   $0x4c
  800334:	68 47 11 80 00       	push   $0x801147
  800339:	e8 41 00 00 00       	call   80037f <_panic>

0080033e <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  80033e:	55                   	push   %ebp
  80033f:	89 e5                	mov    %esp,%ebp
  800341:	57                   	push   %edi
  800342:	56                   	push   %esi
  800343:	53                   	push   %ebx
	asm volatile("int %1\n"
  800344:	bb 00 00 00 00       	mov    $0x0,%ebx
  800349:	8b 55 08             	mov    0x8(%ebp),%edx
  80034c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80034f:	b8 0e 00 00 00       	mov    $0xe,%eax
  800354:	89 df                	mov    %ebx,%edi
  800356:	89 de                	mov    %ebx,%esi
  800358:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  80035a:	5b                   	pop    %ebx
  80035b:	5e                   	pop    %esi
  80035c:	5f                   	pop    %edi
  80035d:	5d                   	pop    %ebp
  80035e:	c3                   	ret    

0080035f <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  80035f:	55                   	push   %ebp
  800360:	89 e5                	mov    %esp,%ebp
  800362:	57                   	push   %edi
  800363:	56                   	push   %esi
  800364:	53                   	push   %ebx
	asm volatile("int %1\n"
  800365:	b9 00 00 00 00       	mov    $0x0,%ecx
  80036a:	8b 55 08             	mov    0x8(%ebp),%edx
  80036d:	b8 0f 00 00 00       	mov    $0xf,%eax
  800372:	89 cb                	mov    %ecx,%ebx
  800374:	89 cf                	mov    %ecx,%edi
  800376:	89 ce                	mov    %ecx,%esi
  800378:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  80037a:	5b                   	pop    %ebx
  80037b:	5e                   	pop    %esi
  80037c:	5f                   	pop    %edi
  80037d:	5d                   	pop    %ebp
  80037e:	c3                   	ret    

0080037f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80037f:	55                   	push   %ebp
  800380:	89 e5                	mov    %esp,%ebp
  800382:	56                   	push   %esi
  800383:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800384:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800387:	8b 35 00 20 80 00    	mov    0x802000,%esi
  80038d:	e8 7d fd ff ff       	call   80010f <sys_getenvid>
  800392:	83 ec 0c             	sub    $0xc,%esp
  800395:	ff 75 0c             	pushl  0xc(%ebp)
  800398:	ff 75 08             	pushl  0x8(%ebp)
  80039b:	56                   	push   %esi
  80039c:	50                   	push   %eax
  80039d:	68 58 11 80 00       	push   $0x801158
  8003a2:	e8 b3 00 00 00       	call   80045a <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8003a7:	83 c4 18             	add    $0x18,%esp
  8003aa:	53                   	push   %ebx
  8003ab:	ff 75 10             	pushl  0x10(%ebp)
  8003ae:	e8 56 00 00 00       	call   800409 <vcprintf>
	cprintf("\n");
  8003b3:	c7 04 24 7b 11 80 00 	movl   $0x80117b,(%esp)
  8003ba:	e8 9b 00 00 00       	call   80045a <cprintf>
  8003bf:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8003c2:	cc                   	int3   
  8003c3:	eb fd                	jmp    8003c2 <_panic+0x43>

008003c5 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8003c5:	55                   	push   %ebp
  8003c6:	89 e5                	mov    %esp,%ebp
  8003c8:	53                   	push   %ebx
  8003c9:	83 ec 04             	sub    $0x4,%esp
  8003cc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8003cf:	8b 13                	mov    (%ebx),%edx
  8003d1:	8d 42 01             	lea    0x1(%edx),%eax
  8003d4:	89 03                	mov    %eax,(%ebx)
  8003d6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003d9:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8003dd:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003e2:	74 09                	je     8003ed <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8003e4:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8003e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003eb:	c9                   	leave  
  8003ec:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8003ed:	83 ec 08             	sub    $0x8,%esp
  8003f0:	68 ff 00 00 00       	push   $0xff
  8003f5:	8d 43 08             	lea    0x8(%ebx),%eax
  8003f8:	50                   	push   %eax
  8003f9:	e8 93 fc ff ff       	call   800091 <sys_cputs>
		b->idx = 0;
  8003fe:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800404:	83 c4 10             	add    $0x10,%esp
  800407:	eb db                	jmp    8003e4 <putch+0x1f>

00800409 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800409:	55                   	push   %ebp
  80040a:	89 e5                	mov    %esp,%ebp
  80040c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800412:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800419:	00 00 00 
	b.cnt = 0;
  80041c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800423:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800426:	ff 75 0c             	pushl  0xc(%ebp)
  800429:	ff 75 08             	pushl  0x8(%ebp)
  80042c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800432:	50                   	push   %eax
  800433:	68 c5 03 80 00       	push   $0x8003c5
  800438:	e8 4a 01 00 00       	call   800587 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80043d:	83 c4 08             	add    $0x8,%esp
  800440:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800446:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80044c:	50                   	push   %eax
  80044d:	e8 3f fc ff ff       	call   800091 <sys_cputs>

	return b.cnt;
}
  800452:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800458:	c9                   	leave  
  800459:	c3                   	ret    

0080045a <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80045a:	55                   	push   %ebp
  80045b:	89 e5                	mov    %esp,%ebp
  80045d:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800460:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800463:	50                   	push   %eax
  800464:	ff 75 08             	pushl  0x8(%ebp)
  800467:	e8 9d ff ff ff       	call   800409 <vcprintf>
	va_end(ap);

	return cnt;
}
  80046c:	c9                   	leave  
  80046d:	c3                   	ret    

0080046e <printnum>:


static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80046e:	55                   	push   %ebp
  80046f:	89 e5                	mov    %esp,%ebp
  800471:	57                   	push   %edi
  800472:	56                   	push   %esi
  800473:	53                   	push   %ebx
  800474:	83 ec 1c             	sub    $0x1c,%esp
  800477:	89 c6                	mov    %eax,%esi
  800479:	89 d7                	mov    %edx,%edi
  80047b:	8b 45 08             	mov    0x8(%ebp),%eax
  80047e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800481:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800484:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800487:	8b 45 10             	mov    0x10(%ebp),%eax
  80048a:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	// to support '-'
	if(padc == '-'){
  80048d:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800491:	74 2c                	je     8004bf <printnum+0x51>
		while (--width > 0)
			putch(' ', putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800493:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800496:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80049d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004a0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8004a3:	39 c2                	cmp    %eax,%edx
  8004a5:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8004a8:	73 43                	jae    8004ed <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004aa:	83 eb 01             	sub    $0x1,%ebx
  8004ad:	85 db                	test   %ebx,%ebx
  8004af:	7e 6c                	jle    80051d <printnum+0xaf>
			putch(padc, putdat);
  8004b1:	83 ec 08             	sub    $0x8,%esp
  8004b4:	57                   	push   %edi
  8004b5:	ff 75 18             	pushl  0x18(%ebp)
  8004b8:	ff d6                	call   *%esi
  8004ba:	83 c4 10             	add    $0x10,%esp
  8004bd:	eb eb                	jmp    8004aa <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8004bf:	83 ec 0c             	sub    $0xc,%esp
  8004c2:	6a 20                	push   $0x20
  8004c4:	6a 00                	push   $0x0
  8004c6:	50                   	push   %eax
  8004c7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004ca:	ff 75 e0             	pushl  -0x20(%ebp)
  8004cd:	89 fa                	mov    %edi,%edx
  8004cf:	89 f0                	mov    %esi,%eax
  8004d1:	e8 98 ff ff ff       	call   80046e <printnum>
		while (--width > 0)
  8004d6:	83 c4 20             	add    $0x20,%esp
  8004d9:	83 eb 01             	sub    $0x1,%ebx
  8004dc:	85 db                	test   %ebx,%ebx
  8004de:	7e 65                	jle    800545 <printnum+0xd7>
			putch(' ', putdat);
  8004e0:	83 ec 08             	sub    $0x8,%esp
  8004e3:	57                   	push   %edi
  8004e4:	6a 20                	push   $0x20
  8004e6:	ff d6                	call   *%esi
  8004e8:	83 c4 10             	add    $0x10,%esp
  8004eb:	eb ec                	jmp    8004d9 <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004ed:	83 ec 0c             	sub    $0xc,%esp
  8004f0:	ff 75 18             	pushl  0x18(%ebp)
  8004f3:	83 eb 01             	sub    $0x1,%ebx
  8004f6:	53                   	push   %ebx
  8004f7:	50                   	push   %eax
  8004f8:	83 ec 08             	sub    $0x8,%esp
  8004fb:	ff 75 dc             	pushl  -0x24(%ebp)
  8004fe:	ff 75 d8             	pushl  -0x28(%ebp)
  800501:	ff 75 e4             	pushl  -0x1c(%ebp)
  800504:	ff 75 e0             	pushl  -0x20(%ebp)
  800507:	e8 b4 09 00 00       	call   800ec0 <__udivdi3>
  80050c:	83 c4 18             	add    $0x18,%esp
  80050f:	52                   	push   %edx
  800510:	50                   	push   %eax
  800511:	89 fa                	mov    %edi,%edx
  800513:	89 f0                	mov    %esi,%eax
  800515:	e8 54 ff ff ff       	call   80046e <printnum>
  80051a:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80051d:	83 ec 08             	sub    $0x8,%esp
  800520:	57                   	push   %edi
  800521:	83 ec 04             	sub    $0x4,%esp
  800524:	ff 75 dc             	pushl  -0x24(%ebp)
  800527:	ff 75 d8             	pushl  -0x28(%ebp)
  80052a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80052d:	ff 75 e0             	pushl  -0x20(%ebp)
  800530:	e8 9b 0a 00 00       	call   800fd0 <__umoddi3>
  800535:	83 c4 14             	add    $0x14,%esp
  800538:	0f be 80 7d 11 80 00 	movsbl 0x80117d(%eax),%eax
  80053f:	50                   	push   %eax
  800540:	ff d6                	call   *%esi
  800542:	83 c4 10             	add    $0x10,%esp
}
  800545:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800548:	5b                   	pop    %ebx
  800549:	5e                   	pop    %esi
  80054a:	5f                   	pop    %edi
  80054b:	5d                   	pop    %ebp
  80054c:	c3                   	ret    

0080054d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80054d:	55                   	push   %ebp
  80054e:	89 e5                	mov    %esp,%ebp
  800550:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800553:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800557:	8b 10                	mov    (%eax),%edx
  800559:	3b 50 04             	cmp    0x4(%eax),%edx
  80055c:	73 0a                	jae    800568 <sprintputch+0x1b>
		*b->buf++ = ch;
  80055e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800561:	89 08                	mov    %ecx,(%eax)
  800563:	8b 45 08             	mov    0x8(%ebp),%eax
  800566:	88 02                	mov    %al,(%edx)
}
  800568:	5d                   	pop    %ebp
  800569:	c3                   	ret    

0080056a <printfmt>:
{
  80056a:	55                   	push   %ebp
  80056b:	89 e5                	mov    %esp,%ebp
  80056d:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800570:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800573:	50                   	push   %eax
  800574:	ff 75 10             	pushl  0x10(%ebp)
  800577:	ff 75 0c             	pushl  0xc(%ebp)
  80057a:	ff 75 08             	pushl  0x8(%ebp)
  80057d:	e8 05 00 00 00       	call   800587 <vprintfmt>
}
  800582:	83 c4 10             	add    $0x10,%esp
  800585:	c9                   	leave  
  800586:	c3                   	ret    

00800587 <vprintfmt>:
{
  800587:	55                   	push   %ebp
  800588:	89 e5                	mov    %esp,%ebp
  80058a:	57                   	push   %edi
  80058b:	56                   	push   %esi
  80058c:	53                   	push   %ebx
  80058d:	83 ec 3c             	sub    $0x3c,%esp
  800590:	8b 75 08             	mov    0x8(%ebp),%esi
  800593:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800596:	8b 7d 10             	mov    0x10(%ebp),%edi
  800599:	e9 1e 04 00 00       	jmp    8009bc <vprintfmt+0x435>
		posflag = 0;
  80059e:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
		padc = ' ';
  8005a5:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8005a9:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8005b0:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8005b7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8005be:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  8005c5:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8005ca:	8d 47 01             	lea    0x1(%edi),%eax
  8005cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005d0:	0f b6 17             	movzbl (%edi),%edx
  8005d3:	8d 42 dd             	lea    -0x23(%edx),%eax
  8005d6:	3c 55                	cmp    $0x55,%al
  8005d8:	0f 87 d9 04 00 00    	ja     800ab7 <vprintfmt+0x530>
  8005de:	0f b6 c0             	movzbl %al,%eax
  8005e1:	ff 24 85 60 13 80 00 	jmp    *0x801360(,%eax,4)
  8005e8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8005eb:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8005ef:	eb d9                	jmp    8005ca <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8005f1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posflag = 1;
  8005f4:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  8005fb:	eb cd                	jmp    8005ca <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8005fd:	0f b6 d2             	movzbl %dl,%edx
  800600:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800603:	b8 00 00 00 00       	mov    $0x0,%eax
  800608:	89 75 08             	mov    %esi,0x8(%ebp)
  80060b:	eb 0c                	jmp    800619 <vprintfmt+0x92>
		switch (ch = *(unsigned char *) fmt++) {
  80060d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800610:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  800614:	eb b4                	jmp    8005ca <vprintfmt+0x43>
			for (precision = 0; ; ++fmt) {
  800616:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800619:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80061c:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800620:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800623:	8d 72 d0             	lea    -0x30(%edx),%esi
  800626:	83 fe 09             	cmp    $0x9,%esi
  800629:	76 eb                	jbe    800616 <vprintfmt+0x8f>
  80062b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80062e:	8b 75 08             	mov    0x8(%ebp),%esi
  800631:	eb 14                	jmp    800647 <vprintfmt+0xc0>
			precision = va_arg(ap, int);
  800633:	8b 45 14             	mov    0x14(%ebp),%eax
  800636:	8b 00                	mov    (%eax),%eax
  800638:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80063b:	8b 45 14             	mov    0x14(%ebp),%eax
  80063e:	8d 40 04             	lea    0x4(%eax),%eax
  800641:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800644:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800647:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80064b:	0f 89 79 ff ff ff    	jns    8005ca <vprintfmt+0x43>
				width = precision, precision = -1;
  800651:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800654:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800657:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80065e:	e9 67 ff ff ff       	jmp    8005ca <vprintfmt+0x43>
  800663:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800666:	85 c0                	test   %eax,%eax
  800668:	0f 48 c1             	cmovs  %ecx,%eax
  80066b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80066e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800671:	e9 54 ff ff ff       	jmp    8005ca <vprintfmt+0x43>
  800676:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800679:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800680:	e9 45 ff ff ff       	jmp    8005ca <vprintfmt+0x43>
			lflag++;
  800685:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800689:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80068c:	e9 39 ff ff ff       	jmp    8005ca <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800691:	8b 45 14             	mov    0x14(%ebp),%eax
  800694:	8d 78 04             	lea    0x4(%eax),%edi
  800697:	83 ec 08             	sub    $0x8,%esp
  80069a:	53                   	push   %ebx
  80069b:	ff 30                	pushl  (%eax)
  80069d:	ff d6                	call   *%esi
			break;
  80069f:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8006a2:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8006a5:	e9 0f 03 00 00       	jmp    8009b9 <vprintfmt+0x432>
			err = va_arg(ap, int);
  8006aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ad:	8d 78 04             	lea    0x4(%eax),%edi
  8006b0:	8b 00                	mov    (%eax),%eax
  8006b2:	99                   	cltd   
  8006b3:	31 d0                	xor    %edx,%eax
  8006b5:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8006b7:	83 f8 0f             	cmp    $0xf,%eax
  8006ba:	7f 23                	jg     8006df <vprintfmt+0x158>
  8006bc:	8b 14 85 c0 14 80 00 	mov    0x8014c0(,%eax,4),%edx
  8006c3:	85 d2                	test   %edx,%edx
  8006c5:	74 18                	je     8006df <vprintfmt+0x158>
				printfmt(putch, putdat, "%s", p);
  8006c7:	52                   	push   %edx
  8006c8:	68 9e 11 80 00       	push   $0x80119e
  8006cd:	53                   	push   %ebx
  8006ce:	56                   	push   %esi
  8006cf:	e8 96 fe ff ff       	call   80056a <printfmt>
  8006d4:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8006d7:	89 7d 14             	mov    %edi,0x14(%ebp)
  8006da:	e9 da 02 00 00       	jmp    8009b9 <vprintfmt+0x432>
				printfmt(putch, putdat, "error %d", err);
  8006df:	50                   	push   %eax
  8006e0:	68 95 11 80 00       	push   $0x801195
  8006e5:	53                   	push   %ebx
  8006e6:	56                   	push   %esi
  8006e7:	e8 7e fe ff ff       	call   80056a <printfmt>
  8006ec:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8006ef:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8006f2:	e9 c2 02 00 00       	jmp    8009b9 <vprintfmt+0x432>
			if ((p = va_arg(ap, char *)) == NULL)
  8006f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fa:	83 c0 04             	add    $0x4,%eax
  8006fd:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800700:	8b 45 14             	mov    0x14(%ebp),%eax
  800703:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800705:	85 c9                	test   %ecx,%ecx
  800707:	b8 8e 11 80 00       	mov    $0x80118e,%eax
  80070c:	0f 45 c1             	cmovne %ecx,%eax
  80070f:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800712:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800716:	7e 06                	jle    80071e <vprintfmt+0x197>
  800718:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80071c:	75 0d                	jne    80072b <vprintfmt+0x1a4>
				for (width -= strnlen(p, precision); width > 0; width--)
  80071e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800721:	89 c7                	mov    %eax,%edi
  800723:	03 45 e0             	add    -0x20(%ebp),%eax
  800726:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800729:	eb 53                	jmp    80077e <vprintfmt+0x1f7>
  80072b:	83 ec 08             	sub    $0x8,%esp
  80072e:	ff 75 d8             	pushl  -0x28(%ebp)
  800731:	50                   	push   %eax
  800732:	e8 28 04 00 00       	call   800b5f <strnlen>
  800737:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80073a:	29 c1                	sub    %eax,%ecx
  80073c:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  80073f:	83 c4 10             	add    $0x10,%esp
  800742:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800744:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800748:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80074b:	eb 0f                	jmp    80075c <vprintfmt+0x1d5>
					putch(padc, putdat);
  80074d:	83 ec 08             	sub    $0x8,%esp
  800750:	53                   	push   %ebx
  800751:	ff 75 e0             	pushl  -0x20(%ebp)
  800754:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800756:	83 ef 01             	sub    $0x1,%edi
  800759:	83 c4 10             	add    $0x10,%esp
  80075c:	85 ff                	test   %edi,%edi
  80075e:	7f ed                	jg     80074d <vprintfmt+0x1c6>
  800760:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  800763:	85 c9                	test   %ecx,%ecx
  800765:	b8 00 00 00 00       	mov    $0x0,%eax
  80076a:	0f 49 c1             	cmovns %ecx,%eax
  80076d:	29 c1                	sub    %eax,%ecx
  80076f:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800772:	eb aa                	jmp    80071e <vprintfmt+0x197>
					putch(ch, putdat);
  800774:	83 ec 08             	sub    $0x8,%esp
  800777:	53                   	push   %ebx
  800778:	52                   	push   %edx
  800779:	ff d6                	call   *%esi
  80077b:	83 c4 10             	add    $0x10,%esp
  80077e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800781:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800783:	83 c7 01             	add    $0x1,%edi
  800786:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80078a:	0f be d0             	movsbl %al,%edx
  80078d:	85 d2                	test   %edx,%edx
  80078f:	74 4b                	je     8007dc <vprintfmt+0x255>
  800791:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800795:	78 06                	js     80079d <vprintfmt+0x216>
  800797:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80079b:	78 1e                	js     8007bb <vprintfmt+0x234>
				if (altflag && (ch < ' ' || ch > '~'))
  80079d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8007a1:	74 d1                	je     800774 <vprintfmt+0x1ed>
  8007a3:	0f be c0             	movsbl %al,%eax
  8007a6:	83 e8 20             	sub    $0x20,%eax
  8007a9:	83 f8 5e             	cmp    $0x5e,%eax
  8007ac:	76 c6                	jbe    800774 <vprintfmt+0x1ed>
					putch('?', putdat);
  8007ae:	83 ec 08             	sub    $0x8,%esp
  8007b1:	53                   	push   %ebx
  8007b2:	6a 3f                	push   $0x3f
  8007b4:	ff d6                	call   *%esi
  8007b6:	83 c4 10             	add    $0x10,%esp
  8007b9:	eb c3                	jmp    80077e <vprintfmt+0x1f7>
  8007bb:	89 cf                	mov    %ecx,%edi
  8007bd:	eb 0e                	jmp    8007cd <vprintfmt+0x246>
				putch(' ', putdat);
  8007bf:	83 ec 08             	sub    $0x8,%esp
  8007c2:	53                   	push   %ebx
  8007c3:	6a 20                	push   $0x20
  8007c5:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8007c7:	83 ef 01             	sub    $0x1,%edi
  8007ca:	83 c4 10             	add    $0x10,%esp
  8007cd:	85 ff                	test   %edi,%edi
  8007cf:	7f ee                	jg     8007bf <vprintfmt+0x238>
			if ((p = va_arg(ap, char *)) == NULL)
  8007d1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8007d4:	89 45 14             	mov    %eax,0x14(%ebp)
  8007d7:	e9 dd 01 00 00       	jmp    8009b9 <vprintfmt+0x432>
  8007dc:	89 cf                	mov    %ecx,%edi
  8007de:	eb ed                	jmp    8007cd <vprintfmt+0x246>
	if (lflag >= 2)
  8007e0:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8007e4:	7f 21                	jg     800807 <vprintfmt+0x280>
	else if (lflag)
  8007e6:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8007ea:	74 6a                	je     800856 <vprintfmt+0x2cf>
		return va_arg(*ap, long);
  8007ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ef:	8b 00                	mov    (%eax),%eax
  8007f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007f4:	89 c1                	mov    %eax,%ecx
  8007f6:	c1 f9 1f             	sar    $0x1f,%ecx
  8007f9:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8007fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ff:	8d 40 04             	lea    0x4(%eax),%eax
  800802:	89 45 14             	mov    %eax,0x14(%ebp)
  800805:	eb 17                	jmp    80081e <vprintfmt+0x297>
		return va_arg(*ap, long long);
  800807:	8b 45 14             	mov    0x14(%ebp),%eax
  80080a:	8b 50 04             	mov    0x4(%eax),%edx
  80080d:	8b 00                	mov    (%eax),%eax
  80080f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800812:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800815:	8b 45 14             	mov    0x14(%ebp),%eax
  800818:	8d 40 08             	lea    0x8(%eax),%eax
  80081b:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80081e:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  800821:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800826:	85 d2                	test   %edx,%edx
  800828:	0f 89 5c 01 00 00    	jns    80098a <vprintfmt+0x403>
				putch('-', putdat);
  80082e:	83 ec 08             	sub    $0x8,%esp
  800831:	53                   	push   %ebx
  800832:	6a 2d                	push   $0x2d
  800834:	ff d6                	call   *%esi
				num = -(long long) num;
  800836:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800839:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80083c:	f7 d8                	neg    %eax
  80083e:	83 d2 00             	adc    $0x0,%edx
  800841:	f7 da                	neg    %edx
  800843:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800846:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800849:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80084c:	bf 0a 00 00 00       	mov    $0xa,%edi
  800851:	e9 45 01 00 00       	jmp    80099b <vprintfmt+0x414>
		return va_arg(*ap, int);
  800856:	8b 45 14             	mov    0x14(%ebp),%eax
  800859:	8b 00                	mov    (%eax),%eax
  80085b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80085e:	89 c1                	mov    %eax,%ecx
  800860:	c1 f9 1f             	sar    $0x1f,%ecx
  800863:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800866:	8b 45 14             	mov    0x14(%ebp),%eax
  800869:	8d 40 04             	lea    0x4(%eax),%eax
  80086c:	89 45 14             	mov    %eax,0x14(%ebp)
  80086f:	eb ad                	jmp    80081e <vprintfmt+0x297>
	if (lflag >= 2)
  800871:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800875:	7f 29                	jg     8008a0 <vprintfmt+0x319>
	else if (lflag)
  800877:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80087b:	74 44                	je     8008c1 <vprintfmt+0x33a>
		return va_arg(*ap, unsigned long);
  80087d:	8b 45 14             	mov    0x14(%ebp),%eax
  800880:	8b 00                	mov    (%eax),%eax
  800882:	ba 00 00 00 00       	mov    $0x0,%edx
  800887:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80088a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80088d:	8b 45 14             	mov    0x14(%ebp),%eax
  800890:	8d 40 04             	lea    0x4(%eax),%eax
  800893:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800896:	bf 0a 00 00 00       	mov    $0xa,%edi
  80089b:	e9 ea 00 00 00       	jmp    80098a <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  8008a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a3:	8b 50 04             	mov    0x4(%eax),%edx
  8008a6:	8b 00                	mov    (%eax),%eax
  8008a8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008ab:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b1:	8d 40 08             	lea    0x8(%eax),%eax
  8008b4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008b7:	bf 0a 00 00 00       	mov    $0xa,%edi
  8008bc:	e9 c9 00 00 00       	jmp    80098a <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
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
  8008df:	e9 a6 00 00 00       	jmp    80098a <vprintfmt+0x403>
			putch('0', putdat);
  8008e4:	83 ec 08             	sub    $0x8,%esp
  8008e7:	53                   	push   %ebx
  8008e8:	6a 30                	push   $0x30
  8008ea:	ff d6                	call   *%esi
	if (lflag >= 2)
  8008ec:	83 c4 10             	add    $0x10,%esp
  8008ef:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8008f3:	7f 26                	jg     80091b <vprintfmt+0x394>
	else if (lflag)
  8008f5:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8008f9:	74 3e                	je     800939 <vprintfmt+0x3b2>
		return va_arg(*ap, unsigned long);
  8008fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008fe:	8b 00                	mov    (%eax),%eax
  800900:	ba 00 00 00 00       	mov    $0x0,%edx
  800905:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800908:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80090b:	8b 45 14             	mov    0x14(%ebp),%eax
  80090e:	8d 40 04             	lea    0x4(%eax),%eax
  800911:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800914:	bf 08 00 00 00       	mov    $0x8,%edi
  800919:	eb 6f                	jmp    80098a <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  80091b:	8b 45 14             	mov    0x14(%ebp),%eax
  80091e:	8b 50 04             	mov    0x4(%eax),%edx
  800921:	8b 00                	mov    (%eax),%eax
  800923:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800926:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800929:	8b 45 14             	mov    0x14(%ebp),%eax
  80092c:	8d 40 08             	lea    0x8(%eax),%eax
  80092f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800932:	bf 08 00 00 00       	mov    $0x8,%edi
  800937:	eb 51                	jmp    80098a <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  800939:	8b 45 14             	mov    0x14(%ebp),%eax
  80093c:	8b 00                	mov    (%eax),%eax
  80093e:	ba 00 00 00 00       	mov    $0x0,%edx
  800943:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800946:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800949:	8b 45 14             	mov    0x14(%ebp),%eax
  80094c:	8d 40 04             	lea    0x4(%eax),%eax
  80094f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800952:	bf 08 00 00 00       	mov    $0x8,%edi
  800957:	eb 31                	jmp    80098a <vprintfmt+0x403>
			putch('0', putdat);
  800959:	83 ec 08             	sub    $0x8,%esp
  80095c:	53                   	push   %ebx
  80095d:	6a 30                	push   $0x30
  80095f:	ff d6                	call   *%esi
			putch('x', putdat);
  800961:	83 c4 08             	add    $0x8,%esp
  800964:	53                   	push   %ebx
  800965:	6a 78                	push   $0x78
  800967:	ff d6                	call   *%esi
			num = (unsigned long long)
  800969:	8b 45 14             	mov    0x14(%ebp),%eax
  80096c:	8b 00                	mov    (%eax),%eax
  80096e:	ba 00 00 00 00       	mov    $0x0,%edx
  800973:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800976:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800979:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80097c:	8b 45 14             	mov    0x14(%ebp),%eax
  80097f:	8d 40 04             	lea    0x4(%eax),%eax
  800982:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800985:	bf 10 00 00 00       	mov    $0x10,%edi
			if(posflag)
  80098a:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80098e:	74 0b                	je     80099b <vprintfmt+0x414>
				putch('+', putdat);
  800990:	83 ec 08             	sub    $0x8,%esp
  800993:	53                   	push   %ebx
  800994:	6a 2b                	push   $0x2b
  800996:	ff d6                	call   *%esi
  800998:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  80099b:	83 ec 0c             	sub    $0xc,%esp
  80099e:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8009a2:	50                   	push   %eax
  8009a3:	ff 75 e0             	pushl  -0x20(%ebp)
  8009a6:	57                   	push   %edi
  8009a7:	ff 75 dc             	pushl  -0x24(%ebp)
  8009aa:	ff 75 d8             	pushl  -0x28(%ebp)
  8009ad:	89 da                	mov    %ebx,%edx
  8009af:	89 f0                	mov    %esi,%eax
  8009b1:	e8 b8 fa ff ff       	call   80046e <printnum>
			break;
  8009b6:	83 c4 20             	add    $0x20,%esp
			char* cp = va_arg(ap, char *);
  8009b9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009bc:	83 c7 01             	add    $0x1,%edi
  8009bf:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8009c3:	83 f8 25             	cmp    $0x25,%eax
  8009c6:	0f 84 d2 fb ff ff    	je     80059e <vprintfmt+0x17>
			if (ch == '\0')
  8009cc:	85 c0                	test   %eax,%eax
  8009ce:	0f 84 03 01 00 00    	je     800ad7 <vprintfmt+0x550>
			putch(ch, putdat);
  8009d4:	83 ec 08             	sub    $0x8,%esp
  8009d7:	53                   	push   %ebx
  8009d8:	50                   	push   %eax
  8009d9:	ff d6                	call   *%esi
  8009db:	83 c4 10             	add    $0x10,%esp
  8009de:	eb dc                	jmp    8009bc <vprintfmt+0x435>
	if (lflag >= 2)
  8009e0:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8009e4:	7f 29                	jg     800a0f <vprintfmt+0x488>
	else if (lflag)
  8009e6:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8009ea:	74 44                	je     800a30 <vprintfmt+0x4a9>
		return va_arg(*ap, unsigned long);
  8009ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ef:	8b 00                	mov    (%eax),%eax
  8009f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8009f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009f9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ff:	8d 40 04             	lea    0x4(%eax),%eax
  800a02:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a05:	bf 10 00 00 00       	mov    $0x10,%edi
  800a0a:	e9 7b ff ff ff       	jmp    80098a <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  800a0f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a12:	8b 50 04             	mov    0x4(%eax),%edx
  800a15:	8b 00                	mov    (%eax),%eax
  800a17:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a1a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a1d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a20:	8d 40 08             	lea    0x8(%eax),%eax
  800a23:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a26:	bf 10 00 00 00       	mov    $0x10,%edi
  800a2b:	e9 5a ff ff ff       	jmp    80098a <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
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
  800a4e:	e9 37 ff ff ff       	jmp    80098a <vprintfmt+0x403>
			char* cp = va_arg(ap, char *);
  800a53:	8b 45 14             	mov    0x14(%ebp),%eax
  800a56:	8d 78 04             	lea    0x4(%eax),%edi
  800a59:	8b 00                	mov    (%eax),%eax
    			if (cp == NULL) {
  800a5b:	85 c0                	test   %eax,%eax
  800a5d:	74 2c                	je     800a8b <vprintfmt+0x504>
    			*cp = *(int *)putdat;
  800a5f:	8b 13                	mov    (%ebx),%edx
  800a61:	88 10                	mov    %dl,(%eax)
			char* cp = va_arg(ap, char *);
  800a63:	89 7d 14             	mov    %edi,0x14(%ebp)
    			if ((*(int *) putdat) > 127)
  800a66:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  800a69:	0f 8e 4a ff ff ff    	jle    8009b9 <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", overflow_error);
  800a6f:	68 ec 12 80 00       	push   $0x8012ec
  800a74:	68 9e 11 80 00       	push   $0x80119e
  800a79:	53                   	push   %ebx
  800a7a:	56                   	push   %esi
  800a7b:	e8 ea fa ff ff       	call   80056a <printfmt>
  800a80:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  800a83:	89 7d 14             	mov    %edi,0x14(%ebp)
  800a86:	e9 2e ff ff ff       	jmp    8009b9 <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", null_error);
  800a8b:	68 b4 12 80 00       	push   $0x8012b4
  800a90:	68 9e 11 80 00       	push   $0x80119e
  800a95:	53                   	push   %ebx
  800a96:	56                   	push   %esi
  800a97:	e8 ce fa ff ff       	call   80056a <printfmt>
        		break;
  800a9c:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  800a9f:	89 7d 14             	mov    %edi,0x14(%ebp)
        		break;
  800aa2:	e9 12 ff ff ff       	jmp    8009b9 <vprintfmt+0x432>
			putch(ch, putdat);
  800aa7:	83 ec 08             	sub    $0x8,%esp
  800aaa:	53                   	push   %ebx
  800aab:	6a 25                	push   $0x25
  800aad:	ff d6                	call   *%esi
			break;
  800aaf:	83 c4 10             	add    $0x10,%esp
  800ab2:	e9 02 ff ff ff       	jmp    8009b9 <vprintfmt+0x432>
			putch('%', putdat);
  800ab7:	83 ec 08             	sub    $0x8,%esp
  800aba:	53                   	push   %ebx
  800abb:	6a 25                	push   $0x25
  800abd:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800abf:	83 c4 10             	add    $0x10,%esp
  800ac2:	89 f8                	mov    %edi,%eax
  800ac4:	eb 03                	jmp    800ac9 <vprintfmt+0x542>
  800ac6:	83 e8 01             	sub    $0x1,%eax
  800ac9:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800acd:	75 f7                	jne    800ac6 <vprintfmt+0x53f>
  800acf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ad2:	e9 e2 fe ff ff       	jmp    8009b9 <vprintfmt+0x432>
}
  800ad7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ada:	5b                   	pop    %ebx
  800adb:	5e                   	pop    %esi
  800adc:	5f                   	pop    %edi
  800add:	5d                   	pop    %ebp
  800ade:	c3                   	ret    

00800adf <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800adf:	55                   	push   %ebp
  800ae0:	89 e5                	mov    %esp,%ebp
  800ae2:	83 ec 18             	sub    $0x18,%esp
  800ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae8:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800aeb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800aee:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800af2:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800af5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800afc:	85 c0                	test   %eax,%eax
  800afe:	74 26                	je     800b26 <vsnprintf+0x47>
  800b00:	85 d2                	test   %edx,%edx
  800b02:	7e 22                	jle    800b26 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b04:	ff 75 14             	pushl  0x14(%ebp)
  800b07:	ff 75 10             	pushl  0x10(%ebp)
  800b0a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b0d:	50                   	push   %eax
  800b0e:	68 4d 05 80 00       	push   $0x80054d
  800b13:	e8 6f fa ff ff       	call   800587 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800b18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b1b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b21:	83 c4 10             	add    $0x10,%esp
}
  800b24:	c9                   	leave  
  800b25:	c3                   	ret    
		return -E_INVAL;
  800b26:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b2b:	eb f7                	jmp    800b24 <vsnprintf+0x45>

00800b2d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b2d:	55                   	push   %ebp
  800b2e:	89 e5                	mov    %esp,%ebp
  800b30:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b33:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800b36:	50                   	push   %eax
  800b37:	ff 75 10             	pushl  0x10(%ebp)
  800b3a:	ff 75 0c             	pushl  0xc(%ebp)
  800b3d:	ff 75 08             	pushl  0x8(%ebp)
  800b40:	e8 9a ff ff ff       	call   800adf <vsnprintf>
	va_end(ap);

	return rc;
}
  800b45:	c9                   	leave  
  800b46:	c3                   	ret    

00800b47 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800b47:	55                   	push   %ebp
  800b48:	89 e5                	mov    %esp,%ebp
  800b4a:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800b4d:	b8 00 00 00 00       	mov    $0x0,%eax
  800b52:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800b56:	74 05                	je     800b5d <strlen+0x16>
		n++;
  800b58:	83 c0 01             	add    $0x1,%eax
  800b5b:	eb f5                	jmp    800b52 <strlen+0xb>
	return n;
}
  800b5d:	5d                   	pop    %ebp
  800b5e:	c3                   	ret    

00800b5f <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800b5f:	55                   	push   %ebp
  800b60:	89 e5                	mov    %esp,%ebp
  800b62:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b65:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b68:	ba 00 00 00 00       	mov    $0x0,%edx
  800b6d:	39 c2                	cmp    %eax,%edx
  800b6f:	74 0d                	je     800b7e <strnlen+0x1f>
  800b71:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800b75:	74 05                	je     800b7c <strnlen+0x1d>
		n++;
  800b77:	83 c2 01             	add    $0x1,%edx
  800b7a:	eb f1                	jmp    800b6d <strnlen+0xe>
  800b7c:	89 d0                	mov    %edx,%eax
	return n;
}
  800b7e:	5d                   	pop    %ebp
  800b7f:	c3                   	ret    

00800b80 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b80:	55                   	push   %ebp
  800b81:	89 e5                	mov    %esp,%ebp
  800b83:	53                   	push   %ebx
  800b84:	8b 45 08             	mov    0x8(%ebp),%eax
  800b87:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800b8a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b8f:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800b93:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800b96:	83 c2 01             	add    $0x1,%edx
  800b99:	84 c9                	test   %cl,%cl
  800b9b:	75 f2                	jne    800b8f <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800b9d:	5b                   	pop    %ebx
  800b9e:	5d                   	pop    %ebp
  800b9f:	c3                   	ret    

00800ba0 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800ba0:	55                   	push   %ebp
  800ba1:	89 e5                	mov    %esp,%ebp
  800ba3:	53                   	push   %ebx
  800ba4:	83 ec 10             	sub    $0x10,%esp
  800ba7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800baa:	53                   	push   %ebx
  800bab:	e8 97 ff ff ff       	call   800b47 <strlen>
  800bb0:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800bb3:	ff 75 0c             	pushl  0xc(%ebp)
  800bb6:	01 d8                	add    %ebx,%eax
  800bb8:	50                   	push   %eax
  800bb9:	e8 c2 ff ff ff       	call   800b80 <strcpy>
	return dst;
}
  800bbe:	89 d8                	mov    %ebx,%eax
  800bc0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800bc3:	c9                   	leave  
  800bc4:	c3                   	ret    

00800bc5 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800bc5:	55                   	push   %ebp
  800bc6:	89 e5                	mov    %esp,%ebp
  800bc8:	56                   	push   %esi
  800bc9:	53                   	push   %ebx
  800bca:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bd0:	89 c6                	mov    %eax,%esi
  800bd2:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800bd5:	89 c2                	mov    %eax,%edx
  800bd7:	39 f2                	cmp    %esi,%edx
  800bd9:	74 11                	je     800bec <strncpy+0x27>
		*dst++ = *src;
  800bdb:	83 c2 01             	add    $0x1,%edx
  800bde:	0f b6 19             	movzbl (%ecx),%ebx
  800be1:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800be4:	80 fb 01             	cmp    $0x1,%bl
  800be7:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800bea:	eb eb                	jmp    800bd7 <strncpy+0x12>
	}
	return ret;
}
  800bec:	5b                   	pop    %ebx
  800bed:	5e                   	pop    %esi
  800bee:	5d                   	pop    %ebp
  800bef:	c3                   	ret    

00800bf0 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800bf0:	55                   	push   %ebp
  800bf1:	89 e5                	mov    %esp,%ebp
  800bf3:	56                   	push   %esi
  800bf4:	53                   	push   %ebx
  800bf5:	8b 75 08             	mov    0x8(%ebp),%esi
  800bf8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bfb:	8b 55 10             	mov    0x10(%ebp),%edx
  800bfe:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800c00:	85 d2                	test   %edx,%edx
  800c02:	74 21                	je     800c25 <strlcpy+0x35>
  800c04:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800c08:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800c0a:	39 c2                	cmp    %eax,%edx
  800c0c:	74 14                	je     800c22 <strlcpy+0x32>
  800c0e:	0f b6 19             	movzbl (%ecx),%ebx
  800c11:	84 db                	test   %bl,%bl
  800c13:	74 0b                	je     800c20 <strlcpy+0x30>
			*dst++ = *src++;
  800c15:	83 c1 01             	add    $0x1,%ecx
  800c18:	83 c2 01             	add    $0x1,%edx
  800c1b:	88 5a ff             	mov    %bl,-0x1(%edx)
  800c1e:	eb ea                	jmp    800c0a <strlcpy+0x1a>
  800c20:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800c22:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c25:	29 f0                	sub    %esi,%eax
}
  800c27:	5b                   	pop    %ebx
  800c28:	5e                   	pop    %esi
  800c29:	5d                   	pop    %ebp
  800c2a:	c3                   	ret    

00800c2b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c2b:	55                   	push   %ebp
  800c2c:	89 e5                	mov    %esp,%ebp
  800c2e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c31:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800c34:	0f b6 01             	movzbl (%ecx),%eax
  800c37:	84 c0                	test   %al,%al
  800c39:	74 0c                	je     800c47 <strcmp+0x1c>
  800c3b:	3a 02                	cmp    (%edx),%al
  800c3d:	75 08                	jne    800c47 <strcmp+0x1c>
		p++, q++;
  800c3f:	83 c1 01             	add    $0x1,%ecx
  800c42:	83 c2 01             	add    $0x1,%edx
  800c45:	eb ed                	jmp    800c34 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c47:	0f b6 c0             	movzbl %al,%eax
  800c4a:	0f b6 12             	movzbl (%edx),%edx
  800c4d:	29 d0                	sub    %edx,%eax
}
  800c4f:	5d                   	pop    %ebp
  800c50:	c3                   	ret    

00800c51 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800c51:	55                   	push   %ebp
  800c52:	89 e5                	mov    %esp,%ebp
  800c54:	53                   	push   %ebx
  800c55:	8b 45 08             	mov    0x8(%ebp),%eax
  800c58:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c5b:	89 c3                	mov    %eax,%ebx
  800c5d:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800c60:	eb 06                	jmp    800c68 <strncmp+0x17>
		n--, p++, q++;
  800c62:	83 c0 01             	add    $0x1,%eax
  800c65:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800c68:	39 d8                	cmp    %ebx,%eax
  800c6a:	74 16                	je     800c82 <strncmp+0x31>
  800c6c:	0f b6 08             	movzbl (%eax),%ecx
  800c6f:	84 c9                	test   %cl,%cl
  800c71:	74 04                	je     800c77 <strncmp+0x26>
  800c73:	3a 0a                	cmp    (%edx),%cl
  800c75:	74 eb                	je     800c62 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c77:	0f b6 00             	movzbl (%eax),%eax
  800c7a:	0f b6 12             	movzbl (%edx),%edx
  800c7d:	29 d0                	sub    %edx,%eax
}
  800c7f:	5b                   	pop    %ebx
  800c80:	5d                   	pop    %ebp
  800c81:	c3                   	ret    
		return 0;
  800c82:	b8 00 00 00 00       	mov    $0x0,%eax
  800c87:	eb f6                	jmp    800c7f <strncmp+0x2e>

00800c89 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c89:	55                   	push   %ebp
  800c8a:	89 e5                	mov    %esp,%ebp
  800c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c93:	0f b6 10             	movzbl (%eax),%edx
  800c96:	84 d2                	test   %dl,%dl
  800c98:	74 09                	je     800ca3 <strchr+0x1a>
		if (*s == c)
  800c9a:	38 ca                	cmp    %cl,%dl
  800c9c:	74 0a                	je     800ca8 <strchr+0x1f>
	for (; *s; s++)
  800c9e:	83 c0 01             	add    $0x1,%eax
  800ca1:	eb f0                	jmp    800c93 <strchr+0xa>
			return (char *) s;
	return 0;
  800ca3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ca8:	5d                   	pop    %ebp
  800ca9:	c3                   	ret    

00800caa <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800caa:	55                   	push   %ebp
  800cab:	89 e5                	mov    %esp,%ebp
  800cad:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800cb4:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800cb7:	38 ca                	cmp    %cl,%dl
  800cb9:	74 09                	je     800cc4 <strfind+0x1a>
  800cbb:	84 d2                	test   %dl,%dl
  800cbd:	74 05                	je     800cc4 <strfind+0x1a>
	for (; *s; s++)
  800cbf:	83 c0 01             	add    $0x1,%eax
  800cc2:	eb f0                	jmp    800cb4 <strfind+0xa>
			break;
	return (char *) s;
}
  800cc4:	5d                   	pop    %ebp
  800cc5:	c3                   	ret    

00800cc6 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800cc6:	55                   	push   %ebp
  800cc7:	89 e5                	mov    %esp,%ebp
  800cc9:	57                   	push   %edi
  800cca:	56                   	push   %esi
  800ccb:	53                   	push   %ebx
  800ccc:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ccf:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800cd2:	85 c9                	test   %ecx,%ecx
  800cd4:	74 31                	je     800d07 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800cd6:	89 f8                	mov    %edi,%eax
  800cd8:	09 c8                	or     %ecx,%eax
  800cda:	a8 03                	test   $0x3,%al
  800cdc:	75 23                	jne    800d01 <memset+0x3b>
		c &= 0xFF;
  800cde:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ce2:	89 d3                	mov    %edx,%ebx
  800ce4:	c1 e3 08             	shl    $0x8,%ebx
  800ce7:	89 d0                	mov    %edx,%eax
  800ce9:	c1 e0 18             	shl    $0x18,%eax
  800cec:	89 d6                	mov    %edx,%esi
  800cee:	c1 e6 10             	shl    $0x10,%esi
  800cf1:	09 f0                	or     %esi,%eax
  800cf3:	09 c2                	or     %eax,%edx
  800cf5:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800cf7:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800cfa:	89 d0                	mov    %edx,%eax
  800cfc:	fc                   	cld    
  800cfd:	f3 ab                	rep stos %eax,%es:(%edi)
  800cff:	eb 06                	jmp    800d07 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d04:	fc                   	cld    
  800d05:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800d07:	89 f8                	mov    %edi,%eax
  800d09:	5b                   	pop    %ebx
  800d0a:	5e                   	pop    %esi
  800d0b:	5f                   	pop    %edi
  800d0c:	5d                   	pop    %ebp
  800d0d:	c3                   	ret    

00800d0e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800d0e:	55                   	push   %ebp
  800d0f:	89 e5                	mov    %esp,%ebp
  800d11:	57                   	push   %edi
  800d12:	56                   	push   %esi
  800d13:	8b 45 08             	mov    0x8(%ebp),%eax
  800d16:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d19:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d1c:	39 c6                	cmp    %eax,%esi
  800d1e:	73 32                	jae    800d52 <memmove+0x44>
  800d20:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800d23:	39 c2                	cmp    %eax,%edx
  800d25:	76 2b                	jbe    800d52 <memmove+0x44>
		s += n;
		d += n;
  800d27:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d2a:	89 fe                	mov    %edi,%esi
  800d2c:	09 ce                	or     %ecx,%esi
  800d2e:	09 d6                	or     %edx,%esi
  800d30:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800d36:	75 0e                	jne    800d46 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800d38:	83 ef 04             	sub    $0x4,%edi
  800d3b:	8d 72 fc             	lea    -0x4(%edx),%esi
  800d3e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800d41:	fd                   	std    
  800d42:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d44:	eb 09                	jmp    800d4f <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800d46:	83 ef 01             	sub    $0x1,%edi
  800d49:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800d4c:	fd                   	std    
  800d4d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800d4f:	fc                   	cld    
  800d50:	eb 1a                	jmp    800d6c <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d52:	89 c2                	mov    %eax,%edx
  800d54:	09 ca                	or     %ecx,%edx
  800d56:	09 f2                	or     %esi,%edx
  800d58:	f6 c2 03             	test   $0x3,%dl
  800d5b:	75 0a                	jne    800d67 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800d5d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800d60:	89 c7                	mov    %eax,%edi
  800d62:	fc                   	cld    
  800d63:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d65:	eb 05                	jmp    800d6c <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800d67:	89 c7                	mov    %eax,%edi
  800d69:	fc                   	cld    
  800d6a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800d6c:	5e                   	pop    %esi
  800d6d:	5f                   	pop    %edi
  800d6e:	5d                   	pop    %ebp
  800d6f:	c3                   	ret    

00800d70 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800d70:	55                   	push   %ebp
  800d71:	89 e5                	mov    %esp,%ebp
  800d73:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800d76:	ff 75 10             	pushl  0x10(%ebp)
  800d79:	ff 75 0c             	pushl  0xc(%ebp)
  800d7c:	ff 75 08             	pushl  0x8(%ebp)
  800d7f:	e8 8a ff ff ff       	call   800d0e <memmove>
}
  800d84:	c9                   	leave  
  800d85:	c3                   	ret    

00800d86 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800d86:	55                   	push   %ebp
  800d87:	89 e5                	mov    %esp,%ebp
  800d89:	56                   	push   %esi
  800d8a:	53                   	push   %ebx
  800d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d91:	89 c6                	mov    %eax,%esi
  800d93:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d96:	39 f0                	cmp    %esi,%eax
  800d98:	74 1c                	je     800db6 <memcmp+0x30>
		if (*s1 != *s2)
  800d9a:	0f b6 08             	movzbl (%eax),%ecx
  800d9d:	0f b6 1a             	movzbl (%edx),%ebx
  800da0:	38 d9                	cmp    %bl,%cl
  800da2:	75 08                	jne    800dac <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800da4:	83 c0 01             	add    $0x1,%eax
  800da7:	83 c2 01             	add    $0x1,%edx
  800daa:	eb ea                	jmp    800d96 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800dac:	0f b6 c1             	movzbl %cl,%eax
  800daf:	0f b6 db             	movzbl %bl,%ebx
  800db2:	29 d8                	sub    %ebx,%eax
  800db4:	eb 05                	jmp    800dbb <memcmp+0x35>
	}

	return 0;
  800db6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dbb:	5b                   	pop    %ebx
  800dbc:	5e                   	pop    %esi
  800dbd:	5d                   	pop    %ebp
  800dbe:	c3                   	ret    

00800dbf <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800dbf:	55                   	push   %ebp
  800dc0:	89 e5                	mov    %esp,%ebp
  800dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800dc8:	89 c2                	mov    %eax,%edx
  800dca:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800dcd:	39 d0                	cmp    %edx,%eax
  800dcf:	73 09                	jae    800dda <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800dd1:	38 08                	cmp    %cl,(%eax)
  800dd3:	74 05                	je     800dda <memfind+0x1b>
	for (; s < ends; s++)
  800dd5:	83 c0 01             	add    $0x1,%eax
  800dd8:	eb f3                	jmp    800dcd <memfind+0xe>
			break;
	return (void *) s;
}
  800dda:	5d                   	pop    %ebp
  800ddb:	c3                   	ret    

00800ddc <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ddc:	55                   	push   %ebp
  800ddd:	89 e5                	mov    %esp,%ebp
  800ddf:	57                   	push   %edi
  800de0:	56                   	push   %esi
  800de1:	53                   	push   %ebx
  800de2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800de5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800de8:	eb 03                	jmp    800ded <strtol+0x11>
		s++;
  800dea:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ded:	0f b6 01             	movzbl (%ecx),%eax
  800df0:	3c 20                	cmp    $0x20,%al
  800df2:	74 f6                	je     800dea <strtol+0xe>
  800df4:	3c 09                	cmp    $0x9,%al
  800df6:	74 f2                	je     800dea <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800df8:	3c 2b                	cmp    $0x2b,%al
  800dfa:	74 2a                	je     800e26 <strtol+0x4a>
	int neg = 0;
  800dfc:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800e01:	3c 2d                	cmp    $0x2d,%al
  800e03:	74 2b                	je     800e30 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e05:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800e0b:	75 0f                	jne    800e1c <strtol+0x40>
  800e0d:	80 39 30             	cmpb   $0x30,(%ecx)
  800e10:	74 28                	je     800e3a <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800e12:	85 db                	test   %ebx,%ebx
  800e14:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e19:	0f 44 d8             	cmove  %eax,%ebx
  800e1c:	b8 00 00 00 00       	mov    $0x0,%eax
  800e21:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800e24:	eb 50                	jmp    800e76 <strtol+0x9a>
		s++;
  800e26:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800e29:	bf 00 00 00 00       	mov    $0x0,%edi
  800e2e:	eb d5                	jmp    800e05 <strtol+0x29>
		s++, neg = 1;
  800e30:	83 c1 01             	add    $0x1,%ecx
  800e33:	bf 01 00 00 00       	mov    $0x1,%edi
  800e38:	eb cb                	jmp    800e05 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e3a:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800e3e:	74 0e                	je     800e4e <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800e40:	85 db                	test   %ebx,%ebx
  800e42:	75 d8                	jne    800e1c <strtol+0x40>
		s++, base = 8;
  800e44:	83 c1 01             	add    $0x1,%ecx
  800e47:	bb 08 00 00 00       	mov    $0x8,%ebx
  800e4c:	eb ce                	jmp    800e1c <strtol+0x40>
		s += 2, base = 16;
  800e4e:	83 c1 02             	add    $0x2,%ecx
  800e51:	bb 10 00 00 00       	mov    $0x10,%ebx
  800e56:	eb c4                	jmp    800e1c <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800e58:	8d 72 9f             	lea    -0x61(%edx),%esi
  800e5b:	89 f3                	mov    %esi,%ebx
  800e5d:	80 fb 19             	cmp    $0x19,%bl
  800e60:	77 29                	ja     800e8b <strtol+0xaf>
			dig = *s - 'a' + 10;
  800e62:	0f be d2             	movsbl %dl,%edx
  800e65:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800e68:	3b 55 10             	cmp    0x10(%ebp),%edx
  800e6b:	7d 30                	jge    800e9d <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800e6d:	83 c1 01             	add    $0x1,%ecx
  800e70:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e74:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800e76:	0f b6 11             	movzbl (%ecx),%edx
  800e79:	8d 72 d0             	lea    -0x30(%edx),%esi
  800e7c:	89 f3                	mov    %esi,%ebx
  800e7e:	80 fb 09             	cmp    $0x9,%bl
  800e81:	77 d5                	ja     800e58 <strtol+0x7c>
			dig = *s - '0';
  800e83:	0f be d2             	movsbl %dl,%edx
  800e86:	83 ea 30             	sub    $0x30,%edx
  800e89:	eb dd                	jmp    800e68 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800e8b:	8d 72 bf             	lea    -0x41(%edx),%esi
  800e8e:	89 f3                	mov    %esi,%ebx
  800e90:	80 fb 19             	cmp    $0x19,%bl
  800e93:	77 08                	ja     800e9d <strtol+0xc1>
			dig = *s - 'A' + 10;
  800e95:	0f be d2             	movsbl %dl,%edx
  800e98:	83 ea 37             	sub    $0x37,%edx
  800e9b:	eb cb                	jmp    800e68 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800e9d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ea1:	74 05                	je     800ea8 <strtol+0xcc>
		*endptr = (char *) s;
  800ea3:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ea6:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ea8:	89 c2                	mov    %eax,%edx
  800eaa:	f7 da                	neg    %edx
  800eac:	85 ff                	test   %edi,%edi
  800eae:	0f 45 c2             	cmovne %edx,%eax
}
  800eb1:	5b                   	pop    %ebx
  800eb2:	5e                   	pop    %esi
  800eb3:	5f                   	pop    %edi
  800eb4:	5d                   	pop    %ebp
  800eb5:	c3                   	ret    
  800eb6:	66 90                	xchg   %ax,%ax
  800eb8:	66 90                	xchg   %ax,%ax
  800eba:	66 90                	xchg   %ax,%ax
  800ebc:	66 90                	xchg   %ax,%ax
  800ebe:	66 90                	xchg   %ax,%ax

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
