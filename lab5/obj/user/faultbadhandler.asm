
obj/user/faultbadhandler.debug:     file format elf32-i386


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
  80002c:	e8 34 00 00 00       	call   800065 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 0c             	sub    $0xc,%esp
	sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W);
  800039:	6a 07                	push   $0x7
  80003b:	68 00 f0 bf ee       	push   $0xeebff000
  800040:	6a 00                	push   $0x0
  800042:	e8 35 01 00 00       	call   80017c <sys_page_alloc>
	sys_env_set_pgfault_upcall(0, (void*) 0xDeadBeef);
  800047:	83 c4 08             	add    $0x8,%esp
  80004a:	68 ef be ad de       	push   $0xdeadbeef
  80004f:	6a 00                	push   $0x0
  800051:	e8 71 02 00 00       	call   8002c7 <sys_env_set_pgfault_upcall>
	*(int*)0 = 0;
  800056:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80005d:	00 00 00 
}
  800060:	83 c4 10             	add    $0x10,%esp
  800063:	c9                   	leave  
  800064:	c3                   	ret    

00800065 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800065:	55                   	push   %ebp
  800066:	89 e5                	mov    %esp,%ebp
  800068:	56                   	push   %esi
  800069:	53                   	push   %ebx
  80006a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80006d:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	// thisenv = 0;
	thisenv = &(envs[ENVX(sys_getenvid())]);
  800070:	e8 c9 00 00 00       	call   80013e <sys_getenvid>
  800075:	25 ff 03 00 00       	and    $0x3ff,%eax
  80007a:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  800080:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800085:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80008a:	85 db                	test   %ebx,%ebx
  80008c:	7e 07                	jle    800095 <libmain+0x30>
		binaryname = argv[0];
  80008e:	8b 06                	mov    (%esi),%eax
  800090:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800095:	83 ec 08             	sub    $0x8,%esp
  800098:	56                   	push   %esi
  800099:	53                   	push   %ebx
  80009a:	e8 94 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80009f:	e8 0a 00 00 00       	call   8000ae <exit>
}
  8000a4:	83 c4 10             	add    $0x10,%esp
  8000a7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000aa:	5b                   	pop    %ebx
  8000ab:	5e                   	pop    %esi
  8000ac:	5d                   	pop    %ebp
  8000ad:	c3                   	ret    

008000ae <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000ae:	55                   	push   %ebp
  8000af:	89 e5                	mov    %esp,%ebp
  8000b1:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  8000b4:	6a 00                	push   $0x0
  8000b6:	e8 42 00 00 00       	call   8000fd <sys_env_destroy>
}
  8000bb:	83 c4 10             	add    $0x10,%esp
  8000be:	c9                   	leave  
  8000bf:	c3                   	ret    

008000c0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000c0:	55                   	push   %ebp
  8000c1:	89 e5                	mov    %esp,%ebp
  8000c3:	57                   	push   %edi
  8000c4:	56                   	push   %esi
  8000c5:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8000cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8000ce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000d1:	89 c3                	mov    %eax,%ebx
  8000d3:	89 c7                	mov    %eax,%edi
  8000d5:	89 c6                	mov    %eax,%esi
  8000d7:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000d9:	5b                   	pop    %ebx
  8000da:	5e                   	pop    %esi
  8000db:	5f                   	pop    %edi
  8000dc:	5d                   	pop    %ebp
  8000dd:	c3                   	ret    

008000de <sys_cgetc>:

int
sys_cgetc(void)
{
  8000de:	55                   	push   %ebp
  8000df:	89 e5                	mov    %esp,%ebp
  8000e1:	57                   	push   %edi
  8000e2:	56                   	push   %esi
  8000e3:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8000e9:	b8 01 00 00 00       	mov    $0x1,%eax
  8000ee:	89 d1                	mov    %edx,%ecx
  8000f0:	89 d3                	mov    %edx,%ebx
  8000f2:	89 d7                	mov    %edx,%edi
  8000f4:	89 d6                	mov    %edx,%esi
  8000f6:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000f8:	5b                   	pop    %ebx
  8000f9:	5e                   	pop    %esi
  8000fa:	5f                   	pop    %edi
  8000fb:	5d                   	pop    %ebp
  8000fc:	c3                   	ret    

008000fd <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000fd:	55                   	push   %ebp
  8000fe:	89 e5                	mov    %esp,%ebp
  800100:	57                   	push   %edi
  800101:	56                   	push   %esi
  800102:	53                   	push   %ebx
  800103:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800106:	b9 00 00 00 00       	mov    $0x0,%ecx
  80010b:	8b 55 08             	mov    0x8(%ebp),%edx
  80010e:	b8 03 00 00 00       	mov    $0x3,%eax
  800113:	89 cb                	mov    %ecx,%ebx
  800115:	89 cf                	mov    %ecx,%edi
  800117:	89 ce                	mov    %ecx,%esi
  800119:	cd 30                	int    $0x30
	if (check && ret > 0)
  80011b:	85 c0                	test   %eax,%eax
  80011d:	7f 08                	jg     800127 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80011f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800122:	5b                   	pop    %ebx
  800123:	5e                   	pop    %esi
  800124:	5f                   	pop    %edi
  800125:	5d                   	pop    %ebp
  800126:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800127:	83 ec 0c             	sub    $0xc,%esp
  80012a:	50                   	push   %eax
  80012b:	6a 03                	push   $0x3
  80012d:	68 4a 11 80 00       	push   $0x80114a
  800132:	6a 4c                	push   $0x4c
  800134:	68 67 11 80 00       	push   $0x801167
  800139:	e8 70 02 00 00       	call   8003ae <_panic>

0080013e <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80013e:	55                   	push   %ebp
  80013f:	89 e5                	mov    %esp,%ebp
  800141:	57                   	push   %edi
  800142:	56                   	push   %esi
  800143:	53                   	push   %ebx
	asm volatile("int %1\n"
  800144:	ba 00 00 00 00       	mov    $0x0,%edx
  800149:	b8 02 00 00 00       	mov    $0x2,%eax
  80014e:	89 d1                	mov    %edx,%ecx
  800150:	89 d3                	mov    %edx,%ebx
  800152:	89 d7                	mov    %edx,%edi
  800154:	89 d6                	mov    %edx,%esi
  800156:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800158:	5b                   	pop    %ebx
  800159:	5e                   	pop    %esi
  80015a:	5f                   	pop    %edi
  80015b:	5d                   	pop    %ebp
  80015c:	c3                   	ret    

0080015d <sys_yield>:

void
sys_yield(void)
{
  80015d:	55                   	push   %ebp
  80015e:	89 e5                	mov    %esp,%ebp
  800160:	57                   	push   %edi
  800161:	56                   	push   %esi
  800162:	53                   	push   %ebx
	asm volatile("int %1\n"
  800163:	ba 00 00 00 00       	mov    $0x0,%edx
  800168:	b8 0b 00 00 00       	mov    $0xb,%eax
  80016d:	89 d1                	mov    %edx,%ecx
  80016f:	89 d3                	mov    %edx,%ebx
  800171:	89 d7                	mov    %edx,%edi
  800173:	89 d6                	mov    %edx,%esi
  800175:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800177:	5b                   	pop    %ebx
  800178:	5e                   	pop    %esi
  800179:	5f                   	pop    %edi
  80017a:	5d                   	pop    %ebp
  80017b:	c3                   	ret    

0080017c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80017c:	55                   	push   %ebp
  80017d:	89 e5                	mov    %esp,%ebp
  80017f:	57                   	push   %edi
  800180:	56                   	push   %esi
  800181:	53                   	push   %ebx
  800182:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800185:	be 00 00 00 00       	mov    $0x0,%esi
  80018a:	8b 55 08             	mov    0x8(%ebp),%edx
  80018d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800190:	b8 04 00 00 00       	mov    $0x4,%eax
  800195:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800198:	89 f7                	mov    %esi,%edi
  80019a:	cd 30                	int    $0x30
	if (check && ret > 0)
  80019c:	85 c0                	test   %eax,%eax
  80019e:	7f 08                	jg     8001a8 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8001a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001a3:	5b                   	pop    %ebx
  8001a4:	5e                   	pop    %esi
  8001a5:	5f                   	pop    %edi
  8001a6:	5d                   	pop    %ebp
  8001a7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001a8:	83 ec 0c             	sub    $0xc,%esp
  8001ab:	50                   	push   %eax
  8001ac:	6a 04                	push   $0x4
  8001ae:	68 4a 11 80 00       	push   $0x80114a
  8001b3:	6a 4c                	push   $0x4c
  8001b5:	68 67 11 80 00       	push   $0x801167
  8001ba:	e8 ef 01 00 00       	call   8003ae <_panic>

008001bf <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001bf:	55                   	push   %ebp
  8001c0:	89 e5                	mov    %esp,%ebp
  8001c2:	57                   	push   %edi
  8001c3:	56                   	push   %esi
  8001c4:	53                   	push   %ebx
  8001c5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8001cb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001ce:	b8 05 00 00 00       	mov    $0x5,%eax
  8001d3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001d6:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001d9:	8b 75 18             	mov    0x18(%ebp),%esi
  8001dc:	cd 30                	int    $0x30
	if (check && ret > 0)
  8001de:	85 c0                	test   %eax,%eax
  8001e0:	7f 08                	jg     8001ea <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001e5:	5b                   	pop    %ebx
  8001e6:	5e                   	pop    %esi
  8001e7:	5f                   	pop    %edi
  8001e8:	5d                   	pop    %ebp
  8001e9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001ea:	83 ec 0c             	sub    $0xc,%esp
  8001ed:	50                   	push   %eax
  8001ee:	6a 05                	push   $0x5
  8001f0:	68 4a 11 80 00       	push   $0x80114a
  8001f5:	6a 4c                	push   $0x4c
  8001f7:	68 67 11 80 00       	push   $0x801167
  8001fc:	e8 ad 01 00 00       	call   8003ae <_panic>

00800201 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800201:	55                   	push   %ebp
  800202:	89 e5                	mov    %esp,%ebp
  800204:	57                   	push   %edi
  800205:	56                   	push   %esi
  800206:	53                   	push   %ebx
  800207:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80020a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80020f:	8b 55 08             	mov    0x8(%ebp),%edx
  800212:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800215:	b8 06 00 00 00       	mov    $0x6,%eax
  80021a:	89 df                	mov    %ebx,%edi
  80021c:	89 de                	mov    %ebx,%esi
  80021e:	cd 30                	int    $0x30
	if (check && ret > 0)
  800220:	85 c0                	test   %eax,%eax
  800222:	7f 08                	jg     80022c <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800224:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800227:	5b                   	pop    %ebx
  800228:	5e                   	pop    %esi
  800229:	5f                   	pop    %edi
  80022a:	5d                   	pop    %ebp
  80022b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80022c:	83 ec 0c             	sub    $0xc,%esp
  80022f:	50                   	push   %eax
  800230:	6a 06                	push   $0x6
  800232:	68 4a 11 80 00       	push   $0x80114a
  800237:	6a 4c                	push   $0x4c
  800239:	68 67 11 80 00       	push   $0x801167
  80023e:	e8 6b 01 00 00       	call   8003ae <_panic>

00800243 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800243:	55                   	push   %ebp
  800244:	89 e5                	mov    %esp,%ebp
  800246:	57                   	push   %edi
  800247:	56                   	push   %esi
  800248:	53                   	push   %ebx
  800249:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80024c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800251:	8b 55 08             	mov    0x8(%ebp),%edx
  800254:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800257:	b8 08 00 00 00       	mov    $0x8,%eax
  80025c:	89 df                	mov    %ebx,%edi
  80025e:	89 de                	mov    %ebx,%esi
  800260:	cd 30                	int    $0x30
	if (check && ret > 0)
  800262:	85 c0                	test   %eax,%eax
  800264:	7f 08                	jg     80026e <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800266:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800269:	5b                   	pop    %ebx
  80026a:	5e                   	pop    %esi
  80026b:	5f                   	pop    %edi
  80026c:	5d                   	pop    %ebp
  80026d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80026e:	83 ec 0c             	sub    $0xc,%esp
  800271:	50                   	push   %eax
  800272:	6a 08                	push   $0x8
  800274:	68 4a 11 80 00       	push   $0x80114a
  800279:	6a 4c                	push   $0x4c
  80027b:	68 67 11 80 00       	push   $0x801167
  800280:	e8 29 01 00 00       	call   8003ae <_panic>

00800285 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800285:	55                   	push   %ebp
  800286:	89 e5                	mov    %esp,%ebp
  800288:	57                   	push   %edi
  800289:	56                   	push   %esi
  80028a:	53                   	push   %ebx
  80028b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80028e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800293:	8b 55 08             	mov    0x8(%ebp),%edx
  800296:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800299:	b8 09 00 00 00       	mov    $0x9,%eax
  80029e:	89 df                	mov    %ebx,%edi
  8002a0:	89 de                	mov    %ebx,%esi
  8002a2:	cd 30                	int    $0x30
	if (check && ret > 0)
  8002a4:	85 c0                	test   %eax,%eax
  8002a6:	7f 08                	jg     8002b0 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8002a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002ab:	5b                   	pop    %ebx
  8002ac:	5e                   	pop    %esi
  8002ad:	5f                   	pop    %edi
  8002ae:	5d                   	pop    %ebp
  8002af:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002b0:	83 ec 0c             	sub    $0xc,%esp
  8002b3:	50                   	push   %eax
  8002b4:	6a 09                	push   $0x9
  8002b6:	68 4a 11 80 00       	push   $0x80114a
  8002bb:	6a 4c                	push   $0x4c
  8002bd:	68 67 11 80 00       	push   $0x801167
  8002c2:	e8 e7 00 00 00       	call   8003ae <_panic>

008002c7 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002c7:	55                   	push   %ebp
  8002c8:	89 e5                	mov    %esp,%ebp
  8002ca:	57                   	push   %edi
  8002cb:	56                   	push   %esi
  8002cc:	53                   	push   %ebx
  8002cd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002d0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8002d8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002db:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002e0:	89 df                	mov    %ebx,%edi
  8002e2:	89 de                	mov    %ebx,%esi
  8002e4:	cd 30                	int    $0x30
	if (check && ret > 0)
  8002e6:	85 c0                	test   %eax,%eax
  8002e8:	7f 08                	jg     8002f2 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002ed:	5b                   	pop    %ebx
  8002ee:	5e                   	pop    %esi
  8002ef:	5f                   	pop    %edi
  8002f0:	5d                   	pop    %ebp
  8002f1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002f2:	83 ec 0c             	sub    $0xc,%esp
  8002f5:	50                   	push   %eax
  8002f6:	6a 0a                	push   $0xa
  8002f8:	68 4a 11 80 00       	push   $0x80114a
  8002fd:	6a 4c                	push   $0x4c
  8002ff:	68 67 11 80 00       	push   $0x801167
  800304:	e8 a5 00 00 00       	call   8003ae <_panic>

00800309 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800309:	55                   	push   %ebp
  80030a:	89 e5                	mov    %esp,%ebp
  80030c:	57                   	push   %edi
  80030d:	56                   	push   %esi
  80030e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80030f:	8b 55 08             	mov    0x8(%ebp),%edx
  800312:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800315:	b8 0c 00 00 00       	mov    $0xc,%eax
  80031a:	be 00 00 00 00       	mov    $0x0,%esi
  80031f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800322:	8b 7d 14             	mov    0x14(%ebp),%edi
  800325:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800327:	5b                   	pop    %ebx
  800328:	5e                   	pop    %esi
  800329:	5f                   	pop    %edi
  80032a:	5d                   	pop    %ebp
  80032b:	c3                   	ret    

0080032c <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80032c:	55                   	push   %ebp
  80032d:	89 e5                	mov    %esp,%ebp
  80032f:	57                   	push   %edi
  800330:	56                   	push   %esi
  800331:	53                   	push   %ebx
  800332:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800335:	b9 00 00 00 00       	mov    $0x0,%ecx
  80033a:	8b 55 08             	mov    0x8(%ebp),%edx
  80033d:	b8 0d 00 00 00       	mov    $0xd,%eax
  800342:	89 cb                	mov    %ecx,%ebx
  800344:	89 cf                	mov    %ecx,%edi
  800346:	89 ce                	mov    %ecx,%esi
  800348:	cd 30                	int    $0x30
	if (check && ret > 0)
  80034a:	85 c0                	test   %eax,%eax
  80034c:	7f 08                	jg     800356 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80034e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800351:	5b                   	pop    %ebx
  800352:	5e                   	pop    %esi
  800353:	5f                   	pop    %edi
  800354:	5d                   	pop    %ebp
  800355:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800356:	83 ec 0c             	sub    $0xc,%esp
  800359:	50                   	push   %eax
  80035a:	6a 0d                	push   $0xd
  80035c:	68 4a 11 80 00       	push   $0x80114a
  800361:	6a 4c                	push   $0x4c
  800363:	68 67 11 80 00       	push   $0x801167
  800368:	e8 41 00 00 00       	call   8003ae <_panic>

0080036d <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  80036d:	55                   	push   %ebp
  80036e:	89 e5                	mov    %esp,%ebp
  800370:	57                   	push   %edi
  800371:	56                   	push   %esi
  800372:	53                   	push   %ebx
	asm volatile("int %1\n"
  800373:	bb 00 00 00 00       	mov    $0x0,%ebx
  800378:	8b 55 08             	mov    0x8(%ebp),%edx
  80037b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80037e:	b8 0e 00 00 00       	mov    $0xe,%eax
  800383:	89 df                	mov    %ebx,%edi
  800385:	89 de                	mov    %ebx,%esi
  800387:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800389:	5b                   	pop    %ebx
  80038a:	5e                   	pop    %esi
  80038b:	5f                   	pop    %edi
  80038c:	5d                   	pop    %ebp
  80038d:	c3                   	ret    

0080038e <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  80038e:	55                   	push   %ebp
  80038f:	89 e5                	mov    %esp,%ebp
  800391:	57                   	push   %edi
  800392:	56                   	push   %esi
  800393:	53                   	push   %ebx
	asm volatile("int %1\n"
  800394:	b9 00 00 00 00       	mov    $0x0,%ecx
  800399:	8b 55 08             	mov    0x8(%ebp),%edx
  80039c:	b8 0f 00 00 00       	mov    $0xf,%eax
  8003a1:	89 cb                	mov    %ecx,%ebx
  8003a3:	89 cf                	mov    %ecx,%edi
  8003a5:	89 ce                	mov    %ecx,%esi
  8003a7:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8003a9:	5b                   	pop    %ebx
  8003aa:	5e                   	pop    %esi
  8003ab:	5f                   	pop    %edi
  8003ac:	5d                   	pop    %ebp
  8003ad:	c3                   	ret    

008003ae <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8003ae:	55                   	push   %ebp
  8003af:	89 e5                	mov    %esp,%ebp
  8003b1:	56                   	push   %esi
  8003b2:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8003b3:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8003b6:	8b 35 00 20 80 00    	mov    0x802000,%esi
  8003bc:	e8 7d fd ff ff       	call   80013e <sys_getenvid>
  8003c1:	83 ec 0c             	sub    $0xc,%esp
  8003c4:	ff 75 0c             	pushl  0xc(%ebp)
  8003c7:	ff 75 08             	pushl  0x8(%ebp)
  8003ca:	56                   	push   %esi
  8003cb:	50                   	push   %eax
  8003cc:	68 78 11 80 00       	push   $0x801178
  8003d1:	e8 b3 00 00 00       	call   800489 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8003d6:	83 c4 18             	add    $0x18,%esp
  8003d9:	53                   	push   %ebx
  8003da:	ff 75 10             	pushl  0x10(%ebp)
  8003dd:	e8 56 00 00 00       	call   800438 <vcprintf>
	cprintf("\n");
  8003e2:	c7 04 24 9b 11 80 00 	movl   $0x80119b,(%esp)
  8003e9:	e8 9b 00 00 00       	call   800489 <cprintf>
  8003ee:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8003f1:	cc                   	int3   
  8003f2:	eb fd                	jmp    8003f1 <_panic+0x43>

008003f4 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8003f4:	55                   	push   %ebp
  8003f5:	89 e5                	mov    %esp,%ebp
  8003f7:	53                   	push   %ebx
  8003f8:	83 ec 04             	sub    $0x4,%esp
  8003fb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8003fe:	8b 13                	mov    (%ebx),%edx
  800400:	8d 42 01             	lea    0x1(%edx),%eax
  800403:	89 03                	mov    %eax,(%ebx)
  800405:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800408:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80040c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800411:	74 09                	je     80041c <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800413:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800417:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80041a:	c9                   	leave  
  80041b:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80041c:	83 ec 08             	sub    $0x8,%esp
  80041f:	68 ff 00 00 00       	push   $0xff
  800424:	8d 43 08             	lea    0x8(%ebx),%eax
  800427:	50                   	push   %eax
  800428:	e8 93 fc ff ff       	call   8000c0 <sys_cputs>
		b->idx = 0;
  80042d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800433:	83 c4 10             	add    $0x10,%esp
  800436:	eb db                	jmp    800413 <putch+0x1f>

00800438 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800438:	55                   	push   %ebp
  800439:	89 e5                	mov    %esp,%ebp
  80043b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800441:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800448:	00 00 00 
	b.cnt = 0;
  80044b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800452:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800455:	ff 75 0c             	pushl  0xc(%ebp)
  800458:	ff 75 08             	pushl  0x8(%ebp)
  80045b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800461:	50                   	push   %eax
  800462:	68 f4 03 80 00       	push   $0x8003f4
  800467:	e8 4a 01 00 00       	call   8005b6 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80046c:	83 c4 08             	add    $0x8,%esp
  80046f:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800475:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80047b:	50                   	push   %eax
  80047c:	e8 3f fc ff ff       	call   8000c0 <sys_cputs>

	return b.cnt;
}
  800481:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800487:	c9                   	leave  
  800488:	c3                   	ret    

00800489 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800489:	55                   	push   %ebp
  80048a:	89 e5                	mov    %esp,%ebp
  80048c:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80048f:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800492:	50                   	push   %eax
  800493:	ff 75 08             	pushl  0x8(%ebp)
  800496:	e8 9d ff ff ff       	call   800438 <vcprintf>
	va_end(ap);

	return cnt;
}
  80049b:	c9                   	leave  
  80049c:	c3                   	ret    

0080049d <printnum>:


static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80049d:	55                   	push   %ebp
  80049e:	89 e5                	mov    %esp,%ebp
  8004a0:	57                   	push   %edi
  8004a1:	56                   	push   %esi
  8004a2:	53                   	push   %ebx
  8004a3:	83 ec 1c             	sub    $0x1c,%esp
  8004a6:	89 c6                	mov    %eax,%esi
  8004a8:	89 d7                	mov    %edx,%edi
  8004aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004b3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8004b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8004b9:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	// to support '-'
	if(padc == '-'){
  8004bc:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8004c0:	74 2c                	je     8004ee <printnum+0x51>
		while (--width > 0)
			putch(' ', putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004c2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004c5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8004cc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004cf:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8004d2:	39 c2                	cmp    %eax,%edx
  8004d4:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8004d7:	73 43                	jae    80051c <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004d9:	83 eb 01             	sub    $0x1,%ebx
  8004dc:	85 db                	test   %ebx,%ebx
  8004de:	7e 6c                	jle    80054c <printnum+0xaf>
			putch(padc, putdat);
  8004e0:	83 ec 08             	sub    $0x8,%esp
  8004e3:	57                   	push   %edi
  8004e4:	ff 75 18             	pushl  0x18(%ebp)
  8004e7:	ff d6                	call   *%esi
  8004e9:	83 c4 10             	add    $0x10,%esp
  8004ec:	eb eb                	jmp    8004d9 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8004ee:	83 ec 0c             	sub    $0xc,%esp
  8004f1:	6a 20                	push   $0x20
  8004f3:	6a 00                	push   $0x0
  8004f5:	50                   	push   %eax
  8004f6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004f9:	ff 75 e0             	pushl  -0x20(%ebp)
  8004fc:	89 fa                	mov    %edi,%edx
  8004fe:	89 f0                	mov    %esi,%eax
  800500:	e8 98 ff ff ff       	call   80049d <printnum>
		while (--width > 0)
  800505:	83 c4 20             	add    $0x20,%esp
  800508:	83 eb 01             	sub    $0x1,%ebx
  80050b:	85 db                	test   %ebx,%ebx
  80050d:	7e 65                	jle    800574 <printnum+0xd7>
			putch(' ', putdat);
  80050f:	83 ec 08             	sub    $0x8,%esp
  800512:	57                   	push   %edi
  800513:	6a 20                	push   $0x20
  800515:	ff d6                	call   *%esi
  800517:	83 c4 10             	add    $0x10,%esp
  80051a:	eb ec                	jmp    800508 <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80051c:	83 ec 0c             	sub    $0xc,%esp
  80051f:	ff 75 18             	pushl  0x18(%ebp)
  800522:	83 eb 01             	sub    $0x1,%ebx
  800525:	53                   	push   %ebx
  800526:	50                   	push   %eax
  800527:	83 ec 08             	sub    $0x8,%esp
  80052a:	ff 75 dc             	pushl  -0x24(%ebp)
  80052d:	ff 75 d8             	pushl  -0x28(%ebp)
  800530:	ff 75 e4             	pushl  -0x1c(%ebp)
  800533:	ff 75 e0             	pushl  -0x20(%ebp)
  800536:	e8 b5 09 00 00       	call   800ef0 <__udivdi3>
  80053b:	83 c4 18             	add    $0x18,%esp
  80053e:	52                   	push   %edx
  80053f:	50                   	push   %eax
  800540:	89 fa                	mov    %edi,%edx
  800542:	89 f0                	mov    %esi,%eax
  800544:	e8 54 ff ff ff       	call   80049d <printnum>
  800549:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80054c:	83 ec 08             	sub    $0x8,%esp
  80054f:	57                   	push   %edi
  800550:	83 ec 04             	sub    $0x4,%esp
  800553:	ff 75 dc             	pushl  -0x24(%ebp)
  800556:	ff 75 d8             	pushl  -0x28(%ebp)
  800559:	ff 75 e4             	pushl  -0x1c(%ebp)
  80055c:	ff 75 e0             	pushl  -0x20(%ebp)
  80055f:	e8 9c 0a 00 00       	call   801000 <__umoddi3>
  800564:	83 c4 14             	add    $0x14,%esp
  800567:	0f be 80 9d 11 80 00 	movsbl 0x80119d(%eax),%eax
  80056e:	50                   	push   %eax
  80056f:	ff d6                	call   *%esi
  800571:	83 c4 10             	add    $0x10,%esp
}
  800574:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800577:	5b                   	pop    %ebx
  800578:	5e                   	pop    %esi
  800579:	5f                   	pop    %edi
  80057a:	5d                   	pop    %ebp
  80057b:	c3                   	ret    

0080057c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80057c:	55                   	push   %ebp
  80057d:	89 e5                	mov    %esp,%ebp
  80057f:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800582:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800586:	8b 10                	mov    (%eax),%edx
  800588:	3b 50 04             	cmp    0x4(%eax),%edx
  80058b:	73 0a                	jae    800597 <sprintputch+0x1b>
		*b->buf++ = ch;
  80058d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800590:	89 08                	mov    %ecx,(%eax)
  800592:	8b 45 08             	mov    0x8(%ebp),%eax
  800595:	88 02                	mov    %al,(%edx)
}
  800597:	5d                   	pop    %ebp
  800598:	c3                   	ret    

00800599 <printfmt>:
{
  800599:	55                   	push   %ebp
  80059a:	89 e5                	mov    %esp,%ebp
  80059c:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80059f:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8005a2:	50                   	push   %eax
  8005a3:	ff 75 10             	pushl  0x10(%ebp)
  8005a6:	ff 75 0c             	pushl  0xc(%ebp)
  8005a9:	ff 75 08             	pushl  0x8(%ebp)
  8005ac:	e8 05 00 00 00       	call   8005b6 <vprintfmt>
}
  8005b1:	83 c4 10             	add    $0x10,%esp
  8005b4:	c9                   	leave  
  8005b5:	c3                   	ret    

008005b6 <vprintfmt>:
{
  8005b6:	55                   	push   %ebp
  8005b7:	89 e5                	mov    %esp,%ebp
  8005b9:	57                   	push   %edi
  8005ba:	56                   	push   %esi
  8005bb:	53                   	push   %ebx
  8005bc:	83 ec 3c             	sub    $0x3c,%esp
  8005bf:	8b 75 08             	mov    0x8(%ebp),%esi
  8005c2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8005c5:	8b 7d 10             	mov    0x10(%ebp),%edi
  8005c8:	e9 1e 04 00 00       	jmp    8009eb <vprintfmt+0x435>
		posflag = 0;
  8005cd:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
		padc = ' ';
  8005d4:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8005d8:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8005df:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8005e6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8005ed:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  8005f4:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8005f9:	8d 47 01             	lea    0x1(%edi),%eax
  8005fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005ff:	0f b6 17             	movzbl (%edi),%edx
  800602:	8d 42 dd             	lea    -0x23(%edx),%eax
  800605:	3c 55                	cmp    $0x55,%al
  800607:	0f 87 d9 04 00 00    	ja     800ae6 <vprintfmt+0x530>
  80060d:	0f b6 c0             	movzbl %al,%eax
  800610:	ff 24 85 80 13 80 00 	jmp    *0x801380(,%eax,4)
  800617:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80061a:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80061e:	eb d9                	jmp    8005f9 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800620:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posflag = 1;
  800623:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  80062a:	eb cd                	jmp    8005f9 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80062c:	0f b6 d2             	movzbl %dl,%edx
  80062f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800632:	b8 00 00 00 00       	mov    $0x0,%eax
  800637:	89 75 08             	mov    %esi,0x8(%ebp)
  80063a:	eb 0c                	jmp    800648 <vprintfmt+0x92>
		switch (ch = *(unsigned char *) fmt++) {
  80063c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80063f:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  800643:	eb b4                	jmp    8005f9 <vprintfmt+0x43>
			for (precision = 0; ; ++fmt) {
  800645:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800648:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80064b:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80064f:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800652:	8d 72 d0             	lea    -0x30(%edx),%esi
  800655:	83 fe 09             	cmp    $0x9,%esi
  800658:	76 eb                	jbe    800645 <vprintfmt+0x8f>
  80065a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80065d:	8b 75 08             	mov    0x8(%ebp),%esi
  800660:	eb 14                	jmp    800676 <vprintfmt+0xc0>
			precision = va_arg(ap, int);
  800662:	8b 45 14             	mov    0x14(%ebp),%eax
  800665:	8b 00                	mov    (%eax),%eax
  800667:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80066a:	8b 45 14             	mov    0x14(%ebp),%eax
  80066d:	8d 40 04             	lea    0x4(%eax),%eax
  800670:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800673:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800676:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80067a:	0f 89 79 ff ff ff    	jns    8005f9 <vprintfmt+0x43>
				width = precision, precision = -1;
  800680:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800683:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800686:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80068d:	e9 67 ff ff ff       	jmp    8005f9 <vprintfmt+0x43>
  800692:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800695:	85 c0                	test   %eax,%eax
  800697:	0f 48 c1             	cmovs  %ecx,%eax
  80069a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80069d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8006a0:	e9 54 ff ff ff       	jmp    8005f9 <vprintfmt+0x43>
  8006a5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8006a8:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8006af:	e9 45 ff ff ff       	jmp    8005f9 <vprintfmt+0x43>
			lflag++;
  8006b4:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006b8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8006bb:	e9 39 ff ff ff       	jmp    8005f9 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8006c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c3:	8d 78 04             	lea    0x4(%eax),%edi
  8006c6:	83 ec 08             	sub    $0x8,%esp
  8006c9:	53                   	push   %ebx
  8006ca:	ff 30                	pushl  (%eax)
  8006cc:	ff d6                	call   *%esi
			break;
  8006ce:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8006d1:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8006d4:	e9 0f 03 00 00       	jmp    8009e8 <vprintfmt+0x432>
			err = va_arg(ap, int);
  8006d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006dc:	8d 78 04             	lea    0x4(%eax),%edi
  8006df:	8b 00                	mov    (%eax),%eax
  8006e1:	99                   	cltd   
  8006e2:	31 d0                	xor    %edx,%eax
  8006e4:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8006e6:	83 f8 0f             	cmp    $0xf,%eax
  8006e9:	7f 23                	jg     80070e <vprintfmt+0x158>
  8006eb:	8b 14 85 e0 14 80 00 	mov    0x8014e0(,%eax,4),%edx
  8006f2:	85 d2                	test   %edx,%edx
  8006f4:	74 18                	je     80070e <vprintfmt+0x158>
				printfmt(putch, putdat, "%s", p);
  8006f6:	52                   	push   %edx
  8006f7:	68 be 11 80 00       	push   $0x8011be
  8006fc:	53                   	push   %ebx
  8006fd:	56                   	push   %esi
  8006fe:	e8 96 fe ff ff       	call   800599 <printfmt>
  800703:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800706:	89 7d 14             	mov    %edi,0x14(%ebp)
  800709:	e9 da 02 00 00       	jmp    8009e8 <vprintfmt+0x432>
				printfmt(putch, putdat, "error %d", err);
  80070e:	50                   	push   %eax
  80070f:	68 b5 11 80 00       	push   $0x8011b5
  800714:	53                   	push   %ebx
  800715:	56                   	push   %esi
  800716:	e8 7e fe ff ff       	call   800599 <printfmt>
  80071b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80071e:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800721:	e9 c2 02 00 00       	jmp    8009e8 <vprintfmt+0x432>
			if ((p = va_arg(ap, char *)) == NULL)
  800726:	8b 45 14             	mov    0x14(%ebp),%eax
  800729:	83 c0 04             	add    $0x4,%eax
  80072c:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80072f:	8b 45 14             	mov    0x14(%ebp),%eax
  800732:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800734:	85 c9                	test   %ecx,%ecx
  800736:	b8 ae 11 80 00       	mov    $0x8011ae,%eax
  80073b:	0f 45 c1             	cmovne %ecx,%eax
  80073e:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800741:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800745:	7e 06                	jle    80074d <vprintfmt+0x197>
  800747:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80074b:	75 0d                	jne    80075a <vprintfmt+0x1a4>
				for (width -= strnlen(p, precision); width > 0; width--)
  80074d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800750:	89 c7                	mov    %eax,%edi
  800752:	03 45 e0             	add    -0x20(%ebp),%eax
  800755:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800758:	eb 53                	jmp    8007ad <vprintfmt+0x1f7>
  80075a:	83 ec 08             	sub    $0x8,%esp
  80075d:	ff 75 d8             	pushl  -0x28(%ebp)
  800760:	50                   	push   %eax
  800761:	e8 28 04 00 00       	call   800b8e <strnlen>
  800766:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800769:	29 c1                	sub    %eax,%ecx
  80076b:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  80076e:	83 c4 10             	add    $0x10,%esp
  800771:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800773:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800777:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80077a:	eb 0f                	jmp    80078b <vprintfmt+0x1d5>
					putch(padc, putdat);
  80077c:	83 ec 08             	sub    $0x8,%esp
  80077f:	53                   	push   %ebx
  800780:	ff 75 e0             	pushl  -0x20(%ebp)
  800783:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800785:	83 ef 01             	sub    $0x1,%edi
  800788:	83 c4 10             	add    $0x10,%esp
  80078b:	85 ff                	test   %edi,%edi
  80078d:	7f ed                	jg     80077c <vprintfmt+0x1c6>
  80078f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  800792:	85 c9                	test   %ecx,%ecx
  800794:	b8 00 00 00 00       	mov    $0x0,%eax
  800799:	0f 49 c1             	cmovns %ecx,%eax
  80079c:	29 c1                	sub    %eax,%ecx
  80079e:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8007a1:	eb aa                	jmp    80074d <vprintfmt+0x197>
					putch(ch, putdat);
  8007a3:	83 ec 08             	sub    $0x8,%esp
  8007a6:	53                   	push   %ebx
  8007a7:	52                   	push   %edx
  8007a8:	ff d6                	call   *%esi
  8007aa:	83 c4 10             	add    $0x10,%esp
  8007ad:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8007b0:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007b2:	83 c7 01             	add    $0x1,%edi
  8007b5:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007b9:	0f be d0             	movsbl %al,%edx
  8007bc:	85 d2                	test   %edx,%edx
  8007be:	74 4b                	je     80080b <vprintfmt+0x255>
  8007c0:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8007c4:	78 06                	js     8007cc <vprintfmt+0x216>
  8007c6:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8007ca:	78 1e                	js     8007ea <vprintfmt+0x234>
				if (altflag && (ch < ' ' || ch > '~'))
  8007cc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8007d0:	74 d1                	je     8007a3 <vprintfmt+0x1ed>
  8007d2:	0f be c0             	movsbl %al,%eax
  8007d5:	83 e8 20             	sub    $0x20,%eax
  8007d8:	83 f8 5e             	cmp    $0x5e,%eax
  8007db:	76 c6                	jbe    8007a3 <vprintfmt+0x1ed>
					putch('?', putdat);
  8007dd:	83 ec 08             	sub    $0x8,%esp
  8007e0:	53                   	push   %ebx
  8007e1:	6a 3f                	push   $0x3f
  8007e3:	ff d6                	call   *%esi
  8007e5:	83 c4 10             	add    $0x10,%esp
  8007e8:	eb c3                	jmp    8007ad <vprintfmt+0x1f7>
  8007ea:	89 cf                	mov    %ecx,%edi
  8007ec:	eb 0e                	jmp    8007fc <vprintfmt+0x246>
				putch(' ', putdat);
  8007ee:	83 ec 08             	sub    $0x8,%esp
  8007f1:	53                   	push   %ebx
  8007f2:	6a 20                	push   $0x20
  8007f4:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8007f6:	83 ef 01             	sub    $0x1,%edi
  8007f9:	83 c4 10             	add    $0x10,%esp
  8007fc:	85 ff                	test   %edi,%edi
  8007fe:	7f ee                	jg     8007ee <vprintfmt+0x238>
			if ((p = va_arg(ap, char *)) == NULL)
  800800:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800803:	89 45 14             	mov    %eax,0x14(%ebp)
  800806:	e9 dd 01 00 00       	jmp    8009e8 <vprintfmt+0x432>
  80080b:	89 cf                	mov    %ecx,%edi
  80080d:	eb ed                	jmp    8007fc <vprintfmt+0x246>
	if (lflag >= 2)
  80080f:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800813:	7f 21                	jg     800836 <vprintfmt+0x280>
	else if (lflag)
  800815:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800819:	74 6a                	je     800885 <vprintfmt+0x2cf>
		return va_arg(*ap, long);
  80081b:	8b 45 14             	mov    0x14(%ebp),%eax
  80081e:	8b 00                	mov    (%eax),%eax
  800820:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800823:	89 c1                	mov    %eax,%ecx
  800825:	c1 f9 1f             	sar    $0x1f,%ecx
  800828:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80082b:	8b 45 14             	mov    0x14(%ebp),%eax
  80082e:	8d 40 04             	lea    0x4(%eax),%eax
  800831:	89 45 14             	mov    %eax,0x14(%ebp)
  800834:	eb 17                	jmp    80084d <vprintfmt+0x297>
		return va_arg(*ap, long long);
  800836:	8b 45 14             	mov    0x14(%ebp),%eax
  800839:	8b 50 04             	mov    0x4(%eax),%edx
  80083c:	8b 00                	mov    (%eax),%eax
  80083e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800841:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800844:	8b 45 14             	mov    0x14(%ebp),%eax
  800847:	8d 40 08             	lea    0x8(%eax),%eax
  80084a:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80084d:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  800850:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800855:	85 d2                	test   %edx,%edx
  800857:	0f 89 5c 01 00 00    	jns    8009b9 <vprintfmt+0x403>
				putch('-', putdat);
  80085d:	83 ec 08             	sub    $0x8,%esp
  800860:	53                   	push   %ebx
  800861:	6a 2d                	push   $0x2d
  800863:	ff d6                	call   *%esi
				num = -(long long) num;
  800865:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800868:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80086b:	f7 d8                	neg    %eax
  80086d:	83 d2 00             	adc    $0x0,%edx
  800870:	f7 da                	neg    %edx
  800872:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800875:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800878:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80087b:	bf 0a 00 00 00       	mov    $0xa,%edi
  800880:	e9 45 01 00 00       	jmp    8009ca <vprintfmt+0x414>
		return va_arg(*ap, int);
  800885:	8b 45 14             	mov    0x14(%ebp),%eax
  800888:	8b 00                	mov    (%eax),%eax
  80088a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80088d:	89 c1                	mov    %eax,%ecx
  80088f:	c1 f9 1f             	sar    $0x1f,%ecx
  800892:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800895:	8b 45 14             	mov    0x14(%ebp),%eax
  800898:	8d 40 04             	lea    0x4(%eax),%eax
  80089b:	89 45 14             	mov    %eax,0x14(%ebp)
  80089e:	eb ad                	jmp    80084d <vprintfmt+0x297>
	if (lflag >= 2)
  8008a0:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8008a4:	7f 29                	jg     8008cf <vprintfmt+0x319>
	else if (lflag)
  8008a6:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8008aa:	74 44                	je     8008f0 <vprintfmt+0x33a>
		return va_arg(*ap, unsigned long);
  8008ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8008af:	8b 00                	mov    (%eax),%eax
  8008b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8008b6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008b9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8008bf:	8d 40 04             	lea    0x4(%eax),%eax
  8008c2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008c5:	bf 0a 00 00 00       	mov    $0xa,%edi
  8008ca:	e9 ea 00 00 00       	jmp    8009b9 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  8008cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d2:	8b 50 04             	mov    0x4(%eax),%edx
  8008d5:	8b 00                	mov    (%eax),%eax
  8008d7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008da:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e0:	8d 40 08             	lea    0x8(%eax),%eax
  8008e3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008e6:	bf 0a 00 00 00       	mov    $0xa,%edi
  8008eb:	e9 c9 00 00 00       	jmp    8009b9 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  8008f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f3:	8b 00                	mov    (%eax),%eax
  8008f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8008fa:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008fd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800900:	8b 45 14             	mov    0x14(%ebp),%eax
  800903:	8d 40 04             	lea    0x4(%eax),%eax
  800906:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800909:	bf 0a 00 00 00       	mov    $0xa,%edi
  80090e:	e9 a6 00 00 00       	jmp    8009b9 <vprintfmt+0x403>
			putch('0', putdat);
  800913:	83 ec 08             	sub    $0x8,%esp
  800916:	53                   	push   %ebx
  800917:	6a 30                	push   $0x30
  800919:	ff d6                	call   *%esi
	if (lflag >= 2)
  80091b:	83 c4 10             	add    $0x10,%esp
  80091e:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800922:	7f 26                	jg     80094a <vprintfmt+0x394>
	else if (lflag)
  800924:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800928:	74 3e                	je     800968 <vprintfmt+0x3b2>
		return va_arg(*ap, unsigned long);
  80092a:	8b 45 14             	mov    0x14(%ebp),%eax
  80092d:	8b 00                	mov    (%eax),%eax
  80092f:	ba 00 00 00 00       	mov    $0x0,%edx
  800934:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800937:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80093a:	8b 45 14             	mov    0x14(%ebp),%eax
  80093d:	8d 40 04             	lea    0x4(%eax),%eax
  800940:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800943:	bf 08 00 00 00       	mov    $0x8,%edi
  800948:	eb 6f                	jmp    8009b9 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  80094a:	8b 45 14             	mov    0x14(%ebp),%eax
  80094d:	8b 50 04             	mov    0x4(%eax),%edx
  800950:	8b 00                	mov    (%eax),%eax
  800952:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800955:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800958:	8b 45 14             	mov    0x14(%ebp),%eax
  80095b:	8d 40 08             	lea    0x8(%eax),%eax
  80095e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800961:	bf 08 00 00 00       	mov    $0x8,%edi
  800966:	eb 51                	jmp    8009b9 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  800968:	8b 45 14             	mov    0x14(%ebp),%eax
  80096b:	8b 00                	mov    (%eax),%eax
  80096d:	ba 00 00 00 00       	mov    $0x0,%edx
  800972:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800975:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800978:	8b 45 14             	mov    0x14(%ebp),%eax
  80097b:	8d 40 04             	lea    0x4(%eax),%eax
  80097e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800981:	bf 08 00 00 00       	mov    $0x8,%edi
  800986:	eb 31                	jmp    8009b9 <vprintfmt+0x403>
			putch('0', putdat);
  800988:	83 ec 08             	sub    $0x8,%esp
  80098b:	53                   	push   %ebx
  80098c:	6a 30                	push   $0x30
  80098e:	ff d6                	call   *%esi
			putch('x', putdat);
  800990:	83 c4 08             	add    $0x8,%esp
  800993:	53                   	push   %ebx
  800994:	6a 78                	push   $0x78
  800996:	ff d6                	call   *%esi
			num = (unsigned long long)
  800998:	8b 45 14             	mov    0x14(%ebp),%eax
  80099b:	8b 00                	mov    (%eax),%eax
  80099d:	ba 00 00 00 00       	mov    $0x0,%edx
  8009a2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009a5:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8009a8:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8009ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ae:	8d 40 04             	lea    0x4(%eax),%eax
  8009b1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009b4:	bf 10 00 00 00       	mov    $0x10,%edi
			if(posflag)
  8009b9:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8009bd:	74 0b                	je     8009ca <vprintfmt+0x414>
				putch('+', putdat);
  8009bf:	83 ec 08             	sub    $0x8,%esp
  8009c2:	53                   	push   %ebx
  8009c3:	6a 2b                	push   $0x2b
  8009c5:	ff d6                	call   *%esi
  8009c7:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  8009ca:	83 ec 0c             	sub    $0xc,%esp
  8009cd:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8009d1:	50                   	push   %eax
  8009d2:	ff 75 e0             	pushl  -0x20(%ebp)
  8009d5:	57                   	push   %edi
  8009d6:	ff 75 dc             	pushl  -0x24(%ebp)
  8009d9:	ff 75 d8             	pushl  -0x28(%ebp)
  8009dc:	89 da                	mov    %ebx,%edx
  8009de:	89 f0                	mov    %esi,%eax
  8009e0:	e8 b8 fa ff ff       	call   80049d <printnum>
			break;
  8009e5:	83 c4 20             	add    $0x20,%esp
			char* cp = va_arg(ap, char *);
  8009e8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009eb:	83 c7 01             	add    $0x1,%edi
  8009ee:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8009f2:	83 f8 25             	cmp    $0x25,%eax
  8009f5:	0f 84 d2 fb ff ff    	je     8005cd <vprintfmt+0x17>
			if (ch == '\0')
  8009fb:	85 c0                	test   %eax,%eax
  8009fd:	0f 84 03 01 00 00    	je     800b06 <vprintfmt+0x550>
			putch(ch, putdat);
  800a03:	83 ec 08             	sub    $0x8,%esp
  800a06:	53                   	push   %ebx
  800a07:	50                   	push   %eax
  800a08:	ff d6                	call   *%esi
  800a0a:	83 c4 10             	add    $0x10,%esp
  800a0d:	eb dc                	jmp    8009eb <vprintfmt+0x435>
	if (lflag >= 2)
  800a0f:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800a13:	7f 29                	jg     800a3e <vprintfmt+0x488>
	else if (lflag)
  800a15:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800a19:	74 44                	je     800a5f <vprintfmt+0x4a9>
		return va_arg(*ap, unsigned long);
  800a1b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1e:	8b 00                	mov    (%eax),%eax
  800a20:	ba 00 00 00 00       	mov    $0x0,%edx
  800a25:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a28:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a2b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2e:	8d 40 04             	lea    0x4(%eax),%eax
  800a31:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a34:	bf 10 00 00 00       	mov    $0x10,%edi
  800a39:	e9 7b ff ff ff       	jmp    8009b9 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  800a3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a41:	8b 50 04             	mov    0x4(%eax),%edx
  800a44:	8b 00                	mov    (%eax),%eax
  800a46:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a49:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a4c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4f:	8d 40 08             	lea    0x8(%eax),%eax
  800a52:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a55:	bf 10 00 00 00       	mov    $0x10,%edi
  800a5a:	e9 5a ff ff ff       	jmp    8009b9 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  800a5f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a62:	8b 00                	mov    (%eax),%eax
  800a64:	ba 00 00 00 00       	mov    $0x0,%edx
  800a69:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a6c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a6f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a72:	8d 40 04             	lea    0x4(%eax),%eax
  800a75:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a78:	bf 10 00 00 00       	mov    $0x10,%edi
  800a7d:	e9 37 ff ff ff       	jmp    8009b9 <vprintfmt+0x403>
			char* cp = va_arg(ap, char *);
  800a82:	8b 45 14             	mov    0x14(%ebp),%eax
  800a85:	8d 78 04             	lea    0x4(%eax),%edi
  800a88:	8b 00                	mov    (%eax),%eax
    			if (cp == NULL) {
  800a8a:	85 c0                	test   %eax,%eax
  800a8c:	74 2c                	je     800aba <vprintfmt+0x504>
    			*cp = *(int *)putdat;
  800a8e:	8b 13                	mov    (%ebx),%edx
  800a90:	88 10                	mov    %dl,(%eax)
			char* cp = va_arg(ap, char *);
  800a92:	89 7d 14             	mov    %edi,0x14(%ebp)
    			if ((*(int *) putdat) > 127)
  800a95:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  800a98:	0f 8e 4a ff ff ff    	jle    8009e8 <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", overflow_error);
  800a9e:	68 0c 13 80 00       	push   $0x80130c
  800aa3:	68 be 11 80 00       	push   $0x8011be
  800aa8:	53                   	push   %ebx
  800aa9:	56                   	push   %esi
  800aaa:	e8 ea fa ff ff       	call   800599 <printfmt>
  800aaf:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  800ab2:	89 7d 14             	mov    %edi,0x14(%ebp)
  800ab5:	e9 2e ff ff ff       	jmp    8009e8 <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", null_error);
  800aba:	68 d4 12 80 00       	push   $0x8012d4
  800abf:	68 be 11 80 00       	push   $0x8011be
  800ac4:	53                   	push   %ebx
  800ac5:	56                   	push   %esi
  800ac6:	e8 ce fa ff ff       	call   800599 <printfmt>
        		break;
  800acb:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  800ace:	89 7d 14             	mov    %edi,0x14(%ebp)
        		break;
  800ad1:	e9 12 ff ff ff       	jmp    8009e8 <vprintfmt+0x432>
			putch(ch, putdat);
  800ad6:	83 ec 08             	sub    $0x8,%esp
  800ad9:	53                   	push   %ebx
  800ada:	6a 25                	push   $0x25
  800adc:	ff d6                	call   *%esi
			break;
  800ade:	83 c4 10             	add    $0x10,%esp
  800ae1:	e9 02 ff ff ff       	jmp    8009e8 <vprintfmt+0x432>
			putch('%', putdat);
  800ae6:	83 ec 08             	sub    $0x8,%esp
  800ae9:	53                   	push   %ebx
  800aea:	6a 25                	push   $0x25
  800aec:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800aee:	83 c4 10             	add    $0x10,%esp
  800af1:	89 f8                	mov    %edi,%eax
  800af3:	eb 03                	jmp    800af8 <vprintfmt+0x542>
  800af5:	83 e8 01             	sub    $0x1,%eax
  800af8:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800afc:	75 f7                	jne    800af5 <vprintfmt+0x53f>
  800afe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b01:	e9 e2 fe ff ff       	jmp    8009e8 <vprintfmt+0x432>
}
  800b06:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b09:	5b                   	pop    %ebx
  800b0a:	5e                   	pop    %esi
  800b0b:	5f                   	pop    %edi
  800b0c:	5d                   	pop    %ebp
  800b0d:	c3                   	ret    

00800b0e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b0e:	55                   	push   %ebp
  800b0f:	89 e5                	mov    %esp,%ebp
  800b11:	83 ec 18             	sub    $0x18,%esp
  800b14:	8b 45 08             	mov    0x8(%ebp),%eax
  800b17:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b1a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b1d:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800b21:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800b24:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b2b:	85 c0                	test   %eax,%eax
  800b2d:	74 26                	je     800b55 <vsnprintf+0x47>
  800b2f:	85 d2                	test   %edx,%edx
  800b31:	7e 22                	jle    800b55 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b33:	ff 75 14             	pushl  0x14(%ebp)
  800b36:	ff 75 10             	pushl  0x10(%ebp)
  800b39:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b3c:	50                   	push   %eax
  800b3d:	68 7c 05 80 00       	push   $0x80057c
  800b42:	e8 6f fa ff ff       	call   8005b6 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800b47:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b4a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b50:	83 c4 10             	add    $0x10,%esp
}
  800b53:	c9                   	leave  
  800b54:	c3                   	ret    
		return -E_INVAL;
  800b55:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b5a:	eb f7                	jmp    800b53 <vsnprintf+0x45>

00800b5c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b5c:	55                   	push   %ebp
  800b5d:	89 e5                	mov    %esp,%ebp
  800b5f:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b62:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800b65:	50                   	push   %eax
  800b66:	ff 75 10             	pushl  0x10(%ebp)
  800b69:	ff 75 0c             	pushl  0xc(%ebp)
  800b6c:	ff 75 08             	pushl  0x8(%ebp)
  800b6f:	e8 9a ff ff ff       	call   800b0e <vsnprintf>
	va_end(ap);

	return rc;
}
  800b74:	c9                   	leave  
  800b75:	c3                   	ret    

00800b76 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800b76:	55                   	push   %ebp
  800b77:	89 e5                	mov    %esp,%ebp
  800b79:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800b7c:	b8 00 00 00 00       	mov    $0x0,%eax
  800b81:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800b85:	74 05                	je     800b8c <strlen+0x16>
		n++;
  800b87:	83 c0 01             	add    $0x1,%eax
  800b8a:	eb f5                	jmp    800b81 <strlen+0xb>
	return n;
}
  800b8c:	5d                   	pop    %ebp
  800b8d:	c3                   	ret    

00800b8e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800b8e:	55                   	push   %ebp
  800b8f:	89 e5                	mov    %esp,%ebp
  800b91:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b94:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b97:	ba 00 00 00 00       	mov    $0x0,%edx
  800b9c:	39 c2                	cmp    %eax,%edx
  800b9e:	74 0d                	je     800bad <strnlen+0x1f>
  800ba0:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800ba4:	74 05                	je     800bab <strnlen+0x1d>
		n++;
  800ba6:	83 c2 01             	add    $0x1,%edx
  800ba9:	eb f1                	jmp    800b9c <strnlen+0xe>
  800bab:	89 d0                	mov    %edx,%eax
	return n;
}
  800bad:	5d                   	pop    %ebp
  800bae:	c3                   	ret    

00800baf <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800baf:	55                   	push   %ebp
  800bb0:	89 e5                	mov    %esp,%ebp
  800bb2:	53                   	push   %ebx
  800bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800bb9:	ba 00 00 00 00       	mov    $0x0,%edx
  800bbe:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800bc2:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800bc5:	83 c2 01             	add    $0x1,%edx
  800bc8:	84 c9                	test   %cl,%cl
  800bca:	75 f2                	jne    800bbe <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800bcc:	5b                   	pop    %ebx
  800bcd:	5d                   	pop    %ebp
  800bce:	c3                   	ret    

00800bcf <strcat>:

char *
strcat(char *dst, const char *src)
{
  800bcf:	55                   	push   %ebp
  800bd0:	89 e5                	mov    %esp,%ebp
  800bd2:	53                   	push   %ebx
  800bd3:	83 ec 10             	sub    $0x10,%esp
  800bd6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800bd9:	53                   	push   %ebx
  800bda:	e8 97 ff ff ff       	call   800b76 <strlen>
  800bdf:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800be2:	ff 75 0c             	pushl  0xc(%ebp)
  800be5:	01 d8                	add    %ebx,%eax
  800be7:	50                   	push   %eax
  800be8:	e8 c2 ff ff ff       	call   800baf <strcpy>
	return dst;
}
  800bed:	89 d8                	mov    %ebx,%eax
  800bef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800bf2:	c9                   	leave  
  800bf3:	c3                   	ret    

00800bf4 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800bf4:	55                   	push   %ebp
  800bf5:	89 e5                	mov    %esp,%ebp
  800bf7:	56                   	push   %esi
  800bf8:	53                   	push   %ebx
  800bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bff:	89 c6                	mov    %eax,%esi
  800c01:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c04:	89 c2                	mov    %eax,%edx
  800c06:	39 f2                	cmp    %esi,%edx
  800c08:	74 11                	je     800c1b <strncpy+0x27>
		*dst++ = *src;
  800c0a:	83 c2 01             	add    $0x1,%edx
  800c0d:	0f b6 19             	movzbl (%ecx),%ebx
  800c10:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800c13:	80 fb 01             	cmp    $0x1,%bl
  800c16:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800c19:	eb eb                	jmp    800c06 <strncpy+0x12>
	}
	return ret;
}
  800c1b:	5b                   	pop    %ebx
  800c1c:	5e                   	pop    %esi
  800c1d:	5d                   	pop    %ebp
  800c1e:	c3                   	ret    

00800c1f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800c1f:	55                   	push   %ebp
  800c20:	89 e5                	mov    %esp,%ebp
  800c22:	56                   	push   %esi
  800c23:	53                   	push   %ebx
  800c24:	8b 75 08             	mov    0x8(%ebp),%esi
  800c27:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c2a:	8b 55 10             	mov    0x10(%ebp),%edx
  800c2d:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800c2f:	85 d2                	test   %edx,%edx
  800c31:	74 21                	je     800c54 <strlcpy+0x35>
  800c33:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800c37:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800c39:	39 c2                	cmp    %eax,%edx
  800c3b:	74 14                	je     800c51 <strlcpy+0x32>
  800c3d:	0f b6 19             	movzbl (%ecx),%ebx
  800c40:	84 db                	test   %bl,%bl
  800c42:	74 0b                	je     800c4f <strlcpy+0x30>
			*dst++ = *src++;
  800c44:	83 c1 01             	add    $0x1,%ecx
  800c47:	83 c2 01             	add    $0x1,%edx
  800c4a:	88 5a ff             	mov    %bl,-0x1(%edx)
  800c4d:	eb ea                	jmp    800c39 <strlcpy+0x1a>
  800c4f:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800c51:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c54:	29 f0                	sub    %esi,%eax
}
  800c56:	5b                   	pop    %ebx
  800c57:	5e                   	pop    %esi
  800c58:	5d                   	pop    %ebp
  800c59:	c3                   	ret    

00800c5a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c5a:	55                   	push   %ebp
  800c5b:	89 e5                	mov    %esp,%ebp
  800c5d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c60:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800c63:	0f b6 01             	movzbl (%ecx),%eax
  800c66:	84 c0                	test   %al,%al
  800c68:	74 0c                	je     800c76 <strcmp+0x1c>
  800c6a:	3a 02                	cmp    (%edx),%al
  800c6c:	75 08                	jne    800c76 <strcmp+0x1c>
		p++, q++;
  800c6e:	83 c1 01             	add    $0x1,%ecx
  800c71:	83 c2 01             	add    $0x1,%edx
  800c74:	eb ed                	jmp    800c63 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c76:	0f b6 c0             	movzbl %al,%eax
  800c79:	0f b6 12             	movzbl (%edx),%edx
  800c7c:	29 d0                	sub    %edx,%eax
}
  800c7e:	5d                   	pop    %ebp
  800c7f:	c3                   	ret    

00800c80 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800c80:	55                   	push   %ebp
  800c81:	89 e5                	mov    %esp,%ebp
  800c83:	53                   	push   %ebx
  800c84:	8b 45 08             	mov    0x8(%ebp),%eax
  800c87:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c8a:	89 c3                	mov    %eax,%ebx
  800c8c:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800c8f:	eb 06                	jmp    800c97 <strncmp+0x17>
		n--, p++, q++;
  800c91:	83 c0 01             	add    $0x1,%eax
  800c94:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800c97:	39 d8                	cmp    %ebx,%eax
  800c99:	74 16                	je     800cb1 <strncmp+0x31>
  800c9b:	0f b6 08             	movzbl (%eax),%ecx
  800c9e:	84 c9                	test   %cl,%cl
  800ca0:	74 04                	je     800ca6 <strncmp+0x26>
  800ca2:	3a 0a                	cmp    (%edx),%cl
  800ca4:	74 eb                	je     800c91 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ca6:	0f b6 00             	movzbl (%eax),%eax
  800ca9:	0f b6 12             	movzbl (%edx),%edx
  800cac:	29 d0                	sub    %edx,%eax
}
  800cae:	5b                   	pop    %ebx
  800caf:	5d                   	pop    %ebp
  800cb0:	c3                   	ret    
		return 0;
  800cb1:	b8 00 00 00 00       	mov    $0x0,%eax
  800cb6:	eb f6                	jmp    800cae <strncmp+0x2e>

00800cb8 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800cb8:	55                   	push   %ebp
  800cb9:	89 e5                	mov    %esp,%ebp
  800cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbe:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800cc2:	0f b6 10             	movzbl (%eax),%edx
  800cc5:	84 d2                	test   %dl,%dl
  800cc7:	74 09                	je     800cd2 <strchr+0x1a>
		if (*s == c)
  800cc9:	38 ca                	cmp    %cl,%dl
  800ccb:	74 0a                	je     800cd7 <strchr+0x1f>
	for (; *s; s++)
  800ccd:	83 c0 01             	add    $0x1,%eax
  800cd0:	eb f0                	jmp    800cc2 <strchr+0xa>
			return (char *) s;
	return 0;
  800cd2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cd7:	5d                   	pop    %ebp
  800cd8:	c3                   	ret    

00800cd9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cd9:	55                   	push   %ebp
  800cda:	89 e5                	mov    %esp,%ebp
  800cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdf:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ce3:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800ce6:	38 ca                	cmp    %cl,%dl
  800ce8:	74 09                	je     800cf3 <strfind+0x1a>
  800cea:	84 d2                	test   %dl,%dl
  800cec:	74 05                	je     800cf3 <strfind+0x1a>
	for (; *s; s++)
  800cee:	83 c0 01             	add    $0x1,%eax
  800cf1:	eb f0                	jmp    800ce3 <strfind+0xa>
			break;
	return (char *) s;
}
  800cf3:	5d                   	pop    %ebp
  800cf4:	c3                   	ret    

00800cf5 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800cf5:	55                   	push   %ebp
  800cf6:	89 e5                	mov    %esp,%ebp
  800cf8:	57                   	push   %edi
  800cf9:	56                   	push   %esi
  800cfa:	53                   	push   %ebx
  800cfb:	8b 7d 08             	mov    0x8(%ebp),%edi
  800cfe:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800d01:	85 c9                	test   %ecx,%ecx
  800d03:	74 31                	je     800d36 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800d05:	89 f8                	mov    %edi,%eax
  800d07:	09 c8                	or     %ecx,%eax
  800d09:	a8 03                	test   $0x3,%al
  800d0b:	75 23                	jne    800d30 <memset+0x3b>
		c &= 0xFF;
  800d0d:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800d11:	89 d3                	mov    %edx,%ebx
  800d13:	c1 e3 08             	shl    $0x8,%ebx
  800d16:	89 d0                	mov    %edx,%eax
  800d18:	c1 e0 18             	shl    $0x18,%eax
  800d1b:	89 d6                	mov    %edx,%esi
  800d1d:	c1 e6 10             	shl    $0x10,%esi
  800d20:	09 f0                	or     %esi,%eax
  800d22:	09 c2                	or     %eax,%edx
  800d24:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800d26:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800d29:	89 d0                	mov    %edx,%eax
  800d2b:	fc                   	cld    
  800d2c:	f3 ab                	rep stos %eax,%es:(%edi)
  800d2e:	eb 06                	jmp    800d36 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d33:	fc                   	cld    
  800d34:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800d36:	89 f8                	mov    %edi,%eax
  800d38:	5b                   	pop    %ebx
  800d39:	5e                   	pop    %esi
  800d3a:	5f                   	pop    %edi
  800d3b:	5d                   	pop    %ebp
  800d3c:	c3                   	ret    

00800d3d <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800d3d:	55                   	push   %ebp
  800d3e:	89 e5                	mov    %esp,%ebp
  800d40:	57                   	push   %edi
  800d41:	56                   	push   %esi
  800d42:	8b 45 08             	mov    0x8(%ebp),%eax
  800d45:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d48:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d4b:	39 c6                	cmp    %eax,%esi
  800d4d:	73 32                	jae    800d81 <memmove+0x44>
  800d4f:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800d52:	39 c2                	cmp    %eax,%edx
  800d54:	76 2b                	jbe    800d81 <memmove+0x44>
		s += n;
		d += n;
  800d56:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d59:	89 fe                	mov    %edi,%esi
  800d5b:	09 ce                	or     %ecx,%esi
  800d5d:	09 d6                	or     %edx,%esi
  800d5f:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800d65:	75 0e                	jne    800d75 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800d67:	83 ef 04             	sub    $0x4,%edi
  800d6a:	8d 72 fc             	lea    -0x4(%edx),%esi
  800d6d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800d70:	fd                   	std    
  800d71:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d73:	eb 09                	jmp    800d7e <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800d75:	83 ef 01             	sub    $0x1,%edi
  800d78:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800d7b:	fd                   	std    
  800d7c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800d7e:	fc                   	cld    
  800d7f:	eb 1a                	jmp    800d9b <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d81:	89 c2                	mov    %eax,%edx
  800d83:	09 ca                	or     %ecx,%edx
  800d85:	09 f2                	or     %esi,%edx
  800d87:	f6 c2 03             	test   $0x3,%dl
  800d8a:	75 0a                	jne    800d96 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800d8c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800d8f:	89 c7                	mov    %eax,%edi
  800d91:	fc                   	cld    
  800d92:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d94:	eb 05                	jmp    800d9b <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800d96:	89 c7                	mov    %eax,%edi
  800d98:	fc                   	cld    
  800d99:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800d9b:	5e                   	pop    %esi
  800d9c:	5f                   	pop    %edi
  800d9d:	5d                   	pop    %ebp
  800d9e:	c3                   	ret    

00800d9f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800d9f:	55                   	push   %ebp
  800da0:	89 e5                	mov    %esp,%ebp
  800da2:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800da5:	ff 75 10             	pushl  0x10(%ebp)
  800da8:	ff 75 0c             	pushl  0xc(%ebp)
  800dab:	ff 75 08             	pushl  0x8(%ebp)
  800dae:	e8 8a ff ff ff       	call   800d3d <memmove>
}
  800db3:	c9                   	leave  
  800db4:	c3                   	ret    

00800db5 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800db5:	55                   	push   %ebp
  800db6:	89 e5                	mov    %esp,%ebp
  800db8:	56                   	push   %esi
  800db9:	53                   	push   %ebx
  800dba:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dc0:	89 c6                	mov    %eax,%esi
  800dc2:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800dc5:	39 f0                	cmp    %esi,%eax
  800dc7:	74 1c                	je     800de5 <memcmp+0x30>
		if (*s1 != *s2)
  800dc9:	0f b6 08             	movzbl (%eax),%ecx
  800dcc:	0f b6 1a             	movzbl (%edx),%ebx
  800dcf:	38 d9                	cmp    %bl,%cl
  800dd1:	75 08                	jne    800ddb <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800dd3:	83 c0 01             	add    $0x1,%eax
  800dd6:	83 c2 01             	add    $0x1,%edx
  800dd9:	eb ea                	jmp    800dc5 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800ddb:	0f b6 c1             	movzbl %cl,%eax
  800dde:	0f b6 db             	movzbl %bl,%ebx
  800de1:	29 d8                	sub    %ebx,%eax
  800de3:	eb 05                	jmp    800dea <memcmp+0x35>
	}

	return 0;
  800de5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dea:	5b                   	pop    %ebx
  800deb:	5e                   	pop    %esi
  800dec:	5d                   	pop    %ebp
  800ded:	c3                   	ret    

00800dee <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800dee:	55                   	push   %ebp
  800def:	89 e5                	mov    %esp,%ebp
  800df1:	8b 45 08             	mov    0x8(%ebp),%eax
  800df4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800df7:	89 c2                	mov    %eax,%edx
  800df9:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800dfc:	39 d0                	cmp    %edx,%eax
  800dfe:	73 09                	jae    800e09 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e00:	38 08                	cmp    %cl,(%eax)
  800e02:	74 05                	je     800e09 <memfind+0x1b>
	for (; s < ends; s++)
  800e04:	83 c0 01             	add    $0x1,%eax
  800e07:	eb f3                	jmp    800dfc <memfind+0xe>
			break;
	return (void *) s;
}
  800e09:	5d                   	pop    %ebp
  800e0a:	c3                   	ret    

00800e0b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e0b:	55                   	push   %ebp
  800e0c:	89 e5                	mov    %esp,%ebp
  800e0e:	57                   	push   %edi
  800e0f:	56                   	push   %esi
  800e10:	53                   	push   %ebx
  800e11:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e14:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e17:	eb 03                	jmp    800e1c <strtol+0x11>
		s++;
  800e19:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800e1c:	0f b6 01             	movzbl (%ecx),%eax
  800e1f:	3c 20                	cmp    $0x20,%al
  800e21:	74 f6                	je     800e19 <strtol+0xe>
  800e23:	3c 09                	cmp    $0x9,%al
  800e25:	74 f2                	je     800e19 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800e27:	3c 2b                	cmp    $0x2b,%al
  800e29:	74 2a                	je     800e55 <strtol+0x4a>
	int neg = 0;
  800e2b:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800e30:	3c 2d                	cmp    $0x2d,%al
  800e32:	74 2b                	je     800e5f <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e34:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800e3a:	75 0f                	jne    800e4b <strtol+0x40>
  800e3c:	80 39 30             	cmpb   $0x30,(%ecx)
  800e3f:	74 28                	je     800e69 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800e41:	85 db                	test   %ebx,%ebx
  800e43:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e48:	0f 44 d8             	cmove  %eax,%ebx
  800e4b:	b8 00 00 00 00       	mov    $0x0,%eax
  800e50:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800e53:	eb 50                	jmp    800ea5 <strtol+0x9a>
		s++;
  800e55:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800e58:	bf 00 00 00 00       	mov    $0x0,%edi
  800e5d:	eb d5                	jmp    800e34 <strtol+0x29>
		s++, neg = 1;
  800e5f:	83 c1 01             	add    $0x1,%ecx
  800e62:	bf 01 00 00 00       	mov    $0x1,%edi
  800e67:	eb cb                	jmp    800e34 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e69:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800e6d:	74 0e                	je     800e7d <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800e6f:	85 db                	test   %ebx,%ebx
  800e71:	75 d8                	jne    800e4b <strtol+0x40>
		s++, base = 8;
  800e73:	83 c1 01             	add    $0x1,%ecx
  800e76:	bb 08 00 00 00       	mov    $0x8,%ebx
  800e7b:	eb ce                	jmp    800e4b <strtol+0x40>
		s += 2, base = 16;
  800e7d:	83 c1 02             	add    $0x2,%ecx
  800e80:	bb 10 00 00 00       	mov    $0x10,%ebx
  800e85:	eb c4                	jmp    800e4b <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800e87:	8d 72 9f             	lea    -0x61(%edx),%esi
  800e8a:	89 f3                	mov    %esi,%ebx
  800e8c:	80 fb 19             	cmp    $0x19,%bl
  800e8f:	77 29                	ja     800eba <strtol+0xaf>
			dig = *s - 'a' + 10;
  800e91:	0f be d2             	movsbl %dl,%edx
  800e94:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800e97:	3b 55 10             	cmp    0x10(%ebp),%edx
  800e9a:	7d 30                	jge    800ecc <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800e9c:	83 c1 01             	add    $0x1,%ecx
  800e9f:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ea3:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800ea5:	0f b6 11             	movzbl (%ecx),%edx
  800ea8:	8d 72 d0             	lea    -0x30(%edx),%esi
  800eab:	89 f3                	mov    %esi,%ebx
  800ead:	80 fb 09             	cmp    $0x9,%bl
  800eb0:	77 d5                	ja     800e87 <strtol+0x7c>
			dig = *s - '0';
  800eb2:	0f be d2             	movsbl %dl,%edx
  800eb5:	83 ea 30             	sub    $0x30,%edx
  800eb8:	eb dd                	jmp    800e97 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800eba:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ebd:	89 f3                	mov    %esi,%ebx
  800ebf:	80 fb 19             	cmp    $0x19,%bl
  800ec2:	77 08                	ja     800ecc <strtol+0xc1>
			dig = *s - 'A' + 10;
  800ec4:	0f be d2             	movsbl %dl,%edx
  800ec7:	83 ea 37             	sub    $0x37,%edx
  800eca:	eb cb                	jmp    800e97 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800ecc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ed0:	74 05                	je     800ed7 <strtol+0xcc>
		*endptr = (char *) s;
  800ed2:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ed5:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ed7:	89 c2                	mov    %eax,%edx
  800ed9:	f7 da                	neg    %edx
  800edb:	85 ff                	test   %edi,%edi
  800edd:	0f 45 c2             	cmovne %edx,%eax
}
  800ee0:	5b                   	pop    %ebx
  800ee1:	5e                   	pop    %esi
  800ee2:	5f                   	pop    %edi
  800ee3:	5d                   	pop    %ebp
  800ee4:	c3                   	ret    
  800ee5:	66 90                	xchg   %ax,%ax
  800ee7:	66 90                	xchg   %ax,%ax
  800ee9:	66 90                	xchg   %ax,%ax
  800eeb:	66 90                	xchg   %ax,%ax
  800eed:	66 90                	xchg   %ax,%ax
  800eef:	90                   	nop

00800ef0 <__udivdi3>:
  800ef0:	55                   	push   %ebp
  800ef1:	57                   	push   %edi
  800ef2:	56                   	push   %esi
  800ef3:	53                   	push   %ebx
  800ef4:	83 ec 1c             	sub    $0x1c,%esp
  800ef7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800efb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800eff:	8b 74 24 34          	mov    0x34(%esp),%esi
  800f03:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800f07:	85 d2                	test   %edx,%edx
  800f09:	75 4d                	jne    800f58 <__udivdi3+0x68>
  800f0b:	39 f3                	cmp    %esi,%ebx
  800f0d:	76 19                	jbe    800f28 <__udivdi3+0x38>
  800f0f:	31 ff                	xor    %edi,%edi
  800f11:	89 e8                	mov    %ebp,%eax
  800f13:	89 f2                	mov    %esi,%edx
  800f15:	f7 f3                	div    %ebx
  800f17:	89 fa                	mov    %edi,%edx
  800f19:	83 c4 1c             	add    $0x1c,%esp
  800f1c:	5b                   	pop    %ebx
  800f1d:	5e                   	pop    %esi
  800f1e:	5f                   	pop    %edi
  800f1f:	5d                   	pop    %ebp
  800f20:	c3                   	ret    
  800f21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f28:	89 d9                	mov    %ebx,%ecx
  800f2a:	85 db                	test   %ebx,%ebx
  800f2c:	75 0b                	jne    800f39 <__udivdi3+0x49>
  800f2e:	b8 01 00 00 00       	mov    $0x1,%eax
  800f33:	31 d2                	xor    %edx,%edx
  800f35:	f7 f3                	div    %ebx
  800f37:	89 c1                	mov    %eax,%ecx
  800f39:	31 d2                	xor    %edx,%edx
  800f3b:	89 f0                	mov    %esi,%eax
  800f3d:	f7 f1                	div    %ecx
  800f3f:	89 c6                	mov    %eax,%esi
  800f41:	89 e8                	mov    %ebp,%eax
  800f43:	89 f7                	mov    %esi,%edi
  800f45:	f7 f1                	div    %ecx
  800f47:	89 fa                	mov    %edi,%edx
  800f49:	83 c4 1c             	add    $0x1c,%esp
  800f4c:	5b                   	pop    %ebx
  800f4d:	5e                   	pop    %esi
  800f4e:	5f                   	pop    %edi
  800f4f:	5d                   	pop    %ebp
  800f50:	c3                   	ret    
  800f51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f58:	39 f2                	cmp    %esi,%edx
  800f5a:	77 1c                	ja     800f78 <__udivdi3+0x88>
  800f5c:	0f bd fa             	bsr    %edx,%edi
  800f5f:	83 f7 1f             	xor    $0x1f,%edi
  800f62:	75 2c                	jne    800f90 <__udivdi3+0xa0>
  800f64:	39 f2                	cmp    %esi,%edx
  800f66:	72 06                	jb     800f6e <__udivdi3+0x7e>
  800f68:	31 c0                	xor    %eax,%eax
  800f6a:	39 eb                	cmp    %ebp,%ebx
  800f6c:	77 a9                	ja     800f17 <__udivdi3+0x27>
  800f6e:	b8 01 00 00 00       	mov    $0x1,%eax
  800f73:	eb a2                	jmp    800f17 <__udivdi3+0x27>
  800f75:	8d 76 00             	lea    0x0(%esi),%esi
  800f78:	31 ff                	xor    %edi,%edi
  800f7a:	31 c0                	xor    %eax,%eax
  800f7c:	89 fa                	mov    %edi,%edx
  800f7e:	83 c4 1c             	add    $0x1c,%esp
  800f81:	5b                   	pop    %ebx
  800f82:	5e                   	pop    %esi
  800f83:	5f                   	pop    %edi
  800f84:	5d                   	pop    %ebp
  800f85:	c3                   	ret    
  800f86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f8d:	8d 76 00             	lea    0x0(%esi),%esi
  800f90:	89 f9                	mov    %edi,%ecx
  800f92:	b8 20 00 00 00       	mov    $0x20,%eax
  800f97:	29 f8                	sub    %edi,%eax
  800f99:	d3 e2                	shl    %cl,%edx
  800f9b:	89 54 24 08          	mov    %edx,0x8(%esp)
  800f9f:	89 c1                	mov    %eax,%ecx
  800fa1:	89 da                	mov    %ebx,%edx
  800fa3:	d3 ea                	shr    %cl,%edx
  800fa5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800fa9:	09 d1                	or     %edx,%ecx
  800fab:	89 f2                	mov    %esi,%edx
  800fad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800fb1:	89 f9                	mov    %edi,%ecx
  800fb3:	d3 e3                	shl    %cl,%ebx
  800fb5:	89 c1                	mov    %eax,%ecx
  800fb7:	d3 ea                	shr    %cl,%edx
  800fb9:	89 f9                	mov    %edi,%ecx
  800fbb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800fbf:	89 eb                	mov    %ebp,%ebx
  800fc1:	d3 e6                	shl    %cl,%esi
  800fc3:	89 c1                	mov    %eax,%ecx
  800fc5:	d3 eb                	shr    %cl,%ebx
  800fc7:	09 de                	or     %ebx,%esi
  800fc9:	89 f0                	mov    %esi,%eax
  800fcb:	f7 74 24 08          	divl   0x8(%esp)
  800fcf:	89 d6                	mov    %edx,%esi
  800fd1:	89 c3                	mov    %eax,%ebx
  800fd3:	f7 64 24 0c          	mull   0xc(%esp)
  800fd7:	39 d6                	cmp    %edx,%esi
  800fd9:	72 15                	jb     800ff0 <__udivdi3+0x100>
  800fdb:	89 f9                	mov    %edi,%ecx
  800fdd:	d3 e5                	shl    %cl,%ebp
  800fdf:	39 c5                	cmp    %eax,%ebp
  800fe1:	73 04                	jae    800fe7 <__udivdi3+0xf7>
  800fe3:	39 d6                	cmp    %edx,%esi
  800fe5:	74 09                	je     800ff0 <__udivdi3+0x100>
  800fe7:	89 d8                	mov    %ebx,%eax
  800fe9:	31 ff                	xor    %edi,%edi
  800feb:	e9 27 ff ff ff       	jmp    800f17 <__udivdi3+0x27>
  800ff0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800ff3:	31 ff                	xor    %edi,%edi
  800ff5:	e9 1d ff ff ff       	jmp    800f17 <__udivdi3+0x27>
  800ffa:	66 90                	xchg   %ax,%ax
  800ffc:	66 90                	xchg   %ax,%ax
  800ffe:	66 90                	xchg   %ax,%ax

00801000 <__umoddi3>:
  801000:	55                   	push   %ebp
  801001:	57                   	push   %edi
  801002:	56                   	push   %esi
  801003:	53                   	push   %ebx
  801004:	83 ec 1c             	sub    $0x1c,%esp
  801007:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80100b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80100f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801013:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801017:	89 da                	mov    %ebx,%edx
  801019:	85 c0                	test   %eax,%eax
  80101b:	75 43                	jne    801060 <__umoddi3+0x60>
  80101d:	39 df                	cmp    %ebx,%edi
  80101f:	76 17                	jbe    801038 <__umoddi3+0x38>
  801021:	89 f0                	mov    %esi,%eax
  801023:	f7 f7                	div    %edi
  801025:	89 d0                	mov    %edx,%eax
  801027:	31 d2                	xor    %edx,%edx
  801029:	83 c4 1c             	add    $0x1c,%esp
  80102c:	5b                   	pop    %ebx
  80102d:	5e                   	pop    %esi
  80102e:	5f                   	pop    %edi
  80102f:	5d                   	pop    %ebp
  801030:	c3                   	ret    
  801031:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801038:	89 fd                	mov    %edi,%ebp
  80103a:	85 ff                	test   %edi,%edi
  80103c:	75 0b                	jne    801049 <__umoddi3+0x49>
  80103e:	b8 01 00 00 00       	mov    $0x1,%eax
  801043:	31 d2                	xor    %edx,%edx
  801045:	f7 f7                	div    %edi
  801047:	89 c5                	mov    %eax,%ebp
  801049:	89 d8                	mov    %ebx,%eax
  80104b:	31 d2                	xor    %edx,%edx
  80104d:	f7 f5                	div    %ebp
  80104f:	89 f0                	mov    %esi,%eax
  801051:	f7 f5                	div    %ebp
  801053:	89 d0                	mov    %edx,%eax
  801055:	eb d0                	jmp    801027 <__umoddi3+0x27>
  801057:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80105e:	66 90                	xchg   %ax,%ax
  801060:	89 f1                	mov    %esi,%ecx
  801062:	39 d8                	cmp    %ebx,%eax
  801064:	76 0a                	jbe    801070 <__umoddi3+0x70>
  801066:	89 f0                	mov    %esi,%eax
  801068:	83 c4 1c             	add    $0x1c,%esp
  80106b:	5b                   	pop    %ebx
  80106c:	5e                   	pop    %esi
  80106d:	5f                   	pop    %edi
  80106e:	5d                   	pop    %ebp
  80106f:	c3                   	ret    
  801070:	0f bd e8             	bsr    %eax,%ebp
  801073:	83 f5 1f             	xor    $0x1f,%ebp
  801076:	75 20                	jne    801098 <__umoddi3+0x98>
  801078:	39 d8                	cmp    %ebx,%eax
  80107a:	0f 82 b0 00 00 00    	jb     801130 <__umoddi3+0x130>
  801080:	39 f7                	cmp    %esi,%edi
  801082:	0f 86 a8 00 00 00    	jbe    801130 <__umoddi3+0x130>
  801088:	89 c8                	mov    %ecx,%eax
  80108a:	83 c4 1c             	add    $0x1c,%esp
  80108d:	5b                   	pop    %ebx
  80108e:	5e                   	pop    %esi
  80108f:	5f                   	pop    %edi
  801090:	5d                   	pop    %ebp
  801091:	c3                   	ret    
  801092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801098:	89 e9                	mov    %ebp,%ecx
  80109a:	ba 20 00 00 00       	mov    $0x20,%edx
  80109f:	29 ea                	sub    %ebp,%edx
  8010a1:	d3 e0                	shl    %cl,%eax
  8010a3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8010a7:	89 d1                	mov    %edx,%ecx
  8010a9:	89 f8                	mov    %edi,%eax
  8010ab:	d3 e8                	shr    %cl,%eax
  8010ad:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8010b1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8010b5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8010b9:	09 c1                	or     %eax,%ecx
  8010bb:	89 d8                	mov    %ebx,%eax
  8010bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8010c1:	89 e9                	mov    %ebp,%ecx
  8010c3:	d3 e7                	shl    %cl,%edi
  8010c5:	89 d1                	mov    %edx,%ecx
  8010c7:	d3 e8                	shr    %cl,%eax
  8010c9:	89 e9                	mov    %ebp,%ecx
  8010cb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8010cf:	d3 e3                	shl    %cl,%ebx
  8010d1:	89 c7                	mov    %eax,%edi
  8010d3:	89 d1                	mov    %edx,%ecx
  8010d5:	89 f0                	mov    %esi,%eax
  8010d7:	d3 e8                	shr    %cl,%eax
  8010d9:	89 e9                	mov    %ebp,%ecx
  8010db:	89 fa                	mov    %edi,%edx
  8010dd:	d3 e6                	shl    %cl,%esi
  8010df:	09 d8                	or     %ebx,%eax
  8010e1:	f7 74 24 08          	divl   0x8(%esp)
  8010e5:	89 d1                	mov    %edx,%ecx
  8010e7:	89 f3                	mov    %esi,%ebx
  8010e9:	f7 64 24 0c          	mull   0xc(%esp)
  8010ed:	89 c6                	mov    %eax,%esi
  8010ef:	89 d7                	mov    %edx,%edi
  8010f1:	39 d1                	cmp    %edx,%ecx
  8010f3:	72 06                	jb     8010fb <__umoddi3+0xfb>
  8010f5:	75 10                	jne    801107 <__umoddi3+0x107>
  8010f7:	39 c3                	cmp    %eax,%ebx
  8010f9:	73 0c                	jae    801107 <__umoddi3+0x107>
  8010fb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8010ff:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801103:	89 d7                	mov    %edx,%edi
  801105:	89 c6                	mov    %eax,%esi
  801107:	89 ca                	mov    %ecx,%edx
  801109:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80110e:	29 f3                	sub    %esi,%ebx
  801110:	19 fa                	sbb    %edi,%edx
  801112:	89 d0                	mov    %edx,%eax
  801114:	d3 e0                	shl    %cl,%eax
  801116:	89 e9                	mov    %ebp,%ecx
  801118:	d3 eb                	shr    %cl,%ebx
  80111a:	d3 ea                	shr    %cl,%edx
  80111c:	09 d8                	or     %ebx,%eax
  80111e:	83 c4 1c             	add    $0x1c,%esp
  801121:	5b                   	pop    %ebx
  801122:	5e                   	pop    %esi
  801123:	5f                   	pop    %edi
  801124:	5d                   	pop    %ebp
  801125:	c3                   	ret    
  801126:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80112d:	8d 76 00             	lea    0x0(%esi),%esi
  801130:	89 da                	mov    %ebx,%edx
  801132:	29 fe                	sub    %edi,%esi
  801134:	19 c2                	sbb    %eax,%edx
  801136:	89 f1                	mov    %esi,%ecx
  801138:	89 c8                	mov    %ecx,%eax
  80113a:	e9 4b ff ff ff       	jmp    80108a <__umoddi3+0x8a>
