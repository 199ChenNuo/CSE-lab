
obj/user/faultwrite.debug:     file format elf32-i386


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
  80002c:	e8 0d 00 00 00       	call   80003e <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
	*(unsigned*)0 = 0;
  800033:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80003a:	00 00 00 
}
  80003d:	c3                   	ret    

0080003e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80003e:	55                   	push   %ebp
  80003f:	89 e5                	mov    %esp,%ebp
  800041:	56                   	push   %esi
  800042:	53                   	push   %ebx
  800043:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800046:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	// thisenv = 0;
	thisenv = &(envs[ENVX(sys_getenvid())]);
  800049:	e8 c9 00 00 00       	call   800117 <sys_getenvid>
  80004e:	25 ff 03 00 00       	and    $0x3ff,%eax
  800053:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  800059:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80005e:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800063:	85 db                	test   %ebx,%ebx
  800065:	7e 07                	jle    80006e <libmain+0x30>
		binaryname = argv[0];
  800067:	8b 06                	mov    (%esi),%eax
  800069:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	56                   	push   %esi
  800072:	53                   	push   %ebx
  800073:	e8 bb ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800078:	e8 0a 00 00 00       	call   800087 <exit>
}
  80007d:	83 c4 10             	add    $0x10,%esp
  800080:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800083:	5b                   	pop    %ebx
  800084:	5e                   	pop    %esi
  800085:	5d                   	pop    %ebp
  800086:	c3                   	ret    

00800087 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800087:	55                   	push   %ebp
  800088:	89 e5                	mov    %esp,%ebp
  80008a:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  80008d:	6a 00                	push   $0x0
  80008f:	e8 42 00 00 00       	call   8000d6 <sys_env_destroy>
}
  800094:	83 c4 10             	add    $0x10,%esp
  800097:	c9                   	leave  
  800098:	c3                   	ret    

00800099 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800099:	55                   	push   %ebp
  80009a:	89 e5                	mov    %esp,%ebp
  80009c:	57                   	push   %edi
  80009d:	56                   	push   %esi
  80009e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80009f:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8000a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000aa:	89 c3                	mov    %eax,%ebx
  8000ac:	89 c7                	mov    %eax,%edi
  8000ae:	89 c6                	mov    %eax,%esi
  8000b0:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000b2:	5b                   	pop    %ebx
  8000b3:	5e                   	pop    %esi
  8000b4:	5f                   	pop    %edi
  8000b5:	5d                   	pop    %ebp
  8000b6:	c3                   	ret    

008000b7 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000b7:	55                   	push   %ebp
  8000b8:	89 e5                	mov    %esp,%ebp
  8000ba:	57                   	push   %edi
  8000bb:	56                   	push   %esi
  8000bc:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8000c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8000c7:	89 d1                	mov    %edx,%ecx
  8000c9:	89 d3                	mov    %edx,%ebx
  8000cb:	89 d7                	mov    %edx,%edi
  8000cd:	89 d6                	mov    %edx,%esi
  8000cf:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000d1:	5b                   	pop    %ebx
  8000d2:	5e                   	pop    %esi
  8000d3:	5f                   	pop    %edi
  8000d4:	5d                   	pop    %ebp
  8000d5:	c3                   	ret    

008000d6 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000d6:	55                   	push   %ebp
  8000d7:	89 e5                	mov    %esp,%ebp
  8000d9:	57                   	push   %edi
  8000da:	56                   	push   %esi
  8000db:	53                   	push   %ebx
  8000dc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000df:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8000e7:	b8 03 00 00 00       	mov    $0x3,%eax
  8000ec:	89 cb                	mov    %ecx,%ebx
  8000ee:	89 cf                	mov    %ecx,%edi
  8000f0:	89 ce                	mov    %ecx,%esi
  8000f2:	cd 30                	int    $0x30
	if (check && ret > 0)
  8000f4:	85 c0                	test   %eax,%eax
  8000f6:	7f 08                	jg     800100 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8000f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000fb:	5b                   	pop    %ebx
  8000fc:	5e                   	pop    %esi
  8000fd:	5f                   	pop    %edi
  8000fe:	5d                   	pop    %ebp
  8000ff:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800100:	83 ec 0c             	sub    $0xc,%esp
  800103:	50                   	push   %eax
  800104:	6a 03                	push   $0x3
  800106:	68 2a 11 80 00       	push   $0x80112a
  80010b:	6a 4c                	push   $0x4c
  80010d:	68 47 11 80 00       	push   $0x801147
  800112:	e8 70 02 00 00       	call   800387 <_panic>

00800117 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800117:	55                   	push   %ebp
  800118:	89 e5                	mov    %esp,%ebp
  80011a:	57                   	push   %edi
  80011b:	56                   	push   %esi
  80011c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80011d:	ba 00 00 00 00       	mov    $0x0,%edx
  800122:	b8 02 00 00 00       	mov    $0x2,%eax
  800127:	89 d1                	mov    %edx,%ecx
  800129:	89 d3                	mov    %edx,%ebx
  80012b:	89 d7                	mov    %edx,%edi
  80012d:	89 d6                	mov    %edx,%esi
  80012f:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800131:	5b                   	pop    %ebx
  800132:	5e                   	pop    %esi
  800133:	5f                   	pop    %edi
  800134:	5d                   	pop    %ebp
  800135:	c3                   	ret    

00800136 <sys_yield>:

void
sys_yield(void)
{
  800136:	55                   	push   %ebp
  800137:	89 e5                	mov    %esp,%ebp
  800139:	57                   	push   %edi
  80013a:	56                   	push   %esi
  80013b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80013c:	ba 00 00 00 00       	mov    $0x0,%edx
  800141:	b8 0b 00 00 00       	mov    $0xb,%eax
  800146:	89 d1                	mov    %edx,%ecx
  800148:	89 d3                	mov    %edx,%ebx
  80014a:	89 d7                	mov    %edx,%edi
  80014c:	89 d6                	mov    %edx,%esi
  80014e:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800150:	5b                   	pop    %ebx
  800151:	5e                   	pop    %esi
  800152:	5f                   	pop    %edi
  800153:	5d                   	pop    %ebp
  800154:	c3                   	ret    

00800155 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800155:	55                   	push   %ebp
  800156:	89 e5                	mov    %esp,%ebp
  800158:	57                   	push   %edi
  800159:	56                   	push   %esi
  80015a:	53                   	push   %ebx
  80015b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80015e:	be 00 00 00 00       	mov    $0x0,%esi
  800163:	8b 55 08             	mov    0x8(%ebp),%edx
  800166:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800169:	b8 04 00 00 00       	mov    $0x4,%eax
  80016e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800171:	89 f7                	mov    %esi,%edi
  800173:	cd 30                	int    $0x30
	if (check && ret > 0)
  800175:	85 c0                	test   %eax,%eax
  800177:	7f 08                	jg     800181 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800179:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80017c:	5b                   	pop    %ebx
  80017d:	5e                   	pop    %esi
  80017e:	5f                   	pop    %edi
  80017f:	5d                   	pop    %ebp
  800180:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800181:	83 ec 0c             	sub    $0xc,%esp
  800184:	50                   	push   %eax
  800185:	6a 04                	push   $0x4
  800187:	68 2a 11 80 00       	push   $0x80112a
  80018c:	6a 4c                	push   $0x4c
  80018e:	68 47 11 80 00       	push   $0x801147
  800193:	e8 ef 01 00 00       	call   800387 <_panic>

00800198 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800198:	55                   	push   %ebp
  800199:	89 e5                	mov    %esp,%ebp
  80019b:	57                   	push   %edi
  80019c:	56                   	push   %esi
  80019d:	53                   	push   %ebx
  80019e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8001a4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001a7:	b8 05 00 00 00       	mov    $0x5,%eax
  8001ac:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001af:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001b2:	8b 75 18             	mov    0x18(%ebp),%esi
  8001b5:	cd 30                	int    $0x30
	if (check && ret > 0)
  8001b7:	85 c0                	test   %eax,%eax
  8001b9:	7f 08                	jg     8001c3 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001be:	5b                   	pop    %ebx
  8001bf:	5e                   	pop    %esi
  8001c0:	5f                   	pop    %edi
  8001c1:	5d                   	pop    %ebp
  8001c2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001c3:	83 ec 0c             	sub    $0xc,%esp
  8001c6:	50                   	push   %eax
  8001c7:	6a 05                	push   $0x5
  8001c9:	68 2a 11 80 00       	push   $0x80112a
  8001ce:	6a 4c                	push   $0x4c
  8001d0:	68 47 11 80 00       	push   $0x801147
  8001d5:	e8 ad 01 00 00       	call   800387 <_panic>

008001da <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001da:	55                   	push   %ebp
  8001db:	89 e5                	mov    %esp,%ebp
  8001dd:	57                   	push   %edi
  8001de:	56                   	push   %esi
  8001df:	53                   	push   %ebx
  8001e0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001e3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8001eb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001ee:	b8 06 00 00 00       	mov    $0x6,%eax
  8001f3:	89 df                	mov    %ebx,%edi
  8001f5:	89 de                	mov    %ebx,%esi
  8001f7:	cd 30                	int    $0x30
	if (check && ret > 0)
  8001f9:	85 c0                	test   %eax,%eax
  8001fb:	7f 08                	jg     800205 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8001fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800200:	5b                   	pop    %ebx
  800201:	5e                   	pop    %esi
  800202:	5f                   	pop    %edi
  800203:	5d                   	pop    %ebp
  800204:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800205:	83 ec 0c             	sub    $0xc,%esp
  800208:	50                   	push   %eax
  800209:	6a 06                	push   $0x6
  80020b:	68 2a 11 80 00       	push   $0x80112a
  800210:	6a 4c                	push   $0x4c
  800212:	68 47 11 80 00       	push   $0x801147
  800217:	e8 6b 01 00 00       	call   800387 <_panic>

0080021c <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80021c:	55                   	push   %ebp
  80021d:	89 e5                	mov    %esp,%ebp
  80021f:	57                   	push   %edi
  800220:	56                   	push   %esi
  800221:	53                   	push   %ebx
  800222:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800225:	bb 00 00 00 00       	mov    $0x0,%ebx
  80022a:	8b 55 08             	mov    0x8(%ebp),%edx
  80022d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800230:	b8 08 00 00 00       	mov    $0x8,%eax
  800235:	89 df                	mov    %ebx,%edi
  800237:	89 de                	mov    %ebx,%esi
  800239:	cd 30                	int    $0x30
	if (check && ret > 0)
  80023b:	85 c0                	test   %eax,%eax
  80023d:	7f 08                	jg     800247 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80023f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800242:	5b                   	pop    %ebx
  800243:	5e                   	pop    %esi
  800244:	5f                   	pop    %edi
  800245:	5d                   	pop    %ebp
  800246:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800247:	83 ec 0c             	sub    $0xc,%esp
  80024a:	50                   	push   %eax
  80024b:	6a 08                	push   $0x8
  80024d:	68 2a 11 80 00       	push   $0x80112a
  800252:	6a 4c                	push   $0x4c
  800254:	68 47 11 80 00       	push   $0x801147
  800259:	e8 29 01 00 00       	call   800387 <_panic>

0080025e <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80025e:	55                   	push   %ebp
  80025f:	89 e5                	mov    %esp,%ebp
  800261:	57                   	push   %edi
  800262:	56                   	push   %esi
  800263:	53                   	push   %ebx
  800264:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800267:	bb 00 00 00 00       	mov    $0x0,%ebx
  80026c:	8b 55 08             	mov    0x8(%ebp),%edx
  80026f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800272:	b8 09 00 00 00       	mov    $0x9,%eax
  800277:	89 df                	mov    %ebx,%edi
  800279:	89 de                	mov    %ebx,%esi
  80027b:	cd 30                	int    $0x30
	if (check && ret > 0)
  80027d:	85 c0                	test   %eax,%eax
  80027f:	7f 08                	jg     800289 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800281:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800284:	5b                   	pop    %ebx
  800285:	5e                   	pop    %esi
  800286:	5f                   	pop    %edi
  800287:	5d                   	pop    %ebp
  800288:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800289:	83 ec 0c             	sub    $0xc,%esp
  80028c:	50                   	push   %eax
  80028d:	6a 09                	push   $0x9
  80028f:	68 2a 11 80 00       	push   $0x80112a
  800294:	6a 4c                	push   $0x4c
  800296:	68 47 11 80 00       	push   $0x801147
  80029b:	e8 e7 00 00 00       	call   800387 <_panic>

008002a0 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002a0:	55                   	push   %ebp
  8002a1:	89 e5                	mov    %esp,%ebp
  8002a3:	57                   	push   %edi
  8002a4:	56                   	push   %esi
  8002a5:	53                   	push   %ebx
  8002a6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002a9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8002b1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002b4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002b9:	89 df                	mov    %ebx,%edi
  8002bb:	89 de                	mov    %ebx,%esi
  8002bd:	cd 30                	int    $0x30
	if (check && ret > 0)
  8002bf:	85 c0                	test   %eax,%eax
  8002c1:	7f 08                	jg     8002cb <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002c6:	5b                   	pop    %ebx
  8002c7:	5e                   	pop    %esi
  8002c8:	5f                   	pop    %edi
  8002c9:	5d                   	pop    %ebp
  8002ca:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002cb:	83 ec 0c             	sub    $0xc,%esp
  8002ce:	50                   	push   %eax
  8002cf:	6a 0a                	push   $0xa
  8002d1:	68 2a 11 80 00       	push   $0x80112a
  8002d6:	6a 4c                	push   $0x4c
  8002d8:	68 47 11 80 00       	push   $0x801147
  8002dd:	e8 a5 00 00 00       	call   800387 <_panic>

008002e2 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002e2:	55                   	push   %ebp
  8002e3:	89 e5                	mov    %esp,%ebp
  8002e5:	57                   	push   %edi
  8002e6:	56                   	push   %esi
  8002e7:	53                   	push   %ebx
	asm volatile("int %1\n"
  8002e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8002eb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002ee:	b8 0c 00 00 00       	mov    $0xc,%eax
  8002f3:	be 00 00 00 00       	mov    $0x0,%esi
  8002f8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8002fb:	8b 7d 14             	mov    0x14(%ebp),%edi
  8002fe:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800300:	5b                   	pop    %ebx
  800301:	5e                   	pop    %esi
  800302:	5f                   	pop    %edi
  800303:	5d                   	pop    %ebp
  800304:	c3                   	ret    

00800305 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800305:	55                   	push   %ebp
  800306:	89 e5                	mov    %esp,%ebp
  800308:	57                   	push   %edi
  800309:	56                   	push   %esi
  80030a:	53                   	push   %ebx
  80030b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80030e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800313:	8b 55 08             	mov    0x8(%ebp),%edx
  800316:	b8 0d 00 00 00       	mov    $0xd,%eax
  80031b:	89 cb                	mov    %ecx,%ebx
  80031d:	89 cf                	mov    %ecx,%edi
  80031f:	89 ce                	mov    %ecx,%esi
  800321:	cd 30                	int    $0x30
	if (check && ret > 0)
  800323:	85 c0                	test   %eax,%eax
  800325:	7f 08                	jg     80032f <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800327:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80032a:	5b                   	pop    %ebx
  80032b:	5e                   	pop    %esi
  80032c:	5f                   	pop    %edi
  80032d:	5d                   	pop    %ebp
  80032e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80032f:	83 ec 0c             	sub    $0xc,%esp
  800332:	50                   	push   %eax
  800333:	6a 0d                	push   $0xd
  800335:	68 2a 11 80 00       	push   $0x80112a
  80033a:	6a 4c                	push   $0x4c
  80033c:	68 47 11 80 00       	push   $0x801147
  800341:	e8 41 00 00 00       	call   800387 <_panic>

00800346 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800346:	55                   	push   %ebp
  800347:	89 e5                	mov    %esp,%ebp
  800349:	57                   	push   %edi
  80034a:	56                   	push   %esi
  80034b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80034c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800351:	8b 55 08             	mov    0x8(%ebp),%edx
  800354:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800357:	b8 0e 00 00 00       	mov    $0xe,%eax
  80035c:	89 df                	mov    %ebx,%edi
  80035e:	89 de                	mov    %ebx,%esi
  800360:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800362:	5b                   	pop    %ebx
  800363:	5e                   	pop    %esi
  800364:	5f                   	pop    %edi
  800365:	5d                   	pop    %ebp
  800366:	c3                   	ret    

00800367 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800367:	55                   	push   %ebp
  800368:	89 e5                	mov    %esp,%ebp
  80036a:	57                   	push   %edi
  80036b:	56                   	push   %esi
  80036c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80036d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800372:	8b 55 08             	mov    0x8(%ebp),%edx
  800375:	b8 0f 00 00 00       	mov    $0xf,%eax
  80037a:	89 cb                	mov    %ecx,%ebx
  80037c:	89 cf                	mov    %ecx,%edi
  80037e:	89 ce                	mov    %ecx,%esi
  800380:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800382:	5b                   	pop    %ebx
  800383:	5e                   	pop    %esi
  800384:	5f                   	pop    %edi
  800385:	5d                   	pop    %ebp
  800386:	c3                   	ret    

00800387 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800387:	55                   	push   %ebp
  800388:	89 e5                	mov    %esp,%ebp
  80038a:	56                   	push   %esi
  80038b:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80038c:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80038f:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800395:	e8 7d fd ff ff       	call   800117 <sys_getenvid>
  80039a:	83 ec 0c             	sub    $0xc,%esp
  80039d:	ff 75 0c             	pushl  0xc(%ebp)
  8003a0:	ff 75 08             	pushl  0x8(%ebp)
  8003a3:	56                   	push   %esi
  8003a4:	50                   	push   %eax
  8003a5:	68 58 11 80 00       	push   $0x801158
  8003aa:	e8 b3 00 00 00       	call   800462 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8003af:	83 c4 18             	add    $0x18,%esp
  8003b2:	53                   	push   %ebx
  8003b3:	ff 75 10             	pushl  0x10(%ebp)
  8003b6:	e8 56 00 00 00       	call   800411 <vcprintf>
	cprintf("\n");
  8003bb:	c7 04 24 7b 11 80 00 	movl   $0x80117b,(%esp)
  8003c2:	e8 9b 00 00 00       	call   800462 <cprintf>
  8003c7:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8003ca:	cc                   	int3   
  8003cb:	eb fd                	jmp    8003ca <_panic+0x43>

008003cd <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8003cd:	55                   	push   %ebp
  8003ce:	89 e5                	mov    %esp,%ebp
  8003d0:	53                   	push   %ebx
  8003d1:	83 ec 04             	sub    $0x4,%esp
  8003d4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8003d7:	8b 13                	mov    (%ebx),%edx
  8003d9:	8d 42 01             	lea    0x1(%edx),%eax
  8003dc:	89 03                	mov    %eax,(%ebx)
  8003de:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003e1:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8003e5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003ea:	74 09                	je     8003f5 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8003ec:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8003f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003f3:	c9                   	leave  
  8003f4:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8003f5:	83 ec 08             	sub    $0x8,%esp
  8003f8:	68 ff 00 00 00       	push   $0xff
  8003fd:	8d 43 08             	lea    0x8(%ebx),%eax
  800400:	50                   	push   %eax
  800401:	e8 93 fc ff ff       	call   800099 <sys_cputs>
		b->idx = 0;
  800406:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80040c:	83 c4 10             	add    $0x10,%esp
  80040f:	eb db                	jmp    8003ec <putch+0x1f>

00800411 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800411:	55                   	push   %ebp
  800412:	89 e5                	mov    %esp,%ebp
  800414:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80041a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800421:	00 00 00 
	b.cnt = 0;
  800424:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80042b:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80042e:	ff 75 0c             	pushl  0xc(%ebp)
  800431:	ff 75 08             	pushl  0x8(%ebp)
  800434:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80043a:	50                   	push   %eax
  80043b:	68 cd 03 80 00       	push   $0x8003cd
  800440:	e8 4a 01 00 00       	call   80058f <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800445:	83 c4 08             	add    $0x8,%esp
  800448:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80044e:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800454:	50                   	push   %eax
  800455:	e8 3f fc ff ff       	call   800099 <sys_cputs>

	return b.cnt;
}
  80045a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800460:	c9                   	leave  
  800461:	c3                   	ret    

00800462 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800462:	55                   	push   %ebp
  800463:	89 e5                	mov    %esp,%ebp
  800465:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800468:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80046b:	50                   	push   %eax
  80046c:	ff 75 08             	pushl  0x8(%ebp)
  80046f:	e8 9d ff ff ff       	call   800411 <vcprintf>
	va_end(ap);

	return cnt;
}
  800474:	c9                   	leave  
  800475:	c3                   	ret    

00800476 <printnum>:


static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800476:	55                   	push   %ebp
  800477:	89 e5                	mov    %esp,%ebp
  800479:	57                   	push   %edi
  80047a:	56                   	push   %esi
  80047b:	53                   	push   %ebx
  80047c:	83 ec 1c             	sub    $0x1c,%esp
  80047f:	89 c6                	mov    %eax,%esi
  800481:	89 d7                	mov    %edx,%edi
  800483:	8b 45 08             	mov    0x8(%ebp),%eax
  800486:	8b 55 0c             	mov    0xc(%ebp),%edx
  800489:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80048c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80048f:	8b 45 10             	mov    0x10(%ebp),%eax
  800492:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	// to support '-'
	if(padc == '-'){
  800495:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800499:	74 2c                	je     8004c7 <printnum+0x51>
		while (--width > 0)
			putch(' ', putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80049b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80049e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8004a5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004a8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8004ab:	39 c2                	cmp    %eax,%edx
  8004ad:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8004b0:	73 43                	jae    8004f5 <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004b2:	83 eb 01             	sub    $0x1,%ebx
  8004b5:	85 db                	test   %ebx,%ebx
  8004b7:	7e 6c                	jle    800525 <printnum+0xaf>
			putch(padc, putdat);
  8004b9:	83 ec 08             	sub    $0x8,%esp
  8004bc:	57                   	push   %edi
  8004bd:	ff 75 18             	pushl  0x18(%ebp)
  8004c0:	ff d6                	call   *%esi
  8004c2:	83 c4 10             	add    $0x10,%esp
  8004c5:	eb eb                	jmp    8004b2 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8004c7:	83 ec 0c             	sub    $0xc,%esp
  8004ca:	6a 20                	push   $0x20
  8004cc:	6a 00                	push   $0x0
  8004ce:	50                   	push   %eax
  8004cf:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004d2:	ff 75 e0             	pushl  -0x20(%ebp)
  8004d5:	89 fa                	mov    %edi,%edx
  8004d7:	89 f0                	mov    %esi,%eax
  8004d9:	e8 98 ff ff ff       	call   800476 <printnum>
		while (--width > 0)
  8004de:	83 c4 20             	add    $0x20,%esp
  8004e1:	83 eb 01             	sub    $0x1,%ebx
  8004e4:	85 db                	test   %ebx,%ebx
  8004e6:	7e 65                	jle    80054d <printnum+0xd7>
			putch(' ', putdat);
  8004e8:	83 ec 08             	sub    $0x8,%esp
  8004eb:	57                   	push   %edi
  8004ec:	6a 20                	push   $0x20
  8004ee:	ff d6                	call   *%esi
  8004f0:	83 c4 10             	add    $0x10,%esp
  8004f3:	eb ec                	jmp    8004e1 <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004f5:	83 ec 0c             	sub    $0xc,%esp
  8004f8:	ff 75 18             	pushl  0x18(%ebp)
  8004fb:	83 eb 01             	sub    $0x1,%ebx
  8004fe:	53                   	push   %ebx
  8004ff:	50                   	push   %eax
  800500:	83 ec 08             	sub    $0x8,%esp
  800503:	ff 75 dc             	pushl  -0x24(%ebp)
  800506:	ff 75 d8             	pushl  -0x28(%ebp)
  800509:	ff 75 e4             	pushl  -0x1c(%ebp)
  80050c:	ff 75 e0             	pushl  -0x20(%ebp)
  80050f:	e8 ac 09 00 00       	call   800ec0 <__udivdi3>
  800514:	83 c4 18             	add    $0x18,%esp
  800517:	52                   	push   %edx
  800518:	50                   	push   %eax
  800519:	89 fa                	mov    %edi,%edx
  80051b:	89 f0                	mov    %esi,%eax
  80051d:	e8 54 ff ff ff       	call   800476 <printnum>
  800522:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800525:	83 ec 08             	sub    $0x8,%esp
  800528:	57                   	push   %edi
  800529:	83 ec 04             	sub    $0x4,%esp
  80052c:	ff 75 dc             	pushl  -0x24(%ebp)
  80052f:	ff 75 d8             	pushl  -0x28(%ebp)
  800532:	ff 75 e4             	pushl  -0x1c(%ebp)
  800535:	ff 75 e0             	pushl  -0x20(%ebp)
  800538:	e8 93 0a 00 00       	call   800fd0 <__umoddi3>
  80053d:	83 c4 14             	add    $0x14,%esp
  800540:	0f be 80 7d 11 80 00 	movsbl 0x80117d(%eax),%eax
  800547:	50                   	push   %eax
  800548:	ff d6                	call   *%esi
  80054a:	83 c4 10             	add    $0x10,%esp
}
  80054d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800550:	5b                   	pop    %ebx
  800551:	5e                   	pop    %esi
  800552:	5f                   	pop    %edi
  800553:	5d                   	pop    %ebp
  800554:	c3                   	ret    

00800555 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800555:	55                   	push   %ebp
  800556:	89 e5                	mov    %esp,%ebp
  800558:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80055b:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80055f:	8b 10                	mov    (%eax),%edx
  800561:	3b 50 04             	cmp    0x4(%eax),%edx
  800564:	73 0a                	jae    800570 <sprintputch+0x1b>
		*b->buf++ = ch;
  800566:	8d 4a 01             	lea    0x1(%edx),%ecx
  800569:	89 08                	mov    %ecx,(%eax)
  80056b:	8b 45 08             	mov    0x8(%ebp),%eax
  80056e:	88 02                	mov    %al,(%edx)
}
  800570:	5d                   	pop    %ebp
  800571:	c3                   	ret    

00800572 <printfmt>:
{
  800572:	55                   	push   %ebp
  800573:	89 e5                	mov    %esp,%ebp
  800575:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800578:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80057b:	50                   	push   %eax
  80057c:	ff 75 10             	pushl  0x10(%ebp)
  80057f:	ff 75 0c             	pushl  0xc(%ebp)
  800582:	ff 75 08             	pushl  0x8(%ebp)
  800585:	e8 05 00 00 00       	call   80058f <vprintfmt>
}
  80058a:	83 c4 10             	add    $0x10,%esp
  80058d:	c9                   	leave  
  80058e:	c3                   	ret    

0080058f <vprintfmt>:
{
  80058f:	55                   	push   %ebp
  800590:	89 e5                	mov    %esp,%ebp
  800592:	57                   	push   %edi
  800593:	56                   	push   %esi
  800594:	53                   	push   %ebx
  800595:	83 ec 3c             	sub    $0x3c,%esp
  800598:	8b 75 08             	mov    0x8(%ebp),%esi
  80059b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80059e:	8b 7d 10             	mov    0x10(%ebp),%edi
  8005a1:	e9 1e 04 00 00       	jmp    8009c4 <vprintfmt+0x435>
		posflag = 0;
  8005a6:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
		padc = ' ';
  8005ad:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8005b1:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8005b8:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8005bf:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8005c6:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  8005cd:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8005d2:	8d 47 01             	lea    0x1(%edi),%eax
  8005d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005d8:	0f b6 17             	movzbl (%edi),%edx
  8005db:	8d 42 dd             	lea    -0x23(%edx),%eax
  8005de:	3c 55                	cmp    $0x55,%al
  8005e0:	0f 87 d9 04 00 00    	ja     800abf <vprintfmt+0x530>
  8005e6:	0f b6 c0             	movzbl %al,%eax
  8005e9:	ff 24 85 60 13 80 00 	jmp    *0x801360(,%eax,4)
  8005f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8005f3:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8005f7:	eb d9                	jmp    8005d2 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8005f9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posflag = 1;
  8005fc:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  800603:	eb cd                	jmp    8005d2 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800605:	0f b6 d2             	movzbl %dl,%edx
  800608:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80060b:	b8 00 00 00 00       	mov    $0x0,%eax
  800610:	89 75 08             	mov    %esi,0x8(%ebp)
  800613:	eb 0c                	jmp    800621 <vprintfmt+0x92>
		switch (ch = *(unsigned char *) fmt++) {
  800615:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800618:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  80061c:	eb b4                	jmp    8005d2 <vprintfmt+0x43>
			for (precision = 0; ; ++fmt) {
  80061e:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800621:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800624:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800628:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80062b:	8d 72 d0             	lea    -0x30(%edx),%esi
  80062e:	83 fe 09             	cmp    $0x9,%esi
  800631:	76 eb                	jbe    80061e <vprintfmt+0x8f>
  800633:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800636:	8b 75 08             	mov    0x8(%ebp),%esi
  800639:	eb 14                	jmp    80064f <vprintfmt+0xc0>
			precision = va_arg(ap, int);
  80063b:	8b 45 14             	mov    0x14(%ebp),%eax
  80063e:	8b 00                	mov    (%eax),%eax
  800640:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800643:	8b 45 14             	mov    0x14(%ebp),%eax
  800646:	8d 40 04             	lea    0x4(%eax),%eax
  800649:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80064c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80064f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800653:	0f 89 79 ff ff ff    	jns    8005d2 <vprintfmt+0x43>
				width = precision, precision = -1;
  800659:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80065c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80065f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800666:	e9 67 ff ff ff       	jmp    8005d2 <vprintfmt+0x43>
  80066b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80066e:	85 c0                	test   %eax,%eax
  800670:	0f 48 c1             	cmovs  %ecx,%eax
  800673:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800676:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800679:	e9 54 ff ff ff       	jmp    8005d2 <vprintfmt+0x43>
  80067e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800681:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800688:	e9 45 ff ff ff       	jmp    8005d2 <vprintfmt+0x43>
			lflag++;
  80068d:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800691:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800694:	e9 39 ff ff ff       	jmp    8005d2 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800699:	8b 45 14             	mov    0x14(%ebp),%eax
  80069c:	8d 78 04             	lea    0x4(%eax),%edi
  80069f:	83 ec 08             	sub    $0x8,%esp
  8006a2:	53                   	push   %ebx
  8006a3:	ff 30                	pushl  (%eax)
  8006a5:	ff d6                	call   *%esi
			break;
  8006a7:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8006aa:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8006ad:	e9 0f 03 00 00       	jmp    8009c1 <vprintfmt+0x432>
			err = va_arg(ap, int);
  8006b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b5:	8d 78 04             	lea    0x4(%eax),%edi
  8006b8:	8b 00                	mov    (%eax),%eax
  8006ba:	99                   	cltd   
  8006bb:	31 d0                	xor    %edx,%eax
  8006bd:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8006bf:	83 f8 0f             	cmp    $0xf,%eax
  8006c2:	7f 23                	jg     8006e7 <vprintfmt+0x158>
  8006c4:	8b 14 85 c0 14 80 00 	mov    0x8014c0(,%eax,4),%edx
  8006cb:	85 d2                	test   %edx,%edx
  8006cd:	74 18                	je     8006e7 <vprintfmt+0x158>
				printfmt(putch, putdat, "%s", p);
  8006cf:	52                   	push   %edx
  8006d0:	68 9e 11 80 00       	push   $0x80119e
  8006d5:	53                   	push   %ebx
  8006d6:	56                   	push   %esi
  8006d7:	e8 96 fe ff ff       	call   800572 <printfmt>
  8006dc:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8006df:	89 7d 14             	mov    %edi,0x14(%ebp)
  8006e2:	e9 da 02 00 00       	jmp    8009c1 <vprintfmt+0x432>
				printfmt(putch, putdat, "error %d", err);
  8006e7:	50                   	push   %eax
  8006e8:	68 95 11 80 00       	push   $0x801195
  8006ed:	53                   	push   %ebx
  8006ee:	56                   	push   %esi
  8006ef:	e8 7e fe ff ff       	call   800572 <printfmt>
  8006f4:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8006f7:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8006fa:	e9 c2 02 00 00       	jmp    8009c1 <vprintfmt+0x432>
			if ((p = va_arg(ap, char *)) == NULL)
  8006ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800702:	83 c0 04             	add    $0x4,%eax
  800705:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800708:	8b 45 14             	mov    0x14(%ebp),%eax
  80070b:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80070d:	85 c9                	test   %ecx,%ecx
  80070f:	b8 8e 11 80 00       	mov    $0x80118e,%eax
  800714:	0f 45 c1             	cmovne %ecx,%eax
  800717:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80071a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80071e:	7e 06                	jle    800726 <vprintfmt+0x197>
  800720:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800724:	75 0d                	jne    800733 <vprintfmt+0x1a4>
				for (width -= strnlen(p, precision); width > 0; width--)
  800726:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800729:	89 c7                	mov    %eax,%edi
  80072b:	03 45 e0             	add    -0x20(%ebp),%eax
  80072e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800731:	eb 53                	jmp    800786 <vprintfmt+0x1f7>
  800733:	83 ec 08             	sub    $0x8,%esp
  800736:	ff 75 d8             	pushl  -0x28(%ebp)
  800739:	50                   	push   %eax
  80073a:	e8 28 04 00 00       	call   800b67 <strnlen>
  80073f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800742:	29 c1                	sub    %eax,%ecx
  800744:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  800747:	83 c4 10             	add    $0x10,%esp
  80074a:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  80074c:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800750:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800753:	eb 0f                	jmp    800764 <vprintfmt+0x1d5>
					putch(padc, putdat);
  800755:	83 ec 08             	sub    $0x8,%esp
  800758:	53                   	push   %ebx
  800759:	ff 75 e0             	pushl  -0x20(%ebp)
  80075c:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80075e:	83 ef 01             	sub    $0x1,%edi
  800761:	83 c4 10             	add    $0x10,%esp
  800764:	85 ff                	test   %edi,%edi
  800766:	7f ed                	jg     800755 <vprintfmt+0x1c6>
  800768:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  80076b:	85 c9                	test   %ecx,%ecx
  80076d:	b8 00 00 00 00       	mov    $0x0,%eax
  800772:	0f 49 c1             	cmovns %ecx,%eax
  800775:	29 c1                	sub    %eax,%ecx
  800777:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80077a:	eb aa                	jmp    800726 <vprintfmt+0x197>
					putch(ch, putdat);
  80077c:	83 ec 08             	sub    $0x8,%esp
  80077f:	53                   	push   %ebx
  800780:	52                   	push   %edx
  800781:	ff d6                	call   *%esi
  800783:	83 c4 10             	add    $0x10,%esp
  800786:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800789:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80078b:	83 c7 01             	add    $0x1,%edi
  80078e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800792:	0f be d0             	movsbl %al,%edx
  800795:	85 d2                	test   %edx,%edx
  800797:	74 4b                	je     8007e4 <vprintfmt+0x255>
  800799:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80079d:	78 06                	js     8007a5 <vprintfmt+0x216>
  80079f:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8007a3:	78 1e                	js     8007c3 <vprintfmt+0x234>
				if (altflag && (ch < ' ' || ch > '~'))
  8007a5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8007a9:	74 d1                	je     80077c <vprintfmt+0x1ed>
  8007ab:	0f be c0             	movsbl %al,%eax
  8007ae:	83 e8 20             	sub    $0x20,%eax
  8007b1:	83 f8 5e             	cmp    $0x5e,%eax
  8007b4:	76 c6                	jbe    80077c <vprintfmt+0x1ed>
					putch('?', putdat);
  8007b6:	83 ec 08             	sub    $0x8,%esp
  8007b9:	53                   	push   %ebx
  8007ba:	6a 3f                	push   $0x3f
  8007bc:	ff d6                	call   *%esi
  8007be:	83 c4 10             	add    $0x10,%esp
  8007c1:	eb c3                	jmp    800786 <vprintfmt+0x1f7>
  8007c3:	89 cf                	mov    %ecx,%edi
  8007c5:	eb 0e                	jmp    8007d5 <vprintfmt+0x246>
				putch(' ', putdat);
  8007c7:	83 ec 08             	sub    $0x8,%esp
  8007ca:	53                   	push   %ebx
  8007cb:	6a 20                	push   $0x20
  8007cd:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8007cf:	83 ef 01             	sub    $0x1,%edi
  8007d2:	83 c4 10             	add    $0x10,%esp
  8007d5:	85 ff                	test   %edi,%edi
  8007d7:	7f ee                	jg     8007c7 <vprintfmt+0x238>
			if ((p = va_arg(ap, char *)) == NULL)
  8007d9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8007dc:	89 45 14             	mov    %eax,0x14(%ebp)
  8007df:	e9 dd 01 00 00       	jmp    8009c1 <vprintfmt+0x432>
  8007e4:	89 cf                	mov    %ecx,%edi
  8007e6:	eb ed                	jmp    8007d5 <vprintfmt+0x246>
	if (lflag >= 2)
  8007e8:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8007ec:	7f 21                	jg     80080f <vprintfmt+0x280>
	else if (lflag)
  8007ee:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8007f2:	74 6a                	je     80085e <vprintfmt+0x2cf>
		return va_arg(*ap, long);
  8007f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f7:	8b 00                	mov    (%eax),%eax
  8007f9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007fc:	89 c1                	mov    %eax,%ecx
  8007fe:	c1 f9 1f             	sar    $0x1f,%ecx
  800801:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800804:	8b 45 14             	mov    0x14(%ebp),%eax
  800807:	8d 40 04             	lea    0x4(%eax),%eax
  80080a:	89 45 14             	mov    %eax,0x14(%ebp)
  80080d:	eb 17                	jmp    800826 <vprintfmt+0x297>
		return va_arg(*ap, long long);
  80080f:	8b 45 14             	mov    0x14(%ebp),%eax
  800812:	8b 50 04             	mov    0x4(%eax),%edx
  800815:	8b 00                	mov    (%eax),%eax
  800817:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80081a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80081d:	8b 45 14             	mov    0x14(%ebp),%eax
  800820:	8d 40 08             	lea    0x8(%eax),%eax
  800823:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800826:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  800829:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  80082e:	85 d2                	test   %edx,%edx
  800830:	0f 89 5c 01 00 00    	jns    800992 <vprintfmt+0x403>
				putch('-', putdat);
  800836:	83 ec 08             	sub    $0x8,%esp
  800839:	53                   	push   %ebx
  80083a:	6a 2d                	push   $0x2d
  80083c:	ff d6                	call   *%esi
				num = -(long long) num;
  80083e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800841:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800844:	f7 d8                	neg    %eax
  800846:	83 d2 00             	adc    $0x0,%edx
  800849:	f7 da                	neg    %edx
  80084b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80084e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800851:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800854:	bf 0a 00 00 00       	mov    $0xa,%edi
  800859:	e9 45 01 00 00       	jmp    8009a3 <vprintfmt+0x414>
		return va_arg(*ap, int);
  80085e:	8b 45 14             	mov    0x14(%ebp),%eax
  800861:	8b 00                	mov    (%eax),%eax
  800863:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800866:	89 c1                	mov    %eax,%ecx
  800868:	c1 f9 1f             	sar    $0x1f,%ecx
  80086b:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80086e:	8b 45 14             	mov    0x14(%ebp),%eax
  800871:	8d 40 04             	lea    0x4(%eax),%eax
  800874:	89 45 14             	mov    %eax,0x14(%ebp)
  800877:	eb ad                	jmp    800826 <vprintfmt+0x297>
	if (lflag >= 2)
  800879:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  80087d:	7f 29                	jg     8008a8 <vprintfmt+0x319>
	else if (lflag)
  80087f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800883:	74 44                	je     8008c9 <vprintfmt+0x33a>
		return va_arg(*ap, unsigned long);
  800885:	8b 45 14             	mov    0x14(%ebp),%eax
  800888:	8b 00                	mov    (%eax),%eax
  80088a:	ba 00 00 00 00       	mov    $0x0,%edx
  80088f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800892:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800895:	8b 45 14             	mov    0x14(%ebp),%eax
  800898:	8d 40 04             	lea    0x4(%eax),%eax
  80089b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80089e:	bf 0a 00 00 00       	mov    $0xa,%edi
  8008a3:	e9 ea 00 00 00       	jmp    800992 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  8008a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ab:	8b 50 04             	mov    0x4(%eax),%edx
  8008ae:	8b 00                	mov    (%eax),%eax
  8008b0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008b3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b9:	8d 40 08             	lea    0x8(%eax),%eax
  8008bc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008bf:	bf 0a 00 00 00       	mov    $0xa,%edi
  8008c4:	e9 c9 00 00 00       	jmp    800992 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  8008c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cc:	8b 00                	mov    (%eax),%eax
  8008ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8008d3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008d6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008dc:	8d 40 04             	lea    0x4(%eax),%eax
  8008df:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008e2:	bf 0a 00 00 00       	mov    $0xa,%edi
  8008e7:	e9 a6 00 00 00       	jmp    800992 <vprintfmt+0x403>
			putch('0', putdat);
  8008ec:	83 ec 08             	sub    $0x8,%esp
  8008ef:	53                   	push   %ebx
  8008f0:	6a 30                	push   $0x30
  8008f2:	ff d6                	call   *%esi
	if (lflag >= 2)
  8008f4:	83 c4 10             	add    $0x10,%esp
  8008f7:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8008fb:	7f 26                	jg     800923 <vprintfmt+0x394>
	else if (lflag)
  8008fd:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800901:	74 3e                	je     800941 <vprintfmt+0x3b2>
		return va_arg(*ap, unsigned long);
  800903:	8b 45 14             	mov    0x14(%ebp),%eax
  800906:	8b 00                	mov    (%eax),%eax
  800908:	ba 00 00 00 00       	mov    $0x0,%edx
  80090d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800910:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800913:	8b 45 14             	mov    0x14(%ebp),%eax
  800916:	8d 40 04             	lea    0x4(%eax),%eax
  800919:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80091c:	bf 08 00 00 00       	mov    $0x8,%edi
  800921:	eb 6f                	jmp    800992 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  800923:	8b 45 14             	mov    0x14(%ebp),%eax
  800926:	8b 50 04             	mov    0x4(%eax),%edx
  800929:	8b 00                	mov    (%eax),%eax
  80092b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80092e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800931:	8b 45 14             	mov    0x14(%ebp),%eax
  800934:	8d 40 08             	lea    0x8(%eax),%eax
  800937:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80093a:	bf 08 00 00 00       	mov    $0x8,%edi
  80093f:	eb 51                	jmp    800992 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  800941:	8b 45 14             	mov    0x14(%ebp),%eax
  800944:	8b 00                	mov    (%eax),%eax
  800946:	ba 00 00 00 00       	mov    $0x0,%edx
  80094b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80094e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800951:	8b 45 14             	mov    0x14(%ebp),%eax
  800954:	8d 40 04             	lea    0x4(%eax),%eax
  800957:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80095a:	bf 08 00 00 00       	mov    $0x8,%edi
  80095f:	eb 31                	jmp    800992 <vprintfmt+0x403>
			putch('0', putdat);
  800961:	83 ec 08             	sub    $0x8,%esp
  800964:	53                   	push   %ebx
  800965:	6a 30                	push   $0x30
  800967:	ff d6                	call   *%esi
			putch('x', putdat);
  800969:	83 c4 08             	add    $0x8,%esp
  80096c:	53                   	push   %ebx
  80096d:	6a 78                	push   $0x78
  80096f:	ff d6                	call   *%esi
			num = (unsigned long long)
  800971:	8b 45 14             	mov    0x14(%ebp),%eax
  800974:	8b 00                	mov    (%eax),%eax
  800976:	ba 00 00 00 00       	mov    $0x0,%edx
  80097b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80097e:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800981:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800984:	8b 45 14             	mov    0x14(%ebp),%eax
  800987:	8d 40 04             	lea    0x4(%eax),%eax
  80098a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80098d:	bf 10 00 00 00       	mov    $0x10,%edi
			if(posflag)
  800992:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800996:	74 0b                	je     8009a3 <vprintfmt+0x414>
				putch('+', putdat);
  800998:	83 ec 08             	sub    $0x8,%esp
  80099b:	53                   	push   %ebx
  80099c:	6a 2b                	push   $0x2b
  80099e:	ff d6                	call   *%esi
  8009a0:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  8009a3:	83 ec 0c             	sub    $0xc,%esp
  8009a6:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8009aa:	50                   	push   %eax
  8009ab:	ff 75 e0             	pushl  -0x20(%ebp)
  8009ae:	57                   	push   %edi
  8009af:	ff 75 dc             	pushl  -0x24(%ebp)
  8009b2:	ff 75 d8             	pushl  -0x28(%ebp)
  8009b5:	89 da                	mov    %ebx,%edx
  8009b7:	89 f0                	mov    %esi,%eax
  8009b9:	e8 b8 fa ff ff       	call   800476 <printnum>
			break;
  8009be:	83 c4 20             	add    $0x20,%esp
			char* cp = va_arg(ap, char *);
  8009c1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009c4:	83 c7 01             	add    $0x1,%edi
  8009c7:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8009cb:	83 f8 25             	cmp    $0x25,%eax
  8009ce:	0f 84 d2 fb ff ff    	je     8005a6 <vprintfmt+0x17>
			if (ch == '\0')
  8009d4:	85 c0                	test   %eax,%eax
  8009d6:	0f 84 03 01 00 00    	je     800adf <vprintfmt+0x550>
			putch(ch, putdat);
  8009dc:	83 ec 08             	sub    $0x8,%esp
  8009df:	53                   	push   %ebx
  8009e0:	50                   	push   %eax
  8009e1:	ff d6                	call   *%esi
  8009e3:	83 c4 10             	add    $0x10,%esp
  8009e6:	eb dc                	jmp    8009c4 <vprintfmt+0x435>
	if (lflag >= 2)
  8009e8:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8009ec:	7f 29                	jg     800a17 <vprintfmt+0x488>
	else if (lflag)
  8009ee:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8009f2:	74 44                	je     800a38 <vprintfmt+0x4a9>
		return va_arg(*ap, unsigned long);
  8009f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f7:	8b 00                	mov    (%eax),%eax
  8009f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8009fe:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a01:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a04:	8b 45 14             	mov    0x14(%ebp),%eax
  800a07:	8d 40 04             	lea    0x4(%eax),%eax
  800a0a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a0d:	bf 10 00 00 00       	mov    $0x10,%edi
  800a12:	e9 7b ff ff ff       	jmp    800992 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  800a17:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1a:	8b 50 04             	mov    0x4(%eax),%edx
  800a1d:	8b 00                	mov    (%eax),%eax
  800a1f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a22:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a25:	8b 45 14             	mov    0x14(%ebp),%eax
  800a28:	8d 40 08             	lea    0x8(%eax),%eax
  800a2b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a2e:	bf 10 00 00 00       	mov    $0x10,%edi
  800a33:	e9 5a ff ff ff       	jmp    800992 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  800a38:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3b:	8b 00                	mov    (%eax),%eax
  800a3d:	ba 00 00 00 00       	mov    $0x0,%edx
  800a42:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a45:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a48:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4b:	8d 40 04             	lea    0x4(%eax),%eax
  800a4e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a51:	bf 10 00 00 00       	mov    $0x10,%edi
  800a56:	e9 37 ff ff ff       	jmp    800992 <vprintfmt+0x403>
			char* cp = va_arg(ap, char *);
  800a5b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a5e:	8d 78 04             	lea    0x4(%eax),%edi
  800a61:	8b 00                	mov    (%eax),%eax
    			if (cp == NULL) {
  800a63:	85 c0                	test   %eax,%eax
  800a65:	74 2c                	je     800a93 <vprintfmt+0x504>
    			*cp = *(int *)putdat;
  800a67:	8b 13                	mov    (%ebx),%edx
  800a69:	88 10                	mov    %dl,(%eax)
			char* cp = va_arg(ap, char *);
  800a6b:	89 7d 14             	mov    %edi,0x14(%ebp)
    			if ((*(int *) putdat) > 127)
  800a6e:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  800a71:	0f 8e 4a ff ff ff    	jle    8009c1 <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", overflow_error);
  800a77:	68 ec 12 80 00       	push   $0x8012ec
  800a7c:	68 9e 11 80 00       	push   $0x80119e
  800a81:	53                   	push   %ebx
  800a82:	56                   	push   %esi
  800a83:	e8 ea fa ff ff       	call   800572 <printfmt>
  800a88:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  800a8b:	89 7d 14             	mov    %edi,0x14(%ebp)
  800a8e:	e9 2e ff ff ff       	jmp    8009c1 <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", null_error);
  800a93:	68 b4 12 80 00       	push   $0x8012b4
  800a98:	68 9e 11 80 00       	push   $0x80119e
  800a9d:	53                   	push   %ebx
  800a9e:	56                   	push   %esi
  800a9f:	e8 ce fa ff ff       	call   800572 <printfmt>
        		break;
  800aa4:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  800aa7:	89 7d 14             	mov    %edi,0x14(%ebp)
        		break;
  800aaa:	e9 12 ff ff ff       	jmp    8009c1 <vprintfmt+0x432>
			putch(ch, putdat);
  800aaf:	83 ec 08             	sub    $0x8,%esp
  800ab2:	53                   	push   %ebx
  800ab3:	6a 25                	push   $0x25
  800ab5:	ff d6                	call   *%esi
			break;
  800ab7:	83 c4 10             	add    $0x10,%esp
  800aba:	e9 02 ff ff ff       	jmp    8009c1 <vprintfmt+0x432>
			putch('%', putdat);
  800abf:	83 ec 08             	sub    $0x8,%esp
  800ac2:	53                   	push   %ebx
  800ac3:	6a 25                	push   $0x25
  800ac5:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ac7:	83 c4 10             	add    $0x10,%esp
  800aca:	89 f8                	mov    %edi,%eax
  800acc:	eb 03                	jmp    800ad1 <vprintfmt+0x542>
  800ace:	83 e8 01             	sub    $0x1,%eax
  800ad1:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800ad5:	75 f7                	jne    800ace <vprintfmt+0x53f>
  800ad7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ada:	e9 e2 fe ff ff       	jmp    8009c1 <vprintfmt+0x432>
}
  800adf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ae2:	5b                   	pop    %ebx
  800ae3:	5e                   	pop    %esi
  800ae4:	5f                   	pop    %edi
  800ae5:	5d                   	pop    %ebp
  800ae6:	c3                   	ret    

00800ae7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ae7:	55                   	push   %ebp
  800ae8:	89 e5                	mov    %esp,%ebp
  800aea:	83 ec 18             	sub    $0x18,%esp
  800aed:	8b 45 08             	mov    0x8(%ebp),%eax
  800af0:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800af3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800af6:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800afa:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800afd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b04:	85 c0                	test   %eax,%eax
  800b06:	74 26                	je     800b2e <vsnprintf+0x47>
  800b08:	85 d2                	test   %edx,%edx
  800b0a:	7e 22                	jle    800b2e <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b0c:	ff 75 14             	pushl  0x14(%ebp)
  800b0f:	ff 75 10             	pushl  0x10(%ebp)
  800b12:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b15:	50                   	push   %eax
  800b16:	68 55 05 80 00       	push   $0x800555
  800b1b:	e8 6f fa ff ff       	call   80058f <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800b20:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b23:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b29:	83 c4 10             	add    $0x10,%esp
}
  800b2c:	c9                   	leave  
  800b2d:	c3                   	ret    
		return -E_INVAL;
  800b2e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b33:	eb f7                	jmp    800b2c <vsnprintf+0x45>

00800b35 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b35:	55                   	push   %ebp
  800b36:	89 e5                	mov    %esp,%ebp
  800b38:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b3b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800b3e:	50                   	push   %eax
  800b3f:	ff 75 10             	pushl  0x10(%ebp)
  800b42:	ff 75 0c             	pushl  0xc(%ebp)
  800b45:	ff 75 08             	pushl  0x8(%ebp)
  800b48:	e8 9a ff ff ff       	call   800ae7 <vsnprintf>
	va_end(ap);

	return rc;
}
  800b4d:	c9                   	leave  
  800b4e:	c3                   	ret    

00800b4f <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800b4f:	55                   	push   %ebp
  800b50:	89 e5                	mov    %esp,%ebp
  800b52:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800b55:	b8 00 00 00 00       	mov    $0x0,%eax
  800b5a:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800b5e:	74 05                	je     800b65 <strlen+0x16>
		n++;
  800b60:	83 c0 01             	add    $0x1,%eax
  800b63:	eb f5                	jmp    800b5a <strlen+0xb>
	return n;
}
  800b65:	5d                   	pop    %ebp
  800b66:	c3                   	ret    

00800b67 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800b67:	55                   	push   %ebp
  800b68:	89 e5                	mov    %esp,%ebp
  800b6a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b6d:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b70:	ba 00 00 00 00       	mov    $0x0,%edx
  800b75:	39 c2                	cmp    %eax,%edx
  800b77:	74 0d                	je     800b86 <strnlen+0x1f>
  800b79:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800b7d:	74 05                	je     800b84 <strnlen+0x1d>
		n++;
  800b7f:	83 c2 01             	add    $0x1,%edx
  800b82:	eb f1                	jmp    800b75 <strnlen+0xe>
  800b84:	89 d0                	mov    %edx,%eax
	return n;
}
  800b86:	5d                   	pop    %ebp
  800b87:	c3                   	ret    

00800b88 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b88:	55                   	push   %ebp
  800b89:	89 e5                	mov    %esp,%ebp
  800b8b:	53                   	push   %ebx
  800b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800b92:	ba 00 00 00 00       	mov    $0x0,%edx
  800b97:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800b9b:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800b9e:	83 c2 01             	add    $0x1,%edx
  800ba1:	84 c9                	test   %cl,%cl
  800ba3:	75 f2                	jne    800b97 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800ba5:	5b                   	pop    %ebx
  800ba6:	5d                   	pop    %ebp
  800ba7:	c3                   	ret    

00800ba8 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800ba8:	55                   	push   %ebp
  800ba9:	89 e5                	mov    %esp,%ebp
  800bab:	53                   	push   %ebx
  800bac:	83 ec 10             	sub    $0x10,%esp
  800baf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800bb2:	53                   	push   %ebx
  800bb3:	e8 97 ff ff ff       	call   800b4f <strlen>
  800bb8:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800bbb:	ff 75 0c             	pushl  0xc(%ebp)
  800bbe:	01 d8                	add    %ebx,%eax
  800bc0:	50                   	push   %eax
  800bc1:	e8 c2 ff ff ff       	call   800b88 <strcpy>
	return dst;
}
  800bc6:	89 d8                	mov    %ebx,%eax
  800bc8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800bcb:	c9                   	leave  
  800bcc:	c3                   	ret    

00800bcd <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800bcd:	55                   	push   %ebp
  800bce:	89 e5                	mov    %esp,%ebp
  800bd0:	56                   	push   %esi
  800bd1:	53                   	push   %ebx
  800bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bd8:	89 c6                	mov    %eax,%esi
  800bda:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800bdd:	89 c2                	mov    %eax,%edx
  800bdf:	39 f2                	cmp    %esi,%edx
  800be1:	74 11                	je     800bf4 <strncpy+0x27>
		*dst++ = *src;
  800be3:	83 c2 01             	add    $0x1,%edx
  800be6:	0f b6 19             	movzbl (%ecx),%ebx
  800be9:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800bec:	80 fb 01             	cmp    $0x1,%bl
  800bef:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800bf2:	eb eb                	jmp    800bdf <strncpy+0x12>
	}
	return ret;
}
  800bf4:	5b                   	pop    %ebx
  800bf5:	5e                   	pop    %esi
  800bf6:	5d                   	pop    %ebp
  800bf7:	c3                   	ret    

00800bf8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800bf8:	55                   	push   %ebp
  800bf9:	89 e5                	mov    %esp,%ebp
  800bfb:	56                   	push   %esi
  800bfc:	53                   	push   %ebx
  800bfd:	8b 75 08             	mov    0x8(%ebp),%esi
  800c00:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c03:	8b 55 10             	mov    0x10(%ebp),%edx
  800c06:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800c08:	85 d2                	test   %edx,%edx
  800c0a:	74 21                	je     800c2d <strlcpy+0x35>
  800c0c:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800c10:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800c12:	39 c2                	cmp    %eax,%edx
  800c14:	74 14                	je     800c2a <strlcpy+0x32>
  800c16:	0f b6 19             	movzbl (%ecx),%ebx
  800c19:	84 db                	test   %bl,%bl
  800c1b:	74 0b                	je     800c28 <strlcpy+0x30>
			*dst++ = *src++;
  800c1d:	83 c1 01             	add    $0x1,%ecx
  800c20:	83 c2 01             	add    $0x1,%edx
  800c23:	88 5a ff             	mov    %bl,-0x1(%edx)
  800c26:	eb ea                	jmp    800c12 <strlcpy+0x1a>
  800c28:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800c2a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c2d:	29 f0                	sub    %esi,%eax
}
  800c2f:	5b                   	pop    %ebx
  800c30:	5e                   	pop    %esi
  800c31:	5d                   	pop    %ebp
  800c32:	c3                   	ret    

00800c33 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c33:	55                   	push   %ebp
  800c34:	89 e5                	mov    %esp,%ebp
  800c36:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c39:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800c3c:	0f b6 01             	movzbl (%ecx),%eax
  800c3f:	84 c0                	test   %al,%al
  800c41:	74 0c                	je     800c4f <strcmp+0x1c>
  800c43:	3a 02                	cmp    (%edx),%al
  800c45:	75 08                	jne    800c4f <strcmp+0x1c>
		p++, q++;
  800c47:	83 c1 01             	add    $0x1,%ecx
  800c4a:	83 c2 01             	add    $0x1,%edx
  800c4d:	eb ed                	jmp    800c3c <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c4f:	0f b6 c0             	movzbl %al,%eax
  800c52:	0f b6 12             	movzbl (%edx),%edx
  800c55:	29 d0                	sub    %edx,%eax
}
  800c57:	5d                   	pop    %ebp
  800c58:	c3                   	ret    

00800c59 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800c59:	55                   	push   %ebp
  800c5a:	89 e5                	mov    %esp,%ebp
  800c5c:	53                   	push   %ebx
  800c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c60:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c63:	89 c3                	mov    %eax,%ebx
  800c65:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800c68:	eb 06                	jmp    800c70 <strncmp+0x17>
		n--, p++, q++;
  800c6a:	83 c0 01             	add    $0x1,%eax
  800c6d:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800c70:	39 d8                	cmp    %ebx,%eax
  800c72:	74 16                	je     800c8a <strncmp+0x31>
  800c74:	0f b6 08             	movzbl (%eax),%ecx
  800c77:	84 c9                	test   %cl,%cl
  800c79:	74 04                	je     800c7f <strncmp+0x26>
  800c7b:	3a 0a                	cmp    (%edx),%cl
  800c7d:	74 eb                	je     800c6a <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c7f:	0f b6 00             	movzbl (%eax),%eax
  800c82:	0f b6 12             	movzbl (%edx),%edx
  800c85:	29 d0                	sub    %edx,%eax
}
  800c87:	5b                   	pop    %ebx
  800c88:	5d                   	pop    %ebp
  800c89:	c3                   	ret    
		return 0;
  800c8a:	b8 00 00 00 00       	mov    $0x0,%eax
  800c8f:	eb f6                	jmp    800c87 <strncmp+0x2e>

00800c91 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c91:	55                   	push   %ebp
  800c92:	89 e5                	mov    %esp,%ebp
  800c94:	8b 45 08             	mov    0x8(%ebp),%eax
  800c97:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c9b:	0f b6 10             	movzbl (%eax),%edx
  800c9e:	84 d2                	test   %dl,%dl
  800ca0:	74 09                	je     800cab <strchr+0x1a>
		if (*s == c)
  800ca2:	38 ca                	cmp    %cl,%dl
  800ca4:	74 0a                	je     800cb0 <strchr+0x1f>
	for (; *s; s++)
  800ca6:	83 c0 01             	add    $0x1,%eax
  800ca9:	eb f0                	jmp    800c9b <strchr+0xa>
			return (char *) s;
	return 0;
  800cab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cb0:	5d                   	pop    %ebp
  800cb1:	c3                   	ret    

00800cb2 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cb2:	55                   	push   %ebp
  800cb3:	89 e5                	mov    %esp,%ebp
  800cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb8:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800cbc:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800cbf:	38 ca                	cmp    %cl,%dl
  800cc1:	74 09                	je     800ccc <strfind+0x1a>
  800cc3:	84 d2                	test   %dl,%dl
  800cc5:	74 05                	je     800ccc <strfind+0x1a>
	for (; *s; s++)
  800cc7:	83 c0 01             	add    $0x1,%eax
  800cca:	eb f0                	jmp    800cbc <strfind+0xa>
			break;
	return (char *) s;
}
  800ccc:	5d                   	pop    %ebp
  800ccd:	c3                   	ret    

00800cce <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800cce:	55                   	push   %ebp
  800ccf:	89 e5                	mov    %esp,%ebp
  800cd1:	57                   	push   %edi
  800cd2:	56                   	push   %esi
  800cd3:	53                   	push   %ebx
  800cd4:	8b 7d 08             	mov    0x8(%ebp),%edi
  800cd7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800cda:	85 c9                	test   %ecx,%ecx
  800cdc:	74 31                	je     800d0f <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800cde:	89 f8                	mov    %edi,%eax
  800ce0:	09 c8                	or     %ecx,%eax
  800ce2:	a8 03                	test   $0x3,%al
  800ce4:	75 23                	jne    800d09 <memset+0x3b>
		c &= 0xFF;
  800ce6:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800cea:	89 d3                	mov    %edx,%ebx
  800cec:	c1 e3 08             	shl    $0x8,%ebx
  800cef:	89 d0                	mov    %edx,%eax
  800cf1:	c1 e0 18             	shl    $0x18,%eax
  800cf4:	89 d6                	mov    %edx,%esi
  800cf6:	c1 e6 10             	shl    $0x10,%esi
  800cf9:	09 f0                	or     %esi,%eax
  800cfb:	09 c2                	or     %eax,%edx
  800cfd:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800cff:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800d02:	89 d0                	mov    %edx,%eax
  800d04:	fc                   	cld    
  800d05:	f3 ab                	rep stos %eax,%es:(%edi)
  800d07:	eb 06                	jmp    800d0f <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0c:	fc                   	cld    
  800d0d:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800d0f:	89 f8                	mov    %edi,%eax
  800d11:	5b                   	pop    %ebx
  800d12:	5e                   	pop    %esi
  800d13:	5f                   	pop    %edi
  800d14:	5d                   	pop    %ebp
  800d15:	c3                   	ret    

00800d16 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800d16:	55                   	push   %ebp
  800d17:	89 e5                	mov    %esp,%ebp
  800d19:	57                   	push   %edi
  800d1a:	56                   	push   %esi
  800d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d21:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d24:	39 c6                	cmp    %eax,%esi
  800d26:	73 32                	jae    800d5a <memmove+0x44>
  800d28:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800d2b:	39 c2                	cmp    %eax,%edx
  800d2d:	76 2b                	jbe    800d5a <memmove+0x44>
		s += n;
		d += n;
  800d2f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d32:	89 fe                	mov    %edi,%esi
  800d34:	09 ce                	or     %ecx,%esi
  800d36:	09 d6                	or     %edx,%esi
  800d38:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800d3e:	75 0e                	jne    800d4e <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800d40:	83 ef 04             	sub    $0x4,%edi
  800d43:	8d 72 fc             	lea    -0x4(%edx),%esi
  800d46:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800d49:	fd                   	std    
  800d4a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d4c:	eb 09                	jmp    800d57 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800d4e:	83 ef 01             	sub    $0x1,%edi
  800d51:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800d54:	fd                   	std    
  800d55:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800d57:	fc                   	cld    
  800d58:	eb 1a                	jmp    800d74 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d5a:	89 c2                	mov    %eax,%edx
  800d5c:	09 ca                	or     %ecx,%edx
  800d5e:	09 f2                	or     %esi,%edx
  800d60:	f6 c2 03             	test   $0x3,%dl
  800d63:	75 0a                	jne    800d6f <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800d65:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800d68:	89 c7                	mov    %eax,%edi
  800d6a:	fc                   	cld    
  800d6b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d6d:	eb 05                	jmp    800d74 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800d6f:	89 c7                	mov    %eax,%edi
  800d71:	fc                   	cld    
  800d72:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800d74:	5e                   	pop    %esi
  800d75:	5f                   	pop    %edi
  800d76:	5d                   	pop    %ebp
  800d77:	c3                   	ret    

00800d78 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800d78:	55                   	push   %ebp
  800d79:	89 e5                	mov    %esp,%ebp
  800d7b:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800d7e:	ff 75 10             	pushl  0x10(%ebp)
  800d81:	ff 75 0c             	pushl  0xc(%ebp)
  800d84:	ff 75 08             	pushl  0x8(%ebp)
  800d87:	e8 8a ff ff ff       	call   800d16 <memmove>
}
  800d8c:	c9                   	leave  
  800d8d:	c3                   	ret    

00800d8e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800d8e:	55                   	push   %ebp
  800d8f:	89 e5                	mov    %esp,%ebp
  800d91:	56                   	push   %esi
  800d92:	53                   	push   %ebx
  800d93:	8b 45 08             	mov    0x8(%ebp),%eax
  800d96:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d99:	89 c6                	mov    %eax,%esi
  800d9b:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d9e:	39 f0                	cmp    %esi,%eax
  800da0:	74 1c                	je     800dbe <memcmp+0x30>
		if (*s1 != *s2)
  800da2:	0f b6 08             	movzbl (%eax),%ecx
  800da5:	0f b6 1a             	movzbl (%edx),%ebx
  800da8:	38 d9                	cmp    %bl,%cl
  800daa:	75 08                	jne    800db4 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800dac:	83 c0 01             	add    $0x1,%eax
  800daf:	83 c2 01             	add    $0x1,%edx
  800db2:	eb ea                	jmp    800d9e <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800db4:	0f b6 c1             	movzbl %cl,%eax
  800db7:	0f b6 db             	movzbl %bl,%ebx
  800dba:	29 d8                	sub    %ebx,%eax
  800dbc:	eb 05                	jmp    800dc3 <memcmp+0x35>
	}

	return 0;
  800dbe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dc3:	5b                   	pop    %ebx
  800dc4:	5e                   	pop    %esi
  800dc5:	5d                   	pop    %ebp
  800dc6:	c3                   	ret    

00800dc7 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800dc7:	55                   	push   %ebp
  800dc8:	89 e5                	mov    %esp,%ebp
  800dca:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800dd0:	89 c2                	mov    %eax,%edx
  800dd2:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800dd5:	39 d0                	cmp    %edx,%eax
  800dd7:	73 09                	jae    800de2 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800dd9:	38 08                	cmp    %cl,(%eax)
  800ddb:	74 05                	je     800de2 <memfind+0x1b>
	for (; s < ends; s++)
  800ddd:	83 c0 01             	add    $0x1,%eax
  800de0:	eb f3                	jmp    800dd5 <memfind+0xe>
			break;
	return (void *) s;
}
  800de2:	5d                   	pop    %ebp
  800de3:	c3                   	ret    

00800de4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800de4:	55                   	push   %ebp
  800de5:	89 e5                	mov    %esp,%ebp
  800de7:	57                   	push   %edi
  800de8:	56                   	push   %esi
  800de9:	53                   	push   %ebx
  800dea:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ded:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800df0:	eb 03                	jmp    800df5 <strtol+0x11>
		s++;
  800df2:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800df5:	0f b6 01             	movzbl (%ecx),%eax
  800df8:	3c 20                	cmp    $0x20,%al
  800dfa:	74 f6                	je     800df2 <strtol+0xe>
  800dfc:	3c 09                	cmp    $0x9,%al
  800dfe:	74 f2                	je     800df2 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800e00:	3c 2b                	cmp    $0x2b,%al
  800e02:	74 2a                	je     800e2e <strtol+0x4a>
	int neg = 0;
  800e04:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800e09:	3c 2d                	cmp    $0x2d,%al
  800e0b:	74 2b                	je     800e38 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e0d:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800e13:	75 0f                	jne    800e24 <strtol+0x40>
  800e15:	80 39 30             	cmpb   $0x30,(%ecx)
  800e18:	74 28                	je     800e42 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800e1a:	85 db                	test   %ebx,%ebx
  800e1c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e21:	0f 44 d8             	cmove  %eax,%ebx
  800e24:	b8 00 00 00 00       	mov    $0x0,%eax
  800e29:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800e2c:	eb 50                	jmp    800e7e <strtol+0x9a>
		s++;
  800e2e:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800e31:	bf 00 00 00 00       	mov    $0x0,%edi
  800e36:	eb d5                	jmp    800e0d <strtol+0x29>
		s++, neg = 1;
  800e38:	83 c1 01             	add    $0x1,%ecx
  800e3b:	bf 01 00 00 00       	mov    $0x1,%edi
  800e40:	eb cb                	jmp    800e0d <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e42:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800e46:	74 0e                	je     800e56 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800e48:	85 db                	test   %ebx,%ebx
  800e4a:	75 d8                	jne    800e24 <strtol+0x40>
		s++, base = 8;
  800e4c:	83 c1 01             	add    $0x1,%ecx
  800e4f:	bb 08 00 00 00       	mov    $0x8,%ebx
  800e54:	eb ce                	jmp    800e24 <strtol+0x40>
		s += 2, base = 16;
  800e56:	83 c1 02             	add    $0x2,%ecx
  800e59:	bb 10 00 00 00       	mov    $0x10,%ebx
  800e5e:	eb c4                	jmp    800e24 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800e60:	8d 72 9f             	lea    -0x61(%edx),%esi
  800e63:	89 f3                	mov    %esi,%ebx
  800e65:	80 fb 19             	cmp    $0x19,%bl
  800e68:	77 29                	ja     800e93 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800e6a:	0f be d2             	movsbl %dl,%edx
  800e6d:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800e70:	3b 55 10             	cmp    0x10(%ebp),%edx
  800e73:	7d 30                	jge    800ea5 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800e75:	83 c1 01             	add    $0x1,%ecx
  800e78:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e7c:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800e7e:	0f b6 11             	movzbl (%ecx),%edx
  800e81:	8d 72 d0             	lea    -0x30(%edx),%esi
  800e84:	89 f3                	mov    %esi,%ebx
  800e86:	80 fb 09             	cmp    $0x9,%bl
  800e89:	77 d5                	ja     800e60 <strtol+0x7c>
			dig = *s - '0';
  800e8b:	0f be d2             	movsbl %dl,%edx
  800e8e:	83 ea 30             	sub    $0x30,%edx
  800e91:	eb dd                	jmp    800e70 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800e93:	8d 72 bf             	lea    -0x41(%edx),%esi
  800e96:	89 f3                	mov    %esi,%ebx
  800e98:	80 fb 19             	cmp    $0x19,%bl
  800e9b:	77 08                	ja     800ea5 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800e9d:	0f be d2             	movsbl %dl,%edx
  800ea0:	83 ea 37             	sub    $0x37,%edx
  800ea3:	eb cb                	jmp    800e70 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800ea5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ea9:	74 05                	je     800eb0 <strtol+0xcc>
		*endptr = (char *) s;
  800eab:	8b 75 0c             	mov    0xc(%ebp),%esi
  800eae:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800eb0:	89 c2                	mov    %eax,%edx
  800eb2:	f7 da                	neg    %edx
  800eb4:	85 ff                	test   %edi,%edi
  800eb6:	0f 45 c2             	cmovne %edx,%eax
}
  800eb9:	5b                   	pop    %ebx
  800eba:	5e                   	pop    %esi
  800ebb:	5f                   	pop    %edi
  800ebc:	5d                   	pop    %ebp
  800ebd:	c3                   	ret    
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
