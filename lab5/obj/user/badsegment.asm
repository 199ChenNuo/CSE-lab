
obj/user/badsegment.debug:     file format elf32-i386


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
  80002c:	e8 09 00 00 00       	call   80003a <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

void
umain(int argc, char **argv)
{
	// Try to load the kernel's TSS selector into the DS register.
	asm volatile("movw $0x28,%ax; movw %ax,%ds");
  800033:	66 b8 28 00          	mov    $0x28,%ax
  800037:	8e d8                	mov    %eax,%ds
}
  800039:	c3                   	ret    

0080003a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80003a:	55                   	push   %ebp
  80003b:	89 e5                	mov    %esp,%ebp
  80003d:	56                   	push   %esi
  80003e:	53                   	push   %ebx
  80003f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800042:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	// thisenv = 0;
	thisenv = &(envs[ENVX(sys_getenvid())]);
  800045:	e8 c9 00 00 00       	call   800113 <sys_getenvid>
  80004a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80004f:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  800055:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80005a:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80005f:	85 db                	test   %ebx,%ebx
  800061:	7e 07                	jle    80006a <libmain+0x30>
		binaryname = argv[0];
  800063:	8b 06                	mov    (%esi),%eax
  800065:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  80006a:	83 ec 08             	sub    $0x8,%esp
  80006d:	56                   	push   %esi
  80006e:	53                   	push   %ebx
  80006f:	e8 bf ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800074:	e8 0a 00 00 00       	call   800083 <exit>
}
  800079:	83 c4 10             	add    $0x10,%esp
  80007c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80007f:	5b                   	pop    %ebx
  800080:	5e                   	pop    %esi
  800081:	5d                   	pop    %ebp
  800082:	c3                   	ret    

00800083 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800083:	55                   	push   %ebp
  800084:	89 e5                	mov    %esp,%ebp
  800086:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  800089:	6a 00                	push   $0x0
  80008b:	e8 42 00 00 00       	call   8000d2 <sys_env_destroy>
}
  800090:	83 c4 10             	add    $0x10,%esp
  800093:	c9                   	leave  
  800094:	c3                   	ret    

00800095 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800095:	55                   	push   %ebp
  800096:	89 e5                	mov    %esp,%ebp
  800098:	57                   	push   %edi
  800099:	56                   	push   %esi
  80009a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80009b:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8000a3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000a6:	89 c3                	mov    %eax,%ebx
  8000a8:	89 c7                	mov    %eax,%edi
  8000aa:	89 c6                	mov    %eax,%esi
  8000ac:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000ae:	5b                   	pop    %ebx
  8000af:	5e                   	pop    %esi
  8000b0:	5f                   	pop    %edi
  8000b1:	5d                   	pop    %ebp
  8000b2:	c3                   	ret    

008000b3 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000b3:	55                   	push   %ebp
  8000b4:	89 e5                	mov    %esp,%ebp
  8000b6:	57                   	push   %edi
  8000b7:	56                   	push   %esi
  8000b8:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8000be:	b8 01 00 00 00       	mov    $0x1,%eax
  8000c3:	89 d1                	mov    %edx,%ecx
  8000c5:	89 d3                	mov    %edx,%ebx
  8000c7:	89 d7                	mov    %edx,%edi
  8000c9:	89 d6                	mov    %edx,%esi
  8000cb:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000cd:	5b                   	pop    %ebx
  8000ce:	5e                   	pop    %esi
  8000cf:	5f                   	pop    %edi
  8000d0:	5d                   	pop    %ebp
  8000d1:	c3                   	ret    

008000d2 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000d2:	55                   	push   %ebp
  8000d3:	89 e5                	mov    %esp,%ebp
  8000d5:	57                   	push   %edi
  8000d6:	56                   	push   %esi
  8000d7:	53                   	push   %ebx
  8000d8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000db:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8000e3:	b8 03 00 00 00       	mov    $0x3,%eax
  8000e8:	89 cb                	mov    %ecx,%ebx
  8000ea:	89 cf                	mov    %ecx,%edi
  8000ec:	89 ce                	mov    %ecx,%esi
  8000ee:	cd 30                	int    $0x30
	if (check && ret > 0)
  8000f0:	85 c0                	test   %eax,%eax
  8000f2:	7f 08                	jg     8000fc <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8000f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000f7:	5b                   	pop    %ebx
  8000f8:	5e                   	pop    %esi
  8000f9:	5f                   	pop    %edi
  8000fa:	5d                   	pop    %ebp
  8000fb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8000fc:	83 ec 0c             	sub    $0xc,%esp
  8000ff:	50                   	push   %eax
  800100:	6a 03                	push   $0x3
  800102:	68 2a 11 80 00       	push   $0x80112a
  800107:	6a 4c                	push   $0x4c
  800109:	68 47 11 80 00       	push   $0x801147
  80010e:	e8 70 02 00 00       	call   800383 <_panic>

00800113 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800113:	55                   	push   %ebp
  800114:	89 e5                	mov    %esp,%ebp
  800116:	57                   	push   %edi
  800117:	56                   	push   %esi
  800118:	53                   	push   %ebx
	asm volatile("int %1\n"
  800119:	ba 00 00 00 00       	mov    $0x0,%edx
  80011e:	b8 02 00 00 00       	mov    $0x2,%eax
  800123:	89 d1                	mov    %edx,%ecx
  800125:	89 d3                	mov    %edx,%ebx
  800127:	89 d7                	mov    %edx,%edi
  800129:	89 d6                	mov    %edx,%esi
  80012b:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80012d:	5b                   	pop    %ebx
  80012e:	5e                   	pop    %esi
  80012f:	5f                   	pop    %edi
  800130:	5d                   	pop    %ebp
  800131:	c3                   	ret    

00800132 <sys_yield>:

void
sys_yield(void)
{
  800132:	55                   	push   %ebp
  800133:	89 e5                	mov    %esp,%ebp
  800135:	57                   	push   %edi
  800136:	56                   	push   %esi
  800137:	53                   	push   %ebx
	asm volatile("int %1\n"
  800138:	ba 00 00 00 00       	mov    $0x0,%edx
  80013d:	b8 0b 00 00 00       	mov    $0xb,%eax
  800142:	89 d1                	mov    %edx,%ecx
  800144:	89 d3                	mov    %edx,%ebx
  800146:	89 d7                	mov    %edx,%edi
  800148:	89 d6                	mov    %edx,%esi
  80014a:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80014c:	5b                   	pop    %ebx
  80014d:	5e                   	pop    %esi
  80014e:	5f                   	pop    %edi
  80014f:	5d                   	pop    %ebp
  800150:	c3                   	ret    

00800151 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800151:	55                   	push   %ebp
  800152:	89 e5                	mov    %esp,%ebp
  800154:	57                   	push   %edi
  800155:	56                   	push   %esi
  800156:	53                   	push   %ebx
  800157:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80015a:	be 00 00 00 00       	mov    $0x0,%esi
  80015f:	8b 55 08             	mov    0x8(%ebp),%edx
  800162:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800165:	b8 04 00 00 00       	mov    $0x4,%eax
  80016a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80016d:	89 f7                	mov    %esi,%edi
  80016f:	cd 30                	int    $0x30
	if (check && ret > 0)
  800171:	85 c0                	test   %eax,%eax
  800173:	7f 08                	jg     80017d <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800175:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800178:	5b                   	pop    %ebx
  800179:	5e                   	pop    %esi
  80017a:	5f                   	pop    %edi
  80017b:	5d                   	pop    %ebp
  80017c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80017d:	83 ec 0c             	sub    $0xc,%esp
  800180:	50                   	push   %eax
  800181:	6a 04                	push   $0x4
  800183:	68 2a 11 80 00       	push   $0x80112a
  800188:	6a 4c                	push   $0x4c
  80018a:	68 47 11 80 00       	push   $0x801147
  80018f:	e8 ef 01 00 00       	call   800383 <_panic>

00800194 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800194:	55                   	push   %ebp
  800195:	89 e5                	mov    %esp,%ebp
  800197:	57                   	push   %edi
  800198:	56                   	push   %esi
  800199:	53                   	push   %ebx
  80019a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80019d:	8b 55 08             	mov    0x8(%ebp),%edx
  8001a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001a3:	b8 05 00 00 00       	mov    $0x5,%eax
  8001a8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001ab:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001ae:	8b 75 18             	mov    0x18(%ebp),%esi
  8001b1:	cd 30                	int    $0x30
	if (check && ret > 0)
  8001b3:	85 c0                	test   %eax,%eax
  8001b5:	7f 08                	jg     8001bf <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001ba:	5b                   	pop    %ebx
  8001bb:	5e                   	pop    %esi
  8001bc:	5f                   	pop    %edi
  8001bd:	5d                   	pop    %ebp
  8001be:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001bf:	83 ec 0c             	sub    $0xc,%esp
  8001c2:	50                   	push   %eax
  8001c3:	6a 05                	push   $0x5
  8001c5:	68 2a 11 80 00       	push   $0x80112a
  8001ca:	6a 4c                	push   $0x4c
  8001cc:	68 47 11 80 00       	push   $0x801147
  8001d1:	e8 ad 01 00 00       	call   800383 <_panic>

008001d6 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001d6:	55                   	push   %ebp
  8001d7:	89 e5                	mov    %esp,%ebp
  8001d9:	57                   	push   %edi
  8001da:	56                   	push   %esi
  8001db:	53                   	push   %ebx
  8001dc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001df:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8001e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001ea:	b8 06 00 00 00       	mov    $0x6,%eax
  8001ef:	89 df                	mov    %ebx,%edi
  8001f1:	89 de                	mov    %ebx,%esi
  8001f3:	cd 30                	int    $0x30
	if (check && ret > 0)
  8001f5:	85 c0                	test   %eax,%eax
  8001f7:	7f 08                	jg     800201 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8001f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001fc:	5b                   	pop    %ebx
  8001fd:	5e                   	pop    %esi
  8001fe:	5f                   	pop    %edi
  8001ff:	5d                   	pop    %ebp
  800200:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800201:	83 ec 0c             	sub    $0xc,%esp
  800204:	50                   	push   %eax
  800205:	6a 06                	push   $0x6
  800207:	68 2a 11 80 00       	push   $0x80112a
  80020c:	6a 4c                	push   $0x4c
  80020e:	68 47 11 80 00       	push   $0x801147
  800213:	e8 6b 01 00 00       	call   800383 <_panic>

00800218 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800218:	55                   	push   %ebp
  800219:	89 e5                	mov    %esp,%ebp
  80021b:	57                   	push   %edi
  80021c:	56                   	push   %esi
  80021d:	53                   	push   %ebx
  80021e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800221:	bb 00 00 00 00       	mov    $0x0,%ebx
  800226:	8b 55 08             	mov    0x8(%ebp),%edx
  800229:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80022c:	b8 08 00 00 00       	mov    $0x8,%eax
  800231:	89 df                	mov    %ebx,%edi
  800233:	89 de                	mov    %ebx,%esi
  800235:	cd 30                	int    $0x30
	if (check && ret > 0)
  800237:	85 c0                	test   %eax,%eax
  800239:	7f 08                	jg     800243 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80023b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80023e:	5b                   	pop    %ebx
  80023f:	5e                   	pop    %esi
  800240:	5f                   	pop    %edi
  800241:	5d                   	pop    %ebp
  800242:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800243:	83 ec 0c             	sub    $0xc,%esp
  800246:	50                   	push   %eax
  800247:	6a 08                	push   $0x8
  800249:	68 2a 11 80 00       	push   $0x80112a
  80024e:	6a 4c                	push   $0x4c
  800250:	68 47 11 80 00       	push   $0x801147
  800255:	e8 29 01 00 00       	call   800383 <_panic>

0080025a <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80025a:	55                   	push   %ebp
  80025b:	89 e5                	mov    %esp,%ebp
  80025d:	57                   	push   %edi
  80025e:	56                   	push   %esi
  80025f:	53                   	push   %ebx
  800260:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800263:	bb 00 00 00 00       	mov    $0x0,%ebx
  800268:	8b 55 08             	mov    0x8(%ebp),%edx
  80026b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80026e:	b8 09 00 00 00       	mov    $0x9,%eax
  800273:	89 df                	mov    %ebx,%edi
  800275:	89 de                	mov    %ebx,%esi
  800277:	cd 30                	int    $0x30
	if (check && ret > 0)
  800279:	85 c0                	test   %eax,%eax
  80027b:	7f 08                	jg     800285 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80027d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800280:	5b                   	pop    %ebx
  800281:	5e                   	pop    %esi
  800282:	5f                   	pop    %edi
  800283:	5d                   	pop    %ebp
  800284:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800285:	83 ec 0c             	sub    $0xc,%esp
  800288:	50                   	push   %eax
  800289:	6a 09                	push   $0x9
  80028b:	68 2a 11 80 00       	push   $0x80112a
  800290:	6a 4c                	push   $0x4c
  800292:	68 47 11 80 00       	push   $0x801147
  800297:	e8 e7 00 00 00       	call   800383 <_panic>

0080029c <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80029c:	55                   	push   %ebp
  80029d:	89 e5                	mov    %esp,%ebp
  80029f:	57                   	push   %edi
  8002a0:	56                   	push   %esi
  8002a1:	53                   	push   %ebx
  8002a2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002a5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8002ad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002b0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002b5:	89 df                	mov    %ebx,%edi
  8002b7:	89 de                	mov    %ebx,%esi
  8002b9:	cd 30                	int    $0x30
	if (check && ret > 0)
  8002bb:	85 c0                	test   %eax,%eax
  8002bd:	7f 08                	jg     8002c7 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002c2:	5b                   	pop    %ebx
  8002c3:	5e                   	pop    %esi
  8002c4:	5f                   	pop    %edi
  8002c5:	5d                   	pop    %ebp
  8002c6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002c7:	83 ec 0c             	sub    $0xc,%esp
  8002ca:	50                   	push   %eax
  8002cb:	6a 0a                	push   $0xa
  8002cd:	68 2a 11 80 00       	push   $0x80112a
  8002d2:	6a 4c                	push   $0x4c
  8002d4:	68 47 11 80 00       	push   $0x801147
  8002d9:	e8 a5 00 00 00       	call   800383 <_panic>

008002de <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002de:	55                   	push   %ebp
  8002df:	89 e5                	mov    %esp,%ebp
  8002e1:	57                   	push   %edi
  8002e2:	56                   	push   %esi
  8002e3:	53                   	push   %ebx
	asm volatile("int %1\n"
  8002e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8002e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002ea:	b8 0c 00 00 00       	mov    $0xc,%eax
  8002ef:	be 00 00 00 00       	mov    $0x0,%esi
  8002f4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8002f7:	8b 7d 14             	mov    0x14(%ebp),%edi
  8002fa:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8002fc:	5b                   	pop    %ebx
  8002fd:	5e                   	pop    %esi
  8002fe:	5f                   	pop    %edi
  8002ff:	5d                   	pop    %ebp
  800300:	c3                   	ret    

00800301 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800301:	55                   	push   %ebp
  800302:	89 e5                	mov    %esp,%ebp
  800304:	57                   	push   %edi
  800305:	56                   	push   %esi
  800306:	53                   	push   %ebx
  800307:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80030a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80030f:	8b 55 08             	mov    0x8(%ebp),%edx
  800312:	b8 0d 00 00 00       	mov    $0xd,%eax
  800317:	89 cb                	mov    %ecx,%ebx
  800319:	89 cf                	mov    %ecx,%edi
  80031b:	89 ce                	mov    %ecx,%esi
  80031d:	cd 30                	int    $0x30
	if (check && ret > 0)
  80031f:	85 c0                	test   %eax,%eax
  800321:	7f 08                	jg     80032b <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800323:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800326:	5b                   	pop    %ebx
  800327:	5e                   	pop    %esi
  800328:	5f                   	pop    %edi
  800329:	5d                   	pop    %ebp
  80032a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80032b:	83 ec 0c             	sub    $0xc,%esp
  80032e:	50                   	push   %eax
  80032f:	6a 0d                	push   $0xd
  800331:	68 2a 11 80 00       	push   $0x80112a
  800336:	6a 4c                	push   $0x4c
  800338:	68 47 11 80 00       	push   $0x801147
  80033d:	e8 41 00 00 00       	call   800383 <_panic>

00800342 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800342:	55                   	push   %ebp
  800343:	89 e5                	mov    %esp,%ebp
  800345:	57                   	push   %edi
  800346:	56                   	push   %esi
  800347:	53                   	push   %ebx
	asm volatile("int %1\n"
  800348:	bb 00 00 00 00       	mov    $0x0,%ebx
  80034d:	8b 55 08             	mov    0x8(%ebp),%edx
  800350:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800353:	b8 0e 00 00 00       	mov    $0xe,%eax
  800358:	89 df                	mov    %ebx,%edi
  80035a:	89 de                	mov    %ebx,%esi
  80035c:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  80035e:	5b                   	pop    %ebx
  80035f:	5e                   	pop    %esi
  800360:	5f                   	pop    %edi
  800361:	5d                   	pop    %ebp
  800362:	c3                   	ret    

00800363 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800363:	55                   	push   %ebp
  800364:	89 e5                	mov    %esp,%ebp
  800366:	57                   	push   %edi
  800367:	56                   	push   %esi
  800368:	53                   	push   %ebx
	asm volatile("int %1\n"
  800369:	b9 00 00 00 00       	mov    $0x0,%ecx
  80036e:	8b 55 08             	mov    0x8(%ebp),%edx
  800371:	b8 0f 00 00 00       	mov    $0xf,%eax
  800376:	89 cb                	mov    %ecx,%ebx
  800378:	89 cf                	mov    %ecx,%edi
  80037a:	89 ce                	mov    %ecx,%esi
  80037c:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  80037e:	5b                   	pop    %ebx
  80037f:	5e                   	pop    %esi
  800380:	5f                   	pop    %edi
  800381:	5d                   	pop    %ebp
  800382:	c3                   	ret    

00800383 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800383:	55                   	push   %ebp
  800384:	89 e5                	mov    %esp,%ebp
  800386:	56                   	push   %esi
  800387:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800388:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80038b:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800391:	e8 7d fd ff ff       	call   800113 <sys_getenvid>
  800396:	83 ec 0c             	sub    $0xc,%esp
  800399:	ff 75 0c             	pushl  0xc(%ebp)
  80039c:	ff 75 08             	pushl  0x8(%ebp)
  80039f:	56                   	push   %esi
  8003a0:	50                   	push   %eax
  8003a1:	68 58 11 80 00       	push   $0x801158
  8003a6:	e8 b3 00 00 00       	call   80045e <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8003ab:	83 c4 18             	add    $0x18,%esp
  8003ae:	53                   	push   %ebx
  8003af:	ff 75 10             	pushl  0x10(%ebp)
  8003b2:	e8 56 00 00 00       	call   80040d <vcprintf>
	cprintf("\n");
  8003b7:	c7 04 24 7b 11 80 00 	movl   $0x80117b,(%esp)
  8003be:	e8 9b 00 00 00       	call   80045e <cprintf>
  8003c3:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8003c6:	cc                   	int3   
  8003c7:	eb fd                	jmp    8003c6 <_panic+0x43>

008003c9 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8003c9:	55                   	push   %ebp
  8003ca:	89 e5                	mov    %esp,%ebp
  8003cc:	53                   	push   %ebx
  8003cd:	83 ec 04             	sub    $0x4,%esp
  8003d0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8003d3:	8b 13                	mov    (%ebx),%edx
  8003d5:	8d 42 01             	lea    0x1(%edx),%eax
  8003d8:	89 03                	mov    %eax,(%ebx)
  8003da:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003dd:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8003e1:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003e6:	74 09                	je     8003f1 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8003e8:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8003ec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003ef:	c9                   	leave  
  8003f0:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8003f1:	83 ec 08             	sub    $0x8,%esp
  8003f4:	68 ff 00 00 00       	push   $0xff
  8003f9:	8d 43 08             	lea    0x8(%ebx),%eax
  8003fc:	50                   	push   %eax
  8003fd:	e8 93 fc ff ff       	call   800095 <sys_cputs>
		b->idx = 0;
  800402:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800408:	83 c4 10             	add    $0x10,%esp
  80040b:	eb db                	jmp    8003e8 <putch+0x1f>

0080040d <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80040d:	55                   	push   %ebp
  80040e:	89 e5                	mov    %esp,%ebp
  800410:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800416:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80041d:	00 00 00 
	b.cnt = 0;
  800420:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800427:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80042a:	ff 75 0c             	pushl  0xc(%ebp)
  80042d:	ff 75 08             	pushl  0x8(%ebp)
  800430:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800436:	50                   	push   %eax
  800437:	68 c9 03 80 00       	push   $0x8003c9
  80043c:	e8 4a 01 00 00       	call   80058b <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800441:	83 c4 08             	add    $0x8,%esp
  800444:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80044a:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800450:	50                   	push   %eax
  800451:	e8 3f fc ff ff       	call   800095 <sys_cputs>

	return b.cnt;
}
  800456:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80045c:	c9                   	leave  
  80045d:	c3                   	ret    

0080045e <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80045e:	55                   	push   %ebp
  80045f:	89 e5                	mov    %esp,%ebp
  800461:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800464:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800467:	50                   	push   %eax
  800468:	ff 75 08             	pushl  0x8(%ebp)
  80046b:	e8 9d ff ff ff       	call   80040d <vcprintf>
	va_end(ap);

	return cnt;
}
  800470:	c9                   	leave  
  800471:	c3                   	ret    

00800472 <printnum>:


static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800472:	55                   	push   %ebp
  800473:	89 e5                	mov    %esp,%ebp
  800475:	57                   	push   %edi
  800476:	56                   	push   %esi
  800477:	53                   	push   %ebx
  800478:	83 ec 1c             	sub    $0x1c,%esp
  80047b:	89 c6                	mov    %eax,%esi
  80047d:	89 d7                	mov    %edx,%edi
  80047f:	8b 45 08             	mov    0x8(%ebp),%eax
  800482:	8b 55 0c             	mov    0xc(%ebp),%edx
  800485:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800488:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80048b:	8b 45 10             	mov    0x10(%ebp),%eax
  80048e:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	// to support '-'
	if(padc == '-'){
  800491:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800495:	74 2c                	je     8004c3 <printnum+0x51>
		while (--width > 0)
			putch(' ', putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800497:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80049a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8004a1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004a4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8004a7:	39 c2                	cmp    %eax,%edx
  8004a9:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8004ac:	73 43                	jae    8004f1 <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004ae:	83 eb 01             	sub    $0x1,%ebx
  8004b1:	85 db                	test   %ebx,%ebx
  8004b3:	7e 6c                	jle    800521 <printnum+0xaf>
			putch(padc, putdat);
  8004b5:	83 ec 08             	sub    $0x8,%esp
  8004b8:	57                   	push   %edi
  8004b9:	ff 75 18             	pushl  0x18(%ebp)
  8004bc:	ff d6                	call   *%esi
  8004be:	83 c4 10             	add    $0x10,%esp
  8004c1:	eb eb                	jmp    8004ae <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8004c3:	83 ec 0c             	sub    $0xc,%esp
  8004c6:	6a 20                	push   $0x20
  8004c8:	6a 00                	push   $0x0
  8004ca:	50                   	push   %eax
  8004cb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004ce:	ff 75 e0             	pushl  -0x20(%ebp)
  8004d1:	89 fa                	mov    %edi,%edx
  8004d3:	89 f0                	mov    %esi,%eax
  8004d5:	e8 98 ff ff ff       	call   800472 <printnum>
		while (--width > 0)
  8004da:	83 c4 20             	add    $0x20,%esp
  8004dd:	83 eb 01             	sub    $0x1,%ebx
  8004e0:	85 db                	test   %ebx,%ebx
  8004e2:	7e 65                	jle    800549 <printnum+0xd7>
			putch(' ', putdat);
  8004e4:	83 ec 08             	sub    $0x8,%esp
  8004e7:	57                   	push   %edi
  8004e8:	6a 20                	push   $0x20
  8004ea:	ff d6                	call   *%esi
  8004ec:	83 c4 10             	add    $0x10,%esp
  8004ef:	eb ec                	jmp    8004dd <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004f1:	83 ec 0c             	sub    $0xc,%esp
  8004f4:	ff 75 18             	pushl  0x18(%ebp)
  8004f7:	83 eb 01             	sub    $0x1,%ebx
  8004fa:	53                   	push   %ebx
  8004fb:	50                   	push   %eax
  8004fc:	83 ec 08             	sub    $0x8,%esp
  8004ff:	ff 75 dc             	pushl  -0x24(%ebp)
  800502:	ff 75 d8             	pushl  -0x28(%ebp)
  800505:	ff 75 e4             	pushl  -0x1c(%ebp)
  800508:	ff 75 e0             	pushl  -0x20(%ebp)
  80050b:	e8 b0 09 00 00       	call   800ec0 <__udivdi3>
  800510:	83 c4 18             	add    $0x18,%esp
  800513:	52                   	push   %edx
  800514:	50                   	push   %eax
  800515:	89 fa                	mov    %edi,%edx
  800517:	89 f0                	mov    %esi,%eax
  800519:	e8 54 ff ff ff       	call   800472 <printnum>
  80051e:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800521:	83 ec 08             	sub    $0x8,%esp
  800524:	57                   	push   %edi
  800525:	83 ec 04             	sub    $0x4,%esp
  800528:	ff 75 dc             	pushl  -0x24(%ebp)
  80052b:	ff 75 d8             	pushl  -0x28(%ebp)
  80052e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800531:	ff 75 e0             	pushl  -0x20(%ebp)
  800534:	e8 97 0a 00 00       	call   800fd0 <__umoddi3>
  800539:	83 c4 14             	add    $0x14,%esp
  80053c:	0f be 80 7d 11 80 00 	movsbl 0x80117d(%eax),%eax
  800543:	50                   	push   %eax
  800544:	ff d6                	call   *%esi
  800546:	83 c4 10             	add    $0x10,%esp
}
  800549:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80054c:	5b                   	pop    %ebx
  80054d:	5e                   	pop    %esi
  80054e:	5f                   	pop    %edi
  80054f:	5d                   	pop    %ebp
  800550:	c3                   	ret    

00800551 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800551:	55                   	push   %ebp
  800552:	89 e5                	mov    %esp,%ebp
  800554:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800557:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80055b:	8b 10                	mov    (%eax),%edx
  80055d:	3b 50 04             	cmp    0x4(%eax),%edx
  800560:	73 0a                	jae    80056c <sprintputch+0x1b>
		*b->buf++ = ch;
  800562:	8d 4a 01             	lea    0x1(%edx),%ecx
  800565:	89 08                	mov    %ecx,(%eax)
  800567:	8b 45 08             	mov    0x8(%ebp),%eax
  80056a:	88 02                	mov    %al,(%edx)
}
  80056c:	5d                   	pop    %ebp
  80056d:	c3                   	ret    

0080056e <printfmt>:
{
  80056e:	55                   	push   %ebp
  80056f:	89 e5                	mov    %esp,%ebp
  800571:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800574:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800577:	50                   	push   %eax
  800578:	ff 75 10             	pushl  0x10(%ebp)
  80057b:	ff 75 0c             	pushl  0xc(%ebp)
  80057e:	ff 75 08             	pushl  0x8(%ebp)
  800581:	e8 05 00 00 00       	call   80058b <vprintfmt>
}
  800586:	83 c4 10             	add    $0x10,%esp
  800589:	c9                   	leave  
  80058a:	c3                   	ret    

0080058b <vprintfmt>:
{
  80058b:	55                   	push   %ebp
  80058c:	89 e5                	mov    %esp,%ebp
  80058e:	57                   	push   %edi
  80058f:	56                   	push   %esi
  800590:	53                   	push   %ebx
  800591:	83 ec 3c             	sub    $0x3c,%esp
  800594:	8b 75 08             	mov    0x8(%ebp),%esi
  800597:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80059a:	8b 7d 10             	mov    0x10(%ebp),%edi
  80059d:	e9 1e 04 00 00       	jmp    8009c0 <vprintfmt+0x435>
		posflag = 0;
  8005a2:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
		padc = ' ';
  8005a9:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8005ad:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8005b4:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8005bb:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8005c2:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  8005c9:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8005ce:	8d 47 01             	lea    0x1(%edi),%eax
  8005d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005d4:	0f b6 17             	movzbl (%edi),%edx
  8005d7:	8d 42 dd             	lea    -0x23(%edx),%eax
  8005da:	3c 55                	cmp    $0x55,%al
  8005dc:	0f 87 d9 04 00 00    	ja     800abb <vprintfmt+0x530>
  8005e2:	0f b6 c0             	movzbl %al,%eax
  8005e5:	ff 24 85 60 13 80 00 	jmp    *0x801360(,%eax,4)
  8005ec:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8005ef:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8005f3:	eb d9                	jmp    8005ce <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8005f5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posflag = 1;
  8005f8:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  8005ff:	eb cd                	jmp    8005ce <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800601:	0f b6 d2             	movzbl %dl,%edx
  800604:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800607:	b8 00 00 00 00       	mov    $0x0,%eax
  80060c:	89 75 08             	mov    %esi,0x8(%ebp)
  80060f:	eb 0c                	jmp    80061d <vprintfmt+0x92>
		switch (ch = *(unsigned char *) fmt++) {
  800611:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800614:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  800618:	eb b4                	jmp    8005ce <vprintfmt+0x43>
			for (precision = 0; ; ++fmt) {
  80061a:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80061d:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800620:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800624:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800627:	8d 72 d0             	lea    -0x30(%edx),%esi
  80062a:	83 fe 09             	cmp    $0x9,%esi
  80062d:	76 eb                	jbe    80061a <vprintfmt+0x8f>
  80062f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800632:	8b 75 08             	mov    0x8(%ebp),%esi
  800635:	eb 14                	jmp    80064b <vprintfmt+0xc0>
			precision = va_arg(ap, int);
  800637:	8b 45 14             	mov    0x14(%ebp),%eax
  80063a:	8b 00                	mov    (%eax),%eax
  80063c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80063f:	8b 45 14             	mov    0x14(%ebp),%eax
  800642:	8d 40 04             	lea    0x4(%eax),%eax
  800645:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800648:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80064b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80064f:	0f 89 79 ff ff ff    	jns    8005ce <vprintfmt+0x43>
				width = precision, precision = -1;
  800655:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800658:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80065b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800662:	e9 67 ff ff ff       	jmp    8005ce <vprintfmt+0x43>
  800667:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80066a:	85 c0                	test   %eax,%eax
  80066c:	0f 48 c1             	cmovs  %ecx,%eax
  80066f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800672:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800675:	e9 54 ff ff ff       	jmp    8005ce <vprintfmt+0x43>
  80067a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80067d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800684:	e9 45 ff ff ff       	jmp    8005ce <vprintfmt+0x43>
			lflag++;
  800689:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80068d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800690:	e9 39 ff ff ff       	jmp    8005ce <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800695:	8b 45 14             	mov    0x14(%ebp),%eax
  800698:	8d 78 04             	lea    0x4(%eax),%edi
  80069b:	83 ec 08             	sub    $0x8,%esp
  80069e:	53                   	push   %ebx
  80069f:	ff 30                	pushl  (%eax)
  8006a1:	ff d6                	call   *%esi
			break;
  8006a3:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8006a6:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8006a9:	e9 0f 03 00 00       	jmp    8009bd <vprintfmt+0x432>
			err = va_arg(ap, int);
  8006ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b1:	8d 78 04             	lea    0x4(%eax),%edi
  8006b4:	8b 00                	mov    (%eax),%eax
  8006b6:	99                   	cltd   
  8006b7:	31 d0                	xor    %edx,%eax
  8006b9:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8006bb:	83 f8 0f             	cmp    $0xf,%eax
  8006be:	7f 23                	jg     8006e3 <vprintfmt+0x158>
  8006c0:	8b 14 85 c0 14 80 00 	mov    0x8014c0(,%eax,4),%edx
  8006c7:	85 d2                	test   %edx,%edx
  8006c9:	74 18                	je     8006e3 <vprintfmt+0x158>
				printfmt(putch, putdat, "%s", p);
  8006cb:	52                   	push   %edx
  8006cc:	68 9e 11 80 00       	push   $0x80119e
  8006d1:	53                   	push   %ebx
  8006d2:	56                   	push   %esi
  8006d3:	e8 96 fe ff ff       	call   80056e <printfmt>
  8006d8:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8006db:	89 7d 14             	mov    %edi,0x14(%ebp)
  8006de:	e9 da 02 00 00       	jmp    8009bd <vprintfmt+0x432>
				printfmt(putch, putdat, "error %d", err);
  8006e3:	50                   	push   %eax
  8006e4:	68 95 11 80 00       	push   $0x801195
  8006e9:	53                   	push   %ebx
  8006ea:	56                   	push   %esi
  8006eb:	e8 7e fe ff ff       	call   80056e <printfmt>
  8006f0:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8006f3:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8006f6:	e9 c2 02 00 00       	jmp    8009bd <vprintfmt+0x432>
			if ((p = va_arg(ap, char *)) == NULL)
  8006fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fe:	83 c0 04             	add    $0x4,%eax
  800701:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800704:	8b 45 14             	mov    0x14(%ebp),%eax
  800707:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800709:	85 c9                	test   %ecx,%ecx
  80070b:	b8 8e 11 80 00       	mov    $0x80118e,%eax
  800710:	0f 45 c1             	cmovne %ecx,%eax
  800713:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800716:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80071a:	7e 06                	jle    800722 <vprintfmt+0x197>
  80071c:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800720:	75 0d                	jne    80072f <vprintfmt+0x1a4>
				for (width -= strnlen(p, precision); width > 0; width--)
  800722:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800725:	89 c7                	mov    %eax,%edi
  800727:	03 45 e0             	add    -0x20(%ebp),%eax
  80072a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80072d:	eb 53                	jmp    800782 <vprintfmt+0x1f7>
  80072f:	83 ec 08             	sub    $0x8,%esp
  800732:	ff 75 d8             	pushl  -0x28(%ebp)
  800735:	50                   	push   %eax
  800736:	e8 28 04 00 00       	call   800b63 <strnlen>
  80073b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80073e:	29 c1                	sub    %eax,%ecx
  800740:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  800743:	83 c4 10             	add    $0x10,%esp
  800746:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800748:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80074c:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80074f:	eb 0f                	jmp    800760 <vprintfmt+0x1d5>
					putch(padc, putdat);
  800751:	83 ec 08             	sub    $0x8,%esp
  800754:	53                   	push   %ebx
  800755:	ff 75 e0             	pushl  -0x20(%ebp)
  800758:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80075a:	83 ef 01             	sub    $0x1,%edi
  80075d:	83 c4 10             	add    $0x10,%esp
  800760:	85 ff                	test   %edi,%edi
  800762:	7f ed                	jg     800751 <vprintfmt+0x1c6>
  800764:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  800767:	85 c9                	test   %ecx,%ecx
  800769:	b8 00 00 00 00       	mov    $0x0,%eax
  80076e:	0f 49 c1             	cmovns %ecx,%eax
  800771:	29 c1                	sub    %eax,%ecx
  800773:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800776:	eb aa                	jmp    800722 <vprintfmt+0x197>
					putch(ch, putdat);
  800778:	83 ec 08             	sub    $0x8,%esp
  80077b:	53                   	push   %ebx
  80077c:	52                   	push   %edx
  80077d:	ff d6                	call   *%esi
  80077f:	83 c4 10             	add    $0x10,%esp
  800782:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800785:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800787:	83 c7 01             	add    $0x1,%edi
  80078a:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80078e:	0f be d0             	movsbl %al,%edx
  800791:	85 d2                	test   %edx,%edx
  800793:	74 4b                	je     8007e0 <vprintfmt+0x255>
  800795:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800799:	78 06                	js     8007a1 <vprintfmt+0x216>
  80079b:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80079f:	78 1e                	js     8007bf <vprintfmt+0x234>
				if (altflag && (ch < ' ' || ch > '~'))
  8007a1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8007a5:	74 d1                	je     800778 <vprintfmt+0x1ed>
  8007a7:	0f be c0             	movsbl %al,%eax
  8007aa:	83 e8 20             	sub    $0x20,%eax
  8007ad:	83 f8 5e             	cmp    $0x5e,%eax
  8007b0:	76 c6                	jbe    800778 <vprintfmt+0x1ed>
					putch('?', putdat);
  8007b2:	83 ec 08             	sub    $0x8,%esp
  8007b5:	53                   	push   %ebx
  8007b6:	6a 3f                	push   $0x3f
  8007b8:	ff d6                	call   *%esi
  8007ba:	83 c4 10             	add    $0x10,%esp
  8007bd:	eb c3                	jmp    800782 <vprintfmt+0x1f7>
  8007bf:	89 cf                	mov    %ecx,%edi
  8007c1:	eb 0e                	jmp    8007d1 <vprintfmt+0x246>
				putch(' ', putdat);
  8007c3:	83 ec 08             	sub    $0x8,%esp
  8007c6:	53                   	push   %ebx
  8007c7:	6a 20                	push   $0x20
  8007c9:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8007cb:	83 ef 01             	sub    $0x1,%edi
  8007ce:	83 c4 10             	add    $0x10,%esp
  8007d1:	85 ff                	test   %edi,%edi
  8007d3:	7f ee                	jg     8007c3 <vprintfmt+0x238>
			if ((p = va_arg(ap, char *)) == NULL)
  8007d5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8007d8:	89 45 14             	mov    %eax,0x14(%ebp)
  8007db:	e9 dd 01 00 00       	jmp    8009bd <vprintfmt+0x432>
  8007e0:	89 cf                	mov    %ecx,%edi
  8007e2:	eb ed                	jmp    8007d1 <vprintfmt+0x246>
	if (lflag >= 2)
  8007e4:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8007e8:	7f 21                	jg     80080b <vprintfmt+0x280>
	else if (lflag)
  8007ea:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8007ee:	74 6a                	je     80085a <vprintfmt+0x2cf>
		return va_arg(*ap, long);
  8007f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f3:	8b 00                	mov    (%eax),%eax
  8007f5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007f8:	89 c1                	mov    %eax,%ecx
  8007fa:	c1 f9 1f             	sar    $0x1f,%ecx
  8007fd:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800800:	8b 45 14             	mov    0x14(%ebp),%eax
  800803:	8d 40 04             	lea    0x4(%eax),%eax
  800806:	89 45 14             	mov    %eax,0x14(%ebp)
  800809:	eb 17                	jmp    800822 <vprintfmt+0x297>
		return va_arg(*ap, long long);
  80080b:	8b 45 14             	mov    0x14(%ebp),%eax
  80080e:	8b 50 04             	mov    0x4(%eax),%edx
  800811:	8b 00                	mov    (%eax),%eax
  800813:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800816:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800819:	8b 45 14             	mov    0x14(%ebp),%eax
  80081c:	8d 40 08             	lea    0x8(%eax),%eax
  80081f:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800822:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  800825:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  80082a:	85 d2                	test   %edx,%edx
  80082c:	0f 89 5c 01 00 00    	jns    80098e <vprintfmt+0x403>
				putch('-', putdat);
  800832:	83 ec 08             	sub    $0x8,%esp
  800835:	53                   	push   %ebx
  800836:	6a 2d                	push   $0x2d
  800838:	ff d6                	call   *%esi
				num = -(long long) num;
  80083a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80083d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800840:	f7 d8                	neg    %eax
  800842:	83 d2 00             	adc    $0x0,%edx
  800845:	f7 da                	neg    %edx
  800847:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80084a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80084d:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800850:	bf 0a 00 00 00       	mov    $0xa,%edi
  800855:	e9 45 01 00 00       	jmp    80099f <vprintfmt+0x414>
		return va_arg(*ap, int);
  80085a:	8b 45 14             	mov    0x14(%ebp),%eax
  80085d:	8b 00                	mov    (%eax),%eax
  80085f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800862:	89 c1                	mov    %eax,%ecx
  800864:	c1 f9 1f             	sar    $0x1f,%ecx
  800867:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80086a:	8b 45 14             	mov    0x14(%ebp),%eax
  80086d:	8d 40 04             	lea    0x4(%eax),%eax
  800870:	89 45 14             	mov    %eax,0x14(%ebp)
  800873:	eb ad                	jmp    800822 <vprintfmt+0x297>
	if (lflag >= 2)
  800875:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800879:	7f 29                	jg     8008a4 <vprintfmt+0x319>
	else if (lflag)
  80087b:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80087f:	74 44                	je     8008c5 <vprintfmt+0x33a>
		return va_arg(*ap, unsigned long);
  800881:	8b 45 14             	mov    0x14(%ebp),%eax
  800884:	8b 00                	mov    (%eax),%eax
  800886:	ba 00 00 00 00       	mov    $0x0,%edx
  80088b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80088e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800891:	8b 45 14             	mov    0x14(%ebp),%eax
  800894:	8d 40 04             	lea    0x4(%eax),%eax
  800897:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80089a:	bf 0a 00 00 00       	mov    $0xa,%edi
  80089f:	e9 ea 00 00 00       	jmp    80098e <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  8008a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a7:	8b 50 04             	mov    0x4(%eax),%edx
  8008aa:	8b 00                	mov    (%eax),%eax
  8008ac:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008af:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b5:	8d 40 08             	lea    0x8(%eax),%eax
  8008b8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008bb:	bf 0a 00 00 00       	mov    $0xa,%edi
  8008c0:	e9 c9 00 00 00       	jmp    80098e <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  8008c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c8:	8b 00                	mov    (%eax),%eax
  8008ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8008cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008d2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d8:	8d 40 04             	lea    0x4(%eax),%eax
  8008db:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008de:	bf 0a 00 00 00       	mov    $0xa,%edi
  8008e3:	e9 a6 00 00 00       	jmp    80098e <vprintfmt+0x403>
			putch('0', putdat);
  8008e8:	83 ec 08             	sub    $0x8,%esp
  8008eb:	53                   	push   %ebx
  8008ec:	6a 30                	push   $0x30
  8008ee:	ff d6                	call   *%esi
	if (lflag >= 2)
  8008f0:	83 c4 10             	add    $0x10,%esp
  8008f3:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8008f7:	7f 26                	jg     80091f <vprintfmt+0x394>
	else if (lflag)
  8008f9:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8008fd:	74 3e                	je     80093d <vprintfmt+0x3b2>
		return va_arg(*ap, unsigned long);
  8008ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800902:	8b 00                	mov    (%eax),%eax
  800904:	ba 00 00 00 00       	mov    $0x0,%edx
  800909:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80090c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80090f:	8b 45 14             	mov    0x14(%ebp),%eax
  800912:	8d 40 04             	lea    0x4(%eax),%eax
  800915:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800918:	bf 08 00 00 00       	mov    $0x8,%edi
  80091d:	eb 6f                	jmp    80098e <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  80091f:	8b 45 14             	mov    0x14(%ebp),%eax
  800922:	8b 50 04             	mov    0x4(%eax),%edx
  800925:	8b 00                	mov    (%eax),%eax
  800927:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80092a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80092d:	8b 45 14             	mov    0x14(%ebp),%eax
  800930:	8d 40 08             	lea    0x8(%eax),%eax
  800933:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800936:	bf 08 00 00 00       	mov    $0x8,%edi
  80093b:	eb 51                	jmp    80098e <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  80093d:	8b 45 14             	mov    0x14(%ebp),%eax
  800940:	8b 00                	mov    (%eax),%eax
  800942:	ba 00 00 00 00       	mov    $0x0,%edx
  800947:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80094a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80094d:	8b 45 14             	mov    0x14(%ebp),%eax
  800950:	8d 40 04             	lea    0x4(%eax),%eax
  800953:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800956:	bf 08 00 00 00       	mov    $0x8,%edi
  80095b:	eb 31                	jmp    80098e <vprintfmt+0x403>
			putch('0', putdat);
  80095d:	83 ec 08             	sub    $0x8,%esp
  800960:	53                   	push   %ebx
  800961:	6a 30                	push   $0x30
  800963:	ff d6                	call   *%esi
			putch('x', putdat);
  800965:	83 c4 08             	add    $0x8,%esp
  800968:	53                   	push   %ebx
  800969:	6a 78                	push   $0x78
  80096b:	ff d6                	call   *%esi
			num = (unsigned long long)
  80096d:	8b 45 14             	mov    0x14(%ebp),%eax
  800970:	8b 00                	mov    (%eax),%eax
  800972:	ba 00 00 00 00       	mov    $0x0,%edx
  800977:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80097a:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80097d:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800980:	8b 45 14             	mov    0x14(%ebp),%eax
  800983:	8d 40 04             	lea    0x4(%eax),%eax
  800986:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800989:	bf 10 00 00 00       	mov    $0x10,%edi
			if(posflag)
  80098e:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800992:	74 0b                	je     80099f <vprintfmt+0x414>
				putch('+', putdat);
  800994:	83 ec 08             	sub    $0x8,%esp
  800997:	53                   	push   %ebx
  800998:	6a 2b                	push   $0x2b
  80099a:	ff d6                	call   *%esi
  80099c:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  80099f:	83 ec 0c             	sub    $0xc,%esp
  8009a2:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8009a6:	50                   	push   %eax
  8009a7:	ff 75 e0             	pushl  -0x20(%ebp)
  8009aa:	57                   	push   %edi
  8009ab:	ff 75 dc             	pushl  -0x24(%ebp)
  8009ae:	ff 75 d8             	pushl  -0x28(%ebp)
  8009b1:	89 da                	mov    %ebx,%edx
  8009b3:	89 f0                	mov    %esi,%eax
  8009b5:	e8 b8 fa ff ff       	call   800472 <printnum>
			break;
  8009ba:	83 c4 20             	add    $0x20,%esp
			char* cp = va_arg(ap, char *);
  8009bd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009c0:	83 c7 01             	add    $0x1,%edi
  8009c3:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8009c7:	83 f8 25             	cmp    $0x25,%eax
  8009ca:	0f 84 d2 fb ff ff    	je     8005a2 <vprintfmt+0x17>
			if (ch == '\0')
  8009d0:	85 c0                	test   %eax,%eax
  8009d2:	0f 84 03 01 00 00    	je     800adb <vprintfmt+0x550>
			putch(ch, putdat);
  8009d8:	83 ec 08             	sub    $0x8,%esp
  8009db:	53                   	push   %ebx
  8009dc:	50                   	push   %eax
  8009dd:	ff d6                	call   *%esi
  8009df:	83 c4 10             	add    $0x10,%esp
  8009e2:	eb dc                	jmp    8009c0 <vprintfmt+0x435>
	if (lflag >= 2)
  8009e4:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8009e8:	7f 29                	jg     800a13 <vprintfmt+0x488>
	else if (lflag)
  8009ea:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8009ee:	74 44                	je     800a34 <vprintfmt+0x4a9>
		return va_arg(*ap, unsigned long);
  8009f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f3:	8b 00                	mov    (%eax),%eax
  8009f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8009fa:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009fd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a00:	8b 45 14             	mov    0x14(%ebp),%eax
  800a03:	8d 40 04             	lea    0x4(%eax),%eax
  800a06:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a09:	bf 10 00 00 00       	mov    $0x10,%edi
  800a0e:	e9 7b ff ff ff       	jmp    80098e <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  800a13:	8b 45 14             	mov    0x14(%ebp),%eax
  800a16:	8b 50 04             	mov    0x4(%eax),%edx
  800a19:	8b 00                	mov    (%eax),%eax
  800a1b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a1e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a21:	8b 45 14             	mov    0x14(%ebp),%eax
  800a24:	8d 40 08             	lea    0x8(%eax),%eax
  800a27:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a2a:	bf 10 00 00 00       	mov    $0x10,%edi
  800a2f:	e9 5a ff ff ff       	jmp    80098e <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  800a34:	8b 45 14             	mov    0x14(%ebp),%eax
  800a37:	8b 00                	mov    (%eax),%eax
  800a39:	ba 00 00 00 00       	mov    $0x0,%edx
  800a3e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a41:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a44:	8b 45 14             	mov    0x14(%ebp),%eax
  800a47:	8d 40 04             	lea    0x4(%eax),%eax
  800a4a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a4d:	bf 10 00 00 00       	mov    $0x10,%edi
  800a52:	e9 37 ff ff ff       	jmp    80098e <vprintfmt+0x403>
			char* cp = va_arg(ap, char *);
  800a57:	8b 45 14             	mov    0x14(%ebp),%eax
  800a5a:	8d 78 04             	lea    0x4(%eax),%edi
  800a5d:	8b 00                	mov    (%eax),%eax
    			if (cp == NULL) {
  800a5f:	85 c0                	test   %eax,%eax
  800a61:	74 2c                	je     800a8f <vprintfmt+0x504>
    			*cp = *(int *)putdat;
  800a63:	8b 13                	mov    (%ebx),%edx
  800a65:	88 10                	mov    %dl,(%eax)
			char* cp = va_arg(ap, char *);
  800a67:	89 7d 14             	mov    %edi,0x14(%ebp)
    			if ((*(int *) putdat) > 127)
  800a6a:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  800a6d:	0f 8e 4a ff ff ff    	jle    8009bd <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", overflow_error);
  800a73:	68 ec 12 80 00       	push   $0x8012ec
  800a78:	68 9e 11 80 00       	push   $0x80119e
  800a7d:	53                   	push   %ebx
  800a7e:	56                   	push   %esi
  800a7f:	e8 ea fa ff ff       	call   80056e <printfmt>
  800a84:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  800a87:	89 7d 14             	mov    %edi,0x14(%ebp)
  800a8a:	e9 2e ff ff ff       	jmp    8009bd <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", null_error);
  800a8f:	68 b4 12 80 00       	push   $0x8012b4
  800a94:	68 9e 11 80 00       	push   $0x80119e
  800a99:	53                   	push   %ebx
  800a9a:	56                   	push   %esi
  800a9b:	e8 ce fa ff ff       	call   80056e <printfmt>
        		break;
  800aa0:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  800aa3:	89 7d 14             	mov    %edi,0x14(%ebp)
        		break;
  800aa6:	e9 12 ff ff ff       	jmp    8009bd <vprintfmt+0x432>
			putch(ch, putdat);
  800aab:	83 ec 08             	sub    $0x8,%esp
  800aae:	53                   	push   %ebx
  800aaf:	6a 25                	push   $0x25
  800ab1:	ff d6                	call   *%esi
			break;
  800ab3:	83 c4 10             	add    $0x10,%esp
  800ab6:	e9 02 ff ff ff       	jmp    8009bd <vprintfmt+0x432>
			putch('%', putdat);
  800abb:	83 ec 08             	sub    $0x8,%esp
  800abe:	53                   	push   %ebx
  800abf:	6a 25                	push   $0x25
  800ac1:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ac3:	83 c4 10             	add    $0x10,%esp
  800ac6:	89 f8                	mov    %edi,%eax
  800ac8:	eb 03                	jmp    800acd <vprintfmt+0x542>
  800aca:	83 e8 01             	sub    $0x1,%eax
  800acd:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800ad1:	75 f7                	jne    800aca <vprintfmt+0x53f>
  800ad3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ad6:	e9 e2 fe ff ff       	jmp    8009bd <vprintfmt+0x432>
}
  800adb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ade:	5b                   	pop    %ebx
  800adf:	5e                   	pop    %esi
  800ae0:	5f                   	pop    %edi
  800ae1:	5d                   	pop    %ebp
  800ae2:	c3                   	ret    

00800ae3 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ae3:	55                   	push   %ebp
  800ae4:	89 e5                	mov    %esp,%ebp
  800ae6:	83 ec 18             	sub    $0x18,%esp
  800ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  800aec:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800aef:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800af2:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800af6:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800af9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b00:	85 c0                	test   %eax,%eax
  800b02:	74 26                	je     800b2a <vsnprintf+0x47>
  800b04:	85 d2                	test   %edx,%edx
  800b06:	7e 22                	jle    800b2a <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b08:	ff 75 14             	pushl  0x14(%ebp)
  800b0b:	ff 75 10             	pushl  0x10(%ebp)
  800b0e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b11:	50                   	push   %eax
  800b12:	68 51 05 80 00       	push   $0x800551
  800b17:	e8 6f fa ff ff       	call   80058b <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800b1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b1f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b25:	83 c4 10             	add    $0x10,%esp
}
  800b28:	c9                   	leave  
  800b29:	c3                   	ret    
		return -E_INVAL;
  800b2a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b2f:	eb f7                	jmp    800b28 <vsnprintf+0x45>

00800b31 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b31:	55                   	push   %ebp
  800b32:	89 e5                	mov    %esp,%ebp
  800b34:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b37:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800b3a:	50                   	push   %eax
  800b3b:	ff 75 10             	pushl  0x10(%ebp)
  800b3e:	ff 75 0c             	pushl  0xc(%ebp)
  800b41:	ff 75 08             	pushl  0x8(%ebp)
  800b44:	e8 9a ff ff ff       	call   800ae3 <vsnprintf>
	va_end(ap);

	return rc;
}
  800b49:	c9                   	leave  
  800b4a:	c3                   	ret    

00800b4b <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800b4b:	55                   	push   %ebp
  800b4c:	89 e5                	mov    %esp,%ebp
  800b4e:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800b51:	b8 00 00 00 00       	mov    $0x0,%eax
  800b56:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800b5a:	74 05                	je     800b61 <strlen+0x16>
		n++;
  800b5c:	83 c0 01             	add    $0x1,%eax
  800b5f:	eb f5                	jmp    800b56 <strlen+0xb>
	return n;
}
  800b61:	5d                   	pop    %ebp
  800b62:	c3                   	ret    

00800b63 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800b63:	55                   	push   %ebp
  800b64:	89 e5                	mov    %esp,%ebp
  800b66:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b69:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b6c:	ba 00 00 00 00       	mov    $0x0,%edx
  800b71:	39 c2                	cmp    %eax,%edx
  800b73:	74 0d                	je     800b82 <strnlen+0x1f>
  800b75:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800b79:	74 05                	je     800b80 <strnlen+0x1d>
		n++;
  800b7b:	83 c2 01             	add    $0x1,%edx
  800b7e:	eb f1                	jmp    800b71 <strnlen+0xe>
  800b80:	89 d0                	mov    %edx,%eax
	return n;
}
  800b82:	5d                   	pop    %ebp
  800b83:	c3                   	ret    

00800b84 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b84:	55                   	push   %ebp
  800b85:	89 e5                	mov    %esp,%ebp
  800b87:	53                   	push   %ebx
  800b88:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800b8e:	ba 00 00 00 00       	mov    $0x0,%edx
  800b93:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800b97:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800b9a:	83 c2 01             	add    $0x1,%edx
  800b9d:	84 c9                	test   %cl,%cl
  800b9f:	75 f2                	jne    800b93 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800ba1:	5b                   	pop    %ebx
  800ba2:	5d                   	pop    %ebp
  800ba3:	c3                   	ret    

00800ba4 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800ba4:	55                   	push   %ebp
  800ba5:	89 e5                	mov    %esp,%ebp
  800ba7:	53                   	push   %ebx
  800ba8:	83 ec 10             	sub    $0x10,%esp
  800bab:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800bae:	53                   	push   %ebx
  800baf:	e8 97 ff ff ff       	call   800b4b <strlen>
  800bb4:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800bb7:	ff 75 0c             	pushl  0xc(%ebp)
  800bba:	01 d8                	add    %ebx,%eax
  800bbc:	50                   	push   %eax
  800bbd:	e8 c2 ff ff ff       	call   800b84 <strcpy>
	return dst;
}
  800bc2:	89 d8                	mov    %ebx,%eax
  800bc4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800bc7:	c9                   	leave  
  800bc8:	c3                   	ret    

00800bc9 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800bc9:	55                   	push   %ebp
  800bca:	89 e5                	mov    %esp,%ebp
  800bcc:	56                   	push   %esi
  800bcd:	53                   	push   %ebx
  800bce:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bd4:	89 c6                	mov    %eax,%esi
  800bd6:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800bd9:	89 c2                	mov    %eax,%edx
  800bdb:	39 f2                	cmp    %esi,%edx
  800bdd:	74 11                	je     800bf0 <strncpy+0x27>
		*dst++ = *src;
  800bdf:	83 c2 01             	add    $0x1,%edx
  800be2:	0f b6 19             	movzbl (%ecx),%ebx
  800be5:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800be8:	80 fb 01             	cmp    $0x1,%bl
  800beb:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800bee:	eb eb                	jmp    800bdb <strncpy+0x12>
	}
	return ret;
}
  800bf0:	5b                   	pop    %ebx
  800bf1:	5e                   	pop    %esi
  800bf2:	5d                   	pop    %ebp
  800bf3:	c3                   	ret    

00800bf4 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800bf4:	55                   	push   %ebp
  800bf5:	89 e5                	mov    %esp,%ebp
  800bf7:	56                   	push   %esi
  800bf8:	53                   	push   %ebx
  800bf9:	8b 75 08             	mov    0x8(%ebp),%esi
  800bfc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bff:	8b 55 10             	mov    0x10(%ebp),%edx
  800c02:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800c04:	85 d2                	test   %edx,%edx
  800c06:	74 21                	je     800c29 <strlcpy+0x35>
  800c08:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800c0c:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800c0e:	39 c2                	cmp    %eax,%edx
  800c10:	74 14                	je     800c26 <strlcpy+0x32>
  800c12:	0f b6 19             	movzbl (%ecx),%ebx
  800c15:	84 db                	test   %bl,%bl
  800c17:	74 0b                	je     800c24 <strlcpy+0x30>
			*dst++ = *src++;
  800c19:	83 c1 01             	add    $0x1,%ecx
  800c1c:	83 c2 01             	add    $0x1,%edx
  800c1f:	88 5a ff             	mov    %bl,-0x1(%edx)
  800c22:	eb ea                	jmp    800c0e <strlcpy+0x1a>
  800c24:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800c26:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c29:	29 f0                	sub    %esi,%eax
}
  800c2b:	5b                   	pop    %ebx
  800c2c:	5e                   	pop    %esi
  800c2d:	5d                   	pop    %ebp
  800c2e:	c3                   	ret    

00800c2f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c2f:	55                   	push   %ebp
  800c30:	89 e5                	mov    %esp,%ebp
  800c32:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c35:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800c38:	0f b6 01             	movzbl (%ecx),%eax
  800c3b:	84 c0                	test   %al,%al
  800c3d:	74 0c                	je     800c4b <strcmp+0x1c>
  800c3f:	3a 02                	cmp    (%edx),%al
  800c41:	75 08                	jne    800c4b <strcmp+0x1c>
		p++, q++;
  800c43:	83 c1 01             	add    $0x1,%ecx
  800c46:	83 c2 01             	add    $0x1,%edx
  800c49:	eb ed                	jmp    800c38 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c4b:	0f b6 c0             	movzbl %al,%eax
  800c4e:	0f b6 12             	movzbl (%edx),%edx
  800c51:	29 d0                	sub    %edx,%eax
}
  800c53:	5d                   	pop    %ebp
  800c54:	c3                   	ret    

00800c55 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800c55:	55                   	push   %ebp
  800c56:	89 e5                	mov    %esp,%ebp
  800c58:	53                   	push   %ebx
  800c59:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c5f:	89 c3                	mov    %eax,%ebx
  800c61:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800c64:	eb 06                	jmp    800c6c <strncmp+0x17>
		n--, p++, q++;
  800c66:	83 c0 01             	add    $0x1,%eax
  800c69:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800c6c:	39 d8                	cmp    %ebx,%eax
  800c6e:	74 16                	je     800c86 <strncmp+0x31>
  800c70:	0f b6 08             	movzbl (%eax),%ecx
  800c73:	84 c9                	test   %cl,%cl
  800c75:	74 04                	je     800c7b <strncmp+0x26>
  800c77:	3a 0a                	cmp    (%edx),%cl
  800c79:	74 eb                	je     800c66 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c7b:	0f b6 00             	movzbl (%eax),%eax
  800c7e:	0f b6 12             	movzbl (%edx),%edx
  800c81:	29 d0                	sub    %edx,%eax
}
  800c83:	5b                   	pop    %ebx
  800c84:	5d                   	pop    %ebp
  800c85:	c3                   	ret    
		return 0;
  800c86:	b8 00 00 00 00       	mov    $0x0,%eax
  800c8b:	eb f6                	jmp    800c83 <strncmp+0x2e>

00800c8d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c8d:	55                   	push   %ebp
  800c8e:	89 e5                	mov    %esp,%ebp
  800c90:	8b 45 08             	mov    0x8(%ebp),%eax
  800c93:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c97:	0f b6 10             	movzbl (%eax),%edx
  800c9a:	84 d2                	test   %dl,%dl
  800c9c:	74 09                	je     800ca7 <strchr+0x1a>
		if (*s == c)
  800c9e:	38 ca                	cmp    %cl,%dl
  800ca0:	74 0a                	je     800cac <strchr+0x1f>
	for (; *s; s++)
  800ca2:	83 c0 01             	add    $0x1,%eax
  800ca5:	eb f0                	jmp    800c97 <strchr+0xa>
			return (char *) s;
	return 0;
  800ca7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cac:	5d                   	pop    %ebp
  800cad:	c3                   	ret    

00800cae <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cae:	55                   	push   %ebp
  800caf:	89 e5                	mov    %esp,%ebp
  800cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800cb8:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800cbb:	38 ca                	cmp    %cl,%dl
  800cbd:	74 09                	je     800cc8 <strfind+0x1a>
  800cbf:	84 d2                	test   %dl,%dl
  800cc1:	74 05                	je     800cc8 <strfind+0x1a>
	for (; *s; s++)
  800cc3:	83 c0 01             	add    $0x1,%eax
  800cc6:	eb f0                	jmp    800cb8 <strfind+0xa>
			break;
	return (char *) s;
}
  800cc8:	5d                   	pop    %ebp
  800cc9:	c3                   	ret    

00800cca <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800cca:	55                   	push   %ebp
  800ccb:	89 e5                	mov    %esp,%ebp
  800ccd:	57                   	push   %edi
  800cce:	56                   	push   %esi
  800ccf:	53                   	push   %ebx
  800cd0:	8b 7d 08             	mov    0x8(%ebp),%edi
  800cd3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800cd6:	85 c9                	test   %ecx,%ecx
  800cd8:	74 31                	je     800d0b <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800cda:	89 f8                	mov    %edi,%eax
  800cdc:	09 c8                	or     %ecx,%eax
  800cde:	a8 03                	test   $0x3,%al
  800ce0:	75 23                	jne    800d05 <memset+0x3b>
		c &= 0xFF;
  800ce2:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ce6:	89 d3                	mov    %edx,%ebx
  800ce8:	c1 e3 08             	shl    $0x8,%ebx
  800ceb:	89 d0                	mov    %edx,%eax
  800ced:	c1 e0 18             	shl    $0x18,%eax
  800cf0:	89 d6                	mov    %edx,%esi
  800cf2:	c1 e6 10             	shl    $0x10,%esi
  800cf5:	09 f0                	or     %esi,%eax
  800cf7:	09 c2                	or     %eax,%edx
  800cf9:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800cfb:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800cfe:	89 d0                	mov    %edx,%eax
  800d00:	fc                   	cld    
  800d01:	f3 ab                	rep stos %eax,%es:(%edi)
  800d03:	eb 06                	jmp    800d0b <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d05:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d08:	fc                   	cld    
  800d09:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800d0b:	89 f8                	mov    %edi,%eax
  800d0d:	5b                   	pop    %ebx
  800d0e:	5e                   	pop    %esi
  800d0f:	5f                   	pop    %edi
  800d10:	5d                   	pop    %ebp
  800d11:	c3                   	ret    

00800d12 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800d12:	55                   	push   %ebp
  800d13:	89 e5                	mov    %esp,%ebp
  800d15:	57                   	push   %edi
  800d16:	56                   	push   %esi
  800d17:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1a:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d1d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d20:	39 c6                	cmp    %eax,%esi
  800d22:	73 32                	jae    800d56 <memmove+0x44>
  800d24:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800d27:	39 c2                	cmp    %eax,%edx
  800d29:	76 2b                	jbe    800d56 <memmove+0x44>
		s += n;
		d += n;
  800d2b:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d2e:	89 fe                	mov    %edi,%esi
  800d30:	09 ce                	or     %ecx,%esi
  800d32:	09 d6                	or     %edx,%esi
  800d34:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800d3a:	75 0e                	jne    800d4a <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800d3c:	83 ef 04             	sub    $0x4,%edi
  800d3f:	8d 72 fc             	lea    -0x4(%edx),%esi
  800d42:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800d45:	fd                   	std    
  800d46:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d48:	eb 09                	jmp    800d53 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800d4a:	83 ef 01             	sub    $0x1,%edi
  800d4d:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800d50:	fd                   	std    
  800d51:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800d53:	fc                   	cld    
  800d54:	eb 1a                	jmp    800d70 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d56:	89 c2                	mov    %eax,%edx
  800d58:	09 ca                	or     %ecx,%edx
  800d5a:	09 f2                	or     %esi,%edx
  800d5c:	f6 c2 03             	test   $0x3,%dl
  800d5f:	75 0a                	jne    800d6b <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800d61:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800d64:	89 c7                	mov    %eax,%edi
  800d66:	fc                   	cld    
  800d67:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d69:	eb 05                	jmp    800d70 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800d6b:	89 c7                	mov    %eax,%edi
  800d6d:	fc                   	cld    
  800d6e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800d70:	5e                   	pop    %esi
  800d71:	5f                   	pop    %edi
  800d72:	5d                   	pop    %ebp
  800d73:	c3                   	ret    

00800d74 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800d74:	55                   	push   %ebp
  800d75:	89 e5                	mov    %esp,%ebp
  800d77:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800d7a:	ff 75 10             	pushl  0x10(%ebp)
  800d7d:	ff 75 0c             	pushl  0xc(%ebp)
  800d80:	ff 75 08             	pushl  0x8(%ebp)
  800d83:	e8 8a ff ff ff       	call   800d12 <memmove>
}
  800d88:	c9                   	leave  
  800d89:	c3                   	ret    

00800d8a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800d8a:	55                   	push   %ebp
  800d8b:	89 e5                	mov    %esp,%ebp
  800d8d:	56                   	push   %esi
  800d8e:	53                   	push   %ebx
  800d8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d92:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d95:	89 c6                	mov    %eax,%esi
  800d97:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d9a:	39 f0                	cmp    %esi,%eax
  800d9c:	74 1c                	je     800dba <memcmp+0x30>
		if (*s1 != *s2)
  800d9e:	0f b6 08             	movzbl (%eax),%ecx
  800da1:	0f b6 1a             	movzbl (%edx),%ebx
  800da4:	38 d9                	cmp    %bl,%cl
  800da6:	75 08                	jne    800db0 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800da8:	83 c0 01             	add    $0x1,%eax
  800dab:	83 c2 01             	add    $0x1,%edx
  800dae:	eb ea                	jmp    800d9a <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800db0:	0f b6 c1             	movzbl %cl,%eax
  800db3:	0f b6 db             	movzbl %bl,%ebx
  800db6:	29 d8                	sub    %ebx,%eax
  800db8:	eb 05                	jmp    800dbf <memcmp+0x35>
	}

	return 0;
  800dba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dbf:	5b                   	pop    %ebx
  800dc0:	5e                   	pop    %esi
  800dc1:	5d                   	pop    %ebp
  800dc2:	c3                   	ret    

00800dc3 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800dc3:	55                   	push   %ebp
  800dc4:	89 e5                	mov    %esp,%ebp
  800dc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800dcc:	89 c2                	mov    %eax,%edx
  800dce:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800dd1:	39 d0                	cmp    %edx,%eax
  800dd3:	73 09                	jae    800dde <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800dd5:	38 08                	cmp    %cl,(%eax)
  800dd7:	74 05                	je     800dde <memfind+0x1b>
	for (; s < ends; s++)
  800dd9:	83 c0 01             	add    $0x1,%eax
  800ddc:	eb f3                	jmp    800dd1 <memfind+0xe>
			break;
	return (void *) s;
}
  800dde:	5d                   	pop    %ebp
  800ddf:	c3                   	ret    

00800de0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800de0:	55                   	push   %ebp
  800de1:	89 e5                	mov    %esp,%ebp
  800de3:	57                   	push   %edi
  800de4:	56                   	push   %esi
  800de5:	53                   	push   %ebx
  800de6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800de9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800dec:	eb 03                	jmp    800df1 <strtol+0x11>
		s++;
  800dee:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800df1:	0f b6 01             	movzbl (%ecx),%eax
  800df4:	3c 20                	cmp    $0x20,%al
  800df6:	74 f6                	je     800dee <strtol+0xe>
  800df8:	3c 09                	cmp    $0x9,%al
  800dfa:	74 f2                	je     800dee <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800dfc:	3c 2b                	cmp    $0x2b,%al
  800dfe:	74 2a                	je     800e2a <strtol+0x4a>
	int neg = 0;
  800e00:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800e05:	3c 2d                	cmp    $0x2d,%al
  800e07:	74 2b                	je     800e34 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e09:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800e0f:	75 0f                	jne    800e20 <strtol+0x40>
  800e11:	80 39 30             	cmpb   $0x30,(%ecx)
  800e14:	74 28                	je     800e3e <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800e16:	85 db                	test   %ebx,%ebx
  800e18:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e1d:	0f 44 d8             	cmove  %eax,%ebx
  800e20:	b8 00 00 00 00       	mov    $0x0,%eax
  800e25:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800e28:	eb 50                	jmp    800e7a <strtol+0x9a>
		s++;
  800e2a:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800e2d:	bf 00 00 00 00       	mov    $0x0,%edi
  800e32:	eb d5                	jmp    800e09 <strtol+0x29>
		s++, neg = 1;
  800e34:	83 c1 01             	add    $0x1,%ecx
  800e37:	bf 01 00 00 00       	mov    $0x1,%edi
  800e3c:	eb cb                	jmp    800e09 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e3e:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800e42:	74 0e                	je     800e52 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800e44:	85 db                	test   %ebx,%ebx
  800e46:	75 d8                	jne    800e20 <strtol+0x40>
		s++, base = 8;
  800e48:	83 c1 01             	add    $0x1,%ecx
  800e4b:	bb 08 00 00 00       	mov    $0x8,%ebx
  800e50:	eb ce                	jmp    800e20 <strtol+0x40>
		s += 2, base = 16;
  800e52:	83 c1 02             	add    $0x2,%ecx
  800e55:	bb 10 00 00 00       	mov    $0x10,%ebx
  800e5a:	eb c4                	jmp    800e20 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800e5c:	8d 72 9f             	lea    -0x61(%edx),%esi
  800e5f:	89 f3                	mov    %esi,%ebx
  800e61:	80 fb 19             	cmp    $0x19,%bl
  800e64:	77 29                	ja     800e8f <strtol+0xaf>
			dig = *s - 'a' + 10;
  800e66:	0f be d2             	movsbl %dl,%edx
  800e69:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800e6c:	3b 55 10             	cmp    0x10(%ebp),%edx
  800e6f:	7d 30                	jge    800ea1 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800e71:	83 c1 01             	add    $0x1,%ecx
  800e74:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e78:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800e7a:	0f b6 11             	movzbl (%ecx),%edx
  800e7d:	8d 72 d0             	lea    -0x30(%edx),%esi
  800e80:	89 f3                	mov    %esi,%ebx
  800e82:	80 fb 09             	cmp    $0x9,%bl
  800e85:	77 d5                	ja     800e5c <strtol+0x7c>
			dig = *s - '0';
  800e87:	0f be d2             	movsbl %dl,%edx
  800e8a:	83 ea 30             	sub    $0x30,%edx
  800e8d:	eb dd                	jmp    800e6c <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800e8f:	8d 72 bf             	lea    -0x41(%edx),%esi
  800e92:	89 f3                	mov    %esi,%ebx
  800e94:	80 fb 19             	cmp    $0x19,%bl
  800e97:	77 08                	ja     800ea1 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800e99:	0f be d2             	movsbl %dl,%edx
  800e9c:	83 ea 37             	sub    $0x37,%edx
  800e9f:	eb cb                	jmp    800e6c <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800ea1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ea5:	74 05                	je     800eac <strtol+0xcc>
		*endptr = (char *) s;
  800ea7:	8b 75 0c             	mov    0xc(%ebp),%esi
  800eaa:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800eac:	89 c2                	mov    %eax,%edx
  800eae:	f7 da                	neg    %edx
  800eb0:	85 ff                	test   %edi,%edi
  800eb2:	0f 45 c2             	cmovne %edx,%eax
}
  800eb5:	5b                   	pop    %ebx
  800eb6:	5e                   	pop    %esi
  800eb7:	5f                   	pop    %edi
  800eb8:	5d                   	pop    %ebp
  800eb9:	c3                   	ret    
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
